set heading off
set pagesize 0
set linesize 200
set verify off
set echo off
select decode(OBJECT_TYPE,
              'PACKAGE BODY',
              'alter package ' || OWNER || '.' || OBJECT_NAME ||
              ' compile body;',
              'alter ' || OBJECT_TYPE || ' ' || OWNER || '.' || OBJECT_NAME ||
              ' compile;')
  from dba_objects
 where STATUS = 'INVALID'
   and OBJECT_TYPE in ('PACKAGE BODY',
                       'PACKAGE',
                       'FUNCTION',
                       'PROCEDURE',
                       'TRIGGER',
                       'VIEW')
 order by OBJECT_TYPE, OBJECT_NAME;
 
set heading on
set pagasize 40
set verify on
set echo on
