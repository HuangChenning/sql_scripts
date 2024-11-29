set lines 170
select a.SQL_TEXT||chr(10)||chr(10)||chr(10)||a.sql_id from v$sql a where sql_text like '%&text%'
/
@@sql10.sql
