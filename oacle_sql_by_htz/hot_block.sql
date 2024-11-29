set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col segment_name for a35
col paratition_name for a15
col segment_type for a10
col tablespace_name for a15


select * from (select p1raw,count(*) total from v$session where event ='latch: cache buffers chains' group by p1raw) where rownum <30 order by total;

ACCEPT p1raw prompt 'Enter Search P1raw  (display in screen ) : '

SELECT /*+ RULE */
 E.OWNER || '.' || E.SEGMENT_NAME SEGMENT_NAME,
 E.PARTITION_NAME,
 e.segment_type,
 e.tablespace_name,
 E.EXTENT_ID EXTENT#,
 X.DBABLK - E.BLOCK_ID + 1 BLOCK#,
 X.TCH,
 L.CHILD#
  FROM SYS.V$LATCH_CHILDREN L, SYS.X$BH X, SYS.DBA_EXTENTS E
 WHERE X.HLADDR = '&p1raw' --p1raw
   AND E.FILE_ID = X.FILE#
   AND X.HLADDR = L.ADDR
   AND X.DBABLK BETWEEN E.BLOCK_ID AND E.BLOCK_ID + E.BLOCKS - 1
 ORDER BY X.TCH DESC

/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

