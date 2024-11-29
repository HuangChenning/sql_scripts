SET SERVEROUT ON SIZE 10000
DECLARE

PROCEDURE P_FOUND_PARTITION (P_OWNER IN VARCHAR2 DEFAULT '%', P_DATE IN DATE DEFAULT SYSDATE + 100) AS
V_HIGH_VALUE VARCHAR2(4000);
V_HIGH_DATE DATE;
V_FLAG NUMBER DEFAULT 0;
BEGIN
   FOR I IN (SELECT OWNER, TABLE_NAME, PARTITION_COUNT
   FROM DBA_PART_TABLES
                                           WHERE OWNER LIKE P_OWNER
                                           AND PARTITIONING_TYPE = 'RANGE'
                                           AND INTERVAL IS NULL) LOOP
           FOR J IN (SELECT PC.OWNER, PC.NAME, TC.DATA_TYPE, COUNT(*) OVER() CN
                                           FROM DBA_PART_KEY_COLUMNS PC, DBA_TAB_COLUMNS TC
                                           WHERE PC.OWNER = TC.OWNER
                                           AND PC.NAME = TC.TABLE_NAME
                                           AND PC.OBJECT_TYPE = 'TABLE'
                                           AND PC.COLUMN_NAME = TC.COLUMN_NAME
                                           AND PC.OWNER = I.OWNER
                                           AND PC.NAME = I.TABLE_NAME) LOOP
                   IF J.CN = 1 AND J.DATA_TYPE = 'DATE' THEN
                           FOR K IN (SELECT HIGH_VALUE FROM DBA_TAB_PARTITIONS TP
                                                                   WHERE TP.TABLE_OWNER = J.OWNER
                                                                   AND TP.TABLE_NAME = J.NAME
                                                                   ORDER BY PARTITION_POSITION) LOOP
                                   IF K.HIGH_VALUE = 'MAXVALUE' THEN
                                           V_HIGH_VALUE := 'TO_DATE(''99991231235959'', ''YYYYMMDDHH24MISS'')';
                                   ELSE
                                           V_HIGH_VALUE := K.HIGH_VALUE;
                                   END IF;
                                   EXECUTE IMMEDIATE 'SELECT ' || V_HIGH_VALUE || ' FROM DUAL' INTO V_HIGH_DATE;
                                   IF P_DATE <= V_HIGH_DATE
                                   THEN
                                           V_FLAG := V_FLAG + 1;
                                   END IF;
                           END LOOP;
                           IF V_FLAG < 2 THEN
                                   DBMS_OUTPUT.PUT_LINE(J.OWNER || '.' || J.NAME || ': NO USABLE PARTITION');
                           END IF;
                           V_FLAG := 0;
                   END IF;
           END LOOP;
   END LOOP;
END;

BEGIN
P_FOUND_PARTITION('%', SYSDATE + 300);
END;
/