set echo off
set lines 250 pages 1000 heading on   verify off
col BS_FIN_TIME             for a19               heading 'FINSH_TIME'
col bs_tag                  for a19               heading 'TAG'
COL piece_name              for a30               heading 'HANDLE'
col backup_type             for a10
col bs_incr_type            FOR A10
col bs_status               for a10
col piece_size              for 9999
col bs_compressed           for a5                 heading 'COMP'
col df_tablespace           for a25                heading 'TABLESPACE'
col fname                   for a70                heading 'DATAFILE NAME'
undefine tablespace;
undefine fid;
undefine day;
break on bs_fin_time on bs_tag on piece_name on backup_type on bs_incr_type on bs_status on piece_size on bs_compressed on df_tablespace
SELECT TO_CHAR (a.bs_completion_time, 'yyyy-mm-dd hh24:mi:ss') bs_fin_time,
       a.bs_tag,
       c.handle                                                piece_name,
       a.backup_type,
       a.bs_incr_type,
       a.bs_status,
       TRUNC (c.bytes / 1024 / 1024 / 1024)                    piece_size,
       a.bs_compressed,
       a.df_tablespace,
       a.fname
  FROM v$backup_files a, v$backup_piece c
 WHERE     a.file_type = 'DATAFILE'
       AND a.bs_stamp = c.set_stamp
       AND a.bs_count = c.set_count
       AND a.df_tablespace = NVL (UPPER ('&tablespace'), a.df_tablespace)
       AND a.df_file# = NVL ('&fid', a.df_file#)
       AND c.start_time > SYSDATE - NVL ('&day', 1000)
  ORDER BY 1,2
  /

undefine tablespace;
undefine fid;
undefine day;
