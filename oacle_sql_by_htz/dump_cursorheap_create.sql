------------------------------------------------------------
-- 《SQL优化与调优技术详解》                             ---
-- 文件：07_03_dump_cursorheap.sql                       ---
-- 作者：黄玮                                            ---
-- 网站：WWW.HelloDBA.COM                                ---
-- Coyprigh (c)：WWW.HelloDBA.COM 保留所有权利           ---
-- 描述：导出SQL游标内存堆信息                           ---
------------------------------------------------------------
create or replace procedure dump_cursorheap(sql_id varchar2,
                                            child_number number default null,
                                            heapindx number default null,
                                            dumplevel number default 2,
                                            filename varchar2 default null) as
------------------------------------------------------------
-- 描述：导出SQL游标内存堆信息                           ---
-- 来源：WWW.HelloDBA.COM                                ---
-- Coyprigh (c)：WWW.HelloDBA.COM 保留所有权利           ---
--                                                       ---
-- 参数描述                                              ---
--     sql_id：SQL语句的ID                               ---
--     child_number：子游标变化，默认为空，即所有子游标  ---
--     heapindx：子堆编号，默认为空，即所有子堆          ---
--     dumplevel：导出级别，默认为2                      ---
--     filename：导出的文件名标识符，                    ---
--               默认为SQL_ID和子游标编号                --- 
------------------------------------------------------------
  p_filename varchar2(100);
  p_obj varchar2(32767);
  p_objct varchar2(32767);
  p_addr raw(64);
  p_hash number;
  p_child_number number;
  p_heap0 raw(64);
  p_heap1 raw(64);
  p_heap2 raw(64);
  p_heap3 raw(64);
  p_heap4 raw(64);
  p_heap5 raw(64);
  p_heap6 raw(64);
  p_heap7 raw(64);
  p_heapnum number(38);
  p_heapraw raw(64);
  p_sub64 number;
  
  p_sql varchar2(32767);
  TYPE MyCurTyp  IS REF CURSOR;
  p_cur MyCurTyp;
begin
	p_sub64 := 8791798054912; -- 0x000007FF00000000

  p_sql := 'select kglnaobj, kglfnobj, kglhdpar, kglnahsh, kglobt09, kglobhd0,kglobhd1,kglobhd2,kglobhd3,kglobhd4,kglobhd5,kglobhd6,kglobhd7 from x$kglob where kglobt03='''||sql_id||'''';
  if child_number is not null then
    p_sql := p_sql||' and kglobt09='||child_number;
  end if;

  if filename is null then
    p_filename := sql_id;
    if child_number is not null then
      p_filename := p_filename||'_'||child_number;
    end if;
  end if;
  --dbms_output.put_line(p_sql);

  execute immediate 'alter session set tracefile_identifier = '''||p_filename||'''';
  dbms_system.ksdddt;

  open p_cur for p_sql;
  loop
    FETCH p_cur INTO p_obj, p_objct, p_addr, p_hash, p_child_number, p_heap0, p_heap1, p_heap2, p_heap3, p_heap4, p_heap5, p_heap6, p_heap7;
    EXIT WHEN p_cur%NOTFOUND;
    if p_cur%ROWCOUNT = 1 then
      dbms_system.ksdwrt(1, 'Address: 0x'||p_addr||'  Hash Value: '||p_hash);
      dbms_system.ksdwrt(1, 'Object Name: '||p_obj);
      dbms_system.ksdwrt(1, 'Object Content: '||p_objct);
    end if;
    dbms_output.put_line('Dumping child '||p_child_number||'....');
    dbms_system.ksdwrt(1, ' ');
    dbms_system.ksdwrt(1, '++++++++++++++++++++++++++++Begin dump child '||p_child_number||'++++++++++++++++++++++++++++');
    --p_heapnum := to_number(rawtohex(p_heap0),'XXXXXXXXXXXXXXXX');
    --if p_heapnum > p_sub64 then
    --  p_heapraw := hextoraw(trim(to_char(p_heapnum-p_sub64,'XXXXXXXXXXXXXXXX')));
    --end if; 
    --p_heapraw := p_heap0;
    --dbms_output.put_line('p_heapnum: '||to_char(p_heapnum-p_sub64,'XXXXXXXXXXXXXXXX')||' p_heap0: '||p_heapraw||'....');
    if (heapindx is null or bitand(heapindx,power(2,0))=power(2,0)) and p_heap0 <> '00' then
      dbms_system.ksdwrt(1, '----------------------------Begin Dump Heap0 (0x'||p_heap0||')-----------------------------');
      execute immediate 'alter session set events ''immediate trace name HEAPDUMP_ADDR level '||dumplevel||', address 0x'||p_heap0||'''';
      dbms_system.ksdwrt(1, '----------------------------End Dump Heap0 (0x'||p_heap0||')-----------------------------');
    end if;
    if (heapindx is null or bitand(heapindx,power(2,1))=power(2,1)) and p_heap1 <> '00' then
      dbms_system.ksdwrt(1, '----------------------------Begin Dump Heap1 (0x'||p_heap1||')-----------------------------');
      execute immediate 'alter session set events ''immediate trace name HEAPDUMP_ADDR level '||dumplevel||', address 0x'||p_heap1||'''';
      dbms_system.ksdwrt(1, '----------------------------End Dump Heap1 (0x'||p_heap1||')-----------------------------');
    end if;
    if (heapindx is null or bitand(heapindx,power(2,2))=power(2,2)) and p_heap2 <> '00' then
      dbms_system.ksdwrt(1, '----------------------------Begin Dump Heap2 (0x'||p_heap2||')-----------------------------');
      execute immediate 'alter session set events ''immediate trace name HEAPDUMP_ADDR level '||dumplevel||', address 0x'||p_heap2||'''';
      dbms_system.ksdwrt(1, '----------------------------End Dump Heap2 (0x'||p_heap2||')-----------------------------');
    end if;
    if (heapindx is null or bitand(heapindx,power(2,2))=power(2,2)) and p_heap3 <> '00' then
      dbms_system.ksdwrt(1, '----------------------------Begin Dump Heap3 (0x'||p_heap3||')-----------------------------');
      execute immediate 'alter session set events ''immediate trace name HEAPDUMP_ADDR level '||dumplevel||', address 0x'||p_heap3||'''';
      dbms_system.ksdwrt(1, '----------------------------End Dump Heap0 (0x'||p_heap3||')-----------------------------');
    end if;
    if (heapindx is null or bitand(heapindx,power(2,4))=power(2,4)) and p_heap4 <> '00' then
      dbms_system.ksdwrt(1, '----------------------------Begin Dump Heap0 (0x'||p_heap4||')-----------------------------');
      execute immediate 'alter session set events ''immediate trace name HEAPDUMP_ADDR level '||dumplevel||', address 0x'||p_heap4||'''';
      dbms_system.ksdwrt(1, '----------------------------End Dump Heap0 (0x'||p_heap4||')-----------------------------');
    end if;
    if (heapindx is null or bitand(heapindx,power(2,5))=power(2,5)) and p_heap5 <> '00' then
      dbms_system.ksdwrt(1, '----------------------------Begin Dump Heap5 (0x'||p_heap5||')-----------------------------');
      execute immediate 'alter session set events ''immediate trace name HEAPDUMP_ADDR level '||dumplevel||', address 0x'||p_heap5||'''';
      dbms_system.ksdwrt(1, '----------------------------End Dump Heap5 (0x'||p_heap5||')-----------------------------');
    end if;
    if (heapindx is null or bitand(heapindx,power(2,6))=power(2,6)) and p_heap6 <> '00' then
      dbms_system.ksdwrt(1, '----------------------------Begin Dump Heap6 (0x'||p_heap6||')-----------------------------');
      execute immediate 'alter session set events ''immediate trace name HEAPDUMP_ADDR level '||dumplevel||', address 0x'||p_heap6||'''';
      dbms_system.ksdwrt(1, '----------------------------End Dump Heap6 (0x'||p_heap6||')-----------------------------');
    end if;
    if (heapindx is null or bitand(heapindx,power(2,7))=power(2,7)) and p_heap7 <> '00' then
      dbms_system.ksdwrt(1, '----------------------------Begin Dump Heap7 (0x'||p_heap7||')-----------------------------');
      execute immediate 'alter session set events ''immediate trace name HEAPDUMP_ADDR level '||dumplevel||', address 0x'||p_heap7||'''';
      dbms_system.ksdwrt(1, '----------------------------End Dump Heap7 (0x'||p_heap7||')-----------------------------');
    end if;
    dbms_system.ksdwrt(1, '++++++++++++++++++++++++++++End dump child '||p_child_number||'++++++++++++++++++++++++++++');
  end loop;
  if p_cur%ROWCOUNT = 0 then
    dbms_system.ksdwrt(1, 'SQL not found!');
  end if;

  close p_cur;

  execute immediate 'alter session set tracefile_identifier = ''''';
end;
/


create or replace public synonym dump_cursorheap for sys.dump_cursorheap;
grant execute on dump_cursorheap to dba;
