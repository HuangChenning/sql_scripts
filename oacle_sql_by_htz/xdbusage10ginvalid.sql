set serveroutput on size 100000
set pagesize 0
spool xdb10ginvalid.log

declare
--define cursors
--check for version
cursor c_ver is select version from v$instance;
--check for invalids owned by XDB
cursor c_inval is select * from dba_objects
where status='INVALID' and OWNER in ('SYS','XDB');
-- Check status of other database features
cursor c_feat is select comp_name,status,version from dba_registry;
--check for xml type tables including 
cursor c_xml_tabs is 
select owner, storage_type, count(*) "TOTAL" from
(select u.name owner, o.name table_name,
    decode(bitand(opq.flags,5),1,'OBJECT-RELATIONAL','CLOB') storage_type
 from sys.opqtype$ opq, sys.tab$ t, sys.user$ u, sys.obj$ o,
      sys.coltype$ ac, sys.col$ tc
 where o.owner# = u.user#
  and o.obj# = t.obj#
  and bitand(t.property, 1) = 1
  and t.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 0
 union all
 select u.name owner, o.name table_name,
    decode(bitand(opq.flags,5),1,'OBJECT-RELATIONAL','CLOB') storage_type
 from sys.opqtype$ opq,
      sys.tab$ t, sys.user$ u, sys.obj$ o, sys.coltype$ ac, sys.col$ tc
where o.owner# = u.user#
  and o.obj# = t.obj#
  and bitand(t.property, 1) = 1
  and t.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 2)
group by owner, storage_type;
--check for xml type colmns
cursor c_xml_tab_cols is 
select owner, storage_type, count(*) "TOTAL" from
(select u.name owner, o.name table_name,
   decode(bitand(opq.flags,5),1,'OBJECT-RELATIONAL','CLOB') storage_type
from sys.opqtype$ opq, sys.tab$ t, sys.user$ u, sys.obj$ o,
     sys.coltype$ ac, sys.col$ tc, sys.attrcol$ attr
where o.owner# = u.user#
  and o.obj# = t.obj#
  and t.obj# = tc.obj#
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and tc.obj#    = attr.obj#(+)
  and tc.intcol# = attr.intcol#(+)
  and tc.name != 'SYS_NC_ROWINFO$'
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 0
 union all
  select u.name owner, o.name table_name,
    decode(bitand(opq.flags,5),1,'OBJECT-RELATIONAL','CLOB') storage_type
from sys.opqtype$ opq, sys.tab$ t, sys.user$ u, sys.obj$ o, 
     sys.coltype$ ac, sys.col$ tc, sys.attrcol$ attr
where o.owner# = u.user#
  and o.obj# = t.obj#
  and t.obj# = tc.obj#
  and tc.obj# = ac.obj#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# = ac.intcol#
  and tc.obj#    = attr.obj#(+)
  and tc.intcol# = attr.intcol#(+)
  and tc.name != 'SYS_NC_ROWINFO$'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 2
)
group by owner, storage_type;
--check for xml type views
cursor c_xml_vw is select owner, count(*) "TOTAL" from
(select u.name owner, o.name view_name
 from sys.opqtype$ opq, sys.view$ v, sys.user$ u, sys.obj$ o,
      sys.coltype$ ac, sys.col$ tc
 where o.owner# = u.user#
  and o.obj# = v.obj#
  and bitand(v.property, 1) = 1
  and v.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 0
 union all
  select u.name owner, o.name view_name
from sys.opqtype$ opq, sys.view$ v, sys.user$ u, 
     sys.obj$ o, sys.coltype$ ac, sys.col$ tc
where o.owner# = u.user#
  and o.obj# = v.obj#
  and bitand(v.property, 1) = 1
  and v.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 2)
group by owner;
--check for API's bbuilt with XML API's
cursor c_api is select owner,name,type from dba_dependencies
where referenced_name in (select object_name from dba_objects
where object_name like 'DBMS_XML%' or object_name like 'DBMS_XSL%')
and TYPE !='SYNONYM' and owner !='SYS';
--check for registered Schemas
cursor c_xml_schemas is select count(*) "TOTAL", status
from dba_objects where object_type='XML SCHEMA' group by status;
--check for objects depending on registered schemas
cursor c_xml_schema_obj is select owner,count(*) "TOTAL"
from dba_dependencies where referenced_type='XML SCHEMA' group by owner;
--define variables for fetching data from cursors
v_ver c_ver%ROWTYPE;
v_inval c_inval%ROWTYPE;
v_feat  c_feat%ROWTYPE;
v_xml_tabs c_xml_tabs%ROWTYPE;
v_xml_tab_cols  c_xml_tab_cols%ROWTYPE;
v_xml_vw c_xml_vw%rowtype;
v_api c_api%rowtype;
v_xml_schemas c_xml_schemas%rowtype;
v_xml_schema_obj c_xml_schema_obj%rowtype;
-- Static variables
v_errcode       NUMBER := 0;
v_errmsg        varchar2(50) := ' ';
begin open c_ver;
fetch c_ver into v_ver;
--check minimum XDB requirements
if dbms_registry.version('XDB') in ('9.2.0.1.0','9.2.0.2.0') then
DBMS_OUTPUT.PUT_LINE('!!!!!!!!!!!!!  UNSUPPORTED VERSION  !!!!!!!!!!!!!');
DBMS_OUTPUT.PUT_LINE('Minimun version is 9.2.0.3.0. actual version is: '
||dbms_registry.version('XDB'));
end if;
if v_ver.version like '10.%' then DBMS_OUTPUT.PUT_LINE(' Doing  '
||v_ver.version||' checks');
-- Print XDB status
DBMS_OUTPUT.PUT_LINE('#############  Status/Version  #############');
DBMS_OUTPUT.PUT_LINE('XDB Status is: '||dbms_registry.status('XDB')
||' at version '||dbms_registry.version('XDB'));
end if;
if v_ver.version != dbms_registry.version('XDB') then
DBMS_OUTPUT.PUT_LINE('Database is at version '||v_ver.version
||' XDB is at version '||dbms_registry.version('XDB'));
end if;
--Check Status if invalid gather invalid objects list and check for usage
--if valid simply check for usage
if dbms_registry.status('XDB') != 'VALID' then
DBMS_OUTPUT.PUT_LINE('#############  Invalid Objects  #############');
open c_inval;
loop
fetch c_inval into v_inval;
            DBMS_OUTPUT.PUT_LINE('Type: '||v_inval.object_type||' '
||v_inval.owner||'.'||v_inval.object_name);
            exit when c_inval%NOTFOUND;
end loop;
close c_inval;
end if;
-- Check XDBCONFIG.XML paramareters
DBMS_OUTPUT.PUT_LINE('#############  OTHER DATABASE FEATURES  #############');
open c_feat;
loop
fetch c_feat into v_feat;
exit when c_feat%NOTFOUND;
if c_feat%rowcount >0 then
DBMS_OUTPUT.PUT_LINE(v_feat.comp_name||' is '||v_feat.status
||' at version '||v_feat.version);
else DBMS_OUTPUT.PUT_LINE('No Data Found');
end if;
end loop;
close c_feat;
-- Check if they have any xmltype tables or columns
--and if they are schema based, clob or binary
DBMS_OUTPUT.PUT_LINE('#############  XMLTYPE Tables #############');
open c_xml_tabs;
loop
fetch c_xml_tabs into v_xml_tabs;
exit when c_xml_tabs%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(v_xml_tabs.owner||' has '||v_xml_tabs.TOTAL
||' XMLTYPE TABLES stored as '||v_xml_tabs.storage_type);
end loop;
close c_xml_tabs;
DBMS_OUTPUT.PUT_LINE('#############  XMLTYPE Columns #############');
open c_xml_tab_cols;
loop
fetch c_xml_tab_cols into v_xml_tab_cols;
exit when c_xml_tab_cols%NOTFOUND;
if c_xml_tab_cols%rowcount > 0 then
DBMS_OUTPUT.PUT_LINE(v_xml_tab_cols.owner||' has '||v_xml_tab_cols.TOTAL||
' XMLTYPE Columns stored as ' ||v_xml_tab_cols.storage_type);
else DBMS_OUTPUT.PUT_LINE('No Data Found');
end if;
end loop;
close c_xml_tab_cols;
DBMS_OUTPUT.PUT_LINE('#############  XMLTYPE Views #############');
open c_xml_vw;
loop
fetch c_xml_vw into v_xml_vw;
exit when c_xml_vw%NOTFOUND;
if c_xml_vw%rowcount > 0 then
DBMS_OUTPUT.PUT_LINE(v_xml_vw.owner||' has '||v_xml_vw.TOTAL||' XMLTYPE Views');
else DBMS_OUTPUT.PUT_LINE('No Data Found');
end if;
end loop;
close c_xml_vw;
DBMS_OUTPUT.PUT_LINE('#############  Items built with XML API''s  #############');
open c_api;
loop
fetch c_api into v_api;
exit when c_api%NOTFOUND;
if c_api%rowcount > 0 then
DBMS_OUTPUT.PUT_LINE(v_api.type||' '||v_api.owner||'.'||v_api.name);
else DBMS_OUTPUT.PUT_LINE('No Data Found');
end if;
end loop;
close c_api;
DBMS_OUTPUT.PUT_LINE('#############  XML SCHEMAS #############');
open c_xml_schemas;
loop
fetch c_xml_schemas into v_xml_schemas;
exit when c_xml_schemas%NOTFOUND;
if c_xml_schemas%rowcount >0 then
DBMS_OUTPUT.PUT_LINE(v_xml_schemas.TOTAL||' '
||v_xml_schemas.status||' XML Schema objects.');
else DBMS_OUTPUT.PUT_LINE('No Data Found');
end if;
end loop;
close c_xml_schemas;
DBMS_OUTPUT.PUT_LINE('############# Objects Depending On XML Schemas #############');
open c_xml_schema_obj;
loop
fetch c_xml_schema_obj into v_xml_schema_obj;
exit when c_xml_schema_obj%NOTFOUND;
if c_xml_schema_obj%rowcount >0 then
DBMS_OUTPUT.PUT_LINE(v_xml_schema_obj.owner||' has '
||v_xml_schema_obj.TOTAL||' object(s) depending on registered XML schemas.');
else DBMS_OUTPUT.PUT_LINE('No Data Found');
end if;
end loop;
close c_xml_schema_obj;
end;
/
spool off