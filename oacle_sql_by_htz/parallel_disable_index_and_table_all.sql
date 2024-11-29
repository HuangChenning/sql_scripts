/* Formatted on 2017/12/14 22:51:25 (QP5 v5.300) */
SET SERVEROUTPUT ON

DECLARE
    v_owner         VARCHAR2 (100);
    v_object_name   VARCHAR2 (100);
BEGIN
    FOR c_table
        IN (SELECT owner, table_name
              FROM dba_tables
             WHERE    (TRIM (degree) != '1' AND TRIM (degree) != '0')
                   OR     (    TRIM (instances) != '1'
                           AND TRIM (instances) != '0')
                      AND owner NOT IN ('SYS', 'SYSTEM'))
    LOOP
        DBMS_OUTPUT.put_line (
               'ALTER TABLE '
            || c_table.owner
            || '.'
            || c_table.table_name
            || ' NOPARALLEL');

        BEGIN
            EXECUTE IMMEDIATE
                   'ALTER TABLE '
                || c_table.owner
                || '."'
                || c_table.table_name
                || '" NOPARALLEL';
        EXCEPTION
            WHEN OTHERS
            THEN
                DBMS_OUTPUT.put_line ('*********************************************'
                    c_table.owner || '.' || c_table.table_name);
        END;
    END LOOP;

    FOR c_index
        IN (SELECT owner, index_name
              FROM dba_indexes
             WHERE    (TRIM (degree) != '1' AND TRIM (degree) != '0')
                   OR     (    TRIM (instances) != '1'
                           AND TRIM (instances) != '0')
                      AND owner NOT IN ('SYS', 'SYSTEM'))
    LOOP
        DBMS_OUTPUT.put_line (
               'ALTER INDEX '
            || c_index.owner
            || '.'
            || c_index.index_name
            || ' NOPARALLEL');

        BEGIN
            EXECUTE IMMEDIATE
                   'ALTER index '
                || c_index.owner
                || '."'
                || c_index.index_name
                || '" NOPARALLEL';
        EXCEPTION
            WHEN OTHERS
            THEN
                DBMS_OUTPUT.put_line ('**********************************************'||
                    c_index.owner || '.' || c_index.index_name);
        END;
    END LOOP;
END;
/

EXIT;