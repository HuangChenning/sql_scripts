set echo off
store set sqlplusset replace
alter session set nls_date_format= "YYYY-MM-DD HH24:MI:SS";
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000
col begin_time for a19
col end_time for a19
col t_block for 999999 heading 'TOTAL BLOCK|SIZE(M)'
col MAXQUERYLEN for 99999999 heading 'MAX LONGEST|QUERY(S)'
col txncount for 999999999 heading 'TRANSACTION|TOTAL'
col MAXQUERYID for a15 heading 'MAX LONGEST|SQL_ID'
col SSOLDERRCNT for 9999999 heading 'NUMBER FAILED|ORA-01555'
col NOSPACEERRCNT for 999999 heading 'NUMBER FAILED|REQUEST UNDO'
col a_size for 999999 heading 'ACTIVE SIZE(M)'
col u_size for 9999999 heading 'UNEXPIRED|UNDO_SIZE(M)'
col e_size for 99999 heading 'EXPIRED|UNDO_SIZE(M)'
col t_time for 999999999 heading 'TUNED_UNDO|RETENTION(S)'
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display one object type,owner,time,status                              |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT hours prompt 'Enter Search Hours (i.e. 4) : ' default 3
select begin_time,
       end_time,
       round(UNDOBLKS * 8192 / 1024 / 1024, 2) t_block,
       TXNCOUNT,
       MAXQUERYLEN,
       MAXQUERYID,
       SSOLDERRCNT,
       NOSPACEERRCNT,
       round(ACTIVEBLKS * 8192 / 1024 / 1024, 2) a_size,
       round(UNEXPIREDBLKS * 8192 / 1024 / 1024, 2) u_size,
       round(EXPIREDBLKS * 8192 / 1024 / 1024, 2) e_size,
       TUNED_UNDORETENTION t_time
  from v$undostat where begin_time>sysdate-&hours;

clear    breaks  
@sqlplusset

