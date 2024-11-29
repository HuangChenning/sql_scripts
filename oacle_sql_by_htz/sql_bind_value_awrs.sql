set echo off
set lines 200 pages 20000 verify off heading on
col snap_id for 99999999
col begin_time for a10
col instance_number for 99 heading 'I'
col name for a15
col datatype_string for 20 heading 'COLUMN_TYPE';
col value_string for a60
undefine sqlid;
SELECT a.snap_id,
         TO_CHAR (b.BEGIN_INTERVAL_TIME, 'mm-dd hh24') begin_time,
         a.instance_number,
         a.name,
         a.DATATYPE_STRING,
         a.VALUE_STRING
    FROM dba_hist_sqlbind a, dba_hist_snapshot b
   WHERE     a.sql_id = '&sqlid'
         AND a.snap_id = b.snap_id
         AND a.dbid = b.dbid
         AND a.instance_number = b.instance_number
ORDER BY snap_id, instance_number, name;
undefine sqlid;