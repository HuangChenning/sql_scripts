set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000

/* 变量的定义 */
ACCEPT old_outline prompt 'Enter Search Old Outline (i.e. CONTROL) : '
ACCEPT new_outline prompt 'Enter Search New Outline (i.e. CONTROL) : '
col test1 new_v old_outline_priv noprint;
col test2 new_v new_outline_priv noprint;
col test3 new_v old_outline_new noprint;

select '&old_outline'||'_priv'  test1 from dual;
select '&new_outline'||'_priv'  test2 from dual;
select '&old_outline'||'_new'   test3 from dual;

/* 创建私有的outline */
create or replace private outline &old_outline_priv from &old_outline;
create or replace private outline &new_outline_priv from &new_outline;

/* 更新私有的outline */
update ol$ set hintcount=(select hintcount from ol$ where ol_name=upper('&new_outline_priv' )) where ol_name=upper('&old_outline_priv' );
delete from ol$ where ol_name=upper('&new_outline_priv' );
update ol$ set ol_name=upper('&new_outline_priv' ) where ol_name=upper('&old_outline_priv' );
commit;
execute dbms_outln_edit.refresh_private_outline(upper('&new_outline_priv' ));
create or replace outline &old_outline_new from private &new_outline_priv;
clear    breaks  
@sqlplusset




