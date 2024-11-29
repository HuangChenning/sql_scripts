set echo off
set long 55555
set lines 300
set pages 1000
set heading on
set verify off
col getddl for a3000
col o_m for a40 heading 'OWNER_MVIEW_NAME'
col last_refresh_type for a10 heading 'LAST_TYPE|REFRESH'
col last_refresh_date for a12 heading 'LAST_DATE|REFRESH'
col stale_since for a12
col MASTER_LINK for a30

select owner || '.' || mview_name o_m,
       last_refresh_type,
       to_char(last_refresh_date, 'yy-mm-dd hh24') last_refresh_date,
       MASTER_LINK,
       decode(staleness, 'UNDEFINED', 'REMOTE', staleness) staleness,
       to_char(STALE_SINCE, 'yy-mm-dd h24') STALE_SINCE
  from dba_mviews a
 where owner = nvl(upper('&owner'), a.owner)
   and mview_name = nvl(upper('&mview_name'), a.mview_name);

undefine owner;
undefine mview_name;
PROMPT '----------------------------------------------'
PROMPT 'IF YOU DON'T GET DDL ABOUT MVIEW,PLEASE CTRL+C'
PROMPT '----------------------------------------------'
select dbms_metadata.get_ddl(upper('MATERIALIZED_VIEW'),upper('&mview_name'),upper('&owner')) as getddl from dual
/
undefine owner;
undefine mview_name;

