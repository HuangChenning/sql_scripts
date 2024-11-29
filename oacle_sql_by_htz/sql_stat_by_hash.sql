set echo off                                                                        
set verify off                                                                      
set serveroutput on                                                                 
set feedback off                                                                    
set lines 300                                                                       
set pages 10000                                                                     
set long 100000                                                                     
col i_mem for 999999 heading 'SHARED|Mem KB'                                        
col sorts for 99999999                                                              
col version_count for 999 heading 'VER|NUM'                                         
col loaded_versions for 999 heading 'Loaded|NUM'                                    
col open_versions for 999 heading 'Open|NUM'                                        
col executions for 99999999 heading 'EXEC|NUM'                                        
col parse_calls for 99999999 heading 'PARSE|CALLS'                                    
col disk_reads for 99999999 heading 'DISK|READ'                                       
col direct_writes for 999999 heading 'DIRECT|WRITE'                                 
col buffer_gets for 99999999999999                                                  
col avg_disk_read for 99999 heading 'AVG|DISK|READ'                                 
col avg_direct_write for 99999 heading 'AVG|DIRECT|WRITE'                           
col avg_buffer_get for 9999999 heading 'AVG|BUFFER|GET'                             
col sql_profile for a14                                                             
col ROWS_PROCESSED for 999999999 heading 'ROW|PROC'                                 
col avg_row_proc for 99999999 heading 'AVG|ROW|PROC'                                
col sql_id for a17                                                                  
col sql_fulltext for a150                                                           
col username for a15 heading 'PARSING|USER_NAME'
select sql_text from v$sqlarea where hash_value=&&hashvalue;    
                                                                                    
set pages 40                                                                        
SELECT round(sharable_mem / 1024, 2) i_mem,                                         
       sorts,                                                                       
       version_count,                                                               
       loaded_versions,                                                             
       OPEN_VERSIONS,                                                               
       executions,                                                                  
       PARSE_CALLS,                                                                 
       disk_reads,                                                                  
       trunc(disk_reads / decode(EXECUTIONS, 0, 1, EXECUTIONS)) avg_disk_read,      
       buffer_gets,                                                                 
       trunc(buffer_gets / decode(EXECUTIONS, 0, 1, EXECUTIONS)) avg_buffer_get,    
       ROWS_PROCESSED,                                                              
       trunc(ROWS_PROCESSED / decode(EXECUTIONS, 0, 1, EXECUTIONS)) avg_row_proc
  FROM v$sqlarea                                                                    
 where hash_value = &&hashvalue                                                          
/                                                                                   
col c_p for a16 heading 'CHILD_NUMBER|PLAN_HASH_VALUE'                              
col PARSING_SCHEMA_NAME for a15 heading 'USER_NAME'                                 
col USERS_OPENING for 9999 heading 'USER|DOING'                                     
col time for a15 heading 'AVG_TIME'                                                 
SELECT username,                                                         
       CHILD_NUMBER || ':' || plan_hash_value c_p,                                  
       round(sharable_mem / 1024, 2) i_mem,                                         
       sorts,                                                                       
       USERS_OPENING,                                                               
       executions,                                                                  
       PARSE_CALLS,                                                                 
       disk_reads,                                                                  
       trunc(disk_reads / decode(EXECUTIONS, 0, 1, EXECUTIONS)) avg_disk_read,      
       buffer_gets,                                                                 
       trunc(buffer_gets / decode(EXECUTIONS, 0, 1, EXECUTIONS)) avg_buffer_get,    
       ROWS_PROCESSED,                                                              
       trunc(ROWS_PROCESSED / decode(EXECUTIONS, 0, 1, EXECUTIONS)) avg_row_proc,   
       trunc(CPU_TIME / decode(EXECUTIONS, 0, 1, EXECUTIONS)) || ':' ||             
       trunc(ELAPSED_TIME / decode(EXECUTIONS, 0, 1, EXECUTIONS)) time             
  FROM v$sql   a,dba_users b                                                                      
 where hash_value = &&hashvalue   and a.PARSING_SCHEMA_ID=b.user_id                                                        
/                                                                                   
undefine hashvalue 