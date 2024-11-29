/* Formatted on 2014/6/16 21:54:40 (QP5 v5.240.12305.39446) */
SET ECHO ON
SET LINESIZE 200 TRIMSPOOL ON
set heading on
COL name FORM a60
col instance_name for a8
col db_name for a8
COL status FORM a10
COL dbname FORM a15
COL member FORM a80
COL inst_id FORM 999
COL resetlogs_time FORM a25
COL created FORM a25
COL db_unique_name FORM a15
COL stat FORM 9999999999
COL thr FORM 99999
COL "Uptime" FORM a80
COL file# FORM 999999
COL checkpoint_change# FORM 999999999999999
COL first_change# FORM 999999999999999
COL change# FORM 999999999999999
col CREATED for a19
col RESETLOGS_TIME  for a19
col CONTROLFILE_TIME for a19
SET PAGESIZE 50000;
ALTER SESSION SET nls_date_format = 'yyyy-mm-dd hh24:mi:ss';

SPOOL '/tmp/recovery_diagnostics.out';

SHOW USER

select * from v$version;
  SELECT inst_id,
         instance_name,
         status,
            startup_time
         || ' - '
         || TRUNC (SYSDATE - (STARTUP_TIME))
         || ' day(s), '
         || TRUNC (
                 24
               * ( (SYSDATE - STARTUP_TIME) - TRUNC (SYSDATE - STARTUP_TIME)))
         || ' hour(s), '
         || MOD (
               TRUNC (
                    1440
                  * ( (SYSDATE - STARTUP_TIME) - TRUNC (SYSDATE - STARTUP_TIME))),
               60)
         || ' minute(s), '
         || MOD (
               TRUNC (
                    86400
                  * ( (SYSDATE - STARTUP_TIME) - TRUNC (SYSDATE - STARTUP_TIME))),
               60)
         || ' seconds'
            "Uptime"
    FROM gv$instance
ORDER BY inst_id
/

SELECT dbid,
       name db_name,
       database_role,
       created,
       resetlogs_change#,
       resetlogs_time,
       open_mode,
       log_mode,
       checkpoint_change#,
       controlfile_type,
       controlfile_change#,
       controlfile_time
  FROM v$database;

ARCHIVE LOG LIST;

SELECT * FROM v$controlfile;

  SELECT DISTINCT (status), COUNT (*)
    FROM V$BACKUP
GROUP BY status;

SELECT file#,
       f.name,
       t.name,
       f.status,
       checkpoint_change#
  FROM v$datafile f, v$tablespace t
 WHERE f.ts# = t.ts#;

SELECT file#,
       status,
       checkpoint_change#,
       checkpoint_time,
       resetlogs_change#,
       resetlogs_time,
       fuzzy
  FROM v$datafile_header;

  SELECT status,
         checkpoint_change#,
         checkpoint_time,
         resetlogs_change#,
         resetlogs_time,
         COUNT (*),
         fuzzy
    FROM v$datafile_header
GROUP BY status,
         checkpoint_change#,
         checkpoint_time,
         resetlogs_change#,
         resetlogs_time,
         fuzzy;

  SELECT DISTINCT (FHRBA_SEQ) Sequence, COUNT (*)
    FROM X$KCVFH
GROUP BY FHRBA_SEQ;

  SELECT v1.thread#,
         v1.group#,
         v1.sequence#,
         v1.first_change#,
         v1.first_time,
         v1.archived,
         v1.status,
         v2.MEMBER
    FROM v$log v1, v$logfile v2
   WHERE v1.group# = v2.group#
ORDER BY v1.first_time;

  SELECT *
    FROM v$recover_file
ORDER BY 1;

SELECT DISTINCT (status) FROM v$datafile;

SELECT ROUND (SUM (bytes) / 1024 / 1024 / 1024, 0) db_size_GB FROM v$datafile;

  SELECT fhsta, COUNT (*)
    FROM X$KCVFH
GROUP BY fhsta;

SELECT MIN (fhrba_Seq), MAX (fhrba_Seq) FROM X$KCVFH;

spool off