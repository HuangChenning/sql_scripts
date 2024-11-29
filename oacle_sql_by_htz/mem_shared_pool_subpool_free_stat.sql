set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 200
col sga_heap for a20
break on SubPool on sga_heap on chunkcomment
  SELECT ksmchidx "SubPool",
         'sga heap(' || ksmchidx || ',0)' sga_heap,
         ksmchcom chunkcomment,
         DECODE (ROUND (ksmchsiz / 1000),
                 0, '0-1K',
                 1, '1-2K',
                 2, '2-3K',
                 3, '3-4K',
                 4, '4-5K',
                 5, '5-6k',
                 6, '6-7k',
                 7, '7-8k',
                 8, '8-9k',
                 9, '9-10k',
                 '> 10K')
            "size",
         COUNT (*),
         ksmchcls status,
         ROUND (SUM (ksmchsiz) / COUNT (*), 2) AVG_BYTES,
         SUM (ksmchsiz) BYTES,
         ROUND (SUM (ksmchsiz) / 1024, 2) KB
    FROM x$ksmsp
   WHERE ksmchcom = 'free memory' and inst_id=userenv('Instance')
GROUP BY ksmchidx,
         ksmchcls,
         'sga heap(' || ksmchidx || ',0)',
         ksmchcom,
         ksmchcls,
         DECODE (ROUND (ksmchsiz / 1000),
                 0, '0-1K',
                 1, '1-2K',
                 2, '2-3K',
                 3, '3-4K',
                 4, '4-5K',
                 5, '5-6k',
                 6, '6-7k',
                 7, '7-8k',
                 8, '8-9k',
                 9, '9-10k',
                 '> 10K')
ORDER BY 1, 4;
