set echo off lines 200 verify off heading on
col line for 999
col time for a11
col type for a10
col error_number for 99999
col cause for a20
col status for a10
col message for a70
col action for a50
undefine pdbname;
SELECT to_char(time,'hh24:mi:ss') time,
       line,
       TYPE,
       cause,
       error_number,
       status,
       message,
       action
FROM pdb_plug_in_violations
WHERE time>sysdate-1/24
  AND con_id IN
    (SELECT con_id
     FROM v$pdbs
     WHERE name=upper('&pdbname'))
 /
 undefine pdbname;