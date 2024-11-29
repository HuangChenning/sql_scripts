set echo off
store set sqlplusset replace
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000
break on o_t
col o_t for a30 heading 'OWNER|TABLE_NAME'
col column_name for a30 heading 'COLUMN_NAME'
col endpoint_value format 9999999999999999999999999999999999999
col endpoint_actual_value format a30
col histogram for a15
col differ for a15
SELECT h.owner || '.' || h.table_name o_t,
       h.column_name,
       h.ENDPOINT_NUMBER,
       (case
         when s.histogram = 'FREQUENCY' then
          to_char((h.endpoint_number - lag(endpoint_number, 1, 0)
                   over(partition by h.column_name order by endpoint_number)),
                  '99999999999999')
          when s.histogram='HEIGHT BALANCED' then 'HEIGHT BALANCED'
         else
          'NO HISTOGRAM'
       end) as differ,
       h.ENDPOINT_VALUE,
       h.endpoint_actual_value,
       s.HISTOGRAM
  FROM dba_tab_histograms h, dba_tab_col_statistics s
 WHERE h.owner = NVL(UPPER('&tableowner'), h.owner)
   AND h.table_name = NVL(UPPER('&tablename'), h.table_name)
   AND h.column_name = NVL(UPPER('&columnname'), h.column_name)
   and h.owner = s.owner
   and h.table_name = s.table_name
   and h.column_name = s.column_name
 ORDER BY o_t, column_name, endpoint_number
/
clear    breaks  
@sqlplusset

