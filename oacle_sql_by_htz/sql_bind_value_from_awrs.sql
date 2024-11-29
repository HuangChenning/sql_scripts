-- File Name:sql_bind_value_from_awrs.sql
-- Purpose:从AWR中获取SQL的绑定变量值并在SQL中用绑定变量值替换绑定变量
-- 只会获取同一个PLAN HASH VALUE最近的一次绑定变量的值，历史绑定变量的值不获取
-- Date:2015-10-11
-- 认真就输、QQ:7343696
-- http://www.htz.pw
-- 20161109 重写SQL,支持12C
set echo off;
set lines 2000 pages 1000 heading on verify off serveroutput on size 1000000;
undefine sqlid;

/* Formatted on 2016/11/9 10:25:24 (QP5 v5.256.13226.35510) */
DECLARE
   l_sql_text       VARCHAR2 (32000);
   l_old_sql_text   VARCHAR2 (32000);
   l_bind           VARCHAR2 (200);
   l_name           VARCHAR2 (30);
   l_info           VARCHAR2 (100);
   l_create         DATE;
BEGIN
   FOR c_sqlstat
      IN (  SELECT DISTINCT a.sql_id, a.parsing_schema_name, a.plan_hash_value
              FROM dba_hist_sqlstat a
             WHERE     sql_id = '&&sqlid'
                   AND a.parsing_schema_name IS NOT NULL
                   AND a.plan_hash_value IS NOT NULL
          ORDER BY a.parsing_schema_name, a.plan_hash_value)
   LOOP
      SELECT sql_text
        INTO l_old_sql_text
        FROM dba_hist_sqltext
       WHERE sql_id = c_sqlstat.sql_id AND ROWNUM = 1;

      l_sql_text := l_old_sql_text;

      FOR c_value_string
         IN (  SELECT datatype_string,
                      name,
                      position,
                      value_string,
                      last_captured
                 FROM (SELECT name name,
                              position,
                              NVL2 (cap_bv,
                                    v.cap_bv.datatype_string,
                                    datatype_string)
                                 datatype_string,
                              NVL2 (cap_bv, v.cap_bv.value_string, NULL)
                                 value_string,
                              NVL2 (cap_bv, v.cap_bv.last_captured, NULL)
                                 last_captured,
                              ROW_NUMBER ()
                              OVER (
                                 PARTITION BY name
                                 ORDER BY
                                    NVL2 (cap_bv, v.cap_bv.last_captured, NULL) DESC)
                                 rrow
                         FROM (SELECT DBMS_SQLTUNE.extract_bind (sql.bind_data,
                                                                 sbm.position)
                                         cap_bv,
                                      sbm.name,
                                      sbm.datatype_string,
                                      position
                                 FROM sys.wrm$_snapshot sn,
                                      sys.wrh$_sql_bind_metadata sbm,
                                      sys.wrh$_sqlstat sql
                                WHERE     sn.snap_id = sql.snap_id
                                      AND sn.dbid = sql.dbid
                                      AND sn.dbid IN (SELECT dbid
                                                        FROM v$database)
                                      AND sn.instance_number =
                                             sql.instance_number
                                      AND sbm.sql_id = sql.sql_id
                                      AND sql.sql_id = c_sqlstat.sql_id
                                      AND sql.parsing_schema_name =
                                             c_sqlstat.parsing_schema_name
                                      AND sql.plan_hash_value =
                                             c_sqlstat.plan_hash_value
                                      AND sn.status = 0) v)
                WHERE rrow = 1
             ORDER BY position)
      LOOP
         IF c_value_string.name LIKE ':SYS_B_%'
         THEN
            l_bind := ':"' || SUBSTR (c_value_string.name, 2) || '"';
         ELSE
            l_bind := c_value_string.name;
         END IF;

         IF c_value_string.value_string IS NOT NULL
         THEN
            IF c_value_string.datatype_string = 'NUMBER'
            THEN
               l_sql_text :=
                  REGEXP_REPLACE (l_sql_text,
                                  l_bind,
                                  c_value_string.value_string,
                                  1,
                                  1,
                                  'i');
            ELSIF c_value_string.datatype_string LIKE 'VARCHAR%'
            THEN
               l_sql_text :=
                  REGEXP_REPLACE (
                     l_sql_text,
                     l_bind,
                     '''' || c_value_string.value_string || '''',
                     1,
                     1,
                     'i');
            ELSE
               l_sql_text :=
                  REGEXP_REPLACE (
                     l_sql_text,
                     l_bind,
                     '''' || c_value_string.value_string || '''',
                     1,
                     1,
                     'i');
            END IF;
         ELSE
            l_sql_text :=
               REGEXP_REPLACE (l_sql_text,
                               l_bind,
                               'null',
                               1,
                               1,
                               'i');
         END IF;

         l_create := c_value_string.last_captured;
      END LOOP;

      DBMS_OUTPUT.put_line (
         '--------------------------------------------------------------------');
      DBMS_OUTPUT.put_line (c_sqlstat.parsing_schema_name);
      DBMS_OUTPUT.put_line (c_sqlstat.plan_hash_value);
      DBMS_OUTPUT.put_line (TO_CHAR (l_create, 'yyyy-mm-dd hh24:mi:ss'));
      DBMS_OUTPUT.put_line (l_sql_text);
   END LOOP;
END;
/