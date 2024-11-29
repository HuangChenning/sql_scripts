-- restore_tzuv.sql
--
-- Used to restore timestamp data backed up before new time zone files are installed
-- See Oracle MetaLink note 756474.1 for more information.
--
--
-- Replace the 'execute immediate' statements with 'dbms_output.put_line'
-- statements if you like to only generate the statements for review and later use.
--
-- Typical output:
-- SQL> @restore_tzuv.sql
-- 2 row(s) in column SCOTT.TZTAB1(Y) updated.
--
-- PL/SQL procedure successfully completed.
--
set serveroutput on
declare
  stmt varchar2(1000);
  ln varchar2(1000);
  cursor c1 is select z.table_owner,
                      z.table_name,
                      z.column_name,
                      c.column_id,
                      o.object_id
                 from sys.sys_tzuv2_temptab z,
                      dba_tab_cols c,
                      dba_objects o
                where z.NESTED_TAB not in ('YES')
                  and z.table_owner not in ('SYS')
                  and o.object_name = z.table_name
                  and o.object_type = 'TABLE'
                  and o.owner = z.table_owner
                  and z.table_owner = c.owner
                  and z.table_name = c.table_name
                  and z.column_name= c.column_name;
begin
  for r1 in c1 loop
    stmt := 'UPDATE ' || r1.table_owner || '.' || r1.table_name || ' T ';
    stmt := stmt || 'SET T.' || r1.column_name||'=(SELECT TO_TIMESTAMP_TZ';
    stmt := stmt || '(T1.SAVED_VALUE, ''YYYY-MM-DD HH24:MI:SSXFF TZR'') FROM ';
    stmt := stmt || r1.table_owner || '.BACKUP_' || r1.object_id || '_';
    stmt := stmt || r1.column_id || ' T1 WHERE T.ROWID=T1.ORIG_ROWID) ';
    stmt := stmt || 'WHERE EXISTS (SELECT ORIG_ROWID FROM ' || r1.table_owner ;
    stmt := stmt || '.BACKUP_' || r1.object_id || '_'|| r1.column_id;
    stmt := stmt || ' T1 WHERE T.ROWID=T1.ORIG_ROWID)';
    execute immediate stmt;
    ln := SQL%ROWCOUNT || ' row(s) in column ' || r1.table_owner || '.';
    ln := ln || r1.table_name || '(' || r1.column_name || ') updated.';
    dbms_output.put_line (ln);
  end loop;
end;
/