  SELECT *
    FROM (  SELECT addr,
                   gets,
                   misses,
                   sleeps
              FROM v$latch_children
             WHERE name = 'cache buffers chains'
          ORDER BY sleeps DESC)
   WHERE ROWNUM < 40
ORDER BY sleeps DESC;
