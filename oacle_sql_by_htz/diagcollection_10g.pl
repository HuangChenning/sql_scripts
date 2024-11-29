#!/usr/bin/perl
# 
# diagcollection.pl
# 
# Copyright (c) 2002, 2012, Oracle and/or its affiliates. All rights reserved. 
#
#    NAME
#      diagcollection.pl - collects and cleans up diagnostic information 
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#
# Usage:
# diagcollection --collect :: collects diagnostic information
#                --clean   :: cleans up diagnostic information archive
#                --coreanalyze   :: extracts diag info from core files 
#
#    MODIFIED   (MM/DD/YY)
#       shullur  05/24/12 - For reverting back nodeview version change.
#       shullur  04/25/12 - For fixing the Nodeview Version
#       wegu     04/22/11 - Backport wegu_bug-11073738 from
#                           st_recommended_11.2.0.2.0
#       jcreight 02/24/11 - Backport jcreight_bug-11683946 from main
#       jchandar 02/13/11 - Backport jchandar_diagformat from main
#       jcreight 02/01/11 - Backport jcreight_bug-11679668 from main
#       jchandar 12/14/10 - XbranchMerge jchandar_bug_10212124 from main
#       jchandar 11/29/10 - bug 10212124: fix CHM/OS meta data issue
#       anutripa 09/01/10 - XbranchMerge anutripa_bug-10048487 from
#                           st_has_11.2.0
#       anutripa 08/23/10 - Correct -getkey to be backward compatible
#       anutripa 06/22/10 - Remove -m option from dumpnodeview
#       jcreight 05/05/10 - Fix bug 9684440: Collect cores when no wrapper
#       jcreight 04/26/10 - Fix bug 9655477: collect cores for CHM
#       jcreight 04/02/10 - Fix bug 9548002: allow --crshome when deconfigured
#       jcreight 03/19/10 - Fix bug 9491777: find CRS home in OLR registry key
#       jcreight 01/19/10 - Fix bug 9273769: check for IPD in CRS home first
#       jcreight 11/18/09 - Update for 9121939: collect OLR information
#       jcreight 11/18/09 - Fix bug 8544401: update ADR collection for 11.2
#       jcreight 10/13/09 - Fix bug 9014438: incident time year format
#       jcreight 09/15/09 - XbranchMerge jcreight_bug-8873780_2 from
#                           st_has_11.2.0.1.0
#       jcreight 09/08/09 - Fix bug 8873780 - fix Solaris dbx usage
#       jcreight 04/01/09 - Fix bug 8400123
#       jcreight 03/20/09 - Fix bug 7670542,7615584,8360860
#       jcreight 02/25/09 - Fix bug 7692311 - collect agent corefiles
#       radyadav 11/12/08 - Fix for bug 7494746
#       rvadraha 11/12/08 -Bug7562975, fix Zip and System command args on win32
#       jcreight 11/11/08 - Collect IPD-OS data (ER 7317121)
#       jcreight 10/14/08 - Fix bug 7368124 by changing --crshome to optional
#                           arg
#       jcreight 08/18/08 - XbranchMerge jcreight_bug-7302848 from st_has_10.2
#       jcreight 08/07/08 - use relative paths to archive CRS logs
#       jcreight 08/05/08 - Fix 7302848: don't use wildcarding on tar cmdline
#       jcreight 05/09/08 - Update usage
#       jcreight 03/28/08 - Fix 6901014: update for 11.2 directory structure
#       jcreight 06/19/07 - review comments + collect patch logs
#       jcreight 06/18/07 - Fix 6138698
#       rajayar  04/02/07 - adr changes
#       rajayar  02/15/07 - make adr changes
#       gdbhat   01/11/07 - added code for AIX usage
#       rajayar  02/24/06 - core collection 
#       rajayar  08/05/05 - filename fix
#       rajayar  06/01/05 - update copyright information
#       rajayar  05/23/05 - change perl location, improve core analyze. 
#       rajayar  04/19/05 - updates to the log location 
#       rajayar  11/22/04 - rajayar_diagcoll_script
#       rajayar  11/09/04 - Creation 

print "Production Copyright 2004, 2010, Oracle.  All rights reserved\n"; 
print "Cluster Ready Services (CRS) diagnostic collection tool\n";


use Sys::Hostname;
use Getopt::Long;
use POSIX;
use File::Glob qw(:globally :case);
use File::Spec::Functions;
use File::Find ();
use DirHandle;
use Time::Local;
#use Local::Time;

use constant TRUE                      =>  "1";
use constant FALSE                     =>  "0";

sub help();
sub collect_unix();
sub collect_win32();
sub clean_win32();
sub clean_unix();
sub coreanalyze();
sub collectDiagForAdr();

$HOSTNAME = hostname;

#
# TODO: create a log for diagcollection and if any failures are encountered
#  package the log file along with the collected data, and emit an
#  error message saying where to find the details.
#

# archive files in chunks to avoid command line length limits
# this is the limit for the command line filename list length
$FLISTLEN = 1024;

if ($HOSTNAME eq "")
{
  print "Set HOSTNAME environment variable and then re-invoke this script.\n";
  exit;
}

# If IP address, do not strip.
if ($HOSTNAME !~ /(\d{1,3}\.){3}\d{1,3}/)
{
  $HOSTNAME =~ s/^([^.]+)\..*/$1/; # strip domain name off of host

  #lowercase the hostname
  $HOSTNAME=lc($HOSTNAME);
}
$currtime=currentTime();

$PLATFORM = $^O;
$HPUX = "hpux";
$WIN32 = "MSWin32";
$LINUX = "linux";
$AIX = "aix";
$SOLARIS = "solaris";

if ($PLATFORM eq $WIN32)
{
  $ZIP = "zip -qr";
  $DEL = "del";
  $COPY = "copy";
  #zips
  $CRSDATA_ZIP = "crsdata_$currtime.zip";
  $ORADATA_ZIP = "oradata_$currtime.zip";
  $OCRDATA_ZIP = "ocrdata_$currtime.zip";
  $CHMOSDATA_ZIP = "chmosdata_$currtime.zip";
  require Win32::TieRegistry;
  import Win32::TieRegistry (Delimiter => '/');
}
else
{
  our $cwd;
  chop($cwd = `pwd`) || die "Can't find current directory: $!\n";
  if (!(-w $cwd))
  { 
     print("Error: current directory $cwd is not writable\n");
     exit;
  }

  if ($PLATFORM eq $HPUX) {
    $GZIP = "/usr/contrib/bin/gzip";
  }
  else {
    $GZIP = "/bin/gzip";
  }

  $COPY = "cp";
  $TAR = "/bin/tar ";
  $CF = "-cf";
  $RF = "-rf";
  $RM = "/bin/rm -rf";
                                                                                
  # TARS
  $CRSDATA_TAR = crsData_.$HOSTNAME.'_'.$currtime.'.'.tar;
  $ORADATA_TAR = oraData_.$HOSTNAME.'_'.$currtime.'.'.tar;
  $OCRDATA_TAR = ocrData_.$HOSTNAME.'_'.$currtime.'.'.tar;
  $COREDATA_TAR = coreData_.$HOSTNAME.'_'.$currtime.'.'.tar;
  $CHMOSDATA_TAR = chmosData_.$HOSTNAME.'_'.$currtime.'.'.tar;
  $SYSLOG_TAR = osData_.$HOSTNAME.'_'.$currtime.'.'.tar;

  #GZIPS
  $CRSDATA_GZIP = $CRSDATA_TAR.'.'.gz;
  $ORADATA_GZIP = $ORADATA_TAR.'.'.gz;
  $OCRDATA_GZIP = $OCRDATA_TAR.'.'.gz;
  $COREDATA_GZIP = $COREDATA_TAR.'.'.gz;
  $CHMOSDATA_GZIP = $CHMOSDATA_TAR.'.'.gz;
  $SYSLOG_GZIP = $SYSLOG_TAR.'.'.gz;
 
  $CRSDATA_PATH = catfile($cwd, $CRSDATA_TAR);
  $SYSLOG_PATH = catfile($cwd, $SYSLOG_TAR);
}

# CHMOS intermediate files
$CHMOSMETADATA_XML = "chmos_meta_$currtime.xml";
$CHMOSDATA_TXT = "chmos_data_all_$currtime.txt";


GetOptions( "clean" => \$clean,
            "collect" => \$collect,
            "help" => \$help,
            "h" => \$help,
            "crs" =>  \$crs,
            "oh" => \$oh,
            "all" => \$all,
            "core" => \$core,
            "coreanalyze" => \$coreanalyze,
            "adr:s" => \$adr,
            "crshome:s" => \$crshome,
            "afterdate:s" => \$afterdate,
            "aftertime:s" => \$aftertime,
            "beforetime:s" => \$beforetime,
            "level:s" => \$level,
            "ipd" => \$chmos,
            "chmos" => \$chmos,
            "ipdhome:s" => \$chmoshome,
            "chmoshome:s" => \$chmoshome,
            "incidenttime:s" => \$incidenttime,
            "incidentduration:s" => \$incidentduration);


#Show help if none of the args are passed 
if ($help || (! $clean && ! $collect && ! $coreanalyze))
{
  help(); 
  exit;
}

### check if run as super user
if ($PLATFORM ne $WIN32) 
{
  my $superUser = "root";
  my $usrname = getpwuid($<);
  if ($usrname ne $superUser) 
  {
    printf("Warning: Script executed while not logged in as as $superUser\n");
    printf("         Some diagnostic data may not be collected\n");
  }
}

#clean up archives
if ($clean)
{
  if ($PLATFORM eq $WIN32) {
   clean_win32();
  }
  else {
   clean_unix();
  }
}



#Collect all by default
if ($collect) 
{
  if (! $crs && !$oh && !$adr && !$chmos) {
    $all=true;
  }

  # look up CRS home if it's needed
  if ($all || $crs || $adr ) {
    if (! $crshome) {
      getCRSHome(TRUE);
    }
  }
  else 
  {
    if ($chmos) {
      if (! $crshome) {
        getCRSHome(FALSE); # get optional CRS home
      }
    }
  }

  if ($oh)
  {
    $ORACLE_HOME=$ENV{'ORACLE_HOME'};

    if($ORACLE_HOME eq "")
    {
      print "Set ORACLE_HOME environment variable and then re-invoke this script.\n";
      exit;
    }
     print "Warning: --oh argument is obsolete, and will be ignored\n";
  }

  if ($PLATFORM eq $WIN32) {
    collect_win32();
  }
  else {
    collect_unix();
  }
} 



sub clean_win32() {
  print "Cleaning up zip files \n";
  system "$DEL crsdata*.zip oradata*.zip ocrdata*.zip chmosdata*.zip ${HOSTNAME}_OCRDUMP  ${HOSTNAME}_OCRCHECK ${HOSTNAME}_OCRBACKUP";
  print "Done\n";
  exit;
}

sub clean_unix() {
  print "Cleaning up tar and gzip files\n";
  system("${RM}  crsData*.tar oraData*.tar ocrData*.tar coreData*.tar chmosData*.tar osData*.tar");
  system("${RM}  crsData*.gz oraData*.gz ocrData*.gz coreData*.gz chmosData*.gz osData*.gz");
  print "Done\n";
  exit;
}

# interrupt handler
sub catch_ctrlc() {
  print "Interrupted, cleaning up\n";
  if ($PLATFORM eq $WIN32) {
    clean_win32();
    system("${DEL}  ${CHMOSMETADATA_XML} ${CHMOSDATA_TXT}");
  }
  else {
    clean_unix();
    system("${RM} ${CHMOSMETADATA_XML} ${CHMOSDATA_TXT}");
  }
  die("exiting due to interrupt");
}

#collect os system logs
#linux system logs are /var/log/messages*
#solaris system logs are /var/adm/messages*
#hpux system logs are /var/adm/syslog/*syslog.log
#aix system logs are /var/adm/ras/*log*
#  System log locations should be defined as absolute paths, but
#   will be converted to relative paths for archiving
sub collectsyslog() {
  my $system_logs = "";
  if ($PLATFORM eq $LINUX)
  {
    $system_logs = "/var/log/messages*";
  }
  elsif ($PLATFORM eq $SOLARIS)
  {
    $system_logs = "/var/adm/messages*";
  }
  elsif ($PLATFORM eq $HPUX)
  {
    $system_logs = "/var/adm/syslog/*syslog.log";
  }
  elsif ($PLATFORM eq $AIX)
  {
    $system_logs = "/var/adm/ras/*log*";
  }
  else
  {
    print "No support for OS log collection on this platform: $PLATFORM\n";
    return;
  }
  print "Collecting OS logs\n";
  # change to / to remove leading slashes 
  chdir("/") || die "unable to change directory to /: $!\n";

  # remove leading slashes to convert absolute pathnames to relative
  #  paths to avoid warning messages from TAR.
  grep(s#^/##, $system_logs);

  system("${TAR} ${afterdatevar} ${CF} ${SYSLOG_PATH} $system_logs");

  # change back to initial current directory
  chdir($cwd) || die "Unable to change directory back to $cwd: $!\n";

  system("${GZIP} ${SYSLOG_TAR}");
}

sub collect_win32() {
  $SIG{INT} = \&catch_ctrlc;
  #Collecting log files
  if ($crs || $all)
  {
     if ($crshome)
     {
     print "The following CRS diagnostic archives will be created in the local directory.\n";
     print "${CRSDATA_ZIP} -> logs and traces from CRS home \n";
     print "${OCRDATA_ZIP} -> ocrdump, ocrcheck etc \n";
     print "Collecting crs data\n";

     system("${ZIP} ${CRSDATA_ZIP} ${crshome}/log/${HOSTNAME}/alert${HOSTNAME}.log ${crshome}/log/${HOSTNAME}/cssd/* ${crshome}/log/${HOSTNAME}/crsd/* ${crshome}/log/${HOSTNAME}/evmd/* ${crshome}/log/${HOSTNAME}/client/* ${crshome}/log/${HOSTNAME}/racg/* ${crshome}/log/${HOSTNAME}/admin/* ${crshome}/log/${HOSTNAME}/agent/* ${crshome}/log/${HOSTNAME}/ctssd/* ${crshome}/log/${HOSTNAME}/gipcd/* ${crshome}/log/${HOSTNAME}/gpnpd/* ${crshome}/log/${HOSTNAME}/init/* ${crshome}/log/${HOSTNAME}/mdnsd/* ${crshome}/log/${HOSTNAME}/ohasd/*");

     print "Collecting OCR data \n";
     system("${crshome}/bin/ocrdump ${HOSTNAME}_OCRDUMP");
     system("${crshome}/bin/ocrcheck >  ${HOSTNAME}_OCRCHECK");
     system("${crshome}/bin/ocrconfig -showbackup >  ${HOSTNAME}_OCRBACKUP");
     system("${ZIP} ${OCRDATA_ZIP}  ${HOSTNAME}_OCRDUMP  ${HOSTNAME}_OCRCHECK ${HOSTNAME}_OCRBACKUP");
     }
     else {
      print "Mandatory argument 'crshome' is missing. \n";
      exit;
     }
  }

  if ($adr)
  {
    collectDiagForAdr();
  }

  if ($chmos)
  {
    collectDiagForCHMOS();
  }

  print "Done \n";

  exit;
}

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

# match non-core files for find command
sub noncore {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f $_ &&
    ! /^core.*\z/s &&
    push @filelist, $File::Find::name;
}


# match all files for find command
sub allfiles {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f $_ && 
    push @filelist, $File::Find::name;
}

#collect diag 
sub collect_unix() {
  
   $SIG{INT} = \&catch_ctrlc;

   if ($afterdate)
   {
     $afterdatevar="--after-date \"${afterdate}\"";
   }
   else
   {
     $afterdatevar = "";
   }
 
  #Collecting log files 
  if ($crs || $all)
  {
     my @log_list;
     my $patchlogs;

     if ($crshome)
     {
       print "The following CRS diagnostic archives will be created in the local directory.\n";
       print "${CRSDATA_GZIP} -> logs,traces and cores from CRS home. Note: core files will be packaged only with the --core option. \n";
       print "${OCRDATA_GZIP} -> ocrdump, ocrcheck etc \n";
       print "${COREDATA_GZIP} -> contents of CRS core files in text format\n\n";
       print "${SYSLOG_GZIP} -> logs from Operating System\n";

       print "Collecting crs data\n";

       # any patch logs under <crs home>/install/*.log?
       opendir(LOG, catfile(${crshome}, "install"));
       @log_list = sort(grep(/.log$/, readdir(LOG)));
       closedir(LOG);
       if (scalar(@log_list) >= 1)
       {
         $patchlogs="${crshome}/install/\*.log";
       }
       # make install log file names relative to CRS home
       grep($_ = catfile("install", $_), @log_list);

       # change to CRS home to shorten archive path names for tar
       chdir($crshome) || die "unable to change directory to ${crshome}: $!\n";

       our @filelist;

       @filelist = @log_list;

       if ($core)
       {
         # Traverse desired directories
         File::Find::find({wanted => \&allfiles}, "log/${HOSTNAME}");
         File::Find::find({wanted => \&allfiles}, "cfgtoollogs");
         File::Find::find({wanted => \&allfiles}, "oc4j/j2ee/home/log");
       }
       else 
       {
         # Traverse desired directories
         File::Find::find({wanted => \&noncore}, "log/${HOSTNAME}");
         File::Find::find({wanted => \&noncore}, "cfgtoollogs");
         File::Find::find({wanted => \&noncore}, "oc4j/j2ee/home/log");
       }

       $first = 1;

       while ($#filelist > 0) {
	   @cmdlist = ();
           $cmdpos = 0;	 	# file # in cmdlist
           $cmdlistlen = 0;

           # put $FLISTLEN chars of filenames at a time into cmdlist
	   while ($cmdlistlen < $FLISTLEN) {
	      $cmdlist[$cmdpos++] = $filelist[0];
	      shift(@filelist);
              $cmdlistlen = length(join(' ', @cmdlist));
              last if(!defined($filelist[0])); 
	   }

           if ($first == 1)
           {
                @cmd = (${TAR}, ${afterdatevar}, ${CF}, ${CRSDATA_PATH}, @cmdlist);
                $first = 0;
           }
           else
           {
                @cmd = (${TAR}, ${afterdatevar}, ${RF}, ${CRSDATA_PATH}, @cmdlist );
           }
           system("@cmd");
       }
       # archive remaining files
       if ($#filelist > 0) {
         @cmd = (${TAR}, ${afterdatevar}, ${RF}, ${CRSDATA_PATH}, @filelist );
         system("@cmd");
       }

       system("${GZIP} ${CRSDATA_PATH}");

       # change back to initial current directory
       chdir($cwd) || die "Unable to change directory back to $cwd: $!\n";

       print "Collecting OCR data \n";
       system("${crshome}/bin/ocrdump ${HOSTNAME}_OCRDUMP");
       system("${crshome}/bin/ocrcheck >  ${HOSTNAME}_OCRCHECK");
       system("${crshome}/bin/ocrconfig -showbackup >  ${HOSTNAME}_OCRBACKUP");
       system("${TAR}  ${afterdatevar} ${CF} ${OCRDATA_TAR}  ${HOSTNAME}_OCRDUMP ${HOSTNAME}_OCRCHECK ${HOSTNAME}_OCRBACKUP; ${GZIP} ${OCRDATA_TAR}");

       print "Collecting information from core files\n";
       coreanalyze();
       system("${RM}  ${HOSTNAME}_OCRDUMP {HOSTNAME}_OCRCHECK ${HOSTNAME}_OCRBACKUP");
      }
      else {
        print "Mandatory argument 'crshome' is missing. \n";
        exit;
     }
  }


   if ($adr)
  {
    collectDiagForAdr();
  }
  
  if ($chmos)
  {
    collectDiagForCHMOS();
  }

  collectsyslog();

  exit;
}

#analyze corefiles in CRS Home
if ($coreanalyze) { 
  if ($PLATFORM eq $WIN32)
  {
   help();
   exit;
  }

  if ($crshome)
  {
   coreanalyze();
  }
  else 
  {
   print "Mandatory argument 'crshome' is missing.\n";
   exit;
  }

}

# match only core files for find command
sub coreonly {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f $_ &&
    /^core.*\z/s &&
    push @corelist, $File::Find::name;
}

sub coreanalyze()
{
  # map a core-file directory pattern to the daemon binary name
  %core_dir_map = (
    'crsd', 'crsd',
    'evmd', 'evmd',
    'cssd', 'ocssd',
    'ctssd', 'octssd',
    'diskmon', 'diskmon',
    'gipcd',  'gipcd',
    'gnsd',  'gnsd',
    'gpnpd', 'gpnpd',
    'mdnsd', 'mdnsd',
    'ohasd', 'ohasd',
    'agent/ohasd/oraagent_*', 'oraagent',
    'agent/ohasd/orarootagent_*', 'orarootagent',
    'agent/ohasd/oracssdagent_root', 'cssdagent',
    'agent/ohasd/oracssdmonitor_root', 'cssdmonitor',
    'agent/crsd/oraagent_*', 'oraagent',
    'agent/crsd/orarootagent_*', 'orarootagent',
    'crflogd', 'ologgerd',
    'crfmond', 'osysmond',
  );

   # find each corefile, try to determine which binary it's from
   our @corelist;
   my @outfiles = ();

   File::Find::find({wanted => \&coreonly}, "${crshome}/log/${HOSTNAME}");

   foreach $corefile (@corelist) {
     $execname = "";
     $coreexists = true;
     foreach $coredir (sort keys(%core_dir_map)) {
       # check if core file name matches coredir pattern
       if ($corefile =~ /$coredir/) {
         $execname = $crshome."/"."bin/".$core_dir_map{$coredir};
         if (-e "$execname".".bin") {
            $execname = "$execname".".bin";
         }

         # calculate output filename for debugger command
         ($ignvolume, $igndir, $corebase) = File::Spec->splitpath($corefile);
         $outfile = $corebase.".".$core_dir_map{$coredir}."."."txt";
       }
     }
     if ($execname eq "")
     {
        print("unknown binary for corefile $corefile\n");
     }
     else
     {

        $info_cmd="gdb_info_cmd";
        $RMF="/bin/rm -f";

        # select a Sun dbx to use
        if($PLATFORM eq $SOLARIS)
        {
          # use Sun Studio 12 if available, otherwise 11, or earlier
          if (-e "/opt/SunProd/studio12/SUNWspro/bin/dbx")
          {
           $DBX = "/opt/SunProd/studio12/SUNWspro/bin/dbx";
          }
          elsif (-e "/opt/SunProd/studio11/SUNWspro/bin/dbx")
          {
           $DBX = "/opt/SunProd/studio11/SUNWspro/bin/dbx";
          }
          else
          {
	    # Following changes are done for bug 7494746.
            $OS_VERSION =`/bin/uname -r`;
            $OS_MINOR_RELEASE_VERSION = substr $OS_VERSION,2;
            chop($OS_MINOR_RELEASE_VERSION);
            $DBX = "/opt/SunProd/SUNWspro".($OS_MINOR_RELEASE_VERSION)."/bin/dbx";
            # for bug 11683946
            if ((!-e "$DBX") && (-e "/bin/dbx"))
            {	
              $DBX = "/bin/dbx";
            }
          }
        }

        if (-e "/usr/bin/gdb")
        {
          # Get the backtrace of all threads
          open OUTFILE, ">> $info_cmd";
          print OUTFILE "set pagination off\n";
          #print OUTFILE "set logging on\n";
          #print OUTFILE "set logging overwrite on\n";
          print OUTFILE "where\n";
          print OUTFILE "display\n";
          print OUTFILE "thread apply all bt\n";
          print OUTFILE "quit\n";
          close OUTFILE;

          $DEBUGGER="/usr/bin/gdb"; 
          $DEBUGCMD="${DEBUGGER} --nx --batch --comm=${info_cmd} --e=${execname} --core=${corefile} > ${outfile}";
        }

        elsif (($PLATFORM eq $SOLARIS) && ((-e "/opt/SUNWspro/bin/dbx") || (-e "$DBX")))
        {
          open OUTFILE, ">> $info_cmd";
          print OUTFILE "where\n";
          print OUTFILE "thread -info\n";
          print OUTFILE "threads\n";
          print OUTFILE "dump\n";
          print OUTFILE "quit\n";
          close OUTFILE;
          
          if (-e "/opt/SUNWspro/bin/dbx")
          {
            $DEBUGGER="/opt/SUNWspro/bin/dbx";
          }
          else
          {
            $DEBUGGER="$DBX";
          }
 
          $DEBUGCMD="${DEBUGGER} -c \"source ${info_cmd}\" ${execname} ${corefile} > ${outfile}";
        }
 
        elsif (($PLATFORM eq $AIX) && (-e "/bin/dbx"))
        {
          open OUTFILE, ">> $info_cmd";
          print OUTFILE "where\n";
          print OUTFILE "enable all\n";
          print OUTFILE "corefile\n";
          print OUTFILE "thread info -\n";
          print OUTFILE "dump\n";
          print OUTFILE "list\n";
          print OUTFILE "quit\n";
          close OUTFILE;
 
          $DEBUGGER="/bin/dbx";
          $DEBUGCMD="${DEBUGGER} -c ${info_cmd} ${execname} ${corefile} > ${outfile} 2>&1";
        }

        else
        {
          print "Debugger could not be located on this system\n";
          return;
        }
     
        system("${DEBUGCMD}");
        system("${RMF} ${info_cmd}");
        system("${RMF} core");
        # save on list of core output text files
        push @outfiles, $outfile;
     }
  }

  if ($coreexists)
  {
    system("${TAR} ${CF} ${COREDATA_TAR} @outfiles; ${GZIP} ${COREDATA_TAR}");
    system("${RMF} core*.txt @outfiles");
  }

  else 
  {
    print "No corefiles found \n";
  }
}

# This collects information as required by ADR.
# If aftertime or before time are passed, this collects files
# after matching the clsd timestamp in the logs.
# 2 latest files from CRSD logs, 2 from CSSD, 1 from the rest and 
# the alert log and copies them to the destination directory
sub collectDiagForAdr() {

    if (! $crshome)
    {
     print "Mandatory argument 'crshome' is missing. \n";
     exit;
    }

    
    # copy alert file
    my $alertfile = "${crshome}/log/${HOSTNAME}/alert${HOSTNAME}.log";
    system("${COPY} $alertfile ${adr}");

    if ($beforetime ne "" || $aftertime ne "")
    {
      $clsdbeforetime= convertTime($beforetime);
      $clsdaftertime= convertTime($aftertime);

      # build up file list for searching
      our @filelist;

      @filelist = ();

      # Traverse desired directories
      File::Find::find({wanted => \&noncore}, "${crshome}/log/${HOSTNAME}");

       # control loop with the LOOP label
      LOOP: foreach $infile (@filelist)
      { 
        if (-f  "${infile}")
        {
          open (INF, "${infile}") or
            next;
        }

        while (<INF>)  # While still input lines in the file...
        { 

            #build pattern based on clsd timestamp (yyyy-mm-dd hh:min:sec.msec)
            $pattern = '(\d{4})-(\d{2})-(\d{2}).(\d{2}):(\d{2}):(\d{2}).(\d{3})';


            if ($_ =~  /$pattern/ ) 
            {
              my $year  = $1;
              my $month = $2;
              my $day   = $3;
              my $hour  = $4;
              my $min   = $5;
              my $sec   = $6;

              my $time = "$year$month$day$hour";

              #if time is greater than aftertime and less than before time, copy the file
              if (($time ge $clsdaftertime) && ($time le $clsdbeforetime))
              {
                print "Copying ${infile} to ${adr}\n";
                system("${COPY} ${infile} ${adr}");             
                next  LOOP;  
              }
            }
         }
         close (INF);
      }  
    }
    else
    {
      # copy 2 latest files from CRSD  
      my @files = getFilesInDir("${crshome}/log/${HOSTNAME}/crsd");

      foreach $file (@files)
      { 
       if ($file =~ m/log/ || $file =~ m/l01/)
       {
        print "Copying ${crshome}/log/${HOSTNAME}/crsd/${file} to ${adr} \n";
        system("${COPY} ${crshome}/log/${HOSTNAME}/crsd/${file} ${adr}");
       }
      }
    

      # copy 2 latest files from CSSD : the .log file and .l01 file 
      my @files = getFilesInDir("${crshome}/log/${HOSTNAME}/cssd");

      foreach $file (@files)
      { 
       if ($file =~ m/log/ || $file =~ m/l01/)
       {
        print "Copying ${crshome}/log/${HOSTNAME}/cssd/${file} to ${adr} \n";
        system("${COPY} ${crshome}/log/${HOSTNAME}/cssd/${file} ${adr}");
       }
      }

      # copy the latest file from EVMD, OHASD, etc
      my @logDirs = ("evmd", "ctssd", "diskmon", "gipcd", "gnsd", "gpnpd", "mdnsd", "ohasd", "racg", "client");

      foreach $dir (@logDirs)
      {
        my @files = getFilesInDir("${crshome}/log/${HOSTNAME}/$dir");

        foreach $file (@files)
        { 
         if ($file =~ m/log/ ) 
         {
           print "Copying ${crshome}/log/${HOSTNAME}/${dir}/${file} to ${adr} \n";
           system("${COPY} ${crshome}/log/${HOSTNAME}/${dir}/${file} ${adr}");
         }
        }
      }
    }

    print "Done. \n";
    exit;
}

# collect information as required by CHMOS
sub collectDiagForCHMOS() {

  my $rc = 0;
  my $isotn  = "false";
  # set default CHMOS home if not specfied
  if (! $chmoshome)
  {
    if ($crshome)
    {
      $chmoshome = $crshome;
    }
    else
    {
      if ($PLATFORM eq $WIN32)
      {
       $chmoshome = catfile("C:", "Progra~1", "oracrf");
      }
      else
      {
        $chmoshome = "/usr/lib/oracrf";
      }
      $isotn  = "true";
    }
  }
  else
  {
    if (($PLATFORM eq $WIN32 && $chmoshome eq catfile("C:", "Progra~1", "oracrf")) ||
         $chmoshome eq "/usr/lib/oracrf")
    {
      $isotn = "true";
    }
  }
 
  my $oclumonbin = catfile ($chmoshome, "bin", "oclumon");
  $oclumonbin = "\"" . $oclumonbin . "\"";
  
  my $master="";

  $master = getCHMOSMaster($oclumonbin, $isotn);

  # check if current node is master.
  
  if (lc($master) eq $HOSTNAME)
  {
    print "Collecting Cluster Health Monitor (OS) data\n";
 
    # set incident time argument in oclumon format
    #  <time>       = Absolute time to be specified within quotes in
    #                 "YYYY-MM-DD HH24:MI:SS" format, like,"2007-11-12 23:05:00"
    my $itime="";	# incident time
    my $endtime = ""; 	# end time of collection
    my $timeargs="";
    my $itimesecs=time;
    if ($incidenttime)
    {
      #build pattern based on incident time arg (mm/dd/yyyyHH24:MM:SS)
      $pattern = '(\d{2})/(\d{2})/(\d{4})(\d{2}):(\d{2}):(\d{2})';

      if ($incidenttime =~  /$pattern/ ) 
      {
	my $month = $1;
	my $day   = $2;
	my $year  = $3;
	my $hour  = $4;
	my $min   = $5;
	my $sec   = $6;

	if ($year < 1970)
	{	
	  print("Bad incident year $year; must be at least 1970\n");
	  return;
	}

        $itime = formatTime($year, $month, $day, $hour, $min, $sec);
        $itimesecs = timelocal($sec,$min,$hour,$day,$month-1,$year);
      }
      else
      {
	 print("Bad time format $incidenttime, use mm/dd/yyyyHH24:MM:SS\n");
	 return;
      }

      my $isecs=0;	# duration in seconds
      my $endtimesecs = time;	# end time in seconds
      #
      # set endtime based on incident duration if specified
      #
      if ($incidentduration)
      {
	  # parse HH:MM into seconds 
	  $pattern = '(\d{2}):(\d{2})';
	  if ($incidentduration =~ /$pattern/ )
	  {
	     my $ihour = $1;
	     my $imin = $2;

	     $isecs = ($imin * 60) + ($ihour * 60 * 60);
	  }
	  else
	  {		
	     print("Bad duration format $incidentduration, use HH24:MM\n");
	     return;
	  }
	  # add duration to start time
	  $endtimesecs = $itimesecs + $isecs;
      }
      ($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst) = localtime($endtimesecs);
      $year = $year + 1900;
      $endtime = formatTime($year, $month, $day, $hour, $min, $sec);
      $timeargs = "-s \"$itime\" -e \"$endtime\"";
    }
    else
    {
      # no incident time specified, collect previous 24 hrs
      $timeargs = "-last \"23:59:59\"";
      # set starttime to current time - 24 hours
      my $startsecs = time - 24 * 60 * 60;
      ($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst) = localtime($startsecs);
      $year = $year + 1900;
      $itime = formatTime($year, $mon+1, $day, $hour, $min, $sec);
      #collect end time now
      ($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst) = localtime(); 
      $year = $year + 1900;
      $endtime = formatTime($year, $mon+1, $day, $hour, $min, $sec);
    }

    # no quotes on program name when $timeargs contains quotes
    my $obin = catfile ($chmoshome, "bin", "oclumon");

    # collect information for all hosts for all available data
    # <CRF_HOME>/bin/oclumon dumpnodeview -allnodes -v 
    #  < time args >
    #  > chmos_data_all_<curr time>.txt
    $rc = system("$obin dumpnodeview -allnodes -v $timeargs > $CHMOSDATA_TXT");
    if (0 != $rc) 
    {
      printf("Failed to collect Cluster Health Monitor (OS) data. oclumon returned $rc\n");
      return;
    }

    createCHMOSMetadata($chmoshome, $itime, $endtime);

    # 
    # pack up CHMOS data
    #
    if ($PLATFORM eq $WIN32)
    {
      system("${ZIP} ${CHMOSDATA_ZIP} ${CHMOSMETADATA_XML} ${CHMOSDATA_TXT}");
      system("${DEL}  ${CHMOSMETADATA_XML} ${CHMOSDATA_TXT}");
    }
    else
    {
      system("${TAR} ${CF} ${CHMOSDATA_TAR} ${CHMOSMETADATA_XML} ${CHMOSDATA_TXT}; ${GZIP} ${CHMOSDATA_TAR}");
      system("${RM} ${CHMOSMETADATA_XML} ${CHMOSDATA_TXT}");
    }
  }
  else
  {
    # if not master, skip, 
    print "Cluster Health Monitor (OS) information has not been retrieved.\n";
    print "Run diagcollection on $master to collect CHM/OS information\n";
  }
}

#
# Get CHMOS master
#

sub getCHMOSMaster
{
  my $master = "master node";
  my $getkey = "-get master";
  my $oclmnbin = shift;
  my $otn = shift;

  if ($otn eq "false")
  {
    open(OUTPUT, "$oclmnbin manage $getkey 2>&1 |");
    while (<OUTPUT>)
    {
      if (/^Master = (.*)/) 
      {
        $master = $1;
        last;
      }
    }
  }
  else
  {
    $getkey = "-get MASTER=";
    open(OUTPUT, "$oclmnbin manage $getkey 2>&1 |");
    while (<OUTPUT>)
    {
      if (/^OCLUMON:(.*)/) 
      {
        $master = $1;
        last;
      }
    }
  }
  close(OUTPUT);
  if ($master eq "master node")
  {
    print("Cannot parse master oclumon get\n");
  }
  $master;
}

#
# Create metadata file
#
sub createCHMOSMetadata()
{
    my $chmoshome = shift;
    my $incidenttime = shift;
    my $endtime = shift;

    my $hflag = 0;
    my $metahosts = "";
    my $mtemp = "";

    my $oclumonbin = catfile ($chmoshome, "bin", "oclumon");
    $oclumonbin = "\"" . $oclumonbin . "\"";

    # get list of hosts using:
    # <CRF_HOME>/bin/oclumon showobjects
    #   Following nodes are attached to the loggerd
    #  <HOSTNAME>
    open(OUTPUT, "$oclumonbin showobjects 2>&1 |");
    while (<OUTPUT>)
    {
      if (/^ Following/)
      {
        #ignore this line      
      }
      elsif(/^\n/)
      {
        #ignore this line      
      }
      elsif($_ =~ /GPnP/)
      {
        #ignore this GPnP error      
      }
      elsif(/^[A-Za-z0-9]/)
      {
        if ($hflag == 0)
        {
          $metahosts = $_;
          chomp($metahosts);
          $hflag = 1;
        }
        else
        {
          $mtemp = $metahosts;
          $metahosts = join "", $mtemp , "," , $_;
          chomp($metahosts);
        }
      }
      else
      {
        #ignore this line
      }
    }
    if ($hflag == 0)
    {
      print("Cannot parse HOSTS from output: '$_'\n");
      $metahosts = "UNKNOWN";
    }
    close(OUTPUT);

    # fetch OS name
    my @metaos = "";
    if ($PLATFORM eq $WIN32)
    {
       $metaos = $WIN32;
    }
    else
    {
       chop($metaos = `uname -a`);
    }

    # fetch CHMOS version using:
    # <CRF_HOME>/bin/oclumon version
    # Cluster Health Monitor (OS), Version 12.1.0.0.0 - Production Copyright 2011 Oracle. All rights reserved. 
    my $metaver = "";
    open(OUTPUT, "$oclumonbin version 2>&1 |");
    while (<OUTPUT>)
    {
      if ($_=~/Cluster Health Monitor \(OS\), Version (\S*)/)
      {
        $metaver = "$1";
      }
    }
    close(OUTPUT);
    if ($metaver eq "")
    {
      print("WARNING: Cannot retrieve Cluster Health Monitor (OS) version\n");
      $metaver = "UNKNOWN";
    }

    # generate CHMOS meta data
    # <CHMOSMETA>
    #  <HOSTS> </HOSTS>
    #  <OS> </OS>
    #  <CHMOS_VERSION></CHMOS_VERSION>
    #  <START_TIME></START_TIME>
    #  <END_TIME></END_TIME>
    # </CHMOSMETA>
    # 
    open METAFILE, ">> $CHMOSMETADATA_XML";
    print METAFILE "<CHMOSMETA>\n";
    print METAFILE "<HOSTS>$metahosts</HOSTS>\n";
    print METAFILE "<OS>$metaos</OS>\n";
    print METAFILE "<CHMOS_VERSION>$metaver</CHMOS_VERSION>\n";
    print METAFILE "<START_TIME>$incidenttime</START_TIME>\n";
    print METAFILE "<END_TIME>$endtime</END_TIME>\n";
    print METAFILE "</CHMOSMETA>\n";
    close METAFILE;
}

##
# convertTime 
# getlocal time if arg passed in empty or construct time.
#
sub convertTime   {

  my $timetoconvert = shift;

  # if time is not passed, get the local time 
  if ($timetoconvert eq "")
  {
    ($sec,$min,$hour,$day,$month,$year,$wday,$yday,$isdst) = localtime();

    $year += 1900;
 #  $month += 1; # TODO: is this needed here?
    return "$year$month$day$hour";   
  }
  else 
  {
    $year  = substr $timetoconvert,0, 4;
    $month = substr $timetoconvert,4, 2;
    $day   = substr $timetoconvert,6, 2;
    $hour  = substr $timetoconvert,8, 2;
  }

  return "$year$month$day$hour";

}

#
# currentTime 
# getlocal time for use in filenames
#
sub currentTime   {

    ($sec,$min,$hour,$day,$month,$year,$wday,$yday,$isdst) = localtime();

    $year += 1900;
    $month += 1;
    return sprintf("%4d%02d%02d_%02d%02d", $year, $month, $day, $hour, $min);

}

#
# format time for use in metadata and cmdline
# ARGS: 6 (year, month, day, hour, min, sec)
#
sub formatTime {
    $year = $_[0];
    $month = $_[1];
    $day = $_[2];
    $hour = $_[3];
    $min = $_[4];
    $sec = $_[5];
    return sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec);
}

sub getFilesInDir {

  my $dir = shift;
  my $dh = DirHandle->new($dir); #die "can't opendir $dir: $!";

  # sort based on access time and return a reversed list. The latest first.
  # dont list cors files and default files
  # Use this if you want the latest file to be listed 
  # my @files = #reverse map {$_ => (stat($_))[9]}
  my @files = 
           grep {  !/^\./   } 
           grep {  !/^core/   } 
           grep {  !/^*OUT/   } 
           $dh->read();
  return @files; 
}

#
#Set crshome from olr.loc, only if user has not supplied the value from cmdline
# ARGS: 1
# ARG1: TRUE if mandatory, FALSE if optional
#
sub getCRSHome() {
  $mandatory = $_[0];
  if ($PLATFORM eq $HPUX) {
        $OLRCONFIG="/var/opt/oracle/olr.loc";
  } elsif ($PLATFORM eq $LINUX) {
        $OLRCONFIG="/etc/oracle/olr.loc";
  } elsif ($PLATFORM eq $SOLARIS) {
        $OLRCONFIG="/var/opt/oracle/olr.loc";
  } elsif ($PLATFORM eq $AIX) {
        $OLRCONFIG="/etc/oracle/olr.loc";
  } elsif ($PLATFORM eq $WIN32) {
        my $swkey=$Registry->{"LMachine/Software/Oracle/olr/"};
        $crshome = $swkey->{"/crs_home"};
        if(! $crshome && $mandatory) {
           print "CRS home not present in the registry\n";
           print "specify -crshome argument\n";
           exit;
        }
  } else  {
    if ($mandatory)
    {
      print "Error: Unknown Operating System for looking up CRS home\n";
      print "specify -crshome argument\n";
      exit;
    }
    return;
  }
  if ($PLATFORM ne $WIN32) {
     if (!open (OLRCFGFILE, "<$OLRCONFIG"))
     { 
       if ($mandatory) {
         die ("Cannot open $OLRCONFIG, specify -crshome argument");
       } 
       return;
     }
     while (<OLRCFGFILE>) {
        if (/^crs_home=(\S+)/) {
            $crshome = $1;
            last;
        }
      }
      close (OLRCFGFILE);
      if (! $crshome && $mandatory) {
           print "CRS home not present in the $OLRCONFIG file\n";
           print "specify -crshome argument\n";
           exit;
      }
  }
}

sub help() {
 print "diagcollection\n";
 print "    --collect  \n";    
 print "             [--crs] For collecting crs diag information \n";
 print "             [--adr] For collecting diag information for ADR; specify ADR location\n";
 print "             [--chmos] For collecting Cluster Health Monitor (OS) data\n";
 print "             [--all] Default.For collecting all diag information. \n";
 print "             [--core] UNIX only. Package core files with CRS data \n";
 print "             [--afterdate] UNIX only. Collects archives from the specified date. Specify in mm/dd/yyyy format\n";
 print "             [--aftertime] Supported with -adr option. Collects archives after the specified time. Specify in YYYYMMDDHHMISS24 format\n";
 print "             [--beforetime] Supported with -adr option. Collects archives before the specified date. Specify in YYYYMMDDHHMISS24 format\n";
 print "             [--crshome] Argument that specifies the CRS Home location \n";
# --chmoshome flag not to be documented
# print "             [--chmoshome] The install location for collecting Cluster Health Monitor (OS) information \n";
 print "             [--incidenttime] Collects Cluster Health Monitor (OS) data from the specified time.  Specify in MM/DD/YYYYHH24:MM:SS format\n";
 print "                  If not specified, Cluster Health Monitor (OS) data generated in the past 24 hours are collected\n";
 print "             [--incidentduration] Collects Cluster Health Monitor (OS) data for the duration after the specified time.  Specify in HH:MM format.\n";
 print "                 If not specified, all Cluster Health Monitor (OS) data after incidenttime are collected \n";
 print "             NOTE: \n";
 print "             1. You can also do the following \n";
 print "                ./diagcollection.pl --collect --crs --crshome <CRS Home>\n";
 print " \n";

 print "     --clean        cleans up the diagnosability\n";
 print "                    information gathered by this script\n";

 print " \n";
 print "     --coreanalyze  UNIX only. Extracts information from core files\n";
 print "                    and stores it in a text file\n";
}



