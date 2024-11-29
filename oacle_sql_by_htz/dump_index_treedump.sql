SET ECHO OFF;
SET LINES 300
SET PAGES 40
SET HEADING ON
SET FEEDBACK OFF
SET VERIFY OFF
undefine owner;
undefine indexname;
undefine i_object_id;
COL object_id NEW_V i_object_id NOPRINT;

SELECT TO_NUMBER (object_id) object_id
  FROM dba_objects
 WHERE     owner = NVL (UPPER ('&owner'), owner)
       AND object_type = 'INDEX'
       AND object_name = UPPER ('&indexname');

ALTER SESSION SET EVENTS 'immediate trace name TREEDUMP level  &i_object_id';
oradebug setmypid;
oradebug tracefile_name;
SET FEEDBACK ON
undefine owner;
undefine indexname;
undefine i_object_id;
SET ECHO ON
