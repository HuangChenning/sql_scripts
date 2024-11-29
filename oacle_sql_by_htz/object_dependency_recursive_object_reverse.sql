set echo off
set pages 4000 lines 3000 verify off heading on verify off serveroutput on
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
exec dbms_output.enable(1000000);
undefine owner;
undefine object_name;
undefine object_type;

DECLARE
   v_owner         VARCHAR2 (100) := UPPER ('&owner');
   v_object_name   VARCHAR2 (200) := UPPER ('&object_name');
   v_object_type   VARCHAR2 (100) := UPPER ('&object_type');
   LEVEL           NUMBER DEFAULT 0;

   CURSOR c_depen_reverse
   IS
      SELECT owner, name, TYPE
        FROM dba_dependencies
       WHERE     dba_dependencies.referenced_owner = v_owner
             AND dba_dependencies.referenced_name = v_object_name
             AND dba_dependencies.referenced_type = v_object_type;

   I               INTEGER;
   object_id       dba_objects.object_id%TYPE;
   datum           VARCHAR2 (25);
   time_stamp      dba_objects.TIMESTAMP%TYPE;
   v_status        dba_objects.status%TYPE;
BEGIN
   SELECT object_id,
          TO_CHAR (last_ddl_time, 'dd-mon-yyyy hh24:mi:ss'),
          timestamp,
          status
     INTO object_id,
          datum,
          time_stamp,
          v_status
     FROM dba_objects
    WHERE     dba_objects.owner = v_owner
          AND dba_objects.object_name = v_object_name
          AND dba_objects.object_type = v_object_type;

   DBMS_OUTPUT.put_line (
         'Level: '
      || ' '
      || LEVEL
      || ' '
      || object_id
      || ' '
      || v_owner
      || ' '
      || v_object_name
      || ' '
      || v_object_type
      || ' '
      || datum
      || ' '
      || time_stamp
      || ' '
      || v_status);

   FOR c_rec IN c_depen_reverse
   LOOP
      recur_object_reverse (c_rec.owner,
                            c_rec.name,
                            c_rec.TYPE,
                            LEVEL + 1);
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line (
            'No record found for: '
         || ' '
         || v_owner
         || ' '
         || v_object_name
         || ' '
         || v_object_type);
END;
/

undefine owner;
undefine object_name;
undefine object_type;