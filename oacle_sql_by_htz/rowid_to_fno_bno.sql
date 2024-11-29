set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000


ACCEPT rowid prompt 'Enter Search Object Name (i.e. AAASdNAAFAAAACEAAh) : '
select '&rowid',
       dbms_rowid.rowid_relative_fno('&rowid') file_id,
       dbms_rowid.rowid_block_number('&rowid') block_id
  from dual
/
clear    breaks  
