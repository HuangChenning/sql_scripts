set echo off
oradebug setmypid
oradebug unlimit
PROMPT DUMP HEAPDUMP 536870914
!df 
show parameter max_dump_file_size
accept input prompt 'Enter OR Ctrl+C'
PROMPT '**********************************************'
PROMPT 'Level	Description                             '
PROMPT '1	    PGA summary                             '
PROMPT '2	    SGA summary                             '
PROMPT '4	    UGA summary                             '
PROMPT '8	      Callheap (Current)                    '
PROMPT '16	    Callheap (User)                       '
PROMPT '32	    Large pool                            '
PROMPT '64	    Streams pool                          '
PROMPT '128	    Java pool                             '
PROMPT '1025	    PGA with contents                   '
PROMPT '2050	    SGA with contents                   '
PROMPT '4100	    UGA with contents                   '
PROMPT '8200	    Callheap with contents (Current)    '
PROMPT '16400	    Callheap with contents (User)       '
PROMPT '32800	    Large pool with contents            '
PROMPT '65600	    Streams pool with contents          '
PROMPT '131200      Java pool with contents           ' 
PROMPT '536870914   shared pool all contents          '
PROMPT '**********************************************'
undefine level;
oradebug dump heapdump &level;
oradebug tracefile_name
oradebug close_trace
undefine level;