 set echo off
 set lines 200 pages 2000 verify off heading on
 SELECT kglnaown AS owner, kglnaobj as Object
     FROM sys.x$kglob
     WHERE kglhdadr='&P1RAW'
    /

