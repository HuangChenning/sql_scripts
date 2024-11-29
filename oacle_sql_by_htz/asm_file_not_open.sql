# 11G,10g
set echo off
set lines 200 pages 1000 heading on 
col gnum for 999
col filnum for 99999
col fullpath for a100

SELECT gnum, filnum, concat('+' || gname, sys_connect_by_path(aname, '/')) fullpath
  FROM (SELECT g.name            gname,
               a.parent_index    pindex,
               a.name            aname,
               a.reference_index rindex,
               a.group_number    gnum,
               a.file_number     filnum
          FROM v$asm_alias a, v$asm_diskgroup g
         WHERE a.group_number = g.group_number)
 START WITH (mod(pindex, power(2, 24))) = 0
CONNECT BY PRIOR rindex = pindex
/
