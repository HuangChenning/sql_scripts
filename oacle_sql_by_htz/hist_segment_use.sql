set verify off
set echo off
set lines 170
set pages 200
col end_time for a20  heading 'snap_create|end time'
col owner   for a20 heading 'object|owner'
col object_type for a15    heading 'object|type'
col object_name for a30   
col change_delta  for 999999 heading 'sum db block|change delta'
col used_delta for a14 heading 'sum space |  used delta'
col allocated_delta for a14 heading 'sum space|allocated_delta'

ACCEPT time prompt 'Enter Begin Time (i.e. 2012-10-22) : '
ACCEPT format prompt 'Enter to char format (i.e. YYYY-MM-DD) : '


PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | Display segment change info  but owner is not sys                      |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

SELECT TO_CHAR (b.END_INTERVAL_TIME, '&format') end_time,
         C.OWNER,
         c.object_type object_type,
         C.OBJECT_NAME object_name,
         SUM(A.DB_BLOCK_CHANGES_DELTA) change_delta,
        trunc(SUM(a.space_used_delta)/1024/1024)||'M' used_delta,
        trunc(SUM(a.space_allocated_delta)/1024/1024)||'M' allocated_delta
    FROM dba_hist_seg_stat a, dba_hist_snapshot b, dba_objects c
   WHERE     C.OBJECT_ID = A.OBJ#
         AND a.snap_id = b.snap_id
         AND B.END_INTERVAL_TIME >= TO_DATE ('&time', '&&format')
         AND c.owner <> 'SYS'
GROUP BY TO_CHAR (b.END_INTERVAL_TIME, '&&format'),
         c.owner,
         c.object_type,
         c.object_name
ORDER BY 1 DESC, 5 DESC
/