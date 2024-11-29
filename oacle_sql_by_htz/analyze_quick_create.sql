/* Formatted on 2014/4/21 13:04:46 (QP5 v5.240.12305.39446) */
CREATE OR REPLACE PROCEDURE analyze_quick (
   owner_table    VARCHAR2,
   name_table     VARCHAR2,
   name_index     VARCHAR2 DEFAULT NULL)
IS
   s             VARCHAR2 (30000);
   num_indexes   NUMBER := 0;
   sum_hash      NUMBER;
BEGIN
   FOR i
      IN (SELECT a.owner, a.index_name, b.column_name
            FROM dba_indexes a, dba_ind_columns b
           WHERE     a.table_owner = UPPER (owner_table)
                 AND a.table_name = UPPER (name_table)
                 AND (a.index_name = UPPER (name_index) OR name_index IS NULL)
                 AND a.index_type NOT IN
                        ('IOT - TOP',
                         'LOB',
                         'FUNCTION-BASED NORMAL',
                         'FUNCTION-BASED DOMAIN',
                         'CLUSTER')
                 AND a.owner = b.index_owner
                 AND a.index_name = b.index_name
                 AND a.table_name = b.table_name
                 AND b.column_position = 1)
   LOOP
      num_indexes := num_indexes + 1;


      s := 'select /*+ full(t1) parallel */ sum(ora_hash(rowid)) from ';
      s :=
            s
         || owner_table
         || '.'
         || name_table
         || ' t1 where '
         || i.column_name
         || ' is not null MINUS ';
      s :=
            s
         || 'select /*+ index_ffs(t '
         || i.index_name
         || ') */ sum(ora_hash(rowid)) from ';
      s :=
            s
         || owner_table
         || '.'
         || name_table
         || ' t where '
         || i.column_name
         || ' is not null';

      BEGIN
         EXECUTE IMMEDIATE s INTO sum_hash;

         IF sum_hash > 0
         THEN
            raise_application_error (
               -20220,
                  'TABLE/INDEX MISMATCH detected!! Table: '
               || UPPER (owner_table)
               || '.'
               || UPPER (name_table)
               || ' Index: '
               || UPPER (i.index_name));
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;       -- no_data_found means that there is not inconsistency
      END;
   END LOOP;

   IF num_indexes = 0 AND name_index IS NOT NULL
   THEN
      raise_application_error (
         -20221,
            'Check was not executed. Index '
         || UPPER (name_index)
         || ' does not exist for table '
         || UPPER (name_table)
         || ' or table does not exist');
   ELSIF num_indexes = 0
   THEN
      raise_application_error (
         -20222,
            'Check was not executed. No INDEXES with index_type=NORMAL found for table '
         || UPPER (name_table)
         || ' or table does not exist');
   END IF;
END;
/