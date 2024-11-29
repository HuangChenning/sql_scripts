-- Begin of script
-- NLS check script v 3.2 02-JUL-2013 GVERMEIR.BE
-- Note 226692.1 Finding out your NLS Setup
SET SPACE 0 NEWPAGE 0 PAGES 1000 LINESIZE 80 LONG 1000
SET ECHO ON TERMOUT ON FEEDBACK ON HEADING ON TRIMSPOOL OFF VERIFY OFF
--
-- PLEASE PROVIDE THE SPOOL FILE AND NOT A COPY PASTE OF THE OUTPUT
--
 
-- Unix spool location
--
SPOOL /tmp/NLSunix.txt
--
-- if this needs to be changed please do a search and replace in the WHOLE
-- script for '/tmp/NLSunix.txt'.
--
-- note: any "SP2-0310: unable to open file" error in this script is NORMAL 
-- and intended
-- 
-- Getting NLS overview
--
-- standard NLS views, see Note 241047.1 for meaning.
-- NLS_TIME_FORMAT, NLS_TIME_TZ_FORMAT are internal use only
-- and should NOT be changed from the default values
-- which are 'HH.MI.SSXFF AM' and 'HH.MI.SSXFF AM TZR'
-- session parameters should correspond to client settings
-- or as set by a logon trigger who can be found 
-- at the end of the script
--
-- shows the current session parameters
select * from NLS_SESSION_PARAMETERS order by parameter
/
-- shows the current instance parameters
select * from NLS_INSTANCE_PARAMETERS order by parameter
/
-- shows the current database parameters
select * from NLS_DATABASE_PARAMETERS order by parameter
/
-- Check if NLS_DATABASE_PARAMETERS is the same as found in PROPS$
select NAME, VALUE$ from SYS.PROPS$ order by name
/
-- shows the current session parameters and 
-- the *DATABASE* characterset as seen in the NLS_DATABASE_PARAMETERS view.
select * from V$NLS_PARAMETERS order by parameter
/
-- displays the values of initialization parameters 
-- in effect for the current session.(!!!) from 11.2.0.2 onwards
select name, value from v$parameter order by name
/
--
-- Getting all current instance settings (INIT.ORA)
--
-- Relevant parameters for sysdate not correct when using listener issues
-- see Note 227334.1
-- Checking if RAC is used -> CLUSTER_DATABASE
-- see if PMON registers at the listener -> LOCAL_LISTENER
-- checking if MTS is used -> DISPATCHERS
-- using locale listener -> LOCAL_LISTENER
-- using remote listener -> REMOTE_LISTENER
--
select name, value from v$system_parameter order by name
/
--
-- sqlplus/client/server versions and db name
--
select NAME from V$DATABASE
/
select &_SQLPLUS_RELEASE Sqlplus_release, 
&_O_RELEASE Oracle_release from DUAL
/
select * from V$VERSION
/
-- 
-- Some character checks
--
-- Check for 2 characters: LATIN CAPITAL LETTER A WITH CIRCUMFLEX and EURO SIGN
-- if the dump command gives not the correct value then the
-- database side does not support those
-- ex of charsets who support the characters: 
-- UTF8: c3,82,e2,82,ac / WE8MSWIN1252: c2,80
-- if you see 'bf' or '3f' it means the db does not support the
-- character
-- this select can be used to debug Unix clients -  Note:264157.1
select dump(to_char(UNISTR('\00C2\20AC')),1016),
UNISTR('\00C2\20AC') from dual
/
--
-- check for invalid charset declarations
--
-- if this select returns more then 7 rows then see
-- Note 286964.1 PLS-553 when calling or compiling pl/sql objects
-- a few rows less can be normal in db's upgraded from v7 and is 
-- no reason for panic
-- It should be also matching the values found
-- in SYS.PROPS$ and NLS_DATABASE_PARAMETERS
select distinct(nls_charset_name(charsetid)) CHARACTERSET,
       decode(type#, 1, decode(charsetform, 1, 'VARCHAR2', 2, 'NVARCHAR2','UNKNOWN'),
                     9, decode(charsetform, 1, 'VARCHAR', 2, 'NCHAR VARYING', 'UNKNOWN'),
                    96, decode(charsetform, 1, 'CHAR', 2, 'NCHAR', 'UNKNOWN'),
                     8, decode(charsetform, 1, 'LONG', 'UNKNOWN'),
                   112, decode(charsetform, 1, 'CLOB', 2, 'NCLOB', 'UNKNOWN')) TYPES_USED_IN
   from sys.col$ where charsetform in (1,2) and type# in (1, 8, 9, 96, 112)
 order by CHARACTERSET, TYPES_USED_IN
/
--
-- check if user N-types are used
--
select distinct OWNER, TABLE_NAME from DBA_TAB_COLUMNS where DATA_TYPE in 
('NCHAR','NVARCHAR2', 'NCLOB') and OWNER not in ('SYS','XDB','SYSTEM','SYSMAN')
/
--
-- Next select should give zero in 10G - otherwise the database was created with CHAR
-- semantics set to CHAR -> may give problems with sys objects
-- see note 144808.1
-- not a problem in 11g and up
select count(*) from dba_tab_columns where CHAR_USED='C' 
and data_type not in ('NCHAR','NVARCHAR2') and owner=('SYS')
/
--
-- time and timezones related checks
--
-- Checking the DST version, only works in 10g and up
SELECT version FROM v$timezone_file
/
-- For 9i use the script in Note 412160.1 or use this count and compare
SELECT count(*), COUNT(DISTINCT(tzname)) FROM v$timezone_names
/
-- check if USER TimeStamp with Time Zone (TSTZ) data is used
-- this is to know if DST updates need acctual check scripts
-- Note 756474.1
--
select c.owner || '.' || c.table_name || '(' || c.column_name || ') -'
    || c.data_type || ' ' col
  from dba_tab_cols c, dba_objects o
 where c.data_type like '%WITH TIME ZONE'
    and c.owner=o.owner
   and c.table_name = o.object_name
   and o.object_type = 'TABLE'
   and o.owner not in ('SYS','WMSYS','DBSNMP')
order by col
/
--
-- DBTIMEZONE has no impact on any of above date/time selects
-- It's preferred value should be +00:00 or UTC.
-- see Note 340512.1
select DBTIMEZONE from DUAL
/
-- check if this is the same as found in SYS.PROPS$
select value$ from SYS.PROPS$ where name ='DBTIMEZONE'
/
-- check if TimeStamp with Local Time Zone (TSLTZ) data is used
-- this is to know if DBTIMEZONE is actually used/relevant
-- by default the database has NO TSLTZ data
-- Note 756454.1
--
select c.owner || '.' || c.table_name || '(' || c.column_name || ') -'
    || c.data_type || ' ' col
  from dba_tab_cols c, dba_objects o
 where c.data_type like '%LOCAL TIME ZONE'
    and c.owner=o.owner
   and c.table_name = o.object_name
   and o.object_type = 'TABLE'
order by col
/
-- setting session to display session time and timezones
ALTER SESSION SET 
NLS_DATE_FORMAT ='DD/MM/YYYY HH24:MI:SS'
NLS_TIMESTAMP_FORMAT ='DD/MM/YYYY HH24:MI:SS.FF9' 
NLS_TIMESTAMP_TZ_FORMAT ='DD/MM/YYYY HH24:MI:SS.FF9 TZR TZD' 
/
-- SYSDATE is NOT affected by Oracle DST patches, see Note 227334.1
select SYSDATE from DUAL
/
-- see Note 340512.1 for more info on below selects
select SESSIONTIMEZONE, LOCALTIMESTAMP, 
SYSTIMESTAMP, CURRENT_TIMESTAMP from DUAL
/
-- for 10g and up: check if the 9i behavior" file set is used
-- see Note 292942.1 NLS_Language and NLS_Territory definitions 
-- changed in 10g and up versus 9i and lower
-- if the output is "18-AVR. -2009" then 10g behavior is used
-- if the output is "18-AVR-2009" then 9 behavior is used or the db is 9i or lower
select to_char(to_date( '18/04/2009', 'DD/MM/YYYY'),'DD-MON-YYYY',
'NLS_DATE_LANGUAGE=FRENCH') from dual
/
--
-- OS related TZ information
--
-- Get Operating system (!) TZ set when instance was started 
-- 10g and up only, will give error in 9i
select dbms_scheduler.GET_SYS_TIME_ZONE_NAME from DUAL
/
-- Get Operating system (!) TZ for session, only useful if client is unix
var hv varchar2(100)
exec dbms_system.get_env('TZ', :hv);
print hv
-- Getting TZ seen by sqlplus
@[$TZ]
--
-- Known NLS settings defintions check
--
select unique count(*) from V$NLS_VALID_VALUES where PARAMETER ='CHARACTERSET'
/
select unique count(*) from V$NLS_VALID_VALUES where PARAMETER ='LANGUAGE'
/
select unique count(*) from V$NLS_VALID_VALUES where PARAMETER ='SORT'
/
select unique count(*) from V$NLS_VALID_VALUES where PARAMETER ='TERRITORY'
/
--
-- logon environment checks
select OSUSER, PROCESS, MACHINE, TERMINAL, PROGRAM, MODULE, MODULE_HASH, 
CLIENT_INFO, SCHEMANAME from V$SESSION where SCHEMANAME = user and 
OSUSER != 'SYSTEM'
/
-- Logon trigger check
-- to see if NLS parameters are set using note 251044.1
select OWNER, TRIGGER_NAME, TRIGGER_BODY from DBA_TRIGGERS where 
 trim(TRIGGERING_EVENT) = 'LOGON'
/
select OWNER, TRIGGER_NAME, TRIGGER_BODY from DBA_TRIGGERS where 
 upper(TRIGGER_NAME) = 'LOGON_PROC'
/
-- checks of variables known to executable
-- Unix checks 
@[$ORACLE_SID]
@[$ORACLE_HOME]
-- Getting the NLS_LANG variable as seen by the executable
-- For the correct NLS_LANG setting see Note 264157.1
@[$NLS_LANG]
-- if set they should match NLS_SESSION_SETTINGS 
-- otherwise the derived default of NLS_LANG is seen -> note 241047.1
@[$NLS_LANGUAGE]
@[$NLS_SORT]
@[$NLS_DATE_FORMAT]
@[$NLS_TERRITORY]
@[$NLS_DATE_FORMAT]
@[$NLS_TIMESTAMP_FORMAT]
@[$NLS_TIMESTAMP_TZ_FORMAT]
@[$NLS_NUMERIC_CHARACTERS]
-- not seen in NLS_SESSION_SETTINGS 
@[$NLS_COMP]
@[$ORA_SDTZ]
@[$ORA_TZFILE]
-- for ORA_NLS see Note 77442.1
@[$ORA_NLS]
@[$ORA_NLS32]
@[$ORA_NLS33]
@[$ORA_NLS10]
@[$ClassPath]
@[$PATH]
@[$LD_LIBRARY_PATH]
@[$SHLIB_PATH]
spool off
--
-- host environment checks for Unix
HOST echo 'NLS_LANG setting:' >> /tmp/NLSunix.txt 
HOST echo $NLS_LANG >> /tmp/NLSunix.txt
HOST echo 'locale settings:' >> /tmp/NLSunix.txt   
HOST locale >> /tmp/NLSunix.txt
HOST echo 'Environment LANG, LC, TZ, NLS and ORA settings:' >> /tmp/NLSunix.txt   
HOST env | egrep 'LANG|LC_|TZ|NLS|ORA|PATH' >> /tmp/NLSunix.txt
--
-- PLEASE PROVIDE THE SPOOL FILE /tmp/NLSunix.txt
-- AND NOT A COPY PASTE OF THE OUTPUT
--
---- end of script
