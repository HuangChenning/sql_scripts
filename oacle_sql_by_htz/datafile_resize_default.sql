-- File Name : datafile_resize_default.sql
-- Purpose : 用户新建数据库时，修改默认的数据文件信息(system,undo,temp,users)
-- Date : 2015/09/05
-- 认真就输、QQ:7343696
-- http://www.htz.pw
-- 修复USERS表空间resize错误值
set verify off serveroutput on
/* Formatted on 2016/11/8 11:37:31 (QP5 v5.256.13226.35510) */
DECLARE
   v_tbname       VARCHAR2 (100);
   v_sql          VARCHAR2 (3000);
   v_sql1         VARCHAR2 (1000);
   v_freemb       NUMBER;
   v_count        NUMBER;
   v_tbsize       NUMBER;
   v_filenumber   NUMBER;
   v_autocount    NUMBER;
   v_pathtype     VARCHAR2 (100);
   v_table        VARCHAR2 (20);
   v_systemsize   NUMBER := 5368709120;
   v_sysauxsize   NUMBER := 16106127360;
   v_othersize    NUMBER := 34358689792;
   v_size         NUMBER;
BEGIN
   FOR c_tb IN (SELECT tablespace_name, a.contents
                  FROM dba_tablespaces a
                 WHERE    a.tablespace_name IN ('SYSTEM',
                                                'SYSAUX',
                                                'TEMP',
                                                'USERS')
                       OR a.contents = 'UNDO')
   LOOP
      IF c_tb.contents NOT IN ('TEMPORARY')
      THEN
         SELECT SUM (bytes)
           INTO v_tbsize
           FROM dba_data_files a
          WHERE a.tablespace_name = c_tb.tablespace_name;

         IF c_tb.tablespace_name = 'SYSTEM'
         THEN
            v_size := v_systemsize;
         ELSIF c_tb.tablespace_name = 'SYSAUX'
         THEN
            v_size := v_sysauxsize;
         ELSIF c_tb.tablespace_name = 'USERS'
         THEN
            SELECT MIN (bytes)
              INTO v_size
              FROM dba_data_files
             WHERE tablespace_name = 'USERS';
         ELSIF c_tb.contents IN ('UNDO')
         THEN
            v_size := v_othersize;
         END IF;

         SELECT COUNT (*)
           INTO v_autocount
           FROM dba_data_files a
          WHERE     a.tablespace_name = c_tb.tablespace_name
                AND a.autoextensible = 'YES';

         v_sql := 'alter database datafile ';
      ELSIF c_tb.contents IN ('TEMPORARY')
      THEN
         v_size := v_othersize;

         SELECT SUM (a.bytes)
           INTO v_tbsize
           FROM dba_temp_files a
          WHERE a.tablespace_name = c_tb.tablespace_name;

         SELECT COUNT (*)
           INTO v_autocount
           FROM dba_temp_files a
          WHERE     a.tablespace_name = c_tb.tablespace_name
                AND a.autoextensible = 'YES';

         v_sql := 'alter database tempfile ';
      END IF;

      IF v_tbsize < v_size
      THEN
         IF c_tb.contents IN ('TEMPORARY')
         THEN
            SELECT MIN (file_id)
              INTO v_filenumber
              FROM dba_temp_files a
             WHERE a.tablespace_name = c_tb.tablespace_name;
         ELSE
            SELECT MIN (file_id)
              INTO v_filenumber
              FROM dba_data_files a
             WHERE a.tablespace_name = c_tb.tablespace_name;
         END IF;

         /*
         SELECT CASE
                  WHEN REGEXP_REPLACE(a.file_name, '[^\+]', '') = '+' THEN
                   'ASM'
                  WHEN SUBSTR(a.file_name,
                              1,
                              REGEXP_INSTR(a.file_name, '[/]', 1, 2) - 1) =
                       '/dev' THEN
                   '/dev'
                  ELSE
                   'FS'
                END AS v_pathtype
           into v_pathtype
           from dba_data_files a
          where a.tablespace_name = c_tb.tablespace_name;
          */
         v_sql1 := v_sql || v_filenumber || ' resize ' || v_size;
         DBMS_OUTPUT.put_line (v_sql1);

         EXECUTE IMMEDIATE v_sql1;
      END IF;

      IF v_autocount > 0
      THEN
         IF c_tb.contents IN ('TEMPORARY')
         THEN
            FOR c_datafile
               IN (SELECT file_id
                     FROM dba_temp_files a
                    WHERE a.tablespace_name = c_tb.tablespace_name)
            LOOP
               v_sql1 := v_sql || c_datafile.file_id || ' autoextend off';
               DBMS_OUTPUT.put_line (v_sql1);

               EXECUTE IMMEDIATE v_sql1;
            END LOOP;
         ELSE
            FOR c_datafile
               IN (SELECT file_id
                     FROM dba_data_files a
                    WHERE a.tablespace_name = c_tb.tablespace_name)
            LOOP
               v_sql1 := v_sql || c_datafile.file_id || ' autoextend off';
               DBMS_OUTPUT.put_line (v_sql1);

               EXECUTE IMMEDIATE v_sql1;
            END LOOP;
         END IF;
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLCODE || '---' || SQLERRM);
END;
/