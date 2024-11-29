set lines 200
col tablespace_name for a20
col group# for 999999 
col member for a60

select open_mode,log_mode,force_logging from v$database;
SELECT value FROM NLS_DATABASE_PARAMETERS WHERE parameter='NLS_CHARACTERSET';

select tablespace_name,file_id,bytes/1024/1024 bytes,AUTOEXTENSIBLE,maxbytes/1024/1024 max_size from dba_data_files order by tablespace_name; 
select tablespace_name,file_id,bytes/1024/1024 bytes,AUTOEXTENSIBLE,maxbytes/1024/1024 max_size from dba_temp_files order by tablespace_name;

SELECT
       a.group#,
       b.thread#,
       b.status,
       round(bytes/1024/1024) bytes,
a.member
  FROM v$logfile a, v$log b
 WHERE a.group# = b.group# order by thread#,group#;
 
 col name for a40
 col DISPLAY_VALUE for a40
 col value for a40
  SELECT name, display_value, VALUE
    FROM v$parameter
   WHERE isdefault <> 'TRUE'
ORDER BY name;

col client_name for a40
select client_name,status from dba_autotask_client;


Select extract(day from snap_interval) * 24 * 60 +
       extract(hour from snap_interval) * 60 +
       extract(minute from snap_interval) "Snapshot Interval",
       extract(day from retention) * 24 * 60 +
       extract(hour from retention) * 60 + extract(minute from retention) "Retention Interval(Minutes) ",
       extract(day from retention) "Retention(in Days) ",topnsql
  from dba_hist_wr_control
/

select profile,resource_name,limit from dba_profiles order by profile,resource_name;

select username,account_status,profile from dba_users;
