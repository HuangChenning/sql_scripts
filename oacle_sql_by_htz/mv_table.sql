/* Formatted on 2018/2/17 22:52:11 (QP5 v5.300) */
DECLARE
    v_table          VARCHAR2 (1000);
    v_owner          VARCHAR2 (1000);
    v_sql            VARCHAR2 (1000);
    v_table_temp     VARCHAR2 (1000);
    v_table_type     VARCHAR2 (100);
    v_tablespace     VARCHAR2 (1000);
    v_parallel       NUMBER;
    v_parallel_pro   NUMBER;
    v_number         NUMBER;
    v_dtype          VARCHAR2 (20);
    v_error          VARCHAR2 (4000);
BEGIN
    v_owner := UPPER ('&1');
    v_table := UPPER ('&2');
    v_table_temp := UPPER ('htz_move_table_temp');
    v_tablespace := UPPER ('&3');
    v_parallel := &4;
    v_parallel_pro := &5;


    BEGIN
        SELECT COUNT (*)
          INTO v_number
          FROM dba_tables
         WHERE table_name = v_table_temp;

        IF v_number = 0
        THEN
            v_sql :=
                   'create table htz_move_table_temp '
                || '(gid number,table_owner varchar(32),table_name varchar2(60),table_partition varchar2(60),table_subpartition varchar(40),index_owner varchar2(40),index_name varchar2(50),index_partition varchar2(50),index_subpartition varchar2(50),dtype varchar(20),status varchar2(20),error varchar2(4000),btime date,etime date)';
            DBMS_OUTPUT.put_line (v_sql);

            EXECUTE IMMEDIATE v_sql;
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            DBMS_OUTPUT.PUT_LINE (
                   TO_CHAR (SYSDATE, 'yyyy-mm-dd:hh24:mi:ss')
                || '-->'
                || SQLERRM);
    END;


    IF v_parallel_pro = 0
    THEN
        SELECT COUNT (*)
          INTO v_number
          FROM htz_move_table_temp
         WHERE status = 'DOING';

        IF v_number = 0
        THEN
            FOR v_cursor
                IN (SELECT a.owner, a.table_name, a.partitioned
                      FROM dba_tables a
                     WHERE     a.owner = v_owner
                           AND a.table_name = v_table
                           AND (a.owner, a.table_name) NOT IN
                                   (SELECT owner, table_name
                                      FROM htz_move_table_temp
                                     WHERE     status = 'DONE'
                                           AND table_partition IS NULL))
            LOOP
                IF v_cursor.partitioned = 'NO'
                THEN
                    INSERT INTO htz_move_table_temp (table_owner,
                                                     table_name,
                                                     dtype,
                                                     status,
                                                     btime)
                         VALUES (v_cursor.owner,
                                 v_cursor.table_name,
                                 'TABLE',
                                 'BEGIN',
                                 SYSDATE);

                    BEGIN
                        v_dtype := 'TABLE';
                        v_sql :=
                               'alter table '
                            || v_cursor.owner
                            || '.'
                            || v_cursor.table_name
                            || ' move tablespace '
                            || v_tablespace
                            || ' parallel '
                            || v_parallel;

                        EXECUTE IMMEDIATE V_SQL;

                        UPDATE htz_move_table_temp
                           SET status = 'END',
                               dtype = v_dtype,
                               etime = SYSDATE
                         WHERE     table_owner = v_cursor.owner
                               AND table_name = v_cursor.table_name;

                        v_dtype := 'INDEX';
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            v_error := SQLERRM;

                            UPDATE htz_move_table_temp
                               SET error = v_error
                             WHERE     table_owner = v_cursor.owner
                                   AND table_name = v_cursor.table_name;
                    END;

                    v_sql := '';

                    IF v_dtype = 'INDEX'
                    THEN
                        FOR v_index
                            IN (SELECT INDEX_NAME, owner
                                  FROM DBA_INDEXES
                                 WHERE     TABLE_NAME = v_cursor.table_name
                                       AND table_owner = v_cursor.owner
                                       AND (owner, index_name) NOT IN
                                               (SELECT owner, INDEX_NAME
                                                  FROM dba_lobs
                                                 WHERE     owner =
                                                               v_cursor.owner
                                                       AND table_name =
                                                               v_cursor.table_name))
                        LOOP
                            BEGIN
                                v_sql :=
                                       'alter index '
                                    || v_index.owner
                                    || '.'
                                    || v_index.INDEX_NAME
                                    || ' rebuild tablespace '
                                    || v_tablespace
                                    || ' parallel '
                                    || v_parallel;

                                INSERT INTO htz_move_table_temp (table_owner,
                                                                 table_name,
                                                                 dtype,
                                                                 index_owner,
                                                                 index_name,
                                                                 status,
                                                                 btime)
                                     VALUES (v_cursor.owner,
                                             v_cursor.table_name,
                                             v_dtype,
                                             v_index.owner,
                                             v_index.index_name,
                                             'BEGIN',
                                             SYSDATE);

                                EXECUTE IMMEDIATE v_sql;

                                UPDATE htz_move_table_temp
                                   SET status = 'END',
                                       dtype = v_dtype,
                                       etime = SYSDATE
                                 WHERE     table_owner = v_cursor.owner
                                       AND table_name = v_cursor.table_name
                                       AND index_owner = v_index.owner
                                       AND index_name = v_index.index_name;
                            EXCEPTION
                                WHEN OTHERS
                                THEN
                                    v_error := SQLERRM;

                                    UPDATE htz_move_table_temp
                                       SET error = v_error
                                     WHERE     table_owner = v_cursor.owner
                                           AND table_name =
                                                   v_cursor.table_name
                                           AND index_owner = v_index.owner
                                           AND index_name =
                                                   v_index.index_name;
                            END;
                        END LOOP;                          -- end loop v_index
                    END IF;                                        --end index
                END IF;                                    --end table part=no
            END LOOP;                                           -- end v_table
        END IF;                                             --end status=doing
    END IF;                                             --end parallel program
END;
/