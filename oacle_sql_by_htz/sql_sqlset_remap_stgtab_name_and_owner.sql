set echo off
set lines 2000 pages 2000 verify off heading on
/* Formatted on 2014/9/11 21:37:08 (QP5 v5.240.12305.39446) */
DECLARE                                                       
   v_old_sqlset_name       VARCHAR2 (100);                    
   v_old_sqlset_owner      VARCHAR2 (100);                    
   v_new_sqlset_name       VARCHAR2 (100);                    
   v_new_sqlset_owner      VARCHAR2 (100);                    
   v_staging_table_name    VARCHAR2 (100);                    
   v_taging_schema_owner   VARCHAR2 (100);                    
BEGIN                                                         
   v_old_sqlset_name := '&old_sqlset_name';                   
   v_old_sqlset_owner := UPPER ('&old_sqlset_owner');          
   v_new_sqlset_name := '&new_sqlset_name';                   
   v_new_sqlset_owner := UPPER ('&new_sqlset_owner');         
   v_staging_table_name := '&staging_table_name';             
   v_taging_schema_owner := UPPER ('&taging_schema_owner');   
                                                              
   DBMS_SQLTUNE.REMAP_STGTAB_SQLSET (                         
      old_sqlset_name       => v_old_sqlset_name,             
      old_sqlset_owner      => v_old_sqlset_owner,            
      new_sqlset_name       => v_new_sqlset_name,             
      new_sqlset_owner      => v_new_sqlset_owner,            
      staging_table_name    => v_staging_table_name,          
      taging_schema_owner   => v_taging_schema_owner);        
END;                                                          
/                                                             