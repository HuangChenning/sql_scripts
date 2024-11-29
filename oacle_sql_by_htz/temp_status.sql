set pages 9999;
set echo off
set lines 800;
set feedback off
col sess   for a15;
col status for a10;
col username for a20;
col client for a25;
col osuser for a10;
col program for a30;
col max_gb   for 999999.99
col temp_gb  for 999999.99
col used_gb  for 999999.99
col allocated_gb  for 999999.99
col free_gb  for 999999.99
col alloc_free%  for 999.99
col max_free%  for 999.99
col tablespace_name for a16
prompt ******************  temp tablespace ****************
select * from (select c.tablespace_name,
                                                         sum(decode(c.maxbytes, 0, c.bytes, maxbytes)) / 1024 / 1024 / 1024 max_gb,
                                                         sum(c.bytes) / 1024 / 1024 / 1024 temp_gb
                                        from dba_temp_files c
                                 group by tablespace_name) b;
prompt ******************* user temp tablespace *************************
select tablespace,
                         sum(a.blocks * b.value / 1024 / 1024 / 1024) used_temp_gb
        from gv$sort_usage a, v$parameter b
 where b.name = 'db_block_size'
 group by tablespace;
prompt ***************** user % temp tablespace ***************************
select d.tablespace_name,
                         d.max_gb,
                         d.temp_gb allocated_gb,
                         d.temp_gb - e.used_gb free_gb,
                         (d.temp_gb - e.used_gb)*100/d.temp_gb "alloc_free%",
                         (d.max_gb - e.used_gb)*100/d.max_gb "max_free%"
        from (select c.tablespace_name,
                                                         sum(decode(c.maxbytes, 0, c.bytes, maxbytes))/1024/1024/1024 max_gb,
                                                         sum(c.bytes)/1024/1024/1024 temp_gb
                                        from dba_temp_files c
                                 group by tablespace_name) d,
                         (select sum(nvl(a.blocks, 0) * b.value/1024/1024/1024) used_gb
                                        from v$sort_usage a, v$parameter b
                                 where b.name = 'db_block_size'
                                 group by a.tablespace) e;
prompt ****************** about sqlid with user temp tablespace ****************   
SELECT sqlid,
       segtype,
       size_g
FROM
  (SELECT ktssosqlid sqlid,
          segtype,
          trunc(sum(ktssoblks*p.value)/1024/1024/1024) size_g
   FROM
     (SELECT ktssosqlid,
             decode(ktssosegt, 1, 'SORT', 2, 'HASH', 3, 'DATA', 4, 'INDEX', 5, 'LOB_DATA', 6, 'LOB_INDEX' , 'UNDEFINED') SEGTYPE,
             ktssoblks
      FROM x$ktsso) a,
     (SELECT value
      FROM v$parameter
      WHERE name='db_block_size') p
   GROUP BY ktssosqlid,
            segtype)
WHERE size_g>0.5
ORDER BY 3
/                        
prompt ****************** about session with user temp tablespace ****************                       
select /*+ rule */ s.sid || ',' || s.serial# as sess,
                         s.username,
                         s.status,
                         substr(s.program, 1, 39) program,
                         s.osuser || '@' || s.machine || '@' || s.process as client,
                         u.blocks * b.value / 1024 / 1024 sort_mb,
                         a.SQL_ID,
                         s.osuser,
                         to_char(s.logon_time, 'mm-dd hh24:mi') as logon_time
        from v$session s, v$sort_usage u, v$sqlarea a, v$parameter b
 where s.saddr = u.session_addr
         and s.sql_address = a.address
         and b.name = 'db_block_size'
         order by sort_mb ;

