set echo off
set verify off
undefine asm_datafile_name
undefine block_id_in_datafile
undefine number_of_blocks
undefine filesystem_filename

declare
  v_FsFileName  varchar2(4000);
  v_AsmFileName varchar2(4000);
  v_FsFileType  number;
  v_AsmFileType number;
  v_offstart    number;
  v_filesize    number;
  v_lbks        number;
  v_typename    varchar2(4000);
  v_handle      number;
  error         number;
  txt           varchar2(4000);
begin
  dbms_output.enable(500000);
  v_FsFileName  := '&filesystem_filename';
  v_AsmFileName := '&asm_datafile_name';
  v_offstart    := '&block_id_in_datafile';
  dbms_diskgroup.getfileattr(v_AsmFileName,
                             v_AsmFileType,
                             v_filesize,
                             v_lbks);
  select decode(v_AsmFileType,
                1,
                'Control File',
                2,
                'Data File',
                3,
                'Online Log File',
                4,
                'Archive Log',
                5,
                'Trace File',
                6,
                'Temporary File',
                7,
                'Not Used',
                8,
                'Not Used',
                9,
                'Backup Piece',
                10,
                'Incremental Backup Piece',
                11,
                'Archive Backup Piece',
                12,
                'Data File Copy',
                13,
                'Spfile',
                14,
                'Disaster Recovery Configuration',
                15,
                'Storage Manager Disk',
                16,
                'Change Tracking File',
                17,
                'Flashback Log File',
                18,
                'DataPump Dump File',
                19,
                'Cross Platform Converted File',
                20,
                'Autobackup',
                21,
                'Any OS file',
                22,
                'Block Dump File',
                23,
                'CSS Voting File',
                24,
                'CRS')
    into v_typename
    from dual;
  dbms_output.put_line('File: ' || v_AsmFileName);
  dbms_output.new_line;
  dbms_output.put_line('Type: ' || v_AsmFileType || ' ' || v_typename);
  dbms_output.new_line;
  dbms_output.put_line('Size: ' || v_filesize);
  dbms_output.new_line;
  dbms_output.put_line('Logical Block Size: ' || v_lbks);
  dbms_output.new_line;
  dbms_diskgroup.patchfile(v_FsFileName,
                           12,
                           v_lbks,
                           1,
                           0,
                           1,
                           v_AsmFileName,
                           v_AsmFileType,
                           v_offstart,
                           0);
end;
/

undefine asm_datafile_name
undefine block_id_in_datafile
undefine number_of_blocks
undefine filesystem_filename