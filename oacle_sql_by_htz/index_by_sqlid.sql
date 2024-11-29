set echo off
set heading on
set verify off
set lines 200
set pages 1000
col owner for a15
col index_name for a35
col tablespacename for a20 heading 'tablespace|name'
col o_t for a35 heading 'OWNER|TABLE_NAME'
col indexname for a20
col status for a10
col index_type for a10
col num_rows for 9999999999
col partitioned for a5 heading PARTI
col lastanalyzed for a20 heading 'last time|analyzed'
col degree for a2 heading 'DE|GR|EE'
col logging for a7
col blevel for 999 heading 'LEV|ELE'
col d_keys for 9999999999 heading 'Dinsinct|Keys'
col pct_free for 9999 heading 'PCT|FREE'
col blevel for 99999 heading 'LEVEL'
col post_name for a15 heading 'COLUMN|POST:NAME'
col logging for a3 heading 'LOG'
break on o_t on index_name
with t as
 (select /*+ materialize */
  distinct object_owner, object_name
    from (select object_owner, object_name
            from v$sql_plan
           where sql_id = '&&sqlid'
             and object_name is not null
          union all
          select object_owner, object_name
            from dba_hist_sql_plan
           where sql_id = '&&sqlid'
             and object_name is not null))
select a.owner||'.'||a.table_name o_t,b.index_name,
       decode(a.status, 'n/a', 'part', a.status) status,
       a.index_type,
       a.uniqueness,
       a.pct_free,
       a.logging logging,
       a.blevel blevel,
       a.distinct_keys d_keys,
       a.leaf_blocks,
       a.degree,
       a.num_rows,
       a.partitioned,
       c.locality,
       b.column_position || ':' || b.column_name post_name
  from dba_indexes a, dba_ind_columns b, dba_part_indexes c
 where  (a.owner, a.table_name) in (select table_owner, table_name
                                  from dba_indexes
                                 where (owner, index_name) in
                                       (select * from t)
                                union all
                                select * from t) and b.index_name = a.index_name and a.table_owner = b.table_owner and a.owner = b.index_owner and a.index_name = c.index_name(+)
 order by a.owner,b.index_name;
undefine sqlid;
clear breaks;