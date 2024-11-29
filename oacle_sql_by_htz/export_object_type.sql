PROMPT  "DATABASE_EXPORT_OBJECTS for full mode,             ";
PROMPT  "SCHEMA_EXPORT_OBJECTS for schema mode,             ";
PROMPT  "TABLE_EXPORT_OBJECTS for table and tablespace mode.";
set echo off
set lines 300 pages 1000  heading on verify off
col named for a5
col object_path for a70
col comments for a70
select named, object_path, comments
  from &type_export_objects        
 where object_path NOT LIKE '%/%'  
    or named = 'Y' order by object_path;                


         