CREATE OR REPLACE PROCEDURE dnfs_monitor
   (sleepSecs IN NUMBER)
IS
   startTime       DATE;
   startReadIOPS   NUMBER;
   startWriteIOPS  NUMBER;
   endTime         DATE;
   endReadIOPS     NUMBER;
   endWriteIOPS    NUMBER;
   readIOPS        NUMBER;
   writeIOPS       NUMBER;
   elapsedTime     NUMBER;
BEGIN

   SELECT sysdate, SUM(stats.nfs_read), SUM(stats.nfs_write)
   INTO startTime, startReadIOPS, startWriteIOPS
   FROM dual, v$dnfs_stats stats;

   DBMS_OUTPUT.PUT_LINE('Started at  ' || TO_CHAR(startTime, 'MM/DD/YYYY HH:MI:SS AM'));

   DBMS_LOCK.SLEEP(sleepSecs);

   SELECT sysdate, SUM(stats.nfs_read), SUM(stats.nfs_write)
   INTO endTime, endReadIOPS, endWriteIOPS
   FROM dual, v$dnfs_stats stats;

   DBMS_OUTPUT.PUT_LINE('Finished at ' || to_char(endTime, 'MM/DD/YYYY HH:MI:SS AM'));

   elapsedTime := (endTime - startTime) * 86400;
   readIOPS := (endReadIOPS - startReadIOPS)/elapsedTime;
   writeIOPS := (endWriteIOPS - startWriteIOPS)/elapsedTime;

   DBMS_OUTPUT.PUT_LINE('READ IOPS:        ' || LPAD(TO_CHAR(readIOPS, '999999999'), 10, ' '));
   DBMS_OUTPUT.PUT_LINE('WRITE IOPS:       ' || LPAD(TO_CHAR(writeIOPS, '999999999'), 10, ' '));
   DBMS_OUTPUT.PUT_LINE('TOTAL IOPS:       ' || LPAD(TO_CHAR(readIOPS + writeIOPS, '999999999'), 10, ' '));
END;
/

CREATE OR REPLACE PROCEDURE dnfs_itermonitor
   (sleepSecs IN NUMBER,
    iter      IN NUMBER)
IS
   startTime       DATE;
   startReadIOPS   NUMBER;
   startWriteIOPS  NUMBER;
   endTime         DATE;
   endReadIOPS     NUMBER;
   endWriteIOPS    NUMBER;
   readIOPS        NUMBER;
   writeIOPS       NUMBER;
   i               NUMBER;
   elapsedTime     NUMBER;
BEGIN

   DBMS_OUTPUT.PUT_LINE('Started at ' || TO_CHAR(SYSDATE, 'MM/DD/YYYY HH:MI:SS AM'));

   DBMS_OUTPUT.PUT_LINE(
       LPAD('TIMESTAMP', 15, ' ')||
       LPAD('READ IOPS', 33, ' ')||
       LPAD('WRITE IOPS', 15, ' ')||
       LPAD('TOTAL IOPS', 15, ' '));

   FOR i IN 1..iter
   LOOP
   SELECT sysdate, SUM(stats.nfs_read), SUM(stats.nfs_write)
   INTO startTime, startReadIOPS, startWriteIOPS
   FROM dual, v$dnfs_stats stats;

   DBMS_LOCK.SLEEP(sleepSecs);

   SELECT sysdate, SUM(stats.nfs_read), SUM(stats.nfs_write)
   INTO endTime, endReadIOPS, endWriteIOPS
   FROM dual, v$dnfs_stats stats;

   elapsedTime := (endTime - startTime) * 86400;
   readIOPS := (endReadIOPS - startReadIOPS)/elapsedTime;
   writeIOPS := (endWriteIOPS - startWriteIOPS)/elapsedTime;

   DBMS_OUTPUT.PUT_LINE(
       TO_CHAR(endTime, 'MM/DD/YYYY HH:MI:SS AM') ||
       LPAD(TO_CHAR(readIOPS, '999999999'), 15, ' ') ||
       LPAD(TO_CHAR(writeIOPS, '999999999'), 15, ' ') ||
       LPAD(TO_CHAR(readIOPS + writeIOPS, '999999999'), 15, ' '));

   END LOOP;
   DBMS_OUTPUT.PUT_LINE('Finished at ' || to_char(endTime, 'MM/DD/YYYY HH:MI:SS AM'));

END;
/
