-- +-----------------------------------------------------------------+
-- | FILE     : sp_last_report.sql                                   |
-- | AUTHOR   : Donald K. Burleson                                   |
-- | DATABASE : Oracle                                               |
-- | CLASS    : Statspack                                            |
-- | PURPOSE  : Simple Statspack alert report.                       |
-- +-----------------------------------------------------------------+

--***********************************************************
--
--  STATSPACK alert report for the DBA
--
--  Created 8/4/2000 by Donald K. Burleson
--  www.dba-oracle.com
--
--  This script is provided free-of-charge by Don Burleson
--  and no portion of this script may be sold to anyone for any reason!
--
--  This script accepts the "number of days back" as an imput parameter
--
--  This script can be scheduled to run daily via cron or OEM
--  and e-mail the results to the on-call DBA
--
--***********************************************************

spool sp_last_rpt.lst

set pages 9999;
set feedback on;
set verify off;

column reads  format 999,999,999
column writes format 999,999,999

select 
   to_char(snap_time,'yyyy-mm-dd HH24') snap_time,
   (newreads.value-oldreads.value) reads,
   (newwrites.value-oldwrites.value) writes
from
   perfstat.stats$sysstat oldreads,
   perfstat.stats$sysstat newreads,
   perfstat.stats$sysstat oldwrites,
   perfstat.stats$sysstat newwrites,
   perfstat.stats$snapshot   sn
where
   newreads.snap_id = (select max(sn.snap_id) from stats$snapshot)
and
   newwrites.snap_id = (select max(sn.snap_id) from stats$snapshot)
and
   oldreads.snap_id = sn.snap_id-1
and
   oldwrites.snap_id = sn.snap_id-1
and
  oldreads.statistic# = 40
and 
  newreads.statistic# = 40
and 
  oldwrites.statistic# = 41
and
  newwrites.statistic# = 41
;


prompt
prompt
prompt ***********************************************************
prompt  This will identify any single file who's read I/O
prompt  is more than 10% of the total read I/O of the database.
prompt
prompt  The "hot" file should be examined, and the hot table/index
prompt  should be identified using STATSPACK.
prompt
prompt  - The busy file should be placed on a disk device with
prompt    "less busy" files to minimize read delay and channel
prompt    contention.
prompt
prompt  - If small file has a hot small table, place the table
prompt    in the KEEP pool
prompt
prompt  - If the file has a large-table full-table scan, place
prompt    the table in the RECYCLE pool and turn on parallel query
prompt    for the table.
prompt ***********************************************************
prompt
prompt

column mydate format a16
column file_name format a40
column reads  format 999,999,999

select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   new.filename                          file_name,
   new.phyrds-old.phyrds                 reads
from
   perfstat.stats$filestatxs old,
   perfstat.stats$filestatxs new,
   perfstat.stats$snapshot   sn
where
   sn.snap_id = (select max(snap_id) from stats$snapshot)
and
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
and
   new.filename = old.filename
--and
--   new.phyrds-old.phyrds > 10000
and
   (new.phyrds-old.phyrds)*10 >
(
select
   (newreads.value-oldreads.value) reads
from
   perfstat.stats$sysstat oldreads,
   perfstat.stats$sysstat newreads,
   perfstat.stats$snapshot   sn1
where
   sn.snap_id = sn1.snap_id
and
   newreads.snap_id = sn.snap_id
and
   oldreads.snap_id = sn.snap_id-1
and
  oldreads.statistic# = 40
and 
  newreads.statistic# = 40
and
  (newreads.value-oldreads.value) > 0
)
;



prompt
prompt
prompt ***********************************************************
prompt  This will identify any single file who's write I/O
prompt  is more than 10% of the total write I/O of the database.
prompt
prompt  The "hot" file should be examined, and the hot table/index
prompt  should be identified using STATSPACK.
prompt
prompt  - The busy file should be placed on a disk device with
prompt    "less busy" files to minimize write delay and channel
prompt    channel contention.
prompt
prompt  - If small file has a hot small table, place the table
prompt    in the KEEP pool
prompt
prompt ***********************************************************
prompt

column mydate format a16
column file_name format a40
column writes  format 999,999,999

select 
   to_char(snap_time,'yyyy-mm-dd HH24')  mydate,
   new.filename                          file_name,
   new.phywrts-old.phywrts               writes
from
   perfstat.stats$filestatxs old,
   perfstat.stats$filestatxs new,
   perfstat.stats$snapshot   sn
where
   sn.snap_id = (select max(snap_id) from stats$snapshot)
and
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
and
   new.filename = old.filename
--and
----   new.phywrts-old.phywrts > 10000
and
   (new.phywrts-old.phywrts)*10 >
(
select
   (newwrites.value-oldwrites.value) writes
from
   perfstat.stats$sysstat oldwrites,
   perfstat.stats$sysstat newwrites,
   perfstat.stats$snapshot   sn1
where
   sn.snap_id = sn1.snap_id
and
   newwrites.snap_id = sn.snap_id
and
   oldwrites.snap_id = sn.snap_id-1
and
  oldwrites.statistic# = 40
and 
  newwrites.statistic# = 40
and
  (newwrites.value-oldwrites.value) > 0
)
;


--***********************************************************
-- Alert when data buffer hit ratio is below threshold
--***********************************************************

prompt
prompt
prompt ***********************************************************
prompt  When the data buffer hit ratio falls below 90%, you
prompt  should consider adding to the db_block_buffer init.ora parameter
prompt
prompt  See p. 171 "High Performance Oracle8 Tuning" by Don Burleson
prompt
prompt ***********************************************************
prompt
prompt

column logical_reads  format 999,999,999
column phys_reads     format 999,999,999
column phys_writes    format 999,999,999
column "BUFFER HIT RATIO" format 999


select
   to_char(snap_time,'dd Mon HH24:mi:ss') mydate,
   d.value            "phys_writes",
   round(100 * (((a.value-e.value)+(b.value-f.value))-(c.value-g.value)) / ((a.value-e.value)+(b.value-f.value)))  
         "BUFFER HIT RATIO"
from 
   perfstat.stats$sysstat a, 
   perfstat.stats$sysstat b, 
   perfstat.stats$sysstat c, 
   perfstat.stats$sysstat d, 
   perfstat.stats$sysstat e,
   perfstat.stats$sysstat f,
   perfstat.stats$sysstat g,
   perfstat.stats$snapshot   sn
where
--   (round(100 * (((a.value-e.value)+(b.value-f.value))-(c.value-g.value)) / ((a.value-e.value)+(b.value-f.value)))  ) < 90
--and
   sn.snap_id = (select max(snap_id) from stats$snapshot)
and
   a.snap_id = sn.snap_id
and
   b.snap_id = sn.snap_id
and
   c.snap_id = sn.snap_id
and
   d.snap_id = sn.snap_id
and
   e.snap_id = sn.snap_id-1
and
   f.snap_id = sn.snap_id-1
and
   g.snap_id = sn.snap_id-1
and
   a.statistic# = 39
and
   e.statistic# = 39
and
   b.statistic# = 38
and
   f.statistic# = 38
and
   c.statistic# = 40
and
   g.statistic# = 40
and
   d.statistic# = 41
;


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


--***********************************************************
-- Alert when total disk sorts are below threshold
--***********************************************************

prompt
prompt
prompt ***********************************************************
prompt  When there are high disk sorts, you should investigate
prompt  increasing sort_area_size, or adding indexes to force index_full scans
prompt
prompt  See p. 167 "High Performance Oracle8 Tuning" by Don Burleson
prompt
prompt ***********************************************************
prompt
prompt


column sorts_memory  format 999,999,999
column sorts_disk    format 999,999,999
column ratio format .9999999999999

select 
   to_char(snap_time,'dd Mon HH24:mi:ss') mydate,
   newmem.value-oldmem.value sorts_memory,
   newdsk.value-olddsk.value sorts_disk,
   (newdsk.value-olddsk.value)/(newmem.value-oldmem.value) ratio
from
   perfstat.stats$sysstat oldmem,
   perfstat.stats$sysstat newmem,
   perfstat.stats$sysstat newdsk,
   perfstat.stats$sysstat olddsk,
   perfstat.stats$snapshot   sn
where
   -- Where there are more than 100 disk sorts per hour
--   newdsk.value-olddsk.value > 100
--and
   sn.snap_id = (select max(snap_id) from stats$snapshot)
and
   newdsk.snap_id = sn.snap_id
and
   olddsk.snap_id = sn.snap_id-1
and
   newmem.snap_id = sn.snap_id
and
   oldmem.snap_id = sn.snap_id-1
and
   oldmem.name = 'sorts (memory)'
and
   newmem.name = 'sorts (memory)'
and
   olddsk.name = 'sorts (disk)'
and
   newdsk.name = 'sorts (disk)'
and
   newmem.value-oldmem.value > 0
;



--***********************************************************
-- Alert when total I/O wait count is above threshold
--***********************************************************

prompt
prompt
prompt ***********************************************************
prompt  When there is high I/O waits, disk bottlenecks may exist
prompt  Run iostats to find the hot disk and shuffle files to
prompt  remove the contention 
prompt
prompt  See p. 191 "High Performance Oracle8 Tuning" by Don Burleson
prompt
prompt ***********************************************************
prompt
prompt

break on snapdate skip 2

column snapdate format a16
column filename format a40

select 
   to_char(snap_time,'dd Mon HH24:mi:ss') mydate,
   old.filename,
   new.wait_count-old.wait_count waits
from
   perfstat.stats$filestatxs old,
   perfstat.stats$filestatxs new,
   perfstat.stats$snapshot   sn
where
   sn.snap_id = (select max(snap_id) from stats$snapshot)
and
   new.wait_count-old.wait_count > 0
and
   new.snap_id = sn.snap_id
and
   old.filename = new.filename
and
   old.snap_id = sn.snap_id-1
;


--***********************************************************
-- Alert when average buffer busy waits exceed threshold
--***********************************************************

prompt
prompt
prompt ***********************************************************
prompt  Buffer Bury Waits may signal a high update table with too
prompt  few freelists.  Find the offending table and add more freelists. 
prompt
prompt  See p. 134 "Oracle SAP Administration" by Don Burleson
prompt
prompt ***********************************************************
prompt
prompt


column buffer_busy_wait format 999,999,999

select 
   to_char(snap_time,'dd Mon HH24:mi:ss') mydate,
   avg(new.buffer_busy_wait-old.buffer_busy_wait) buffer_busy_wait
from
   perfstat.stats$buffer_pool_statistics old,
   perfstat.stats$buffer_pool_statistics new,
   perfstat.stats$snapshot   sn
where
   sn.snap_id = (select max(snap_id) from stats$snapshot)
and
   new.snap_id = sn.snap_id
and
   new.snap_id = sn.snap_id
and
   old.snap_id = sn.snap_id-1
--having
--   avg(new.buffer_busy_wait-old.buffer_busy_wait) > 100
group by
   to_char(snap_time,'dd Mon HH24:mi:ss')
;


--***********************************************************
-- Alert when total redo log space requests exceed threshold
--***********************************************************

prompt
prompt
prompt ***********************************************************
prompt  High redo log space requests indicate a need to increase
prompt  the log_buffer parameter
prompt
prompt
prompt ***********************************************************
prompt
prompt



column redo_log_space_requests  format 999,999,999

select 
   to_char(snap_time,'dd Mon HH24:mi:ss') mydate,
   newmem.value-oldmem.value redo_log_space_requests
from
   perfstat.stats$sysstat oldmem,
   perfstat.stats$sysstat newmem,
   perfstat.stats$snapshot   sn
where
   sn.snap_id = (select max(snap_id) from stats$snapshot)
--and
--   newmem.value-oldmem.value > 30
and
   newmem.snap_id = sn.snap_id
and
   oldmem.snap_id = sn.snap_id-1
and
   oldmem.name = 'redo log space requests'
and
   newmem.name = 'redo log space requests'
and
   newmem.value-oldmem.value > 0
;


--***********************************************************
-- Alert when table_fetch_continued_row exceeds threshold
--***********************************************************

prompt
prompt
prompt ***********************************************************
prompt  Table fetch continued row indicates chained rows, or fetches of
prompt  long datatypes (long raw, blob)
prompt 
prompt  Investigate increasing db_block_size or reorganizing tables
prompt  with chained rows.
prompt
prompt  See p. 381 "High Performance Oracle8 Tuning" by Don Burleson
prompt  See p. 102 "Oracle SAP Administration" by Don Burleson
prompt
prompt ***********************************************************
prompt
prompt




column table_fetch_continued_row  format 999,999,999

select 
   to_char(snap_time,'dd Mon HH24:mi:ss') mydate,
   avg(newmem.value-oldmem.value) table_fetch_continued_row
from
   perfstat.stats$sysstat oldmem,
   perfstat.stats$sysstat newmem,
   perfstat.stats$snapshot   sn
where
   sn.snap_id = (select max(snap_id) from stats$snapshot)
and
   newmem.snap_id = sn.snap_id
and
   oldmem.snap_id = sn.snap_id-1
and
   oldmem.name = 'table fetch continued row'
and
   newmem.name = 'table fetch continued row'
--and
--   newmem.value-oldmem.value > 0
--having 
--   avg(newmem.value-oldmem.value) > 10000
group by
   to_char(snap_time,'dd Mon HH24:mi:ss')
;


prompt
prompt
prompt ***********************************************************
prompt  Enqueue Deadlocks indicate contention within the Oracle
prompt  shared pool.
prompt 
prompt  Investigate increasing shared_pool_size 
prompt
prompt  See p. xxx "High Performance Oracle8 Tuning" by Don Burleson
prompt
prompt ***********************************************************
prompt

column enqueue_deadlocks     format 999,999,999

select
   to_char(snap_time,'dd Mon HH24:mi:ss') mydate,
   a.value enqueue_deadlocks
from 
   perfstat.stats$sysstat     a, 
   perfstat.stats$snapshot   sn
where
   sn.snap_id = (select max(snap_id) from stats$snapshot)
and
   a.snap_id = sn.snap_id
and
   a.statistic# = 24
--and
--   a.value > 10
;



prompt
prompt
prompt ***********************************************************
prompt  Long-table full table scans can indicate a need to:
prompt
prompt        - Make the offending tables parallel query
prompt          (alter table xxx parallel degree yyy;)
prompt        - Place the table in the RECYCLE pool
prompt        - Build an index on the table to remove the FTS
prompt
prompt To locate the table, run access.sql
prompt 
prompt  See Oracle Magazine September 200 issue for details
prompt
prompt ***********************************************************
prompt


column fts  format 999,999,999

select 
   to_char(snap_time,'dd Mon HH24:mi:ss') mydate,
   newmem.value-oldmem.value fts
from
   perfstat.stats$sysstat oldmem,
   perfstat.stats$sysstat newmem,
   perfstat.stats$snapshot   sn
where
  sn.snap_id = (select max(snap_id) from stats$snapshot)
--and
--   newmem.value-oldmem.value > 1000
and
   newmem.snap_id = sn.snap_id
and
   oldmem.snap_id = sn.snap_id-1
and
   oldmem.statistic# = 140
and
   newmem.statistic# = 140
--and
--   newmem.value-oldmem.value > 0
;


spool off;

