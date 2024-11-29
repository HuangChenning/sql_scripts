#!/usr/bin/perl
#
#
#
#  newheap.pl : this is the perl implementation of heap.awk
#
#  USAGE:
#  ~~~~~~
#
#        perl ./newheap.pl [tracefile]
#
#        perl ./newheap.pl [OPTIONS] [tracefile]
#
#        perl ./newheap.pl -h
#
#  AUTHOR: matteo.malvezzi@oracle.com mmalvezz_it
#  ~~~~~~
#
#  MODIFIED:
#  ~~~~~~~~
#  15/06/15 - Add the getopt and manual page using pod2usage
#             Add date information to the outputfile name
#             Debug option, set the variable $DEBUG=TRUE
#  19/06/15 - Better utilization of hash array
#             Replace /Chunk/ with /^ *Chunck/
#  23/06/15 - Check heap error
#             Handle "sz=12.."  w/o space in free list section

use strict;
use Time::HiRes qw(time);
use Term::ANSIColor 2.00 qw(:pushpop);
use Data::Dumper qw(Dumper);
use Getopt::Std;
use Pod::Usage;
use POSIX qw(strftime);
use POSIX;

use constant topheap         => 0x0001;    #sga heap
use constant freelst         => 0x0002;    #free list
use constant genheap         => 0x0004;    #generic heap
use constant endtoph         => 0x0008;
use constant rfreels         => 0x0010;    #reserved free list
use constant permcmt         => 0x0020;    #Comment on permanent chunck
use constant heapcor         => 0x0040;    #Heap has a curruption
use constant sort_by_extents => 1;         #Sort ds by extents
use constant sort_by_size    => 2;         #Sort ds by szie
use constant TRUE            => 1;
use constant FALSE           => 0;
use constant MAX_HEADER_LINE => 2000;      #Search header info not over mhl
use constant siz             => 0;
use constant cnt             => 1;

my $CHCPM = FALSE;
my $DEBUG = FALSE;
my $KGHNA = FALSE; #KGH NO ACCESS presence,
                   #if one is found during precheck it turns to TRUE
my $ALLCH = FALSE; #prints all the chunck of the heap
my $SUBDT = TRUE;  #prints subheaps details (useful for for heapdump 0x10000002)
my $BRKDW = 0;     #break down size
my $PRTFL = TRUE;  #print free list information
my $TOPDS = 10;    #print top of the list of subhead
                   #ds order by number of extents or by size
my $HEAPC = FALSE; #heap corruption

my $sortds = sort_by_size;
my $hline  = 0;

my $heaps = 0;     #Total heap size
my @bkell = ();
my $permtype;

my @chelm = ();    #chunk line
my @charr = ();    #array of chunk
my %chtyp = ();    #group by chtyp;

my %altyp = ();    #group by allocation type
my %altas = ();    #group by alloc type w/o addr
my $heapz = 0;     #heapsize
my %dsarr = ();    #list of subheap ds
my @dscnt = ();    #number of extents per ds
my @bkell = ();    #array accomodating bucket id and bucket size
my @bkarr = ();    #aggregate buckets free list information
my $maxfc = 0;     #largest piece of free contiguos memory
my $maxrc = 0;     #largest revers free list
my $uperm = 0;     #permanet memory used
my %prtys = ();    #cprm size group by type of allocation
my $tmp   = 0;

my $lssiz = 0;
my $lssum = 0;
my $bksiz = 0;
my $b0id  = 0;
my $b0sz  = 32;

my $t1 = 0;
my $t2 = 0;

#............Getoptions................#

my %options = ();
getopts( "gmfht:s:", \%options );

if ( defined $options{h} ) {
   pod2usage( -exitval => 0, -verbose => 2 );
}

if ( defined $options{m} ) {
   pod2usage(1);
}
if ( defined $options{f} ) {
   $PRTFL = FALSE;
}

if ( defined $options{t} && isdigit( $options{t} ) ) {
   $BRKDW = $options{t};
}

if ( defined $options{s} ) {
   if ( $options{s} eq "extents" ) {
      $sortds = sort_by_extents;
   }

   if ( $options{s} eq "size" ) {
      $sortds = sort_by_size;
   }
}

if ( defined $options{g} ) {
   $DEBUG = TRUE;
}

if ( not defined $ARGV[0] ) {
   printf "Missing tracefile name\nhelp: perl ./newheap.pl -h\n";
   exit;
}

my $ofile = "./heapout.txt";
printf "Heapdump analyzer: %+14s \n", "240615";

#improve the name of the outputfile

## bit operators ##
sub bitand {
   my ( $var, $mask ) = @_;
   if ( ( $var & $mask ) != 0 ) {
      return TRUE;
   }
   else {
      return FALSE;
   }
}

sub bitset {
   my ( $var, $mask ) = @_;
   $var |= $mask;
   return ($var);
}

sub bitunset {
   my ( $var, $mask ) = @_;
   ( ($var) ^= ( ($mask) & ($var) ) );
   return ($var);
}

my $bitsec = 0;    #bit section

my $hpdm = $ARGV[0];    #1st  arg: tracefile name

if ( $hpdm =~ /\.trc/ ) {
   $ofile = $hpdm;
   $ofile =~ s/\.trc/\.heapdump/g;
   my $loctime = strftime "%y%j%H%M%S", localtime;
   $ofile = $ofile . "." . $loctime;
}

open( my $fh, '>', $ofile ) or die "cannot not open file '$ofile' $!";

my $linecounter;
open( HEAPDUMP, $hpdm ) || die "cannot open file";
print "Starting precheck\n";
PRECHECK: while (<HEAPDUMP>) {

   if ( $linecounter < MAX_HEADER_LINE ) {

      #get rdbms version
      if ( $_ =~ /Enterprise Edition Release/ ) {
	 my @rdbms_version = split;
	 printf $fh "RDBMS: %+30s\n", $rdbms_version[6];
      }

      if ( $_ =~ /ACTION NAME/ ) {
	 my @date_of_dump = split;
	 printf $fh "Date: %+31s %+10s\n\n", $date_of_dump[3], $date_of_dump[4];
      }

      if ( $_ =~ /Oradebug command/ && $_ =~ /heapdump/ ) {
	 my @heaplevel = split;
	 $heaplevel[5] =~ s/\'//g;
	 printf $fh "Heapdump level: %+21s\n", $heaplevel[5];
      }
   }
   $linecounter++;

   if ( $_ =~ /cprm/ && $CHCPM == FALSE ) {
      $CHCPM = TRUE;
      printf "EVENT 10235 level 65536 ";
   }

  # ........handle heap errors......#
  #     CHEKC BAD MAGIC NUMBER:
  #     ~~~~~~~~~~~~~~~~~~~~~~
  #     Chunk 970ccfe8 sz=       24  R-stopper   "reserved stoppe"
  #     Chunk 970cd000 sz= 13315544    perm      "perm           "  alo=13315544
  #     Chunk 97d7fdd8 sz=  2097168  BAD MAGIC NUMBER IN NEXT CHUNK (0)
  #     perm      "perm           "  alo=2097168

   if ( $_ =~ /ERROR, / ) {
      printf PUSHCOLOR RED;
      printf "%+2s %+20s\n", "FIND HEAP ERROR AT LINE:      ", $linecounter;
      printf RESET;
      printf $fh "%+6s:%s", $linecounter, $_;
      $HEAPC = TRUE;
   }

   if ( $_ =~ /BAD MAGIC NUMBER/ ) {
      printf PUSHCOLOR RED;
      printf "%+2s %+20s\n", "FIND BAD MAGIC NUMBER AT LINE:", $linecounter;
      printf RESET;
      printf $fh "%+6s:%s", $linecounter, $_;
      $HEAPC = TRUE;
   }

   #...end of heap error section....#

   if ( $_ =~ /KGH: NO ACCESS/ && $KGHNA == FALSE ) {
      $KGHNA = TRUE;
      printf "KGH: NO ACCESS FOUND\n";
   }

   if ( $_ =~ /DUMP FILE SIZE IS LIMITED/ ) {
      printf PUSHCOLOR RED;
      printf "DUMP FILE SIZE IS LIMITED: CHECK PARAMETER MAX_DUMP_FILE_SIZE\n";
      printf RESET;
      exit(1);
   }

}

seek( HEAPDUMP, 0, 0 );

MAIN_LOOP: while (<HEAPDUMP>) {

   GetHeap($_);

   if (  ( bitand( $bitsec, topheap ) == TRUE )
      || ( ( $SUBDT == TRUE ) && bitand( $bitsec, genheap ) == TRUE ) )
   {

      if ( $_ =~ /^ *Chunk/ ) {

	 my $l1;
	 my $l2;
	 if ( $l1 == 0 ) {
	    $l1 = index( $_, "\"" );
	    $l2 = index( $_, "\"", $l1 + 1 );
	 }

	 $_ =~ s/\"//g;
	 $_ =~ s/\n/ /g;

	 my $alloctype = substr $_, $l1, $l2 - $l1;
	 $alloctype =~ s/_/ /g;

	 @chelm = split;

	 #this code lines manages the case where we
	 #have sz=#### w/o spaces, it's less expensive
	 #than resplace sz for each line
	 if ( length( $chelm[2] ) > 3 ) {
	    $_ =~ s/sz=/sz= /g;
	    @chelm = ();
	    @chelm = split;
	    if ( $DEBUG == TRUE ) {
	       print Dumper \@chelm;
	    }
	 }

      #  Chunk 8ef73000 sz=     4096    recreate  "KGLH0^ea369dda "  latch=(nil)
      #  Chunk 8dea5970 sz=     4096    recreate  "SQLA^bf1d7a5   "  latch=(nil)
      #  Chunk 8efbe000 sz=     4096    recreate  "KGLH0^bf1d7a5  "  latch=(nil)
      #  Chunk 8dea4970 sz=     4096    recreate  "SQLA^86111aab  "  latch=(nil)
      #                         +---+   +-------+ +-------------+
      #                           |        |             |
      #                           |        |             |
      #                +----------+        |             +-----+
      #                |                   |                   |
      #          +-----------+       +-----------+      +-------------+
      #          | $chelm[3] |       | $chelm[4] |      | $alloctype  |
      #          +-----------+       +-----------+      +-------------+
      #

	 if ( $KGHNA == TRUE ) {
	    if ( $_ =~ /KGH: NO ACCESS/ ) {
	       $alloctype = ();
	       $alloctype = "KGH: NO ACCESS  ";
	       $chelm[4]  = "no_access";
	    }
	 }

	 if ( $ALLCH == TRUE ) {
	    push( @charr, [ $chelm[3], $chelm[4], $alloctype ] );
	 }

	 $chtyp{ $chelm[4] }[siz] += $chelm[3];    #----> group by chunck type
	 $chtyp{ $chelm[4] }[cnt] += 1;

	 $altyp{$alloctype}[siz] += $chelm[3];   #----> group by allocation type
	 $altyp{$alloctype}[cnt] += 1;

	 #count permanent memory
	 if ( $chelm[4] =~ "perm" ) {

	    #printf "%s\n", $chelm[6];
	    $chelm[6] =~ s/alo=//g;
	    $uperm += $chelm[6];
	 }

	 @chelm = ();

	 #get ds allocation type
	 if ( $_ =~ /ds\=/ ) {

	    #get suheapds address

	    my $k1 = index( $_, "\=" );
	    my $k2 = index( $_, "\=", $k1 + 1 );
	    my $ds = substr $_, $k2 + 1, length($_) - $k2;
	    $ds =~ s/ //g;
	    $ds =~ s/0x//g;
	    $ds =~ s/\n//g;

	    $dsarr{$ds} = $alloctype;

	 }

      }

      if ( $_ =~ /^ *ds / && $_ =~ /sz\=/ && $_ =~ /ct\=/ ) {
	 my @dselemnt = split;
	 $dselemnt[1] =~ s/0x//g;

	 if ( substr( $dselemnt[1], 0, 1 ) == '0' ) {

	    # ds        0bf97d590 sz=  63448 ct=  4
	    #           +
	    #           |
	    #           +---> handle this 0

	    $dselemnt[1] = substr( $dselemnt[1], 1 );
	 }

	 #addr         #num of ext  #sz
	 push( @dscnt, [ $dselemnt[1], $dselemnt[5], $dselemnt[3] ] );
      }

   }

   if ( bitand( $bitsec, (endtoph) ) == TRUE ) {
      if ( $_ =~ /Total heap size/ ) {
	 $_ =~ s/Total heap size    =//g;
	 $heaps = $_;
      }

      # print all the chunck in the heap
      if ( $ALLCH == TRUE ) {
	 for ( my $cnt = 0 ; $cnt < scalar(@charr) ; $cnt++ ) {
	    printf $fh "[%+10s] [%+20s] [%-25s]\n", $charr[$cnt][0],
	      $charr[$cnt][1],
	      $charr[$cnt][2];
	 }
      }

      printf $fh "%11s %20s %10s %15s\n", "chunck type", "Count", "Sum",
	"Average";
      printf $fh "%11s %20s %10s %15s\n", "~~~~~~~~~~~", "~~~~~~~~~~~~~",
	"~~~~~~~~~~", "~~~~~~~~~~";
      foreach my $ctp (
	 sort { $chtyp{$b}[siz] <=> $chtyp{$a}[siz] }
	 keys %chtyp
	)
      {
	 printf $fh "%-11s %20i %10i %15.3f\n",
	   $ctp, $chtyp{$ctp}[cnt], $chtyp{$ctp}[siz],
	   $chtyp{$ctp}[siz] / $chtyp{$ctp}[cnt];

	 if ( $HEAPC == TRUE ) {
	    if ( $ctp eq "BAD" ) {
	       $bitsec = bitset( $bitsec, heapcor );
	    }
	 }

      }

      printf $fh '~' x ($hline) . "\n";

      if ( bitand( $bitsec, heapcor ) == TRUE ) {
	 print $fh ">>>WARINING HEAP CURRUPTION<<<\n";
	 $bitsec = bitunset( $bitsec, heapcor );
      }

      printf $fh "Total heap size=%d\n",               $heaps;
      printf $fh "Total PERMANENT memory used %10s\n", $uperm;

      if ( scalar(%altyp) != 0 ) {
	 printf $fh "\nBreakDown\n~~~~~~~~~\n";
	 if (  ( bitand( $bitsec, genheap ) == TRUE ) && ( $SUBDT == TRUE )
	    || ( bitand( $bitsec, topheap ) == TRUE ) )
	 {
	    printf $fh "\n";
	    printf $fh "%18s %15s %15s %15s %s\n", "Type", "Count",
	      "Sum", "Average", "Percent";
	    printf $fh "%18s %15s %15s %15s %s\n", "~~~~", "~~~~~",
	      "~~~", "~~~~~~~", "~~~~~~~";
	    foreach my $atp (
	       sort { $altyp{$b}[siz] <=> $altyp{$a}[siz] }
	       keys %altyp
	      )
	    {
	       if ( $altyp{$atp}[siz] > $BRKDW ) {
		  my $key = $atp;
		  $atp =~ s/               /Free(heap.pl)  /g;
		  printf $fh "%18s %15d %15d %15.2f %7.2f\n",
		    $atp,
		    $altyp{$key}[cnt], $altyp{$key}[siz],
		    $altyp{$key}[siz] / $altyp{$key}[cnt],
		    100 * ( $altyp{$key}[siz] / $heaps );

		  # group by family ALL
		  if ( $key =~ /\^/ ) {
		     my $p1 = substr( $key, 0, index( $key, "\^" ) );
		     $altas{$p1}[siz] += $altyp{$key}[siz];
		     $altas{$p1}[cnt] += $altyp{$key}[cnt];
		  }

		  #
	       }
	    }

	    if ( scalar(%altas) != 0 ) {
	       printf $fh "\n";
	       printf $fh "%18s %15s %15s %15s %s\n", "Type", "Count",
		 "Sum", "Average", "Percent";
	       printf $fh "%18s %15s %15s %15s %s\n", "~~~~", "~~~~~",
		 "~~~", "~~~~~~~", "~~~~~~~";
	       foreach my $atp (
		  sort { $altas{$b}[siz] <=> $altas{$a}[siz] }
		  keys %altas
		 )
	       {

		  my $key = $atp;
		  printf $fh "%18s %15d %15d %15.2f %7.2f\n",
		    "All:" . $atp, $altas{$key}[cnt],
		    $altas{$key}[siz], $altas{$key}[siz] / $altas{$key}[cnt],
		    100 * ( $altas{$key}[siz] / $heaps );
	       }
	    }
	 }
      }

      my $numofds = scalar(@dscnt);
      if ( $numofds != 0 ) {

	 printf $fh "\n\n\n";
	 printf $fh "Top(%i):list subheap ds", $TOPDS;
	 printf $fh " ordered by %s ",
	   ( ( $sortds == sort_by_extents ) ? "extents\n" : "size\n" );
	 printf $fh "\n";
	 printf $fh "%18s %15s %15s %-20s\n", "DS ADDR", "EXTENTS", "SIZE",
	   "TYPE";
	 printf $fh "%18s %15s %15s %-20s\n", "~~~~~~~~~~~~", "~~~~~~~~~~~~",
	   "~~~~~~~~~~~~", "~~~~~~~~~~~~";

	 # Sort list of ds by number of extents
	 @dscnt = sort { $b->[$sortds] <=> $a->[$sortds] } @dscnt;

	 for (
	    my $cnt = 0 ;
	    $cnt < ( scalar(@dscnt) > $TOPDS ? $TOPDS : scalar(@dscnt) ) ;
	    $cnt++
	   )
	 {
	    printf $fh "%18s %15s %15s %-20s \n", "0x" . $dscnt[$cnt][0],
	      $dscnt[$cnt][1],
	      , $dscnt[$cnt][2], $dsarr{ $dscnt[$cnt][0] };
	 }
	 printf $fh "\nTotal number of ds=%i\n", $numofds;
      }

      ##
      ##

      #At the end of the heap reset all the array
      @charr = ();
      %chtyp = ();
      %altyp = ();
      @dscnt = ();
      $uperm = 0;
      %dsarr = ();
      %altas = ();

      $t2 = time;    #get timestamp at the end of the heap
      my $delta = $t2 - $t1;
      if ( $delta != 0 ) {
	 printf "time(s) %3.6f", $delta;
      }
      else { print "\n"; }

      #reset bit vector
      $bitsec = bitunset( $bitsec, endtoph );
      $bitsec = bitunset( $bitsec, topheap | genheap );
   }

   #......free list section............"
   #
   #
   #    FREE LISTS:
   #     Bucket 0 size=32
   #       Chunk c00000027c000078 sz=        0    kghdsx
   #     Bucket 1 size=40
   #       Chunk c0000002204edfe0 sz=       40    free      "               "
   #       Chunk c00000020c8a0788 sz=       40    free      "               "
   #       Chunk c00000021d1d3fe0 sz=       40    free      "               "
   #       0     1                2         3

   if ( $PRTFL == TRUE ) {
      if ( bitand( $bitsec, freelst ) == TRUE ) {

	 if ( $_ =~ /^ *Bucket/ ) {

	    @bkell = split;
	    $bkell[2] =~ s/size=//g;

	    if ( $b0id != $bkell[1] ) {
	       if ( $lssiz != 0 ) {
		  printf $fh
		    " Bucket %5s [size=%5s] Av.size=  %10i count= %10i \n",
		    $b0id, $b0sz, $lssum / $lssiz, $lssiz;
	       }
	       $b0id  = $bkell[1];
	       $b0sz  = $bkell[2];
	       $lssum = 0;
	       $lssiz = 0;
	    }

	 }

	 if ( $_ =~ /^ *Chunk/ ) {
	    my @tmparr = split;

	    if ( length( $tmparr[2] ) > 3 ) {
	       $_ =~ s/sz=/sz= /g;

	       @tmparr = ();
	       @tmparr = split;

	       if ( $DEBUG == TRUE ) {
		  print Dumper \@tmparr;
	       }

	    }

	    $lssum += $tmparr[3];
	    $lssiz += 1;

	    #get largest free chunk of the heap
	    if ( $tmparr[3] > $maxfc ) {
	       $maxfc = $tmparr[3];
	    }
	 }

	 if ( $_ =~ /Total free space/ ) {

	    if ( $lssiz != 0 ) {
	       printf $fh
		 " Bucket %5s [size=%5s] Av.size=  %10i count= %10i \n",
		 $b0id, $b0sz, $lssum / $lssiz, $lssiz;
	    }
	    printf $fh "\n";
	    printf $fh "Largest CONTIGUOUS free memory (NORMAL)   was %10s\n",
	      $maxfc;
	    $bitsec = bitunset( $bitsec, freelst );
	    $b0id   = 0;
	    $b0sz   = 0;
	    $lssum  = 0;
	    $lssiz  = 0;
	    @bkell  = ();
	    $maxfc  = 0;
	 }
      }
   }

   #.........Reserved free list............#
   if ( bitand( $bitsec, rfreels ) == TRUE ) {
      if ( $_ =~ /^ *Chunk/ ) {
	 my @tmparr = split;
	 if ( $maxrc < $tmparr[3] ) { $maxrc = $tmparr[3]; }
      }

      if ( $_ =~ /Total reserved free space/ ) {
	 $bitsec = bitunset( $bitsec, rfreels );
	 printf $fh "Largest CONTIGUOUS free memory (RESERVED) was %10s\n",
	   $maxrc;
	 $maxrc = 0;
      }
   }

   #.......End of reserved free list........#

   #.......Permanent chunk  (cprm)..........#
   if ( $CHCPM == TRUE && bitand( $bitsec, permcmt ) == TRUE ) {
      @chelm = split;
      if ( $chelm[3] =~ /cprm/ ) {
	 my $k1 = index( $_, "\"" );
	 my $k2 = index( $_, "\"", $k1 + 1 );
	 $permtype = substr $_, $k1 + 1, $k2 - $k1 - 1;

	 $prtys{$permtype}[siz] += $chelm[2];
	 $prtys{$permtype}[cnt] += 1;
      }

      if ( $_ =~ /Permanent space/ ) {
	 if ( scalar(%prtys) != 0 ) {
	    printf $fh "\nBreakdown of CPRM Chunks (Commented Perm Chunks)\n\n";
	    printf $fh "%15s %20s %10s %15s\n", "type", "Count", "Sum",
	      "Average";
	    printf $fh "%15s %20s %10s %15s\n", "~~~~", "~~~~~~~~~~~~~",
	      "~~~~~~~~~~", "~~~~~~~~~~";

	    foreach my $ctp (
	       sort { $prtys{$b}[siz] <=> $prtys{$a}[siz] }
	       keys %prtys
	      )
	    {
	       printf $fh "%-11s %20i %10i %15.3f\n",
		 $ctp, $prtys{$ctp}[cnt], $prtys{$ctp}[siz],
		 $prtys{$ctp}[siz] / $prtys{$ctp}[cnt];
	    }

	 }
	 $bitsec   = bitunset( $bitsec, permcmt );
	 $permtype = ();
	 @chelm    = ();
	 %prtys    = ();
      }

   }

   # END OF PERMANENT CHUNK

}

close($hpdm);

sub GetHeap {
   my $line = $_;

   #....... End of the heap section........#
   if ( $line =~ /^Total heap size/ ) {
      $bitsec = bitset( $bitsec, (endtoph) );
   }

   #........Begin of the heap section.......#
   if ( $line =~ /HEAP DUMP/ ) {
      $t1 = time;
      my $r1 = index( $line, "\"" );
      my $r2 = index( $line, "\"", $r1 + 1 );
      printf "\nAnalysizing heap: %+17s ",
	( substr $line, $r1 + 1, $r2 - $r1 - 1 );

      if ( $line =~ /sga heap/ ) {
	 $bitsec = bitset( $bitsec, topheap );
	 printf $fh "\n\n\n" . ( '=' x 80 ) . "\n" . $line;
	 my $ll = length($line) - 1;
	 printf $fh '~' x ($ll) . "\n\n";
	 $hline = $ll;
      }

      if ( $line !~ /sga heap/ ) {
	 $bitsec = bitset( $bitsec, genheap );
	 if ( $SUBDT == TRUE ) {
	    printf $fh "\n\n\n" . ( '=' x 80 ) . "\n" . $line;
	    my $ll = length($line) - 1;
	    printf $fh '~' x ($ll) . "\n\n";
	 }
      }

   }

   #........Begin of reserv free list...... #
   if ( $line =~ /RESERVED FREE LISTS/ ) {
      $bitsec = bitset( $bitsec, rfreels );

   }

   #.........Begin of free list.............#
   if ( $PRTFL == TRUE ) {
      if ( $line =~ /FREE LISTS:/ && $line !~ /RESERVED/ ) {
	 printf $fh "\n\nFree list:(Non empty buckets)\n";
	 printf $fh "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n";
	 $bitsec = bitset( $bitsec, freelst );
      }
   }

   #.........Comment on permanent chunck...#
   if ( $CHCPM == TRUE && $line =~ /PERMANENT CHUNKS:/ ) {
      $bitsec = bitset( $bitsec, permcmt );
   }

   { return (0); }

}

printf PUSHCOLOR RED "\n";
printf PUSHCOLOR RED ON_GREEN "OUTPUT WRITTEN TO %s ", $ofile;
printf RESET;
printf "\n\n";

__END__

=head1 NAME

heap.pl - perl implementation of the heap.awk heap dump analyzer

=head1 SYNOPSIS

perl heap.pl [I<options>] [I<TRACEFILE>]

perl [I<TRACEFILE>]

=head1 DESCRIPTION

This is the perl implementation of heap.awk (see mos B<note 825886.1>). 
The reason for writing a perl version is the perl indexes utilization which 
speeds up the execution. Ranking of heap descriptor has been included
(see mos B<note  1593434.1>). The script has been tested
using B<heapdump> at level B<0x10000002> , B<0x00000002> and event B<10235> at level B<65536> (KGHCHFCPM: 0x1000).
Output is written directly to a file with suffix .heapdump.<currentdate>.
Some code lines that try to catch heap corraption have been recently added.


=head1 OPTIONS

=over 8

=item B<-h>

Print the man page 

=item B<-f>

disable the free list distribution output; Mind that for the seek of simplicity 
the free list section reports only non empty buckets. B<Default is on>

=back

=over 8

=item B<-t> I<THRESHOLD>

In the memory allocation type summary prints only allocation greater than the
threshold.  This can be useful to have a shortest list of allocation type with
a significant amount of memory. B<Default is zero>.  

=back

                                                                  
        BreakDown                                                       
        ~~~~~~~~~                                                      
                                                                  
                    Type    Count        Sum         Average Percent  
                    ~~~~    ~~~~~        ~~~         ~~~~~~~ ~~~~~~~  
        Free(heap.pl)          57    5161760        90557.19   30.77  
        KSFD SGA I/O b          1    4190376      4190376.00   24.98  
        KGLHD                3633    2015192          554.69   12.01  
        KQR PO               1864    1439104          772.05    8.58  
        dbgefgHtAddSK-1        24     482624        20109.33    2.88  
        parameter table       240     472008         1966.70    2.81  
                                    +---+---+                         
                                        |                             
                                        |                             
                +---------+             |                            
                |threshold|-------------+                             
                +---------+                                           

=over 8

=item B<-s> I<METHOD>

The heap.pl includes the list of top 10 heap descriptor, it can be sorted by number of extents B<extents> or by B<size>. Default is by size.

 
=back

        Top(10):list subheap ds ordered by size                        
                                                                       
                   DS ADDR    EXTENTS            SIZE TYPE             
              ~~~~~~~~~~~~    ~~~~~~~    ~~~~~~~~~~~~ ~~~~~~~~~~~~     
            /   0xbec6c568        172          704512 PLDIA^191e0a8d   
            |   0xbe927b70         62          328288 PLMCD^2d1fad2c   
            |   0xbed3d008        290          322400 KOKTD^feff3964   
            |   0xbe959a88         64          262144 SQLA^44d3fd04    
        +---+   0xbe996a88         59          241664 SQLA^def94bfb    
        |   |   0xbe98ca88         58          237568 SQLA^848d1637    
        |   |   0xbe9eca88         55          225280 SQLA^f942ecdf    
        |   |   0xbe93c808         40          163840 PLDIA^96657e50   
        |   |   0xbe94aa88         35          143360 SQLA^7829c47a    
        |   \   0xbea03790         33          135168 PLDIA^e286e5af  
        |                        \-----/      \------/                 
        |                           |             |                   
        |     +--------+            |             |                    
        +---->| TOPDS  |            |             |                    
              +--------+            |             |                    
                                    |             |                    
              +--------+  +----------------+  +---------------+       
              | sortds |->| sort_by_extent |->|  sort_by_size |        
              +--------+  +----------------+  +---------------+        

=over 8


=item B<-g>

Debug option. Set the variable B<$DEBUG=TRUE> and print the elements of 
the array B<$chelm> while parsing heap section. As far as I can see most of 
the errors come from this section splitting line in single tokes.  

=back

        Chunk 8ef73000 sz=     4096    recreate  "KGLH0^ea369dda "  
        Chunk 8dea5970 sz=     4096    recreate  "SQLA^bf1d7a5   "  
        Chunk 8efbe000 sz=     4096    recreate  "KGLH0^bf1d7a5  "  
        Chunk 8dea4970 sz=     4096    recreate  "SQLA^86111aab  "  
                               +---+   +-------+ +-------------+
                                 |        |             |
                                 |        |             |
                      +----------+        |             +-----+
                      |                   |                   |
                +-----------+       +-----------+      +-------------+
                | $chelm[3] |       | $chelm[4] |      | $alloctype  |
                +-----------+       +-----------+      +-------------+

=over 8


Lines with a token like this "sz=509150984" rappresent an exception 
to be managed by the parser

=back

=head1 REFERENCES


=over 8

=item B<http://gbr30026.uk.oracle.com:81/Public/TOOLS/Awk/heap2_7.awk>

=item B<Note 1088239.1> Master Note for Diagnosing ORA-4031 

=item B<Note 396940.1>  Troubleshooting and Diagnosing ORA-4031 Error [Video] 

=item B<Note 61866.1>   Debugging KGH

=item B<Note 35084.1>   EVENT: HEAPDUMP - Interpreting 

=item B<Note 39686.1>   EVENT: HEAPDUMP - How to get 

=back

=cut


