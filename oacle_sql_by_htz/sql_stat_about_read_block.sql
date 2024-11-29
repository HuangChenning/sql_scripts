 set lines 200
set pages 2000
set autotrace traceonly;
select count(*) from scott.test1;
set autotrace off;

SELECT b.name, a.VALUE
  FROM v$sesstat a,
       (SELECT statistic#, name
          FROM v$statname
         WHERE name IN
                  ('consistent changes',
                   'consistent gets',
                   'consistent gets direct',
                   'consistent gets from cache',
                   'db block changes',
                   'db block gets',
                   'db block gets direct',
                   'db block gets from cache',
                   'physical reads',
                   'physical reads cache',
                   'physical reads direct',
                   'physical reads direct temporary tablespace',
                   'session logical reads')) b,(select sid from v$mystat where rownum=1) c
 WHERE     a.statistic# = b.statistic#
       AND a.sid=c.sid
/
