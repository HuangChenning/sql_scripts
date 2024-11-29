PROMPT # trace AWR snapshots                                            
PROMPT alter session set events 'immediate trace name awr_test level 1';
PROMPT # trace AWR purging                                              
PROMPT alter session set events 'immediate trace name awr_test level 2';
PROMPT # trace AWR SQL                                                  
PROMPT alter session set events 'immediate trace name awr_test level 3';
PROMPT # turn off all of the above, if set                              
PROMPT alter session set events 'immediate trace name awr_test level 4';

oradebug setmypid;
oradebug dump awr_test &level;
oradebug tracefile_name;


PROMPT tail -f tracefile_name;
PROMPT EXEC CREATE_SNAPSHOT;
