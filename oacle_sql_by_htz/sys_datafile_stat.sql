set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000
col name for a50
col phyrds for 99999999999999 heading 'PHYSICAL READS|NUMBER'
col phyblkrd for 9999999999999 heading 'PHYSICAL READ|BLOCK TOTAL'
col readtim for 99999999999 heading 'PHYSICAL READ|TIME '
col singleblkrds for 9999999999 heading 'SINGLE PHYSICAL|READ NUMBER'
col singleblkrdtim for 9999999999 heading 'SINGLE PHYSICAL|READ TIME'
col multiblkrd for 99999999999 heading 'MULTI PHYSICAL|READ BLOCKS'
col multiblkrdtim for 99999999999 heading 'MULTI PHYSICAL|READ TIME'
col singleblk_avgtime for 999999999 heading 'SINGLE PHYSICAL|AVG TIME'
col  multiblk_avgtim for 9999999999 heading 'MULTI PHYSICAL|AVG TIME'
SELECT df.name,
       fl.phyrds,
       fl.phyblkrd,
       fl.readtim,
       fl.singleblkrds,
       fl.singleblkrdtim,
       (fl.phyblkrd - fl.singleblkrds) AS multiblkrd,
       (fl.readtim - fl.singleblkrdtim) AS multiblkrdtim,
       ROUND (
          fl.singleblkrdtim / DECODE (fl.singleblkrds, 0, 1, fl.singleblkrds),
          3)
          AS singleblk_avgtim,
       ROUND (
            (fl.readtim - fl.singleblkrdtim)
          / DECODE ( (fl.phyblkrd - fl.singleblkrds),
                    0, 1,
                    (fl.phyblkrd - fl.singleblkrds)),
          3)
          AS multiblk_avgtim
  FROM v$filestat fl, v$datafile df
 WHERE fl.file# = df.file#
/
clear    breaks  
@sqlplusset

