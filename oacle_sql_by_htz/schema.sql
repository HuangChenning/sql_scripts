define _VERSION_11  = "--"
define _VERSION_10  = "--"
define _CLIENT_MODE = "  "
define _LONG_MODE   = "  "
define _VERSION_12  = "--"
alter session set current_schema=&username;
col version12  noprint new_value _VERSION_12
col version11  noprint new_value _VERSION_11
SELECT /*+ no_parallel */
      CASE
          WHEN     SUBSTR (
                      banner,
                      INSTR (banner, 'Release ') + 8,
                      INSTR (SUBSTR (banner, INSTR (banner, 'Release ') + 8),
                             ' ')) >= '10.2'
               AND SUBSTR (
                      banner,
                      INSTR (banner, 'Release ') + 8,
                      INSTR (SUBSTR (banner, INSTR (banner, 'Release ') + 8),
                             ' ')) < '12.1'
          THEN
             '  '
          ELSE
             '--'
       END
          version11,
       CASE
          WHEN SUBSTR (
                  banner,
                  INSTR (banner, 'Release ') + 8,
                  INSTR (SUBSTR (banner, INSTR (banner, 'Release ') + 8),
                         ' ')) >= '12.1'
          THEN
             '  '
          ELSE
             '--'
       END
          version12
  FROM v$version
 WHERE banner LIKE 'Oracle Database%';
undefine con_name;
define proname=idle
col proname new_value sqlproname
set heading off
set termout off
col proname noprint
select upper(sys_context('userenv','current_schema'))
&_VERSION_12 ||'@'||upper(sys_context('userenv','con_name'))||'@'||upper(sys_context('userenv','cdb_name'))
&_VERSION_11 ||'@'||upper(sys_context('userenv','db_name'))
  proname from dual;
set sqlprompt '&sqlproname> '
undefine username;
set heading on
set termout on