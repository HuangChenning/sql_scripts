set echo off
set verify off
set lines 250
set pages 30
SET FEEDBACK OFF
COL INST_ID FOR 99 HEADING 'INST|ID'
COL NAME FOR A40
COL TYPE FOR A10
COL DISPLAY_VALUE FOR A20 HEADING 'DISPLAY|VALUE'
COL ISDEFAULT FOR A7 HEADING 'IS|DEFAULT'
COL ISSES_MODIFIABLE FOR A7 HEADING 'SESSION|MODIFY'
COL ISSYS_MODIFIABLE FOR A7 HEADING 'SYSTEM|MODIFY'
COL ISINSTANCE_MODIFIABLE FOR A8 HEADING 'INSTANCE|MODIFY'
COL ISMODIFIED FOR A8 HEADING 'IS|MODIFIED'
COL description FOR A70 HEADING 'DESCRIPTION'
break on inst_id

ACCEPT parameter prompt 'Enter Search Parameter Value (i.e. session) : '


SELECT nam.inst_id,
       nam.ksppinm NAME,
       val.ksppstvl DISPLAY_VALUE,
       DECODE(nam.ksppity,
              1,
              'BOOLEAN',
              2,
              'STRING',
              3,
              'INTEGER',
              4,
              'PARAMETER FILE',
              5,
              'RESERVED',
              6,
              'BIG INTEGER') TYPE,
       val.ksppstdf isdefault,
       DECODE(BITAND(nam.ksppiflg / 256, 1), 1, 'TRUE', 'FALSE') isses_modifiable,
       DECODE(BITAND(nam.ksppiflg / 65536, 3),
              1,
              'IMMED',
              2,
              'DEFERRED',
              3,
              'IMMED',
              'FALSE') issys_modifiable,
       decode(bitand(ksppiflg, 4),
              4,
              'FALSE',
              decode(bitand(ksppiflg / 65536, 3), 0, 'FALSE', 'TRUE')) ISINSTANCE_MODIFIABLE,
       decode(bitand(ksppstvf, 7), 1, 'MODIFIED', 4, 'SYSTEM_MOD', 'FALSE') ISMODIFIED,
       decode(bitand(ksppstvf, 2), 2, 'TRUE', 'FALSE') ISADJUSTED,
       decode(bitand(ksppilrmflg / 64, 1), 1, 'TRUE', 'FALSE') ISDEPRECATED,
       decode(bitand(ksppilrmflg / 268435456, 1), 1, 'TRUE', 'FALSE') ISBASIC ,nam.ksppdesc description
  FROM x$ksppi nam, x$ksppsv val
 WHERE nam.indx = val.indx
   AND (nam.ksppinm = DECODE('&parameter', 'all', nam.ksppinm, '&parameter') or
       nam.ksppinm LIKE '%&parameter%')
/
clear    breaks  
set verify on
set feedback on
set linesize 100 termout on feedback 6 heading on;
SET SERVEROUTPUT off
set echo on
