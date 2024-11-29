CREATE OR REPLACE PROCEDURE kill_session (pn_sid NUMBER, pn_serial NUMBER)
AS
   lv_user     VARCHAR2 (40);
   user_kill   VARCHAR2 (40);
BEGIN
   SELECT USER INTO user_kill FROM DUAL;


   SELECT username
     INTO lv_user
     FROM v$session
    WHERE sid = pn_sid AND serial# = pn_serial;

   IF lv_user IS NOT NULL AND lv_user = user_kill
   THEN
      EXECUTE IMMEDIATE
         'alter system kill session ''' || pn_sid || ',' || pn_serial || '''';
   ELSE
      raise_application_error (
         -20000,
         'Attempt to kill protected other session has been blocked.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('SESSION :' || pn_sid || ' IS NOT FIND;');
END;
/
/*grant execute on kill_session to username;
create public synonym kill_session for sys.kill_session;
grant select on v_$session to username;
grant execute on dbms_output to username;
ser serveroutput on*/