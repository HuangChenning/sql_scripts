  CREATE OR REPLACE TRIGGER "SYS"."DDL_AUDIT_TRIGGER"
   AFTER DDL
   ON DATABASE
DECLARE
   Session_Id_Var       NUMBER;
   Os_User_Var          VARCHAR2 (200);
   Client_IP_Addr_Var   VARCHAR2 (200);
   Terminal_Var         VARCHAR2 (200);
   Host_Var             VARCHAR2 (200);
   Cut                  NUMBER;
   Sql_Text             ORA_NAME_LIST_T;
   L_Trace              NUMBER;
   DDL_Sql_Var          VARCHAR2 (2000);
   SERVER_HOST_Var      VARCHAR2 (30);
   SERVER_IP_ADDR_Var   VARCHAR2 (20);
   DB_UNIQUE_NAME_Var   VARCHAR2 (30);
   INSTANCE_NAME_Var    VARCHAR2 (30);
   Version_Var          VARCHAR2 (10);
   SID_Num              NUMBER;
   Service_Name_Var     VARCHAR2 (30);
   v_messages           VARCHAR2 (100);
   n_errcode            NUMBER;
   n_roles              NUMBER;
BEGIN
   --获取Active DataGuard的角色：只有角色为PRIMARY的才能执行触发器的动作
   SELECT COUNT (*)
     INTO n_roles
     FROM v$database
    WHERE database_role = 'PRIMARY';

   IF n_roles = 1
   THEN
      SELECT SUBSTR (SYS_CONTEXT ('USERENV', 'SERVER_HOST'), 1, 30),
             '', --SUBSTR (UTL_INADDR.GET_HOST_ADDRESS, 1, 20),                     /*取消记录*/
             '', --SUBSTR (SYS_CONTEXT ('USERENV', 'DB_UNIQUE_NAME'), 1, 30),       /*取消记录*/
             SUBSTR (SYS_CONTEXT ('USERENV', 'INSTANCE_NAME'), 1, 30),
             SYS_CONTEXT ('USERENV', 'SESSIONID'),
             SYS_CONTEXT ('USERENV', 'OS_USER'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS'),
             '', --SYS_CONTEXT ('USERENV', 'TERMINAL'),                             /*取消记录*/
             SYS_CONTEXT ('USERENV', 'HOST'),
             SUBSTR (SYS_CONTEXT ('USERENV', 'SERVICE_NAME'), 1, 30),
             SYS_CONTEXT ('USERENV', 'SID')
        INTO SERVER_HOST_Var,
             SERVER_IP_ADDR_Var,
             DB_UNIQUE_NAME_Var,
             INSTANCE_NAME_Var,
             Session_Id_Var,
             Os_User_Var,
             Client_IP_Addr_Var,
             Terminal_Var,
             Host_Var,
             Service_Name_Var,
             SID_Num
        FROM DUAL;


      BEGIN
         SELECT COUNT (*)
           INTO L_Trace
           FROM DUAL
          WHERE ORA_DICT_OBJ_NAME NOT LIKE 'ORA_TEMP%'
                AND ORA_DICT_OBJ_NAME NOT LIKE '%LOG';

         /*
               AND UTL_INADDR.GET_HOST_ADDRESS IS NOT NULL
               AND SYS_CONTEXT ('USERENV', 'IP_ADDRESS') IS NOT NULL
               AND SYS_CONTEXT ('USERENV', 'IP_ADDRESS') <>
                      UTL_INADDR.GET_HOST_ADDRESS;
        */
         IF L_Trace > 0
         THEN
            Cut := ORA_SQL_TXT (Sql_Text);

            FOR i IN 1 .. Cut
            LOOP
               DDL_Sql_Var := SUBSTR (DDL_Sql_Var || Sql_Text (i), 1, 2000);
            END LOOP;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;


      INSERT INTO SYSTEM.Audit_DDL_OBJ (SERVER_HOST,
                                        SERVER_IP_ADDR,
                                        DB_UNIQUE_NAME,
                                        INSTANCE_NAME,
                                        Opr_Time,
                                        Session_Id,
                                        OS_User,
                                        Client_IP_Addr,
                                        Terminal,
                                        HOST,
                                        User_Name,
                                        DDL_Type,
                                        DDL_Sql,
                                        Object_Type,
                                        Owner,
                                        Object_Name,
                                        service_name,
                                        sid)
           VALUES (SERVER_HOST_Var,
                   SERVER_IP_ADDR_Var,
                   DB_UNIQUE_NAME_Var,
                   INSTANCE_NAME_Var,
                   SYSDATE,
                   Session_Id_Var,
                   Os_User_Var,
                   Client_IP_Addr_Var,
                   Terminal_Var,
                   Host_Var,
                   ORA_LOGIN_USER,
                   ORA_SYSEVENT,
                   DDL_Sql_Var,
                   ORA_DICT_OBJ_TYPE,
                   ORA_DICT_OBJ_OWNER,
                   ORA_DICT_OBJ_NAME,
                   Service_Name_Var,
                   SID_Num);
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
                      'Recorded DDL Operation Event Failed!',
                      v_messages,
                      n_errcode);

         COMMIT;
      END IF;
END DDL_Audit_Trigger;