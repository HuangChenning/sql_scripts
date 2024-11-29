SET ECHO OFF
SET LINES 200 PAGES 1000 HEADING ON VERIFY OFF
COL dest_id FOR 99 HEADING ID
COL status FOR a10
COL type FOR a15
COL RECOVERY_MODE FOR a25
COL DB_UNIQUE_NAME FOR a10
COL synchronized FOR a4 HEADING 'SYNC'
COL arch FOR a15 HEADING 'ARCH|THREAD.SEQ'
COL apply FOR a15 HEADING 'APPLY|THREAD.SEQ'
col error for a30 heading 'ERROR'
COL inst_id FOR 99 HEADING 'I'

  SELECT inst_id,
         dest_id,
         status,
         TYPE,
         RECOVERY_MODE,
         ARCHIVED_THREAD# || '.' || ARCHIVED_SEQ# arch,
         APPLIED_THREAD# || '.' || APPLIED_SEQ# apply,
         DB_UNIQUE_NAME,
         SYNCHRONIZED,
         error
    FROM gv$archive_dest_status
   WHERE status IN ('VALID')
ORDER BY inst_id,dest_id;