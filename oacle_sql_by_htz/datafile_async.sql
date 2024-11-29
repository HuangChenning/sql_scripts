set echo off
set lines 300
set pages 50
set heading on
set verify off
col file_no for 99999 heading 'FILE|NO'
col name for a60 heading 'FILE|NAME'
col filetype_name for a20 heading 'TYPE|NAME'
col asynch_io for a10 heading 'ASYNC|YES/NO'
col access_method for a15 heading 'ACCESS|METHOD'
select a.file_no, b.NAME, a.filetype_name, a.asynch_io, a.access_method
  from v$iostat_file a, v$datafile b
 where a.file_no = b.file#(+);
