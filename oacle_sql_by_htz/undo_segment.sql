set echo off
set lines 300
set pages 40
set heading on
set verify off
col tablespace for a20
col segment_name for a30
col segment_header for a14 heading 'SEGMENT_HEADER|FILE#.BLOCK'
col status for a10
col scnbas for 9999999999
col scnwrp for 999999
col xactsqn for 9999999999
col undosqn for 9999999999
col segment_size for 999999 heading 'SEGMENT_SIZE(M)'
select decode(B.NAME,'','SYSTEM',b.name) || '.' || decode(c.value, '', 'OLD', 'CURRENT') tablespace,
       decode(user#, 0, 'PRI', 1, 'PUB') || '.' || a.name segment_name,
       file# || '.' || block# segment_header,
       decode(a.status$,
              2,
              'OFFLINE',
              3,
              'ONLINE',
              4,
              'UNDEFINED',
              5,
              'NEEDS RECOVERY',
              6,
              'PARTLY AVAILABLE',
              'UNDEFINED') status,
       round(d.bytes / 1024 / 1024) segment_size,
       scnbas,
       scnwrp,
       xactsqn,
       undosqn
  from undo$ a,
       (select ts#, name
          from ts$ ts
         where ts.contents$ = 0
           and bitand(ts.flags, 16) = 16) b,
       (select value from v$parameter where name = 'undo_tablespace') c,
       dba_segments d
 where a.ts# = b.ts#(+)
   and b.name = c.value(+)
   and a.name = d.segment_name(+)
 order by 1;
