#!/usr/bin/perl
#支持KILL所有本地的LOCAL=NO进程
#支持接用户接参数。
#支持存储过程的名字等

use strict;
use warnings;
use POSIX qw(strftime);

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