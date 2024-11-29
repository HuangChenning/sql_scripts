#!/usr/bin/perl

# File Name :migrate_parallel_create_index.pl
# Purpose : 利用impdp生成的index ddl语句，并行的创建索引
# Date： 2016-07-10
# 认真就输、QQ:7343696
# http://www.htz.pw
# 2017-08-02 修改索引存在的判断的逻辑结构
# 2017-08-02 修改索引存在时，跳过下次匹配的ALTER INDEX语句
# 2017-08-02 修改日志目录的判断语句
use strict;
use warnings;
use POSIX qw(strftime);
use Cwd;
use Getopt::Long qw(:config no_ignore_case);
use File::Copy;
use Sys::Hostname;

our $workDir=getcwd;
our $logDir=getcwd."/logs";
our $dateFormat=strftime "%Y%m%d%H%M%S", localtime;

#impdp
our $dpDirecotry=$workDir;
our $dpFile;
our $dpFilePath="$workDir/dpFile";
our $dpParallel;
our $dpUserName;
our $dpUserPassword;

#sqlplus
our $dbParallel;
our $oracleBase;
our $oracleHome;
our $dbLogin;
our $runCount         =0;
our $runTotalCount    =0;
our $dbUserName;
our $dbUserPassword;
our $dbTnsLabel;

# log file
our $errorLog;
our $warrLog;
our $commandLog;
our $stepLog;


sub fileOpen
{
   unless (-e $logDir and -w $logDir){
           mkdir $logDir or die "Failed mkdir $logDir and exits";
   }
       open $errorLog,">",getcwd."/logs/parallel_create_index_".$dateFormat.".err"       or die "Failed Open Error Logfle ,errpr $!";
       open $warrLog,">",getcwd."/logs/parallel_create_index_".$dateFormat.".warr"       or die "Failed Open Warring Logfle ,errpr $!";
       open $commandLog,">",getcwd."/logs/parallel_create_index_".$dateFormat.".command" or die "Failed Open Command Logfle ,errpr $!";
       open $stepLog,">",getcwd."/logs/parallel_create_index_".$dateFormat.".step"       or die "Failed Open Command Logfle ,errpr $!";
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
    print "migrate_impdp_parallel_create_index.pl -f index.txt -u username -p password -t htz(remote login file mode)\n";
    print "migrate_impdp_parallel_create_index.pl -f index.txt (as sysdba file mode )\n";
    print "migrate_impdp_parallel_create_index.pl -f index.txt -u username -p password -t htz -n network_link -S htz,htz1,htz3 (impdp mode) \n";
    print "     -f   index ddl file name (created by impdp sqlfile)\n";
    print "     -u   username for sqlplus and impdp login database(when define password then default system or null) \n";
    print "     -p   password for sqlplus and impdp login database(when define username then default oracle or null) \n";
    print "     -t   tnsnames label name for sqlplus and impdp login database \n";
    print "     -P   parallel sqlplus process  (default 20)\n";
    print "     -S   schema for impdp\n";
    print "     -n   network_link for impdp\n";
    exit; 
}


sub parseArgs
{
    my ($opt_f,$opt_u,$opt_p,$opt_t,$opt_P,$opt,$opt_S,$opt_h,$opt_n);
    if ($#ARGV < 0)
    {
        usage();
        exit 1;
    }
    else
    {
      GetOptions(
          'filename|f=s'          => \$opt_f,
          'username|u=s'          => \$opt_u,
          'password|p=s'          => \$opt_p,
          'tnsname|t=s'           => \$opt_t,
          'parallel|P=s'          => \$opt_P,
          'schema|S=s'            => \$opt_S,
          'help|h|H'              => \$opt_h,
          'nework_link|n=s'       => \$opt_n,
          );
    }
    if (defined $opt_h){
        usage();
    }
    if (not defined $opt_f){
        usage();
    }
    else {
        $dpFile=$opt_f;
    }
    if (not defined $opt_u and not defined $opt_p and defined $opt_t){
          usage();
    }
    elsif (not defined $opt_u and not defined $opt_p and not defined $opt_t){
        $dbLogin='/ as sysdba';
        printLog('D',"User Input  : [\$dbLogin = $dbLogin");     
    }
    elsif (not defined $opt_u and defined $opt_p){
        $dbUserName="system";
        $dbUserPassword=$opt_p;
        printLog('D',"User Input  : [\$dbUserName] = $dbUserName");
        printLog('D',"User Input  : [\$dbUserPassword = $dbUserPassword");
    }
    elsif (defined $opt_u and not defined $opt_p){
        $dbUserName=$opt_u;
        $dbUserPassword="oracle";
        printLog('D',"User Input  : [\$dbUserName] = $dbUserName");
        printLog('D',"User Input  : [\$dbUserPassword = $dbUserPassword");
    }
    else{
        $dbUserName=$opt_u;
        $dbUserPassword=$opt_p;
        printLog('D',"User Input  : [\$dbUserName] = $dbUserName");
        printLog('D',"User Input  : [\$dbUserPassword = $dbUserPassword");
    }
    if ((defined $opt_u or defined $opt) and not defined $opt_t){
        usage()
    }
    elsif((defined $opt_u or defined $opt) and defined $opt_t){
        $dbTnsLabel=$opt_t;
        printLog('D',"User Input  : [\$dbTnsLabel = $dbTnsLabel"); 
        $dbLogin=$opt_u.'/'.$opt_p.'@'.$dbTnsLabel;
        printLog('D',"User Input  : [\$dbLogin = $dbLogin"); 
    }
    if (defined $opt_P){
       $dbParallel=$opt_P;
    }
    else{
       $dbParallel=20;
    }
}

sub execSql{

    my $sqloutput;
    my $sqlquery=$_[0];
    my $sqlplusset='SET LINES 11111 PAGES 0 TRIM ON TRIMS ON TI OFF TIMI OFF AUTOT OFF FEED OFF SERVEROUTPUT ON SIZE UNLIMITED';
    $sqloutput=`sqlplus -s /nolog <<EOF
                           conn $dbLogin;
                           $sqlplusset;
                           $sqlquery;
                           quit;
EOF
                           `;
   if (($sqloutput =~ /ORA[-][0-9]/) || ($sqloutput =~ /SP2-.*/))
    {
           printLog('D',"sql:$sqlquery");                     
           printLog('E',"sql:$sqloutput");                     
    }
}

sub execSqlAndGetValue{

    my $sqloutput;
    my $sqlquery=$_[0];
    my $sqlplusset='SET LINES 11111 PAGES 0 TRIM ON TRIMS ON TI OFF TIMI OFF AUTOT OFF FEED OFF SERVEROUTPUT ON SIZE UNLIMITED';
    $sqloutput=`sqlplus -s /nolog <<EOF
                           conn $dbLogin;
                           $sqlplusset;
                           $sqlquery;
                           quit;
EOF
                           `;
   if (($sqloutput =~ /ORA[-][0-9]/) || ($sqloutput =~ /SP2-.*/))
    {
           printLog('D',"sql:$sqlquery");                     
           printLog('E',"sql:$sqloutput");                     
    }
    return $sqloutput;
}

sub checkFile{
        if ( -f $_[0] and -r _ and -o _){
                printLog('I',"$_[0] is exist and test read and test owner");
                return 1;
        }
        else{
                printLog('I',"$_[0] is not exists or can not read or not owner");
                return 0;
        }
}
sub rmLogFile{
   my $filename='.process';
   my @file_name=<${filename}*.log>;
   if (@file_name >0)
   {
       foreach(@file_name)
       {
          printLog ("D","remove file :$_");
          unlink $_;
       }
   }
}
sub checkLogFile{                                                                                                                                                                                               
    my $errcnt = 0;                                                                                                                                                                                             
    my $processstatus='.processstatus.log';                                                                                                                                                                     
    open PROCESSROW,"<",$processstatus;                                                                                                                                                                         
    while(<PROCESSROW>){                                                                                                                                                                                        
    next if /^s*$/;                                                                                                                                                                                             
    chomp;                                                                                                                                                                                                      
    my $PROCESSLOG=$_;                                                                                                                                                                                          
    open SQLRESULTTEMP, "<",$PROCESSLOG;                                                                                                                                                                        
    while (<SQLRESULTTEMP>){                                                                                                                                                                                    
        chomp;                                                                                                                                                                                                  
        my $errorline = $_;                                                                                                                                                                                     
        if ($errorline =~ m/ORA\-[0-9]{5}/){                                                                                                                                                                  
            printLog("D","Error : [$errorline]");                                                                                                                                                                   
            $errcnt ++;                                                                                                                                                                                         
        }                                                                                                                                                                                                       
    }                                                                                                                                                                                                           
    close SQLRESULTTEMP;                                                                                                                                                                                        
    }                                                                                                                                                                                                           
    close PROCESSROW;                                                                                                                                                                                           
    return $errcnt;                                                                                                                                                                                             
} 
sub checkIndex{
         my $line=shift;
         if ( $line=~/\"(.*?)\"\.\"(.*?)\".*\"(.*?)\"\.\"(.*?)\"/){            
             my ($indexschema,$indexname,$tableschema,$tablename)=($1,$2,$3,$4);
             if( execSqlAndGetValue("select count(*) from dba_tables where owner=upper('$tableschema') and table_name=upper('$tablename')")<1){
                 printLog('W',"$tableschema.$tablename Not In Database and Please Confire");
                 return 1;
                 }
             elsif(execSqlAndGetValue("select count(*) from dba_indexes where owner=upper('$indexschema') and index_name=upper('$indexname')")>0){
                 printLog('W',"$indexschema.$indexname is exits And Please Confire");
                 return 1;
             }
             elsif(execSqlAndGetValue("select count(*) from system.migrate_table_big where owner=upper('$tableschema') and table_name=upper('$tablename')")>0){
                 printLog('W',"$tableschema.$tablename is exits In Big Table exits ,so Skip");
                 return 1;
             }
             else{
                 return 2;
          }
        }
        else{
             printLog('W',"Failed Get Index Name And Table Name and $line");  
             return 1;
        }         
}
sub createIndexScript{
        printLog("I","Create Script For Create Index");
        open EXECSCRIPT, '>', "./.executecreateindex.sh";                                                                                                                                                               
        print EXECSCRIPT "TASKNO=\$1\n";                                                                                                                                                                            
        print EXECSCRIPT "sqlplus $dbLogin <<EOF\n";                                                                                                                                                           
        print EXECSCRIPT "set echo on heading on time on timing on feedback on pages 10000;\n";  
        print EXECSCRIPT "alter session set workarea_size_policy=MANUAL;\n";
        print EXECSCRIPT "alter session set db_file_multiblock_read_count=512;\n";
        print EXECSCRIPT "alter session set events '10351 trace name context forever, level 128';\n";
        print EXECSCRIPT "alter session set sort_area_size=2147483647;\n";
        print EXECSCRIPT qq#alter session set "_sort_multiblock_read_count"=128;\n#;
        print EXECSCRIPT "alter session enable parallel ddl;\n";
        print EXECSCRIPT "alter session enable parallel dml;\n";
        print EXECSCRIPT "set timing on \n";                                                                                                                  
        print EXECSCRIPT "\$2\n";                                                                                                                                                                                   
        print EXECSCRIPT "COMMIT;\n";                                                                                                                                                                               
        print EXECSCRIPT "EXIT\n";                                                                                                                                                                                  
        print EXECSCRIPT "EOF\n";                                                                                                                                                                                   
        print EXECSCRIPT "echo .processlog_\${TASKNO}.log >> .processstatus.log\n";                                                                                                                                 
        close EXECSCRIPT;                                                                                                                                                                                           
        chmod 0755, "./.executecreateindex.sh";  
        `echo > .processstatus.log`; 
}

sub indexCreate{
        my $mysql=shift;
        $runTotalCount++;
        $runCount++;
        `nohup ./.executecreateindex.sh $runTotalCount "$mysql">>.processlog_${runTotalCount}.log 2>&1 &`;    
        while ( $runCount >= $dbParallel){
              sleep 10;
              $runCount =0 + `ps -ef|grep executecreateindex|grep -v grep | wc -l`; 
              printLog('D',"Script Num:$runCount Is Execing");
              printLog("E","Find Error Info And Exits ") if (checkLogFile);
        }
       printLog("E","Find Error Info And Exits ") if (checkLogFile);
        
}
sub checkProcess{
        while ($runCount >0){
              sleep 10;
              $runCount =0 + `ps -ef|grep executecreateindex|grep -v grep | wc -l`; 
              printLog('D',"Script Num:$runCount Is Execing");
              printLog("E","Find Error Info And Exits ") if (checkLogFile);
        }  
        printLog('D',"Index Be Created Success ,Number is $runTotalCount"); 
}
sub readFile{
        my $checkvalue=checkFile("$_[0]");
        if ($checkvalue == 0){
          printLog('E',"$_[0] is not exists or can not read or not owner");
        }
         else
        {
          printLog("I","$_[0] is exist and test read and test owner");
        }
        my $sql;
        printLog('D',"Open File $_[0]");
        open (FILENAME,"$_[0]") or printLog("E","Failed ******:Open File $_[0]");
        while (<FILENAME>){
                next if /^s*$/;
                if (/^-- CONNECT STAT/){
                        my $dbSchema=(split(/ /))[2];
                }
                elsif (/^CREATE INDEX/ or /^CREATE UNIQUE INDEX/ or /^CREATE BITMAP INDEX/){
                        chomp($sql=$_);
                        if (checkIndex("$sql") != 2){
                             undef $sql;
                             next;
                       }
                 }   
                elsif (/^  ALTER INDEX/ and /;/){
                        next if (not defined $sql);
                        $sql=$sql."         $_";
                        printLog("I","Sql******:$sql");
                        indexCreate("$sql");
                        undef $sql;
                }
                elsif (/^  \w+/ and not /ALTER INDEX/){
                        next if (not defined $sql);
                        $sql=$sql."         $_";
                }
        }
}
fileOpen;
parseArgs;
rmLogFile;
createIndexScript;
readFile("$dpFile");
checkProcess;
fileClose;
