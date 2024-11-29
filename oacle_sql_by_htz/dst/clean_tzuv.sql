-- clean_tzuv.sql
--
-- Used to clean up the backup tables after restoring their values after
-- installing new time zone files.
-- See Oracle MetaLink note 756474.1 for more information.
--
--
-- Replace the 'execute immediate' statements with 'dbms_output.put_line'
-- statements if you like to only generate the statements for review and later use.
--
-- Typical output:
-- SQL> @clean_tzuv.sql
-- Backup table SCOTT.BACKUP_37900_2 dropped.
-- Table SYS.SYS_TZUV2_TEMPTAB dropped.
-- Table SYS.SYS_TZUV2_AFFECTED_REGIONS dropped.
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
    stmt := 'DROP TABLE ' || r1.table_owner || '.BACKUP_';
    stmt := stmt || r1.object_id || '_' || r1.column_id;
    execute immediate stmt;
    ln := 'Backup table ' || r1.table_owner || '.BACKUP_';
    ln := ln || r1.object_id || '_' || r1.column_id || ' dropped.';
    dbms_output.put_line (ln);
  end loop;
  execute immediate 'drop table sys.sys_tzuv2_temptab';
  dbms_output.put_line ('Table SYS.SYS_TZUV2_TEMPTAB dropped.');
  execute immediate 'drop table sys.sys_tzuv2_affected_regions';
  dbms_output.put_line ('Table SYS.SYS_TZUV2_AFFECTED_REGIONS dropped.');
end;
/