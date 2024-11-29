set echo off
@sql_outline.sql
set long for 200000

PROMPT ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
PROMPT attribute_name                                                ;
PROMPT                                                               ;
PROMPT outline_name                                                  ;
PROMPT sql_text                                                      ;
PROMPT category                                                      ;
PROMPT all                                                           ;
PROMPT                                                               ;
PROMPT attribute_value                                               ;
PROMPT Based on attribute_name, this can be:                         ;
PROMPT Name of stored outline to be migrated                         ;
PROMPT SQL text of stored outlines to be migrated                    ;
PROMPT Category of stored outlines to be migrated                    ;
PROMPT NULL if attribute_name is all                                 ;
PROMPT ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;

var rpt clob;
exec :rpt := dbms_spm.migrate_stored_outline(attribute_name => '&attribute_name', attribute_value => '&value');
select :rpt report from dual;
undefine attribute_name;
undefine value;
