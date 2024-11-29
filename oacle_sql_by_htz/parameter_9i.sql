set echo off
set verify off
set lines 170
set pages 30
set feedback off
col inst_id for 99 heading 'Inst|Id'
col name for a20
col type for a15
col DISPLAY_VALUE for a20 heading 'Display|Value'
col isdefault for a10 heading 'Is|Default'
col isses_modifiable for a10 heading 'Session|Modify'
col issys_modifiable for a10 heading 'System|Modify'
col isinstance_modifiable for a10 heading 'Instance|Modify'
col a_desc for a50 heading 'Description'
break on inst_id
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display one parameter value                                            |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

ACCEPT parameter prompt 'Enter Search Parameter Value (i.e. session) : '


SELECT inst_id,
       name,
       DECODE (TYPE,
               1, 'Boolean',
               2, 'String',
               3, 'Integer',
               4, 'Parameter file',
               5, 'Reserved',
               6, 'Big integer')
          TYPE,
--       DISPLAY_VALUE,
       isdefault,
       isses_modifiable,
       issys_modifiable,
--       isinstance_modifiable,
       SUBSTR (description, 1, 50) a_desc
  FROM sys.gv$parameter
 WHERE UPPER (name) LIKE UPPER ('%&parameter%')
/ 
clear    breaks  
set verify on
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on
