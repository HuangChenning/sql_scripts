set echo off
-- File Name : dump_redo_convert_time_to_redotime.sql
-- Purpose : 转换年月日到REDO中存放的时间数字
-- Version : 1.0
-- Date : 2015/09/05
-- Modify Date : 2015/09/05
-- 认真就输、QQ:7343696
-- http://www.htz.pw
--        ALTER SYSTEM DUMP LOGFILE 'u01/oracle/V7323/dbs/arch1_76.dbf' 
--        TIME MIN 299425687 
--        TIME MAX 299458800; 
undefine redo_day 
undefine redo_hhmiss 
 
accept redo_day prompt "Enter day (DD/MM/YYYY) ? " 
accept redo_hhmiss prompt "Enter time (HH24:MI:SS) ? " 
 
column redo_year  new_value redo_year format 9999 
column redo_month new_value redo_month format 9999 
column redo_day   new_value redo_day format 9999 
column redo_hour  new_value redo_hour format 9999 
column redo_min   new_value redo_min format 9999 
column redo_sec   new_value redo_sec format 9999 
column redo_time  new_value redo_time  
 
set verify off 
 
select to_number(to_char(to_date('&redo_day &redo_hhmiss',
                                 'DD/MM/YYYY HH24:MI:SS'),
                         'YYYY')) redo_year,
       to_number(to_char(to_date('&redo_day &redo_hhmiss',
                                 'DD/MM/YYYY HH24:MI:SS'),
                         'MM')) redo_month,
       to_number(to_char(to_date('&redo_day &redo_hhmiss',
                                 'DD/MM/YYYY HH24:MI:SS'),
                         'DD')) redo_day,
       to_number(to_char(to_date('&redo_day &redo_hhmiss',
                                 'DD/MM/YYYY HH24:MI:SS'),
                         'HH24')) redo_hour,
       to_number(to_char(to_date('&redo_day &redo_hhmiss',
                                 'DD/MM/YYYY HH24:MI:SS'),
                         'MI')) redo_min,
       to_number(to_char(to_date('&redo_day &redo_hhmiss',
                                 'DD/MM/YYYY HH24:MI:SS'),
                         'SS')) redo_sec
  from dual;

select ((((((&redo_year - 1988)) * 12 + (&redo_month - 1)) * 31 +
       (&redo_day - 1)) * 24 + (&redo_hour)) * 60 + (&redo_min)) * 60 +
       (&redo_sec) redo_time
  from dual;
undefine redo_day 
undefine redo_hhmiss