#!/usr/bin/perl
####################################################################################################
##                                                                                                ##
## Author : HongyeDBA @ Enmotech                                                                  ##
##                                                                                                ##
##------------------------------------------------------------------------------------------------##
##                +d:                                                                             ##
##                `hds`                   .`                                                      ##
##                 -ddh+`                /h`                                                      ##
##                  odddh+              /hy`                                                      ##
##                  .hdhhhhs.`        ./hhy.                                                      ##
##                  `shhhhhhhh/`     /yhyhy-                                                      ##
##                   ohhhhhhhhho.  `/hhyyhh:                                                      ##
##                   -hhhhyhhhhhh: ohhhshhy/                                                      ##
##                    -yhhhyyhhhhy+hhhyyyyy:                                                      ##
##                    `shhhhyyhhhhhyyyoyyyy-                                                      ##
##                `.``` :yhhhsyhyyyyyssyyy+    .-`-:-`                                            ##
##     `.``-::osysyhhhhysshhyyssyyyyy+yyys+oyyyyyy+.                                              ##
##    `:osyhhhyyyhhhhhhhyyy[ HongyeDBA ]yyyyssyys:                                                ##
##         ./syhyyyyysssyyyyyyyyssyy+yyyssssyyo.                                                  ##
##            `:+osyyyyysssoooosysoossoo++/:.                                                     ##
##                 .:/+//+syyyysoo/:/+sys/`                                                       ##
##                    `:syyyyyssoo+.`   `.`                                                       ##
##                   :yyyssssssoy/  `.                                                            ##
##                 :syysso+/-` `-    `.                                                           ##
##               -+o/:-.`             `.                                                          ##
##              ``                     `.                                                         ##
##                                      `.                                                        ##
####################################################################################################
##         |      |                  |                                                            ##
## Version | Beta | Complete Time    | Description                                                ##
##---------|------|------------------|------------------------------------------------------------##
##     1.0 |      | 2014-05-22 13:50 | First Edition                                              ##
##         |      |                  |                                                            ##
####################################################################################################

use strict;
use warnings;

# Oracle运行环境
our $oracleSID = $ENV{'ORACLE_SID'};
our $oracleHome = $ENV{'ORACLE_HOME'};
# SQLSet 表名
our $sqlsetTabName = 'SQLSET_TAB_20140507';
# SQLSet 用户
our $sqlsetOwner = 'SPA';
# SQLSet 用户密码
our $sqlsetOwnerPass = 'SPA';
# SQLSet 名称
our $sqlsetName = 'SQLSET_20140507';
# SPA 任务名称
our $spaTaskPrefix = 'SPA_TASK_20140507';
# SQL 自定义过滤条件
our $sqlRemoveFilter = "PARSING_SCHEMA_NAME IN ('SPA', 'DSG', 'IGNITE_M') OR PARSING_SCHEMA_NAME LIKE 'CD_%'";
# SPA 测试并行度
our $execParallels = 32;

#########################################################################
##                                                                     ##
## Log and Debug Printer                                               ##
##                                                                     ##
#########################################################################
sub printLOG{

    my ( $sec, $min, $hour, $mday, $month, $year, $wday, $yday, $daylight )=localtime;
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
    #my $sc = `cat $scriptsFile`;
    #print "Execute Command :\n$sc\n";

    # Check Result File
    open SQLRESULTTEMP, "<", $resultFile;
    while (<SQLRESULTTEMP>){
        my $errorLine = $_;
        printLOG('executeSQL', "Error : [$errorLine]") if ($errorLine =~ m/\AORA\-[0-9]{5}/);

        #if ($errorLine =~ m/\AORA\-[0-9]{5}/){
        #    printLOG('executeSQL', "Error : [$errorLine]");
        #    print "Press Enter to Continue ...";
        #    <>;
        #}
    }
    close SQLRESULTTEMP;
}

#########################################################################
##                                                                     ##
## Pre-Check                                                           ##
##                                                                     ##
#########################################################################
sub preCheck{

  # Check Needed Parameters
  die 'SQLSET Table Name is Needed !!!' if ($sqlsetTabName =~ m/\A\s*\z/);
  die 'SQLSET Owner is Needed !!!' if ($sqlsetOwner =~ m/\A\s*\z/);
  die 'SQLSET Owner\'s Password is Needed !!!' if ($sqlsetOwnerPass =~ m/\A\s*\z/);
  die 'SQLSET Name is Needed !!!' if ($sqlsetName =~ m/\A\s*\z/);
  if ($spaTaskPrefix =~ m/\A\s*\z/){
    my ( $sec, $min, $hour, $mday, $month, $year, $wday, $yday, $daylight )=localtime;
    $year += 1900;
    $month += 1;
    $month = "0".$month if ($month < 10);
    $mday = "0".$mday if ($mday < 10);
    $spaTaskPrefix = 'SPA_TASK_'.$year.$month.$mday;
  }

  # Check User And Password
}

#########################################################################
##                                                                     ##
## Pre-Process                                                         ##
##                                                                     ##
#########################################################################
sub preProcess{

  printLOG('Remove Needless SQL in Pre-Defined Conditions', 'Begin');
  my $sqlSTMT = '';

  printLOG('1. Remove System SQLs (Filter According PARSING_SCHEMA_NAME)');
  $sqlSTMT = 'DELETE FROM '.$sqlsetOwner.'.'.$sqlsetTabName." WHERE PARSING_SCHEMA_NAME IN ('SYS','SYSTEM','OUTLN','DIP','TSMSYS','DBSNMP','ORACLE_OCM','WMSYS','EXFSYS','DMSYS','CTXSYS','XDB','ANONYMOUS','ORDSYS','ORDPLUGINS','SI_INFORMTN_SCHEMA','MDSYS','OLAPSYS');";
  executeSQL($sqlSTMT);

  printLOG('2. Remove no Executed SQLs (Filter According EXECUTIONS)');
  $sqlSTMT = 'DELETE FROM '.$sqlsetOwner.'.'.$sqlsetTabName." WHERE EXECUTIONS = 0;";
  executeSQL($sqlSTMT);

  printLOG('3. Remove SQL by Customer Filter');
  $sqlSTMT = 'DELETE FROM '.$sqlsetOwner.'.'.$sqlsetTabName." WHERE $sqlRemoveFilter;";
  executeSQL($sqlSTMT);

  printLOG('4. Create Temporary Index on [FORCE_MATCHING_SIGNATURE, SQL_ID]');
  $sqlSTMT = 'CREATE INDEX '.$sqlsetOwner.'.IDX_SQLSET_TAB_TMP ON '.$sqlsetOwner.'.'.$sqlsetTabName.'(FORCE_MATCHING_SIGNATURE, SQL_ID) PARALLEL 8;';
  executeSQL($sqlSTMT);

  printLOG('5. Remove SQLs with no Bind (Filter According FORCE_MATCHING_SIGNATURE)');
  $sqlSTMT = 'BEGIN
  FOR X IN (SELECT FORCE_MATCHING_SIGNATURE, MIN(SQL_ID) SQL_ID FROM '.$sqlsetOwner.'.'.$sqlsetTabName.' GROUP BY FORCE_MATCHING_SIGNATURE HAVING COUNT(*) > 1)
  LOOP
    DELETE FROM '.$sqlsetOwner.'.'.$sqlsetTabName.' WHERE FORCE_MATCHING_SIGNATURE = X.FORCE_MATCHING_SIGNATURE AND SQL_ID <> X.SQL_ID;
    COMMIT;
  END LOOP;
  END;
  /';
  executeSQL($sqlSTMT);

  printLOG('6. Remove Temporary Index on [FORCE_MATCHING_SIGNATURE, SQL_ID]');
  $sqlSTMT = 'DROP INDEX '.$sqlsetOwner.'.IDX_SQLSET_TAB_TMP;';
  executeSQL($sqlSTMT);
  printLOG('Remove Needless SQL in Pre-Defined Conditions', 'OK');
}

#########################################################################
##                                                                     ##
## Split SQL Set to Make Parallel                                      ##
##                                                                     ##
#########################################################################
sub splitSQLSet{

  printLOG('Split SQLs in SQL Set Staging Table into ['.$execParallels.'] Pieces', 'Begin');
  printLOG('1. Create Index on [SQL_ID]');
  my $sqlSTMT = "DECLARE
    L_INDEX_EXISTS    NUMBER :=0;
  BEGIN
    SELECT COUNT(*) INTO L_INDEX_EXISTS FROM DBA_INDEXES WHERE OWNER = '$sqlsetOwner' AND INDEX_NAME = 'IDX_SPA_SPLIT_STSTAB_SQLID';
    IF L_INDEX_EXISTS > 0 THEN
      EXECUTE IMMEDIATE 'DROP INDEX $sqlsetOwner.IDX_SPA_SPLIT_STSTAB_SQLID';
    END IF;
    EXECUTE IMMEDIATE 'CREATE INDEX $sqlsetOwner.IDX_SPA_SPLIT_STSTAB_SQLID ON $sqlsetOwner.$sqlsetTabName(SQL_ID) PARALLEL 8';
  END;
  /";
  executeSQL($sqlSTMT);

  printLOG('2. Split SQLs in Staging Table');
  $sqlSTMT = "DECLARE
    L_CURR_TABLE_TIPS   NUMBER   :=0;
  BEGIN
    FOR X IN (SELECT SQL_ID FROM $sqlsetOwner.$sqlsetTabName ORDER BY ELAPSED_TIME/EXECUTIONS) LOOP
      UPDATE $sqlsetOwner.$sqlsetTabName SET NAME = '${sqlsetName}_'||L_CURR_TABLE_TIPS WHERE SQL_ID = X.SQL_ID;
      L_CURR_TABLE_TIPS := MOD(L_CURR_TABLE_TIPS + 1, $execParallels);
    END LOOP;
  END;
  /";
  executeSQL($sqlSTMT);

  printLOG('3. Move Data from Staging Table to Temporary Created Table');
  for (my $i = 0; $i < $execParallels; $i++){
    printLOG('   Create Temporary Staging Table ['.($i + 1).' of '.$execParallels.']');
    $sqlSTMT = 'CREATE TABLE '.$sqlsetOwner.'.'.$sqlsetTabName.'_'.$i.' NESTED TABLE BIND_LIST STORE AS '.$sqlsetTabName.'_B_'.$i.' NESTED TABLE PLAN STORE AS '.$sqlsetTabName.'_P_'.$i.' AS SELECT * FROM '.$sqlsetOwner.'.'.$sqlsetTabName.' WHERE NAME = \''.$sqlsetName.'_'.$i.'\';';
    executeSQL($sqlSTMT);
  }

  printLOG('4. Revert "Name" Field in SQL Set Table');
  $sqlSTMT = "UPDATE $sqlsetOwner.$sqlsetTabName SET NAME = '$sqlsetName';";
  executeSQL($sqlSTMT);
  printLOG('Split SQLs in SQL Set Staging Table into ['.$execParallels.'] Pieces', 'OK');
}

#########################################################################
##                                                                     ##
## unPack SQL Set from Table in Parallel Mode                          ##
##                                                                     ##
#########################################################################
sub unpackSQLSet{

  printLOG('Unpack SQL Set from Temporary Created Table', 'Begin');
  printLOG('1. Unpack SQL Set');
  my $sqlSTMT = "CONN $sqlsetOwner/$sqlsetOwnerPass
  BEGIN
    FOR X IN 0..".($execParallels - 1)."
    LOOP
      DBMS_SQLTUNE.UNPACK_STGTAB_SQLSET (
                   SQLSET_NAME          => '$sqlsetName'||'_'||X,
                   SQLSET_OWNER         => '$sqlsetOwner',
                   REPLACE              => TRUE,
                   STAGING_TABLE_NAME   => '$sqlsetTabName'||'_'||X,
                   STAGING_SCHEMA_OWNER => '$sqlsetOwner');
    END LOOP;
  END;
  /";
  executeSQL($sqlSTMT);

  printLOG('2. Remove Temporary Staging Table');
  for (my $i = 0; $i < $execParallels; $i++){
    printLOG('   Remove Temporary Table ['.($i + 1).' of '.$execParallels.']');
    $sqlSTMT = "DROP TABLE $sqlsetOwner.$sqlsetTabName"."_$i PURGE;";
    executeSQL($sqlSTMT);
  }

  printLOG('Unpack SQL Set from Temporary Created Table', 'OK');
}

#########################################################################
##                                                                     ##
## Create SPA Task in Parallel Mode                                    ##
##                                                                     ##
#########################################################################
sub createTasks{

  printLOG('Create Analysis Task', 'Begin');
  my $sqlSTMT = "CONN $sqlsetOwner/$sqlsetOwnerPass
  DECLARE
    L_SPA_TASK_NAME  VARCHAR2(64);
  BEGIN
    FOR X IN 0..".($execParallels - 1)." LOOP
      L_SPA_TASK_NAME := DBMS_SQLPA.CREATE_ANALYSIS_TASK(
                               TASK_NAME    => '$spaTaskPrefix'||'_'||X,
                               DESCRIPTION  => 'SPA Analysis task on : '||TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
                               SQLSET_NAME  => '$sqlsetName'||'_'||X,
                               SQLSET_OWNER => '$sqlsetOwner');
    END LOOP;
  END;
  /";
  executeSQL($sqlSTMT);
  printLOG('Create Analysis Task', 'OK');
}

#########################################################################
##                                                                     ##
## Convert SQL Set in Parallel Mode                                    ##
##                                                                     ##
#########################################################################
sub convertTrail{

  printLOG('Create SPA Trail for Prod (Convert SQL Set)', 'Begin');
  my $sqlSTMT = "CONN $sqlsetOwner/$sqlsetOwnerPass
  BEGIN
    FOR X IN 0..".($execParallels - 1)." LOOP
      DBMS_SQLPA.EXECUTE_ANALYSIS_TASK(
                 TASK_NAME      => '$spaTaskPrefix'||'_'||X,
                 EXECUTION_NAME => '$spaTaskPrefix'||'_10G',
                 EXECUTION_TYPE => 'CONVERT SQLSET',
                 EXECUTION_DESC => 'Convert 10g SQLSET on : '||TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    END LOOP;
  END;
  /";
  executeSQL($sqlSTMT);
  printLOG('Create SPA Trail for Prod (Convert SQL Set)', 'OK');
}

#########################################################################
##                                                                     ##
## Execute SQL Set in Parallel Mode                                    ##
##                                                                     ##
#########################################################################
sub executeTrail{

  printLOG('Create SPA Trail for Test (Test Execute)', 'Begin');
  for (my $i = 0; $i < $execParallels; $i++){
    open EXECSCRIPT, '>', "./exec_SPA_$i.sh";
    print EXECSCRIPT "sqlplus $sqlsetOwner/$sqlsetOwnerPass <<EOF\n";
    print EXECSCRIPT "EXEC DBMS_SQLPA.EXECUTE_ANALYSIS_TASK('$spaTaskPrefix"."_$i', 'TEST EXECUTE', '$spaTaskPrefix"."_11G', NULL, 'Execute SQL in 11g on : '||TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));\n";
    print EXECSCRIPT "EXIT\n";
    print EXECSCRIPT "EOF\n";
    close EXECSCRIPT;
    chmod 0755, "exec_SPA_$i.sh";
    my $bgTask = `nohup ./exec_SPA_$i.sh 1>exec_SPA_$i.log 2>&1 &`;
  }
  my $testExec = `ps -ef | grep exec_SP[A] | wc -l`;
  chomp($testExec);
  while ($testExec > 0){
    printLOG('   Execution Processes Does not Complete, Current Count is : ['.$testExec.']');
    sleep 60;
    $testExec = `ps -ef | grep exec_SP[A] | wc -l`;
    chomp($testExec);
  }
  printLOG('Create SPA Trail for Test (Test Execute)', 'OK');
}

#########################################################################
##                                                                     ##
## Merge Parallel Task into First Part                                 ##
##                                                                     ##
#########################################################################
sub mergeTasks{

  printLOG('Backup AWR Base Table We Need to Change', 'Begin');
  printLOG('   Backup Table [WRI$_ADV_FINDINGS]');
  my $sqlSTMT = "DECLARE
    L_TABLE_EXISTS   NUMBER :=0;
  BEGIN
    SELECT COUNT(*) INTO L_TABLE_EXISTS FROM DBA_TABLES WHERE TABLE_NAME = 'SPA\$_ADV_FINDINGS';
    IF L_TABLE_EXISTS > 0 THEN
      EXECUTE IMMEDIATE 'DROP TABLE SPA\$_ADV_FINDINGS PURGE';
    END IF;
    EXECUTE IMMEDIATE 'CREATE TABLE SPA\$_ADV_FINDINGS AS SELECT * FROM WRI\$_ADV_FINDINGS';
  END;
  /";
  executeSQL($sqlSTMT);
  printLOG('   Backup Table [WRI$_ADV_TASKS]');
  $sqlSTMT = "DECLARE
    L_TABLE_EXISTS   NUMBER :=0;
  BEGIN
    SELECT COUNT(*) INTO L_TABLE_EXISTS FROM DBA_TABLES WHERE TABLE_NAME = 'SPA\$_ADV_TASKS';
    IF L_TABLE_EXISTS > 0 THEN
      EXECUTE IMMEDIATE 'DROP TABLE SPA\$_ADV_TASKS PURGE';
    END IF;
    EXECUTE IMMEDIATE 'CREATE TABLE SPA\$_ADV_TASKS AS SELECT * FROM WRI\$_ADV_TASKS';
  END;
  /";
  executeSQL($sqlSTMT);
  printLOG('   Backup Table [WRI$_ADV_SQLT_PLAN_HASH]');
  $sqlSTMT = "DECLARE
    L_TABLE_EXISTS   NUMBER :=0;
  BEGIN
    SELECT COUNT(*) INTO L_TABLE_EXISTS FROM DBA_TABLES WHERE TABLE_NAME = 'SPA\$_ADV_SQLT_PLAN_HASH';
    IF L_TABLE_EXISTS > 0 THEN
      EXECUTE IMMEDIATE 'DROP TABLE SPA\$_ADV_SQLT_PLAN_HASH PURGE';
    END IF;
    EXECUTE IMMEDIATE 'CREATE TABLE SPA\$_ADV_SQLT_PLAN_HASH AS SELECT * FROM WRI\$_ADV_SQLT_PLAN_HASH';
  END;
  /";
  executeSQL($sqlSTMT);
  printLOG('   Backup Table [WRI$_ADV_OBJECTS]');
  $sqlSTMT = "DECLARE
    L_TABLE_EXISTS   NUMBER :=0;
  BEGIN
    SELECT COUNT(*) INTO L_TABLE_EXISTS FROM DBA_TABLES WHERE TABLE_NAME = 'SPA\$_ADV_OBJECTS';
    IF L_TABLE_EXISTS > 0 THEN
      EXECUTE IMMEDIATE 'DROP TABLE SPA\$_ADV_OBJECTS PURGE';
    END IF;
    EXECUTE IMMEDIATE 'CREATE TABLE SPA\$_ADV_OBJECTS AS SELECT * FROM WRI\$_ADV_OBJECTS';
  END;
  /";
  executeSQL($sqlSTMT);
  printLOG('   Backup Table [WRI$_SQLSET_STATEMENTS]');
  $sqlSTMT = "DECLARE
    L_TABLE_EXISTS   NUMBER :=0;
  BEGIN
    SELECT COUNT(*) INTO L_TABLE_EXISTS FROM DBA_TABLES WHERE TABLE_NAME = 'SPA\$_SQLSET_STATEMENTS';
    IF L_TABLE_EXISTS > 0 THEN
      EXECUTE IMMEDIATE 'DROP TABLE SPA\$_SQLSET_STATEMENTS PURGE';
    END IF;
    EXECUTE IMMEDIATE 'CREATE TABLE SPA\$_SQLSET_STATEMENTS AS SELECT * FROM WRI\$_SQLSET_STATEMENTS';
  END;
  /";
  executeSQL($sqlSTMT);
  printLOG('   Backup Table [WRI$_SQLSET_DEFINITIONS]');
  $sqlSTMT = "DECLARE
    L_TABLE_EXISTS   NUMBER :=0;
  BEGIN
    SELECT COUNT(*) INTO L_TABLE_EXISTS FROM DBA_TABLES WHERE TABLE_NAME = 'SPA\$_SQLSET_DEFINITIONS';
    IF L_TABLE_EXISTS > 0 THEN
      EXECUTE IMMEDIATE 'DROP TABLE SPA\$_SQLSET_DEFINITIONS PURGE';
    END IF;
    EXECUTE IMMEDIATE 'CREATE TABLE SPA\$_SQLSET_DEFINITIONS AS SELECT * FROM WRI\$_SQLSET_DEFINITIONS';
  END;
  /";
  executeSQL($sqlSTMT);
  printLOG('Backup AWR Base Table We Need to Change', 'OK');


  # 8. Modify Contents of AWR Base Table
  printLOG('Modify Contents of AWR Base Table', 'Begin');
  printLOG('   Modify Table [WRI$_ADV_TASKS]');
  $sqlSTMT = "UPDATE WRI\$_ADV_TASKS SET NAME = '$spaTaskPrefix' WHERE NAME = '$spaTaskPrefix"."_0';";
  executeSQL($sqlSTMT);
  printLOG('   Modify Table [WRI$_ADV_OBJECTS]');
  $sqlSTMT = "UPDATE WRI\$_ADV_OBJECTS SET ATTR1='$sqlsetName' WHERE ATTR1='$sqlsetName"."_0' AND ID = 1 AND TYPE = 8 AND TASK_ID = (SELECT ID FROM WRI\$_ADV_TASKS WHERE NAME = '$spaTaskPrefix');";
  executeSQL($sqlSTMT);
  printLOG('   Modify Object Relation between Table [WRI$_ADV_SQLT_PLAN_HASH], [WRI$_ADV_FINDINGS], [WRI$_ADV_OBJECTS]');
  $sqlSTMT = "DECLARE
    L_OBJ_ID    NUMBER  := 0;
    L_MIN_TASK  NUMBER  := 0;
  BEGIN
    SELECT ID INTO L_MIN_TASK FROM WRI\$_ADV_TASKS WHERE NAME = '$spaTaskPrefix';
    FOR X IN (SELECT TASK_ID, COUNT(*) CNT FROM WRI\$_ADV_FINDINGS WHERE EXEC_NAME = '$spaTaskPrefix"."_11G' GROUP BY TASK_ID ORDER BY TASK_ID)
    LOOP
      UPDATE WRI\$_ADV_FINDINGS SET ID = ID + L_OBJ_ID WHERE TASK_ID = X.TASK_ID AND EXEC_NAME = '$spaTaskPrefix"."_11G';
      L_OBJ_ID := L_OBJ_ID + X.CNT;
    END LOOP;
    L_OBJ_ID := 3;
    FOR X IN (SELECT TASK_ID, ID, EXEC_NAME
                FROM WRI\$_ADV_OBJECTS
               WHERE TASK_ID IN (SELECT ID FROM WRI\$_ADV_TASKS WHERE NAME LIKE '$spaTaskPrefix"."%')
                 AND ID >= 3
                 AND EXEC_NAME = '$spaTaskPrefix"."_11G'
               ORDER BY TASK_ID, ID)
    LOOP
      UPDATE WRI\$_ADV_OBJECTS
         SET TASK_ID = L_MIN_TASK, ID = L_OBJ_ID
       WHERE TASK_ID = X.TASK_ID AND ID = X.ID AND EXEC_NAME = X.EXEC_NAME;
      UPDATE WRI\$_ADV_FINDINGS
         SET TASK_ID = L_MIN_TASK, OBJ_ID = L_OBJ_ID
       WHERE TASK_ID = X.TASK_ID AND OBJ_ID = X.ID AND EXEC_NAME = X.EXEC_NAME;
      UPDATE WRI\$_ADV_SQLT_PLAN_HASH
         SET TASK_ID = L_MIN_TASK, OBJECT_ID = L_OBJ_ID
       WHERE TASK_ID = X.TASK_ID AND OBJECT_ID = X.ID AND EXEC_NAME = X.EXEC_NAME;
      L_OBJ_ID := L_OBJ_ID + 1;
    END LOOP;
  END;
  /";
  executeSQL($sqlSTMT);
  printLOG('   Modify Table [WRI$_SQLSET_STATEMENTS]');
  $sqlSTMT = "UPDATE WRI\$_SQLSET_STATEMENTS
     SET SQLSET_ID = (SELECT MIN(ID) FROM WRI\$_SQLSET_DEFINITIONS WHERE OWNER = '$sqlsetOwner' AND NAME LIKE '$sqlsetName"."_%')
   WHERE SQLSET_ID IN (SELECT ID FROM WRI\$_SQLSET_DEFINITIONS WHERE OWNER = '$sqlsetOwner' AND NAME LIKE '$sqlsetName"."_%');";
  executeSQL($sqlSTMT);
  printLOG('   Modify Table [WRI$_SQLSET_DEFINITIONS]');
  $sqlSTMT = "UPDATE WRI\$_SQLSET_DEFINITIONS
     SET NAME = '$sqlsetName', STATEMENT_COUNT = (SELECT SUM(STATEMENT_COUNT) FROM WRI\$_SQLSET_DEFINITIONS WHERE NAME LIKE '$sqlsetName"."_%' AND OWNER = '$sqlsetOwner')
   WHERE ID = (SELECT MIN(ID) FROM WRI\$_SQLSET_DEFINITIONS WHERE OWNER = '$sqlsetOwner' AND NAME LIKE '$sqlsetName"."_%');";
  executeSQL($sqlSTMT);
  printLOG('Modify Contents of AWR Base Table', 'OK');
}

#########################################################################
##                                                                     ##
## Execute Compare Task                                                ##
##                                                                     ##
#########################################################################
sub execCompare{

  printLOG('do Compare Task', 'Begin');
  printLOG('   do Compare Task for [Elapsed Time]');
  my $sqlSTMT = "CONN $sqlsetOwner/$sqlsetOwnerPass
  EXEC DBMS_SQLPA.EXECUTE_ANALYSIS_TASK( -
                  TASK_NAME      => '$spaTaskPrefix', -
                  EXECUTION_TYPE => 'compare performance', -
                  EXECUTION_NAME => '$spaTaskPrefix'||'_COMP_ET', -
                  EXECUTION_PARAMS => DBMS_ADVISOR.ARGLIST( -
                                                   'COMPARISON_METRIC', 'ELAPSED_TIME', -
                                                   'EXECUTION_NAME1','$spaTaskPrefix'||'_10G', -
                                                   'EXECUTION_NAME2','$spaTaskPrefix'||'_11G'), -
                  EXECUTION_DESC => 'Compare SQLs between 10g and 11g on :'||TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));";
  executeSQL($sqlSTMT);
  printLOG('   do Compare Task for [Buffer Gets]');
  $sqlSTMT = "CONN $sqlsetOwner/$sqlsetOwnerPass
  EXEC DBMS_SQLPA.EXECUTE_ANALYSIS_TASK( -
                  TASK_NAME      => '$spaTaskPrefix', -
                  EXECUTION_TYPE => 'compare performance', -
                  EXECUTION_NAME => '$spaTaskPrefix'||'_COMP_BG', -
                  EXECUTION_PARAMS => DBMS_ADVISOR.ARGLIST( -
                                                   'COMPARISON_METRIC', 'BUFFER_GETS', -
                                                   'EXECUTION_NAME1','$spaTaskPrefix'||'_10G', -
                                                   'EXECUTION_NAME2','$spaTaskPrefix'||'_11G'), -
                  EXECUTION_DESC => 'Compare SQLs between 10g and 11g on :'||TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));";
  executeSQL($sqlSTMT);
  printLOG('do Compare Task', 'OK');
}

#########################################################################
##                                                                     ##
## Get SPA Reports                                                     ##
##                                                                     ##
#########################################################################
sub getReports{

  printLOG('Get SPA Reports', 'Begin');
  printLOG('   Fix Numberic Error [ORA-01426] by Reduce Executions');
  my $sqlSTMT = "UPDATE WRI\$_SQLSET_STATISTICS
     SET ELAPSED_TIME = ELAPSED_TIME/10
       , CPU_TIME = CPU_TIME/10
       , BUFFER_GETS = BUFFER_GETS/10
       , DISK_READS = DISK_READS/10
       , DIRECT_WRITES = DIRECT_WRITES/10
       , ROWS_PROCESSED = ROWS_PROCESSED/10
       , FETCHES = FETCHES/10
       , EXECUTIONS = EXECUTIONS/10
   WHERE EXECUTIONS>2147483647;";
  executeSQL($sqlSTMT);

  printLOG('   Get Report for [Elapsed Time] for type [All]');
  $sqlSTMT = "CONN $sqlsetOwner/$sqlsetOwnerPass
  ALTER SESSION SET EVENTS='31156 TRACE NAME CONTEXT FOREVER, LEVEL 0X400';
  SET LINES 1111 PAGES 50000 LONG 1999999999 TRIM ON TRIMS ON SERVEROUTPUT ON SIZE UNLIMITED
  SPOOL elapsed_all.html
  SELECT XMLTYPE(DBMS_SQLPA.REPORT_ANALYSIS_TASK('$spaTaskPrefix','HTML','ALL','ALL',NULL,100,'$spaTaskPrefix'||'_COMP_ET')).GETCLOBVAL(0,0) FROM DUAL;";
  executeSQL($sqlSTMT);

  printLOG('   Get Report for [Buffer Gets] for type [All]');
  $sqlSTMT = "CONN $sqlsetOwner/$sqlsetOwnerPass
  ALTER SESSION SET EVENTS='31156 TRACE NAME CONTEXT FOREVER, LEVEL 0X400';
  SET LINES 1111 PAGES 50000 LONG 1999999999 TRIM ON TRIMS ON SERVEROUTPUT ON SIZE UNLIMITED
  SPOOL buffer_all.html
  SELECT XMLTYPE(DBMS_SQLPA.REPORT_ANALYSIS_TASK('$spaTaskPrefix','HTML','ALL','ALL',NULL,100,'$spaTaskPrefix'||'_COMP_BG')).GETCLOBVAL(0,0) FROM DUAL;";
  executeSQL($sqlSTMT);

  printLOG('   Get Error SQL Report');
  $sqlSTMT = "CONN $sqlsetOwner/$sqlsetOwnerPass
  ALTER SESSION SET EVENTS='31156 TRACE NAME CONTEXT FOREVER, LEVEL 0X400';
  SET LINES 1111 PAGES 50000 LONG 1999999999 TRIM ON TRIMS ON SERVEROUTPUT ON SIZE UNLIMITED
  SPOOL error.html
  SELECT XMLTYPE(DBMS_SQLPA.REPORT_ANALYSIS_TASK('$spaTaskPrefix','HTML','ERRORS','ALL',NULL,10000,'$spaTaskPrefix'||'_COMP_ET')).GETCLOBVAL(0,0) FROM DUAL;";
  executeSQL($sqlSTMT);

  printLOG('   Get Unsupported SQL Report');
  $sqlSTMT = "CONN $sqlsetOwner/$sqlsetOwnerPass
  ALTER SESSION SET EVENTS='31156 TRACE NAME CONTEXT FOREVER, LEVEL 0X400';
  SET LINES 1111 PAGES 50000 LONG 1999999999 TRIM ON TRIMS ON SERVEROUTPUT ON SIZE UNLIMITED
  SPOOL unsupported.html
  SELECT XMLTYPE(DBMS_SQLPA.REPORT_ANALYSIS_TASK('$spaTaskPrefix','HTML','UNSUPPORTED','ALL',NULL,10000,'$spaTaskPrefix'||'_COMP_ET')).GETCLOBVAL(0,0) FROM DUAL;";
  executeSQL($sqlSTMT);

  printLOG('Get SPA Reports', 'OK');
}

#########################################################################
##                                                                     ##
## Main Function                                                       ##
##                                                                     ##
#########################################################################

# 0. Check Environment
preCheck;

# 1. Remove Needless SQLs
preProcess;

# 2. Split SQL in SQL Set Staging Table
splitSQLSet;

# 3. Unpack SQL Set from Temporary Created Table
unpackSQLSet;

# 4. Create Analysis Task
createTasks;

# 5. Create SPA Trail for Prod (Convert SQLSET)
convertTrail;

# 6. Create SPA Trail for Test (Test Execute)
executeTrail;

# 7. Backup AWR Base Table We Need to Change
mergeTasks;

# 8. do Compare Task
execCompare;

# 9. Get SPA Reports
getReports;
