CREATE OR REPLACE PROCEDURE oerr12700( a number , b number, c number) IS
un varchar2(99);tn varchar2(99); trowid varchar2(99);
ind_name varchar2(99); ind_col varchar2(99);
nfile number; nblock number; nrow number;
fname VARCHAR2(513) ;
dbs number ;
dbs_x varchar2(129);
x number;

BEGIN

x:= dbms_utility.get_parameter_value('db_block_size',dbs,dbs_x);


nfile:=dbms_utility.data_block_address_file(b);
select FILE_NAME into fname from dba_data_files
where RELATIVE_FNO = nfile ;


nblock:=dbms_utility.data_block_address_block(b);
select NAME,dba_users.username  into tn,un from obj$,dba_users where dataobj#=a
and dba_users.user_id=obj$.owner# ;

trowid:= dbms_rowid.rowid_create(1,a,nfile,nblock,c);

dbms_output.put_line(' ORA-600 [12700] ['||a||'],['||b||'],['||c||']');
dbms_output.put_line('--------------------------------------------------');
dbms_output.put_line('there is an index pointing to a row in '||un||'.'||tn);
dbms_output.put_line('row is slot '||c||' in file '||nfile||' block '||nblock);
dbms_output.put_line('one index entry is pointing to ROWID='''|| trowid||'''');
dbms_output.put_line('--------------------------------------------------');
dbms_output.put_line('You may want to check the integrity of '||un||'.'||tn);
dbms_output.put_line('executing :');
dbms_output.put_line('dbv file='||fname||' 
blocksize='||dbs||' start='|| nblock||' end='||nblock);
dbms_output.put_line('--------------------------------------------------');

--
dbms_output.put_line('IF dbv does not show any corruption, you can try to');
dbms_output.put_line('find the corrupted indexes using the queries proposed');
dbms_output.put_line('by the procedure oerr12700diag('||a||','||b||','||c||')');
dbms_output.put_line('-------------------------------------------------------');
END;
/
