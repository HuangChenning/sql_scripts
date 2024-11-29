set echo off
set serveroutput on
set feedback on
set lines 170
set pages 10

undefine count;
alter session set events '5614566 trace name context forever';
DECLARE
    v_sql   VARCHAR2 (100);
BEGIN
    FOR c_cursor
        IN (SELECT sql_id, address, hash_value
              FROM (SELECT sql_id,
                           address,
                           hash_value,
                           FORCE_MATCHING_SIGNATURE,
                           COUNT (*)
                               OVER (PARTITION BY FORCE_MATCHING_SIGNATURE)
                               t_count
                      FROM v$sqlarea a
                     WHERE     FORCE_MATCHING_SIGNATURE > 0
                           AND FORCE_MATCHING_SIGNATURE !=
                                   EXACT_MATCHING_SIGNATURE)
             WHERE t_count > &count)
    LOOP
        DBMS_OUTPUT.put_line (
               'purge sql_id :'
            || c_cursor.sql_id
            || ' address: '
            || c_cursor.address
            || ' hash_value : '
            || c_cursor.hash_value);
        v_sql := c_cursor.address
            || ','
            || c_cursor.hash_value;

        BEGIN
            DBMS_SHARED_POOL.purge (''||v_sql||'', 'C', 0);
        EXCEPTION
            WHEN OTHERS
            THEN
                DBMS_OUTPUT.put_line (
                       'not find sql_id :'
                    || c_cursor.sql_id
                    || ' address: '
                    || c_cursor.address
                    || ' hash_value : '
                    || c_cursor.hash_value);
        END;
    END LOOP;
END;
/

undefine count;