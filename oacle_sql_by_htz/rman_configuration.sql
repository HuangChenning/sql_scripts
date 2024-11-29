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

COLUMN name     FORMAT a48   HEADING 'Name'
COLUMN value    FORMAT a55   HEADING 'Value'

SELECT
    name
  , value
FROM
    v$rman_configuration
ORDER BY
    name
/
