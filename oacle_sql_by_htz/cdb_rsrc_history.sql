set echo off
set lines 300 pages 10000 heading on verify off
col pdb_name for a20
col btime                for        a7
col INTSIZE_CSEC         for        99999        heading 'CSEC'
col num_cpus             for        999          heading 'NUM|CPU'
col iops                 for        99999        heading 'IOPS'
col iombps               for        99999        heading 'IOMB'
col mem_g                for        a15          heading 'SGA.BUF.SHAR.PGA'
col plan_name            for        a20
col ses                  for        a20          heading 'SESS|LIMIT|AVG_RUNNING|AVG_WAITING'
col cpus                 for        a20          heading 'CPU|LIMIT|AVG_CPU'
undefine  pdb_name;
SELECT p.PDB_NAME,
       to_char(r.BEGIN_TIME, 'hh24:mi') btime,
       r.INTSIZE_CSEC,
       r.NUM_CPUS,
       r.RUNNING_SESSIONS_LIMIT || '.' || trunc(r.AVG_RUNNING_SESSIONS) || '.' ||
       trunc(r.AVG_WAITING_SESSIONS) ses,
       trunc(r.CPU_UTILIZATION_LIMIT) || '.' ||
       trunc(r.AVG_CPU_UTILIZATION) cpus,
       trunc(r.IOPS) iops,
       trunc(r.IOMBPS) iombps,
       AVG_IO_THROTTLE,
       trunc(r.SGA_BYTES / 1024 / 1024 / 1024) || '.' ||
       trunc(r.BUFFER_CACHE_BYTES / 1024 / 1024 / 1024) || '.' ||
       trunc(r.SHARED_POOL_BYTES / 1024 / 1024 / 1024) || '.' ||
       trunc(r.PGA_BYTES / 1024 / 1024 / 1024) mem_g,
       PLAN_NAME
  FROM V$RSRCPDBMETRIC_HISTORY r, CDB_PDBS p
 WHERE r.CON_ID = p.CON_ID and p.pdb_name=nvl(upper('&pdb_name'),pdb_name)
 order by pdb_name, btime
/
undefine pdb_name;