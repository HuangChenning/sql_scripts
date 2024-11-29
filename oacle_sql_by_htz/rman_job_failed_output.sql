set echo off
set lines 20000 pages 5550 heading on verify off

-- select output
--   from v$rman_output a
--  where (SESSION_RECID, SESSION_STAMP) in
--        (select *
--           from (select SESSION_RECID, SESSION_STAMP
--                   from v$rman_status
--                  where status = 'FAILED'
--                    and operation = decode('&TYPE_B_D_R',
--                                           'B',
--                                           'BACKUP',
--                                           'D',
--                                           'DELETE',
--                                           'R',
--                                           'RESTORE',
--                                           operation)
--                  order by command_id desc)
--          where rownum < 10);

select to_char(j.start_time, 'yyyy-mm-dd hh24:mi:ss') start_time,
       j.status,
       j.input_type,
       o.OUTPUT
  from V$RMAN_BACKUP_JOB_DETAILS j, GV$RMAN_OUTPUT o
 where o.session_recid = j.session_recid
   and o.session_stamp = j.session_stamp
   and j.STATUS = 'FAILED'
   and start_time > sysdate - 10
   and o.output is not null
 order by j.start_time, j.command_id;
