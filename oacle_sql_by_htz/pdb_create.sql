-- File Name : pdb_create.sql
-- Purpose : 用于四川电信创建PDB
-- 支持 12c，为了便于pdb undo表空间一样，所以这样必须在1节点执行此脚本,此脚本只能用于创建。
-- Date : 2018/01/06
-- 认真就输、QQ:7343696
-- http://www.htz.pw

set lines 200 verify off lines 2000
undefine pdbname;
undefine diskgroupname;
undefine password;
col name for a20
col total_mb for 99999999
col free_mb for 9999999
col usable_file_mb for 9999999
select name,total_mb,free_mb, usable_file_mb  from v$asm_diskgroup;
PRO
PRO Parameter 1:
PRO pdb name (must input)
PRO
DEF pdb_name=upper('&1');
PRO
PRO Parameter 2:
PRO diskgroup name for datafile and default tablespace (must input)
PRO
DEF diskgroupname = upper('&2');
PRO
PRO Parameter 3:
PRO default tablespace name  (default users)
PRO
DEF default_tb_name = nvl('&3','users');

PRO Parameter 4:
PRO admin user password  (default KDF()3432ab)
PRO
DEF admin_user_password = nvl('&4','KDF()3432ab');



DECLARE
    i_pdb_name              VARCHAR2 (100) := &&pdb_name;
    i_diskgroup_name        VARCHAR2 (100) := &&diskgroupname;
    i_default_tb_name       VARCHAR2 (100) := &&default_tb_name;
    i_admin_user_paddword   VARCHAR2 (100) := &&admin_user_password;
    i_count                 NUMBER;
    i_sql                   VARCHAR2 (1000);
    i_name                  VARCHAR2 (100);
BEGIN
    SELECT UPPER (SYS_CONTEXT ('userenv', 'con_name')) INTO i_name FROM DUAL;

    IF i_name = 'CDB$ROOT'
    THEN
        SELECT instance_number INTO i_count FROM v$instance;

        IF i_count = 1
        THEN
            SELECT COUNT (*)
              INTO i_count
              FROM v$pdbs
             WHERE name = UPPER (i_pdb_name);

            IF i_count = 0
            THEN
                SELECT COUNT (*)
                  INTO i_count
                  FROM v$asm_diskgroup
                 WHERE name = UPPER (i_diskgroup_name);

                IF i_count = 1
                THEN
                  select 'YES' into executing from dual;
                    i_sql :=
                           'create pluggable database '
                        || i_pdb_name
                        || ' admin user pdbadmin identified by "'
                        || i_admin_user_paddword
                        || '" create_file_dest = '
                        || CHR (39)
                        || '+'
                        || i_diskgroup_name
                        || CHR (39)
                        || ' default tablespace '
                        || i_default_tb_name
                        || ' datafile '
                        || CHR (39)
                        || '+'
                        || i_diskgroup_name
                        || CHR (39)
                        || ' size 1g autoextend off ';
                    DBMS_OUTPUT.put_line (i_sql);

                    EXECUTE IMMEDIATE i_sql;

                    DBMS_OUTPUT.put_line (
                        'success create pdb ' || i_pdb_name);
                    DBMS_OUTPUT.put_line (
                           'begin open pdb '
                        || i_pdb_name
                        || ' at current instances');

                    EXECUTE IMMEDIATE
                        'alter pluggable database ' || i_pdb_name || ' open';
                ELSE
                    DBMS_OUTPUT.put_line (
                           'exis,diskgroup name '
                        || i_diskgroup_name
                        || ' is not exist,please create it and exec this script');
                END IF;
            ELSE
                DBMS_OUTPUT.put_line (
                    'exit,pdb name ' || i_pdb_name || ' is exist.');
            END IF;
        ELSE
            DBMS_OUTPUT.put_line ('you must run this sql at first instance;');
        END IF;
    ELSE
        DBMS_OUTPUT.put_line (
            'you must connect to cdbroot and run this script');
    END IF;
END;
/


DECLARE
    i_pdb_name              VARCHAR2 (100) := &&pdb_name;
    i_diskgroup_name        VARCHAR2 (100) := &&diskgroupname;
    i_default_tb_name       VARCHAR2 (100) := &&default_tb_name;
    i_admin_user_paddword   VARCHAR2 (100) := &&admin_user_password;
    i_count                 NUMBER;
    i_sql                   VARCHAR2 (1000);
    i_name                  VARCHAR2 (100);
BEGIN
    SELECT COUNT (*)
      INTO i_count
      FROM v$pdbs
     WHERE name = UPPER (i_pdb_name) AND open_mode = 'READ WRITE';

    IF i_count > 0
    THEN
        SELECT COUNT (*)
          INTO i_count
          FROM v$pdbs
         WHERE name = UPPER (i_pdb_name) AND open_mode = 'READ WRITE';

        IF i_count <> 1
        THEN
            DBMS_OUTPUT.put_line (
                   'pdb name '
                || i_pdb_name
                || ' is not open ,please open it first');
        ELSE
            EXECUTE IMMEDIATE 'alter session set container=' || i_pdb_name;
        END IF;
    ELSE
        DBMS_OUTPUT.put_line (
            'pdb name ' || i_pdb_name || ' is not exist ,please create it ');
    END IF;
END;
/

set serveroutput on lines 2000 verify off


/* Formatted on 2018/1/5 14:52:37 (QP5 v5.300) */
SET SERVEROUTPUT ON

DECLARE
    i_pdb_name              VARCHAR2 (100) := &&pdb_name;
    i_diskgroup_name        VARCHAR2 (100) := &&diskgroupname;
    i_default_tb_name       VARCHAR2 (100) := &&default_tb_name;
    i_admin_user_paddword   VARCHAR2 (100) := &&admin_user_password;
    i_count                 NUMBER;
    i_sql                   VARCHAR2 (1000);
    i_name                  VARCHAR2 (100);
BEGIN
    SELECT UPPER (SYS_CONTEXT ('userenv', 'con_name')) INTO i_name FROM DUAL;

    IF i_name = i_pdb_name
    THEN
        SELECT COUNT (*)
          INTO i_count
          FROM v$pdbs
         WHERE name = UPPER (i_pdb_name) AND open_mode = 'READ WRITE';

        IF i_count = 0
        THEN
            EXECUTE IMMEDIATE 'alter database open';
        END IF;

        DBMS_OUTPUT.put_line ('create undo tablespace for other instances');

        FOR c_instance IN (SELECT 'UNDOTBS' || inst_id NAME
                             FROM gv$pdbs
                            WHERE open_mode = 'MOUNTED')
        LOOP
            SELECT COUNT (*)
              INTO i_count
              FROM v$tablespace
             WHERE name = c_instance.name;

            IF i_count = 0
            THEN
                i_sql :=
                       'create undo tablespace '
                    || c_instance.name
                    || ' datafile '
                    || CHR (39)
                    || '+'
                    || i_diskgroup_name
                    || CHR (39)
                    || ' size 30m autoextend off';
                DBMS_OUTPUT.put_line (i_sql);

                EXECUTE IMMEDIATE i_sql;
            ELSE
                DBMS_OUTPUT.put_line (
                    c_instance.name || '  is exis and will not create it ');
            END IF;
        END LOOP;
    ELSE
        DBMS_OUTPUT.put_line (
               'please switch to pdb_name '
            || i_pdb_name
            || '  and create undo tbs and resize datafile');
    END IF;
END;
/



DECLARE
    v_tbname                VARCHAR2 (100);
    v_sql                   VARCHAR2 (3000);
    v_sql1                  VARCHAR2 (1000);
    v_freemb                NUMBER;
    v_count                 NUMBER;
    v_tbsize                NUMBER;
    v_filenumber            NUMBER;
    v_autocount             NUMBER;
    v_pathtype              VARCHAR2 (100);
    v_table                 VARCHAR2 (20);
    v_systemsize            NUMBER := 5368709120;
    v_sysauxsize            NUMBER := 5368709120;
    v_othersize             NUMBER := 34358689792;
    v_size                  NUMBER;
    i_pdb_name              VARCHAR2 (100) := &&pdb_name;
    i_diskgroup_name        VARCHAR2 (100) := &&diskgroupname;
    i_default_tb_name       VARCHAR2 (100) := &&default_tb_name;
    i_admin_user_paddword   VARCHAR2 (100) := &&admin_user_password;
    i_count                 NUMBER;
    i_sql                   VARCHAR2 (1000);
    i_name                  VARCHAR2 (100);
BEGIN
    SELECT UPPER (SYS_CONTEXT ('userenv', 'con_name')) INTO i_name FROM DUAL;

    IF i_name = i_pdb_name
    THEN
        SELECT COUNT (*)
          INTO i_count
          FROM v$pdbs
         WHERE name = UPPER (i_pdb_name) AND open_mode = 'READ WRITE';

        IF i_count = 0
        THEN
            EXECUTE IMMEDIATE 'alter database open';
        END IF;

        DBMS_OUTPUT.put_line ('begin resize default datafile');

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
                        v_sql1 :=
                            v_sql || c_datafile.file_id || ' autoextend off';
                        DBMS_OUTPUT.put_line (v_sql1);

                        EXECUTE IMMEDIATE v_sql1;
                    END LOOP;
                ELSE
                    FOR c_datafile
                        IN (SELECT file_id
                              FROM dba_data_files a
                             WHERE a.tablespace_name = c_tb.tablespace_name)
                    LOOP
                        v_sql1 :=
                            v_sql || c_datafile.file_id || ' autoextend off';
                        DBMS_OUTPUT.put_line (v_sql1);

                        EXECUTE IMMEDIATE v_sql1;
                    END LOOP;
                END IF;
            END IF;
        END LOOP;
    ELSE
        DBMS_OUTPUT.put_line (
               'please switch to pdb_name '
            || i_pdb_name
            || '  and create undo tbs and resize datafile');
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE (SQLCODE || '---' || SQLERRM);
END;
/


/* Formatted on 2018/1/5 15:08:50 (QP5 v5.300) */
DECLARE
    i_pdb_name              VARCHAR2 (100) := &&pdb_name;
    i_diskgroup_name        VARCHAR2 (100) := &&diskgroupname;
    i_default_tb_name       VARCHAR2 (100) := &&default_tb_name;
    i_admin_user_paddword   VARCHAR2 (100) := &&admin_user_password;
    i_count                 NUMBER;
    i_sql                   VARCHAR2 (1000);
    i_name                  VARCHAR2 (100);
BEGIN
    SELECT COUNT (*)
      INTO i_count
      FROM v$pdbs
     WHERE name = UPPER (i_pdb_name);

    IF i_count > 0
    THEN
        SELECT COUNT (*)
          INTO i_count
          FROM gv$pdbs
         WHERE name = UPPER (i_pdb_name) AND open_mode NOT IN 'READ WRITE';

        IF i_count > 0
        THEN
            EXECUTE IMMEDIATE
                   'alter pluggable database '
                || i_pdb_name
                || ' open instances=all';
        ELSE
            DBMS_OUTPUT.put_line ('all instances are open');
        END IF;

    ELSE
        DBMS_OUTPUT.put_line (
            'pdb name ' || i_pdb_name || ' is not exist ,please create it ');
    END IF;
END;
/


show con_name;
