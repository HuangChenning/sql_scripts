CREATE OR REPLACE PROCEDURE oerr12700diag( a number , b number, c number) IS
un varchar2(99);tn varchar2(99); trowid varchar2(99);
ind_name varchar2(99); ind_col varchar2(99);
nfile number; nblock number; nrow number;

cursor pindexes(towner varchar2, tname varchar2) is
select C.INDEX_NAME,COLUMN_NAME from dba_ind_columns C, dba_indexes I
where c.INDEX_NAME=i.INDEX_NAME
and I.INDEX_TYPE <> 'DOMAIN'
and C.TABLE_OWNER=towner and C.TABLE_NAME=tname
and C.COLUMN_POSITION=1 ;

rpindexes pindexes%rowtype;

BEGIN
nfile:=dbms_utility.data_block_address_file(b);
nblock:=dbms_utility.data_block_address_block(b);
select NAME,dba_users.username  into tn,un from obj$,dba_users where dataobj#=a
and dba_users.user_id=obj$.owner# ;

trowid:= dbms_rowid.rowid_create(1,a,nfile,nblock,c);

dbms_output.put_line('--------------------------------------------------');
dbms_output.put_line('IF dbv did not show any corruption, you can try to');
dbms_output.put_line('find the corrupted indexes using following queries:');
dbms_output.put_line('-------------------------------------------------------');
dbms_output.put_line('If a query returns "no rows selected" index is sane');
dbms_output.put_line('If a query returns '||trowid||' index is corrupted');
dbms_output.put_line('..................................................');


dbms_output.put_line('.');
dbms_output.put_line('To test  '||un||'.'||tn||' indexes ') ;
dbms_output.put_line('.');
for rpindexes in  pindexes(un,tn) loop
dbms_output.put_line('.');
dbms_output.put_line('To test  INDEX '||rpindexes.INDEX_NAME||' you run :' );
dbms_output.put_line('.');
dbms_output.put_line('select rowid "'||rpindexes.INDEX_NAME||' corrupted!" 
from ');
dbms_output.put_line(
'(SELECT /*+ INDEX_FFS('||tn||','||rpindexes.INDEX_NAME||') */ ');
dbms_output.put_line(
                      rpindexes.COLUMN_NAME||',rowid from '||
                      un||'.'||tn||' where '||
                      rpindexes.COLUMN_NAME||'='||rpindexes.COLUMN_NAME||') ' );
dbms_output.put_line( 'where rowid='''||trowid||''';'||' ');
end loop ;
END;
/