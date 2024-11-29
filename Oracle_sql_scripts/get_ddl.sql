-- File Name : get_ddl_table.sql
-- Purpose : 显示表，表的注释，表的索引的DDL.
-- Date : 2015/09/05
-- 认真就输、QQ:7343696
-- http://www.htz.pw
set echo off
SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON
col getddl for a2000
EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR', true);
EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'STORAGE',false);
EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SEGMENT_ATTRIBUTES',false);
EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'TABLESPACE',false);
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | input object type                                                      |
PROMPT | index,user,tablespace,table,sequence,view,procedure,role,synonym       |
PROMPT | directory,profile and so on                                            |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
PROMPT   AQ_QUEUE
PROMPT   AQ_QUEUE_TABLE
PROMPT   AQ_TRANSFORM
PROMPT   ASSOCIATION
PROMPT   AUDIT
PROMPT   AUDIT_OBJ
PROMPT   CLUSTER
PROMPT   COMMENT
PROMPT   CONSTRAINT
PROMPT   CONTEXT
PROMPT   DATABASE_EXPORT
PROMPT   DB_LINK
PROMPT   DEFAULT_ROLE
PROMPT   DIMENSION
PROMPT   DIRECTORY
PROMPT   FGA_POLICY
PROMPT   FUNCTION
PROMPT   INDEX_STATISTICS
PROMPT   INDEX
PROMPT   INDEXTYPE
PROMPT   JAVA_SOURCE
PROMPT   JOB
PROMPT   LIBRARY
PROMPT   MATERIALIZED_VIEW
PROMPT   MATERIALIZED_VIEW_LOG
PROMPT   OBJECT_GRANT
PROMPT   OPERATOR
PROMPT   PACKAGE
PROMPT   PACKAGE_SPEC
PROMPT   PACKAGE_BODY
PROMPT   PROCEDURE
PROMPT   PROFILE
PROMPT   PROXY
PROMPT   REF_CONSTRAINT
PROMPT   REFRESH_GROUP
PROMPT   RESOURCE_COST
PROMPT   RLS_CONTEXT
PROMPT   RLS_GROUP
PROMPT   RLS_POLICY
PROMPT   RMGR_CONSUMER_GROUP
PROMPT   RMGR_INTITIAL_CONSUMER_GROUP
PROMPT   RMGR_PLAN
PROMPT   RMGR_PLAN_DIRECTIVE
PROMPT   ROLE
PROMPT   ROLE_GRANT
PROMPT   ROLLBACK_SEGMENT
PROMPT   SCHEMA_EXPORT
PROMPT   SEQUENCE
PROMPT   SYNONYM
PROMPT   SYSTEM_GRANT
PROMPT   TABLE
PROMPT   TABLE_DATA
PROMPT   TABLE_EXPORT
PROMPT   TABLE_STATISTICS
PROMPT   TABLESPACE
PROMPT   TABLESPACE_QUOTA
PROMPT   TRANSPORTABLE_EXPORT
PROMPT   TRIGGER
PROMPT   TRUSTED_DB_LINK
PROMPT   TYPE
PROMPT   TYPE_SPEC
PROMPT   TYPE_BODY
PROMPT   USER
PROMPT   VIEW
PROMPT   XMLSCHEMA 
ACCEPT objecttype prompt 'Enter Search Object Type (i.e. INDEX) : '

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | input object name                                                      |
PROMPT +------------------------------------------------------------------------+
PROMPT
ACCEPT objectname prompt 'Enter Search Object Name (i.e. DEPT) : '

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | input object owner                                                      |
PROMPT +------------------------------------------------------------------------+
PROMPT
ACCEPT owner prompt 'Enter Search Object  Owner(i.e. SCOTT) : '
select dbms_metadata.get_ddl(upper('&objecttype'),upper('&objectname'),upper('&owner')) as getddl from dual
/
