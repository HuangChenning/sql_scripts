set lines 200
set pages 40
col group_name for a20
col disk_name for a30
col ext_nu for 999999999999 heading 'VIRTUAL|EXTENT_NUM'
break on group_name on disk_name;
select c.name group_name,
       a.path disk_name,     
       b.xnum_kffxp ext_nu,
       b.AU_KFFXP au_num,
       b.COMPOUND_KFFXP COMPOUND_INDEX,
       b.INCARN_KFFXP INCARNATION,
       decode(b.FLAGS_KFFXP,
              '0',
              'PAIMARY',
              '1',
              'MIRROR',
              '2',
              '2ND MIRROR') au_type
  from v$asm_disk a, x$kffxp b, v$asm_diskgroup c
 where a.disk_number = b.disk_kffxp
   and b.group_kffxp = c.group_number
   and c.group_number = a.group_number
   and number_kffxp = '&file_id'
 order by 3;
clear breaks;
