CREATE OR REPLACE PROCEDURE dnfs_monitor
   (sleepSecs IN NUMBER)
IS
   startTime       DATE;
   startReadIOPS   NUMBER;
   startWriteIOPS  NUMBER;
   startReadBytes  NUMBER;
   startWriteBytes NUMBER;
   endTime         DATE;
   endReadIOPS     NUMBER;
   endWriteIOPS    NUMBER;
   endReadBytes    NUMBER;
   endWriteBytes   NUMBER;
   readThr         NUMBER;
   writeThr        NUMBER;
   readIOPS        NUMBER;
   writeIOPS       NUMBER;
   elapsedTime     NUMBER;
BEGIN

   SELECT sysdate, SUM(stats.nfs_readbytes), SUM(stats.nfs_writebytes), SUM(stats.nfs_read), SUM(stats.nfs_write)
   INTO startTime, startReadBytes, startWriteBytes, startReadIOPS, startWriteIOPS
   FROM dual, v$dnfs_stats stats;

   DBMS_OUTPUT.PUT_LINE('Started at  ' || TO_CHAR(startTime, 'MM/DD/YYYY HH:MI:SS AM'));

   DBMS_LOCK.SLEEP(sleepSecs);

   SELECT sysdate, SUM(stats.nfs_readbytes), SUM(stats.nfs_writebytes), SUM(stats.nfs_read), SUM(stats.nfs_write)
   INTO endTime, endReadBytes, endWriteBytes, endReadIOPS, endWriteIOPS
   FROM dual, v$dnfs_stats stats;

   DBMS_OUTPUT.PUT_LINE('Finished at ' || to_char(endTime, 'MM/DD/YYYY HH:MI:SS AM'));

   elapsedTime := (endTime - startTime) * 86400;
   readThr := (endReadBytes - startReadBytes)/(1024 * 1024 * elapsedTime);
   writeThr := (endWriteBytes - startWriteBytes)/(1024 * 1024 * elapsedTime);
   readIOPS := (endReadIOPS - startReadIOPS)/elapsedTime;
   writeIOPS := (endWriteIOPS - startWriteIOPS)/elapsedTime;

   DBMS_OUTPUT.PUT_LINE('READ IOPS:        ' || LPAD(TO_CHAR(readIOPS, '999999999'), 10, ' '));
   DBMS_OUTPUT.PUT_LINE('WRITE IOPS:       ' || LPAD(TO_CHAR(writeIOPS, '999999999'), 10, ' '));
   DBMS_OUTPUT.PUT_LINE('TOTAL IOPS:       ' || LPAD(TO_CHAR(readIOPS + writeIOPS, '999999999'), 10, ' '));
   DBMS_OUTPUT.PUT_LINE('READ Throughput:  ' || LPAD(TO_CHAR(readThr, '999999999'), 10, ' ') || ' MB/s');
   DBMS_OUTPUT.PUT_LINE('WRITE Throughput: ' || LPAD(TO_CHAR(writeThr, '999999999'), 10, ' ') || ' MB/s');
   DBMS_OUTPUT.PUT_LINE('TOTAL Throughput: ' || LPAD(TO_CHAR(readThr + writeThr, '999999999'), 10, ' ') || ' MB/s');
END;
/

CREATE OR REPLACE PROCEDURE dnfs_itermonitor
   (sleepSecs IN NUMBER,
    iter      IN NUMBER)
IS
   startTime       DATE;
   startReadIOPS   NUMBER;
   startWriteIOPS  NUMBER;
   startReadBytes  NUMBER;
   startWriteBytes NUMBER;
   endTime         DATE;
   endReadIOPS     NUMBER;
   endWriteIOPS    NUMBER;
   endReadBytes    NUMBER;
   endWriteBytes   NUMBER;
   readThr         NUMBER;
   writeThr        NUMBER;
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
       LPAD('TOTAL IOPS', 15, ' ')||
       LPAD('READ (MB/s)', 15, ' ')||
       LPAD('WRITE (MB/s)', 15, ' ')||
       LPAD('TOTAL (MB/s)', 15, ' '));

   FOR i IN 1..iter
   LOOP
   SELECT sysdate, SUM(stats.nfs_readbytes), SUM(stats.nfs_writebytes), SUM(stats.nfs_read), SUM(stats.nfs_write)
   INTO startTime, startReadBytes, startWriteBytes, startReadIOPS, startWriteIOPS
   FROM dual, v$dnfs_stats stats;

   DBMS_LOCK.SLEEP(sleepSecs);

   SELECT sysdate, SUM(stats.nfs_readbytes), SUM(stats.nfs_writebytes), SUM(stats.nfs_read), SUM(stats.nfs_write)
   INTO endTime, endReadBytes, endWriteBytes, endReadIOPS, endWriteIOPS
   FROM dual, v$dnfs_stats stats;

   elapsedTime := (endTime - startTime) * 86400;
   readThr := (endReadBytes-startReadBytes)/(1024 * 1024 * elapsedTime);
   writeThr := (endWriteBytes-startWriteBytes)/(1024 * 1024 * elapsedTime);
   readIOPS := (endReadIOPS - startReadIOPS)/elapsedTime;
   writeIOPS := (endWriteIOPS - startWriteIOPS)/elapsedTime;

   DBMS_OUTPUT.PUT_LINE(
       TO_CHAR(endTime, 'MM/DD/YYYY HH:MI:SS AM') ||
       LPAD(TO_CHAR(readIOPS, '999999999'), 15, ' ') ||
       LPAD(TO_CHAR(writeIOPS, '999999999'), 15, ' ') ||
       LPAD(TO_CHAR(readIOPS + writeIOPS, '999999999'), 15, ' ') ||
       LPAD(TO_CHAR(readThr, '999999999'), 15, ' ') ||
       LPAD(TO_CHAR(writeThr, '999999999'), 15, ' ') ||
       LPAD(TO_CHAR(readThr + writeThr, '999999999'), 15, ' '));
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('Finished at ' || to_char(endTime, 'MM/DD/YYYY HH:MI:SS AM'));

END;
/
