DECLARE
  LN_SEQ NUMBER;
BEGIN
  FOR I IN 1 .. 3600 LOOP
    SELECT PERFSTAT.ZHANGQIAOC_SASHSEQ.NEXTVAL INTO LN_SEQ FROM DUAL;
    INSERT INTO PERFSTAT.ZHANGQIAOC_SASH
      SELECT D.DBID,
	     SYSDATE SAMPLE_TIME,
	     S.SID "SESSION_ID",
	     DECODE(W.WAIT_TIME, 0, 'WAITING', 'ON CPU') "SESSION_STATE",
	     S.SERIAL# "SESSION_SERIAL#",
	     S.USER# "USER_ID",
	     S.SQL_ADDRESS "SQL_ADDRESS",
	     -1 "SQL_PLAN_HASH_VALUE",
	     -1 "SQL_CHILD_NUMBER",
	     S.SQL_HASH_VALUE "SQL_ID",
	     S.COMMAND "SQL_OPCODE" /* aka SQL_OPCODE */,
	     S.TYPE "SESSION_TYPE",
	     -1 "EVENT#",
	     W.EVENT "EVENT",
	     W.SEQ# "SEQ#" /* xksuse.ksuseseq */,
	     W.P1 "P1" /* xksuse.ksusep1  */,
	     W.P2 "P2" /* xksuse.ksusep2  */,
	     W.P3 "P3" /* xksuse.ksusep3  */,
	     W.WAIT_TIME "WAIT_TIME" /* xksuse.ksusetim */,
	     W.SECONDS_IN_WAIT "TIME_WAITED" /* xksuse.ksusewtm */,
	     S.ROW_WAIT_OBJ# "CURRENT_OBJ#",
	     S.ROW_WAIT_FILE# "CURRENT_FILE#",
	     S.ROW_WAIT_BLOCK# "CURRENT_BLOCK#",
	     S.PROGRAM "PROGRAM",
	     S.MODULE_HASH "MODULE_HASH", /* ASH collects string */
	     S.ACTION_HASH "ACTION_HASH", /* ASH collects string */
	     S.FIXED_TABLE_SEQUENCE "FIXED_TABLE_SEQUENCE",
	     LN_SEQ SAMPLE_ID,
	     S.MACHINE,
	     S.TERMINAL
	FROM V$SESSION S, V$DATABASE D, V$SESSION_WAIT W
       WHERE S.SID != (SELECT DISTINCT SID FROM V$MYSTAT WHERE ROWNUM < 2)
	 AND W.SID = S.SID
	 AND S.STATUS = 'ACTIVE' /* ACTIVE */
	 AND LOWER(W.EVENT) NOT IN /* waiting and the wait event is not idle */
	     ('queue monitor wait', 'null event', 'pl/sql lock timer',
	      'px deq: execution msg', 'px deq: table q normal',
	      'px idle wait', 'sql*net message from client',
	      'sql*net message from dblink', 'dispatcher timer',
	      'lock manager wait for remote message', 'pipe get',
	      'pmon timer', 'queue messages', 'rdbms ipc message',
	      'slave wait', 'smon timer', 'virtual circuit status',
	      'wakeup time manager', 'i/o slave wait', 'jobq slave wait',
	      'queue monitor wait', 'SQL*Net message from client');
    COMMIT;
    DBMS_LOCK.SLEEP(1);
  END LOOP;
END;
/

