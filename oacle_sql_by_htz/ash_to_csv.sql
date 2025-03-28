column DELTA_WRITE_IO_BYTES format a24
column DELTA_READ_IO_BYTES format a24
column DELTA_WRITE_IO_REQUESTS format a24
column DELTA_READ_IO_REQUESTS format a24
column DELTA_TIME format a24
column TM_DELTA_DB_TIME format a24
column TM_DELTA_CPU_TIME format a24
column TM_DELTA_TIME format a24
column DBREPLAY_CALL_COUNTER format a24
column DBREPLAY_FILE_ID format a24
column ECID format a66
column PORT format a24
column MACHINE format a66
column CLIENT_ID format a66
column ACTION format a66
column MODULE format a66
column PROGRAM format a66
column SERVICE_HASH format a24
column IS_REPLAYED format a3
column IS_CAPTURED format a3
column REPLAY_OVERHEAD format a3
column CAPTURE_OVERHEAD format a3
column IN_SEQUENCE_LOAD format a3
column IN_CURSOR_CLOSE format a3
column IN_BIND format a3
column IN_JAVA_EXECUTION format a3
column IN_PLSQL_COMPILATION format a3
column IN_PLSQL_RPC format a3
column IN_PLSQL_EXECUTION format a3
column IN_SQL_EXECUTION format a3
column IN_HARD_PARSE format a3
column IN_PARSE format a3
column IN_CONNECTION_MGMT format a3
column TIME_MODEL format a24
column REMOTE_INSTANCE# format a24
column XID format a10
column CONSUMER_GROUP_ID format a24
column TOP_LEVEL_CALL_NAME format a66
column TOP_LEVEL_CALL# format a24
column CURRENT_ROW# format a24
column CURRENT_BLOCK# format a24
column CURRENT_FILE# format a24
column CURRENT_OBJ# format a24
column BLOCKING_HANGCHAIN_INFO format a3
column BLOCKING_INST_ID format a24
column BLOCKING_SESSION_SERIAL# format a24
column BLOCKING_SESSION format a24
column BLOCKING_SESSION_STATUS format a13
column TIME_WAITED format a24
column SESSION_STATE format a9
column WAIT_TIME format a24
column WAIT_CLASS_ID format a24
column WAIT_CLASS format a66
column P3 format a24
column P3TEXT format a66
column P2 format a24
column P2TEXT format a66
column P1 format a24
column P1TEXT format a66
column SEQ# format a24
column EVENT_ID format a24
column EVENT format a66
column PX_FLAGS format a24
column QC_SESSION_SERIAL# format a24
column QC_SESSION_ID format a24
column QC_INSTANCE_ID format a24
column PLSQL_SUBPROGRAM_ID format a24
column PLSQL_OBJECT_ID format a24
column PLSQL_ENTRY_SUBPROGRAM_ID format a24
column PLSQL_ENTRY_OBJECT_ID format a24
column SQL_EXEC_START format a9
column SQL_EXEC_ID format a24
column SQL_PLAN_OPTIONS format a66
column SQL_PLAN_OPERATION format a66
column SQL_PLAN_LINE_ID format a24
column SQL_PLAN_HASH_VALUE format a24
column TOP_LEVEL_SQL_OPCODE format a24
column TOP_LEVEL_SQL_ID format a15
column FORCE_MATCHING_SIGNATURE format a24
column SQL_OPNAME format a66
column SQL_OPCODE format a24
column SQL_CHILD_NUMBER format a24
column IS_SQLID_CURRENT format a3
column SQL_ID format a15
column USER_ID format a24
column FLAGS format a24
column SESSION_TYPE format a12
column SESSION_SERIAL# format a24
column SESSION_ID format a24
column SAMPLE_TIME format a13
column SAMPLE_ID format a24
column INSTANCE_NUMBER format a24
column DBID format a24
column SNAP_ID format a24
column TEMP_SPACE_ALLOCATED format a24
column PGA_ALLOCATED format a24
column DELTA_INTERCONNECT_IO_BYTES format a24
undefine begin_date;


set pages 2000
set lines 2750
set heading off
set feedback off
set echo off

! echo "SNAP_ID , DBID , INSTANCE_NUMBER , SAMPLE_ID , SAMPLE_TIME , SESSION_ID , SESSION_SERIAL# , SESSION_TYPE , FLAGS , USER_ID , SQL_ID ,"-
"IS_SQLID_CURRENT , SQL_CHILD_NUMBER , SQL_OPCODE , SQL_OPNAME , FORCE_MATCHING_SIGNATURE , TOP_LEVEL_SQL_ID , TOP_LEVEL_SQL_OPCODE , "-
"SQL_PLAN_HASH_VALUE , SQL_PLAN_LINE_ID , SQL_PLAN_OPERATION , SQL_PLAN_OPTIONS , SQL_EXEC_ID , SQL_EXEC_START , PLSQL_ENTRY_OBJECT_ID,"-
"PLSQL_ENTRY_SUBPROGRAM_ID , PLSQL_OBJECT_ID , PLSQL_SUBPROGRAM_ID , QC_INSTANCE_ID , QC_SESSION_ID , QC_SESSION_SERIAL# , PX_FLAGS , EVENT ,"-
" EVENT_ID , SEQ# , P1TEXT , P1 , P2TEXT , P2 , P3TEXT , P3 , WAIT_CLASS , WAIT_CLASS_ID , WAIT_TIME , SESSION_STATE , TIME_WAITED ,"-
"BLOCKING_SESSION_STATUS , BLOCKING_SESSION , BLOCKING_SESSION_SERIAL# , BLOCKING_INST_ID , BLOCKING_HANGCHAIN_INFO , CURRENT_OBJ# , "-
"CURRENT_FILE# , CURRENT_BLOCK# , CURRENT_ROW# , TOP_LEVEL_CALL# , TOP_LEVEL_CALL_NAME , CONSUMER_GROUP_ID , XID , REMOTE_INSTANCE# , TIME_MODEL ,"-
"IN_CONNECTION_MGMT , IN_PARSE , IN_HARD_PARSE , IN_SQL_EXECUTION , IN_PLSQL_EXECUTION , IN_PLSQL_RPC , IN_PLSQL_COMPILATION , IN_JAVA_EXECUTION ,"-
" IN_BIND , IN_CURSOR_CLOSE , IN_SEQUENCE_LOAD , CAPTURE_OVERHEAD , REPLAY_OVERHEAD , IS_CAPTURED , IS_REPLAYED , SERVICE_HASH , PROGRAM , MODULE ,"-
" ACTION , CLIENT_ID , MACHINE , PORT , ECID , DBREPLAY_FILE_ID , DBREPLAY_CALL_COUNTER , TM_DELTA_TIME , TM_DELTA_CPU_TIME , TM_DELTA_DB_TIME , "-
"DELTA_TIME , DELTA_READ_IO_REQUESTS , DELTA_WRITE_IO_REQUESTS , DELTA_READ_IO_BYTES , DELTA_WRITE_IO_BYTES , DELTA_INTERCONNECT_IO_BYTES , "-
"PGA_ALLOCATED , TEMP_SPACE_ALLOCATED " > myash.csv

spool myash.csv append
select SNAP_ID ||','|| DBID ||','|| INSTANCE_NUMBER ||','|| SAMPLE_ID ||','|| SAMPLE_TIME ||','|| SESSION_ID ||','|| SESSION_SERIAL# ||','|| -
SESSION_TYPE ||','|| FLAGS ||','|| USER_ID ||','|| SQL_ID ||','|| IS_SQLID_CURRENT ||','|| SQL_CHILD_NUMBER ||','|| SQL_OPCODE ||','|| SQL_OPNAME -
||','|| FORCE_MATCHING_SIGNATURE ||','|| TOP_LEVEL_SQL_ID ||','|| TOP_LEVEL_SQL_OPCODE ||','|| SQL_PLAN_HASH_VALUE ||','|| SQL_PLAN_LINE_ID -
||','|| SQL_PLAN_OPERATION ||','|| SQL_PLAN_OPTIONS ||','|| SQL_EXEC_ID ||','|| SQL_EXEC_START ||','|| PLSQL_ENTRY_OBJECT_ID ||','|| -
PLSQL_ENTRY_SUBPROGRAM_ID ||','|| PLSQL_OBJECT_ID ||','|| PLSQL_SUBPROGRAM_ID ||','|| QC_INSTANCE_ID ||','|| QC_SESSION_ID ||','|| QC_SESSION_SERIAL#- 
||','|| PX_FLAGS ||','|| EVENT ||','|| EVENT_ID ||','|| SEQ# ||','|| P1TEXT ||','|| P1 ||','|| P2TEXT ||','|| P2 ||','|| P3TEXT ||','|| P3 ||','|| -
WAIT_CLASS ||','|| WAIT_CLASS_ID ||','|| WAIT_TIME ||','|| SESSION_STATE ||','|| TIME_WAITED ||','|| BLOCKING_SESSION_STATUS ||','|| BLOCKING_SESSION-
||','|| BLOCKING_SESSION_SERIAL# ||','|| BLOCKING_INST_ID ||','|| BLOCKING_HANGCHAIN_INFO ||','|| CURRENT_OBJ# ||','|| CURRENT_FILE# ||','|| -
CURRENT_BLOCK# ||','|| CURRENT_ROW# ||','|| TOP_LEVEL_CALL# ||','|| TOP_LEVEL_CALL_NAME ||','|| CONSUMER_GROUP_ID ||','|| XID ||','|| -
REMOTE_INSTANCE# ||','|| TIME_MODEL ||','|| IN_CONNECTION_MGMT ||','|| IN_PARSE ||','|| IN_HARD_PARSE ||','|| IN_SQL_EXECUTION ||','|| -
IN_PLSQL_EXECUTION ||','|| IN_PLSQL_RPC ||','|| IN_PLSQL_COMPILATION ||','|| IN_JAVA_EXECUTION ||','|| IN_BIND ||','|| IN_CURSOR_CLOSE ||','|| -
IN_SEQUENCE_LOAD ||','|| CAPTURE_OVERHEAD ||','|| REPLAY_OVERHEAD ||','|| IS_CAPTURED ||','|| IS_REPLAYED ||','|| SERVICE_HASH ||','|| -
PROGRAM ||','|| MODULE ||','|| ACTION ||','|| CLIENT_ID ||','|| MACHINE ||','|| PORT ||','|| ECID ||','|| DBREPLAY_FILE_ID ||','|| -
DBREPLAY_CALL_COUNTER ||','|| TM_DELTA_TIME ||','|| TM_DELTA_CPU_TIME ||','|| TM_DELTA_DB_TIME ||','|| DELTA_TIME ||','|| -
DELTA_READ_IO_REQUESTS ||','|| DELTA_WRITE_IO_REQUESTS ||','|| DELTA_READ_IO_BYTES ||','|| DELTA_WRITE_IO_BYTES ||','|| -
DELTA_INTERCONNECT_IO_BYTES ||','|| PGA_ALLOCATED ||','|| TEMP_SPACE_ALLOCATED 
From gv$active_session_history
 where SAMPLE_TIME >= to_date('&&begin_date', 'yyyy-mm-dd hh24:mi:ss')
   AND SAMPLE_TIME <= to_date('&&begin_date', 'yyyy-mm-dd hh24:mi:ss') +
       nvl(&&interval_hours, 2) / 24
Order by sample_time, session_id asc;
select SNAP_ID ||','|| DBID ||','|| INSTANCE_NUMBER ||','|| SAMPLE_ID ||','|| SAMPLE_TIME ||','|| SESSION_ID ||','|| SESSION_SERIAL# ||','|| -
SESSION_TYPE ||','|| FLAGS ||','|| USER_ID ||','|| SQL_ID ||','|| IS_SQLID_CURRENT ||','|| SQL_CHILD_NUMBER ||','|| SQL_OPCODE ||','|| SQL_OPNAME -
||','|| FORCE_MATCHING_SIGNATURE ||','|| TOP_LEVEL_SQL_ID ||','|| TOP_LEVEL_SQL_OPCODE ||','|| SQL_PLAN_HASH_VALUE ||','|| SQL_PLAN_LINE_ID -
||','|| SQL_PLAN_OPERATION ||','|| SQL_PLAN_OPTIONS ||','|| SQL_EXEC_ID ||','|| SQL_EXEC_START ||','|| PLSQL_ENTRY_OBJECT_ID ||','|| -
PLSQL_ENTRY_SUBPROGRAM_ID ||','|| PLSQL_OBJECT_ID ||','|| PLSQL_SUBPROGRAM_ID ||','|| QC_INSTANCE_ID ||','|| QC_SESSION_ID ||','|| QC_SESSION_SERIAL#- 
||','|| PX_FLAGS ||','|| EVENT ||','|| EVENT_ID ||','|| SEQ# ||','|| P1TEXT ||','|| P1 ||','|| P2TEXT ||','|| P2 ||','|| P3TEXT ||','|| P3 ||','|| -
WAIT_CLASS ||','|| WAIT_CLASS_ID ||','|| WAIT_TIME ||','|| SESSION_STATE ||','|| TIME_WAITED ||','|| BLOCKING_SESSION_STATUS ||','|| BLOCKING_SESSION-
||','|| BLOCKING_SESSION_SERIAL# ||','|| BLOCKING_INST_ID ||','|| BLOCKING_HANGCHAIN_INFO ||','|| CURRENT_OBJ# ||','|| CURRENT_FILE# ||','|| -
CURRENT_BLOCK# ||','|| CURRENT_ROW# ||','|| TOP_LEVEL_CALL# ||','|| TOP_LEVEL_CALL_NAME ||','|| CONSUMER_GROUP_ID ||','|| XID ||','|| -
REMOTE_INSTANCE# ||','|| TIME_MODEL ||','|| IN_CONNECTION_MGMT ||','|| IN_PARSE ||','|| IN_HARD_PARSE ||','|| IN_SQL_EXECUTION ||','|| -
IN_PLSQL_EXECUTION ||','|| IN_PLSQL_RPC ||','|| IN_PLSQL_COMPILATION ||','|| IN_JAVA_EXECUTION ||','|| IN_BIND ||','|| IN_CURSOR_CLOSE ||','|| -
IN_SEQUENCE_LOAD ||','|| CAPTURE_OVERHEAD ||','|| REPLAY_OVERHEAD ||','|| IS_CAPTURED ||','|| IS_REPLAYED ||','|| SERVICE_HASH ||','|| -
PROGRAM ||','|| MODULE ||','|| ACTION ||','|| CLIENT_ID ||','|| MACHINE ||','|| PORT ||','|| ECID ||','|| DBREPLAY_FILE_ID ||','|| -
DBREPLAY_CALL_COUNTER ||','|| TM_DELTA_TIME ||','|| TM_DELTA_CPU_TIME ||','|| TM_DELTA_DB_TIME ||','|| DELTA_TIME ||','|| -
DELTA_READ_IO_REQUESTS ||','|| DELTA_WRITE_IO_REQUESTS ||','|| DELTA_READ_IO_BYTES ||','|| DELTA_WRITE_IO_BYTES ||','|| -
DELTA_INTERCONNECT_IO_BYTES ||','|| PGA_ALLOCATED ||','|| TEMP_SPACE_ALLOCATED 
From DBA_HIST_ACTIVE_SESS_HISTORY
 where SAMPLE_TIME >= to_date('&&begin_date', 'yyyy-mm-dd hh24:mi:ss')
   AND SAMPLE_TIME <= to_date('&&begin_date', 'yyyy-mm-dd hh24:mi:ss') +
       nvl(&&interval_hours, 2) / 24
Order by sample_time, session_id asc;
spool off;
undefine begin_date;