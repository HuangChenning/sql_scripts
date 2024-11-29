set echo off 
SET LINES 170  PAGES 0

SELECT DECODE(OBJECT_TYPE,
              'PACKAGE BODY',
              'PROMPT alter package ' || OWNER || '.' || OBJECT_NAME ||
              ' compile body;',
              'PROMPT alter ' || OBJECT_TYPE || ' ' || OWNER || '.' ||
              OBJECT_NAME || ' compile;') || CHR(10) ||
       DECODE(OBJECT_TYPE,
              'PACKAGE BODY',
              'alter package ' || OWNER || '.' || OBJECT_NAME ||
              ' compile body;',
              'alter ' || OBJECT_TYPE || ' ' || OWNER || '.' || OBJECT_NAME ||
              ' compile;') || chr(10) || 'show error;'
  FROM dba_objects
 WHERE STATUS = 'INVALID'
   AND OBJECT_TYPE IN ('PACKAGE BODY',
                       'PACKAGE',
                       'FUNCTION',
                       'PROCEDURE',
                       'TRIGGER',
                       'VIEW')
 ORDER BY OBJECT_TYPE, OBJECT_NAME
/