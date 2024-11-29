set echo off
set verify off
set lines 170
set pages 100
col owner for a20
col segment_name for a35
col segment_type for a15
col tablespace_name for a25
col partition_name for a35 heading 'Name|Partition'
col t_size for 99999999 heading 'Total|size(M)'
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | desc display a user OR all(not system sys) segment space used          |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT owner prompt 'Enter Search owner Name (i.e. SCOTT|ALL) : ' default 'ALL'
ACCEPT segment_name prompt 'Enter Search Segment Name (i.e. DEPT|ALL) : ' default 'ALL'
ACCEPT number prompt 'Enter Display rows Name (i.e. 20) : ' default '20'
SELECT *
  FROM (  SELECT owner,
                 segment_name,
                 segment_type,
                 partition_name,
                 tablespace_name,
                 ROUND (SUM (bytes)/1024/1024,2) t_size
            FROM dba_segments a
            WHERE owner = DECODE(upper('&owner'), 'ALL', owner, upper('&owner'))
            and owner not in ('SYS','SYSTEM')
           and segment_name= DECODE(UPPER('&segment_name'), 'ALL', segment_name, UPPER('&segment_name'))
        GROUP BY a.owner, a.segment_name,segment_type, a.partition_name,tablespace_name
        ORDER BY t_size DESC)
 WHERE ROWNUM < &number
/
