/* Formatted on 2016/5/3 20:39:34 (QP5 v5.256.13226.35510) */
CREATE OR REPLACE TRIGGER "SYS"."LOGOFF_AUDIT_TRIGGER"
   BEFORE LOGOFF
   ON DATABASE
/*
||名称：会话登离事件审计触发器
||说明：
*/
DECLARE
   Session_Id_Var        NUMBER;                                    /* 会话ID */
   SID_Num               NUMBER;
   Session_Serial#_Num   NUMBER;
   Program_Var           VARCHAR2 (100);
   v_messages            VARCHAR2 (100);
   n_errcode             NUMBER;
   n_roles               NUMBER;
BEGIN
   --获取Active DataGuard的角色：只有角色为PRIMARY的才能执行触发器的动作
   SELECT COUNT (*)
     INTO n_roles
     FROM v$database
    WHERE database_role = 'PRIMARY';

   /* 获取登陆用户信息 */
   IF N_ROLES = 1
   THEN
      SELECT SYS_CONTEXT ('USERENV', 'SESSIONID'),
             SYS_CONTEXT ('USERENV', 'SID')
        INTO Session_Id_Var, SID_Num
        FROM DUAL;

      SELECT SERIAL#, Program
        INTO SESSION_SERIAL#_NUM, Program_Var
        FROM V$SESSION
       WHERE SID = SID_NUM;

      /* 更新会话审计记录信息 */
      UPDATE SYSTEM.Audit_Login_DB
         SET LogOff_Date = SYSDATE,
             Elapsed_Seconds = (SYSDATE - LogOn_Date) * 86400,
             Session_serial# = Session_Serial#_Num,
             Program = Program_Var
       WHERE Session_Id = Session_Id_Var AND Session_serial# IS NULL;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      --NULL;
      v_messages := SUBSTR (SQLERRM, 1, 100);
      n_errcode := SQLCODE;

      IF N_ROLES = 1
      THEN
         INSERT INTO SYSTEM.tab_log (log_date,
                                     flag,
                                     msg,
                                     errcode)
              VALUES (SYSDATE,
                      'Recorded LogOff Event Failed!',
                      v_messages,
                      n_errcode);

         COMMIT;
      END IF;
END LogOff_Audit_Trigger;