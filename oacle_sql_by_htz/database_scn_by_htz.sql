--1,创建表
--drop table system.scn_htz_rate;
--create table system.scn_htz_rate(start_time date,inst_id number,value number,current_scn number);
--2，自动作业插入数据，每10分钟插入一次
--VARIABLE jobno NUMBER
--
--BEGIN
--   DBMS_JOB.SUBMIT (
--      :jobno,
--      'insert into system.scn_htz_rate select sysdate,inst_id,value,DBMS_FLASHBACK.get_system_change_number from  gv$sysstat where name=''calls to kcmgas'' and inst_id=(select instance_number from v$instance);',
--      SYSDATE,
--      'SYSDATE + 10/1440');
--   COMMIT;
--END;
--/
--
--PRINT jobno


set echo off
set lines 2000 pages 2000 num 20 
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
select start_time,
       inst_id,
       trunc((value - lag_value) /
             ((start_time - lag_start_time) * 3600 * 24),
             2) kcmgas_rate,
       trunc((current_scn - lag_current_scn) /
             ((start_time - lag_start_time) * 3600 * 24),
             2) scn_rate,
       trunc(((value - lag_value) / (current_scn - lag_current_scn)) * 100,
             2) as "KCMGAS_REATE%",
       trunc(((((((TO_NUMBER(TO_CHAR(start_time, 'YYYY')) - 1988) * 12 * 31 * 24 * 60 * 60) +
             ((TO_NUMBER(TO_CHAR(start_time, 'MM')) - 1) * 31 * 24 * 60 * 60) +
             (((TO_NUMBER(TO_CHAR(start_time, 'DD')) - 1)) * 24 * 60 * 60) +
             (TO_NUMBER(TO_CHAR(start_time, 'HH24')) * 60 * 60) +
             (TO_NUMBER(TO_CHAR(start_time, 'MI')) * 60) +
             (TO_NUMBER(TO_CHAR(start_time, 'SS')))) * (16 * 1024)) -
             current_scn) / (16 * 1024 * 60 * 60))) indicator_hours
  from (select start_time,
               lag(start_time) over(partition by inst_id order by start_time) lag_start_time,
               inst_id,
               value,
               lag(value) over(partition by inst_id order by start_time) lag_value,
               current_scn,
               lag(current_scn) over(partition by inst_id order by start_time) lag_current_scn
          from scott.scn_htz_rate)
 where lag_start_time is not null
   and lag_value is not null
 order by start_time;