SET ECHO OFF
SET LINES 2000 PAGES 10000 HEADING ON VERIFY OFF
COL time FOR a8
COL hash FOR 9999999999999999
COL sleeps FOR 99999999999999
COL location FOR a40
COL object FOR a40
COL kglnaown for a20 heading 'OWNER'

  SELECT *
    FROM (  SELECT TO_CHAR (SYSDATE, 'HH:MI:SS') time,
                   KGLNAHSH hash,
                   SUM (sleeps) sleeps,
                   location,
                   MUTEX_TYPE,
		   KGLNAOWN,
                   SUBSTR (KGLNAOBJ, 1, 40) object
              FROM x$kglob, v$mutex_sleep_history
             WHERE kglnahsh = mutex_identifier
          GROUP BY KGLNAOWN,KGLNAOBJ,
                   KGLNAHSH,
                   location,
                   MUTEX_TYPE
          ORDER BY sleeps DESC)
   WHERE ROWNUM < 1000
ORDER BY sleeps
/
