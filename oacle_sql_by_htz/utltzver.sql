Rem
Rem $Header: utltzver.sql 28-jun-2010.17:53:00 gvermeir Exp $
Rem
Rem Copyright (c) 2008,2010 Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      utltzver.sql - time zone version script for 9i (and higher)
Rem
Rem    NOTES
Rem      * This script must be run using SQL*PLUS.
Rem      * You must be connected AS SYSDBA to run this script.
Rem
Rem    DESCRIPTION
Rem      This script shows the version of the installed timezone defintions.
Rem      Mainly usefull for 9i but can be used on any version up to 11g
Rem 
Rem    MODIFIED   (MM/DD/YY)
Rem    gvermeir   06/28/10 - updated to DSTv14
Rem    gvermeir   12/16/09 - corrected < DST13 9i detection
Rem    gvermeir   12/15/09 - updated to DSTv13
Rem    gvermeir   07/22/09 - corrected 9i detection
Rem    gvermeir   06/16/09 - updated to DSTv11
Rem    gvermeir   02/15/08 - created from utltzuv7.sql
Rem

SET SERVEROUTPUT ON

DECLARE

  dbv                  VARCHAR2(10);
  release              VARCHAR2(16);
  dbtzv                VARCHAR2(5);
  tznames_count        NUMBER;
  tznames_dist_count   NUMBER;
  
BEGIN

--========================================================================
-- Make sure that only Release 9i and up uses this script
--========================================================================

SELECT substr(version,1,6), version INTO dbv, release FROM v$instance;
        
IF dbv in ('8.1.7.','8.1.6.','8.1.5.','8.0.6.','8.0.5.','8.0.4.')
  THEN
    DBMS_OUTPUT.PUT_LINE('Timezones are not supported in Release ' || release);
    DBMS_OUTPUT.PUT_LINE('Cannot provide Timezone version.');
    RETURN;
END IF;
        
IF dbv not in ('9.0.1.','9.2.0.','10.1.0','10.2.0','11.1.0','11.2.0')
  THEN
    DBMS_OUTPUT.PUT_LINE('Please see metalink note 412160.1 to get ');
    DBMS_OUTPUT.PUT_LINE('the script for Release ' || release);
    DBMS_OUTPUT.PUT_LINE('Versions below 9.0.1 do not have Timezone information');
   RETURN;
END IF;
        
--======================================================================
-- Check if the TIMEZONE data version
--======================================================================

-- TZ version checks if db is 10g or higher

IF dbv in ('10.1.0','10.2.0','11.1.0','11.2.0')
 THEN
    EXECUTE IMMEDIATE 'SELECT version FROM v$timezone_file' INTO dbtzv;
END IF;
 
-- TZ version checks if db is 9i
-- In 9i there is no way to catch if the TZ files are newer then the latest DST patch version 
-- at the time this script was made, wich is DSTv13
-- For DSTv8 and up it's assumed the large timezone file 
-- (standard in 9.2.0.5 and up when ORA_TZFILE is NOT set) is used.
-- Using the small timezone file will be catched.

-- checking if V7 (or higher) is used in 9i

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

-- DBMS_OUTPUT.PUT_LINE('temp version is ' || TO_CHAR(dbtzv) || '!');

-- checking if V6 is used in 9i

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

-- DBMS_OUTPUT.PUT_LINE('temp version is ' || TO_CHAR(dbtzv) || '!');

-- checking if V5 is used in 9i

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

-- DBMS_OUTPUT.PUT_LINE('temp version is ' || TO_CHAR(dbtzv) || '!');

-- checking if V4 or lower is used in 9i
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

-- DBMS_OUTPUT.PUT_LINE('temp version is ' || TO_CHAR(dbtzv) || '!');

-- checking if V8 is used or DSTv14 small file
-- no DST rules changed, only tz's added
-- The then 99 is the check if for DSTv >7 and < 14 the small file is used 

IF dbtzv = 7 and dbv in ('9.0.1.','9.2.0.')
  THEN
     EXECUTE IMMEDIATE 'SELECT COUNT(DISTINCT(tzname)), COUNT(tzname)
                     FROM v$timezone_names' 
                     INTO tznames_dist_count, tznames_count;
  
       dbtzv := CASE
             WHEN (tznames_dist_count = 519 and tznames_count = 1858) THEN 7
             WHEN (tznames_dist_count = 188 and tznames_count =  637) THEN 7
             WHEN (tznames_dist_count = 199 and tznames_count =  755) THEN 14
             WHEN (tznames_dist_count = 197 and tznames_count =  676) THEN 99                          
             WHEN (tznames_dist_count > 519 and tznames_count > 1858) THEN 8 
           END;
END IF;

-- DBMS_OUTPUT.PUT_LINE('temp version is ' || TO_CHAR(dbtzv) || '!');

-- checking if V9 is used

IF dbtzv = 8 and dbv in ('9.0.1.','9.2.0.')
  THEN
     EXECUTE IMMEDIATE 'SELECT CASE TO_NUMBER(TO_CHAR(TO_TIMESTAMP_TZ
                               (''20080531 23:00:00 Africa/Casablanca'',''YYYYMMDD HH24:MI:SS TZR'') +
                               to_dsinterval(''0 08:00:00''),''HH24''))
                        WHEN 8 THEN 9
                        WHEN 7 THEN 8 END
                        FROM DUAL'
                        INTO dbtzv;
END IF;

-- DBMS_OUTPUT.PUT_LINE('temp version is ' || TO_CHAR(dbtzv) || '!');

-- checking if V10, v11 , V13 or v14 is used
-- no need to check for DSTv12
-- no DST rules changed

IF dbtzv = 9 and dbv in ('9.0.1.','9.2.0.')
  THEN
     EXECUTE IMMEDIATE 'SELECT COUNT(DISTINCT(tzname)), COUNT(tzname)
                     FROM v$timezone_names' 
                     INTO tznames_dist_count, tznames_count;
       dbtzv := CASE
             WHEN (tznames_dist_count = 548 and tznames_count = 1987) THEN 9
             WHEN (tznames_dist_count = 549 and tznames_count = 1992) THEN 10
             WHEN (tznames_dist_count = 551 and tznames_count = 2137) THEN 11
             WHEN (tznames_dist_count = 551 and tznames_count = 2141) THEN 13 
             WHEN (tznames_dist_count = 556 and tznames_count = 2164) THEN 14 
             WHEN (tznames_dist_count > 556 ) THEN 99 
             WHEN (tznames_dist_count = 556 and tznames_count > 2164) THEN 99 
        END;
END IF;

-- 99 is a catch to have always a result when things don't match
-- like when runned on a future DST version in 9i

-- DBMS_OUTPUT.PUT_LINE('temp version is ' || TO_CHAR(dbtzv) || '!');

-- when updating this script this needs to be highest dst version for 9i
  
IF dbtzv <= 14 and dbv in ('9.0.1.','9.2.0.')
  THEN
     DBMS_OUTPUT.PUT_LINE('Your current 9i Server timezone version is ' || 
                       TO_CHAR(dbtzv) || '!');
     RETURN;
END IF;

-- no way to catch DSTv8 and up if the small timezone file is used.

IF dbtzv > 14 and dbv in ('9.0.1.','9.2.0.')
  THEN
     DBMS_OUTPUT.PUT_LINE('The exact DST version cannot be detected but is DSTv8 or higher ' || 
                          'please check manually the 9i DST version');
     DBMS_OUTPUT.PUT_LINE('Most likely you are using the small timezone file -ORA_TZFILE IS set-');
     DBMS_OUTPUT.PUT_LINE('OR check note 412160.1 to see if there is a newer script');
     RETURN;
END IF;


IF dbtzv < 99 and dbv not in ('9.0.1.','9.2.0.')
  THEN
     DBMS_OUTPUT.PUT_LINE('Your current Server timezone version is ' || 
                       TO_CHAR(dbtzv) || '!');
     RETURN;
END IF;
  
END;
/

Rem=========================================================================
SET SERVEROUTPUT OFF
Rem=========================================================================