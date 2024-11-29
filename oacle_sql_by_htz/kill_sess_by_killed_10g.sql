set echo off
set lines 300 heading on pages 10000 verify off
col kill for a30 
col program for a20

select 'kill -9 '||spid kill, program from v$process 
       where program!= 'PSEUDO' 
       and addr not in (select paddr from v$session)
       and addr not in (select paddr from v$bgprocess)
       and addr not in (select paddr from v$shared_server) order by program;