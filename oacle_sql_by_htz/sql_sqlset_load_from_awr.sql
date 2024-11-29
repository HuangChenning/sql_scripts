SET ECHO OFF
set verify off set heading on 
SET lines 200
set pages 100
@sql_sqlset
undefine sqlset_name;
undefine sqlset_owner;
DECLARE
   sql_cursor   DBMS_SQLTUNE.sqlset_cursor;
   v_sqlset_name varchar2(1000);
   v_sqlset_owner varchar2(100);
   
BEGIN
    v_sqlset_name := '&sqlset_name';
    v_sqlset_owner:= nvl(upper('&sqlset_owner'),NULL);
   OPEN sql_cursor FOR
      SELECT VALUE (p)
        FROM TABLE (DBMS_SQLTUNE.select_workload_repository (&begin_snap, -- begin_snap
                                                             &end_snap,  -- end_snap
                                                             NULL, -- basic_filter
                                                             NULL, -- object_filter
                                                             NULL, -- ranking_measure1
                                                             NULL, -- ranking_measure2
                                                             NULL, -- ranking_measure3
                                                             NULL, -- result_percentage
                                                             NULL) -- result_limit
                                                                ) p;

   DBMS_SQLTUNE.load_sqlset (sqlset_name       => v_sqlset_name,
                             populate_cursor   => sql_cursor,
                             sqlset_owner      => v_sqlset_owner);
END;
/
@sql_sqlset
undefine sqlset_name;
undefine sqlset_owner;