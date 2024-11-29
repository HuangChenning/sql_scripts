set echo off
set lines 3000 pages 50 heading on verify off
PROMPT "********************************************************" 
PROMPT "BEGIN                                                   "
PROMPT "  DBMS_SPM.CONFIGURE('space_budget_percent',30);        "
PROMPT "END;                                                    "
PROMPT "/                                                       "
PROMPT "                                                        "
PROMPT "BEGIN                                                   "
PROMPT "  DBMS_SPM.CONFIGURE( 'plan_retention_weeks',105);      "
PROMPT "END;                                                    "
PROMPT "/                                                       "
PROMPT "********************************************************"                                                    

SELECT PARAMETER_NAME, PARAMETER_VALUE FROM DBA_SQL_MANAGEMENT_CONFIG;
