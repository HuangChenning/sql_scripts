/* Formatted on 2016/5/3 20:40:12 (QP5 v5.256.13226.35510) */
CREATE OR REPLACE TRIGGER "SYS"."LOGON_DENIED"
   AFTER SERVERERROR
   ON DATABASE
/*
||���ƣ��Ự��½ʧ���¼���ƴ�����
||˵����
*/
DECLARE
   Session_Id_Var       NUMBER;                                     /* �ỰID */
   Os_User_Var          VARCHAR2 (200);                           /* �ն�OS�û� */
   IP_Address_Var       VARCHAR2 (200);                             /* �ն�IP */
   Terminal_Var         VARCHAR2 (200);                               /* �ն� */
   Host_Var             VARCHAR2 (200);                            /* �ն������� */
   SID_Num              NUMBER;
   DBLINK_Info_Var      VARCHAR2 (100);
   Module_Var           VARCHAR2 (50);
   SERVER_HOST_Var      VARCHAR2 (30);
   SERVER_IP_ADDR_Var   VARCHAR2 (20);
   DB_UNIQUE_NAME_Var   VARCHAR2 (30);
   INSTANCE_NAME_Var    VARCHAR2 (30);
   Session_User_Var     VARCHAR2 (30);
   Program_Var          VARCHAR2 (30);
   Version_Var          VARCHAR2 (10);
   Service_Name_Var     VARCHAR2 (30);
   v_messages           VARCHAR2 (100);
   n_errcode            NUMBER;
   n_roles              NUMBER;
BEGIN
   IF (ora_is_servererror (1017))
   THEN
      --��ȡActive DataGuard�Ľ�ɫ��ֻ�н�ɫΪPRIMARY�Ĳ���ִ�д������Ķ���
      SELECT COUNT (*)
        INTO n_roles
        FROM v$database
       WHERE database_role = 'PRIMARY';

      --��ȡ�汾��Ϣ
      SELECT SUBSTR (version, 1, INSTR (version, '.', 1) - 1)
        INTO Version_Var
        FROM dba_registry
       WHERE comp_id = 'CATALOG';

      IF n_roles = 1
      THEN
         /* ��ȡ��½�û���Ϣ */
         IF Version_Var <= '10'
         THEN
            SELECT '', --SUBSTR (UTL_INADDR.GET_HOST_ADDRESS, 1, 20),               /*ȡ����¼*/
                   SYS_CONTEXT ('USERENV', 'SESSIONID'),
                   SYS_CONTEXT ('USERENV', 'OS_USER'),
                   SYS_CONTEXT ('USERENV', 'IP_ADDRESS'),
                   '', --SYS_CONTEXT ('USERENV', 'TERMINAL'),                       /*ȡ����¼*/
                   SYS_CONTEXT ('USERENV', 'HOST'),
                   SYS_CONTEXT ('USERENV', 'SID'),
                   '', --SUBSTR(SYS_CONTEXT('USERENV','DBLINK_INFO'),1,100),   /*10G������,��Ҫ�ÿ�ֵ�滻*/
                   SUBSTR (SYS_CONTEXT ('USERENV', 'MODULE'), 1, 50),
                   SUBSTR (SYS_CONTEXT ('USERENV', 'SERVER_HOST'), 1, 30),
                   '', --SUBSTR (SYS_CONTEXT ('USERENV', 'DB_UNIQUE_NAME'), 1, 30), /*ȡ����¼*/
                   '', --SUBSTR (SYS_CONTEXT ('USERENV', 'INSTANCE_NAME'), 1, 30),  /*ȡ����¼*/
                   SYS_CONTEXT ('USERENV', 'SESSION_USER'),
                   SUBSTR (SYS_CONTEXT ('USERENV', 'SERVICE_NAME'), 1, 30)
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
                   Session_User_Var,
                   Service_Name_Var
              FROM DUAL;
         ELSE
            SELECT '', --SUBSTR (UTL_INADDR.GET_HOST_ADDRESS, 1, 20),               /*ȡ����¼*/
                   SYS_CONTEXT ('USERENV', 'SESSIONID'),
                   SYS_CONTEXT ('USERENV', 'OS_USER'),
                   SYS_CONTEXT ('USERENV', 'IP_ADDRESS'),
                   '', --SYS_CONTEXT ('USERENV', 'TERMINAL'),                       /*ȡ����¼*/
                   SYS_CONTEXT ('USERENV', 'HOST'),
                   SYS_CONTEXT ('USERENV', 'SID'),
                   SUBSTR (SYS_CONTEXT ('USERENV', 'DBLINK_INFO'), 1, 100),
                   SUBSTR (SYS_CONTEXT ('USERENV', 'MODULE'), 1, 50),
                   SUBSTR (SYS_CONTEXT ('USERENV', 'SERVER_HOST'), 1, 30),
                   '', --SUBSTR (SYS_CONTEXT ('USERENV', 'DB_UNIQUE_NAME'), 1, 30), /*ȡ����¼*/
                   '', --SUBSTR (SYS_CONTEXT ('USERENV', 'INSTANCE_NAME'), 1, 30),  /*ȡ����¼*/
                   SYS_CONTEXT ('USERENV', 'SESSION_USER'),
                   SUBSTR (SYS_CONTEXT ('USERENV', 'SERVICE_NAME'), 1, 30)
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
                   Session_User_Var,
                   Service_Name_Var
              FROM DUAL;
         END IF;

         SELECT program
           INTO Program_Var
           FROM v$session
          WHERE sid = SID_Num;

         /* ��¼��½�����Ϣ */
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
                                            Program,
                                            MESSAGE,
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
                      Session_User_Var,
                      SYSDATE,
                      NULL,
                      NULL,
                      Module_Var,
                      DBLINK_Info_Var,
                      Program_Var,
                      'Logon Denied!',
                      Service_Name_Var);
      END IF;
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
                      'Recorded LoginFailed  Event Failed!',
                      v_messages,
                      n_errcode);

         COMMIT;
      END IF;
END logon_denied;