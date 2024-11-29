col owner for a15  
col table_name for a30
col partition_name for a15
set linesize 200 pagesize 1400
   
SELECT table_owner,
       TABLE_NAME,
       PARTITION_NAME,
       trunc(BLOCKS * (select value
                         from v$system_parameter
                        where name = 'db_block_size') / 1024 / 1024) "BLOCK*SIZE(M)",
       trunc(NUM_ROWS * AVG_ROW_LEN / 1024 / 1024) "NUM_ROWS*AVG",
       trunc((BLOCKS * (select value
                          from v$system_parameter
                         where name = 'db_block_size') / 1024 / 1024) -
             (NUM_ROWS * AVG_ROW_LEN / 1024 / 1024)) "Delta MB",
       round(((BLOCKS * (select value
                           from v$system_parameter
                          where name = 'db_block_size') / 1024 / 1024) -
             (NUM_ROWS * AVG_ROW_LEN / 1024 / 1024)) /
             (BLOCKS * (select value
                          from v$system_parameter
                         where name = 'db_block_size') / 1024 / 1024) * 100,
             2) "FREE%"
  FROM dba_tab_partitions
 WHERE UPPER(table_owner) not in ('SYS',
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
                                  'FLOWS_FILES',
                                  'APEX_040100',
                                  'DVSYS',
                                  'GSMADMIN_INTERNAL',
                                  'OJVMSYS',
                                  'ORDDATA',
                                  'LBACSYS')
   and BLOCKS > 0
 order by 6;
