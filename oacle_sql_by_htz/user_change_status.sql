-- File Name : user_change_status.sql
-- Purpose : 将用户状态是expire的更改为open
-- Date : 2016/05/19
-- 认真就输、QQ:7343696
-- http://www.htz.pw
-- 更多脚本，请访问http://www.htz.pw/script
-- 20160930

set serveroutput on verify off

undefine day;
DECLARE
   v_sql          VARCHAR2 (100);
   i_status       VARCHAR2 (100);
   i_old_status   VARCHAR2 (100);
BEGIN
   FOR c_user IN (SELECT name, astatus, password
                    FROM user$ a
                   WHERE     a.astatus IN (1,
                                           2,
                                           5,
                                           6,
                                           9,
                                           10)
                         AND a.EXPTIME > SYSDATE - &day)
   LOOP
      IF c_user.astatus IN (5,
                            6,
                            9,
                            10)
      THEN
         v_sql :=
               'alter user '
            || c_user.name
            || ' identified by values '
            || CHR (39)
            || c_user.password
            || CHR (39)
            || ' account unlock';
      ELSE
         v_sql :=
               'alter user '
            || c_user.name
            || ' identified by values '
            || CHR (39)
            || c_user.password
            || CHR (39);
      END IF;

      SELECT ACCOUNT_STATUS
        INTO i_old_status
        FROM dba_users
       WHERE username = c_user.name;

      EXECUTE IMMEDIATE v_sql;

      SELECT ACCOUNT_STATUS
        INTO i_status
        FROM dba_users
       WHERE username = c_user.name;

      DBMS_OUTPUT.put_line (
            'User '
         || c_user.name
         || ' Old Status :'
         || i_old_status
         || ' And New Status :'
         || i_status);
   END LOOP;
END;
/
undefine day;