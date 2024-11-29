set echo  off
set lines 250 pages 1000 heading on verify off;
col name for a10 heading 'DB_NAME'
col owner for a25
col table_name for a25
col column_name for a25
col data_type for a25

define _VERSION_12  = "--"
define _VERSION_11  = "--"


col version11  noprint new_value _VERSION_11
col version12  noprint new_value _VERSION_12


select case
         when
              substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) <
              '12.1.0.2.0' then
          '  '
         else
          '--'
       end  version11,
       case
         when substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) >=
              '12.1.0.2.0' then
          '  '
         else
          '--'
       end  version12
  from v$version
 where banner like 'Oracle Database%';
 
              select
&_VERSION_12  b.name, 
              a.owner
              from 
&_VERSION_12  v$containers b,cdb_logstdby_skip a
&_VERSION_11  dba_logstdby_skip a
              where a.statement_opt = 'INTERNAL SCHEMA' 
&_VERSION_12  and  a.con_id = b.con_id 
							order by 
&_VERSION_12	name, 
							owner
/
							select
&_VERSION_12  b.name, 
							a.owner, a.table_name, a.column_name, a.data_type
							from 
&_VERSION_12  cdb_logstdby_unsupported a, v$containers b
&_VERSION_11  dba_logstdby_unsupported a
&_VERSION_12  where a.con_id = b.con_id
/

set lines 78
