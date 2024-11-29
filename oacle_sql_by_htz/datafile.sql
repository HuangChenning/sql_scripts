set echo off;
set lines 300 pages 1000 heading on verify off;
break on tablespace

col  pdb_name          for  a8                       heading 'PDB_NAME';
col  tablespace_name   for  a15                      heading 'TABLESPACE';
col  file_id           for  9999                     heading 'FILE|ID';
col  RELATIVE_FNO      for  9999                     heading 'RFID';
col  status            for  a10                      heading 'STATUS';
col  bytes             for  99999                    heading 'SIZEM';
col  maxbytes          for  99999                    heading 'MSIZE';
col FILE_NAME          for  a90                      heading 'FILE_NAME';
col AUTOEXTENSIBLE     for  a5                       heading 'AUTO?';

define _VERSION_12  = "--"
define _VERSION_11  = "--"


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

undefine tablespace_name;
undefine file_id;
undefine pdb_name;
  SELECT 
&_VERSION_11  a.tablespace_name,                               
&_VERSION_11       a.file_name,                                     
&_VERSION_11       a.file_id,                                       
&_VERSION_11       a.RELATIVE_FNO,                                  
&_VERSION_11       substr(a.status,1,10) status, 
&_VERSION_11       a.AUTOEXTENSIBLE,                                        
&_VERSION_11       trunc(a.bytes / 1024 / 1024) bytes,              
&_VERSION_11       trunc(a.MAXBYTES / 1024 / 1024) maxbytes  
&_VERSION_11  from dba_data_files a                                 
&_VERSION_11 where a.tablespace_name =                              
&_VERSION_11       nvl(upper('&&tablespace_name'), a.tablespace_name)
&_VERSION_11   and a.file_id = nvl('&&file_id', a.file_id)           
&_VERSION_11 ORDER BY a.tablespace_name,a.file_id
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_11
&_VERSION_12 *   FROM (SELECT DECODE (b.name, '', 'CDB$ROOT', b.name) pdb_name,
&_VERSION_12                 c.name tablespace_name,
&_VERSION_12                 a.name file_name,
&_VERSION_12                 a.file# file_id,
&_VERSION_12                 a.rfile# RELATIVE_FNO,substr(a.status,1,10) status,
&_VERSION_12                 TRUNC (a.bytes / 1024 / 1024) bytes
&_VERSION_12            FROM v$datafile a, v$containers b,v$tablespace c
&_VERSION_12           WHERE     a.con_id = b.con_id(+) and c.con_id=a.con_id and c.ts#=a.ts#
&_VERSION_12                 AND c.name =
&_VERSION_12                        NVL (UPPER ('&&tablespace_name'), c.name)
&_VERSION_12                 AND a.file# = NVL ('&&file_id', a.file#)) c
&_VERSION_12   WHERE c.pdb_name = NVL (UPPER ('&&pdb_name'), c.pdb_name)
&_VERSION_12 ORDER BY pdb_name, tablespace_name, file_id
/
undefine tablespace_name;
undefine file_id;
undefine pdb_name
