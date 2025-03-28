REM srdc_impdp_performance.sql - Gather Information for IMPDP Performance Issues
define SRDCNAME='IMPDP_PERFORMANCE'
SET MARKUP HTML ON PREFORMAT ON
set TERMOUT off FEEDBACK off verify off TRIMSPOOL on HEADING off
set lines 132 pages 10000
COLUMN SRDCSPOOLNAME NOPRINT NEW_VALUE SRDCSPOOLNAME
select 'SRDC_'||upper('&&SRDCNAME')||'_'||upper(instance_name)||'_'||to_char(sysdate,'YYYYMMDD_HH24MISS') SRDCSPOOLNAME from v$instance;
set TERMOUT on MARKUP html preformat on 
REM
spool &&SRDCSPOOLNAME..htm
select '+----------------------------------------------------+' from dual
union all
select '| Diagnostic-Name: '||'&&SRDCNAME' from dual
union all
select '| Timestamp:       '||to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS TZH:TZM') from dual
union all
select '| Machine:         '||host_name from v$instance
union all
select '| Version:         '||version from v$instance
union all
select '| DBName:          '||name from v$database
union all
select '| Instance:        '||instance_name from v$instance
union all
select '+----------------------------------------------------+' from dual
/

set HEADING on MARKUP html preformat off
REM === -- end of standard header -- ===

set concat "#"
SET PAGESIZE 9999
SET LINESIZE 256
SET TRIMOUT ON
SET TRIMSPOOL ON
Column sid format 99999 heading "SESS|ID"
Column serial# format 9999999 heading "SESS|SER|#"
Column session_id format 99999 heading "SESS|ID"
Column session_serial# format 9999999 heading "SESS|SER|#"
Column event format a40
Column total_waits format 9,999,999,999 heading "TOTAL|TIME|WAITED|MICRO"
Column pga_used_mem format 9,999,999,999 
Column pga_alloc_mem format 9,999,999,999
Column status heading 'Status' format a20
Column timeout heading 'Timeout' format 999999
Column error_number heading 'Error Number' format 999999
Column error_msg heading 'Message' format a44 
Column sql_text heading 'Current SQL statement' format a44 
Column Number_of_objects format 99999999
Column object_type format a35
ALTER SESSION SET nls_date_format='DD-MON-YYYY HH24:MI:SS';

SET MARKUP HTML ON PREFORMAT ON

--====================Retrieve sid, serial# information for the active DataPump process(es)===========================
SET HEADING OFF
SELECT '=================================================================================================================================' FROM dual
UNION ALL
SELECT 'Determine sid, serial# details for the active DataPump process(es):' FROM dual
UNION ALL
SELECT '=================================================================================================================================' FROM dual;
SET HEADING ON
set feedback on
col program for a42
col username for a10
col spid for a7
select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') "DATE", s.program, s.sid,  
       s.status, s.username, d.job_name, p.spid, s.serial#, p.pid  
from   v$session s, v$process p, dba_datapump_sessions d 
where  p.addr=s.paddr and s.saddr=d.saddr and
      (UPPER (s.program) LIKE '%DM0%' or UPPER (s.program) LIKE '%DW0%');  
set feedback off

--====================Retrieve sid, serial#, PGA details for the active DataPump process(es)===========================
SET HEADING OFF
SELECT '=================================================================================================================================' FROM dual
UNION ALL
SELECT 'Determine PGA details for the active DataPump process(es):' FROM dual
UNION ALL
SELECT '=================================================================================================================================' FROM dual;
SET HEADING ON
set feedback on
SELECT sid, s.serial#, p.PGA_USED_MEM,p.PGA_ALLOC_MEM
FROM   v$process p, v$session s
WHERE  p.addr = s.paddr and
       (UPPER (s.program) LIKE '%DM0%' or UPPER (s.program) LIKE '%DW0%');
set feedback off


--====================Retrive all wait events and time in wait for the running DataPump process(es)====================
SET HEADING OFF
SELECT '=================================================================================================================================' FROM dual
UNION ALL
SELECT 'All wait events and time in wait for the active DataPump process(es):' FROM dual
UNION ALL
SELECT '=================================================================================================================================' FROM dual;
SET HEADING ON
select session_id, session_serial#, Event, sum(time_waited) total_waits
from   v$active_session_history
where  sample_time > sysdate - 1 and 
       (UPPER (program) LIKE '%DM0%' or UPPER (program) LIKE '%DW0%') and 
       session_id in (select sid from v$session where UPPER (program) LIKE '%DM0%' or UPPER (program) LIKE '%DW0%') and 
       session_state = 'WAITING' And time_waited > 0
group  by session_id, session_serial#, Event
order  by session_id, session_serial#, total_waits desc;

--====================DataPump progress - retrieve current sql id and statement====================
SET HEADING OFF
SELECT '=================================================================================================================================' FROM dual
UNION ALL
SELECT 'DataPump progress - retrieve current SQL id and statement:' FROM dual
UNION ALL
SELECT '=================================================================================================================================' FROM dual;
SET HEADING ON
select sysdate, a.sid, a.sql_id, a.event, b.sql_text
from   v$session a, v$sql b
where  a.sql_id=b.sql_id and 
       (UPPER (a.program) LIKE '%DM0%' or UPPER (a.program) LIKE '%DW0%')
order  by a.sid desc;

SET HEADING OFF MARKUP HTML OFF
SET SERVEROUTPUT ON FORMAT WRAP

declare
  v_ksppinm varchar2(30); 
  CURSOR c_fix IS select v.KSPPSTVL value FROM x$ksppi n, x$ksppsv v WHERE n.indx = v.indx and n.ksppinm = v_ksppinm;
  CURSOR c_count is select count(*) from DBA_OPTSTAT_OPERATIONS where operation in ('gather_dictionary_stats','gather_fixed_objects_stats');
  CURSOR c_stats is select operation, START_TIME, END_TIME from DBA_OPTSTAT_OPERATIONS  
         where operation in ('gather_dictionary_stats','gather_fixed_objects_stats') order by 2 desc;
  v_long_op_flag number := 0 ;                        
  v_target varchar2(100); 
  v_sid number;
  v_totalwork number;    
  v_opname varchar2(200);
  v_sofar number;                        
  v_time_remain number;  
  stmt varchar2(2000);
  v_fix c_fix%ROWTYPE;
  v_count number;

begin
  stmt:='select count(*) from v$session_longops where sid in (select sid from v$session where UPPER (program) LIKE '||
        '''%DM0%'''||' or UPPER (program) LIKE '||'''%DW0%'')'||' and totalwork <> sofar';
  DBMS_OUTPUT.PUT_LINE ('<pre>');
  dbms_output.put_line ('=================================================================================================================================');
  dbms_output.put_line ('Check v$session_longops - DataPump pending work');
  dbms_output.put_line ('=================================================================================================================================');
  execute immediate stmt into v_long_op_flag;
  if (v_long_op_flag > 0) then      
    dbms_output.put_line ('The number of long running DataPump processes is:   '|| v_long_op_flag);
    dbms_output.put_line (chr (10));                        
    for longop in (select sid,target,opname, sum(totalwork) totwork, sum(sofar) sofar, sum(totalwork-sofar) blk_remain, Round(sum(time_remaining/60),2) time_remain                        
                   from v$session_longops where sid in (select sid from v$session where UPPER (program) LIKE '%DM0%' or UPPER (program) LIKE '%DW0%') and 
                   opname NOT LIKE '%aggregate%' and totalwork <> sofar group by sid,target,opname) loop
      dbms_output.put_line (Rpad ('DataPump SID', 40, ' ')||chr (9)||':'||chr (9)||longop.sid); 
      dbms_output.put_line (Rpad ('Object being read', 40, ' ')||chr (9)||':'||chr (9)||longop.target);      
      dbms_output.put_line (Rpad ('Operation being executed', 40, ' ')||chr (9)||':'||chr (9)||longop.opname); 
      dbms_output.put_line (Rpad ('Total blocks to be read', 40, ' ')||chr (9)||':'||chr (9)||longop.totwork);                        
      dbms_output.put_line (Rpad ('Total blocks already read', 40, ' ')||chr (9)||':'||chr (9)||longop.sofar);                        
      dbms_output.put_line (Rpad ('Remaining blocks to be read', 40, ' ')||chr (9)||':'||chr (9)||longop.blk_remain);                        
      dbms_output.put_line (Rpad ('Estimated time remaining for the process', 40, ' ')||chr (9)||':'||chr (9)||longop.time_remain|| ' Minutes'); 
      dbms_output.put_line (chr (10));
    end Loop;
  else
    DBMS_OUTPUT.PUT_LINE ('No DataPump session is found in v$session_longops');
    dbms_output.put_line (chr (10)); 
  end If;

  DBMS_OUTPUT.PUT_LINE ('=================================Have Dictionary and Fixed Objects statistics been gathered?===================================='); 
    open c_count;
    fetch c_count into v_count;
    if v_count>0 then
      BEGIN
        DBMS_OUTPUT.PUT_LINE (rpad ('OPERATION', 30)||' '||rpad ('START_TIME', 32)||'   '||rpad ('END_TIME', 32));
        DBMS_OUTPUT.PUT_LINE (rpad ('--------------------------', 30)||' '||rpad ('-----------------------------', 32)||'   '||rpad ('-----------------------------', 32));
        FOR v_stats IN c_stats LOOP 
          DBMS_OUTPUT.PUT_LINE (rpad (v_stats.operation, 30)||' '||rpad (v_stats.start_time, 32)||'   '||rpad (v_stats.end_time, 32)); 
        END LOOP;
      end;   
    else
      DBMS_OUTPUT.PUT_LINE ('Dictionary and fixed objects statistics have not been gathered for this database.'); 
      dbms_output.put_line (chr (10));
    END IF; 
    dbms_output.put_line ('=================================================================================================================================');
    dbms_output.put_line (chr (10));
  
  for i in 1..6 loop
    if i = 1 then
      v_ksppinm := 'fixed_date';
    elsif i = 2 then
      v_ksppinm := 'aq_tm_processes';
    elsif i = 3 then
      v_ksppinm := 'compatible';
    elsif i = 4 then
      v_ksppinm := 'optimizer_features_enable';
    elsif i = 5 then
      v_ksppinm := 'optimizer_index_caching';
    elsif i = 6 then
      v_ksppinm := 'optimizer_index_cost_adj';
    end if;
    
    dbms_output.put_line ('=================================================================================================================================');
    DBMS_OUTPUT.PUT_LINE ('Is the '||upper (v_ksppinm)||' parameter set?'); 
    dbms_output.put_line ('=================================================================================================================================');

    open c_fix; 
    fetch c_fix into v_fix;
    close c_fix;
    if nvl (to_char (v_fix.value), '1') = to_char ('1') then
      DBMS_OUTPUT.PUT_LINE ('No value is found for '||upper (v_ksppinm)||' parameter.');
    else
      DBMS_OUTPUT.PUT_LINE ('The '||upper (v_ksppinm)||' parameter is set for this database and the value is: '||v_fix.value);
    end if;
    dbms_output.put_line('=================================================================================================================================');
    dbms_output.put_line (chr (10));
  end loop;
end;
/

set feedback off
begin
  dbms_output.put_line(chr(10));
  DBMS_OUTPUT.PUT_LINE ('=================================================Encountering space issues?======================================================'); 
end;
/

begin
  dbms_output.put_line(chr(10));
  DBMS_OUTPUT.PUT_LINE ('Look at view DBA_RESUMABLE:'); 
end;
/

set feedback on
SET HEADING on
set linesize 120
set pagesize 120
column name heading 'Name' format a30
column status heading 'Status' format a20
column timeout heading 'Timeout' format 999999
column error_number heading 'Error Number' format 999999
column error_msg heading 'Message' format a44

select NAME,STATUS, TIMEOUT, ERROR_NUMBER, ERROR_MSG from DBA_RESUMABLE; 

set feedback off
SET HEADING OFF

begin
  dbms_output.put_line(chr(10));
  DBMS_OUTPUT.PUT_LINE ('Look at view DBA_OUTSTANDING_ALERTS:'); 
end;
/

set feedback on
SET HEADING on
column object_name heading 'Object Name' format a20
column object_type heading 'Object Type' format a14
column reason heading 'Reason' format a40
column suggested_action heading 'Suggested action' format a40

select OBJECT_NAME,OBJECT_TYPE,REASON,SUGGESTED_ACTION from DBA_OUTSTANDING_ALERTS; 

set feedback off
SET HEADING OFF
SET LINESIZE 256
begin
  dbms_output.put_line ('=================================================================================================================================');
  DBMS_OUTPUT.PUT_LINE ('</pre>');
end;
/

spool off
PROMPT
PROMPT
PROMPT REPORT GENERATED : &SRDCSPOOLNAME..htm

exit