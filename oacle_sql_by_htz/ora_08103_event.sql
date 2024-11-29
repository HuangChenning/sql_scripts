alter session set max_dump_file_size=unlimited;
alter session set db_file_multiblock_read_count=1;
alter session set events 'immediate trace name trace_buffer_on level 1048576';
alter session set events '10200 trace name context forever, level 1';
alter session set events '8103 trace name errorstack level 3';
alter session set events '10236 trace name context forever, level 1';
oradebug setmypid;
oradebug tracefile_name;
