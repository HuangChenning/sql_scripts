set echo off;
set lines 300 pages 1000 verify off heading on serveroutput on;
col comp_id for a15
col comp_name for a50
col version for a12
col status for a10
select comp_id,comp_name,version,status from dba_registry;

DECLARE
   start_time    DATE;

   end_time      DATE;
   object_name   VARCHAR (100);
   object_id     CHAR (10);
BEGIN
   SELECT date_loading, date_loaded
     INTO start_time, end_time
     FROM registry$
    WHERE cid = '&comp_id';



   SELECT obj#, name
     INTO object_id, object_name
     FROM obj$
    WHERE     status > 1
          AND (   ctime BETWEEN start_time AND end_time
               OR mtime BETWEEN start_time AND end_time
               OR stime BETWEEN start_time AND end_time)
          AND ROWNUM <= 1;

   DBMS_OUTPUT.put_line (
         'Please compile Invalid object '
      || object_name
      || ' 
Object_id '
      || object_id);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('CATPROC can be validated now');
END;
/