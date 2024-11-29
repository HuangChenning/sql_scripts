SET SERVEROUTPUT ON heading off pages 1000 verify off lines 200

undefine 1;
undefine diskgroupname;
PRO Parameter 1:
PRO diskgroup name for datafile and default tablespace (must input)
PRO
DEF diskgroupname = upper('&1');

DECLARE
    i_pdb_name              VARCHAR2 (100);
    i_diskgroup_name        VARCHAR2 (100) := &&diskgroupname;
    i_count                 NUMBER;
    i_sql                   VARCHAR2 (1000);
    i_name                  VARCHAR2 (100);
BEGIN
    SELECT UPPER (SYS_CONTEXT ('userenv', 'con_name')) INTO i_name FROM DUAL;

    IF i_name <> 'CDB$ROOT'
    THEN
        SELECT COUNT (*)
          INTO i_count
          FROM v$pdbs
         WHERE open_mode = 'READ WRITE';

        IF i_count = 0
        THEN
            EXECUTE IMMEDIATE 'alter database open';
        ELSIF i_count>1 THEN
           dbms_output.put_line('pdb count >1');
           return;
        END IF;

        DBMS_OUTPUT.put_line ('create undo tablespace for other instances');

        FOR c_instance IN (SELECT 'UNDOTBS' || inst_id NAME
                             FROM gv$pdbs)
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
               'please switch to pdb_name  and create undo tbs and resize datafile');
    END IF;
END;
/

undefine 1;
undefine diskgroupname;
