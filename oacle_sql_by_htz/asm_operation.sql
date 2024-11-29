set lines 200
set pages 40
col name for a20
col operation for a10
col state for a10
select a.name,b.OPERATION,b.STATE,b.power,b.ACTUAL,b.sofar,b.est_work,b.est_rate,b.est_minutes from v$asm_operation b,v$asm_diskgroup a where a.group_number=b.group_number;
