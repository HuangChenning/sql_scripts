set lines 170 
set pages 1000
select * from table(dbms_xplan.display(format=>'OUTLINE'));
