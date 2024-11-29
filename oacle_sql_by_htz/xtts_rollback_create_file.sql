set pages 0 lines 200 long 20000
set serveroutput on size 20000  format wrapped;
spool rollback_create_file.log
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
                                          OVER (ORDER BY a.start_time DESC)
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
         IN (SELECT a.df_file# df_file,
                       '+DATA/'
                    || (SELECT LOWER (name) FROM v$database)
                    || '/datafile/'
                    || LOWER (a.DF_TABLESPACE)
                    || '_'
                    || a.df_file#
                    || '.dbf'
                       fname
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
         || '.bak'
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
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line (' ');
      DBMS_OUTPUT.put_line (' ');
   END LOOP;

   CLOSE i_handle_cursor;
END;
/

spool off