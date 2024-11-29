set echo off
set heading on
set pages 100
set lines 300
set verify off
col s_u_s for a30 heading 'INST_ID.SID|USERNAME.STATUS'
col sql_id for a20 heading 'SQL_ID|SQL_CHILD_NUMBER'
col block_s for a15 heading 'BLOCK_SESS|INST:SESS'
col l_s for a15 heading 'LAST_CALL_ET|SEQ#'
col o_s for a30 heading 'OWNER:SEGMENT_NAME'
col xid for a25 heading 'XID|USN:SLOT:WRAP'
col uba for a25 heading 'UBA|FILE:BLOCK:SEQ:REC'
col used_ublk for 999999999 heading 'USED|UNDO_BLOCK'
col used_urec for 999999999 heading 'USED|UNDO_REC'
col tablespace_name for a15 heading 'UNDO|TABLESPACE'
undefine inst_id;
undefine sid;
SELECT a.inst_id || '.' || a.sid || '.' || a.username || '.' || a.status
          s_u_s,
       a.LAST_CALL_ET || '.' || a.seq# l_s,
          DECODE (a.sql_id, '0', a.prev_sql_id, a.sql_id)
       || ':'
       || sql_child_number
          sql_id,
       c.tablespace_name,
       c.owner || '.' || c.segment_name o_s,
       b.xidusn || '.' || B.XIDSLOT || '.' || b.xidsqn xid,
       B.UBAFIL || '.' || b.ubablk || '.' || b.ubasqn || '.' || B.UBAREC uba,
       b.used_ublk,
       used_urec
  FROM gv$session a, gv$transaction b, dba_rollback_segs c
 WHERE     a.inst_id = b.inst_id
       AND a.saddr = b.ses_addr
       AND b.xidusn = c.segment_id
       AND a.inst_id = NVL ('&inst_id', a.inst_id)
       AND a.sid = NVL ('&sid', a.sid);
undefine inst_id;
undefine sid;
