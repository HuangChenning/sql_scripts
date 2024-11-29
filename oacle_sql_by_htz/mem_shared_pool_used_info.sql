set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 200
col subpool for a30
  SELECT    'shared pool ('
         || NVL (DECODE (TO_CHAR (ksmdsidx), '0', '0 - Unused', ksmdsidx),
                 'Total')
         || '):'
            subpool,
         ksmssnam,
         ksmsslen,
         ROUND (ksmsslen / 1024 / 1024, 2) MB
    FROM x$ksmss
   WHERE ksmsslen <> 0
ORDER BY ksmdsidx, ksmsslen;
