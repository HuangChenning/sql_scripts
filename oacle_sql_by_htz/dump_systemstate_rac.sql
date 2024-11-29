oradebug setmypid
oradebug unlimit
oradebug setinst all
oradebug -g all hanganalyze 4
oradebug -g all dump systemstate 266
exec dbms_lock.sleep(50);
oradebug -g all dump systemstate 266
oradebug tracelfile_name

