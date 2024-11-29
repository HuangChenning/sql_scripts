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

COLUMN bs_key              FORMAT 9999          HEADING 'BS|Key'
COLUMN piece#              FORMAT 99999         HEADING 'Piece|#'
COLUMN copy#               FORMAT 9999          HEADING 'Copy|#'
COLUMN bp_key              FORMAT 9999          HEADING 'BP|Key'
COLUMN status              FORMAT a9            HEADING 'Status'
COLUMN handle              FORMAT a75           HEADING 'Handle'
COLUMN start_time          FORMAT a19           HEADING 'Start|Time'
COLUMN completion_time     FORMAT a19           HEADING 'End|Time'
COLUMN elapsed_seconds     FORMAT 999,999       HEADING 'Elapsed|Seconds'
COLUMN deleted             FORMAT a8            HEADING 'Deleted?'

BREAK ON bs_key SKIP 2

SELECT
    bs.recid                                            bs_key
  , bp.piece#                                           piece#
  , bp.copy#                                            copy#
  , bp.recid                                            bp_key
  , DECODE(   bp.status
            , 'A', 'Available'
            , 'D', 'Deleted'
            , 'X', 'Expired')                             status
  , bp.handle                                             handle
  , TO_CHAR(bp.start_time, 'mm/dd/yyyy HH24:MI:SS')       start_time
  , TO_CHAR(bp.completion_time, 'mm/dd/yyyy HH24:MI:SS')  completion_time
  , bp.elapsed_seconds                                    elapsed_seconds
FROM
    v$backup_set bs JOIN v$backup_piece bp USING (set_stamp,set_count)
WHERE
    bp.status IN ('A', 'X')
ORDER BY
    bs.recid
  , bp.piece#
/
