def S='&1'
def T='&2'
set lines 2000 pages 0 ver off echo off head off feed off
set newpage none
set trimspool on
set long 5000000
col output for a1000 word_wrapped
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SQLTERMINATOR',true);
exec dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',false);
--spool &T..sql
select dbms_metadata.get_ddl('TABLE','&T','&S') output from dual;
select dbms_metadata.get_dependent_ddl('INDEX','&T','&S') output from dual;
select dbms_metadata.get_dependent_ddl('CONSTRAINT','&T','&S') output from dual;
select dbms_metadata.get_dependent_ddl('REF_CONSTRAINT','&T','&S') output from dual;
select dbms_metadata.get_dependent_ddl('TRIGGER','&T','&S') output from dual;

-- Uncomment to generate object level grants
-- select dbms_metadata.get_dependent_ddl('OBJECT_GRANT','&T','&S') output from dual;
-- For example;
-- select dbms_metadata.get_dependent_ddl('view','&T','&S') output from dual;

--spool off;
