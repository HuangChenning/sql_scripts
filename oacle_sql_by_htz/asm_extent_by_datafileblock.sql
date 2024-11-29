set echo off
set lines 3000 pages 4000 heading on verify off
col group_name for a15
col number_name for a30 heading 'DATAFILE|NUMBER_NAME'
col p_extent_number for 999999999 heading 'PHYSICS|EXTENT_NUMBER'
col extent_number for 999999999 heading 'EXTENT_NUMBER'
col l_extent_number for 999999999 heading 'LOGICAL_NUMBER'
col disk_name for a25 heading 'DISK_NUMBER|DISK_NMAE'
COL AU_NUMBER FOR 999999 HEADING 'EXTENT|NUMBER'
col extent_begin_block for 99999999999 heading 'EXTENT|BEGIN_BLOCK'
col extent_end_block for 99999999999 heading 'EXTENT|END_BLOCK'
col BEGIN_BLOCK for a10
col end_block for 99999999
undefine file_number;
undefine filename;
undefine file_type;
undefine block;
select group_name,
       number_name,
       p_extent_number,
       extent_number,
       l_extent_number,
       disk_name,
       au_number,
       extent_begin_block,
       (extent_begin_block + nvl('&&block', 1)) DISK_BLOCK,
       extent_end_block,
       total_au,
       decode(begin_block,'0','1',begin_block) begin_block,
       end_block
  from (select group_name,
               number_name,
               p_extent_number,
               extent_number,
               l_extent_number,
               disk_name,
               au_number,
               au_number * 1024 / 8 extent_begin_block,
               ((au_number + 1) * 1024 / 8-1) extent_end_block,
               total_au,
               ((lag(total_au, 1, 0) over(order by total_au)) * 1024 / 8) begin_block,
               ((total_au * 1024 / 8)-1) end_block
          from (select d.name group_name,
                       a.NUMBER_KFFXP || '.' || b.NAME number_name,
                       a.PXN_KFFXP p_extent_number,
                       a.XNUM_KFFXP extent_number,
                       a.LXN_KFFXP l_extent_number,
                       a.DISK_KFFXP || '.' || c.name disk_name,
                       a.AU_KFFXP au_number,
                       count(a.au_kffxp) over(partition by b.NAME, lxn_kffxp order by a.xnum_kffxp) total_au
                  from x$kffxp         a,
                       v$asm_alias     b,
                       v$asm_disk      c,
                       v$asm_diskgroup d
                 where a.GROUP_KFFXP = b.GROUP_NUMBER
                   and a.NUMBER_KFFXP = b.FILE_NUMBER
                   and a.group_kffxp = d.group_number
                   and a.group_kffxp = c.GROUP_NUMBER
                   and a.disk_kffxp = c.disk_number
                   and b.SYSTEM_CREATED = 'Y'
                   and a.xnum_kffxp <> 2147483648
                   and a.number_kffxp = nvl('&&file_number', a.number_kffxp)
                   and substr(b.name, instr(b.name, '.', 1, 2) + 1) in
                       (select INCARNATION
                          from v$asm_file
                         where file_number = nvl('&&file_number', file_number)
                           and type = nvl(upper('&file_type'), type))
                   and b.name = nvl('&filename', b.name)))
 where nvl('&&block', begin_block) between begin_block and end_block
 order by number_name, extent_number
/

undefine file_number;
undefine filename;
undefine file_type;
undefine block;
