set echo off
set verify off
set serveroutput on
set feedback off
set pages 65535
set long 65535
col reason for a4000

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display reason of one sql not shared                                   |
PROMPT +------------------------------------------------------------------------+ 
PROMPT


ACCEPT outputname prompt 'Enter Search Output File name (i.e. /tmp/123.log) : '
ACCEPT sqlid prompt 'Enter Search Sql id (i.e. DEPT) : '
ACCEPT isobsolete prompt 'Enter Search Child  Cursor Is Obsolete(i.e. N|Y|ALL) : '
ACCEPT isshareable prompt 'Enter Search Child  Cursor Is Shareable(i.e. Y|N|ALL) : '
set termout off
spool &outputname

SELECT to_char(a.reason) as "reason"
  FROM sys.V_$sql_shared_cursor a, sys.v_$sql b
   WHERE     b.is_obsolete =
                DECODE (upper('&isobsolete'),  'N', 'N',  'Y', 'Y',  b.is_obsolete)
         AND b.is_shareable =
                DECODE (upper('&isshareable'),  'N', 'N',  'Y', 'Y',  b.is_shareable)
         AND a.sql_id = b.sql_id
         AND a.child_number = b.child_number
         AND a.child_address = b.child_address
         AND a.sql_id = '&sqlid'
/
spool off
clear    breaks  
set termout on
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
spool off
set echo on

