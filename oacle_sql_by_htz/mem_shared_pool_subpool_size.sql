set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 200
PROMPT
PROMPT
PROMPT 'FREE MEM EVERY SUBPOOL'
PROMPT
  SELECT subpool,
         NAME,
         SUM (BYTES),
         ROUND (SUM (BYTES) / 1048576, 2) mb
    FROM (SELECT    'shared pool ('
                 || DECODE (TO_CHAR (ksmdsidx), '0', '0 - Unused', ksmdsidx)
                 || '):'
                    subpool,
                 ksmssnam NAME,
                 ksmsslen BYTES
            FROM x$ksmss
           WHERE     ksmsslen > 0
                 AND inst_id = USERENV ('Instance')
                 AND LOWER (ksmssnam) LIKE LOWER ('%free memory%'))
GROUP BY subpool, NAME
ORDER BY subpool ASC, SUM (BYTES) DESC;
PROMPT
PROMPT
PROMPT 'TOTAL distribute MEM EVERY SUBPOOL'
  SELECT    'shared pool ('
         || NVL (DECODE (TO_CHAR (ksmdsidx), '0', '0 - Unused', ksmdsidx),
                 'Total')
         || '):'
            subpool,
         'TOTAL',
         SUM (ksmsslen) BYTES,
         ROUND (SUM (ksmsslen) / 1048576, 2) mb
    FROM x$ksmss
   WHERE ksmsslen > 0 AND inst_id = USERENV ('Instance')
GROUP BY ROLLUP (ksmdsidx)
ORDER BY subpool ASC;
