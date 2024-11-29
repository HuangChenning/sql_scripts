set echo off
set feedback off heading on verify off
set linesize 512
set pages 1000
col CYCLE_FLAG for a10
col ORDER_FLAG for a10
prompt
prompt All Sequences in Database
prompt
ACCEPT owner prompt 'Enter Search Sequence Owner (i.e. DEPT|ALL(DEFAULT)) : ' default ''
ACCEPT name prompt 'Enter Search Sequence Name (i.e. DEPT|ALL(DEFAULT)) : '   default ''
break on SEQUENCE_OWNER skip 1

SELECT	 SEQUENCE_OWNER, SEQUENCE_NAME, MIN_VALUE, MAX_VALUE, INCREMENT_BY,
		 DECODE (CYCLE_FLAG, 'Y', 'YES', 'N', 'NO') CYCLE_FLAG,
		 DECODE (ORDER_FLAG, 'Y', 'YES', 'N', 'NO') ORDER_FLAG, CACHE_SIZE,
		 LAST_NUMBER
	FROM DBA_SEQUENCES 
	WHERE SEQUENCE_OWNER NOT IN ('SYS','SYSTEM','OUTLN','DBSNMP')
	and sequence_owner=nvl(upper('&owner'),sequence_owner) and sequence_name=nvl(upper('&name'),sequence_name)
ORDER BY 1, 2; 