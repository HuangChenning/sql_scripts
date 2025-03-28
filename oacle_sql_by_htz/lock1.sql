set linesize 200 feedback off heading on 
column sid format 999 
column res heading 'Resource Type' format a20 
column id1 format 9999999 
column id2 format 9999999 
column lmode heading 'Lock Held' format a14 
column request heading 'Lock Req.' format a14 
column serial# format 99999 
column username  format a10  
column terminal heading Term format a6 
column tab format a10 
column owner format a8 
SELECT  l.sid,s.serial#,s.username,s.terminal, 
        decode(l.type,'RW','RW - Row Wait Enqueue', 
                    'TM','TM - DML Enqueue', 
                    'TX','TX - Trans Enqueue', 
                    'UL','UL - User',l.type||'System') res, 
        substr(t.name,1,10) tab,u.name owner, 
        l.id1,l.id2, 
        decode(l.lmode,1,'No Lock', 
                2,'Row Share', 
                3,'Row Exclusive', 
                4,'Share', 
                5,'Shr Row Excl', 
                6,'Exclusive',null) lmode, 
        decode(l.request,1,'No Lock', 
                2,'Row Share', 
                3,'Row Excl', 
                4,'Share', 
                5,'Shr Row Excl', 
                6,'Exclusive',null) request 
FROM v$lock l, v$session s, 
sys.user$ u,sys.obj$ t 
WHERE l.sid = s.sid 
AND s.type != 'BACKGROUND' 
AND t.obj# = l.id1 
AND u.user# = t.owner# 
/ 

