 set lines 400 pages 1000 heading on
 COL time FOR a18
 COL event     FOR a30
 COL sid     FOR a10
 COL WAIT_CLASS     FOR a21
 col sql_id for a20
 col current_obj# for a40
 col object for a40
 col pga_allocated for a12         heading 'PGA_ALLOC'
 col top_level_sql_id for a20
 col temp_space_allocated for a12  heading 'TEMP_ALLOC'
 col plsql_object_id for a15
 col sid for a20
 col object_name for a40
ACCEPT b_hours prompt 'Enter Search Hours Ago (i.e. 3) : ' default '1'
ACCEPT e_hours prompt 'Enter How Many Hours  (i.e. 3) : ' default '1'
ACCEPT display_time prompt 'Enter How Display Interval Minute  (i.e. 10(default)) : ' default '10'
ACCEPT where_column prompt 'Enter which  column name (default value 1) :' default '1'
ACCEPT value prompt 'Enter where column value (default value 1) :' default '1'

variable b_hours number;
variable e_hours number;
variable display_hours number;
variable where_columnn varchar2(1000);
variable value varchar2(100);
begin
   :e_hours:=&e_hours;
   :b_hours:=&b_hours;
   :display_hours:=&display_time;
   :where_column:='&where_column';
   :value:='&value';
   end;
   /

WITH tt
     AS (SELECT /*+ materialize*/
               TO_CHAR (date_hh, 'yyyymmdd hh24')
                || ' '
                || display_hours * (date_mi)
                || '-'
                || display_hours * (date_mi + 1)
                    time,
                sql_id,
                event,
                current_obj#,
                wait_class,
                pga_allocated,
                top_level_sql_id,
                temp_space_allocated,
                plsql_object_id,
                sid,
                1 cnt
           FROM (SELECT TRUNC (sample_time, 'hh')                date_hh,
                        TRUNC (TO_CHAR (sample_time, 'mi') / display_hours) date_mi,
                        sql_id,
                        DECODE (
                            session_state,
                            'on cpu', DECODE (session_type,
                                              'background', 'bcpu',
                                              'on cpu'),
                            event)
                            event,
                        current_obj#,
                        wait_class,
                        pga_allocated,
                        top_level_sql_id,
                        temp_space_allocated,
                        plsql_object_id,
                        session_id || '.' || session_serial#     sid,
                        1                                        cnt
                   FROM gv$active_session_history
                  WHERE     SAMPLE_TIME >= SYSDATE - :b_hours / 24
                        AND SAMPLE_TIME <=
                                SYSDATE - (:b_hours - :e_hours) / 24
                        AND :where_column=:value
                 UNION ALL
                 SELECT TRUNC (sample_time, 'hh')                date_hh,
                        TRUNC (TO_CHAR (sample_time, 'mi') / display_hours) date_mi,
                        sql_id,
                        DECODE (
                            session_state,
                            'on cpu', DECODE (session_type,
                                              'background', 'bcpu',
                                              'on cpu'),
                            event)
                            event,
                        current_obj#,
                        wait_class,
                        pga_allocated,
                        top_level_sql_id,
                        temp_space_allocated,
                        plsql_object_id,
                        session_id || '.' || session_serial#     sid,
                        10                                       cnt
                   FROM DBA_HIST_ACTIVE_SESS_HISTORY
                  WHERE     SAMPLE_TIME >= SYSDATE - :b_hours / 24
                        AND SAMPLE_TIME <=
                                SYSDATE - (:b_hours - :e_hours) / 24)
                        AND :where_column=:value),
     tt_sqlid
     AS (SELECT time,
                sql_id,
                s_sql_id,
                t_sql_id
           FROM (SELECT time,
                        sql_id,
                        s_sql_id,
                        ROW_NUMBER ()
                            OVER (PARTITION BY time ORDER BY s_sql_id DESC)
                            t_sql_id
                   FROM (SELECT DISTINCT
                                time,
                                   sql_id
                                || '('
                                ||   100
                                   * TRUNC (
                                         (  SUM (cnt)
                                            OVER (PARTITION BY time, sql_id)
                                          / SUM (cnt)
                                                OVER (PARTITION BY time)),
                                         2)
                                || ')'
                                    sql_id,
                                SUM (cnt) OVER (PARTITION BY time, sql_id)
                                    s_sql_id
                           FROM tt))
          WHERE t_sql_id < 5),
     tt_event
     AS (SELECT time,
                event,
                s_event,
                t_event
           FROM (SELECT time,
                        event,
                        s_event,
                        ROW_NUMBER ()
                            OVER (PARTITION BY time ORDER BY s_event DESC)
                            t_event
                   FROM (SELECT DISTINCT
                                time,
                                   SUBSTR (event, 1, 20)
                                || '('
                                ||   100
                                   * TRUNC (
                                         (  SUM (cnt)
                                            OVER (PARTITION BY time, event)
                                          / SUM (cnt)
                                                OVER (PARTITION BY time)),
                                         2)
                                || ')'
                                    event,
                                SUM (cnt) OVER (PARTITION BY time, event)
                                    s_event
                           FROM tt))
          WHERE t_event < 5),
     tt_current_obj
     AS ( select time,current_obj#, t_current_obj# from (
SELECT time,
                        current_obj#,
                        s_current_obj#,
                        ROW_NUMBER ()
                        OVER (PARTITION BY time ORDER BY s_current_obj# DESC)
                            t_current_obj#
                   FROM (SELECT DISTINCT
                                time,
                                   owner||'.'||object_name
                                || '('
                                ||   100
                                   * TRUNC (
                                         (  SUM (
                                                cnt)
                                            OVER (
                                                PARTITION BY time,
                                                             current_obj#)
                                          / SUM (cnt)
                                                OVER (PARTITION BY time)),
                                         2)
                                || ')'
                                    current_obj#,
                                SUM (cnt)
                                    OVER (PARTITION BY time, current_obj#)
                                    s_current_obj#
                           FROM tt,dba_objects o where tt.current_obj#=o.object_id))
          WHERE t_current_obj# < 5),
     tt_wait_class
     AS (SELECT time,
                wait_class,
                s_wait_class,
                t_wait_class
           FROM (SELECT time,
                        wait_class,
                        s_wait_class,
                        ROW_NUMBER ()
                        OVER (PARTITION BY time ORDER BY s_wait_class DESC)
                            t_wait_class
                   FROM (SELECT DISTINCT
                                time,
                                   wait_class
                                || '('
                                ||   100
                                   * TRUNC (
                                         (  SUM (
                                                cnt)
                                            OVER (
                                                PARTITION BY time, wait_class)
                                          / SUM (cnt)
                                                OVER (PARTITION BY time)),
                                         2)
                                || ')'
                                    wait_class,
                                SUM (cnt)
                                    OVER (PARTITION BY time, wait_class)
                                    s_wait_class
                           FROM tt))
          WHERE t_wait_class < 5),
     tt_pga_allocated
     AS (SELECT time,
                pga_allocated,
                s_pga_allocated,
                t_pga_allocated
           FROM (SELECT time,
                        pga_allocated,
                        s_pga_allocated,
                        ROW_NUMBER ()
                        OVER (PARTITION BY time
                              ORDER BY s_pga_allocated DESC)
                            t_pga_allocated
                   FROM (SELECT DISTINCT
                                time,
                                   trunc(pga_allocated/1024/1024)
                                || '('
                                ||   100
                                   * TRUNC (
                                         (  SUM (
                                                cnt)
                                            OVER (
                                                PARTITION BY time,
                                                             pga_allocated)
                                          / SUM (cnt)
                                                OVER (PARTITION BY time)),
                                         2)
                                || ')'
                                    pga_allocated,
                                SUM (cnt)
                                    OVER (PARTITION BY time, pga_allocated)
                                    s_pga_allocated
                           FROM tt))
          WHERE t_pga_allocated < 5),
     tt_top_level_sql_id
     AS (SELECT time,
                top_level_sql_id,
                s_top_level_sql_id,
                t_top_level_sql_id
           FROM (SELECT time,
                        top_level_sql_id,
                        s_top_level_sql_id,
                        ROW_NUMBER ()
                        OVER (PARTITION BY time
                              ORDER BY s_top_level_sql_id DESC)
                            t_top_level_sql_id
                   FROM (SELECT DISTINCT
                                time,
                                   top_level_sql_id
                                || '('
                                ||   100
                                   * TRUNC (
                                         (  SUM (
                                                cnt)
                                            OVER (
                                                PARTITION BY time,
                                                             top_level_sql_id)
                                          / SUM (cnt)
                                                OVER (PARTITION BY time)),
                                         2)
                                || ')'
                                    top_level_sql_id,
                                SUM (cnt)
                                OVER (PARTITION BY time, top_level_sql_id)
                                    s_top_level_sql_id
                           FROM tt))
          WHERE t_top_level_sql_id < 5),
     tt_temp_space_allocated
     AS (SELECT time,
                 temp_space_allocated,
                s_temp_space_allocated,
                t_temp_space_allocated
           FROM (SELECT time,
                        temp_space_allocated,
                        s_temp_space_allocated,
                        ROW_NUMBER ()
                        OVER (PARTITION BY time
                              ORDER BY s_temp_space_allocated DESC)
                            t_temp_space_allocated
                   FROM (SELECT DISTINCT
                                time,
                                   trunc(temp_space_allocated/1024/1024)
                                || '('
                                ||   100
                                   * TRUNC (
                                         (  SUM (
                                                cnt)
                                            OVER (
                                                PARTITION BY time,
                                                             temp_space_allocated)
                                          / SUM (cnt)
                                                OVER (PARTITION BY time)),
                                         2)
                                || ')'
                                    temp_space_allocated,
                                SUM (
                                    cnt)
                                OVER (
                                    PARTITION BY time, temp_space_allocated)
                                    s_temp_space_allocated
                           FROM tt))
          WHERE t_temp_space_allocated < 5),
     tt_plsql_object_id
     AS (SELECT time,
                plsql_object_id,
                s_plsql_object_id,
                t_plsql_object_id
           FROM (SELECT time,
                        plsql_object_id,
                        s_plsql_object_id,
                        ROW_NUMBER ()
                        OVER (PARTITION BY time
                              ORDER BY s_plsql_object_id DESC)
                            t_plsql_object_id
                   FROM (SELECT DISTINCT
                                time,
                                   plsql_object_id
                                || '('
                                ||   100
                                   * TRUNC (
                                         (  SUM (
                                                cnt)
                                            OVER (
                                                PARTITION BY time,
                                                             plsql_object_id)
                                          / SUM (cnt)
                                                OVER (PARTITION BY time)),
                                         2)
                                || ')'
                                    plsql_object_id,
                                SUM (cnt)
                                    OVER (PARTITION BY time, plsql_object_id)
                                    s_plsql_object_id
                           FROM tt))
          WHERE t_plsql_object_id < 5),
     tt_sid
     AS (SELECT time,
                sid,
                s_sid,
                t_sid
           FROM (SELECT time,
                        sid,
                        s_sid,
                        ROW_NUMBER ()
                            OVER (PARTITION BY time ORDER BY s_sid DESC)
                            t_sid
                   FROM (SELECT DISTINCT
                                time,
                                   sid
                                || '('
                                ||   100
                                   * TRUNC (
                                         (  SUM (cnt)
                                                OVER (PARTITION BY time, sid)
                                          / SUM (cnt)
                                                OVER (PARTITION BY time)),
                                         2)
                                || ')'
                                    sid,
                                SUM (cnt) OVER (PARTITION BY time, sid) s_sid
                           FROM tt))
          WHERE t_sid < 5)
SELECT a.time,
       a.sql_id,
       b.event,
       c.current_obj#,
       d.wait_class,
       e.pga_allocated,
       f.top_level_sql_id,
       g.plsql_object_id,
       h.sid,
       i.temp_space_allocated
  FROM tt_sqlid  a
       FULL OUTER JOIN tt_event b
           ON a.time = b.time AND a.t_sql_id = b.t_event
       FULL OUTER JOIN tt_current_obj c
           ON a.time = c.time AND a.t_sql_id = c.t_current_obj#
       FULL OUTER JOIN tt_wait_class d
           ON a.time = d.time AND a.t_sql_id = d.t_wait_class
       FULL OUTER JOIN tt_pga_allocated e
           ON a.time = e.time AND a.t_sql_id = e.t_pga_allocated
       FULL OUTER JOIN tt_top_level_sql_id f
           ON a.time = f.time AND a.t_sql_id = f.t_top_level_sql_id
       FULL OUTER JOIN tt_plsql_object_id g
           ON a.time = g.time AND a.t_sql_id = g.t_plsql_object_id
       FULL OUTER JOIN tt_sid h ON a.time = h.time AND a.t_sql_id = h.t_sid
       FULL OUTER JOIN tt_temp_space_allocated i
           ON a.time = i.time AND a.t_sql_id = i.t_temp_space_allocated
/