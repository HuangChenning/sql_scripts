/* Formatted on 2013/6/1 21:56:05 (QP5 v5.240.12305.39476) */
set pages 40
set lines 200
col username for a15
col workarea_exec_optimal heading 'WORKAREA EXECUTIONS |OPTIMAL'
col workarea_exec_onepass heading 'WORKAREA EXECUTIONS|ONEPASS'
col workarea_exec_multipass heading 'WORKAREA EXECUTIONS|MUTIPASS'
col writes_direct_temp heading 'PHYSICAL WRITES DIRECT|TEMPORARY TABLESPACE'
col reads_direct_temp heading 'PHYSICAL READS DIRECT|TEMPORARY TABLESPACE'
SELECT *
  FROM (  SELECT s.sid,DECODE(s.SQL_HASH_VALUE, '0', s.PREV_HASH_VALUE, s.SQL_HASH_VALUE) hash_value,
                 NVL (
                    DECODE (TYPE,
                            'BACKGROUND', 'SYS (' || b.ksbdpnam || ')',
                            s.username),
                    SUBSTR (p.program, INSTR (p.program, '(')))
                    username,s.status,
                 NVL (
                    SUM (
                       CASE
                          WHEN sn.name = 'sorts (memory)' THEN ss.VALUE
                          ELSE 0
                       END),
                    0)
                    sorts_memory,
                 NVL (
                    SUM (
                       CASE
                          WHEN sn.name = 'sorts (disk)' THEN ss.VALUE
                          ELSE 0
                       END),
                    0)
                    sorts_disk,
                 NVL (
                    SUM (
                       CASE
                          WHEN sn.name = 'sorts (rows)' THEN ss.VALUE
                          ELSE 0
                       END),
                    0)
                    sorts_rows,
                 NVL (
                    SUM (
                       CASE
                          WHEN sn.name =
                                  'physical reads direct temporary tablespace'
                          THEN
                             ss.VALUE
                          ELSE
                             0
                       END),
                    0)
                    reads_direct_temp,
                 NVL (
                    SUM (
                       CASE
                          WHEN sn.name =
                                  'physical writes direct temporary tablespace'
                          THEN
                             ss.VALUE
                          ELSE
                             0
                       END),
                    0)
                    writes_direct_temp,
                 NVL (
                    SUM (
                       CASE
                          WHEN sn.name = 'workarea executions - optimal'
                          THEN
                             ss.VALUE
                          ELSE
                             0
                       END),
                    0)
                    workarea_exec_optimal,
                 NVL (
                    SUM (
                       CASE
                          WHEN sn.name = 'workarea executions - onepass'
                          THEN
                             ss.VALUE
                          ELSE
                             0
                       END),
                    0)
                    workarea_exec_onepass,
                 NVL (
                    SUM (
                       CASE
                          WHEN sn.name = 'workarea executions - multipass'
                          THEN
                             ss.VALUE
                          ELSE
                             0
                       END),
                    0)
                    workarea_exec_multipass
            FROM v$session s,
                 v$sesstat ss,
                 v$statname sn,
                 v$process p,
                 x$ksbdp b
           WHERE     s.paddr = p.addr
                 AND b.inst_id(+) = USERENV ('INSTANCE')
                 AND p.addr = b.ksbdppro(+)
                 AND s.TYPE = 'USER'
                 AND s.sid = ss.sid
                 AND ss.statistic# = sn.statistic#
                 AND sn.name IN
                        ('sorts (memory)',
                         'sorts (disk)',
                         'sorts (rows)',
                         'physical reads direct temporary tablespace',
                         'physical writes direct temporary tablespace',
                         'workarea executions - optimal',
                         'workarea executions - onepass',
                         'workarea executions - multipass')
        GROUP BY s.sid,
                 DECODE(s.SQL_HASH_VALUE, '0', s.PREV_HASH_VALUE, s.SQL_HASH_VALUE),
                 NVL (
                    DECODE (TYPE,
                            'BACKGROUND', 'SYS (' || b.ksbdpnam || ')',
                            s.username),
                    SUBSTR (p.program, INSTR (p.program, '('))),s.status
        ORDER BY workarea_exec_multipass desc,
                 workarea_exec_onepass desc ,
                 reads_direct_temp + writes_direct_temp desc ,
                 sorts_rows desc)
 WHERE ROWNUM <= 200 order by workarea_exec_multipass 
/