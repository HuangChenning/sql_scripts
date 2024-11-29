set echo off
set verify off
set lines 170
set pages 10

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display instance run time                                              |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
COLUMN STARTED_AT format a25
COLUMN UPTIME format a50
SELECT TO_CHAR (startup_time, 'YYYY-MM-DD HH24:MI:SS') started_at,
          TRUNC (SYSDATE - (startup_time))
       || ' day(s), '
       || TRUNC (  24
                 * ((SYSDATE - startup_time) - TRUNC (SYSDATE - startup_time)
                   )
                )
       || ' hour(s), '
       || MOD (TRUNC (  1440
                      * (  (SYSDATE - startup_time)
                         - TRUNC (SYSDATE - startup_time)
                        )
                     ),
               60
              )
       || ' minute(s), '
       || MOD (TRUNC (  86400
                      * (  (SYSDATE - startup_time)
                         - TRUNC (SYSDATE - startup_time)
                        )
                     ),
               60
              )
       || ' seconds' uptime
  FROM v$instance;
