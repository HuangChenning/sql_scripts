/* Formatted on 2015/3/17 16:27:16 (QP5 v5.240.12305.39446) */
REM - Run a report of all of the processes in the database
REM - where the username is not null (i.e exclude background processes)

COLUMN alme HEADING "Allocated MB" FORMAT 99999D9
COLUMN usme HEADING "Used MB" FORMAT 99999D9
COLUMN frme HEADING "Freeable MB" FORMAT 99999D9
COLUMN mame HEADING "Max MB" FORMAT 99999D9
COLUMN username FORMAT a15
COLUMN program FORMAT a22
COLUMN sid FORMAT a5
COLUMN spid FORMAT a8
SET LINESIZE 300

  SELECT s.username,
         SUBSTR (s.sid, 1, 5) sid,
         p.spid,
         logon_time,
         SUBSTR (s.program, 1, 22) program,
         s.process pid_remote,
         ROUND (pga_used_mem / 1024 / 1024) usme,
         ROUND (pga_alloc_mem / 1024 / 1024) alme,
         ROUND (pga_freeable_mem / 1024 / 1024) frme,
         ROUND (pga_max_mem / 1024 / 1024) mame
    FROM v$session s, v$process p
   WHERE p.addr = s.paddr AND s.username IS NOT NULL
ORDER BY pga_max_mem, logon_time;

PROMPT - pick one of the SID's from the above list and enter it when prompted
PROMPT - for ORASID to see a breakdown summary
COLUMN pid NEW_VALUE orapid
COLUMN category HEADING "Category"
COLUMN allocated for 9999999999999999 HEADING "Allocated bytes"
COLUMN used HEADING "Used bytes"
COLUMN max_allocated HEADING "Max allocated bytes"

SELECT pid,
       category,
       allocated,
       used,
       max_allocated
  FROM v$process_memory
 WHERE pid = (SELECT pid
                FROM v$process
               WHERE addr = (SELECT paddr
                               FROM v$session
                              WHERE sid = &SID));


PROMPT - analysing pga detail - note that you need to pause after
PROMPT - issuing pga_detail_get to allow the v$process_memory_detail
PROMPT - table to be filled.
PROMPT - note that you also need to make sure that the process you are
PROMPT - monitoring is actually doing something otherwise the details aren't
PROMPT - populated


oradebug setorapid &orapid
PROMPT   BEGIN dump headump 
oradebug dump heapdump 536870913
PROMPT   END dump headump 

oradebug DUMP pga_detail_cancel &orapid

REM oradebug dump pga_detail_dump &orapid
PROMPT BEGIN dump pga_detail_dump
oradebug dump pga_detail_dump &orapid;
PROMP END dump pga_detail_dump
oradebug tracefile_name;
oradebug DUMP pga_detail_get &orapid

PROMPT Pausing to allow v$process_memory_detail to be populated.
REM - if you do not get consistent results, it may be worth increasing this
REM - value to allow more time before we take a snapshot.
EXEC dbms_lock.sleep(10);

REM  save the detailed information to your own table - as the data is
REM  overwritten in v$process_memory_detail each time you call pga_detail_get

CREATE TABLE SYSTEM.htz_pga_tab1
AS
   SELECT category,
          name,
          heap_name,
          bytes,
          allocation_count,
          heap_descriptor,
          parent_heap_descriptor
     FROM v$process_memory_detail
    WHERE category = 'Other';

REM - Stop the script waiting for user input to allow for the user to
REM - determine a suitable time before executing this again
PROMPT Press Return to take another snapshot
ACCEPT DUMMY

oradebug DUMP pga_detail_get &orapid
PROMPT Pausing to allow v$process_memory_detail to be populated.
EXEC dbms_lock.sleep(10);

REM save the detailed information to a second  table
REM and then run a query showing the differences between the 2 runs.


CREATE TABLE SYSTEM.htz_pga_tab2
AS
   SELECT category,
          name,
          heap_name,
          bytes,
          allocation_count,
          heap_descriptor,
          parent_heap_descriptor
     FROM v$process_memory_detail
    WHERE category = 'Other';


COLUMN category HEADING "Category"
COLUMN name HEADING "Name"
COLUMN heap_name HEADING "Heap name"
COLUMN q1 HEADING "Memory 1st" FORMAT 999,999,999,999
COLUMN q2 HEADING "Memory 2nd" FORMAT 999,999,999,999
COLUMN diff HEADING "Difference" FORMAT S999,999,999,999
SET LINES 150

  SELECT tab2.category,
         tab2.name,
         tab2.heap_name,
         tab1.bytes q1,
         tab2.bytes q2,
         tab2.bytes - tab1.bytes diff
    FROM SYSTEM.htz_pga_tab1 tab1, SYSTEM.htz_pga_tab2 tab2
   WHERE     tab1.category = tab2.category
         AND tab1.name = tab2.name
         AND tab1.heap_name = tab2.heap_name
         AND tab1.bytes <> tab2.bytes
ORDER BY 6 DESC;

PROMPT Pausing DROP system.htz_pga_tab2,system.htz_pga_tab1
accept  input
DROP TABLE SYSTEM.htz_pga_tab1;
DROP TABLE SYSTEM.htz_pga_tab2;
