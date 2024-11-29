@check_html.sql

col SCRIPT_SP_AWR new_value SCRIPT_SP_AWR
SELECT DISTINCT DECODE(REPLACE(SUBSTR(VERSION, 1, 2), '.', ''),9,(CASE WHEN CNT > 0 THEN  'run_sp.sql' ELSE 'none.sql' END),10,'run_awr.sql',11,'run_awr.sql') SCRIPT_SP_AWR FROM DBA_REGISTRY,(SELECT COUNT(*) CNT FROM DBA_TABLES WHERE OWNER = 'PERFSTAT'	   AND TABLE_NAME LIKE 'STATS%');
@&SCRIPT_SP_AWR

col SCRIPTS new_value SCRIPTS
SELECT DISTINCT DECODE(REPLACE(SUBSTR(VERSION, 1, 2), '.', ''),9,'dba_snapshot_database_9i.sql',10,'dba_snapshot_database_10g.sql',11,'dba_snapshot_database_10g.sql') SCRIPTS FROM DBA_REGISTRY;
@&SCRIPTS


