set echo off
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 40
column owner format a16
column object_name format a30
column start_day format a11
column block_increase format 9999999999
col tablespace_name for a15
break on end_interva_time on tablespace_name  on owner 
SELECT *
  FROM (  SELECT TO_CHAR (sn.end_interval_time, 'MM-DD HH24:MI')
                    end_interva_time,
                 tb.name tablespace_name,
                 obj.owner,
                 obj.object_name,
                 ROUND (SUM (a.space_used_delta), 2) used_increase,
                 ROUND (SUM (a.space_allocated_delta), 2) allocate_increase,
                 SUM (a.db_block_changes_delta) block_increase,
                 DENSE_RANK ()
                 OVER (
                    PARTITION BY TO_CHAR (sn.end_interval_time,
                                          'MM-DD HH24:MI')
                    ORDER BY SUM (a.space_used_delta) DESC)
                    AS "ORDERBY"
            FROM dba_hist_seg_stat a,
                 dba_hist_snapshot sn,
                 dba_objects obj,
                 v$tablespace tb
           WHERE     a.ts# = tb.ts#
                 AND sn.snap_id = a.snap_id
                 AND obj.object_id = a.obj#
                 --  and obj.owner not in ('SYS', 'SYSTEM')
                 AND end_interval_time >=
                        TO_TIMESTAMP (
                           (TO_CHAR (SYSDATE - NVL ('&&day', 7), 'YYYY-MM-DD')),
                           'YYYY-MM-DD')
                 AND end_interval_time <=
                        TO_TIMESTAMP (
                           (TO_CHAR (
                                 SYSDATE
                               - (  NVL ('&&day', 7)
                                  - NVL ('&interval_day', &&day)),
                               'YYYY-MM-DD')),
                           'YYYY-MM-DD')
                 AND tb.name = NVL (UPPER ('&tablespace_name'), tb.name)
                 AND obj.OWNER = NVL (UPPER ('&ownername'), obj.owner)
                 AND obj.OBJECT_NAME =
                        NVL (UPPER ('&segmentname'), obj.object_name)
        GROUP BY TO_CHAR (sn.end_interval_time, 'MM-DD HH24:MI'),
                 tb.name,
                 obj.owner,
                 obj.object_name) dd
 WHERE dd.orderby < NVL ('&top', 40)
/
clear    breaks  
undefine tablespace_name;
undefine day;
undefine ownername;
undefine segmentname;
undefine top;
undefine interval_day