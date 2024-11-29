set echo off;
set lines 400 pages 1000 heading on verify off;
col file_name1 new_value file_name1 noprint;
select 'migrate_datagurad_check_info_'||to_char(sysdate,'yyyymmddhh24miss')||'_'||name file_name1 from v$database;

spool  &file_name1;

col inst_id        for 9       heading 'I'
col db_unique_name for a20     heading 'DB_U_NAME'
col name           for a10     heading 'DB_NAME'
col log_mode       for a10     heading 'ARCH?'
col force_logging  for a10     heading 'FORCE?'
col platform_name  for a20
col flashback_on   for a3      heading 'FON'
col database_role  for a10     heading 'DB_ROLE'
col switchover_status   for a20  heading 'S_STATUS'
col DATAGUARD_BROKER    for a10  heading 'BROKER?'


col action         format a20
col namespace      format a10
col version        format a10
col comments       format a50
col action_time    format a30
col bundle_series  format a15
col comp_name      for a50
col comp_id        for a25
col schema         for a15
col patch_id       for 9999999999
col version        for a10
col action         for a10
col status         for a10
col banner         for a90
col DESCRIPTION    for a60
col BUNDLE_SERIES  for a10 heading 'BUNDLE'



col  pdb_name          for  a8                       heading 'PDB_NAME';
col  tablespace_name   for  a15                      heading 'TABLESPACE';
col  file_id           for  9999                     heading 'FILE|ID';
col  RELATIVE_FNO      for  9999                     heading 'RFID';
col  status            for  a10                      heading 'STATUS';
col  bytes             for  99999                    heading 'SIZEM';
col  maxbytes          for  99999                    heading 'MSIZE';
col FILE_NAME          for  a90                      heading 'FILE_NAME';
col AUTOEXTENSIBLE     for  a5                       heading 'AUTO?';


col p_name             for a40                heading    'NAME'
col p_value            for a100                heading    'DISPLAY_VALUE'


COLUMN bs_key                 FORMAT 999999                 HEADING 'BS|Key'
COLUMN backup_type            FORMAT a14                    HEADING 'Backup|Type'
COLUMN device_type            FORMAT a10                    HEADING 'Device|Type'
COLUMN controlfile_included   FORMAT a11                    HEADING 'Controlfile|Included?'
COLUMN spfile_included        FORMAT a9                     HEADING 'SPFILE|Included?'
COLUMN incremental_level      FORMAT 999999                 HEADING 'Inc.|Level'
COLUMN pieces                 FORMAT 9,999                  HEADING '# of|Pieces'
COLUMN start_time             FORMAT a19                    HEADING 'Start|Time'
COLUMN completion_time        FORMAT a19                    HEADING 'End|Time'
COLUMN elapsed_seconds        FORMAT 999,999                HEADING 'Elapsed|Seconds'
COLUMN tag                    FORMAT a19                    HEADING 'Tag'
COLUMN block_size             FORMAT 999,999                HEADING 'Block|Size'


col Day for a12
col Date for a12
set linesize 175
set pages 100
col h0 for 999
col h1 for 999
col h2 for 999
col h3 for 999
col h4 for 999
col h5 for 999
col h6 for 999
col h7 for 999
col h8 for 999
col h9 for 999
col h10 for 999
col h11 for 999
col h12 for 999
col h13 for 999
col h14 for 999
col h15 for 999
col h16 for 999
col h17 for 999
col h18 for 999
col h19 for 999
col h20 for 999
col h21 for 999
col h22 for 999
col h23 for 999

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

alter session set nls_timestamp_format = 'yyyy-mm-dd hh24:mi:ss.ff';



select DB_UNIQUE_NAME,name,log_mode,FORCE_LOGGING,PLATFORM_NAME,FLASHBACK_ON,DATABASE_ROLE ,SWITCHOVER_STATUS,DATAGUARD_BROKER from v$database;


SELECT inst_id,
       stat_name os_info,
       CASE
           WHEN stat_name = 'PHYSICAL_MEMORY_BYTES'
           THEN
               TRUNC (VALUE / 1024 / 1024 / 1024)
           ELSE
               VALUE
       END
           VALUE
  FROM gv$osstat
 WHERE stat_name IN ('NUM_CPUS',
                     'NUM_CPU_CORES',
                     'NUM_CPU_SOCKETS',
                     'PHYSICAL_MEMORY_BYTES')
 /

select * from v$version
/
select comp_id, comp_name, schema,version, status from sys.dba_registry
/

select
&_VERSION_11  * from dba_registry_history order by 1
&_VERSION_12  substr(ACTION_TIME,1,18) ACTION_TIME ,patch_id,version,action,status,BUNDLE_SERIES,BUNDLE_ID,DESCRIPTION from dba_registry_sqlpatch order by 1
/



  SELECT
   a.tablespace_name,
        a.file_name,
        a.file_id,
        trunc(a.bytes / 1024 / 1024) bytes,
        trunc(a.MAXBYTES / 1024 / 1024) maxbytes
   from dba_data_files a
  ORDER BY a.tablespace_name,a.file_id

/



select trunc(sum(bytes)/1024/1024/1024) total_size from dba_data_files;

SELECT inst_id,
       name p_name,
       DISPLAY_VALUE p_value
  FROM sys.gv$parameter
 WHERE isdefault='FALSE' order by inst_id,name
/


SELECT
    bs.recid                                              bs_key
  , DECODE(backup_type
           , 'L', 'Archived Logs'
           , 'D', 'Datafile Full'
           , 'I', 'Incremental')                          backup_type
  , device_type                                           device_type
  , DECODE(   bs.controlfile_included
            , 'NO', null
            , bs.controlfile_included)                    controlfile_included
  , sp.spfile_included                                    spfile_included
  , bs.incremental_level                                  incremental_level
  , bs.pieces                                             pieces
  , TO_CHAR(bs.start_time, 'mm/dd/yyyy HH24:MI:SS')       start_time
  , TO_CHAR(bs.completion_time, 'mm/dd/yyyy HH24:MI:SS')  completion_time
  , bs.elapsed_seconds                                    elapsed_seconds
  , bp.tag                                                tag
  , bs.block_size                                         block_size
FROM
    v$backup_set                           bs
  , (select distinct
         set_stamp
       , set_count
       , tag
       , device_type
     from v$backup_piece
     where status in ('A', 'X'))           bp
 ,  (select distinct
         set_stamp
       , set_count
       , 'YES'     spfile_included
     from v$backup_spfile)                 sp
WHERE
      bs.set_stamp = bp.set_stamp
  AND bs.set_count = bp.set_count
  AND bs.set_stamp = sp.set_stamp (+)
  AND bs.set_count = sp.set_count (+)
  AND backup_type  in ('D','I')
ORDER BY
    bs.recid
/

col dest_id            for   99              heading 'ID'
col dest_name          for   a40
col error              for   a80


select dest_id,dest_name,db_unique_name, error from v$archive_dest where status='VALID';



 SELECT  to_char(first_time,'yyyy-mm-dd') "Date",
         TO_CHAR (first_time, 'Dy') "Day",
         COUNT (1) "Total",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '00', 1, 0)) "h0",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '01', 1, 0)) "h1",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '02', 1, 0)) "h2",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '03', 1, 0)) "h3",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '04', 1, 0)) "h4",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '05', 1, 0)) "h5",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '06', 1, 0)) "h6",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '07', 1, 0)) "h7",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '08', 1, 0)) "h8",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '09', 1, 0)) "h9",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '10', 1, 0)) "h10",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '11', 1, 0)) "h11",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '12', 1, 0)) "h12",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '13', 1, 0)) "h13",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '14', 1, 0)) "h14",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '15', 1, 0)) "h15",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '16', 1, 0)) "h16",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '17', 1, 0)) "h17",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '18', 1, 0)) "h18",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '19', 1, 0)) "h19",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '20', 1, 0)) "h20",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '21', 1, 0)) "h21",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '22', 1, 0)) "h22",
         SUM (DECODE (TO_CHAR (first_time, 'hh24'), '23', 1, 0)) "h23",
         ROUND (COUNT (1) / 24, 2) "Avg"
    FROM V$log_history
GROUP BY to_char(first_time,'yyyy-mm-dd'), TO_CHAR (first_time, 'Dy')
ORDER BY 1
/

col first_time for a20
col redo for 9999999999 heading 'REDO(G)'
  SELECT TO_CHAR (TRUNC (first_time), 'yyyy-mm-dd')                 first_time,
         TRUNC (SUM (blocks) * SUM (block_size) / 1024 / 1024 / 1024) redo
    FROM (SELECT DISTINCT THREAD#,
                          SEQUENCE#,
                          first_time,
                          blocks,
                          block_size
            FROM v$archived_log)
GROUP BY TRUNC (first_time)
ORDER BY 1
/

COLUMN disk_group_name        FORMAT a16           HEAD 'Disk Group Name'
COLUMN disk_file_path         FORMAT a33           HEAD 'Path'
COLUMN disk_file_name         FORMAT a25           HEAD 'File Name'
COLUMN disk_file_fail_group   FORMAT a20           HEAD 'Fail Group'
COLUMN total_mb               FORMAT 999,999,999   HEAD 'File Size (MB)'
COLUMN os_mb                  FORMAT 999,999,999   HEAD 'Os Size (MB)'
COLUMN used_mb                FORMAT 999,999,999   HEAD 'Used Size (MB)'
COLUMN pct_used               FORMAT 999.99        HEAD 'Pct. Used'
COLUMN disk_header_status          HEAD 'Header|Status'
COLUMN FAILGROUP_TYPE         FORMAT a9            HEAD 'FAILGROUP|TYPE'
col mount_status heading 'Mount|Status'
col mode_status  heading 'Mode|Status'
BREAK ON disk_group_name ON disk_file_fail_group SKIP 1


SELECT NVL (a.name, '[CANDIDATE]') disk_group_name,
         b.failgroup disk_file_fail_group,
         b.PATH disk_file_path,
         b.name disk_file_name,
         b.header_status disk_header_status,
         b.mount_status,
         b.total_mb total_mb,
         (b.total_mb - b.free_mb) used_mb
    FROM v$asm_diskgroup a RIGHT OUTER JOIN v$asm_disk b USING (group_number)
ORDER BY a.name, b.failgroup, b.PATH
/




col name for a15 heading 'GROUP_NAME'
col volume_device for a25 heading 'VOLUME_PATH'
col size_mb for 99999 heading 'VOLUME|SIZE_MB'
col TOTAL_FREE for 99999 heading 'FILE|FREE_MB'
col CORRUPT for a10 heading 'CORRUPT'
col REDUNDANCY for a10 heading 'REDUNDA'
col COLUMN_STRIPE for a6 heading 'COLUMN|STRIPE'
col usage for a10 heading 'USAGE'
col file_state for a15 heading 'FILE_STATE'
col volume_stat for a10 heading 'VOL_STATE'
col mountpath for a15
select b.name,
       a.VOLUME_DEVICE,
       a.SIZE_MB,
       c.TOTAL_FREE,
       a.REDUNDANCY,
       a.STRIPE_COLUMNS||'.'||a.STRIPE_WIDTH_K COLUMN_STRIPE,
       a.USAGE,
       a.state volume_stat,
       c.CORRUPT,
       c.STATE file_state,
       a.MOUNTPATH
  from v$asm_volume a, v$asm_diskgroup b, V$ASM_FILESYSTEM c
 where a.group_number = b.group_number
   and a.VOLUME_NUMBER = c.NUM_VOL(+)

/


!cat /proc/meminfo
!cat /etc/sysctl.conf|grep -v ^#
!df -h
!ifconfig -a|grep -E "mtu|HWaddr"|grep -v lo|awk -F: '{print $1}' |awk '{print $1}'|uniq| xargs -I {} ethtool {}
exit;

