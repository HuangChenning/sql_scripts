set lines 200
set echo off
set verify off
col curtime for a10
col sess for a25
col instance_name for a8
col sql_id for a20
col lo_type for a25 heading 'TYPE'
col lock_object for a40
col sqlid for a20 heading 'SQL_ID|SQL_CHILD_NUMBER'
set pages 200
set heading on
prompt 
prompt +----------------------------------------------------------------------------+
prompt | DISPLAY SESSION LOCK INFO                                                  |
prompt +----------------------------------------------------------------------------+
prompt 

SELECT TO_CHAR (SYSDATE, 'hh24:mi:ss') AS curtime,
            DECODE (a.request, 0, 'Holder: ', 'Waiter: ')
         || c.instance_name
         || ':'
         || a.sid
            sess,
         DECODE (b.sql_hash_value, 0, b.prev_hash_value, b.sql_hash_value)
            hash_value,
         a.id1,
         a.id2,
         DECODE (a.lmode,
                 1, '1||No Lock',
                 2, '2||Row Share',
                 3, '3||Row Exclusive',
                 4, '4||Share',
                 5, '5||Shr Row Excl',
                 6, '6||Exclusive',
                 NULL)
            lmode,
        DECODE (a.REQUEST,
                 1, '1||No Lock',
                 2, '2||Row Share',
                 3, '3||Row Exclusive',
                 4, '4||Share',
                 5, '5||Shr Row Excl',
                 6, '6||Exclusive',
                 NULL)
            REQUEST,
         DECODE (a.TYPE,
                 'CF', 'CF||Control File',
                 'DX', 'DX||Distrted Transaction',
                 'FS', 'FS||File Set',
                 'IR', 'Instance Recovery',
                 'IS', 'Instance State',
                 'IV', 'Libcache Invalidation',
                 'LS', 'LogStartORswitch',
                 'MR', 'Media Recovery',
                 'RT', 'Redo Thread',
                 'RW', 'Row Wait',
                 'SQ', 'Sequence #',
                 'ST', 'Diskspace Transaction',
                 'TE', 'Extend Table',
                 'TT', 'Temp Table',
                 'TX', 'TX||Transaction enqueue',
                 'TM', 'TM||Dml enqueue',
                 'UL', 'PLSQL User_lock',
                 'UN', 'User Name',
                 'Other type')
            lo_type,
         a.ctime
    FROM GV$LOCK a, gv$session b, gv$instance c
   WHERE     (a.id1, a.id2, a.TYPE) IN (SELECT id1, id2, TYPE
                                          FROM GV$LOCK
                                         WHERE request > 0)
         AND b.inst_id = a.inst_id
         AND a.sid = b.sid
         AND a.inst_id = c.inst_id
ORDER BY id1, request
/

