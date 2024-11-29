SPO coe_xfr_sql_profile.log;
SET DEF ON TERM OFF ECHO ON FEED OFF VER OFF HEA ON LIN 2000 PAGES 100 LONG 8000000 LONGC 800000 TRIMS ON TI OFF TIMI OFF SERVEROUT ON SIZE 1000000 NUMF "" SQLP SQL>;
SET TERM ON ECHO OFF;
PRO
PRO Parameter for_sql_id:
PRO SQL_ID (required)
PRO
DEF sql_id = '&1';
PRO

PRO
PRO Parameter from_sql_id:
PRO SQL_ID (required)
PRO
DEF from_sql_id = '&2';
PRO

WITH
p AS (
SELECT distinct plan_hash_value
  FROM DBA_SQLSET_PLANS
 WHERE sql_id = TRIM('&&from_sql_id.')
   AND other_xml IS NOT NULL
),
m AS (
SELECT plan_hash_value,
       SUM(elapsed_time)/SUM(executions) avg_et_secs
  FROM DBA_SQLSET_STATEMENTS
 WHERE sql_id = TRIM('&&from_sql_id.')
   AND executions > 0
 GROUP BY
       plan_hash_value )
SELECT p.plan_hash_value,
       ROUND(m.avg_et_secs/1e6, 3) avg_et_secs
  FROM p, m
 WHERE p.plan_hash_value = m.plan_hash_value(+)
 ORDER BY
       avg_et_secs NULLS LAST;
PRO
PRO Parameter PLAN_HASH_VALUE:
PRO PLAN_HASH_VALUE (required)
PRO
DEF plan_hash_value = '&3';
PRO
PRO Values passed:
PRO ~~~~~~~~~~~~~
PRO TARGET_SQL_ID         : "&&sql_id."
PRO PLAN_HASH_VALUE: "&&plan_hash_value."
PRO FROM_SQL_ID: "&&from_sql_id."
PRO
SET TERM OFF ECHO ON;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

VAR sql_text CLOB;
VAR other_xml CLOB;
EXEC :sql_text := NULL;
EXEC :other_xml := NULL;

-- get sql_text from sqlset
BEGIN
    SELECT REPLACE(sql_text, CHR(00), ' ')
      INTO :sql_text
      FROM DBA_SQLSET_STATEMENTS
     WHERE sql_id = TRIM('&&sql_id.')
       AND sql_text IS NOT NULL
       AND ROWNUM = 1;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('getting sql_text from sqlset: '||SQLERRM);
    :sql_text := NULL;
END;
/

SELECT :sql_text FROM DUAL;


-- get other_xml from sqlset
BEGIN
    FOR i IN (SELECT other_xml
                FROM DBA_SQLSET_PLANS
               WHERE sql_id = TRIM('&&from_sql_id.')
                 AND plan_hash_value = TO_NUMBER(TRIM('&&plan_hash_value.'))
                 AND other_xml IS NOT NULL
               ORDER BY
                     sqlset_id,id)
    LOOP
      :other_xml := i.other_xml;
      EXIT; -- 1st
    END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('getting other_xml from sqlset: '||SQLERRM);
    :other_xml := NULL;
END;
/

SELECT :other_xml FROM DUAL;

-- generates script that creates sql profile in target system:
SET ECHO OFF;
PRO coe_xfr_sql_profile_&&sql_id._&&plan_hash_value..sql.
SET FEED OFF LIN 666 TRIMS ON TI OFF TIMI OFF SERVEROUT ON SIZE 1000000 FOR WOR;
SPO OFF;
SPO coe_xfr_sql_profile_&&sql_id._&&plan_hash_value..sql;
DECLARE
  l_pos NUMBER;
  l_hint VARCHAR2(32767);
BEGIN
  DBMS_OUTPUT.PUT_LINE('SPO coe_xfr_sql_profile_&&sql_id._&&plan_hash_value..log;');
  DBMS_OUTPUT.PUT_LINE('SET ECHO ON TERM ON LIN 2000 TRIMS ON NUMF 99999999999999999999;');
  DBMS_OUTPUT.PUT_LINE('WHENEVER SQLERROR EXIT SQL.SQLCODE;');
  DBMS_OUTPUT.PUT_LINE('REM');
  DBMS_OUTPUT.PUT_LINE('VAR signature NUMBER;');
  DBMS_OUTPUT.PUT_LINE('REM');
  DBMS_OUTPUT.PUT_LINE('DECLARE');
  DBMS_OUTPUT.PUT_LINE('sql_txt CLOB;');
  DBMS_OUTPUT.PUT_LINE('h       SYS.SQLPROF_ATTR;');
  DBMS_OUTPUT.PUT_LINE('BEGIN');
  DBMS_OUTPUT.PUT_LINE('sql_txt := q''[');
  WHILE NVL(LENGTH(:sql_text), 0) > 0
  LOOP
    l_pos := INSTR(:sql_text, CHR(10));
    IF l_pos > 0 THEN
      DBMS_OUTPUT.PUT_LINE(SUBSTR(:sql_text, 1, l_pos - 1));
      :sql_text := SUBSTR(:sql_text, l_pos + 1);
    ELSE
      DBMS_OUTPUT.PUT_LINE(:sql_text);
      :sql_text := NULL;
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(']'';');
  DBMS_OUTPUT.PUT_LINE('h := SYS.SQLPROF_ATTR(');
  DBMS_OUTPUT.PUT_LINE('q''[BEGIN_OUTLINE_DATA]'',');
  FOR i IN (SELECT /*+ opt_param('parallel_execution_enabled', 'false') */
                   SUBSTR(EXTRACTVALUE(VALUE(d), '/hint'), 1, 4000) hint
              FROM TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE(:other_xml), '/*/outline_data/hint'))) d)
  LOOP
    l_hint := i.hint;
    WHILE NVL(LENGTH(l_hint), 0) > 0
    LOOP
      IF LENGTH(l_hint) <= 500 THEN
        DBMS_OUTPUT.PUT_LINE('q''['||l_hint||']'',');
        l_hint := NULL;
      ELSE
        l_pos := INSTR(SUBSTR(l_hint, 1, 500), ' ', -1);
        DBMS_OUTPUT.PUT_LINE('q''['||SUBSTR(l_hint, 1, l_pos)||']'',');
        l_hint := '   '||SUBSTR(l_hint, l_pos);
      END IF;
    END LOOP;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('q''[END_OUTLINE_DATA]'');');
  DBMS_OUTPUT.PUT_LINE(':signature := DBMS_SQLTUNE.SQLTEXT_TO_SIGNATURE(sql_txt);');
  DBMS_OUTPUT.PUT_LINE('DBMS_SQLTUNE.IMPORT_SQL_PROFILE (');
  DBMS_OUTPUT.PUT_LINE('sql_text    => sql_txt,');
  DBMS_OUTPUT.PUT_LINE('profile     => h,');
  DBMS_OUTPUT.PUT_LINE('name        => ''coe_&&sql_id._&&plan_hash_value.'',');
  DBMS_OUTPUT.PUT_LINE('description => ''coe &&sql_id. &&plan_hash_value. ''||:signature||'''',');
  DBMS_OUTPUT.PUT_LINE('category    => ''DEFAULT'',');
  DBMS_OUTPUT.PUT_LINE('validate    => TRUE,');
  DBMS_OUTPUT.PUT_LINE('replace     => TRUE,');
  DBMS_OUTPUT.PUT_LINE('force_match => TRUE /* TRUE:FORCE (match even when different literals in SQL). FALSE:EXACT (similar to CURSOR_SHARING) */ );');
  DBMS_OUTPUT.PUT_LINE('END;');
  DBMS_OUTPUT.PUT_LINE('/');
  DBMS_OUTPUT.PUT_LINE('WHENEVER SQLERROR CONTINUE');
  DBMS_OUTPUT.PUT_LINE('SET ECHO OFF;');
  DBMS_OUTPUT.PUT_LINE('PRINT signature');
  DBMS_OUTPUT.PUT_LINE('PRO');
  DBMS_OUTPUT.PUT_LINE('PRO ... manual custom SQL Profile has been created');
  DBMS_OUTPUT.PUT_LINE('PRO');
  DBMS_OUTPUT.PUT_LINE('SET TERM ON ECHO OFF LIN 80 TRIMS OFF NUMF "";');
  DBMS_OUTPUT.PUT_LINE('SPO OFF;');
  DBMS_OUTPUT.PUT_LINE('PRO');
  DBMS_OUTPUT.PUT_LINE('PRO COE_XFR_SQL_PROFILE_&&sql_id._&&plan_hash_value. completed');
END;
/
SPO OFF;
SET DEF ON TERM ON ECHO OFF FEED 6 VER ON HEA ON LONG 80 LONGC 80 TRIMS OFF TI OFF TIMI OFF SERVEROUT OFF NUMF "" SQLP SQL>;
PRO
PRO Execute coe_xfr_sql_profile_&&sql_id._&&plan_hash_value..sql
PRO on TARGET system in order to create a custom SQL Profile
PRO with plan &&plan_hash_value linked to adjusted sql_text.
PRO
UNDEFINE 1 2 3 sql_id from_sql_id plan_hash_value
PRO
PRO COE_XFR_SQL_PROFILE completed.


