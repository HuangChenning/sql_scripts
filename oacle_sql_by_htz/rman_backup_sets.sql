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

COLUMN bs_key                 FORMAT 999999                 HEADING 'BS|Key'
COLUMN backup_type            FORMAT a14                    HEADING 'Backup|Type'
COLUMN device_type            FORMAT a10                    HEADING 'Device|Type'
COLUMN controlfile_included   FORMAT a11                    HEADING 'Controlfile|Included?'
COLUMN spfile_included        FORMAT a9                     HEADING 'SPFILE|Included?'
COLUMN incremental_level      FORMAT 999999                 HEADING 'Inc.|Level'
COLUMN pieces                 FORMAT 9,999                  HEADING '# of|Pieces'
COLUMN start_time             FORMAT a19                    HEADING 'Start|Time'
COLUMN completion_time        FORMAT a19                    HEADING 'End|Time'
COLUMN elapsed_seconds        FORMAT 999,999                HEADING 'Elapsed|Seconds'
COLUMN tag                    FORMAT a19                    HEADING 'Tag'
COLUMN block_size             FORMAT 999,999                HEADING 'Block|Size'

SELECT
    bs.recid                                              bs_key
  , DECODE(backup_type
           , 'L', 'Archived Logs'
           , 'D', 'Datafile Full'
           , 'I', 'Incremental')                          backup_type
  , device_type                                           device_type
  , DECODE(   bs.controlfile_included
            , 'NO', null
            , bs.controlfile_included)                    controlfile_included
  , sp.spfile_included                                    spfile_included
  , bs.incremental_level                                  incremental_level
  , bs.pieces                                             pieces
  , TO_CHAR(bs.start_time, 'mm/dd/yyyy HH24:MI:SS')       start_time
  , TO_CHAR(bs.completion_time, 'mm/dd/yyyy HH24:MI:SS')  completion_time
  , bs.elapsed_seconds                                    elapsed_seconds
  , bp.tag                                                tag
  , bs.block_size                                         block_size
FROM
    v$backup_set                           bs
  , (select distinct
         set_stamp
       , set_count
       , tag
       , device_type
     from v$backup_piece
     where status in ('A', 'X'))           bp
 ,  (select distinct
         set_stamp
       , set_count
       , 'YES'     spfile_included
     from v$backup_spfile)                 sp
WHERE
      bs.set_stamp = bp.set_stamp
  AND bs.set_count = bp.set_count
  AND bs.set_stamp = sp.set_stamp (+)
  AND bs.set_count = sp.set_count (+)
ORDER BY
    bs.recid
/
