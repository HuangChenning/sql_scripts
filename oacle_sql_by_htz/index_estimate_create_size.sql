/* dbms_space是根据dbms_stats收集后的统计信息来计算索引的大小，
所以不是根据当前表的大小来分析，
而是根据分析表时的大小来统计，
如果表上没有统计信息，请手动收集统计信息 */
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
