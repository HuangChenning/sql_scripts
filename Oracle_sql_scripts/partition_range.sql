/* 
循环计算最大分区的max值，并与分区边界值做比较
*/

set linesize 1000 
set pagesize 999 
col high_value for a40 
col ACTUALVALUE format a88 
col partition_name format a20 
set serveroutput on 
declare 
  act_value varchar2(4000); 
begin 
  execute immediate 'alter session set nls_date_format="yyyy-mm-dd hh24:mi:ss"';
  dbms_output.put_line(rpad('T_Col_Name',30,'-')||rpad('T_Owner',30,'-')||rpad('T_Name',30,'-')||rpad('Part_Name',20,'-')||rpad('High_value',40,'-')||rpad('Act_value-',30,'-')||rpad('Warning',10,'-')); 

  for i in ( 
    SELECT a.column_name,a.owner,a.name,c.partition_name,high_value,'select max(' || column_name|| ') from '||a.owner||'.'||a.name||' partition (' || 
    partition_name || ')' actualvalue 
    from dba_part_key_columns a, dba_part_tables b, dba_tab_partitions c 
    where a.name = b.table_name
    and a.owner=b.owner 
    and b.table_name=c.table_name 
    and b.partition_count = c.partition_position 
    and a.owner = c.table_owner 
    and b.owner not in ('SYS', 'SYSTEM','AUDSYS') 
    and b.partitioning_type='RANGE' 
    order by 1) 
    loop 
    act_value:=-1; 
    --dbms_output.put_line(i.actualvalue); 
    execute immediate i.actualvalue into act_value; 
    dbms_output.put_line(rpad(i.column_name,30,' ')||rpad(i.owner,30,' ')||rpad(i.name,30,' ')||rpad(i.partition_name,20,' ')||rpad(i.high_value,40,' ')||lpad(nvl(act_value,'Null'),30,' ')||lpad(case when  i.high_value>act_value then 'Y' else 'N' END  ,10,' ')); 
  end loop; 
end; 
/
