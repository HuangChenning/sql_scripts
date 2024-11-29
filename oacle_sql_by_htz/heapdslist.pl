#!/usr/bin/perl
use strict;

my    $cnt=0;


my    $subpl;   # Supbool and subpool duration information
my    @kghds;   # Head descriptor information(addr,size,num of exnt,desc type)

### kghds index ###
my    $addr=0;  
my    $size=1;
my    $extn=2;
my    $desc=3;
###################

my    @kghar;   # Array of heap descriptor information
my    $elemn;   # Number of elements in kghar
my    %typtb;   # Unique index with (ds address , ds type )
my    @dsinf;   # Used to stuff the typtb
my    $smart=0; # Used to skip some unseful section of the dump

my    $cn;
my    $cx;
my    $hpdm=$ARGV[0];  #1st  arg: tracefile name 
my    $rnck=$ARGV[1];  #2nd  arg: size of the top list 
my    $trsh=$ARGV[2];  #3th  arg: max size of ds skipped 


sub printreport{
 my ($rnck,$sgah,@dsarr)=@_;
 my $elemn=scalar(@dsarr);
 my $hdr;
 my $tab;

 if ( $elemn != 0 ) 
 {
 print  "\n";
 print  "HEAP,\n";
 print  "DURATION         DS ADDRESS          SIZE  EXTENTS      TYPE\n";
 print  "--------   ----------------    ---------- --------      ------------\n" ;
 } 
 
 if ( ($elemn - $rnck)>=0 ) { 
 for(my $cn=(( $rnck != 0 ) ? ( $elemn - $rnck ) : 0 ); $cn<$elemn ; $cn++)
 {
  printf("%s %+21s %+13s %+8s %20s \n",
   $sgah,$dsarr[$cn][0],$dsarr[$cn][1],$dsarr[$cn][2],$dsarr[$cn][3]);
 }

 }
 if ( ($elemn - $rnck)<0 ) {
 for(my $cn=0 ; $cn<$elemn ; $cn++)
 {
  printf("%s %+21s %+13s %+8s %20s \n",
   $sgah,$dsarr[$cn][0],$dsarr[$cn][1],$dsarr[$cn][2],$dsarr[$cn][3]);
 }


 }  
 print "\nTotal heap descriptors $elemn\n";
 print "===============================\n\n";
}

open(HEAPDUMP,$hpdm) || die "cannot open file";
print "file:$hpdm\n";
print "top :$rnck\n";
print "trsh:$trsh\n";

MAIN_LOOP: while(<HEAPDUMP>)
{ 
  
 s/^\s+//;
 my @array=split;
  if (( $_ =~ "sga heap\\(" ) && !($_ =~  "FIVE"  )) {
        $_ =~ s/HEAP DUMP heap name=\"//g;
        substr($_,13,length($_),'');
        $_=~ s/sga heap//g;
        $subpl=$_;
        printf("SGA HEAP%s\n\n",$subpl);
        $smart=1;
        $cnt=0;
  } 
 
  
 if ( $smart ==  1 )
 {
 #Get the heapdescriptor
 if ( ( $array[0] eq "ds" ) && ( $array[2] eq "sz\=" ) ) 
 {
    $kghds[$addr]=$array[1];
    $kghds[$size]=$array[3];
    $kghds[$extn]=$array[5];
    $kghds[$desc]="NULL";
    
    #========================================================================= 
    #Problem with 11.2.0.2 format 
    #Chunk  07cb58e00 sz=     4096    recreate  "SQLA^6a0f9e2   "  latch=(nil)
    #ds     07cf61758 sz=   941784 ct=      228
    #       ^
    #========================================================================= 
    #Chunk  107bf7948 sz=     4096    freeable  "KGLH0^1400a489 " ds=0x107c0b7a0
    #ds     107c0b7a0 sz= 45048368 ct=    10996
    #========================================================================= 

    if ((length ( $kghds[$addr] ) == 9) && (substr($kghds[$addr],0,1) eq  "0" ))
     {  $kghds[$addr]=substr( $kghds[$addr],1,9); }

    #Add element to the array, filtering by ds size can reduce the size 
    #of the array
    
    if ( $kghds[$size] >= $trsh  ) {
        push(@kghar,[@kghds]); 
        printf ("\rds cnt=%i",++$cnt);
        }
  }

  #  Associative array 
  #  typtb: (Address,Type)   
  #       

    if (( $array[0] eq "Chunk") && ( $_ =~ "ds\=" ))
    {
       @dsinf=split(/\"/,$_);

       substr($dsinf[2] ,0 ,5,'');
       substr($dsinf[2],length($dsinf[2])-1,length($dsinf[2]),'');
       $dsinf[2]=~ s/0x//; 

       $typtb{$dsinf[2]} ||=0;
       $typtb{$dsinf[2]} = $dsinf[1]
 
     }

 } 

 #identy the end of sub pool, print result and rest all the variables
 #if ( ( $_ =~ /Unpinned space/ ) && ( $_ =~ /rcr/ )) 
 if ( ( $_ =~ /Total heap size/ ) && ($smart == 1) ) 
 {
   ########## SORT BY NUMBER OF EXTENTS ###########
   @kghar = sort { $a->[$extn] <=> $b->[$extn] } @kghar;
   ################################################

   # Set the ds type"
   $elemn=scalar(@kghar);
   for( $cx=0 ; $cx < $elemn ; $cx++) {
      $kghar[$cx][3]=$typtb{$kghar[$cx][0]};
     }
    
   &printreport($rnck,$subpl,@kghar);

   ########### RESET THE ARRAYS #################
   @kghar=();    
   %typtb=();   
   @dsinf=();
   $smart=0;
 }
}

close(HEAPDUMP);


