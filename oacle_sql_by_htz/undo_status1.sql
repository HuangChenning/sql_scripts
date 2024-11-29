set serverout on size 1000000
set echo off
set verify off
SET PAGES 5000
set linesize 500
col NAME_COL_PLUS_SHOW_PARAM for a20;
col VALUE_COL_PLUS_SHOW_PARAM for a20;
col parameter for a40
col session_value for a20
col instance_value for a20
col description for a60
col "Tablespace Name" for a40
col file_name for a60
col status for a15
col autoextensible for a4 heading 'AUTO'
col bytes for 999999 heading 'SIZE(M)'
col maxbytes for 99999 heading 'MAXSIZE(M)'
col user_bytes for 99999 heading 'USER_SIZE|(M)'
show parameter undo ;
SELECT a.ksppinm AS parameter,
       b.ksppstvl AS session_value,
       c.ksppstvl AS instance_value,
       a.ksppdesc AS description
FROM   x$ksppi a,
       x$ksppcv b,
       x$ksppsv c
WHERE  a.indx = b.indx
AND    a.indx = c.indx
AND    a.ksppinm LIKE '/_%' ESCAPE '/'
AND    a.ksppinm LIKE '%_undo_autotune%'
ORDER BY a.ksppinm
/
select tablespace_name, file_name, status, autoextensible, trunc(bytes/1024/1024) bytes,trunc(user_bytes/1024/1024) user_bytes, trunc(maxbytes/1024/1024) maxbytes
  from dba_data_files
 where tablespace_name in
       (select tablespace_name from dba_tablespaces where contents = 'UNDO')
/
col name for a25
col program for a30
col xacts for 99
col sid for 99999
col serial# for 99999
col sqlid for a18
col status for a15
col sid:serial:ospid for a25
col io for  a30 heading 'LOG_IO:PHY_IO|CR_GET:CR_CHANGE'
select *
  from (select to_char(sysdate, 'hh24:mi:ss') as curtime,
               e.start_time,
               a.name,
               round(f.bytes / 1024 / 1024, 2) as mbytes,
               b.xacts,
               c.sid || ':' || c.serial# || ':' || g.spid "sid:serial:ospid",
               decode(sql_hash_value, 0, prev_hash_value, sql_hash_value) as hash_value,
               DECODE(c.sql_id, '', c.prev_sql_id, c.sql_id) || ':' ||
               sql_child_number AS SQLID,
               decode(instr(C.PROGRAM, '(TNS'),
                      0,
                      c.PROGRAM,
                      substr(c.program, 1, instr(C.PROGRAM, '(TNS') - 1)) PROGRAM,
              e.LOG_IO||':'||e.PHY_IO||':'||e.CR_GET||':'||e.CR_CHANGE io
          from v$rollname    a,
               v$rollstat    b,
               v$session     c,
               v$transaction e,
               dba_segments  f,
               v$process     g
         where a.usn = b.usn
           and b.usn = e.xidusn
           and c.saddr = e.ses_addr
           and g.addr = c.paddr
           and a.name(+) = f.segment_name
         order by mbytes DESC)
 where rownum <= 20;

select to_char(sysdate, 'hh24:mi:ss') as curtime,
       status,
       TRUNC(SUM(BYTES) / 1024 / 1024) "size(M)",
       count(*) total_extent
  from dba_undo_extents
 where tablespace_name =
       (select VALUE from v$parameter where name = 'undo_tablespace')
 group by status;

select tablespace_name,
       trunc(a.Free_Space) "Free_space(M)",
       trunc(b.TOTAL_SPACE) "TOTAL_SPACE(M)",
       trunc((1 - a.Free_Space / b.TOTAL_SPACE) * 100) "USED(%)"
  from (select tablespace_name, sum(bytes / 1024 / 1024) Free_Space
          from dba_free_space
         where tablespace_name =
               (select VALUE from v$parameter where name = 'undo_tablespace')
         group by tablespace_name) a,
       (select sum(bytes / 1024 / 1024) TOTAL_SPACE
          from v$datafile a, v$tablespace b
         where a.ts# = b.ts#
           and b.name =
               (select VALUE from v$parameter where name = 'undo_tablespace')) b;
