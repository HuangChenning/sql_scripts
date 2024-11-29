SET serveroutput on SIZE 1000000  
exec show_dumpfile_info(p_dir=> '&directory', p_file=> '&dumpfile')  
