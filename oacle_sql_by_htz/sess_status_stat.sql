set echo off
set lines 300 pages 100 verify off heading on

/* Formatted on 2014/3/28 11:47:46 (QP5 v5.240.12305.39446) */
  SELECT inst_id, status, COUNT (*) total
    FROM gv$session
GROUP BY inst_id, status
ORDER BY inst_id, status;