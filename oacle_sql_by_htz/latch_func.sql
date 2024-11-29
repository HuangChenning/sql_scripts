set echo off
set lines 30000 pages 5000 heading on verify off
col ksmfsadr for a20
col ksmfsnam for a30
col ksmfstyp for a10
col ksmfssiz for 9999999999
col kslldnam for a60
col kslldlvl for 999999
  SELECT k.ksmfsadr,
         ksmfsnam,
         ksmfstyp,
         ksmfssiz,
         kslldnam,
         kslldlvl
    FROM x$ksmfsv k, x$kslld a
   WHERE k.ksmfstyp LIKE '%ksllt%' AND k.ksmfsadr = a.kslldadr
ORDER BY ksmfsnam;