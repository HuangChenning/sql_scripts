set echo off;
set lines 300 pages 1000 heading on verify off
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

set lines 78
