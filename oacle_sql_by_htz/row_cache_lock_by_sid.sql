-- File Name : we.sql
-- Purpose : 显示对象或者回话的row cache锁的信息
-- 支持 10g,11g
-- Date : 2015/09/05
-- 认真就输、QQ:7343696
-- http://www.htz.pw
set echo off
set lines 300 heading on pages 1000 verify off
COL event FORMAT a18
COL program FORMAT a23
COL os_sess FOR a15 heading 'SESS_SERIAL'
col u_s for a22 heading 'USERNMAE|LAST_CALL|SEQ#'
col object_info    for  a60 heading 'OBJECT|OWNER:NAME'
col lock_info      for  a5 heading 'LOCK|H:R'
col rac_info       for  a10   heading 'RAC_LOCK'
col sql_id         for  a18


VAR biten NUMBER;

BEGIN
   :biten := UTL_RAW.little_endian;
END;
/

undefine sid;
undefine objname;
undefine objowner;
undefine mode_hold;
undefine mode_request;
SELECT /*+ rule*/
 b.username || '.' || trim(a.objname) || '.' || a.object_type object_info,
 a.mode_hold || '.' || a.mode_request lock_info,
 a.instance_type || ':' || a.instance_id1 || '.' || a.instance_id2 rac_info,
 SUBSTR(DECODE(c.STATE,
               'WAITING',
               c.EVENT,
               DECODE(TYPE, 'BACKGROUND', '[BCPU]:', '[CPU]:') || c.event),
        1,
        18) event,
 SUBSTR(c.program, 1, 22) program,
 b.username || '|' || CASE
   WHEN c.last_call_et < 1000 THEN
    c.last_call_et || ''
   WHEN c.last_call_et BETWEEN 1000 AND 10000 THEN
    SUBSTR(c.last_call_et / 1000, 1, 3) || 'K'
   WHEN c.last_call_et > 10000 THEN
    SUBSTR(c.last_call_et / 10000, 1, 3) || 'W'
 END || '|' || CASE
   WHEN c.seq# < 1000 THEN
    c.seq# || ''
   WHEN c.seq# BETWEEN 1000 AND 10000 THEN
    SUBSTR(c.seq# / 1000, 1, 3) || 'K'
   WHEN c.seq# > 10000 THEN
    SUBSTR(c.seq# / 10000, 1, 3) || 'W'
 END u_s,
 c.sid || ':' || c.serial# os_sess,
 DECODE(c.sql_id,
        '0',
        'P.' || c.prev_sql_id,
        '',
        'P.' || c.prev_sql_id,
        'C.' || c.sql_id) || ':' || c.sql_child_number sql_id
  FROM (SELECT distinct UTL_RAW.cast_to_binary_integer(UTL_RAW.SUBSTR(HEXTORAW(kqrfpkey),
                                                             1,
                                                             2),
                                              :biten) user_id,
               KQRFPMOD mode_hold,
               KQRFPREQ mode_request,
               KQRFPSES saddr,
               KQRFPITY instance_type,
               KQRFPII1 instance_id1,
               KQRFPII2 instance_id2,
               UTL_RAW.cast_to_varchar2(UTL_RAW.SUBSTR(HEXTORAW(kqrfpkey),
                                                       6,
                                                       30)) objname,
               DECODE(UTL_RAW.SUBSTR(HEXTORAW(kqrfpkey), 37, 1),
                      '01',
                      'TABLE/PROC',
                      '02',
                      'PACKAGE BODY',
                      '03',
                      'TRIGGER',
                      '04',
                      'INDEX',
                      '05',
                      'CLUSTER',
                      '0A',
                      'QUEUE',
                      'kqdoknsp=0x' ||
                      UTL_RAW.SUBSTR(HEXTORAW(kqrfpkey), 37, 1)) object_type
          FROM x$kqrfp
         WHERE kqrfpcid = 8) a,
       dba_users b,
       v$session c
 WHERE a.saddr = c.saddr
   AND a.user_id = b.user_id
   AND c.sid = NVL('&sid', c.sid)
   AND b.username = NVL(UPPER('&objowner'), b.username)
 --  AND TRIM(a.objname) = NVL(UPPER('&objname'), a.objname)
   AND a.mode_hold = NVL('&mode_hold', a.mode_hold)
   AND a.mode_request = NVL('&mode_request', a.mode_request)
/
undefine sid;
undefine objname;
undefine objowner;
undefine mode_hold;
undefine mode_request;