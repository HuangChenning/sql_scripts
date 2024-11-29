set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Trace all session of amodule                                |
PROMPT +------------------------------------------------------------------------+


ACCEPT service_nmae prompt 'Enter Search Service_name (i.e. orcl9i) : '
ACCEPT module_name prompt 'Enter Search Module Name (i.e. HTZ) : '

dbms_monitor.serv_mod_act_trace_enable( -     
service_name => '&service_name', -     
module_name => '&module_name', -     
action_name => 'DEBIT_ENTRY', -     
waits => true, -     
binds => true, -     
instance_name => null);

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | Stop Trace all session of amodule                                      |
PROMPT |exec dbms_monitor.serv_mod_act_trace_disable( -                         |
PROMPT |service_name => '&service_name', -                                              |
PROMPT |module_name => '&module_name', -                                             |
PROMPT |action_name => 'DEBIT_ENTRY');                                          |
PROMPT +------------------------------------------------------------------------|


clear    breaks
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on
