/* Formatted on 2018/7/25 15:51:53 (QP5 v5.300) */
-- File Name : dg_add_standby_logfile.sql
-- Purpose : �����ڴDGʱ���Զ����ñ�����־
-- ֻ��10g,11g�������Թ�
-- Ҳ�������ڱȽϱ�����־��������־��С�����Զ�ɾ�������������ı�����־��.
-- ֧���ļ�ϵͳ��ASM��������֧��RAW
-- STANDBY��·�������v$logfile���صĵ�һ�е�·����ͬ
-- Ĭ��DROP STANDBY LOGFILE�ǽ��õģ������Ҫɾ�������ֶ�ȡ��--
-- Date : 2016/05/19
-- ������䡢QQ:7343696
-- http://www.htz.pw
-- ����ű��������http://www.htz.pw/script
-- 2016.12.12 ����жϴ������Ƿ���ڣ���������ڣ���create_online�����л�ȡ���������û�����ã���ȡsystem��ռ����ڵĴ�����
-- 2016.12.12 ���standby_file_management�������޸ģ������auto�޸ĳ�manual���ű�������ɺ��޸�Ϊauto��ֵ��
-- 2017.02.12 �޸�if�ṹ
-- 2017.06.27 �޸Ĵ������ж��������Ȼ�ȡlogfile�еĴ���������֣��ж��Ƿ���ڣ�����������ж�log�����Ƿ����ã����û�����ã��ж�create file�Ƿ���ڣ���������ڣ��ж������ļ�·���Ĵ������Ƿ����
-- 2018.07.25 �޸Ľű���֧���ļ�ϵͳ�������ļ�ϵͳ��ִ�����ֻ�����������Ҫ�ֶ�ȷ�����ļ������ֶ�ִ��
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