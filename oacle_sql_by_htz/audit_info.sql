/* Formatted on 2015/2/4 16:33:09 (QP5 v5.240.12305.39446) */
SET ECHO OFF
REM NAME:   TFSAUDIT.SQL
REM USAGE:"@path/tfsaudit"
REM --------------------------------------------------------------------------
REM REQUIREMENTS:
REM    SELECT ON DBA_OBJ_AUDIT_OPTS, DBA_STMT_AUDIT_OPTS, DBA_AUDIT_TRAIL
REM    and DBA_PRIV_AUDIT_OPTS
REM --------------------------------------------------------------------------
REM AUTHOR:
REM    Geert De Paep    -    Oracle Belgium
REM --------------------------------------------------------------------------
REM PURPOSE:
REM    see what is being audited in the database, and to see the audit_trail
REM -------------------------------------------------------------------------
REM DISCLAIMER:
REM    This script is provided for educational purposes only. It is NOT
REM    supported by Oracle World Wide Technical Support.
REM    The script has been tested and appears to work as intended.
REM    You should always run new scripts on a test instance initially.
REM --------------------------------------------------------------------------
REM Main text of script follows:

COL user_name FOR a12 HEADING "User name"
COL proxy_name FOR a12 HEADING "Proxy name"
COL privilege FOR a30 HEADING "Privilege"
COL user_name FOR a12 HEADING "User name"
COL audit_option FORMAT a30 HEADING "Audit Option"
COL timest FORMAT a13
COL userid FORMAT a8 TRUNC
COL obn FORMAT a10 TRUNC
COL name FORMAT a13 TRUNC
COL sessionid FORMAT 99999
COL entryid FORMAT 999
COL owner FORMAT a10
COL object_name FORMAT a10
COL object_type FORMAT a6
COL priv_used FORMAT a15 TRUNC
BREAK ON user_name
SET PAGES 1000
set lines 200

SET PAUSE 'Return...'

PAUSE Press return to see the audit related parameters...

COL name FOR a20
COL display_value FOR a40

  SELECT NAME, DISPLAY_VALUE
    FROM V$PARAMETER
   WHERE UPPER (NAME) LIKE UPPER ('%audit%')
ORDER BY NAME, ROWNUM
/



PROMPT
PROMPT System auditing options across the system and by user

  SELECT *
    FROM sys.dba_stmt_audit_opts
ORDER BY user_name, proxy_name, audit_option
/

PAUSE Press return to see auditing options on all objects...

SELECT owner,
       object_name,
       object_type,
       alt,
       aud,
       com,
       del,
       gra,
       ind,
       ins,
       loc,
       ren,
       sel,
       upd,
       REF,
       exe
  FROM sys.dba_obj_audit_opts
 WHERE    alt != '-/-'
       OR aud != '-/-'
       OR com != '-/-'
       OR del != '-/-'
       OR gra != '-/-'
       OR ind != '-/-'
       OR ins != '-/-'
       OR loc != '-/-'
       OR ren != '-/-'
       OR sel != '-/-'
       OR upd != '-/-'
       OR REF != '-/-'
       OR exe != '-/-'
/

PAUSE Press return to see audit trail... Note that the query returns the audit data for the last day only

COL acname FORMAT a12 HEADING "Action name"

  SELECT username userid,
         TO_CHAR (timestamp, 'dd-mon hh24:mi') timest,
         action_name acname,
         priv_used,
         obj_name obn,
         ses_actions
    FROM sys.dba_audit_trail
   WHERE timestamp > SYSDATE - 1
ORDER BY timestamp
/

PAUSE Press return to see system privileges audited across the system and by user...

  SELECT *
    FROM dba_priv_audit_opts
ORDER BY user_name, proxy_name, privilege
/