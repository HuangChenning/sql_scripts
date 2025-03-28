
set linesize 120
set pagesize 120


select to_char(sysdate, 'dd-MON-yyyy hh24:mi:ss') "Script Run Time" from dual;

select INSTANCE_NUMBER,INSTANCE_NAME,HOST_NAME from v$instance;

PROMPT
PROMPT V$SESSSTAT MEMORY INFO
PROMPT -------------------------

--Monitor the pga usage for all processes related to an instance from v$sesstat.
--Look at trends of individual processes growing in size or high number of processes
REM v$sesstat  pga/uga memory size

select p.spid, s.sid, substr(n.name,1,25) memory, s.value as Bytes from v$sesstat s, v$statname n, v$process p, v$session vs
where s.statistic# = n.statistic#
/* this query currently looks at both uga and pga, if only one of these is desired modify the like clause to pga or uga */
and n.name like '%ga memory%'
and s.sid=vs.sid
and vs.paddr=p.addr
/* --remove comment delimiters to view only certain sizes, i.e. over 10Mbytes */
/* and s.value > 10000000 */
order by s.value asc;

PROMPT
PROMPT LARGEST PGA_ALLOC_MEM PROCESS NOT LIKE LGWR
PROMPT -------------------------

REM List Largest process.

/* Do Not eliminate all background process because certain background processes do need to be monitored at times */
select pid,spid,substr(username,1,20) "USER" ,program,PGA_USED_MEM,PGA_ALLOC_MEM,PGA_FREEABLE_MEM,PGA_MAX_MEM
from v$process
where pga_alloc_mem=(select max(pga_alloc_mem) from v$process
where program not like '%LGWR%');

PROMPT
PROMPT SELECT SUM(PGA_ALLOC_MEM) sum(PGA_USED_MEM) FROM V$PROCESS
PROMPT ------------------------- 

REM Summation of pga based on v$process
REM allocated includes free PGA memory not yet released to the operating system by the server process
select sum(pga_alloc_mem)/1024/1024 as "Mbytes Alloc", sum(PGA_USED_MEM)/1024/1024 as "Mbytes used" from v$process;

PROMPT
PROMPT SELECT SUM PGA MEMORY FROM V$SESSTAT
PROMPT ------------------------- 

REM Summation of pga memory based on v$sesstat
select sum(value)/1024/1024 as "Mbytes" from v$sesstat s, v$statname n
        where
        n.STATISTIC# = s.STATISTIC# and
        n.name = 'session pga memory';

PROMPT
PROMPT SELECT * FROM V$PGASTAT 
PROMPT -------------------------

REM PGA stats from v$pgastat
select substr(name,1,30), value, unit from v$pgastat;


PROMPT
PROMPT SHOW INFO on ALL PROCESSES 
PROMPT -------------------------

--List all processes including pga size from v$process
--Outer join will show if any defunct processes exist without associated session.
set linesize 120
set pagesize 120
column spid heading 'OSpid' format a8
column pid heading 'Orapid' format 999999
column sid heading 'Sess id' format 99999
column serial# heading 'Serial#' format 999999
column status heading 'Status' format a8
column pga_alloc_mem heading 'PGA alloc' format 99,999,999,999
column pga_used_mem heading 'PGA used' format 99,999,999,999
column username heading 'oracleuser' format a12
column osuser heading 'OS user' format a12
column program heading 'Program' format a20

SELECT
p.spid,
p.pid,
s.sid,
s.serial#,
s.status,
p.pga_alloc_mem,
p.PGA_USED_MEM,
s.username,
s.osuser,
s.program
FROM
v$process p,
v$session s
WHERE s.paddr ( + ) = p.addr
and p.BACKGROUND is null /* Comment out this line if need to monitor background processes */
Order by p.pga_alloc_mem desc;


PROMPT
PROMPT SUM of PGA and SGA FROM V$SESSTAT,V$SGA
PROMPT ------------------------- 

--Summation of pga and sga gives a value of total memory usage by oracle instance
--look at total memory used by instance SGA and PGA

select sum(bytes)/1024/1024 as "Total PGA+SGA Mbytes" from
        (select value as bytes from v$sga
        union all
        select value as bytes from
        v$sesstat s,
        v$statname n
        where
        n.STATISTIC# = s.STATISTIC# and
        n.name = 'session pga memory'
        );



clear breaks


