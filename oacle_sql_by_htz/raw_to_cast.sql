set echo off
set lines 200
set heading on
set pages 40
PROMPT CAST_TO_BINARY_DOUBLE 
PROMPT CAST_TO_BINARY_FLOAT 
PROMPT CAST_TO_BINARY_INTEGER 
PROMPT CAST_TO_NUMBER 
PROMPT CAST_TO_RAW 
PROMPT CAST_TO_VARCHAR2 
PROMPT CAST_TO_NVARCHAR2    
undefine type;
SELECT utl_raw.cast_to_&type(replace(replace('&value',',',''),' ')) value FROM dual;
undefine type;
