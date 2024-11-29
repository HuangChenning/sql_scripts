--# anquan.sql
--# create by htz
--# www.htz.pw
--# 2017-09-05 modified for 12C i_version IN ('12.1.0.2', '12.1.0.1', '12.2.0.1')
set lines 200 serveroutput on
/* modify o7_dictionary_accessibility*/
DECLARE
   i_sql   VARCHAR2 (1000);
BEGIN
   FOR c_value IN (SELECT VALUE
                     FROM v$parameter
                    WHERE name = 'O7_DICTIONARY_ACCESSIBILITY' and value not in ('FALSE'))
   LOOP
      DBMS_OUTPUT.put_line ('modify o7_dictionary_accessibility to false');

      EXECUTE IMMEDIATE
         'ALTER SYSTEM SET O7_DICTIONARY_ACCESSIBILITY=FALSE scope=spfile';
   END LOOP;
END;
/

/* change user password with default password */

DECLARE
   i_sql        VARCHAR2 (1000);
   i_password   VARCHAR2 (100) := 'W34ewr#d';
BEGIN
   DBMS_OUTPUT.put_line ('modify username password with default password');

   FOR c_value IN (SELECT username
                     FROM DBA_USERS_WITH_DEFPWD where username not in ('XS$NULL'))
   LOOP
      DBMS_OUTPUT.put_line (
         'modify ' || c_value.username || ' password to ' || i_password);
      i_sql :=
            'alter user '
         || c_value.username
         || ' identified by "'
         || i_password
         || '"';
      DBMS_OUTPUT.put_line (i_sql);

      EXECUTE IMMEDIATE i_sql;
   END LOOP;
END;
/

/* create function password_verify_function*/
/* Formatted on 2017/8/21 14:45:09 (QP5 v5.300) */
DECLARE
    i_count   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO i_count
      FROM dba_objects
     WHERE     object_name = UPPER ('password_verify_function')
           AND owner = 'SYS'
           AND object_type = 'FUNCTION';

    IF i_count = 0
    THEN
        EXECUTE IMMEDIATE
            '
CREATE FUNCTION password_verify_function (
   username        VARCHAR2,
   password        VARCHAR2,
   old_password    VARCHAR2)
   RETURN BOOLEAN
IS
   n                 BOOLEAN;
   m                 INTEGER;
   differ            INTEGER;
   isdigit           BOOLEAN;
   ischar            BOOLEAN;
   ispunct           BOOLEAN;
   db_name           VARCHAR2 (40);
   digitarray        VARCHAR2 (20);
   punctarray        VARCHAR2 (25);
   chararray         VARCHAR2 (52);
   chararray1        VARCHAR2 (52);
   chararray2        VARCHAR2 (52);
   i_char            VARCHAR2 (10);
   simple_password   VARCHAR2 (10);
   reverse_user      VARCHAR2 (32);
BEGIN
   digitarray := ''0123456789'';
   chararray := ''abcdefghijklmnopqrstuvwxyz'';
   chararray1 := ''ABCDEFGHIJKLMNOPQRSTUVWXYZ'';
   chararray2 := ''~!#$^&*()_+'';

   -- Check for the minimum length of the password
   IF LENGTH (password) < 8
   THEN
      raise_application_error (-20001, ''Password length less than 8'');
   END IF;


   -- Check if the password is same as the username or username(1-100)
   IF NLS_LOWER (password) = NLS_LOWER (username)
   THEN
      raise_application_error (-20002, ''Password same as or similar to user'');
   END IF;

   FOR i IN 1 .. 100
   LOOP
      i_char := TO_CHAR (i);

      IF NLS_LOWER (username) || i_char = NLS_LOWER (password)
      THEN
         raise_application_error (
            -20005,
            ''Password same as or similar to user name '');
      END IF;
   END LOOP;

   -- Check if the password is same as the username reversed

   FOR i IN REVERSE 1 .. LENGTH (username)
   LOOP
      reverse_user := reverse_user || SUBSTR (username, i, 1);
   END LOOP;

   IF NLS_LOWER (password) = NLS_LOWER (reverse_user)
   THEN
      raise_application_error (-20003, ''Password same as username reversed'');
   END IF;

   -- Check if the password is the same as server name and or servername(1-100)
   SELECT name INTO db_name FROM sys.v$database;

   IF NLS_LOWER (db_name) = NLS_LOWER (password)
   THEN
      raise_application_error (-20004,
                               ''Password same as or similar to server name'');
   END IF;

   FOR i IN 1 .. 100
   LOOP
      i_char := TO_CHAR (i);

      IF NLS_LOWER (db_name) || i_char = NLS_LOWER (password)
      THEN
         raise_application_error (
            -20005,
            ''Password same as or similar to server name '');
      END IF;
   END LOOP;

   -- Check if the password is too simple. A dictionary of words may be
   -- maintained and a check may be made so as not to allow the words
   -- that are too simple for the password.
   IF NLS_LOWER (password) IN (''welcome1'',
                               ''database1'',
                               ''account1'',
                               ''user1234'',
                               ''password1'',
                               ''oracle123'',
                               ''computer1'',
                               ''abcdefg1'',
                               ''change_on_install'')
   THEN
      raise_application_error (-20006, ''Password too simple'');
   END IF;

   -- Check if the password is the same as oracle (1-100)
   simple_password := ''oracle'';

   FOR i IN 1 .. 100
   LOOP
      i_char := TO_CHAR (i);

      IF simple_password || i_char = NLS_LOWER (password)
      THEN
         raise_application_error (-20007, ''Password too simple '');
      END IF;
   END LOOP;

   -- Check if the password contains at least one letter, one digit
   -- 1. Check for the digit
   isdigit := FALSE;
   m := LENGTH (password);

   FOR i IN 1 .. 10
   LOOP
      FOR j IN 1 .. m
      LOOP
         IF SUBSTR (password, j, 1) = SUBSTR (digitarray, i, 1)
         THEN
            isdigit := TRUE;
            GOTO findchar;
         END IF;
      END LOOP;
   END LOOP;

   IF isdigit = FALSE
   THEN
      raise_application_error (
         -20008,
         ''Password must contain at least one digit,one character,one upper character,one special character'');
   END IF;

  -- 2. Check for the character
  <<findchar>>
   ischar := FALSE;

   FOR i IN 1 .. LENGTH (chararray)
   LOOP
      FOR j IN 1 .. m
      LOOP
         IF SUBSTR (password, j, 1) = SUBSTR (chararray, i, 1)
         THEN
            ischar := TRUE;
            GOTO findchar1;
         END IF;
      END LOOP;
   END LOOP;

   IF ischar = FALSE
   THEN
      raise_application_error (-20009, ''Password must contain at least one digit,one character,one upper character,one special character'');
   END IF;

  <<findchar1>>
   ischar := FALSE;

   FOR i IN 1 .. LENGTH (chararray1)
   LOOP
      FOR j IN 1 .. m
      LOOP
         IF SUBSTR (password, j, 1) = SUBSTR (chararray1, i, 1)
         THEN
            ischar := TRUE;
            GOTO findchar2;
         END IF;
      END LOOP;
   END LOOP;

   IF ischar = FALSE
   THEN
      raise_application_error (-20009, ''Password must contain at least one digit,one character,one upper character,one special character'');
   END IF;

  <<findchar2>>
   ischar := FALSE;

   FOR i IN 1 .. LENGTH (chararray2)
   LOOP
      FOR j IN 1 .. m
      LOOP
         IF SUBSTR (password, j, 1) = SUBSTR (chararray2, i, 1)
         THEN
            ischar := TRUE;
            GOTO endsearch;
         END IF;
      END LOOP;
   END LOOP;

   IF ischar = FALSE
   THEN
      raise_application_error (-20009, ''Password must contain at least one digit,one character,one upper character,one special character'');
   END IF;
  <<endsearch>>
   -- Check if the password differs from the previous password by at least
   -- 3 letters
   IF old_password IS NOT NULL
   THEN
      differ := LENGTH (old_password) - LENGTH (password);

      differ := ABS (differ);

      IF differ < 3
      THEN
         IF LENGTH (password) < LENGTH (old_password)
         THEN
            m := LENGTH (password);
         ELSE
            m := LENGTH (old_password);
         END IF;

         FOR i IN 1 .. m
         LOOP
            IF SUBSTR (password, i, 1) != SUBSTR (old_password, i, 1)
            THEN
               differ := differ + 1;
            END IF;
         END LOOP;

         IF differ < 3
         THEN
            raise_application_error (-20011,
                                     ''Password should differ from the \
            old password by at least 3 characters'');
         END IF;
      END IF;
   END IF;

   -- Everything is fine; return TRUE ;
   RETURN (TRUE);
END;
'        ;
    ELSE
        DBMS_OUTPUT.put_line ('password_verify_function is exists');
    END IF;
END;
/

/* create profile profile_user or change profile_user  to  password_verify_function */

/* Formatted on 2017/9/5 23:08:49 (QP5 v5.300) */
DECLARE
    i_sql       VARCHAR2 (1000);
    i_count     NUMBER;
    i_version   VARCHAR2 (12);
    i_pdbname   VARCHAR2 (100);
BEGIN
    SELECT SUBSTR (banner, INSTR (banner, '.', 1) - 2, 8)
      INTO i_version
      FROM v$version
     WHERE banner LIKE 'Oracle Database%';

    SELECT COUNT (*)
      INTO i_count
      FROM dba_objects a
     WHERE     a.owner = 'SYS'
           AND a.object_name = UPPER ('password_verify_function')
           AND a.object_type = 'FUNCTION';

    IF i_count > 0
    THEN
        IF i_version IN ('12.1.0.2', '12.1.0.1', '12.2.0.1')
        THEN
            SELECT SYS_CONTEXT ('USERENV', 'CON_NAME')
              INTO i_pdbname
              FROM DUAL;

            IF i_pdbname = 'CDB$ROOT'
            THEN
                SELECT COUNT (*)
                  INTO i_count
                  FROM dba_profiles
                 WHERE profile = UPPER ('C##PROFILE_USER');
            ELSE
                SELECT COUNT (*)
                  INTO i_count
                  FROM dba_profiles
                 WHERE profile = UPPER ('PROFILE_USER');
            END IF;
        ELSE
            SELECT COUNT (*)
              INTO i_count
              FROM dba_profiles
             WHERE profile = UPPER ('PROFILE_USER');
        END IF;

        IF i_count < 1
        THEN
            IF i_version IN ('12.1.0.2', '12.1.0.1', '12.2.0.1')
            THEN
                SELECT SYS_CONTEXT ('USERENV', 'CON_NAME')
                  INTO i_pdbname
                  FROM DUAL;

                IF i_pdbname = 'CDB$ROOT'
                THEN
                    i_sql :=
                        'create PROFILE c##profile_user LIMIT  PASSWORD_LIFE_TIME 80  PASSWORD_GRACE_TIME 10  PASSWORD_REUSE_TIME 360   PASSWORD_REUSE_MAX 3  FAILED_LOGIN_ATTEMPTS 5  PASSWORD_LOCK_TIME 20 PASSWORD_VERIFY_FUNCTION password_verify_function';
                ELSE
                    i_sql :=
                        'create PROFILE profile_user LIMIT  PASSWORD_LIFE_TIME 80  PASSWORD_GRACE_TIME 10  PASSWORD_REUSE_TIME 360   PASSWORD_REUSE_MAX 3  FAILED_LOGIN_ATTEMPTS 5  PASSWORD_LOCK_TIME 20 PASSWORD_VERIFY_FUNCTION password_verify_function';
                END IF;
            ELSE
                i_sql :=
                    'create PROFILE profile_user LIMIT  PASSWORD_LIFE_TIME 80  PASSWORD_GRACE_TIME 10  PASSWORD_REUSE_TIME 360   PASSWORD_REUSE_MAX 3  FAILED_LOGIN_ATTEMPTS 5  PASSWORD_LOCK_TIME 20 PASSWORD_VERIFY_FUNCTION password_verify_function';
            END IF;

            DBMS_OUTPUT.put_line (i_sql);

            EXECUTE IMMEDIATE i_sql;
        END IF;

        IF i_version IN ('12.1.0.2', '12.1.0.1', '12.2.0.1')
        THEN
            SELECT SYS_CONTEXT ('USERENV', 'CON_NAME')
              INTO i_pdbname
              FROM DUAL;

            IF i_pdbname = 'CDB$ROOT'
            THEN
                FOR c_value
                    IN (SELECT profile
                          FROM dba_profiles
                         WHERE     resource_name = 'PASSWORD_VERIFY_FUNCTION'
                               AND LIMIT NOT IN ('PASSWORD_VERIFY_FUNCTION'))
                LOOP
                    i_sql :=
                           'alter profile '
                        || c_value.profile
                        || ' LIMIT PASSWORD_VERIFY_FUNCTION password_verify_function';
                    DBMS_OUTPUT.put_line (i_sql);

                    EXECUTE IMMEDIATE i_sql;
                END LOOP;
            ELSE
                FOR c_value
                    IN (SELECT profile
                          FROM dba_profiles
                         WHERE     resource_name = 'PASSWORD_VERIFY_FUNCTION'
                               AND profile NOT LIKE 'C##P%'
                               AND LIMIT NOT IN ('PASSWORD_VERIFY_FUNCTION'))
                LOOP
                    i_sql :=
                           'alter profile '
                        || c_value.profile
                        || ' LIMIT PASSWORD_VERIFY_FUNCTION password_verify_function';
                    DBMS_OUTPUT.put_line (i_sql);

                    EXECUTE IMMEDIATE i_sql;
                END LOOP;
            END IF;
        ELSE
            FOR c_value
                IN (SELECT profile
                      FROM dba_profiles
                     WHERE     resource_name = 'PASSWORD_VERIFY_FUNCTION'
                           AND LIMIT NOT IN ('PASSWORD_VERIFY_FUNCTION'))
            LOOP
                i_sql :=
                       'alter profile '
                    || c_value.profile
                    || ' LIMIT PASSWORD_VERIFY_FUNCTION password_verify_function';
                DBMS_OUTPUT.put_line (i_sql);

                EXECUTE IMMEDIATE i_sql;
            END LOOP;
        END IF;
    END IF;
END;
/

/* change default user profile to profile_user */

DECLARE
   i_sql     VARCHAR2 (1000);
   i_count   NUMBER;
BEGIN
   DBMS_OUTPUT.put_line ('modify username profile with default profile');

   SELECT COUNT (*)
     INTO i_count
     FROM dba_profiles
    WHERE profile = UPPER ('PROFILE_USER');

   IF i_count > 0
   THEN
      FOR c_value
         IN (SELECT username
               FROM dba_users
              WHERE     profile NOT IN ('PROFILE_USER')
                    AND account_status IN
                           ('LOCKED', 'EXPIRED ' || CHR (38) || ' LOCKED')
                    AND username NOT IN ('DBSNMP', 'XS$NULL')
                    AND username IN ('OLAPSYS',
                                     'SI_INFORMTN_SCHEMA',
                                     'MGMT_VIEW',
                                     'OWBSYS',
                                     'ORDPLUGINS',
                                     'SPATIAL_WFS_ADMIN_USR',
                                     'SPATIAL_CSW_ADMIN_USR',
                                     'XDB',
                                     'SYSMAN',
                                     'APEX_PUBLIC_USER',
                                     'DIP',
                                     'OUTLN',
                                     'ANONYMOUS',
                                     'CTXSYS',
                                     'ORDDATA',
                                     'MDDATA',
                                     'OWBSYS_AUDIT',
                                     'APEX_030200',
                                     'XS$NULL',
                                     'APPQOSSYS',
                                     'ORACLE_OCM',
                                     'WMSYS',
                                     'SCOTT',
                                     'DBSNMP',
                                     'EXFSYS',
                                     'ORDSYS',
                                     'MDSYS',
                                     'FLOWS_FILES',
                                     'SYSTEM'))
      LOOP
         DBMS_OUTPUT.put_line (
            'modify ' || c_value.username || ' profile to PROFILE_USER ');
         i_sql :=
            'alter user "' || c_value.username || '" profile profile_user';
         DBMS_OUTPUT.put_line (i_sql);

         EXECUTE IMMEDIATE i_sql;
      END LOOP;

      EXECUTE IMMEDIATE 'alter user system profile profile_user';
      select count(*) into i_count from v$dataguard_config where db_unique_name not in (select db_unique_name from v$database);
      if i_count=0 then
      EXECUTE IMMEDIATE 'alter user sys profile profile_user';
      end if;
   END IF;
END;
/


/* change default profile value */

DECLARE
   i_sql     VARCHAR2 (1000);
   i_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO i_count
     FROM dba_objects a
    WHERE     a.owner = 'SYS'
          AND a.object_name = UPPER ('password_verify_function')
          AND a.object_type = 'FUNCTION';

   IF i_count > 0
   THEN
      SELECT COUNT (*)
        INTO i_count
        FROM dba_profiles
       WHERE     profile = 'DEFAULT'
             AND (   (    resource_name = 'PASSWORD_LIFE_TIME'
                      AND LIMIT NOT IN ('UNLIMITED'))
                  OR (    resource_name = 'FAILED_LOGIN_ATTEMPTS'
                      AND LIMIT NOT IN ('UNLIMITED'))
                  OR (    resource_name = 'PASSWORD_REUSE_MAX'
                      AND LIMIT NOT IN ('10'))
                  OR (    resource_name = 'PASSWORD_VERIFY_FUNCTION'
                      AND LIMIT NOT IN ('PASSWORD_VERIFY_FUNCTION'))
                  OR (    resource_name = 'PASSWORD_LOCK_TIME'
                      AND LIMIT NOT IN ('UNLIMITED'))
                  OR (    resource_name = 'PASSWORD_GRACE_TIME'
                      AND LIMIT NOT IN ('UNLIMITED')));

      IF i_count > 0
      THEN
         FOR c_value
            IN (SELECT resource_name
                  INTO i_count
                  FROM dba_profiles
                 WHERE     profile = 'DEFAULT'
                       AND (   (    resource_name = 'PASSWORD_LIFE_TIME'
                                AND LIMIT NOT IN ('UNLIMITED'))
                            OR (    resource_name = 'FAILED_LOGIN_ATTEMPTS'
                                AND LIMIT NOT IN ('UNLIMITED'))
                            OR (    resource_name = 'PASSWORD_REUSE_MAX'
                                AND LIMIT NOT IN ('10'))
                            OR (    resource_name =
                                       'PASSWORD_VERIFY_FUNCTION'
                                AND LIMIT NOT IN ('PASSWORD_VERIFY_FUNCTION'))
                            OR (    resource_name = 'PASSWORD_LOCK_TIME'
                                AND LIMIT NOT IN ('UNLIMITED'))
                            OR (    resource_name = 'PASSWORD_GRACE_TIME'
                                AND LIMIT NOT IN ('UNLIMITED'))))
         LOOP
            IF c_value.resource_name = 'PASSWORD_LIFE_TIME'
            THEN
               DBMS_OUTPUT.put_line (
                  'alter profile default limit PASSWORD_LIFE_TIME  UNLIMITED');

               EXECUTE IMMEDIATE
                  'alter profile default limit PASSWORD_LIFE_TIME  UNLIMITED';
            END IF;

            IF c_value.resource_name = 'FAILED_LOGIN_ATTEMPTS'
            THEN
               DBMS_OUTPUT.put_line (
                  'alter profile default limit FAILED_LOGIN_ATTEMPTS  UNLIMITED');

               EXECUTE IMMEDIATE
                  'alter profile default limit FAILED_LOGIN_ATTEMPTS  UNLIMITED';
            END IF;

            IF c_value.resource_name = 'PASSWORD_REUSE_MAX'
            THEN
               DBMS_OUTPUT.put_line (
                  'alter profile default limit  PASSWORD_REUSE_MAX 10');

               EXECUTE IMMEDIATE
                  'alter profile default limit  PASSWORD_REUSE_MAX 10';
            END IF;

            IF c_value.resource_name = 'PASSWORD_VERIFY_FUNCTION'
            THEN
               DBMS_OUTPUT.put_line (
                  'alter profile default limit PASSWORD_VERIFY_FUNCTION PASSWORD_VERIFY_FUNCTION');

               EXECUTE IMMEDIATE
                  'alter profile default limit PASSWORD_VERIFY_FUNCTION PASSWORD_VERIFY_FUNCTION';
            END IF;

            IF c_value.resource_name = 'PASSWORD_LOCK_TIME'
            THEN
               DBMS_OUTPUT.put_line (
                  'alter profile default limit PASSWORD_LOCK_TIME  UNLIMITED');

               EXECUTE IMMEDIATE
                  'alter profile default limit PASSWORD_LOCK_TIME  UNLIMITED';
            END IF;

            IF c_value.resource_name = 'PASSWORD_GRACE_TIME'
            THEN
               DBMS_OUTPUT.put_line (
                  'alter profile default limit PASSWORD_GRACE_TIME  UNLIMITED');

               EXECUTE IMMEDIATE
                  'alter profile default limit PASSWORD_GRACE_TIME  UNLIMITED';
            END IF;
         END LOOP;
      END IF;
   END IF;
END;
/


/* create table audit_login_db and tab_log for login trigger record */

DECLARE
    i_sql      VARCHAR2 (4000);
    i_number   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO i_number
      FROM dba_tables
     WHERE table_name = 'AUDIT_LOGIN_DB' AND owner = 'SYSTEM';
    DBMS_OUTPUT.PUT_LINE('create table system.audit_login_db');
    IF i_number = 0
    THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SYSTEM.AUDIT_LOGIN_DB
(
    SERVER_HOST       VARCHAR2 (30),
    SERVER_IP_ADDR    VARCHAR2 (20),
    DB_UNIQUE_NAME    VARCHAR2 (30),
    INSTANCE_NAME     VARCHAR2 (30),
    SESSION_ID        NUMBER,
    SID               NUMBER,
    SESSION_SERIAL#   NUMBER,
    OS_USER           VARCHAR2 (200),
    CLIENT_IP_ADDR    VARCHAR2 (200),
    TERMINAL          VARCHAR2 (200),
    HOST              VARCHAR2 (200),
    USER_NAME         VARCHAR2 (30),
    LOGON_DATE        DATE,
    LOGOFF_DATE       DATE,
    ELAPSED_SECONDS   NUMBER,
    MODULE            VARCHAR2 (50),
    DBLINK_INFO       VARCHAR2 (100),
    PROGRAM           VARCHAR2 (100),
    MESSAGE           VARCHAR2 (50),
    SERVICE_NAME      VARCHAR2 (30)
)
PARTITION BY RANGE
    (LOGON_DATE)
    INTERVAL ( NUMTOYMINTERVAL (1, ''MONTH'') )
    (PARTITION
         PART_201410
         VALUES LESS THAN
             (TO_DATE (''2014-11-01 00:00:00'', ''SYYYY-MM-DD HH24:MI:SS'')))';

        EXECUTE IMMEDIATE 'CREATE INDEX SYSTEM.IX_AUDIT_LOGIN_SESSIONID
    ON SYSTEM.AUDIT_LOGIN_DB (SESSION_ID)
    LOCAL';
    ELSE
        DBMS_OUTPUT.put_line ('TABLE AUDIT_LOGIN_DB is exits;');
    END IF;

    SELECT COUNT (*)
      INTO i_number
      FROM dba_tables
     WHERE table_name = 'TAB_LOG' AND owner = 'SYSTEM';

    IF i_number = 0
    THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SYSTEM.tab_log
(
    log_date   DATE,
    flag       VARCHAR2 (200),
    msg        VARCHAR2 (150),
    errcode    NUMBER
)'       ;
      dbms_output.put_line('success for create system.audit_login_db ');
    ELSE
        DBMS_OUTPUT.put_line ('TABLE TAB_LOG is exits;');
    END IF;
END;
/


/* create login trigger login_audit_trigger */

DECLARE
    i_number   NUMBER;
    i_output   varchar2(1000);
BEGIN
    SELECT COUNT (*)
      INTO i_number
      FROM dba_triggers
     WHERE TRIGGER_NAME = 'LOGIN_AUDIT_TRIGGER' AND owner = 'SYS';

    IF i_number = 0
    THEN
        DBMS_OUTPUT.PUT_LINE('trigger login_audit_trigger is not exits');
        SELECT COUNT (*)
          INTO i_number
          FROM dba_tables
         WHERE owner = 'SYSTEM' AND table_name = 'AUDIT_LOGIN_DB';

        IF i_number = 1
        THEN
            SELECT COUNT (*)
              INTO i_number
              FROM dba_tables
             WHERE owner = 'SYSTEM' AND table_name = 'TAB_LOG';

            IF i_number = 1
            THEN
                EXECUTE IMMEDIATE
                    'CREATE  TRIGGER SYS.LOGIN_AUDIT_TRIGGER
    AFTER LOGON
    ON DATABASE
DECLARE
    Session_Id_Var       NUMBER;
    Os_User_Var          VARCHAR2 (200);
    IP_Address_Var       VARCHAR2 (200);
    Terminal_Var         VARCHAR2 (200);
    Host_Var             VARCHAR2 (200);
    SID_Num              NUMBER;
    DBLINK_Info_Var      VARCHAR2 (100);
    Module_Var           VARCHAR2 (50);
    SERVER_HOST_Var      VARCHAR2 (30);
    SERVER_IP_ADDR_Var   VARCHAR2 (20);
    DB_UNIQUE_NAME_Var   VARCHAR2 (30);
    INSTANCE_NAME_Var    VARCHAR2 (30);
    Service_Name_Var     VARCHAR2 (30);
    Version_Var          VARCHAR2 (10);
    v_messages           VARCHAR2 (100);
    n_errcode            NUMBER;
    n_roles              NUMBER;
BEGIN

    SELECT COUNT (*)
      INTO n_roles
      FROM v$database
     WHERE database_role = ''PRIMARY'';


    SELECT SUBSTR (version, 1, INSTR (version, ''.'', 1) - 1)
      INTO Version_Var
      FROM dba_registry
     WHERE comp_id = ''CATALOG'';

    IF n_roles = 1
    THEN
        IF Version_Var <= ''10''
        THEN
            SELECT '''', --SUBSTR (UTL_INADDR.GET_HOST_ADDRESS, 1, 20),
                   SYS_CONTEXT (''USERENV'', ''SESSIONID''),
                   SYS_CONTEXT (''USERENV'', ''OS_USER''),
                   SYS_CONTEXT (''USERENV'', ''IP_ADDRESS''),
                   '''', --SYS_CONTEXT (''USERENV'', ''TERMINAL''),
                   SYS_CONTEXT (''USERENV'', ''HOST''),
                   SYS_CONTEXT (''USERENV'', ''SID''),
                   '''', --SUBSTR(SYS_CONTEXT(''USERENV'',''DBLINK_INFO''),1,100),
                   SUBSTR (SYS_CONTEXT (''USERENV'', ''MODULE''), 1, 50),
                   SUBSTR (SYS_CONTEXT (''USERENV'', ''SERVER_HOST''), 1, 30),
                   '''', --SUBSTR (SYS_CONTEXT (''USERENV'', ''DB_UNIQUE_NAME''), 1, 30),
                   '''', --SUBSTR (SYS_CONTEXT (''USERENV'', ''INSTANCE_NAME''), 1, 30),
                   SUBSTR (SYS_CONTEXT (''USERENV'', ''SERVICE_NAME''), 1, 30)
              INTO SERVER_IP_ADDR_Var,
                   Session_Id_Var,
                   Os_User_Var,
                   IP_Address_Var,
                   Terminal_Var,
                   Host_Var,
                   SID_Num,
                   DBLINK_Info_Var,
                   Module_Var,
                   SERVER_HOST_Var,
                   DB_UNIQUE_NAME_Var,
                   INSTANCE_NAME_Var,
                   Service_Name_Var
              FROM DUAL;
        ELSE
            SELECT '''', --SUBSTR (UTL_INADDR.GET_HOST_ADDRESS, 1, 20),
                   SYS_CONTEXT (''USERENV'', ''SESSIONID''),
                   SYS_CONTEXT (''USERENV'', ''OS_USER''),
                   SYS_CONTEXT (''USERENV'', ''IP_ADDRESS''),
                   '''',      --SYS_CONTEXT (''USERENV'', ''TERMINAL''),
                   SYS_CONTEXT (''USERENV'', ''HOST''),
                   SYS_CONTEXT (''USERENV'', ''SID''),
                   SUBSTR (SYS_CONTEXT (''USERENV'', ''DBLINK_INFO''), 1, 100),
                   SUBSTR (SYS_CONTEXT (''USERENV'', ''MODULE''), 1, 50),
                   SUBSTR (SYS_CONTEXT (''USERENV'', ''SERVER_HOST''), 1, 30),
                   '''', --SUBSTR (SYS_CONTEXT (''USERENV'', ''DB_UNIQUE_NAME''), 1, 30),
                   '''', --SUBSTR (SYS_CONTEXT (''USERENV'', ''INSTANCE_NAME''), 1, 30),
                   SUBSTR (SYS_CONTEXT (''USERENV'', ''SERVICE_NAME''), 1, 30)
              INTO SERVER_IP_ADDR_Var,
                   Session_Id_Var,
                   Os_User_Var,
                   IP_Address_Var,
                   Terminal_Var,
                   Host_Var,
                   SID_Num,
                   DBLINK_Info_Var,
                   Module_Var,
                   SERVER_HOST_Var,
                   DB_UNIQUE_NAME_Var,
                   INSTANCE_NAME_Var,
                   Service_Name_Var
              FROM DUAL;
        END IF;


         /* INSERT INTO SYSTEM.Audit_Login_DB (SERVER_HOST,
                                           SERVER_IP_ADDR,
                                           DB_UNIQUE_NAME,
                                           INSTANCE_NAME,
                                           Session_Id,
                                           SID,
                                           Session_serial#,
                                           OS_User,
                                           CLIENT_IP_ADDR,
                                           Terminal,
                                           HOST,
                                           User_Name,
                                           LogOn_Date,
                                           LogOff_Date,
                                           Elapsed_Seconds,
                                           Module,
                                           DBLINK_Info,
                                           service_name)
             VALUES (SERVER_HOST_Var,
                     SERVER_IP_ADDR_Var,
                     DB_UNIQUE_NAME_Var,
                     INSTANCE_NAME_Var,
                     Session_Id_Var,
                     SID_Num,
                     NULL,
                     Os_User_Var,
                     IP_Address_Var,
                     Terminal_Var,
                     Host_Var,
                     USER,
                     SYSDATE,
                     NULL,
                     NULL,
                     Module_Var,
                     DBLINK_Info_Var,
                     Service_Name_Var); */
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        --NULL;
        v_messages := SUBSTR (SQLERRM, 1, 100);
        n_errcode := SQLCODE;

        IF n_roles = 1
        THEN
            INSERT INTO SYSTEM.tab_log (log_date,
                                        flag,
                                        msg,
                                        errcode)
                 VALUES (SYSDATE,
                         ''Recorded Login Event Failed!'',
                         v_messages,
                         n_errcode);

            COMMIT;
        END IF;
END Login_Audit_Trigger;
'                ;
            END IF;
        END IF;
    ELSE
        DBMS_OUTPUT.put_line ('trggier Login_Audit_Trigger is Exits');
    END IF;

    SELECT COUNT (*)
      INTO i_number
      FROM dba_objects
     WHERE     object_name = 'LOGIN_AUDIT_TRIGGER'
           AND object_type = 'TRIGGER'
           AND created > SYSDATE - 1 / 24;

    IF i_number = 1
    THEN
        EXECUTE IMMEDIATE 'alter trigger sys.Login_Audit_Trigger disable';
        select status into i_output from dba_triggers where trigger_name='LOGIN_AUDIT_TRIGGER';
        DBMS_OUTPUT.put_line('LOGIN_AUDIT_TRIGGER STATUS is :'||i_output);
    ELSE
       select to_char(created,'yyyy-mm-dd hh24:mi:ss') into i_output from dba_objects where object_name='LOGIN_AUDIT_TRIGGER' and object_type = 'TRIGGER';
       dbms_output.put_line('LOGIN_AUDIT_TRIGGER create time : '||i_output);
    END IF;
END;
/

