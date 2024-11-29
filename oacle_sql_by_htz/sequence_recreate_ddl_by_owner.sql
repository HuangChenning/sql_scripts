set echo off lines 2000 pages 0 verify off heading off long 1024 feed off  termout  off trimout  off trimspool off
col getddl for a1024
spool &output_name;
select 'DROP SEQUENCE ' || SEQUENCE_OWNER || '.' || SEQUENCE_NAME || ';' ||
       CHR(10) || 'CREATE SEQUENCE  ' || sequence_owner || '.' ||
       sequence_name || ' MINVALUE ' || min_value || ' MAXVALUE ' ||
       max_value || ' INCREMENT BY ' || increment_by || ' START WITH ' ||
       last_number || ' CACHE ' || cache_size || ' ' ||
       decode(CYCLE_FLAG, 'N', 'NOCYCLE', 'Y', 'CYCLE') || ' ' ||
       decode(order_flag, 'Y', 'ORDER', 'N', 'NOORDER') || ';' as getddl
  from dba_sequences
 where sequence_owner in (&owner_list);
exit
