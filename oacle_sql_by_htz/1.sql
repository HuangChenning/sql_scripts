/* Formatted on 2018/1/19 0:47:35 (QP5 v5.300) */
 set lines 400 pages 1000 heading on
 COL time FOR a18
 COL event     FOR a27
 COL sid     FOR a10
 COL WAIT_CLASS     FOR a21
 col sql_id for a20
 col event for a22
 col current_obj# for a15
 col pga_allocated for a12         heading 'PGA_ALLOC'
 col top_level_sql_id for a20
 col temp_space_allocated for a12  heading 'TEMP_ALLOC'
 col plsql_object_id for a15
 col sid for a20
 col object_name for a40

WITH tt AS
 (SELECT /*+ materialize*/
   time,
   sql_id,
   event,
   current_obj#,
   current_obj,
   wait_class,
   pga_allocated,
   top_level_sql_id,
   temp_space_allocated,
   plsql_object_id,
   sid
    FROM (SELECT DISTINCT time,
                          sql_id || '(' ||
                          ROUND(100 * s_sql_id / t_sql_id, 1) || ')' sql_id,
                          DENSE_RANK() OVER(PARTITION BY time ORDER BY s_sql_id DESC) o_sql_id,
                          s_sql_id,
                          substr(event,1,20) || '(' || ROUND(100 * s_event / t_event, 1) || ')' event,
                          DENSE_RANK() OVER(PARTITION BY time ORDER BY s_event DESC) o_event,
                          current_obj#,
                          '(' || ROUND(100 * s_obj / t_obj, 1) || ')' current_obj,
                          DENSE_RANK() OVER(PARTITION BY time ORDER BY s_obj DESC) o_obj,
                          wait_class || '(' ||
                          ROUND(100 * s_wait / t_wait, 1) || ')' wait_class,
                          DENSE_RANK() OVER(PARTITION BY time ORDER BY s_wait DESC) o_wait,
                          TRUNC(PGA_ALLOCATED / 1024 / 1024) || '(' ||
                          ROUND(100 * s_pga / t_pga, 1) || ')' PGA_ALLOCATED,
                          DENSE_RANK() OVER(PARTITION BY time ORDER BY s_pga DESC) o_pga,
                          top_level_sql_id || '(' ||
                          ROUND(100 * s_top / t_top, 1) || ')' top_level_sql_id,
                          DENSE_RANK() OVER(PARTITION BY time ORDER BY s_top DESC) o_top,
                          TRUNC(temp_space_allocated / 1024 / 1024) || '(' ||
                          ROUND(100 * s_temp / t_temp, 1) || ')' temp_space_allocated,
                          DENSE_RANK() OVER(PARTITION BY time ORDER BY s_temp DESC) o_temp,
                          plsql_object_id || '(' ||
                          ROUND(100 * s_plsql / t_plsql, 1) || ')' plsql_object_id,
                          DENSE_RANK() OVER(PARTITION BY time ORDER BY s_plsql DESC) o_plsql,
                          sid || '(' || ROUND(100 * s_sid / t_sid, 1) || ')' sid,
                          DENSE_RANK() OVER(PARTITION BY time ORDER BY s_sid DESC) o_sid
            FROM (SELECT time,
                         sql_id,
                         SUM(cnt) OVER(PARTITION BY time, sql_id) s_sql_id,
                         SUM(cnt) OVER(PARTITION BY time) t_sql_id,
                         event,
                         SUM(cnt) OVER(PARTITION BY time, event) s_event,
                         SUM(cnt) OVER(PARTITION BY time) t_event,
                         current_obj#,
                         SUM(cnt) OVER(PARTITION BY time, current_obj#) s_obj,
                         SUM(cnt) OVER(PARTITION BY time) t_obj,
                         wait_class,
                         SUM(cnt) OVER(PARTITION BY time, wait_class) s_wait,
                         SUM(cnt) OVER(PARTITION BY time) t_wait,
                         PGA_ALLOCATED,
                         SUM(cnt) OVER(PARTITION BY time, PGA_ALLOCATED) s_pga,
                         SUM(cnt) OVER(PARTITION BY time) t_pga,
                         top_level_sql_id,
                         SUM(cnt) OVER(PARTITION BY time, top_level_sql_id) s_top,
                         SUM(cnt) OVER(PARTITION BY time) t_top,
                         temp_space_allocated,
                         SUM(cnt) OVER(PARTITION BY time, temp_space_allocated) s_temp,
                         SUM(cnt) OVER(PARTITION BY time) t_temp,
                         plsql_object_id,
                         SUM(cnt) OVER(PARTITION BY time, plsql_object_id) s_plsql,
                         SUM(cnt) OVER(PARTITION BY time) t_plsql,
                         sid,
                         SUM(cnt) OVER(PARTITION BY time, sid) s_sid,
                         SUM(cnt) OVER(PARTITION BY time) t_sid
                    FROM (SELECT TO_CHAR(DATE_HH, 'yyyymmdd hh24') || ' ' ||
                                 10 * (DATE_MI) || '-' || 10 * (DATE_MI + 1) time,
                                 sql_id,
                                 event,
                                 CURRENT_OBJ#,
                                 WAIT_CLASS,
                                 PGA_ALLOCATED,
                                 TOP_LEVEL_SQL_ID,
                                 TEMP_SPACE_ALLOCATED,
                                 PLSQL_OBJECT_ID,
                                 sid,
                                 1 cnt
                            FROM (SELECT TRUNC(SAMPLE_TIME, 'HH') DATE_HH,
                                         TRUNC(TO_CHAR(SAMPLE_TIME, 'MI') / 10) DATE_MI,
                                         sql_id,
                                         DECODE(SESSION_STATE,
                                                'ON CPU',
                                                DECODE(SESSION_TYPE,
                                                       'BACKGROUND',
                                                       'BCPU',
                                                       'ON CPU'),
                                                EVENT) event,
                                         CURRENT_OBJ#,
                                         WAIT_CLASS,
                                         PGA_ALLOCATED,
                                         TOP_LEVEL_SQL_ID,
                                         TEMP_SPACE_ALLOCATED,
                                         PLSQL_OBJECT_ID,
                                         SESSION_ID || '.' || SESSION_SERIAL# sid,
                                         1 cnt
                                    FROM GV$ACTIVE_SESSION_HISTORY
                                   WHERE SAMPLE_TIME >= SYSDATE - 30 / 1440))))
   WHERE (o_sql_id < 5 or  o_event < 5 or o_obj <5  or o_wait <5 or o_pga <5  or o_top<5 or o_temp <5  or o_plsql or o_sid <5))
SELECT b.time,
       b.sql_id,
       b.event,
       DECODE(b.current_obj#,
              '-1',
              'NULL' || current_obj,
              '0',
              '0' || current_obj,
              c.owner || '.' || c.object_name || b.current_obj) object_name,
       b.wait_class,
       b.pga_allocated,
       b.top_level_sql_id,
       b.temp_space_allocated,
       b.plsql_object_id,
       b.sid
  FROM tt b, dba_objects c
 WHERE (c.object_id(+) = b.current_obj#)
 ORDER BY time
