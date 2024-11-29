set echo  off
set lines 250 pages 1000 heading on verify off;
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
 
                 SELECT /*+ rule*/
&_VERSION_12     b.name, 
                 a.OWNER, a.TABLE_NAME
                   FROM 
&_VERSION_12      cdb_LOGSTDBY_NOT_UNIQUE a, v$containers b
&_VERSION_11      dba_logstdby_not_unique a                   
                  WHERE (
&_VERSION_12      a.con_id, 
                  OWNER, TABLE_NAME) NOT IN
                   (SELECT DISTINCT 
&_VERSION_12      con_id, 
						      OWNER, TABLE_NAME
                   FROM 
&_VERSION_12      cdb_LOGSTDBY_UNSUPPORTED
&_VERSION_11			dba_LOGSTDBY_UNSUPPORTED  
                   )
                    and owner not in ('APEX_040200')
                    AND BAD_COLUMN = 'Y'
&_VERSION_12       and a.con_id = b.con_id
/
set lines 78