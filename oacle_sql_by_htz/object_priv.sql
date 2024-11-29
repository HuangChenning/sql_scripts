-- 
-- gives user/table privileges, regardless of how the privilege 
-- is given; either directly or through any number of roles 
-- 
-- Parameters:  Table Name 
--  

prompt Examining the data dictionary.  Please wait.... 
  
-- whenever sqlerror stop 1; 
  
set verify off feedback off 
undefine TABLE_NAME
-- temp table user_dba_role_privs created, as CONNECT BY 
-- unusable on dba_role_priv view 
 
create table user_dba_role_privs storage (initial 100k next 100k) 
as select * from sys.dba_role_privs 
/ 
  
-- temp table user_dba_tab_privs created to speed up search 
 
create table user_dba_tab_privs storage (initial 100k next 100k) 
as select * from sys.dba_tab_privs where table_name = upper('&&TABLE_NAME') 
/ 
 
create index user_dba_tab_privs_idx on user_dba_tab_privs (privilege, grantee) 
storage (initial 100k next 100k); 
  
set feedback off 
set heading off 
 
prompt 
 
prompt 'Grantee list for table ' || upper('&&TABLE_NAME') from dual;
set feedback on 
set heading on 
  
column ge   format a50 heading "Grantee" 
column priv format a10 heading "Privilege" 
  
break on ge 
set feedback on 
  
select grantee||' Thru role '||granted_role ge, 'SELECT' priv 
from user_dba_role_privs 
start with granted_role in 
(select grantee from user_dba_tab_privs where privilege='SELECT' ) 
connect by prior grantee=granted_role 
union 
 
-- 
 
select grantee||' Thru role '||granted_role ge, 'UPDATE' priv 
from user_dba_role_privs 
start with granted_role in 
(select grantee from user_dba_tab_privs where privilege='UPDATE' ) 
connect by prior grantee=granted_role 
union 
 
-- 
 
select grantee||' Thru role '||granted_role ge, 'INSERT' priv 
from user_dba_role_privs 
start with granted_role in 
(select grantee from user_dba_tab_privs where privilege='INSERT' ) 
connect by prior grantee=granted_role 
union 
 
-- 
 
select grantee||' Thru role '||granted_role ge, 'DELETE' priv 
from user_dba_role_privs 
start with granted_role in 
(select grantee from user_dba_tab_privs where privilege='DELETE' ) 
connect by prior grantee=granted_role 
union 
 
-- 
 
select grantee||' Thru role '||granted_role ge, 'INDEX' priv 
from user_dba_role_privs 
start with granted_role in 
(select grantee from user_dba_tab_privs where privilege='INDEX' ) 
connect by prior grantee=granted_role 
union 
 
-- 
 
select grantee||' Thru role '||granted_role ge, 'ALTER' priv 
from user_dba_role_privs 
start with granted_role in 
(select grantee from user_dba_tab_privs where privilege='ALTER' ) 
connect by prior grantee=granted_role 
union 
 
-- 
 
select grantee||' Thru role '||granted_role ge, 'REFERENCES' priv 
from user_dba_role_privs 
start with granted_role in 
(select grantee from user_dba_tab_privs where privilege='REFERENCES' ) 
connect by prior grantee=granted_role 
union 
 
-- 
 
select grantee||' Thru role '||granted_role ge, 'EXECUTE' priv 
from user_dba_role_privs 
start with granted_role in 
(select grantee from user_dba_tab_privs where privilege='EXECUTE' ) 
connect by prior grantee=granted_role 
union 

--
 
select grantee|| ' Direct' ge , privilege priv
from sys.dba_tab_privs
where table_name  = upper('&&TABLE_NAME')
order by 1,2
/

set feedback off
drop table user_dba_role_privs;
drop table user_dba_tab_privs;
undefine TABLE_NAME;

clear breaks 
set feedback on