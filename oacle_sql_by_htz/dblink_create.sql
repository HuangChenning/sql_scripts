/* Formatted on 2016/12/24 23:07:38 (QP5 v5.256.13226.35510) */
SET ECHO OFF
SET VERIFY OFF SERVEROUTPUT ON LINES 250;
PRO Parameter 1:
PRO DBLINK OWNER (required)
PRO
DEF OWNERNAME = '&1';
PRO
PRO Parameter 2:
PRO LINKNAME (required)
PRO
DEF DBLINKNAME = '&2';
PRO

PRO Parameter 3:
PRO CONNECT USERNAME (required)
PRO
DEF CONNECTUSERNMAE = '&3';
PRO

PRO Parameter 4:
PRO CONNECT USERNAME PASSWORD (required)
PRO
DEF CONNECTPASSWORD = '&4';
PRO

PRO Parameter 5:
PRO TNSNAME LABEL NAME (required)
PRO
DEF LABELNAME = '&5';
PRO

DECLARE
   i_sql          VARCHAR2 (200);
   i_number       NUMBER;
   i_schemaname   VARCHAR2 (200);
   i_username     VARCHAR2 (200);
   i_linkname     VARCHAR2 (200);
   i_password     VARCHAR2 (200);
   i_tnsname      VARCHAR2 (200);

   PROCEDURE exec_sql (p_user IN VARCHAR2, p_statement IN VARCHAR2)
   IS
      lv_userid   NUMBER;
      lv_cursor   NUMBER;
      lv_result   NUMBER;
   BEGIN
      -- Get USER_ID for specified user
      SELECT user_id
        INTO lv_userid
        FROM dba_users
       WHERE username = p_user;

      -- Open, parse, execute and close
      lv_cursor := sys.DBMS_SYS_SQL.open_cursor;
      sys.DBMS_SYS_SQL.parse_as_user (lv_cursor,
                                      p_statement,
                                      DBMS_SQL.native,
                                      lv_userid,
                                      TRUE);
      lv_result := sys.DBMS_SYS_SQL.execute (lv_cursor);
      sys.DBMS_SYS_SQL.close_cursor (lv_cursor);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.PUT_LINE (
            'Failed to execute the specified statement for user: ' || p_user);
         DBMS_OUTPUT.PUT_LINE (SQLERRM);
   END;
BEGIN
   SELECT TRIM ('&&OWNERNAME') INTO i_schemaname FROM DUAL;

   SELECT TRIM ('&&DBLINKNAME') INTO i_linkname FROM DUAL;

   SELECT TRIM ('&&CONNECTUSERNMAE') INTO i_username FROM DUAL;

   SELECT TRIM ('&&CONNECTPASSWORD') INTO i_password FROM DUAL;

   SELECT TRIM ('&&LABELNAME') INTO i_tnsname FROM DUAL;

   SELECT COUNT (*)
     INTO i_number
     FROM dba_db_links
    WHERE owner = UPPER (i_schemaname) AND db_link = UPPER (i_linkname);

   IF i_number > 0
   THEN
      DBMS_OUTPUT.put_line (
            '***************'
         || UPPER (i_schemaname)
         || ':'
         || UPPER (i_linkname)
         || ' is exits and exit ************************');
   ELSE
      i_sql :=
            'CREATE DATABASE LINK '
         || i_linkname
         || ' CONNECT TO '
         || i_username
         || ' IDENTIFIED BY '
         || i_password
         || ' USING '
         || CHR (39)
         || i_tnsname
         || CHR (39);
     -- DBMS_OUTPUT.put_line (i_sql);
      exec_sql (UPPER (i_schemaname), i_sql);
      i_sql :='select count(*) from dual@'||i_linkname;
      exec_sql (UPPER (i_schemaname), i_sql);
   END IF;
END;
/
