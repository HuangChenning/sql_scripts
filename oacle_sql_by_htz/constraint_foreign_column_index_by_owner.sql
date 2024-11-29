set echo off
set lines 300
set pages 40
set verify off
col owner for a20
col constraint_name for a40
col table_name for a40
col column_name for a40
col index_column for a40
SELECT DISTINCT a.owner,
                  a.constraint_name,
                  a.table_name,
                  b.column_name,
                  NVL (c.column_name, '***check index***') index_column
    FROM dba_constraints a, dba_cons_columns b, dba_ind_columns c
   WHERE     constraint_type = 'R'
         AND a.owner = UPPER ('&owner')
         AND a.owner = b.owner
         AND a.constraint_name = b.constraint_name
         AND b.column_name = c.column_name(+)
         AND b.table_name = c.table_name(+)
         AND b.position = c.column_position(+)
ORDER BY table_name, column_name
/
undefine owner;
