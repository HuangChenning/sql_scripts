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


/* Formatted on 2016/12/24 23:22:57 (QP5 v5.256.13226.35510) */
DECLARE
   i_sql          VARCHAR2 (200);
   i_number       NUMBER;
   i_schemaname   VARCHAR2 (200);
   i_linkname     VARCHAR2 (200);

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


   SELECT COUNT (*)
     INTO i_number
     FROM dba_db_links
    WHERE owner = UPPER (i_schemaname) AND db_link = UPPER (i_linkname);

   IF i_number > 0
   THEN
      i_sql := 'DROP DATABASE LINK ' || i_linkname;
      -- DBMS_OUTPUT.put_line (i_sql);
      exec_sql (UPPER (i_schemaname), i_sql);

      SELECT COUNT (*)
        INTO i_number
        FROM dba_db_links
       WHERE owner = UPPER (i_schemaname) AND db_link = UPPER (i_linkname);

      IF i_number > 0
      THEN
         DBMS_OUTPUT.put_line (
            'success exec drop command but dblink is exists and exit');
      END IF;
   ELSE
      DBMS_OUTPUT.put_line (
            '***************'
         || UPPER (i_schemaname)
         || ':'
         || UPPER (i_linkname)
         || ' is not exits and exit ************************');
   END IF;
END;
/

undefine 1,2,OWNERNAME,DBLINKNAME
undefine 2
undefine OWNERNAME
undefine DBLINKNAME
