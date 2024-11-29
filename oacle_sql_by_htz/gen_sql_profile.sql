DECLARE
   ar_hint_table      SYS.dbms_debug_vc2coll;
   ar_profile_hints   SYS.sqlprof_attr := sys.sqlprof_attr ();
   cl_sql_text        CLOB;
   i                  PLS_INTEGER;
BEGIN
   WITH a
        AS (SELECT ROWNUM AS r_no, a.*
              FROM TABLE (
                      DBMS_XPLAN.display_cursor ('&&good_sql_id',
                                                 NULL,
                                                 'OUTLINE')
                      ) a),
        b
        AS (SELECT MIN (r_no) AS start_r_no
              FROM a
             WHERE a.plan_table_output = 'Outline Data'),
        c
        AS (SELECT MIN (r_no) AS end_r_no
              FROM a, b
             WHERE a.r_no > b.start_r_no AND a.plan_table_output = ' */'),
        d
        AS (SELECT INSTR (a.plan_table_output, 'BEGIN_OUTLINE_DATA')
                      AS start_col
              FROM a, b
             WHERE r_no = b.start_r_no + 4)
     SELECT SUBSTR (a.plan_table_output, d.start_col) AS outline_hints
       BULK COLLECT INTO ar_hint_table
       FROM a,
            b,
            c,
            d
      WHERE a.r_no >= b.start_r_no + 4 AND a.r_no <= c.end_r_no - 1
   ORDER BY a.r_no;

   SELECT sql_text
     INTO cl_sql_text
     FROM 
          v$sql
    WHERE sql_id = '&&bad_sql_id';

   i := ar_hint_table.FIRST;

   WHILE i IS NOT NULL
   LOOP
      IF ar_hint_table.EXISTS (i + 1)
      THEN
         IF SUBSTR (ar_hint_table (i + 1), 1, 1) = ' '
         THEN
            ar_hint_table (i) :=
               ar_hint_table (i) || TRIM (ar_hint_table (i + 1));
            ar_hint_table.delete (i + 1);
         END IF;
      END IF;

      i := ar_hint_table.NEXT (i);
   END LOOP;

   i := ar_hint_table.FIRST;

   WHILE i IS NOT NULL
   LOOP
      ar_profile_hints.EXTEND;
      ar_profile_hints (ar_profile_hints.COUNT) := ar_hint_table (i);
      i := ar_hint_table.NEXT (i);
   END LOOP;

   DBMS_SQLTUNE.import_sql_profile (sql_text      => cl_sql_text,
                                    profile       => ar_profile_hints,
                                    name          => '&&PROFILENAME'-- use force_match => true
                                                                  -- to use CURSOR_SHARING=SIMILAR
                                                                  -- behaviour, i.e. match even with
                                                                  -- differing literals
                                    ,
                                    force_match   => FALSE);
END;
/
