set echo off;
set lines 250 pages 10000 verify off heading on
col end_time for a11
col report_id for 99999999
col sql_id for a13
col plan_hash for a14
col sql_exec_start for a19
col last_refresh_time for a19
col sql_exec_id for a15
col cpu_time_MS for 999999999
col elapsed_time_MS for 9999999999
col logical_m for 999999999
col read_m for 99999999
col REFRESH_COUNT for a5 heading 'R_CNT'
undefine days
SELECT /*+ NO_XML_QUERY_REWRITE */
 to_char(b.END_INTERVAL_TIME, 'mm-dd hh24:mi') end_time,
 t.report_id,
 x1.sql_id,
 x1.plan_hash,
 x1.sql_exec_start,
 x1.last_refresh_time,
 x1.sql_exec_id,
 trunc(x1.cpu_time / 1000) cpu_time_MS,
 trunc(x1.elapsed_time / 1000) elapsed_time_MS,
 trunc(x1.buffer_gets * 8 / 1024) logical_m,
 trunc(x1.read_bytes / 1024 / 1024) read_m,refresh_count
  FROM dba_hist_reports t,
       dba_hist_snapshot b,
       xmltable('/report_repository_summary/sql' PASSING
                xmlparse(document t.report_summary) COLUMNS sql_id path
                '@sql_id',
                sql_exec_start path '@sql_exec_start',
                sql_exec_id path '@sql_exec_id',
                status path 'status',
                sql_text path 'sql_text',
                first_refresh_time path 'first_refresh_time',
                last_refresh_time path 'last_refresh_time',
                refresh_count path 'refresh_count',
                inst_id path 'inst_id',
                session_id path 'session_id',
                session_serial path 'session_serial',
                user_id path 'user_id',
                username path 'user',
                con_id path 'con_id',
                con_name path 'con_name',
                modul path 'module',
                action path 'action',
                service path 'service',
                program path 'program',
                plan_hash path 'plan_hash',
                is_cross_instance path 'is_cross_instance',
                dop path 'dop',
                instances path 'instances',
                px_servers_requested path 'px_servers_requested',
                px_servers_allocated path 'px_servers_allocated',
                duration path 'stats/stat[@name="duration"]',
                elapsed_time path 'stats/stat[@name="elapsed_time"]',
                cpu_time path 'stats/stat[@name="cpu_time"]',
                user_io_wait_time path
                'stats/stat[@name="user_io_wait_time"]',
                application_wait_time path
                'stats/stat[@name="application_wait_time"]',
                concurrency_wait_time path
                'stats/stat[@name="concurrency_wait_time"]',
                cluster_wait_time path
                'stats/stat[@name="cluster_wait_time"]',
                plsql_exec_time path 'stats/stat[@name="plsql_exec_time"]',
                other_wait_time path 'stats/stat[@name="other_wait_time"]',
                buffer_gets path 'stats/stat[@name="buffer_gets"]',
                read_reqs path 'stats/stat[@name="read_reqs"]',
                read_bytes path 'stats/stat[@name="read_bytes"]') x1
 where t.COMPONENT_NAME = 'sqlmonitor'
   and t.snap_id = b.snap_id
   and b.END_INTERVAL_TIME > (sysdate - nvl('&days',2))
   and t.dbid = b.dbid
 order by elapsed_time_MS
/
undefine days