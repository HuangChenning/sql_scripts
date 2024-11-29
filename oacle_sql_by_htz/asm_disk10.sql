SET ECHO        OFF
SET FEEDBACK    6
SET HEADING     ON
SET LINESIZE    220
SET PAGESIZE    50000
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
SET VERIFY      OFF

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

COLUMN disk_group_name        FORMAT a15           HEAD 'Disk Group Name'
COLUMN disk_file_path         FORMAT a30           HEAD 'Path'
COLUMN disk_file_name         FORMAT a25           HEAD 'File Name'
COLUMN disk_file_fail_group   FORMAT a15           HEAD 'Fail Group'
COLUMN total_mb               FORMAT 999,999,999   HEAD 'File Size (MB)'
COLUMN os_mb                  FORMAT 999,999,999   HEAD 'Os Size (MB)'
COLUMN used_mb                FORMAT 999,999,999   HEAD 'Used Size (MB)'
COLUMN pct_used               FORMAT 999.99        HEAD 'Pct. Used'
COLUMN disk_header_status          HEAD 'Header|Status'
COLUMN FAILGROUP_TYPE					FORMAT a9 					 HEAD 'FAILGROUP|TYPE'
col mount_status heading 'Mount|Status'
col mode_status  heading 'Mode|Status'
BREAK ON report ON disk_group_name SKIP 1

COMPUTE sum LABEL ""              OF total_mb used_mb ON disk_group_name
COMPUTE sum LABEL "Grand Total: " OF total_mb used_mb ON report

SELECT
    NVL(a.name, '[CANDIDATE]')                       disk_group_name
  , b.path                                           disk_file_path
  , b.name                                           disk_file_name
  , b.failgroup                                      disk_file_fail_group
  , b.header_status                                  disk_header_status
  , b.mount_status
  , b.mode_status
  , b.total_mb                                       total_mb
  , (b.total_mb - b.free_mb)                         used_mb
  , ROUND((1- (b.free_mb/decode(b.total_mb,0,1,b.total_mb)))*100, 2)      pct_used
FROM
    v$asm_diskgroup a RIGHT OUTER JOIN v$asm_disk b USING (group_number)
ORDER BY
    a.name,b.path
/
