set echo off
set lines 170
set pages 1000
set verify off
col owner for a15
col table_name for a30
col partitioned for a5 heading 'Part'
col num_rows for 99999999999
col l_time for a19 heading 'Last Time|Analyzed'
col temporary for a5 heading 'Temp'
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display no index table  of user                                        |
PROMPT +------------------------------------------------------------------------+
PROMPT
ACCEPT table_owner prompt 'Enter Search Owner name (i.e. SCOTT) : '
  SELECT owner,
         table_name,
         partitioned,
         temporary,
         num_rows,
         TO_CHAR (last_analyzed, 'yyyy-mm-dd hh24:mi:ss') l_time
    FROM dba_tables a
   WHERE     a.owner = UPPER ('&table_owner')
         AND a.table_name NOT IN
                (SELECT b.table_name
                   FROM dba_indexes b
                  WHERE b.table_owner = UPPER ('&table_owner'))
ORDER BY num_rows DESC
/
