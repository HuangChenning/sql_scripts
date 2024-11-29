set echo off;
set lines 300 pages 1000 heading on verify off;
break on tablespace

col  pdb_name          for  a8                       heading 'PDB_NAME';
col  tablespace_name   for  a15                      heading 'TABLESPACE';
col  file_id           for  9999                     heading 'FILE|ID';
col  RELATIVE_FNO      for  9999                     heading 'RFID';
col  status            for  a10                      heading 'STATUS';
col  bytes             for  99999                    heading 'SIZEM';
col  maxbytes          for  99999                    heading 'MSIZE';
col FILE_NAME          for  a90                      heading 'FILE_NAME';
col AUTOEXTENSIBLE     for  a5                       heading 'AUTO?';

define _VERSION_12  = "--"
define _VERSION_11  = "--"


col version11  noprint new_value _VERSION_11
col version12  noprint new_value _VERSION_12


select case
         when
              substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) <
              '12.1.0.2.0' then
          '  '
         else
          '--'
       end  version11,
       case
         when substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) >=
              '12.1.0.2.0' then
          '  '
         else
          '--'
       end  version12
  from v$version
 where banner like 'Oracle Database%';

undefine tablespace_name;
undefine file_id;
undefine pdb_name;
  SELECT
&_VERSION_11  a.tablespace_name,
&_VERSION_11       a.file_name,
&_VERSION_11       a.file_id,
&_VERSION_11       a.RELATIVE_FNO,
&_VERSION_11       substr(a.status,1,10) status,
&_VERSION_11       a.AUTOEXTENSIBLE,
&_VERSION_11       trunc(a.bytes / 1024 / 1024) bytes,
&_VERSION_11       trunc(a.MAXBYTES / 1024 / 1024) maxbytes
&_VERSION_11  from dba_data_files a
&_VERSION_11 ORDER BY a.tablespace_name,a.file_id
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_12 *   FROM (SELECT DECODE (b.name, '', 'CDB$ROOT', b.name) pdb_name,
&_VERSION_12                 c.name tablespace_name,
&_VERSION_12                 a.name file_name,
&_VERSION_12                 a.file# file_id,
&_VERSION_12                 a.rfile# RELATIVE_FNO,substr(a.status,1,10) status,
&_VERSION_12                 TRUNC (a.bytes / 1024 / 1024) bytes
&_VERSION_12            FROM v$datafile a, v$containers b,v$tablespace c
&_VERSION_12           WHERE     a.con_id = b.con_id(+) and c.con_id=a.con_id and c.ts#=a.ts#
&_VERSION_12                 AND a.file# = NVL ('&&file_id', a.file#)) c)
&_VERSION_12 ORDER BY pdb_name, tablespace_name, file_id
/

  SELECT
&_VERSION_11  a.tablespace_name,
&_VERSION_11       a.file_name,
&_VERSION_11       a.file_id,
&_VERSION_11       a.RELATIVE_FNO,
&_VERSION_11       substr(a.status,1,10) status,
&_VERSION_11       a.AUTOEXTENSIBLE,
&_VERSION_11       trunc(a.bytes / 1024 / 1024) bytes,
&_VERSION_11       trunc(a.MAXBYTES / 1024 / 1024) maxbytes
&_VERSION_11  from dba_temp_files a
&_VERSION_11 ORDER BY a.tablespace_name,a.file_id
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_12 *   FROM (SELECT DECODE (b.name, '', 'CDB$ROOT', b.name) pdb_name,
&_VERSION_12                 c.name tablespace_name,
&_VERSION_12                 a.name file_name,
&_VERSION_12                 a.file# file_id,
&_VERSION_12                 a.rfile# RELATIVE_FNO,substr(a.status,1,10) status,
&_VERSION_12                 TRUNC (a.bytes / 1024 / 1024) bytes
&_VERSION_12            FROM v$tempfile a, v$containers b,v$tablespace c
&_VERSION_12           WHERE     a.con_id = b.con_id(+) and c.con_id=a.con_id and c.ts#=a.ts#)
&_VERSION_12 ORDER BY pdb_name, tablespace_name, file_id
/


set echo off
set verify off heading on
set lines 200
set pages 100
break on inst_id on group#
col f_time for a19 heading 'First Time'
col inst_id for 99 heading 'I'
col status for a10
col type for a10
col member for a60
col group# for 99 heading 'G'
col thread# for 9 heading 'T'
col bytes for 9999999 heading 'bytes|M'
/* Formatted on 2012-11-6 13:59:59 (QP5 v5.185.11230.41888) */
SELECT
       a.group#,
       b.thread#,
       b.status,
       a.TYPE,
       round(bytes/1024/1024) bytes,
       a.status,
       b.FIRST_CHANGE#,
       b.NEXT_CHANGE#,
       a.MEMBER,
       TO_CHAR (first_time, 'yyyymmdd hh24:mi:ss') f_time
  FROM v$logfile a, v$log b
 WHERE a.group# = b.group#
UNION ALL
SELECT
       a.group#,
       b.thread#,
       b.status,
       a.TYPE,
       bytes / 1024 / 1024,
       a.status,
       b.FIRST_CHANGE#,
       b.NEXT_CHANGE#,
       a.MEMBER,
       TO_CHAR (first_time, 'yyyymmdd hh24:mi:ss')
  FROM v$logfile a, v$standby_log b
 WHERE  a.group# = b.group#
ORDER BY thread#,group#
/
clear    breaks

select value from v$parameter where name='control_files';

select value from v$parameter where name='spfile';

