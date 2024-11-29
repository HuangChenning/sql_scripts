/* Formatted on 2012-11-2 10:50:55 (QP5 v5.185.11230.41888) */ 
set lines 170
set feedback off
set long 1000
set echo off
set verify off
set pages 1000
col startup_time for a19 heading 'SNAP CREATE TIME'
col snap_id for 9999999999999
col sql_id for a20
col plan_hash_value for 9999999999999
col total_e for 9999999999 heading 'TOTAL DELTA|EXECUTIONS'
col object_name   for a20
col object_owner  for a20
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | DISPLAY FULL SCAN TABLE SQL FROM AWR                                   |
PROMPT | YOU MUST INPUT BEGIN SNAP_ID AND END SNAP_ID                           |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | DISPLAY CREATE SNAP ID TIME BEFOER INSTANCE START UP                   |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
@@awr_snapshot_info.sql
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | INPUT BEGIN SNAP_ID AND END SNAP_ID                    |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
 
ACCEPT beginsnap prompt 'Enter Search Begin Snap Id (i.e. 12345) : '

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | IF YOU INPUT 0 SNAP_ID  IS  MAX(SNAP_ID)                               |
PROMPT +------------------------------------------------------------------------+
PROMPT
ACCEPT endsnap prompt 'Enter Search End Snap Id (i.e. 12346) : '

Rem
Rem 
Rem ===================
Rem count end_snap value
set term off
col end_snap new_v i_end_snap
select DECODE(&endsnap,0, (select max(e.snap_id) from sys.DBA_HIST_SNAPSHOT e), &endsnap) end_snap from dual;
set term on
set feedback on

SELECT a.sql_id,
         a.plan_hash_value,
         SUM (a.EXECUTIONS_DELTA) total_e,
         b.object_name,
         b.object_owner
    FROM sys.dba_hist_sqlstat a, sys.DBA_HIST_SQL_PLAN b
   WHERE     a.snap_id > &beginsnap - 1
         AND a.snap_id < &i_end_snap + 1
         AND a.plan_hash_value = b.plan_hash_value
         AND a.sql_id = b.sql_id
         AND b.operation = 'TABLE ACCESS'
         AND b.options = 'FULL'
         AND b.object_owner NOT IN ('SYS', 'SYSTEM')
GROUP BY a.sql_id, a.plan_hash_value, b.object_owner,b.object_name
ORDER BY 3 
/


set lines 75
set pages 10
set feedback on
set echo on
