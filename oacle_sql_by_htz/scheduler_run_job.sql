ACCEPT job_name prompt 'Enter Search Job Name (i.e. CONTROL) : '
ACCEPT now prompt 'Is It run  in foreground (i.e. TRUE|FALSE) : ' default 'FALSE'

begin 
dbms_scheduler.run_job(job_name=>upper('&job_name'),use_current_session=>&now); 
end;
/
