set echo off
set lines 200
set long 2000
set pages 1000
undefine sqlid;
SELECT xmltype(a.reason)
  FROM V$sql_shared_cursor a, v$sql b
 WHERE     a.sql_id = '&sqlid'
       AND a.sql_id = b.sql_id
       AND A.CHILD_ADDRESS = B.CHILD_ADDRESS
       AND B.IS_OBSOLETE = 'N'
       AND B.IS_SHAREABLE = 'Y'
/
undefine sqlid
