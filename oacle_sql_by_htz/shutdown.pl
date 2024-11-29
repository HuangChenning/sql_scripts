#!/usr/bin/perl
#perl shutdown -i instance_name/ALL(delete all instance in ENV oracle_home)
#File Name : shutdown.pl
#Purpose : shutdown database
#Version : 1.0
#Date : 2016/12/09
#Modify Date : 2016/12/09
#ÈÏÕæ¾ÍÊä¡¢QQ:7343696
#http://www.htz.pw
use strict;
use warnings;
use POSIX qw(strftime);

our $db_name;
our $instance_name;
our @instance_group;
our @listener_name;
our $shutdown_listener;
our $error_file='error_filename.log';
our $db_status;
our @sid;
our $oracleHome=$ENV{ORACLE_HOME};
#########################################################################
##                                                                     ##
## Log and Debug Printer                                               ##
##                                                                     ##
#########################################################################
sub print_log{

    my $date = strftime "%Y-%m-%d %H:%M:%S", localtime;
    if (not defined $_[1]){
        printf STDOUT "%20s :              %s\n", $date, $_[0];
    }
    else{
        printf STDOUT "%20s :[%10s]  %s\n", $date, $_[1], $_[0];
    }
}
#########################################################################
##     get Arguments                                                   ##
#########################################################################
sub get_args(){

    my %arghash;
    my $optname;
    my $optvalue;
    if ($#ARGV >= 0) {
        while ($optname = shift @ARGV){
            if (substr($optname, 0, 1) eq "-" ){
                $optvalue = shift @ARGV;
                if(defined $optvalue){
                    if(substr($optvalue, 0, 1) eq '-'){
                        unshift(@ARGV, $optvalue);
                        $optvalue = '';
                        print_log("[$optname] is default values","get_args");
                    }
                    else{
                        print_log("User Input : [$optname] = [$optvalue]","get_args");
                        $arghash{$optname} = $optvalue;
                    }                 
                }
                else{
                    $arghash{$optname} = '';
                }
            }
            else{
                print_log("User Input Error for:$optname","get_args");
            }
        }
    } else {
        print_log("Checking Params Failed","checkInputs");
        exit 0;
    }
    return %arghash
   
}

#########################################################################
##                                                                     ##
## Check User Inputs                                                   ##
##                                                                     ##
#########################################################################
sub check_input(){

    print_log("Check User Input Information.",'CHECK');
    # Get User Input Information
    my %arglist = get_args;
    for (keys %arglist){
        my $inputkey = $_;
        #print "input key is : [$inputKey], Value is : [$argList{$inputKey}]\n";
        if ($inputkey eq '-i'){
                  if($arglist{'-i'} eq 'ALL' or not defined $arglist{'-i'}){
                                @instance_group=();
                  } else {
                          @instance_group= split(/:/,$arglist{'-i'});
                  }
            
        }
   }
}

###############################################################################
# Function : touch_error_file
# Purpose  : Create the error file if requested
###############################################################################
sub touch_error_file
{
   my $message = $_[0];

   open ERRFILE, ">>$error_file";
   print ERRFILE "$message\n";
   close ERRFILE;
}
###############################################################################
# Function : delete_error_file
# Purpose  : delete the error file 
###############################################################################
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
# Function : Die
# Purpose  : Print message and exit
###############################################################################
sub Die
{
    my $message = $_[0];

    touch_error_file($message);
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


#########################################################################
##                                                                     ##
## Execute SQLs in   retune single row                                 ##
##                                                                     ##
#########################################################################
sub exec_sql{

    my $sql_output;
    my $sql_query=$_[0];
    my $sqlplusset='SET LINES 11111 PAGES 0 TRIM ON TRIMS ON TI OFF TIMI OFF AUTOT OFF FEED OFF SERVEROUTPUT ON SIZE UNLIMITED';
    $sql_output=`sqlplus -s '/ as sysdba' <<EOF
                           $sqlplusset;
                           $sql_query;
                           quit;
EOF
                           `;
   if (($sql_output =~ /ORA[-][0-9]/) || ($sql_output =~ /SP2-.*/))
    {
           print_log("sql: $sql_query",'ERROR');
           Die("$sql_output")                       
    }
    else
    {
          return trim($sql_output);
    }
}
#########################################################################
##                                                                     ##
## Execute SQL in   DB info                                            ##
##                                                                     ##
#########################################################################
sub exec_sql1{

    my $sql_output;
    my $sql_query=$_[0];
    my $sqlplusset='SET LINES 11111 PAGES 0 TRIM ON TRIMS ON TI OFF TIMI OFF AUTOT OFF FEED OFF SERVEROUTPUT ON SIZE UNLIMITED';
    $sql_output=`sqlplus -s '/ as sysdba' <<EOF
                           $sqlplusset;
                           $sql_query;
                           quit;
EOF
                           `;
   if (($sql_output =~ /ORA[-][0-9]/) || ($sql_output =~ /SP2-.*/))
    {
           print_log("sql: $sql_query",'ERROR');
           return -1;                      
    }
    else
    {
          return trim($sql_output);
    }
}
#########################################################################
##                                                                     ##
## Execute SQLs in   retune single row                                 ##
##                                                                     ##
#########################################################################
sub exec_sqls{

    my @sql_output;
    my @sql_output_temp;
    my $sql_query=$_[0];
    my $sqlplusset='SET LINES 11111 PAGES 0 TRIM ON TRIMS ON TI OFF TIMI OFF AUTOT OFF FEED OFF SERVEROUTPUT ON SIZE UNLIMITED';

    @sql_output=`sqlplus -s '/ as sysdba' <<EOF
                           $sqlplusset;
                           $sql_query;
                           quit;
EOF
                           `;
   foreach(@sql_output)
   {                          
      chomp;
      if (($_ =~ /ORA[-][0-9]/) || ($_ =~ /SP2-.*/))
       {
              print_log("sql: $_",'ERROR');
              Die("$_")                       
       }
   }
      return @sql_output;
}

#########################################################################
##                                                                     ##
## verify oracle_sid and instance_name                                 ##
##                                                                     ##
#########################################################################
sub env_parameter{
          my $env_name=$ENV{$_[0]};
          if (not defined($env_name))
          {
                my $sid='';
                Die("change ORACLE_SID failed") unless $ENV{$_[0]}=$instance_name;
                print_log("success change ORACLE_SID=$instance_name",'CHANGE');
          }
          else
          {
                my $sid=$env_name;
                if (${env_name} ne ${instance_name}){
                   print_log("change ORACLE_SID=$instance_name",'CHANGE');
                   Die("change ORACLE_SID failed") unless $ENV{$_[0]}=$instance_name;
                }
          }
          print_log("check sid oracle home","INFO");
          my $oraTabFile='/etc/oratab';
          my @hometemp;
          my $oraclehometemp;
          my $linetemp;
          my $returntemp;
          if ( -f $oraTabFile ) {
                print_log("Open oraTab File and get Oracle Home","INFO");
                open(ORATAB,"$oraTabFile") || Die "Can not Open $oraTabFile,Error no :$!";
                while (<ORATAB>){
                         $linetemp=trim($_);
                         if ($linetemp =~ m/htz1025/ and $linetemp =~ m/$ENV{ORACLE_HOME}/ and $linetemp !~ m/^#/ ){
                            $oraclehometemp=(split (/:/,$linetemp))[1];
                            if ($oracleHome eq $oraclehometemp){
                                print_log("Oracle Home eq Env,values=$oracleHome","INFO");
                                $returntemp=1;
                            }
                         }
                }
                close(ORATAB);
          }
          if (not defined($returntemp)){
                 print_log("Exec Sql for get Oracle Home","INFO");
                 my $execresult=exec_sql1("select count(*) from dual");
                 if (exec_sql1("select count(*) from dual") < 0)
                 {
                   print_log("${instance_name}'s oracle home <> env oracle home","FAILD");
                   $returntemp=0;
                 }
                 else{
                  $returntemp=1;
                 }
          }
          return $returntemp;
}

###############################################################################
# Function : check_ckpt_process
# Purpose  : To check ckpt process of database
###############################################################################
sub check_ckpt_process{
          my $process_name='ora_ckpt_'.$instance_name;
          my $process_number;
          print_log("$instance_name check  ckpt process",'CHECK');
          Die("faild : check ckpt process of $instance_name") if( `ps -ef|awk '{print \$8}'|grep $process_name|grep -v grep|wc -l`<1)
        
}
###############################################################################
# Function : check_db_state
# Purpose  : To check state of database
###############################################################################

sub check_db_state{
       my $db_status=trim(exec_sql('select open_mode from v\$database'));
       print_log("db $instance_name open mode is :$db_status",'OPEN_MODE');
       
}

###############################################################################
# Function : kill_process
# Purpose  : kill normal process of database
###############################################################################

sub kill_process{
             print_log("$instance_name begin kill normal process",'KILL');
             my $sql_query="SELECT P.SPID FROM V\\\$SESSION S, V\\\$PROCESS P WHERE S.PADDR = P.ADDR\(\+\) AND S.USERNAME IS NOT NULL and s.username not in ('SYS')";     
             my @process_group=exec_sqls($sql_query);
       foreach(@process_group)
       {
             `kill -9 $_`;
       }   
       print_log("$instance_name finish kill normal process",'KILL');    
}

###############################################################################
# Function : check_listener
# Purpose  : To check listener
###############################################################################

sub check_listener{
       $db_status=trim(exec_sql('select open_mode from v\$database'));
       print_log("db open mode is :$db_status",'OPEN_MODE')
       
}

###############################################################################
# Function : switch_logfile
# Purpose  : To check listener
###############################################################################

sub switch_logfile{
       print_log("$instance_name begin switch logfile group",'SWITCH');
       my $sql_query=
                    "DECLARE
                     i_sql      VARCHAR2 (200);
                     i_group    NUMBER;
                     i_number   NUMBER := 1;
                  BEGIN
                     SELECT COUNT (*) + 1
                       INTO i_group
                       FROM v\\\$log
                      WHERE thread# IN (SELECT thread# FROM v\\\$thread);
                  
                     WHILE i_number <= i_group
                     LOOP
                        EXECUTE IMMEDIATE 'alter system switch logfile';
                  
                        i_number := i_number + 1;
                     END LOOP;
                     EXECUTE IMMEDIATE 'alter system checkpoint';
                  END;
                  /
                  ";
        exec_sql($sql_query);
       print_log("$instance_name finish switch logfile group",'SWITCH');
}
###############################################################################
# Function : shutdown_database
# Purpose  : To check listener
###############################################################################

sub shutdown_database{
       print_log("$instance_name begin shutdown database",'SHUT');
       exec_sql('shutdown immediate');
       print_log("$instance_name finish shutdown database",'SHUT');
}

delete_error_file($error_file);
check_input;
if ($#instance_group < 0){
         @instance_group=();
         print_log("shutdown all instance and get all sid","INFO");
         @instance_group=`ps -ef|grep ckpt|grep -v grep|awk '{print \$8}'|awk -F_ '{print \$3}'|grep -v ASM`;
         if (not defined(@instance_group)){
             Die('there is not any db open and you not input db name');
         }
}


foreach(@instance_group){

   next if /^#/;
   chomp($instance_name=$_);
   check_ckpt_process;
   next if env_parameter("ORACLE_SID") < 1;
   check_db_state;
   switch_logfile;
   kill_process;
   switch_logfile;
   shutdown_database;
}