set lines 200
set echo off
set verify off
col curtime for a8
col sess for a20
col object_name for a20
col instance_name for a8
col lmode for a25
col sql_id for a20
col lo_type for a35 heading 'TYPE'
col id1-id2 for a10
col lock_object for a40
col sqlid for a17 heading 'SQL_ID|SQL_CHILD_NUMBER'
col command for a10
set pages 200
set heading on
prompt
prompt +----------------------------------------------------------------------------+
prompt | DISPLAY SESSION LOCK INFO                                                  |
prompt +----------------------------------------------------------------------------+
prompt
PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | INPUT SESSION ID                                                       |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT sid prompt 'Enter Search Sid (i.e. 123|0(ALL)) : '

/* Formatted on 2012-11-12 10:25:37 (QP5 v5.185.11230.41888) */
  SELECT TO_CHAR (SYSDATE, 'hh24:mi:ss') AS curtime,
          c.instance_name
         || ':'
         || a.sid
            sess,
         DECODE (b.command,
                 0, 'BACKGROUND',
                 1, 'Create Table',
                 2, 'INSERT',
                 3, 'SELECT',
                 4, 'CREATE CLUSTER',
                 5, 'ALTER CLUSTER',
                 6, 'UPDATE',
                 7, 'DELETE',
                 8, 'DROP',
                 9, 'CREATE INDEX',
                 10, 'DROP INDEX',
                 11, 'ALTER INDEX',
                 12, 'DROP TABLE',
                 13, 'CREATE SEQUENCE',
                 14, 'ALTER SEQUENCE',
                 15, 'ALTER TABLE',
                 16, 'DROP SEQUENCE',
                 17, 'GRANT',
                 18, 'REVOKE',
                 19, 'CREATE SYNONYM',
                 20, 'DROP SYNONYM',
                 21, 'CREATE VIEW',
                 22, 'DROP VIEW',
                 23, 'VALIDATE INDEX',
                 24, 'CREATE PROCEDURE',
                 25, 'ALTER PROCEDURE',
                 26, 'LOCK TABLE',
                 27, 'NO OPERATION',
                 28, 'RENAME',
                 29, 'COMMENT',
                 30, 'AUDIT',
                 31, 'NOAUDIT',
                 32, 'CREATE EXTERNAL DATABASE',
                 33, 'DROP EXTERNAL DATABASE',
                 34, 'CREATE DATABASE',
                 35, 'ALTER DATABASE',
                 36, 'CREATE ROLLBACK SEGMENT',
                 37, 'ALTER ROLLBACK SEGMENT',
                 38, 'DROP ROLLBACK SEGMENT',
                 39, 'CREATE TABLESPACE',
                 40, 'ALTER TABLESPACE',
                 41, 'DROP TABLESPACE',
                 42, 'ALTER SESSION',
                 43, 'ALTER USER',
                 44, 'COMMIT',
                 45, 'ROLLBACK',
                 46, 'SAVEPOINT',
                 47, 'PL/SQL EXECUTE',
                 48, 'SET TRANSACTION',
                 49, 'ALTER SYSTEM SWITCH LOG',
                 50, 'EXPLAIN',
                 51, 'CREATE USER',
                 52, 'CREATE ROLE',
                 53, 'DROP USER',
                 54, 'DROP ROLE',
                 55, 'SET ROLE',
                 56, 'CREATE SCHEMA',
                 57, 'CREATE CONTROL FILE',
                 58, 'ALTER TRACING',
                 59, 'CREATE TRIGGER',
                 60, 'ALTER TRIGGER',
                 61, 'DROP TRIGGER',
                 62, 'ANALYZE TABLE',
                 63, 'ANALYZE INDEX',
                 64, 'ANALYZE CLUSTER',
                 65, 'CREATE PROFILE',
                 66, 'DROP PROFILE',
                 67, 'ALTER PROFILE',
                 68, 'DROP PROCEDURE',
                 69, 'DROP PROCEDURE',
                 70, 'ALTER RESOURCE COST',
                 71, 'CREATE SNAPSHOT LOG',
                 72, 'ALTER SNAPSHOT LOG',
                 73, 'DROP SNAPSHOT LOG',
                 74, 'CREATE SNAPSHOT',
                 75, 'ALTER SNAPSHOT',
                 76, 'DROP SNAPSHOT',
                 79, 'ALTER ROLE',
                 85, 'TRUNCATE TABLE',
                 86, 'TRUNCATE CLUSTER',
                 87, '-',
                 88, 'ALTER VIEW',
                 89, '-',
                 90, '-',
                 91, 'CREATE FUNCTION',
                 92, 'ALTER FUNCTION',
                 93, 'DROP FUNCTION',
                 94, 'CREATE PACKAGE',
                 95, 'ALTER PACKAGE',
                 96, 'DROP PACKAGE',
                 97, 'CREATE PACKAGE BODY',
                 98, 'ALTER PACKAGE BODY',
                 99, 'DROP PACKAGE BODY',
                 b.command || ' - ???')
            COMMAND,
         DECODE (
            b.command,
            0, 'None',
            DECODE (a.id2,
                    0, d.NAME || '.' || SUBSTR (e.NAME, 1, 20),
                    'Rollback Segment'))
            OBJECT_NAME,
         DECODE (b.sql_hash_value, 0, b.prev_hash_value, b.sql_hash_value)
            hash_value,
         a.id1 || '-' || a.id2 "ID1-ID2",
         DECODE (a.lmode,
                 1, '1||No Lock',
                 2, '2||Row Share',
                 3, '3||Row Exclusive',
                 4, '4||Share',
                 5, '5||Shr Row Excl',
                 6, '6||Exclusive',
                 NULL)
            lmode,
--         DECODE (a.REQUEST,
 --                1, '1||No Lock',
--                 2, '2||Row Share',
--                 3, '3||Row Exclusive',
--                 4, '4||Share',
--                 5, '5||Shr Row Excl',
--                 6, '6||Exclusive',
--                 NULL)
--            REQUEST,
         DECODE (
            a.TYPE,
            'BL', 'BL||Buffer hash table instance lock',
            'CF', ' Control file schema global enqueue lock',
            'CI', 'Cross-instance function invocation instance lock',
            'CS', 'Control file schema global enqueue lock',
            'CU', 'Cursor bind lock',
            'DF', 'Data file instance lock',
            'DL', 'Direct loader parallel index create',
            'DM', 'Mount/startup db primary/secondary instance lock',
            'DR', 'Distributed recovery process lock',
            'DX', 'Distributed transaction entry lock',
            'FI', 'SGA open-file information lock',
            'FS', 'File set lock',
            'HW', 'HW||Space management operations on a specific segment lock',
            'IN', 'Instance number lock',
            'IR', 'Instance recovery serialization global enqueue lock',
            'IS', 'Instance state lock',
            'IV', 'Library cache invalidation instance lock',
            'JQ', 'Job queue lock',
            'KK', 'Thread kick lock',
            'MB', 'Master buffer hash table instance lock',
            'MM', 'Mount definition gloabal enqueue lock',
            'MR', 'Media recovery lock',
            'PF', 'Password file lock',
            'PI', 'Parallel operation lock',
            'PR', 'Process startup lock',
            'PS', 'Parallel operation lock',
            'RE', 'USE_ROW_ENQUEUE enforcement lock',
            'RT', 'Redo thread global enqueue lock',
            'RW', 'Row wait enqueue lock',
            'SC', 'System commit number instance lock',
            'SH', 'System commit number high water mark enqueue lock',
            'SM', 'SMON lock',
            'SN', 'Sequence number instance lock',
            'SQ', 'Sequence number enqueue lock',
            'SS', 'Sort segment lock',
            'ST', 'Space transaction enqueue lock',
            'SV', 'Sequence number value lock',
            'TA', 'Generic enqueue lock',
            'TD', 'TD||DDL enqueue lock',
            'TE', 'Extend-segment enqueue lock',
            'TM', 'TM||DML enqueue lock',
            'TO', 'Temporary Table Object Enqueue',
            'TT', 'TT||Temporary table enqueue lock',
            'TX', 'TX||Transaction enqueue lock',
            'UL', 'User supplied lock',
            'UN', 'User name lock',
            'US', 'Undo segment DDL lock',
            'WL', 'Being-written redo log instance lock',
            'WS', 'Write-atomic-log-switch global enqueue lock',
            'TS', DECODE (a.id2,
                          0, 'Temporary segment enqueue lock (ID2=0)',
                          'New block allocation enqueue lock (ID2=1)'),
            'LA', 'Library cache lock instance lock (A=namespace)',
            'LB', 'Library cache lock instance lock (B=namespace)',
            'LC', 'Library cache lock instance lock (C=namespace)',
            'LD', 'Library cache lock instance lock (D=namespace)',
            'LE', 'Library cache lock instance lock (E=namespace)',
            'LF', 'Library cache lock instance lock (F=namespace)',
            'LG', 'Library cache lock instance lock (G=namespace)',
            'LH', 'Library cache lock instance lock (H=namespace)',
            'LI', 'Library cache lock instance lock (I=namespace)',
            'LJ', 'Library cache lock instance lock (J=namespace)',
            'LK', 'Library cache lock instance lock (K=namespace)',
            'LL', 'Library cache lock instance lock (L=namespace)',
            'LM', 'Library cache lock instance lock (M=namespace)',
            'LN', 'Library cache lock instance lock (N=namespace)',
            'LO', 'Library cache lock instance lock (O=namespace)',
            'LP', 'Library cache lock instance lock (P=namespace)',
            'LS', 'Log start/log switch enqueue lock',
            'PA', 'Library cache pin instance lock (A=namespace)',
            'PB', 'Library cache pin instance lock (B=namespace)',
            'PC', 'Library cache pin instance lock (C=namespace)',
            'PD', 'Library cache pin instance lock (D=namespace)',
            'PE', 'Library cache pin instance lock (E=namespace)',
            'PF', 'Library cache pin instance lock (F=namespace)',
            'PG', 'Library cache pin instance lock (G=namespace)',
            'PH', 'Library cache pin instance lock (H=namespace)',
            'PI', 'Library cache pin instance lock (I=namespace)',
            'PJ', 'Library cache pin instance lock (J=namespace)',
            'PL', 'Library cache pin instance lock (K=namespace)',
            'PK', 'Library cache pin instance lock (L=namespace)',
            'PM', 'Library cache pin instance lock (M=namespace)',
            'PN', 'Library cache pin instance lock (N=namespace)',
            'PO', 'Library cache pin instance lock (O=namespace)',
            'PP', 'Library cache pin instance lock (P=namespace)',
            'PQ', 'Library cache pin instance lock (Q=namespace)',
            'PR', 'Library cache pin instance lock (R=namespace)',
            'PS', 'Library cache pin instance lock (S=namespace)',
            'PT', 'Library cache pin instance lock (T=namespace)',
            'PU', 'Library cache pin instance lock (U=namespace)',
            'PV', 'Library cache pin instance lock (V=namespace)',
            'PW', 'Library cache pin instance lock (W=namespace)',
            'PX', 'Library cache pin instance lock (X=namespace)',
            'PY', 'Library cache pin instance lock (Y=namespace)',
            'PZ', 'Library cache pin instance lock (Z=namespace)',
            'QA', 'Row cache instance lock (A=cache)',
            'QB', 'Row cache instance lock (B=cache)',
            'QC', 'Row cache instance lock (C=cache)',
            'QD', 'Row cache instance lock (D=cache)',
            'QE', 'Row cache instance lock (E=cache)',
            'QF', 'Row cache instance lock (F=cache)',
            'QG', 'Row cache instance lock (G=cache)',
            'QH', 'Row cache instance lock (H=cache)',
            'QI', 'Row cache instance lock (I=cache)',
            'QJ', 'Row cache instance lock (J=cache)',
            'QL', 'Row cache instance lock (K=cache)',
            'QK', 'Row cache instance lock (L=cache)',
            'QM', 'Row cache instance lock (M=cache)',
            'QN', 'Row cache instance lock (N=cache)',
            'QO', 'Row cache instance lock (O=cache)',
            'QP', 'Row cache instance lock (P=cache)',
            'QQ', 'Row cache instance lock (Q=cache)',
            'QR', 'Row cache instance lock (R=cache)',
            'QS', 'Row cache instance lock (S=cache)',
            'QT', 'Row cache instance lock (T=cache)',
            'QU', 'Row cache instance lock (U=cache)',
            'QV', 'Row cache instance lock (V=cache)',
            'QW', 'Row cache instance lock (W=cache)',
            'QX', 'Row cache instance lock (X=cache)',
            'QY', 'Row cache instance lock (Y=cache)',
            'QZ', 'Row cache instance lock (Z=cache)',
            'Other type')
            lo_type,
         a.ctime
    FROM sys.GV$LOCK a,
         sys.gv$session b,
         sys.gv$instance c,
         sys.USER$ d,
         sys.OBJ$ e
   WHERE     b.inst_id = a.inst_id
         AND a.sid = b.sid
         AND a.sid =decode(&sid,0,a.sid,&sid)
         AND a.inst_id = c.inst_id
         AND a.lmode IN (2, 3, 4, 5, 6)
         AND e.OBJ# = DECODE (a.ID2, 0, a.ID1, 1)
         AND d.USER# = e.OWNER#
         AND b.TYPE != 'BACKGROUND'
ORDER BY sess
/
