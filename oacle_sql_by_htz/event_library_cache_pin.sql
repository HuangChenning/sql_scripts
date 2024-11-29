set echo off
set verify off heading on
set serveroutput on
set pages 9999;
set lines 200;
col sess   for a25;
col mod_req for a15 heading 'KGLLKMOD|KGLLKREQ'
col user_status for a20 heading 'USERNAME|STATUS'
col client for a20;
col osuser for a10;
col program for a15;
col command for a15;
col program for a20
col ievent for a20
col r_lock for a10 heading 'HAVE LOCK|REQ LOCK'
col sql_id for a19
select distinct DECODE(p.KGLlkREQ, 0, 'H:', 'W:')||s.sid || ':' ||
       s.serial# || ':' || o.spid || '.' || s.last_call_et sess,
       s.username || ':' || s.status user_status,
       DECODE(s.sql_id, '0', s.prev_sql_id, s.sql_id) sql_id,
       p.kgllkmod || '.' || p.kgllkreq r_lock,
       w.p1raw "HANDLE",
       b.name as command,
       substr(w.event, 1, 20) ievent,
       substr(s.program, 1, 20) program,
       substr(s.osuser || '@' || s.machine || '@' || s.process, 1, 19) as client
  FROM v$session_wait w,
       dba_kgllock    p,
       v$session      s,
       v$process      o,
       audit_actions  b
 WHERE p.kgllkuse = s.saddr
   AND kgllkhdl = w.p1raw
   and s.paddr = o.addr
   and s.command = b.action
   and p.kgllkhdl in
       (select p1raw from v$session_wait a where a.event like 'library%')
 ORDER BY handle,sess
 /
col KGLNAOBJ for a20
col KGLNAOWN for a20
select addr, kglhdadr as "handle", kglhdpar, kglnaown, kglnaobj, kglnahsh, kglhdobj
  from x$kglob
 where kglhdadr IN
       (select /*+ unnest */p1raw from gv$session_wait where event like 'library%') 
       /
clear    breaks 