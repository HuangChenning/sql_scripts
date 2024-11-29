set echo off;
set lines 200 pages 100 verify off heading on
col scn for 9999999999999
col name for a20
col GUARANTEE_FLASHBACK_DATABASE heading 'GUAR'
col time for a19
col restore_point_time for a19
col preserved for a10 heading 'PRES'
SELECT scn,
       DATABASE_INCARNATION#,
       STORAGE_SIZE,
       TO_CHAR (time, 'yyyy-mm-dd hh24:mi:ss') time,
       TO_CHAR (RESTORE_POINT_TIME, 'yyyy-mm-dd hh24:mi:ss')
          restore_point_time,
       GUARANTEE_FLASHBACK_DATABASE,
       PRESERVED,
       NAME
  FROM v$restore_point
/