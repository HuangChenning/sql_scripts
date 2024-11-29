set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col totalmb for 999999999999
col usedmb for 999999999999
col freemb for 99999999999
col "% Used" for a6
col "Used" for 99999999

select t.tablespace_name, t.mb "TotalMB", t.mb - nvl(f.mb,0) "UsedMB", nvl(f.mb,0) "FreeMB"
       ,lpad(ceil((1-nvl(f.mb,0)/decode(t.mb,0,1,t.mb))*100)||'%', 6) "% Used", t.ext "Ext", 
       '|'||rpad(lpad('#',ceil((1-nvl(f.mb,0)/decode(t.mb,0,1,t.mb))*20),'#'),20,' ')||'|' "Used"
from (
  select tablespace_name, trunc(sum(bytes)/1048576) MB
  from dba_free_space
  group by tablespace_name
 union all
  select tablespace_name, trunc(sum(bytes_free)/1048576) MB
  from v$temp_space_header
  group by tablespace_name
) f, (
  select tablespace_name, trunc(sum(bytes)/1048576) MB, max(autoextensible) ext
  from dba_data_files
  group by tablespace_name
 union all
  select tablespace_name, trunc(sum(bytes)/1048576) MB, max(autoextensible) ext
  from dba_temp_files
  group by tablespace_name
) t
where t.tablespace_name = f.tablespace_name (+)
order by t.tablespace_name;

clear    breaks
col totalmb    clear
col usedmb     clear
col freemb     clear
col "% Used"   clear
col "Used"     clear
@sqlplusset

