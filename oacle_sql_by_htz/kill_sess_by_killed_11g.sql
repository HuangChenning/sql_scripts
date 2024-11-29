set echo off
set lines 300 heading on pages 10000 verify off
select 'kill -9 '||spid,program from v$process where addr in (select creator_addr from v$session where status='KILLED');