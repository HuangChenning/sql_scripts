set echo off
set heading on
set feedback off
set verify off
set lines 200
set pages 10000
set verify off
column host format a60
column db_link format a32
col owner for a15
col username for a15 heading 'REMOTE DATABASE|OBJECT OWNER'
col dec for a4
col authusr for a15
undefine link_owner;
undefine link_name;
break on OWNER skip 1

SELECT A.OWNER,
       A.DB_LINK,
       c.status,
       A.USERNAME,
       A.CREATED,
       DECODE(B.FLAG, 0, 'NO', 1, 'YES') "DEC",
       B.AUTHUSR,
       a.host
  FROM DBA_DB_LINKS A, SYS.USER$ U, SYS.LINK$ B, DBA_OBJECTS C
 WHERE A.DB_LINK = B.NAME
   AND A.OWNER = U.NAME
   AND B.OWNER# = U.USER#
   AND A.DB_LINK = C.OBJECT_NAME
   AND A.OWNER = C.OWNER
   AND C.OBJECT_TYPE = 'DATABASE LINK'
   /*and a.db_link like upper('%linkname%')*/
   and a.owner=nvl(upper('&link_owner'),a.owner)
   and a.db_link=nvl(upper('&link_name'),a.db_link)
ORDER BY 1, 2, 3
/
