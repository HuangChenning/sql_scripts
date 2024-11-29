set echo off
set lines 3000 pages 4000 heading on verify off
col group_name for a15
col number_name for a30 heading 'DATAFILE|NUMBER_NAME'
col p_extent_number for 999999999 heading 'PHYSICS|EXTENT_NUMBER'
col extent_number for 9999999999 heading 'EXTENT_NUMBER'
col l_extent_number for 99999999999 heading 'LOGICAL_NUMBER'
col disk_name for a25 heading 'DISK_NUMBER|DISK_NMAE'
COL AU_NUMBER FOR 999999999 HEADING 'AU_NUMBER'
select d.name group_name,
       a.NUMBER_KFFXP || '.' || b.NAME number_name,
       a.PXN_KFFXP p_extent_number,
       a.XNUM_KFFXP extent_number,
       a.LXN_KFFXP l_extent_number,
       a.DISK_KFFXP || '.' || c.name disk_name,
       a.AU_KFFXP au_number,
       count(a.au_kffxp) over(partition by b.NAME, lxn_kffxp order by a.xnum_kffxp) total_au
  from x$kffxp a, v$asm_alias b, v$asm_disk c, v$asm_diskgroup d
 where a.GROUP_KFFXP = b.GROUP_NUMBER
   and a.NUMBER_KFFXP = b.FILE_NUMBER
   and a.group_kffxp = d.group_number
   and a.group_kffxp = c.GROUP_NUMBER
   and a.disk_kffxp = c.disk_number
   and b.SYSTEM_CREATED = 'Y'
   and a.xnum_kffxp<>2147483648
   and a.number_kffxp = nvl('&file_number', a.number_kffxp)
   and b.name = nvl('&filename', b.name)
/
