/* Formatted on 2014/8/14 13:50:35 (QP5 v5.240.12305.39446) */
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
/* Formatted on 2014/8/14 16:38:20 (QP5 v5.240.12305.39446) */
  SELECT group_name,
         number_name,
         p_extent_number,
         extent_number,
         l_extent_number,
         disk_name,
         au_number,
           extent_begin_block
         + (&&block - DECODE (begin_block, '0', '1', begin_block))
            disk_block,
         extent_begin_block,
         extent_end_block,
         total_au,
         DECODE (begin_block, '0', '1', begin_block) begin_block,
         end_block
    FROM (SELECT group_name,
                 number_name,
                 p_extent_number,
                 extent_number,
                 l_extent_number,
                 disk_name,
                 au_number,
                 au_number * 1024 / 8 extent_begin_block,
                 ( (au_number + 1) * 1024 / 8 - 1) extent_end_block,
                 total_au,
                 ( (LAG (total_au, 1, 0) OVER (ORDER BY total_au)) * 1024 / 8)
                    begin_block,
                 ( (total_au * 1024 / 8) - 1) end_block
            FROM (SELECT d.name group_name,
                         a.NUMBER_KFFXP || '.' || b.NAME number_name,
                         a.PXN_KFFXP p_extent_number,
                         a.XNUM_KFFXP extent_number,
                         a.LXN_KFFXP l_extent_number,
                         a.DISK_KFFXP || '.' || c.name disk_name,
                         a.AU_KFFXP au_number,
                         COUNT (
                            a.au_kffxp)
                         OVER (PARTITION BY b.NAME, lxn_kffxp
                               ORDER BY a.xnum_kffxp)
                            total_au
                    FROM x$kffxp a,
                         v$asm_alias b,
                         v$asm_disk c,
                         v$asm_diskgroup d
                   WHERE     a.GROUP_KFFXP = b.GROUP_NUMBER
                         AND a.NUMBER_KFFXP = b.FILE_NUMBER
                         AND a.group_kffxp = d.group_number
                         AND a.group_kffxp = c.GROUP_NUMBER
                         AND a.disk_kffxp = c.disk_number
                         AND b.SYSTEM_CREATED = 'Y'
                         AND a.xnum_kffxp <> 2147483648
                         AND a.number_kffxp =
                                NVL ('&&file_number', a.number_kffxp)
                         AND SUBSTR (b.name,
                                       INSTR (b.name,
                                              '.',
                                              1,
                                              2)
                                     + 1) IN
                                (SELECT INCARNATION
                                   FROM v$asm_file
                                  WHERE     file_number =
                                               NVL ('&&file_number',
                                                    file_number)
                                        AND TYPE =
                                               NVL (UPPER ('&&file_type'),
                                                    TYPE))
                         AND b.name = NVL ('&&filename', b.name)))
   WHERE NVL ('&&block', begin_block) BETWEEN begin_block AND end_block
ORDER BY number_name, extent_number
/
undefine file_number;
undefine filename;
undefine file_type;
undefine block;