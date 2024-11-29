/* Formatted on 2014/6/5 0:14:02 (QP5 v5.240.12305.39446) */
SET ECHO OFF
SET LINES 2000 PAGES 1000 HEADING ON VERIFY OFF
COL owner FOR a15
col name for a30 heading 'OBJECT_NAME|SUB_OBJECT_NAME'
COL tablespace_name FOR a15
COL obj FOR a20 HEADING 'OBJ#|DATAOBJ#'
COL object_type FOR a15
BREAK ON owner ON name ON object_type ON tablespace_name
UNDEFINE owner;
UNDEFINE object_name;
UNDEFINE statistic_name;

/* Formatted on 2014/6/5 0:17:45 (QP5 v5.240.12305.39446) */
SELECT statistic#, name FROM v$segstat_name;

  SELECT owner,
         object_name||'.'||
         subobject_name name,
         object_type,
         tablespace_name,
         obj# || '.' || dataobj# obj,
         statistic_name,
         VALUE
    FROM V$SEGMENT_STATISTICS a
   WHERE     owner = NVL (UPPER ('&owner'), a.owner)
         AND object_name = NVL (UPPER ('&object_name'), a.object_name)
         AND statistic_name = NVL ('&statistic_name', a.statistic_name)
ORDER BY owner,
         object_name,
         subobject_name,
         statistic_name;

UNDEFINE owner;
UNDEFINE object_name;
UNDEFINE statistic_name;