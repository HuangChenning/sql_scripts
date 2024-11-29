set echo off lines 300 pages 100 heading on verify off serveroutput on
col name for a25
col status for a10
col tablespace_name for a20 heading 'TABLESPACE'
col resize for 9999999 heading 'RESIZE(M)'
col xacts for 999999 heading 'ACTIVE|TRANS'
col gets for 999999 heading 'HEADER|GETS'
col waits for 999999 heading 'HEADER|WAITS'
col optsize for 999999 heading 'OPT|SIZE(M)'
col shrinks for 9999999 heading 'NUM|SHRINKS'
col wraps for 999999 heading 'NUM|WRAPS'
col extends for 999999 heading 'NUM|EXTENDS'
col curext for 999999 heading 'CURRENT|EXTENT'
col curblk for 99999999 heading 'CURRENT|BLOCK'
break on tablespace_name;
SELECT C.TABLESPACE_NAME,
       a.name,
       s.status,
       ROUND (RSSIZE / 1024 / 1024) RSSIZE,
       xacts,
       gets,
       waits,
       ROUND (optsize / 1024 / 1024) optsize,
       SHRINKS,
       wraps,
       extends,
       curext,
       curblk
  FROM v$rollstat s, v$rollname a, dba_rollback_segs c
 WHERE s.usn = a.usn AND s.usn(+) = C.SEGMENT_ID
 order by tablespace_name;
set echo on