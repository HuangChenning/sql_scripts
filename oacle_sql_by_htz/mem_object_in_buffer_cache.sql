aaset lines 170
set pages 100
col object_name for a20
col state for a10
col blsiz for 999999
ACCEPT objectname prompt 'Enter Search Object Name (i.e. CONTROL) : ' default '0'

SELECT o.object_name,
         DECODE (state,
                 0, 'free',
                 1, 'xcur',
                 2, 'scur',
                 3, 'cr',
                 4, 'read',
                 5, 'mrec',
                 6, 'irec',
                 7, 'write',
                 8, 'pi')
            state,
         blsiz,
         COUNT (*) blocks
    FROM x$bh b, dba_objects o
   WHERE b.obj = o.data_object_id AND b.ts# > 0 AND o.object_name = upper('&objectname')
GROUP BY o.object_name, state, blsiz
/
