-- File Name : get_ddl_table.sql
-- Purpose : 显示表、表的注释、表的索引、约束、对象权限的DDL.
-- Date : 2015/09/05
-- 认真就输、QQ:7343696
-- http://www.htz.pw
-- 如果需要替换表空间，需要做下面的操作，将TBS1替换成TBS2,TBS3替换成TBS4
--EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'TABLESPACE',true);
--EXECUTE DBMS_METADATA.SET_REMAP_PARAM(DBMS_METADATA.SESSION_TRANSFORM,,'REMAP_TABLESPACE','TBS1','TBS2');
--EXECUTE DBMS_METADATA.SET_REMAP_PARAM(DBMS_METADATA.SESSION_TRANSFORM,,'REMAP_TABLESPACE','TBS3','TBS4');
set echo off
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON
col getddl for a2000
EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR', true);
EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'STORAGE',false);
EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SEGMENT_ATTRIBUTES',false);
EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'TABLESPACE',false);
undefine owner;
undefine table_name;
--!mv get_ddl_index_by_owner.txt get_ddl_index_by_owner_`date +"%Y%m%d_%H%M%S"`.txt
--spool  get_ddl_index_by_owner.txt 
SELECT DBMS_METADATA.GET_DEPENDENT_DDL ('INDEX', TABLE_NAME, TABLE_OWNER) as "getddl"
  FROM (SELECT DISTINCT table_name, table_owner
          FROM Dba_indexes
         WHERE     table_owner = UPPER ('&OWNER')
               AND table_name = NVL (UPPER ('&TABLE_NAME'), table_name))
--               AND index_name NOT IN
--                      (SELECT constraint_name
--                         FROM sys.Dba_constraints
--                        WHERE     table_name = table_name
--                              AND constraint_type = 'P'))
/
undefine owner;
undefine table_name;
-- spool off