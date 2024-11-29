host echo '-----Oracle Database Recovery Check STRAT-----'
host echo '----Starting Collect Data Dictionary Information----'

define reportHeader="<font size=+3 color=darkgreen><b>Oracle Database Recovery Check Result</b></font><hr>Copyright (c) 2012-2013 <a target=""_blank"" href=""http://www.htz.pw"">»œ’ÊæÕ ‰</a>. All rights reserved.<p>"


set termout       off
set echo          off
set feedback      off
set verify        off
set wrap          on
set trimspool     on
set serveroutput  on
set escape        on
set pagesize 50000
set long     2000000000
set numw 16
col error format a30
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
set markup html on spool on preformat off entmap on -
head ' -
  <title>Oracle Database recovery check result</title> -
  <style type="text/css"> -
    body              {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
    p                 {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
    table,tr,td       {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#FFFFCC; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;} -
    th                {font:bold 10pt Arial,Helvetica,sans-serif; color:White; background:#0066cc; padding:0px 0px 0px 0px;} -
    h1                {font:bold 12pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:#0066cc; border-bottom:1px solid #cccc99; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;} -
    h2                {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; margin-top:4pt; margin-bottom:0pt;} -
	a                 {font:10pt Arial,Helvetica,sans-serif; color:#663300; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
  </style>' -
body   'BGCOLOR="#C0C0C0"' -
table  'WIDTH="90%" BORDER="1"' 

spool db_recover_htz.html
set markup html on entmap off
prompt &reportHeader


SET MARKUP HTML ON
--current_date
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Execution Time</b></font><hr align="center" width="250"></center>
select sysdate as current_date from dual;

--version
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>DB Version</b></font><hr align="center" width="250"></center>
select * from v$version;


--instance
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Instance Information</b></font><hr align="center" width="250"></center>
select INSTANCE_NUMBER,INSTANCE_NAME,host_name,STATUS,STARTUP_TIME,THREAD# from Gv$instance;


--database
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Controlfile Information</b></font><hr align="center" width="300"></center>
select dbid, name,open_mode,
       created created,
       open_mode, log_mode,
       checkpoint_change# as checkpoint_change#,
       controlfile_type ctl_type,
       controlfile_created ctl_created,
       controlfile_change# as ctl_change#,
       controlfile_time ctl_time,
       resetlogs_change# as resetlogs_change#,
       resetlogs_time resetlogs_time
from v$database; 

--scn
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>SCN Information</b></font><hr align="center" width="300"></center>
SELECT to_char(tim,'yyyy-mm-dd hh24:mi:ss') tim,scn,round((chk16kscn-scn)/24/3600/16/1024,1) Headroom
FROM  
(
select tim, scn,
  ((
  ((to_number(to_char(tim,'YYYY'))-1988)*12*31*24*60*60) +
  ((to_number(to_char(tim,'MM'))-1)*31*24*60*60) +
  (((to_number(to_char(tim,'DD'))-1))*24*60*60) +
  (to_number(to_char(tim,'HH24'))*60*60) +
  (to_number(to_char(tim,'MI'))*60) +
  (to_number(to_char(tim,'SS')))
  ) * (16*1024)) chk16kscn
  from
 (select sysdate tim,checkpoint_change# scn from v$database))
ORDER BY tim;

--parameter 
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Non-default Parameter</b></font><hr align="center" width="300"></center>
SELECT
    p.name,i.instance_name ,p.value
FROM
    gv$parameter p
  , gv$instance  i
WHERE
    p.inst_id = i.inst_id
and  isdefault='FALSE'
ORDER BY
    p.name
  , i.instance_name;

--TABLESPACE 
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Tablespace Information</b></font><hr align="center" width="300"></center>
select * from (
select a.ts#,a.name,sum(bytes)/1024/1024/1024 ts_size_g from v$datafile b,
v$tablespace a where a.ts#=b.ts# group by a.ts#,a.name
union all
select a.ts#,a.name,sum(bytes)/1024/1024/1024 from v$tempfile b,
v$tablespace a where a.ts#=b.ts# group by a.ts#,a.name)
order by ts# asc;


--v$datafile
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Datafile Information</b></font><hr align="center" width="300"></center>
select ts#,file#,BYTES/1024/1024/1024 file_size_G,status,enabled,CREATION_TIME,
checkpoint_change# "SCN",
last_change# "STOP_SCN",
name from v$datafile
order by 1,2;

/*
ERROR	
NULL if the datafile header read and validation were successful. 
If the read failed then the rest of the columns are NULL. 
If the validation failed then the rest of columns may display invalid data. 
If there is an error then usually the datafile must be restored from a backup before it can be recovered or used.

FORMAT		Indicates the format for the header block. The possible values are 6, 7, 8, or 0.
6 - indicates Oracle Version 6
7 - indicates Oracle Version 7
8 - indicates Oracle Version 8
0 - indicates the format could not be determined (for example, the header could not be read)

RECOVER	 File needs media recovery (YES | NO)
*/


--v$datafile_header
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Datafile Header Information</b></font><hr align="center" width="350"></center>
select ts#,file#,TABLESPACE_NAME,status,ERROR,FORMAT,recover,FUZZY,
CREATION_TIME CREATE_TIME,
checkpoint_change# "SCN",
RESETLOGS_CHANGE# "RESETLOGS SCN"
from v$datafile_header
order by 1,2;

/*
fhsta 
64  normal rman fuzzy
4   normal fuzzy
8192 system good
8196 system fuzzy
0   normal good
8256 system rman fuzzy
*/
select hxfil FILENUMBER, fhsta STATUS, fhscn SCN, fhrba_seq SEQUENCE from x$kcvfh;

--redo
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Redofile Information</b></font><hr align="center" width="300"></center>
  SELECT thread#,a.group#,
         a.sequence#,a.bytes/1024/1024 "SIZE(M)",
         first_change# "F_SCN",
         a.FIRST_TIME,
         a.ARCHIVED,
         a.status,
         MEMBER
    FROM v$log a, v$logfile b
   WHERE a.group# = B.GROUP#
ORDER BY thread#,a.sequence# DESC;

--v$recover_file
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>V$recover_file Information</b></font><hr align="center" width="350"></center>
select file#,online_status "STATUS",
change# "SCN",
time"TIME" 
from v$recover_file;

--v$backup begin backup
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Hot Backup Information</b></font><hr align="center" width="350"></center>
select file#,CHANGE# "SCN",
TIME "TIME" from v$backup;

--v$archived_log
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Archivelog Information</b></font><hr align="center" width="300"></center>
col name for a50
select 
thread#,sequence# sequence#,
FIRST_CHANGE# FIRST_CHANGE#,
FIRST_TIME FIRST_TIME,
NEXT_CHANGE# NEXT_CHANGE#,
NEXT_TIME NEXT_TIME,
name from (
select  rownum rn,a.* from 
(
select 
sequence#,thread#,
FIRST_CHANGE#,
FIRST_TIME,
NEXT_CHANGE#,
NEXT_TIME,
name from v$archived_log 
where DELETED='NO'
 order by NEXT_TIME desc
) a
) where rn<10; 

--$RECOVER_LOG
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>V$recover_log Information</b></font><hr align="center" width="350"></center>
select THREAD#,SEQUENCE# SEQUENCE#,
TIME "TIME"
from v$recovery_log;

--rman backup
prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Rman Information</b></font><hr align="center" width="250"></center>
    SELECT A.RECID "BACKUP SET",
         A.SET_STAMP,
         DECODE (B.INCREMENTAL_LEVEL,
                 '', DECODE (BACKUP_TYPE, 'L', 'Archivelog', 'Full'),
                 1, 'Incr-1',
                 0, 'Incr-0',
                 B.INCREMENTAL_LEVEL)
            "Type LV",
         B.CONTROLFILE_INCLUDED "including CTL",
         DECODE (A.STATUS,
                 'A', 'AVAILABLE',
                 'D', 'DELETED',
                 'X', 'EXPIRED',
                 'ERROR')
            "STATUS",
         A.DEVICE_TYPE "Device Type",
         A.START_TIME "Start Time",
         A.COMPLETION_TIME "Completion Time",
         A.ELAPSED_SECONDS "Elapsed Seconds",
         A.TAG "Tag",
         A.HANDLE "Path"
    FROM GV$BACKUP_PIECE A, GV$BACKUP_SET B
   WHERE A.SET_STAMP = B.SET_STAMP AND A.DELETED = 'NO'
ORDER BY A.COMPLETION_TIME DESC;
spool off


host echo '<div style="display:none">'>>db_recover_htz.html
host echo '----Starting Collect PATCH Information----'
host echo ''
host echo '------------------------------ ORACLE PATCH ------------------------------'>>db_recover_htz.html
host $ORACLE_HOME/OPatch/opatch lsinventory >>db_recover_htz.html

host echo '----Starting Collect ALERT LOG Information----'
host echo ''

host echo '------------------------------ ORACLE ALERT ------------------------------'>>db_recover_htz.html
set pages 0
set markup html off
spool /tmp/htz_trace_name.lst
select value  from v$parameter where name='background_dump_dest';
spool off
host alert_dir=`cat /tmp/htz_trace_name.lst|grep -v SQL`;current_path=`pwd`;cd $alert_dir;tail -1000 "alert_$ORACLE_SID.log" >>$current_path/db_recover_htz.html
host rm -rf /tmp/htz_trace_name.lst


host echo '------------------------------ ORACLE DUMP------------------------------'>>db_recover_htz.html
spool /tmp/htz_dump_name.lst
select d.value||'/'||lower(rtrim(i.instance,chr(0)))||'_ora_'||p.spid||'.trc' trace_file_name from (select p.spid from v$mystat m, v$session s,v$process p where m.statistic# = 1 and s.sid = m.sid and p.addr = s.paddr ) p,(select t.instance from v$thread t,v$parameter v where v.name = 'thread' and(v.value = 0 or t.thread# = to_number(v.value))) i,(select value from v$parameter where name = 'user_dump_dest') d;
spool off
host echo '----Starting DUMP file_hdrs Information----'
host echo ''
host dump_name=`cat /tmp/htz_dump_name.lst|grep -v SQL|grep .trc`;echo '-------------------dump file_hdrs-------------------'>>$dump_name
ALTER SESSION SET EVENTS 'immediate trace name file_hdrs level 3';
host echo '----Starting DUMP controlf Information----'
host echo ''
host dump_name=`cat /tmp/htz_dump_name.lst|grep -v SQL|grep .trc`;echo '-------------------dump controlf-------------------'>>$dump_name
ALTER SESSION SET EVENTS 'immediate trace name controlf level 3';
host echo '----Starting DUMP redohdr Information----'
host echo ''
host dump_name=`cat /tmp/htz_dump_name.lst|grep -v SQL|grep .trc`;echo '-------------------dump redohdr-------------------'>>$dump_name
ALTER SESSION SET EVENTS 'immediate trace name redohdr level 3';
host dump_name=`cat /tmp/htz_dump_name.lst|grep -v SQL|grep .trc`;cat $dump_name >>db_recover_htz.html
host rm -rf /tmp/htz_dump_name.lst

host echo '</ div>'>>db_recover_htz.html
host echo '-----Oracle Database Recovery Check END-----'
host pwd
host ls -l db_recover_htz.html
host echo ''
exit;