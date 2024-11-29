set echo off
set verify off
set lines 170
set pages 100
col property_name for a40
col property_value for a40
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display default user tablespace,default temp tablespace ,tb type       |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
SELECT property_name,property_value FROM database_properties WHERE property_name LIKE 'DEFAULT%';
