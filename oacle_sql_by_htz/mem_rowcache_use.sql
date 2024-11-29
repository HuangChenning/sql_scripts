set echo off
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
/* Formatted on 2013/2/27 23:09:52 (QP5 v5.215.12089.38647) */
  SELECT parameter,
         SUM (gets),
         SUM (getmisses),
         ROUND (
            (100 * SUM (getmisses) / DECODE (SUM (gets), 0, 1, SUM (gets))),
            2)
            Getmiss_ratio,
         ROUND (
              100
            * SUM (gets - getmisses)
            / DECODE (SUM (gets), 0, 1, SUM (gets)),
            2)
            Hit_Ratio,
         SUM (modifications) updates
    FROM v$rowcache
GROUP BY parameter
ORDER BY Getmiss_ratio DESC, Hit_Ratio DESC;

clear    breaks  

