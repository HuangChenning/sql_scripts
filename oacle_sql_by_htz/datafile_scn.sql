set echo off
set lines 400 pages 10000 verify off serveroutput on heading on  
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';

COL STATUS               FOR A15                HEADING 'STATUS'
COL SCN                  FOR 999999999999999    HEADING 'SCN'
COL CURRENT_SCN          FOR 999999999999999    HEADING 'CURRENT_SCN'
COL CHECKPOINT_CHANGE#   FOR 999999999999999    HEADING 'CHECKPOINT_CHANGE#'
COL CHECKPOINT_CHANGE#   FOR 999999999999999    HEADING 'CHECKPOINT_CHANGE#'
COL LAST_CHANGE#         FOR 999999999999999    HEADING 'LAST_CHANGE#'      
COL RESETLOGS_CHANGE#    FOR 999999999999999    HEADING 'RESETLOGS_CHANGE#' 
COL OFFLINE_CHANGE#      FOR 999999999999999    HEADING 'OFFLINE_CHANGE#'   
COL FILE# 							 FOR 9999               HEADING 'FILE#' 						
COL RFILE#               FOR 99999              HEADING 'RFILE#'   
COL MEMBER               FOR A80                HEADING 'REDO_LOGFILE_MEMBER'    
COL CRON_SCN             FOR 999999999999999    HEADING 'CONTROL_FILE_SCN' 
COL FILE_HEADER_SCN      FOR 999999999999999    HEADING 'FILE_HEADER_SCN'  
COL L_SIZE               FOR 99999              HEADING "SIZEM"
COL THREAD#              FOR 99                 HEADING 'I'
COL GROUP#               FOR 99                 HEADING 'G'
COL FIRST_CHANGE#        FOR 9999999999999999
COL FIRST_TIME           FOR A14
COL ARCHIVED             FOR A10
COL STATUS               FOR A10
COL FHSTA                FOR 9999

PROMPT
PROMPT FROM V$VERSION
PROMPT
select * from v$version;
PROMPT
PROMPT FROM V$DATABASE
PROMPT
select open_mode,log_mode,current_scn,checkpoint_change# controlfile_scn,resetlogs_change#  from v$database;

PROMPT
PROMPT FROM V$DATAFILE
PROMPT


col name  for a60
select file#,rfile#,status,checkpoint_change#,OFFLINE_CHANGE#,last_change#,name  from v$datafile;

PROMPT
PROMPT FROM V$DATAFILE_HEADER
PROMPT
col tablespace_name for a15
col error for a20
col format for 999999
col fuzzy for a5
col checkpoint_count for 9999999 heading 'CHK_COUNT'
col status for a15
select tablespace_name,file#,rfile#,status,error,format,fuzzy,checkpoint_change#,checkpoint_count, RESETLOGS_CHANGE# from v$datafile_header;

PROMPT
PROMPT FROM x$kcvfh
PROMPT

  select fhthr thread,
         fhrba_seq sequence,
         fhscn scn,
         fhsta status,
         count (*) rcount
    from x$kcvfh
group by fhthr,
         fhrba_seq,
         fhscn,
         fhsta;

  select fhtsn ts#,
         hxfil file#,
         fhrfn rfile#,
         decode (hxons, 0, 'offline', 'online') f_status,
         decode (hxerr,
                 0, null,
                 1, 'file missing',
                 2, 'offline normal',
                 3, 'not verified',
                 4, 'file not found',
                 5, 'cannot open file',
                 6, 'cannot read header',
                 7, 'corrupt header',
                 8, 'wrong file type',
                 9, 'wrong database',
                 10, 'wrong file number',
                 11, 'wrong file create',
                 12, 'wrong file create',
                 16, 'delayed open',
                 14, 'wrong resetlogs',
                 15, 'old controlfile',
                 'unknown error')
            f_error,
         fhsta fhsta,
         decode (hxifz,  0, 'no',  1, 'yes',  null) fuzzy,
         fhcrs crt_scn,
         fhcrt crt_time,
         fhscn cpt_scn,
         fhtim cpt_time,
         fhrls resetlogs_scn,
         fhthr thread#,
         fhrba_seq sequence#
    from x$kcvfh
order by fhtsn, fhrfn;

PROMPT
PROMPT FROM v$datafile<>v$datafile_header
PROMPT

select a.file#,
       a.name,
       a.status,
       a.checkpoint_change# cron_scn,
       b.checkpoint_change# file_header_scn,
       b.recover,
       b.fuzzy
  from v$datafile a, v$datafile_header b
 where a.file# = b.file# and a.checkpoint_change# <> b.checkpoint_change#
/



PROMPT
PROMPT FROM V$LOG,V$LOG_FILE
PROMPT
col l_size for 99999 heading "SIZEM"
col thread# for 99 heading 'I'
col group# for 99 heading 'G'
col first_change# for 9999999999999999
col first_time for a14
col archived for a10
col status for a10
col member from a50
  SELECT a.thread#,
         a.group#,
         a.sequence#,
         TRUNC (a.bytes / 1024 / 1024) l_size,
         a.first_change#,
         TO_CHAR (a.first_time, 'mm-dd hh24:mi:ss') first_time,
         a.archived,
         a.status,
         b.member
    FROM v$log a, v$logfile b
   WHERE a.group# = B.GROUP#
ORDER BY thread#, a.sequence# DESC;
PROMPT
PROMPT FROM V$LOG_HISTORY
PROMPT

select thread#,
       sequence#,
       first_change#,
       to_char (first_time, 'mm-dd hh24:mi:ss') first_time,
       next_change#,
       resetlogs_change#,
       to_char (resetlogs_time, 'mm-dd hh24:mi:ss') resetlogs_time
  from v$log_history
 where     first_change# >=
              (select min (checkpoint_change#) from v$datafile_header)
       and next_change# <=
              (select max (checkpoint_change#) from v$datafile_header)
  order by first_change#
/

PROMPT
PROMPT FROM V$ARCHIVED_LOG
PROMPT

select thread#,
       sequence#,
       first_change#,
       to_char (first_time, 'mm-dd hh24:mi:ss') first_time,
       next_change#,
       resetlogs_change#,
       to_char (resetlogs_time, 'mm-dd hh24:mi:ss') resetlogs_time
  from v$archived_log
 where     first_change# >=
              (select min (checkpoint_change#) from v$datafile_header)
       and next_change# <=
              (select max (checkpoint_change#) from v$datafile_header)
 order by first_change#
/

PROMPT
PROMPT FROM V$RECOVER_FILE
PROMPT
col inline_status for a7 heading 'STATUS'
col change# for 999999999999999
select file#,ONLINE_STATUS ,error,change# from v$recover_file;

  select a.recid "backup set",
         a.set_stamp,
         decode (b.incremental_level,
                 '', decode (backup_type, 'l', 'archivelog', 'full'),
                 1, 'incr-1',
                 0, 'incr-0',
                 b.incremental_level)
            "type lv",
         b.controlfile_included "including ctl",
         decode (a.status,
                 'a', 'available',
                 'd', 'deleted',
                 'x', 'expired',
                 'error')
            "status",
         a.device_type "device type",
         a.start_time "start time",
         a.completion_time "completion time",
         a.elapsed_seconds "elapsed seconds",
         a.tag "tag",
         a.handle "path"
    from gv$backup_piece a, gv$backup_set b
   where a.set_stamp = b.set_stamp and a.deleted = 'no'
order by a.completion_time desc;