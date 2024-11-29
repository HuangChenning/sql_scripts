set veri off;
set feedback off;
set heading off;
set termout off;
set linesize 170
set pagesize 0

variable time1 NUMBER  
variable time2 NUMBER   
VARIABLE dbid NUMBER
VARIABLE instid NUMBER
col report new_value report_name noprint

BEGIN
  SELECT max(snap_id) INTO :time1 FROM dba_hist_snapshot;
  SELECT snap_id begin_snap INTO :time2 from (select snap_id,rownum rn from(SELECT snap_id FROM dba_hist_snapshot order by snap_id desc) where rownum<=3) where rn=3;
  SELECT dbid INTO :dbid FROM v$database;
  SELECT instance_number INTO :instid FROM v$instance;
END;
/

select './'||instance_name||'_'||'awrhtml_'||:time2||'_'||:time1||'.html' report from v$instance;


spool &&report_name;
select output from table(dbms_workload_repository.awr_report_html( :dbid,:instid,:time2, :time1,0 ));
spool OFF
