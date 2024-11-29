set echo off
store set sqlplusset replace
set verify off
set lines 200
set pages 1000
col t_t_n for a40 heading 'Owner|Table_name'
col tablespace_name for a15 heading 'Tablespace|Name'
col partitioned for a4 heading 'Part'
col temporary for a4 heading 'Temp'
col num_rows for 99999999999999
col avg_row_len for 999 heading 'Avg|Row|Len'
col l_time for a19 heading 'last |analyzed'
col pct_free for 9999 heading 'Pct|Free'
col pct_used for 9999 heading 'Pct|Used'
col t_size for a15 heading 'Table|SIZE KB'
col degree for a6 heading 'DEGREE' 
break on t_t_n
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display one table or all tble info                             |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

ACCEPT owner prompt 'Enter Search Table Owner (i.e. DEPT|DEFAULT(ALL)) : '
ACCEPT name prompt 'Enter Search Table Name (i.e. DEPT|DEFAULT(ALL)) : ' 



SELECT   t.owner||':'||t.table_name "t_t_n",
         t.tablespace_name,
         t.partitioned,
         t.ini_trans,
         t.max_trans,
         t.temporary,
         t.num_rows,
         t.avg_row_len,
	 trim(t.degree) degree,
         TRUNC ( (t.blocks * p.VALUE) / 1024) || 'KB' t_size,
         TO_CHAR (t.last_analyzed, 'yyyy-mm-dd hh24:mi:ss') l_time,
         t.pct_free,
         t.pct_used
    FROM sys.dba_tables t, sys.v$parameter p
   WHERE     
         t.table_name =
                DECODE (UPPER ('&name'),
                        'ALL', t.table_name,
                        UPPER ('&name'))
         AND p.name = 'db_block_size'
         and t.owner=nvl(upper('&owner'),t.owner)
ORDER BY t.table_name,t.tablespace_name;
ACCEPT partname prompt 'Enter Search Part Name (i.e. DEPT)) : ' 
exec dbms_stats.delete_table_stats(ownname=>upper('&owner'),tabname=>upper('&name'),partname=>upper('&partname'),cascade_parts=>TRUE);

SELECT   t.owner||':'||t.table_name "t_t_n",
         t.tablespace_name,
         t.partitioned,
         t.ini_trans,
         t.max_trans,
         t.temporary,
         t.num_rows,
         t.avg_row_len,
	 trim(t.degree) degree,
         TRUNC ( (t.blocks * p.VALUE) / 1024) || 'KB' t_size,
         TO_CHAR (t.last_analyzed, 'yyyy-mm-dd hh24:mi:ss') l_time,
         t.pct_free,
         t.pct_used
    FROM sys.dba_tables t, sys.v$parameter p
   WHERE     
         t.table_name =
                DECODE (UPPER ('&name'),
                        'ALL', t.table_name,
                        UPPER ('&name'))
         AND p.name = 'db_block_size'
         and t.owner=nvl(upper('&owner'),t.owner)
ORDER BY t.table_name,t.tablespace_name;
 
