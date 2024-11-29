SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;
PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : User Session Trace File Location                            |
PROMPT | Instance : &current_instance                                           |
PROMPT +------------------------------------------------------------------------+
ACCEPT sid prompt 'Enter Search Sid (i.e. 123) : '
ACCEPT serail prompt 'Enter Search Serail (i.e. 123) : '

variable sid  number;
variable serail  number;
begin
  :sid  :=  &sid;
  :serail  :=  &serail;
end;
/


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

COLUMN "Trace File Path" FORMAT a80 HEADING 'Your trace file with path is:'

SELECT
    a.trace_path || '/' || b.trace_file "Trace File Path"
FROM
    (  SELECT value trace_path 
       FROM   v$parameter 
       WHERE  name='user_dump_dest'
    ) a
  , (  SELECT c.instance || '_ora_' || spid ||'.trc' TRACE_FILE 
       FROM   v$process,
              (select lower(instance_name) instance from v$instance)  c
       WHERE  addr = ( SELECT paddr 
                       FROM v$session 
                       WHERE sid=:sid and serial#=:serail 
                     )
    ) b
/
