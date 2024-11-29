set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
COL OWNER FOR A15 HEADING 'INDEX_OWNER'
COL object_name  for a15 heading 'INDEX_NAME'
col table_name for a15



PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | DISPLAY RECENT CREATE INDEX INFORMATION                            |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT owner prompt 'Enter Search Table Owner(i.e. SCOTT) : '
ACCEPT table prompt 'Enter Search Table Name(i.e. DEPT|ALL) : '
ACCEPT day prompt 'Enter Search Day Create Time(i.e. 2) : '


  SELECT a.owner,
         SUBSTR (a.object_name, 1, 30) object_name,
         b.table_name,
         a.object_type,
         to_char(a.created,'YYYY-MM-DD HH24:MI:SS') CREATE_TIME
    FROM dba_objects a, dba_tables b
   WHERE     object_type IN ('INDEX', 'INDEX PARTITION')
         AND a.owner = b.owner
         AND a.created > (SYSDATE - &day)
         AND a.owner = UPPER ('&owner')
         AND b.table_name =
                DECODE (UPPER ('&table'),
                        'ALL', b.table_name,
                        UPPER ('&table'))
ORDER BY created
/
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

