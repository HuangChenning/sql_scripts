set echo off
set lines 200 pages 100 heading on verify off
col name  for a60
col value for 9999999999999
col unit  for a10
select name,value,unit from v$pgastat order by name
;


