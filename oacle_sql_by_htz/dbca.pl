#!/usr/bin/perl
use strict;
use warnings;
use POSIX qw(strftime);
use Cwd;
use Getopt::Long qw(:config no_ignore_case);
use File::Copy;
use Sys::Hostname;

our $wordDir=getcwd;
our $logDir=getcwd."/logs";
our $dateFormat=strftime "%Y%m%d%H%M%S", localtime;

#perl
$|=1;
# db
our $dbVersion;
our $dbFilePath;
our $dbStorageType;
our $dbName;
our $dbRedoSize=51;
our $dbRedoGroupNumber;
our $dbRedoFileNumber;
our $dbCharacset;
our $dbMemManType;
our $dbMemSgaMaxSize;
our $dbMemPgaSize;
our $dbMemCacheSize;
our $dbMemSharepoolSize;
our $dbMemLargepoolSize;
our $dbMemJavepoolSize;
our $dbMemStreampoolSize;
our $dbMemTarget;
our $dbMemSize;
our $dbType;
our $dbGroupName;
our $dbDirectory;
our $dbFra;
our @dbNodeName;
our $dbUndoSize;
our $password="oracle";
our $dbSystemSize;
our $dbSysauxSize;
our $dbFileExtend;
our $dbArch;
our $hostName=hostname;
our $dbProcess;

#for 12c
our $dbCdb;
our @dbPdbName;
our $dbPdbName;
our $dbPdbCount;


# env
our $oracleBase=$ENV{ORACLE_BASE};
our $oracleHome=$ENV{ORACLE_HOME};
# other
our $dbNodeList;

# log file
our $errorLog;
our $warrLog;
our $commandLog;
our $stepLog;

sub fileOpen
{
   unless (-e $logDir and -d $logDir){
        print("mkdir $logDir\n");
        mkdir $logDir ||die("Failed mkdir $logDir and exits ,Error No :$!");
   }
       print("Open Log File\n");
       open $errorLog,">",getcwd."/logs/".$dateFormat.".err"       || die("Failed Open Error Logfle ,errpr $!");
       open $warrLog,">",getcwd."/logs/".$dateFormat.".warr"       || die("Failed Open Warring Logfle ,errpr $!");
       open $commandLog,">",getcwd."/logs/".$dateFormat.".command" || die("Failed Open Command Logfle ,errpr $!");
       open $stepLog,">",getcwd."/logs/".$dateFormat.".step"       || die("Failed Open Command Logfle ,errpr $!");
}


sub fileClose
{
    close $errorLog if ($errorLog);
    close $warrLog if ($warrLog);
    close $commandLog if ($commandLog);
    close $stepLog if ($stepLog);
}

sub printLog{
  my ($type,$msg,$step) = @_;
  my $date=strftime "%Y%m%d%H%M%S", localtime;
  if ($type eq "E"){
     if ($errorLog){
           printf  "%14s:%15s: %s\n",$date,"ERROR",$msg;
           printf $commandLog "%14s:%15s: %s\n",$date,"ERROR",$msg;
           printf $errorLog "%14s:%15s: %s\n",$date,"ERROR",$msg;
           fileClose;
           exit;
      }
   }
   elsif ($type eq "W") {
     if ($warrLog){
         printf $commandLog "%14s:%15s: %s\n",$date,"INFO",$msg;
         printf $warrLog "%14s:%15s: %s\n",$date,"WARRING",$msg;
     }
   }
   elsif ($type eq "I") {
     if ($warrLog){
         printf $commandLog "%14s:%15s: %s\n",$date,"INFO",$msg;
     }
   }
   elsif ($type eq "D") {
         printf $commandLog "%14s:%15s: %s\n",$date,"INFO",$msg;
         printf "%14s:%15s: %s\n",$date,"INFO",$msg;
    }
}



sub usage{
        print "      dbca.pl -d dbname -g 5 -t rac -N node1,node2 -arch true -storagetype asm  -redosize 2048 -c zhs16gbk -p 2000 \n";
        print "      dbca.pl -d dbname -N node1,node2  -G diskgroup (rac)\n";
        print "      dbca.pl -d dbname -P htzpdb1,htzpdb2 -N node1,node2  -G diskgroup (rac) \n";
        print "      dbca.pl -d dbname (single)\n";
        print "              -d          dbname\n";
        print "              -P          pdb name\n";
        print "              -g          log group number every thread(default 6)\n";
        print "              -G          diskgroup for datafile\n";
        print "              -D          directory for datafile when storagetype is fs(default oracle_base/oradata)\n";
        print "              -n          log file number every log group(default 1)\n";
        print "              -t          database type rac/single (default sigle)\n";
        print "              -N          node name for rac database\n";
        print "              -s          memory management type auto/manual (default manual)\n";
        print "              -sgasize    sga_max_size(M) \n";
        print "              -c          characset\n";
        print "              -p          process number (default)\n";
        print "              -C          database compent (default little) \n";
        print "              -arch       database archive mode true/fasle (default false) \n";
        print "              -fra        location for fra(default datafile group name)\n";
        print "              -storagetype storege type(file|asm (default file))\n";
        print "              -undosize   undo tablespace size (default 32767M)\n";
        print "              -redosize   redo logfile size (default 2048M)\n";
        print "              -systemsize system tablespace size (default 5120M)\n";
        print "              -sysauxsize sysaux tablespace size (default 10240M)\n";
        print "              -fileextend datafile auto extend  true/false(default false)\n";
        exit 1;
}

sub parseArgs
{
    my ($opt_d,$opt_g,$opt_n,$opt_t,$opt_N,$opt_s,$opt_c,$opt_C,$opt_h,$opt_p,
       $opt_fra,$opt_groupname,$opt_storagetype,$opt_undosize,$opt_arch,$opt_D,
       $opt_redosize,$opt_systemsize,$opt_sysauxsize,$opt_fileextend,$opt_sgasize,$opt_P);
    if ($#ARGV < 0)
    {
        usage();
        exit 1;
    }
    else
    {
      GetOptions(
          'dbname|d=s'          => \$opt_d,
          'loggroup|g=s'        => \$opt_g,
          'diskgroup|G=s'       => \$opt_groupname,
          'lognumber|n=i'       => \$opt_n,
          'dbtype|t=s'          => \$opt_t,
          'nodename|N=s'        => \$opt_N,
          'characset|c=s'       => \$opt_c,
          'mem|s=s'             => \$opt_s,
          'sgasize=i'           => \$opt_sgasize,
          'compent|C=s'         => \$opt_C,
          'process|p=i'         => \$opt_p,
          'help|h!'             => \$opt_h,
          'fra=s'               => \$opt_fra,
          'storagetype=s'       => \$opt_storagetype,
          'undosize=i'          => \$opt_undosize,
          'redosize=i'          => \$opt_redosize,
          'systemsize=i'        => \$opt_systemsize,
          'sysauxsize=i'        => \$opt_sysauxsize,
          'fileextend=s'        => \$opt_fileextend,
          'arch=s'              => \$opt_arch,
          'directory|D=s'       => \$opt_D,
          'pdbname|P=s'         => \$opt_P,
        );
    }
    if (defined $opt_h){
        usage();
    }
    if (not defined $opt_d){
        usage();
    }
    if (defined $opt_d){
        $dbName=$opt_d;
        printLog('D',"User Input  : [\$dbName] = $dbName");
    }
    if (defined $opt_g){
        $dbRedoGroupNumber=$opt_g;
        printLog('D',"User Input  : [\$dbRedoGroupNumber] = $dbRedoGroupNumber");
    }
    else{
        $dbRedoGroupNumber=6;
        printLog('D',"User Input  : [\$dbRedoGroupNumber] = $dbRedoGroupNumber");
    }
    if (defined $opt_n){
        $dbRedoFileNumber=$opt_n;
        printLog('D',"User Input  : [\$dbRedoFileNumber] = $dbRedoFileNumber");
    }
    else{
        $dbRedoFileNumber=1;
        printLog('D',"User Input  : [\$dbRedoFileNumber] = $dbRedoFileNumber");
    }
    if (defined $opt_p){
        $dbProcess=$opt_p;
        printLog('D',"User Input  : [\$dbProcess] = $dbProcess");
    }
    else{
        $dbProcess=2000;
        printLog('D',"User Input  : [\$dbProcess] = $dbProcess");
    }
    if (not defined $opt_t and not defined $opt_N){
        $dbType='single';
        $opt_N=$hostName;
        $dbNodeList=$opt_N;
        @dbNodeName=split (/,/,$opt_N);
        printLog('D',"User Input  : [\$dbType] = $dbType");
        printLog('D',"User Input  : [\$dbNodeList] = $dbNodeList");
    }
    elsif (not defined $opt_t and defined $opt_N){
        $dbType='rac';
        $dbNodeList=$opt_N;
        @dbNodeName=split (/,/,$opt_N);
        printLog('D',"User Input  : [\$dbType] = $dbType");
        printLog('D',"User Input  : [\$dbNodeList] = $dbNodeList");
    }
    else{
        $dbType=$opt_t;
        if ($dbType eq 'rac' && not defined $opt_N){
                usage;
        }
        elsif ($dbType eq 'rac' && defined $opt_N){
           @dbNodeName=split (/,/,$opt_N);
           $dbNodeList=$opt_N;
           printLog('D',"User Input  : [\$dbType] = $dbType");
           printLog('D',"User Input  : [\$dbNodeList] = $dbNodeList ");
        }
        elsif ($dbType eq 'single'){
           $opt_N=$hostName;
           @dbNodeName=split (/,/,$opt_N);
           printLog('D',"User Input  : [\$dbType] = $dbType");
           printLog('D',"User Input  : [\$dbNodeList] = $dbNodeList");
        }
    }
    if (defined $opt_P){
       $dbPdbName=$opt_P;
       @dbPdbName=split(/,/,$dbPdbName);
       printLog('D',"User Input  : [\$dbPdbName] = $dbPdbName");
    }
    if (defined $opt_c){
        $dbCharacset=$opt_c;
        printLog('D',"User Input  : [\$dbCharacset] = $dbCharacset");
    }
    else{
        $dbCharacset='zhs16gbk';
        printLog('D',"User Input  : [\$dbCharacset] = $dbCharacset");
    }
    if (not defined $opt_storagetype and not defined $opt_groupname and not defined $opt_D){
        $dbStorageType='file';
        $dbDirectory="${oracleBase}/oradata";
        printLog('D',"User Input  : [\$dbStorageType] = $dbStorageType");
        printLog('D',"User Input  : [\$dbDirectory] = $dbDirectory");
    }
    elsif( not defined $opt_storagetype and defined $opt_groupname){
        $dbStorageType='asm';
        printLog('D',"User Input  : [\$dbStorageType] = $dbStorageType");
    }
    elsif( not defined $opt_storagetype and defined $opt_D){
        $dbStorageType='file';
        $dbDirectory=$opt_D;
        printLog('D',"User Input  : [\$dbStorageType] = $dbStorageType");
        printLog('D',"User Input  : [\$dbDirectory] = $dbDirectory");
    }
    else{
          $dbStorageType=$opt_storagetype;
          if (($dbStorageType eq 'file' or $dbStorageType eq 'FILE') and defined $opt_groupname){
                usage;
          }
          elsif(($dbStorageType eq 'file' or $dbStorageType eq 'FILE') and not defined $opt_D){
                 $dbStorageType='file';
                 $dbDirectory="$oracleBase/oradata";
             printLog('D',"User Input  : [\$dbStorageType] = $dbStorageType");
             printLog('D',"User Input  : [\$dbDirectory] = $dbDirectory");
          }
          elsif(($dbStorageType eq 'file' or $dbStorageType eq 'FILE') and  defined $opt_D){
                 $dbStorageType='file';
                 $dbDirectory=$opt_D;
             printLog('D',"User Input  : [\$dbStorageType] = $dbStorageType");
             printLog('D',"User Input  : [\$dbDirectory] = $dbDirectory");
          }
          else{
                printLog('D',"User Input  : [\$dbStorageType] = $dbStorageType");
          }

    }
    if (defined $opt_groupname){
        $dbGroupName=$opt_groupname;
        printLog('D',"User Input  : [\$dbGroupName] = $dbGroupName");
    }
    if (defined $opt_fra){
        $dbFra=$opt_fra;
        printLog('D',"User Input  : [\$dbFra] = $dbFra");
    }
    else{
         if ($dbStorageType eq 'FILE' or $dbStorageType eq 'file'){
          $dbFra = "$oracleBase/flash_recovery_area";
          printLog('D',"User Input  : [\$dbFra] = $dbFra");
         }
         else{
            if ( not defined $opt_groupname) {
            usage;
            }
            else{
            $dbFra=$opt_groupname;
            printLog('D',"User Input  : [\$dbFra] = $dbFra");
            }
         }
    }
    if (defined $opt_undosize){
        $dbUndoSize=$opt_undosize;
        printLog('D',"User Input  : [\$dbUndoSize] = $dbUndoSize");
    }
    else{
        $dbUndoSize=32767;
        printLog('D',"User Input  : [\$dbUndoSize] = $dbUndoSize");
    }
    if (defined $opt_redosize){
        $dbRedoSize=$opt_redosize;
        printLog('D',"User Input  : [\$dbRedoSize] = $dbRedoSize");
    }
    else{
        $dbRedoSize=2048;
        printLog('D',"User Input  : [\$dbRedoSize] = $dbRedoSize");
    }
    if (defined $opt_systemsize){
        $dbSystemSize=$opt_systemsize;
        printLog('D',"User Input  : [\$dbSystemSize] = $dbSystemSize");
    }
    else{
        $dbSystemSize=5124;
        printLog('D',"User Input  : [\$dbSystemSize] = $dbSystemSize");
    }
    if (defined $opt_sysauxsize){
        $dbSysauxSize=$opt_sysauxsize;
        printLog('D',"User Input  : [\$dbSysauxSize] = $dbSysauxSize");
    }
    else{
        $dbSysauxSize=10240;
        printLog('D',"User Input  : [\$dbSysauxSize] = $dbSysauxSize");
    }
    if (defined $opt_fileextend){
        $dbFileExtend=$opt_fileextend;
        if ($dbFileExtend eq 'true' or $dbFileExtend eq 'false'){
        printLog('D',"User Input  : [\$dbFileExtend] = $dbFileExtend");
        }
        else{
                usage;
        }
    }
    else{
        $dbFileExtend='false';
        printLog('D',"User Input  : [\$dbFileExtend] = $dbFileExtend");
    }
    if (defined $opt_arch){
        $dbArch=$opt_arch;
        if ($dbArch eq 'true' or $dbArch eq 'false'){
        printLog('D',"User Input  : [\$dbArch] = $dbArch");
        }
        else{
                usage;
        }
    }
    else{
        $dbArch='false';
        printLog('D',"User Input  : [\$dbArch] = $dbArch");
    }
    if (defined $opt_s){
        $dbMemManType=uc($opt_s);
    }
    else{
        $dbMemManType='MANUAL';
    }
    if (defined $opt_sgasize and uc($dbMemManType) eq 'AUTO'){
        $dbMemSgaMaxSize=$opt_sgasize;
        $dbMemTarget=$dbMemSgaMaxSize;
    }
    elsif (defined $opt_sgasize and uc($dbMemManType eq 'MANUAL')){
        $dbMemManType=uc('manual');
        $dbMemSgaMaxSize=$opt_sgasize;
    }
    elsif (not defined $opt_sgasize){
       $dbMemSgaMaxSize=$opt_sgasize;
    }
}

sub dbMem{
     chomp(my $totalmem=`grep MemTotal /proc/meminfo\|awk '{print \$2}'`);
     my $sga;
     my $pga;

     if (not defined $dbMemSgaMaxSize){
        if ($dbProcess <= 3000 and $totalmem < 100*1024*1024){
           $sga=$totalmem*0.6;
           $pga=$totalmem*0.1;
           }
        elsif ($dbProcess <= 3000 and $totalmem < 200*1024*1024 and $totalmem >=100*1024*1024 ){
            $sga=$totalmem*0.75;
            $pga=$totalmem*0.1;
           }
        elsif ($dbProcess <= 3000 and $totalmem > 200*1024*1024 ){
            $sga=$totalmem*0.8;
            $pga=$totalmem*0.1;
           }
        elsif ($dbProcess >3000 and $dbProcess <6000 and $totalmem < 100*1024*1024){
           $sga=$totalmem*0.5;
           $pga=$totalmem*0.1;
           }
        elsif ($dbProcess >3000 and $dbProcess <6000 and $totalmem < 200*1024*1024 and $totalmem >100*1024*1024){
           $sga=$totalmem*0.6;
           $pga=$totalmem*0.1;
           }
        elsif($dbProcess >3000 and $dbProcess <6000 and $totalmem > 200*1024*1024){
           $sga=$totalmem*0.7;
           $pga=$totalmem*0.1;
           }
        elsif ($dbProcess>6000 and $totalmem <100*1024*1024)
           {
                $sga=$totalmem*0.4;
                $pga=$totalmem*0.1;
           }
        elsif ($dbProcess>6000 and $totalmem >100*1024*1024 and $totalmem<200*1024*1024)
           {
                $sga=$totalmem*0.55;
                $pga=$totalmem*0.1;
           }
        elsif ($dbProcess>6000 and $totalmem >200*1024*1024)
           {
                $sga=$totalmem*0.7;
                $pga=$totalmem*0.1;
           }
        else{
                $sga=$totalmem*0.5;
                $pga=$totalmem*0.1;
           }
        $dbMemSgaMaxSize=int($sga);
      }
      $dbMemPgaSize=int($totalmem*0.1);
      if (uc($dbMemManType) eq 'MANUAL'){
        $dbMemCacheSize=int(0.72*$dbMemSgaMaxSize);
        $dbMemSharepoolSize=int(0.15*$dbMemSgaMaxSize);
        $dbMemLargepoolSize=int(0.02*$dbMemSgaMaxSize);
        $dbMemJavepoolSize=int(0.01*$dbMemSgaMaxSize);
        $dbMemStreampoolSize=0;
        $dbMemTarget=0;
        printLog('D',"User Input  : [\$dbMemManType] = $dbMemManType");
        printLog('D',"User Input  : [\$dbMemSgaMaxSize] = $dbMemSgaMaxSize");
        printLog('D',"User Input  : [\$dbMemTarget] = $dbMemTarget");
        printLog('D',"User Input  : [\$dbMemCacheSize] = $dbMemCacheSize");
        printLog('D',"User Input  : [\$dbMemSharepoolSize] = $dbMemSharepoolSize");
        printLog('D',"User Input  : [\$dbMemLargepoolSize] = $dbMemLargepoolSize");
        printLog('D',"User Input  : [\$dbMemStreampoolSize] = $dbMemStreampoolSize");
       }
      elsif (uc($dbMemManType) eq 'AUTO'){
        $dbMemTarget=$dbMemSgaMaxSize;
        printLog('D',"User Input  : [\$dbMemManType] = $dbMemManType");
        printLog('D',"User Input  : [\$dbMemSgaMaxSize] = $dbMemSgaMaxSize");
        printLog('D',"User Input  : [\$dbMemTarget] = $dbMemTarget")
       }
}
#########################################################################
##                                                                     ##
## Check Oracle Envs                                                   ##
##                                                                     ##
#########################################################################

sub envCheck{


     if ($oracleBase && $oracleHome)
     {
          printLog('D',"Envs info  : [ORACLE BASE] = $oracleBase");
          printLog('D',"Envs info  : [ORACLE HOME] = $oracleHome");
     }
     else{
          printLog('E',"Envs info  : [ORACLE BASE or ORACLE HOME Is Error and Please Check");
     }
}

#########################################################################
##                                                                     ##
## Check Oracle Version                                                ##
##                                                                     ##
#########################################################################

sub envDbversion{
      my $dbver;

     if ($dbver=`sqlplus -v`)
     {
          $dbver=~/(\d+.\d+)/;
          $dbVersion=$1;
          printLog('I',"Envs Info  :  Db version is $dbVersion");
     }
     else{
          printLog('I',"sqlplus commannd info :$dbver");
          printLog('E',"Envs info  : Not Find sqlplus command;");
     }
}

#########################################################################
##                                                                     ##
## Execute SQLs in   retune single row                                 ##
##                         $sqlplusset;                                             ##
#########################################################################
sub execSql{

    my $sqloutput;
    my $sqlquery=$_[0];
    my $sqlplusset='SET LINES 11111 PAGES 0 TRIM ON TRIMS ON TI OFF TIMI OFF AUTOT OFF FEED OFF SERVEROUTPUT ON SIZE UNLIMITED';
    $sqloutput=`sqlplus -s '/ as sysdba' <<EOF
                           $sqlquery;
                           quit;
EOF
                           `;
   printLog('I',"sql:$sqloutput");
   if (($sqloutput =~ /ORA[-][0-9]/) || ($sqloutput =~ /SP2-.*/))
    {
           printLog('D',"sql:$sqlquery");
           printLog('E',"sql:$sqloutput");
    }
}

#########################################################################
##                                                                     ##
## verify oracle_sid and instance_name                                 ##
##                                                                     ##
#########################################################################
sub envPara{
          my $envname=$ENV{$_[0]};
          my $dbname=$_[1];
          my $instancename;
          if ($dbType eq 'rac' || $dbType  eq 'RAC') {
              printLog('I',"Begin Exec srvctl status database -d $dbName");
              my @output=`srvctl status database -d $dbName`;
              printLog('I',"@output");
              foreach(@output){
                  if (/$hostName/){
                      chomp;
                      $instancename=$1 if /($dbName\d)/;
                  }
              }
          }
          else{
             $instancename=$dbName;
          }
          printLog('I',"Instance Name :$instancename");
          if (not defined($instancename)){
          printLog('E',"Undefined instancename and exit");
          }
          if (not defined($envname))
          {
                my $sid='';
                printLog('E',"change ORACLE_SID failed") unless $ENV{$_[0]}=$instancename;
                printLog('I',"success change ORACLE_SID=$instancename");
          }
          else
          {
                my $sid=$envname;
                if (${envname} ne ${instancename}){
                   printLog('I',"change ORACLE_SID=$instancename");
                   printLog('E',"change ORACLE_SID failed") unless $ENV{$_[0]}=$instancename;
                }
          }
}
sub dbCreateTemplate{
     if ($dbVersion eq '11.1' or $dbVersion eq '11.2' ){
        open (TEMPFILE,">template.dbt") || printLog('E',"Failed Open file moban.dbt ,Error :$!");
        print TEMPFILE qq# <DatabaseTemplate name="$dbName" description=" " version="11.2.0.0.0">\n#;
        print TEMPFILE qq# <CommonAttributes>\n#;
        print TEMPFILE qq#    <option name="OMS" value="false"/>\n#;
        print TEMPFILE qq#    <option name="JSERVER" value="true"/>\n#;
        print TEMPFILE qq#    <option name="SPATIAL" value="false"/>\n#;
        print TEMPFILE qq#    <option name="IMEDIA" value="false"/>\n#;
        print TEMPFILE qq#    <option name="XDB_PROTOCOLS" value="true">\n#;
        print TEMPFILE qq#       <tablespace id="SYSAUX"/>\n#;
        print TEMPFILE qq#    </option>\n#;
        print TEMPFILE qq#    <option name="ORACLE_TEXT" value="false">\n#;
        print TEMPFILE qq#       <tablespace id="SYSAUX"/>\n#;
        print TEMPFILE qq#    </option>\n#;
        print TEMPFILE qq#    <option name="SAMPLE_SCHEMA" value="false"/>\n#;
        print TEMPFILE qq#    <option name="CWMLITE" value="false">\n#;
        print TEMPFILE qq#       <tablespace id="SYSAUX"/>\n#;
        print TEMPFILE qq#    </option>\n#;
        print TEMPFILE qq#    <option name="EM_REPOSITORY" value="false">\n#;
        print TEMPFILE qq#       <tablespace id="SYSAUX"/>\n#;
        print TEMPFILE qq#    </option>\n#;
        print TEMPFILE qq#    <option name="APEX" value="false"/>\n#;
        print TEMPFILE qq#    <option name="OWB" value="false"/>\n#;
        print TEMPFILE qq#    <option name="DV" value="false"/>\n#;
        print TEMPFILE qq#    <option name="NET_EXTENSIONS" value="false"/>\n#;
        print TEMPFILE qq# </CommonAttributes>\n#;
        print TEMPFILE qq# <Variables/>\n#;
        print TEMPFILE qq# <CustomScripts Execute="false"/>\n#;
        print TEMPFILE qq# <InitParamAttributes>\n#;
        print TEMPFILE qq#    <InitParams>\n#;
        print TEMPFILE qq#        <initParam name="db_name" value="$dbName"/>\n#;
        print TEMPFILE qq#        <initParam name="db_domain" value=""/>\n#;
        print TEMPFILE qq#        <initParam name="dispatchers" value="(PROTOCOL=TCP) (SERVICE={SID}XDB)"/>\n#;
        #print TEMPFILE qq#        <initParam name="audit_file_dest" value="{ORACLE_BASE}\admin\{DB_UNIQUE_NAME}\adump"/>\n#;
        print TEMPFILE qq#        <initParam name="remote_login_passwordfile" value="EXCLUSIVE"/>\n#;
        print TEMPFILE qq#        <initParam name="processes" value="$dbProcess"/>\n#;
        print TEMPFILE qq#        <initParam name="diagnostic_dest" value="{ORACLE_BASE}"/>\n#;
        print TEMPFILE qq#        <initParam name="audit_trail" value="none"/>\n#;
        print TEMPFILE qq#        <initParam name="db_block_size" value="8" unit="KB"/>\n#;
        print TEMPFILE qq#        <initParam name="open_cursors" value="300"/>\n#;
        print TEMPFILE qq#        <initParam name="pga_aggregate_target" value="3237" unit="MB"/>\n#;
        print TEMPFILE qq#     </InitParams>\n#;
        print TEMPFILE qq#     <MiscParams>\n#;
        print TEMPFILE qq#        <databaseType>MULTIPURPOSE</databaseType>\n#;
        print TEMPFILE qq#        <maxUserConn>20</maxUserConn>\n#;
        print TEMPFILE qq#        <percentageMemTOSGA>40</percentageMemTOSGA>\n#;
        print TEMPFILE qq#        <customSGA>true</customSGA>\n#;
        print TEMPFILE qq#        <characterSet>ZHS16GBK</characterSet>\n#;
        print TEMPFILE qq#        <nationalCharacterSet>AL16UTF16</nationalCharacterSet>\n#;
        print TEMPFILE qq#        <archiveLogMode>$dbArch</archiveLogMode>\n#;
        print TEMPFILE qq#        <initParamFileName>{ORACLE_BASE}/admin/{DB_UNIQUE_NAME}/pfile/init.ora</initParamFileName>\n#;
        print TEMPFILE qq#     </MiscParams>\n#;
        print TEMPFILE qq#     <SPfile useSPFile="true">{ORACLE_HOME}/dbs/spfile{SID}.ora</SPfile>\n#;
        print TEMPFILE qq#  </InitParamAttributes>\n#;
        print TEMPFILE qq#  <StorageAttributes>\n#;
        print TEMPFILE qq#     <ControlfileAttributes id="Controlfile">\n#;
        print TEMPFILE qq#        <maxDatafiles>2000</maxDatafiles>\n#;
        print TEMPFILE qq#        <maxLogfiles>16</maxLogfiles>\n#;
        print TEMPFILE qq#        <maxLogMembers>3</maxLogMembers>\n#;
        print TEMPFILE qq#        <maxLogHistory>1</maxLogHistory>\n#;
        print TEMPFILE qq#        <maxInstances>8</maxInstances>\n#;
        print TEMPFILE qq#        <image name="control01.ctl" filepath="{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/"/>\n#;
        print TEMPFILE qq#        <image name="control02.ctl" filepath="{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/"/>\n#;
        print TEMPFILE qq#     </ControlfileAttributes>\n#;
        print TEMPFILE qq#     <DatafileAttributes id="{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/sysaux01.dbf">\n#;
        print TEMPFILE qq#        <tablespace>SYSAUX</tablespace>\n#;
        print TEMPFILE qq#        <temporary>false</temporary>\n#;
        print TEMPFILE qq#        <online>true</online>\n#;
        print TEMPFILE qq#        <status>0</status>\n#;
        print TEMPFILE qq#        <size unit="MB">600</size>\n#;
        print TEMPFILE qq#        <reuse>true</reuse>\n#;
        print TEMPFILE qq#        <autoExtend>$dbFileExtend</autoExtend>\n#;
        print TEMPFILE qq#        <increment unit="KB">10240</increment>\n#;
        print TEMPFILE qq#        <maxSize unit="MB">-1</maxSize>\n#;
        print TEMPFILE qq#     </DatafileAttributes>\n#;
        print TEMPFILE qq#     <DatafileAttributes id="{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/system01.dbf">\n#;
        print TEMPFILE qq#        <tablespace>SYSTEM</tablespace>\n#;
        print TEMPFILE qq#        <temporary>false</temporary>\n#;
        print TEMPFILE qq#        <online>true</online>\n#;
        print TEMPFILE qq#        <status>0</status>\n#;
        print TEMPFILE qq#        <size unit="MB">700</size>\n#;
        print TEMPFILE qq#        <reuse>true</reuse>\n#;
        print TEMPFILE qq#        <autoExtend>$dbFileExtend</autoExtend>\n#;
        print TEMPFILE qq#        <increment unit="KB">10240</increment>\n#;
        print TEMPFILE qq#        <maxSize unit="MB">-1</maxSize>\n#;
        print TEMPFILE qq#     </DatafileAttributes>\n#;
        print TEMPFILE qq#     <DatafileAttributes id="{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/temp01.dbf">\n#;
        print TEMPFILE qq#        <tablespace>TEMP</tablespace>\n#;
        print TEMPFILE qq#        <temporary>false</temporary>\n#;
        print TEMPFILE qq#        <online>true</online>\n#;
        print TEMPFILE qq#        <status>0</status>\n#;
        print TEMPFILE qq#        <size unit="MB">20</size>\n#;
        print TEMPFILE qq#        <reuse>true</reuse>\n#;
        print TEMPFILE qq#        <autoExtend>$dbFileExtend</autoExtend>\n#;
        print TEMPFILE qq#        <increment unit="KB">640</increment>\n#;
        print TEMPFILE qq#        <maxSize unit="MB">-1</maxSize>\n#;
        print TEMPFILE qq#     </DatafileAttributes>\n#;
        print TEMPFILE qq#     <DatafileAttributes id="{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/users01.dbf">\n#;
        print TEMPFILE qq#        <tablespace>USERS</tablespace>\n#;
        print TEMPFILE qq#        <temporary>false</temporary>\n#;
        print TEMPFILE qq#        <online>true</online>\n#;
        print TEMPFILE qq#        <status>0</status>\n#;
        print TEMPFILE qq#        <size unit="MB">5</size>\n#;
        print TEMPFILE qq#        <reuse>true</reuse>\n#;
        print TEMPFILE qq#        <autoExtend>$dbFileExtend</autoExtend>\n#;
        print TEMPFILE qq#        <increment unit="KB">1280</increment>\n#;
        print TEMPFILE qq#        <maxSize unit="MB">-1</maxSize>\n#;
        print TEMPFILE qq#     </DatafileAttributes>\n#;
        print TEMPFILE qq#     <TablespaceAttributes id="SYSAUX">\n#;
        print TEMPFILE qq#        <online>true</online>\n#;
        print TEMPFILE qq#        <offlineMode>1</offlineMode>\n#;
        print TEMPFILE qq#        <readOnly>false</readOnly>\n#;
        print TEMPFILE qq#        <temporary>false</temporary>\n#;
        print TEMPFILE qq#        <defaultTemp>false</defaultTemp>\n#;
        print TEMPFILE qq#        <undo>false</undo>\n#;
        print TEMPFILE qq#        <local>true</local>\n#;
        print TEMPFILE qq#        <blockSize>-1</blockSize>\n#;
        print TEMPFILE qq#        <allocation>1</allocation>\n#;
        print TEMPFILE qq#        <uniAllocSize unit="KB">-1</uniAllocSize>\n#;
        print TEMPFILE qq#        <initSize unit="KB">64</initSize>\n#;
        print TEMPFILE qq#        <increment unit="KB">64</increment>\n#;
        print TEMPFILE qq#        <incrementPercent>50</incrementPercent>\n#;
        print TEMPFILE qq#        <minExtends>1</minExtends>\n#;
        print TEMPFILE qq#        <maxExtends>4096</maxExtends>\n#;
        print TEMPFILE qq#        <minExtendsSize unit="KB">64</minExtendsSize>\n#;
        print TEMPFILE qq#        <logging>true</logging>\n#;
        print TEMPFILE qq#        <recoverable>false</recoverable>\n#;
        print TEMPFILE qq#        <maxFreeSpace>0</maxFreeSpace>\n#;
        print TEMPFILE qq#        <autoSegmentMgmt>true</autoSegmentMgmt>\n#;
        print TEMPFILE qq#        <bigfile>false</bigfile>\n#;
        print TEMPFILE qq#        <datafilesList>\n#;
        print TEMPFILE qq#           <TablespaceDatafileAttributes id="{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/sysaux01.dbf">\n#;
        print TEMPFILE qq#              <id>-1</id>\n#;
        print TEMPFILE qq#           </TablespaceDatafileAttributes>\n#;
        print TEMPFILE qq#        </datafilesList>\n#;
        print TEMPFILE qq#     </TablespaceAttributes>\n#;
        print TEMPFILE qq#     <TablespaceAttributes id="SYSTEM">\n#;
        print TEMPFILE qq#        <online>true</online>\n#;
        print TEMPFILE qq#        <offlineMode>1</offlineMode>\n#;
        print TEMPFILE qq#        <readOnly>false</readOnly>\n#;
        print TEMPFILE qq#        <temporary>false</temporary>\n#;
        print TEMPFILE qq#        <defaultTemp>false</defaultTemp>\n#;
        print TEMPFILE qq#        <undo>false</undo>\n#;
        print TEMPFILE qq#        <local>true</local>\n#;
        print TEMPFILE qq#        <blockSize>-1</blockSize>\n#;
        print TEMPFILE qq#        <allocation>3</allocation>\n#;
        print TEMPFILE qq#        <uniAllocSize unit="KB">-1</uniAllocSize>\n#;
        print TEMPFILE qq#        <initSize unit="KB">64</initSize>\n#;
        print TEMPFILE qq#        <increment unit="KB">64</increment>\n#;
        print TEMPFILE qq#        <incrementPercent>50</incrementPercent>\n#;
        print TEMPFILE qq#        <minExtends>1</minExtends>\n#;
        print TEMPFILE qq#        <maxExtends>-1</maxExtends>\n#;
        print TEMPFILE qq#        <minExtendsSize unit="KB">64</minExtendsSize>\n#;
        print TEMPFILE qq#        <logging>true</logging>\n#;
        print TEMPFILE qq#        <recoverable>false</recoverable>\n#;
        print TEMPFILE qq#        <maxFreeSpace>0</maxFreeSpace>\n#;
        print TEMPFILE qq#        <autoSegmentMgmt>true</autoSegmentMgmt>\n#;
        print TEMPFILE qq#        <bigfile>false</bigfile>\n#;
        print TEMPFILE qq#        <datafilesList>\n#;
        print TEMPFILE qq#           <TablespaceDatafileAttributes id="{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/system01.dbf">\n#;
        print TEMPFILE qq#              <id>-1</id>\n#;
        print TEMPFILE qq#           </TablespaceDatafileAttributes>\n#;
        print TEMPFILE qq#        </datafilesList>\n#;
        print TEMPFILE qq#     </TablespaceAttributes>\n#;
        print TEMPFILE qq#     <TablespaceAttributes id="TEMP">\n#;
        print TEMPFILE qq#        <online>true</online>\n#;
        print TEMPFILE qq#        <offlineMode>1</offlineMode>\n#;
        print TEMPFILE qq#        <readOnly>false</readOnly>\n#;
        print TEMPFILE qq#        <temporary>true</temporary>\n#;
        print TEMPFILE qq#        <defaultTemp>true</defaultTemp>\n#;
        print TEMPFILE qq#        <undo>false</undo>\n#;
        print TEMPFILE qq#        <local>true</local>\n#;
        print TEMPFILE qq#        <blockSize>-1</blockSize>\n#;
        print TEMPFILE qq#        <allocation>1</allocation>\n#;
        print TEMPFILE qq#        <uniAllocSize unit="KB">-1</uniAllocSize>\n#;
        print TEMPFILE qq#        <initSize unit="KB">64</initSize>\n#;
        print TEMPFILE qq#        <increment unit="KB">64</increment>\n#;
        print TEMPFILE qq#        <incrementPercent>0</incrementPercent>\n#;
        print TEMPFILE qq#        <minExtends>1</minExtends>\n#;
        print TEMPFILE qq#        <maxExtends>0</maxExtends>\n#;
        print TEMPFILE qq#        <minExtendsSize unit="KB">64</minExtendsSize>\n#;
        print TEMPFILE qq#        <logging>true</logging>\n#;
        print TEMPFILE qq#        <recoverable>false</recoverable>\n#;
        print TEMPFILE qq#        <maxFreeSpace>0</maxFreeSpace>\n#;
        print TEMPFILE qq#        <autoSegmentMgmt>true</autoSegmentMgmt>\n#;
        print TEMPFILE qq#        <bigfile>false</bigfile>\n#;
        print TEMPFILE qq#        <datafilesList>\n#;
        print TEMPFILE qq#           <TablespaceDatafileAttributes id="{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/temp01.dbf">\n#;
        print TEMPFILE qq#              <id>-1</id>\n#;
        print TEMPFILE qq#           </TablespaceDatafileAttributes>\n#;
        print TEMPFILE qq#        </datafilesList>\n#;
        print TEMPFILE qq#     </TablespaceAttributes>\n#;
        print TEMPFILE qq#     <TablespaceAttributes id="USERS">\n#;
        print TEMPFILE qq#        <online>true</online>\n#;
        print TEMPFILE qq#        <offlineMode>1</offlineMode>\n#;
        print TEMPFILE qq#        <readOnly>false</readOnly>\n#;
        print TEMPFILE qq#        <temporary>false</temporary>\n#;
        print TEMPFILE qq#        <defaultTemp>false</defaultTemp>\n#;
        print TEMPFILE qq#        <undo>false</undo>\n#;
        print TEMPFILE qq#        <local>true</local>\n#;
        print TEMPFILE qq#        <blockSize>-1</blockSize>\n#;
        print TEMPFILE qq#        <allocation>1</allocation>\n#;
        print TEMPFILE qq#        <uniAllocSize unit="KB">-1</uniAllocSize>\n#;
        print TEMPFILE qq#        <initSize unit="KB">128</initSize>\n#;
        print TEMPFILE qq#        <increment unit="KB">128</increment>\n#;
        print TEMPFILE qq#        <incrementPercent>0</incrementPercent>\n#;
        print TEMPFILE qq#        <minExtends>1</minExtends>\n#;
        print TEMPFILE qq#        <maxExtends>4096</maxExtends>\n#;
        print TEMPFILE qq#        <minExtendsSize unit="KB">128</minExtendsSize>\n#;
        print TEMPFILE qq#        <logging>true</logging>\n#;
        print TEMPFILE qq#        <recoverable>false</recoverable>\n#;
        print TEMPFILE qq#        <maxFreeSpace>0</maxFreeSpace>\n#;
        print TEMPFILE qq#        <autoSegmentMgmt>true</autoSegmentMgmt>\n#;
        print TEMPFILE qq#        <bigfile>false</bigfile>\n#;
        print TEMPFILE qq#        <datafilesList>\n#;
        print TEMPFILE qq#           <TablespaceDatafileAttributes id="{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/users01.dbf">\n#;
        print TEMPFILE qq#              <id>-1</id>\n#;
        print TEMPFILE qq#           </TablespaceDatafileAttributes>\n#;
        print TEMPFILE qq#        </datafilesList>\n#;
        print TEMPFILE qq#     </TablespaceAttributes>\n#;
        for (my $var = 0 ; $var < $#dbNodeName+1 ; $var++)
        {
            my $undonum = $var + 1;
            print TEMPFILE qq#      <DatafileAttributes id="{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/undotbs$undonum.dbf">\n#;
            print TEMPFILE qq#         <tablespace>UNDOTBS$undonum</tablespace>\n#;
            print TEMPFILE qq#         <temporary>false</temporary>\n#;
            print TEMPFILE qq#         <online>true</online>\n#;
            print TEMPFILE qq#         <status>0</status>\n#;
            print TEMPFILE qq#         <size unit="MB">$dbUndoSize</size>\n#;
            print TEMPFILE qq#         <reuse>true</reuse>\n#;
            print TEMPFILE qq#         <autoExtend>$dbFileExtend</autoExtend>\n#;
            print TEMPFILE qq#         <increment unit="MB">4096</increment>\n#;
            print TEMPFILE qq#         <maxSize unit="MB">-1</maxSize>\n#;
            print TEMPFILE qq#      </DatafileAttributes>\n#;
            print TEMPFILE qq#      <TablespaceAttributes id="UNDOTBS$undonum">\n#;
            print TEMPFILE qq#         <online>true</online>\n#;
            print TEMPFILE qq#         <offlineMode>1</offlineMode>\n#;
            print TEMPFILE qq#         <readOnly>false</readOnly>\n#;
            print TEMPFILE qq#         <temporary>false</temporary>\n#;
            print TEMPFILE qq#         <defaultTemp>false</defaultTemp>\n#;
            print TEMPFILE qq#         <undo>true</undo>\n#;
            print TEMPFILE qq#         <local>true</local>\n#;
            print TEMPFILE qq#         <blockSize>-1</blockSize>\n#;
            print TEMPFILE qq#         <allocation>1</allocation>\n#;
            print TEMPFILE qq#         <uniAllocSize unit="KB">-1</uniAllocSize>\n#;
            print TEMPFILE qq#         <initSize unit="KB">512</initSize>\n#;
            print TEMPFILE qq#         <increment unit="KB">512</increment>\n#;
            print TEMPFILE qq#         <incrementPercent>50</incrementPercent>\n#;
            print TEMPFILE qq#         <minExtends>8</minExtends>\n#;
            print TEMPFILE qq#         <maxExtends>4096</maxExtends>\n#;
            print TEMPFILE qq#         <minExtendsSize unit=\"KB\">512</minExtendsSize>\n#;
            print TEMPFILE qq#         <logging>true</logging>\n#;
            print TEMPFILE qq#         <recoverable>false</recoverable>\n#;
            print TEMPFILE qq#         <maxFreeSpace>0</maxFreeSpace>\n#;
            print TEMPFILE qq#         <datafilesList>\n#;
            print TEMPFILE qq#            <TablespaceDatafileAttributes id="{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/undotbs$undonum.dbf">\n#;
            print TEMPFILE qq#               <id>-1</id>\n#;
            print TEMPFILE qq#            </TablespaceDatafileAttributes>\n#;
            print TEMPFILE qq#         </datafilesList>\n#;
            print TEMPFILE qq#      </TablespaceAttributes>\n#;
            my $redoboase = $var * $dbRedoGroupNumber;
            for (my $var2 = 1 ; $var2 < ($dbRedoGroupNumber+1) ; $var2++)
             {
                 my $redogroupnumber = $redoboase + $var2;
                 my $redothread      = $var + 1;
                 print TEMPFILE qq#      <RedoLogGroupAttributes id="$redogroupnumber">\n#;
                 print TEMPFILE qq#         <reuse>false</reuse>\n#;
                 print TEMPFILE qq#         <fileSize unit="MB">$dbRedoSize</fileSize>\n#;
                 print TEMPFILE qq#         <Thread>$redothread</Thread>\n#;
                 print TEMPFILE qq#         <member ordinal="0" memberName="redo${redogroupnumber}.log" filepath="{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/"/>\n#;
                 print TEMPFILE qq#     </RedoLogGroupAttributes>\n#;
             }
      }
         print TEMPFILE qq#</StorageAttributes>\n#;
         print TEMPFILE qq#</DatabaseTemplate>\n#;
         printLog('D',"Copy template File to template Dir");
         #copy('template.dbt',"$oracleHome/assistants/dbca/templates/");
         `cp -f template.dbt "$oracleHome/assistants/dbca/templates/"`;
         printLog('E',"Failed *********Copy Template File*******") unless -f "$oracleHome/assistants/dbca/templates/template.dbt";
    }
}
sub dbCreateDbca{
    printLog('D',"Create Dbca Command");
    my $dbca;
    if ($dbVersion eq '11.2' or $dbVersion eq '11.1'){
       $dbca="dbca -createDatabase -silent  -gdbName  $dbName \\
              -sid $dbName -sysPassword $password -systemPassword $password  \\
              -characterSet $dbCharacset  -nationalCharacterSet AL16UTF16  \\
              -sampleSchema false -databaseType OLTP  \\
              -emConfiguration NONE -disableSecurityConfiguration NONE \\
              -redoLogFileSize $dbRedoSize -templateName template.dbt \\
              -memoryPercentage 30   ";
    }
    elsif($dbVersion eq '12.2' or $dbVersion eq '12.1'){
       $dbca="dbca  -createDatabase -silent  -ignorePreReqs  -gdbName $dbName \\
                -sid $dbName -sysPassword $password -systemPassword $password \\
                -characterSet $dbCharacset -nationalCharacterSet AL16UTF16  \\
                -sampleSchema false -databaseType OLTP \\
                -emConfiguration NONE  \\
                -redoLogFileSize $dbRedoSize  -templateName New_Database.dbt \\
                -dbOptions OMS:false,JSERVER:false,SPATIAL:false,IMEDIA:false,ORACLE_TEXT:false,SAMPLE_SCHEMA:false,CWMLITE:false,APEX:false,DV:false \\
                -memoryMgmtType AUTO_SGA"
    }
    if ($dbVersion eq '12.2'){
        $dbca=$dbca."  -useLocalUndoForPDBs true  "
    }
    if (@dbPdbName){
           my $pdbcount=@dbPdbName;
           $dbca=$dbca." -createAsContainerDatabase true  -numberOfPDBs $pdbcount -pdbName $dbPdbName  -pdbAdminPassword $password"
    }
    if ($dbType eq 'RAC' or $dbType eq 'rac'){
        $dbca=$dbca."  -nodelist $dbNodeList   ";
    }
    if ($dbStorageType eq 'asm' or $dbStorageType eq 'ASM')  {
        $dbca=$dbca."    -storageType ASM -diskGroupName $dbGroupName -recoveryGroupName    $dbFra"
    }
    else{
        $dbca=$dbca."    -storageType FS -datafileDestination $dbDirectory -recoveryAreaDestination $dbFra"
    }
   printLog('I',"$dbca");
   printLog('D',"Begin Exec Dbca Command");
   printLog('D',"For details check the logfiles at: $oracleBase/cfgtoollogs/dbca/$dbName");
  # my $output=`$dbca`;
   my $line;
   my $failed=0;
   my $success=0;
   if (!open(CMD, "$dbca 2>&1 |")) {
                printLog('E',"Failed Exec Dbca Create Database:$dbName");
   }
   else
   {
      while (<CMD>){
#        chomp($line=$_);
         printLog('I',"$_\n");
         if (/^ORA-\d{5}/){
            printLog('I',"$_");
            $failed=1;
         }
         elsif(/Completing Database Creation/){
            printLog('I',"$_");
            $success++;
         }
#         elsif (/DBCA_PROGRESS : 100%/){
#            printLog('D',"$_");
#            $success++;
#         }
         elsif (/for further details$/){
            printLog('I',"$_");
         }
      }
      if ($failed == 1){
          printLog('E',"Failed Exec Dbca Create Database:$dbName");
      }
      if ($success < 1){
          printLog('E',"Failed Exec Dbca Create Database:$dbName and Not Find ORA");
      }
      else{
        printLog('D',"Completed Database Creation");
      }
   }
}

sub dbChangeMemPara{
   my $isql;
   printLog('D',"Begin Change Database Memory Parameter");
   if (uc($dbMemManType) eq 'MANUAL'){
        $isql=qq#alter system set db_cache_size=${dbMemCacheSize}m scope=spfile;
                alter system set sga_target=${dbMemTarget}m scope=spfile;
                alter system set sga_max_size=${dbMemSgaMaxSize}m scope=spfile;
                alter system set shared_pool_size=${dbMemSharepoolSize}m scope=spfile;
                alter system set large_pool_size=${dbMemLargepoolSize}m scope=spfile;
                alter system set java_pool_size=${dbMemJavepoolSize}m scope=spfile;\n#;
   }
   else{
        $isql=qq# alter system set sga_target=${dbMemTarget}m scope=spfile;
                alter system set sga_max_size=${dbMemSgaMaxSize}m scope=spfile;\n#;
   }
   printLog('I',"$isql");
   execSql($isql);
   printLog('D',"End Change Database Memory Parameter");
}

sub dbChangeRacPara{
        if (uc($dbType) eq 'RAC'){
           printLog('D',"Begin Change Database Rac Parameter");
           my $isql=qq#alter system set "_clusterwide_global_transactions"=false scope=spfile;
             alter system set "_gc_policy_time"=0 scope=spfile;
             alter system set "_gc_undo_affinity"=false scope=spfile;
             alter system set parallel_force_local=true scope=spfile;\n#;
         printLog('I',"$isql");
   execSql($isql);
   printLog('D',"End Change Database Rac Parameter");
 }
}

sub dbChangePara{
   printLog('D',"Begin Change Database Parameter");
   my $isql;
   if ($dbVersion eq '11.2'){
   $isql=qq#alter system set O7_DICTIONARY_ACCESSIBILITY=FALSE scope=spfile;
              alter system set event='28401 trace name context forever,level 1','60025 trace name context forever','10943 trace name context forever,level 2097152','10949 trace name context forever,level 1','10262 trace name context forever, level 90000' scope=spfile;
              alter system set "_simple_view_merging"=true scope=spfile;
              alter system set parallel_adaptive_multi_user=false;
              alter system set sec_case_sensitive_logon=false;
              alter system set "_memory_imm_mode_without_autosga"=false scope=spfile;
              alter system set "_cursor_obsolete_threshold" =1000 scope=spfile;
              alter system set filesystemio_options=setall scope=spfile;
              alter system set "_partition_large_extents"=FALSE sid='*' scope=spfile;
              alter system set "_index_partition_large_extents"=FALSE sid='*' scope=spfile;
              alter system set audit_trail=none scope=spfile;
              alter system set resource_limit=true sid='*' scope=spfile;
              alter system set resource_manager_plan='FORCE:' sid='*' scope=spfile;
              alter system set "_optimizer_null_aware_antijoin"=false sid ='*' scope=spfile;
              alter system set deferred_segment_creation=false sid='*' scope=spfile;
              alter system set "_optimizer_use_feedback"=false  sid ='*' scope=spfile;
              alter system set "_optimizer_adaptive_cursor_sharing"=false sid='*' scope=spfile;
              alter system set "_optimizer_extended_cursor_sharing"=none sid='*' scope=spfile;
              alter system set "_optimizer_extended_cursor_sharing_rel"=none sid='*' scope=spfile;
              alter system set "_PX_use_large_pool"=true  sid ='*' scope=spfile;
              alter system set "_optimizer_mjc_enabled"=false scope=spfile;
              alter system set memory_target=0 scope=spfile;
              alter system set enable_ddl_logging=true scope=spfile;
              alter system set sec_max_failed_login_attempts=100 scope=spfile;
              alter system set "_undo_autotune"=false scope=spfile;
              alter system set "_sort_elimination_cost_ratio"=1 scope=spfile;
              alter system set  "_use_adaptive_log_file_sync"=false scope=spfile;
              alter system set "_optimizer_null_aware_antijoin"=false scope=spfile;
              alter system set "_b_tree_bitmap_plans"=false scope=spfile;
              alter system set undo_retention=10800;
              alter system set "_highthreshold_undoretention"=50000 scope=spfile;
              alter system set session_cached_cursors=400 scope=spfile;
              alter system set open_cursors=4000 scope=spfile;
              alter system set open_links=40 scope=spfile;
              alter system set open_links_per_instance=40 scope=spfile;
              alter system set db_files=2000 scope=spfile;
              alter system set control_file_record_keep_time=31 scope=spfile;
              alter system set shared_servers=0 scope=spfile;
              alter system set max_shared_servers=0 scope=spfile;
              alter system set "_serial_direct_read"=never;\n#;
    }
    elsif ($dbVersion eq '12.2'){
        $isql=qq#alter system set "_b_tree_bitmap_plans"=false                  scope=spfile;
             alter system set "_bloom_filter_enabled"=FALSE                 scope=spfile;
             alter system set "_cleanup_rollback_entries"=5000              scope=spfile;
             alter system set "_datafile_open_errors_crash_instance"=false  scope=spfile;
             alter system set "_datafile_write_errors_crash_instance"=false scope=spfile;
             alter system set "_cursor_obsolete_threshold" =100             scope=spfile;
             alter system set "_db_block_numa"=1                            scope=spfile;
             alter system set "_drop_stat_segment"=1                        scope=spfile;
             alter system set "_enable_pdb_close_abort"=true                scope=spfile;
             alter system set "_enable_pdb_close_noarchivelog"=false        scope=spfile;
             alter system set "_fix_control"='8611462:OFF'                  scope=spfile;
             alter system set "_gc_policy_time"=0                           scope=spfile;
             alter system set "_ges_direct_free_res_type"=CTARAHDXBB        scope=spfile;
             alter system set "_index_partition_large_extents"=FALSE        scope=spfile;
             alter system set "_keep_remote_column_size"=TRUE               scope=spfile;
             alter system set "_ktb_debug_flags"=8                          scope=spfile;
             alter system set "_library_cache_advice"=false                 scope=spfile;
             alter system set "_memory_imm_mode_without_autosga"=FALSE      scope=spfile;
             alter system set "_optimizer_ads_use_result_cache" = FALSE     scope=spfile;
             alter system set "_optimizer_aggr_groupby_elim"=FALSE          scope=spfile;
             alter system set "_optimizer_dsdir_usage_control"=0            scope=spfile;
             alter system set "_optimizer_adaptive_cursor_sharing"=false    scope=spfile;
             alter system set "_optimizer_extended_cursor_sharing"=none     scope=spfile;
             alter system set "_optimizer_extended_cursor_sharing_rel"=none scope=spfile;
             alter system set "_optimizer_mjc_enabled"=FALSE                scope=spfile;
             alter system set "_optimizer_null_accepting_semijoin"=false    scope=spfile;
             alter system set "_optimizer_null_aware_antijoin"=false        scope=spfile;
             alter system set "_optimizer_reduce_groupby_key"=FALSE         scope=spfile;
             alter system set "_optimizer_unnest_scalar_sq"=false           scope=spfile;
             alter system set "_optimizer_use_feedback"=false               scope=spfile;
             alter system set "_part_access_version_by_number"=FALSE        scope=spfile;
             alter system set "_partition_large_extents"=FALSE              scope=spfile;
             alter system set "_partition_large_extents"=FALSE              scope=spfile;
             alter system set "_px_use_large_pool"=true                     scope=spfile;
             alter system set "_report_capture_cycle_time"=0                scope=spfile;
             alter system set "_rollback_segment_count"=2000                scope=spfile;
             alter system set "_serial_direct_read"=never                   scope=spfile;
             alter system set "_sort_elimination_cost_ratio"=1              scope=spfile;
             alter system set "_sql_plan_directive_mgmt_control"=0          scope=spfile;
             alter system set "_sys_logon_delay"=0                          scope=spfile;
             alter system set "_undo_autotune"=false                        scope=spfile;
             alter system set "_use_adaptive_log_file_sync"=FALSE           scope=spfile;
             alter system set "_use_single_log_writer"=true                 scope=spfile;
             alter system set audit_trail=none                              scope=spfile;
             alter system set autotask_max_active_pdbs=10                   scope=spfile;
             alter system set cell_offload_processing=false                 scope=spfile;
             alter system set control_file_record_keep_time=31              scope=spfile;
             alter system set db_cache_advice=off                           scope=spfile;
             alter system set db_files=5000                                 scope=spfile;
             alter system set deferred_segment_creation=false               scope=spfile;
             alter system set enable_ddl_logging=true                       scope=spfile;
             alter system set event='28401 trace name context forever,level 1','60025 trace name context forever','10943 trace name context forever,level 2097152','10949 trace name context forever,level 1','10262 trace name context forever, level 90000' scope=spfile;
             alter system set filesystemio_options=setall                   scope=spfile;
             alter system set max_shared_servers=0                          scope=spfile;
             alter system set memory_target=0                               scope=spfile;
             alter system set open_cursors=3000                             scope=spfile;
             alter system set open_links =40                                 scope=spfile;
             alter system set open_links_per_instance =40                   scope=spfile;
             alter system set optimizer_adaptive_plans=FALSE                scope=spfile;
             alter system set parallel_force_local=true                     scope=spfile;
             alter system set pga_aggregate_limit=0                         scope=spfile;
             alter system set resource_manager_plan='FORCE:'                scope=spfile;
             alter system set result_cache_max_size=0                       scope=spfile;
             alter system set sec_max_failed_login_attempts=100             scope=spfile;
             alter system set session_cached_cursors=300                    scope=spfile;
             alter system set shared_servers=0                              scope=spfile;
             alter system set temp_undo_enabled=false                       scope=spfile;
             alter system set undo_retention=10800                          scope=spfile;\n#;
    }
   printLog('I',"$isql");
   execSql($isql);
   printLog('D',"End Change Database Parameter");
}


sub dbChangeJob{
   printLog('D',"Begin Change Database Job Info");
   my $isql=qq#exec dbms_scheduler.disable('ORACLE_OCM.MGMT_CONFIG_JOB');
               exec dbms_scheduler.disable('ORACLE_OCM.MGMT_STATS_CONFIG_JOB');

               BEGIN
               DBMS_AUTO_TASK_ADMIN.DISABLE(
               client_name => 'auto space advisor',
               operation => NULL,
               window_name => NULL);
               END;
               /
               BEGIN
               DBMS_AUTO_TASK_ADMIN.DISABLE(
               client_name => 'sql tuning advisor',
               operation => NULL,
               window_name => NULL);
               END;
               /

               EXECUTE DBMS_SCHEDULER.SET_ATTRIBUTE('SATURDAY_WINDOW','repeat_interval','freq=daily;byday=SAT;byhour=22;byminute=0; bysecond=0');
               EXECUTE DBMS_SCHEDULER.SET_ATTRIBUTE('SATURDAY_WINDOW','duration','+000 04:00:00');
               EXECUTE DBMS_SCHEDULER.SET_ATTRIBUTE('SUNDAY_WINDOW','repeat_interval','freq=daily;byday=SUN;byhour=22;byminute=0; bysecond=0');
               EXECUTE DBMS_SCHEDULER.SET_ATTRIBUTE('SUNDAY_WINDOW','duration','+000 04:00:00');\n#;
   printLog('I',"$isql");
   execSql($isql);
   printLog('D',"End Change Database Job Info");
}

sub dbChangeProfile{
   printLog('D',"Begin Change Database Profile Info");
   my $isql=qq#alter profile "DEFAULT" limit PASSWORD_GRACE_TIME UNLIMITED;
               alter profile "DEFAULT" limit PASSWORD_LIFE_TIME UNLIMITED;
               alter profile "DEFAULT" limit PASSWORD_LOCK_TIME UNLIMITED;
               alter profile "DEFAULT" limit FAILED_LOGIN_ATTEMPTS UNLIMITED;\n#;
   printLog('I',"$isql");
   execSql($isql);
   printLog('D',"End Change Database Profile Info");
}

sub dbChangeAwr{
   printLog('D',"Begin Change Database Awr Info");
   my $isql=qq#EXEC DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS(RETENTION=>64800,INTERVAL=>30);
               EXEC DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS(topnsql => 30);
               exit;\n#;
   printLog('I',"$isql");
   execSql($isql);
   printLog('D',"End Change Database Awr Info");
}

sub dbResizeFile{

  printLog('D',"Begin Resize Datafile To custom Value");
  my $isql=qq# set verify off serveroutput on
                     DECLARE
                        v_tbname       VARCHAR2 (100);
                        v_sql          VARCHAR2 (3000);
                        v_sql1         VARCHAR2 (1000);
                        v_freemb       NUMBER;
                        v_count        NUMBER;
                        v_tbsize       NUMBER;
                        v_filenumber   NUMBER;
                        v_autocount    NUMBER;
                        v_pathtype     VARCHAR2 (100);
                        v_table        VARCHAR2 (20);
                        v_systemsize   NUMBER := ${dbSystemSize};
                        v_sysauxsize   NUMBER := ${dbSysauxSize};
                        v_othersize    NUMBER := ${dbUndoSize};
                        v_size         NUMBER;
                     BEGIN
                        FOR c_tb IN (SELECT tablespace_name, a.contents
                                       FROM dba_tablespaces a
                                      WHERE    a.tablespace_name IN ('SYSTEM',
                                                                     'SYSAUX',
                                                                     'TEMP',
                                                                     'USERS')
                                            OR a.contents = 'UNDO')
                        LOOP
                           IF c_tb.contents NOT IN ('TEMPORARY')
                           THEN
                              SELECT SUM (bytes)
                                INTO v_tbsize
                                FROM dba_data_files a
                               WHERE a.tablespace_name = c_tb.tablespace_name;

                              IF c_tb.tablespace_name = 'SYSTEM'
                              THEN
                                 v_size := v_systemsize;
                              ELSIF c_tb.tablespace_name = 'SYSAUX'
                              THEN
                                 v_size := v_sysauxsize;
                              ELSIF c_tb.tablespace_name = 'USERS'
                              THEN
                                 SELECT MIN (bytes)
                                   INTO v_size
                                   FROM dba_data_files
                                  WHERE tablespace_name = 'USERS';
                              ELSIF c_tb.contents IN ('UNDO')
                              THEN
                                 v_size := v_othersize;
                              END IF;

                              SELECT COUNT (*)
                                INTO v_autocount
                                FROM dba_data_files a
                               WHERE     a.tablespace_name = c_tb.tablespace_name
                                     AND a.autoextensible = 'YES';

                              v_sql := 'alter database datafile ';
                           ELSIF c_tb.contents IN ('TEMPORARY')
                           THEN
                              v_size := v_othersize;

                              SELECT SUM (a.bytes)
                                INTO v_tbsize
                                FROM dba_temp_files a
                               WHERE a.tablespace_name = c_tb.tablespace_name;

                              SELECT COUNT (*)
                                INTO v_autocount
                                FROM dba_temp_files a
                               WHERE     a.tablespace_name = c_tb.tablespace_name
                                     AND a.autoextensible = 'YES';

                              v_sql := 'alter database tempfile ';
                           END IF;

                           IF v_tbsize < v_size
                           THEN
                              IF c_tb.contents IN ('TEMPORARY')
                              THEN
                                 SELECT MIN (file_id)
                                   INTO v_filenumber
                                   FROM dba_temp_files a
                                  WHERE a.tablespace_name = c_tb.tablespace_name;
                              ELSE
                                 SELECT MIN (file_id)
                                   INTO v_filenumber
                                   FROM dba_data_files a
                                  WHERE a.tablespace_name = c_tb.tablespace_name;
                              END IF;

                              v_sql1 := v_sql || v_filenumber || ' resize ' || v_size;
                              DBMS_OUTPUT.put_line (v_sql1);

                              EXECUTE IMMEDIATE v_sql1;
                           END IF;

                           IF v_autocount > 0
                           THEN
                              IF c_tb.contents IN ('TEMPORARY')
                              THEN
                                 FOR c_datafile
                                    IN (SELECT file_id
                                          FROM dba_temp_files a
                                         WHERE a.tablespace_name = c_tb.tablespace_name)
                                 LOOP
                                    v_sql1 := v_sql || c_datafile.file_id || ' autoextend off';
                                    DBMS_OUTPUT.put_line (v_sql1);

                                    EXECUTE IMMEDIATE v_sql1;
                                 END LOOP;
                              ELSE
                                 FOR c_datafile
                                    IN (SELECT file_id
                                          FROM dba_data_files a
                                         WHERE a.tablespace_name = c_tb.tablespace_name)
                                 LOOP
                                    v_sql1 := v_sql || c_datafile.file_id || ' autoextend off';
                                    DBMS_OUTPUT.put_line (v_sql1);

                                    EXECUTE IMMEDIATE v_sql1;
                                 END LOOP;
                              END IF;
                           END IF;
                        END LOOP;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           DBMS_OUTPUT.PUT_LINE (SQLCODE || '---' || SQLERRM);
                     END;
                     / \n#;
     printLog('D',"Begin Resize Datafile To custom Value In CDB or Database");
     printLog('I',"$isql");
     execSql($isql);
     if ($dbVersion eq '12.1' or $dbVersion eq '12.2') {
        if (@dbPdbName){
          my $pdbname;
          foreach $pdbname (@dbPdbName){
             printLog('D',"Begin Resize Datafile To custom Value In Pdb :$pdbname");
             my $pdbisql="alter session set container=${pdbname};\n".$isql;
             printLog('I',"$pdbisql");
             execSql($pdbisql);
             printLog('D',"Finish Resize Datafile To custom Value In Pdb :$pdbname");
          }
        }
     }
}

sub dbAnquan1{
  printLog('D',"Begin Run Anquan Scrips In CDB or Database");
  printLog('D',"Begin Run Anquan Scrips Change o7_dictionary_accessibility In CDB or Database");
  my $isql=qq#set lines 200 serveroutput on
           /* modify o7_dictionary_accessibility*/
           DECLARE
              i_sql   VARCHAR2 (1000);
           BEGIN
              FOR c_value IN (SELECT VALUE
                                FROM v\\\$parameter
                               WHERE name = 'O7_DICTIONARY_ACCESSIBILITY' and value not in ('FALSE'))
              LOOP
                 DBMS_OUTPUT.put_line ('modify o7_dictionary_accessibility to false');

                 EXECUTE IMMEDIATE
                    'ALTER SYSTEM SET O7_DICTIONARY_ACCESSIBILITY=FALSE scope=spfile';
              END LOOP;
           END;
           / \n #;
     printLog('I',"$isql");
     execSql($isql);
     if ($dbVersion eq '12.1' or $dbVersion eq '12.2') {
        if (@dbPdbName){
          my $pdbname;
          foreach $pdbname (@dbPdbName){
             printLog('D',"Begin Run Anquan Scrips Change o7_dictionary_accessibility  In Pdb :$pdbname");
             my $pdbisql="alter session set container=${pdbname};\n".$isql;
             printLog('I',"$pdbisql");
             execSql($pdbisql);
             printLog('D',"Finish Run Anquan Scrips Change o7_dictionary_accessibility  In Pdb :$pdbname");
          }
        }
     }
}
sub dbAnquan2{
  printLog('D',"Begin Run Anquan Scrips Change User Passwd with Default In CDB or Database");
  my $isql=qq#
           DECLARE
              i_sql        VARCHAR2 (1000);
              i_password   VARCHAR2 (100) := 'W34ewr\#d';
           BEGIN
              DBMS_OUTPUT.put_line ('modify username password with default password');

              FOR c_value IN (SELECT username
                                FROM DBA_USERS_WITH_DEFPWD where username not in ('XS\$NULL'))
              LOOP
                 DBMS_OUTPUT.put_line (
                    'modify ' || c_value.username || ' password to ' || i_password);
                 i_sql :=
                       'alter user '
                    || c_value.username
                    || ' identified by "'
                    || i_password
                    || '"';
                 DBMS_OUTPUT.put_line (i_sql);

                 EXECUTE IMMEDIATE i_sql;
              END LOOP;
           END;
           / \n#;
     printLog('I',"$isql");
     execSql($isql);
     if ($dbVersion eq '12.1' or $dbVersion eq '12.2') {
        if (@dbPdbName){
          my $pdbname;
          foreach $pdbname (@dbPdbName){
             printLog('D',"Begin Run Anquan Scrips Change User Passwd with Default In Pdb :$pdbname");
             my $pdbisql="alter session set container=${pdbname};\n".$isql;
             printLog('I',"$pdbisql");
             execSql($pdbisql);
             printLog('D',"Finish Run Anquan Scrips Change User Passwd with Default In Pdb :$pdbname");
          }
        }
     }
 }

 sub dbAnquan3{
     printLog('D',"Begin Run Anquan Scrips Create Funcation For password In CDB or Database");
       my $isql=qq# DECLARE
               i_count   NUMBER;
           BEGIN
               SELECT COUNT (*)
                 INTO i_count
                 FROM dba_objects
                WHERE     object_name = UPPER ('password_verify_function')
                      AND owner = 'SYS'
                      AND object_type = 'FUNCTION';

               IF i_count = 0
               THEN
                   EXECUTE IMMEDIATE
                       '
           CREATE FUNCTION password_verify_function (
              username        VARCHAR2,
              password        VARCHAR2,
              old_password    VARCHAR2)
              RETURN BOOLEAN
           IS
              n                 BOOLEAN;
              m                 INTEGER;
              differ            INTEGER;
              isdigit           BOOLEAN;
              ischar            BOOLEAN;
              ispunct           BOOLEAN;
              db_name           VARCHAR2 (40);
              digitarray        VARCHAR2 (20);
              punctarray        VARCHAR2 (25);
              chararray         VARCHAR2 (52);
              chararray1        VARCHAR2 (52);
              chararray2        VARCHAR2 (52);
              i_char            VARCHAR2 (10);
              simple_password   VARCHAR2 (10);
              reverse_user      VARCHAR2 (32);
           BEGIN
              digitarray := ''0123456789'';
              chararray := ''abcdefghijklmnopqrstuvwxyz'';
              chararray1 := ''ABCDEFGHIJKLMNOPQRSTUVWXYZ'';
              chararray2 := ''~\!\#\\\$^&*()_+'';

              -- Check for the minimum length of the password
              IF LENGTH (password) < 8
              THEN
                 raise_application_error (-20001, ''Password length less than 8'');
              END IF;


              -- Check if the password is same as the username or username(1-100)
              IF NLS_LOWER (password) = NLS_LOWER (username)
              THEN
                 raise_application_error (-20002, ''Password same as or similar to user'');
              END IF;

              FOR i IN 1 .. 100
              LOOP
                 i_char := TO_CHAR (i);

                 IF NLS_LOWER (username) || i_char = NLS_LOWER (password)
                 THEN
                    raise_application_error (
                       -20005,
                       ''Password same as or similar to user name '');
                 END IF;
              END LOOP;

              -- Check if the password is same as the username reversed

              FOR i IN REVERSE 1 .. LENGTH (username)
              LOOP
                 reverse_user := reverse_user || SUBSTR (username, i, 1);
              END LOOP;

              IF NLS_LOWER (password) = NLS_LOWER (reverse_user)
              THEN
                 raise_application_error (-20003, ''Password same as username reversed'');
              END IF;

              -- Check if the password is the same as server name and or servername(1-100)
              SELECT name INTO db_name FROM sys.v\$database;

              IF NLS_LOWER (db_name) = NLS_LOWER (password)
              THEN
                 raise_application_error (-20004,
                                          ''Password same as or similar to server name'');
              END IF;

              FOR i IN 1 .. 100
              LOOP
                 i_char := TO_CHAR (i);

                 IF NLS_LOWER (db_name) || i_char = NLS_LOWER (password)
                 THEN
                    raise_application_error (
                       -20005,
                       ''Password same as or similar to server name '');
                 END IF;
              END LOOP;

              -- Check if the password is too simple. A dictionary of words may be
              -- maintained and a check may be made so as not to allow the words
              -- that are too simple for the password.
              IF NLS_LOWER (password) IN (''welcome1'',
                                          ''database1'',
                                          ''account1'',
                                          ''user1234'',
                                          ''password1'',
                                          ''oracle123'',
                                          ''computer1'',
                                          ''abcdefg1'',
                                          ''change_on_install'')
              THEN
                 raise_application_error (-20006, ''Password too simple'');
              END IF;

              -- Check if the password is the same as oracle (1-100)
              simple_password := ''oracle'';

              FOR i IN 1 .. 100
              LOOP
                 i_char := TO_CHAR (i);

                 IF simple_password || i_char = NLS_LOWER (password)
                 THEN
                    raise_application_error (-20007, ''Password too simple '');
                 END IF;
              END LOOP;

              -- Check if the password contains at least one letter, one digit
              -- 1. Check for the digit
              isdigit := FALSE;
              m := LENGTH (password);

              FOR i IN 1 .. 10
              LOOP
                 FOR j IN 1 .. m
                 LOOP
                    IF SUBSTR (password, j, 1) = SUBSTR (digitarray, i, 1)
                    THEN
                       isdigit := TRUE;
                       GOTO findchar;
                    END IF;
                 END LOOP;
              END LOOP;

              IF isdigit = FALSE
              THEN
                 raise_application_error (
                    -20008,
                    ''Password must contain at least one digit,one character,one upper character,one special character'');
              END IF;

             -- 2. Check for the character
             <<findchar>>
              ischar := FALSE;

              FOR i IN 1 .. LENGTH (chararray)
              LOOP
                 FOR j IN 1 .. m
                 LOOP
                    IF SUBSTR (password, j, 1) = SUBSTR (chararray, i, 1)
                    THEN
                       ischar := TRUE;
                       GOTO findchar1;
                    END IF;
                 END LOOP;
              END LOOP;

              IF ischar = FALSE
              THEN
                 raise_application_error (-20009, ''Password must contain at least one digit,one character,one upper character,one special character'');
              END IF;

             <<findchar1>>
              ischar := FALSE;

              FOR i IN 1 .. LENGTH (chararray1)
              LOOP
                 FOR j IN 1 .. m
                 LOOP
                    IF SUBSTR (password, j, 1) = SUBSTR (chararray1, i, 1)
                    THEN
                       ischar := TRUE;
                       GOTO findchar2;
                    END IF;
                 END LOOP;
              END LOOP;

              IF ischar = FALSE
              THEN
                 raise_application_error (-20009, ''Password must contain at least one digit,one character,one upper character,one special character'');
              END IF;

             <<findchar2>>
              ischar := FALSE;

              FOR i IN 1 .. LENGTH (chararray2)
              LOOP
                 FOR j IN 1 .. m
                 LOOP
                    IF SUBSTR (password, j, 1) = SUBSTR (chararray2, i, 1)
                    THEN
                       ischar := TRUE;
                       GOTO endsearch;
                    END IF;
                 END LOOP;
              END LOOP;

              IF ischar = FALSE
              THEN
                 raise_application_error (-20009, ''Password must contain at least one digit,one character,one upper character,one special character'');
              END IF;
             <<endsearch>>
              -- Check if the password differs from the previous password by at least
              -- 3 letters
              IF old_password IS NOT NULL
              THEN
                 differ := LENGTH (old_password) - LENGTH (password);

                 differ := ABS (differ);

                 IF differ < 3
                 THEN
                    IF LENGTH (password) < LENGTH (old_password)
                    THEN
                       m := LENGTH (password);
                    ELSE
                       m := LENGTH (old_password);
                    END IF;

                    FOR i IN 1 .. m
                    LOOP
                       IF SUBSTR (password, i, 1) \!= SUBSTR (old_password, i, 1)
                       THEN
                          differ := differ + 1;
                       END IF;
                    END LOOP;

                    IF differ < 3
                    THEN
                       raise_application_error (-20011,
                                                ''Password should differ from the \
                       old password by at least 3 characters'');
                    END IF;
                 END IF;
              END IF;

              -- Everything is fine; return TRUE ;
              RETURN (TRUE);
           END;
           '        ;
               ELSE
                   DBMS_OUTPUT.put_line ('password_verify_function is exists');
               END IF;
           END;
           / \n#;
     printLog('I',"$isql");
     execSql($isql);
     if ($dbVersion eq '12.1' or $dbVersion eq '12.2') {
        if (@dbPdbName){
          my $pdbname;
          foreach $pdbname (@dbPdbName){
             printLog('D',"Begin Run Anquan Scrips Create Profile In Pdb :$pdbname");
             my $pdbisql="alter session set container=${pdbname};\n".$isql;
             printLog('I',"$pdbisql");
             execSql($pdbisql);
             printLog('D',"Finish Run Anquan Scrips Create Profile In Pdb :$pdbname");
          }
        }
     }
 }

sub dbAnquan4{
  printLog('D',"Begin Run Anquan Scrips Create Profile In CDB or Database");
  my $isql=qq#
           DECLARE
               i_sql       VARCHAR2 (1000);
               i_count     NUMBER;
               i_version   VARCHAR2 (12);
               i_pdbname   VARCHAR2 (100);
           BEGIN
               SELECT SUBSTR (banner, INSTR (banner, '.', 1) - 2, 8)
                 INTO i_version
                 FROM v\\\$version
                WHERE banner LIKE 'Oracle Database%';

               SELECT COUNT (*)
                 INTO i_count
                 FROM dba_objects a
                WHERE     a.owner = 'SYS'
                      AND a.object_name = UPPER ('password_verify_function')
                      AND a.object_type = 'FUNCTION';

               IF i_count > 0
               THEN
                   IF i_version IN ('12.1.0.2', '12.1.0.1', '12.2.0.1')
                   THEN
                       SELECT SYS_CONTEXT ('USERENV', 'CON_NAME')
                         INTO i_pdbname
                         FROM DUAL;

                       IF i_pdbname = 'CDB\\\$ROOT'
                       THEN
                           SELECT COUNT (*)
                             INTO i_count
                             FROM dba_profiles
                            WHERE profile = UPPER ('C\#\#PROFILE_USER');
                       ELSE
                           SELECT COUNT (*)
                             INTO i_count
                             FROM dba_profiles
                            WHERE profile = UPPER ('PROFILE_USER');
                       END IF;
                   ELSE
                       SELECT COUNT (*)
                         INTO i_count
                         FROM dba_profiles
                        WHERE profile = UPPER ('PROFILE_USER');
                   END IF;

                   IF i_count < 1
                   THEN
                       IF i_version IN ('12.1.0.2', '12.1.0.1', '12.2.0.1')
                       THEN
                           SELECT SYS_CONTEXT ('USERENV', 'CON_NAME')
                             INTO i_pdbname
                             FROM DUAL;

                           IF i_pdbname = 'CDB\\\$ROOT'
                           THEN
                               i_sql :=
                                   'create PROFILE c\#\#profile_user LIMIT  PASSWORD_LIFE_TIME 80  PASSWORD_GRACE_TIME 10  PASSWORD_REUSE_TIME 360   PASSWORD_REUSE_MAX 3  FAILED_LOGIN_ATTEMPTS 5  PASSWORD_LOCK_TIME 20 PASSWORD_VERIFY_FUNCTION  PASSWORD_VERIFY_FUNCTION';
                            ELSE
                               i_sql :=
                                   'create PROFILE profile_user LIMIT  PASSWORD_LIFE_TIME 80  PASSWORD_GRACE_TIME 10  PASSWORD_REUSE_TIME 360   PASSWORD_REUSE_MAX 3  FAILED_LOGIN_ATTEMPTS 5  PASSWORD_LOCK_TIME 20 PASSWORD_VERIFY_FUNCTION password_verify_function';
                           END IF;
                       ELSE
                           i_sql :=
                               'create PROFILE profile_user LIMIT  PASSWORD_LIFE_TIME 80  PASSWORD_GRACE_TIME 10  PASSWORD_REUSE_TIME 360   PASSWORD_REUSE_MAX 3  FAILED_LOGIN_ATTEMPTS 5  PASSWORD_LOCK_TIME 20 PASSWORD_VERIFY_FUNCTION password_verify_function';
                       END IF;

                       DBMS_OUTPUT.put_line (i_sql);

                       EXECUTE IMMEDIATE i_sql;
                   END IF;

                   IF i_version IN ('12.1.0.2', '12.1.0.1', '12.2.0.1')
                   THEN
                       SELECT SYS_CONTEXT ('USERENV', 'CON_NAME')
                         INTO i_pdbname
                         FROM DUAL;

                       IF i_pdbname = 'CDB\\\$ROOT'
                       THEN
                           FOR c_value
                               IN (SELECT profile
                                     FROM dba_profiles
                                    WHERE     resource_name = 'PASSWORD_VERIFY_FUNCTION'
                                          AND LIMIT NOT IN ('PASSWORD_VERIFY_FUNCTION'))
                           LOOP
                               i_sql :=
                                      'alter profile '
                                   || c_value.profile
                                   || ' LIMIT PASSWORD_VERIFY_FUNCTION c\#\#password_verify_function';
                               DBMS_OUTPUT.put_line (i_sql);

                               EXECUTE IMMEDIATE i_sql;
                           END LOOP;
                       ELSE
                           FOR c_value
                               IN (SELECT profile
                                     FROM dba_profiles
                                    WHERE     resource_name = 'PASSWORD_VERIFY_FUNCTION'
                                          AND profile NOT LIKE 'C\#\#P%'
                                          AND LIMIT NOT IN ('PASSWORD_VERIFY_FUNCTION'))
                           LOOP
                               i_sql :=
                                      'alter profile '
                                   || c_value.profile
                                   || ' LIMIT PASSWORD_VERIFY_FUNCTION password_verify_function';
                               DBMS_OUTPUT.put_line (i_sql);

                               EXECUTE IMMEDIATE i_sql;
                           END LOOP;
                       END IF;
                   ELSE
                       FOR c_value
                           IN (SELECT profile
                                 FROM dba_profiles
                                WHERE     resource_name = 'PASSWORD_VERIFY_FUNCTION'
                                      AND LIMIT NOT IN ('PASSWORD_VERIFY_FUNCTION'))
                       LOOP
                           i_sql :=
                                  'alter profile '
                               || c_value.profile
                               || ' LIMIT PASSWORD_VERIFY_FUNCTION password_verify_function';
                           DBMS_OUTPUT.put_line (i_sql);

                           EXECUTE IMMEDIATE i_sql;
                       END LOOP;
                   END IF;
               END IF;
           END;
           / \n#;
     printLog('I',"$isql");
     execSql($isql);
     if ($dbVersion eq '12.1' or $dbVersion eq '12.2') {
        if (@dbPdbName){
          my $pdbname;
          foreach $pdbname (@dbPdbName){
             printLog('D',"Begin Run Anquan Scrips Create Profile In Pdb :$pdbname");
             my $pdbisql="alter session set container=${pdbname};\n".$isql;
             printLog('I',"$pdbisql");
             execSql($pdbisql);
             printLog('D',"Finish Run Anquan Scrips Create Profile In Pdb :$pdbname");
          }
        }
     }
 }

sub dbAnquan5{
  printLog('D',"Begin Run Anquan Scrips Alter User profile with Default User In CDB or Database");
  my $isql=qq#
           DECLARE
              i_sql     VARCHAR2 (1000);
              i_count   NUMBER;
           BEGIN
              DBMS_OUTPUT.put_line ('modify username profile with default profile');

              SELECT COUNT (*)
                INTO i_count
                FROM dba_profiles
               WHERE profile = UPPER ('PROFILE_USER');

              IF i_count > 0
              THEN
                 FOR c_value
                    IN (SELECT username
                          FROM dba_users
                         WHERE     profile NOT IN ('PROFILE_USER')
                               AND account_status IN
                                      ('LOCKED', 'EXPIRED ' || CHR (38) || ' LOCKED')
                               AND username NOT IN ('DBSNMP', 'XS\$NULL')
                               AND username IN ('OLAPSYS',
                                                'SI_INFORMTN_SCHEMA',
                                                'MGMT_VIEW',
                                                'OWBSYS',
                                                'ORDPLUGINS',
                                                'SPATIAL_WFS_ADMIN_USR',
                                                'SPATIAL_CSW_ADMIN_USR',
                                                'XDB',
                                                'SYSMAN',
                                                'APEX_PUBLIC_USER',
                                                'DIP',
                                                'OUTLN',
                                                'ANONYMOUS',
                                                'CTXSYS',
                                                'ORDDATA',
                                                'MDDATA',
                                                'OWBSYS_AUDIT',
                                                'APEX_030200',
                                                'XS\$NULL',
                                                'APPQOSSYS',
                                                'ORACLE_OCM',
                                                'WMSYS',
                                                'SCOTT',
                                                'DBSNMP',
                                                'EXFSYS',
                                                'ORDSYS',
                                                'MDSYS',
                                                'FLOWS_FILES',
                                                'SYSTEM'))
                 LOOP
                    DBMS_OUTPUT.put_line (
                       'modify ' || c_value.username || ' profile to PROFILE_USER ');
                    i_sql :=
                       'alter user "' || c_value.username || '" profile profile_user';
                    DBMS_OUTPUT.put_line (i_sql);

                    EXECUTE IMMEDIATE i_sql;
                 END LOOP;

                 EXECUTE IMMEDIATE 'alter user system profile profile_user';
                 select count(*) into i_count from v\\\$dataguard_config where db_unique_name not in (select db_unique_name from v\\\$database);
                 if i_count=0 then
                 EXECUTE IMMEDIATE 'alter user sys profile profile_user';
                 end if;
              END IF;
           END;
           / \n#;

     printLog('I',"$isql");
     execSql($isql);
     if ($dbVersion eq '12.1' or $dbVersion eq '12.2') {
        if (@dbPdbName){
          my $pdbname;
          foreach $pdbname (@dbPdbName){
             printLog('D',"Begin Run Anquan Scrips Alter User profile with Default User In Pdb :$pdbname");
             my $pdbisql="alter session set container=${pdbname};\n".$isql;
             printLog('I',"$pdbisql");
             execSql($pdbisql);
             printLog('D',"Finish Run Anquan Scrips Alter User profile with Default User In Pdb :$pdbname");
          }
        }
     }
 }



 sub dbAnquan6{
  printLog('D',"Begin Run Anquan Scrips Alter User profile with Default User In CDB or Database");
  my $isql=qq#          DECLARE
              i_sql     VARCHAR2 (1000);
              i_count   NUMBER;
           BEGIN
              SELECT COUNT (*)
                INTO i_count
                FROM dba_objects a
               WHERE     a.owner = 'SYS'
                     AND a.object_name = UPPER ('password_verify_function')
                     AND a.object_type = 'FUNCTION';

              IF i_count > 0
              THEN
                 SELECT COUNT (*)
                   INTO i_count
                   FROM dba_profiles
                  WHERE     profile = 'DEFAULT'
                        AND (   (    resource_name = 'PASSWORD_LIFE_TIME'
                                 AND LIMIT NOT IN ('UNLIMITED'))
                             OR (    resource_name = 'FAILED_LOGIN_ATTEMPTS'
                                 AND LIMIT NOT IN ('UNLIMITED'))
                             OR (    resource_name = 'PASSWORD_REUSE_MAX'
                                 AND LIMIT NOT IN ('10'))
                             OR (    resource_name = 'PASSWORD_VERIFY_FUNCTION'
                                 AND LIMIT NOT IN ('PASSWORD_VERIFY_FUNCTION'))
                             OR (    resource_name = 'PASSWORD_LOCK_TIME'
                                 AND LIMIT NOT IN ('UNLIMITED'))
                             OR (    resource_name = 'PASSWORD_GRACE_TIME'
                                 AND LIMIT NOT IN ('UNLIMITED')));

                 IF i_count > 0
                 THEN
                    FOR c_value
                       IN (SELECT resource_name
                             INTO i_count
                             FROM dba_profiles
                            WHERE     profile = 'DEFAULT'
                                  AND (   (    resource_name = 'PASSWORD_LIFE_TIME'
                                           AND LIMIT NOT IN ('UNLIMITED'))
                                       OR (    resource_name = 'FAILED_LOGIN_ATTEMPTS'
                                           AND LIMIT NOT IN ('UNLIMITED'))
                                       OR (    resource_name = 'PASSWORD_REUSE_MAX'
                                           AND LIMIT NOT IN ('10'))
                                       OR (    resource_name =
                                                  'PASSWORD_VERIFY_FUNCTION'
                                           AND LIMIT NOT IN ('PASSWORD_VERIFY_FUNCTION'))
                                       OR (    resource_name = 'PASSWORD_LOCK_TIME'
                                           AND LIMIT NOT IN ('UNLIMITED'))
                                       OR (    resource_name = 'PASSWORD_GRACE_TIME'
                                           AND LIMIT NOT IN ('UNLIMITED'))))
                    LOOP
                       IF c_value.resource_name = 'PASSWORD_LIFE_TIME'
                       THEN
                          DBMS_OUTPUT.put_line (
                             'alter profile default limit PASSWORD_LIFE_TIME  UNLIMITED');

                          EXECUTE IMMEDIATE
                             'alter profile default limit PASSWORD_LIFE_TIME  UNLIMITED';
                       END IF;

                       IF c_value.resource_name = 'FAILED_LOGIN_ATTEMPTS'
                       THEN
                          DBMS_OUTPUT.put_line (
                             'alter profile default limit FAILED_LOGIN_ATTEMPTS  UNLIMITED');

                          EXECUTE IMMEDIATE
                             'alter profile default limit FAILED_LOGIN_ATTEMPTS  UNLIMITED';
                       END IF;

                       IF c_value.resource_name = 'PASSWORD_REUSE_MAX'
                       THEN
                          DBMS_OUTPUT.put_line (
                             'alter profile default limit  PASSWORD_REUSE_MAX 10');

                          EXECUTE IMMEDIATE
                             'alter profile default limit  PASSWORD_REUSE_MAX 10';
                       END IF;

                       IF c_value.resource_name = 'PASSWORD_VERIFY_FUNCTION'
                       THEN
                          DBMS_OUTPUT.put_line (
                             'alter profile default limit PASSWORD_VERIFY_FUNCTION PASSWORD_VERIFY_FUNCTION');

                          EXECUTE IMMEDIATE
                             'alter profile default limit PASSWORD_VERIFY_FUNCTION PASSWORD_VERIFY_FUNCTION';
                       END IF;

                       IF c_value.resource_name = 'PASSWORD_LOCK_TIME'
                       THEN
                          DBMS_OUTPUT.put_line (
                             'alter profile default limit PASSWORD_LOCK_TIME  UNLIMITED');

                          EXECUTE IMMEDIATE
                             'alter profile default limit PASSWORD_LOCK_TIME  UNLIMITED';
                       END IF;

                       IF c_value.resource_name = 'PASSWORD_GRACE_TIME'
                       THEN
                          DBMS_OUTPUT.put_line (
                             'alter profile default limit PASSWORD_GRACE_TIME  UNLIMITED');

                          EXECUTE IMMEDIATE
                             'alter profile default limit PASSWORD_GRACE_TIME  UNLIMITED';
                       END IF;
                    END LOOP;
                 END IF;
              END IF;
           END;
           / \n#;

     printLog('I',"$isql");
     execSql($isql);
     if ($dbVersion eq '12.1' or $dbVersion eq '12.2') {
        if (@dbPdbName){
          my $pdbname;
          foreach $pdbname (@dbPdbName){
             printLog('D',"Begin Run Anquan Scrips Alter User profile with Default User In Pdb :$pdbname");
             my $pdbisql="alter session set container=${pdbname};\n".$isql;
             printLog('I',"$pdbisql");
             execSql($pdbisql);
             printLog('D',"Finish Run Anquan Alter User profile with Default User In Pdb :$pdbname");
          }
        }
     }
 }


 sub dbAnquan7{
  printLog('D',"Begin Run Anquan Scrips Create Audit Table In CDB or Database");
  my $isql=qq#
           DECLARE
               i_sql      VARCHAR2 (4000);
               i_number   NUMBER;
           BEGIN
               SELECT COUNT (*)
                 INTO i_number
                 FROM dba_tables
                WHERE table_name = 'AUDIT_LOGIN_DB' AND owner = 'SYSTEM';
               DBMS_OUTPUT.PUT_LINE('create table system.audit_login_db');
               IF i_number = 0
               THEN
                   EXECUTE IMMEDIATE 'CREATE TABLE SYSTEM.AUDIT_LOGIN_DB
           (
               SERVER_HOST       VARCHAR2 (30),
               SERVER_IP_ADDR    VARCHAR2 (20),
               DB_UNIQUE_NAME    VARCHAR2 (30),
               INSTANCE_NAME     VARCHAR2 (30),
               SESSION_ID        NUMBER,
               SID               NUMBER,
               SESSION_SERIAL\#   NUMBER,
               OS_USER           VARCHAR2 (200),
               CLIENT_IP_ADDR    VARCHAR2 (200),
               TERMINAL          VARCHAR2 (200),
               HOST              VARCHAR2 (200),
               USER_NAME         VARCHAR2 (30),
               LOGON_DATE        DATE,
               LOGOFF_DATE       DATE,
               ELAPSED_SECONDS   NUMBER,
               MODULE            VARCHAR2 (50),
               DBLINK_INFO       VARCHAR2 (100),
               PROGRAM           VARCHAR2 (100),
               MESSAGE           VARCHAR2 (50),
               SERVICE_NAME      VARCHAR2 (30)
           )
           PARTITION BY RANGE
               (LOGON_DATE)
               INTERVAL ( NUMTOYMINTERVAL (1, ''MONTH'') )
               (PARTITION
                    PART_201410
                    VALUES LESS THAN
                        (TO_DATE (''2014-11-01 00:00:00'', ''SYYYY-MM-DD HH24:MI:SS'')))';

                   EXECUTE IMMEDIATE 'CREATE INDEX SYSTEM.IX_AUDIT_LOGIN_SESSIONID
               ON SYSTEM.AUDIT_LOGIN_DB (SESSION_ID)
               LOCAL';
               ELSE
                   DBMS_OUTPUT.put_line ('TABLE AUDIT_LOGIN_DB is exits;');
               END IF;

               SELECT COUNT (*)
                 INTO i_number
                 FROM dba_tables
                WHERE table_name = 'TAB_LOG' AND owner = 'SYSTEM';

               IF i_number = 0
               THEN
                   EXECUTE IMMEDIATE 'CREATE TABLE SYSTEM.tab_log
           (
               log_date   DATE,
               flag       VARCHAR2 (200),
               msg        VARCHAR2 (150),
               errcode    NUMBER
           )'       ;
                 dbms_output.put_line('success for create system.audit_login_db ');
               ELSE
                   DBMS_OUTPUT.put_line ('TABLE TAB_LOG is exits;');
               END IF;
           END;
           / \n#;

     printLog('I',"$isql");
     execSql($isql);
     if ($dbVersion eq '12.1' or $dbVersion eq '12.2') {
        if (@dbPdbName){
          my $pdbname;
          foreach $pdbname (@dbPdbName){
             printLog('D',"Begin Run Anquan Scrips Create Audit Table  In Pdb :$pdbname");
             my $pdbisql="alter session set container=${pdbname};\n".$isql;
             printLog('I',"$pdbisql");
             execSql($pdbisql);
             printLog('D',"Finish Run Anquan Scrips Create Audit Table  In Pdb :$pdbname");
          }
        }
     }
 }


sub dbAnquan8{
  printLog('D',"Begin Run Anquan Scrips Create Login Trigger In CDB or Database");
  my $isql=qq#DECLARE
               i_number   NUMBER;
               i_output   varchar2(1000);
           BEGIN
               SELECT COUNT (*)
                 INTO i_number
                 FROM dba_triggers
                WHERE TRIGGER_NAME = 'LOGIN_AUDIT_TRIGGER' AND owner = 'SYS';

               IF i_number = 0
               THEN
                   DBMS_OUTPUT.PUT_LINE('trigger login_audit_trigger is not exits');
                   SELECT COUNT (*)
                     INTO i_number
                     FROM dba_tables
                    WHERE owner = 'SYSTEM' AND table_name = 'AUDIT_LOGIN_DB';

                   IF i_number = 1
                   THEN
                       SELECT COUNT (*)
                         INTO i_number
                         FROM dba_tables
                        WHERE owner = 'SYSTEM' AND table_name = 'TAB_LOG';

                       IF i_number = 1
                       THEN
                           EXECUTE IMMEDIATE
                               'CREATE  TRIGGER SYS.LOGIN_AUDIT_TRIGGER
               AFTER LOGON
               ON DATABASE
           DECLARE
               Session_Id_Var       NUMBER;
               Os_User_Var          VARCHAR2 (200);
               IP_Address_Var       VARCHAR2 (200);
               Terminal_Var         VARCHAR2 (200);
               Host_Var             VARCHAR2 (200);
               SID_Num              NUMBER;
               DBLINK_Info_Var      VARCHAR2 (100);
               Module_Var           VARCHAR2 (50);
               SERVER_HOST_Var      VARCHAR2 (30);
               SERVER_IP_ADDR_Var   VARCHAR2 (20);
               DB_UNIQUE_NAME_Var   VARCHAR2 (30);
               INSTANCE_NAME_Var    VARCHAR2 (30);
               Service_Name_Var     VARCHAR2 (30);
               Version_Var          VARCHAR2 (10);
               v_messages           VARCHAR2 (100);
               n_errcode            NUMBER;
               n_roles              NUMBER;
           BEGIN

               SELECT COUNT (*)
                 INTO n_roles
                 FROM v\\\$database
                WHERE database_role = ''PRIMARY'';


               SELECT SUBSTR (version, 1, INSTR (version, ''.'', 1) - 1)
                 INTO Version_Var
                 FROM dba_registry
                WHERE comp_id = ''CATALOG'';

               IF n_roles = 1
               THEN
                   IF Version_Var <= ''10''
                   THEN
                       SELECT '''', --SUBSTR (UTL_INADDR.GET_HOST_ADDRESS, 1, 20),
                              SYS_CONTEXT (''USERENV'', ''SESSIONID''),
                              SYS_CONTEXT (''USERENV'', ''OS_USER''),
                              SYS_CONTEXT (''USERENV'', ''IP_ADDRESS''),
                              '''', --SYS_CONTEXT (''USERENV'', ''TERMINAL''),
                              SYS_CONTEXT (''USERENV'', ''HOST''),
                              SYS_CONTEXT (''USERENV'', ''SID''),
                              '''', --SUBSTR(SYS_CONTEXT(''USERENV'',''DBLINK_INFO''),1,100),
                              SUBSTR (SYS_CONTEXT (''USERENV'', ''MODULE''), 1, 50),
                              SUBSTR (SYS_CONTEXT (''USERENV'', ''SERVER_HOST''), 1, 30),
                              '''', --SUBSTR (SYS_CONTEXT (''USERENV'', ''DB_UNIQUE_NAME''), 1, 30),
                              '''', --SUBSTR (SYS_CONTEXT (''USERENV'', ''INSTANCE_NAME''), 1, 30),
                              SUBSTR (SYS_CONTEXT (''USERENV'', ''SERVICE_NAME''), 1, 30)
                         INTO SERVER_IP_ADDR_Var,
                              Session_Id_Var,
                              Os_User_Var,
                              IP_Address_Var,
                              Terminal_Var,
                              Host_Var,
                              SID_Num,
                              DBLINK_Info_Var,
                              Module_Var,
                              SERVER_HOST_Var,
                              DB_UNIQUE_NAME_Var,
                              INSTANCE_NAME_Var,
                              Service_Name_Var
                         FROM DUAL;
                   ELSE
                       SELECT '''', --SUBSTR (UTL_INADDR.GET_HOST_ADDRESS, 1, 20),
                              SYS_CONTEXT (''USERENV'', ''SESSIONID''),
                              SYS_CONTEXT (''USERENV'', ''OS_USER''),
                              SYS_CONTEXT (''USERENV'', ''IP_ADDRESS''),
                              '''',      --SYS_CONTEXT (''USERENV'', ''TERMINAL''),
                              SYS_CONTEXT (''USERENV'', ''HOST''),
                              SYS_CONTEXT (''USERENV'', ''SID''),
                              SUBSTR (SYS_CONTEXT (''USERENV'', ''DBLINK_INFO''), 1, 100),
                              SUBSTR (SYS_CONTEXT (''USERENV'', ''MODULE''), 1, 50),
                              SUBSTR (SYS_CONTEXT (''USERENV'', ''SERVER_HOST''), 1, 30),
                              '''', --SUBSTR (SYS_CONTEXT (''USERENV'', ''DB_UNIQUE_NAME''), 1, 30),
                              '''', --SUBSTR (SYS_CONTEXT (''USERENV'', ''INSTANCE_NAME''), 1, 30),
                              SUBSTR (SYS_CONTEXT (''USERENV'', ''SERVICE_NAME''), 1, 30)
                         INTO SERVER_IP_ADDR_Var,
                              Session_Id_Var,
                              Os_User_Var,
                              IP_Address_Var,
                              Terminal_Var,
                              Host_Var,
                              SID_Num,
                              DBLINK_Info_Var,
                              Module_Var,
                              SERVER_HOST_Var,
                              DB_UNIQUE_NAME_Var,
                              INSTANCE_NAME_Var,
                              Service_Name_Var
                         FROM DUAL;
                   END IF;


                    /* INSERT INTO SYSTEM.Audit_Login_DB (SERVER_HOST,
                                                      SERVER_IP_ADDR,
                                                      DB_UNIQUE_NAME,
                                                      INSTANCE_NAME,
                                                      Session_Id,
                                                      SID,
                                                      Session_serial\#,
                                                      OS_User,
                                                      CLIENT_IP_ADDR,
                                                      Terminal,
                                                      HOST,
                                                      User_Name,
                                                      LogOn_Date,
                                                      LogOff_Date,
                                                      Elapsed_Seconds,
                                                      Module,
                                                      DBLINK_Info,
                                                      service_name)
                        VALUES (SERVER_HOST_Var,
                                SERVER_IP_ADDR_Var,
                                DB_UNIQUE_NAME_Var,
                                INSTANCE_NAME_Var,
                                Session_Id_Var,
                                SID_Num,
                                NULL,
                                Os_User_Var,
                                IP_Address_Var,
                                Terminal_Var,
                                Host_Var,
                                USER,
                                SYSDATE,
                                NULL,
                                NULL,
                                Module_Var,
                                DBLINK_Info_Var,
                                Service_Name_Var); */
               END IF;
           EXCEPTION
               WHEN OTHERS
               THEN
                   --NULL;
                   v_messages := SUBSTR (SQLERRM, 1, 100);
                   n_errcode := SQLCODE;

                   IF n_roles = 1
                   THEN
                       INSERT INTO SYSTEM.tab_log (log_date,
                                                   flag,
                                                   msg,
                                                   errcode)
                            VALUES (SYSDATE,
                                    ''Recorded Login Event Failed\!'',
                                    v_messages,
                                    n_errcode);

                       COMMIT;
                   END IF;
           END Login_Audit_Trigger;
           '                ;
                       END IF;
                   END IF;
               ELSE
                   DBMS_OUTPUT.put_line ('trggier Login_Audit_Trigger is Exits');
               END IF;

               SELECT COUNT (*)
                 INTO i_number
                 FROM dba_objects
                WHERE     object_name = 'LOGIN_AUDIT_TRIGGER'
                      AND object_type = 'TRIGGER'
                      AND created > SYSDATE - 1 / 24;

               IF i_number = 1
               THEN
                   EXECUTE IMMEDIATE 'alter trigger sys.Login_Audit_Trigger disable';
                   select status into i_output from dba_triggers where trigger_name='LOGIN_AUDIT_TRIGGER';
                   DBMS_OUTPUT.put_line('LOGIN_AUDIT_TRIGGER STATUS is :'||i_output);
               ELSE
                  select to_char(created,'yyyy-mm-dd hh24:mi:ss') into i_output from dba_objects where object_name='LOGIN_AUDIT_TRIGGER' and object_type = 'TRIGGER';
                  dbms_output.put_line('LOGIN_AUDIT_TRIGGER create time : '||i_output);
               END IF;
           END;
           /
          \n #;

     printLog('I',"$isql");
     execSql($isql);
     if ($dbVersion eq '12.1' or $dbVersion eq '12.2') {
        if (@dbPdbName){
          my $pdbname;
          foreach $pdbname (@dbPdbName){
             printLog('D',"Begin Run Create Login Trigger In Pdb :$pdbname");
             my $pdbisql="alter session set container=${pdbname};\n".$isql;
             printLog('I',"$pdbisql");
             execSql($pdbisql);
             printLog('D',"Finish Run Create Login Trigger In Pdb :$pdbname");
          }
        }
     }

}


fileOpen;
parseArgs;
envCheck;
envDbversion;
dbMem;
dbCreateTemplate;
dbCreateDbca;
envPara('ORACLE_SID','$dbName');
#dbChangeMemPara;
#dbChangeRacPara;
dbChangePara;
dbChangeJob;
dbChangeAwr;
#dbResizeFile;
#dbAnquan1;
#dbAnquan2;
#dbAnquan3;
#dbAnquan4;
#dbAnquan5;
#dbAnquan6;
#dbAnquan7;
#dbAnquan8;
fileClose;