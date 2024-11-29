SET ECHO        OFF
SET FEEDBACK    6
SET HEADING     ON
SET LINESIZE    180
SET PAGESIZE    50000
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
SET VERIFY      OFF

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

COLUMN owner           FORMAT a25         HEADING 'Owner'
COLUMN object_name     FORMAT a30         HEADING 'Object Name'
COLUMN object_type     FORMAT a20         HEADING 'Object Type'
COLUMN status          FORMAT a10         HEADING 'Status'

BREAK ON owner SKIP 2 ON report

COMPUTE count LABEL ""               OF object_name ON owner
COMPUTE count LABEL "Grand Total: "  OF object_name ON report

SELECT
    owner
  , object_name
  , object_type
  , status
FROM dba_objects
WHERE status <> 'VALID'
ORDER BY owner, object_name
/


