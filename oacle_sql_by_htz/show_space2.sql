create or replace procedure show_space(ownname in varchar2 default user,
                                       segname in varchar2,
                                       parname in varchar2 default NULL) as
  p_segname            varchar2(100);
  p_type               varchar2(20);
  p_owner              varchar2(30);
  p_partition          varchar2(50);
  p_space              varchar2(10);
  p_analyzed           varchar2(20);
  v_out                varchar2(100);
  v_out1               varchar2(100);

  is_partition varchar2(20);
  count_object_type number(4);

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

  procedure p(p_label in varchar2, p_num in number) is
  begin
    dbms_output.put_line(rpad(p_label, 40, '.') || p_num);
  end;
begin
  DBMS_OUTPUT.ENABLE (buffer_size=>null);
  p_segname := upper(segname);
  p_owner   := upper(ownname);

  ------------------
  /*
  判断对象类型,是分区类型还是一般类型
  */

  select count(1)
    into count_object_type
    from dba_objects
   where owner = p_owner
     and object_name = p_segname;

  if count_object_type = 1 then
     select object_type
      into p_type
      from dba_objects
     where owner = p_owner
       and object_name = p_segname
       and rownum <2;
  else
    select object_type||' PARTITION'
      into p_type
      from dba_objects
     where owner = p_owner
       and object_name = p_segname
       and rownum <2;
  end if;

 /*
  如果是分区类型
  可以取该分区对象中的第一个对象或则循环取出所有对象
  这里取第一个对象

  */
  ------------
  if parname is not null then
    p_partition := upper(parname);
  else
    if count_object_type > 1 then

      select subobject_name
        into p_partition
        from dba_objects
       where owner = p_owner
         and object_name = p_segname
         and subobject_name is not null
         and rownum < 2;
    end if;
  end if;


  /*
  判断是ASSM还是MSSM
  */
  select segment_subtype
    into p_space
    from dba_segments
   where owner = p_owner
     and segment_name = p_segname
     and rownum < 2;




  --dbms_output.put_line(p_type);

  /*
  判断是否做了表分析
  */
  p_analyzed := null;

  if p_type = 'TABLE' then
    select to_char(last_analyzed,'yyyy-mm-dd hh24:mi:ss')
      into p_analyzed
      from dba_tables
     where owner = p_owner
       and table_name = p_segname;
  end if;

  if p_type = 'INDEX' then
    select to_char(last_analyzed,'yyyy-mm-dd hh24:mi:ss')
      into p_analyzed
      from dba_indexes
     where owner = p_owner
       and index_name = p_segname;
  end if;



  /*判断是否是分区对象*/
  if p_partition is null then
    ---非分区对象
    ---根据ASSM还是MSSM来选择执行unused_space或则free_blocks
    if (p_space = 'ASSM') then
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
    else
      dbms_space.free_blocks(segment_owner     => p_owner,
                             segment_name      => p_segname,
                             segment_type      => p_type,
                             freelist_group_id => 0,
                             free_blks         => l_free_blks);
      p('Free Blocks', l_free_blks);

    end if;

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


    ---是分区对象
  else
    if (p_space = 'ASSM') then

      select object_type
        into p_type
        from dba_objects
       where owner = p_owner
         and subobject_name = p_partition
         and rownum < 2;

      /*
      dbms_output.put_line(p_type);
      dbms_output.put_line(p_partition);
      */


      dbms_space.unused_space(segment_owner             => p_owner,
                              segment_name              => p_segname,
                              segment_type              => p_type,
                              total_blocks              => l_total_blocks,
                              total_bytes               => l_total_bytes,
                              unused_blocks             => l_unused_blocks,
                              unused_bytes              => l_unused_bytes,
                              LAST_USED_EXTENT_FILE_ID  => l_LastUsedExtFileId,
                              LAST_USED_EXTENT_BLOCK_ID => l_LastUsedExtBlockId,
                              LAST_USED_BLOCK           => l_LAST_USED_BLOCK,
                              partition_name            => p_partition);
    else

      select object_type
        into p_type
        from dba_objects
       where owner = p_owner
         and object_name = p_segname
         and rownum < 2;

      dbms_space.free_blocks(segment_owner     => p_owner,
                             segment_name      => p_segname,
                             segment_type      => p_type,
                             freelist_group_id => 0,
                             free_blks         => l_free_blks,
                             partition_name    => p_partition);
      p('Free Blocks', l_free_blks);
    end if;

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
                           full_bytes         => l_full_bytes,
                           partition_name => p_partition);
  end if;


/*
输出结果
*/
    p('Total Blocks', l_total_blocks);
    p('Total Bytes', l_total_bytes);
    p('Unused Blocks', l_unused_blocks);
    p('Unused Bytes', l_unused_bytes);
    p('Last Used Ext FileId', l_LastUsedExtFileId);
    p('Last Used Ext BlockId', l_LastUsedExtBlockId);
    p('Last Used Block', l_LAST_USED_BLOCK);

  dbms_output.put_line(rpad(' ', 50, '*'));

  v_out1 := 'The segment '||p_owner||'.'||p_segname||' type is '||p_type;
  dbms_output.put_line(v_out1);
  if p_analyzed is null then
    v_out := 'The segment '||p_owner||'.'||p_segname||' is not analyzed';
    dbms_output.put_line(v_out);
  else
    v_out := 'The segment '||p_owner||'.'||p_segname||' is analyzed('||p_analyzed||')';
     dbms_output.put_line(v_out);
  end if;
    dbms_output.put_line(rpad(' ', 50, '*'));
    p('0% -- 25% free space blocks', l_fs1_blocks);
    p('0% -- 25% free space bytes', l_fs1_bytes);
    p('25% -- 50% free space blocks', l_fs2_blocks);
    p('25% -- 50% free space bytes', l_fs2_bytes);
    p('50% -- 75% free space blocks', l_fs3_blocks);
    p('50% -- 75% free space bytes', l_fs3_bytes);
    p('75% -- 100% free space blocks', l_fs4_blocks);
    p('75% -- 100% free space bytes', l_fs4_bytes);
    p('Unused Blocks', l_unformatted_blocks);
    p('Unused Bytes', l_unformatted_bytes);
    p('Total Blocks', l_full_blocks);
    p('Total bytes', l_full_bytes);
end;
/