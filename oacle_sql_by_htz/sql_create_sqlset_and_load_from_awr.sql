SET ECHO OFF
SET lines 200
set pages 0
@sql_sqlset
PROMPT 'SORT_TYPE elapsed_time,cpu_time,buffer_gets,disk_reads,direct_writes,rows_processed,fetches,executions';
DECLARE
   sql_cursor   DBMS_SQLTUNE.sqlset_cursor;
   v_sqlset_name varchar2(1000);
   v_sqlset_desc varchar2(1000);
BEGIN
    v_sqlset_name := '&sqlset_name';
    v_sqlset_desc := '&sqlset_desc';
    DBMS_SQLTUNE.create_sqlset (sqlset_name   => v_sqlset_name,
                               description   => v_sqlset_desc);

   OPEN sql_cursor FOR
      SELECT VALUE (p)
        FROM TABLE (DBMS_SQLTUNE.select_workload_repository (&begin_snap, -- begin_snap
                                                             &end_snap,  -- end_snap
                                                             NULL, -- basic_filter
                                                             NULL, -- object_filter
                                                             '&sort_type', -- ranking_measure1
                                                             NULL, -- ranking_measure2
                                                             NULL, -- ranking_measure3
                                                             NULL, -- result_percentage
                                                             &topn) -- result_limit
                                                                ) p;

   DBMS_SQLTUNE.load_sqlset (sqlset_name       => v_sqlset_name,
                             populate_cursor   => sql_cursor);
END;
/
@sql_sqlset