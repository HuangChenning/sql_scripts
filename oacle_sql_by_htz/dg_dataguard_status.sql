set echo off
set lines 500 pages 40
set heading on
set verify off
col inst_id for 99 heading 'I'
col dest_id for 99 heading 'DE|ID'
select *
  from (select a.inst_id,
               a.facility,
               a.severity,
               a.dest_id,
               a.error_code,
               a.timestamp,
               a.message
          from gv$dataguard_status a
         where error_code <> '0'
           and a.timestamp > sysdate - nvl('&hours', 1) / 24
         order by a.timestamp desc)
 where rownum < nvl('&ntop', 50);
