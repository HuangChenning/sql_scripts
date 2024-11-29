variable jobid varchar2(32);
exec select job_name into :jobid from dba_scheduler_jobs where program_name='GATHER_STATS_PROG';
print :jobid;
exec dbms_scheduler.stop_job(:jobid,false);