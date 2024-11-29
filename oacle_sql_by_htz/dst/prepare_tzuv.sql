-- prepare_tzuv.sql
--
-- Used to create and populate backup tables after running utltzuvX.sql
-- See Oracle MetaLink note 756474.1 for more information.
--
--
-- Replace the 'execute immediate' statements with 'dbms_output.put_line'
-- statements if you like to only generate the statements for review and later use.
--
-- Typical output:
-- SQL> @prepare_tzuv.sql
-- Backup table SCOTT.BACKUP_37900_2 for SCOTT.TZTAB1(Y) created, 5 row(s) inserted.
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
    stmt := 'CREATE TABLE '|| r1.table_owner || '.' || 'BACKUP_';
    stmt := stmt || r1.object_id || '_' || r1.column_id || ' (ORIG_ROWID ';
    stmt := stmt || 'ROWID PRIMARY KEY, SAVED_VALUE VARCHAR2(256))';
    execute immediate stmt;
    ln := 'Backup table ' || r1.table_owner || '.' || 'BACKUP_';
    ln := ln || r1.object_id || '_' || r1.column_id || ' for ' || r1.table_owner;
    ln := ln || '.' || r1.table_name || '(' || r1.column_name || ') created';
    dbms_output.put (ln);
    stmt := 'INSERT INTO ' || r1.table_owner || '.' || 'BACKUP_' || r1.object_id;
    stmt := stmt || '_' || r1.column_id || ' SELECT ROWID, TO_CHAR(' ;
    stmt := stmt || r1.column_name || ', ''YYYY-MM-DD HH24:MI:SSXFF TZR'') ';
    stmt := stmt || 'FROM ' || r1.table_owner || '.' || r1.table_name||' WHERE ';
    stmt := stmt || 'UPPER(TO_CHAR(' || r1.column_name || ',''TZR'')) ';
    stmt := stmt || 'IN (SELECT UPPER(TIME_ZONE_NAME) FROM ';
    stmt := stmt || 'SYS.SYS_TZUV2_AFFECTED_REGIONS)';
    execute immediate stmt;
    dbms_output.put_line (', ' || SQL%ROWCOUNT || ' row(s) inserted.');
  end loop;
end;
/