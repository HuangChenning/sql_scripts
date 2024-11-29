set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Trace One Session                                           |
PROMPT +------------------------------------------------------------------------+

ACCEPT sid prompt 'Enter Search Sid (i.e. 123) : '
ACCEPT serial prompt 'Enter Search Serail (i.e. 123) : '
ACCEPT level prompt 'Enter Search Level(i.e. 0(off)|1.2.4.8.12) : '

variable sid  number;
variable serial  number;
variable level  number;
begin
  :sid     :=  &sid;
  :serial  :=  &serial;
  :level   :=  &level;
end;
/

exec sys.dbms_system.set_bool_param_in_session(:sid,:serial,'timed_statistics', true);
exec sys.dbms_system.set_int_param_in_session(:sid,:serial,'timed_os_statistics', 0);
exec sys.dbms_system.set_int_param_in_session(:sid,:serial,'max_dump_file_size', 2147483647);
exec sys.dbms_system.set_ev(:sid,:serial,10046,:level, '');


clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

