-- File Name : db_add_logfile.sql
-- Purpose : 用于在创建数据库后，添加日志文件组，需要指定日志组个数
--           指定日志文件大小，会自动把日志文件小于指定大小的日志组删除
--           @db_add_logfile.sql 一路回车
--           @db_add_logfile.sql 2 8 +DATA_01
-- Date : 2016/05/19
-- 认真就输、QQ:7343696
-- http://www.htz.pw
-- 更多脚本，请访问http://www.htz.pw/script
-- 20161129 增加路径输入，如果路径不一样，会在新路径创建所有的日志组。
-- 20161129 添加在非归档模式对RAC的支持，如果是非归档模式，不删除其它节点活动或当前的REDO，只给出提示信息。
set lines 200
set pages 1000 heading on verify off serveroutput on
PRO
PRO Parameter 1:
PRO log file size (default 2g)
PRO
PRO Parameter 2:
PRO total group number by thread  (default 7)
PRO
PRO Parameter 3:
PRO log file path name  (default old path name)
PRO
PRO
DECLARE
   path_type         VARCHAR2 (200);
   path_name         VARCHAR2 (200);
   i_group_current   NUMBER;
   i_logfile_size    NUMBER;
   i_group_number    NUMBER;
   i_log_number      NUMBER;
   i_group_name      NUMBER;
   i_instance_id     NUMBER;
   i_sql             VARCHAR2 (200);
   i_sql_arch        VARCHAR2 (200) := 'alter system switch logfile';
   i_sql_arch2       VARCHAR2 (200) := 'alter system archive log current';
   i_group_status    VARCHAR2 (200);
   i_logfile_name    VARCHAR2 (200);
   i_log_mode        VARCHAR2 (200);
BEGIN
   SELECT TO_NUMBER (NVL ('&1', 2) * 1024 * 1024 * 1024)
     INTO i_logfile_size
     FROM DUAL;

   SELECT TO_NUMBER (NVL ('&2', 6)) INTO i_group_number FROM DUAL;

   SELECT NVL ('&3', 'DEFAULT') INTO path_name FROM DUAL;

   SELECT log_mode INTO i_log_mode FROM v$database;

   SELECT instance_number INTO i_instance_id FROM v$instance;

   IF path_name = 'DEFAULT'
   THEN
      SELECT CASE
                WHEN REGEXP_REPLACE (MEMBER, '[^\+]', '') = '+'
                THEN
                   'ASM'
                WHEN SUBSTR (x.MEMBER,
                             1,
                               REGEXP_INSTR (x.MEMBER,
                                             '[/]',
                                             1,
                                             2)
                             - 1) = '/dev'
                THEN
                   '/dev'
                ELSE
                   'FS'
             END
                AS path_type
        INTO path_type
        FROM v$logfile x
       WHERE ROWNUM = 1;

      SELECT CASE
                WHEN REGEXP_REPLACE (MEMBER, '[^\+]', '') = '+'
                THEN
                   SUBSTR (x.MEMBER,
                           1,
                             REGEXP_INSTR (x.MEMBER,
                                           '[/]',
                                           1,
                                           1)
                           - 1)
                ELSE
                   SUBSTR (x.MEMBER,
                           1,
                           REGEXP_INSTR (x.MEMBER,
                                         '[/]',
                                         1,
                                         REGEXP_COUNT (x.MEMBER, '[/]')))
             END
                AS name
        INTO path_name
        FROM v$logfile x
       WHERE ROWNUM = 1;

      SELECT (MAX (group#) + 1) INTO i_group_name FROM v$logfile;

      FOR c_thread IN (SELECT DISTINCT thread# FROM v$log)
      LOOP
         SELECT COUNT (*)
           INTO i_group_current
           FROM v$log
          WHERE thread# = c_thread.thread# AND bytes >= i_logfile_size;

         WHILE i_group_current < i_group_number
         LOOP
            IF path_type = 'ASM'
            THEN
               i_sql :=
                     'alter database add  logfile thread '
                  || c_thread.thread#
                  || ' '
                  || CHR (39)
                  || path_name
                  || CHR (39)
                  || ' size '
                  || i_logfile_size;
            ELSIF path_type = 'FS'
            THEN
               i_logfile_name := path_name || 'redo' || i_group_name || '.log';

               SELECT COUNT (*)
                 INTO i_log_number
                 FROM v$logfile
                WHERE MEMBER = i_logfile_name;

               WHILE i_log_number > 0
               LOOP
                  i_group_name := i_group_name + 1;
                  i_logfile_name :=
                     path_name || 'redo' || i_group_name || '.log';

                  SELECT COUNT (*)
                    INTO i_log_number
                    FROM v$logfile
                   WHERE MEMBER = i_logfile_name;
               END LOOP;

               i_sql :=
                     'alter database add  logfile thread '
                  || c_thread.thread#
                  || ' '
                  || CHR (39)
                  || path_name
                  || 'redo'
                  || i_group_name
                  || '.log'
                  || CHR (39)
                  || ' size '
                  || i_logfile_size;
            END IF;

            DBMS_OUTPUT.put_line (i_sql);

            EXECUTE IMMEDIATE i_sql;

            i_group_current := i_group_current + 1;
            i_group_name := i_group_name + 1;
         END LOOP;

         FOR i_delete_group
            IN (SELECT group#, THREAD#
                  FROM v$log
                 WHERE thread# = c_thread.thread# AND bytes < i_logfile_size)
         LOOP
            SELECT status
              INTO i_group_status
              FROM v$log
             WHERE group# = i_delete_group.group#;

            IF i_log_mode = 'ARCHIVELOG'
            THEN
               WHILE i_group_status IN ('ACTIVE', 'CURRENT')
               LOOP
                  EXECUTE IMMEDIATE i_sql_arch2;

                  SELECT status
                    INTO i_group_status
                    FROM v$log
                   WHERE group# = i_delete_group.group#;
               END LOOP;

               i_sql :=
                     'alter database drop logfile group '
                  || i_delete_group.group#;

               DBMS_OUTPUT.put_line (i_sql);

               EXECUTE IMMEDIATE i_sql;
            ELSE
               IF i_instance_id = c_thread.thread#
               THEN
                  WHILE i_group_status IN ('ACTIVE', 'CURRENT')
                  LOOP
                     EXECUTE IMMEDIATE i_sql_arch;

                     SELECT status
                       INTO i_group_status
                       FROM v$log
                      WHERE group# = i_delete_group.group#;
                  END LOOP;

                  i_sql :=
                        'alter database drop logfile group '
                     || i_delete_group.group#;

                  DBMS_OUTPUT.put_line (i_sql);

                  EXECUTE IMMEDIATE i_sql;
               ELSE
                  IF i_group_status IN ('ACTIVE', 'CURRENT')
                  THEN
                     DBMS_OUTPUT.put_line (
                           'manual exec : alter database drop logfile group '
                        || i_delete_group.group#
                        || ' on '
                        || c_thread.thread#);
                  ELSE
                     i_sql :=
                           'alter database drop logfile group '
                        || i_delete_group.group#;

                     DBMS_OUTPUT.put_line (i_sql);

                     EXECUTE IMMEDIATE i_sql;
                  END IF;
               END IF;
            END IF;
         END LOOP;
      END LOOP;
   ELSE
      SELECT CASE
                WHEN REGEXP_REPLACE (path_name, '[^\+]', '') = '+'
                THEN
                   'ASM'
                WHEN SUBSTR (path_name,
                             1,
                               REGEXP_INSTR (path_name,
                                             '[/]',
                                             1,
                                             2)
                             - 1) = '/dev'
                THEN
                   '/dev'
                ELSE
                   'FS'
             END
                AS path_type
        INTO path_type
        FROM DUAL x
       WHERE ROWNUM = 1;

      SELECT (MAX (group#) + 1) INTO i_group_name FROM v$logfile;

      FOR c_thread IN (SELECT DISTINCT thread# FROM v$log)
      LOOP
         SELECT COUNT (*)
           INTO i_group_current
           FROM v$log
          WHERE     thread# = c_thread.thread#
                AND bytes >= i_logfile_size
                AND group# IN (SELECT group#
                                 FROM v$logfile
                                WHERE UPPER (MEMBER) LIKE
                                         UPPER (path_name) || '%');

         WHILE i_group_current < i_group_number
         LOOP
            IF path_type = 'ASM'
            THEN
               i_sql :=
                     'alter database add  logfile thread '
                  || c_thread.thread#
                  || ' '
                  || CHR (39)
                  || path_name
                  || CHR (39)
                  || ' size '
                  || i_logfile_size;
            ELSIF path_type = 'FS'
            THEN
               i_logfile_name := path_name || 'redo' || i_group_name || '.log';

               SELECT COUNT (*)
                 INTO i_log_number
                 FROM v$logfile
                WHERE MEMBER = i_logfile_name;

               WHILE i_log_number > 0
               LOOP
                  i_group_name := i_group_name + 1;
                  i_logfile_name :=
                     path_name || 'redo' || i_group_name || '.log';

                  SELECT COUNT (*)
                    INTO i_log_number
                    FROM v$logfile
                   WHERE MEMBER = i_logfile_name;
               END LOOP;

               i_sql :=
                     'alter database add  logfile thread '
                  || c_thread.thread#
                  || ' '
                  || CHR (39)
                  || path_name
                  || 'redo'
                  || i_group_name
                  || '.log'
                  || CHR (39)
                  || ' size '
                  || i_logfile_size;
            END IF;

            DBMS_OUTPUT.put_line (i_sql);

            EXECUTE IMMEDIATE i_sql;

            i_group_current := i_group_current + 1;
            i_group_name := i_group_name + 1;
         END LOOP;

         FOR i_delete_group
            IN (SELECT group#
                  FROM v$log
                 WHERE     thread# = c_thread.thread#
                       AND (   bytes < i_logfile_size
                            OR group# NOT IN (SELECT group#
                                                FROM v$logfile
                                               WHERE UPPER (MEMBER) LIKE
                                                           UPPER (path_name)
                                                        || '%')))
         LOOP
            SELECT status
              INTO i_group_status
              FROM v$log
             WHERE group# = i_delete_group.group#;

            IF i_log_mode = 'ARCHIVELOG'
            THEN
               WHILE i_group_status IN ('ACTIVE', 'CURRENT')
               LOOP
                  EXECUTE IMMEDIATE i_sql_arch2;

                  SELECT status
                    INTO i_group_status
                    FROM v$log
                   WHERE group# = i_delete_group.group#;
               END LOOP;

               i_sql :=
                     'alter database drop logfile group '
                  || i_delete_group.group#;

               DBMS_OUTPUT.put_line (i_sql);

               EXECUTE IMMEDIATE i_sql;
            ELSE
               IF i_instance_id = c_thread.thread#
               THEN
                  WHILE i_group_status IN ('ACTIVE', 'CURRENT')
                  LOOP
                     EXECUTE IMMEDIATE i_sql_arch;

                     SELECT status
                       INTO i_group_status
                       FROM v$log
                      WHERE group# = i_delete_group.group#;
                  END LOOP;

                  i_sql :=
                        'alter database drop logfile group '
                     || i_delete_group.group#;

                  DBMS_OUTPUT.put_line (i_sql);

                  EXECUTE IMMEDIATE i_sql;
               ELSE
                  IF i_group_status IN ('ACTIVE', 'CURRENT')
                  THEN
                     DBMS_OUTPUT.put_line (
                           'manual exec : alter database drop logfile group '
                        || i_delete_group.group#
                        || ' on '
                        || c_thread.thread#);
                  ELSE
                     i_sql :=
                           'alter database drop logfile group '
                        || i_delete_group.group#;

                     DBMS_OUTPUT.put_line (i_sql);

                     EXECUTE IMMEDIATE i_sql;
                  END IF;
               END IF;
            END IF;
         END LOOP;
      END LOOP;
   END IF;
END;
/