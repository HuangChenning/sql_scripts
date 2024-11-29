set echo off
set lines 300 pages 100 verify off heading on 
PROMPT "set longchunksize 30000"
PROMPT "Select GET_CLOB( <CLOB_COLUMN> , 1 , dbms_lob.getlength(<CLOB_COLUMN>))  from Table_name ;"