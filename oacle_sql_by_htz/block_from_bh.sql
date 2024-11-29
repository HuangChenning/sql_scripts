set echo off
set lines 200
set pages 40
set verify off
set heading on
col DIRTY      for a6
col TEMP       for a6
col PING       for a6
col STALE      for a6
col DIRECT     for a6
col inst_id for 99 heading 'ID'
col file# for 9999 heading 'FILE#'
col dbablk for 9999999999 heading 'BLOCK'
col status for a10 heading 'STATUS'
undefine owner;
undefine table_name;
select bh.inst_id,
       bh.addr,
       file#,
       dbablk,
       obj,     
       decode(state,
              0,
              'free',
              1,
              'xcur',
              2,
              'scur',
              3,
              'cr',
              4,
              'read',
              5,
              'mrec',
              6,
              'irec',
              7,
              'write',
              8,
              'pi',
              9,
              'memory',
              10,
              'mwrite',
              11,
              'donated') status,
       name,
       decode(bitand(flag, 1), 0, 'N', 'Y') DIRTY,
       decode(bitand(flag, 16), 0, 'N', 'Y') TEMP,
       decode(bitand(flag, 1536), 0, 'N', 'Y') PING,
       decode(bitand(flag, 16384), 0, 'N', 'Y') STALE,
       decode(bitand(flag, 65536), 0, 'N', 'Y') DIRECT
  from x$bh bh, x$le le
 where bh.le_addr = le.le_addr(+)
   and obj in (select data_object_id
                 from dba_objects
                where owner = nvl(upper('&owner'), owner)
                  and object_name = nvl(upper('&table_name'), object_name)
                  and object_type = 'TABLE')
/
undefine owner;
undefine table_name;