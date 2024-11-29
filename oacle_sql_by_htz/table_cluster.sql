set echo off
set lines 300 pages 1000 serveroutput on heading on verify off
col owner for a20
col u_n for a35 heading 'CLUSTER|OWNER_TABLE_NAME'
col o_n for a35 heading 'TABLE|OWNER_TABLE_NAME'
col table_name for a20
col tab_column_name for a20
col tab_oerder for 99999999
undefine cluster_owner;
undefine cluster_name;
undefine table_owner;
undefine table_name;
select u.name || '.' || oc.name u_n,
       cc.name AS "CLU_COLUMN_NAME",
       tu.name || '.' || ot.name o_n,
       decode(bitand(tc.property, 1), 1, ac.name, tc.name) AS "TAB_COLUMN_NAME",tc.col# as "COLUMN_ID",
       t.tab# AS "TAB_ORDER"
  from sys.user$    u,
       sys.obj$     oc,
       sys.col$     cc,
       sys.obj$     ot,
       sys.col$     tc,
       sys.tab$     t,
       sys.attrcol$ ac,
       sys.user$    tu
 where oc.owner# = u.user#
   and oc.obj# = cc.obj#
   and t.bobj# = oc.obj#
   and t.obj# = tc.obj#
   and tc.segcol# = cc.segcol#
   and t.obj# = ot.obj#
   and oc.type# = 3
   and tc.obj# = ac.obj#(+)
   and tc.intcol# = ac.intcol#(+)
   and tu.user# = ot.owner#
   and u.name = nvl(upper('&cluster_owner'), u.name)
   and oc.name = nvl(upper('&cluster_name'), oc.name)
   and tu.name = nvl(upper('&table_owner'), tu.name)
   and ot.name = nvl(upper('&table_name'), ot.name)
 order by 1
/

undefine cluster_owner;
undefine cluster_name;
undefine table_owner;
undefine table_name;