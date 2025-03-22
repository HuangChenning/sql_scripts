/* dbms_space�Ǹ���dbms_stats�ռ����ͳ����Ϣ�����������Ĵ�С��
���Բ��Ǹ��ݵ�ǰ��Ĵ�С��������
���Ǹ��ݷ�����ʱ�Ĵ�С��ͳ�ƣ�
�������û��ͳ����Ϣ�����ֶ��ռ�ͳ����Ϣ */
set serveroutput on
DECLARE
v_used_bytes NUMBER(10);
v_Allocated_Bytes NUMBER(10);
BEGIN

DBMS_SPACE.CREATE_INDEX_COST
(
'CREATE INDEX SCOTT.ind_test1_object_type ON scott.test1(object_type)',
v_used_Bytes,
v_Allocated_Bytes
);

DBMS_OUTPUT.PUT_LINE('Used Size(M): ' || TO_CHAR(trunc(v_used_Bytes/1024/1024)));
DBMS_OUTPUT.PUT_LINE('Allocated Size(M): ' || TO_CHAR(trunc(v_Allocated_Bytes/1024/1024)));

END;
/
