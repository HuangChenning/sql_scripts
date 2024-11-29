--select spid from v$process where addr in (select paddr from v$session where sid in (select sid from v$mystat));

select spid from v$process where addr in (select paddr from v$session where sid=userenv('sid'))
/