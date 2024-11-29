set echo off
set lines 200 pages 400 heading on heading on verify off
/* Formatted on 2014/8/9 14:42:02 (QP5 v5.240.12305.39446) */
CREATE OR REPLACE PROCEDURE scott.htz_test_db_link
AS
   v_dbname     VARCHAR2 (100);
   v_linkname   VARCHAR2 (100) := 'link_test';
   v_owner      VARCHAR2 (100) := 'scott';
BEGIN
   EXECUTE IMMEDIATE 'select global_name from global_name@' || v_linkname
      INTO v_dbname;

   DBMS_OUTPUT.put_line (
      v_linkname || ' SUCCESSFULLY connected to ' || v_dbname);
END;
/

EXEC scott.htz_test_db_link;

DROP PROCEDURE scott.htz_test_db_link;