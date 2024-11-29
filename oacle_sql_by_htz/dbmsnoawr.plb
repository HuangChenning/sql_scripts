Rem
Rem dbmsnoawr.sql
Rem
Rem Copyright (c) 2006, Oracle. All rights reserved.
Rem
Rem    NAME
Rem      dbmsnoawr.sql - Declaration of the DBMS_AWR package
Rem
Rem    DESCRIPTION
Rem      Utilities for disabling and getting status of AWR
Rem
Rem    NOTES
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    gwood       04/13/07 - created
Rem
create or replace package dbms_awr as
--    PACKAGE dbms_awr
--	    This package allows users to disable AWR functionality in a Oracle 10g+ database.
--	    The use of this package is not resticted by licencing of the Diagnostic Pack.
--	    Additionally this package contains two functions that can be used to determine
--        if AWR is currently enabled.
--
--    PROCEDURE dbms_awr.disable_awr
--    PURPOSE: turns off collections into Automatic Workload Repository
--    PARAMETERS: none
  procedure disable_awr;
--    PROCEDURE dbms_awr.enable_awr
--    PURPOSE: turns on collections into Automatic Workload Repository. The capture interval
--        is set to the default of 60 minutes.
--    PARAMETERS: none
  procedure enable_awr;
--    FUNCTION dbms_awr.awr_enabled
--    PURPOSE: Returns TRUE if Automatic Workload Repository is performing periodic capture.
--             Returns FALSE if Automatic Workload Repository periodic capture is disabled.
--    PARAMETERS: none
  function awr_enabled return boolean;
--    FUNCTION dbms_awr.awr_status
--    PURPOSE: Returns 'ENABLED' if Automatic Workload Repository is performing periodic capture.
--             Returns 'DISABLED' if Automatic Workload Repository periodic capture is disabled.
--    PARAMETERS: none
  function awr_status return varchar2;
end dbms_awr;
/

create or replace package body dbms_awr wrapped
a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
27b 1de
XeDco+SpVfG9KEZ2ikXc00yhW88wg2P3AK7bfHRAWE7VX0b1S25KKJCp5VrehjNR9oaXoWT1
GGfYVnyl/lLyux308Fmhfp1y9pjrQyux50RY8xmHmiSG2bFbFs2Upn6MLYcfsqsW+joOTKYe
4TyFpXVqzVWS+Tjt8bcmSiai64IVcdOB3Q7Y6kQ8PGwqXqAiy9sFQKD0X6RC/ePGAQzUKwvS
3L8/hKgjdK9Fgw8bb7v1HTq22OJlAv+R/DYCSK57rPmAkyx/XLuXcPo3hcYs8fvUUAO33szW
gy5zNau9U7xiyAOExBz9Vh0U7EaMRl6rLr6UXpk/0tk3BW0W/GVo3XfdSzUpGN5aKa1xF2Yh
trcMV3KuK/FfIpy0bNDxSQ3LFuOsB8i5xzhj/dCqMxT4dO2awc0hnP3XeLhxWDvcEuqdkR9O
u+Z6US/LtRISXt2I8zFq6/aDSuOXTor9KQ1jYA==

/


