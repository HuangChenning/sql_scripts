set echo off
set lines 200 pages 2000 verify off heading on
SELECT cpu_count AS cpu#,
       cpu_core_count AS core#,
       cpu_socket_count AS socket#,
       cpu_count_hwm AS cpu_hwm,
       cpu_core_count_hwm AS core_hwm,
       cpu_socket_count_hwm AS socket_hwm
  FROM x$ksull;
 