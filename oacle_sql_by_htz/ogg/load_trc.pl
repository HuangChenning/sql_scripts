#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;
use File::Copy;

# Oracle run env
our $oracleSID = $ENV{'ORACLE_SID'};
our $oracleHome = $ENV{'ORACLE_HOME'};
# SQLSet table name
our $sqlsetTabName = 'SQLSET_TAB_20150122';
# Trace dir
our $tracedir = '/bill/oradata01/spa/20150122';
# oracle dir prefix
our $oracle_dir = 'SPA_DIR';
#oracle map table
our $ora_maptable = 'MAPPING_TABLE';
# SQLSet username
our $sqlsetOwner = 'SPA';
# SQLSet password
our $sqlsetOwnerPass = 'spa';
# SQLSet table_name
our $sqlsetName = 'SQLSET_20150122';
# SQLSet commite rows
our $sqlsetcommitrow = 100;

# SPA parallel
our $execParallels = 32;

#########################################################################
##                                                                     ##
## Log and Debug Printer                                               ##
##                                                                     ##
#########################################################################
sub printLOG{

    my ($sec, $min, $hour, $mday, $month, $year, $wday, $yday, $daylight)=localtime;
    $year += 1900;
    $month += 1;
    $month = "0".$month if ($month < 10);
    $mday = "0".$mday if ($mday < 10);
    $sec = "0".$sec if ($sec < 10);
    $min = "0".$min if ($min < 10);
    $hour = "0".$hour if ($hour < 10);
    my $date = "$year-$month-$mday $hour:$min:$sec";
    if (not defined $_[1]){
      printf STDOUT "%20s :         %s\n", $date, $_[0];
    }
    else{
      printf STDOUT "%20s :[%5s]  %s\n", $date, $_[1], $_[0];
    }
}

#########################################################################
##                                                                     ##
## Execute SQLs in Given String                                        ##
##                                                                     ##
#########################################################################
sub executeSQL{

    # Build SQL Scripts
    my $scriptsFile = 'sql_script.tmp';
    my $resultFile = 'sql_result.tmp';
    open SQLSCRIPTTEMP, ">", $scriptsFile;
    printf SQLSCRIPTTEMP "%s\n%s\n", "SET LINES 11111 PAGES 0 TRIM ON TRIMS ON TI OFF TIMI OFF AUTOT OFF FEED OFF SERVEROUTPUT ON SIZE UNLIMITED", "SPOOL $resultFile";
    printf SQLSCRIPTTEMP "%s\n", "$_[0]";
    printf SQLSCRIPTTEMP "%s\n%s\n%s\n", "SPOOL OFF", "COMMIT;", "EXIT";
    close SQLSCRIPTTEMP;

    # Execute SQL With SQL*Plus
    `ORACLE_SID=$oracleSID; ORACLE_HOME=$oracleHome; export ORACLE_SID ORACLE_HOME; $oracleHome/bin/sqlplus -s '/ as sysdba' \@$scriptsFile`;

    # Check Result File
    my $errCNT = 0;
    open SQLRESULTTEMP, "<", $resultFile;
    while (<SQLRESULTTEMP>){
        my $errorLine = $_;
        if ($errorLine =~ m/\AORA\-[0-9]{5}/){
          printLOG('executeSQL', "Error : [$errorLine]");
          $errCNT ++;
        }
    }
    close SQLRESULTTEMP;

    return $errCNT;
}

#########################################################################
##                                                                     ##
## Load Trace into oracle                                              ##
##                                                                     ##
#########################################################################
sub loadtrace{
  printLOG('1. Execute SQL on Target Database');
  for (my $i = 0; $i < $execParallels; $i++){
    open EXECSCRIPT, '>', "./exec_SPA_load_$i.sh";
    print EXECSCRIPT "sqlplus $sqlsetOwner/$sqlsetOwnerPass <<EOF\n";
    print EXECSCRIPT "create or replace directory ${oracle_dir}_${i} as '$tracedir/trc${i}';\n";
    # print EXECSCRIPT "EXEC DBMS_SQLPA.EXECUTE_ANALYSIS_TASK('$spaTaskPrefix"."_$i', 'TEST EXECUTE', '$spaTaskPrefix"."_11G', NULL, 'Execute SQL in 11g on : '||TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));\n";
    print EXECSCRIPT "declare\n";
    print EXECSCRIPT "  mycur dbms_sqltune.sqlset_cursor;\n";
    print EXECSCRIPT "begin\n";
    print EXECSCRIPT "  dbms_sqltune.create_sqlset('${sqlsetName}_${i}');\n";
    print EXECSCRIPT "    open mycur for\n";
    print EXECSCRIPT "      select value(p)\n";
    print EXECSCRIPT "      from table(dbms_sqltune.select_sql_trace(\n";
    print EXECSCRIPT "                   directory=>'${oracle_dir}_${i}',\n";
    print EXECSCRIPT "                   file_name=>'%trc',\n";
    print EXECSCRIPT "                   mapping_table_name => '${ora_maptable}',\n";
    print EXECSCRIPT "                   select_mode => dbms_sqltune.single_execution)) p;\n";
    print EXECSCRIPT "  dbms_sqltune.load_sqlset(\n";
    print EXECSCRIPT "    sqlset_name => '${sqlsetName}_${i}',\n";
    print EXECSCRIPT "    populate_cursor => mycur,\n";
    print EXECSCRIPT "    commit_rows => ${sqlsetcommitrow});\n";
    print EXECSCRIPT "  close mycur;\n";
    print EXECSCRIPT "end;\n";
    print EXECSCRIPT "/\n";
    print EXECSCRIPT "EXIT\n";
    print EXECSCRIPT "EOF\n";
    print EXECSCRIPT "echo false > exec_SPA_load_work_$i.log\n";
    close EXECSCRIPT;
    chmod 0755, "exec_SPA_load_$i.sh";
    my $bgTask = `nohup ./exec_SPA_load_$i.sh 1>exec_SPA_load_$i.log 2>&1 &`;
  }
    my $testExec = `ps -ef | grep exec_SPA_load | grep -v grep | wc -l`;
    chomp($testExec);
    while ($testExec > 0){
      printLOG('   Execution Processes Does not Complete, Current Count is : ['.$testExec.']');
      sleep 60;
      $testExec = `ps -ef | grep exec_SPA_load | grep -v grep | wc -l`;
      chomp($testExec);
  }
}

#########################################################################
##                                                                     ##
## rename trace                                                        ##
##                                                                     ##
#########################################################################
sub rename_trace{

  # my $path="/acct/oradata01/spa";
  opendir(DIR,$tracedir) or die "can't open it:$!";
  my @dir = grep {/\.trc$/} readdir DIR;
  closedir(DIR);
  my $filenum=0;
  foreach(@dir){
    $filenum +=1;
  }
  my $execut=int($filenum/$execParallels);
  for(my $p=0;$p<=$execParallels-1;$p++){
    mkdir "${tracedir}/trc${p}";
    for(my $e=1;$e<=$execut;$e++){
      my $name=shift@dir;
        print "$name\n";
      move "${tracedir}/$name","${tracedir}/trc${p}/$name";
    }
  }
}


#########################################################################
##                                                                     ##
## Load Trace into oracle                                              ##
##                                                                     ##
#########################################################################
sub loadsqltostgtab{
  # printLOG('Split SQLs in SQL Set Staging Table into ['.$execParallels.'] Pieces', 'Begin');
  printLOG('2. Create SQL Set Staging Table ['.$sqlsetTabName.']');
  my $sqlSTMT = "  BEGIN
    dbms_sqltune.create_stgtab_sqlset(table_name => '$sqlsetTabName',schema_name => '$sqlsetOwner');
    end;
    /";
  executeSQL($sqlSTMT);
  #printLOG($sqlSTMT);

  printLOG('2. Pack SQL Set into Staging Table ['.$sqlsetTabName.']');

 $sqlSTMT = "BEGIN
    FOR X IN 0..".($execParallels - 1)." LOOP
      DBMS_SQLTUNE.pack_stgtab_sqlset(sqlset_name => '${sqlsetName}_'||X,sqlset_owner=>'$sqlsetOwner',staging_table_name => '$sqlsetTabName',staging_schema_owner => '$sqlsetOwner');
    END LOOP;
    END;
    /";
   executeSQL($sqlSTMT);
  #printLOG($sqlSTMT);
}


rename_trace;
loadtrace;
loadsqltostgtab;


