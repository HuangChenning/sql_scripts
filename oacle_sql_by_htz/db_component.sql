set echo off
set lines 200 pages 1000 heading on
SET SERVEROUTPUT ON;
DECLARE

ORG_VERSION varchar2(12);
PRV_VERSION varchar2(12);
P_VERSION VARCHAR2(10);

BEGIN

SELECT version INTO p_version
FROM registry$ WHERE cid='CATPROC' ;

IF SUBSTR(p_version,1,5) = '9.2.0' THEN

DBMS_OUTPUT.PUT_LINE(RPAD('Comp ID', 8) ||RPAD('Component',35)||
   RPAD('Status',10) ||RPAD('Version', 15));

DBMS_OUTPUT.PUT_LINE(RPAD(' ',8,'-') ||RPAD(' ',35,'-')||
   RPAD(' ',10,'-') ||RPAD(' ',15,'-'));

FOR x in (SELECT SUBSTR(dr.comp_id,1,8) comp_id,
 SUBSTR(dr.comp_name,1,35) comp_name,
 dr.status Status,SUBSTR(dr.version,1,15) version
 FROM dba_registry dr,registry$ r
 WHERE dr.comp_id=r.cid and dr.comp_name=r.cname
 ORDER BY 1)

LOOP

DBMS_OUTPUT.PUT_LINE(RPAD(SUBSTR(x.comp_id,1,8),8) ||
   RPAD(SUBSTR(x.comp_name,1,35),35)||
   RPAD(x.status,10) || RPAD(x.version, 15));
END LOOP;

ELSIF SUBSTR(p_version,1,5) != '9.2.0' THEN

DBMS_OUTPUT.PUT_LINE(RPAD('Comp ID', 8) ||RPAD('Component',35)||
   RPAD('Status',10) ||RPAD('Version', 15)||
   RPAD('Org_Version',15)||RPAD('Prv_Version',15));

DBMS_OUTPUT.PUT_LINE(RPAD(' ',8,'-') ||RPAD(' ',35,'-')||
   RPAD(' ',10,'-')||RPAD(' ',15,'-')||RPAD(' ',15,'-')||
   RPAD(' ',15,'-'));

FOR y in (SELECT SUBSTR(dr.comp_id,1,8) comp_id,
 SUBSTR(dr.comp_name,1,35) comp_name, dr.status Status,
 SUBSTR(dr.version,1,11) version,org_version,prv_version
 FROM dba_registry dr,registry$ r
 WHERE dr.comp_id=r.cid and dr.comp_name=r.cname
 ORDER BY 1)

LOOP

DBMS_OUTPUT.PUT_LINE(RPAD(substr(y.comp_id,1,8), 8) ||
    RPAD(substr(y.comp_name,1,35),35)||RPAD(y.status,10) ||
    RPAD(y.version, 15)||RPAD(y.org_version,15)||RPAD(y.prv_version,15));

END LOOP;

END IF;
END;
/
