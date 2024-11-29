set echo off
set lines 200
set heading on
set pages 50
select inst_id, bufsize, rdmemblks, rddiskblks, hitrate, bufinfo
  from x$logbuf_readhist;

