set echo off
undefine p1;
set lines 200 pages 2000 verify off heading on
col objectowner for a20 heading 'OWNER'
col objectname for a50
col namespace for 9999999999
col objecttype for 9999999999
SELECT KGLNAOWN objectowner,
       SUBSTR (KGLNAOBJ, 1, 50) objectname,
       KGLHDNSP Namespace,
       KGLOBTYP objecttype
  FROM x$kglob
 WHERE KGLNAHSH IN ('&&p1') OR KGLHDBID IN ('&&p1')
/
undefine p1;
