set echo off
set verify off
set heading on
set lines 200
set pages 40
undefine data_object_id;
undefine relative_fno;
undefine block_number
undefine row_number;
select dbms_rowid.ROWID_CREATE(1,&data_object_id,&relative_fno,&block_number,nvl('&row_number',0)) as "ROWID" from dual;
undefine data_object_id;
undefine relative_fno;
undefine block_number
undefine row_number;