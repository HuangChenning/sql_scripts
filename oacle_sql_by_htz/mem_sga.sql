set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000


PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display total memory used                              |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
/* Formatted on 2012-11-15 10:15:13 (QP5 v5.185.11230.41888) */
SELECT round(a.SGA_MEM + b.PGA_MEM,2)||'M' "TOTAL_MEMORY"
  FROM (SELECT SUM (current_size) / 1024 / 1024 "SGA_MEM"
          FROM v$sga_dynamic_components,
               (SELECT SUM (pga_alloc_mem) / 1024 / 1024 "PGA_MEM"
                  FROM v$process) a
         WHERE component IN
                  ('shared pool',
                   'large pool',
                   'java pool',
                   'streams pool',
                   'DEFAULT buffer cache')) a,
       (SELECT SUM (pga_alloc_mem) / 1024 / 1024 "PGA_MEM" FROM v$process) b
/

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT |displays information about the last 800 completed SGA resize operations |
PROMPT +------------------------------------------------------------------------+
PROMPT

col component for a30
col oper_type for a15 heading 'Operation|Type'
col oper_mode for a15 heading 'Operation|Mode'
col parameter for a20
col initial_size for a10 heading 'Initial|Size'
col target_size for a10 heading 'Target|Size'
col final_size for a10 heading 'Final|Size'
col status for a10
col start_time for a19
/* Formatted on 2012-11-15 10:51:54 (QP5 v5.185.11230.41888) */
  SELECT component,
         oper_type,
         oper_mode,
         parameter,
         ROUND (initial_size / 1024 / 1024, 2) || 'M' initial_size,
         ROUND (target_size / 1024 / 1024, 2) || 'M' target_size,
         ROUND (final_size / 1024 / 1024, 2) || 'M' final_size,
         status,
         to_char(start_time,'YYYY-MM-DD HH24:MI:SS') start_time
    FROM sys.V$SGA_RESIZE_OPS
   WHERE initial_size > 0 AND target_size > 0 AND final_size > 0
ORDER BY start_time
/

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT |displays sizes of different SGA components,the granule size, free memory|
PROMPT +------------------------------------------------------------------------+
PROMPT

col name for a40
col t_size for a20 heading 'Bytes'
select name,round((bytes/1024/1024),2)||'M' t_size,resizeable from sys.v$sgainfo  order by t_size
/
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT |displays info all completed SGA resize operations since instance startup|
PROMPT +------------------------------------------------------------------------+
PROMPT

col component for a30
col c_size for a10 heading 'Current|Size'
col m_size for a10 heading 'Min|Size'
col mm_size for a10 heading 'Max|Size'
col s_size for a10 heading 'User|Specified|Size'
col t_date for a19 heading 'Last Time|Operation'
col open_count for 9999 heading 'Open|Count'
col last_oper_type for a15 heading 'Last_Type|Operation'
col last_oper_mode for a15 heading 'Last_Mode|Operation'
col granule_size for a10
SELECT component,
       ROUND ( (current_size / 1024 / 1024), 2) || 'M' c_size,
       ROUND ( (min_size / 1024 / 1024), 2) || 'M' m_size,
       ROUND ( (max_size / 1024 / 1024), 2) || 'M' mm_size,
       ROUND ( (user_specified_size / 1024 / 1024), 2) || 'M' s_size,
       oper_count,
       last_oper_type,
       last_oper_mode,
       to_char(last_oper_time,'YYYY-MM-DD HH24:MI:SS') t_date,
       ROUND ( (granule_size / 1024 / 1024), 2) || 'M' granule_size
  FROM V$SGA_DYNAMIC_COMPONENTS
/

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT |displays size information about the SGA, including the sizes of different|
PROMPT | SGA components, the granule size, and free memory.                      |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
col RESIZEABLE for a10 heading 'RESIZEABLE'

select * from v$sgainfo
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on
