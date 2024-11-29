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
    flag       VARCHAR2 (40),
    msg        VARCHAR2 (150),
    errcode    NUMBER
)'       ;
      dbms_output.put_line('success for create system.audit_login_db ');
    ELSE
        DBMS_OUTPUT.put_line ('TABLE TAB_LOG is exits;');
    END IF;
END;
/


/* Formatted on 2017/8/21 12:02:24 (QP5 v5.300) */
DECLARE
    i_number   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO i_number
      FROM dba_triggers
     WHERE TRIGGER_NAME = 'LOGIN_AUDIT_TRIGGER' AND owner = 'SYS';

    IF i_number = 0
    THEN
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
            /* 获取登陆用户信息 */
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

        /* 记录登陆审计信息 */
        INSERT INTO SYSTEM.Audit_Login_DB (SERVER_HOST,
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
                     Service_Name_Var);
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
        EXECUTE IMMEDIATE 'alter trigger Login_Audit_Trigger disable';
    END IF;
END;
/