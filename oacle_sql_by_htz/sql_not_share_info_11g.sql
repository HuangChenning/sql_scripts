set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000

col sql_id for a15
col child_number for 999 heading 'Child|Num'
col is_obsolete for a5 heading 'IS|Obsolete'
col is_bind_sensitive for a6 heading 'Is|Bind|Sens'
col is_shareable for a6 heading 'Is|Share|Able'
col is_bind_aware for a6 heading 'Is|Bind|Aware'
col address for a19 heading 'Parent|Address'
col name for a25 heading 'Variable|Name'
col position for 99 heading 'Posi|Tion'
col datatype for 999 heading 'Data|Type'
col datatype_string for a15 heading 'Datatype|String'
break on position  skip 1 on datatype
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display one sqlid info about not share columns  and datatype           |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

ACCEPT sqlid prompt 'Enter Search Sql id (i.e. DEPT) : '
ACCEPT isobsolete prompt 'Enter Search Child  Cursor Is Obsolete(i.e. N|Y|ALL) : '
ACCEPT isshareable prompt 'Enter Search Child  Cursor Is Shareable(i.e. Y|N|ALL) : '

 SELECT a.address,
         a.hash_value,
         a.sql_id,
         a.child_number,
         b.is_obsolete,
         b.is_shareable,
         b.is_bind_aware,
         b.is_bind_sensitive,
         a.name,
         a.position,
         a.datatype,
         a.datatype_string
    FROM sys.V_$SQL_BIND_CAPTURE a, sys.v_$sql b
   WHERE     b.is_obsolete =
                DECODE (upper('&isobsolete'),  'N', 'N',  'Y', 'Y',  b.is_obsolete)
         AND b.is_shareable =
                DECODE (upper('&isshareable'),  'N', 'N',  'Y', 'Y',  b.is_shareable)
         AND a.sql_id = b.sql_id
         AND a.child_number = b.child_number
         AND a.child_address = b.child_address
         AND a.sql_id = '&sqlid'
ORDER BY position,child_number
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on
