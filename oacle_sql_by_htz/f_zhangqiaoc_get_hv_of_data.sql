/* Formatted on 2015/10/16 17:28:07 (QP5 v5.256.13226.35510) */
CREATE OR REPLACE PROCEDURE SYS.f_zhangqiaoc_get_hv_of_data (
   avc_owner    VARCHAR2,
   avc_table    VARCHAR2)
AS
   lvc_sql_text    VARCHAR2 (30000);
   ln_hash_value   NUMBER;
   lvc_error       VARCHAR2 (100);
BEGIN
   SELECT    'select /*+parallel(a,16)*/sum(dbms_utility.get_hash_value('
          || column_name_path
          || ',0,power(2,30)) ) from '
          || owner
          || '.'
          || table_name
          || ' a '
     INTO LVC_SQL_TEXT
     FROM (SELECT owner,
                  table_name,
                  column_name_path,
                  ROW_NUMBER ()
                  OVER (PARTITION BY table_name
                        ORDER BY table_name, curr_level DESC)
                     column_name_path_rank
             FROM (    SELECT owner,
                              table_name,
                              column_name,
                              RANK,
                              LEVEL AS curr_level,
                              LTRIM (
                                 SYS_CONNECT_BY_PATH (column_name, '||''|''||'),
                                 '||''|''||')
                                 column_name_path
                         FROM (  SELECT owner,
                                        table_name,
                                        '"' || column_name || '"' column_name,
                                        ROW_NUMBER ()
                                        OVER (PARTITION BY table_name
                                              ORDER BY table_name, column_name)
                                           RANK
                                   FROM dba_tab_columns
                                  WHERE     owner = UPPER (avc_owner)
                                        AND table_name = UPPER (avc_table)
                                        AND DATA_TYPE IN ('TIMESTAMP(3)',
                                                          'INTERVAL DAY(3) TO SECOND(0)',
                                                          'TIMESTAMP(6)',
                                                          'NVARCHAR2',
                                                          'CHAR',
                                                          'BINARY_DOUBLE',
                                                          'NCHAR',
                                                          'DATE',
                                                          'RAW',
                                                          'TIMESTAMP(6)',
                                                          'VARCHAR2',
                                                          'NUMBER')
                               ORDER BY table_name, column_name)
                   CONNECT BY     table_name = PRIOR table_name
                              AND RANK - 1 = PRIOR RANK))
    WHERE column_name_path_rank = 1;

   EXECUTE IMMEDIATE lvc_sql_text INTO ln_hash_value;



   lvc_sql_text :=
      'insert into get_hv_of_data_result(owner,table_name,value) values(:x1,:x2,:x3)';

   EXECUTE IMMEDIATE lvc_sql_text USING avc_owner, avc_table, ln_hash_value;

   DBMS_OUTPUT.put_line (
      avc_owner || '.' || avc_table || '      ' || ln_hash_value);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      lvc_error := 'NO DATA FOUND';
      lvc_sql_text :=
         'insert into get_hv_of_data_result(owner,table_name,error) values(:x1,:x2,:x3)';

      EXECUTE IMMEDIATE lvc_sql_text USING avc_owner, avc_table, lvc_error;
   WHEN OTHERS
   THEN
      lvc_sql_text :=
         'insert into get_hv_of_data_result(owner,table_name,value) values(:x1,:x2,:x3)';

      EXECUTE IMMEDIATE lvc_sql_text USING avc_owner, avc_table, SQLERRM;
END;
/