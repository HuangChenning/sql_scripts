select 'kill -9 '|| spid from v$process where addr in (select paddr from v$session where username=upper('&username'));

