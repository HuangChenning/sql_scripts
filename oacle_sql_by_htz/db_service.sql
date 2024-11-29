set echo off
set lines 200
col name for a20;
col failover_method for a15 heading 'FAILOVER|METHOD';
col failover_retries for 99999 heading 'FAILOVER|RETRIES';

select name, failover_method, failover_type, failover_retries,goal, clb_goal,aq_ha_notifications  from dba_services;
/
clear    breaks
