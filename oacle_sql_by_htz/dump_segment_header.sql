set echo off;
set lines 200;
set pages 40;
set verify off;
set serveroutput on;

DECLARE
  p_tablespace   varchar2(50);
  p_header_file  number;
  p_header_block number;
  p_owner        varchar2(50);
  p_segname      varchar2(60);
  p_dump_type    number;
begin
  p_owner   := upper('&sgment_owner');
  p_segname := upper('&segment_name');
  p_dump_type := nvl('&type_number',null);
  execute immediate 'select tablespace_name, header_file, header_block 
    from dba_segments s 
    where owner=:seg_owner and segment_name=:seg_name'
    into p_tablespace, p_header_file, p_header_block
    using p_owner, p_segname;

  if p_dump_type = 5 then
    dbms_space_admin.segment_dump(p_tablespace,
                                  p_header_file,
                                  p_header_block,
                                  p_dump_type);
  else
    execute immediate 'alter system dump datafile ' || p_header_file ||
                      ' block ' || p_header_block;
  end if;
end;
/
@sess_current_trace_file_location.sql 