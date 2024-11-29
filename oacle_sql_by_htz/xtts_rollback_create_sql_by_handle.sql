set pages 0 lines 2000 long 20000
set serveroutput on size 1000000  format wrapped;

--select 'set serveroutput on;' || chr(10) || 'DECLARE' || chr(10) ||
--       '  outhandle varchar2(512) ;' || chr(10) ||
--       '  outtag varchar2(30) ;' || chr(10) || '  done boolean ;' ||
--       chr(10) || '  failover boolean ;' || chr(10) ||
--       '  devtype VARCHAR2(512);' || chr(10) || 'BEGIN' || chr(10) ||
--       '  DBMS_OUTPUT.put_line(' || chr(39) || 'Entering RollForward' ||
--       chr(39) || ');' || chr(10) ||
--       '  devtype := sys.dbms_backup_restore.deviceAllocate;' || chr(10) ||
--       '  sys.dbms_backup_restore.applySetDatafile(check_logical => FALSE, cleanup => FALSE) ;' ||
--       chr(10) || '  DBMS_OUTPUT.put_line(' || chr(39) ||
--       'After applySetDataFile' || chr(39) || ');'
--  from dual
--union all
--select '  sys.dbms_backup_restore.applyDatafileTo(dfnumber =>   ' ||
--       a.df_file# || ' ,toname => ''' || a.fname ||
--       ''',fuzziness_hint => 0, max_corrupt => 0, islevel0 => 0,recid => 0, stamp => 0);'
--  from v$backup_files a, v$backup_piece b
-- where a.bs_count = b.set_count
--   and a.bs_stamp = b.SET_STAMP
--   and b.handle =
--       '/oracle/app/oracle/fast_recovery_area/ORCL1124/backupset/2016_03_22/o1_mf_nnndf_TAG20160322T012427_ch0clctb_.bkp'
--   and a.file_type = 'DATAFILE'
--union all
--select chr(10) || '  DBMS_OUTPUT.put_line(' || chr(39) ||
--       'Done: applyDataFileTo' || chr(39) || ');' || chr(10) ||
--       '  DBMS_OUTPUT.put_line(' || chr(39) || 'Done: applyDataFileTo' ||
--       chr(39) || ');' || chr(10) || chr(10) ||
--       '  sys.dbms_backup_restore.restoreSetPiece(handle => ' || chr(39) ||
--       '/test/oracle/accta/backup/convert_bp/ACCTA_INCR_327_feq2rmd4_con_1_1.bak' ||
--       chr(39) ||
--       ',tag => null, fromdisk => true, recid => 0, stamp => 0) ;' ||
--       chr(10) || '  DBMS_OUTPUT.put_line(' || chr(39) ||
--       'Done: RestoreSetPiece' || chr(39) || ');' || chr(10) || chr(10) ||
--       '  sys.dbms_backup_restore.restoreBackupPiece(done => done, params => null, outhandle => outhandle,outtag => outtag, failover => failover);' ||
--       chr(10) || '  DBMS_OUTPUT.put_line(' || chr(39) ||
--       'Done: RestoreBackupPiece' || chr(39) || ');' || chr(10) || chr(10) ||
--       '  sys.dbms_backup_restore.restoreCancel(TRUE);' || chr(10) ||
--       '  sys.dbms_backup_restore.deviceDeallocate;' || chr(10) || '  END;' ||
--       chr(10) || '  /'
--  from dual;
--

--/* Formatted on 2016/3/22 9:08:06 (QP5 v5.256.13226.35510) */
--SET PAGES 0 LINES 2000 LONG 20000
--SELECT    'set serveroutput on;'
--       || CHR (10)
--       || 'DECLARE'
--       || CHR (10)
--       || '  outhandle varchar2(512) ;'
--       || CHR (10)
--       || '  outtag varchar2(30) ;'
--       || CHR (10)
--       || '  done boolean ;'
--       || CHR (10)
--       || '  failover boolean ;'
--       || CHR (10)
--       || '  devtype VARCHAR2(512);'
--       || CHR (10)
--       || 'BEGIN'
--       || CHR (10)
--       || '  DBMS_OUTPUT.put_line('
--       || CHR (39)
--       || 'Entering RollForward'
--       || CHR (39)
--       || ');'
--       || CHR (10)
--       || '  devtype := sys.dbms_backup_restore.deviceAllocate;'
--       || CHR (10)
--       || '  sys.dbms_backup_restore.applySetDatafile(check_logical => FALSE, cleanup => FALSE) ;'
--       || CHR (10)
--       || '  DBMS_OUTPUT.put_line('
--       || CHR (39)
--       || 'After applySetDataFile'
--       || CHR (39)
--       || ');'
--  FROM DUAL
--UNION ALL
--SELECT    '  sys.dbms_backup_restore.applyDatafileTo(dfnumber =>   '
--       || a.df_file#
--       || ' ,toname => '''
--       || a.fname
--       || ''',fuzziness_hint => 0, max_corrupt => 0, islevel0 => 0,recid => 0, stamp => 0);'
--  FROM v$backup_files a, v$backup_piece b
-- WHERE     a.bs_count = b.set_count
--       AND a.bs_stamp = b.SET_STAMP
--       AND b.handle =
--              '/oracle/app/oracle/fast_recovery_area/ORCL1124/backupset/2016_03_22/o1_mf_nnndf_TAG20160322T012427_ch0clctb_.bkp'
--       AND a.file_type = 'DATAFILE'
--UNION ALL
--SELECT    CHR (10)
--       || '  DBMS_OUTPUT.put_line('
--       || CHR (39)
--       || 'Done: applyDataFileTo'
--       || CHR (39)
--       || ');'
--       || CHR (10)
--       || '  DBMS_OUTPUT.put_line('
--       || CHR (39)
--       || 'Done: applyDataFileTo'
--       || CHR (39)
--       || ');'
--       || CHR (10)
--       || CHR (10)
--       || '  sys.dbms_backup_restore.restoreSetPiece(handle => '
--       || CHR (39)
--       || '/test/oracle/accta/backup/convert_bp/ACCTA_INCR_327_feq2rmd4_con_1_1.bak'
--       || CHR (39)
--       || ',tag => null, fromdisk => true, recid => 0, stamp => 0) ;'
--       || CHR (10)
--       || '  DBMS_OUTPUT.put_line('
--       || CHR (39)
--       || 'Done: RestoreSetPiece'
--       || CHR (39)
--       || ');'
--       || CHR (10)
--       || CHR (10)
--       || '  sys.dbms_backup_restore.restoreBackupPiece(done => done, params => null, outhandle => outhandle,outtag => outtag, failover => failover);'
--       || CHR (10)
--       || '  DBMS_OUTPUT.put_line('
--       || CHR (39)
--       || 'Done: RestoreBackupPiece'
--       || CHR (39)
--       || ');'
--       || CHR (10)
--       || CHR (10)
--       || '  sys.dbms_backup_restore.restoreCancel(TRUE);'
--       || CHR (10)
--       || '  sys.dbms_backup_restore.deviceDeallocate;'
--       || CHR (10)
--       || '  END;'
--       || CHR (10)
--       || '  /'
--  FROM DUAL;



/* Formatted on 2016/3/22 10:52:26 (QP5 v5.256.13226.35510) */
/* Formatted on 2016/3/22 11:27:40 (QP5 v5.256.13226.35510) */
DECLARE
   i_tag   v$backup_piece.handle%TYPE;

   CURSOR i_handle_cursor
   IS
      SELECT DISTINCT d.handle
        FROM v$backup_piece d, v$backup_files b
       WHERE     d.tag IN (SELECT tag
                             FROM (SELECT a.tag,
                                          a.handle,
                                          ROW_NUMBER ()
                                             OVER (ORDER BY a.start_time)
                                             rnum
                                     FROM V$BACKUP_PIECE a, v$backup_files b
                                    WHERE     a.set_count = B.BS_COUNT
                                          AND A.SET_STAMP = B.BS_STAMP
                                          AND b.file_type = 'DATAFILE')
                            WHERE rnum = 1)
             AND d.set_count = B.BS_COUNT
             AND d.SET_STAMP = B.BS_STAMP
             AND b.file_type = 'DATAFILE';
BEGIN
   OPEN i_handle_cursor;

   LOOP
      FETCH i_handle_cursor INTO i_tag;

      EXIT WHEN i_handle_cursor%NOTFOUND;
      DBMS_OUTPUT.put_line ('sqlplus / as sysdba <<EOF');
      DBMS_OUTPUT.put_line ('set timing on');
      DBMS_OUTPUT.put_line ('set time on');
      DBMS_OUTPUT.put_line ('set serveroutput on;');
      DBMS_OUTPUT.put_line ('DECLARE');
      DBMS_OUTPUT.put_line ('  outhandle varchar2(512) ;');
      DBMS_OUTPUT.put_line ('  outtag varchar2(30) ;');
      DBMS_OUTPUT.put_line ('  done boolean ;');
      DBMS_OUTPUT.put_line ('  failover boolean ;');
      DBMS_OUTPUT.put_line ('  devtype VARCHAR2(512);');
      DBMS_OUTPUT.put_line ('BEGIN');
      DBMS_OUTPUT.put_line (
         '  DBMS_OUTPUT.put_line(''  Entering RollForward'');');
      DBMS_OUTPUT.put_line (
         '  devtype := sys.dbms_backup_restore.deviceAllocate;');
      DBMS_OUTPUT.put_line (
         '  sys.dbms_backup_restore.applySetDatafile(check_logical => FALSE, cleanup => FALSE) ;');
      DBMS_OUTPUT.put_line (
         '  DBMS_OUTPUT.put_line(''  After applySetDataFile'');');
      DBMS_OUTPUT.put_line (' ');

      FOR i_file_cursor
         IN (SELECT a.df_file# df_file, a.fname fname
               FROM v$backup_files a, v$backup_piece b
              WHERE     a.bs_count = b.set_count
                    AND a.bs_stamp = b.SET_STAMP
                    AND b.handle = i_tag
                    AND a.file_type = 'DATAFILE')
      LOOP
         DBMS_OUTPUT.put_line (
               '    sys.dbms_backup_restore.applyDatafileTo(dfnumber =>   '
            || i_file_cursor.df_file
            || ' ,toname => '''
            || i_file_cursor.fname
            || ''',fuzziness_hint => 0, max_corrupt => 0, islevel0 => 0,recid => 0, stamp => 0);');
      END LOOP;

      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line (
            '  sys.dbms_backup_restore.restoreSetPiece(handle => '''
         || i_tag
         || ''',tag => null, fromdisk => true, recid => 0, stamp => 0) ;');
      DBMS_OUTPUT.put_line (
         '  DBMS_OUTPUT.put_line(''  Done: RestoreSetPiece'');');
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line (
         '  sys.dbms_backup_restore.restoreBackupPiece(done => done, params => null, outhandle => outhandle,outtag => outtag, failover => failover);');
      DBMS_OUTPUT.put_line (
         '  DBMS_OUTPUT.put_line(''Done: RestoreBackupPiece'')');
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line ('  sys.dbms_backup_restore.restoreCancel(TRUE);');
      DBMS_OUTPUT.put_line ('  sys.dbms_backup_restore.deviceDeallocate;');
      DBMS_OUTPUT.put_line ('  END;');
      DBMS_OUTPUT.put_line ('  /');
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line ('exit');
      DBMS_OUTPUT.put_line ('EOF');
   END LOOP;

   CLOSE i_handle_cursor;
END;
/
