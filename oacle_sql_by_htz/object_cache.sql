set echo off
set verify off
set lines 170
set pages 100
col owner for a20
col namespace for a40
col s_size for 999999999999 heading 'Used Total|Mem KB'
col type for a40
break on owner on namespace
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display object cache in shared pool                                    |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
SELECT decode(owner,'','NULL',owner) owner,
         namespace,
         TYPE,
         ROUND (SUM (sharable_mem) / 1024, 2) s_size
    FROM sys.v$db_object_cache
GROUP BY owner, namespace, TYPE
ORDER BY owner, s_size
/
clear    breaks  
set lines 80
set pages 5
set echo on
set verify on