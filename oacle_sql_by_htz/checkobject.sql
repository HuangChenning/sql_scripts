-- File Name : checkobject.sql
-- Purpose : 用户逻辑迁移后，数据对象个数的对比
-- v2
-- Date : 2016-10-18
-- 认真就输、QQ:7343696
-- http://www.htz.pw
-- 更多脚本，请访问http://www.htz.pw/script
-- 修改constraint的sql语句 2016-10-18,删除重复的check约束脚本见：constraint_delete_repeat_check.sql
-- 修改constraint的sql语句 2016-10-18,在总脚本总排除重复check约束脚本统计。
-- 添加trigger 的sql语句  2017-07-24
-- 修改对象个数的SQL语句，考虑空值情况
--CREATE TABLE SYSTEM.migrate_username
--AS
--   SELECT username
--     FROM dba_users
--    WHERE username NOT IN ('ANONYMOUS',
--                           'APEX_030200',
--                           'APEX_PUBLIC_USER',
--                           'APPQOSSYS',
--                           'CTXSYS',
--                           'DBSNMP',
--                           'DIP',
--                           'EXFSYS',
--                           'FLOWS_FILES',
--                           'MDDATA',
--                           'MDSYS',
--                           'MGMT_VIEW',
--                           'OLAPSYS',
--                           'ORACLE_OCM',
--                           'ORDDATA',
--                           'ORDPLUGINS',
--                           'ORDSYS',
--                           'OUTLN',
--                           'OWBSYS',
--                           'OWBSYS_AUDIT',
--                           'SCOTT',
--                           'SI_INFORMTN_SCHEMA',
--                           'SPATIAL_CSW_ADMIN_USR',
--                           'SPATIAL_WFS_ADMIN_USR',
--                           'SYS',
--                           'SYSMAN',
--                           'SYSTEM',
--                           'WMSYS',
--                           'XDB',
--                           'XS$NULL')
PROMPT 开始检查数据库对象 ...
SET LINES 2000 PAGES 50000 HEADING ON
COL owner               FOR a20
COL username 						FOR a20
COL index_name          FOR a30
COL o_type              FOR a15
COL new_status          FOR a15
COL old_status          FOR a15
COL PRIV                FOR a80
COL OBJECT_NAME         FOR a40
COL COLUMN_NAME         FOR a30
COL log_user            FOR a30
COL schema_user         FOR a30
COL what                FOR a80
COL mview_name          FOR a40
COL MASTER_LINK         FOR a30
COL STALENESS           FOR a15
COL COMPILE_STATE       FOR a15
COL stale_since         FOR a20
COL table_name          for a30
COL CONSTRAINT_NAME     FOR a30
COL DB_LINK             FOR a30
COL OWNER               FOR a30
COL COLUMN_NAME         FOR A30
COL COLUMN_POSITION     FOR 99
col N_OWNER             FOR a20
col OBJECT_TYPE         FOR a30
!mv checkresult.txt checkresult_`date +"%Y%m%d_%H%M%S"`.txt
SPOOL  checkresult.txt
PROMPT 1,Compare the number of objects

SELECT O.OWNER N_OWNER,
         O.OBJECT_TYPE O_TYPE,
         NVL(O.CNT,0) O_CNT,
         NVL(N.CNT,0) N_CNT,
         NVL(O.CNT,0) - NVL(N.CNT,0) O_N_DIFF
    FROM (  SELECT OWNER, OBJECT_TYPE, COUNT (*) CNT
              FROM DBA_OBJECTS
             WHERE (OBJECT_NAME NOT LIKE 'BIN%' and ( object_name not like 'SYS_IL%'))
          GROUP BY OWNER, OBJECT_TYPE) N,
         (  SELECT OWNER, OBJECT_TYPE, COUNT (*) CNT
              FROM DBA_OBJECTS@to_old
             WHERE (OBJECT_NAME NOT LIKE 'BIN%' and (object_name not like 'SYS_IL%'))
          GROUP BY OWNER, OBJECT_TYPE) O
   WHERE     N.OWNER(+) = O.OWNER
         AND N.OBJECT_TYPE(+) = O.OBJECT_TYPE
         AND (O.CNT <> N.CNT OR O.CNT IS NULL OR N.CNT IS NULL)
         AND O.OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
ORDER BY O.OWNER;



PROMPT 2,Compare the number of index


  SELECT O.OWNER N_OWNER,
         O.OBJECT_TYPE O_TYPE,
         NVL(O.CNT,0) O_CNT,
         NVL(N.CNT,0) N_CNT,
         NVL(O.CNT,0) - NVL(N.CNT,0) O_N_DIFF
    FROM (  SELECT OWNER, OBJECT_TYPE, COUNT (*) CNT
              FROM DBA_OBJECTS
             WHERE (OBJECT_NAME NOT LIKE 'BIN%' and (object_name not like 'SYS_IL%'))
          GROUP BY OWNER, OBJECT_TYPE) N,
         (  SELECT OWNER, OBJECT_TYPE, COUNT (*) CNT
              FROM DBA_OBJECTS@to_old
             WHERE (OBJECT_NAME NOT LIKE 'BIN%' and (object_name not like 'SYS_IL%'))
          GROUP BY OWNER, OBJECT_TYPE) O
   WHERE     N.OWNER(+) = O.OWNER
         AND N.OBJECT_TYPE(+) = O.OBJECT_TYPE
         AND (O.CNT <> N.CNT OR O.CNT IS NULL OR N.CNT IS NULL)
         AND O.OBJECT_TYPE = 'INDEX'
         AND O.OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
ORDER BY O.OWNER;


PROMPT 3,index : exist in old ,but not exist in new  not include SYS_C  SYS_IL

SELECT owner, index_name, INDEX_TYPE
  FROM dba_indexes@to_old
 WHERE     OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
       AND index_name NOT LIKE 'SYS_C%'
       AND index_name NOT LIKE 'SYS_IL%'
MINUS
SELECT owner, index_name, INDEX_TYPE
  FROM dba_indexes
 WHERE OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
ORDER BY owner, index_name;

PROMPT 4,index  column : exist in old ,but not exist in new
SELECT a.owner,
       a.table_name,
       a.INDEX_TYPE,
       b.COLUMN_NAME,
       b.COLUMN_POSITION
  FROM dba_indexes@to_old a, dba_ind_columns@to_old b
 WHERE a.OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
   and a.owner = b.index_owner
   and a.index_name = b.index_name
MINUS
SELECT a.owner,
       a.table_name,
       a.INDEX_TYPE,
       b.COLUMN_NAME,
       b.COLUMN_POSITION
  FROM dba_indexes a, dba_ind_columns b
 WHERE a.OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
   and a.owner = b.index_owner
   and a.index_name = b.index_name
 order by owner, table_name
/


PROMPT 3,index : exist in new ,but not exist in old  not include SYS_C  SYS_IL

SELECT owner, index_name, INDEX_TYPE
  FROM dba_indexes
 WHERE     OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
       AND index_name NOT LIKE 'SYS_C%'
       AND index_name NOT LIKE 'SYS_IL%'
MINUS
SELECT owner, index_name, INDEX_TYPE
  FROM dba_indexes@to_old
 WHERE OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
ORDER BY owner, index_name;

PROMPT 4,index  column : exist in new ,but not exist in old
SELECT a.owner,
       a.table_name,
       a.INDEX_TYPE,
       b.COLUMN_NAME,
       b.COLUMN_POSITION
  FROM dba_indexes a, dba_ind_columns b
 WHERE a.OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
   and a.owner = b.index_owner
   and a.index_name = b.index_name
MINUS
SELECT a.owner,
       a.table_name,
       a.INDEX_TYPE,
       b.COLUMN_NAME,
       b.COLUMN_POSITION
  FROM dba_indexes@to_old a, dba_ind_columns@to_old b
 WHERE a.OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
   and a.owner = b.index_owner
   and a.index_name = b.index_name
 order by owner, table_name
/


PROMPT 4,All  object  status
PROMPT      source db is valid ，target db is invalid

  SELECT new.owner,
         new.object_name,
         new.object_type,
         new.status new_status,
         old.status old_status
    FROM (SELECT owner,
                 object_name,
                 object_type,
                 status
            FROM dba_objects@to_old
           WHERE owner IN (SELECT username FROM SYSTEM.migrate_username@to_old))
         old,
         (SELECT owner,
                 object_name,
                 object_type,
                 status
            FROM dba_objects
           WHERE owner IN (SELECT username FROM SYSTEM.migrate_username@to_old))
         new
   WHERE     new.owner = old.owner
         AND new.object_name = old.object_name
         AND new.object_type = old.object_type
         AND new.status <> old.status
         AND new.status = 'INVALID'
ORDER BY owner, object_type
/

PROMPT 5,Compare the number of table

  SELECT O.OWNER N_OWNER,
         O.OBJECT_TYPE O_TYPE,
         NVL(O.CNT,0) O_CNT,
         NVL(N.CNT,0) N_CNT,
         NVL(O.CNT,0) - NVL(N.CNT,0) O_N_DIFF
    FROM (  SELECT OWNER, OBJECT_TYPE, COUNT (*) CNT
              FROM DBA_OBJECTS
             WHERE OBJECT_NAME NOT LIKE 'BIN%'
          GROUP BY OWNER, OBJECT_TYPE) N,
         (  SELECT OWNER, OBJECT_TYPE, COUNT (*) CNT
              FROM DBA_OBJECTS@to_old
             WHERE OBJECT_NAME NOT LIKE 'BIN%'
          GROUP BY OWNER, OBJECT_TYPE) O
   WHERE     N.OWNER(+) = O.OWNER
         AND N.OBJECT_TYPE(+) = O.OBJECT_TYPE
         AND (O.CNT <> N.CNT OR O.CNT IS NULL OR N.CNT IS NULL)
         AND O.object_type = 'TABLE'
         AND O.OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
ORDER BY O.OWNER
/

PROMPT 6,tables:  exist in old ,but not exist in new

SELECT owner, table_name, temporary
  FROM dba_tables@to_old o
 WHERE O.OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
MINUS
SELECT owner, table_name, temporary
  FROM dba_tables o
 WHERE O.OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
ORDER BY OWNER;


PROMPT 7,object:exist in new,but not exist in old

SELECT owner, table_name
  FROM dba_tables o
 WHERE O.OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
MINUS
SELECT owner, table_name
  FROM dba_tables@to_old o
 WHERE O.OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
ORDER BY OWNER;



PROMPT 8,synonym: compare the number of synonym

  SELECT O.OWNER N_OWNER,
         NVL(O.CNT,0) O_CNT,
         NVL(N.CNT,0) N_CNT,
         NVL(O.CNT,0) - NVL(N.CNT,0) O_N_DIFF
    FROM (  SELECT OWNER, COUNT (*) CNT
              FROM dba_synonyms
          GROUP BY OWNER) N,
         (  SELECT OWNER, COUNT (*) CNT
              FROM dba_synonyms@to_old
          GROUP BY OWNER) O
   WHERE     N.OWNER(+) = O.OWNER
         AND (O.CNT <> N.CNT OR O.CNT IS NULL OR N.CNT IS NULL)
         AND O.OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
ORDER BY O.OWNER;


PROMPT 8,trigger: compare the number of trigger

SELECT n.owner,
       NVL (o.cnt, 0)                  o_cnt,
       NVL (n.cnt, 0)                  n_cnt,
       NVL (o.cnt, 0) - NVL (n.cnt, 0) o_n_diff
  FROM (SELECT owner, COUNT (*) cnt
          FROM dba_triggers
         WHERE owner IN (SELECT username
                           FROM SYSTEM.migrate_username)) n,
       (SELECT owner, COUNT (*) cnt
          FROM dba_triggers@to_old
         WHERE owner IN (SELECT username
                           FROM SYSTEM.migrate_username)) o
 WHERE     n.owner(+) = o.owner
       AND (o.cnt <> n.cnt OR o.cnt IS NULL OR n.cnt IS NULL)

PROMPT 9,Compare the number of  constraint by status not disabled


--  SELECT OWNER,
--         TYPE N_TYPE,
--         MAX (ncount) N_CNT,
--         MAX (ocount) O_CNT,
--         MAX (ncount) - MAX (ocount) NO_DIFF
--    FROM (  SELECT co.OWNER,
--                   CO.CONSTRAINT_TYPE TYPE,
--                   COUNT (*) ncount,
--                   0 ocount
--              FROM DBA_CONSTRAINTS CO
--             WHERE     co.TABLE_NAME NOT LIKE 'BIN%'
--                   AND co.status NOT IN ('DISABLED')
--                   AND Co.OWNER IN (SELECT username
--                                      FROM SYSTEM.migrate_username@to_old)
--          GROUP BY co.owner, co.constraint_type
--          UNION ALL
--            SELECT co.OWNER,
--                   CO.CONSTRAINT_TYPE TYPE,
--                   0,
--                   COUNT (*) ocount
--              FROM DBA_CONSTRAINTS@to_old CO
--             WHERE     co.TABLE_NAME NOT LIKE 'BIN%'
--                   AND co.status NOT IN ('DISABLED')
--                   AND Co.OWNER IN (SELECT username
--                                      FROM SYSTEM.migrate_username@to_old)
--          GROUP BY co.owner, co.constraint_type)
--GROUP BY OWNER, TYPE
--  HAVING MAX (ncount) <> MAX (ocount)
--ORDER BY NO_DIFF
--/
 /* Formatted on 2016/10/18 23:43:13 (QP5 v5.256.13226.35510) */
  SELECT OWNER,
         TYPE N_TYPE,
         MAX (ncount) N_CNT,
         MAX (ocount) O_CNT,
         MAX (ncount) - MAX (ocount) NO_DIFF
    FROM (  SELECT owner,
                   constraint_type TYPE,
                   COUNT (*) ncount,
                   0 ocount
              FROM (  SELECT a.owner,
                             a.table_name,
                             a.constraint_name,
                             a.constraint_type,
                             b.column_name,
                             ROW_NUMBER ()
                                OVER (PARTITION BY a.owner,
                                                   a.table_name,
                                                   a.constraint_type,
                                                   b.column_name
                                      ORDER BY
                                         a.owner,
                                         a.table_name,
                                         a.constraint_type,
                                         b.column_name)
                                rnum
                        FROM dba_constraints a, dba_cons_columns b
                       WHERE     a.owner = b.owner
                             AND a.constraint_name = b.constraint_name
                             AND a.TABLE_NAME NOT LIKE 'BIN%'
                             AND a.status NOT IN ('DISABLED')
                             AND a.owner IN (SELECT username
                                               FROM SYSTEM.migrate_username@to_old)
                    ORDER BY owner, table_name, column_name)
             WHERE rnum = 1
          GROUP BY owner, constraint_type
          UNION ALL
            SELECT owner,
                   constraint_type,
                   0 ncount,
                   COUNT (*) ocount
              FROM (  SELECT a.owner,
                             a.table_name,
                             a.constraint_name,
                             a.constraint_type,
                             b.column_name,
                             ROW_NUMBER ()
                                OVER (PARTITION BY a.owner,
                                                   a.table_name,
                                                   a.constraint_type,
                                                   b.column_name
                                      ORDER BY
                                         a.owner,
                                         a.table_name,
                                         a.constraint_type,
                                         b.column_name)
                                rnum
                        FROM dba_constraints@to_old a, dba_cons_columns@to_old b
                       WHERE     a.owner = b.owner
                             AND a.constraint_name = b.constraint_name
                             AND a.TABLE_NAME NOT LIKE 'BIN%'
                             AND a.status NOT IN ('DISABLED')
                             AND a.owner IN (SELECT username
                                               FROM SYSTEM.migrate_username@to_old)
                    ORDER BY owner, table_name, column_name)
             WHERE rnum = 1
          GROUP BY owner, constraint_type)
GROUP BY OWNER, TYPE
  HAVING MAX (ncount) <> MAX (ocount)
ORDER BY NO_DIFF
/
PROMPT 10,constraint:exits in old,but not exits in new,not include SYS_C% SYS_I% BIN%

/* Formatted on 2016/10/18 23:51:21 (QP5 v5.256.13226.35510) */
SELECT *
  FROM (SELECT CC.OWNER,
               cc.constraint_name,
               CC.TABLE_NAME,
               CC.COLUMN_NAME,
               CO.CONSTRAINT_TYPE,
               CO.status
          FROM DBA_CONS_COLUMNS@to_old CC, DBA_CONSTRAINTS@to_old CO
         WHERE     CC.OWNER = CO.OWNER
               AND CC.CONSTRAINT_NAME = CO.CONSTRAINT_NAME
               AND CC.TABLE_NAME NOT LIKE 'BIN%'
               AND co.constraint_name NOT LIKE 'SYS_C%'
               AND co.constraint_name NOT LIKE 'SYS_I%'
               AND co.constraint_name NOT LIKE 'BIN$%')
 WHERE OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
MINUS
SELECT *
  FROM (SELECT CC.OWNER,
               cc.constraint_name,
               CC.TABLE_NAME,
               CC.COLUMN_NAME,
               CO.CONSTRAINT_TYPE,
               co.status
          FROM DBA_CONS_COLUMNS CC, DBA_CONSTRAINTS CO
         WHERE     CC.OWNER = CO.OWNER
               AND CC.CONSTRAINT_NAME = CO.CONSTRAINT_NAME
               AND CC.TABLE_NAME NOT LIKE 'BIN%'
               AND co.constraint_name NOT LIKE 'BIN$%'
               AND co.constraint_name NOT LIKE 'SYS_C%'
               AND co.constraint_name NOT LIKE 'SYS_I%'
               AND co.constraint_name NOT LIKE 'BIN$%')
 WHERE OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
/


PROMPT 11,constraint :on table  in old ,but not exits in new
--SELECT *
--  FROM (  SELECT owner,
--                 table_name,
--                 constraint_type,
--                 status,
--                 COUNT (*)
--            FROM (SELECT DISTINCT co.OWNER,
--                                  co.TABLE_NAME,
--                                  CO.CONSTRAINT_TYPE,
--                                  CO.status
--                    FROM DBA_CONSTRAINTS@to_old Co
--                   WHERE     co.TABLE_NAME NOT LIKE 'BIN%'
--                         AND co.OWNER IN (SELECT username
--                                            FROM SYSTEM.migrate_username@to_old)
--                         AND co.status NOT IN ('DISABLED'))
--        GROUP BY OWNER,
--                 TABLE_NAME,
--                 CONSTRAINT_TYPE,
--                 status)
--MINUS
--SELECT *
--  FROM (  SELECT owner,
--                 table_name,
--                 constraint_type,
--                 status,
--                 COUNT (*)
--            FROM (SELECT DISTINCT co.OWNER,
--                                  co.TABLE_NAME,
--                                  CO.CONSTRAINT_TYPE,
--                                  co.status
--                    FROM DBA_CONSTRAINTS CO
--                   WHERE     co.TABLE_NAME NOT LIKE 'BIN%'
--                         AND co.OWNER IN (SELECT username
--                                            FROM SYSTEM.migrate_username@to_old)
--                         AND co.status NOT IN ('DISABLED'))
--        GROUP BY OWNER,
--                 TABLE_NAME,
--                 CONSTRAINT_TYPE,
--                 status)
--/
--
/* Formatted on 2016/10/19 0:19:39 (QP5 v5.256.13226.35510) */
  SELECT owner,
         table_name,
         constraint_type,
         MAX (ncount) N_CNT,
         MAX (ocount) O_CNT,
         MAX (ncount) - MAX (ocount) NO_DIFF
    FROM (  SELECT owner,
                   table_name,
                   constraint_type,
                   COUNT (*) ocount,
                   0 ncount
              FROM (SELECT DISTINCT co.OWNER,
                                    co.TABLE_NAME,
                                    CO.CONSTRAINT_TYPE,
                                    CO.status
                      FROM DBA_CONSTRAINTS@to_old Co
                     WHERE     co.TABLE_NAME NOT LIKE 'BIN%'
                           AND co.OWNER IN (SELECT username
                                              FROM SYSTEM.migrate_username@to_old)
                           AND co.status NOT IN ('DISABLED'))
          GROUP BY OWNER, TABLE_NAME, CONSTRAINT_TYPE
          UNION ALL
            SELECT owner,
                   table_name,
                   constraint_type,
                   0 ocount,
                   COUNT (*) ncount
              FROM (SELECT DISTINCT co.OWNER,
                                    co.TABLE_NAME,
                                    CO.CONSTRAINT_TYPE,
                                    co.status
                      FROM DBA_CONSTRAINTS CO
                     WHERE     co.TABLE_NAME NOT LIKE 'BIN%'
                           AND co.OWNER IN (SELECT username
                                              FROM SYSTEM.migrate_username@to_old)
                           AND co.status NOT IN ('DISABLED'))
          GROUP BY OWNER, TABLE_NAME, CONSTRAINT_TYPE)
GROUP BY owner, table_name, constraint_type
  HAVING MAX (ncount) <> MAX (ocount)
ORDER BY NO_DIFF
/
PROMPT 11,constraint :on column_name  in old ,but not exits in new
SELECT *
  FROM (SELECT DISTINCT CC.OWNER,
                        CC.TABLE_NAME,
                        CC.COLUMN_NAME,
                        CO.CONSTRAINT_TYPE,
                        CO.status
          FROM DBA_CONS_COLUMNS@to_old CC, DBA_CONSTRAINTS@to_old CO
         WHERE     CC.OWNER = CO.OWNER
               AND CC.CONSTRAINT_NAME = CO.CONSTRAINT_NAME
               AND CC.TABLE_NAME NOT LIKE 'BIN%'
               AND cc.OWNER IN (SELECT username
                                  FROM SYSTEM.migrate_username@to_old))
MINUS
SELECT *
  FROM (SELECT DISTINCT CC.OWNER,
                        CC.TABLE_NAME,
                        CC.COLUMN_NAME,
                        CO.CONSTRAINT_TYPE,
                        co.status
          FROM DBA_CONS_COLUMNS CC, DBA_CONSTRAINTS CO
         WHERE     CC.OWNER = CO.OWNER
               AND CC.CONSTRAINT_NAME = CO.CONSTRAINT_NAME
               AND cc.OWNER IN (SELECT username
                                  FROM SYSTEM.migrate_username@to_old))
/
PROMPT 12,constraint :on column_name  in new ,but not exits in old
/* Formatted on 2016/10/18 23:56:52 (QP5 v5.256.13226.35510) */
SELECT *
  FROM (SELECT DISTINCT CC.OWNER,
                        CC.TABLE_NAME,
                        CC.COLUMN_NAME,
                        CO.CONSTRAINT_TYPE,
                        CO.status
          FROM DBA_CONS_COLUMNS CC, DBA_CONSTRAINTS CO
         WHERE     CC.OWNER = CO.OWNER
               AND CC.CONSTRAINT_NAME = CO.CONSTRAINT_NAME
               AND CC.TABLE_NAME NOT LIKE 'BIN%'
               AND cc.OWNER IN (SELECT username
                                  FROM SYSTEM.migrate_username@to_old))
MINUS
SELECT *
  FROM (SELECT DISTINCT CC.OWNER,
                        CC.TABLE_NAME,
                        CC.COLUMN_NAME,
                        CO.CONSTRAINT_TYPE,
                        co.status
          FROM DBA_CONS_COLUMNS@to_old CC, DBA_CONSTRAINTS@to_old CO
         WHERE     CC.OWNER = CO.OWNER
               AND CC.CONSTRAINT_NAME = CO.CONSTRAINT_NAME
               AND cc.OWNER IN (SELECT username
                                  FROM SYSTEM.migrate_username@to_old))
/
PROMPT 12,Compare the number of sequence
PROMPT 13,dblink-private: exist in old ,but not exist in new
SELECT owner, db_link, username
  FROM dba_db_links@to_old
 WHERE OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
MINUS
SELECT owner, db_link, username
  FROM dba_db_links
 WHERE OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
/

PROMPT 13,dblink-public: exist in old ,but not exist in new
SELECT owner, db_link, username
  FROM dba_db_links@to_old
 WHERE OWNER IN ('PUBLIC')
MINUS
SELECT owner, db_link, username
  FROM dba_db_links
 WHERE OWNER IN ('PUBLIC')
/


PROMPT  14,Compare system permission
SELECT *
  FROM (SELECT DECODE (SA1.GRANTEE#, 1, 'PUBLIC', U1.NAME) username,
               SUBSTR (U2.NAME, 1, 20) rollname,
               SUBSTR (SPM.NAME, 1, 27) privilege
          FROM SYS.SYSAUTH$@to_old SA1,
               SYS.SYSAUTH$@to_old SA2,
               SYS.USER$@to_old U1,
               SYS.USER$@to_old U2,
               SYS.SYSTEM_PRIVILEGE_MAP@to_old SPM
         WHERE     SA1.GRANTEE# = U1.USER#
               AND SA1.PRIVILEGE# = U2.USER#
               AND U2.USER# = SA2.GRANTEE#
               AND SA2.PRIVILEGE# = SPM.PRIVILEGE
        UNION
        SELECT U.NAME username,
               NULL rollname,
               SUBSTR (SPM.NAME, 1, 27) privilege
          FROM SYS.SYSTEM_PRIVILEGE_MAP@to_old SPM,
               SYS.SYSAUTH$@to_old SA,
               SYS.USER$@to_old U
         WHERE SA.GRANTEE# = U.USER# AND SA.PRIVILEGE# = SPM.PRIVILEGE)
 WHERE username IN (SELECT username FROM SYSTEM.migrate_username@to_old)
MINUS
SELECT *
  FROM (SELECT DECODE (SA1.GRANTEE#, 1, 'PUBLIC', U1.NAME) username,
               SUBSTR (U2.NAME, 1, 20) rollname,
               SUBSTR (SPM.NAME, 1, 27) privilege
          FROM SYS.SYSAUTH$ SA1,
               SYS.SYSAUTH$ SA2,
               SYS.USER$ U1,
               SYS.USER$ U2,
               SYS.SYSTEM_PRIVILEGE_MAP SPM
         WHERE     SA1.GRANTEE# = U1.USER#
               AND SA1.PRIVILEGE# = U2.USER#
               AND U2.USER# = SA2.GRANTEE#
               AND SA2.PRIVILEGE# = SPM.PRIVILEGE
        UNION
        SELECT U.NAME username,
               NULL rollname,
               SUBSTR (SPM.NAME, 1, 27) privilege
          FROM SYS.SYSTEM_PRIVILEGE_MAP SPM, SYS.SYSAUTH$ SA, SYS.USER$ U
         WHERE SA.GRANTEE# = U.USER# AND SA.PRIVILEGE# = SPM.PRIVILEGE)
 WHERE username IN (SELECT username FROM SYSTEM.migrate_username@to_old);
PROMPT  14,Compare role of user

SELECT DISTINCT
          'grant '
       || granted_role
       || ' to '
       || GRANTEE
       || DECODE (ADMIN_OPTION, 'YES', ' WITH GRANT OPTION', '')
       || ';'
          priv
  FROM (    SELECT grantee, granted_role, ADMIN_OPTION
              FROM dba_role_privs@to_old
        START WITH grantee IN (SELECT username
                                 FROM SYSTEM.migrate_username@to_old)
        CONNECT BY PRIOR granted_role = grantee)
MINUS
SELECT DISTINCT
          'grant '
       || granted_role
       || ' to '
       || GRANTEE
       || DECODE (ADMIN_OPTION, 'YES', ' WITH GRANT OPTION', '')
       || ';'
          priv
  FROM (    SELECT grantee, granted_role, ADMIN_OPTION
              FROM dba_role_privs
        START WITH grantee IN (SELECT username
                                 FROM SYSTEM.migrate_username@to_old)
        CONNECT BY PRIOR granted_role = grantee)
/

PROMPT 14,Compare sys permission and create ddl
SELECT    'grant '
       || privilege
       || ' to '
       || GRANTEE
       || DECODE (ADMIN_OPTION, 'YES', ' WITH GRANT OPTION', '')
       || ';'
          priv
  --  ,'Granted directly '
  FROM dba_sys_privs@to_old
 WHERE grantee IN (SELECT username FROM SYSTEM.migrate_username@to_old)
MINUS
SELECT    'grant '
       || privilege
       || ' to '
       || GRANTEE
       || DECODE (ADMIN_OPTION, 'YES', ' WITH GRANT OPTION', '')
       || ';'
          priv
  FROM dba_sys_privs
 WHERE grantee IN (SELECT username FROM SYSTEM.migrate_username@to_old)
/

PROMPT 15,Compare object permission
SELECT    'grant '
       || privilege
       || ' on '
       || owner
       || '.'
       || table_name
       || ' to '
       || GRANTEE
       || DECODE (grantable, 'YES', ' WITH GRANT OPTION', '')
       || ';'
          priv
  --  ,'Granted directly '
  FROM dba_tab_privs@to_old
 WHERE grantee IN (SELECT username FROM SYSTEM.migrate_username@to_old)
MINUS
SELECT    'grant '
       || privilege
       || ' on '
       || owner
       || '.'
       || table_name
       || ' to '
       || GRANTEE
       || DECODE (grantable, 'YES', ' WITH GRANT OPTION', '')
       || ';'
          priv
  --  ,'Granted directly '
  FROM dba_tab_privs
 WHERE grantee IN (SELECT username FROM SYSTEM.migrate_username@to_old)
/

PROMPT 16,Compare  sys permission of role
SELECT    'grant '
       || privilege
       || ' to '
       || GRANTEE
       || DECODE (ADMIN_OPTION, 'YES', ' WITH GRANT OPTION', '')
       || ';'
          priv
  FROM dba_sys_privs@to_old
 WHERE grantee IN (SELECT ROLE FROM dba_roles@to_old)
MINUS
SELECT    'grant '
       || privilege
       || ' to '
       || GRANTEE
       || DECODE (ADMIN_OPTION, 'YES', ' WITH GRANT OPTION', '')
       || ';'
          priv
  FROM dba_sys_privs
 WHERE grantee IN (SELECT ROLE FROM dba_roles)
/

PROMPT 16,Compare  object permission granted by role
SELECT    'grant '
       || privilege
       || ' on '
       || owner
       || '.'
       || table_name
       || ' to '
       || GRANTEE
       || DECODE (grantable, 'YES', ' WITH GRANT OPTION', '')
       || ';'
          priv
  --  ,'Granted directly '
  FROM dba_tab_privs@to_old
 WHERE     grantee IN (    SELECT granted_role
                             FROM dba_role_privs@to_old
                       START WITH grantee IN (SELECT username
                                                FROM SYSTEM.migrate_username@to_old)
                       CONNECT BY PRIOR granted_role = grantee)
       AND owner NOT IN ('XDB')
MINUS
SELECT    'grant '
       || privilege
       || ' on '
       || owner
       || '.'
       || table_name
       || ' to '
       || GRANTEE
       || DECODE (grantable, 'YES', ' WITH GRANT OPTION', '')
       || ';'
          priv
  --  ,'Granted directly '
  FROM dba_tab_privs
 WHERE grantee IN (    SELECT granted_role
                         FROM dba_role_privs
                   START WITH grantee IN (SELECT username
                                            FROM SYSTEM.migrate_username@to_old)
                   CONNECT BY PRIOR granted_role = grantee)
/

PROMPT 17,boby:exits in old,but not exists in new
SELECT owner, object_name
  FROM dba_objects@to_old
 WHERE     OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
       AND object_type = 'PACKAGE BODY'
MINUS
SELECT owner, object_name
  FROM dba_objects
 WHERE     OWNER IN (SELECT username FROM SYSTEM.migrate_username@to_old)
       AND object_type = 'PACKAGE BODY'
/

PROMPT 18,job : exist in old ,but not exist in new
SELECT log_user,
       schema_user,
       what,
       broken
  FROM dba_jobs@to_old a
 WHERE a.schema_user IN (SELECT username FROM SYSTEM.migrate_username@to_old)
MINUS
SELECT log_user,
       schema_user,
       what,
       broken
  FROM dba_jobs a
 WHERE a.schema_user IN (SELECT username FROM SYSTEM.migrate_username@to_old)
/

PROMPT 18,mview : exist in old ,but not exist in new
SELECT owner, mview_name, MASTER_LINK
  FROM dba_mviews@to_old a
 WHERE a.owner IN (SELECT username FROM SYSTEM.migrate_username@to_old)
MINUS
SELECT owner, mview_name, MASTER_LINK
  FROM dba_mviews a
 WHERE a.owner IN (SELECT username FROM SYSTEM.migrate_username@to_old)
/

PROMPT 19,mview : display info in new ,different from old
SELECT owner,
       mview_name,
       MASTER_LINK,
       STALENESS,
       COMPILE_STATE,
       TO_CHAR (STALE_SINCE, 'yyyy-mm-dd hh24:mi:ss') stale_since
  FROM dba_mviews a
 WHERE a.owner IN (SELECT username FROM SYSTEM.migrate_username@to_old)
MINUS
SELECT owner,
       mview_name,
       MASTER_LINK,
       STALENESS,
       COMPILE_STATE,
       TO_CHAR (STALE_SINCE, 'yyyy-mm-dd hh24:mi:ss') stale_since
  FROM dba_mviews@to_old a
 WHERE a.owner IN (SELECT username FROM SYSTEM.migrate_username@to_old)
/

SPOOL  OFF
EXIT