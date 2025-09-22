set echo off
set long 65534
set lines 300
set pages 50
set heading on
set feed on
set verify off
col getddl for a3000
select dbms_metadata.get_ddl(upper('MATERIALIZED_VIEW'),upper('&mview_name'),upper('&owner')) as getddl from dual
/
undefine mview_name;
undefine owner;

