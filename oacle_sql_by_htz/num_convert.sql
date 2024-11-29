PROMPT  '********************************************************'
PROMPT  'function hex_to_dec (hexin IN VARCHAR2) return NUMBER;  '                 
PROMPT  'function dec_to_hex (decin IN NUMBER) return VARCHAR2;  '                 
PROMPT  'function oct_to_dec (octin IN NUMBER) return NUMBER;    '                 
PROMPT  'function dec_to_oct (decin IN NUMBER) return VARCHAR2;  '                 
PROMPT  'function bin_to_dec (binin IN NUMBER) return NUMBER;    '                 
PROMPT  'function dec_to_bin (decin IN NUMBER) return VARCHAR2;  '                 
PROMPT  'function hex_to_bin (hexin IN VARCHAR2) return NUMBER;  '                 
PROMPT  'function bin_to_hex (binin IN NUMBER) return VARCHAR2;  '                 
PROMPT  'function oct_to_bin (octin IN NUMBER) return NUMBER;    '                 
PROMPT  'function bin_to_oct (binin IN NUMBER) return NUMBER;    '                 
PROMPT  'function oct_to_hex (octin IN NUMBER) return VARCHAR2;  '                 
PROMPT  'function hex_to_oct (hexin IN VARCHAR2) return NUMBER;  '                 
PROMPT  '********************************************************'
set echo off
set verify off
set lines 200
set long 65535
select num_convert.&function(replace('&number',' ')) value from dual;
undefine function;
undefine number;