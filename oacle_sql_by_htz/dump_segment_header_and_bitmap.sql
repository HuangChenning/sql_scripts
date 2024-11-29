set echo off;
set lines 200;
set pages 40;
set verify off;
set serveroutput on;
DECLARE
   i_segment_owner    VARCHAR2 (100);
   i_segment_name     VARCHAR2 (100);
   i_partition_name   VARCHAR2 (100);
BEGIN
   i_segment_owner := UPPER ('&segment_owner');
   i_segment_name := UPPER ('&table_name');
/*   i_partition_name := nvl(upper('&partition_name'),'a.partition_name'); */

   FOR i
      IN (SELECT tablespace_name, header_file, header_block
            FROM dba_segments a
           WHERE     owner = i_segment_owner
                 AND segment_name = i_segment_name 
                 /*and a.partition_name=i_partition_name*/
                )
   LOOP
      DBMS_OUTPUT.put_line ('TABLESPACE_NAME ' || i.tablespace_name);
      DBMS_SPACE_ADMIN.segment_dump (i.tablespace_name,
                                     i.header_file,
                                     i.header_block);
   END LOOP;
END;
/
undefine segment_owner;
undefine table_name;
undefine partition_name;

oradebug setmypid
oradebug tracefile_name;