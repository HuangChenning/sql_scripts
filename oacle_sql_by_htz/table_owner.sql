set echo off
set verify off
set lines 200
set pages 1000
col t_t_n for a30 heading 'Table_name'
col tablespace_name for a15 heading 'Tablespace|Name'
col partitioned for a4 heading 'Part'
col temporary for a4 heading 'Temp'
col num_rows for 99999999999999
col avg_row_len for 999 heading 'Avg|Row|Len'
col l_time for a19 heading 'last |analyzed'
col pct_free for 9999 heading 'Pct|Free'
col pct_used for 9999 heading 'Pct|Used'
col t_size for a15 heading 'Table|SIZE KB'
break on t_t_n
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display one table or all tble info                             |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT owner prompt 'Enter Search Table Owner (i.e. SCOTT) : '
ACCEPT name prompt 'Enter Search Table Name (i.e. DEPT|DEFAULT(ALL)) : ' default 'ALL'


SELECT  t.table_name "t_t_n",
         t.tablespace_name,
         t.partitioned,
         t.ini_trans,
         t.max_trans,
         t.temporary,
         t.num_rows,
         t.avg_row_len,
	 t.degree,
         TRUNC ( (t.blocks * p.VALUE) / 1024) || 'KB' t_size,
         TO_CHAR (t.last_analyzed, 'yyyy-mm-dd hh24:mi:ss') l_time,
         t.pct_free,
         t.pct_used
    FROM sys.dba_tables t, sys.v$parameter p
   WHERE     t.owner = UPPER ('&owner')
         AND t.table_name =
                DECODE (UPPER ('&name'),
                        'ALL', t.table_name,
                        UPPER ('&name'))
         AND p.name = 'db_block_size'
ORDER BY t.table_name,t.tablespace_name;
 
