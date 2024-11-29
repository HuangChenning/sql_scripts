PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | PLEASE CHANGE THE FILE,AND INPUT YOU SQL                               |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
--select b.* from v$sqlarea a ,table(version_rpt(a.sql_id)) b where loaded_versions >=100;
--Generate reports for all cursors with more than 100 versions using HASH_VALUE:
--select b.* from v$sqlarea a ,table(version_rpt(null,a.hash_value)) b where loaded_versions>=100;
--Generate the report for cursor with sql_id cyzznbykb509s:
--select * from table(version_rpt('cyzznbykb509s'));