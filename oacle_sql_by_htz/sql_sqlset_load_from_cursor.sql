/* SELECT *
  FROM TABLE (DBMS_SQLTUNE.SELECT_CURSOR_CACHE (NULL,
                                                NULL,
                                                NULL,
                                                NULL,
                                                NULL,
                                                NULL,
                                                NULL,
                                                NULL)) p;
*/

prompt Syntax
prompt CREATE TYPE sqlset_row AS object (
prompt   sql_id                   VARCHAR(13),
prompt   force_matching_signature NUMBER,
prompt   sql_text                 CLOB,
prompt   object_list              sql_objects,
prompt   bind_data                RAW(2000),
prompt   parsing_schema_name      VARCHAR2(30),
prompt   module                   VARCHAR2(48),
prompt   action                   VARCHAR2(32),
prompt   elapsed_time             NUMBER,
prompt   cpu_time                 NUMBER,
prompt   buffer_gets              NUMBER,
prompt   disk_reads               NUMBER,
prompt   direct_writes            NUMBER,
prompt   rows_processed           NUMBER,
prompt   fetches                  NUMBER,
prompt   executions               NUMBER,
prompt   end_of_fetch_count       NUMBER,
prompt   optimizer_cost           NUMBER,
prompt   optimizer_env            RAW(2000),
prompt   priority                 NUMBER,
prompt   command_type             NUMBER,
prompt   first_load_time          VARCHAR2(19),
prompt   stat_period              NUMBER,
prompt   active_stat_period       NUMBER,
prompt   other                    CLOB,
prompt   plan_hash_value          NUMBER,
prompt   sql_plan                 sql_plan_table_type,
prompt   bind_list                sql_binds) 
prompt DBMS_SQLTUNE.SELECT_CURSOR_CACHE(                                    
prompt         'module = ''MY_APPLICATION'' and action = ''MY_ACTION''')) P;
SET ECHO OFF
SET lines 200 pages 500  verify off heading on
@sql_sqlset

DECLARE
  sql_cursor     DBMS_SQLTUNE.sqlset_cursor;
  v_sqlset_name  varchar2(1000);
  v_sqlset_owner varchar2(100);
BEGIN
  v_sqlset_name  := '&sqlset_name';
  v_sqlset_owner := nvl(upper('&sqlset_owner'), NULL);

  OPEN sql_cursor FOR
    SELECT VALUE(p)
      FROM TABLE(DBMS_SQLTUNE.SELECT_CURSOR_CACHE(nvl('&basic_filter',NULL), -- basic_filter
                                                         NULL, -- object_filter
                                                         NULL, -- ranking_measure1
                                                         NULL, -- ranking_measure2
                                                         NULL, -- ranking_measure3
                                                         NULL, -- result_percentage
                                                         NULL, -- result_limit
                                                         NULL -- attribute_list
                                                         ) -- recursive_sql
                 ) p;

  DBMS_SQLTUNE.load_sqlset(sqlset_name     => v_sqlset_name,
                           populate_cursor => sql_cursor,
                           sqlset_owner    => v_sqlset_owner);
END;
/
@sql_sqlset
