set echo off
set verify off
set pages 40
set feedback off
set long 1000
set heading on
col sql_text for a5000

--select to_char(sql_fulltext)


undefine hashvalue;
VAR sql_text CLOB;
EXEC :sql_text := NULL;
set serveroutput on
DECLARE
  l_sql_text VARCHAR2(32767);
BEGIN -- 10g see bug 5017909
  DBMS_OUTPUT.PUT_LINE('getting sql_text from memory');
  FOR i IN (SELECT DISTINCT piece, sql_text
              FROM gv$sqltext_with_newlines
             WHERE hash_value = &&hashvalue
             ORDER BY 1, 2)
  LOOP
    IF :sql_text IS NULL THEN
      DBMS_LOB.CREATETEMPORARY(:sql_text, TRUE);
      DBMS_LOB.OPEN(:sql_text, DBMS_LOB.LOB_READWRITE);
    END IF;
    l_sql_text := REPLACE(i.sql_text, CHR(00), ' ');
    DBMS_LOB.WRITEAPPEND(:sql_text, LENGTH(l_sql_text), l_sql_text);
  END LOOP;
  IF :sql_text IS NOT NULL THEN
    DBMS_LOB.CLOSE(:sql_text);
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('getting sql_text from memory: '||SQLERRM);
    :sql_text := NULL;
END;
/



PROMPT 
PROMPT
DECLARE
  l_pos NUMBER;
BEGIN
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
END;
/
undefine hashvalue;