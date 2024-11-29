set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 200
col parameter for a40
col session_value for a20
col instance_value for a20
col description for a60

SELECT a.ksppinm AS parameter,
       b.ksppstvl AS session_value,
       c.ksppstvl AS instance_value,
       a.ksppdesc AS description
FROM   x$ksppi a,
       x$ksppcv b,
       x$ksppsv c
WHERE  a.indx = b.indx
AND    a.indx = c.indx
AND    a.ksppinm LIKE '/_%' ESCAPE '/'
AND    (a.ksppinm = '_shared_pool_reserved_min_alloc')
ORDER BY a.ksppinm
/
PROMPT +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROMPT 如果request_failures > 0 并且 last_failure_size > _shared_pool_reserved_min_alloc
PROMPT 那么ORA-04031错误就可能是因为共享池保留空间缺少连续空间所致。
PROMPT 要解决这个问题，可以考虑加大_shared_pool_reserved_min_alloc来降低缓冲进共享池保留空间的对象数目
PROMPT 并增大shared_pool_reserved_size 和 shared_pool_size来加大共享池保留空间的可用内存。
PROMPT 
PROMPT 如果request_failures > 0 并且 last_failure_size < _shared_pool_reserved_min_alloc
PROMPT 那么是因为在库高速缓冲缺少连续空间导致ORA-04031错误。
PROMPT ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SELECT free_space,
       avg_free_size,
       used_space,
       avg_used_size,
       request_failures,
       last_failure_size
  FROM v$shared_pool_reserved;

