set echo off
set lines 200
set pages 2000
set heading on
create or replace function shared_cursor_reason(bitvector number)
RETURN clob

IS
  v_reason clob;
begin
    if bitand(bitvector, POWER(2, 0)) = POWER(2, 0) then v_reason := v_reason||'UNBOUND_CURSOR: The existing child cursor was not fully built (in other words, it was not optimized)'||chr(13)||chr(10)||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 1)) = POWER(2, 1) then v_reason := v_reason||'SQL_TYPE_MISMATCH: The SQL type does not match the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 2)) = POWER(2, 2) then v_reason := v_reason||'OPTIMIZER_MISMATCH: The optimizer environment does not match the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 3)) = POWER(2, 3) then v_reason := v_reason||'OUTLINE_MISMATCH: The outlines do not match the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 4)) = POWER(2, 4) then v_reason := v_reason||'STATS_ROW_MISMATCH: The existing statistics do not match the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 5)) = POWER(2, 5) then v_reason := v_reason||'LITERAL_MISMATCH: Non-data literal values do not match the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 6)) = POWER(2, 6) then v_reason := v_reason||'FORCE_HARD_PARSE: For internal use'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 7)) = POWER(2, 7) then v_reason := v_reason||'EXPLAIN_PLAN_CURSOR: The child cursor is an explain plan cursor and should not be shared'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 8)) = POWER(2, 8) then v_reason := v_reason||'BUFFERED_DML_MISMATCH: Buffered DML does not match the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 9)) = POWER(2, 9) then v_reason := v_reason||'PDML_ENV_MISMATCH: PDML environment does not match the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 10)) = POWER(2, 10) then v_reason := v_reason||'INST_DRTLD_MISMATCH: Insert direct load does not match the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 11)) = POWER(2, 11) then v_reason := v_reason||'SLAVE_QC_MISMATCH: The existing child cursor is a slave cursor and the new one was issued by the coordinator (or, the existing child cursor was issued by the coordinator and the new one is a slave cursor)'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 12)) = POWER(2, 12) then v_reason := v_reason||'TYPECHECK_MISMATCH: The existing child cursor is not fully optimized'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 13)) = POWER(2, 13) then v_reason := v_reason||'AUTH_CHECK_MISMATCH: Authorization/translation check failed for the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 14)) = POWER(2, 14) then v_reason := v_reason||'BIND_MISMATCH: The bind metadata does not match the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 15)) = POWER(2, 15) then v_reason := v_reason||'DESCRIBE_MISMATCH: The typecheck heap is not present during the describe for the child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 16)) = POWER(2, 16) then v_reason := v_reason||'LANGUAGE_MISMATCH: The language handle does not match the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 17)) = POWER(2, 17) then v_reason := v_reason||'TRANSLATION_MISMATCH: The base objects of the existing child cursor do not match'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 18)) = POWER(2, 18) then v_reason := v_reason||'BIND_EQUIV_FAILURE: The bind value''s selectivity does not match that used to optimize the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 19)) = POWER(2, 19) then v_reason := v_reason||'INSUFF_PRIVS: Insufficient privileges on objects referenced by the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 20)) = POWER(2, 20) then v_reason := v_reason||'INSUFF_PRIVS_REM: Insufficient privileges on remote objects referenced by the existing child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 21)) = POWER(2, 21) then v_reason := v_reason||'REMOTE_TRANS_MISMATCH: The remote base objects of the existing child cursor do not match'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 22)) = POWER(2, 22) then v_reason := v_reason||'LOGMINER_SESSION_MISMATCH: LogMiner Session parameters mismatch'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 23)) = POWER(2, 23) then v_reason := v_reason||'INCOMP_LTRL_MISMATCH: Cursor might have some binds (literals) which may be unsafe/non-data. Value mismatch.'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 24)) = POWER(2, 24) then v_reason := v_reason||'OVERLAP_TIME_MISMATCH: Mismatch caused by setting session parameter ERROR_ON_OVERLAP_TIME'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 25)) = POWER(2, 25) then v_reason := v_reason||'EDITION_MISMATCH: Cursor edition mismatch'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 26)) = POWER(2, 26) then v_reason := v_reason||'MV_QUERY_GEN_MISMATCH: Internal, used to force a hard-parse when analyzing materialized view queries'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 27)) = POWER(2, 27) then v_reason := v_reason||'USER_BIND_PEEK_MISMATCH: Cursor is not shared because value of one or more user binds is different and this has a potential to change the execution plan'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 28)) = POWER(2, 28) then v_reason := v_reason||'TYPCHK_DEP_MISMATCH: Cursor has typecheck dependencies'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 29)) = POWER(2, 29) then v_reason := v_reason||'NO_TRIGGER_MISMATCH: Cursor and child have no trigger mismatch'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 30)) = POWER(2, 30) then v_reason := v_reason||'FLASHBACK_CURSOR: Cursor non-shareability due to flashback'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 31)) = POWER(2, 31) then v_reason := v_reason||'ANYDATA_TRANSFORMATION: Is criteria for opaque type transformation and does not match'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 32)) = POWER(2, 32) then v_reason := v_reason||'INCOMPLETE_CURSOR/PDDL_ENV_MISMATCH  : Cursor is incomplete: typecheck heap came from call memory / Environment setting mismatch for parallel DDL cursor (that is, one or more of the following parameter values have changed: PARALLEL_EXECUTION_ENABLED, PARALLEL_DDL_MODE, PARALLEL_DDL_FORCED_DEGREE, or PARALLEL_DDL_FORCED_INSTANCES)'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 33)) = POWER(2, 33) then v_reason := v_reason||'TOP_LEVEL_RPI_CURSOR: Is top level RPI cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 34)) = POWER(2, 34) then v_reason := v_reason||'DIFFERENT_LONG_LENGTH: Value of LONG does not match'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 35)) = POWER(2, 35) then v_reason := v_reason||'LOGICAL_STANDBY_APPLY: Logical standby apply context does not match'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 36)) = POWER(2, 36) then v_reason := v_reason||'DIFF_CALL_DURN: If Slave SQL cursor/single call'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 37)) = POWER(2, 37) then v_reason := v_reason||'BIND_UACS_DIFF: One cursor has bind UACs and one does not'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 38)) = POWER(2, 38) then v_reason := v_reason||'PLSQL_CMP_SWITCHS_DIFF: PL/SQL anonymous block compiled with different PL/SQL compiler switches'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 39)) = POWER(2, 39) then v_reason := v_reason||'CURSOR_PARTS_MISMATCH: Cursor was compiled with subexecution (cursor parts were executed)'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 40)) = POWER(2, 40) then v_reason := v_reason||'STB_OBJECT_MISMATCH: STB has come into existence since cursor was compiled'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 41)) = POWER(2, 41) then v_reason := v_reason||'CROSSEDITION_TRIGGER_MISMATCH: The set of crossedition triggers to execute might differ'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 42)) = POWER(2, 42) then v_reason := v_reason||'PQ_SLAVE_MISMATCH: Top-level slave decides not to share cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 43)) = POWER(2, 43) then v_reason := v_reason||'TOP_LEVEL_DDL_MISMATCH: Is top-level DDL cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 44)) = POWER(2, 44) then v_reason := v_reason||'MULTI_PX_MISMATCH: Cursor has multiple parallelizers and is slave-compiled'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 45)) = POWER(2, 45) then v_reason := v_reason||'BIND_PEEKED_PQ_MISMATCH: Cursor based around bind peeked values'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 46)) = POWER(2, 46) then v_reason := v_reason||'MV_REWRITE_MISMATCH: Cursor needs recompilation because an SCN was used during compile time due to being rewritten by materialized view'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 47)) = POWER(2, 47) then v_reason := v_reason||'ROLL_INVALID_MISMATCH: Marked for rolling invalidation and invalidation window exceeded'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 48)) = POWER(2, 48) then v_reason := v_reason||'OPTIMIZER_MODE_MISMATCH: Parameter OPTIMIZER_MODE mismatch (for example, all_rows versus first_rows_1)'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 49)) = POWER(2, 49) then v_reason := v_reason||'PX_MISMATCH: Mismatch in one parameter affecting the parallelization of a SQL statement. For example, one cursor was compiled with parallel DML enabled while the other was not.'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 50)) = POWER(2, 50) then v_reason := v_reason||'MV_STALEOBJ_MISMATCH: Cursor cannot be shared because there is a mismatch in the list of materialized views which were stale at the time the cursor was built'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 51)) = POWER(2, 51) then v_reason := v_reason||'FLASHBACK_TABLE_MISMATCH: Cursor cannot be shared because there is a mismatch with triggers being enabled and/or referential integrity constraints being deferred'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 52)) = POWER(2, 52) then v_reason := v_reason||'LITREP_COMP_MISMATCH: Mismatch in use of literal replacement'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 53)) = POWER(2, 53) then v_reason := v_reason||'PLSQL_DEBUG: Value of the PLSQL_DEBUG parameter for the current session does not match the value used to build the cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 54)) = POWER(2, 54) then v_reason := v_reason||'LOAD_OPTIMIZER_STATS: A hard parse is forced in order to initialize extended cursor sharing'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 55)) = POWER(2, 55) then v_reason := v_reason||'ACL_MISMATCH: Cached ACL evaluation result stored in the child cursor is not valid for the current session or user'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 56)) = POWER(2, 56) then v_reason := v_reason||'FLASHBACK_ARCHIVE_MISMATCH: Value of the FLASHBACK_DATA_ARCHIVE_INTERNAL_CURSOR parameter for the current session does not match the value used to build the cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 57)) = POWER(2, 57) then v_reason := v_reason||'LOCK_USER_SCHEMA_FAILED: User or schema used to build the cursor no longer exists (Note: This sharing criterion is deprecated )'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 58)) = POWER(2, 58) then v_reason := v_reason||'REMOTE_MAPPING_MISMATCH: Reloaded cursor was previously remote-mapped and is currently not remote-mapped. Therefore, the cursor needs to be reparsed.'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 59)) = POWER(2, 59) then v_reason := v_reason||'LOAD_RUNTIME_HEAP_FAILED: Loading of runtime heap for the new cursor (or reload of aged out cursor) failed'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 60)) = POWER(2, 60) then v_reason := v_reason||'HASH_MATCH_FAILED: No existing child cursors have the unsafe literal bind hash values required by the current cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 61)) = POWER(2, 61) then v_reason := v_reason||'PURGED_CURSOR: Child cursor is marked for purging'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 62)) = POWER(2, 62) then v_reason := v_reason||'BIND_LENGTH_UPGRADEABLE: Bind length(s) required for the current cursor are longer than the bind length(s) used to build the child cursor'||chr(13)||chr(10); end if;
    if bitand(bitvector, POWER(2, 63)) = POWER(2, 63) then v_reason := v_reason||'USE_FEEDBACK_STATS: A hard parse is forced so that the optimizer can reoptimize the query with improved cardinality estimates'||chr(13)||chr(10); end if;

    IF v_reason IS NULL OR TRIM(v_reason) IS NULL THEN
        v_reason := 'Cursor is originally shared.';
    END IF;

    RETURN v_reason;
end;
/

create or replace view all_shared_cursors
as
select inst_id instance_number,
       sql_id,
       kglhdpar address,
       kglhdadr child_address,
       childno child_number,
       shared_cursor_reason(bitvector) reason
  from x$kkscs;
  

select child_number,reason from all_shared_cursors where sql_id='&sqlid';
undefine sqlid;
set echo on

