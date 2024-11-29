CREATE OR REPLACE PACKAGE "PAC_CHECK_OWNER" IS
  -----grant execute any procedure to dsg;
  ----- grant select any dictionary to dsg;
  ----- grant select any sequence to dsg;
  ----- grant select any table to dsg;
  -- AUTHOR  : ZHANGLI
  -- CREATED : 2008/4/19 9:31:05
  -- PURPOSE : 比对两边的数据
  --初始化比对对象，包括表，对象（存储过程，函数，包等等）
  --0 is not check
  --1 is check ok
  --2 is checking
  --3 is error
  --4 is stop
  PROCEDURE INIT_CHECK_OWNER(DS_OWNER IN VARCHAR2, DT_OWNER IN VARCHAR2);
  --比对单个表,首先count比对，如果两边的count值一致，然后再进行minus
  --初始化最后一次比对的表
  PROCEDURE INIT_CHECK_DATA;
  --再dsg_check_table里面status=2的是有问题的
  PROCEDURE CHECK_TABLE(P_DS_OWNER   IN VARCHAR2,
                        P_DT_OWNER   IN VARCHAR2,
                        P_TABLE_NAME IN VARCHAR2,
                        P_TABLE_TYPE IN NUMBER,
                        P_CHECK_TYPE IN NUMBER,
                        P_CK_TIME    IN NUMBER DEFAULT 0);
  --对比两边分区表
  PROCEDURE CHECK_TAB_PARTITION(P_DS_OWNER   IN VARCHAR2,
                                P_DT_OWNER   IN VARCHAR2,
                                P_TABLE_NAME IN VARCHAR2,
                                P_PART_NAME  IN VARCHAR2,
                                P_CHECK_TYPE IN NUMBER DEFAULT 0);
  --发起数据比对
  PROCEDURE CHECK_START(CK_TIMES NUMBER DEFAULT 1);
  --停止数据比对,status = 3 where status= 0
  PROCEDURE CHECK_STOP;
  --重新启动并发，断点序传,status=0 where status = 3
  PROCEDURE CHECK_CONTINUE;
  --比对结束,打印比对统计信息
  PROCEDURE CHECK_SUMMARY_PRINT;
  --发起比对对象
  PROCEDURE CHECK_OBJECTS;
  --找出不支持的表
  --  PROCEDURE CHECK_NO_SUP(P_OWNER IN VARCHAR2);
  --找出所有的job，以备可以手工处理
  PROCEDURE GET_ALL_JOB(P_OWNER IN VARCHAR2);
  --找出所有的lob数据
  PROCEDURE SHOW_ALL_LOB_TAB;
  --发起比对两边索引
  --  PROCEDURE CHECK_INDEX;
  ---for check table partition
  PROCEDURE SHOW_OBJECTS;
  FUNCTION GET_SQL_PART_TAB(P_DS_OWNER   VARCHAR2,
                            P_TABLE_NAME VARCHAR2,
                            P_PART_TAB   VARCHAR2) RETURN VARCHAR2;
  PROCEDURE SHOW_SPACE(P_SEGNAME   IN VARCHAR2,
                       P_OWNER     IN VARCHAR2 DEFAULT USER,
                       P_TYPE      IN VARCHAR2 DEFAULT 'TABLE',
                       P_PARTITION IN VARCHAR2 DEFAULT NULL);
  /*重建unusable索引，enable外健*/
  PROCEDURE REPAIR_OBJ;
  /*编译所有的对象*/
  PROCEDURE RECOMPILE_OBJ;
  /*打印核对表大小*/
  PROCEDURE SHOW_CHECK_TAB_SIZE;
  /*同不源端和目标端的SEQUENCE*/
  PROCEDURE SYNC_SEQ(P_DS_OWNER VARCHAR2, P_DT_OWNER VARCHAR2);
  /*同不源端和目标端的SYNONYM*/
  PROCEDURE SYNC_SYNONYM(P_DS_OWNER VARCHAR2, P_DT_OWNER VARCHAR2);
  /*打印出所有数据的大小，包括数据，索引，lob数据，lob索引 */
  PROCEDURE CHECK_VIEW(P_DS_OWNER VARCHAR2, P_DT_OWNER VARCHAR2);
  --  PROCEDURE SHOW_CHECK_TAB_SIZE;
  /*找出所有含有chained_rows的表*/
  PROCEDURE FIND_CHAINED_ROW;
  /*比对两边的表结构*/
  PROCEDURE PRO_TUNING;
  /*打印>255字节的数据*/
  PROCEDURE PRINT(MESG IN VARCHAR2, WRAPLENGTH IN NUMBER DEFAULT NULL);
END PAC_CHECK_OWNER;
/

CREATE OR REPLACE PACKAGE BODY "PAC_CHECK_OWNER" IS
  PROCEDURE INIT_CHECK_OWNER(DS_OWNER IN VARCHAR2, DT_OWNER IN VARCHAR2) IS
    V_DS_OWNER VARCHAR2(15) := UPPER(TRIM(DS_OWNER));
    V_DT_OWNER VARCHAR2(15) := UPPER(TRIM(DT_OWNER));
  BEGIN
    /*backup the last check of the owner ,but backup the last only one*/
    -- delete from dsg_check_his where ds_name = v_ds_owner;
    -- commit;
    INSERT INTO DSG_CHECK_HIS
      SELECT * FROM DSG_CHECK_TABLE;
    COMMIT;

    /*clear the current check table */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DSG_CHECK_TABLE';

    /*insert the current check partition table*/
    INSERT INTO DSG_CHECK_TABLE
      (DS_OWNER,
       DT_OWNER,
       DS_NAME,
       DT_NAME,
       TABLE_PARTITION,
       DS_COUNT,
       DT_COUNT,
       MINUS_COUNT,
       DIFF_TIME,
       SEQ,
       STATUS,
       CHECK_TYPE)
      SELECT V_DS_OWNER,
	     V_DT_OWNER,
	     TABLE_NAME,
	     TABLE_NAME,
	     PARTITION_NAME,
	     -- || '@dbverify',
	     0,
	     0,
	     0,
	     0,
	     0,
	     0,
	     'TABLE PARTITION'
	FROM ALL_TAB_PARTITIONS@DBVERIFY ATP
       WHERE ATP.TABLE_OWNER = V_DS_OWNER
	 AND ATP.TABLE_NAME IN
	     (SELECT TABLE_NAME
		FROM ALL_PART_TABLES APT
	       WHERE APT.OWNER = V_DS_OWNER
		 AND APT.PARTITIONING_TYPE IN ('RANGE', 'LIST'));
    /*insert the current check normal table*/
    INSERT INTO DSG_CHECK_TABLE
      (DS_OWNER,
       DT_OWNER,
       DS_NAME,
       DT_NAME,
       TABLE_PARTITION,
       DS_COUNT,
       DT_COUNT,
       MINUS_COUNT,
       DIFF_TIME,
       SEQ,
       STATUS,
       CHECK_TYPE)
      SELECT V_DS_OWNER,
	     V_DT_OWNER,
	     OBJECT_NAME,
	     OBJECT_NAME,
	     'NORMAL',
	     -- || '@dbverify',
	     0,
	     0,
	     0,
	     0,
	     0,
	     0,
	     OBJECT_TYPE
	FROM ALL_OBJECTS@DBVERIFY
       WHERE OWNER = V_DS_OWNER
	 AND OBJECT_TYPE LIKE 'TABLE';

    /*insert into current check which is the all objects */
    INSERT INTO DSG_CHECK_TABLE
      (DS_OWNER,
       DT_OWNER,
       DS_NAME,
       DT_NAME,
       TABLE_PARTITION,
       DS_COUNT,
       DT_COUNT,
       MINUS_COUNT,
       DIFF_TIME,
       SEQ,
       STATUS,
       CHECK_TYPE)
      SELECT DISTINCT V_DS_OWNER,
		      V_DT_OWNER,
		      OBJECT_TYPE,
		      OBJECT_TYPE,
		      'DSG_OBJECTS',
		      COUNT(1),
		      0,
		      0,
		      0,
		      0,
		      0,
		      OBJECT_TYPE
	FROM DBA_OBJECTS@DBVERIFY
       WHERE OWNER = V_DS_OWNER
	 AND OWNER NOT IN ('SYS', 'SYSTEM', 'OUTLN', 'PERFSTAT')
	 AND OBJECT_TYPE IN ('DIMENSION',
			     'FUNCTION',
			     'INDEXTYPE',
			     'JAVA CLASS',
			     'JAVA SOURCE',
			     'MATERIALIZED VIEW',
			     'OPERATOR',
			     'PACKAGE',
			     'PROCEDURE',
			     'TRIGGER',
			     'TYPE',
			     'TYPE BODY',
			     'VIEW',
			     'SYNONYM',
			     'DATABASE LINK',
			     'PACKAGE BODY',
			     'DATABASE LINK')
       GROUP BY OWNER, OBJECT_TYPE;
    /*insert into the index type for total it*/
    INSERT INTO DSG_CHECK_TABLE
      (DS_OWNER,
       DT_OWNER,
       DS_NAME,
       DT_NAME,
       TABLE_PARTITION,
       DS_COUNT,
       DT_COUNT,
       MINUS_COUNT,
       DIFF_TIME,
       SEQ,
       STATUS,
       CHECK_TYPE)
      SELECT DISTINCT V_DS_OWNER,
		      V_DT_OWNER,
		      'INDEX',
		      'INDEX',
		      'DSG_INDEX',
		      --decode(object_type,'INDEX PARTITION','INDEX',object_type),
		      --decode(object_type,'INDEX PARTITION','INDEX',object_type),
		      COUNT(1),
		      0,
		      0,
		      0,
		      0,
		      0,
		      'INDEX'
	FROM ALL_INDEXES@DBVERIFY
       WHERE OWNER = V_DS_OWNER
	 AND OWNER NOT IN ('SYS', 'SYSTEM', 'OUTLN', 'PERFSTAT')
   AND INDEX_NAME NOT LIKE 'BIN%'
   AND TABLE_OWNER =  V_DS_OWNER
       GROUP BY OWNER;

    --decode(object_type,'INDEX PARTITION','INDEX',object_type);
    /*for check every sequence for check is right*/
    INSERT INTO DSG_CHECK_TABLE
      (DS_OWNER,
       DT_OWNER,
       DS_NAME,
       DT_NAME,
       TABLE_PARTITION,
       DS_COUNT,
       DT_COUNT,
       MINUS_COUNT,
       DIFF_TIME,
       SEQ,
       STATUS,
       CHECK_TYPE)
      SELECT V_DS_OWNER,
	     V_DT_OWNER,
	     OBJECT_NAME,
	     OBJECT_NAME,
	     'DSG_SEQUENCE',
	     0,
	     0,
	     0,
	     0,
	     0,
	     0,
	     OBJECT_TYPE
	FROM ALL_OBJECTS@DBVERIFY
       WHERE OWNER = V_DS_OWNER
	 AND OBJECT_TYPE = 'SEQUENCE';

    /*for deal the last exception*/
    DELETE FROM DSG_CHECK_TABLE
     WHERE CHECK_TYPE = 'TABLE'
       AND (DS_OWNER, DS_NAME) IN
	   (SELECT DS_OWNER, DS_NAME
	      FROM DSG_CHECK_TABLE
	     WHERE CHECK_TYPE = 'TABLE PARTITION');
    /*
    update dsg_check_table
     set seg_byte = (select sum(bytes)
      from dba_segments@dbverify
     where owner = ds_owner
       and segment_name = ds_name
       and table_partition = partition_name)
     where table_partition not in
      ('DSG_SEQUENCE', 'DSG_OBJECTS', 'DSG_INDEX', 'NORMAL');
    update dsg_check_table
     set seg_byte = (select sum(bytes)
      from dba_extents@dbverify
     where owner = ds_owner
       and segment_name = ds_name)
     where table_partition = 'NORMAL';
     */
    UPDATE DSG_CHECK_TABLE SET SEG_BYTE = 0 WHERE SEG_BYTE IS NULL;
    COMMIT;
    DELETE FROM DSG_CHECK_TABLE
     WHERE DS_NAME LIKE 'BIN$%'
	OR DS_NAME LIKE 'MLOG$%'
	OR DS_NAME LIKE 'RUPD$%';
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END INIT_CHECK_OWNER;

  /*初始化最后一次比对的表*/
  PROCEDURE INIT_CHECK_DATA IS
  BEGIN
    UPDATE DSG_CHECK_TABLE
       SET DS_COUNT	 = 0,
	   DT_COUNT	 = 0,
	   MINUS_COUNT	 = 0,
	   DIFF_TIME	 = 0,
	   SEQ		 = 0,
	   STATUS	 = 0,
	   START_DIFF	 = NULL,
	   MINUS_DIFF	 = NULL,
	   DS_COUNT_DIFF = NULL,
	   DT_COUNT_DIFF = NULL,
	   ERR_MSG	 = NULL,
	   CHECK_SQL	 = NULL;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END INIT_CHECK_DATA;

  PROCEDURE CHECK_START(CK_TIMES NUMBER DEFAULT 1) IS
    V_JUDGE	  NUMBER := 1;
    V_CK_TIMES	  NUMBER := CK_TIMES;
    V_SESSION_ID  NUMBER;
    V_CLIENT_INFO VARCHAR2(50);
    /*
     CURSOR c_owner_table
     IS
     SELECT ds_owner, dt_owner, ds_name
     FROM dsg_check_table
    WHERE status = 0 AND check_type LIKE 'TABLE%' and status = 0 and rownum<2;
    */
  BEGIN
    IF V_CK_TIMES = 0 THEN
      /* this is a dead loop for plan more then one process*/
      WHILE 1 = 1 LOOP
	SELECT COUNT(1)
	  INTO V_JUDGE
	  FROM DSG_CHECK_TABLE
	 WHERE CHECK_TYPE LIKE 'TABLE%'
	   AND STATUS = 0;
	IF V_JUDGE <= 0 THEN
	  EXIT;
	END IF;
	FOR C IN (SELECT DS_OWNER,
			 DT_OWNER,
			 DS_NAME,
			 TABLE_PARTITION,
			 CHECK_TYPE
		    FROM (SELECT DS_OWNER,
				 DT_OWNER,
				 DS_NAME,
				 TABLE_PARTITION,
				 CHECK_TYPE
			    FROM DSG_CHECK_TABLE
			   WHERE CHECK_TYPE LIKE 'TABLE%'
			     AND STATUS = 0
			   ORDER BY SEG_BYTE DESC)
		   WHERE ROWNUM < 2) LOOP
	  /*get current session's sid,ip*/
	  SELECT SYS_CONTEXT('USERENV', 'SESSIONID'),
		 SYS_CONTEXT('USERENV', 'CLIENT_INFO')
	    INTO V_SESSION_ID, V_CLIENT_INFO
	    FROM DUAL;

	  /*for division check table's type*/
	  IF C.CHECK_TYPE = 'TABLE' THEN
	    UPDATE DSG_CHECK_TABLE
	       SET SEQ = V_SESSION_ID, ERR_MSG = V_CLIENT_INFO
	     WHERE DS_OWNER = C.DS_OWNER
	       AND DT_OWNER = C.DT_OWNER
	       AND DS_NAME = C.DS_NAME;
	    COMMIT;
	    CHECK_TABLE(C.DS_OWNER,
			C.DT_OWNER,
			C.DS_NAME,
			0,
			0,
			V_CK_TIMES);
	  ELSIF C.CHECK_TYPE = 'TABLE PARTITION' THEN
	    CHECK_TABLE(C.DS_OWNER,
			C.DT_OWNER,
			C.DS_NAME,
			1,
			0,
			V_CK_TIMES);
	    /*check_tab_partition(c.ds_owner,
	    c.dt_owner,
	    c.ds_name,
	    c.table_partition);*/
	  END IF;
	END LOOP;
      END LOOP;
    ELSE
      WHILE 1 = 1 LOOP
	SELECT COUNT(1)
	  INTO V_JUDGE
	  FROM DSG_CHECK_TABLE
	 WHERE (CHECK_TYPE LIKE 'TABLE%' AND STATUS = 0 AND
	       DIFF_TIME < V_CK_TIMES)
	    OR (CHECK_TYPE LIKE 'TABLE%' AND STATUS = 3 AND
	       DIFF_TIME < V_CK_TIMES);
	--  dbms_output.put_line(v_ck_times);
	IF V_JUDGE <= 0 THEN
	  EXIT;
	END IF;
	FOR C IN (SELECT DS_OWNER,
			 DT_OWNER,
			 DS_NAME,
			 TABLE_PARTITION,
			 CHECK_TYPE
		    FROM (SELECT DS_OWNER,
				 DT_OWNER,
				 DS_NAME,
				 TABLE_PARTITION,
				 CHECK_TYPE
			    FROM DSG_CHECK_TABLE
			   WHERE CHECK_TYPE LIKE 'TABLE%'
			     AND STATUS = 0
			     AND DIFF_TIME < V_CK_TIMES
			      OR CHECK_TYPE LIKE 'TABLE%'
			     AND STATUS = 3
			     AND DIFF_TIME < V_CK_TIMES
			   ORDER BY SEG_BYTE DESC)
		   WHERE ROWNUM < 2) LOOP
	  /*get current session's sid,ip*/
	  SELECT SYS_CONTEXT('USERENV', 'SESSIONID'),
		 SYS_CONTEXT('USERENV', 'CLIENT_INFO')
	    INTO V_SESSION_ID, V_CLIENT_INFO
	    FROM DUAL;

	  /*for division check table's type*/
	  IF C.CHECK_TYPE = 'TABLE' THEN
	    UPDATE DSG_CHECK_TABLE
	       SET SEQ = V_SESSION_ID, ERR_MSG = V_CLIENT_INFO
	     WHERE DS_OWNER = C.DS_OWNER
	       AND DT_OWNER = C.DT_OWNER
	       AND DS_NAME = C.DS_NAME;
	    COMMIT;
	    CHECK_TABLE(C.DS_OWNER,
			C.DT_OWNER,
			C.DS_NAME,
			0,
			0,
			V_CK_TIMES);
	  ELSIF C.CHECK_TYPE = 'TABLE PARTITION' THEN
	    CHECK_TABLE(C.DS_OWNER,
			C.DT_OWNER,
			C.DS_NAME,
			1,
			0,
			V_CK_TIMES);
	    /*check_tab_partition(c.ds_owner,
	    c.dt_owner,
	    c.ds_name,
	    c.table_partition);*/
	  END IF;
	END LOOP;
      END LOOP;
    END IF;
  END CHECK_START;

  /*STOP THE CHECK TABLE */
  PROCEDURE CHECK_STOP IS
    V_SESSION_ID  NUMBER;
    V_CLIENT_INFO VARCHAR2(50);
  BEGIN
    SELECT SYS_CONTEXT('USERENV', 'SESSIONID'),
	   SYS_CONTEXT('USERENV', 'CLIENT_INFO')
      INTO V_SESSION_ID, V_CLIENT_INFO
      FROM DUAL;

    UPDATE DSG_CHECK_TABLE
       SET STATUS = 4, SEQ = V_SESSION_ID, ERR_MSG = V_CLIENT_INFO
     WHERE STATUS = 0;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END CHECK_STOP;

  /* CONTINUE THE CHECK */
  PROCEDURE CHECK_CONTINUE IS
  BEGIN
    UPDATE DSG_CHECK_TABLE
       SET STATUS = 0, SEQ = 0, ERR_MSG = NULL
     WHERE STATUS = 4;

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END CHECK_CONTINUE;

  /*FOR SUMMARY CHECK RESULT */
  PROCEDURE CHECK_SUMMARY_PRINT IS
    CURSOR C_CHECK_TAB IS
      SELECT * FROM DSG_CHECK_TABLE;

    V_SEQ_OK	   NUMBER := 0;
    V_SEQ_MID	   NUMBER := 0;
    V_SEQ_ERR	   NUMBER := 0;
    V_OBJ_NAME	   VARCHAR2(400);
    V_TAB_OK	   NUMBER := 0;
    V_TAB_MID	   NUMBER := 0;
    V_TAB_ERR	   NUMBER := 0;
    V_PERCENT_OK   NUMBER;
    V_PERCENT_ERR  NUMBER;
    V_PERCENT_NONE NUMBER;
    V_TAB_COUNT    NUMBER;
    V_SEQ_COUNT    NUMBER;
  BEGIN
    DBMS_OUTPUT.ENABLE(300000);
    FOR C IN C_CHECK_TAB LOOP
      IF C.CHECK_TYPE LIKE 'TABLE%' THEN
	IF C.STATUS = 1 THEN
	  V_TAB_OK := V_TAB_OK + 1;
	ELSIF C.STATUS = 2 THEN
	  V_TAB_MID := V_TAB_MID + 1;
	ELSIF C.STATUS = 3 THEN
	  V_TAB_ERR := V_TAB_ERR + 1;
	END IF;
      ELSIF C.CHECK_TYPE LIKE 'SEQUENCE' THEN
	IF C.STATUS = 1 THEN
	  V_SEQ_OK := V_SEQ_OK + 1;
	ELSIF C.STATUS = 2 THEN
	  V_SEQ_MID := V_SEQ_MID + 1;
	ELSIF C.STATUS = 3 THEN
	  V_SEQ_ERR := V_SEQ_ERR + 1;
	END IF;
      ELSE
	IF C.STATUS = 0 THEN
	  V_OBJ_NAME := V_OBJ_NAME || CHR(10) || ' Not Check ' || C.DS_NAME || '. ';
	ELSIF C.STATUS = 2 THEN
	  V_OBJ_NAME := V_OBJ_NAME || CHR(10) || C.DS_OWNER || '.' ||
			C.DS_NAME || '(' || C.DS_COUNT || '->' ||
			C.DT_COUNT || ')' || CHR(10) || V_OBJ_NAME;
	ELSE
	  V_OBJ_NAME := V_OBJ_NAME || CHR(10) ||
			RPAD(C.DS_NAME || ' Check ok ! ', 40, '.');
	END IF;
      END IF;
      --dbms_output.put_line(c.check_type||' '||c.ds_name||'  '||v_seq_mid);
    END LOOP;
    SELECT DECODE(TRUNC(A.SUM * 100 / DECODE(B.SUM, 0, 1), 2),
		  NULL,
		  0,
		  TRUNC(A.SUM * 100 / DECODE(B.SUM, 0, 1), 2))
      INTO V_PERCENT_OK
      FROM (SELECT SUM(SEG_BYTE) SUM FROM DSG_CHECK_TABLE WHERE STATUS = 1) A,
	   (SELECT SUM(SEG_BYTE) SUM FROM DSG_CHECK_TABLE) B;
    SELECT DECODE(TRUNC(A.SUM * 100 / DECODE(B.SUM, 0, 1), 2),
		  NULL,
		  0,
		  TRUNC(A.SUM * 100 / DECODE(B.SUM, 0, 1), 2))
      INTO V_PERCENT_ERR
      FROM (SELECT SUM(SEG_BYTE) SUM FROM DSG_CHECK_TABLE WHERE STATUS = 2) A,
	   (SELECT SUM(SEG_BYTE) SUM FROM DSG_CHECK_TABLE) B;
    SELECT DECODE(TRUNC(A.SUM * 100 / DECODE(B.SUM, 0, 1), 2),
		  NULL,
		  0,
		  TRUNC(A.SUM * 100 / DECODE(B.SUM, 0, 1), 2))
      INTO V_PERCENT_NONE
      FROM (SELECT SUM(SEG_BYTE) SUM FROM DSG_CHECK_TABLE WHERE STATUS = 0) A,
	   (SELECT SUM(SEG_BYTE) SUM FROM DSG_CHECK_TABLE) B;
    SELECT COUNT(1)
      INTO V_TAB_COUNT
      FROM DSG_CHECK_TABLE
     WHERE CHECK_TYPE LIKE 'TABLE%';
    SELECT COUNT(1)
      INTO V_SEQ_COUNT
      FROM DSG_CHECK_TABLE
     WHERE CHECK_TYPE LIKE 'SEQUENCE%';
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 100, '='));
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 50, ' ') || 'DSG' || RPAD(' ', 46, ' ') || '=');
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 100, '='));
    DBMS_OUTPUT.PUT_LINE(RPAD('', 5, ' ') || LPAD('TYPE ', 20, ' ') ||
			 LPAD('VALUE_OK', 20, ' ') ||
			 LPAD('VALUE_ERR', 20, ' ') ||
			 LPAD('VALUE_NONE', 20, ' ') ||
			 LPAD('VALUE_TAB_COUNT', 20, ' '));
    DBMS_OUTPUT.PUT_LINE(RPAD('', 5, ' ') || LPAD('TABLE', 20, ' ') ||
			 LPAD(V_TAB_OK, 20, ' ') ||
			 LPAD(V_TAB_ERR, 20, ' ') ||
			 LPAD(V_TAB_MID, 20, ' ') ||
			 LPAD(V_TAB_COUNT, 20, ' '));
    DBMS_OUTPUT.PUT_LINE(RPAD('', 5, ' ') || LPAD('SEQUENCE', 20, ' ') ||
			 LPAD(V_SEQ_OK, 20, ' ') ||
			 LPAD(V_SEQ_ERR, 20, ' ') ||
			 LPAD(V_SEQ_MID, 20, ' ') ||
			 LPAD(V_SEQ_COUNT, 20, ' '));
    DBMS_OUTPUT.PUT_LINE('Complete comparison ' || V_PERCENT_OK || '%');
    DBMS_OUTPUT.PUT_LINE('Or are in the wrong comparison ' ||
			 V_PERCENT_ERR || '%');
    DBMS_OUTPUT.PUT_LINE('Unfinished comparison ' || V_PERCENT_NONE || '%');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 100, '-'));
    DBMS_OUTPUT.PUT_LINE(RPAD(' ', 10, ' ') || V_OBJ_NAME || CHR(10) ||
			 RPAD('', 5, ' '));
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 100, '='));
  END;

  /*only check one table*/
  PROCEDURE CHECK_TABLE(P_DS_OWNER   IN VARCHAR2,
			P_DT_OWNER   IN VARCHAR2,
			P_TABLE_NAME IN VARCHAR2,
			P_TABLE_TYPE IN NUMBER,
			P_CHECK_TYPE IN NUMBER,
			P_CK_TIME    IN NUMBER DEFAULT 0) IS
    V_CHECK_RESULT NUMBER;
    V_SQL_ST	   VARCHAR2(50);
    V_DS_COUNT	   NUMBER;
    V_DT_COUNT	   NUMBER;
    V_SQL_ERR	   VARCHAR2(500);
    V_JUDGE	   NUMBER;
    V_SESSION_ID   NUMBER;
    V_CLIENT_INFO  VARCHAR2(50);
    -- Local variables here
    V_ALL_SQL	 CLOB;
    V_SQL_DS	 CLOB;
    V_SQL_DT	 CLOB;
    V_SQL_CK	 VARCHAR2(4000);
    V_SQL_TMP	 CLOB;
    V_CK_TIME	 NUMBER := P_CK_TIME;
    V_DS_OWNER	 VARCHAR2(15) := TRIM(UPPER(P_DS_OWNER));
    V_DT_OWNER	 VARCHAR2(15) := TRIM(UPPER(P_DT_OWNER));
    V_TABLE_NAME VARCHAR2(50) := TRIM(P_TABLE_NAME);
    V_FULL_SQL	 CLOB := 'All check sql is :';

    /*for get all columns of the table ,which is not include the long,lob and so on*/
    CURSOR C_CHECK_TAB_COL_SQL IS
      SELECT DB.OWNER, DB.TABLE_NAME, COLUMN_NAME, DATA_TYPE
	FROM ALL_TAB_COLUMNS@DBVERIFY DB, DSG_CHECK_TABLE DCT
       WHERE DATA_TYPE NOT IN
	     ('LONG', 'CLOB', 'BLOB', 'NCLOB', 'NBLOB', 'BFILE', 'LONG RAW')
	 AND DB.OWNER = V_DS_OWNER
	 AND DB.TABLE_NAME = DCT.DS_NAME
	 AND TABLE_NAME = V_TABLE_NAME;

    /* for get the one partition in the partitions table's */
    CURSOR C_CHECK_PART_TAB(C_DS_OWNER VARCHAR2, C_TABLE_NAME VARCHAR2) IS
      SELECT DS_OWNER, DT_OWNER, DS_NAME, TABLE_PARTITION
	FROM DSG_CHECK_TABLE
       WHERE DS_OWNER = V_DS_OWNER
	 AND DS_NAME = V_TABLE_NAME
	 AND ROWNUM < 2
	 AND STATUS = 0;
    CURSOR C_CHECK_PART_TAB_2(C_DS_OWNER VARCHAR2, C_TABLE_NAME VARCHAR2) IS
      SELECT DS_OWNER, DT_OWNER, DS_NAME, TABLE_PARTITION
	FROM DSG_CHECK_TABLE
       WHERE DS_OWNER = V_DS_OWNER
	 AND DS_NAME = V_TABLE_NAME
	 AND ROWNUM < 2
	 AND STATUS = 0
	 AND DIFF_TIME < V_CK_TIME
	  OR DS_OWNER = V_DS_OWNER
	 AND DS_NAME = V_TABLE_NAME
	 AND ROWNUM < 2
	 AND STATUS = 3
	 AND DIFF_TIME < V_CK_TIME;
  BEGIN
    --dbms_output.enable(29999);
    V_SQL_ERR := NULL;

    --dbms_output.put_line('p_check_type'||p_check_type);
    IF P_TABLE_TYPE = 0 THEN
      /* for check normal table */
      BEGIN
	---For get start time
	UPDATE DSG_CHECK_TABLE
	   SET START_DIFF    = SYSDATE,
	       DS_COUNT_DIFF = SYSDATE,
	       DT_COUNT_DIFF = SYSDATE,
	       MINUS_DIFF    = SYSDATE,
	       DIFF_TIME     = DIFF_TIME + 1,
	       STATUS	     = 2
	 WHERE DS_OWNER = V_DS_OWNER
	   AND DS_NAME = V_TABLE_NAME;
	COMMIT;
	V_SQL_CK := 'SELECT /*+parallel(B,10)+*/ ds_count,dt_count  FROM (' ||
		    'select count(1) ds_count from ' || V_DS_OWNER || '."' ||
		    V_TABLE_NAME ||
		    '"@dbverify ) A ,(select count(1) dt_count from ' ||
		    V_DT_OWNER || '."' || V_TABLE_NAME || '" ) B ';
	-- dbms_output.put_line(v_sql_ck);
	V_FULL_SQL := V_FULL_SQL || CHR(10) || V_SQL_CK;

	EXECUTE IMMEDIATE V_SQL_CK
	  INTO V_DS_COUNT, V_DT_COUNT;

	UPDATE DSG_CHECK_TABLE
	   SET DS_COUNT_DIFF = SYSDATE,
	       DT_COUNT_DIFF = SYSDATE,
	       MINUS_DIFF    = SYSDATE,
	       DS_COUNT      = V_DS_COUNT,
	       DT_COUNT      = V_DT_COUNT,
	       STATUS	     = 2,
	       CHECK_SQL     = V_FULL_SQL
	 WHERE DT_OWNER = V_DT_OWNER
	   AND DS_NAME = V_TABLE_NAME;

	COMMIT;
	--dbms_output.put_line(p_check_type || ' ' || v_ds_count || ' ' ||v_dt_count);
	IF P_CHECK_TYPE = 0 THEN
	  IF V_DT_COUNT = V_DS_COUNT THEN
	    V_SQL_ST  := 'SELECT /*+parallel(t,10)+*/ COUNT(1) FROM (SELECT ';
	    V_SQL_TMP := V_SQL_TMP || ' 1,';
	    -- Test statements here
	    FOR C IN C_CHECK_TAB_COL_SQL LOOP
	      IF C.COLUMN_NAME IS NOT NULL THEN
		IF C.DATA_TYPE LIKE '%CHAR%' THEN
		  V_SQL_TMP := V_SQL_TMP || '"' || C.COLUMN_NAME ||
			       '",';
		ELSE
		  V_SQL_TMP := V_SQL_TMP || '"' || C.COLUMN_NAME || '",';
		END IF;
	      END IF;
	      -- dbms_output.put_line(v_sql_tmp);
	    END LOOP;
	    -- dbms_output.put_line(v_sql_tmp);
	    V_SQL_DS   := SUBSTR(V_SQL_TMP, 0, LENGTH(V_SQL_TMP) - 1) ||
			  ' FROM "' || V_DS_OWNER || '"."' || V_TABLE_NAME ||
			  '"@dbverify';
	    V_SQL_DT   := SUBSTR(V_SQL_TMP, 0, LENGTH(V_SQL_TMP) - 1) ||
			  ' FROM "' || V_DT_OWNER || '"."' || V_TABLE_NAME || '"';
	    V_ALL_SQL  := V_SQL_ST || V_SQL_DS || ' MINUS SELECT ' ||
			  V_SQL_DT || ') t';
	    V_FULL_SQL := V_FULL_SQL || CHR(10) || V_ALL_SQL;
	    --dbms_output.put_line(v_all_sql);

	    EXECUTE IMMEDIATE DBMS_LOB.SUBSTR(V_ALL_SQL)
	      INTO V_CHECK_RESULT;
	    IF V_CHECK_RESULT > 0 THEN
	      UPDATE DSG_CHECK_TABLE
		 SET MINUS_DIFF  = SYSDATE,
		     MINUS_COUNT = V_CHECK_RESULT,
		     STATUS	 = 3,
		     CHECK_SQL	 = V_FULL_SQL
	       WHERE DS_OWNER = V_DS_OWNER
		 AND DS_NAME = V_TABLE_NAME;
	    ELSE
	      UPDATE DSG_CHECK_TABLE
		 SET MINUS_DIFF  = SYSDATE,
		     MINUS_COUNT = V_CHECK_RESULT,
		     STATUS	 = 1,
		     CHECK_SQL	 = V_FULL_SQL
	       WHERE DS_OWNER = V_DS_OWNER
		 AND DS_NAME = V_TABLE_NAME;
	    END IF;
	    COMMIT;
	    --	INSERT INTO DSG_TEXT (TEXT) VALUES (V_SQL);
	    --	COMMIT;
	  ELSE
	    UPDATE DSG_CHECK_TABLE
	       SET MINUS_DIFF  = SYSDATE,
		   MINUS_COUNT = V_CHECK_RESULT,
		   STATUS      = 3,
		   CHECK_SQL   = V_FULL_SQL
	     WHERE DS_OWNER = V_DS_OWNER
	       AND DS_NAME = V_TABLE_NAME;
	    COMMIT;
	  END IF;
	END IF;
      EXCEPTION
	WHEN OTHERS THEN
	  V_SQL_ERR := SQLERRM;
	  UPDATE DSG_CHECK_TABLE
	     SET MINUS_DIFF  = SYSDATE,
		 MINUS_COUNT = V_CHECK_RESULT,
		 STATUS      = 3,
		 CHECK_SQL   = V_FULL_SQL
	   WHERE DS_OWNER = V_DS_OWNER
	     AND DS_NAME = V_TABLE_NAME;
	  COMMIT;
	  /*
	  dbms_output.put_line('v_all_sql is '||v_all_sql);
	  dbms_output.put_line('v_ds_sql is  '||v_sql_ds);
	  dbms_output.put_line('v_dt_sql is  '||v_sql_dt);
	  dbms_output.put_line('v_full_sql is'||v_full_sql);
	  */
      END;

      IF V_SQL_ERR IS NOT NULL THEN
	UPDATE DSG_CHECK_TABLE
	   SET ERR_MSG = V_SQL_ERR
	 WHERE DS_OWNER = V_DS_OWNER
	   AND DS_NAME = V_TABLE_NAME;

	DBMS_OUTPUT.PUT_LINE(V_SQL_ERR);
	COMMIT;
      END IF;
    ELSIF P_TABLE_TYPE = 1 THEN
      /* for check partition table */
      IF V_CK_TIME = 1 THEN
	WHILE 1 = 1 LOOP
	  SELECT COUNT(1)
	    INTO V_JUDGE
	    FROM DSG_CHECK_TABLE DCT
	   WHERE DCT.DS_OWNER = P_DS_OWNER
	     AND DCT.DS_NAME = P_TABLE_NAME
	     AND STATUS = 0;
	  IF V_JUDGE > 0 THEN
	    FOR C IN C_CHECK_PART_TAB(V_DS_OWNER, V_TABLE_NAME) LOOP
	      SELECT SYS_CONTEXT('USERENV', 'SESSIONID'),
		     SYS_CONTEXT('USERENV', 'CLIENT_INFO')
		INTO V_SESSION_ID, V_CLIENT_INFO
		FROM DUAL;
	      UPDATE DSG_CHECK_TABLE
		 SET SEQ       = V_SESSION_ID,
		     ERR_MSG   = V_CLIENT_INFO,
		     DIFF_TIME = DIFF_TIME + 1
	       WHERE DS_OWNER = C.DS_OWNER
		 AND DS_NAME = C.DS_NAME
		 AND TABLE_PARTITION = C.TABLE_PARTITION;
	      COMMIT;
	      DBMS_OUTPUT.PUT_LINE(V_CLIENT_INFO);
	      CHECK_TAB_PARTITION(P_DS_OWNER   => C.DS_OWNER,
				  P_DT_OWNER   => C.DT_OWNER,
				  P_TABLE_NAME => C.DS_NAME,
				  P_PART_NAME  => C.TABLE_PARTITION,
				  P_CHECK_TYPE => P_CHECK_TYPE);
	      --  dbms_output.put_line(c.ds_owner || '.' || c.ds_name || '.' ||c.table_partition);
	    END LOOP;
	  ELSE
	    EXIT;
	  END IF;
	END LOOP;
      ELSE
	WHILE 1 = 1 LOOP
	  SELECT COUNT(1)
	    INTO V_JUDGE
	    FROM DSG_CHECK_TABLE DCT
	   WHERE (DCT.DS_OWNER = P_DS_OWNER AND DCT.DS_NAME = P_TABLE_NAME AND
		 STATUS = 0 AND DIFF_TIME < V_CK_TIME)
	      OR (DCT.DS_OWNER = P_DS_OWNER AND DCT.DS_NAME = P_TABLE_NAME AND
		 STATUS = 3 AND DIFF_TIME < V_CK_TIME);
	  --dbms_output.put_line(p_ds_owner || '.' || p_table_name || ' ' ||v_judge || ' ' || v_ck_time);
	  IF V_JUDGE > 0 THEN
	    FOR C IN C_CHECK_PART_TAB_2(V_DS_OWNER, V_TABLE_NAME) LOOP
	      SELECT SYS_CONTEXT('USERENV', 'SESSIONID'),
		     SYS_CONTEXT('USERENV', 'CLIENT_INFO')
		INTO V_SESSION_ID, V_CLIENT_INFO
		FROM DUAL;

	      UPDATE DSG_CHECK_TABLE
		 SET SEQ       = V_SESSION_ID,
		     ERR_MSG   = V_CLIENT_INFO,
		     STATUS    = 2,
		     DIFF_TIME = DIFF_TIME + 1
	       WHERE DS_OWNER = C.DS_OWNER
		 AND DS_NAME = C.DS_NAME
		 AND TABLE_PARTITION = C.TABLE_PARTITION;
	      COMMIT;
	      DBMS_OUTPUT.PUT_LINE(V_CLIENT_INFO);
	      CHECK_TAB_PARTITION(P_DS_OWNER   => C.DS_OWNER,
				  P_DT_OWNER   => C.DT_OWNER,
				  P_TABLE_NAME => C.DS_NAME,
				  P_PART_NAME  => C.TABLE_PARTITION,
				  P_CHECK_TYPE => P_CHECK_TYPE);
	      --  dbms_output.put_line(c.ds_owner || '.' || c.ds_name || '.' ||c.table_partition);
	    END LOOP;
	  ELSE
	    DBMS_OUTPUT.PUT_LINE(' not found !');
	    EXIT;
	  END IF;
	END LOOP;
      END IF;
    ELSE
      DBMS_OUTPUT.PUT_LINE('check object err!');
    END IF;
  END CHECK_TABLE;
  -----------------------------------------------------------------------------------------------------
  -----------for partition table check --------------------------
  -----------------------------------------------------------------------------------------------------
  /*
  grant drop any synonym to dsg
  grant create any synonym to dsg
  */
  PROCEDURE CHECK_TAB_PARTITION(P_DS_OWNER   IN VARCHAR2,
				P_DT_OWNER   IN VARCHAR2,
				P_TABLE_NAME IN VARCHAR2,
				P_PART_NAME  IN VARCHAR2,
				P_CHECK_TYPE IN NUMBER) IS
    V_CHECK_RESULT NUMBER := 0;
    --	v_dsg_no number;
    --v_create_synonym varchar2(200);
    --v_drop_synonym varchar2(200);
    --v_ds_synonym  varchar2(100);
    V_SQL_ERR  VARCHAR2(500);
    V_SQL_CK   VARCHAR2(1000);
    V_ALL_SQL  CLOB;
    V_SQL_DS   CLOB;
    V_SQL_DT   CLOB;
    V_SQL_TMP  CLOB;
    V_SQL_ST   VARCHAR2(200);
    V_DT_COUNT NUMBER := 0;
    V_DS_COUNT NUMBER := 0;
    --v_synonym_ck  number := 0;
    V_WHERE_SQL  VARCHAR2(4000);
    V_SQL_LENGTH NUMBER := 0;
    V_FULL_SQL	 CLOB := 'All check sql is :';

    /* for get all columns of partition table */
    CURSOR C_CHECK_TAB_COL_SQL IS
      SELECT DB.OWNER, DB.TABLE_NAME, COLUMN_NAME, DATA_TYPE
	FROM ALL_TAB_COLUMNS@DBVERIFY DB, DSG_CHECK_TABLE DCT
       WHERE DATA_TYPE NOT IN
	     ('LONG', 'CLOB', 'BLOB', 'NCLOB', 'NBLOB', 'BFILE', 'LONG RAW')
	 AND DB.OWNER = P_DS_OWNER
	 AND DB.TABLE_NAME = DCT.DS_NAME
	 AND TABLE_NAME = P_TABLE_NAME
	 AND DCT.TABLE_PARTITION = P_PART_NAME;
  BEGIN
    --DBMS_OUTPUT.put_line(p_ds_owner||'->'||P_DT_OWNER);
    BEGIN
      -- dbms_output.enable(10000);
      /*get get the condition of the partition */
      V_WHERE_SQL := '';
      V_SQL_ERR   := '';

      UPDATE DSG_CHECK_TABLE
	 SET START_DIFF    = SYSDATE,
	     DS_COUNT_DIFF = SYSDATE,
	     DT_COUNT_DIFF = SYSDATE,
	     MINUS_DIFF    = SYSDATE,
	     STATUS	   = 2,
	     DS_COUNT	   = 0,
	     DT_COUNT	   = 0
       WHERE DT_OWNER = P_DT_OWNER
	 AND DS_NAME = P_TABLE_NAME
	 AND TABLE_PARTITION = P_PART_NAME;
      COMMIT;

      SELECT GET_SQL_PART_TAB(P_DS_OWNER, P_TABLE_NAME, P_PART_NAME)
	INTO V_WHERE_SQL
	FROM DUAL;

      --dbms_output.put_line(v_where_sql);
      IF V_WHERE_SQL IS NULL THEN
	GOTO ERR;
      ELSIF V_WHERE_SQL LIKE '%DEFAULT' THEN
	V_SQL_ERR := ' IT IS LIST PARTITION ' || V_WHERE_SQL;
      END IF;

      V_SQL_CK	 := 'SELECT /*+parallel(B,10)+*/ ds_count,dt_count  FROM (' ||
		    'select count(1) ds_count from ' || P_DS_OWNER || '."' ||
		    P_TABLE_NAME || '"@dbverify ' || V_WHERE_SQL ||
		    ') A ,(select count(1) dt_count from ' || P_DT_OWNER || '."' ||
		    P_TABLE_NAME || '" ' || V_WHERE_SQL || ') B ';
      V_FULL_SQL := V_FULL_SQL || CHR(10) || V_SQL_CK;
      --  dbms_output.put_line(v_full_sql);
      EXECUTE IMMEDIATE V_SQL_CK
	INTO V_DS_COUNT, V_DT_COUNT;

      UPDATE DSG_CHECK_TABLE
	 SET DS_COUNT_DIFF = SYSDATE,
	     DT_COUNT_DIFF = SYSDATE,
	     MINUS_DIFF    = SYSDATE,
	     DS_COUNT	   = V_DS_COUNT,
	     DT_COUNT	   = V_DT_COUNT,
	     STATUS	   = 2,
	     CHECK_SQL	   = V_FULL_SQL
       WHERE DT_OWNER = P_DT_OWNER
	 AND DS_NAME = P_TABLE_NAME
	 AND TABLE_PARTITION = P_PART_NAME;

      COMMIT;
      -- dbms_output.put_line(p_check_type || ' ' || v_ds_count || ' ' || v_dt_count);
      IF P_CHECK_TYPE = 0 THEN
	IF V_DT_COUNT = V_DS_COUNT THEN
	  /* for combination the minus sql*/
	  V_SQL_ST     := 'SELECT COUNT(1) FROM (SELECT ';
	  V_SQL_LENGTH := LENGTH(V_SQL_ST);
	  -- Test statements here
	  FOR C IN C_CHECK_TAB_COL_SQL LOOP
	    IF C.COLUMN_NAME IS NOT NULL THEN
	      IF C.DATA_TYPE LIKE '%CHAR%' THEN
		V_SQL_TMP    := V_SQL_TMP || '"' || C.COLUMN_NAME || '",';
		V_SQL_LENGTH := V_SQL_LENGTH + LENGTH(C.COLUMN_NAME) + 6;
	      ELSE
		V_SQL_TMP    := V_SQL_TMP || '"' || C.COLUMN_NAME || '",';
		V_SQL_LENGTH := V_SQL_LENGTH + LENGTH(C.COLUMN_NAME);
	      END IF;
	    END IF;
	  END LOOP;
	  --dbms_output.put_line(v_sql_length);
	  V_SQL_DS     := SUBSTR(V_SQL_TMP, 0, LENGTH(V_SQL_TMP) - 1) ||
			  ' FROM "' || P_DS_OWNER || '"."' || P_TABLE_NAME ||
			  '"@dbverify ' || V_WHERE_SQL;
	  V_SQL_DT     := SUBSTR(V_SQL_TMP, 0, LENGTH(V_SQL_TMP) - 1) ||
			  ' FROM "' || P_DT_OWNER || '"."' || P_TABLE_NAME || '"' ||
			  V_WHERE_SQL;
	  V_SQL_LENGTH := V_SQL_LENGTH + LENGTH(V_SQL_DS) +
			  LENGTH(V_SQL_DT) + 15;
	  V_ALL_SQL    := V_SQL_ST || V_SQL_DS || ' MINUS SELECT ' ||
			  V_SQL_DT || ')';
	  /*
	  delete from dsg_test;
	  insert into dsg_test values (v_all_sql);
	  commit;
	  */
	  V_FULL_SQL := V_FULL_SQL || CHR(10) || V_ALL_SQL;

	  EXECUTE IMMEDIATE DBMS_LOB.SUBSTR(V_ALL_SQL)
	    INTO V_CHECK_RESULT;

	  --dbms_output.put_line(dbms_lob.substr(v_all_sql));
	  IF V_CHECK_RESULT > 0 THEN
	    UPDATE DSG_CHECK_TABLE
	       SET MINUS_DIFF  = SYSDATE,
		   MINUS_COUNT = V_CHECK_RESULT,
		   STATUS      = 3,
		   CHECK_SQL   = V_FULL_SQL
	     WHERE DS_OWNER = P_DS_OWNER
	       AND DS_NAME = P_TABLE_NAME
	       AND TABLE_PARTITION = P_PART_NAME;
	    COMMIT;
	  ELSE
	    UPDATE DSG_CHECK_TABLE
	       SET MINUS_DIFF  = SYSDATE,
		   MINUS_COUNT = V_CHECK_RESULT,
		   STATUS      = 1,
		   CHECK_SQL   = V_FULL_SQL
	     WHERE DS_OWNER = P_DS_OWNER
	       AND DS_NAME = P_TABLE_NAME
	       AND TABLE_PARTITION = P_PART_NAME;
	    COMMIT;
	  END IF;
	  --  INSERT INTO DSG_TEXT (TEXT) VALUES (V_SQL);
	  --  COMMIT;
	ELSE
	  UPDATE DSG_CHECK_TABLE
	     SET MINUS_DIFF  = SYSDATE,
		 MINUS_COUNT = V_CHECK_RESULT,
		 STATUS      = 3,
		 CHECK_SQL   = V_FULL_SQL
	   WHERE DS_OWNER = P_DS_OWNER
	     AND DS_NAME = P_TABLE_NAME
	     AND TABLE_PARTITION = P_PART_NAME;
	  COMMIT;
	END IF;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
	V_SQL_ERR := V_SQL_ERR || CHR(10) || SQLERRM;
	UPDATE DSG_CHECK_TABLE
	   SET MINUS_DIFF  = SYSDATE,
	       MINUS_COUNT = V_CHECK_RESULT,
	       STATUS	   = 3,
	       CHECK_SQL   = V_FULL_SQL
	 WHERE DS_OWNER = P_DS_OWNER
	   AND DS_NAME = P_TABLE_NAME
	   AND TABLE_PARTITION = P_PART_NAME;
	COMMIT;
    END;
    --dbms_output.put_line(v_full_sql);
    --dbms_output.put_line('minus length is : ' || v_sql_length);
    IF V_SQL_ERR IS NOT NULL THEN
      UPDATE DSG_CHECK_TABLE
	 SET ERR_MSG = V_SQL_ERR
       WHERE DS_OWNER = P_DS_OWNER
	 AND DS_NAME = P_TABLE_NAME
	 AND TABLE_PARTITION = P_PART_NAME;
      COMMIT;
      --dbms_output.put_line(v_sql_err);
    END IF;

    GOTO OVER;

    <<ERR>>
    DBMS_OUTPUT.PUT_LINE(P_DS_OWNER || '.' || P_TABLE_NAME ||
			 'PARTITION IS ERR');
    <<OVER>>
    NULL;
  END CHECK_TAB_PARTITION;

  /*for check the index's type count*/
  /*
   PROCEDURE check_index IS
  v_ind_count NUMBER(10) := 0;
  v_ind_part_count NUMBER(10) := 0;
  v_ck_ind NUMBER(5);
  v_ck_ind_part NUMBER(5);

  --  v_obj_type VARCHAR2 (20);

  CURSOR c_ind IS
  SELECT owner, table_name
   FROM all_tables
   WHERE (owner, table_name) IN
   (SELECT dt_owner, ds_name
   FROM dsg_check_table
   WHERE check_type LIKE 'TABLE%');
   BEGIN
  FOR c IN c_ind LOOP
  SELECT COUNT(1)
   INTO v_ck_ind
   FROM all_objects
   WHERE owner = c.owner
  AND object_name = c.table_name
  and object_type like 'INDEX';
  SELECT COUNT(1)
   INTO v_ck_ind_part
   FROM all_objects
   WHERE owner = c.owner
  AND object_name = c.table_name
  and object_type like 'INDEX PARTITION';
  v_ind_count := v_ind_count + v_ck_ind;
  v_ind_part_count := v_ind_part_count + v_ck_ind_part;
  --  dbms_output.put_line('select count(1) from all_objects where owner = '''||c.owner||''' and object_name = '''||c.table_name||'''and object_type like''INDEX PARTITION'';' );
  END LOOP;
  dbms_output.put_line('INDEX PARTITION ->' || v_ind_part_count ||
    chr(10) || 'INDEX ->' || v_ind_count);
  UPDATE dsg_check_table dct
   SET dct.dt_count = v_ind_count,
    dct.status	= decode(v_ind_count - ds_count, 0, 1, 2),
    dct.start_diff = SYSDATE,
    dct.minus_diff = SYSDATE,
    dct.ds_count_diff = SYSDATE,
    dct.dt_count_diff = SYSDATE,
    dct.seq   = userenv('SESSIONID')
   WHERE dct.check_type like 'INDEX';
  UPDATE dsg_check_table dct
   SET dct.dt_count = v_ind_part_count,
    dct.status	= decode(v_ind_part_count - ds_count, 0, 1, 2),
    dct.start_diff = SYSDATE,
    dct.minus_diff = SYSDATE,
    dct.ds_count_diff = SYSDATE,
    dct.dt_count_diff = SYSDATE,
    dct.seq   = userenv('SESSIONID')
   WHERE dct.check_type like 'INDEX PARTITION';
  COMMIT;
   END check_index;
   */
  PROCEDURE CHECK_OBJECTS IS
    V_SQL_CODE CLOB;
    V_SQL_ERR  VARCHAR2(500);
    V_DS_COUNT NUMBER(8) := 0;
    V_DT_COUNT NUMBER(8) := 0;
    V_CK_OBJ   NUMBER(8) := 0;
    V_CK_ERR   NUMBER(4) := 0;
    /*for get all objects which is need check*/
    CURSOR C_OBJ_DS(C_DS_OWNER	  VARCHAR2,
		    C_DT_OWNER	  VARCHAR2,
		    C_OBJECT_TYPE VARCHAR2) IS
      SELECT OBJECT_NAME, OBJECT_TYPE
	FROM DBA_OBJECTS@DBVERIFY
       WHERE OBJECT_TYPE = C_OBJECT_TYPE
	 AND OWNER LIKE C_DS_OWNER
	 AND OBJECT_NAME NOT LIKE 'SYS%'
      MINUS
      SELECT OBJECT_NAME, OBJECT_TYPE
	FROM DBA_OBJECTS
       WHERE OBJECT_TYPE = C_OBJECT_TYPE
	 AND OWNER LIKE C_DT_OWNER;
    CURSOR C_OBJ_DT(C_DS_OWNER	  VARCHAR2,
		    C_DT_OWNER	  VARCHAR2,
		    C_OBJECT_TYPE VARCHAR2) IS
      SELECT OBJECT_NAME, OBJECT_TYPE
	FROM DBA_OBJECTS
       WHERE OBJECT_TYPE = C_OBJECT_TYPE
	 AND OWNER LIKE C_DT_OWNER
	 AND OBJECT_NAME NOT LIKE 'SYS%'
      MINUS
      SELECT OBJECT_NAME, OBJECT_TYPE
	FROM DBA_OBJECTS@DBVERIFY
       WHERE OBJECT_TYPE = C_OBJECT_TYPE
	 AND OWNER LIKE C_DS_OWNER;

    CURSOR COBJECTS IS
      SELECT DS_OWNER, DT_OWNER, DT_NAME, DS_NAME, CHECK_TYPE
	FROM DSG_CHECK_TABLE
       WHERE CHECK_TYPE IN ('FUNCTION',
			    'INDEXTYPE',
			    'JAVA CLASS',
			    'JAVA SOURCE',
			    'MATERIALIZED VIEW',
			    'OPERATOR',
			    'PACKAGE',
			    'PACKAGE BODY',
			    'PROCEDURE',
			    'TRIGGER',
			    'TYPE',
			    'TYPE BODY',
			    'VIEW',
			    'SYNONYM',
			    'INDEX PARTITION',
			    'INDEX',
			    'DATABASE LINK');
  BEGIN
    -----------------------for owner's sequence
    UPDATE DSG_CHECK_TABLE DCT
       SET (DCT.DS_COUNT,
	    DCT.STATUS,
	    DCT.START_DIFF,
	    DCT.DS_COUNT_DIFF,
	    DCT.MINUS_DIFF) =
	   (SELECT DSS.LAST_NUMBER, 2, SYSDATE, SYSDATE, SYSDATE
	      FROM ALL_SEQUENCES@DBVERIFY DSS
	     WHERE DCT.DS_OWNER = DSS.SEQUENCE_OWNER
	       AND DSS.SEQUENCE_NAME = DCT.DS_NAME),
	   DCT.SEQ = USERENV('SESSIONID')
     WHERE DCT.CHECK_TYPE = 'SEQUENCE';
    COMMIT;

    UPDATE DSG_CHECK_TABLE DCT
       SET (DCT.DT_COUNT, DCT.STATUS, DCT.DT_COUNT_DIFF) =
	   (SELECT DTS.LAST_NUMBER, 1, SYSDATE
	      FROM ALL_SEQUENCES DTS
	     WHERE DCT.DT_OWNER = DTS.SEQUENCE_OWNER
	       AND DCT.DT_NAME = DTS.SEQUENCE_NAME)
     WHERE DCT.CHECK_TYPE = 'SEQUENCE';
    COMMIT;
    --------------------for other object type
    FOR AREC IN COBJECTS LOOP
      V_SQL_CODE := NULL;
      BEGIN
	FOR C_OBJ IN C_OBJ_DS(AREC.DS_OWNER, AREC.DT_OWNER, AREC.CHECK_TYPE) LOOP
	  V_CK_OBJ := V_CK_OBJ + 1;
	  IF C_OBJ.OBJECT_TYPE = 'FUNCTION' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''FUNCTION'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'PROCEDURE' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''PROCEDURE'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'PACKAGE' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''PACKAGE_SPEC'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'PACKAGE BODY' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''PACKAGE_BODY'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'TRIGGER' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''TRIGGER'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'VIEW' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''VIEW'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'SYNONYM' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''SYNONYM'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'SEQUENCE' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''SEQUENCE'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE LIKE 'INDEX%' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''INDEX'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'MATERIALIZED VIEW' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''MATERIALIZED_VIEW'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'DATABASE LINK' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''DB_LINK'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'TYPE' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''TYPE_SPEC'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'TYPE BODY' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''TYPE_BODY'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSE
	    V_SQL_CODE := V_SQL_CODE || 'SELECT dbms_metadata.get_ddl(''' ||
			  C_OBJ.OBJECT_TYPE || ''',''' || C_OBJ.OBJECT_NAME ||
			  ''',''' || AREC.DS_OWNER || ''') FROM DUAL;' ||
			  CHR(10);
	  END IF;
	END LOOP;
	FOR C_OBJ IN C_OBJ_DT(AREC.DS_OWNER, AREC.DT_OWNER, AREC.CHECK_TYPE) LOOP
	  V_CK_OBJ := V_CK_OBJ + 1;
	  IF C_OBJ.OBJECT_TYPE = 'FUNCTION' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''FUNCTION'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DT_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'PROCEDURE' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''PROCEDURE'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DT_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'PACKAGE' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''PACKAGE_SPEC'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DT_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'PACKAGE BODY' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''PACKAGE_BODY'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DT_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'TRIGGER' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''TRIGGER'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DT_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'VIEW' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''VIEW'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DT_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'SYNONYM' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''SYNONYM'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DT_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'SEQUENCE' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''SEQUENCE'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DT_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE LIKE 'INDEX%' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''INDEX'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DT_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'MATERIALIZED VIEW' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''MATERIALIZED_VIEW'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DT_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'DATABASE LINK' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''DB_LINK'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'TYPE' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''TYPE_SPEC'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSIF C_OBJ.OBJECT_TYPE = 'TYPE BODY' THEN
	    V_SQL_CODE := V_SQL_CODE ||
			  'SELECT dbms_metadata.get_ddl(''TYPE_BODY'',''' ||
			  C_OBJ.OBJECT_NAME || ''',''' || AREC.DS_OWNER ||
			  ''') FROM DUAL;' || CHR(10);
	  ELSE
	    V_SQL_CODE := V_SQL_CODE || 'SELECT dbms_metadata.get_ddl(''' ||
			  C_OBJ.OBJECT_TYPE || ''',''' || C_OBJ.OBJECT_NAME ||
			  ''',''' || AREC.DT_OWNER || ''') FROM DUAL;' ||
			  CHR(10);
	  END IF;
	END LOOP;
	IF V_CK_OBJ > 0 THEN
	  V_CK_ERR := 2;
	ELSE
	  V_CK_ERR := 1;
	END IF;
	SELECT COUNT(1)
	  INTO V_DS_COUNT
	  FROM DBA_OBJECTS@DBVERIFY
	 WHERE OBJECT_TYPE = AREC.CHECK_TYPE
	   AND OWNER = AREC.DS_OWNER;
	SELECT COUNT(1)
	  INTO V_DT_COUNT
	  FROM DBA_OBJECTS
	 WHERE OBJECT_TYPE = AREC.CHECK_TYPE
	   AND OWNER IN AREC.DT_OWNER;
	DBMS_OUTPUT.PUT_LINE('V_DS_COUNT IS :' || V_DS_COUNT);
	DBMS_OUTPUT.PUT_LINE('V_DT_COUNT IS :' || V_DT_COUNT);
	DBMS_OUTPUT.PUT_LINE('V_CK_OBJ IS :' || V_CK_OBJ);
	DBMS_OUTPUT.PUT_LINE('CHECK_TYPE IS :' || AREC.CHECK_TYPE);

	UPDATE DSG_CHECK_TABLE DCT
	   SET DCT.DS_COUNT	 = V_DS_COUNT,
	       DCT.DT_COUNT	 = V_DT_COUNT,
	       DCT.STATUS	 = V_CK_ERR,
	       DCT.SEQ		 = SYS_CONTEXT('USERENV', 'SESSIONID'),
	       DCT.START_DIFF	 = SYSDATE,
	       DCT.MINUS_DIFF	 = SYSDATE,
	       DCT.DS_COUNT_DIFF = SYSDATE,
	       DCT.DT_COUNT_DIFF = SYSDATE,
	       DCT.CHECK_SQL	 = V_SQL_CODE
	 WHERE DCT.DS_OWNER = AREC.DS_OWNER
	   AND DCT.DT_OWNER = AREC.DT_OWNER
	   AND DCT.CHECK_TYPE = AREC.CHECK_TYPE
	   AND DCT.DS_NAME = AREC.DS_NAME;
	COMMIT;
      EXCEPTION
	WHEN OTHERS THEN
	  V_SQL_ERR := SQLCODE;
	  UPDATE DSG_CHECK_TABLE DCT
	     SET DCT.ERR_MSG = V_SQL_ERR
	   WHERE DCT.DS_OWNER = AREC.DS_OWNER
	     AND DCT.DT_OWNER = AREC.DT_OWNER
	     AND DCT.CHECK_TYPE = AREC.CHECK_TYPE
	     AND DCT.DS_NAME = AREC.DS_NAME;
	  COMMIT;
      END;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END CHECK_OBJECTS;

  ------------------------------------------------------
  -----------------FOR CHECK ALL NOT SUPPORSE TABLES
  /*****for get all job*****/
  PROCEDURE GET_ALL_JOB(P_OWNER VARCHAR2) IS
    V_OWNER	VARCHAR2(15) := TRIM(P_OWNER);
    V_JOB_COUNT NUMBER := 0;
    V_JOB_CON	VARCHAR2(4000);
    WSPACE	VARCHAR2(5) := RPAD(' ', 5, ' ');

    CURSOR C_JOB IS
      SELECT JOB, LOG_USER, PRIV_USER, SCHEMA_USER, WHAT
	FROM DBA_JOBS@DBVERIFY
       WHERE SCHEMA_USER = V_OWNER;
  BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 75, '='));

    FOR C IN C_JOB LOOP
      SELECT 'begin ' || CHR(10) ||
	     RPAD('sys.dbms_ijob.remove(job=> ' || JOB || ');', 50, ' ') ||
	     CHR(10) ||
	     RPAD('sys.dbms_ijob.submit(job => ' || JOB || ',', 50, ' ') ||
	     CHR(10) || WSPACE || 'LUSER=>''' || LOG_USER || ''',' ||
	     CHR(10) || WSPACE || 'PUSER=>''' || PRIV_USER || ''',' ||
	     CHR(10) || WSPACE || 'CUSER=>''' || SCHEMA_USER || ''',' ||
	     CHR(10) || WSPACE || 'next_date => to_date(''' ||
	     TO_CHAR(NEXT_DATE, 'yyyy-mm-dd hh24:mi:ss') ||
	     ''',''yyyy-mm-dd hh24:mi:ss''),' || CHR(10) || WSPACE ||
	     'interval =>''' || REPLACE(INTERVAL, '''', '''''') || ''',' ||
	     CHR(10) || WSPACE || 'BROKEN => ' ||
	     DECODE(BROKEN, 'Y', 'TRUE', 'N', 'FALSE', 'FALSE') || ',' ||
	     CHR(10) || WSPACE || 'what => ''' || WHAT || ''',' || CHR(10) ||
	     WSPACE || 'NLSENV=>''' || REPLACE(NLS_ENV, '''', '''''') ||
	     ''',' || CHR(10) || WSPACE || 'ENV => ''' || MISC_ENV || '''' ||
	     CHR(10) || ');' || CHR(10) || WSPACE || 'commit;' || CHR(10) ||
	     'end;' || CHR(10) || '/' || CHR(10)
	INTO V_JOB_CON
	FROM DBA_JOBS
       WHERE JOB = C.JOB;

      DBMS_OUTPUT.PUT_LINE('The job :' || TO_CHAR(C.JOB) || ' log_user = ' ||
			   C.LOG_USER || ' priv_user = ' || C.PRIV_USER ||
			   ' schema_user = ' || C.SCHEMA_USER || CHR(10) ||
			   ' what = ' || RPAD('', 10, ' ') || C.WHAT ||
			   CHR(10) || RPAD('-', 75, ' -') || CHR(10) ||
			   V_JOB_CON);
      V_JOB_COUNT := V_JOB_COUNT + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 75, ' -'));
    DBMS_OUTPUT.PUT_LINE('The count of job for ' || V_OWNER || ' is ' ||
			 TO_CHAR(V_JOB_COUNT));
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 75, '='));
  END GET_ALL_JOB;

  /*********************************************************************************************************/
  ----------------for get check sql of table_partitions
  /*********************************************************************************************************/
  FUNCTION GET_SQL_PART_TAB(P_DS_OWNER	 VARCHAR2,
			    P_TABLE_NAME VARCHAR2,
			    P_PART_TAB	 VARCHAR2) RETURN VARCHAR2 IS
    V_CHECK_PART_TAB	 NUMBER;
    V_CHECK_STRUCT_COUNT NUMBER := 0;
    ---judge the columns of tables'partition is one columns
    V_PARTITION_TYPE	 VARCHAR2(15);
    V_COLUMN_STR	 VARCHAR2(100);
    V_WHERE_STR 	 VARCHAR2(4000);
    V_HIGH_VALUE	 VARCHAR2(100);
    V_MIDDLE_VALUE	 VARCHAR2(100);
    V_PARTITION_POSITION NUMBER;
    V_DATA_TYPE 	 VARCHAR2(20);

    /* for get the table's column which is the partition's key */
    CURSOR C_COL_PART_TAB(C_DS_OWNER VARCHAR2, C_TABLE_NAME VARCHAR2) IS
      SELECT OWNER, NAME, OBJECT_TYPE, COLUMN_NAME, COLUMN_POSITION
	FROM ALL_PART_KEY_COLUMNS@DBVERIFY
       WHERE OWNER = C_DS_OWNER
	 AND NAME = C_TABLE_NAME;
  BEGIN
    /*	for get the contition of if the table is partition table*/
    SELECT COUNT(1)
      INTO V_CHECK_PART_TAB
      FROM ALL_TAB_PARTITIONS@DBVERIFY
     WHERE TABLE_OWNER = P_DS_OWNER
       AND TABLE_NAME = P_TABLE_NAME;

    --	dbms_output.put_line(v_check_part_tab);
    /* if the table is partition table ,then deal with the partition*/
    IF V_CHECK_PART_TAB > 0 THEN
      /* for get the type of partition table */
      SELECT PARTITIONING_TYPE
	INTO V_PARTITION_TYPE
	FROM ALL_PART_TABLES@DBVERIFY
       WHERE OWNER = P_DS_OWNER
	 AND TABLE_NAME = P_TABLE_NAME;

      /* for get the partition's high value and partition's position*/
      SELECT HIGH_VALUE, PARTITION_POSITION
	INTO V_HIGH_VALUE, V_PARTITION_POSITION
	FROM ALL_TAB_PARTITIONS@DBVERIFY
       WHERE TABLE_OWNER = P_DS_OWNER
	 AND TABLE_NAME = P_TABLE_NAME
	 AND PARTITION_NAME = P_PART_TAB;

      /* get the partition's key column of the table's cursor*/
      FOR C IN C_COL_PART_TAB(P_DS_OWNER, P_TABLE_NAME) LOOP
	V_CHECK_STRUCT_COUNT := V_CHECK_STRUCT_COUNT + 1;
	V_COLUMN_STR	     := C.COLUMN_NAME;
      END LOOP;

      /* for get the data's type of the column which is the partition of table's key*/
      SELECT DATA_TYPE
	INTO V_DATA_TYPE
	FROM ALL_TAB_COLUMNS@DBVERIFY
       WHERE OWNER = P_DS_OWNER
	 AND TABLE_NAME = P_TABLE_NAME
	 AND COLUMN_NAME = V_COLUMN_STR;

      /*for check the partition table's type*/
      -- dbms_output.put_line(v_partition_type);
      IF V_PARTITION_TYPE = 'RANGE' THEN
	--dbms_output.put_line('RANGE');
	/*judge the last partition's position,and high_value*/
	IF V_PARTITION_POSITION > 1 THEN
	  SELECT HIGH_VALUE
	    INTO V_MIDDLE_VALUE
	    FROM ALL_TAB_PARTITIONS@DBVERIFY
	   WHERE TABLE_OWNER = P_DS_OWNER
	     AND TABLE_NAME = P_TABLE_NAME
	     AND PARTITION_POSITION = V_PARTITION_POSITION - 1;
	END IF;

	IF V_CHECK_STRUCT_COUNT = 1 THEN
	  /*
	  v_where_str := ' where  ' || v_column_str || ' > ' ||
	    v_middle_value || ' and ' || v_column_str || ' < ' ||
	    v_high_value;
	   */
	  /*judge the high value is maxvalue*/
	  --   dbms_output.put_line(v_where_str);
	  IF V_HIGH_VALUE = 'MAXVALUE' THEN
	    V_WHERE_STR := ' where  ' || V_COLUMN_STR || ' > ' ||
			   V_MIDDLE_VALUE;
	    -- dbms_output.put_line(v_where_str);
	  ELSE
	    /*weather the partition is the first partition */
	    IF V_PARTITION_POSITION > 1 THEN
	      -- v_high_value := v_high_value;
	      -- v_middle_value := v_middle_value;
	      V_WHERE_STR := ' where  "' || V_COLUMN_STR || '" < ' ||
			     V_HIGH_VALUE || ' and "' || V_COLUMN_STR ||
			     '" >= ' || V_MIDDLE_VALUE;
	      -- dbms_output.put_line(v_where_str);
	    ELSE
	      V_HIGH_VALUE := V_HIGH_VALUE;
	      V_WHERE_STR  := ' where  "' || V_COLUMN_STR || '" < ' ||
			      V_HIGH_VALUE;
	    END IF;
	  END IF;
	END IF;
      ELSIF V_PARTITION_TYPE = 'LIST' THEN
	--dbms_output.put_line('LIST');
	IF V_CHECK_STRUCT_COUNT = 1 THEN
	  V_WHERE_STR := ' where  "' || V_COLUMN_STR || '" in ( ' ||
			 V_HIGH_VALUE || ' )';
	END IF;
	--dbms_output.put_line(v_partition_type);
      ELSE
	--v_partition_type := 'UNKNOWN';
	V_WHERE_STR := '';
	--dbms_output.put_line(v_partition_type);
      END IF;
      -- dbms_output.put_line('it is a partition table');
    END IF;

    RETURN V_WHERE_STR;
  END GET_SQL_PART_TAB;

  /*get all lob table,need noice them*/
  PROCEDURE SHOW_ALL_LOB_TAB IS
    V_OWNER VARCHAR2(15) := NULL;
    V_COUNT NUMBER := 0;

    CURSOR C_LOB IS
      SELECT OWNER, TABLE_NAME, COLUMN_NAME, DATA_TYPE
	FROM ALL_TAB_COLUMNS@DBVERIFY ATC
       WHERE OWNER IN (SELECT DISTINCT DS_OWNER FROM DSG_CHECK_TABLE)
	 AND DATA_TYPE IN
	     ('LONG', 'CLOB', 'BLOB', 'NCLOB', 'NBLOB', 'BFILE');
  BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 75, '='));

    FOR C IN C_LOB LOOP
      V_COUNT := V_COUNT + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD(C.OWNER || '.' || C.TABLE_NAME, 40, ' ') ||
			   RPAD('---->', 10, ' ') || C.COLUMN_NAME || '(' ||
			   C.DATA_TYPE || ')');
      V_OWNER := C.OWNER;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 75, ' -'));

    IF V_COUNT > 0 THEN
      DBMS_OUTPUT.PUT_LINE('There have ' || V_COUNT ||
			   ' columns contains lob ');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Not found the lob table in the ' || V_OWNER || '!');
    END IF;

    DBMS_OUTPUT.PUT_LINE(RPAD('=', 75, '='));
  END SHOW_ALL_LOB_TAB;

  /* show all objects */
  PROCEDURE SHOW_OBJECTS IS
    /* for get all the objects's count of the owner */
    CURSOR C_OBJ_TYPE_COUNT IS
      SELECT OWNER, OBJECT_TYPE, COUNT(1) AS COUNT_TYPE
	FROM ALL_OBJECTS AO, DSG_CHECK_TABLE DCT
       WHERE OWNER = DCT.DS_OWNER
       GROUP BY OWNER, OBJECT_TYPE;
  BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 55, '=') || CHR(10) ||
			 RPAD('DS_OWNER', 15, ' ') || '=' ||
			 RPAD('OBJECT_TYPE', 20, '=') || '=' ||
			 LPAD('type_count', 15, ' '));

    FOR C IN C_OBJ_TYPE_COUNT LOOP
      DBMS_OUTPUT.PUT_LINE(RPAD(C.OWNER, 15, ' ') || '(' ||
			   RPAD(C.OBJECT_TYPE, 20, ' ') || ')' ||
			   LPAD(C.COUNT_TYPE, 15, ' '));
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(RPAD('=', 55, '='));
  END SHOW_OBJECTS;

  PROCEDURE SHOW_SPACE(P_SEGNAME   IN VARCHAR2,
		       P_OWNER	   IN VARCHAR2,
		       P_TYPE	   IN VARCHAR2 DEFAULT 'TABLE',
		       P_PARTITION IN VARCHAR2 DEFAULT NULL) AS
    --
    L_FREE_BLOCKS	 NUMBER;
    L_TOTAL_BLOCKS	 NUMBER;
    L_TOTAL_BYTES	 NUMBER;
    L_UNUSED_BYTES	 NUMBER;
    L_UNUSED_BLOCKS	 NUMBER;
    L_LASTUSEDEXTFILEID  NUMBER;
    L_LASTUSEDEXTBLOCKID NUMBER;
    L_LAST_USED_BLOCK	 NUMBER;
    --
    L_SEGNAME	VARCHAR2(30);
    L_OWNER	VARCHAR2(30);
    L_TYPE	VARCHAR2(20);
    L_PARTITION VARCHAR2(30);

    --
    PROCEDURE P(P_LABEL IN VARCHAR2, P_NUM IN NUMBER) IS
    BEGIN
      DBMS_OUTPUT.PUT_LINE(RPAD(P_LABEL, 40, '.') || P_NUM);
    END;

    --
    PROCEDURE P(P_LABEL IN VARCHAR2, P_NUM IN VARCHAR2) IS
    BEGIN
      DBMS_OUTPUT.PUT_LINE(RPAD(P_LABEL, 40, '.') || P_NUM);
    END;
  BEGIN
    L_SEGNAME	:= UPPER(P_SEGNAME);
    L_OWNER	:= UPPER(P_OWNER);
    L_TYPE	:= UPPER(P_TYPE);
    L_PARTITION := UPPER(P_PARTITION);
    DBMS_SPACE.FREE_BLOCKS(SEGMENT_OWNER     => L_OWNER,
			   SEGMENT_NAME      => L_SEGNAME,
			   SEGMENT_TYPE      => L_TYPE,
			   PARTITION_NAME    => L_PARTITION,
			   FREELIST_GROUP_ID => 0,
			   FREE_BLKS	     => L_FREE_BLOCKS);
    --
    DBMS_SPACE.UNUSED_SPACE(SEGMENT_OWNER	      => L_OWNER,
			    SEGMENT_NAME	      => L_SEGNAME,
			    SEGMENT_TYPE	      => L_TYPE,
			    PARTITION_NAME	      => L_PARTITION,
			    TOTAL_BLOCKS	      => L_TOTAL_BLOCKS,
			    TOTAL_BYTES 	      => L_TOTAL_BYTES,
			    UNUSED_BLOCKS	      => L_UNUSED_BLOCKS,
			    UNUSED_BYTES	      => L_UNUSED_BYTES,
			    LAST_USED_BLOCK	      => L_LAST_USED_BLOCK,
			    LAST_USED_EXTENT_FILE_ID  => L_LASTUSEDEXTFILEID,
			    LAST_USED_EXTENT_BLOCK_ID => L_LASTUSEDEXTBLOCKID);
    --
    P('Free Blocks', L_FREE_BLOCKS);
    P('Total Blocks', L_TOTAL_BLOCKS);
    P('Total Bytes', L_TOTAL_BYTES);
    P('Unused Blocks', L_UNUSED_BLOCKS);
    P('Unused Bytes', L_UNUSED_BYTES);
    P('Last Used Ext FileId', L_LASTUSEDEXTFILEID);
    P('Last Used Ext BlockId', L_LASTUSEDEXTBLOCKID);
    P('Last Used Block', L_LAST_USED_BLOCK);
    P('********** Summary Percentages *********', '');
    P('% Bytes Unused',
      TRIM(TO_CHAR((L_UNUSED_BYTES / L_TOTAL_BYTES) * 100, '990.00')) || '%');
    P('% Blocks Unused',
      TRIM(TO_CHAR((L_UNUSED_BLOCKS / L_TOTAL_BLOCKS) * 100, '990.00')) || '%');
    P('% Blocks Free',
      TRIM(TO_CHAR((L_FREE_BLOCKS / L_TOTAL_BLOCKS) * 100, '990.00')) || '%');
    P('% Blocks Used',
      TRIM(TO_CHAR((1 -
		   ((L_FREE_BLOCKS + L_UNUSED_BLOCKS) / L_TOTAL_BLOCKS)) * 100,
		   '990.00')) || '%');
  END SHOW_SPACE;
  /*repair all unusable index,and key*/
  PROCEDURE REPAIR_OBJ IS
    V_REP_SQL_STR VARCHAR2(500) := NULL;

    /*for all unusable indexes */
    CURSOR C_REPAIR_IND IS
      SELECT 'alter index "' || OWNER || '"."' || INDEX_NAME ||
	     '" rebuild nologging compute statistics;' CMD
	FROM DBA_INDEXES
       WHERE STATUS = 'UNUSABLE'
	 AND OWNER IN (SELECT DISTINCT DT_OWNER FROM DSG_CHECK_TABLE)
      UNION
      SELECT 'alter index "' || INDEX_OWNER || '"."' || INDEX_NAME ||
	     '" rebuild partition "' || PARTITION_NAME ||
	     '" nologging compute statistics;' CMD
	FROM DBA_IND_PARTITIONS D
       WHERE STATUS = 'UNUSABLE'
	 AND INDEX_OWNER IN (SELECT DISTINCT DT_OWNER FROM DSG_CHECK_TABLE)
      UNION
      SELECT 'alter index "' || INDEX_OWNER || '"."' || INDEX_NAME ||
	     '" rebuild subpartition "' || SUBPARTITION_NAME || ';' CMD
	FROM DBA_IND_SUBPARTITIONS
       WHERE STATUS = 'UNUSABLE'
	 AND INDEX_OWNER IN (SELECT DISTINCT DT_OWNER FROM DSG_CHECK_TABLE)
       ORDER BY 1;

    /*for all foreign key*/
    CURSOR C_REF_KEY IS
      SELECT AC.OWNER, AC.TABLE_NAME, AC.CONSTRAINT_NAME
	FROM ALL_CONSTRAINTS AC
       WHERE OWNER IN (SELECT DISTINCT DT_OWNER FROM DSG_CHECK_TABLE)
	 AND AC.CONSTRAINT_TYPE = 'R';
  BEGIN
    FOR C_R_I IN C_REPAIR_IND LOOP
      V_REP_SQL_STR := C_R_I.CMD;

      EXECUTE IMMEDIATE V_REP_SQL_STR;
    END LOOP;

    FOR C_R_K IN C_REF_KEY LOOP
      V_REP_SQL_STR := 'alter table ' || C_R_K.OWNER || '.' ||
		       C_R_K.TABLE_NAME || ' enable constraints ' ||
		       C_R_K.CONSTRAINT_NAME;

      EXECUTE IMMEDIATE V_REP_SQL_STR;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END REPAIR_OBJ;

  /*recomplie all objects*/
  PROCEDURE RECOMPILE_OBJ IS
    CURSOR C_RECOM_OBJ IS
      SELECT 'alter ' || DECODE(OBJECT_TYPE,
				'PACKAGE BODY',
				'PACKAGE',
				'TYPE BODY',
				'TYPE',
				OBJECT_TYPE) || ' "' || OWNER || '"."' ||
	     OBJECT_NAME || '" compile' ||
	     DECODE(OBJECT_TYPE,
		    'PACKAGE BODY',
		    ' DEBUG;',
		    'TYPE BODY',
		    ' DEBUG;',
		    ';') CMD
	FROM ALL_OBJECTS
       WHERE STATUS = 'INVALID';
  BEGIN
    FOR C IN C_RECOM_OBJ LOOP
      EXECUTE IMMEDIATE C.CMD;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      PRINT(SQLERRM);
  END RECOMPILE_OBJ;

  /*show all check data's size */
  PROCEDURE SHOW_CHECK_TAB_SIZE IS
    V_TAB_SIZE	    NUMBER := 0;
    V_TAB_BLOCK     NUMBER := 0;
    V_IND_SIZE	    NUMBER := 0;
    V_IND_BLOCK     NUMBER := 0;
    V_TAB_LOB_SIZE  NUMBER := 0;
    V_TAB_LOB_BLOCK NUMBER := 0;
    V_LOB_IND_SIZE  NUMBER := 0;
    V_LOB_IND_BLOCK NUMBER := 0;
  BEGIN
    SELECT SUM(SEG_BYTE) + V_TAB_SIZE, SUM(SEG_BYTE) + V_TAB_BLOCK
      INTO V_TAB_SIZE, V_TAB_BLOCK
      FROM DSG_CHECK_TABLE
     WHERE CHECK_TYPE LIKE 'TABLE%';
    SELECT SUM(BYTES) + V_IND_SIZE, SUM(BLOCKS) + V_IND_BLOCK
      INTO V_IND_SIZE, V_IND_BLOCK
      FROM DBA_SEGMENTS@DBVERIFY
     WHERE (OWNER, SEGMENT_NAME) IN
	   (SELECT DISTINCT DI.OWNER, DI.INDEX_NAME
	      FROM DSG_CHECK_TABLE DCT, DBA_INDEXES@DBVERIFY DI
	     WHERE DCT.DS_OWNER = DI.OWNER
	       AND DCT.DS_NAME = DI.TABLE_NAME
	       AND DI.UNIQUENESS IN ('UNIQUE', 'NONUNIQUE'));
    SELECT SUM(BYTES) + V_TAB_LOB_SIZE, SUM(BLOCKS) + V_TAB_LOB_BLOCK
      INTO V_TAB_LOB_SIZE, V_TAB_LOB_BLOCK
      FROM DBA_SEGMENTS@DBVERIFY
     WHERE (OWNER, SEGMENT_NAME) IN
	   (SELECT DISTINCT DL.OWNER, DL.SEGMENT_NAME
	      FROM DSG_CHECK_TABLE DCT, DBA_LOBS@DBVERIFY DL
	     WHERE DCT.DS_OWNER = DL.OWNER
	       AND DCT.DS_NAME = DL.TABLE_NAME);

    SELECT SUM(BYTES) + V_LOB_IND_SIZE, SUM(BLOCKS) + V_LOB_IND_BLOCK
      INTO V_LOB_IND_SIZE, V_LOB_IND_BLOCK
      FROM DBA_SEGMENTS@DBVERIFY
     WHERE (OWNER, SEGMENT_NAME) IN
	   (SELECT DISTINCT DL.OWNER, DL.INDEX_NAME
	      FROM DSG_CHECK_TABLE DCT, DBA_LOBS@DBVERIFY DL
	     WHERE DCT.DS_OWNER = DL.OWNER
	       AND DCT.DS_NAME = DL.TABLE_NAME);
    PRINT('all check data''s size(MB) is :');
    PRINT(RPAD('table''s data size is :', 30, ' ') ||
	  RPAD(TRUNC(V_TAB_SIZE / 1024 / 1024, 3), 15, ' ') ||
	  RPAD('blocks is :', 15, ' ') ||
	  RPAD(TRUNC(V_TAB_BLOCK / 1024 / 8, 5), 15, ' '));
    PRINT(RPAD('indexes''s data size is :', 30, ' ') ||
	  RPAD(TRUNC(V_IND_SIZE / 1024 / 1024, 3), 15, ' ') ||
	  RPAD('blocks is :', 15, ' ') ||
	  RPAD(TRUNC(V_IND_BLOCK, 5), 15, ' '));
    PRINT(RPAD('lobs''s data size is :', 30, ' ') ||
	  RPAD(TRUNC(V_TAB_LOB_SIZE / 1024 / 1024, 3), 15, ' ') ||
	  RPAD('blocks is :', 15, ' ') ||
	  RPAD(TRUNC(V_TAB_LOB_BLOCK, 5), 15, ' '));
    PRINT(RPAD('lobs indexes''s data size is :', 30, ' ') ||
	  RPAD(TRUNC(V_LOB_IND_SIZE / 1024 / 1024, 3), 15, ' ') ||
	  RPAD('blocks is :', 15, ' ') ||
	  RPAD(TRUNC(V_LOB_IND_BLOCK, 5), 15, ' '));
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END SHOW_CHECK_TAB_SIZE;

  /*find all chained_rows table */
  PROCEDURE SYNC_SEQ(P_DS_OWNER VARCHAR2, P_DT_OWNER VARCHAR2) IS
    V_DS_OWNER VARCHAR2(30) := P_DS_OWNER;
    V_DT_OWNER VARCHAR2(30) := P_DT_OWNER;

    CURSOR C_SEQ IS
      SELECT *
	FROM DBA_SEQUENCES@DBVERIFY
       WHERE SEQUENCE_OWNER = V_DS_OWNER;

    V_DS_SEQ_VAR   DBA_SEQUENCES%ROWTYPE;
    V_DT_SEQ_VAR   DBA_SEQUENCES%ROWTYPE;
    V_SEQ_SQL_CRT  VARCHAR2(4000);
    V_SEQ_SQL_DROP VARCHAR2(4000);
    V_SEQ_CK	   NUMBER;
  BEGIN
    FOR C IN C_SEQ LOOP
      SELECT *
	INTO V_DS_SEQ_VAR
	FROM DBA_SEQUENCES@DBVERIFY
       WHERE SEQUENCE_OWNER = C.SEQUENCE_OWNER
	 AND SEQUENCE_NAME = C.SEQUENCE_NAME;

      SELECT COUNT(1)
	INTO V_SEQ_CK
	FROM DBA_SEQUENCES
       WHERE SEQUENCE_OWNER = V_DT_OWNER
	 AND SEQUENCE_NAME = C.SEQUENCE_NAME;

      IF V_SEQ_CK > 0 THEN
	SELECT *
	  INTO V_DT_SEQ_VAR
	  FROM DBA_SEQUENCES
	 WHERE SEQUENCE_OWNER = V_DT_OWNER
	   AND SEQUENCE_NAME = C.SEQUENCE_NAME;
	IF V_DS_SEQ_VAR.INCREMENT_BY <> V_DT_SEQ_VAR.INCREMENT_BY OR
	   V_DS_SEQ_VAR.CACHE_SIZE <> V_DT_SEQ_VAR.CACHE_SIZE OR
	   V_DS_SEQ_VAR.LAST_NUMBER <> V_DT_SEQ_VAR.LAST_NUMBER OR
	   V_DS_SEQ_VAR.MIN_VALUE <> V_DT_SEQ_VAR.MIN_VALUE OR
	   V_DS_SEQ_VAR.MAX_VALUE <> V_DT_SEQ_VAR.MAX_VALUE OR
	   V_DS_SEQ_VAR.ORDER_FLAG <> V_DT_SEQ_VAR.ORDER_FLAG OR
	   V_DS_SEQ_VAR.CYCLE_FLAG <> V_DT_SEQ_VAR.CYCLE_FLAG THEN
	  V_SEQ_SQL_DROP := 'drop sequence ' || V_DT_OWNER || '.' ||
			    V_DS_SEQ_VAR.SEQUENCE_NAME;

	  SELECT 'create sequence ' || V_DT_OWNER || '.' ||
		 V_DS_SEQ_VAR.SEQUENCE_NAME || ' minvalue ' ||
		 V_DS_SEQ_VAR.MIN_VALUE || ' maxvalue ' ||
		 V_DS_SEQ_VAR.MAX_VALUE || ' increment by ' ||
		 V_DS_SEQ_VAR.INCREMENT_BY || ' start with ' ||
		 V_DS_SEQ_VAR.LAST_NUMBER ||
		 DECODE(V_DS_SEQ_VAR.CACHE_SIZE,
			0,
			' NOCACHE ',
			' cache ' || V_DS_SEQ_VAR.CACHE_SIZE) || ' ' ||
		 DECODE(V_DS_SEQ_VAR.ORDER_FLAG, 'N', 'NOORDER', 'ORDER') || ' ' ||
		 DECODE(V_DS_SEQ_VAR.CYCLE_FLAG, 'N', 'NOCYCLE', 'CYCLE')
	    INTO V_SEQ_SQL_CRT
	    FROM DUAL;

	  EXECUTE IMMEDIATE V_SEQ_SQL_DROP;

	  EXECUTE IMMEDIATE V_SEQ_SQL_CRT;
	END IF;
      ELSE
	SELECT 'create sequence ' || V_DT_OWNER || '.' ||
	       V_DS_SEQ_VAR.SEQUENCE_NAME || ' minvalue ' ||
	       V_DS_SEQ_VAR.MIN_VALUE || ' maxvalue ' ||
	       V_DS_SEQ_VAR.MAX_VALUE || ' increment by ' ||
	       V_DS_SEQ_VAR.INCREMENT_BY || ' start with ' ||
	       V_DS_SEQ_VAR.LAST_NUMBER ||
	       DECODE(V_DS_SEQ_VAR.CACHE_SIZE,
		      0,
		      ' NOCACHE ',
		      ' cache ' || V_DS_SEQ_VAR.CACHE_SIZE) || ' ' ||
	       DECODE(V_DS_SEQ_VAR.ORDER_FLAG, 'N', 'NOORDER', 'ORDER') || ' ' ||
	       DECODE(V_DS_SEQ_VAR.CYCLE_FLAG, 'N', 'NOCYCLE', 'CYCLE')
	  INTO V_SEQ_SQL_CRT
	  FROM DUAL;
	DBMS_OUTPUT.PUT_LINE(V_SEQ_SQL_CRT);
	EXECUTE IMMEDIATE V_SEQ_SQL_CRT;
      END IF;
      -- dbms_output.put_line(v_seq_sql_drop || chr(10) || v_seq_sql_crt);
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END SYNC_SEQ;
  /*同不源端和目标端的SYNONYM*/
  PROCEDURE SYNC_SYNONYM(P_DS_OWNER VARCHAR2, P_DT_OWNER VARCHAR2) IS
    CURSOR C_SYNONYM(C_DS_OWNER VARCHAR2, C_DT_OWNER VARCHAR2) IS
      SELECT *
	FROM DBA_SYNONYMS@DBVERIFY
       WHERE OWNER = C_DS_OWNER
      MINUS
      SELECT * FROM DBA_SYNONYMS WHERE OWNER = C_DT_OWNER;
    V_SQL_CODE VARCHAR2(4000) := NULL;
  BEGIN
    FOR C IN C_SYNONYM(P_DS_OWNER, P_DT_OWNER) LOOP
      SELECT 'CREATE OR REPLACE SYNONYM ' || C.OWNER || '.' ||
	     C.SYNONYM_NAME || ' FOR ' || C.TABLE_OWNER || '.' ||
	     C.TABLE_NAME ||
	     DECODE(C.DB_LINK, NULL, NULL, '@' || C.DB_LINK)
	INTO V_SQL_CODE
	FROM DUAL;
      EXECUTE IMMEDIATE V_SQL_CODE;
      V_SQL_CODE := NULL;
    END LOOP;
  END SYNC_SYNONYM;
  PROCEDURE CHECK_VIEW(P_DS_OWNER VARCHAR2, P_DT_OWNER VARCHAR2) IS
    DEF1 VARCHAR2(32000);
    DEF2 VARCHAR2(32000);
    LEN1 NUMBER;
    LEN2 NUMBER;
    I	 NUMBER;
    CURSOR C1 IS
      SELECT VIEW_NAME FROM DBA_VIEWS@DBVERIFY WHERE OWNER = P_DS_OWNER;
  BEGIN
    DBMS_OUTPUT.ENABLE(100000);
    FOR C IN C1 LOOP
      SELECT TEXT, TEXT_LENGTH
	INTO DEF1, LEN1
	FROM DBA_VIEWS
       WHERE VIEW_NAME = C.VIEW_NAME
	 AND OWNER = P_DT_OWNER;
      SELECT TEXT, TEXT_LENGTH
	INTO DEF2, LEN2
	FROM DBA_VIEWS@DBVERIFY
       WHERE VIEW_NAME = C.VIEW_NAME
	 AND OWNER = P_DS_OWNER;
      I    := 1;
      DEF1 := REPLACE(DEF1, ' ', '');
      DEF2 := REPLACE(DEF2, ' ', '');
      IF DEF1 != DEF2 OR LENGTH(DEF1) != LENGTH(DEF2) THEN
	DBMS_OUTPUT.PUT_LINE(LPAD('-', 35 + LENGTH(C.VIEW_NAME), '-'));
	DBMS_OUTPUT.PUT_LINE('|  ' || C.VIEW_NAME || '	  |');
	DBMS_OUTPUT.PUT_LINE(LPAD('-', 35 + LENGTH(C.VIEW_NAME), '-'));
	DBMS_OUTPUT.PUT_LINE('Local text_length: ' || TO_CHAR(LEN1));
	DBMS_OUTPUT.PUT_LINE('Remote text_length):  ' || TO_CHAR(LEN2));
	DBMS_OUTPUT.PUT_LINE(' ');
	I := 1;
	WHILE I <= LENGTH(DEF1) LOOP
	  IF SUBSTR(DEF1, I, 240) != SUBSTR(DEF2, I, 240) THEN
	    DBMS_OUTPUT.PUT_LINE('Difference at offset ' || TO_CHAR(I));
	    DBMS_OUTPUT.PUT_LINE(' local: ' || SUBSTR(DEF1, I, 240));
	    DBMS_OUTPUT.PUT_LINE(' remote:  ' || SUBSTR(DEF2, I, 240));
	  END IF;
	  I := I + 240;
	END LOOP;
      END IF;
      IF LENGTH(DEF2) > LENGTH(DEF1) THEN
	DBMS_OUTPUT.PUT_LINE('Remote longer than Local. Next 255 bytes: ');
	DBMS_OUTPUT.PUT_LINE(SUBSTR(DEF2, LENGTH(DEF1), 255));
      END IF;
    END LOOP;
  END CHECK_VIEW;
  PROCEDURE FIND_CHAINED_ROW IS
    V_SQL_STR VARCHAR2(500) := NULL;
    V_CK_TAB  NUMBER;

    CURSOR C_ALL_TAB IS
      SELECT DT_OWNER, DT_NAME
	FROM DSG_CHECK_TABLE
       WHERE CHECK_TYPE LIKE 'TABLE%';
  BEGIN
    SELECT COUNT(1)
      INTO V_CK_TAB
      FROM USER_TABLES
     WHERE TABLE_NAME LIKE 'CHAINED_ROWS';
    IF V_CK_TAB > 0 THEN
      EXECUTE IMMEDIATE 'truncate table chained_rows';
    ELSE
      EXECUTE IMMEDIATE 'create table CHAINED_ROWS ( owner_name varchar2(30), table_name varchar2(30), cluster_name varchar2(30), partition_name varchar2(30), subpartition_name varchar2(30), head_rowi
, analyze_timestamp date )';
    END IF;
    FOR C IN C_ALL_TAB LOOP
      BEGIN
	V_SQL_STR := 'ANALYZE TABLE ' || C.DT_OWNER || '.' || C.DT_NAME ||
		     ' LIST CHAINED ROWS ';
	EXECUTE IMMEDIATE V_SQL_STR;
      EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE(SQLERRM);
      END;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END;
  /*比对两边的表结构*/
  /*
  */
  /*-- Description  : Displays several performance indicators and comments on the value.*/

  PROCEDURE PRO_TUNING IS
    V_VALUE NUMBER;

    FUNCTION FORMAT(P_VALUE IN NUMBER) RETURN VARCHAR2 IS
    BEGIN
      RETURN LPAD(TO_CHAR(ROUND(P_VALUE, 2), '990.00') || '%', 8, ' ') || '  ';
    END;

  BEGIN

    -- --------------------------
    -- Dictionary Cache Hit Ratio
    -- --------------------------
    SELECT (1 - (SUM(GETMISSES) / (SUM(GETS) + SUM(GETMISSES)))) * 100
      INTO V_VALUE
      FROM V$ROWCACHE;

    DBMS_OUTPUT.PUT('Dictionary Cache Hit Ratio  : ' || FORMAT(V_VALUE));
    IF V_VALUE < 90 THEN
      DBMS_OUTPUT.PUT_LINE('Increase SHARED_POOL_SIZE parameter to bring value above 90%');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Value Acceptable.');
    END IF;

    -- -----------------------
    -- Library Cache Hit Ratio
    -- -----------------------
    SELECT (1 - (SUM(RELOADS) / (SUM(PINS) + SUM(RELOADS)))) * 100
      INTO V_VALUE
      FROM V$LIBRARYCACHE;

    DBMS_OUTPUT.PUT('Library Cache Hit Ratio  : ' || FORMAT(V_VALUE));
    IF V_VALUE < 99 THEN
      DBMS_OUTPUT.PUT_LINE('Increase SHARED_POOL_SIZE parameter to bring value above 99%');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Value Acceptable.');
    END IF;

    -- -------------------------------
    -- DB Block Buffer Cache Hit Ratio
    -- -------------------------------
    SELECT (1 - (PHYS.VALUE / (DB.VALUE + CONS.VALUE))) * 100
      INTO V_VALUE
      FROM V$SYSSTAT PHYS, V$SYSSTAT DB, V$SYSSTAT CONS
     WHERE PHYS.NAME = 'physical reads'
       AND DB.NAME = 'db block gets'
       AND CONS.NAME = 'consistent gets';

    DBMS_OUTPUT.PUT('DB Block Buffer Cache Hit Ratio  : ' ||
		    FORMAT(V_VALUE));
    IF V_VALUE < 89 THEN
      DBMS_OUTPUT.PUT_LINE('Increase DB_BLOCK_BUFFERS parameter to bring value above 89%');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Value Acceptable.');
    END IF;

    -- ---------------
    -- Latch Hit Ratio
    -- ---------------
    SELECT (1 - (SUM(MISSES) / SUM(GETS))) * 100 INTO V_VALUE FROM V$LATCH;

    DBMS_OUTPUT.PUT('Latch Hit Ratio  : ' || FORMAT(V_VALUE));
    IF V_VALUE < 98 THEN
      DBMS_OUTPUT.PUT_LINE('Increase number of latches to bring the value above 98%');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Value acceptable.');
    END IF;

    -- -----------------------
    -- Disk Sort Ratio
    -- -----------------------
    SELECT (DISK.VALUE / MEM.VALUE) * 100
      INTO V_VALUE
      FROM V$SYSSTAT DISK, V$SYSSTAT MEM
     WHERE DISK.NAME = 'sorts (disk)'
       AND MEM.NAME = 'sorts (memory)';

    DBMS_OUTPUT.PUT('Disk Sort Ratio  : ' || FORMAT(V_VALUE));
    IF V_VALUE > 5 THEN
      DBMS_OUTPUT.PUT_LINE('Increase SORT_AREA_SIZE parameter to bring value below 5%');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Value Acceptable.');
    END IF;

    -- ----------------------
    -- Rollback Segment Waits
    -- ----------------------
    SELECT (SUM(WAITS) / SUM(GETS)) * 100 INTO V_VALUE FROM V$ROLLSTAT;

    DBMS_OUTPUT.PUT('Rollback Segment Waits   : ' || FORMAT(V_VALUE));
    IF V_VALUE > 5 THEN
      DBMS_OUTPUT.PUT_LINE('Increase number of Rollback Segments to bring the value below 5%');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Value acceptable.');
    END IF;

    -- -------------------
    -- Dispatcher Workload
    -- -------------------
    SELECT NVL((SUM(BUSY) / (SUM(BUSY) + SUM(IDLE))) * 100, 0)
      INTO V_VALUE
      FROM V$DISPATCHER;

    DBMS_OUTPUT.PUT('Dispatcher Workload   : ' || FORMAT(V_VALUE));
    IF V_VALUE > 50 THEN
      DBMS_OUTPUT.PUT_LINE('Increase MTS_DISPATCHERS to bring the value below 50%');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Value acceptable.');
    END IF;

  END PRO_TUNING;
  /*print all large obj*/
  PROCEDURE PRINT(MESG IN VARCHAR2, WRAPLENGTH IN NUMBER DEFAULT NULL) IS
    --Print out a string (can be longer than 255 characters)
    PIECE1 VARCHAR2(4000);
    PIECE2 VARCHAR2(4000);
    POSN   NUMBER;
    WL	   NUMBER;
  BEGIN
    IF WRAPLENGTH IS NULL THEN
      WL := 255;
    ELSE
      WL := LEAST(WRAPLENGTH, 255);
    END IF;

    IF LENGTH(MESG) <= WL THEN
      DBMS_OUTPUT.PUT_LINE(MESG);
    ELSE
      PIECE1 := MESG;
      POSN   := 1;

      WHILE LENGTH(PIECE1) > 0 LOOP
	POSN := WL;

	WHILE SUBSTR(PIECE1, POSN - 1, 1) NOT IN
	      (' ', '  ', CHR(13), CHR(9)) LOOP
	  POSN := POSN - 1;

	  IF POSN = 1 THEN
	    POSN := WL;
	    EXIT;
	  END IF;
	END LOOP;

	PIECE2 := SUBSTR(PIECE1, 1, POSN - 1);
	DBMS_OUTPUT.PUT_LINE(PIECE2);
	PIECE1 := SUBSTR(PIECE1, POSN, LENGTH(PIECE1));
      END LOOP;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('*** ERROR IN PRINT ***');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END PRINT;
BEGIN
  NULL;
  -- Initialization
END PAC_CHECK_OWNER;
/
