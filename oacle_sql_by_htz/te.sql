col PLAN_TABLE_OUTPUT for a170
col inst_child for a15
COL inst_child FOR A21;
BREAK ON inst_child SKIP 2;
set lines 200
ACCEPT sqlid prompt 'Enter Serach Sql_id (i.e. ) : '

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | Historical Execution Plans                                             |
PROMPT +------------------------------------------------------------------------+ 


SELECT t.plan_table_output
  FROM (SELECT DISTINCT sql_id, plan_hash_value, dbid
          FROM dba_hist_sql_plan WHERE sql_id = '&sqlid') v,
       TABLE(DBMS_XPLAN.DISPLAY_AWR(v.sql_id, v.plan_hash_value, v.dbid, 'ADVANCED -PROJECTION')) t;


PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT |    Current Execution Plans (last execution)                            |
PROMPT +------------------------------------------------------------------------+ 


SELECT RPAD('Inst: '||v.inst_id, 9)||' '||RPAD('Child: '||v.child_number, 11) inst_child, t.plan_table_output
  FROM gv$sql v,
       TABLE(DBMS_XPLAN.DISPLAY('gv$sql_plan_statistics_all', NULL, 'ADVANCED ALLSTATS LAST -PROJECTION', 'inst_id = '||v.inst_id||' AND sql_id = '''||v.sql_id||''' AND child_number = '||v.child_number)) t
 WHERE v.sql_id = '&sqlid'
   AND v.loaded_versions > 0;

