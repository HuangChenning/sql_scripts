set echo off;
set lines 200 pages 4000 verify off heading on
undefine owner;
undefine tablename;
col object_name for a30 heading 'TABLE NAME'
col savetime for a24 heading 'SAVE TIME|SNALYZE'
col rowcnt for 9999999999999
col blkcnt for 999999999999
col avgrln for 999999999
col samplesize for 999999999
select b.object_name,
       to_char(savtime, 'mm-dd hh24') || '  ' ||
       to_char(a.analyzetime, 'mm-dd hh24') savetime,
       a.rowcnt,
       a.blkcnt,
       a.avgrln,
       a.samplesize
  from wri$_optstat_tab_history a, dba_objects b
 where a.obj# = b.object_id
   and b.owner = nvl(upper('&owner'), b.owner)
   and b.object_name = nvl(upper('&tablename'), b.object_name)
 order by object_name, savetime;
undefine owner;
undefine tablename;
