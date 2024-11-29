set echo off
set verify off
set lines 170
set pages 10

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display session cache cursor and total cursor use info                 |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
/* Formatted on 2012-11-12 11:03:01 (QP5 v5.185.11230.41888) */
SELECT 'session_cached_cursors' parameter,
       LPAD (VALUE, 5) VALUE,
       DECODE (VALUE, 0, '  n/a', TO_CHAR (100 * used / VALUE, '990') || '%')
          usage
  FROM (SELECT MAX (s.VALUE) used
          FROM v$statname n, v$sesstat s
         WHERE     n.name = 'session cursor cache count'
               AND s.statistic# = n.statistic#),
       (SELECT VALUE
          FROM v$parameter
         WHERE name = 'session_cached_cursors')
UNION ALL
SELECT 'open_cursors',
       LPAD (VALUE, 5),
       TO_CHAR (100 * used / VALUE, '990') || '%'
  FROM (  SELECT MAX (SUM (s.VALUE)) used
            FROM v$statname n, v$sesstat s
           WHERE     n.name IN
                        ('opened cursors current', 'session cursor cache count')
                 AND s.statistic# = n.statistic#
        GROUP BY s.sid),
       (SELECT VALUE
          FROM v$parameter
         WHERE name = 'open_cursors')
/