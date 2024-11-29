prompt set echo on
prompt drop table t;
prompt create table t as select * from all_objects;
prompt create index t_idx on t(object_name);
prompt exec dbms_stats.gather_table_stats( user, 'T', cascade=>true );
prompt create undo tablespace undo_small
prompt datafile '/home/ora11gr2/app/ora11gr2/oradata/orcl/undo_small.dbf' 
prompt size 10m reuse
prompt autoextend off
prompt /
prompt alter system set undo_tablespace = undo_small;
prompt begin
prompt     for x in ( select /*+ INDEX(t t_idx) */ rowid rid, object_name, rownum r
prompt                  from t
prompt                 where object_name > ' ' )
prompt     loop
prompt         update t
prompt            set object_name = lower(x.object_name)
prompt          where rowid = x.rid;
prompt         --if ( mod(x.r,100) = 0 ) then
prompt          --  commit;
prompt         --end if;
prompt    end loop;
prompt    commit;
prompt end;
prompt /
prompt alter system set undo_tablespace = UNDOTBS1;
prompt drop tablespace undo_small;

