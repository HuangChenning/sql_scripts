/* 查看参数，包括隐藏参数 */
set echo off
set verify off
set lines 250
set pages 100
SET FEEDBACK OFF
COL INST_ID FOR 9 HEADING 'I'
COL NAME FOR A40
COL TYPE FOR A7
COL DISPLAY_VALUE FOR A20 HEADING 'DISPLAY|VALUE'
COL ISDEFAULT FOR A7 HEADING 'IS|DEFAULT'
COL ISSES_MODIFIABLE FOR A7 HEADING 'SESSION|MODIFY'
COL ISSYS_MODIFIABLE FOR A7 HEADING 'SYSTEM|MODIFY'
COL ISINSTANCE_MODIFIABLE FOR A8 HEADING 'INSTANCE|MODIFY'
COL ISMODIFIED FOR A8 HEADING 'IS|MODIFIED'
COL description FOR A50 HEADING 'DESCRIPTION'
COL cid for 999 heading 'CID'
col ISADJUSTED for a6 heading 'IS|ADJUST'
col ISDEPRECATED for a7 heading 'IS|DEPRECAT'
col ISBASIC for a5 heading 'IS|BASIC'
col ispdb for a5 heading 'IS|PDB'
break on inst_id
define _VERSION_12  = "--"
define _VERSION_11  = "--"


col version11  noprint new_value _VERSION_11
col version12  noprint new_value _VERSION_12

col version11  noprint new_value _VERSION_11
col version12  noprint new_value _VERSION_12

select case
         when 
              substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) <
              '12.1.0.2.0' then
          '  '
         else
          '--'
       end  version11,
       case
         when substr(banner,
                     instr(banner, 'Release ') + 8,
                     instr(substr(banner, instr(banner, 'Release ') + 8), ' ')) >=
              '12.1.0.2.0' then
          '  '
         else
          '--'
       end  version12
  from v$version
 where banner like 'Oracle Database%';

ACCEPT parameter prompt 'Enter Search Parameter Value (i.e. session) : '


SELECT nam.inst_id,
&_VERSION_12 nam.con_id cid,
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
       DECODE (BITAND (ksppiflg / 524288, 1), 1, 'TRUE', 'FALSE') ispdb,
       decode(bitand(ksppiflg, 4),
              4,
              'FALSE',
              decode(bitand(ksppiflg / 65536, 3), 0, 'FALSE', 'TRUE')) ISINSTANCE_MODIFIABLE,
       decode(bitand(ksppstvf, 7), 1, 'MODIFIED', 4, 'SYSTEM_MOD', 'FALSE') ISMODIFIED,
       decode(bitand(ksppstvf, 2), 2, 'TRUE', 'FALSE') ISADJUSTED,
       decode(bitand(ksppilrmflg / 64, 1), 1, 'TRUE', 'FALSE') ISDEPRECATED,
       decode(bitand(ksppilrmflg / 268435456, 1), 1, 'TRUE', 'FALSE') ISBASIC ,substr(nam.ksppdesc,1,60) description
  FROM x$ksppi nam, x$ksppsv val
 WHERE nam.indx = val.indx
   AND (nam.ksppinm = DECODE('&parameter', 'all', nam.ksppinm, '&parameter') or
       nam.ksppinm LIKE '%&parameter%')
/

