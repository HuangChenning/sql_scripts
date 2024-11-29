create or replace procedure undump(i_vc_input in varchar2) is
  /*
  功能： 将dump出来的16进制文本内容翻译成其原始文本，目前仅支持ZHS16GBK和AL32UTF8字符集
  作者： dbsnake
  创建日期：2010-11-30
  输入参数：
  i_vc_input: 输入的dump出来的16进制文本内容
  输出参数：
  无
  输入输出参数：
  无
  调用到的存储过程：
  无
  */
  o_vc_return_flag    varchar2(4000);
  i_vc_input_compress varchar2(4000);
  vc_characterset     varchar2(4000);
  type type_character_number is table of number index by binary_integer;
  characters_number type_character_number;
  j                 number;
  n_temp            number;
  n_skipflag        number;
begin
  if (instr(i_vc_input, ', ') > 0) then
    i_vc_input_compress := trim(replace(i_vc_input, ', ', ”));
  elsif (instr(i_vc_input, ' ') > 0) then
    i_vc_input_compress := trim(replace(i_vc_input, ' ', ”));
  else
    i_vc_input_compress := trim(i_vc_input);
  end if;
  select value
    into vc_characterset
    from nls_database_parameters
   where parameter = 'NLS_CHARACTERSET';
  j          := 1;
  n_skipflag := 0;
  for i in 1 .. length(i_vc_input_compress) loop
    if (n_skipflag > 0) then
      n_skipflag := n_skipflag – 1;
    end if;
    if (n_skipflag = 0) then
      select to_number(substr(i_vc_input_compress, i, 2), 'XXXXXXXXXXXX')
        into n_temp
        from dual;
      if (n_temp < 128) then
        characters_number(j) := n_temp;
        j := j + 1;
        n_skipflag := 2;
      else
        if (vc_characterset = 'ZHS16GBK') then
          select to_number(substr(i_vc_input_compress, i, 4),
                           'XXXXXXXXXXXX')
            into n_temp
            from dual;
          characters_number(j) := n_temp;
          j := j + 1;
          n_skipflag := 4;
        elsif (vc_characterset = 'AL32UTF8') then
          select to_number(substr(i_vc_input_compress, i, 6),
                           'XXXXXXXXXXXX')
            into n_temp
            from dual;
          characters_number(j) := n_temp;
          j := j + 1;
          n_skipflag := 6;
        else
          select to_number(substr(i_vc_input_compress, i, 4),
                           'XXXXXXXXXXXX')
            into n_temp
            from dual;
          characters_number(j) := n_temp;
          j := j + 1;
          n_skipflag := 4;
        end if;
      end if;
    end if;
  end loop;
  if (characters_number.count > 0) then
    for k in characters_number.first .. characters_number.last loop
      if (characters_number(k) > 31) then
        dbms_output.put(chr(characters_number(k)));
      end if;
    end loop;
  end if;
  dbms_output.put_line(chr(10));
exception
  when others then
    o_vc_return_flag := 'E' || '_' || sqlcode || '_' || sqlerrm;
    dbms_output.put_line(o_vc_return_flag);
    return;
end undump;
/
