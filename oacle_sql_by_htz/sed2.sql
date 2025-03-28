set echo off
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000
prompt Show wait event descriptions matching &1...

col sed_name            head EVENT_NAME for a45
col sed_p1              head PARAMETER1 for a15
col sed_p2              head PARAMETER2 for a15
col sed_p3              head PARAMETER3 for a15
col sed_event#          head EVENT# for 99999
col sed_req_description HEAD REQ_DESCRIPTION for a20 WORD_WRAP
col sed_req_reason      HEAD REQ_REASON for a20 WRAP
col sed_wait_class      HEAD WAIT_CLASS for a15
col sed_eq_name         HEAD ENQUEUE_NAME for a10

SELECT 
    e.event# sed_event#
  , e.name sed_name 
  , e.wait_class sed_wait_class
  , e.parameter1 sed_p1 
  , e.parameter2 sed_p2 
  , e.parameter3 sed_p3
  , s.eq_name         sed_eq_name
  , s.req_reason      sed_req_reason
  , s.req_description sed_req_description
FROM 
    v$event_name e
  , v$enqueue_statistics s
WHERE 
    e.event# = s.event# (+)
AND lower(e.name) like lower('&1') 
ORDER BY 
    sed_name
/
clear    breaks  
