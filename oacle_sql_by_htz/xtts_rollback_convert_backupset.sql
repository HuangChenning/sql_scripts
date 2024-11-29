set pages 0 lines 2000 long 20000
set serveroutput on size 1000000  format wrapped;
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
      DBMS_OUTPUT.put_line (' DECLARE');
      DBMS_OUTPUT.put_line ('   handle    varchar2(512);');
      DBMS_OUTPUT.put_line ('   comment   varchar2(80);');
      DBMS_OUTPUT.put_line ('   media     varchar2(80);');
      DBMS_OUTPUT.put_line ('   concur    boolean;');
      DBMS_OUTPUT.put_line ('   recid     number;');
      DBMS_OUTPUT.put_line ('   stamp     number;');
      DBMS_OUTPUT.put_line ('   pltfrmfr number;');
      DBMS_OUTPUT.put_line ('   devtype   VARCHAR2(512);');
      DBMS_OUTPUT.put_line (' BEGIN');
      DBMS_OUTPUT.put_line (
         '     sys.dbms_backup_restore.restoreCancel(TRUE);');
      DBMS_OUTPUT.put_line (
         '     devtype := sys.dbms_backup_restore.deviceAllocate;');
      DBMS_OUTPUT.put_line (
            '     sys.dbms_backup_restore.backupBackupPiece(bpname => '''
         || i_tag
         || ''',fname => '''
         || i_tag
         || '.bak'',handle => handle,media=> media,comment=> comment, concur=> concur,recid=> recid,stamp => stamp, check_logical => FALSE,copyno=> 1, deffmt=> 0, copy_recid=> 0,copy_stamp => 0,npieces=> 1,dest=> 0,pltfrmfr=> 6);');
      DBMS_OUTPUT.put_line (' END;');
      DBMS_OUTPUT.put_line (' /');

      DBMS_OUTPUT.put_line ('exit');
      DBMS_OUTPUT.put_line ('EOF');
      DBMS_OUTPUT.put_line ('');
   END LOOP;

   CLOSE i_handle_cursor;
END;
/