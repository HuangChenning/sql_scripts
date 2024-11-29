
SET echo OFF
SET lines 200 pages 1000 verify OFF heading ON 
col id FOR 9999
col name FOR a40 heading PARA_NAME 
col current_value FOR a30
col system_value for a30
undefine sid;
undefine isdefault_yes_no;

SELECT a.CHILD_NUMBER,a.CHILD_ADDRESS,a.id id,
       a.name,
       a.value current_value,
       val.ksppstvl system_value,
       a.isdefault
FROM v$sql_optimizer_env a,
     x$ksppi nam,
     x$ksppsv val
WHERE nam.indx = val.indx
  AND a.name=nam.ksppinm
  AND a.sql_id='&sqlid'
  AND a.child_number=nvl('&child_number',a.child_number)
  AND a.isdefault=nvl(upper('&isdefault_yes_no'),a.isdefault)
  ORDER BY id
/
undefine sid;
undefine isdefault_yes_no;