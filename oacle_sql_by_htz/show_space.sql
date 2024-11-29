set echo off;
set lines 200;
set pages 40;
set verify off;
set serveroutput on;
PROMPT SEGMENT_TYPE:TABLE,INDEX
DECLARE
  p_space              varchar2(10);
  p_segname            varchar2(100);
  p_type               varchar2(10);
  p_owner              varchar2(30);
  p_analyzed           number;
  p_padlen             number;
  l_unformatted_blocks number;
  l_unformatted_bytes  number;
  l_fs1_blocks         number;
  l_fs1_bytes          number;
  l_fs2_blocks         number;
  l_fs2_bytes          number;
  l_fs3_blocks         number;
  l_fs3_bytes          number;
  l_fs4_blocks         number;
  l_fs4_bytes          number;
  l_full_blocks        number;
  l_full_bytes         number;
  l_free_blks          number;
  l_total_blocks       number;
  l_total_bytes        number;
  l_unused_blocks      number;
  l_unused_bytes       number;
  l_LastUsedExtFileId  number;
  l_LastUsedExtBlockId number;
  l_LAST_USED_BLOCK    number;
begin
  p_owner   := upper('&segment_owner');
  p_segname := upper('&object_name');
  p_type    := upper('&segment_type');
  p_padlen  := 60;

  dbms_space.unused_space(segment_owner             => p_owner,
                          segment_name              => p_segname,
                          segment_type              => p_type,
                          total_blocks              => l_total_blocks,
                          total_bytes               => l_total_bytes,
                          unused_blocks             => l_unused_blocks,
                          unused_bytes              => l_unused_bytes,
                          LAST_USED_EXTENT_FILE_ID  => l_LastUsedExtFileId,
                          LAST_USED_EXTENT_BLOCK_ID => l_LastUsedExtBlockId,
                          LAST_USED_BLOCK           => l_LAST_USED_BLOCK);

  execute immediate 'select segment_space_management
    from dba_tablespaces ts, dba_segments s
    where owner=:seg_owner and segment_name=:seg_name and s.tablespace_name = ts.tablespace_name'
    into p_space
    using p_owner, p_segname;

  if p_space = 'MANUAL' or (p_space <> 'auto' and p_space <> 'AUTO') then
    dbms_space.free_blocks(segment_owner     => p_owner,
                           segment_name      => p_segname,
                           segment_type      => p_type,
                           freelist_group_id => 0,
                           free_blks         => l_unused_blocks);
    --dbms_output.put_line(rpad('Free Blocks', p_padlen, '.') || l_free_blks);
  end if;

  dbms_output.put_line(rpad('Total Blocks', p_padlen, '.') ||
                       l_total_blocks);
  dbms_output.put_line(rpad('Total Bytes', p_padlen, '.') || l_total_bytes);
  dbms_output.put_line(rpad('Unformatted Blocks above HiHWM',
                            p_padlen,
                            '.') || l_unused_blocks);
  dbms_output.put_line(rpad('Unformatted Bytes above HiHWM', p_padlen, '.') ||
                       l_unused_bytes);
  dbms_output.put_line(rpad('Last Used Ext FileId', p_padlen, '.') ||
                       l_LastUsedExtFileId);
  dbms_output.put_line(rpad('Last Used Ext BlockId', p_padlen, '.') ||
                       l_LastUsedExtBlockId);
  dbms_output.put_line(rpad('Last Used Block', p_padlen, '.') ||
                       l_LAST_USED_BLOCK);
  dbms_output.put_line(rpad('Blocks under HWM', p_padlen, '.') ||
                       (l_total_blocks - l_unused_blocks));
  execute immediate 'select count(1)
    from dual
   where exists (select 1 from dba_tab_statistics
           where owner = :seg_owner
             and table_name = :seg_name)
      or exists (select 1 from dba_ind_statistics
           where owner = :seg_owner
             and index_name = :seg_name)'
    into p_analyzed
    using p_owner, p_segname, p_owner, p_segname;
  if p_analyzed > 0 or p_type = 'LOB' then
    dbms_space.space_usage(segment_owner      => p_owner,
                           segment_name       => p_segname,
                           segment_type       => p_type,
                           unformatted_blocks => l_unformatted_blocks,
                           unformatted_bytes  => l_unformatted_bytes,
                           fs1_blocks         => l_fs1_blocks,
                           fs1_bytes          => l_fs1_bytes,
                           fs2_blocks         => l_fs2_blocks,
                           fs2_bytes          => l_fs2_bytes,
                           fs3_blocks         => l_fs3_blocks,
                           fs3_bytes          => l_fs3_bytes,
                           fs4_blocks         => l_fs4_blocks,
                           fs4_bytes          => l_fs4_bytes,
                           full_blocks        => l_full_blocks,
                           full_bytes         => l_full_bytes);
    dbms_output.put_line(rpad(' ', p_padlen + 20, '*'));
    dbms_output.put_line('Data blocks usage details:');
  
    dbms_output.put_line(rpad('Full blocks', p_padlen, '.') ||
                         l_full_blocks);
    dbms_output.put_line(rpad('Full bytes', p_padlen, '.') || l_full_bytes);
    dbms_output.put_line(rpad('0% -- 25% free space blocks', p_padlen, '.') ||
                         l_fs1_blocks);
    dbms_output.put_line(rpad('0% -- 25% free space bytes', p_padlen, '.') ||
                         l_fs1_bytes);
    dbms_output.put_line(rpad('25% -- 50% free space blocks',
                              p_padlen,
                              '.') || l_fs2_blocks);
    dbms_output.put_line(rpad('25% -- 50% free space bytes', p_padlen, '.') ||
                         l_fs2_bytes);
    dbms_output.put_line(rpad('50% -- 75% free space blocks',
                              p_padlen,
                              '.') || l_fs3_blocks);
    dbms_output.put_line(rpad('50% -- 75% free space bytes', p_padlen, '.') ||
                         l_fs3_bytes);
    dbms_output.put_line(rpad('75% -- 100% free space blocks',
                              p_padlen,
                              '.') || l_fs4_blocks);
    dbms_output.put_line(rpad('75% -- 100% free space bytes',
                              p_padlen,
                              '.') || l_fs4_bytes);
    dbms_output.put_line(rpad('Unformatted blocks bewteen LoHWM and HiHWM',
                              p_padlen,
                              '.') || l_unformatted_blocks);
    dbms_output.put_line(rpad('Unformatted bytes bewteen LoHWM and HiHWM',
                              p_padlen,
                              '.') || l_unformatted_bytes);
    dbms_output.put_line(rpad('Useful(Formatted) blocks', p_padlen, '.') ||
                         (l_fs1_blocks + l_fs2_blocks + l_fs3_blocks +
                          l_fs4_blocks + l_full_blocks));
    dbms_output.put_line(rpad('Useful(Formatted) bytes', p_padlen, '.') ||
                         (l_fs1_bytes + l_fs2_bytes + l_fs3_bytes +
                          l_fs4_bytes + l_full_bytes));
  end if;
end;
/
undefine  segment_owner;
undefine   object_name ;
undefine  segment_type; 