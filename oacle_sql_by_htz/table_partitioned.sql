set echo off
set feedback off
set linesize 512
set pages 20000
prompt
prompt All Table Partitions in Database
prompt

break on TABLE_OWNER on TABLE_NAME skip 1

SELECT	 TABLE_OWNER, TABLE_NAME, TABLESPACE_NAME,
		 PARTITION_NAME, PARTITION_POSITION,
		 LOGGING, HIGH_VALUE, PCT_FREE,
		 PCT_USED, INI_TRANS, MAX_TRANS,
		 INITIAL_EXTENT, NEXT_EXTENT,
		 MAX_EXTENT, PCT_INCREASE
	FROM SYS.DBA_TAB_PARTITIONS where table_owner not in ('SYS','SYSMAN','SYSTEM')
ORDER BY TABLE_OWNER, TABLE_NAME, PARTITION_POSITION;
