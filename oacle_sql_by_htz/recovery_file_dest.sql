 set echo off
 set lines 300
 set pages 40
 col reclaimable for a20
 COL used for a20
 COL QUOTA FOR A20
 COL NAME FOR A30
col used1 for 99999 heading 'USED%';
SELECT substr(name, 1, 30) name, round(space_limit/1024/1024)||'M' AS quota,
       round(space_used/1024/1024)||'M'        AS used,round(100*space_used/space_limit) used1,
       round(space_reclaimable/1024/1024)||'M' AS reclaimable,
        number_of_files   AS files
  FROM  v$recovery_file_dest 
  /
Select file_type, percent_space_used,percent_space_reclaimable, 
    number_of_files as "number" from v$flash_recovery_area_usage
/

