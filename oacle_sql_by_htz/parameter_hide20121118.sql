set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 200
col name for a30
col value for a20
col describ for a50

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display hide parameter value                                       |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

ACCEPT par prompt 'Enter Search Parameter (i.e. max) : '


SELECT i.ksppinm NAME, v.ksppstvl VALUE, i.ksppdesc describ
from sys.x$ksppi i, sys.x$ksppcv v
WHERE i.indx = v.indx
   AND i.ksppinm LIKE '%&par%';
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on
