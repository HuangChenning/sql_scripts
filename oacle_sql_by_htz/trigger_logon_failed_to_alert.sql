CREATE OR REPLACE TRIGGER logon_failed_to_alert
   AFTER SERVERERROR
   ON DATABASE
DECLARE
   MESSAGE     VARCHAR2 (168);
   ip          VARCHAR2 (15);
   v_os_user   VARCHAR2 (80);
   v_module    VARCHAR2 (50);
   v_action    VARCHAR2 (50);
   v_pid       VARCHAR2 (10);
   v_sid       NUMBER;
   v_program   VARCHAR2 (48);
BEGIN
   IF (ora_is_servererror (1017))
   THEN
      -- get ip FOR remote connections :
      IF UPPER (SYS_CONTEXT ('userenv', 'network_protocol')) = 'TCP'
      THEN
         ip := SYS_CONTEXT ('userenv', 'ip_address');
      END IF;

      SELECT sid
        INTO v_sid
        FROM sys.v_$mystat
       WHERE ROWNUM < 2;

      SELECT p.spid, v.program
        INTO v_pid, v_program
        FROM v$process p, v$session v
       WHERE p.addr = v.paddr AND v.sid = v_sid;

      v_os_user := SYS_CONTEXT ('userenv', 'os_user');
      DBMS_APPLICATION_INFO.read_module (v_module, v_action);

      MESSAGE :=
            TO_CHAR (SYSDATE, 'YYYYMMDD HH24MISS')
         || ' logon failed from '
         || NVL (ip, 'localhost')
         || ' '
         || v_pid
         || ' '
         || v_os_user
         || ' with '
         || v_program
         || ' – '
         || v_module
         || ' '
         || v_action;

      sys.DBMS_SYSTEM.ksdwrt (2, MESSAGE);
   END IF;
END;
/
