/* Formatted on 2018/7/25 15:51:53 (QP5 v5.300) */
-- File Name : dg_add_standby_logfile.sql
-- Purpose : 用于在搭建DG时，自动配置备库日志
-- 只在10g,11g环境测试过
-- 也可以用于比较备库日志与主库日志大小，会自动删除不满足条件的备库日志组.
-- 支持文件系统与ASM环境，不支持RAW
-- STANDBY的路径与访问v$logfile还回的第一行的路径相同
-- 默认DROP STANDBY LOGFILE是禁用的，如果需要删除，请手动取消--
-- Date : 2016/05/19
-- 认真就输、QQ:7343696
-- http://www.htz.pw
-- 更多脚本，请访问http://www.htz.pw/script
-- 2016.12.12 添加判断磁盘组是否存在，如果不存在，从create_online参数中获取，如果参数没有配置，获取system表空间所在的磁盘组
-- 2016.12.12 添加standby_file_management参数的修改，如果是auto修改成manual，脚本运行完成后，修改为auto的值。
-- 2017.02.12 修改if结构
-- 2017.06.27 修改磁盘组判断条件，先获取logfile中的磁盘组的名字，判断是否存在，如果不存在判断log参数是否配置，如果没有配置，判断create file是否存在，如果不存在，判断数据文件路径的磁盘组是否存在
-- 2018.07.25 修改脚本，支持文件系统，但是文件系统不执行命令，只是生成命令，需要手动确认无文件后，在手动执行
SET ECHO OFF
SET SERVEROUTPUT ON

DECLARE
    i_online_max_size   NUMBER;
    i_standb_min_size   NUMBER;
    i_add_group         NUMBER;
    i_delete_group      NUMBER;
    i_group_name        NUMBER;
    i_number            NUMBER;
    i_group1            NUMBER;
    i_group             NUMBER;
    i_temp              NUMBER;
    i_fileauto          VARCHAR2 (20);
    i_sql               VARCHAR2 (200);
    path_type           VARCHAR2 (200);
    path_name           VARCHAR2 (200);
BEGIN
    SELECT VALUE
      INTO i_fileauto
      FROM v$parameter
     WHERE name = 'standby_file_management' AND ROWNUM = 1;

    IF i_fileauto = 'AUTO'
    THEN
        EXECUTE IMMEDIATE
               'alter system set standby_file_management='
            || CHR (39)
            || 'manual'
            || CHR (39);
    END IF;

    SELECT path_type
      INTO path_type
      FROM (SELECT CASE
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
              FROM v$logfile x
             WHERE TYPE = 'STANDBY'
            UNION ALL
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
              FROM v$logfile x
             WHERE TYPE = 'ONLINE')
     WHERE ROWNUM = 1;

    SELECT name
      INTO path_name
      FROM (SELECT CASE
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
                           SUBSTR (
                               MEMBER,
                               1,
                               INSTR (
                                   MEMBER,
                                   '/',
                                   1,
                                   LENGTH (
                                       REGEXP_REPLACE (MEMBER, '[^/]+', ''))))
                   END
                       AS name
              FROM v$logfile x
             WHERE TYPE = 'STANDBY'
            UNION ALL
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
                           SUBSTR (
                               MEMBER,
                               1,
                               INSTR (
                                   MEMBER,
                                   '/',
                                   1,
                                   LENGTH (
                                       REGEXP_REPLACE (MEMBER, '[^/]+', ''))))
                   END
                       AS name
              FROM v$logfile x
             WHERE TYPE = 'ONLINE')
     WHERE ROWNUM = 1;

    IF path_type = 'ASM'
    THEN
        SELECT COUNT (*)
          INTO i_temp
          FROM v$asm_diskgroup
         WHERE '+' || UPPER (name) = UPPER (path_name);

        IF i_temp < 1
        THEN
            SELECT COUNT (*)
              INTO i_temp
              FROM v$asm_diskgroup
             WHERE '+' || UPPER (name) IN
                       (SELECT UPPER (VALUE)
                          FROM v$parameter
                         WHERE     name LIKE 'db_create_online_log_dest_%'
                               AND VALUE IS NOT NULL);

            IF i_temp < 1
            THEN
                SELECT VALUE
                  INTO path_name
                  FROM v$parameter
                 WHERE     name = 'db_create_file_dest'
                       AND VALUE IS NOT NULL
                       AND ROWNUM = 1;
            ELSE
                SELECT SUBSTR (x.name,
                               1,
                                 REGEXP_INSTR (x.name,
                                               '[/]',
                                               1,
                                               1)
                               - 1)
                  INTO path_name
                  FROM v$datafile x
                 WHERE file# = 1;

                SELECT COUNT (*)
                  INTO i_temp
                  FROM v$asm_diskgroup
                 WHERE '+' || UPPER (name) = UPPER (path_name);

                IF i_temp < 1
                THEN
                    DBMS_OUTPUT.put_line (
                        'diskgroup is not exits,please check diskgroup and parameter;');
                END IF;
            END IF;
        END IF;
    ELSIF path_type = 'ASM'
    THEN
        SELECT REGEXP_REPLACE (x.MEMBER, '/[^/]+$')
          INTO path_name
          FROM v$logfile x
         WHERE ROWNUM = 1;
         dbms_output.put_line('File Type Is FS,Please verify file name and Exec command manual;');
    END IF;

    SELECT (MAX (group#) + 1)
      INTO i_group_name
      FROM v$logfile;

    FOR c_thread IN (SELECT DISTINCT thread#
                       FROM v$log)
    LOOP
        SELECT MAX (bytes)
          INTO i_online_max_size
          FROM v$log
         WHERE thread# = c_thread.thread#;

        SELECT COUNT (*)
          INTO i_group
          FROM v$log
         WHERE thread# = c_thread.thread#;

        SELECT COUNT (*)
          INTO i_group1
          FROM v$standby_log
         WHERE thread# = c_thread.thread# AND bytes >= i_online_max_size;

        SELECT i_group - i_group1
          INTO i_add_group
          FROM DUAL;

        i_number := 0;

        WHILE i_number <= i_add_group
        LOOP
            IF path_type = 'ASM'
            THEN
                i_sql :=
                       'alter database add standby logfile thread '
                    || c_thread.thread#
                    || ' '
                    || CHR (39)
                    || path_name
                    || CHR (39)
                    || ' size '
                    || i_online_max_size;
            ELSIF path_type = 'FS'
            THEN
                i_sql :=
                       'alter database add standby logfile thread '
                    || c_thread.thread#
                    || ' '
                    || CHR (39)
                    || path_name
                    || '/htzstandby'
                    || i_group_name
                    || '.log'
                    || CHR (39)
                    || ' size '
                    || i_online_max_size;
            ELSIF path_type = 'RAW'
            THEN
                DBMS_OUTPUT.put_line ('redo file is raw');
            END IF;

            DBMS_OUTPUT.put_line (i_sql);

            IF path_type = 'ASM'
            THEN
                EXECUTE IMMEDIATE i_sql;
            END IF;

            i_number := i_number + 1;
            i_group_name := i_group_name + 1;
        END LOOP;

        i_number := 0;

        FOR c_delete_group
            IN (SELECT group#
                  FROM v$standby_log
                 WHERE     BYTES < i_online_max_size
                       AND thread# = c_thread.thread#)
        LOOP
            i_sql :=
                   'alter database drop logfile '
                || ' group '
                || c_delete_group.group#;

            DBMS_OUTPUT.put_line (i_sql);

            IF path_type = 'ASM'
            THEN
                EXECUTE IMMEDIATE i_sql;

                EXECUTE IMMEDIATE i_sql;
            END IF;
        END LOOP;
    END LOOP;

    IF i_fileauto = 'AUTO'
    THEN
        EXECUTE IMMEDIATE
               'alter system set standby_file_management='
            || CHR (39)
            || 'auto'
            || CHR (39);
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.put_line (SQLCODE || '-' || SQLERRM);

        IF i_fileauto = 'AUTO'
        THEN
            EXECUTE IMMEDIATE
                   'alter system set standby_file_management='
                || CHR (39)
                || 'auto'
                || CHR (39);
        END IF;
END;
/