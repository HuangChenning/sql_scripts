set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000


PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | how the cache hit percentage and over allocation count statistics displayed |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
select PGA_TARGET_FOR_ESTIMATE / 1024 / 1024 PGA_EST_MB,
       PGA_TARGET_FACTOR,
       ESTD_PGA_CACHE_HIT_PERCENTAGE,
       ESTD_OVERALLOC_COUNT
  from v$pga_target_advice;
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

