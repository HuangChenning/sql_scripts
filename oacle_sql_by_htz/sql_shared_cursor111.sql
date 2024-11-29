  set echo off
  set verify off
  SET PAGES 0
  SET HEADING OFF;
  set lines 100 
 SELECT 'UNBOUND_CURSOR:                '||SUM(TO_NUMBER(DECODE(unbound_cursor,'Y',1,'N','0'))),
                 'SQL_TYPE_MISMATCH:             '||SUM(TO_NUMBER(DECODE(sql_type_mismatch,'Y',1,'N','0'))),
                 'OPTIMIZER_MISMATCH:            '||SUM(TO_NUMBER(DECODE(optimizer_mismatch,'Y',1,'N','0'))),
                 'OUTLINE_MISMATCH:              '||SUM(TO_NUMBER(DECODE(outline_mismatch,'Y',1,'N','0'))),
                 'STATS_ROW_MISMATCH:            '||SUM(TO_NUMBER(DECODE(stats_row_mismatch,'Y',1,'N','0'))),
                 'LITERAL_MISMATCH:              '||SUM(TO_NUMBER(DECODE(literal_mismatch,'Y',1,'N','0'))),
                 'FORCE_HARD_PARSE:              '||SUM(TO_NUMBER(DECODE(force_hard_parse,'Y',1,'N','0'))),
                 'EXPLAIN_PLAN_CURSOR:           '||SUM(TO_NUMBER(DECODE(explain_plan_cursor,'Y',1,'N','0'))),
                 'BUFFERED_DML_MISMATCH:         '||SUM(TO_NUMBER(DECODE(buffered_dml_mismatch,'Y',1,'N','0'))),
                 'PDML_ENV_MISMATCH:             '||SUM(TO_NUMBER(DECODE(pdml_env_mismatch,'Y',1,'N','0'))),
                 'INST_DRTLD_MISMATCH:           '||SUM(TO_NUMBER(DECODE(inst_drtld_mismatch,'Y',1,'N','0'))),
                 'SLAVE_QC_MISMATCH:             '||SUM(TO_NUMBER(DECODE(slave_qc_mismatch,'Y',1,'N','0'))),
                 'TYPECHECK_MISMATCH:            '||SUM(TO_NUMBER(DECODE(typecheck_mismatch,'Y',1,'N','0'))),
                 'AUTH_CHECK_MISMATCH:           '||SUM(TO_NUMBER(DECODE(auth_check_mismatch,'Y',1,'N','0'))),
                 'BIND_MISMATCH:                 '||SUM(TO_NUMBER(DECODE(bind_mismatch,'Y',1,'N','0'))),
                 'DESCRIBE_MISMATCH:             '||SUM(TO_NUMBER(DECODE(describe_mismatch,'Y',1,'N','0'))),
                 'LANGUAGE_MISMATCH:             '||SUM(TO_NUMBER(DECODE(language_mismatch,'Y',1,'N','0'))),
                 'TRANSLATION_MISMATCH:          '||SUM(TO_NUMBER(DECODE(translation_mismatch,'Y',1,'N','0'))),
                 'ROW_LEVEL_SEC_MISMATCH:        '||SUM(TO_NUMBER(DECODE(row_level_sec_mismatch,'Y',1,'N','0'))),
                 'INSUFF_PRIVS:                  '||SUM(TO_NUMBER(DECODE(insuff_privs,'Y',1,'N','0'))),
                 'INSUFF_PRIVS_REM:              '||SUM(TO_NUMBER(DECODE(insuff_privs_rem,'Y',1,'N','0'))),
                 'REMOTE_TRANS_MISMATCH:         '||SUM(TO_NUMBER(DECODE(remote_trans_mismatch,'Y',1,'N','0'))),
                 'LOGMINER_SESSION_MISMATCH:     '||SUM(TO_NUMBER(DECODE(logminer_session_mismatch,'Y',1,'N','0'))),
                 'INCOMP_LTRL_MISMATCH:          '||SUM(TO_NUMBER(DECODE(incomp_ltrl_mismatch,'Y',1,'N','0'))),
                 'OVERLAP_TIME_MISMATCH:         '||SUM(TO_NUMBER(DECODE(overlap_time_mismatch,'Y',1,'N','0'))),
                 'EDITION_MISMATCH:              '||SUM(TO_NUMBER(DECODE(edition_mismatch,'Y',1,'N','0'))),
                 'MV_QUERY_GEN_MISMATCH:         '||SUM(TO_NUMBER(DECODE(mv_query_gen_mismatch,'Y',1,'N','0'))),
                 'USER_BIND_PEEK_MISMATCH:       '||SUM(TO_NUMBER(DECODE(user_bind_peek_mismatch,'Y',1,'N','0'))),
                 'TYPCHK_DEP_MISMATCH:           '||SUM(TO_NUMBER(DECODE(typchk_dep_mismatch,'Y',1,'N','0'))),
                 'NO_TRIGGER_MISMATCH:           '||SUM(TO_NUMBER(DECODE(no_trigger_mismatch,'Y',1,'N','0'))),
                 'FLASHBACK_CURSOR:              '||SUM(TO_NUMBER(DECODE(flashback_cursor,'Y',1,'N','0'))),
                 'ANYDATA_TRANSFORMATION:        '||SUM(TO_NUMBER(DECODE(anydata_transformation,'Y',1,'N','0'))),
                 'INCOMPLETE_CURSOR:             '||SUM(TO_NUMBER(DECODE(incomplete_cursor,'Y',1,'N','0'))),
                 'TOP_LEVEL_RPI_CURSOR:          '||SUM(TO_NUMBER(DECODE(top_level_rpi_cursor,'Y',1,'N','0'))),
                 'DIFFERENT_LONG_LENGTH:         '||SUM(TO_NUMBER(DECODE(different_long_length,'Y',1,'N','0'))),
                 'LOGICAL_STANDBY_APPLY:         '||SUM(TO_NUMBER(DECODE(logical_standby_apply,'Y',1,'N','0'))),
                 'DIFF_CALL_DURN:                '||SUM(TO_NUMBER(DECODE(diff_call_durn,'Y',1,'N','0'))),
                 'BIND_UACS_DIFF:                '||SUM(TO_NUMBER(DECODE(bind_uacs_diff,'Y',1,'N','0'))),
                 'PLSQL_CMP_SWITCHS_DIFF:        '||SUM(TO_NUMBER(DECODE(plsql_cmp_switchs_diff,'Y',1,'N','0'))),
                 'CURSOR_PARTS_MISMATCH:         '||SUM(TO_NUMBER(DECODE(cursor_parts_mismatch,'Y',1,'N','0'))),
                 'STB_OBJECT_MISMATCH:           '||SUM(TO_NUMBER(DECODE(stb_object_mismatch,'Y',1,'N','0'))),
                 'CROSSEDITION_TRIGGER_MISMATCH: '||SUM(TO_NUMBER(DECODE(crossedition_trigger_mismatch,'Y',1,'N','0'))),
                 'PQ_SLAVE_MISMATCH:             '||SUM(TO_NUMBER(DECODE(pq_slave_mismatch,'Y',1,'N','0'))),
                 'TOP_LEVEL_DDL_MISMATCH:        '||SUM(TO_NUMBER(DECODE(top_level_ddl_mismatch,'Y',1,'N','0'))),
                 'MULTI_PX_MISMATCH:             '||SUM(TO_NUMBER(DECODE(multi_px_mismatch,'Y',1,'N','0'))),
                 'BIND_PEEKED_PQ_MISMATCH:       '||SUM(TO_NUMBER(DECODE(bind_peeked_pq_mismatch,'Y',1,'N','0'))),
                 'MV_REWRITE_MISMATCH:           '||SUM(TO_NUMBER(DECODE(mv_rewrite_mismatch,'Y',1,'N','0'))),
                 'ROLL_INVALID_MISMATCH:         '||SUM(TO_NUMBER(DECODE(roll_invalid_mismatch,'Y',1,'N','0'))),
                 'OPTIMIZER_MODE_MISMATCH:       '||SUM(TO_NUMBER(DECODE(optimizer_mode_mismatch,'Y',1,'N','0'))),
                 'PX_MISMATCH:                   '||SUM(TO_NUMBER(DECODE(px_mismatch,'Y',1,'N','0'))),
                 'MV_STALEOBJ_MISMATCH:          '||SUM(TO_NUMBER(DECODE(mv_staleobj_mismatch,'Y',1,'N','0'))),
                 'FLASHBACK_TABLE_MISMATCH:      '||SUM(TO_NUMBER(DECODE(flashback_table_mismatch,'Y',1,'N','0'))),
                 'LITREP_COMP_MISMATCH:          '||SUM(TO_NUMBER(DECODE(litrep_comp_mismatch,'Y',1,'N','0'))),
                 'PLSQL_DEBUG:                   '||SUM(TO_NUMBER(DECODE(plsql_debug,'Y',1,'N','0'))),
                 'LOAD_OPTIMIZER_STATS:          '||SUM(TO_NUMBER(DECODE(load_optimizer_stats,'Y',1,'N','0'))),
                 'ACL_MISMATCH:                  '||SUM(TO_NUMBER(DECODE(acl_mismatch,'Y',1,'N','0'))),
                 'FLASHBACK_ARCHIVE_MISMATCH:    '||SUM(TO_NUMBER(DECODE(flashback_archive_mismatch,'Y',1,'N','0'))),
                 'LOCK_USER_SCHEMA_FAILED:       '||SUM(TO_NUMBER(DECODE(lock_user_schema_failed,'Y',1,'N','0'))),
                 'REMOTE_MAPPING_MISMATCH:       '||SUM(TO_NUMBER(DECODE(remote_mapping_mismatch,'Y',1,'N','0'))),
                 'LOAD_RUNTIME_HEAP_FAILED:      '||SUM(TO_NUMBER(DECODE(load_runtime_heap_failed,'Y',1,'N','0'))),
                 'HASH_MATCH_FAILED:             '||SUM(TO_NUMBER(DECODE(hash_match_failed,'Y',1,'N','0')))
          FROM   v$sql_shared_cursor
          WHERE  address IN (SELECT address
                                       FROM   v$sqlarea
                                       WHERE  sql_id = '&sqlid');
     set heading on
     set lines 200
undefine sqlid
set echo on