set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000


PROMPT ���: 
PROMPT 	REQUEST_FAILURES > 0 ���� LAST_FAILURE_SIZE > SHARED_POOL_RESERVED_MIN_ALLOC 
PROMPT ��ôORA-04031 ���������Ϊ����ر����ռ�ȱ�������ռ����¡�Ҫ����������,����
PROMPT ���ǼӴ�SHARED_POOL_RESERVED_MIN_ALLOC �����ͻ��������ر����ռ�Ķ�����Ŀ��
PROMPT ������ SHARED_POOL_RESERVED_SIZE �� SHARED_POOL_SIZE ���Ӵ���ر����ռ��
PROMPT ���� �ڴ档
PROMPT ����� 
PROMPT 	REQUEST_FAILURES > 0 ���� LAST_FAILURE_SIZE < SHARED_POOL_RESERVED_MIN_ALLOC 
PROMPT ���� 
PROMPT 	REQUEST_FAILURES ����0 ���� LAST_FAILURE_SIZE < SHARED_POOL_RESERVED_MIN_ALLOC 
PROMPT ��ô����Ϊ�ڿ���ٻ���ȱ�������ռ䵼��ORA-04031 ���� 
PROMPT ��һ��Ӧ�ÿ��ǽ���SHARED_POOL_RESERVED_MIN_ALLOC �Է������Ķ��󵽹���� ����
PROMPT �ռ��в��ҼӴ�SHARED_POOL_SIZE�� 

	SELECT free_space, avg_free_size,used_space, avg_used_size, request_failures,
       last_failure_size
  FROM v$shared_pool_reserved
/
clear    breaks  
@sqlplusset

