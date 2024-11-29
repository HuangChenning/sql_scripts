set feedback off  
set head off  
set echo off  
set linesize 200  
set pagesize 2500  
spool &sh_file_name  
SELECT    'echo  '
       || name
       || CHR (10)
       || 'dbv file='
       || name
       || ' blocksize='
       || block_size
       || ' end='
       || (bytes / block_size)
       || ' logfile='
       || SUBSTR (name,
                    INSTR (name,
                           '/',
                           -1,
                           1)
                  + 1)
       || '.'
       || file#
       || '.log'
  FROM v$datafile;
spool off  
