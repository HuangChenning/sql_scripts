set echo off
set verify off
set lines 170
set pages 40
col owner for a20

col segment_name for a35
col segment_type for a15
col partition_name for a35 heading 'Name|Partition'
col t_size for 99999999 heading 'Total|size(M)'
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | desc display a user OR all(not system sys) segment space used          |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

ACCEPT number prompt 'Enter Display rows Name (i.e. 20) : ' default '40'
SELECT *
  FROM (  SELECT a.tablespace_name,owner,
                 segment_name,
                 segment_type,
                 partition_name,
                 ROUND (SUM (bytes)/1024/1024,2) t_size
            FROM dba_segments a
            WHERE a.tablespace_name=nvl(upper('&tablespace_name'),a.tablespace_name)
        GROUP BY a.tablespace_name,a.owner, a.segment_name,segment_type, a.partition_name
        ORDER BY t_size DESC)
 WHERE ROWNUM < &number
/

undefine tablespace_name