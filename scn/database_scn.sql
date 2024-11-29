set lines 150
set echo off
col name for a50
set pages 200
prompt  current_scn 
select current_scn scn,a.checkpoint_change# dbcheckpoint,b.file#,b.checkpoint_change# filecheckpoing,to_char(checkpoint_time,'yyyy-mm-dd hh24:mi:ss') time,b.name from v$database a,v$datafile b;
prompt dbms_flashback
select dbms_flashback.get_system_change_number scn from dual; 
prompt before 9i
select max(ktuxescnw*power(2,32)+ktuxescnb) scn from x$ktuxe;
