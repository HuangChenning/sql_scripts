set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
col sql_id for a15
col child_number for 999 heading 'Child|Num'
col last_load_time for a20
col disk_reads for 9999999999
col buffer_gets for 9999999999
col is_obsolete for a5 heading 'IS|Obsolete'
col is_bind_sensitive for a10 heading 'Is|Bind|Sens'
col is_shareable for a10 heading 'Is|Share|Able'
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display info about child cursor of sqlid                               |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT sqlid prompt 'Enter Search Sql id (i.e. DEPT) : '
ACCEPT childnumber prompt 'Enter Search Child  Number (i.e. 123|0(ALL)) : '
ACCEPT isobsolete prompt 'Enter Search Child  Number Is Obsolete(i.e. Y|N|ALL) : '
ACCEPT isshareable prompt 'Enter Search Child  Number Is Shareable(i.e. Y|N|ALL) : '
 SELECT sql_id,
         address,
         child_number,
         child_address,
         last_load_time,
         executions,
         loads,
         disk_reads,
         buffer_gets,
         is_obsolete,
         is_bind_sensitive,
         is_bind_aware,
         is_shareable
    FROM v$sql
   WHERE sql_id = '&sqlid'
   and child_number=decode(&childnumber,0,child_number,&childnumber)
   and is_obsolete=decode('&isobsolete','N','N','Y','Y',is_obsolete)
   and is_shareable=decode('&isshareable','N','N','Y','Y',is_shareable)
ORDER BY last_load_time DESC

/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on


