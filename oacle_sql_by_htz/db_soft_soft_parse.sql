set echo off
set lines 300
set pages 40
col cursor_cache_hits format a20 truncate;
col soft_parses format a20 truncate;
col hard_parses format a20 truncate;


select to_char(100 * sess / calls, '9999990.00') || '%' cursor_cache_hits,
       to_char(100 * (calls - sess - hard) / calls, '999990.00') || '%' soft_parses,
       to_char(100 * hard / calls, '999990.00') || '%' hard_parses
  from (select value calls from v$sysstat where name = 'parse count (total)'),
       (select value hard from v$sysstat where name = 'parse count (hard)'),
       (select value sess
	          from v$sysstat
		         where name = 'session cursor cache hits');
set echo on
