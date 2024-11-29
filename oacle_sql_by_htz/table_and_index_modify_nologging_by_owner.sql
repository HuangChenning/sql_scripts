/* Formatted on 2017/10/21 12:06:56 (QP5 v5.300) */
SET SERVEROUTPUT ON
ALTER SESSION SET ddl_lock_timeout=0;
undefine 1;

DECLARE
    v_owner   VARCHAR2 (100) := UPPER ('&1');
    v_table   VARCHAR2 (100);
    v_index   VARCHAR2 (100);
    v_sql     VARCHAR2 (1000);
    v_row     NUMBER;
BEGIN
    FOR c_table IN (SELECT table_name
                      FROM dba_tables
                     WHERE owner = UPPER (v_owner))
    LOOP
        BEGIN
            v_sql :=
                   'alter table '
                || v_owner
                || '.'
                || c_table.table_name
                || ' nologging';

            EXECUTE IMMEDIATE v_sql;
        EXCEPTION
            WHEN OTHERS
            THEN
                DBMS_OUTPUT.put_line (
                    'Find Error on :' || v_owner || '.' || c_table.table_name);
        END;
    END LOOP;

    SELECT COUNT (*)
      INTO v_row
      FROM dba_tables
     WHERE owner = v_owner AND logging NOT IN ('NO');

    DBMS_OUTPUT.put_line ('tables not nologging number:' || v_row);

    FOR c_index IN (SELECT index_name
                      FROM dba_indexes
                     WHERE     owner = UPPER (v_owner)
                           AND index_name NOT IN (SELECT index_name
                                                    FROM dba_lobs
                                                   WHERE owner = v_owner))
    LOOP
        BEGIN
            v_sql :=
                   'alter index '
                || v_owner
                || '.'
                || c_index.index_name
                || ' nologging';

            EXECUTE IMMEDIATE v_sql;
        EXCEPTION
            WHEN OTHERS
            THEN
                DBMS_OUTPUT.put_line (
                    'Find Error on :' || v_owner || '.' || c_index.index_name);
        END;
    END LOOP;

    SELECT COUNT (*)
      INTO v_row
      FROM dba_indexes
     WHERE     owner = v_owner
           AND logging NOT IN ('NO')
           AND index_name NOT IN (SELECT index_name
                                    FROM dba_lobs
                                   WHERE owner = v_owner);

    DBMS_OUTPUT.put_line ('indexs not nologging number:' || v_row);
END;
/
undefine 1;