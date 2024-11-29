begin 
dbms_monitor.serv_mod_act_trace_enable(service_name=>'SYS$BACKGROUND', 
module_name=>'MMON_SLAVE', 
action_name=>'Auto-Flush Slave Action'); 

dbms_monitor.serv_mod_act_trace_enable(service_name=>'SYS$BACKGROUND', 
module_name=>'MMON_SLAVE', 
action_name=>'Remote-Flush Slave Action'); 
end; 
/
