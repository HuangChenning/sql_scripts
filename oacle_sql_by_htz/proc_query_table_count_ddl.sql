/* Formatted on 2016/6/23 17:30:23 (QP5 v5.256.13226.35510) */
CREATE OR REPLACE PROCEDURE proc_query_rows (n_degree      NUMBER,
                                             v_in_owner    VARCHAR2)
--AUTHID CURRENT_USER
AS
   v_owner       VARCHAR2 (30);
   v_tablename   VARCHAR2 (30);
   n_rows        NUMBER (10);
   v_sql         VARCHAR2 (1000);

   CURSOR cur_tab (v_cur_owner VARCHAR2)
   IS
      SELECT owner, table_name
        FROM dba_tables
       WHERE owner = UPPER (v_cur_owner);

   CURSOR cur_tab_oth
   IS
        SELECT owner, table_name
          FROM dba_tables
         WHERE     owner NOT IN ('SCWY', 'SCWAP', 'MAILSENDER')
               AND owner IN (SELECT username
                               FROM dba_users@dl_to_old
                              WHERE created >
                                       TO_DATE ('2012-4-16 14:11:34',
                                                'yyyy-mm-dd hh24:mi:ss'))
      ORDER BY owner, table_name;
BEGIN
   /*
      UPDATE tab_rows
      SET    record_date = NULL;
   */
   IF (UPPER (v_in_owner) <> 'OTHERS')
   THEN
      OPEN cur_tab (UPPER (v_in_owner));

      LOOP
         FETCH cur_tab INTO v_owner, v_tablename;

         EXIT WHEN cur_tab%NOTFOUND;

         BEGIN
            v_sql :=
                  'select /*+parallel(a '
               || n_degree
               || ')*/count(*) from '
               || v_owner
               || '.'
               || v_tablename
               || ' a';

            --DBMS_OUTPUT.put_line (v_sql);

            EXECUTE IMMEDIATE v_sql INTO n_rows;

            /*
            INSERT INTO tab_rows (owner, table_name, old_rows)
            VALUES (v_owner, v_tablename, n_rows);
            */
            MERGE INTO tab_rows a
                 USING (SELECT v_owner owner, v_tablename table_name
                          FROM DUAL) b
                    ON (a.owner = b.owner AND a.table_name = b.table_name)
            WHEN MATCHED
            THEN
               UPDATE SET a.new_rows = n_rows, record_date = SYSDATE
            WHEN NOT MATCHED
            THEN
               INSERT     (owner,
                           table_name,
                           new_rows,
                           record_date)
                   VALUES (v_owner,
                           v_tablename,
                           n_rows,
                           SYSDATE);

            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (v_sql);
         END;
      END LOOP;

      CLOSE cur_tab;
   END IF;

   IF (UPPER (v_in_owner) = 'OTHERS')
   THEN
      OPEN cur_tab_oth;

      LOOP
         FETCH cur_tab_oth INTO v_owner, v_tablename;

         EXIT WHEN cur_tab_oth%NOTFOUND;

         BEGIN
            v_sql :=
                  'select /*+parallel(a '
               || n_degree
               || ')*/count(*) from '
               || v_owner
               || '.'
               || v_tablename
               || ' a';

            --DBMS_OUTPUT.put_line (v_sql);

            EXECUTE IMMEDIATE v_sql INTO n_rows;

            /*
            INSERT INTO tab_rows (owner, table_name, old_rows)
            VALUES (v_owner, v_tablename, n_rows);
            */
            MERGE INTO tab_rows a
                 USING (SELECT v_owner owner, v_tablename table_name
                          FROM DUAL) b
                    ON (a.owner = b.owner AND a.table_name = b.table_name)
            WHEN MATCHED
            THEN
               UPDATE SET a.new_rows = n_rows, record_date = SYSDATE
            WHEN NOT MATCHED
            THEN
               INSERT     (owner,
                           table_name,
                           new_rows,
                           record_date)
                   VALUES (v_owner,
                           v_tablename,
                           n_rows,
                           SYSDATE);

            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (v_sql);
         END;
      END LOOP;

      CLOSE cur_tab_oth;
   END IF;
END;