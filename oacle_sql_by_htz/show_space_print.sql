set serveroutput on
exec show_space(p_segname=>upper('&name'),P_OWNER=>upper('&owner'),P_TYPE=>upper('&type'));
