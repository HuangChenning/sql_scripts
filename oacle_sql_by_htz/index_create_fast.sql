alter session set workarea_size_policy=MANUAL;
alter session set db_file_multiblock_read_count=512;
alter session set events '10351 trace name context forever, level 128';
alter session set sort_area_size=2147483648;
alter session set "_sort_multiblock_read_count"=128;
alter session enable parallel ddl;
alter session enable parallel dml;
set timing on
