select d.value || '/' || lower(rtrim(i.instance, chr(0))) || '_ora_' ||
       p.spid || '.trc' trace_file_name
  from (select p.spid
          from sys.v$mystat m, sys.v$session s, sys.v$process p
         where m.statistic# = 1
           and s.sid = m.sid
           and p.addr = s.paddr) p,
       (select t.instance
          from sys.v$thread t, sys.v$parameter v
         where v.name = 'thread'
           and (v.value = 0 or t.thread# = to_number(v.value))) i,
       (select value from sys.v$parameter where name = 'user_dump_dest') d
/
