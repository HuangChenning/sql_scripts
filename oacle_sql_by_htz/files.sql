set echo off
SET LINESIZE 145
SET PAGESIZE 9999
SET VERIFY   OFF

COLUMN db NEW_VALUE xdb NOPRINT FORMAT a1

COLUMN type        FORMAT a8                 HEADING 'Type'
COLUMN tablespace  FORMAT a15                HEADING 'Tablspace'
COLUMN filename    FORMAT a65                HEADING 'Filename'
COLUMN filesize    FORMAT 9,999,999,999,999  HEADING 'File Size'
COLUMN stat        FORMAT a10                HEADING 'Status'
COLUMN seq         FORMAT 9999999            HEADING 'Sequence'
COLUMN arc         FORMAT a4                 HEADING 'Archived'

SELECT name db
FROM   v$database;

SELECT
    'Data'                        type
  , tablespace_name               tablespace
  , REPLACE(file_name,'?','&xdb') filename
  , bytes                         filesize
  , DECODE(status,'AVAILABLE','Available','INVALID','Invalid','****') stat
  , 0                              seq
  , ''                             arc
FROM dba_data_files
UNION
SELECT
    'Redo'
  , 'Grp ' || a.group#
  , member
  , bytes
  , DECODE(b.status,'CURRENT','Current','INACTIVE','Inactive','UNUSED','Unused','****')
  , sequence#
  , archived
FROM
    v$logfile  a
  , v$log      b
WHERE
    a.group# = b.group#
UNION
SELECT
    'Parm'
  , 'Ctrl 1'
  , REPLACE(NVL(LTRIM(SUBSTR(value,1,instr(value||',',',',1,1)-1)),'  (none)'),
   '?','&xdb') file_name
  , 0
  , ''
  , 0
  , ''
FROM
    v$parameter
WHERE
    name = 'control_files'
UNION
SELECT
    'Parm'
  , 'Ctrl 2'
  , REPLACE(nvl(ltrim(substr(value,instr(value||',',',',1,1)+1,
    instr(value||',',',',1,2)-instr(value||',',',',1,1)-1)),'  (none)'),
    '?' ,'&xdb') file_name
  , 0
  , ''
  , 0
  , ''
FROM
    v$parameter
WHERE
    name = 'control_files'
UNION
SELECT
    'Parm'
  , 'Ctrl 3'
  , REPLACE(nvl(ltrim(substr(value,instr(value||',',',',1,2)+1,
    instr(value||',',',',1,3)-instr(value||',',',',1,2)-1)),'  (none)'),
    '?','&xdb') file_name
  , 0
  , ''
  , 0
  , ''
FROM
    v$parameter
WHERE
    name = 'control_files'
UNION
SELECT
    'Parm'
  , 'Ctrl 4'
  , REPLACE(nvl(ltrim(substr(value,instr(value||',',',',1,3)+1,
    instr(value||',',',',1,4)-instr(value||',',',',1,3)-1)),'  (none)'),
    '?','&xdb') file_name
  , 0
  , ''
  , 0
  , ''
FROM
    v$parameter
WHERE
    name = 'control_files'
UNION
SELECT
    'Parm'
  , 'spfile'
  , REPLACE(value,'?','&xdb') file_name
  , 0
  , ''
  , 0
  , ''
FROM
    v$parameter
WHERE
    name = 'spfile' or name='pfile'
UNION
SELECT
    'Parm'
  , 'Archive'
  , DECODE(d.log_mode, 'ARCHIVELOG',
                       REPLACE(p.value,'?','&xdb') || ' - ENABLED',
                       REPLACE(p.value,'?','&xdb') || ' - Disabled') file_name
  , 0
  , ''
  , 0
  , ''
FROM
    v$parameter p
  , v$database  d
WHERE
    p.name = 'log_archive_dest'
UNION
SELECT 
    'Tempfile' type
  , tablespace_name
  , REPLACE(file_name,'?','$input{Oracle_SID_Name}') tempfile_name
  , bytes
  , DECODE(status,'AVAILABLE','Available','INVALID','Invalid','****') stat
  , 0
  , ''
FROM dba_temp_files
ORDER BY 1,2,3
/

