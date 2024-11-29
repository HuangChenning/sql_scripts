set echo off feedback off timing off pause off verify off def off
set heading off pagesize 10000 linesize 1000 trimout on termout off serverout on FEEDBACK off def off trim on trimspool on
spool check9.php
alter session set nls_language='simplified chinese';

declare

  dbversion            varchar2(4):='0';
  sum_time_waited      number:=0;
  pct_time_waited      number:=0;
  even_row_color       varchar2(7) := '#ffffff';
  odd_row_color        varchar2(7) := '#ffffff';
  head_row_color       varchar2(7) := '#c0c0c0';
  title                varchar2(200);
  col_value            varchar2(200);
  cursor_sql_text      varchar2(200);
  inst_id              number:=1;
  head                 varchar2(200):='Event,Total<br>Waits<br>(Seconds),Time<br>Waited<br>(Hours),Total<br>TimeOuts<br>(Seconds),Average<br>Wait<br>(Seconds),PCT<br>Waited,';
  font                 varchar2(10):= chr(52174)||chr(52453);
  cn_none              varchar2(10):= chr(52958)||chr(41915);
  cn_group             varchar2(10):= chr(55273);
  cn_never             varchar2(10):= chr(46291)||chr(52916)||chr(47062)||chr(52982);

  type table_cell2 is table of  varchar2(4000) index by binary_integer ;
  t_cell2 table_cell2;

  type type_system_event is record
     (
      event          varchar2(60),
      total_waits    number,
      total_timeouts number,
      time_waited    number,
      average_wait   number
      );
  type table_system_event is table of  type_system_event index by binary_integer ;
  system_event table_system_event;

 cursor c9(var_inst_id number) is
 select event, total_waits,total_timeouts,time_waited, average_wait
  from (
       select a.EVENT,
       a.TOTAL_WAITS,
       a.TIME_WAITED,
       a.TOTAL_TIMEOUTS,
       b.INSTANCE_NAME,
       a.average_wait,
       rank() over(partition by instance_name order by event, time_waited desc) seq,
       rank() over(partition by event order by instance_name) inst
       from gv$system_event a,
       (select inst_id, value instance_name
          from gv$parameter
         where name = 'instance_name') b
 where a.INST_ID = b.INST_ID
   and (time_waited / 360000) >= 0.01
   and event not in
       ('SQL*Net message from client', 'rdbms ipc message', 'slave wait',
        'pmon timer', 'smon timer', 'rdbms ipc reply',
        'SQL*Net message to client', 'SQL*Net break/reset to client',
        'inactive session', 'Null event')
 order by time_waited desc)
 where inst=var_inst_id;

procedure wait(var_inst_id in number) is
begin
   open c9(var_inst_id);
   fetch c9 bulk collect into system_event;
   close c9;

for  i in 1..system_event.count
  loop
  sum_time_waited:=sum_time_waited+system_event(i).time_waited;
  end loop;

for  i in 1..system_event.count
  loop
  pct_time_waited:=round(system_event(i).time_waited/sum_time_waited,4)*100;
  system_event(i).time_waited:=round(system_event(i).time_waited/360000,2);
  system_event(i).total_waits:=round(system_event(i).total_waits/1000,2);
  system_event(i).total_timeouts:=round(system_event(i).total_timeouts/1000,2);
  system_event(i).average_wait:=round(system_event(i).average_wait/1000,2);
  if i = 1 then
      dbms_output.enable(1000000);
      dbms_output.put_line('$event' || var_inst_id||'="<table width=73% border=1 cellspacing=0 cellpadding=0 style=''margin-left:149pt;border-collapse:collapse;border:none;mso-border-alt:solid white .5pt;mso-padding-alt:0cm 5.4pt 0cm 5.4pt''><tr bgcolor=' ||head_row_color || '>');
      for j in 1 .. 6 loop
        select substr(head,
                      decode(j, 1, 1, instr(head, ',', 1, j - 1) + 1),
                      instr(head, ',', 1, j) -
                      decode(j, 1, 1, instr(head, ',', 1, j - 1) + 1))
          into title
          from dual;
        --dbms_output.put_line('<td style=''border:solid windowtext .5pt''><p class=MsoNormal style=''line-height:100%><span lang=EN-US style=''font-size:9.0pt;font-family:ËÎÌו;text-align:justify;text-justify:inter-ideograph>' ||title || '</span></p></td>');
        dbms_output.put_line('<td style=''border:solid white .5pt''><span style=''font-size:9.0pt;font-family:'||font||'''>' ||title || '</span></td>');
      end loop;
      dbms_output.put_line('</tr>');
    else
      if mod(i, 2) = 1 then
        dbms_output.put_line('<tr bgcolor=' || odd_row_color || '>');
      else
        dbms_output.put_line('<tr bgcolor=' || even_row_color || '>');
      end if;
    end if;
    for j in 1 .. 6 loop
      select decode(j,
              1,system_event(i).event,
              2,to_char(system_event(i).total_waits),
              3,to_char(system_event(i).time_waited),
              4,to_char(system_event(i).total_timeouts),
              5,to_char(system_event(i).average_wait),
              6,to_char(pct_time_waited)||'%')
      into col_value  from dual;
      dbms_output.put_line('<td style=''border:solid white .5pt''><span style=''font-size:9.0pt;font-family:'||font||'''>'||col_value||'</span></td>');
    end loop;
    dbms_output.put_line('</tr>');
    exit when i=5;
  end loop;
  if system_event.count>0 then
    dbms_output.put_line('</table>";');
  end if;
end;

procedure cell1(var     in varchar2,
                p_query in varchar2,
                head    in varchar2) is
  l_theCursor    integer default dbms_sql.open_cursor;
  l_columnValue  varchar2(4000);
  l_status       integer;
  l_descTbl      dbms_sql.desc_tab;
  l_colCnt       number;
  l_rowCnt       number := 0;
  even_row_color       varchar2(7) := '#ffffff';
  odd_row_color        varchar2(7) := '#ffffff';
  head_row_color       varchar2(7) := '#c0c0c0';
begin
  dbms_sql.parse(l_theCursor, p_query, dbms_sql.native);
  dbms_sql.describe_columns(l_theCursor, l_colCnt, l_descTbl);

  for i in 1 .. l_colCnt loop
    dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
  end loop;

  l_status := dbms_sql.execute(l_theCursor);
  dbms_output.enable(1000000);

  while (dbms_sql.fetch_rows(l_theCursor) > 0) loop
    if l_rowcnt = 0 then
      --dbms_output.put_line('$' || var ||'="<table width=73% border=1 cellspacing=0 cellpadding=0 style=''margin-left:149pt;border-collapse:collapse;border:none;mso-border-alt:solid white .5pt;mso-padding-alt:0cm 5.4pt 0cm 5.4pt''><tr bgcolor=' ||odd_row_color || '>');
      dbms_output.put_line('$' || var ||'="<table width=73% border=1 cellspacing=0 cellpadding=0 style=''margin-left:149pt;border-collapse:collapse;border:none;mso-border-alt:solid white .5pt;mso-padding-alt:0cm 5.4pt 0cm 5.4pt''><tr bgcolor=' ||head_row_color || '>');
      for i in 1 .. l_colcnt loop
        select substr(head,
                      decode(i, 1, 1, instr(head, ',', 1, i - 1) + 1),
                      instr(head, ',', 1, i) -decode(i, 1, 1, instr(head, ',', 1, i - 1) + 1))
          into title  from dual;
        dbms_output.put_line('<td style=''border:solid white .5pt''><span style=''font-size:9.0pt;font-family:'||font||'''>'||title ||'</span></td>');
      end loop;
      dbms_output.put_line('</tr>');
      l_rowCnt := l_rowcnt + 1;
    else
      if mod(l_rowcnt, 2) = 1 then
        dbms_output.put_line('<tr bgcolor=' || odd_row_color || '>');
      else
        dbms_output.put_line('<tr bgcolor=' || even_row_color || '>');
      end if;
    end if;
    for i in 1 .. l_colCnt loop
      dbms_sql.column_value(l_theCursor, i, l_columnValue);
      l_columnValue:=replace(l_columnValue,'"','\"');
      l_columnValue:=substr(l_columnValue,1,160);
      dbms_output.put_line('<td style=''border:solid white .5pt''><span style=''font-size:9.0pt;font-family:'||font||'''>'||l_columnvalue || '</span></td>');
    end loop;
    dbms_output.put_line('</tr>');
    l_rowCnt := l_rowcnt + 1;
  end loop;
  if l_rowcnt >= 1 then
    dbms_output.put_line('</table>";');
    else dbms_output.put_line('$'||var||'="<span style=''font-size:9.0pt;font-family:'||font||';text-align:left''>'||cn_none||'</span>";');
  end if;
end;

procedure cell2(var     in varchar2,
                p_query in varchar2) is
  l_theCursor    integer default dbms_sql.open_cursor;
  l_columnValue  varchar2(4000);
  l_status       integer;
  l_descTbl      dbms_sql.desc_tab;
  l_colCnt       number;
  l_rowCnt       number:= 0;
  l_result       varchar2(4000);
  l_piece        number:=0;

begin

  dbms_sql.parse(l_theCursor, p_query, dbms_sql.native);
  dbms_sql.describe_columns(l_theCursor, l_colCnt, l_descTbl);

  for i in 1 .. l_colCnt loop
    dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
  end loop;

  l_status := dbms_sql.execute(l_theCursor);

  while (dbms_sql.fetch_rows(l_theCursor) > 0) loop
  l_rowCnt:=l_rowCnt+1;
  dbms_sql.column_value(l_theCursor, 1, l_columnValue);
  t_cell2(l_rowCnt):=l_columnValue;
  end loop;
  dbms_output.enable(1000000);
  for r in 1..l_rowCnt  loop
     l_result:='';
      l_columnValue:=t_cell2(r);
      --l_columnValue:=replace(l_columnValue,' ','&nbsp');
      l_columnValue:=replace(l_columnValue,'"','\"');
      l_columnValue:=replace(l_columnValue,'$','');
      l_result:=l_result||l_columnValue;
      if r = 1 then l_result:='$' || var ||'="'||l_result; end if;
      if r<l_rowCnt then l_result:=l_result||'<br>'; end if;
      if r=l_rowCnt then l_result:=l_result||'";'; end if;
      dbms_output.put_line(l_result);
  end loop;
  if l_rowcnt=0 then dbms_output.put_line('$'||var||'="<span style=''font-size:9.0pt;font-family:'||font||';text-align:left''>'||cn_none||'</span>";');
  end if;
end;

procedure cell3(var     in varchar2,
                p_query in varchar2) is
  l_theCursor    integer default dbms_sql.open_cursor;
  l_columnValue  varchar2(4000);
  l_status       integer;
  l_descTbl      dbms_sql.desc_tab;
  l_colCnt       number;
  l_rowCnt       number := 0;
  l_result       varchar2(4000);

begin
  dbms_sql.parse(l_theCursor, p_query, dbms_sql.native);
  dbms_sql.describe_columns(l_theCursor, l_colCnt, l_descTbl);

  for i in 1 .. l_colCnt loop
    dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
  end loop;

  l_status := dbms_sql.execute(l_theCursor);

  while (dbms_sql.fetch_rows(l_theCursor) > 0) loop
  l_rowCnt:=l_rowCnt+1;
  dbms_sql.column_value(l_theCursor, 1, l_columnValue);
  t_cell2(l_rowCnt):=l_columnValue;
  end loop;
  dbms_output.enable(1000000);

   for r in 1..l_rowCnt loop
      l_columnValue:=t_cell2(r);
      l_columnValue:=replace(l_columnValue,'''','''''');
      l_columnValue:=replace(l_columnValue,'"','');
      l_result:=l_result||l_columnValue;
      if r = 1 then l_result:='$' || var ||'="'||l_result; end if;
      if r<l_rowCnt then l_result:=l_result||','; end if;
      if r=l_rowCnt then l_result:=l_result||'";'; end if;
  end loop;
  dbms_output.put_line(substrb(l_result,1,255));
end;

begin
dbms_output.put_line('<?php');
cell3('inst1','select instance_name from (select instance_name,rownum id from gv$instance order by 1) where id=1');
cell3('inst2','select instance_name from (select instance_name,rownum id from gv$instance order by 1) where id=2');
cell3('instance_name','select value from gv$parameter where name=''instance_name'' order by 1');
cell3('server_name','select value from v$parameter where name=''service_names''');
cell3('db_version','select substr(substr(banner,instr(banner,''Release'')+8),1,instr(substr(banner,instr(banner,''Release'')+8),'' '')-1)a from v$version where banner like ''%Edition%''');
cell3('sql_version','select substr(substr(banner,instr(banner,''Release'')+8),1,instr(substr(banner,instr(banner,''Release'')+8),'' '')-1)a from v$version where banner like ''%SQL%''');
cell3('disk_space','select to_char(round(sum(bytes)/1024/1024))||'' M'' a from v$datafile');
cell3('disk_used','select round(sum(a.total - floor(b.free))) ||'' M'' a from (select tablespace_name n1, sum(bytes) / 1024 / 1024 total from dba_data_files group by tablespace_name) a, (select tablespace_name n2, sum(bytes) / 1024 / 1024 free from dba_free_space group by tablespace_name) b where a.n1 = b.n2');
cell3('nls_territory','select value from v$parameter where name=''nls_territory''');
cell3('nls_language','select value from v$parameter where name=''nls_language''');
cell3('nls_characterset','select value$  from sys.props$ where name=''NLS_CHARACTERSET''');
cell3('nls_nchar_characterset','select value$  from sys.props$ where name=''NLS_NCHAR_CHARACTERSET''');
cell3('sum_sga','select ltrim(to_char(sum(value),''999,999,999,999''))sum_sga from v$sga');
cell3('db_block_size','select value from v$parameter where name=''db_block_size''');
cell3('shared_pool','select ''  ''||ltrim(to_char(value,''999,999,999,999'')) shared_pool from v$parameter where name=''shared_pool_size''');
cell3('data_buffer','select case when (select to_number(substr(substr(banner,instr(banner,''Release'')+8),1,instr(substr(banner,instr(banner,''Release'')+8),''.'')-1)) from v$version where banner like ''%Edition%'') in (7,8) then ''  '' || ltrim(to_char(((select value from v$parameter where name = ''db_block_buffers'') * (select value from v$parameter where name = ''db_block_size'')),''999,999,999,999'')) || ''('' || (select value|| ''*'' ||(select value from v$parameter where name = ''db_block_size'') from v$parameter where name = ''db_block_buffers'') || '')'' else (select ''  '' || ltrim(to_char(value, ''999,999,999,999'')) from v$parameter where name = ''db_cache_size'') end db_buffer from dual');
cell3('large_pool','select ''  ''||ltrim(to_char(value,''999,999,999,999'')) lp from v$parameter where name=''large_pool_size''');
cell3('java_pool','select ''  ''||ltrim(to_char(value,''999,999,999,999'')) jp from v$parameter where name=''java_pool_size''');
cell3('sort_size','select ltrim(to_char(value,''999,999,999,999'')) sz from v$parameter where name=''sort_area_size''');
cell3('nls_ter','select value from v$parameter where name=''nls_territory''');
cell3('nls_lang','select value from v$parameter where name=''nls_language''');
cell3('tablespace_count','select to_char(count(1))a from v$tablespace');
cell3('datafile_count','select to_char(count(1)) from v$datafile');
cell2('temp_size','select round(sum(tmp) / 1024 / 1024, 2)||''M'' ts from (select nvl(sum(bytes), 0) tmp from v$tablespace a, v$datafile b, dba_tablespaces c where contents = ''TEMPORARY'' and a.ts# = b.ts# and a.name = c.tablespace_name union all select sum(bytes) from v$tempfile)');
cell3('control_count','select to_char(count(1)) from v$controlfile');
cell3('redo_size','select distinct bytes/1024/1024||''M'' from v$log');
cell3('redo_files_pgp','select distinct to_char(count(1)) from v$logfile group by group#');
cell3('redo_same_size','select decode(count(distinct bytes),1,''YES'',''NO'') online_log_the_same_size from v$log');
cell3('redo_group_mulited','select decode((cnt),1,''NO'',''YES'') rmt from (select distinct cnt from  (select count(1)cnt from v$logfile group by group#))');
cell3('archive_mode','select decode(log_mode,''ARCHIVELOG'',''YES'',''NO'') am from v$database');
cell3('temp_tablespace','select b.tablespace_name||'' ''||sum(bytes)/1024/1024||''M*'' tmpfl from dba_data_files a,dba_tablespaces b where a.tablespace_name=b.tablespace_name and b.contents=''TEMPORARY'' group by b.tablespace_name union all select tablespace_name||'' ''||sum(bytes)/1024/1024||''M'' from dba_temp_files group by tablespace_name');
cell3('processes','select value from v$parameter where name=''processes''');
cell3('host_name','select host_name from gv$instance order by 1');
cell2('undo_space','select a.name||''  ''||sum(bytes)/1024/1024||''M''udo from v$tablespace a,v$datafile b where a.TS#=b.TS# and a.NAME in (select distinct tablespace_name from dba_rollback_segs where tablespace_name<>''SYSTEM'') group by a.name');
cell2('redo_tgroup','select b.instance_name ||chr(41914)||count(1)||chr(55273) tg from v$log a, (select inst_id, value instance_name from gv$parameter where name = ''instance_name'') b, gv$instance c   where a.thread# = c.THREAD# and c.INST_ID = b.inst_id group by b.instance_name order by b.instance_name');
cell3('roll_file_name','select ''rollstat_''||host_name||''.lst'' from gv$instance');

cell1('tablespace_io','select tablespace_name name,sum(f.phyblkrd) phyblkrd, sum(f.phyblkwrt) phyblkwrt, instance_name from gv$filestat f, dba_data_files fs, (select inst_id,value instance_name from gv$parameter where name=''instance_name'') ins where f.file# = fs.file_id and f.INST_ID = ins.INST_ID group by tablespace_name, ins.INSTANCE_NAME order by 4, 2, 3 desc','Tablespace&nbsp;name,Physical<br>Blks&nbsp;Read,Physical<br>Blks&nbsp;Wrtn,Instance<br>Name,');
cell1('tablespace_free','select spacename, sum(totalsize) totalsize, sum(used) usedsize, sum(totalfree) totalfree, pct_free from (select a.n1  spacename, a.total totalsize, a.total - floor(b.free) used,floor(b.free) totalfree,floor(b.free / a.total * 100) || ''%'' pct_free from (select tablespace_name n1, sum(bytes) / 1024 / 1024 total from dba_data_files group by tablespace_name) a, (select tablespace_name n2, sum(bytes) / 1024 / 1024 free from dba_free_space group by tablespace_name)  b where a.n1 = b.n2 order by floor(b.free / a.total * 100)) group by rollup(((spacename), pct_free))','Tablespace&nbsp;Name,SIZE,USED,FREE,FREE%,');
cell1('temp_spaces','select tablespace_name,initial_extent/1024,next_extent/1024,pct_increase from dba_tablespaces where contents=''TEMPORARY''','Tablespace_Name,Initial_extent(K),Next_extent(K),PCT_INCREASE,');
cell1('file_io','select fs.name name, f.phyblkrd, f.phyblkwrt, instance_name from gv$filestat f, gv$dbfile fs, (select inst_id,value instance_name from gv$parameter where name=''instance_name'') ins where f.file# = fs.file# and ins.INST_ID = f.INST_ID and fs.INST_ID=f.INST_ID order by 4, 2, 3 desc','DataFile&nbsp;Name,Physical<br>Blks&nbsp;Read,Physical<br>Blks&nbsp;Wrtn,Instance&nbsp;Name,');
cell1('log_file','select c.INSTANCE_NAME,a.GROUP#,b.STATUS,b.MEMBER,a.BYTES/1024/1024 M from gv$log a,gv$logfile b,(select inst_id,value instance_name from gv$parameter where name=''instance_name'') c where a.GROUP#=b.GROUP# and b.INST_ID=c.INST_ID order by 1,2','Instance,Group#,Member<br>Status,Member,Size(M),');
cell1('data_file','select file#,name,status,bytes/1024/1024 M from v$datafile','File#,Name,Status,Size(M),');
cell1('temp_file','select file_id,tablespace_name,status,file_name,bytes/1024/1024 M from dba_temp_files','File#,Tablespac&nbsp;Name,Status,File_name,Size(M),');
cell1('tablespace_type','select tablespace_name spacename,STATUS,CONTENTS,LOGGING,EXTENT_MANAGEMENT,allOCATION_TYPE from dba_tablespaces','TABLESPACE&nbsp;NAME,STATUS,CONTENTS,LOGGING,EXTENT<br>MANAGEMENT,ALLOCATE,');
cell1('roll_backs','select segment_name,tablespace_name,initial_extent,next_extent,min_extents,max_extents,pct_increase,b.INSTANCE_NAME from dba_rollback_segs a,(select a.inst_id, value instance_name, b.HOST_NAME,b.INSTANCE_NUMBER from gv$parameter a, gv$instance b where name = ''instance_name'' and a.INST_ID = b.INST_ID) b where a.instance_num = b.INSTANCE_NUMBER(+)','Segment<br>name,Tablespace<br>name,Initial<br>extent,Next<br>extent,Min<br>extents,Max<br>extents,pct_increase,Instance<br>name,');
cell1('roll_status','select * from ( select segment_name,waits,gets,round(100 * (waits / gets),2) ratio,shrinks,wraps,round((a.rssize + 8192) / 1024 / 1024,2) rssize,round(a.hwmsize / 1024 / 1024,2) hwmsize,a.OPTSIZE / 1024 / 1024 optmal,c.INSTANCE_NAME from gv$rollstat a,dba_rollback_segs b,(select inst_id,value instance_name from gv$parameter where name=''instance_name'') c where a.usn =b.segment_id and b.instance_num=c.INST_ID(+) order by c.INSTANCE_NAME,segment_name)','SEGMENT_NAME,WAITS,GETS,Ratio,SHRINKS,WRAPS,RSSIZE,HWMSIZE,OPTMAL,INSTANCE,');
cell1('user_password_limits','select * from user_password_limits','Resource_name,Limit,');
cell1('profiles','select * from dba_profiles','Profile,Resource_name,Resource_type,Limit,');
cell1('invalid_objects','select Owner Oown,Object_Name Oname,Object_Type Otype,''Invalid Obj'' Prob from DBA_OBJECTS where Object_Type in (''PROCEDURE'',''PACKAGE'',''FUNCTION'',''TRIGGER'',''PACKAGE BODY'',''VIEW'') and Owner not in (''SYS'',''SYSTEM'') and Status != ''VALID'' order by 1,4,3,2','Owner,OBJECT&nbsp;NAME,OBJECT&nbsp;TYPE,Cause,');
cell1('old_analyzed','select * from (select owner,''INDEX'',index_name,decode(last_analyzed,null,chr(46291)||chr(52916)||chr(47062)||chr(52982),to_char(last_analyzed,''yyyy/mm/dd hh24:mi:ss''))lan from dba_indexes where owner not in (''SYS'', ''SYSTEM'', ''OUTLN'', ''DIP'', ''TSMSYS'', ''DBSNMP'', ''WMSYS'',''EXFSYS'', ''DMSYS'', ''CTXSYS'', ''XDB'', ''ANONYMOUS'', ''ORDSYS'',''ORDPLUGINS'', ''SI_INFORMTN_SCHEMA'', ''MDSYS'', ''OLAPSYS'', ''MDDATA'',''SYSMAN'', ''MGMT_VIEW'', ''SCOTT'', ''PERFSTAT'', ''TPCC'') order by last_analyzed desc) where rownum<21 union all select * from (select owner,''TABLE'',table_name,decode(last_analyzed,null,chr(46291)||chr(52916)||chr(47062)||chr(52982),to_char(last_analyzed,''yyyy/mm/dd hh24:mi:ss'')) from dba_tables where owner not in (''SYS'', ''SYSTEM'', ''OUTLN'', ''DIP'', ''TSMSYS'', ''DBSNMP'', ''WMSYS'',''EXFSYS'', ''DMSYS'', ''CTXSYS'', ''XDB'', ''ANONYMOUS'', ''ORDSYS'',''WKSYS'',''ORDPLUGINS'', ''SI_INFORMTN_SCHEMA'', ''MDSYS'', ''OLAPSYS'', ''MDDATA'',''SYSMAN'', ''MGMT_VIEW'', ''SCOTT'', ''PERFSTAT'', ''TPCC'') order by last_analyzed desc) where rownum<21','Owner,Type,Name,Last_analyzed,');
cell1('invalid_indexes','select owner,index_name,index_type from dba_indexes where status = ''UNUSABLE'' ORDER BY OWNER, index_name','Owner,INDEX_NAME,INDEX_TYPE,');
cell1('disabled_constraints','select OWNER,CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME from dba_constraints where status=''DISABLED''','OWNER,CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME,');
cell1('trans_need_recovery','select * from dba_2pc_pending','LOCAL_TRAN_ID,GLOBAL_TRAN_ID,STATE,MIXED,ADVICE,TRAN_COMMENT,FAIL_TIME,FORCE_TIME,RETRY_TIME,OS_USER,OS_TERMINAL,HOST,DB_USER,COMMIT#,');
cell1('table_without_local_index','select owner,table_name from dba_part_tables where owner not in (''SYS'',''SYSTEM'') minus select owner,table_name from dba_part_indexes where LOCALITY=''LOCAL'' and ALIGNMENT=''PREFIXED'' and owner not in (''SYS'',''SYSTEM'')','owner,Table_name,');
cell1('users','select decode(seq, 1, username, '''') username,decode(seq, 1, default_tablespace, '''') default_tablespace,decode(seq, 1, temporary_tablespace, '''') temporary_tablespace,granted_role,decode(seq,1,default_role,'''') default_role,decode(seq,1,account_status,'''') account_status,decode(seq,1,profile,'''') profile from (select username,default_tablespace,temporary_tablespace,granted_role,default_role,u.account_status,u.profile,rank() over(partition by username order by granted_role) seq from dba_users u, dba_role_privs r where u.username = r.grantee order by username)','UserName,Default<br>Tablespace,Temporary<br>Tablespace,Granted<br>Roles,Default<br>role,Account<br>status,Profile,');

cell3('user_dba','SELECT grantee username FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE=''DBA''');
cell3('user_drop_table','select username from dba_users u,(select grantee, privilege priv, '''' from dba_sys_privs c) r where u.username = r.grantee and r.priv like ''DROP ANY TABLE%'' order by username');
cell3('user_default_system','select username from dba_users where default_tablespace=''SYSTEM''');
cell3('user_temp_system','select username from dba_users where temporary_tablespace=''SYSTEM''');
cell2('rbuffer_cache','select replace(lpad(round(ratio,2),5,'';'')||''  ''||inst.INSTANCE_NAME, '';'', ''&'' || ''nbsp;'') rbf  from (select (1 - a.value / (b.value + c.value)) * 100 ratio, a.INST_ID, 1 seq from gv$sysstat a, gv$sysstat b, gv$sysstat c where a.name = ''physical reads'' and b.name = ''consistent gets'' and c.name = ''db block gets'' and a.INST_ID = b.INST_ID and a.INST_ID = c.INST_ID)gv,(select inst_id,value instance_name from gv$parameter where name=''instance_name'') inst where gv.inst_id=inst.INST_ID order by seq,gv.inst_id');
cell2('rdic_cache','select replace(lpad(round(ratio,2),5,'';'')||''  ''||inst.INSTANCE_NAME, '';'', ''&'' || ''nbsp;'') rdic from (select sum(gets) / (sum(gets) + sum(getmisses)) * 100 ratio,INST_ID,2 seq from gv$rowcache group by inst_id)gv,(select inst_id,value instance_name from gv$parameter where name=''instance_name'') inst where gv.inst_id=inst.INST_ID order by seq,gv.inst_id');
cell2('rlib_cache','select replace(lpad(round(ratio,2),5,'';'')||''  ''||inst.INSTANCE_NAME, '';'', ''&'' || ''nbsp;'') rlib  from ( select sum(pins) / (sum(pins) + sum(reloads)) * 100 ratio,inst_id,3 seq from gv$librarycache group by inst_id )gv,(select inst_id,value instance_name from gv$parameter where name=''instance_name'') inst where gv.inst_id=inst.INST_ID order by seq,gv.inst_id');
cell2('rsort_memory','select replace(lpad(round(ratio,2),5,'';'')||''  ''||inst.INSTANCE_NAME, '';'', ''&'' || ''nbsp;'') rst from (select round((100 * b.value)/decode((a.value + b.value), 0, 1, (a.value + b.value)),2) ratio,a.INST_ID,4 seq from gv$sysstat a, gv$sysstat b where a.name = ''sorts (disk)'' and b.name = ''sorts (memory)'' and a.INST_ID = b.INST_ID)gv,(select inst_id,value instance_name from gv$parameter where name=''instance_name'') inst where gv.inst_id=inst.INST_ID order by seq,gv.inst_id');
cell2('parmlist','select a.name from (select name, value v1 from (select name, value,rank() over(partition by name order by inst_id) seq from gv$parameter where isdefault = ''FALSE'' and value is not null) where seq=1) a,(select name, value v2 from (select name,value,rank() over(partition by name order by inst_id) seq from gv$parameter where isdefault = ''FALSE'' and value is not null) where seq=2) b where a.name=b.name(+)');
cell2('parm1','select v1 from (select name, value v1 from (select name,value, rank() over(partition by name order by inst_id) seq from gv$parameter where isdefault = ''FALSE'' and value is not null) where seq=1) a,(select name, value v2 from (select name,value,rank() over(partition by name order by inst_id) seq from gv$parameter where isdefault =''FALSE'' and value is not null) where seq=2) b where a.name=b.name(+)');
cell2('parm2','select v2 from (select name, value v1 from (select name,value, rank() over(partition by name order by inst_id) seq from gv$parameter where isdefault = ''FALSE'' and value is not null) where seq=1) a,(select name, value v2 from (select name,value,rank() over(partition by name order by inst_id) seq from gv$parameter where isdefault =''FALSE'' and value is not null) where seq=2) b where a.name=b.name(+)');

cell1('topsql_io','select * from (select b.username, a.disk_reads, a.executions,round(a.disk_reads/decode(a.executions,0,1,a.executions),2) rds_exec_ratio,a.sql_text from gv$sqlarea a, dba_users b where a.parsing_user_id = b.user_id and b.username not in (''SYS'',''SYSTEM'') order by 4 desc) where rownum<6','Username,Disk_reads,Executions,Read_exec<br>ratio,Sql_text,');
cell1('topsql_buffer','select * from (select b.username, a.buffer_gets, a.executions,round(a.buffer_gets/decode(a.executions,0,1,a.executions),2) buf_exec_ratio,a.sql_text from gv$sqlarea a, dba_users b where a.parsing_user_id = b.user_id and b.username not in (''SYS'',''SYSTEM'') order by 4 desc) where rownum<6','Username,Buffer<br>gets,Executions,Buf_exec<br>ratio,Sql_text,');
wait(1);
wait(2);
dbms_output.put_line('?>');
end;
/
spoo off
exit