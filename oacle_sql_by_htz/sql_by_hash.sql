set lines 200
set pages 999
col sql_text format a80
select sql_text from 
v$sqltext_with_newlines 
where hash_value=&hash_value
order by piece;
undefine hash_value