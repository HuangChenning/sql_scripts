exec dbms_scheduler.disable('ORACLE_OCM.MGMT_CONFIG_JOB');
exec dbms_scheduler.disable('ORACLE_OCM.MGMT_STATS_CONFIG_JOB');

BEGIN
DBMS_AUTO_TASK_ADMIN.DISABLE(
client_name => 'auto space advisor',
operation => NULL,
window_name => NULL);
END;
/
BEGIN
DBMS_AUTO_TASK_ADMIN.DISABLE(
client_name => 'sql tuning advisor',
operation => NULL,
window_name => NULL);
END;
/

EXECUTE DBMS_SCHEDULER.SET_ATTRIBUTE('SATURDAY_WINDOW','repeat_interval','freq=daily;byday=SAT;byhour=22;byminute=0; bysecond=0');
EXECUTE DBMS_SCHEDULER.SET_ATTRIBUTE('SATURDAY_WINDOW','duration','+000 04:00:00');
EXECUTE DBMS_SCHEDULER.SET_ATTRIBUTE('SUNDAY_WINDOW','repeat_interval','freq=daily;byday=SUN;byhour=22;byminute=0; bysecond=0');
EXECUTE DBMS_SCHEDULER.SET_ATTRIBUTE('SUNDAY_WINDOW','duration','+000 04:00:00');



EXEC DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS(RETENTION=>64800,INTERVAL=>30);
EXEC DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS(topnsql => 30);