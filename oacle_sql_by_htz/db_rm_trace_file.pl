#!/usr/bin/perl
use strict;
use warnings;
use POSIX qw(strftime);
use File::Find;


our $sidName;
our $traceType;    #  10G 1,adump,bdump,udump,listener,11G,1,audit,diag,listener
our $dbVersion;
our $purgeHour;
our $forceAll;
our $traceU;
our $traceD;
our $traceA;
our $traceB;
our $traceC;
our $traceTrace;
our $traceAlert;
our $traceBase=$ENV{ORACLE_BASE};
our $auditTrace;
our %fileNames;
our $outRedo1='outputredo.log';
our $outRedo2='outoutsuccess.log';
our $errorFile="errorfilename.log";

#########################################################################
##                                                                     ##
## Log and Debug Printer                                               ##
##                                                                     ##
#########################################################################
sub printlog{

    my $date = strftime "%Y-%m-%d %H:%M:%S", localtime;
    if (not defined $_[1]){
        printf STDOUT "%20s :              %s\n", $date, $_[0];
    }
    else{
        printf STDOUT "%20s :[%10s]  %s\n", $date, $_[1], $_[0];
    }
}

###############################################################################
# Function : touch_error_file
# Purpose  : Create the error file if requested
###############################################################################
sub toucherrorfile
{
   my $message = $_[0];

   open ERRFILE, ">>$errorFile";
   print ERRFILE "$message\n";
   close ERRFILE;
}
###############################################################################
# Function : delete_error_file
# Purpose  : delete the error file 
###############################################################################
sub deleteerrorfile
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
# Function : Die
# Purpose  : Print message and exit
###############################################################################
sub Die
{
    my $message = $_[0];

    toucherrorfile($message);
die "
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Error:
------
$message
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
";
}

#########################################################################
##                                                                     ##
## Get Arguments                                                       ##
#########################################################################
sub getArgs(){

    my %argHash;
    my $optName;
    my $optValue;

    if ($#ARGV >= 1) {
        while ($optName = shift @ARGV){
            if (substr($optName, 0, 1) eq "-" ){
                $optValue = shift @ARGV;
                if(defined $optValue){
                    if(substr($optValue, 0, 1) eq '-'){
                        unshift(@ARGV, $optValue);
                        $optValue = '';
                         printlog("User Input : [$optName]","getArgs");
                    }
                    else{
                         printlog("User Input : [$optName] = [$optValue]","getArgs");
                    }
                    $argHash{$optName} = $optValue;
                }
                else{
                    $argHash{$optName} = '';
                }
            }
            else{
                 printlog("User Input Error for [$optName]", "ARGS");
            }
        }
    } else {
         printlog("Checking Params Failed","ARGS");
        usage();
        exit 0;
    }


    return %argHash
}


#########################################################################
##                                                                     ##
## Check User Inputs                                                   ##
##                                                                     ##
#########################################################################
sub checkInputs(){

    printlog('Check User Input Information', "ARGS");
    my %argList = getArgs;
    for (keys %argList){
        my $inputKey = $_;
        #print "input key is : [$inputKey], Value is : [$argList{$inputKey}]\n";
        if ($inputKey eq '-s'){
            $sidName = $argList{'-s'};
        }
        elsif ($inputKey eq '-h'){
            $purgeHour = $argList{'-h'};
        }
        elsif ($inputKey eq '-f'){
            $forceAll='ALL'
        }
        elsif ($inputKey eq '-t'){
            $traceType=$argList{'-t'}
        }
    }    

    # 1. Check Input Primary Connection
    if(defined $purgeHour and  defined $forceAll){
        Die "Purge Hour And Force ALL Are exits,You Only Choose One";
    }
    if (defined $purgeHour){
       $forceAll='NO';
     }
    if(not defined $sidName){
        Die "Please Input Sid Name";
    }
    if(not defined $traceType){
        $traceType='1111';
    }
    if(not defined $purgeHour and not defined $forceAll){
        $purgeHour=1;
        $forceAll='NO';
    }
    if(not defined $purgeHour and not defined $forceAll){
        $traceType='1111';
    }
}

###############################################################################
# Function : touch_error_file
# Purpose  : Create the error file if requested
###############################################################################
sub usage{
         printf "rmdbtrace.pl -s sidname -h 2 -t 1111  or rmdbtrace.pl -s sidname -f -t 1111\n";
         printf "      -s instance name\n";
         printf "      -h retention time of udump and bdump trace file,default 1 \n";
         printf "      -t 1111(10g audit,bdump,udump,listener) or -t 111(11g audit,diag,listenr) default 1111\n";
         printf "      -f force delete all trace file\n";
         exit 0;
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

#########################################################################
##                                                                     ##
## Execute SQLs in   retune single row                                 ##
##                                                                     ##
#########################################################################
sub execsql{

    my $sqlOutput;
    my $sqlQuery=$_[0];
    my $sqlPlusset='SET LINES 11111 PAGES 0 TRIM ON TRIMS ON TI OFF TIMI OFF AUTOT OFF FEED OFF SERVEROUTPUT ON SIZE UNLIMITED';
    $sqlOutput=`sqlplus -s '/ as sysdba' <<EOF
                           $sqlPlusset;
                           $sqlQuery;
                           quit;
                           EOF
                           `;
   if (($sqlOutput =~ /ORA[-][0-9]/) || ($sqlOutput =~ /SP2-.*/))
    {
           printlog("sql: $sqlQuery",'ERROR');
           Die("$sqlOutput")                       
    }
    else
    {
          return trim($sqlOutput);
    }
}
#########################################################################
##                                                                     ##
## Execute SQLs in   retune single row                                 ##
##                                                                     ##
#########################################################################
sub execsqls{

    my @sqlOutput;
    my $sqlQuery=$_[0];
    my $sqlPlusset='SET LINES 11111 PAGES 0 TRIM ON TRIMS ON TI OFF TIMI OFF AUTOT OFF FEED OFF SERVEROUTPUT ON SIZE UNLIMITED';

    @sqlOutput=`sqlplus -s '/ as sysdba' <<EOF
                           $sqlPlusset;
                           $sqlQuery;
                           quit;
                           EOF
                           `;
   foreach(@sqlOutput)
   {                          
      chomp;
      if (($_ =~ /ORA[-][0-9]/) || ($_ =~ /SP2-.*/))
       {
              print_log("sql: $_",'ERROR');
              Die("$_")                       
       }
   }
      return @sqlOutput;
}
#########################################################################
##                                                                     ##
## verify oracle_sid and instance_name                                 ##
##                                                                     ##
#########################################################################
sub envParam{
          my $envName=$ENV{'ORACLE_SID'};
          if (not defined($envName))
          {
                printlog("System not Config Oracle Sid","ENV");
                Die("Failed Modify  Oracle Sid") if $ENV{$_[0]}=$sidName;
                printlog("Success Modify Oracle Sid to $sidName",'CHANGE');
          }
          else
          {
                if (${envName} ne ${sidName}){
                   printlog("System Env Sid ne Input Value,Modify Oracle Sid to $sidName",'CHANGE');
                   Die("Failed Modify Oracle Sid") unless $ENV{'ORACLE_SID'}=$sidName;
                }
          }
          Die("System Not Config Oracle Base") unless $ENV{ORACLE_BASE};
          Die("System Not Config Oracle Base") unless $ENV{ORACLE_HOME};
}
#########################################################################
##                                                                     ##
## get log directory                                                   ##
##                                                                     ##
#########################################################################
sub getdir{
    Die "Database Status not in ('nomount mount open')" unless execsql("select open_mode from v\\\$database");
    $dbVersion=execsql("SELECT SUBSTR (banner,
                            INSTR (banner, 'Release ') + 8,
                            INSTR (SUBSTR (banner, INSTR (banner, 'Release ') + 4), ' '))
                            FROM v\\\$version
                            WHERE banner LIKE 'Oracle Database%'" );
     if ($dbVersion < '11.2'){
        $traceB=execsql("select value from v\\\$parameter where name in ('background_dump_dest')");
        $traceC=execsql("select value from v\\\$parameter where name in ('core_dump_dest')");
        $traceU=execsql("select value from v\\\$parameter where name in ('user_dump_dest')");
        $traceA=execsql("select value from v\\\$parameter where name in ('audit_file_dest')");
        $auditTrace='ora_(\d+|\d+_\d+).aud';
     }
     elsif ($dbVersion>='11.2'){
          $traceTrace=execsql("select value from v\\\$diag_info where name in ('Diag Trace')");
          $traceAlert=execsql("select value from v\\\$diag_info where name in ('Diag Alert')");
          $traceA=execsql("select value from v\\\$parameter where name in ('audit_file_dest')");
          $auditTrace="${sidName}".'_ora_\d+_\d+.aud';
          $auditTrace="${sidName}".'_ora_\d+_\d+.aud';
    }                    
}

#########################################################################
##                                                                     ##
## reset trace file name                                               ##
##                                                                     ##
#########################################################################
sub dbSetTrace{
        execsql("oradebug setospid $_;oradebug close_trace;oradebug flush;");
}

#########################################################################
##                                                                     ##
## diff file change time                                               ##
##                                                                     ##
#########################################################################
sub fileTimeDiff{
              my $fileName=$_[0];
              Die "$fileName Is Not Exits,Please Verify" unless -e $fileName;
        return time()-(stat $fileName)[9];
}
#########################################################################
##                                                                     ##
## get trace file name                                                 ##
##                                                                     ##
#########################################################################

sub outfilename{
              $fileNames{$File::Find::name}=$_ if -e $_ and -f $_;
}

sub findFileName{             
        find(\&outfilename,"$_[0]");
}

#########################################################################
##                                                                     ##
## rm audit file                                                       ##
##                                                                     ##
#########################################################################
sub rmTraceA{
        printlog('Get Audit File Name','INFO');
        undef %fileNames;
        findFileName($traceA);
        printlog('Begin Rm Audit File','Remove');
        open  OUTFILENAME1,">>",$outRedo1;
        open  OUTFILENAME2,">>",$outRedo2;
        while((my $key,my $value)=each %fileNames){
             next if $value eq '.' or $value eq '..';
             printf OUTFILENAME1 "$key\n";
             if ($value=~/$auditTrace/){;
                printf OUTFILENAME2 "$key\n" if unlink $key;
             }
        }
        close OUTFILENAME1;
        close OUTFILENAME2;
        printlog('Finish Rm Audit File','Remove');
}

#########################################################################
##                                                                     ##
## rm user dump  file                                                       ##
##                                                                     ##
#########################################################################
sub rmTraceU{
        printlog('Get User Dump File Name','INFO');
        undef %fileNames;
        my @sessTrace;
        findFileName($traceU);
        printlog('Get Current Session Dump File Name','INFO');
        my @currFileNames=execsqls("select instance_name||'_ora_'||spid||'.trc'  from v\\\$process,v\\\$instance where  addr not in (select paddr from v\\\$session where sid in (select sid from v\\\$mystat)) and background is null and spid is not null");
        printlog('Begin Rm User Dump File','Remove');
        open  OUTFILENAME1,">>",$outRedo1;
        open  OUTFILENAME2,">>",$outRedo2;
        while((my $key,my $value)=each %fileNames){
             next if $value eq '.' or $value eq '..';
             if ($forceAll eq 'ALL'){
                   if (grep /$value/,@currFileNames){
                       Die "Failed Push $value to Sess Trace" unless push(@sessTrace,$value);
                       printf OUTFILENAME1 "$key\n";
                       printf OUTFILENAME2 "$key\n" if unlink $key;
                  }
                  else{
                     printf OUTFILENAME1 "$key\n";
                     printf OUTFILENAME2 "$key\n" if unlink $key;
                  }
            }
            else{
                 if (fileTimeDiff($key)>($purgeHour*3600)){
                      Die "Failed Push $value to Sess Trace" unless push(@sessTrace,$value);
                      printf OUTFILENAME1 "$key\n";
                      printf OUTFILENAME2 "$key\n" if unlink $key;
                }
            }
        }
        close OUTFILENAME1;
        close OUTFILENAME2;
        printlog('Finish Rm User Dump File','Remove');
        if (@sessTrace>0){
                my @Pids=execsqls("select spid from v\\\$process");
                printlog("Begin Close  User Porcess Trace File And Flush","INOF");
                foreach(@sessTrace){                       
                      my $Pid=$_;
                      $Pid=~s/(\w+_ora_)(\d+)(.trc)/$2/;
                      next unless grep /$Pid/,@Pids;
                      execsql("oradebug setospid $Pid;\n oradebug close_trace;\n oradebug flush; \n exit;\n");
                }
                printlog("End Close  User Porcess Trace File And Flush","INOF");
        }

}


#########################################################################
##                                                                     ##
## rm backgroup dump file                                              ##
##                                                                     ##
#########################################################################
sub rmTraceB{
        printlog('Get Background  Dump File Name','INFO');
        undef %fileNames;
        my @sessTrace;
        findFileName($traceB);
        printlog('Get Current Background Dump File Name','INFO');
        my @currFileNames=execsqls("select b.instance_name||'_'||lower(substr(a.program, instr(a.program, '(') + 1,4)) || '_' || spid ||'.trc'  from v\\\$process a, v\\\$instance b where a.background is not null and addr not in (select paddr from v\\\$session where sid in (select sid from v\\\$mystat)) union all select 'alert_'||instance_name||'.log' from v\\\$instance");
        printlog('Begin Rm Background Dump File','Remove');
        open  OUTFILENAME1,">>",$outRedo1;
        open  OUTFILENAME2,">>",$outRedo2;
        while((my $key,my $value)=each %fileNames){
             next if $value eq '.' or $value eq '..';
             next if $value=~m/alert.*.log/;
             if ($forceAll eq 'ALL'){
                   if (grep /$value/,@currFileNames){
                       Die "Failed Push $value to Sess Trace" unless push(@sessTrace,$value);
                       printf OUTFILENAME1 "$key\n";
                       printf OUTFILENAME2 "$key\n" if unlink $key;
                  }
                  else{
                     printf OUTFILENAME1 "$key\n";
                     printf OUTFILENAME2 "$key\n" if unlink $key;
                  }
            }
            else{
                 if (fileTimeDiff($key)>($purgeHour*3600)){
                    Die "Failed Push $value to Sess Trace" unless push(@sessTrace,$value);
                    printf OUTFILENAME1 "$key\n";
                    printf OUTFILENAME2 "$key\n" if unlink $key;
                }
            }
        }
        close OUTFILENAME1;
        close OUTFILENAME2;
        printlog('Finish Rm Background Dump File','Remove');
        if (@sessTrace>0){
                my @Pids=execsqls("select spid from v\\\$process");
                printlog("Begin Close Background Porcess Trace File And Flush","INOF");
                foreach(@sessTrace){
                        my $Pid=$_;
                        $Pid=~s/(\w+_\w+_)(\d+)(.trc)/$2/;
                        next unless grep /$Pid/,@Pids;
                        execsql("oradebug setospid $Pid; \n oradebug close_trace; \n oradebug flush; \n exit;\n");
                }
               printlog("End Close Background Porcess Trace File And Flush","INOF");
        }
}
#########################################################################
##                                                                     ##
## touch new listener file                                             ##
##                                                                     ##
#########################################################################
sub rmListenerLog{
        printlog('Get  Listener File Name','INFO');
        Die "Failed Get Listener Name" unless my $listenerNum=grep /Listener Log File/,`lsnrctl status`;
        Die "Failed Get Listener Name" if $listenerNum==0;
        my @listenerLogFile=grep /Listener Log File/,`lsnrctl status`;
        my @listenerLogFiles=split(/Log File/,shift(@listenerLogFile));
        my $listenerFile=trim($listenerLogFiles[1]);
        printlog('Config Listener Log Status Off','INFO');
        Die "Failed Set Listener Log Status" if (`lsnrctl <<EOF >/dev/null
                set log_status off
                exit
                EOF`);
        Die "Failed Empty Listener Log File" if `> $listenerFile`;
        printlog('Finish Rm Listener File','Remove');
        printlog('Config Listener Log Status On','INFO');
        Die "Failed Set Listener Log Status" if (`lsnrctl <<EOF >/dev/null
                set log_status on
                exit
                EOF`);
}
checkInputs;
envParam;
getdir;
rmTraceA if substr($traceType,0,1)==1;
rmTraceU if substr($traceType,1,1)==1;
rmTraceB if substr($traceType,2,1)==1;
rmListenerLog if substr($traceType,3,1)==1;