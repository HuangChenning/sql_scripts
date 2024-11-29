set echo off
set lines 3000 pages 100 verify off heading on
col t_t for a25 heading 'TABLESPACE|TABLE NAME'
col column_name for a20 heading 'COLUMN NAME'
col segment_name for a25 heading 'SEGMENT NAME'
col index_name for a24 heading 'INDEX NAME'
col chunk for 99999
col pctversion for a10 heading 'PCT|VERSION'
col retention for 9999999 heading 'RETENTION'
col cache for a5 
col logging for a5 heading 'LOG'
col partitioned for a4 heading 'PART'
col in_row for a6
col securefile for a6 heading 'SECURE'
undefine owner;
undefine tablename;
break on t_t
SELECT tablespace_name||'.'||table_name t_t,
       column_name,
       segment_name,
       index_name,
       chunk,
       pctversion,
       retention,
       in_row,
       cache,
       logging,
       partitioned
  FROM dba_lobs
 WHERE     owner = NVL (UPPER ('&owner'), owner)
       AND table_name = NVL (UPPER ('&tablename'), table_name);
undefine owner;
undefine tablename;
