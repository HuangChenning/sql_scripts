Rem
Rem Copyright (c) 2008, Oracle Corporation.  All rights reserved.
Rem
Rem    NAME
Rem      awrtoprdrpt.sql
Rem
Rem    DESCRIPTION
Rem      This report displays AWR ststistics for segments
Rem      with top physical reads for the period, as well
Rem      as object affinity specific settings.
Rem      It should help tuning object to instance affinity
Rem      in a RAC environment.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    jrimoli     03/03/08 - Created
Rem  
Rem

set pages 10000
set feed off newp none
set lines 132
variable bid number
variable dbid number
variable eid number
accept begin_snap number prompt "Begin Snapshot: "
accept end_snap number prompt "End Snapshot: "
accept min_pr prompt "Minimum physical reads per minute to display: "
whenever sqlerror exit
declare 
n number;
m number;
begin
     	:bid:=&begin_snap;
     	:eid:=&end_snap;
    	select dbid into :dbid
	from v$database;
	select count(*) into m
	from dba_hist_snapshot 
	where snap_id=:bid
	and dbid=:dbid;
	select count(*) into n
	from dba_hist_snapshot 
	where snap_id=:eid
	and dbid=:dbid;
        if n <> m  
          then raise_application_error(-20001,'snap_ids not available on all instances');
        end if; 
        select count(*) into n
        from dba_hist_snapshot s1, dba_hist_snapshot s2
        where s1.snap_id=:bid
        and s2.snap_id=:eid
	and s1.dbid=s2.dbid
	and s1.dbid=:dbid
        and s1.instance_number=s2.instance_Number
        and s2.startup_time < s1.END_INTERVAL_TIME;
        if n <> m  
          then raise_application_error(-20001,'Instance(s) restarted between snapshots');
        end if; 
end;
/
set term off
col rep new_value report_name
select 'top_phrd_'||:bid||'_'||:eid rep
from dual;
undef begin_snap
undef end_snap
set term on
spool &report_name
prompt AWR Top Physical Reads Per Object Report
prompt ========================================
prompt
prompt This report should help identify objects that would qualify for instance affinity.  Although object affinity 
prompt decisions are based on GCS lock opens, 'physical reads cache' can be used for affinity estimate purposes. 
prompt Usually, most GCS lock opens are caused by 'physical reads cache'.
prompt 
break on db_name on version
col db_name head 'Database|Name'
col end_interval_time format a25
col instance_name format a10 head 'Instance|Name'
col version format a15 head 'Database|Version' new_value dbver
col begin_snap format 999,999 head 'Begin|Snap'
col end_snap format 999,999 head 'End|Snap'
col begin_int format a25 head 'Begin|Timestamp'
col end_int format a25 head 'End|Timestamp'
select d.db_name, d.version, d.instance_name, b.snap_id begin_snap, b.END_INTERVAL_TIME begin_int, e.snap_id end_snap, e.END_INTERVAL_TIME end_int
from dba_hist_database_instance d, dba_hist_snapshot b, dba_hist_snapshot e
where b.instance_number=e.instance_number
and b.dbid=e.dbid
and b.dbid=:dbid
and b.snap_id=:bid
and e.snap_id=:eid
and e.dbid=d.dbid
and e.startup_time=d.startup_time
order by d.instance_name
/
prompt
prompt Local open ratio indicates effectiveness of affinity and read mostly policies
prompt Local open ratio = gc local grants/(gc local grants + gc remote grants)
prompt Higher ratios mean less GCS messages and improved performance
prompt
col lrat format 990.9
set head off 

select 'Local open ratio for this AWR period: ', 
	sum(l2.value-l1.value)/(sum(l2.value-l1.value)+sum(r2.value-r1.value))*100 lrat, '%'
from dba_hist_sysstat l1, dba_hist_sysstat l2, dba_hist_sysstat r1, dba_hist_sysstat r2
where l1.dbid=:dbid
and l2.dbid=:dbid
and r1.dbid=:dbid
and r2.dbid=:dbid
and l1.snap_id=:bid
and l2.snap_id=:eid
and r1.snap_id=:bid
and r2.snap_id=:eid
and l1.stat_name='gc local grants'
and l2.stat_name='gc local grants'
and r1.stat_name='gc remote grants'
and r2.stat_name='gc remote grants';

set head on
set serveroutput on format wrapped
prompt
declare
 policy_time number;
 policy_ratio number;
 policy_minimum number;
 inst_percent number;
 version number;
 aff_enabled varchar2(10);
begin
	version := to_number(substr('&dbver',1,2));	
	if version=11 
	then
		select nvl(min(value),'TRUE') into aff_enabled
		from dba_hist_parameter
		where parameter_name='_gc_affinity_locking'
		and snap_id=:eid;
	end if;
	for c in (select parameter_name, min(value) value
		from dba_hist_parameter
		where snap_id=:eid
		and parameter_name in ('_gc_policy_minimum','_gc_policy_time','_gc_affinity_ratio',
			'_gc_affinity_limit', '_gc_affinity_time', '_gc_affinity_minimum')
		group by parameter_name)
	loop
		case c.parameter_name
			when '_gc_policy_minimum' then policy_minimum:=c.value;
			when '_gc_affinity_minimum' then policy_minimum:=c.value;
			when '_gc_policy_time' then policy_time:=c.value;
			when '_gc_affinity_time' then policy_time:=c.value;
			when '_gc_affinity_ratio' then policy_ratio:=c.value;
			when '_gc_affinity_limit' then policy_ratio:=c.value;
		end case;
	end loop;
	policy_time:=nvl(policy_time,10);
	dbms_output.put_line ('Object affinity and dynamic remaster settings for this AWR period:');
	dbms_output.put_line ('==================================================================');
	if policy_time=0 
	then aff_enabled:='FALSE'; 
	else dbms_output.put_line ('Dynamic remaster decisions were set to occur every '||policy_time||' minutes');
	end if;
	policy_ratio:=nvl(policy_ratio,50);
	inst_percent:=trunc(policy_ratio/(policy_ratio+1)*100);
	if version=11
	then 	policy_minimum:=nvl(policy_minimum,1500);
	else 	policy_minimum:=nvl(policy_minimum,6000);
	end if;
	if aff_enabled='FALSE' 
	then 
		dbms_output.put_line ('Object Affinity was disabled!');
		dbms_output.put_line ('If affinity was enabled, objects would qualify for affinity if:');
	else 	dbms_output.put_line ('During the AWR period, these were the conditions for objects to qualify for affinity:');
	end if;
	dbms_output.put_line (' ');
	dbms_output.put_line ('1) Top instance should open at least '||policy_minimum||' locks per minute for the object');
	dbms_output.put_line ('   Compare that to the column "PhRd Cache per minute" below');
	dbms_output.put_line (' ');
	dbms_output.put_line ('2) Top instance should open at least '||inst_percent||' % of the locks for the object');
	dbms_output.put_line ('   Compare that to the column "% of Object" below');
	dbms_output.put_line (' ');
end;
/
set serveroutput off
undef dbver
prompt
col owner format a10 trunc
col object_name format a30
col subobject_name format a20 trunc
col instance_number format 99 head "Top|inst"
col phrds_cache_permin format 999,999,999 head "PhRd Cache|per minute"
col percobj format 999.9 head "% of|object"
col perctotrd format 999.9 head "% of|reads"
select o.OWNER, o.OBJECT_NAME, o.SUBOBJECT_NAME, 
	i.instance_number, i.phrds_cache/min.minutes phrds_cache_permin,
	i.phrds_cache/sum(s.PHYSICAL_READS_DELTA-s.physical_reads_direct_delta)*100 percobj, i.phrds_cache/totpr.value*100 perctotrd
from dba_hist_seg_stat s, dba_hist_seg_stat_obj o,
	(select obj#, dataobj#, instance_number, sum(physical_reads_delta-physical_reads_direct_delta) phrds_cache
        from dba_hist_seg_stat ss
        where snap_id between :bid+1 and :eid
        and dbid=:dbid
        group by obj#, dataobj#, instance_number
        having sum(physical_reads_delta-physical_reads_direct_delta) = (select max(sum(physical_reads_delta-physical_reads_direct_delta))
                                        from dba_hist_seg_stat
                                        where snap_id between :bid+1 and :eid
                                        and dbid=:dbid
                                        and obj#=ss.obj#
                                        and dataobj#=ss.dataobj#
                                        group by obj#, dataobj#, instance_number)) i,
	(select bsn.instance_number, 
		(extract(day from (esn.END_INTERVAL_TIME-bsn.END_INTERVAL_TIME))*86400 +
                 extract(hour from (esn.END_INTERVAL_TIME-bsn.END_INTERVAL_TIME))*3600 +
                 extract(minute from (esn.END_INTERVAL_TIME-bsn.END_INTERVAL_TIME))*60 +
                 extract(second from (esn.END_INTERVAL_TIME-bsn.END_INTERVAL_TIME)))/60 minutes
	from dba_hist_snapshot bsn, dba_hist_snapshot esn
	where bsn.snap_id=:bid
	and esn.snap_id=:eid
	and bsn.instance_number=esn.instance_number
	and bsn.dbid=esn.dbid
	and bsn.dbid=:dbid) min,
	(select sum(eprc.value-bprc.value) value
	from dba_hist_sysstat bprc, dba_hist_sysstat eprc
	where bprc.dbid=eprc.dbid
	and bprc.instance_number=eprc.instance_number
	and bprc.snap_id=:bid
	and eprc.snap_id=:eid
	and bprc.stat_name=eprc.stat_name
	and bprc.stat_name='physical reads cache') totpr
where s.dbid=o.dbid
and s.obj#=o.obj#
and s.dataobj#=o.dataobj#
and s.dbid=:dbid
and i.obj#=s.obj#
and min.instance_number=i.instance_number
and i.phrds_cache/min.minutes > &min_pr
and i.dataobj#=s.dataobj#
and s.snap_id between :bid+1 and :eid
group by o.OWNER, o.OBJECT_NAME, o.SUBOBJECT_NAME, i.instance_number, i.phrds_cache, i.phrds_cache/min.minutes, totpr.value
order by i.phrds_cache desc
/
spool off
undef report_name min_pr
begin
	:bid:=null;
	:eid:=null;
	:dbid:=null;
end;
/
set feed on
