--**************************************************************
--   rpt_lib.sql
--
--   ¨ 2001 by Donald K. Burleson
--
--   No part of this SQL script may be copied. Sold or distributed
--   without the express consent of Donald K. Burleson
--**************************************************************
set lines 80;
set pages 999;

column mydate heading 'Yr.  Mo Dy  Hr.' format a16
column reloads       format 999,999,999
column hit_ratio     format 999.99
column pin_hit_ratio format 999.99

break on mydate skip 2;

select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   new.namespace, 
   (new.gethits-old.gethits)/(new.gets-old.gets) hit_ratio,
   (new.pinhits-old.pinhits)/(new.pins-old.pins) pin_hit_ratio,
   new.reloads
from 
   stats$librarycache old,
   stats$librarycache new,
   stats$snapshot     sn
where
   new.snap_id = sn.snap_id
and
   old.snap_id = new.snap_id-1
and
   old.namespace = new.namespace
and
   new.gets-old.gets > 0
and
   new.pins-old.pins > 0
;

