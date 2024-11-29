-- File Name : constraint_delete_repeat_check
-- Purpose : 删除系统中重复的check约束
-- Date : 20161018
-- 认真就输、QQ:7343696
-- http://www.htz.pw

DECLARE
   v_sql   VARCHAR2 (200);
BEGIN
   FOR t_cursor
      IN (SELECT *
            FROM (  SELECT a.owner,
                           a.table_name,
                           a.constraint_name,
                           b.column_name,
                           a.search_condition_vc,
                           ROW_NUMBER ()
                           OVER (
                              PARTITION BY a.owner, a.table_name, b.column_name
                              ORDER BY a.owner, a.table_name, b.column_name)
                              rnum
                      FROM dba_constraints a, dba_cons_columns b
                     WHERE     a.owner = b.owner
                           AND a.constraint_name = b.constraint_name
                           AND a.constraint_type = 'C'
                           AND a.owner NOT IN ('ANONYMOUS',
                                               'APEX_030200',
                                               'APEX_PUBLIC_USER',
                                               'APPQOSSYS',
                                               'CTXSYS',
                                               'DBSNMP',
                                               'DIP',
                                               'EXFSYS',
                                               'FLOWS_FILES',
                                               'MDDATA',
                                               'MDSYS',
                                               'MGMT_VIEW',
                                               'OLAPSYS',
                                               'ORACLE_OCM',
                                               'ORDDATA',
                                               'LBACSYS',
                                               'ORDPLUGINS',
                                               'ORDSYS',
                                               'OUTLN',
                                               'APEX_040200',
                                               'DVSYS',
                                               'OWBSYS',
                                               'OWBSYS_AUDIT',
                                               'SCOTT',
                                               'SI_INFORMTN_SCHEMA',
                                               'SPATIAL_CSW_ADMIN_USR',
                                               'SPATIAL_WFS_ADMIN_USR',
                                               'SYS',
                                               'SYSMAN',
                                               'SYSTEM',
                                               'WMSYS',
                                               'XDB',
                                               'PERFSTAT',
                                               'XS$NULL')
                  ORDER BY owner, table_name, column_name)
           WHERE rnum > 1)
   LOOP
      v_sql :=
            'alter table '
         || t_cursor.owner
         || '.'
         || t_cursor.table_name
         || ' drop constraint "'
         || t_cursor.constraint_name
         || '"';
      DBMS_OUTPUT.put_line (
            '--alter table '
         || t_cursor.owner
         || '.'
         || t_cursor.table_name
         || ' add  check ('
         || t_cursor.search_condition_vc
         || ');');
      DBMS_OUTPUT.put_line (v_sql);

      EXECUTE IMMEDIATE v_sql;
   END LOOP;
END;
/