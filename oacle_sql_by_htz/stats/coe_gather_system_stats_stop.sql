REM $Header: coe_gather_system_stats_stop.sql 11.1 465787.1 2008/05/28 csierra $
SET ECHO ON;
SPO COE_GATHER_SYSTEM_STATS_STOP.TXT
SET SERVEROUT ON SIZE 1000000;

WHENEVER SQLERROR EXIT SQL.SQLCODE;
BEGIN
  IF USER != 'SYS' THEN
    RAISE_APPLICATION_ERROR(-20100, 'Connect as SYS, not as '||USER);
  END IF;
END;
/

COL v_statid NOPRI NEW_V v_statid FOR A30;
SELECT 'COE'||TO_CHAR(SYSDATE, 'YYYYMMDDHH24MI') v_statid FROM DUAL;

DECLARE
  my_statid VARCHAR2(30) := '&&v_statid';
BEGIN
  DBMS_OUTPUT.PUT_LINE('*** STATID: '||my_statid);
  DBMS_STATS.GATHER_SYSTEM_STATS (
    gathering_mode => 'STOP');
  BEGIN
    DBMS_STATS.EXPORT_SYSTEM_STATS (
      stattab => 'COE$_STATTAB',
      statid  => my_statid||'SAFTERSTOP',
      statown => 'COECBOSTATS' );
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SUBSTR('*** SKIP after stop export: '||SQLERRM, 1, 255));
  END;
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI')||' STOP Gathering CBO Stats for SYSTEM');
END;
/

WHENEVER SQLERROR CONTINUE;

SPO OFF;
