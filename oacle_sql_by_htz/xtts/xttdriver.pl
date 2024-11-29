#!/usr/bin/perl
#
# $Header: rdbms/demo/rman_xttconvert_ver1/xttdriver.pl /main/1 2014/12/23 19:37:34 asathyam Exp $
#
# xttdriver.pl
#
# Copyright (c) 2013, 2014, Oracle and/or its affiliates. All rights reserved.
#
#    NAME
#      xttdriver.pl - Cross Platform Transportable Tablespace DRIVER perl
#                     script
#
#    DESCRIPTION
#      The script that is run to perform the main steps of the XTTS with Cross
#      Platform Incremental Backups procedure.
#
#    VERSION
#      1.4.2.1
#      Whenever you change the version change the "myversion" parameter
#
#    NOTES
#      In version 1.4 two new options -P and -G have been added.
#
#      In the current flow the datafiles are transported using a staging area
#      in the source and desination. This has been eliminated by using
#      dbms_file_transfer.
#
#      Parallelism is supported for rollforward if rollparallel is set
#
#    Bug Fixes
#    ==========  
#      Dec 15 2014 [Version 1.4.2.1]
#      -----------------------------
#        1. Bug 20192155: Fix for ORA-15126
#        2. Added --version option to give version
#
#      Nov 24 2014 [Version 1.4.2]
#      ------------------------------
#        1. Enhancement: Added getparallel option to transfer datafiles in
#           parallel.
#
#      March 24 2014 [Version 1.4.1]
#      ------------------------------
#        1. 18456868 - Made sure sqlplus and rman is present in the PATH
#        2. 18456834 - Added new option -F/--propfile to pass the location
#              of properties file if required. This was requested by EM.
#        3. 18459238 - dfcopydir was not required when we run using -G
#           option. The checking has been enhanced.
#        4. Even when convert instance is used, the -G should be run only
#           from destination instance and not the conversion instance
#        5. Impdp added ';' at the end which resulted in error. Fixed this 
#        6. Added more debugging messages
#        7. Do more error checking before proceeding to next steps
#        8. Bug 17819946 - When number of tablespaces is more, the length
#           of list exceeds 2499 and fails. This is also fixed
#        9. If debug option is set to more than 1 the temporary files are
#           preserved. Otherwise it is deleted.
#       10. Bug 18797439 - Add new option -I/--propdir. All required files
#           will be picked from the runtime location of xttdriver.pl 
#       11. Clean up the code such that the temp files are more readable
#           and can be mapped to backups   
#
#    MODIFIED   (MM/DD/YY)
#    asathyam    12/16/14 - Bug 20192155: ASM convert exceeds 50 chars
#    asathyam    11/11/14 - Get parallel implemenation for getfile
#    asathyam    05/19/14 - EM wanted only propfile to be picked from
#                           specified location.
#    asathyam    03/26/14 - Bug fixes. Details mentioned above
#    asathyam    01/30/14 - Implement doug's comments
#    asathyam    11/17/13 - Added support for same endian support
#    asathyam    10/20/13 - Bug 17673485 :- Added new option to support
#                           individual specified tablespaces to be roll
#                           forwarded in parallel
#    asathyam    10/02/13 - Bug 17673476 :- Fixed ASM related issues
#    asathyam    05/28/13 - New version 1.4
#    svrrao      03/15/13 - Enhance to v1.3. Introduce parallelism
#    fsanchez    03/15/13 - Creation

#
# Globals
#
use Getopt::Long qw(:config no_ignore_case);
use POSIX ":sys_wait_h";
use strict;
use vars qw/ %opt /;
our %transfer = ();
our $context = \%opt;
our @tablespaces = ();
our @properties = ();
our %props;
our $tmp;
our $xttpath;
our $rmantfrdf;
our $rmandstdf;
our $xttprep;
our $rmanpath;
our $connectstring;
our $sqlSettings;
our $errfile;
our $getfile;
our $xtts_incr_backup = "xib";
our @rolltbsArray = ();
my %tbsHash;
my $fixCnvSql;
my $fixRollSql;
our @forkArray = ();
my $xttrollforwardp;
my $rollParallel = 0;
my $getParallel = 0;
my $metaTransfer = 0;
my $scpParms = 0;
our $xttprop;
our $cnvrSql       = "xttcnvrtbkupdest.sql";
our $stageondest;
our $backupondest;
our $platformid;
our $connectstringcnvinst;
our $myversion = "1.4.2.1";

# Following constants are for the options that are used in the perl script
use constant PREPARE      => 1;
use constant BCKPINCR     => 2;
use constant NEWPLAN      => 3;
use constant PUTFILE      => 4;
use constant GETFILE      => 5;

###############################################################################
# Function : parseArg
# Purpose  : Command line options processing
# Inputs   : None
# Returns  : None
###############################################################################
sub parseArg
{
   GetOptions ($context,
               'convert|c',
               'debug|d:i',
               'generate|e',
               'incremental|i',
               'orahome|o=s',
               'prepare|p',
               'rollforward|r',
               'determinescn|s',
               'xttdir|D=s',
               'propfile|F=s',
               'getfile|G',
               'propdir|I',
               'clearerrorfile|L',
               'orasid|O=s',
               'putfile|P',
               'rolltbs|R=s',
               'setupgetfile|S',
               'version|v',
               'help|h'
              ) or usage();

   if ($context->{"help"})
   {
      usage();
   }

   if ($context->{"version"})
   {
      PrintMessage ("Version is $myversion");
      exit (1);
   }

   if (defined ($context->{"debug"}) && ($context->{"debug"} == 0))
   {
      $context->{"debug"} = 1;
   }
   if ($ENV{'XTTDEBUG'})
   {
      $context->{"debug"} = $ENV{'XTTDEBUG'};
   }

   # User provided a directory, start from there to pick up files
   if ($context->{"propdir"})
   {
      use File::Basename;
      chdir (dirname($0));
   }

   if ($context->{"propfile"})
   {
      $xttprop = $context->{"propfile"};
   }
   else
   {
      $xttprop = "xtt.properties";
   }
}

###############################################################################
# Function : touchErrFile
# Purpose  : Create the error file if requested
###############################################################################
sub touchErrFile
{
   my $message = $_[0];

   open ERRFILE, ">>$errfile";
   print ERRFILE "$message\n";
   close ERRFILE;
}

###############################################################################
# Function : Unlink
# Purpose  : Delete the file if the debug level is less than 2
###############################################################################
sub Unlink
{
   my $delFile = $_[0];
   my $force   = $_[1];

   if ($force || ($context->{"debug"} < 2))
   {
      unlink ($delFile);
   }
}

###############################################################################
# Function : GetRMANTrace
# Purpose  : get the trace file name
###############################################################################
sub GetRMANTrace
{
   my $fileAppend = $_[0];
   my $trace = "";
   my $traceFile;

   if ($context->{"debug"})
   {
      $traceFile = "$tmp/rmantrc_".GetTimeStamp().
                    "_".$fileAppend.".trc";
      $trace = "debug trace $traceFile";
   }
   return ($trace, $traceFile);
}

###############################################################################
# Function : deleteErrFile
# Purpose  : check if the error file exists and delete
###############################################################################
sub deleteErrFile
{
   if (-e $errfile)
   {
      Unlink ($errfile, 1);
   }
}

###############################################################################
# Function : checkErrFile
# Purpose  : check if the error file exists
###############################################################################
sub checkErrFile
{
   if (-e $errfile)
   {
      {
die "
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Error:
------
      Some failure occurred. Check $errfile for more details
      If you have fixed the issue, please delete $errfile and run it
      again OR run xttdriver.pl with -L option
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
";
      }
   }
}

###############################################################################
# Function : debug
# Purpose  : print if environment variable is set or if debug flag is passed
###############################################################################
sub debug
{
   if ($context -> {"debug"})
   {
      print $_[0] . "\n";
   }
}

###############################################################################
# Function : Die
# Purpose  : Print message and exit
###############################################################################
sub Die
{
    my $message = $_[0];

    touchErrFile($message);
die "
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Error:
------
$message
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
";
}

###############################################################################
# Function : trim
# Purpose  : To remove whitespace from the start and end of the string
###############################################################################
sub trim
{
  my $string = $_[0];
  $string =~ s/^\s+//;
  $string =~ s/\s+$//;
  return $string;
}

###############################################################################
# Function : checkError
# Purpose  : check if any error was there and bail out
###############################################################################
sub checkError
{
   my ($errorMessage, $output) = @_;

   chomp ($output);
   $output = trim ($output);

   if (($output =~ /ORA[-][0-9]/) || ($output =~ /SP2-.*/))
   {
      debug $output;
      Die("$errorMessage");
   }
   debug $output;
}

###############################################################################
# Function : PrintMessage
# Purpose  : Print the message that is passed to it
# Inputs   : Any text
# Outputs  : None
# NOTES    : None
###############################################################################
sub PrintMessage
{
    my $message = $_[0];

print "
--------------------------------------------------------------------
$message
--------------------------------------------------------------------
";
}

sub delete_error_file
{
  if (defined $_[1])
  {
    if (-e $_[1])
    {
       unlink ($_[1]);
    }
    else
    {
    printlog("file $_[1] is not find")
    }
   
  }
}


###############################################################################
# Function : parseProperties
# Purpose  : Parse the properties file xtt.properties
###############################################################################
sub parseProperties
{
   PrintMessage ("Parsing properties");

   # Check if any failure occured and stop exection
   checkErrFile();

   @properties = qw(tablespaces stageondest storageondest dfcopydir
                    backupondest backupformat platformid oracle_home_cnvinst
                    oracle_sid_cnvinst asm_home asm_sid dstlink
                    srcdir dstdir srclink rollparallel getfileparallel
                    metatransfer desthost desttmpdir destuser);
   open my $in, "$xttprop" or Die "$xttprop not found: $!";
   
   while(<$in>)
   {
      next if /^#/;
      $props{$1}=$2 while m/(\S+)=(.+)/g;
   }
   close $in;

   if ($context -> {"debug"})
   {
      foreach my $pkey (keys %props)
      {
         print "Key: $pkey\n";
         print "Values: $props{$pkey}\n";
      }
   }
   @tablespaces = split(/,/, $props{'tablespaces'});

   PrintMessage ("Done parsing properties");
}

###############################################################################
# Function : check
# Purpose  : check if the properties were defined
###############################################################################
sub check
{
  my $arg = $_[0];
  my $key = $_[1];

  debug "ARGUMENT $key";

  if (!defined ($arg))
  {
     Die ("Please define xtt.properties:$key");
  }
}

###############################################################################
# Function : checkNoPwdSSHEnabled
# Purpose  : For putfile option few properties will be not be required, the
#            same applies for the plan option
###############################################################################
sub checkNoPwdSSHEnabled
{
   my $outFile = "";

   if ($metaTransfer == 0)
   {
      return;
   }

   $outFile = "$tmp/transferFile".GetTimeStamp().".log";

   unless (system ("ssh $scpParms \"echo host\" 2> $outFile") == 0)
   {
      my @failArray = ();
      open FAIL, "$outFile";
      @failArray = <FAIL>;
      close FAIL;
      Die ("Passwordless SSH not enabled to machine\n@failArray");
   }
}

###############################################################################
# Function : transferFiles
# Purpose  : For putfile option few properties will be not be required, the
#            same applies for the plan option
###############################################################################
sub transferFiles
{
   my @trnsfrFiles = @_;
   my $output = 0;
   my $files = "";
   my $scpParmsL = "";
   my $outFile = "$tmp/transferFile".GetTimeStamp().".log";

   if ($metaTransfer == 0)
   {
      return;
   }
   foreach my $x (@trnsfrFiles)
   {
      chomp($x);
      $files = $files."$x ";
   }
   $scpParmsL = 
         "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ".
         "NumberOfPasswordPrompts=0 ";
   unless (system ("scp $scpParmsL $files ".$context -> {"remoteConnect"}.
                     ":".$context->{'desttmp'}." 2> $outFile") == 0)
   {
      print "scp $scpParmsL $files ".$context -> {"remoteConnect"}.
                     ":".$context->{'desttmp'}." 2> $outFile";
      my @failArray = ();
      open FAIL, "$outFile";
      @failArray = <FAIL>;
      close FAIL;
      Die ("Unable to transfer files to destination machine\n@failArray");
   }
   Unlink ($outFile);
}

###############################################################################
# Function : getParallelProp
# Purpose  : Find how many files can be fetchde in parallel
###############################################################################
sub getParallelProp
{
   my $propValue = $_[0];

   # We need to find how how many cores are there in the machine and then use 
   # that number to see if what the user has provided is less than that
   # For now we assume that max is 8
   # use Sys::Info;
   # use Sys::Info::Constants qw( :device_cpu );
   # my $info = Sys::Info->new;
   # my $cpu  = $info->device( CPU => %options );
   #
   # printf "CPU: %s\n", scalar($cpu->identify)  || 'N/A';
   # printf "CPU speed is %s MHz\n", $cpu->speed || 'N/A';
   # printf "There are %d CPUs\n"  , $cpu->count || 1;
   # printf "CPU load: %s\n"       , $cpu->load  || 0;
   if ($propValue > 8)
   {
      $propValue = 8;
      PrintMessage ("Maximum $propValue files will be fetched in parallel");
   }

   return $propValue;
}

###############################################################################
# Function : checkProps
# Purpose  : For putfile option few properties will be not be required, the
#            same applies for the plan option
###############################################################################
sub checkProps
{
   PrintMessage ("Checking properties");

   # Check if any failure occured and stop exection
   checkErrFile();

   # The following are required irrespective of what option is used
   check $props{'tablespaces'},  $properties[0];
   check $props{'platformid'},   $properties[6];
   check $props{'backupformat'}, $properties[5];
   check $props{'stageondest'},  $properties[1];
   check $props{'backupondest'}, $properties[4];

   if (!defined($props{'parallel'}) ||
       $props{'parallel'} <= 0)
   {
      $props{'parallel'} = 8;
   }

   if (defined($props{'metatransfer'}))
   {
      if (!defined($props{'desthost'}))
      {
         Die ("Files transfered requested, but remote host not defined");
      }
      if (!defined($props{'desttmpdir'}))
      {
         Die ("Files transfered requested, but remote dir not defined");
      }
      if (defined($props{'destuser'}))
      {
         $context -> {"remoteConnect"} = 
            $props{'destuser'}."@".$props{'desthost'};
      }
      else
      {
         $context -> {"remoteConnect"} = $props{'desthost'};
      }
      $context -> {"desttmp"} = $props{'desttmpdir'};
      $metaTransfer = 1;
      $scpParms = 
         "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ".
         "NumberOfPasswordPrompts=0 ".$props{'desthost'};
   }

   if (!defined($props{'getfileparallel'}) ||
       $props{'getfileparallel'} <= 0)
   {
      $getParallel = 1;
   }
   else
   {
      $getParallel = getParallelProp($props{'getfileparallel'});
   }

   # Depending on option the checks are done   
   if (defined($context->{"putfile"}))
   {
      check $props{'srcdir'},   $properties[12];
      check $props{'dstdir'},   $properties[13];
      check $props{'dstlink'},  $properties[11];
   }
   if (defined($context->{"setupgetfile"}) ||
       defined($context->{"getfile"}))
   {
      check $props{'srcdir'},   $properties[12];
      check $props{'dstdir'},   $properties[13];
      check $props{'srclink'},  $properties[14];
   }

   if (defined($context->{"prepare"}))
   {
      check $props{'dfcopydir'}, $properties[3];
   }
   PrintMessage ("Done checking properties");
}

###############################################################################
# Function : warnMesg
# Purpose  : Print message and exit
###############################################################################
sub warnMesg
{
    my $message = $_[0];

print "
####################################################################
Warning:
--------
$message
####################################################################
";
}

###############################################################################
# Function : checkDbLink
# Purpose  : To check if the given DB link works
###############################################################################
sub checkDbLink
{
   my $sqlOutput ;
   my $dblink = $_[0];
   my $sqlQuery =
      "select 'Count=' || count(*) from dual@"."$dblink;";

   $sqlOutput = `sqlplus -L -s $connectstring <<EOF
                         $sqlSettings
                         $sqlQuery
                         quit;
                         EOF
                         `;
   chomp ($sqlOutput);
   $sqlOutput = trim ($sqlOutput);

   if ($sqlOutput =~ m/^Count=(.*)/)
   {
      if ($1 <= 0)
      {
         Die ("Database link $props{'dstlink'} is not working");
      }
   }
   else
   {
      Die ($sqlOutput);
   }
}

###############################################################################
# Function : checkDBState
# Purpose  : To check state of database
###############################################################################
sub checkDBState
{
   my $sqlOutput ;
   my $dblink = $_[0];
   my $sqlQuery =
      'select \'STATUS=\' || status FROM v\$instance;';

   $sqlOutput = `sqlplus -L -s $connectstring <<EOF
                         $sqlSettings
                         $sqlQuery
                         quit;
                         EOF
                         `;
   chomp ($sqlOutput);
   $sqlOutput = trim ($sqlOutput);

   if ($sqlOutput =~ m/^STATUS=(.*)/)
   {
      my $startStatus = trim ($1);
      if ($startStatus ne "STARTED")
      {
         Die ("Open database in nomount mode and try rollforward again");
      }
   }
   else
   {
      Die ($sqlOutput);
   }
}

###############################################################################
# Function : checkDirObjects
# Purpose  : In order to transfer the files we need to define directory
#            objects, this function will check if they are defined.
###############################################################################
sub checkDirObjects
{
   my $dirtoCheck = $_[0];
   my $remoteLink = $_[1];
   my $dirtoCheckLink;
   my $dirObjPath;
   my $sqlOutput ;
   my $sqlQuery ;

   debug "checkDirObjects: Check dir path $remoteLink\n";

   if ($remoteLink eq "")
   {
      $dirtoCheckLink = $dirtoCheck;
      debug "checkDirObjects: remotelink not present\n";
      $sqlQuery =
                  "SELECT 'DIRECTORY_PATH=' || DIRECTORY_PATH FROM ".
                  "ALL_DIRECTORIES WHERE DIRECTORY_NAME = \'$dirtoCheck\';";
   }
   else
   {
      $dirtoCheckLink = $dirtoCheck." in target link ".$remoteLink;
      $sqlQuery =
                  "SELECT 'DIRECTORY_PATH=' || DIRECTORY_PATH FROM ".
                  "ALL_DIRECTORIES\@".
                  "$remoteLink WHERE DIRECTORY_NAME = \'$dirtoCheck\';";
   }

   $sqlOutput = `sqlplus -L -s $connectstring <<EOF
                         $sqlSettings
                         $sqlQuery
                         quit;
                         EOF
                         `;

   chomp ($sqlOutput);
   $sqlOutput = trim ($sqlOutput);

   if (($sqlOutput =~ m/^DIRECTORY_PATH=(.*)/) && ($1))
   {
      $dirObjPath = $1;
   }
   else
   {
      print "Directory object \"$dirtoCheckLink\" does not exist\n";
      Die ($sqlOutput);
   }

   return $dirObjPath;
}

###############################################################################
# Function : verifySrcdirDatafiles
# Purpose  : Verify if the datafiles are present in the same directory
#            as defined in the source directory object
###############################################################################
sub verifySrcdirDatafiles
{
   my $dfPath = "$tmp/xttprepare.cmd";
   my @dfList = ();
   my @unidfList = ();
   my %seen;
   my $name;

   open DFLIST, $dfPath ;
   @dfList = <DFLIST>;
   close DFLIST;

   foreach my $df (@dfList)
   {
      chomp ($df);
      if ($df =~ /^#DNAME:(.*)/)
      {
         $name = $1;
         if (! (grep { $_ eq $name } @unidfList))
         {
            push (@unidfList, $1);
         }
      }
   }

   foreach my $df (@unidfList)
   {
      if ($props{'srcdfpath'} ne $df)
      {
         warnMesg ("Datafile path $df and source directory object ".
                   "path $props{'srcdfpath'} doest not match");
      }
   }
}

##
## This routine is called from
## Prepare Src
## Backup Incr (backincr)
## New Plan (newplan)
## Putfile
## Getfile
## Helper routine to batch the tablespaces sent into control file
## queries, this way too many controlfile reads is avoided.
## It takes one parameter, to tell who called it
## 1 => Prepare, 2 => backincr, 3 => newplan, 4 => putfile, 5 => getfile
##
sub generate_batch_tsoutput()
{
   my $option        = $_[0];
   my $stageondest   = $props{'stageondest'};
   my $platform      = "'$props{'platform'}'";
   my $storageondest = $props{'storageondest'};
   my $dfcopydir     = $props{'dfcopydir'};
   my $script_type   = "PREPARE";
   my $output;

   my $number_of_tablespaces_per_batch =
      int(($#tablespaces + 1)/$props{'parallel'});

   # Check if any failure occured and stop exection
   checkErrFile();

   $number_of_tablespaces_per_batch = ($number_of_tablespaces_per_batch == 0)
                                      ? 1
                                      : $number_of_tablespaces_per_batch;

   my $total_sets = $number_of_tablespaces_per_batch * $props{'parallel'};

   debug $connectstring;
   debug "size of tablespace " . scalar(@tablespaces);
   debug "No. of tablespaces per batch " . $number_of_tablespaces_per_batch;

   my $countno = 0;
   my $tablespace_str  = "";
   my $old_tablespace_str  = "";

   ## Generate the rmanconvert.cmd and xttplan.txt from the output
   ## for Prepare
   if (($option == PREPARE) || ($option == PUTFILE) || ($option == GETFILE))
   {
      open(XTTPLAN, ">$xttpath") ||
          die 'Cant find xttplan.txt, TMPDIR undefined';

      if ($option == PREPARE)
      {
         open(RMANCONVERT, ">$rmanpath") ||
             die 'Cant find rmanconvert.cmd, TMPDIR undefined';
      }
      else
      {
         $script_type = "TRANSFER";
         &verifySrcdirDatafiles();

         open(RMANDSTDF, ">$rmandstdf") ||
             die 'Cant find $rmandstdf, TMPDIR undefined';
      }
   }
   elsif ($option == BCKPINCR)
   {
     open XTTNEWPLAN, ">$tmp/xttplan.txt.new" or die $!;

     $script_type = 'DETNEW';
   }
   elsif ($option == NEWPLAN)
   {
     $script_type = 'PREPNEXT';
   }

   ## Based on parallelism, do so many tablespaces at a time.
   my $ind = 0;
   while ($ind < $total_sets ||
          $ind < scalar(@tablespaces))
   {
      ## Remove leading and trailing spaces.
      $tablespaces[$ind] =~ s/^\s+//;
      $tablespaces[$ind] =~ s/\s+$//;

      ## grab the rest
      while ($ind < scalar(@tablespaces) &&
             $ind >= $total_sets)
      {
         $tablespace_str .= "'" . $tablespaces[$ind] . "'";
         if ($ind !=  $#tablespaces)
         {
            $tablespace_str .= ",";
         }
         $ind++;
      }

      if ($ind < $total_sets)
      {
         $tablespace_str .= "'" . $tablespaces[$ind] . "'";

         if (($ind % $number_of_tablespaces_per_batch) !=
             ($number_of_tablespaces_per_batch-1))

         {
            $tablespace_str .= ",";
         }

         $countno++;
         $ind++;
      }

      if ($countno == $number_of_tablespaces_per_batch ||
          $ind == scalar(@tablespaces))
      {
        debug "TABLESPACE STRING :" . $tablespace_str;

        $countno = 0;

        ## Subst. for tablespace names
        open my $in, "xttprep.tmpl" or die $!;

        if (($option == PREPARE) || ($option == PUTFILE) ||
            ($option == GETFILE))
        {
           print "Prepare source for Tablespaces:
                  $tablespace_str  $stageondest\n";
           ## Open the pareparesrc.sql file and substitute all the parameters
           open my $prepout, ">xttpreparesrc.sql" or die $!;

           while(<$in>)
           {
              s/%%stageondest%%/$stageondest/;
              s/%%storageondest%%/$storageondest/;
              s/%%dfcopydir%%/$dfcopydir/;
              s/%%tmp%%/$tmp/;
              s/%%parallel%%/$props{'parallel'}/;
              s/%%type%%/$script_type/;
              if ($_ =~ /%%TABLESPACES%%/)
              {
                 my @tbs = split(/,/, $tablespace_str);
                 foreach (@tbs) 
                 {
                    print $prepout "$_,\n";
                 }
                 print $prepout "NULL\n";
              } 
              else
              {  
                 print $prepout "$_";
              }
           }

           close $in;
           close $prepout;

           ## timestamp here -- start
           print "xttpreparesrc.sql for $tablespace_str started at ".
                 (localtime) . "\n";

           ## Reset tablespace string
           $old_tablespace_str = $tablespace_str;
           $tablespace_str  = "";

           ## Substitution ends here and xttpreparesrc.sql generated
           my $output = `sqlplus -L -s $connectstring \@xttpreparesrc.sql`;
           ## timestamp here -- end
           print "xttpreparesrc.sql for $tablespace_str ended at ".
                 (localtime) . "\n";
           checkError ("Error in executing xttpreparesrc.sql", $output);
    
           my @line = split /\n/, $output;

            if (($option == PUTFILE) || ($option == GETFILE))
            {
               foreach my $line (@line)
               {
                  if ($line =~ /^#PLAN:/)
                  {
                     $line =~ s/^#PLAN://;
                     print XTTPLAN "$line\n";
                     if ($line =~ /(\S+)::::(\S+)/)
                     {
                        print RMANDSTDF "::$1\n";
                     }
                  }
                  elsif ($line =~ /^#TRANSFER:/)
                  {
                     $line =~ s/^#TRANSFER://;
                     if ($line =~ /.*source_file_name=(.*?),(.*)/)
                     {
                        push(@{$transfer{$1}}, $2);
                     }
                  }
                  elsif ($line =~ /^#NEWDESTDF:/)
                  {
                     $line =~ s/^#NEWDESTDF://;
                     if ($option == PUTFILE)
                     {
                        $line =~ s/DESTDIR:/$props{'dstdfpath'}/;
                     }
                     print RMANDSTDF "$line\n";
                  }
               }
            }
            else
            {
               foreach my $line (@line)
               {
                  if ($line =~ /^#PLAN:/)
                  {
                     $line =~ s/^#PLAN://;
                     print XTTPLAN "$line\n";
                  }
                  elsif ($line =~ /^#CONVERT:/)
                  {
                     $line =~ s/^#CONVERT://;
                     print RMANCONVERT "$line \n";
                  }
               }
               ## Invoke the backup as copy routine once generated as the last
               ## step
               my $rmancopycmd = "$tmp/xttprepare.cmd";

               my ($rmanTrace, $traceFile) = GetRMANTrace("prepare");
               $output = `rman target \/ $rmanTrace cmdfile $rmancopycmd`;

               if ($output =~ /ERROR MESSAGE/)
               {
                  Die("$output $!");
               }
               Unlink ($traceFile);
            }
        }
        elsif ($option == BCKPINCR)
        {
           ## Subst. for tablespace names

           print "Prepare newscn for Tablespaces: $tablespace_str \n";

           ## Open the pareparesrc.sql file and substitute all the parameters
           open my $prepout, ">xttdetnewfromscnsrc.sql" or die $!;

           while(<$in>)
           {
              s/%%tmp%%/$tmp/;
              s/%%type%%/$script_type/;
              if ($_ =~ /%%TABLESPACES%%/)
              {
                 my @tbs = split(/,/, $tablespace_str);
                 foreach (@tbs) 
                 {
                    print $prepout "$_,\n";
                 }
                 print $prepout "NULL\n";
              } 
              else
              {  
                 print $prepout "$_";
              }
           }

           close $in;
           close $prepout;

           ## Reset tablespace string
           $tablespace_str  = "";

           ## Substitution ends here and xttdetnewfromscnsrc.sql generated

           $output = `sqlplus -L -s $connectstring \@xttdetnewfromscnsrc.sql`;
           checkError ("Error in executing xttdetnewfromscnsrc.sql", $output);

           my @line = split /\n/, $output;

           foreach my $line (@line)
           {
             print XTTNEWPLAN $line . "\n";
           }
        }
        elsif ($option == NEWPLAN)
        {
           ## Subst. for tablespace names

           print "Prepare newscn for Tablespaces: $tablespace_str \n";

           ## Open the pareparesrc.sql file and substitute all the parameters
           open my $prepout, ">xttpreparenextiter.sql" or die $!;

           while(<$in>)
           {
              s/%%tmp%%/$tmp/;
              s/%%type%%/$script_type/;
              if ($_ =~ /%%TABLESPACES%%/)
              {
                 my @tbs = split(/,/, $tablespace_str);
                 foreach (@tbs) 
                 {
                    print $prepout "$_,\n";
                 }
                 print $prepout "NULL\n";
              } 
              else
              {  
                 print $prepout "$_";
              }
           }

           close $in;
           close $prepout;

           ## Reset tablespace string
           $tablespace_str  = "";

           ## Substitution ends here and xttpreparenextiter.sql generated

           $output = `sqlplus -L -s $connectstring \@xttpreparenextiter.sql`;
           checkError ("Error in executing xttpreparenextiter.sql", $output);
        }
     }
   }
   if (($option == PREPARE) || ($option == PUTFILE) || ($option == GETFILE))
   {
      close (XTTPLAN);
      if ($option == PREPARE)
      {
         close (RMANCONVERT);
      }
      elsif ($option == GETFILE)
      {
         close (RMANDSTDF);

         # Ver: 1.4.1 We will generate the SQL file in the destination.
         my $transferCount = 0;

         open GETFILE1, ">$getfile";
         foreach my $user (sort keys %transfer)
         {
            debug "$user: @{$transfer{$user}}\n";
            foreach my $file (@{$transfer{$user}})
            {
               # Bug 17673476: If the destination file is for ASM, it does not
               # work with automated filenames. So we convert the names here.
               # The automated filenames will be of format "x.y.z". This will
               # converted to "x_y_z"
               my $destFile = $file;
               if ($destFile =~ m/(.*)\.([0-9]+)\.([0-9]+)/)
               {
                  $destFile = "$1_$2_$3";
               }

               print GETFILE1 "$transferCount,$file,$destFile\n";
            }
            $transferCount = $transferCount + 1;
         }
         close GETFILE1;
      }
      elsif ($option == PUTFILE)
      {
         close (RMANDSTDF);

         my $sqlQuery;

         foreach my $user (sort keys %transfer)
         {
            debug "$user: @{$transfer{$user}}\n";
            foreach my $file (@{$transfer{$user}})
            {
               # Bug 17673476: If the destination file is for ASM, it does not
               # work with automated filenames. So we convert the names here.
               # The automated filenames will be of format "x.y.z". This will
               # converted to "x_y_z"
               my $destFile = $file;
               if ($destFile =~ m/(.*)\.([0-9]+)\.([0-9]+)/)
               {
                  $destFile = "$1_$2_$3";
               }
               $sqlQuery = "
                  BEGIN
                  DBMS_FILE_TRANSFER.PUT_FILE(
                  source_directory_object      => '".$props{'srcdir'}."',
                  source_file_name             => '".$file."',
                  destination_directory_object => '".$props{'dstdir'}."',
                  destination_file_name        => '".$destFile."',
                  destination_database         => '".$props{'dstlink'}."');
                  END;
                  /
                  quit;
                  ";
               ## Invoke the backup as copy routine once generated as the last step
               $output = `sqlplus -L -s $connectstring <<EOF
                                  $sqlSettings
                                  $sqlQuery
                                  quit;
                                  EOF
                                  `;
               checkError ("Error in executing \n$sqlQuery\n", $output);
            }
         }
      }
   }
   elsif ($option == BCKPINCR)
   {
      close (XTTNEWPLAN);
   }

   if ($metaTransfer)
   {
      my @trnsfrFiles = ();
      if ($option == GETFILE)
      {
         push (@trnsfrFiles, "$tmp/xttnewdatafiles.txt");
         push (@trnsfrFiles, "$tmp/getfile.sql");
         transferFiles (@trnsfrFiles);
      }
      if ($option == BCKPINCR)
      {
         push (@trnsfrFiles, "$tmp/xttplan.txt");
         transferFiles (@trnsfrFiles);
      }
      if ($option == PREPARE)
      {
         push (@trnsfrFiles, "$tmp/rmanconvert.cmd");
         transferFiles (@trnsfrFiles);
         @trnsfrFiles = ();
         $context->{"desttmp"} = $props{'stageondest'};
         push (@trnsfrFiles, $props{'dfcopydir'}."/*");
         transferFiles (@trnsfrFiles);
         $context -> {"desttmp"} = $props{'desttmpdir'};
      }
   }
}
##
## End generate_batch_tsoutput
##

###############################################################################
# Function : assignGlobVars
# Purpose  : Assign global variables
###############################################################################
sub assignGlobVars
{
   if (! defined($context->{"xttdir"}))
   {
      if (defined($ENV{'TMPDIR'}))
      {
         $tmp = $ENV{'TMPDIR'};
      }
      else
      {
         Die ("TMPDIR not defined");
      }
   }
   else
   {
      $tmp = $context->{"xttdir"};
   }

   $xttpath   = "$tmp/xttplan.txt";
   $rmantfrdf = "$tmp/rmantfrdf.sql";
   $rmandstdf = "$tmp/xttnewdatafiles.txt";
   $xttprep   = "$tmp/xttprepare.cmd";
   $rmanpath  = "$tmp/rmanconvert.cmd";
   $errfile   = "$tmp/FAILED";
   $getfile   = "$tmp/getfile.sql";
   $connectstring = "/ as sysdba";
   $sqlSettings =
   "SET TRIMSPOOL OFF LINES 32767 PAGES 0 FEEDBACK OFF ".
   "VERIFY OFF DEFINE \"&\" TERMOUT OFF";
}

###############################################################################
# Function : checkMove
# Purpose  : Check if entry is present and move it
###############################################################################
sub checkMove
{
   my $srcPath = $_[0];
   my $dstPath = $_[1];

   if (!$dstPath)
   {
      my $timenow =  time;
      $dstPath = $srcPath.$timenow;
   }

   if (-e $srcPath)
   {
      system("\\mv $srcPath $dstPath");
   }
}

###############################################################################
# Function : fixXTTDestFile
# Purpose  : Fix the destination file by replacing the tag DESTDIR with the
#            actual location
###############################################################################
sub fixXTTDestFile
{
   my $replaceFile = 0;
   my @destArray = ();

   open(RMANDSTDF, "$rmandstdf") ||
      Die "Cant find $rmandstdf";
   @destArray = <RMANDSTDF>;
   close RMANDSTDF;

   foreach my $line (@destArray)
   {
       if ($line =~ /.*DESTDIR:.*/)
       {
          $replaceFile = 1;
          last;
       }
   }

   if ($replaceFile)
   {
      open(RMANDSTDF1, ">$rmandstdf"."temp") ||
         Die "Cant find $rmandstdf";
      $props{'dstdfpath'} = &checkDirObjects($props{'dstdir'});
      foreach my $line (@destArray)
      {
          $line =~ s/DESTDIR:/$props{'dstdfpath'}/;
          if ($line =~ m/(.*)\/(.*)\.([0-9]+)\.(.*)/)
          {
             $line = "$1/$2_$3_$4\n";
          }
          print RMANDSTDF1 "$line";
      }
      close RMANDSTDF1;
   }

   if ($replaceFile)
   {
      Unlink ("$rmandstdf", 1);
      system("\\cp $rmandstdf"."temp $rmandstdf");
   }
}

###############################################################################
# Function : getFilesSource
# Purpose  : Get files from the source database.
###############################################################################
sub getFilesSource
{
   PrintMessage ("Getting datafiles from source");

   my $output;
   my $connectstringcnvinst;
   my $pid;
   my @getArray = ();
   my $getFileTemp;

  sqlpl
   $props{'srcdfpath'} =
       &checkDirObjects($props{'srcdir'}, $props{'srclink'});

   fixXTTDestFile();

   $connectstringcnvinst = "/ as sysdba";

   open FILE, "$getfile" or Die ("Cannot open $getfile");;
   @getArray =  <FILE>;
   close FILE;

   foreach my $x (@getArray)
   {
      chomp ($x);
      if ($x =~ m/(.*?),(.*?),(.*)/)
      {
         my $sqlQuery = 
                 "BEGIN
                  DBMS_FILE_TRANSFER.GET_FILE(
                  source_directory_object      => '".$props{'srcdir'}."',
                  source_file_name             => '".$2."',
                  source_database              => '".$props{'srclink'}."',
                  destination_directory_object => '".$props{'dstdir'}."',
                  destination_file_name        => '".$3."');
                  END;
                  /
                  ";

         $getFileTemp = "getfile"."_$2"."_$1".".sql";
         open FILE, ">$getFileTemp";
         print FILE "$sqlQuery\nquit\n";
         close FILE;

         ChecktoProceed($getParallel);
         $pid = fork();

         if ($pid == 0)
         {
            PrintMessage ("Executing getfile for $getFileTemp");
            $output =  `sqlplus -L -s \"$connectstringcnvinst\" \@$getFileTemp`;
            checkError ("Error in executing $getFileTemp", $output);
            Unlink ($getFileTemp);
            exit (0);
         }
         else
         {
            UpdateForkArray ($pid, $getParallel);
         }
      }
   }

   while((my $pid = wait()) > 0)
   {
      #sleep (1);
   }

   PrintMessage ("Completed getting datafiles from source");
}

###############################################################################
# Function : prepare
# Purpose  : Initial preparation for script to run.
###############################################################################
sub prepare
{
   ###
   ### Prepare starts here
   ###

   PrintMessage ("Starting prepare phase");

   # Check if any failure occured and stop exection
   checkErrFile();

   my $timenow = time;

   ## Perform cleanup of files by renaming the xttplan.txt, rmanconvert.cmd
   ## and xttprep.cmd (datafile copy)
   checkMove($xttpath, $xttpath.$timenow);
   checkMove($rmanpath, $rmanpath.$timenow);
   checkMove($xttprep, $xttprep.$timenow);

   ## For each tablespace, lets generate the scripts
   my $stageondest   = $props{'stageondest'};
   my $platform      = "'$props{'platform'}'";
   my $storageondest = $props{'storageondest'};
   my $dfcopydir     = $props{'dfcopydir'};

   debug "Parallel:" . $props{'parallel'};

   ## Remove trailing '/'s
   $dfcopydir = $1 if($dfcopydir=~/(.*)\/$/);
   ## Check if previous ".tf" files present.
   ##
   my @present = glob("$dfcopydir/*.tf");

   if (@present)
   {
      ## Try deleting any existing copied datafiles
      system("\\rm -f $dfcopydir/*.tf");
      sleep 5;
   }

   if ($context->{"putfile"})
   {
      &checkDbLink($props{'dstlink'});
      $props{'srcdfpath'} = &checkDirObjects($props{'srcdir'});
      $props{'dstdfpath'} =
          &checkDirObjects($props{'dstdir'}, $props{'dstlink'});
      &generate_batch_tsoutput(PUTFILE);
   }
   elsif ($context->{"setupgetfile"})
   {
      $props{'srcdfpath'} = &checkDirObjects($props{'srcdir'});
      &generate_batch_tsoutput(GETFILE);
   }
   else
   {
      &generate_batch_tsoutput(PREPARE);
   }

   PrintMessage ("Done with prepare phase");
}

###############################################################################
# Function : checkExec
# Purpose  : Check if the rman and sqlplus executables are present in path
###############################################################################
sub checkExec
{
   if (defined ($context->{"orahome"}))
   {
      $ENV{'ORACLE_HOME'} = $context->{"orahome"};
   }
   else
   {
      if (defined ($ENV{'ORACLE_HOME'}))
      {
         $context->{"orahome"} = $ENV{'ORACLE_HOME'};
      }
      else
      {
         Die ("Niether ORACLE_HOME defined or orahome passed to script") ;
      }
   }

   if (defined ($context->{"orasid"}))
   {
      $ENV{'ORACLE_SID'} = $context->{"orasid"};
   }
   else
   {
      if (defined ($ENV{'ORACLE_SID'}))
      {
         $context->{"orasid"} = $ENV{'ORACLE_SID'};
      }
      else
      {
         Die ("Niether ORACLE_SID defined or orasid passed to script") ;
      }
   }

   debug "ORACLE_SID  : $context->{\"orasid\"}";
   debug "ORACLE_HOME : $context->{\"orahome\"}";

   $ENV{'PATH'} = "$context->{\"orahome\"}/bin".":".$ENV{'PATH'};
   $context->{'sqlexec'}   = "$context->{\"orahome\"}/bin/sqlplus";
   $context->{'rmanexec'}  = "$context->{\"orahome\"}/bin/rman";

   if (! -x $context->{"rmanexec"})
   {
      Die ("RMAN executable not found in path");
   }

   if (! -x $context->{"sqlexec"})
   {
      Die ("SQLPLUS executable not found in path");
   }
}

###############################################################################
# Function : Main
# Purpose  : Main entry point for the program
###############################################################################
sub Main
{
   parseArg();
   assignGlobVars();

   # User wanted to clear file, do it so here
   if ($context->{"clearerrorfile"})
   {
      Unlink ($errfile, 1);
   }

   parseProperties();
   checkProps();
   checkExec();

   #If we want specify tablespaces to be rolled forward, then store them in
   #a hash
   if ($context->{"rolltbs"})
   {
      @rolltbsArray = split (',', $context->{"rolltbs"});
      foreach my $x (@rolltbsArray)
      {
         $tbsHash{"$x"}= 1;
      }
   }

   if ($context->{"incremental"})
   {
      backincr();
   }
   elsif ($context->{"rollforward"})
   {
      fixXTTDestFile();
      rollforward();
   }
   elsif ($context->{"determinescn"})
   {
      newplan();
   }
   elsif ($context->{"convert"})
   {
      #If the transfer is across the same endian then platformid will be
      #set as 0.
      if ($props{'platformid'} == 0)
      {
         genConvertDFNames();
      }
      else
      {
         convert();
      }
   }
   elsif ($context->{"generate"})
   {
      plugin();
   }
   elsif (($context->{"prepare"}) || ($context->{"putfile"}) ||
          ($context->{"setupgetfile"}))
   {
      checkNoPwdSSHEnabled ();
      prepare();
   }
   elsif ($context->{"getfile"})
   {
      getFilesSource();
   }
   else
   {
      usage();
   }
}

###
### Incremental Starts here
###

## Generates <TMPDIR>/tsbkupmap.txt
## that maps tablespace to backup

sub gentablespace_backupmap
{
   my @line = split /\n/, $_[0];

   my $tsbkupmap = "$tmp/tsbkupmap.txt";
   my $incrbkups = "$tmp/incrbackups.txt";

   my $backupformat = $props{'backupformat'};
   my $i = 0;
   my @fnums = ();
   my @fnumorder = ();
   my $chan;
   my %bpfn;
   my %bpts;
   my %chfn;
   my $tsname;
   my $fno;
   my $order = 0;

   checkMove ($tsbkupmap);
   checkMove ($incrbkups);

   open(TSBKMAP, ">$tsbkupmap") ||
      Die("Cant open tablespace backup map file $!");
   open(INCRBKUPS, ">$incrbkups") || Die("Cant open incr backups file $!");

   while ($i <= $#line)
   {
      my $str = $line[$i];

      if ($str =~ /^ts::(.*)$/)
      {
         $tsname = $1;
         $order = 0;
      }
      elsif ($str =~ /channel (.*): specifying datafile/)
      {
        $chan = $1;
      }
      ## In HP, an issue was reported where in the RMAN output was
      ## shown as 'input datafile fno' instead of 'input datafile file number'.
      ## So parse for both here.
      elsif (($str =~ /input datafile file number=(\d+) name/) ||
             ($str =~ /input datafile fno=(\d+) name/))
      {
         $fno = $1 + 0;
         push(@fnums, $fno);
         $i++;
         next;
      }
      elsif (defined($chan) && $#fnums >= 0 )
      {
         my @new = @fnums;
         $chfn{$chan} -> {"fnumarray"} = \@new;
         @fnums = ();
      }
      elsif ($str =~ /channel (.*): finished piece/)
      {
         ## piece name is on the next line
         $i++;
         $str = $line[$i];

         $chan = $1;

         if ($str =~ /piece handle=(.+)[\/](\S+) tag/)
         {
            debug "backup piece:" . $2 . "\n" ;
            $bpfn{$2} -> {"fnumarray"} = $chfn{$chan} -> {"fnumarray"};
            $order = $order + 1;
            $bpfn{$2} -> {"fnumorder"} = $order;
            debug "TSNAME:" . $tsname;
            $bpts{$2} = $tsname;
         }
      }
      elsif ($str =~ /including current control file in backup set/)
      {
        do
        {
           $i++;
           $str = $line[$i];
        }
        while ($str !~ /Finished backup/);
      }

      $i++;
   }

   foreach my $pkey (keys %bpfn)
   {
      print INCRBKUPS $backupformat . "/$pkey\n";
      my @fns = @{$bpfn{$pkey} -> {"fnumarray"}};
      my $sizefns = @fns;

      print TSBKMAP $bpts{$pkey} . "::";

      my $orderx = $bpfn{$pkey} -> {"fnumorder"};
      foreach my $v (@fns)
      {
         $sizefns--;
         print TSBKMAP $v;
         print TSBKMAP "," if ($sizefns > 0);
      }

      print TSBKMAP ":::".  $orderx;
      print TSBKMAP "=" .  $pkey;
      print TSBKMAP "\n";
   }
   close(TSBKMAP);
   close(INCRBKUPS);
}

sub backincr()
{
   PrintMessage ("Backup incremental");
   checkErrFile();
   ## Move out any existing xttplan.txt.new
   my $xttpathnew = "$tmp/xttplan.txt.new";
   my @trnsfrFiles = ();

   if ( -e $xttpathnew )
   {
      my $timenow = time;

      system("\\mv $xttpathnew $xttpath"  . $timenow);
   }

   ## Generate the next round xttplan.txt
   &generate_batch_tsoutput(BCKPINCR);

   ## At this point, we must have a new xttplan.txt.new
   ## populated with required from_scn's  for next incremental backup.

   debug "Start backup incremental" ;

   # Clean up any rmanincr.cmd from TMPDIR area.
   my $rmanincrpath = "$tmp/rmanincr.cmd";
   my $timenow = time;
   if ( -e $rmanincrpath )
   {
      system("\\mv $rmanincrpath $rmanincrpath" . $timenow);
   }
   debug "Crossed mv " ;

   my $backupformat = $props{'backupformat'};
   debug "Crossed mv $backupformat" ;
   ## Remove trailing '/'s
   $backupformat = $1 if($backupformat=~/(.*)\/$/);

   ## Generate $tmp/rmanincr.cmd
   debug "Generate $tmp/rmanincr.cmd";

   open(RMANINCR, ">$tmp/rmanincr.cmd") || Die("Cant open rmanincr.cmd $!");

   ## Parse out xttplan.txt and build the rman command
   open(XTTPLAN, $xttpath) || die 'Cant find xttplan.txt, TMPDIR undefined';

   my $rman_str1 = "set nocfau;";
   my $rman_str;

   while (<XTTPLAN>)
   {
      if (/(\S+)::::(\S+)/)
      {
         my $tablespace = $1;
         my $scn        = $2;
         my $rman_str;

         print RMANINCR $rman_str1 . "\n";

         $rman_str = "host 'echo ts::$tablespace';";
         print RMANINCR $rman_str . "\n";

         $rman_str = "backup incremental from scn $scn ";
         print RMANINCR $rman_str . "\n";

         $rman_str = "  tag tts_incr_update tablespace '$tablespace' format";
         print RMANINCR $rman_str . "\n";

         $rman_str = " '$backupformat/%U';";
         print RMANINCR $rman_str . "\n";
      }
   }
   close(XTTPLAN);
   close(RMANINCR);

   ## Execute the rman command here

   my ($rmanTrace, $traceFile) = GetRMANTrace("incrbackup");
   my $output_str = "rman target \/ $rmanTrace cmdfile $rmanincrpath";
   print $output_str . "\n";

   my $output = `rman target \/ $rmanTrace cmdfile $rmanincrpath`;
   print $output . "\n";

   &gentablespace_backupmap( $output ) ;

   if ($metaTransfer)
   {
      @trnsfrFiles = ();
      push (@trnsfrFiles, "$tmp/tsbkupmap.txt");
      transferFiles (@trnsfrFiles);

      open FILE, "$tmp/incrbackups.txt";
      @trnsfrFiles = <FILE>;
      close FILE;

      $context->{"desttmp"} = $props{'stageondest'};
      transferFiles (@trnsfrFiles);
      $context -> {"desttmp"} = $props{'desttmpdir'};
   }

   Unlink ($traceFile);

   PrintMessage ("Done backing up incrementals");
   exit;
}

###
### Incremental Ends here
###
####################################
# Check if element exists in array.
####################################
sub checkInArray
{
   my $element = $_[0];

   if (@rolltbsArray)
   {
      if ($tbsHash{"$element"})
      {
         return 1;
      }
      else
      {
         return 0;
      }
   }
   else
   {
      return 1;
   }
}

###
### Rollforward Starts here - on destination
###
### New changes in v1.1
###
### xttrollforwarddest.sql is now a generated file.
###
### All file processing is handled by perl itself.
### xttrollforwarddest.sql will be called for each tablespace
### The destination database will be started up in nomount
### until all the tablespaces are rollforwarded.
###
sub rmconvertedincr
{
   # Check if any failure occured and stop exection
   checkErrFile();

   my $backupondest  = $props{'backupondest'};
   my $asmhome       = $props{'asm_home'};
   my $asmsid        = $props{'asm_sid'};
   my $rmcmd         = "";

   if (defined $props{'asm_home'})
   {
      ## Lets first delete the incremental backup if any
      ## this will happen through asmcmd
      my $oh_saved = $ENV{'ORACLE_HOME'};
      my $ohsid_saved = $ENV{'ORACLE_SID'};
      my $asmcmd = 0 ;
      my $asmcmd_str;

      $ENV{'ORACLE_HOME'} = $asmhome;
      $ENV{'ORACLE_SID'} = $asmsid;

      # Remove trailing spaces
      $backupondest =~ s/\s+$//;
      $asmsid =~ s/\s+$//;

      $asmcmd_str = "asmcmd rm $backupondest/$xtts_incr_backup";
      print $asmcmd_str . "  $asmhome .. $asmsid \n" ;

      $asmcmd = `asmcmd rm $backupondest/$xtts_incr_backup`;
      print "ASMCMD:  $asmcmd\n";

      $ENV{'ORACLE_HOME'} = $oh_saved;
      $ENV{'ORACLE_SID'} = $ohsid_saved;
      if ($asmcmd == 0)
      {
         Unlink ("$backupondest/$xtts_incr_backup", 1);
      }
   }
   else
   {
      Unlink ("$backupondest/$xtts_incr_backup", 1);
   }

}

###############################################################################
# Function : ChecktoProceed
# Purpose  : When running the roll forward in parallel, we will check if we can
#            fork any more jobs
###############################################################################
sub ChecktoProceed
{
   my $parallel = $_[0];
   # Check if any failure occured and stop exection
   checkErrFile();
   my $running = 0;

   if ($#forkArray <= 0)
   {
      return;
   }
   do
   {
      $running = 0;
      foreach my $index (0 .. $#forkArray)
      {
         my $x = $forkArray[$index];
         if ($x <= 0)
         {
            next;
         }
         my $kid = waitpid($x, WNOHANG);
         if ($kid >= 0)
         {
            $running = $running + 1;
         }
         else
         {
            $forkArray[$index] = 0;
         }
      }
   } while ($running >= $parallel);

   return;
}

sub UpdateForkArray
{
   my ($pid, $parallel) = @_;

   if ($#forkArray < $parallel)
   {
      push (@forkArray, $pid);
   }
   else
   {
      foreach my $index (0 .. $#forkArray)
      {
         my $x = $forkArray[$index];
         if ($x == 0)
         {
            $forkArray[$index] = $pid;
            last;
         }
      }
   }
}

###############################################################################
# Function : FixCnvScripts
# Purpose  : Fix the scripts that has details about incremental backup
###############################################################################
sub FixCnvScripts
{
   my $toFixSql  = $_[0];
   my $inpSql    = $_[1];
   my $fixedStr  = $_[2];
   my $platformid  = $props{'platformid'};
   my $fixedStrL = "";
   my $len = 0;

   open XTTS_INCR_BACKUP, "<$inpSql";
   open XTTS_INCR_BACKUP1, ">$toFixSql";
   my @arrayXttincr = <XTTS_INCR_BACKUP>;

   # Bug 20192155: Use xib instead of "xtts_incr_backup" to prevent
   # ORA error ORA-15126 with ASM
   $fixedStrL = substr($fixedStr, 0, 42);
   $xtts_incr_backup = "xib"."_".$fixedStrL;
   $len = length ($xtts_incr_backup);
   if ($len > 50)
   {
      Die ("Length of backupiece exceeds 50 chars $xtts_incr_backup");
   }

   foreach my $x (@arrayXttincr)
   {
      chomp($x);
      if ($x =~ m/(.*)xtts_incr_backup(.*)\,/)
      {
         print XTTS_INCR_BACKUP1 "$1$xtts_incr_backup$2,\n";
      }
      elsif ($x =~ m/(.*)xtts_incr_backup(.*)/)
      {
         print XTTS_INCR_BACKUP1 "$1$xtts_incr_backup$2\n";
      }
      elsif (!(($platformid == 0) && ($x =~ m/(.*)pltfrmfr(.*)/)))
      {
         print XTTS_INCR_BACKUP1 "$x\n";
      }
      else
      {
         print XTTS_INCR_BACKUP1 "$x\n";
      }
   }
   close XTTS_INCR_BACKUP1;
   close XTTS_INCR_BACKUP;
}

###############################################################################
# Function : sortArrayOrder
# Purpose  : Sort the Array based on piece
###############################################################################
sub sortArrayOrder 
{
  return sort {
               (($a =~ /::(.*):::.*/)[0] <=> ($b =~ /::(.*):::.*/)[0] ||
                ($a =~ /:::(.*?)=/)[0] <=> ($b =~ /:::(.*?)=/)[0]
               )
               } @_;
}

###############################################################################
# UTIL functions
# Following functions are useful for conversion, rollforward etc
###############################################################################
sub ConvertBackup
{
   my $backup   = $_[0];
   my $dfno     = $_[1];
   my $fixCnvSql;
   my $outputCnvrt;

   $fixCnvSql  = "$tmp/xxttconv_$backup"."_$dfno.sql";

   FixCnvScripts ($fixCnvSql, $cnvrSql, $backup."_".$dfno);
   Unlink ("$backupondest/$xtts_incr_backup", 1);

   my $outputCnvrt =  
      `sqlplus -L -s \"$connectstringcnvinst\" \@$fixCnvSql $stageondest/$backup $backupondest $platformid`;
   checkError ("$fixCnvSql execution failed", $outputCnvrt);
   Unlink ($fixCnvSql);
}

sub RollPiece
{
   my $sqlfile = $_[0];
   my $outputCnvrt;

   ## now call generated rollforward
   $outputCnvrt =  
      `sqlplus -L -s \"/ as sysdba\" \@$sqlfile`;
   checkError ("$sqlfile execution failed", $outputCnvrt);
}

sub ConvertRoll
{
   my ($fixedStr, $oldre, $rb, $rend, $bkupList, $rmList) = @_;
   my $rollFile;

   $rollFile = "$tmp/xxttroll_$fixedStr.sql";
   
   open (XTTROLL, ">$rollFile") or Die $!;
   print XTTROLL $rb;

   foreach my $y (@{$rmList})
   {
      print XTTROLL $y;
   }

   foreach my $backup (@{$bkupList})
   {
      my $re = $oldre;
      ConvertBackup ($backup, $fixedStr);
      $re =~ s/##xtts_incr_backup/$xtts_incr_backup/;
      print XTTROLL $re;
   }
   print XTTROLL $rend;
   close XTTROLL;

   RollPiece ($rollFile);

   rmconvertedincr();
}

###############################################################################
# End of UTIL functions
# Following functions are useful for conversion, rollforward etc
###############################################################################

###############################################################################
# Function : clearUpRollfwd
# Purpose  : Clear the scripts and converted incrementals after rollfwd
###############################################################################
sub clearUpRollfwd
{
   Unlink ($fixCnvSql);
   Unlink ($xttrollforwardp);
   Unlink ($fixRollSql);
   rmconvertedincr();
}

sub rollforward()
{
   PrintMessage ("Start rollforward");

   # Check if any failure occured and stop exection
   checkErrFile();

   my $connectstringdest = "/ as sysdba";
   my $ohcnv = $props{'cnvinst_home'};
   my $ohcnvsid = $props{'cnvinst_sid'};
   my $tsbkupmappath = "$tmp/tsbkupmap.txt";
   my $tsn;
   my $fixedSql;
   my $pid = 0;
   my $i = 0;
   my $parent = 0;
   my $count = 0;
   my $newrm;
   my $oldre;

my $rb = q(

   set serveroutput on;

   DECLARE
   outhandle varchar2(512) ;

   outtag varchar2(30) ;
   done boolean ;
   failover boolean ;
   devtype VARCHAR2(512);

   BEGIN

   DBMS_OUTPUT.put_line('Entering RollForward');

   -- Now the rolling forward.
   devtype := sys.dbms_backup_restore.deviceAllocate;

   sys.dbms_backup_restore.applySetDatafile(
   check_logical => FALSE, cleanup => FALSE) ;

   DBMS_OUTPUT.put_line('After applySetDataFile');

   );

my $rm = q(

   sys.dbms_backup_restore.applyDatafileTo(
     dfnumber => ##fno,
     toname => ##fname,
     fuzziness_hint => 0, max_corrupt => 0, islevel0 => 0,
     recid => 0, stamp => 0);

   );

my $rmend = q(
  DBMS_OUTPUT.put_line('Done: applyDataFileTo');
  );

my $re = q(
  DBMS_OUTPUT.put_line('Done: applyDataFileTo');

  -- Restore Set Piece
  sys.dbms_backup_restore.restoreSetPiece(
    handle => '##backupondest/##xtts_incr_backup',
    tag => null, fromdisk => true, recid => 0, stamp => 0) ;

  DBMS_OUTPUT.put_line('Done: RestoreSetPiece');

  -- Restore Backup Piece
  sys.dbms_backup_restore.restoreBackupPiece(
    done => done, params => null, outhandle => outhandle,
    outtag => outtag, failover => failover);

  DBMS_OUTPUT.put_line('Done: RestoreBackupPiece');

  );

my $rend = q(
  sys.dbms_backup_restore.restoreCancel(TRUE);
  sys.dbms_backup_restore.deviceDeallocate;

  END;
  /
  exit

  );

   $stageondest  = $props{'stageondest'};
   $backupondest = $props{'backupondest'};
   $platformid   = $props{'platformid'};

   $re =~ s/##backupondest/$backupondest/;
   $oldre = $re;

   if (!defined($ohcnv))
   {
      $connectstringcnvinst = "/ as sysdba";
   }
   else
   {
      debug "convert instance: $ohcnv \n";
      debug "convert instance: $ohcnvsid \n";

      $connectstringcnvinst =
        "/\@(DESCRIPTION=(ADDRESS=(PROTOCOL=BEQ)(PROGRAM=$ohcnv/bin/oracle)".
        "(ARGV0=oracle$ohcnvsid)(ARGS='(DESCRIPTION=(LOCAL=YES)".
        "(ADDRESS=(PROTOCOL=BEQ)))')".
        "(ENVS='ORACLE_HOME=$ohcnv,ORACLE_SID=$ohcnvsid'))".
        "(CONNECT_DATA=(SID=$ohcnvsid))) as sysdba";
   }

   my %tsbkupmap;
   my @tsArray = ();

   open my $in, $tsbkupmappath or Die ("$tsbkupmappath $!");
   @tsArray = <$in>;
   close $in;
   
   foreach my $x (sortArrayOrder @tsArray)
   {
      $_ = $x;
      next if /^#/;
      if (m/(\S+):::.*?=(\S+)/g)
      {
         push (@{$tsbkupmap{$1}}, $2);
      }
   }

   ##
   ## Putting database on target in nomount
   ## as it could cause the following error.
   ## ORA-00600: internal error code, arguments: [2130], [33], [32], [4]
   ## The reason for this is :
   ##
   ## The code is trying to access KCCDEDBF (datafile) record# 33 when there
   ## is only record# 32.  It looks when you try to apply the incremental
   ## backup on linux box, you are expecting the datafile# 33 to exists in the
   ## target database. However, that can't be always true.
   ##
   ## This is worked around by starting the target database iin nomount.
   ## The convert call/script should work in nomount state of database too.
   ##
   ## Ver 1.4: Startup nomount is no longer required
   if (defined($context->{"rolltbs"}))
   {
      checkDBState();
   }
   my $outputstart =  `sqlplus -L -s \"/ as sysdba\" \@xttstartupnomount.sql`;
   checkError ("Error in executing xttstartupnomount.sql", $outputstart);

   ## Generate xttrollforwarddest.sql that is the script
   ## that will rollforward all the converted datafiles.
   my $tsbkcount = scalar keys %tsbkupmap;

   if ($tsbkcount == 0)
   {
      Die ("No tablepsace entries found");
   }

   my @sortedkeys = sort keys %tsbkupmap;

   foreach $tsn (@sortedkeys)
   {
      my ($ts, $rdfno, $order) = split(/::/, $tsn);
      my $fixedStr;

      if ($context->{"rolltbs"})
      {
         my $checkArray = checkInArray($ts);
         if ($checkArray == 0)
         {
            next;
         }
      }

      debug "rdfno " . $rdfno . "\n";
      my @rdfnos = split /,/,  $rdfno;

      open (ROLLPLAN, "$tmp/xttnewdatafiles.txt") or Die $!;

      my $scrape = 0;

      # Check if any failure occured and stop exection
      checkErrFile();

      debug "BEFORE ROLLPLAN\n";

      my @rmList = ();

      while (<ROLLPLAN>)
      {
         if ($scrape == 1 && $_ !~ /::/)
         {
            chop;
            my $oldrm = $rm;

            my  $dfstr = $_;
            my ($dfno, $dfname) = split /,/, $dfstr;
            my $ind;

            ## include the dfno only if present in the tsbkupmap.txt list
            ## of dfnos.
            my $found = 0;

            for ($ind = 0; $ind <= $#rdfnos ; $ind++)
            {
               if ($dfno == $rdfnos[$ind])
               {
                  $found = 1;
                  last;
               }
            }

            if ($found == 1)
            {
               debug "datafile number : $dfno  \n";
               debug "datafile name   : $dfname\n";
   
               $newrm = $rm;
               $newrm =~ s/##fno/$dfno/;
               $newrm =~ s/##fname/'$dfname'/;
               push (@rmList, $newrm);
            }
         }

         if (/^::$ts$/)
         {
            $scrape = 1;
         }
         elsif (/^::/)
         {
            $scrape = 0;
         }
      }
      push (@rmList, $rmend);
      close(ROLLPLAN);
      debug "AFTER ROLLPLAN\n";

      $rollParallel = $props{'rollparallel'};
      
      $fixedStr = $rdfno;
      $fixedStr =~ tr/,/_/;

      if ($rollParallel)
      {
         ChecktoProceed($rollParallel);

         $pid = fork();

         if ($pid == 0)
         {
            ConvertRoll ($fixedStr, $oldre, $rb ,$rend, \@{$tsbkupmap{$tsn}},
                         \@rmList);
            exit (0);
         }
         else
         {
            UpdateForkArray ($pid, $rollParallel);
         } 
      }
      else
      {
         ConvertRoll ($fixedStr, $oldre, $rb ,$rend, \@{$tsbkupmap{$tsn}},
                      \@rmList);
      }
   }

   while((my $pid = wait()) > 0)
   {
      #sleep (1);
   }

   # Check if any failure occured and stop exection
   checkErrFile();

   my $outputstart =  `sqlplus -L -s \"/ as sysdba\" \@xttdbopen.sql`;
   checkError ("Error in executing xttdbopen.sql", $outputstart);

   PrintMessage ("End of rollforward phase");

   exit;
}

###
### Rollforward Ends here - on destination
###

###
### xttplan.txt with new fromscn -- STARTS
###
sub newplan()
{
   # Check if any failure occured and stop exection
   checkErrFile();

   ## Move the current xttplan.txt.new as xttplan.txt
   ## The xttplan.txt.new gets generated during backincr()
   my $xttplanpath = "$tmp/xttplan.txt";
   my $xttplanpathnew = "$tmp/xttplan.txt.new";

   if ( -e $xttplanpath )
   {
      my $timenow = time;

      system("\\mv $xttplanpath $xttplanpath" . $timenow);
      system("\\mv $xttplanpathnew $xttplanpath");
   }

   ## Checks that no tablespace went read only
   ## or datafiles offline
   &generate_batch_tsoutput(NEWPLAN);

   print "New $tmp/xttplan.txt with FROM SCN's generated\n";
   exit;
}

###
### xttplan.txt with new fromscn -- ENDS
###

###
### Convert Starts here - on destination
###
sub convert()
{
   PrintMessage ("Performing convert");
   # Check if any failure occured and stop exection
   checkErrFile();

   my ($rmanTrace, $traceFile) = GetRMANTrace("convert");
   my $output = `rman target \/ $rmanTrace cmdfile $rmanpath`;

   if ($output =~ /ERROR MESSAGE/)
   {
      Die("$output $!");
   }
   Unlink ($traceFile);


   my @lines = split /\n/, $output;

   my $xttnewdata = "$tmp/xttnewdatafiles.txt";

   if ( -e $xttnewdata )
   {
      my $timenow = time;
      system("\\mv $xttnewdata $xttnewdata" . $timenow);
   }

   open(XTTNEW, ">$xttnewdata") || Die("Cant open xttnewdatafiles.txt");

   foreach my $line (@lines)
   {
      my $tsname;
      my $filno;

      $_ = $line;

      if (/converted datafile=(.+)\/(\w+)[_](\d+)\.xtf/)
      {
         print XTTNEW "$3,";
         $line =~ s/.*converted datafile=//;
         print XTTNEW "$line\n";
      }
      elsif(/^ts(\S+)/)
      {
         print XTTNEW $1 . "\n";
         $tsname = $1;
      }

   }

   close(XTTNEW);

   PrintMessage ("Converted datafiles listed in: $xttnewdata");

   exit;
}

###############################################################################
# Function : genConvertDFNames
# Purpose  : When script is used to transport tablespaces between same endian
#            this function will be called. Here we create xttnewdatafiles.txt
###############################################################################
sub genConvertDFNames
{
   my @convertArray = ();

   # Check if any failure occured and stop exection
   checkErrFile();

   open(RMANCONVERT, "$rmanpath") ||
       die 'Cant find rmanconvert.cmd, TMPDIR undefined';
   @convertArray = <RMANCONVERT>;
   close RMANCONVERT;

   open(RMANDSTDF, ">$rmandstdf") ||
      Die "Cant find $rmandstdf";

   foreach my $x (@convertArray)
   {
      chomp($x);
      $x = trim($x);
      if ($x =~ /'(.*)\.tf'/)
      {
         $x = $1.".tf";
         if ($x =~ /.*(.+)\/(\w+)[_](\d+)\.tf/)
         {
            print RMANDSTDF "::$2\n";
            print RMANDSTDF "$3,$x\n";
         }
      }
   }

   close RMANDSTDF;

   exit;
}

###
### Convert Ends here - on destination
###

###
### Generate plugin/impdp command template as xttplugin.txt
### - Starts here, on destination
###
sub plugin()
{
   PrintMessage ("Generating plugin");
   # Check if any failure occured and stop exection
   checkErrFile();

   my $xttplugin = "$tmp/xttplugin.txt";
   my $tts       = "transport_tablespaces=";
   my $tdf       = "transport_datafiles=";
   my $comma     = 0;
   my $xttnewdata = "$tmp/xttnewdatafiles.txt";
   my $command_str;

   if ( -e $xttplugin )
   {
      my $timenow = time;
      system("\\mv $xttplugin $xttplugin" . $timenow);
   }

   open(XTTPLUG, ">$xttplugin") || Die("Unable to open file $xttplugin");

   $command_str = "impdp directory=<DATA_PUMP_DIR> logfile=<tts_imp.log> \\" . "\n" .
                  "network_link=<ttslink> transport_full_check=no \\" . "\n" ;

   print XTTPLUG $command_str;

   print XTTPLUG $tts;

   open(XTTPLAN, $xttpath) || Die("Cant find xttplan.txt\n $!");

   while (<XTTPLAN>)
   {
      if ($comma == 1 && /::::/)
      {
         print XTTPLUG ",";
         $comma = 0;
      }
      if (/(\S+)::::(\S+)/)
      {
         print XTTPLUG $1;
         $comma = 1;
      }
   }
   close(XTTPLAN);

   print XTTPLUG " \\\n";
   print XTTPLUG $tdf;
   $comma = 0;

   open(XTTNEWDATA, $xttnewdata) || Die("Cant find xttnewdatafiles.txt\n $!");

   while (<XTTNEWDATA>)
   {
      if ($comma == 1)
      {
         print XTTPLUG ",";
         $comma = 0;
      }
      if (! /^::\S+/)
      {
         chop;

         my ($dfno, $dfname) = split /,/, $_;

         print XTTPLUG  "'" . $dfname . "'";
         $comma = 1;
      }
   }

   print XTTPLUG "\n";

   close(XTTNEWDATA);
   close(XTTPLUG);

   PrintMessage ("Done generating plugin file $xttplugin");
   exit;
}

###
### Generate plugin/impdp command - Ends here, on destination
###

###############################################################################
# Function : usage
# Purpose  : Message about this program and how to use it
###############################################################################
sub usage
{
   print STDERR << "EOF";

   This program prepares, backsup and rollsforward tablespaces
   for cross-platform transportable tablespaces.

    usage: $0
                  {[--convert/-c] || [--generate|-e] || [--incremental|-i] ||
                   [[--prepare|-p] || [--getfile|-G]] ||
                   [--rollforward|-r [--rolltbs|-R <TBS1[,TBS2]>] || 
                   [--determinescn|-s] || 
                   [--orasid/O] || [--orahome|-o]]
                   [--help|-h]}
       
       Additional options
       ------------------
               [--debug|d] [--clearerrorfile|-C] [--xttdir|Dir <tmpdir>]
               [-F/--propfile] [-I/--propdir]

     -c  : conversion of datafiles
     -e  : generate impdp script: export over new link
     -i  : incremental backup
     -p  : prepare
     -G  : get datafiles from source database using get_file, should not
           be used together with -p
     -r  : roll forward datafiles
     -R  : roll forward specific tablespace(s)
     -s  : new from_scn values into xttplan.txt
     -h  : this (help) message (Default)
     -d  : provides more debug information, also rman is called with debug
           option so that tracing is better.
           If "--debug 2" is used then the temporary files generated are 
           preserved, otherwise they get deleted
     -L  : delete the ERROR FILE and proceed with the execution
     -D  : Instead of defining environement variable, user can pass tmpdir 
           through xttdir
     -O  : Use this option to pass ORACLE_SID to override the environment 
           variable
     -o  : Use this option to pass ORACLE_HOME to override the environment 
           variable
     -I  : Use this option to mention the location from where the script 
           will pick the properties file etc
     -F  : Use this option to mention the location from where the script 
           will pick the properties file.
     -v  : Will print version of the script and exit

    example: $0 -p
             $0 -i
             $0 -r
             $0 -s

EOF
   exit;
}

###############################################################################
# Function : GetTimeStamp
# Purpose  : Get the time stamp
# Inputs   : None
# Outputs  : Timestamp
# NOTES    : None
###############################################################################

sub GetTimeStamp
{
    my $timeStamp = $$."_".int(rand(1000));
    return ($timeStamp);
}

## Call main function
Main();
