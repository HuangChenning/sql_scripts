set echo off
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col user_ublk for 9999999999999 heading 'USED UNDO BLOCKS'
col used_urec for 9999999999999 heading 'USED UNDO RECORDS'
col t_size for 999999999.99 heading 'USED UNDO SIZE(M)'
ACCEPT sid prompt 'Enter Search Sid (i.e. 12) : ' default '' 

select s.sid,
       USED_UBLK "UNDO BLOCKS USED",
       round(used_ublk * a.block_size / 1024 / 1024, 2) t_size,
       used_urec "UNDO RECORDS USED"
  from v$transaction t, v$session s, dba_tablespaces a
 where s.sid = nvl('&sid', s.sid)
   and s.taddr = t.addr
   and a.tablespace_name =
       (select distinct tablespace_name
	     from dba_data_files f, v$transaction t1
	     where f.file_id = t1.UBAFIL)

/
clear    breaks  
