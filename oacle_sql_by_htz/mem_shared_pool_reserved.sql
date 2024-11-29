set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000


PROMPT 如果: 
PROMPT 	REQUEST_FAILURES > 0 并且 LAST_FAILURE_SIZE > SHARED_POOL_RESERVED_MIN_ALLOC 
PROMPT 那么ORA-04031 错误就是因为共享池保留空间缺少连续空间所致。要解决这个问题,可以
PROMPT 考虑加大SHARED_POOL_RESERVED_MIN_ALLOC 来降低缓冲进共享池保留空间的对象数目，
PROMPT 并增大 SHARED_POOL_RESERVED_SIZE 和 SHARED_POOL_SIZE 来加大共享池保留空间的
PROMPT 可用 内存。
PROMPT 如果： 
PROMPT 	REQUEST_FAILURES > 0 并且 LAST_FAILURE_SIZE < SHARED_POOL_RESERVED_MIN_ALLOC 
PROMPT 或者 
PROMPT 	REQUEST_FAILURES 等于0 并且 LAST_FAILURE_SIZE < SHARED_POOL_RESERVED_MIN_ALLOC 
PROMPT 那么是因为在库高速缓冲缺少连续空间导致ORA-04031 错误。 
PROMPT 第一步应该考虑降低SHARED_POOL_RESERVED_MIN_ALLOC 以放入更多的对象到共享池 保留
PROMPT 空间中并且加大SHARED_POOL_SIZE。 

	SELECT free_space, avg_free_size,used_space, avg_used_size, request_failures,
       last_failure_size
  FROM v$shared_pool_reserved
/
clear    breaks  
@sqlplusset

