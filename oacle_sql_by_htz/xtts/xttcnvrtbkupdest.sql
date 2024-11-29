--
-- Convert the incremental backup (target convert)
-- Inputs: cross-plaform backups
--

set serveroutput on;
set termout      on;
set verify      off;

DECLARE
  
  handle varchar2(512) ;
  comment varchar2(80) ;
  media varchar2(80) ;
  concur boolean ;
  recid number ;
  stamp number ;
  platfrmto number;
  same_endian number := 1;

  
  sql_stmt  VARCHAR2(400) := 'BEGIN 
   sys.dbms_backup_restore.applyDatafileTo(
    dfnumber => :b1,
    toname => :b2,
    fuzziness_hint => 0, max_corrupt => 0, islevel0 => 0, 
    recid => 0, stamp => 0); END; ';
    
  devtype VARCHAR2(512);
  
BEGIN

   BEGIN
      sys.dbms_backup_restore.restoreCancel(TRUE);
      devtype := sys.dbms_backup_restore.deviceAllocate; 
    
      sys.dbms_backup_restore.backupBackupPiece(
        bpname => '&&1',
        fname => '&&2/xtts_incr_backup',
        handle => handle, media => media, comment => comment, 
        concur => concur, recid => recid, stamp => stamp, check_logical => FALSE,
        copyno => 1, deffmt => 0, copy_recid => 0, copy_stamp => 0,
        npieces => 1, dest => 0,
        pltfrmfr => &&3);
   EXCEPTION
      WHEN OTHERS
      THEN
        DBMS_OUTPUT.put_line ('ERROR IN CONVERSION ' || SQLERRM);
   END ;

   sys.dbms_backup_restore.deviceDeallocate;

   DBMS_OUTPUT.put_line('CONVERTED BACKUP PIECE' || 
                        '&&2/xtts_incr_backup');

END;
/

exit
