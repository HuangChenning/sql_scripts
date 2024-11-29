/*
     This file is part of demos for "Mutex Internals" seminar v.22.04.2011
     Andrey S. Nikolaev (Andrey.Nikolaev@rdtex.ru) 
 
http://andreynikolaev.wordpress.com
 
     Top 10 heavily accessed library cache objects
 
     usage: @library_cache_objects_heavily_accessed.sql
*/
col name format a100
col cursor format a12 noprint
col type format a15
col LOCKED_TOTAL heading Locked format 99999
col PINNED_TOTAL heading Pinned format 99999999
col EXECUTIONS heading Executed format 99999999
col NAMESPACE heading Nsp format 999
set wrap on
set linesize 200
select * from (
   select case when (kglhdadr =  kglhdpar) then 'Parent' else 'Child '||kglobt09 end cursor,
             kglhdadr ADDRESS,kglnahsh hash_value,kglobtyd type,kglobt23 LOCKED_TOTAL,kglobt24 PINNED_TOTAL,kglhdexc EXECUTIONS,kglhdnsp NAMESPACE ,substr(kglnaobj,1,100) name
               from x$kglob  
               order by kglobt24 desc)
where rownum <= 10;