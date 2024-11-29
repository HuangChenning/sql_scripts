set echo off
set lines 250 pages 10000 heading on verify off
col file_name for a60
col thread# for 99 heading 'T'
col sequence# for 9999999
col timestamp for a14
col dict_begin for a5 heading 'BEGIN'
col dict_end for a3 heading 'END'
col bsize for 9999 heading 'size(M)'
col change_scn for a25 heading 'FIRST_NEXT_CHANGE#'
select file_name,
       THREAD#,
       sequence#,
       first_change#||'.'||next_change# change_scn,
       to_char(timestamp,'mm-dd hh24:mi:ss') timestamp,
       dict_begin,
       dict_end,
       applied,
       trunc(blocks*block_size/1024/1024) bsize
  from dba_logstdby_log
 order by sequence#
/
set lines 78