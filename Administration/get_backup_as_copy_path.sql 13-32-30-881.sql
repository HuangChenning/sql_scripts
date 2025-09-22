  SELECT    'backup as copy datafile '
         || file_id
         || ' format='
         || CHR (39)
         || '/tmp/'
         || LOWER (TABLESPACE_NAME)
         || ROW_NUMBER () OVER (PARTITION BY tablespace_name ORDER BY file_id)
         || '.dbf'
         || CHR (39)
         || ';'
    FROM dba_data_files
ORDER BY file_id DESC;


tonda
