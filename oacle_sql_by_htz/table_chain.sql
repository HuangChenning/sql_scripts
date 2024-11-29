
prompt List Tables with > 5 % chained rows and > 500 total rows
  SELECT owner,
         table_name,
         pct_free,
         ROUND (100 * chain_cnt / num_rows, 0) chain_pct
    FROM sys.dba_all_tables
   WHERE ROUND (100 * chain_cnt / num_rows, 0) > 5
         AND owner NOT IN
                ('SYS',
                 'SYSTEM',
                 'SYSMAN',
                 'EXFSYS',
                 'WMSYS',
                 'OLAPSYS',
                 'OUTLN',
                 'DBSNMP',
                 'ORDSYS',
                 'ORDPLUGINS',
                 'MDSYS',
                 'CTXSYS',
                 'AURORA$ORB$UNAUTHENTICATED',
                 'XDB',
                 'FLOWS_030000',
                 'FLOWS_FILES')
         AND num_rows IS NOT NULL
         AND num_rows > 500
ORDER BY 1, 2
/

prompt List Table Partitions with > 5 % chained rows and > 500 total rows

  SELECT table_owner,
         table_name,
         partition_name,
         pct_free,
         ROUND (100 * chain_cnt / num_rows, 0) chain_pct
    FROM sys.dba_tab_partitions
   WHERE ROUND (100 * chain_cnt / num_rows, 0) > 5
         AND table_owner NOT IN
                ('SYS',
                 'SYSTEM',
                 'SYSMAN',
                 'EXFSYS',
                 'WMSYS',
                 'OLAPSYS',
                 'OUTLN',
                 'DBSNMP',
                 'ORDSYS',
                 'ORDPLUGINS',
                 'MDSYS',
                 'CTXSYS',
                 'AURORA$ORB$UNAUTHENTICATED',
                 'XDB',
                 'FLOWS_030000',
                 'FLOWS_FILES')
         AND num_rows IS NOT NULL
         AND num_rows > 500
ORDER BY 1, 2
/
