col name	format a22 heading 'Name'
set verify off
set echo off
set lines 2000
col name for a30 heading 'Constraint|Name'
col type	format a20  heading 'Type'
col stat	format a10  heading 'status'
col ref_tab	format a20 heading 'Reference|Object' 
col ref_con	format a22 heading 'Reference|Constraint'
col index_name for a20 heading 'Index |Name'
col column_name for a15 heading 'Column|Name'
col owner_name for a35 heading 'Owner|tablename'
set pages 10000
ACCEPT owner prompt 'Enter table owner (i.e. SCOTT) : '
break on owner_name
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display table's constraints info                                       |
PROMPT +------------------------------------------------------------------------+ 
 
  SELECT a.owner || ':' || a.table_name owner_name,
         a.constraint_name name,
         c.column_name,
         DECODE (a.constraint_type,
                 'C', 'Check or Not null',
                 'R', 'Foreign Key',
                 'P', 'Primary key',
                 'U', 'Unique',
                 '*')
            TYPE,
         a.status,
         b.owner || '.' || b.table_name ref_tab,
         a.r_constraint_name ref_con,
         a.index_name
    FROM dba_constraints a, dba_constraints b, dba_cons_columns c
   WHERE     a.owner = UPPER ('&owner')
         AND a.r_constraint_name = b.constraint_name(+)
         AND a.constraint_name = c.constraint_name
ORDER BY 1
/ 
 
clear breaks
