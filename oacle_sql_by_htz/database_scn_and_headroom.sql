set lines 170
col max_scn for 999999999999999999999
col current_scn for 999999999999999999999999
/* Formatted on 2015/2/20 14:24:38 (QP5 v5.240.12305.39446) */
SELECT version,
       (  (  (  (TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')) - 1988)
              * 12
              * 31
              * 24
              * 60
              * 60)
           + ( (TO_NUMBER (TO_CHAR (SYSDATE, 'MM')) - 1) * 31 * 24 * 60 * 60)
           + ( ( (TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) - 1)) * 24 * 60 * 60)
           + (TO_NUMBER (TO_CHAR (SYSDATE, 'HH24')) * 60 * 60)
           + (TO_NUMBER (TO_CHAR (SYSDATE, 'MI')) * 60)
           + (TO_NUMBER (TO_CHAR (SYSDATE, 'SS'))))
        * (16 * 1024))
          max_scn,
       DBMS_FLASHBACK.get_system_change_number current_scn,
       TO_CHAR (SYSDATE, 'YYYY/MM/DD HH24:MI:SS') DATE_TIME,
       (  (  (  (  (  (TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')) - 1988)
                    * 12
                    * 31
                    * 24
                    * 60
                    * 60)
                 + (  (TO_NUMBER (TO_CHAR (SYSDATE, 'MM')) - 1)
                    * 31
                    * 24
                    * 60
                    * 60)
                 + (  ( (TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) - 1))
                    * 24
                    * 60
                    * 60)
                 + (TO_NUMBER (TO_CHAR (SYSDATE, 'HH24')) * 60 * 60)
                 + (TO_NUMBER (TO_CHAR (SYSDATE, 'MI')) * 60)
                 + (TO_NUMBER (TO_CHAR (SYSDATE, 'SS'))))
              * (16 * 1024))
           - DBMS_FLASHBACK.get_system_change_number)
        / (16 * 1024 * 60 * 60))
          indicator_hours
  FROM v$instance;



