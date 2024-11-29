/* Formatted on 2017/11/2 15:30:03 (QP5 v5.300) */
DECLARE
    v_sql        VARCHAR2 (1000);
    v_number     NUMBER;
    v_varchar2   VARCHAR2 (1000);

    PROCEDURE compare_para (param_name        IN VARCHAR2,
                            value_current     IN VARCHAR2,
                            value_target      IN VARCHAR2,
                            modify_sys        IN VARCHAR2,
                            modify_instance   IN VARCHAR2,
                            modify_ed         IN VARCHAR2,
                            is_def            IN VARCHAR2,
                            para_type         IN NUMBER)
    IS
        v_sql1   VARCHAR2 (1000);
        v_sql2   VARCHAR2 (1000);
    BEGIN
        IF value_current <> value_target
        THEN
            -- v_sql1 := 'alter system set "' || param_name || '" =' || value_target ||' scope=spfile; -- current_value ' || value_current;
            SELECT DECODE (
                       is_def,
                       'FALSE',    'alter system set "'
                                || param_name
                                || '" ='
                                || DECODE (para_type, '2', '''')
                                || value_target
                                || DECODE (para_type, '2', '''')
                                || DECODE (modify_sys,
                                           'FALSE', ' scope=spfile',
                                           ' ')
                                || ';--'
                                || DECODE (modify_instance,
                                           'FALSE', 'DATABASE MUST RESTART ')
                                || DECODE (modify_ed,
                                           'FALSE', ' ',
                                           ' MODIFIED ')
                                || '   current_value:'
                                || value_current,
                       'TRUE',    'alter system reset '
                               || param_name
                               || DECODE (modify_sys,
                                          'FALSE', ' scope=spfile',
                                          ' ')
                               || ';--'
                               || DECODE (modify_instance,
                                          'FALSE', 'DATABASE MUST RESTART ')
                               || DECODE (modify_ed,
                                          'FALSE', ' ',
                                          ' MODIFIED ')
                               || '   current_value:'
                               || value_current)
              INTO v_sql2
              FROM DUAL;

            --  DBMS_OUTPUT.put_line(v_sql1);
            DBMS_OUTPUT.put_line (v_sql2);
        END IF;
    END compare_para;

    PROCEDURE print_para (param_name        IN VARCHAR2,
                          value_current     IN VARCHAR2,
                          modify_sys        IN VARCHAR2,
                          modify_instance   IN VARCHAR2,
                          modify_ed         IN VARCHAR2,
                          is_def            IN VARCHAR2,
                          para_type         IN NUMBER)
    IS
        v_sql1   VARCHAR2 (1000);
        v_sql2   VARCHAR2 (1000);
    BEGIN
        SELECT DECODE (
                   is_def,
                   'FALSE',    '--display  "'
                            || param_name
                            || '" ='
                            || DECODE (para_type, '2', '''')
                            || value_current
                            || DECODE (para_type, '2', '''')
                            || DECODE (modify_sys,
                                       'FALSE', ' scope=spfile',
                                       ' ')
                            || ';--'
                            || DECODE (modify_instance,
                                       'FALSE', 'DATABASE MUST RESTART ')
                            || DECODE (modify_ed, 'FALSE', ' ', ' MODIFIED ')
                            || '   :',
                   'TRUE',    'alter system reset '
                           || param_name
                           || DECODE (modify_sys,
                                      'FALSE', ' scope=spfile',
                                      ' ')
                           || ';--'
                           || DECODE (modify_instance,
                                      'FALSE', 'DATABASE MUST RESTART ')
                           || DECODE (modify_ed, 'FALSE', ' ', ' MODIFIED ')
                           || '   :'
                           || value_current)
          INTO v_sql2
          FROM DUAL;

        DBMS_OUTPUT.put_line (v_sql2);
    END print_para;
BEGIN
    FOR c_parameter
        IN (SELECT DISTINCT
                   UPPER (nam.ksppinm) NAME,
                   val.ksppstvl        DISPLAY_VALUE,
                   nam.ksppity         para_type,
                   DECODE (BITAND (nam.ksppiflg / 65536, 3),
                           1, 'IMMED',
                           2, 'DEFERRED',
                           3, 'IMMED',
                           'FALSE')
                       issys_modifiable,
                   DECODE (
                       BITAND (ksppiflg, 4),
                       4, 'FALSE',
                       DECODE (BITAND (ksppiflg / 65536, 3),
                               0, 'FALSE',
                               'TRUE'))
                       ISINSTANCE_MODIFIABLE,
                   DECODE (BITAND (ksppstvf, 7),
                           1, 'MODIFIED',
                           4, 'SYSTEM_MOD',
                           'FALSE')
                       ISMODIFIED,
                   DECODE (BITAND (ksppilrmflg / 64, 1), 1, 'TRUE', 'FALSE')
                       ISDEPRECATED
              FROM x$ksppi nam, x$ksppsv val
             WHERE     nam.indx = val.indx
                   AND UPPER (nam.ksppinm) IN
                           ('_B_TREE_BITMAP_PLANS',
                            '_BLOOM_FILTER_ENABLED',
                            '_CLEANUP_ROLLBACK_ENTRIES',
                            '_DATAFILE_OPEN_ERRORS_CRASH_INSTANCE',
                            '_DATAFILE_WRITE_ERRORS_CRASH_INSTANCE',
                            '_DB_BLOCK_NUMA',
                            '_DROP_STAT_SEGMENT',
                            '_ENABLE_PDB_CLOSE_ABORT',
                            '_ENABLE_PDB_CLOSE_NOARCHIVELOG',
                            '_FIX_CONTROL',
                            '_GC_POLICY_TIME',
                            '_GES_DIRECT_FREE_RES_para_type',
                            '_INDEX_PARTITION_LARGE_EXTENTS',
                            '_KEEP_REMOTE_COLUMN_SIZE',
                            '_KTB_DEBUG_FLAGS',
                            '_LIBRARY_CACHE_ADVICE',
                            '_MEMORY_IMM_MODE_WITHOUT_AUTOSGA',
                            '_OPTIMIZER_ADS_USE_RESULT_CACHE',
                            '_OPTIMIZER_AGGR_GROUPBY_ELIM',
                            '_OPTIMIZER_DSDIR_USAGE_CONTROL',
                            '_OPTIMIZER_EXTENDED_CURSOR_SHARING',
                            '_OPTIMIZER_EXTENDED_CURSOR_SHARING_REL',
                            '_OPTIMIZER_MJC_ENABLED',
                            '_OPTIMIZER_NULL_ACCEPTING_SEMIJOIN',
                            '_OPTIMIZER_NULL_AWARE_ANTIJOIN',
                            '_OPTIMIZER_REDUCE_GROUPBY_KEY',
                            '_OPTIMIZER_UNNEST_SCALAR_SQ',
                            '_OPTIMIZER_USE_FEEDBACK',
                            '_PART_ACCESS_VERSION_BY_NUMBER',
                            '_PARTITION_LARGE_EXTENTS',
                            '_PARTITION_LARGE_EXTENTS',
                            '_PX_USE_LARGE_POOL',
                            '_REPORT_CAPTURE_CYCLE_TIME',
                            '_ROLLBACK_SEGMENT_COUNT',
                            '_SERIAL_DIRECT_READ',
                            '_SORT_ELIMINATION_COST_RATIO',
                            '_SQL_PLAN_DIRECTIVE_MGMT_CONTROL',
                            '_SYS_LOGON_DELAY',
                            '_UNDO_AUTOTUNE',
                            '_USE_ADAPTIVE_LOG_FILE_SYNC',
                            '_USE_SINGLE_LOG_WRITER',
                            'AUDIT_TRAIL',
                            'AUTOTASK_MAX_ACTIVE_PDBS',
                            'CELL_OFFLOAD_PROCESSING',
                            'CONTROL_FILE_RECORD_KEEP_TIME',
                            'DB_CACHE_ADVICE',
                            'DB_FILES',
                            'DEFERRED_SEGMENT_CREATION',
                            'ENABLE_DDL_LOGGING',
                            'EVENT',
                            'FILESYSTEMIO_OPTIONS',
                            'MAX_SHARED_SERVERS',
                            'MEMORY_TARGET',
                            'OPEN_CURSORS',
                            'OPEN_LINK',
                            'OPEN_LINKS_PER_INSTANCE',
                            'OPTIMIZER_ADAPTIVE_PLANS',
                            'PARALLEL_FORCE_LOCAL',
                            'PGA_AGGREGATE_LIMIT',
                            'RESOURCE_MANAGER_PLAN',
                            'RESULT_CACHE_MAX_SIZE',
                            'SEC_MAX_FAILED_LOGIN_ATTEMPTS',
                            'SESSION_CACHED_CURSORS',
                            'SHARED_SERVERS',
                            'TEMP_UNDO_ENABLED',
                            'UNDO_RETENTION'))
    LOOP
        IF c_parameter.name = '_BLOOM_FILTER_ENABLED'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_B_TREE_BITMAP_PLANS'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_CLEANUP_ROLLBACK_ENTRIES'
        THEN
            v_varchar2 := '5000';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_DATAFILE_OPEN_ERRORS_CRASH_INSTANCE'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_DATAFILE_WRITE_ERRORS_CRASH_INSTANCE'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_DB_BLOCK_NUMA'
        THEN
            v_varchar2 := '1';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_DROP_STAT_SEGMENT'
        THEN
            v_varchar2 := '1';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_ENABLE_PDB_CLOSE_ABORT'
        THEN
            v_varchar2 := 'TRUE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_ENABLE_PDB_CLOSE_NOARCHIVELOG'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_FIX_CONTROL'
        THEN
            v_varchar2 := '8611462:OFF';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_GC_POLICY_TIME'
        THEN
            v_varchar2 := '0';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_GES_DIRECT_FREE_RES_para_type'
        THEN
            v_varchar2 := 'CTARAHDXBB';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_INDEX_PARTITION_LARGE_EXTENTS'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_B_TREE_BITMAP_PLANS'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_KEEP_REMOTE_COLUMN_SIZE'
        THEN
            v_varchar2 := 'TRUE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_KTB_DEBUG_FLAGS'
        THEN
            v_varchar2 := '8';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_LIBRARY_CACHE_ADVICE'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_MEMORY_IMM_MODE_WITHOUT_AUTOSGA'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_OPTIMIZER_ADS_USE_RESULT_CACHE'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_OPTIMIZER_AGGR_GROUPBY_ELIM'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_OPTIMIZER_DSDIR_USAGE_CONTROL'
        THEN
            v_varchar2 := '0';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_OPTIMIZER_EXTENDED_CURSOR_SHARING'
        THEN
            v_varchar2 := 'NONE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_OPTIMIZER_EXTENDED_CURSOR_SHARING_REL'
        THEN
            v_varchar2 := 'NONE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_OPTIMIZER_MJC_ENABLED'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_OPTIMIZER_NULL_ACCEPTING_SEMIJOIN'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_OPTIMIZER_NULL_AWARE_ANTIJOIN'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_OPTIMIZER_REDUCE_GROUPBY_KEY'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_OPTIMIZER_UNNEST_SCALAR_SQ'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_OPTIMIZER_USE_FEEDBACK'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_PART_ACCESS_VERSION_BY_NUMBER'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_PARTITION_LARGE_EXTENTS'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_PX_USE_LARGE_POOL'
        THEN
            v_varchar2 := 'TRUE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_REPORT_CAPTURE_CYCLE_TIME'
        THEN
            v_varchar2 := '0';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_ROLLBACK_SEGMENT_COUNT'
        THEN
            v_varchar2 := '2000';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_SERIAL_DIRECT_READ'
        THEN
            v_varchar2 := 'NEVER';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_SORT_ELIMINATION_COST_RATIO'
        THEN
            v_varchar2 := '1';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_SQL_PLAN_DIRECTIVE_MGMT_CONTROL'
        THEN
            v_varchar2 := '0';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_SYS_LOGON_DELAY'
        THEN
            v_varchar2 := '0';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_UNDO_AUTOTUNE'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_USE_ADAPTIVE_LOG_FILE_SYNC'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = '_USE_SINGLE_LOG_WRITER'
        THEN
            v_varchar2 := 'TRUE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'AUDIT_TRAIL'
        THEN
            v_varchar2 := 'NONE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;


        IF c_parameter.name = 'AUTOTASK_MAX_ACTIVE_PDBS'
        THEN
            v_varchar2 := '10';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;


        IF c_parameter.name = 'CELL_OFFLOAD_PROCESSING'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'CONTROL_FILE_RECORD_KEEP_TIME'
        THEN
            v_varchar2 := '31';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'DB_CACHE_ADVICE'
        THEN
            v_varchar2 := 'OFF';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'DB_FILES'
        THEN
            v_varchar2 := '5000';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'DEFERRED_SEGMENT_CREATION'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'ENABLE_DDL_LOGGING'
        THEN
            v_varchar2 := 'TRUE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'FILESYSTEMIO_OPTIONS'
        THEN
            v_varchar2 := 'SETALL';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'MAX_SHARED_SERVERS'
        THEN
            v_varchar2 := '0';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'MEMORY_TARGET'
        THEN
            v_varchar2 := '0';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'OPEN_CURSORS'
        THEN
            v_varchar2 := '3000';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'OPEN_LINK'
        THEN
            v_varchar2 := '40';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'OPEN_LINKS_PER_INSTANCE'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'OPTIMIZER_ADAPTIVE_PLANS'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'PARALLEL_FORCE_LOCAL'
        THEN
            v_varchar2 := 'TRUE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'PGA_AGGREGATE_LIMIT'
        THEN
            v_varchar2 := '0';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'RESOURCE_MANAGER_PLAN'
        THEN
            v_varchar2 := 'FORCE:';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'RESULT_CACHE_MAX_SIZE'
        THEN
            v_varchar2 := '0';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'SEC_MAX_FAILED_LOGIN_ATTEMPTS'
        THEN
            v_varchar2 := '100';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'SESSION_CACHED_CURSORS'
        THEN
            v_varchar2 := '300';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'SHARED_SERVERS'
        THEN
            v_varchar2 := '0';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'UNDO_RETENTION'
        THEN
            v_varchar2 := '10800';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;

        IF c_parameter.name = 'TEMP_UNDO_ENABLED'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter.name,
                          c_parameter.display_value,
                          v_varchar2,
                          c_parameter.issys_modifiable,
                          c_parameter.isinstance_modifiable,
                          c_parameter.ismodified,
                          c_parameter.isdeprecated,
                          c_parameter.para_type);
        END IF;
    END LOOP;

    FOR c_parameter_rac
        IN (SELECT DISTINCT
                   UPPER (nam.ksppinm) NAME,
                   val.ksppstvl        DISPLAY_VALUE,
                   nam.ksppity         para_type,
                   DECODE (BITAND (nam.ksppiflg / 65536, 3),
                           1, 'IMMED',
                           2, 'DEFERRED',
                           3, 'IMMED',
                           'FALSE')
                       issys_modifiable,
                   DECODE (
                       BITAND (ksppiflg, 4),
                       4, 'FALSE',
                       DECODE (BITAND (ksppiflg / 65536, 3),
                               0, 'FALSE',
                               'TRUE'))
                       ISINSTANCE_MODIFIABLE,
                   DECODE (BITAND (ksppstvf, 7),
                           1, 'MODIFIED',
                           4, 'SYSTEM_MOD',
                           'FALSE')
                       ISMODIFIED,
                   DECODE (BITAND (ksppilrmflg / 64, 1), 1, 'TRUE', 'FALSE')
                       ISDEPRECATED
              FROM x$ksppi nam, x$ksppsv val
             WHERE     nam.indx = val.indx
                   AND UPPER (nam.ksppinm) IN
                           ('_CLUSTERWIDE_GLOBAL_TRANSACTIONS',
                            '_GC_POLICY_TIME',
                            '_GC_UNDO_AFFINITY',
                            'PARALLEL_FORCE_LOCAL',
                            '_LM_TICKETS',
                            '_LM_SYNC_TIMEOUT'))
    LOOP
        IF c_parameter_rac.name = '_CLUSTERWIDE_GLOBAL_TRANSACTIONS'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter_rac.name,
                          c_parameter_rac.display_value,
                          v_varchar2,
                          c_parameter_rac.issys_modifiable,
                          c_parameter_rac.isinstance_modifiable,
                          c_parameter_rac.ismodified,
                          c_parameter_rac.isdeprecated,
                          c_parameter_rac.para_type);
        END IF;

        IF c_parameter_rac.name = '_GC_POLICY_TIME'
        THEN
            v_varchar2 := '0';
            compare_para (c_parameter_rac.name,
                          c_parameter_rac.display_value,
                          v_varchar2,
                          c_parameter_rac.issys_modifiable,
                          c_parameter_rac.isinstance_modifiable,
                          c_parameter_rac.ismodified,
                          c_parameter_rac.isdeprecated,
                          c_parameter_rac.para_type);
        END IF;

        IF c_parameter_rac.name = '_GC_UNDO_AFFINITY'
        THEN
            v_varchar2 := 'FALSE';
            compare_para (c_parameter_rac.name,
                          c_parameter_rac.display_value,
                          v_varchar2,
                          c_parameter_rac.issys_modifiable,
                          c_parameter_rac.isinstance_modifiable,
                          c_parameter_rac.ismodified,
                          c_parameter_rac.isdeprecated,
                          c_parameter_rac.para_type);
        END IF;

        IF c_parameter_rac.name = 'PARALLEL_FORCE_LOCAL'
        THEN
            v_varchar2 := 'TRUE';
            compare_para (c_parameter_rac.name,
                          c_parameter_rac.display_value,
                          v_varchar2,
                          c_parameter_rac.issys_modifiable,
                          c_parameter_rac.isinstance_modifiable,
                          c_parameter_rac.ismodified,
                          c_parameter_rac.isdeprecated,
                          c_parameter_rac.para_type);
        END IF;

        IF c_parameter_rac.name = '_LM_TICKETS'
        THEN
            v_varchar2 := '5000';
            compare_para (c_parameter_rac.name,
                          c_parameter_rac.display_value,
                          v_varchar2,
                          c_parameter_rac.issys_modifiable,
                          c_parameter_rac.isinstance_modifiable,
                          c_parameter_rac.ismodified,
                          c_parameter_rac.isdeprecated,
                          c_parameter_rac.para_type);
        END IF;

        IF c_parameter_rac.name = '_LM_SYNC_TIMEOUT'
        THEN
            v_varchar2 := '1200';
            compare_para (c_parameter_rac.name,
                          c_parameter_rac.display_value,
                          v_varchar2,
                          c_parameter_rac.issys_modifiable,
                          c_parameter_rac.isinstance_modifiable,
                          c_parameter_rac.ismodified,
                          c_parameter_rac.isdeprecated,
                          c_parameter_rac.para_type);
        END IF;
    END LOOP;

    FOR c_parameter_other
        IN (SELECT DISTINCT name,
                            display_value,
                            TYPE para_type,
                            ISSYS_MODIFIABLE,
                            ISINSTANCE_MODIFIABLE,
                            ISDEPRECATED,
                            ISMODIFIED
              FROM v$parameter
             WHERE    (    UPPER (name) NOT IN
                               ('_B_TREE_BITMAP_PLANS',
                                '_BLOOM_FILTER_ENABLED',
                                '_CLEANUP_ROLLBACK_ENTRIES',
                                '_DATAFILE_OPEN_ERRORS_CRASH_INSTANCE',
                                '_DATAFILE_WRITE_ERRORS_CRASH_INSTANCE',
                                '_DB_BLOCK_NUMA',
                                '_DROP_STAT_SEGMENT',
                                '_ENABLE_PDB_CLOSE_ABORT',
                                '_ENABLE_PDB_CLOSE_NOARCHIVELOG',
                                '_FIX_CONTROL',
                                '_GC_POLICY_TIME',
                                '_GES_DIRECT_FREE_RES_para_type',
                                '_INDEX_PARTITION_LARGE_EXTENTS',
                                '_KEEP_REMOTE_COLUMN_SIZE',
                                '_KTB_DEBUG_FLAGS',
                                '_LIBRARY_CACHE_ADVICE',
                                '_MEMORY_IMM_MODE_WITHOUT_AUTOSGA',
                                '_OPTIMIZER_ADS_USE_RESULT_CACHE',
                                '_OPTIMIZER_AGGR_GROUPBY_ELIM',
                                '_OPTIMIZER_DSDIR_USAGE_CONTROL',
                                '_OPTIMIZER_EXTENDED_CURSOR_SHARING',
                                '_OPTIMIZER_EXTENDED_CURSOR_SHARING_REL',
                                '_OPTIMIZER_MJC_ENABLED',
                                '_OPTIMIZER_NULL_ACCEPTING_SEMIJOIN',
                                '_OPTIMIZER_NULL_AWARE_ANTIJOIN',
                                '_OPTIMIZER_REDUCE_GROUPBY_KEY',
                                '_OPTIMIZER_UNNEST_SCALAR_SQ',
                                '_OPTIMIZER_USE_FEEDBACK',
                                '_PART_ACCESS_VERSION_BY_NUMBER',
                                '_PARTITION_LARGE_EXTENTS',
                                '_PARTITION_LARGE_EXTENTS',
                                '_PX_USE_LARGE_POOL',
                                '_REPORT_CAPTURE_CYCLE_TIME',
                                '_ROLLBACK_SEGMENT_COUNT',
                                '_SERIAL_DIRECT_READ',
                                '_SORT_ELIMINATION_COST_RATIO',
                                '_SQL_PLAN_DIRECTIVE_MGMT_CONTROL',
                                '_SYS_LOGON_DELAY',
                                '_UNDO_AUTOTUNE',
                                '_USE_ADAPTIVE_LOG_FILE_SYNC',
                                '_USE_SINGLE_LOG_WRITER',
                                'AUDIT_TRAIL',
                                'AUTOTASK_MAX_ACTIVE_PDBS',
                                'CELL_OFFLOAD_PROCESSING',
                                'CONTROL_FILE_RECORD_KEEP_TIME',
                                'DB_CACHE_ADVICE',
                                'DB_FILES',
                                'DEFERRED_SEGMENT_CREATION',
                                'ENABLE_DDL_LOGGING',
                                'EVENT',
                                'FILESYSTEMIO_OPTIONS',
                                'MAX_SHARED_SERVERS',
                                'MEMORY_TARGET',
                                'OPEN_CURSORS',
                                'OPEN_LINK',
                                'OPEN_LINKS_PER_INSTANCE',
                                'OPTIMIZER_ADAPTIVE_PLANS',
                                'PARALLEL_FORCE_LOCAL',
                                'PGA_AGGREGATE_LIMIT',
                                'RESOURCE_MANAGER_PLAN',
                                'RESULT_CACHE_MAX_SIZE',
                                'SEC_MAX_FAILED_LOGIN_ATTEMPTS',
                                'SESSION_CACHED_CURSORS',
                                'SHARED_SERVERS',
                                'TEMP_UNDO_ENABLED',
                                'UNDO_RETENTION',
                                '_CLUSTERWIDE_GLOBAL_TRANSACTIONS',
                                '_GC_POLICY_TIME',
                                '_GC_UNDO_AFFINITY',
                                'PARALLEL_FORCE_LOCAL',
                                '_LM_TICKETS',
                                '_LM_SYNC_TIMEOUT',
                                'EVENT',
                                'LOCAL_LISTENER',
                                'AUDIT_FILE_DEST',
                                'DIAGNOSTIC_DEST',
                                'NLS_LANGUAGE',
                                'COMPATIBLE',
                                'LOG_ARCHIVE_FORMAT',
                                'THREAD',
                                'DB_UNIQUE_NAME',
                                'DB_BLOCK_SIZE',
                                'LOG_ARCHIVE_DEST_STATE_1',
                                'DISPATCHERS',
                                'NLS_TERRITORY',
                                'DB_NAME',
                                'CLUSTER_DATABASE_INSTANCES',
                                'DB_RECOVERY_FILE_DEST_SIZE',
                                'INSTANCE_NUMBER',
                                'CLUSTER_DATABASE',
                                'REMOTE_LOGIN_PASSWORDFILE',
                                'CONTROL_FILES',
                                'FAL_SERVER',
                                'LOG_ARCHIVE_CONFIG',
                                'DB_RECOVERY_FILE_DEST',
                                'UNDO_TABLESPACE',
                                'DB_CREATE_FILE_DEST',
                                'ENABLE_PLUGGABLE_DATABASE')
                       AND name NOT LIKE 'log_archive_dest_%'
                       AND ISDEFAULT = 'FALSE')
                   OR (    name IN ('sga_max_size',
                                    'sga_target',
                                    'sga_min_size',
                                    'java_pool_size',
                                    'large_pool_size',
                                    'shared_pool_size',
                                    'streams_pool_size')
                       AND ISDEFAULT = 'TRUE'))
    LOOP
        print_para (c_parameter_other.name,
                    c_parameter_other.display_value,
                    c_parameter_other.issys_modifiable,
                    c_parameter_other.isinstance_modifiable,
                    c_parameter_other.ismodified,
                    c_parameter_other.isdeprecated,
                    c_parameter_other.para_type);
    END LOOP;
END;
/