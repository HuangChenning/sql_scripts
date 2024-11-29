/**********************************************************************
 * File:	trclvl12.sql
 * Type:	SQL*Plus script
 * Author:	Tim Gorman (Evergreen Database Technologies, Inc.)
 * Date:	14-Jun-95
 *
 * Description:
 *	SQL*Plus script to use the TRCLVL12 stored procedure.
 *
 * Modifications:
 *********************************************************************/
set verify off serveroutput on size 1000000

col sid format a9 heading "SID and|SERIAL#"
col username format a8 heading "Oracle|USERNAME" truncate
col osuser format a8 heading "Unix|USERNAME" truncate
col status format a8 heading "Status" truncate
col program format a30 heading "Client-side|Program" truncate
col machine format a10 heading "Client-side|Hostname" truncate

prompt
prompt Enable SQL Tracing at level 12 for another Oracle session.  "Level 12"
prompt is SQL trace with (default) performance statistics, WAIT events, and
prompt BIND variable values.  The latter two types of information do not affect
prompt TKPROF report output, and can be viewed only in the raw ".trc" file...
prompt
accept V_NAME prompt "Enter the Oracle or Unix username running the session: "
prompt

select	sid || ',' || serial# sid,
	username,
	osuser,
	status,
	program,
	machine
from	v$session
where	(username like '%' || upper('&&V_NAME') || '%'
   or	 osuser like '%' || lower('&&V_NAME') || '%')
and	type = 'USER'
and	audsid <> userenv('SESSIONID')
/

prompt
prompt Enter the "SID,SERIAL#" pair for the session you want to trace.  For
prompt example, enter:         ===>  NNN,MMM
prompt where NNN is the SID and MMM is the SERIAL# displayed from the query
prompt above.  Don't forget the "comma"...
accept V_SID prompt "===> "
prompt

exec trclvl12(&&V_SID)

set verify on serveroutput off
prompt
