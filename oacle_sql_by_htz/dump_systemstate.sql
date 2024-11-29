oradebug setmypid
oradebug unlimit
oradebug  hanganalyze 4
oradebug dump systemstate 266
exec dbms_lock.sleep(50);
oradebug dump systemstate 266
oradebug tracefile_name
