set lines 200
col sql_id                      for a18
col sql_count                   for 99999
col eecutions                   for 999999999
col buffer_gets                 for 999999999
col avg_get                     for 9999999
col object_owner                for a15
col object_name                 for a30
col filter_predicates           for a100
col parent_access               for a30
col parent_join                 for a20


with tt as
 (select sql_id,
         plan_hash_value,
         sql_text,
         force_matching_signature,
         sql_count,
         executions,
         buffer_gets,
         trunc(buffer_gets / decode(executions, 0, 1, executions)) avg_buffer_gets,
         disk_reads,
         trunc(disk_reads / decode(executions, 0, 1, executions)) avg_disk_reads,
         user_id_wait_time,
         trunc(user_id_wait_time / decode(executions, 0, 1, executions)) avg_user_id_wait_time,
         physical_write_bytes,
         trunc(physical_write_bytes / decode(executions, 0, 1, executions)) avg_physical_write_bytes
    from (select b.sql_id,
                 b.plan_hash_value,
                 b.sql_text,
                 b.force_matching_signature,
                 count(*) over(partition by b.sql_id) sql_count,
                 sum(b.EXECUTIONS) over(partition by b.sql_id) executions,
                 sum(b.BUFFER_GETS) over(partition by b.sql_id) buffer_gets,
                 sum(b.DISK_READS) over(partition by b.sql_id) disk_reads,
                 sum(b.USER_IO_WAIT_TIME) over(partition by b.sql_id) user_id_wait_time,
                 sum(b.PHYSICAL_WRITE_BYTES) over(partition by b.sql_id) physical_write_bytes
            from v$sql b
           where b.FORCE_MATCHING_SIGNATURE <> 0)
   where buffer_gets > 10000
   order by sql_id),
bb as
 (select c.sql_id,
         c.PLAN_HASH_VALUE,
         c.CHILD_NUMBER,
         c.OBJECT_OWNER,
         c.object_name,
         c.ID,
         c.PARTITION_START,
         c.OPERATION,
         c.OPTIONS,
         c.FILTER_PREDICATES,
         (select b.ACCESS_PREDICATES
            from v$sql_plan b
           where c.sql_id = b.sql_id
             and c.CHILD_NUMBER = b.child_number
             and c.PARENT_ID = b.id
             and c.PLAN_HASH_VALUE = b.plan_hash_value) parent_access,
         (select b.OPERATION
            from v$sql_plan b
           where c.sql_id = b.sql_id
             and c.CHILD_NUMBER = b.child_number
             and c.PARENT_ID = b.id
             and c.PLAN_HASH_VALUE = b.plan_hash_value) parent_join
    from v$sql_plan c
   where c.operation = 'TABLE ACCESS'
     and c.options = 'FULL')
select sql_id,
       plan_hash_value,
       object_owner,
       object_name,
       id,
       operation,
       options,
       FILTER_PREDICATES,
       parent_access,
       executions,
       avg_buffer_gets,
       avg_disk_reads,
       avg_user_id_wait_time,
       avg_physical_write_bytes,
       sql_text
  from (select distinct bb.sql_id,
                        bb.plan_hash_value,
                        bb.CHILD_NUMBER,
                        bb.object_owner,
                        bb.object_name,
                        bb.id,
                        bb.operation,
                        bb.options,
                        bb.FILTER_PREDICATES,
                        bb.parent_access,
                        bb.parent_join,
                        tt.sql_text,
                        tt.force_matching_signature,
                        tt.sql_count,
                        tt.executions,
                        tt.buffer_gets,
                        tt.avg_buffer_gets,
                        tt.disk_reads,
                        tt.avg_disk_reads,
                        tt.user_id_wait_time,
                        tt.avg_user_id_wait_time,
                        tt.physical_write_bytes,
                        tt.avg_physical_write_bytes,
                        rank() over(partition by tt.FORCE_MATCHING_SIGNATURE, tt.plan_hash_value order by tt.sql_id, bb.CHILD_NUMBER) sql_order
          from tt, bb
         where tt.sql_id = bb.sql_id
           and tt.plan_hash_value = bb.PLAN_HASH_VALUE) cc
 where sql_order = 1
 order by buffer_gets desc, sql_id, CHILD_NUMBER, id
/