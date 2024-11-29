set echo off
set echo off
set verify off
set serveroutput on
set feedback off
set lines 200
set pages 1000
col df_file# for 9999 heading 'FILE#'
col df_tablespace for a15 heading 'TABLESPACE'
col bs_key for 99999 heading 'BACKUP|KEY'
col bs_type for a10 heading 'BS|TYPE'
col bs_incr_type for a10 heading  'BACKUP|TYPE'
col bs_status for a15 heading 'BACKUP|STATUS'
col t_date for a19 heading 'COMPLETION TIME'
col bs_device_type for a10 heading 'BACKUP|DEVICE'
col fname for a70 heading 'DATAFILE_NAME'
col t_size for a10 heading 'BACKUP_SET|SIZE(G)'
ACCEPT file_id prompt 'Enter Search Datafile Id (i.e. 123|default all) : ' default '0'
ACCEPT tablespace prompt 'Enter Search Tablespace Name(i.e. SYSTEM|default all) : ' default ''
select df_file#,
       df_tablespace,
       a.bs_key,
       bs_incr_type,
       bs_status,
       to_char(bs_completion_time, 'yyyy-mm-dd hh24:mi:ss') t_date,
       round(bs_bytes / 1024 / 1024 / 1024, 2)||'G' t_size,
       bs_device_type,
       bs_pieces,
       bs_copies,
       a.fname
  from v$backup_files a
 where fname is not null
   and a.df_file# is not null
   and bs_type = 'DATAFILE'
   and a.df_tablespace is not null
   and df_file# = decode(&file_id,0,df_file#,&file_id)
   and df_tablespace = nvl(upper('&tablespace'), df_tablespace)
 order by bs_key desc, df_tablespace, df_file#
/
clear    breaks  
