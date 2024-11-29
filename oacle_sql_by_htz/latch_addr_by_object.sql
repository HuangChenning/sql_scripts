set echo off
set lines 300
set pages 10000
set verify off
set heading on
col o_o				for a40 heading 'OWNER|OBJECT_NAME'
col addr                        for 9999999999999999999 heading 'LATCH_ADDR'
col obj                         for 999999999 heading 'OBJECT_ID'
col dbarfil                     for 999999999 heading 'DBARFILE'
col dbablk                      for 999999999 heading 'DBABLOCK'
select do.owner || '.' || do.object_name o_o,
       lc.addr,
       bh.obj,
       bh.DBARFIL,
       bh.dbablk
  from v$latch_children lc, x$bh bh, dba_objects do
 where lc.addr = bh.hladdr
   and bh.obj = do.object_id
   and lc.name = 'cache buffers chains'
   and do.owner = nvl(upper('&owner'), do.owner)
   and do.object_name = nvl(upper('&objectname'), do.object_name)
   order by addr;

