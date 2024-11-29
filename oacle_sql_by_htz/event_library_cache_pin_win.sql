store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set pages 9999;
set lines 200;
col sesspro   for a20;
col user_status for a20 heading 'USERNAME|STATUS'
col client for a15;
col osuser for a10;
col program for a15;
col command for a15;
col program for a30
col ievent for a20
col r_lock for a25 heading 'HAVE LOCK:REQ LOCK'
col sql_id for a19
col p3 for 9999
col namespace for a10
select s.sid || ',' || s.serial# || ',' || spid as "sesspro",
       s.username || ':' || s.status user_status,
       substr(s.program, 1, 30) program,
       substr(s.osuser || '@' || s.machine || '@' || s.process, 1, 29) as client,
       DECODE(s.sql_id, '0', s.prev_sql_id, s.sql_id) || ':' ||
       sql_child_number sql_id,
       DECODE(kglpnmod,
              0,
              'no lock',
              1,
              'null lock',
              2,
              'share lock',
              3,
              'exclusive lock') || ':' ||
       DECODE(kglpnreq,
              0,
              'no lock',
              1,
              'null lock',
              2,
              'share lock',
              3,
              'exclusive lock') r_lock,
       w.p1raw "HANDLE|P1RAW",
       b.name as command,
       substr(s.event, 1, 20) ievent,
       to_char(s.logon_time, 'dd hh24:mi') as logon_tim
  from v$session_wait w,
       v$session      s,
       x$kglpn        p,
       v$process      o,
       audit_actions  b
 where w.event like '%library%'
   and w.sid = s.sid
   and p.kglpnuse = s.saddr
   and o.addr = s.paddr
   and s.command = b.action
/
set lines 170
col object for a30 heading 'OBJECT|OWNER:NAME'
select addr, kglhdadr as "handle", kglhdpar,  kglnahsh, kglhdobj, kglnaown||':'||kglnaobj object,object_type
  from x$kglob a,dba_objects b 
 where kglhdadr IN
       (select substr(p1raw,-8,8) from v$session_wait where event like 'library%') and a.kglnaobj=b.object_name 
       /
clear    breaks  
@sqlplusset

