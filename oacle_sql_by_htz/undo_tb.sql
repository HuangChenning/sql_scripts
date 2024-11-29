set serverout on size 1000000
set verify off
SET PAGES 5000
set linesize 500
col NAME_COL_PLUS_SHOW_PARAM for a20;
col VALUE_COL_PLUS_SHOW_PARAM for a20;
show parameter undo ;
col name for a12
col program for a30
col xacts for 99
col sid for 99999
col serial# for 99999
select * from
(select  to_char(sysdate,'hh24:mi:ss') as curtime,e.start_time,a.name,round(f.bytes/1024/1024,2) as mbytes,b.xacts,c.sid,c.
serial#
,decode(sql_hash_value,0,prev_hash_value,sql_hash_value) as hash_value,decode(instr(C.PROGRAM,'(TNS'),0,c.PROGRAM,substr(c.program,1,instr(C.PROGRAM,'(TNS') -1 )) PROGRAM,c.LOGON_TIME
from v$rollname a,v$rollstat b,v$session c,v$transaction e ,dba_segments f
where a.usn=b.usn and b.usn=e.xidusn
and c.saddr=e.ses_addr
and a.name(+)=f.segment_name
order by mbytes DESC)
where rownum<=10;
select to_char(sysdate,'hh24:mi:ss') as curtime,status,TRUNC(SUM(BYTES)/1024/1024) "size(M)" from dba_undo_extents where tablespace_name=(select VALUE from v$parameter where name='undo_tablespace') group by status;
col "Tablespace Name" for a40
select tablespace_name,trunc(a.Free_Space) "Free_space(M)",trunc(b.TOTAL_SPACE) "TOTAL_SPACE(M)",trunc((1 - a.Free_Space/b.TOTAL_SPACE) * 100) "USED(%)" from(
select tablespace_name,sum(bytes/1024/1024) Free_Space
from dba_free_space 
where tablespace_name = (select VALUE from v$parameter where name='undo_tablespace') group by tablespace_name) a,
(select sum(bytes/1024/1024) TOTAL_SPACE
from v$datafile a,v$tablespace b
where a.ts# = b.ts# and b.name = (select VALUE from v$parameter where name='undo_tablespace'))b;
