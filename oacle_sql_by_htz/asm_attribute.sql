set echo off
set lines 300  pages 100 heading on verify off
col groupname for a20 heading 'DISKGROUPNAME'
col name      for a50
col value     for a50
col system_created for a3  heading 'SYS'
break on groupname
select b.name groupname,a.name,a.value,a.system_created from V$ASM_ATTRIBUTE a ,v$asm_diskgroup b where a.group_number=b.group_number and b.name=nvl(upper('&diskgroup'),b.name) order by 1,2;