Rem
Rem $Header: utltzpv4.sql 15-feb-2008.21:15:00 gvermeir Exp $
Rem
Rem utltzuv4.sql
Rem
Rem Copyright (c) 2006, 2007, 2008 Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      utltzpv4.sql - time zone file upgrade to version 4 script for patchsets who include V4
Rem
Rem    NOTES
Rem      * This script needs to be run *before* upgrading to a new version time 
Rem        zone file ( $ORACLE_HOME/oracore/zoneinfo/ ).
Rem      * This script will *not* update any data.
Rem      * this script will drop and recreate sys.sys_tzuv2_temptab and 
Rem        sys.sys_tzuv2_affected_regions, 2 tables that are to be used exclusivly 
Rem        for DST upgrade checks.
Rem      * This script must be run using SQL*PLUS.
Rem      * You must be connected AS SYSDBA to run this script.
Rem
Rem    DESCRIPTION
Rem      The contents of the files timezone.dat and timezlrg.dat 
Rem      are usually updated to a new version to reflect the transition rule 
Rem      changes for some time zone region names. The transition rule 
Rem      changes of some time zones might affect the column data of
Rem      TIMESTAMP WITH TIME ZONE data type. For example, if users
Rem      enter TIMESTAMP '2003-02-17 09:00:00 America/Sao_Paulo', 
Rem      we convert the data to UTC based on the transition rules in the 
Rem      time zone file and store them on the disk. So '2003-02-17 11:00:00'
Rem      along with the time zone id for 'America/Sao_Paulo' is stored 
Rem      because the offset for this particular time is '-02:00' . Now the 
Rem      transition rules are modified and the offset for this particular 
Rem      time is changed to '-03:00'. when users retrieve the data, 
Rem      they will get '2003-02-17 08:00:00 America/Sao_Paulo'. There is
Rem      one hour difference compared to the original value.
Rem     
Rem      Refer to $ORACLE_HOME/oracore/zoneinfo/readme.txt for detailed 
Rem      information about time zone file updates.
Rem 
Rem      This script should be run before you update your database's
Rem      time zone file to the latest version. This is a pre-update script.
Rem
Rem      This script scans the database to find out all columns of
Rem      TIMESTAMP WITH TIME ZONE data type in regular tables. The script
Rem      also finds out how many rows might be affected by checking
Rem      whether the column data contain the values for the affected time 
Rem      zone names.
Rem      
Rem      The script drops and recreates 2 tables
Rem      sys.sys_tzuv2_affected_regions and sys.sys_tzuv2_temptab.
Rem
Rem      Before running the script, make sure the table name doesn't
Rem      conflict with any existing table object. If it does,
Rem      change the table name sys.sys_tzuv2_temptab to some other name
Rem      in the script. 
Rem 
Rem      You can query after running the script this table to view the result:
Rem         select * from sys.sys_tzuv2_temptab;   
Rem
Rem      If your database has column data that will be affected by the
Rem      time zone file update, dump the data before you upgrade to the
Rem      new version. After the upgrade, you need update the data
Rem      to make sure the data is stored based on the new rules.
Rem      
Rem
Rem      An example of backing up the data as varchar before applying the dst patch:
Rem      user scott has a table tztab:
Rem      create table tztab(x number primary key, y timestamp with time zone);
Rem      insert into tztab values(1, timestamp '');
Rem
Rem      Before upgrade, you can create a table tztab_back, note
Rem      column y here is defined as VARCHAR2 to preserve the original
Rem      value.
Rem      create table tztab_back(x number primary key, y varchar2(256));
Rem      insert into tztab_back select x, 
Rem                  to_char(y, 'YYYY-MM-DD HH24.MI.SSXFF TZR') from tztab;
Rem
Rem      After upgrade, you need update the data in the table tztab using
Rem      the value in tztab_back.
Rem      update tztab t set t.y = (select to_timestamp_tz(t1.y, 
Rem        'YYYY-MM-DD HH24.MI.SSXFF TZR') from tztab_back t1 where t.x=t1.x); 
Rem
Rem      More information is in Note:550739.1 Usage of utltzuv7.sql before updating time zone files
Rem
Rem      you may
Rem      drop table sys.sys_tzuv2_temptab;
Rem      drop table sys.sys_tzuv2_affected_regions;
Rem      once you are done with the time zone file upgrade.
Rem    
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    gvermeir   02/15/08 - made special version for patchsets who include V4
Rem    gvermeir   02/06/08 - changed cursor to handle tables with non-uppercase column names
Rem    gvermeir   02/04/08 - changed dstv7 detection routine for 92 to avoid bug 4616093
Rem    gvermeir   01/21/08 - added nested table check for 10g and up and minor cleanup
Rem    gvermeir   01/03/08 - changed to search for upgrade to v7 to find Argentina changes
Rem    gvermeir   12/06/07 - changed to search for upgrade to v7 to find AU/Brazil/Egypt/Venezulea changes
Rem    gvermeir   12/05/07 - removed incorrect suggestion to backup data trough exp/imp
Rem    gvermeir   12/01/07 - changed detection routine of current DST files version to more flexible one
Rem    gvermeir   07/25/07 - changed to search for upgrade to v6 to find NZ changes and made generic for 9i and up
Rem    huagli     06/25/07 - bug 6141905 timezone updates V5
Rem    huagli     06/25/07 - Creation
Rem

SET SERVEROUTPUT ON

Rem=========================================================================
Rem Recreate any existing table with this name sys.sys_tzuv2_temptab
Rem this table will hold any possible affected rows
Rem=========================================================================  
DROP TABLE sys.sys_tzuv2_temptab CASCADE CONSTRAINTS
/
CREATE TABLE sys.sys_tzuv2_temptab
(
 table_owner  VARCHAR2(30),
 table_name   VARCHAR2(30),
 column_name  VARCHAR2(30),
 rowcount     NUMBER,
 nested_tab   VARCHAR2(3)
)
/

Rem========================================================================
Rem Recreate any existing table with this name sys.sys_tzuv2_affected_regions
Rem this table will hold affected timezonenames
Rem========================================================================
DROP TABLE sys.sys_tzuv2_affected_regions CASCADE CONSTRAINTS
/
CREATE TABLE sys.sys_tzuv2_affected_regions
(
 time_zone_name VARCHAR2(60)
)
/

DECLARE

  dbv                  VARCHAR2(10);
  release              VARCHAR2(16);
  tznames_count        NUMBER;
  tznames_dist_count   NUMBER;
  dbtzv                VARCHAR2(5);
  numrows              NUMBER;
  TYPE cursor_t        IS REF CURSOR;
  cursor_tstz          cursor_t;
  tstz_owner           VARCHAR2(30);
  tstz_tname           VARCHAR2(30);
  tstz_qcname          VARCHAR2(4000);
                  
BEGIN

  --========================================================================
  -- Make sure that only Release 9i and up uses this script
  --========================================================================

  SELECT substr(version,1,6), version INTO dbv, release FROM v$instance;
        
  IF dbv in ('8.1.7.','8.1.6.','8.1.5.','8.0.6.','8.0.5.','8.0.4.')
  THEN
    DBMS_OUTPUT.PUT_LINE('TIMEZONE data type was not supported in Release ' || release);
    DBMS_OUTPUT.PUT_LINE('No need to validate TIMEZONE data.');
    RETURN;
  END IF;
        
  IF dbv not in ('9.0.1.','9.2.0.','10.1.0','10.2.0','11.1.0')
  THEN
    DBMS_OUTPUT.PUT_LINE('Please contact Oracle support to get ');
    DBMS_OUTPUT.PUT_LINE('the script for Release ' || release);
    DBMS_OUTPUT.PUT_LINE('Versions below 9.0.1 do not have TIMEZONE data and are not affected');
   RETURN;
  END IF;
        
  --======================================================================
  -- Check if the TIMEZONE data is consistent with the latest version.
  --======================================================================

 -- TZ version checks if db is 10g or higher

IF dbv in ('10.1.0','10.2.0','11.1.0')
 THEN
    EXECUTE IMMEDIATE 'SELECT version FROM v$timezone_file' INTO dbtzv;
END IF;
 
 -- TZ version checks if db is 9i
 -- In 9i there is no way to catch if the TZ files are newer then the latest DST patch version 
 -- at the time this script was made, wich is V7

 -- checking if V7 (or higher) is used

IF dbv in ('9.0.1.','9.2.0.')
  THEN
     EXECUTE IMMEDIATE 'SELECT CASE TO_NUMBER(TO_CHAR(TO_TIMESTAMP_TZ
                               (''20080405 23:00:00 Australia/Victoria'',''YYYYMMDD HH24:MI:SS TZR'') +
                               to_dsinterval(''0 08:00:00''),''HH24''))
                        WHEN 7 THEN 6
                        WHEN 6 THEN 7 END
                        FROM DUAL'
                        INTO dbtzv;
END IF;

-- checking if V6 is used

IF dbtzv = 6 and dbv in ('9.0.1.','9.2.0.')
  THEN
     EXECUTE IMMEDIATE 'SELECT CASE TO_NUMBER(TO_CHAR(TO_TIMESTAMP_TZ
                               (''20070929 23:00:00 NZ'',''YYYYMMDD HH24:MI:SS TZR'') +
                               to_dsinterval(''0 08:00:00''),''HH24''))
                        WHEN 7 THEN 5
                        WHEN 8 THEN 6 END
                        FROM DUAL'
                        INTO dbtzv;
END IF;

-- checking if V5 is used

IF dbtzv = 5 and dbv in ('9.0.1.','9.2.0.')
  THEN
     EXECUTE IMMEDIATE 'SELECT CASE TO_NUMBER(TO_CHAR(TO_TIMESTAMP_TZ
                               (''20070310 23:00:00 CUBA'',''YYYYMMDD HH24:MI:SS TZR'') +
                               to_dsinterval(''0 08:00:00''),''HH24''))
                        WHEN 7 THEN 4
                        WHEN 8 THEN 5 END
                        FROM DUAL'
                        INTO dbtzv;
END IF;

-- checking if V4 or lower is used 
-- this will not change anymore, so using old routine for 9i

IF dbtzv = 4 and dbv in ('9.0.1.','9.2.0.')
  THEN
     EXECUTE IMMEDIATE 'SELECT COUNT(DISTINCT(tzname)), COUNT(tzname)
                     FROM v$timezone_names' 
                     INTO tznames_dist_count, tznames_count;
  
      dbtzv := CASE
             WHEN tznames_dist_count in (183, 355, 347) THEN 1
             WHEN tznames_dist_count = 377 THEN 2
             WHEN (tznames_dist_count = 186 and tznames_count = 636) THEN 2
             WHEN (tznames_dist_count = 186 and tznames_count = 626) THEN 3
             WHEN tznames_dist_count in (185, 386) THEN 3
             WHEN (tznames_dist_count = 387 and tznames_count = 1438) THEN 3
             WHEN (tznames_dist_count = 391 and tznames_count = 1457) THEN 4 
             WHEN (tznames_dist_count = 188 and tznames_count = 637) THEN 4 
           END;
END IF;

-- if current version is already V4 there nothing to do for patchsets who include V4

IF dbtzv = 4
  THEN
    DBMS_OUTPUT.PUT_LINE('Your current timezone version is ' || 
                       TO_CHAR(dbtzv) || '!');
    DBMS_OUTPUT.PUT_LINE('No need to validate TIMEZONE data');
     RETURN;
END IF;

 -- if it's higher then 4 you need re-apply the same DST patch after applying the patchset
 -- catching > 7 will only work for 10g and up
  
IF dbtzv > 4
  THEN
    DBMS_OUTPUT.PUT_LINE('Your current timezone version is ' || 
                       TO_CHAR(dbtzv) || '!');
     DBMS_OUTPUT.PUT_LINE('Your need to re-apply the same version after ' ||
                          'applying the patchset!');
     RETURN;
END IF;


 DBMS_OUTPUT.PUT_LINE('Your current timezone version is ' || 
                       TO_CHAR(dbtzv) || '!');
  
  --======================================================================
  -- Get tables with columns defined as type TIMESTAMP WITH TIME ZONE.
  --======================================================================
  
  OPEN cursor_tstz FOR
       'SELECT atc.owner, atc.table_name, atc.column_name ' ||
       'FROM   "ALL_TAB_COLS" atc, "ALL_TABLES" at ' ||
       'WHERE  data_type LIKE ''TIMESTAMP%WITH TIME ZONE''' ||
       ' AND atc.owner = at.owner AND atc.table_name = at.table_name ' ||
       'ORDER BY atc.owner, atc.table_name, atc.column_name';
    

  --======================================================================
  -- Get all the affected time zones based on the current database time 
  -- zone version, and put them into a temporary table, sys_tzuv2_temptab.
  --======================================================================
  
  IF dbtzv = 1 
  THEN
    EXECUTE IMMEDIATE 'INSERT INTO sys.sys_tzuv2_affected_regions
      SELECT ''AMERICA/DENVER'' FROM DUAL UNION ALL
      SELECT ''AMERICA/SHIPROCK'' FROM DUAL UNION ALL
      SELECT ''US/MOUNTAIN'' FROM DUAL UNION ALL
      SELECT ''CST'' FROM DUAL UNION ALL
      SELECT ''AFRICA/CAIRO'' FROM DUAL UNION ALL
      SELECT ''AFRICA/KHARTOUM'' FROM DUAL UNION ALL
      SELECT ''AFRICA/TUNIS'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ADAK'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ANCHORAGE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ARAGUAINA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ASUNCION'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ATKA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/BOA_VISTA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/BOISE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/BUENOS_AIRES'' FROM DUAL UNION ALL
      SELECT ''AMERICA/CAMBRIDGE_BAY'' FROM DUAL UNION ALL
      SELECT ''AMERICA/CANCUN'' FROM DUAL UNION ALL
      SELECT ''AMERICA/CHICAGO'' FROM DUAL UNION ALL
      SELECT ''AMERICA/CHIHUAHUA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/CUIABA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/DAWSON'' FROM DUAL UNION ALL
      SELECT ''AMERICA/DETROIT'' FROM DUAL UNION ALL
      SELECT ''AMERICA/EDMONTON'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ENSENADA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/FORT_WAYNE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/FORTALEZA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/GOOSE_BAY'' FROM DUAL UNION ALL
      SELECT ''AMERICA/GUATEMALA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/HALIFAX'' FROM DUAL UNION ALL
      SELECT ''AMERICA/HAVANA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/INDIANA/INDIANAPOLIS'' FROM DUAL UNION ALL
      SELECT ''AMERICA/INDIANA/KNOX'' FROM DUAL UNION ALL
      SELECT ''AMERICA/INDIANA/MARENGO'' FROM DUAL UNION ALL
      SELECT ''AMERICA/INDIANA/VEVAY'' FROM DUAL UNION ALL
      SELECT ''AMERICA/INDIANAPOLIS'' FROM DUAL UNION ALL
      SELECT ''AMERICA/INUVIK'' FROM DUAL UNION ALL
      SELECT ''AMERICA/IQALUIT'' FROM DUAL UNION ALL
      SELECT ''AMERICA/JAMAICA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/JUNEAU'' FROM DUAL UNION ALL
      SELECT ''AMERICA/KENTUCKY/LOUISVILLE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/KNOX_IN'' FROM DUAL UNION ALL
      SELECT ''AMERICA/LOS_ANGELES'' FROM DUAL UNION ALL
      SELECT ''AMERICA/LOUISVILLE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/MACEIO'' FROM DUAL UNION ALL
      SELECT ''AMERICA/MANAGUA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/MAZATLAN'' FROM DUAL UNION ALL
      SELECT ''AMERICA/MEXICO_CITY'' FROM DUAL UNION ALL
      SELECT ''AMERICA/MIQUELON'' FROM DUAL UNION ALL
      SELECT ''AMERICA/MONTEVIDEO'' FROM DUAL UNION ALL
      SELECT ''AMERICA/MONTREAL'' FROM DUAL UNION ALL
      SELECT ''AMERICA/NEW_YORK'' FROM DUAL UNION ALL
      SELECT ''AMERICA/NOME'' FROM DUAL UNION ALL
      SELECT ''AMERICA/NORONHA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/RANKIN_INLET'' FROM DUAL UNION ALL
      SELECT ''AMERICA/SANTIAGO'' FROM DUAL UNION ALL
      SELECT ''AMERICA/SAO_PAULO'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ST_JOHNS'' FROM DUAL UNION ALL
      SELECT ''AMERICA/TEGUCIGALPA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/THULE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/THUNDER_BAY'' FROM DUAL UNION ALL
      SELECT ''AMERICA/TIJUANA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/VANCOUVER'' FROM DUAL UNION ALL
      SELECT ''AMERICA/WHITEHORSE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/WINNIPEG'' FROM DUAL UNION ALL
      SELECT ''AMERICA/YELLOWKNIFE'' FROM DUAL UNION ALL
      SELECT ''ASIA/ALMATY'' FROM DUAL UNION ALL
      SELECT ''ASIA/AMMAN'' FROM DUAL UNION ALL
      SELECT ''ASIA/ANADYR'' FROM DUAL UNION ALL
      SELECT ''ASIA/AQTAU'' FROM DUAL UNION ALL
      SELECT ''ASIA/AQTOBE'' FROM DUAL UNION ALL
      SELECT ''ASIA/BAGHDAD'' FROM DUAL UNION ALL
      SELECT ''ASIA/BAKU'' FROM DUAL UNION ALL
      SELECT ''ASIA/BISHKEK'' FROM DUAL UNION ALL
      SELECT ''ASIA/CHAGOS'' FROM DUAL UNION ALL
      SELECT ''ASIA/DAMASCUS'' FROM DUAL UNION ALL
      SELECT ''ASIA/GAZA'' FROM DUAL UNION ALL
      SELECT ''ASIA/HONG_KONG'' FROM DUAL UNION ALL
      SELECT ''ASIA/JAKARTA'' FROM DUAL UNION ALL
      SELECT ''ASIA/JAYAPURA'' FROM DUAL UNION ALL
      SELECT ''ASIA/JERUSALEM'' FROM DUAL UNION ALL
      SELECT ''ASIA/KARACHI'' FROM DUAL UNION ALL
      SELECT ''ASIA/TBILISI'' FROM DUAL UNION ALL
      SELECT ''ASIA/TEHRAN'' FROM DUAL UNION ALL
      SELECT ''ASIA/TEL_AVIV'' FROM DUAL UNION ALL
      SELECT ''ASIA/TOKYO'' FROM DUAL UNION ALL
      SELECT ''ATLANTIC/BERMUDA'' FROM DUAL UNION ALL
      SELECT ''ATLANTIC/STANLEY'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/ACT'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/ADELAIDE'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/BROKEN_HILL'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/CANBERRA'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/HOBART'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/LHI'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/LORD_HOWE'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/MELBOURNE'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/NSW'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/PERTH'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/PITCAIRN'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/SOUTH'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/SYDNEY'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/TASMANIA'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/VICTORIA'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/WEST'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/YANCOWINNA'' FROM DUAL UNION ALL
      SELECT ''BRAZIL/DENORONHA'' FROM DUAL UNION ALL
      SELECT ''BRAZIL/EAST'' FROM DUAL UNION ALL
      SELECT ''CST6CDT'' FROM DUAL UNION ALL  
      SELECT ''CANADA/ATLANTIC'' FROM DUAL UNION ALL
      SELECT ''CANADA/CENTRAL'' FROM DUAL UNION ALL
      SELECT ''CANADA/EASTERN'' FROM DUAL UNION ALL
      SELECT ''CANADA/MOUNTAIN'' FROM DUAL UNION ALL
      SELECT ''CANADA/NEWFOUNDLAND'' FROM DUAL UNION ALL
      SELECT ''CANADA/PACIFIC'' FROM DUAL UNION ALL
      SELECT ''CANADA/YUKON'' FROM DUAL UNION ALL
      SELECT ''CHILE/CONTINENTAL'' FROM DUAL UNION ALL
      SELECT ''CHILE/EASTERISLAND'' FROM DUAL UNION ALL
      SELECT ''CUBA'' FROM DUAL UNION ALL
      SELECT ''EST'' FROM DUAL UNION ALL 
      SELECT ''EST5EDT'' FROM DUAL UNION ALL  
      SELECT ''EGYPT'' FROM DUAL UNION ALL
      SELECT ''EUROPE/RIGA'' FROM DUAL UNION ALL
      SELECT ''EUROPE/TALLINN'' FROM DUAL UNION ALL
      SELECT ''EUROPE/VILNIUS'' FROM DUAL UNION ALL
      SELECT ''HST'' FROM DUAL UNION ALL 
      SELECT ''HONGKONG'' FROM DUAL UNION ALL 
      SELECT ''IRAN'' FROM DUAL UNION ALL
      SELECT ''ISRAEL'' FROM DUAL UNION ALL   
      SELECT ''JAMAICA'' FROM DUAL UNION ALL  
      SELECT ''JAPAN'' FROM DUAL UNION ALL
      SELECT ''MST'' FROM DUAL UNION ALL 
      SELECT ''MST7MDT'' FROM DUAL UNION ALL  
      SELECT ''MEXICO/BAJASUR'' FROM DUAL UNION ALL
      SELECT ''MEXICO/GENERAL'' FROM DUAL UNION ALL
      SELECT ''PST'' FROM DUAL UNION ALL 
      SELECT ''PST8PDT'' FROM DUAL UNION ALL  
      SELECT ''PACIFIC/EASTER'' FROM DUAL UNION ALL
      SELECT ''PACIFIC/FIJI'' FROM DUAL UNION ALL
      SELECT ''PACIFIC/GUAM'' FROM DUAL UNION ALL
      SELECT ''PACIFIC/SAIPAN'' FROM DUAL UNION ALL
      SELECT ''PACIFIC/TONGATAPU'' FROM DUAL UNION ALL
      SELECT ''US/ALASKA'' FROM DUAL UNION ALL
      SELECT ''US/ALEUTIAN'' FROM DUAL UNION ALL
      SELECT ''US/CENTRAL'' FROM DUAL UNION ALL
      SELECT ''US/EAST-INDIANA'' FROM DUAL UNION ALL
      SELECT ''US/EASTERN'' FROM DUAL UNION ALL
      SELECT ''US/MICHIGAN'' FROM DUAL UNION ALL
      SELECT ''US/PACIFIC'' FROM DUAL UNION ALL
      SELECT ''US/PACIFIC-NEW'' FROM DUAL';
  
   ELSIF dbtzv=2 THEN 
    EXECUTE IMMEDIATE 'INSERT INTO sys.sys_tzuv2_affected_regions
      SELECT ''AMERICA/DENVER'' FROM DUAL UNION ALL
      SELECT ''AMERICA/SHIPROCK'' FROM DUAL UNION ALL
      SELECT ''US/MOUNTAIN'' FROM DUAL UNION ALL
      SELECT ''CST'' FROM DUAL UNION ALL
      SELECT ''AFRICA/CAIRO'' FROM DUAL UNION ALL
      SELECT ''AFRICA/KHARTOUM'' FROM DUAL UNION ALL
      SELECT ''AFRICA/TUNIS'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ADAK'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ANCHORAGE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ARAGUAINA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ASUNCION'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ATKA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/BOISE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/CAMBRIDGE_BAY'' FROM DUAL UNION ALL
      SELECT ''AMERICA/CHICAGO'' FROM DUAL UNION ALL
      SELECT ''AMERICA/CUIABA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/DAWSON'' FROM DUAL UNION ALL
      SELECT ''AMERICA/DETROIT'' FROM DUAL UNION ALL
      SELECT ''AMERICA/EDMONTON'' FROM DUAL UNION ALL
      SELECT ''AMERICA/FORT_WAYNE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/GOOSE_BAY'' FROM DUAL UNION ALL
      SELECT ''AMERICA/GUATEMALA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/HALIFAX'' FROM DUAL UNION ALL
      SELECT ''AMERICA/HAVANA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/INDIANA/INDIANAPOLIS'' FROM DUAL UNION ALL
      SELECT ''AMERICA/INDIANA/KNOX'' FROM DUAL UNION ALL
      SELECT ''AMERICA/INDIANA/MARENGO'' FROM DUAL UNION ALL
      SELECT ''AMERICA/INDIANA/VEVAY'' FROM DUAL UNION ALL
      SELECT ''AMERICA/INDIANAPOLIS'' FROM DUAL UNION ALL
      SELECT ''AMERICA/INUVIK'' FROM DUAL UNION ALL
      SELECT ''AMERICA/IQALUIT'' FROM DUAL UNION ALL
      SELECT ''AMERICA/JAMAICA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/JUNEAU'' FROM DUAL UNION ALL
      SELECT ''AMERICA/KENTUCKY/LOUISVILLE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/KNOX_IN'' FROM DUAL UNION ALL
      SELECT ''AMERICA/LOS_ANGELES'' FROM DUAL UNION ALL
      SELECT ''AMERICA/LOUISVILLE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/MANAGUA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/MIQUELON'' FROM DUAL UNION ALL
      SELECT ''AMERICA/MONTEVIDEO'' FROM DUAL UNION ALL
      SELECT ''AMERICA/MONTREAL'' FROM DUAL UNION ALL
      SELECT ''AMERICA/NEW_YORK'' FROM DUAL UNION ALL
      SELECT ''AMERICA/NOME'' FROM DUAL UNION ALL
      SELECT ''AMERICA/NORONHA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/RANKIN_INLET'' FROM DUAL UNION ALL
      SELECT ''AMERICA/SAO_PAULO'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ST_JOHNS'' FROM DUAL UNION ALL
      SELECT ''AMERICA/TEGUCIGALPA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/THULE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/THUNDER_BAY'' FROM DUAL UNION ALL
      SELECT ''AMERICA/VANCOUVER'' FROM DUAL UNION ALL
      SELECT ''AMERICA/WHITEHORSE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/WINNIPEG'' FROM DUAL UNION ALL
      SELECT ''AMERICA/YELLOWKNIFE'' FROM DUAL UNION ALL
      SELECT ''ASIA/ALMATY'' FROM DUAL UNION ALL
      SELECT ''ASIA/AMMAN'' FROM DUAL UNION ALL
      SELECT ''ASIA/AQTAU'' FROM DUAL UNION ALL
      SELECT ''ASIA/AQTOBE'' FROM DUAL UNION ALL
      SELECT ''ASIA/BAKU'' FROM DUAL UNION ALL
      SELECT ''ASIA/BISHKEK'' FROM DUAL UNION ALL
      SELECT ''ASIA/CHAGOS'' FROM DUAL UNION ALL
      SELECT ''ASIA/DAMASCUS'' FROM DUAL UNION ALL
      SELECT ''ASIA/GAZA'' FROM DUAL UNION ALL
      SELECT ''ASIA/HONG_KONG'' FROM DUAL UNION ALL
      SELECT ''ASIA/JAKARTA'' FROM DUAL UNION ALL
      SELECT ''ASIA/JAYAPURA'' FROM DUAL UNION ALL
      SELECT ''ASIA/JERUSALEM'' FROM DUAL UNION ALL
      SELECT ''ASIA/TBILISI'' FROM DUAL UNION ALL
      SELECT ''ASIA/TEHRAN'' FROM DUAL UNION ALL
      SELECT ''ASIA/TEL_AVIV'' FROM DUAL UNION ALL
      SELECT ''ASIA/TOKYO'' FROM DUAL UNION ALL
      SELECT ''ATLANTIC/BERMUDA'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/ACT'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/ADELAIDE'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/BROKEN_HILL'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/CANBERRA'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/HOBART'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/LHI'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/LORD_HOWE'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/MELBOURNE'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/NSW'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/PERTH'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/PITCAIRN'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/SOUTH'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/SYDNEY'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/TASMANIA'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/VICTORIA'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/WEST'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/YANCOWINNA'' FROM DUAL UNION ALL
      SELECT ''BRAZIL/DENORONHA'' FROM DUAL UNION ALL
      SELECT ''BRAZIL/EAST'' FROM DUAL UNION ALL
      SELECT ''CST6CDT'' FROM DUAL UNION ALL
      SELECT ''CANADA/ATLANTIC'' FROM DUAL UNION ALL
      SELECT ''CANADA/CENTRAL'' FROM DUAL UNION ALL
      SELECT ''CANADA/EASTERN'' FROM DUAL UNION ALL
      SELECT ''CANADA/MOUNTAIN'' FROM DUAL UNION ALL
      SELECT ''CANADA/NEWFOUNDLAND'' FROM DUAL UNION ALL
      SELECT ''CANADA/PACIFIC'' FROM DUAL UNION ALL
      SELECT ''CANADA/YUKON'' FROM DUAL UNION ALL
      SELECT ''CUBA'' FROM DUAL UNION ALL
      SELECT ''EST'' FROM DUAL UNION ALL
      SELECT ''EST5EDT'' FROM DUAL UNION ALL
      SELECT ''EGYPT'' FROM DUAL UNION ALL
      SELECT ''HST'' FROM DUAL UNION ALL
      SELECT ''HONGKONG'' FROM DUAL UNION ALL
      SELECT ''IRAN'' FROM DUAL UNION ALL
      SELECT ''ISRAEL'' FROM DUAL UNION ALL 
      SELECT ''JAMAICA'' FROM DUAL UNION ALL
      SELECT ''JAPAN'' FROM DUAL UNION ALL
      SELECT ''MST'' FROM DUAL UNION ALL
      SELECT ''MST7MDT'' FROM DUAL UNION ALL
      SELECT ''PST'' FROM DUAL UNION ALL
      SELECT ''PST8PDT'' FROM DUAL UNION ALL
      SELECT ''US/ALASKA'' FROM DUAL UNION ALL
      SELECT ''US/ALEUTIAN'' FROM DUAL UNION ALL
      SELECT ''US/CENTRAL'' FROM DUAL UNION ALL
      SELECT ''US/EAST-INDIANA'' FROM DUAL UNION ALL
      SELECT ''US/EASTERN'' FROM DUAL UNION ALL
      SELECT ''US/MICHIGAN'' FROM DUAL UNION ALL
      SELECT ''US/PACIFIC'' FROM DUAL UNION ALL
      SELECT ''US/PACIFIC-NEW'' FROM DUAL';
   
  ELSIF dbtzv=3 THEN
    EXECUTE IMMEDIATE 'INSERT INTO sys.sys_tzuv2_affected_regions 
      SELECT ''AFRICA/CAIRO'' FROM DUAL UNION ALL
      SELECT ''AFRICA/TUNIS'' FROM DUAL UNION ALL
      SELECT ''AMERICA/CUIABA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/DAWSON'' FROM DUAL UNION ALL
      SELECT ''AMERICA/EDMONTON'' FROM DUAL UNION ALL
      SELECT ''AMERICA/GOOSE_BAY'' FROM DUAL UNION ALL
      SELECT ''AMERICA/GUATEMALA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/INUVIK'' FROM DUAL UNION ALL
      SELECT ''AMERICA/MANAGUA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/MONTEVIDEO'' FROM DUAL UNION ALL
      SELECT ''AMERICA/SAO_PAULO'' FROM DUAL UNION ALL
      SELECT ''AMERICA/ST_JOHNS'' FROM DUAL UNION ALL
      SELECT ''AMERICA/TEGUCIGALPA'' FROM DUAL UNION ALL
      SELECT ''AMERICA/THULE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/VANCOUVER'' FROM DUAL UNION ALL
      SELECT ''AMERICA/WHITEHORSE'' FROM DUAL UNION ALL
      SELECT ''AMERICA/YELLOWKNIFE'' FROM DUAL UNION ALL
      SELECT ''ASIA/AMMAN'' FROM DUAL UNION ALL
      SELECT ''ASIA/DAMASCUS'' FROM DUAL UNION ALL
      SELECT ''ASIA/GAZA'' FROM DUAL UNION ALL
      SELECT ''ASIA/TEHRAN'' FROM DUAL UNION ALL
      SELECT ''ATLANTIC/BERMUDA'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/PERTH'' FROM DUAL UNION ALL
      SELECT ''AUSTRALIA/WEST'' FROM DUAL UNION ALL
      SELECT ''BRAZIL/EAST'' FROM DUAL UNION ALL
      SELECT ''CANADA/MOUNTAIN'' FROM DUAL UNION ALL
      SELECT ''CANADA/NEWFOUNDLAND'' FROM DUAL UNION ALL
      SELECT ''CANADA/PACIFIC'' FROM DUAL UNION ALL
      SELECT ''CANADA/YUKON'' FROM DUAL UNION ALL
      SELECT ''EGYPT'' FROM DUAL UNION ALL    
      SELECT ''IRAN'' FROM DUAL';
  END IF;

  
  EXECUTE IMMEDIATE 'ANALYZE TABLE sys.sys_tzuv2_affected_regions ' ||
                    'COMPUTE STATISTICS';
  
--======================================================================
-- Check regular table columns.
-- they have no value in the nested_tab column to avoid confusion
--======================================================================  
  LOOP
       BEGIN
         FETCH cursor_tstz INTO tstz_owner, tstz_tname, tstz_qcname;
         EXIT WHEN cursor_tstz%NOTFOUND;

         EXECUTE IMMEDIATE 
           'SELECT COUNT(1) FROM ' ||
            tstz_owner || '."' || tstz_tname || '" t_alias, ' ||
            ' sys.sys_tzuv2_affected_regions r ' ||
            ' WHERE UPPER(r.time_zone_name) = ' ||
               ' UPPER(TO_CHAR(t_alias."' || tstz_qcname || '", ''TZR'')) ' INTO numrows;
        
         IF numrows > 0 THEN
           EXECUTE IMMEDIATE ' INSERT INTO sys.sys_tzuv2_temptab VALUES (''' ||
             tstz_owner || ''',''' || tstz_tname || ''',''' || 
             tstz_qcname || ''',' || numrows || ', ''  '')';
         END IF;
  
       EXCEPTION
         WHEN OTHERS THEN
           DBMS_OUTPUT.PUT_LINE('OWNER : ' || tstz_owner);
           DBMS_OUTPUT.PUT_LINE('TABLE : ' || tstz_tname);
           DBMS_OUTPUT.PUT_LINE('COLUMN : ' || tstz_qcname);
           DBMS_OUTPUT.PUT_LINE(SQLERRM);
       END;
  END LOOP;

--======================================================================
-- Check nested table columns,only possible if 10g or higher.
-- these tables need manual check to see what data may be stored 
-- we simply see if it's a TIMESTAMP WITH TIME ZONE datatype, not
-- if it actually contains affected data.
--======================================================================
IF dbv in ('10.1.0','10.2.0','11.1.0')
 THEN 
  EXECUTE IMMEDIATE
    'INSERT INTO sys.sys_tzuv2_temptab 
       SELECT owner, table_name, qualified_col_name, NULL, ''YES''
       FROM DBA_NESTED_TABLE_COLS
       WHERE data_type like ''TIMESTAMP%WITH TIME ZONE''';
END IF;

  DBMS_OUTPUT.PUT_LINE('.');
  DBMS_OUTPUT.PUT_LINE('Do a select * from sys.sys_tzuv2_temptab; to see if any TIMEZONE');
  DBMS_OUTPUT.PUT_LINE('data is affected by version 4 transition rules.');
  DBMS_OUTPUT.PUT_LINE('.');
  DBMS_OUTPUT.PUT_LINE('Any table with YES in the nested_tab column (last column) needs');
  DBMS_OUTPUT.PUT_LINE('a manual check as these are nested tables.');

END;
/

COMMIT
/

Rem=========================================================================
SET SERVEROUTPUT OFF
Rem=========================================================================