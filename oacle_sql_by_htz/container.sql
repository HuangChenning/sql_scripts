set echo off
set lines 200 pages 1000 verify off heading on
col i                      for    a1
col cid                     for    a1
col name                   for    a15
col logging                for    a15    heading 'LOGGING|FORCE|NO FORCE'
col open_mode              for    a10
col open_time              for    a19
col tsize                   for    999999 heading 'SIZE_G'
col recovery_status        for    a10
col status                 for    a10
col save_status            for    a10
break on i on id on name on logging
undefine con_name;
SELECT trim(b.INST_ID) i,
       trim(b.con_id) cid,
       b.name  name,
       a.logging||'.'||a.force_logging||'.'||force_nologging logging,
       b.open_mode,
       a.status,
       to_char(open_time,'yyyy-mm-dd hh24:mi:ss') open_time,
       trunc(b.total_size/1024/1024/1024) tsize,
       b.recovery_status
FROM dba_pdbs a,
     gv$containers b
WHERE a.pdb_name(+)=b.name
  AND a.dbid(+)=b.dbid
  AND a.guid(+)=b.guid
 /
undefine con_name;
alter session set container=&con_name;
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
undefine con_name;
set heading on
set termout on