col begin_snap new_value begin_snap noprint 
col end_snap new_value end_snap noprint 
col inst_num new_value inst_num noprint
col report new_value report_name noprint

SELECT max(snap_id) end_snap FROM perfstat.stats$snapshot;
select snap_id begin_snap from (select snap_id,rownum rn from(SELECT snap_id FROM perfstat.stats$snapshot order by snap_id desc) where rownum<=3) where rn=3;
SELECT instance_number inst_num FROM v$instance;
select './'||instance_name||'_'||'spreport_'||&&begin_snap||'_'||&&end_snap||'.lst' report from v$instance;
@./spreport.sql
