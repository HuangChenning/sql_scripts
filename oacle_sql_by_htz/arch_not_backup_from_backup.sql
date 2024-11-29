SET ECHO OFF
SET LINES 200 PAGES 1000 VERIFY OFF
COL thread#     FOR 9999         HEADING 'INST'
COL sequence#   FOR 9999999999   HEADING 'SEQUENCE'
COL first_time  FOR a19
COL next_time   FOR a19
COL filesize    FOR 9999999
COL next_sequence FOR 9999999999 HEADING 'NEXT_SEQ'
PRO Parameter 1:
PRO SEQUENCE (required,default 0)
PRO
DEF sequence = nvl('&1','0')

SELECT THREAD#,
       SEQUENCE#,
       FIRST_TIME,
       NEXT_TIME,
       TRUNC (FILESIZE / 1024 / 1024) filesize,
       NVL (LEAD (sequence#) OVER (PARTITION BY thread# ORDER BY sequence#),
            '00000000')
          next_sequence
  FROM (SELECT THREAD#,
               SEQUENCE#,
               FIRST_TIME,
               NEXT_TIME,
               FILESIZE,
               NVL (
                  LEAD (sequence#)
                     OVER (PARTITION BY thread# ORDER BY sequence#),
                  sequence#)
                  LAST_VALUE,
               (  NVL (
                     LEAD (sequence#)
                        OVER (PARTITION BY thread# ORDER BY sequence#),
                     sequence#)
                - SEQUENCE#)
                  diff_value
          FROM v$backup_archivelog_details
         WHERE sequence# > &sequence)
 WHERE diff_value > 1;
 undefine 1;
 undefine sequence;
