/* Formatted on 2014/8/12 17:18:23 (QP5 v5.240.12305.39446) */
CREATE OR REPLACE PROCEDURE recur_object_reverse (
   v_owner         IN VARCHAR2,
   v_object_name      VARCHAR2,
   v_object_type      VARCHAR2,
   LEVEL              NUMBER DEFAULT 0)
IS
   CURSOR c_depen_reverse
   IS
      SELECT owner, name, TYPE
        FROM dba_dependencies
       WHERE     dba_dependencies.referenced_owner = v_owner
             AND dba_dependencies.referenced_name = v_object_name
             AND dba_dependencies.referenced_type = v_object_type;

   i            INTEGER;
   object_id    dba_objects.object_id%TYPE;
   datum        VARCHAR2 (25);
   time_stamp   dba_objects.timestamp%TYPE;
   v_status     dba_objects.status%TYPE;
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