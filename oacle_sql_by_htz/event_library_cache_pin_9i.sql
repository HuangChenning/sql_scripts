store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set pages 9999;
set lines 200;
col sess for a35 heading 'SID:SERIAL:SPID:LAST_CALL_ET'
col user_status for a20 heading 'USERNAME|STATUS'
col client for a15;
col osuser for a10;
col command for a15;
col program for a20
col ievent for a20
col r_lock for a8 heading 'LOCK|HAVE:REQ'
col hash_value for 999999999999
col client for a20
select /*+ rule */DECODE(p.KGLlkREQ, 0, 'Holder: ', 'Waiter: ') || w.inst_id || ':' ||
       s.sid || ':' || s.serial# || ':' || o.spid||'.'||s.last_call_et sess,
       s.username || ':' || s.status user_status,
       DECODE(s.sql_hash_value, '0', s.prev_hash_value, s.sql_hash_value) hash_value,
       p.kgllkmod || '.' || p.kgllkreq r_lock,
       w.p1raw "HANDLE",
       b.name as command,
       p.KGLLKTYPE lock_type,
       to_char(s.logon_time, 'dd hh24:mi') as logon_time,
       substr(s.program, 1, 20) program,
       substr(s.osuser || '@' || s.machine || '@' || s.process,1,19) as client
  FROM gv$session_wait w,
       dba_kgllock     p,
       gv$session      s,
       gv$process      o,
       audit_actions   b
 WHERE p.kgllkuse = s.saddr
   AND kgllkhdl = w.p1raw
   and (kgllkhdl) in (select kgllkhdl from dba_kgllock where kgllkreq>0)
   and s.paddr = o.addr
   and s.command = b.action
   and w.inst_id = s.inst_id
   and s.inst_id = o.inst_id
  ORDER BY  handle
 /
col KGLNAOBJ for a20
col KGLNAOWN for a20
select /*+ rule */addr, kglhdadr as "handle", kglhdpar, kglnaown, kglnaobj, kglnahsh, kglhdobj
  from x$kglob
 where kglhdadr IN
       (select p1raw from v$session_wait where event like 'library%') 
       /
clear    breaks  
@sqlplusset

