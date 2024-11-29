store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
select d.blk_size, c.child#, p.bp_name, c.gets, c.sleeps
  from x$kcbwds d, v$latch_children c, x$kcbwbpd p
 where d.set_latch = c.addr
   and d.set_id between p.bp_lo_sid and p.bp_hi_sid
 order by c.child#

/
clear    breaks  
@sqlplusset
set echo off