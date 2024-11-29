
sqlplus -s "/as sysdba" <<EOF
set heading off linesize 170 pagesize 0 feedback off
truncate table get_hv_of_data_result;
spool check_$1.sql
/* Formatted on 2015/10/16 16:14:11 (QP5 v5.256.13226.35510) */
  SELECT    'exec f_zhangqiaoc_get_hv_of_data('''
         || owner
         || ''','''
         || table_name
         || ''')'
    FROM dba_tables
   WHERE     owner = UPPER ('$1')
         AND table_name NOT IN (SELECT name
                                  FROM SYSTEM.NO_MIGRATE_AND_BIG_TABLE
                                 WHERE owner = UPPER ('$1'))
         AND table_name NOT IN (SELECT table_name
                                  FROM dba_tables
                                 WHERE     owner = UPPER ('$1')
                                       AND iot_type IS NULL)
         AND table_name IN (SELECT table_name
                              FROM (  SELECT table_name, COUNT (*)
                                        FROM dba_tab_columns
                                       WHERE     owner = UPPER ('$1')
                                             AND DATA_TYPE IN ('TIMESTAMP(3)',
                                                               'INTERVAL DAY(3) TO SECOND(0)',
                                                               'TIMESTAMP(6)',
                                                               'NVARCHAR2',
                                                               'CHAR',
                                                               'BINARY_DOUBLE',
                                                               'NCHAR',
                                                               'DATE',
                                                               'RAW',
                                                               'VARCHAR2',
                                                               'NUMBER')
                                    GROUP BY table_name
                                      HAVING COUNT (*) > 0))
ORDER BY table_name;
spool off
set serveroutput on
@check_$1.sql
exit;
EOF


--SELECT 'exec f_zhangqiaoc_get_hv_of_data(''' || owner || ''',''' ||
--       table_name || ''')'
--  FROM dba_tables
-- WHERE owner = UPPER('$1')
--   AND table_name NOT IN (SELECT name
--                            FROM SYSTEM.NO_MIGRATE_AND_BIG_TABLE
--                           WHERE owner = UPPER('$1'))
--   AND table_name NOT IN (SELECT table_name
--                            FROM dba_tables
--                           WHERE owner = UPPER('$1')
--                             AND iot_type IS NULL)
-- ORDER BY table_name;