Rem
Rem Copyright (c) 2008,2013 Oracle. All rights reserved.  
Rem
Rem    NAME
Rem     countTSTZdata.sql - Gives count of TimeStamp with TimeZone columns
Rem		Version 1.0
Rem
Rem    NOTES
Rem      * This script must be run using SQL*PLUS.
Rem      * This script must be connected AS SYSDBA to run.
Rem      * This script is mainly usefull for 11.2 and up .
Rem      * The database will NOT be restarted .
Rem      * NO downtime is needed for this script.
Rem
Rem    DESCRIPTION
Rem      Script to approximate how much TimeStamp with TimeZone data there is 
Rem      in an database.
Rem		 Useful when using DBMS_DST or the upg_tzv_check.sql 
Rem 	 and upg_tzv_apply.sql scripts 
Rem 
Rem    MODIFIED   (MM/DD/YY)
Rem    gvermeir   05/13/13 - Initial release.
Rem
set FEEDBACK off
set SERVEROUTPUT on
-- Get time
-- VARIABLE V_SEC number
-- EXEC :V_SEC := DBMS_UTILITY.GET_TIME

-- Alter session to avoid performance issues
alter session set nls_sort='BINARY';

-- Set client_info so one can use: 
-- select .... from V$SESSION where CLIENT_INFO = 'counttstzdata';
EXEC DBMS_APPLICATION_INFO.SET_CLIENT_INFO('counttstzdata');
whenever SQLERROR EXIT

-- Check if user is sys
declare
	V_CHECKVAR1				varchar2(10 char);
begin
		execute immediate
		'select substr(SYS_CONTEXT(''USERENV'',''CURRENT_USER''),1,10) from dual' into V_CHECKVAR1 ;
		if V_CHECKVAR1 = 'SYS' then
				null;
			else
				DBMS_OUTPUT.PUT_LINE('ERROR: Current connection is not a sysdba connection!');
				RAISE_APPLICATION_ERROR(-20001,'Stopping script - see previous message .....');
		end if;
end;
/

whenever SQLERROR CONTINUE

EXEC DBMS_OUTPUT.PUT_LINE( ' Estimating amount of TSTZ data. ' );
EXEC DBMS_OUTPUT.PUT_LINE( ' This might take some time.... ' );
EXEC DBMS_OUTPUT.PUT_LINE( ' . ' );
EXEC DBMS_OUTPUT.PUT_LINE( ' For SYS tables first... ' );
EXEC DBMS_OUTPUT.PUT_LINE( ' Note: empty tables are not listed.' );
EXEC DBMS_OUTPUT.PUT_LINE( ' Owner.Tablename.Columnname - count star of that column ' );
declare
	V_COUNTSTAR				number;
	V_TOTALCOUNT			number;
	V_TOTALCOLS				number;
	V_STMT					varchar2(200 char);
begin
	V_TOTALCOUNT := TO_NUMBER('0');
	V_TOTALCOLS	 := TO_NUMBER('0');
	for REC in ( select C.OWNER, C.TABLE_NAME , C.COLUMN_NAME
			from DBA_TAB_COLS C, DBA_OBJECTS O
			where C.OWNER=O.OWNER
			and C.TABLE_NAME = O.OBJECT_NAME
			and C.OWNER = 'SYS'
			and C.DATA_TYPE like '%WITH TIME ZONE'
			and O.OBJECT_TYPE = 'TABLE'
			order by C.TABLE_NAME, C.COLUMN_NAME)
		LOOP
			V_STMT := 'select count(*) from "' || REC.OWNER || '"."' || REC.TABLE_NAME || '"' ;
			execute immediate V_STMT into V_COUNTSTAR;
			IF V_COUNTSTAR > 0 THEN
				DBMS_OUTPUT.PUT_LINE(REC.OWNER ||'.'|| REC.TABLE_NAME || '.'|| REC.COLUMN_NAME ||' - Count * is : ' || V_COUNTSTAR );
			END IF;
			V_TOTALCOUNT := V_TOTALCOUNT + V_COUNTSTAR ;
			V_TOTALCOLS  := V_TOTALCOLS + 1;
		end LOOP;
	DBMS_OUTPUT.PUT_LINE( ' Total count * of SYS TSTZ columns ROWS is : ' || TO_CHAR(V_TOTALCOUNT) );
	DBMS_OUTPUT.PUT_LINE( ' There are in total '|| TO_CHAR(V_TOTALCOLS)||' SYS TSTZ columns.'  );
	end;
/
EXEC DBMS_OUTPUT.PUT_LINE( ' . ' );
EXEC DBMS_OUTPUT.PUT_LINE( ' For non-SYS tables ... ' );
EXEC DBMS_OUTPUT.PUT_LINE( ' Note: empty tables are not listed.' );
EXEC DBMS_OUTPUT.PUT_LINE( ' Owner.Tablename.Columnname - count star of that column ' );
declare
	V_COUNTSTAR				number;
	V_TOTALCOUNT			number;
	V_TOTALCOLS				number;
	V_STMT					varchar2(200 char);
begin	
	V_TOTALCOUNT := TO_NUMBER('0');
	V_TOTALCOLS	 := TO_NUMBER('0');
	for REC in ( select C.OWNER, C.TABLE_NAME , C.COLUMN_NAME
			from DBA_TAB_COLS C, DBA_OBJECTS O
			where C.OWNER=O.OWNER
			and C.TABLE_NAME = O.OBJECT_NAME 
			and C.DATA_TYPE like '%WITH TIME ZONE'				
			and O.OBJECT_TYPE = 'TABLE'
		    and C.OWNER != 'SYS'
			order by C.OWNER, C.TABLE_NAME, C.COLUMN_NAME)
		LOOP
			V_STMT := 'select count(*) from "' || REC.OWNER || '"."' || REC.TABLE_NAME || '"' ;
			execute immediate V_STMT into V_COUNTSTAR;
			IF V_COUNTSTAR > 0 THEN
				DBMS_OUTPUT.PUT_LINE(REC.OWNER ||'.'|| REC.TABLE_NAME || '.'|| REC.COLUMN_NAME ||' - Count * is : ' || V_COUNTSTAR );
			END IF;		
			V_TOTALCOUNT := V_TOTALCOUNT + V_COUNTSTAR ;
			V_TOTALCOLS  := V_TOTALCOLS + 1;
		end LOOP;
	DBMS_OUTPUT.PUT_LINE( ' Total count * of non-SYS TSTZ columns ROWS is :  ' || TO_CHAR(V_TOTALCOUNT) );
	DBMS_OUTPUT.PUT_LINE( ' There are in total '|| TO_CHAR(V_TOTALCOLS)||' non-SYS TSTZ columns.'  );
end;
/
-- Print time it took
-- EXEC :V_SEC := (DBMS_UTILITY.GET_TIME - :V_SEC)/100
-- EXEC DBMS_OUTPUT.PUT_LINE(' Total Seconds elapsed : '||:V_SEC)
set FEEDBACK on
-- End of countTSTZdata.sql
