/* Formatted on 2012/12/19 22:13:25 (QP5 v5.215.12089.38647) */
-------------
set echo off
set verify off
set serveroutput on
set feedback off
set lines 170
set pages 1000
COL name FORMAT a30
COL value FORMAT a20
REM How many CPU does the system have?
REM Default degree of parallelism is
REM Default = parallel_threads_per_cpu * cpu_count
REM -------------------------------------------------;

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | Default degree of parallelism is parallel_threads_per_cpu * cpu_count  |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

SELECT SUBSTR (name, 1, 30) Name, SUBSTR (VALUE, 1, 5) VALUE
  FROM v$parameter
 WHERE name IN ('parallel_threads_per_cpu', 'cpu_count');

COL owner FORMAT a30
COL degree FORMAT a10
COL instances FORMAT a10
REM Normally DOP := degree * Instances
REM See the following Note for the exact formula.
REM Note:260845.1 Old and new Syntax for setting Degree of Parallelism
REM How many tables a user have with different DOPs
REM -------------------------------------------------------;

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | tables a user have with different DOPs                                 |
PROMPT | Normally DOP := degree * Instances                                     |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

  SELECT *
    FROM (  SELECT SUBSTR (owner, 1, 15) Owner,
                   LTRIM (degree) Degree,
                   LTRIM (instances) Instances,
                   COUNT (*) "Num Tables",
                   'Parallel'
              FROM all_tables
             WHERE    (TRIM (degree) != '1' AND TRIM (degree) != '0')
                   OR (TRIM (instances) != '1' AND TRIM (instances) != '0')
          GROUP BY owner, degree, instances
          UNION
            SELECT SUBSTR (owner, 1, 15) owner,
                   '1',
                   '1',
                   COUNT (*),
                   'Serial'
              FROM all_tables
             WHERE     (TRIM (degree) = '1' OR TRIM (degree) = '0')
                   AND (TRIM (instances) = '1' OR TRIM (instances) = '0')
          GROUP BY owner)
ORDER BY owner;

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | indexes a user have with different DOPs                               |
PROMPT | Normally DOP := degree * Instances                                     |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

REM How many indexes a user have with different DOPs
REM ---------------------------------------------------;

  SELECT *
    FROM (  SELECT SUBSTR (owner, 1, 15) Owner,
                   SUBSTR (TRIM (degree), 1, 7) Degree,
                   SUBSTR (TRIM (instances), 1, 9) Instances,
                   COUNT (*) "Num Indexes",
                   'Parallel'
              FROM all_indexes
             WHERE    (TRIM (degree) != '1' AND TRIM (degree) != '0')
                   OR (TRIM (instances) != '1' AND TRIM (instances) != '0')
          GROUP BY owner, degree, instances
          UNION
            SELECT SUBSTR (owner, 1, 15) owner,
                   '1',
                   '1',
                   COUNT (*),
                   'Serial'
              FROM all_indexes
             WHERE     (TRIM (degree) = '1' OR TRIM (degree) = '0')
                   AND (TRIM (instances) = '1' OR TRIM (instances) = '0')
          GROUP BY owner)
ORDER BY owner;


COL table_name FORMAT a35
COL index_name FORMAT a35
REM Tables that have Indexes with not the same DOP
REM !!!!! This command can take some time to execute !!!
REM ---------------------------------------------------;
SET LINES 150

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | Tables that have Indexes with not the same DOP                         |
PROMPT +------------------------------------------------------------------------+ 
PROMPT

SELECT SUBSTR (t.owner, 1, 15) Owner,
       t.table_name,
       SUBSTR (TRIM (t.degree), 1, 7) Degree,
       SUBSTR (TRIM (t.instances), 1, 9) Instances,
       i.index_name,
       SUBSTR (TRIM (i.degree), 1, 7) Degree,
       SUBSTR (TRIM (i.instances), 1, 9) Instances
  FROM all_indexes i, all_tables t
 WHERE     (   TRIM (i.degree) != TRIM (t.degree)
            OR TRIM (i.instances) != TRIM (t.instances))
       AND i.owner = t.owner
       AND i.table_name = t.table_name;
clear    breaks  
set verify on
set serveroutput off
set feedback on
set linesize 78 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on