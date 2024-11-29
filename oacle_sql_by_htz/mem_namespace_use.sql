set echo off
set verify off
set serveroutput on
set feedback off
set lines 2000
set pages 1000
SELECT namespace,
       gets,
       gethits,
       ROUND(GETHITRATIO * 100, 2) gethit_ratio,
       pins,
       pinhits,
       ROUND(PINHITRATIO * 100, 2) pinhit_ratio,
       reloads,
       invalidations
  FROM v$librarycache

/
clear    breaks  
