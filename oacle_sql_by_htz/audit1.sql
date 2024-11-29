set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000


PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display database audit information                                     |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display  audit is on/off                                     |
PROMPT +------------------------------------------------------------------------+
PROMPT
col name for a20
col value for a20
select name,value from v$parameter where name='audit_trail'
/

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | describes auditing options on all objects owned by the current user.  |
PROMPT *************************************************************************
PROMPT | dash (-) indicates that the audit option is not set.                  |
PROMPT | The S character indicates that the audit option is set, BY SESSION.   |
PROMPT | The A character indicates that the audit option is set, BY ACCESS.    |
PROMPT | Each audit option has two possible settings, WHENEVER SUCCESSFUL and \|
PROMPT | WHENEVER NOT SUCCESSFUL, separated by a slash (/).                    |
PROMPT +------------------------------------------------------------------------+
PROMPT
col owner for a25
col object_name for a25
col object_type for a20
col alt for a5 heading 'alter'
col aud for a5 heading 'audit'
col com for a7 heading 'comment'
col del for a6 heading 'delete'
col gra for a5 heading 'grant'
col ind for a5 heading 'index'
col loc for a4 heading 'lock'
col ren for a6 heading 'rename'
col sel for a6 heading 'select'
col upd for a6 heading 'update'
col ref for a9 heading 'reference'
col exe for a7 heading 'execute'
col cre for a6 heading 'create'
col rea for a4 heading 'read'
col wri for a5 heading 'write'
col fbk for a9 heading 'flashback'
select * from dba_obj_audit_opts order by owner
/

clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on

