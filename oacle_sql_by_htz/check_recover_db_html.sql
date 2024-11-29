-- +----------------------------------------------------------------------------+
-- |                               Travel Liu                                   |
-- |                          travel.liu@outlook.com                            |
-- |                             www.traveldba.com                              |
-- |----------------------------------------------------------------------------|
-- |                                                                            |
-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : check_recover_db_html.sql                                       |
-- | CLASS    : Database Recover                                                |
-- | PURPOSE  : Reports the database recover Infomation                         |
-- +----------------------------------------------------------------------------+
-- | MODIFIED      (YYYY/MM/DD)                                                 |
-- | Travel.liu     2013/03/08 - First Edition                                  |
-- | Travel.liu     2013/09/10 - Rewrite The Scripts                            |
-- +----------------------------------------------------------------------------+
prompt Creating Database Recover Chekc report.
prompt This script must be run as sys user.
prompt This process can take several minutes to complete.

set termout       off
set echo          off
set feedback      off
set verify        off
set heading       off
set wrap          on
set trimspool     on
set serveroutput  on
set escape        on
set pagesize 50000
set long     2000000000
set linesize 999

undef seminar_logfile
alter session set nls_date_format = 'YYYY-mm-dd HH24:MI:SS'; 

col tempfile new_value tempfile

select
     instance_name||'_'||to_char(sysdate, 'YYYYMMDD_HH24MISS') tempfile
from v$instance;
def seminar_logfile=check_recover_db_&tempfile..html

SPO &seminar_logfile REPLACE;

PRO <html>
PRO
PRO <head>
PRO <title>Check_Database_Recover_Information.html</title>
PRO

PRO <style type="text/css">
PRO body {font:10pt Arial,Helvetica,Verdana,Geneva,sans-serif; color:black; background:white;}
PRO p {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} 
PRO table,tr,td       {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#FFFFCC; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;} 
PRO a {font-weight:bold; color:#663300;}
PRO pre {font:8pt Monaco,"Courier New",Courier,monospace;} /* for code */
PRO h1 {font-size:18pt; font-weight:bold; color:#336699;}
PRO h2 {font-size:14pt; font-weight:bold; color:#336699;}
PRO h3 {font-size:12pt; font-weight:bold; color:#336699;}
PRO li {font-size:10pt; font-weight:bold; color:#336699; padding:0.1em 0 0 0;}
--PRO table {font-size:8pt; color:black; background:white;}
--PRO th {font-weight:bold; background:#cccc99; color:#336699; vertical-align:bottom; padding-left:3pt; padding-right:3pt; padding-top:1pt; padding-bottom:1pt;}
PRO th {font:bold 10pt Arial,Helvetica,sans-serif; color:White; background:#0066cc; padding:0px 0px 0px 0px;}
--PRO td {text-align:left; background:#fcfcf0; vertical-align:top; padding-left:3pt; padding-right:3pt; padding-top:1pt; padding-bottom:1pt;}
--PRO td.c {text-align:center;} /* center */
--PRO td.l {text-align:left;} /* left (default) */
--PRO td.r {text-align:right;} /* right */
--PRO td.rr {text-align:right; color:crimson; background:#fcfcf0;} /* right and red */
--PRO td.rrr {text-align:right; background:crimson;} /* right and super red  */
--PRO font.n {font-size:8pt; font-style:italic; color:#336699;} /* table footnote in blue */
--PRO font.f {font-size:8pt; color:#999999;} /* footnote in gray */
PRO body   'BGCOLOR="#C0C0C0"' 
PRO table  'WIDTH="90%" BORDER="1"' 
PRO </style>
PRO
PRO </head>
PRO <body>
PRO <font size=+3 color=darkgreen><b>Database Recover Check Report </b></font><hr>Copyright (c) 2012-2013 Travel.Liu. All rights reserved. (<a target=""_blank"" href=""http://www.traveldba.com"">www.traveldba.com</a>)<p>
PRO


--PRO <a name="tl"></a><h2>Main Report</h2>
prompt <a name="t1"></a>
prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Main Report</b></font><hr align="left" width="460">


PRO <ul>
PRO <li><a href="#tc1"> Current_scn </a></li>
PRO <li><a href="#tc2"> Oracle Version</a></li>
PRO <li><a href="#tc3"> Database Infomation </a></li>
PRO <li><a href="#tc4"> Database incarnation </a></li>
PRO <li><a href="#tc5"> Database Parameter </a></li>
PRO <li><a href="#tc6"> Tablespace Information</a></li>
PRO <li><a href="#tc7"> Datafile Information</a></li>
PRO <li><a href="#tc8"> Redo Information </a></li>
PRO <li><a href="#tc9"> LogFile Information </a></li>
PRO <li><a href="#tc10"> Recover file </a></li>
PRO <li><a href="#tc11"> Corruption Information</a></li>
PRO <li><a href="#tc12"> Rman backup Information </a></li>
PRO </ul>


prompt <a name="tc1"></a>
prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Current_date</b></font><hr align="left" width="460">
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>Current_date</th>
PRO </tr>
PRO
select '<tr>'||CHR(10)||'<td>'||to_char(sysdate, 'YYYY-mm-dd HH24:MI:SS') ||'</td>'||CHR(10)||'</tr>'||CHR(10) from dual;
PRO
PRO </table>
PRO


PRO <ul>
PRO <li><a href="#tl">Main Report</a></li>
PRO </ul>
pro <a name="tc2"></a>
pro <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Oracle Version</b></font><hr align="left" width="460">
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>VERSION</th>
PRO </tr>
PRO
select '<tr>'||CHR(10)||'<td>'||BANNER ||'</td>'||CHR(10)||'</tr>'||CHR(10) from v$version;
PRO
PRO </table>
PRO

PRO <ul>
PRO <li><a href="#tl">Main Report</a></li>
PRO </ul>
pro <a name="tc3"></a>
pro <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Database Infomation </b></font><hr align="left" width="460">
PRO
PRO <table width="90%" border="1" >
PRO
select     '<tr> <th align="left" width="20%" > DBID</th> <td><tt>'||dbid||'</tt></td></tr>'||
           '<tr> <th align="left" width="20%" > NAME</th> <td>'||name||'</td>'||
           '<tr> <th align="left" width="20%" > CREATE_TIME </th> <td>' ||to_char(created, 'yyyy-mm-dd hh24:mi:ss')||'</td>'||
           '<tr> <th align="left" width="20%" > OPEN_MODE</th> <td>'||open_mode||'</td>'||
           '<tr> <th align="left" width="20%" > LOG_MODE</th> <td>'||log_mode||'</td>'||
           '<tr> <th align="left" width="20%" > CHECKPOINT_CHANGE</th> <td>'||to_char(checkpoint_change#, '999999999999999') ||'</td>'||
           '<tr> <th align="left" width="20%" > CONTROLFILE_TYPE</th> <td>' ||controlfile_type ||'</td>'||
           '<tr> <th align="left" width="20%" > CONTROLFILE_CREATED</th> <td>'||to_char(controlfile_created,'yyyy-mm-dd hh24:mi:ss')||'</td>'||
           '<tr> <th align="left" width="20%" > CONTROLFILE_CHANGE</th> <td>'||to_char(controlfile_change#, '999999999999999') ||'</td>'||
           '<tr> <th align="left" width="20%" > CONTROLFILE_CREATED_TIME</th> <td>'||to_char(controlfile_time, 'yyyy-mm-dd hh24:mi:ss')||'</td>'||
           '<tr> <th align="left" width="20%" > RESETLOGS_CHANGE</th> <td>'||to_char(resetlogs_change#, '999999999999999') ||'</td>'||
           '<tr> <th align="left" width="20%" > RESETLOGS_TIME</th> <td>'||to_char(resetlogs_time, 'yyyy-mm-dd hh24:mi:ss') ||'</td>'||
           '<tr> <th align="left" width="20%" > ARCHIVE_CHANGE</th> <td>'||to_char(ARCHIVE_CHANGE#, '999999999999999') ||'</td>'||
           '<tr> <th align="left" width="20%" > FLASHBACK_ON</th> <td>'||FLASHBACK_ON||'</td>'||
           '<tr> <th align="left" width="20%" > FORCE_LOGGING</th> <td>'||FORCE_LOGGING||'</td></tr>'
from v$database;
PRO
PRO </table>
PRO





PRO <ul>
PRO <li><a href="#tl4">Main Report</a></li>
PRO </ul>
pro <a name="tc4"></a>
pro <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Database Incarnation (for 10g) </b></font><hr align="left" width="460">
--PRO <a name="tc4"></a><h2>Database Incarnation (for 10g) </h2>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>INCARNATION</th>
PRO <th>RESETLOGS_CHANGE</th>
PRO <th>RESETLOGS_TIME</th>
PRO <th>PRIOR_RESETLOGS_CHANGE</th>
PRO <th>PRIOR_RESETLOGS_TIME</th>
PRO <th>STATUS</th>

PRO </tr>
PRO
select '<tr>'||CHR(10)||
       '<td>'||incarnation#||'</td>'||
       '<td>'||to_char(resetlogs_change#, '999999999999999')||'</td>'||
       '<td>'||to_char(resetlogs_time,'yyyy-mm-dd hh24:mi:ss')||'</td>'||
       '<td>'||to_char(prior_resetlogs_change#, '999999999999999')||'</td>'||
       '<td>'||to_char(prior_resetlogs_time,'yyyy-mm-dd hh24:mi:ss')||'</td>'||
       '<td>'||status||'</td>'||
       '</tr>'||CHR(10)
 from v$database_incarnation;
PRO
PRO </table>
PRO


PRO <ul>
PRO <li><a href="#tl">Main Report</a></li>
PRO </ul>
pro <a name="tc5"></a>
pro <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Database Parameter </b></font><hr align="left" width="460">
--PRO <a name="tc5"></a><h2>Database Parameter </h2>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>NAME</th>
PRO <th>VALUE</th>
PRO </tr>
PRO
select    '<tr>'||CHR(10)||
          '<td>'||name||'</td>'||
		  '<td>'||value ||'</td>'||
		 '</tr>'||CHR(10)
   from v$parameter 
   where isdefault='FALSE' order by 1;
PRO
PRO </table>
PRO


PRO <ul>
PRO <li><a href="#tl">Main Report</a></li>
PRO </ul>
--PRO <a name="tc6"></a><h2>Tablespace Information</h2>
pro <a name="tc6"></a>
pro <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Tablespace Information </b></font><hr align="left" width="460">

PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>TS#</th>
PRO <th>NAME</th>
PRO <th>TABLESPACE_SIZE(G)</th>
PRO </tr>
select 
		'<tr>'||CHR(10)||
		'<td>'||a.ts#||'</td>'||
		'<td>'||a.name||'</td>'||
		'<td>'||sum(bytes)/1024/1024/1024||'</td>'|| 
		'</tr>'||CHR(10)
     from v$datafile b,
     v$tablespace a 
     where a.ts#=b.ts#(+) group by a.ts#,a.name order by a.ts#;
PRO
PRO </table>
PRO


PRO <ul>
PRO <li><a href="#tl">Main Report</a></li>
PRO </ul>
--PRO <a name="tc7"></a><h2>Datafile Information</h2>
pro <a name="tc7"></a>
pro <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Datafile Information </b></font><hr align="left" width="460">
PRO <h3>Datafile Base Information</h3>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>TS#</th>
PRO <th>FILE#</th>
PRO <th>FILE_SIZE(G)</th>
PRO <th>STATUS</th>
PRO <th>ENABLED</th>
PRO <th>SCN</th>
PRO <th>STOP_SCN</th>
PRO <th>NAME</th>
PRO </tr>
--v$datafile
select 		'<tr>'||CHR(10)||
			'<td>'||ts#||'</td>'||'<td>'||file#||'</td>'||
			'<td>'||BYTES/1024/1024/1024 ||'</td>'||
			'<td>'||status||'</td>'||
			'<td>'||enabled||'</td>'||
			'<td>'||to_char(checkpoint_change#,'999999999999999') ||'</td>'||
			'<td>'||to_char(last_change#,'999999999999999')||'</td>'||
			'<td>'||name ||'</td>'||
			'</tr>'||CHR(10)
     from v$datafile order by ts#,file#;
PRO
PRO </table>
PRO

PRO <h3>Datafile Crash Information</h3>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>NAME</th>
PRO <th>STATUS</th>
PRO <th>STATUS#</th>
PRO <th>Control_File_SCN</th>
PRO <th>Datafile__SCN</th>
PRO <th>Datafile_Status</th>
PRO </tr>
SELECT    '<tr>'||CHR(10)||
          '<td>'||a.name||'</td>'||
          '<td>'||a.status||'</td>'||
          '<td>'||a.file#||'</td>'||
          '<td>'||a.checkpoint_change# ||'</td>'||
          '<td>'||b.checkpoint_change# ||'</td>'||
          '<td>'||CASE
                  WHEN ((a.checkpoint_change# - b.checkpoint_change#) = 0) THEN 'Startup Normal'
                  WHEN ((b.checkpoint_change#) = 0) THEN 'File Missing?'
                  WHEN ((a.checkpoint_change# - b.checkpoint_change#) > 0) THEN 'Media Rec. Req.'
                  WHEN ((a.checkpoint_change# - b.checkpoint_change#) < 0) THEN 'Old Control File'
                  ELSE 'what the ?' END  ||'</td>' ||'</tr>' ||CHR(10)
           FROM v$datafile a -- control file SCN for datafile
           ,v$datafile_header b -- datafile header SCN
           WHERE a.file# = b.file#
           ORDER BY a.file#;
PRO
PRO </table>
PRO


PRO <h3>Checkpoint change SCN Location </h3>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th> SCN_location </th>
PRO <th> NAME </th>
PRO <th> CHECKPOINT_CHANGE </th>
PRO </tr>
select '<tr>' || CHR(10) || '<td>' || SCN_location || '</td>' || '<td>' || name ||
       '</td>' || '<td>' || checkpoint_change# || '</td>' || '</tr>' ||
       CHR(10)
  from (select 'controlfile' SCN_location,
               'SYSTEM checkpoint' name,
               checkpoint_change#
          from v$database
        union
        select 'file in controlfile', to_char(count(*)), checkpoint_change#
          from v$datafile
         group by checkpoint_change#
        union
        select 'file header', to_char(count(*)), checkpoint_change#
          from v$datafile_header
         group by checkpoint_change#) a;
PRO
PRO </table>
PRO

PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th> SCN_location </th>
PRO <th> NAME </th>
PRO <th> CHECKPOINT_CHANGE </th>
PRO </tr>
select '<tr>' || CHR(10) || '<td>' || SCN_location || '</td>' || '<td>' || name ||
       '</td>' || '<td>' || checkpoint_change# || '</td>' || '</tr>' ||
       CHR(10)
  from (select 'controlfile' SCN_location,
               'SYSTEM checkpoint' name,
               checkpoint_change#
          from v$database
        union
        select 'file in controlfile', name, checkpoint_change#
          from v$datafile
        union
        select 'file header', name, checkpoint_change#
          from v$datafile_header) a;
PRO
PRO </table>
PRO


PRO <h3>Checks Datafile The Required redo log sequence </h3>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th> MEMBER </th>
PRO <th> GROUP </th>
PRO <th> THREAD </th>
PRO <th> SEQUENCE </th>
PRO <th> STATUS </th>
PRO <th> FIRST_CHANGE </th>
PRO <th> FIRST_TIME </th>
PRO <th> MIN_CHECKPOINT_CHANGE </th>
PRO </tr>

select '<tr>' || CHR(10) || '<td>' || LF.member || '</td>' || '<td>' ||
       L.group# || '</td>' || '<td>' || L.thread# || '</td>' || '<td>' ||
       L.sequence# || '</td>' || '<td>' || L.status || '</td>' || '<td>' ||
       L.first_change# || '</td>' || '<td>' || L.first_time || '</td>' ||
       '<td>' || DF.min_checkpoint_change# || '</td>' || '</tr>' || CHR(10)
  from v$log L,
       v$logfile LF,
       (select min(checkpoint_change#) min_checkpoint_change#
          from v$datafile_header
         where status = 'ONLINE') DF
 where LF.group# = L.group#
   and L.first_change# >= DF.min_checkpoint_change#;
PRO
PRO </table>
PRO


PRO <h3>Datafile Header Base Information Information </h3>

PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>TS#</th>
PRO <th>TBS_NAME</th>
PRO <th>FILE#</th>
PRO <th>NAME</th>
PRO <th>STATUS</th>
PRO <th>ERROR</th>
PRO <th>FUZZY</th>
PRO <th>CREATION_CHANGE</th>
PRO <th>CREATE_TIME</th>
PRO <th>CHK_CHANGE</th>
PRO <th>CHK_TIME</th>
PRO <th>RES_CHANGE</th>
PRO <th>RES_TIME</th>
PRO <th>BYTES</th>
PRO </tr>
select 	'<tr>'||CHR(10)
              ||'<td>'||TS#
              ||'</td>'||'<td>'||TABLESPACE_NAME
              ||'</td>'||'<td>'||FILE#
              ||'</td>'||'<td>'||NAME
              ||'</td>'||'<td>'||STATUS
              ||'</td>'||'<td>'||ERROR
              ||'</td>'||'<td>'||FUZZY
              ||'</td>'||'<td>'||to_char(CREATION_CHANGE#,'9999999999999999') 
              ||'</td>'||'<td>'||to_char(CREATION_TIME,'yyyy-mm-dd hh24:mi:ss') 
              ||'</td>'||'<td>'||to_char(CHECKPOINT_CHANGE#,'9999999999999999') 
              ||'</td>'||'<td>'||TO_CHAR(CHECKPOINT_TIME, 'yyyy-mm-dd hh24:mi:ss')
              ||'</td>'||'<td>'||TO_CHAR(RESETLOGS_CHANGE#, '999999999999999') 
              ||'</td>'||'<td>'||TO_CHAR(RESETLOGS_TIME, 'yyyy-mm-dd hh24:mi:ss') 
              ||'</td>'||'<td>'||TO_CHAR(BYTES, '9999999999990')
              ||'</td>'||'</tr>'||CHR(10)
from v$datafile_header
order by ts#,file#;
PRO
PRO </table>
PRO


/*
fhsta 
64  normal rman fuzzy
4   normal fuzzy
8192 system good
8196 system fuzzy
0   normal good
8256 system rman fuzzy
*/

--SELECT hxfil file_num,substr(hxfnm,1,40) file_name,fhtyp type,hxerr validity, fhscn chk_ch#, fhtnm tablespace_name,fhsta status,fhrba_seq sequence FROM x$kcvfh;

PRO <h3> Datafile Information IN V$KCVFH </h3>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>FILE_NUMBER</th>
PRO <th>FILE_NAME</th>
PRO <th>FILE_TYPE</th>
PRO <th>Validity</th>
PRO <th>Checkpoint_Change</th>
PRO <th>TableSpace_name</th>
PRO <th>STATUS</th>
PRO <th>THREAD</th>
PRO <th>SEQUENCE</th>
PRO <th>HXSTS</th>
PRO </tr>
select    '<tr>'||CHR(10)
				||'<td>'||hxfil 
				||'</td>'||'<td>'||substr(hxfnm,1,50) 
				||'</td>'||'<td>'||fhtyp
				||'</td>'||'<td>'||hxerr
				||'</td>'||'<td>'||fhscn 
				||'</td>'||'<td>'||fhtnm
				||'</td>'||'<td>'||fhsta 
				||'</td>'||'<td>'||fhthr
				||'</td>'||'<td>'||fhrba_seq
				||'</td>'||'<td>'||HXSTS
				||'</td>'||'</tr>'||CHR(10)
from x$kcvfh;
PRO
PRO </table>
PRO



PRO <ul>
PRO <li><a href="#tl">Main Report</a></li>
PRO </ul>
--redo
--PRO <a name="tc8"></a><h2> Redo Information </h2>
pro <a name="tc8"></a>
pro <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Redo Information </b></font><hr align="left" width="460">

PRO <h3> Redo Base Information </h3>

PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>THREAD</th>
PRO <th>SEQUENCE</th>
PRO <th>GROUP</th>
PRO <th>FIRST_CHANGE</th>
PRO <th>STATUS</th>
PRO <th>ARCHIVED</th>
PRO <th>MEMBER</th>
PRO </tr>
  SELECT      '<tr>'||CHR(10)
  				    ||'<td>'||thread#
					||'</td>'||'<td>'||a.sequence#
					||'</td>'||'<td>'||a.group#
					||'</td>'||'<td>'||TO_CHAR (first_change#, '9999999999999999')
					||'</td>'||'<td>'||a.status
					||'</td>'||'<td>'||a.ARCHIVED
					||'</td>'||'<td>'||MEMBER
					||'</td>'||'</tr>'||CHR(10)
    FROM v$log a, v$logfile b
   WHERE a.group# = B.GROUP#
ORDER BY a.sequence# DESC;
PRO
PRO </table>
PRO

PRO <h3> Redo Crash Information </h3>

PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>THREAD</th>
PRO <th>OPEN_MODE</th>
PRO <th>STATUS</th>
PRO <th>STATUS</th>
PRO </tr>
SELECT '<tr>' || CHR(10) || '<td>'|| a.thread# || '</td>' || '<td>'||
       b.open_mode || '</td>' || '<td>'|| a.status || '</td>' || '<td>'|| CASE
         WHEN ((b.open_mode = 'MOUNTED') AND (a.status = 'OPEN')) THEN
          'Crash Recovery req.'
         WHEN ((b.open_mode = 'MOUNTED') AND (a.status = 'CLOSED')) THEN
          'No Crash Rec. req.'
         WHEN ((b.open_mode = 'READ WRITE') AND (a.status = 'OPEN')) THEN
          'Inst. already open'
         WHEN ((b.open_mode = 'READ ONLY') AND (a.status = 'CLOSED')) THEN
          'Inst. open read only'
         ELSE
          'huh?'
       END || '</td>' || '</tr>' || CHR(10)
  FROM v$thread a, gv$database b
 WHERE a.thread# = b.inst_id;
PRO
PRO </table>
PRO

PRO <h3>Current Log Archive Information</h3>

PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>RECID</th>
PRO <th>THREAD</th>
PRO <th>SEQUENCE</th>
PRO <th>NAME</th>
PRO <th>FIRST_CHANGE</th>
PRO <th>NEXT_CHANGE</th>
PRO <th>ARCHIVED</th>
PRO <th>DEL</th>
PRO <th>COMPLETED</th>
PRO </tr>
SELECT      '<tr>'||CHR(10)
                  ||'<td>'||a.recid
                  ||'</td>'||'<td>'||a.thread#
                  ||'</td>'||'<td>'||a.sequence#
                  ||'</td>'||'<td>'||a.name
                  ||'</td>'||'<td>'||tO_CHAR(a.first_change#, '999999999999999')
                  ||'</td>'||'<td>'||to_char(a.NEXT_CHANGE#, '999999999999999')
                  ||'</td>'||'<td>'||a.archived
                  ||'</td>'||'<td>'||a.deleted
                  ||'</td>'||'<td>'||a.completion_time
	FROM v$archived_log a, v$log l
	WHERE a.thread# = l.thread#
	AND a.sequence# = l.sequence#;

PRO
PRO </table>
PRO


PRO <h3>Redo Information In X$KCCRT </h3>

PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>THREAD</th>
PRO <th>RTCKP_SCN</th>
PRO <th>RTCKP_RBA_SEQ</th>
PRO <th>RTCKP_RBA_BNO</th>
PRO <th>RTCKP_RBA_BOF</th>
PRO <th>RTSEQ</th>
PRO <th>RTENB</th>
PRO <th>FLASHBACK</th>
PRO </tr>
  select 
  '<tr>'||CHR(10) 
  ||'<td>'||rtnum
  ||'</td>'||'<td>'||RTCKP_SCN
  ||'</td>'||'<td>'||RTCKP_RBA_SEQ
  ||'</td>'||'<td>'||RTCKP_RBA_BNO
  ||'</td>'||'<td>'||RTCKP_RBA_BOF
  ||'</td>'||'<td>'||RTSEQ
  ||'</td>'||'<td>'||RTENB
  ||'</td>'||'<td>'||decode(bitand(rtsta,128), 128, 'FB_ENABLED_FOR_THREAD','FB_DISABLED_FOR_THREAD')
  ||'</td>'||'</tr>'||CHR(10) 
  from x$kccrt;

PRO
PRO </table>
PRO



PRO <ul>
PRO <li><a href="#tl">Main Report</a></li>
PRO </ul>
--PRO <a name="tc9"></a><h2> LogFile Information </h2>
pro <a name="tc9"></a>
pro <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>LogFile Information </b></font><hr align="left" width="460">
--v$log_history
--select * from v$log_history;

PRO <h3> Log History Information </h3>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th> RECID </th>           
PRO <th> STAMP </th>           
PRO <th> THREAD </th>         
PRO <th> SEQUENCE  </th>       
PRO <th> FIRST_CHANGE </th>   
PRO <th> FIRST_TIME </th>      
PRO <th> NEXT_CHANGE </th>    
PRO <th> RESETLOGS_CHANGE </th>
PRO <th> RESETLOGS_TIME </th>   
PRO </tr>
select 		'<tr>'||CHR(10)
				||'<td>'||RECID
				||'</td>'||'<td>'||to_char(STAMP,'9999999999999999')
				||'</td>'||'<td>'||THREAD#
				||'</td>'||'<td>'||SEQUENCE#
				||'</td>'||'<td>'||to_char(FIRST_CHANGE#,'9999999999999999')
				||'</td>'||'<td>'||to_char(FIRST_TIME,'yyyy-mm-dd hh24:mi:ss')
				||'</td>'||'<td>'||to_char(NEXT_CHANGE#,'9999999999999999')
				||'</td>'||'<td>'||to_char(RESETLOGS_CHANGE#,'9999999999999999')
				||'</td>'||'<td>'||to_char(RESETLOGS_TIME,'yyyy-mm-dd hh24:mi:ss')
				||'</td>'||'</tr>'||CHR(10)
from (
select  rownum rn,a.* from 
(
	select 
	   RECID,            
	   STAMP ,           
	   THREAD#,          
	   SEQUENCE#,        
	   FIRST_CHANGE#,    
	   FIRST_TIME ,      
	   NEXT_CHANGE#,     
	   RESETLOGS_CHANGE#,
	   RESETLOGS_TIME    
	from v$log_history
	order by SEQUENCE# desc
	) a
) where rn<10; 

PRO
PRO </table>
PRO

--v$archived_log
PRO <h3>Archived Log Information </h3>

PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th> RECID </th>                      
PRO <th> THREAD </th>         
PRO <th> SEQUENCE  </th>  
PRO <th> NAME  </th>  
PRO <th> FIRST_CHANGE </th>  
PRO <th> FIRST_TIME </th>        
PRO <th> NEXT_CHANGE </th>        
PRO <th> NEXT_TIME </th>    
PRO <th> Archived </th>
PRO <th> DELETED </th>   
PRO <th> COMPLETED </th>   
PRO <th> BLOCK </th>  
PRO <th> BLOCK_SIZE</th>  
PRO </tr>
select 		'<tr>'||CHR(10)
                ||'<td>'||RECID
				||'</td>'||'<td>'||thread#
				||'</td>'||'<td>'||to_char(sequence#,'9999999999999999')
				||'</td>'||'<td>'||NAME
				||'</td>'||'<td>'||to_char(FIRST_CHANGE#,'9999999999999999')
				||'</td>'||'<td>'||FIRST_TIME
				||'</td>'||'<td>'||to_char(NEXT_CHANGE#,'9999999999999999')
				||'</td>'||'<td>'||NEXT_TIME
				||'</td>'||'<td>'||Archived 
				||'</td>'||'<td>'||deleted 
				||'</td>'||'<td>'|| completion_time
				||'</td>'||'<td>'|| blocks
				||'</td>'||'<td>'|| block_size
				||'</td>'||'</tr>'||CHR(10)
		from (
				select  rownum rn,a.* from 
				(	SELECT recid,
					thread#,
					sequence#,
					name,
					tO_CHAR(first_change#, '999999999999999') as first_change#,
		            FIRST_TIME,
					to_char(NEXT_CHANGE#, '999999999999999') as next_change# ,
					NEXT_TIME,
					archived,
					deleted,
					completion_time,
					blocks,
					block_size
					FROM v$archived_log
					order by SEQUENCE# desc
				) a 
			 ) where rn<10; 
PRO
PRO </table>
PRO


PRO <ul>
PRO <li><a href="#tl">Main Report</a></li>
PRO </ul>
--v$recover_file
--PRO <a name="tc10"></a><h2>Recover file/Log Information </h2>
pro <a name="tc10"></a>
pro <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Recover file/Log Information </b></font><hr align="left" width="460">

PRO <h3>Recover File </h3>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>FILE</th>
PRO <th>ONLINE_STATUS</th>
PRO <th>SCN</th>
PRO <th>TIME</th>
PRO </tr>
select    '<tr>'||CHR(10)
				||'<td>'||file#
				||'</td>'||'<td>'||online_status
				||'</td>'||'<td>'||to_char(change#,'9999999999999999')
				||'</td>'||'<td>'||To_char(time,'yyyy-mm-dd hh24:mi:ss')
				||'</td>'||'</tr>'||CHR(10)
from v$recover_file;
PRO
PRO </table>
PRO

--$RECOVER_LOG
PRO <h3>Recovery Log</h3>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>THREAD</th>
PRO <th>SEQUENCE</th>
PRO <th>TIME</th>
PRO </tr>
select 
				'<tr>'||CHR(10)
				||'<td>'||THREAD#
				||'</td>'||'<td>'||to_char(SEQUENCE#,'99999999999')
				||'</td>'||'<td>'||to_char(TIME,'yyyy-mm-dd hh24:mi:ss')
				||'</td>'||'</tr>'||CHR(10)
from v$recovery_log;
PRO
PRO </table>
PRO

--select * from V$BACKUP_CORRUPTION;
PRO <ul>
PRO <li><a href="#tl">Main Report</a></li>
PRO </ul>
--PRO <a name="tc11"></a><h2> Corruption Information </h2>
pro <a name="tc11"></a>
pro <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Corruption Information </b></font><hr align="left" width="460">

--v$BACKUP_CORRUPTION

PRO <h3>Backup Corruption</h3>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th> RECID </th>           
PRO <th> STAMP </th>           
PRO <th> SET_STAMP </th>         
PRO <th> SET_COUNT </th>       
PRO <th> PIECE </th>   
PRO <th> FILE </th>      
PRO <th> BLOCK </th>    
PRO <th> BLOCKS </th>
PRO <th> CORRUPTION_CHANGE </th>   
PRO <th> MARKED_CORRUPT </th>
PRO <th> CORRUPTION_TYPE </th>   
PRO </tr>

select '<tr>'||CHR(10)
		||'<td>'||RECID              
		||'</td>'||'<td>'||STAMP              
		||'</td>'||'<td>'||SET_STAMP          
		||'</td>'||'<td>'||SET_COUNT          
		||'</td>'||'<td>'||PIECE#             
		||'</td>'||'<td>'||FILE#              
		||'</td>'||'<td>'||BLOCK#             
		||'</td>'||'<td>'||BLOCKS             
		||'</td>'||'<td>'||to_char(CORRUPTION_CHANGE#,'9999999999999999999') 
		||'</td>'||'<td>'||MARKED_CORRUPT          
		||'</td>'||'<td>'||CORRUPTION_TYPE 
		||'</td>'||'</tr>'||CHR(10)
		from V$BACKUP_CORRUPTION;
PRO
PRO </table>
PRO

--select * from V$COPY_CORRUPTION;
--v$COPY_CORRUPTION
PRO <h3>copy Corruption</h3>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th> RECID </th>           
PRO <th> STAMP </th>           
PRO <th> COPY_RECID </th>         
PRO <th> COPY_STAMP </th>       
PRO <th> FILE </th>      
PRO <th> BLOCK </th>    
PRO <th> BLOCKS </th>
PRO <th> CORRUPTION_CHANGE </th>   
PRO <th> MARKED_CORRUPT </th>
PRO <th> CORRUPTION_TYPE </th>   
PRO </tr>

select '<tr>'||CHR(10)
		||'<td>'||RECID              
		||'</td>'||'<td>'||STAMP              
		||'</td>'||'<td>'||COPY_RECID          
		||'</td>'||'<td>'||COPY_STAMP                      
		||'</td>'||'<td>'||FILE#              
		||'</td>'||'<td>'||BLOCK#             
		||'</td>'||'<td>'||BLOCKS             
		||'</td>'||'<td>'||to_char(CORRUPTION_CHANGE#,'9999999999999999999') 
		||'</td>'||'<td>'||MARKED_CORRUPT          
		||'</td>'||'<td>'||CORRUPTION_TYPE 
		||'</td>'||'</tr>'||CHR(10)
		from V$COPY_CORRUPTION;
PRO
PRO </table>
PRO

-- select * from V$DATABASE_BLOCK_CORRUPTION;
--v$DATABASE_BLOCK_CORRUPTION
PRO <h3>Database block Corruption </h3>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th> FILE </th>      
PRO <th> BLOCK </th>    
PRO <th> BLOCKS </th>
PRO <th> CORRUPTION_CHANGE </th>   
PRO <th> CORRUPTION_TYPE </th>    
PRO </tr>

select '<tr>'||CHR(10)                    
		||'</td>'||'<td>'||FILE#              
		||'</td>'||'<td>'||BLOCK#             
		||'</td>'||'<td>'||BLOCKS             
		||'</td>'||'<td>'||to_char(CORRUPTION_CHANGE#,'9999999999999999999')         
		||'</td>'||'<td>'||CORRUPTION_TYPE 
		||'</td>'||'</tr>'||CHR(10)
		from V$BACKUP_CORRUPTION;
PRO
PRO </table>


PRO <ul>
PRO <li><a href="#tl">Main Report</a></li>
PRO </ul>
--PRO <a name="tc12"></a><h2>Backup Information </h2>
pro <a name="tc12"></a>
pro <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Backup Information </b></font><hr align="left" width="460">
--databfile is  begin backup alter tablespace user begin backup;
-- SELECT f.name,b.status,b.change#,b.time FROM v$backup b,v$datafile f WHERE b.file# = f.file# AND b.status='ACTIVE';

PRO <h3> Datafile in begin Backup Mode </h3>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>NAME</th>
PRO <th>STATUS</th>
PRO <th>CHANGE</th>
PRO <th>TIME</th>
PRO </tr>
select  '<tr>'||CHR(10)
					||'<td>'||f.name
					||'</td>'||'<td>'||b.status
					||'</td>'||'<td>'||to_char(b.CHANGE#,'9999999999999999')
					||'</td>'||'<td>'||to_char(b.TIME,'yyyy-mm-dd hh24:mi:ss')
					||'</td>'||'</tr>'||CHR(10)
FROM v$backup b,v$datafile f WHERE b.file# = f.file#;
PRO
PRO </table>
PRO


--rman backup
PRO <h3>Rman Backup Information</h3>
PRO
PRO <table width="90%" border="1">
PRO
PRO <tr>
PRO <th>BACKUP SET</th>
PRO <th>SET_STAMP</th>
PRO <th>Type LV</th>
PRO <th>including CTL</th>
PRO <th>STATUS</th>
PRO <th>Device Type</th>
PRO <th>START_TIME</th>
PRO <th>COMPLETION_TIME</th>
PRO <th>ELAPSED_SECONDS</th>
PRO <th>TAG</th>
PRO <th>Path</th>
PRO </tr>
SELECT        '<tr>'||CHR(10)
					||'<td>'||A.RECID
					||'</td>'||'<td>'||A.SET_STAMP
					||'</td>'||'<td>'||DECODE (B.INCREMENTAL_LEVEL,'', DECODE (BACKUP_TYPE, 'L', 'Archivelog', 'Full'),1, 'Incr-1',0, 'Incr-0',B.INCREMENTAL_LEVEL)
					||'</td>'||'<td>'||B.CONTROLFILE_INCLUDED
					||'</td>'||'<td>'||DECODE (A.STATUS,'A', 'AVAILABLE','D', 'DELETED','X', 'EXPIRED','ERROR')
					||'</td>'||'<td>'||A.DEVICE_TYPE
					||'</td>'||'<td>'||A.START_TIME
					||'</td>'||'<td>'||A.COMPLETION_TIME
					||'</td>'||'<td>'||A.ELAPSED_SECONDS
					||'</td>'||'<td>'||A.TAG
					||'</td>'||'<td>'||A.HANDLE
					||'</td>'||'</tr>'||CHR(10)
    FROM GV$BACKUP_PIECE A, GV$BACKUP_SET B
   WHERE A.SET_STAMP = B.SET_STAMP AND A.DELETED = 'NO'
ORDER BY A.COMPLETION_TIME DESC;

PRO
PRO </table>
PRO


PRO <ul>
PRO <li><a href="#tl">Main Report</a></li>
PRO </ul>
PRO
SELECT '<!-- '||TO_CHAR(SYSDATE, 'YYYY-MM-DD/HH24:MI:SS')||' -->' FROM dual;
PRO <hr size="3">
pro <div style="color:#00FF00">
pro <a href='http://www.traveldba.com'><p align=right>Copyright@Travel</p></a>
pro </div>

PRO </body>
PRO </html>

SPO OFF;

SET TERMOUT ON
prompt 
prompt Output written to: &seminar_logfile
exit;

