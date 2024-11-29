set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col owner for a20
col table_name for a35
col constraint_name for a30
col columns for a40


PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display table have no index on foreign key column                      |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT owner prompt 'Enter Search Object Owner (i.e. SCOTT) : '

SELECT owner,
       table_name,
       constraint_name,
          cname1
       || NVL2 (cname2, ',' || cname2, NULL)
       || NVL2 (cname3, ',' || cname3, NULL)
       || NVL2 (cname4, ',' || cname4, NULL)
       || NVL2 (cname5, ',' || cname5, NULL)
       || NVL2 (cname6, ',' || cname6, NULL)
       || NVL2 (cname7, ',' || cname7, NULL)
       || NVL2 (cname8, ',' || cname8, NULL)
          columns
  FROM (  SELECT c.owner,
                 b.table_name,
                 b.constraint_name,
                 MAX (DECODE (position, 1, column_name, NULL)) cname1,
                 MAX (DECODE (position, 2, column_name, NULL)) cname2,
                 MAX (DECODE (position, 3, column_name, NULL)) cname3,
                 MAX (DECODE (position, 4, column_name, NULL)) cname4,
                 MAX (DECODE (position, 5, column_name, NULL)) cname5,
                 MAX (DECODE (position, 6, column_name, NULL)) cname6,
                 MAX (DECODE (position, 7, column_name, NULL)) cname7,
                 MAX (DECODE (position, 8, column_name, NULL)) cname8,
                 COUNT (*) col_cnt
            FROM (SELECT SUBSTR (table_name, 1, 30) table_name,
                         SUBSTR (constraint_name, 1, 30) constraint_name,
                         SUBSTR (column_name, 1, 30) column_name,
                         position
                    FROM dba_cons_columns) a,
                 dba_constraints b,
                 dba_tables c
           WHERE     a.constraint_name = b.constraint_name
                 AND b.constraint_type = 'R'
                 AND b.table_name = c.table_name
                 AND c.owner = UPPER ('&owner')
        GROUP BY c.owner, b.table_name, b.constraint_name) cons
 WHERE col_cnt >
          ALL (  SELECT COUNT (*)
                   FROM dba_ind_columns i
                  WHERE     i.table_name = cons.table_name
                        AND i.column_name IN
                               (cname1,
                                cname2,
                                cname3,
                                cname4,
                                cname5,
                                cname6,
                                cname7,
                                cname8)
                        AND i.column_position <= cons.col_cnt
               GROUP BY i.index_name)
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

