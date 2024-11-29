Rem
Rem $Header: rdbms/admin/utlu111i.sql /st_rdbms_11.1.0/10 2008/07/31 16:34:29 cmlim Exp $
Rem
Rem utlu111i.sql
Rem
Rem Copyright (c) 2006, 2010,  Oracle and/or its affiliates. 
Rem All rights reserved. 
Rem
Rem    NAME
Rem      utlu111i.sql - UTiLity Upgrade Information
Rem
Rem    DESCRIPTION
Rem      This script provides information about databases to be
Rem      upgraded to 11.1.  
Rem
Rem      Supported releases: 9.2.0, 10.1.0 and 10.2.0
Rem
Rem    NOTES
Rem      Run connected AS SYSDBA to the database to be upgraded
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    bmccarth    10/20/10 - Metalink Update:
Rem    cmlim       10/20/10 - bug 10210185: add time zone detection up to tz
Rem                           v14 for 9i databases
Rem    cdilling             - Optimize select statement referencing dba_queues table
Rem                           On DB's with large number, query can take hours
Rem    bmccarth    09/09/09 - add versioning/date for metalink
Rem                         - bug 6614161 - Remove Network ACL warnings
Rem                         - Merge following two backports:
Rem    cmlim       05/29/09 - backport_bug_7656036: add more time zone region
Rem                           versions for Oracle 9.2 (from utltzver.sql)
Rem                         - include bug 8509010: check java_pool_size always
Rem                         - include lrg 3681155: display db_cache_size
Rem    cmlim       01/06/09 - backport 7689741 for base bug 7569744: 920 is not
Rem                           generating correct timezone msg
Rem    cmlim       07/30/08 - lrg 3535375: add GV$IOSTAT_FUNCTION and
Rem                           GV_IOSTAT_FUNCTION as invalid objs
Rem    cdilling    05/29/08 - add support for memory_target
Rem    cdilling    04/09/08 - exclude EVENT_HISTOGRAM from invalid query
Rem    cdilling    03/13/08 - various objects added to invalid query
Rem    cdilling    03/09/08 - Backport cdilling_bug-6849641 from main
Rem    cdilling    03/06/08 - add GV$IOSTAT_FILE to list of invalid objects
Rem    cdilling    02/13/08 - XbranchMerge cdilling_lrg-3300861 from main
Rem    cdilling    02/07/08 - exclude SQLSTATS invalid objects
Rem    cdilling    01/22/08 - exclude MGMT_ invalid objects
Rem    cdilling    12/26/07 - add more invalid objects
Rem    bdagevil    12/24/07 - add gv$sqlare_plan_hash to exception list
Rem    cdilling    11/26/07 - add warnings for mv refreshes, etc.
Rem    rburns      10/15/07 - adjust for component patch script
Rem    rburns      08/01/07 - add 11.1 patch information
Rem    cdilling    07/25/07 - update size calculations
Rem    jciminsk    08/03/07 - version to 11.1.0.7.0
Rem    cdilling    07/26/07 - add word 'manual' to cluster_database warning
Rem    rburns      06/15/07 - require TZ version 4
Rem    rburns      06/19/07 - blocksize default only for 9.2
Rem    rburns      06/06/07 - update version to production
Rem    cdilling    04/19/07 - add 11g obsoleted/deprec parameters
Rem    rburns      05/18/07 - extend time zone checks
Rem    cdilling    04/19/07 - display em downgrade warning
Rem    cdilling    04/17/07 - add check for Network ACLs
Rem    rburns      04/10/07 - adjust for 32/64-bit pool sizes
Rem    cdilling    04/03/07 - remove companion cd display
Rem    cdilling    03/21/07 - only require min java_vm_pool when java in db
Rem    rburns      03/13/07 - include ODM in component list
Rem    rburns      02/14/07 - version for BETA5
Rem    rburns      02/19/07 - recalibrate 070215 label with APEX
Rem    cdilling    12/21/06 - check params for XE and DBUA
Rem    cdilling    02/02/07 - eliminiate invalid objects - bug 4905742
Rem    cdilling    02/12/07 - increase shared memory by 16M  - bug 5874353 
Rem    cdilling    12/11/06 - add DV support
Rem    mgirkar     12/20/06 - Obsolete _log_archive_buffer_size
Rem    cdilling    10/31/06 - add support for diag_dest and ORACLE_OCM
Rem    cdilling    10/30/06 - beta4 version
Rem    cdilling    09/27/06 - check for APEX in db
Rem    cdilling    10/06/06 - beta3 version
Rem    rburns      09/14/06 - beta2 version
Rem    rburns      08/27/06 - 11g sizing
Rem    rburns      07/19/06 - change component order 
Rem    cdilling    06/28/06 - use db_block_buffers for VLM - bug 5241554
Rem    rburns      05/29/06 - reorder components 
Rem    cdilling    01/25/06 - Created
Rem

SET SERVEROUTPUT ON FORMAT WRAPPED;

---------------------------- DECLARATIONS ---------------------------

DECLARE

-- *****************************************************************
-- Release Specific Constants
-- These constants must be updated for each new patch release
-- *****************************************************************

  utlu_banner      CONSTANT VARCHAR2(50) := 'Oracle Database 11.1 Pre-Upgrade Information Tool ';
  utlu_version     CONSTANT VARCHAR2(30) := '11.1.0.7';
  utlu_patchset    CONSTANT VARCHAR2(3)  := '.0';
  utlu_buildrev    CONSTANT VARCHAR2(3)  := '002';
  utlu_tz_version  CONSTANT NUMBER := 4;

  
-- *****************************************************************
-- Database Information 
-- *****************************************************************

  db_name         VARCHAR2(30);
  db_version      VARCHAR2(30);
  db_dict_version VARCHAR2(30);
  db_prev_version VARCHAR2(30);
  db_compat       VARCHAR2(30);
  db_platform_id  NUMBER;
  db_platform_name VARCHAR2(30);
  db_block_size   NUMBER;
  db_undo         VARCHAR2(30);
  db_undo_tbs     VARCHAR2(30);
  db_tz_version   NUMBER := 0;
  db_vlm          VARCHAR2(30);     -- TRUE when Very Large Memory enabled
  db_64           BOOLEAN := FALSE; -- TRUE when platform is 64-bit

  dbv             BINARY_INTEGER; -- (920, 101, 102, 111)
  vers            VARCHAR2(12);   -- major version (e.g., 10.1.0)
  patch           VARCHAR2(12);   -- patch version (e.g., 10.1.0.2)
  tznames_dist    NUMBER;         -- 9.2 distinct timezone names
  tznames_count   NUMBER;         -- 9.2 total timezone names
  memory_target   BOOLEAN := FALSE; -- TRUE when memory_target is set 
  text_buffer     VARCHAR2(30);   -- a temporary text buffer

-- *****************************************************************
-- Component Information 
-- *****************************************************************

  TYPE comp_record_t IS RECORD (
      cid            VARCHAR2(30), -- component id
      cname          VARCHAR2(45), -- component name
      version        VARCHAR2(30), -- version
      status         VARCHAR2(15), -- component status
      schema         VARCHAR2(30), -- owner of component
      def_ts         VARCHAR2(30), -- name of default tablespace
      script         VARCHAR2(128), -- upgrade script name
      processed      BOOLEAN,
      install        BOOLEAN,
      sys_kbytes     NUMBER,
      sysaux_kbytes  NUMBER,
      def_ts_kbytes  NUMBER,
      ins_sys_kbytes NUMBER,
      ins_def_kbytes NUMBER
      );

  TYPE comp_table_t IS TABLE of comp_record_t INDEX BY BINARY_INTEGER;

  cmp_info comp_table_t;      -- Table of component information

-- index values for components (order as in upgrade script)
  catalog CONSTANT BINARY_INTEGER:=1;
  catproc CONSTANT BINARY_INTEGER:=2;
  javavm  CONSTANT BINARY_INTEGER:=3;
  xml     CONSTANT BINARY_INTEGER:=4;
  rac     CONSTANT BINARY_INTEGER:=5;
  owm     CONSTANT BINARY_INTEGER:=6;
  mgw     CONSTANT BINARY_INTEGER:=7;
  aps     CONSTANT BINARY_INTEGER:=8;
  amd     CONSTANT BINARY_INTEGER:=9;
  ols     CONSTANT BINARY_INTEGER:=10;
  dv      CONSTANT BINARY_INTEGER:=11;
  em      CONSTANT BINARY_INTEGER:=12;
  context CONSTANT BINARY_INTEGER:=13;
  xdb     CONSTANT BINARY_INTEGER:=14;
  catjava CONSTANT BINARY_INTEGER:=15;
  ordim   CONSTANT BINARY_INTEGER:=16;
  sdo     CONSTANT BINARY_INTEGER:=17;
  odm     CONSTANT BINARY_INTEGER:=18;
  wk      CONSTANT BINARY_INTEGER:=19;
  exf     CONSTANT BINARY_INTEGER:=20;
  rul     CONSTANT BINARY_INTEGER:=21;
  apex    CONSTANT BINARY_INTEGER:=22;
  xoq     CONSTANT BINARY_INTEGER:=23;
  stats   CONSTANT BINARY_INTEGER:=24;

  max_comps CONSTANT BINARY_INTEGER :=24; -- include STATS for space calcs
  max_components CONSTANT BINARY_INTEGER :=23;

-- *****************************************************************
-- Tablespace Information 
-- *****************************************************************

   TYPE tablespace_record_t IS RECORD (
       name    VARCHAR2(30),  -- tablespace name
       inuse   NUMBER,        -- kbytes inuse in tablespace
       alloc   NUMBER,        -- kbytes allocated to tbs
       auto    NUMBER,        -- autoextend kbytes available
       avail   NUMBER,        -- total kbytes available
       delta   NUMBER,        -- kbytes required for upgrade
       inc_by  NUMBER,        -- kbytes to increase tablespace by
       min     NUMBER,        -- minimum required kbytes to perform upgrade
       addl    NUMBER,        -- additional space allocated during upgrade
       fname   VARCHAR2(513), -- filename in tablespace
       fauto   BOOLEAN,       -- TRUE if there is a file to increase autoextend
       temporary BOOLEAN,     -- TRUE if Temporary tablespace
       localmanaged BOOLEAN   -- TRUE if locally managed temporary tablespace
                              -- FALSE if dictionary managed temp tablespace
       );

   TYPE tablespace_table_t IS TABLE OF tablespace_record_t
        INDEX BY BINARY_INTEGER;
 
   ts_info tablespace_table_t; -- Tablespace information
   max_ts  BINARY_INTEGER; -- Total number of relevant tablespaces

-- *****************************************************************
-- Rollback Segment Information 
-- *****************************************************************

   TYPE rollback_record_t IS RECORD (
       tbs_name VARCHAR2(30), -- tablespace name
       seg_name VARCHAR2(30), -- segment name
       status   VARCHAR(30),  -- online or offline
       inuse    NUMBER, -- kbytes in use
       next     NUMBER, -- kbytes in NEXT
       max_ext  NUMBER, -- max extents
       auto     NUMBER  -- autoextend available for tablespace
       );

   TYPE rollback_table_t IS TABLE of rollback_record_t
        INDEX BY BINARY_INTEGER;

   rs_info    rollback_table_t;  -- Rollback segment information
   max_rs     BINARY_INTEGER; -- Total number of public rollback segs

-- *****************************************************************
-- Log File Information 
-- *****************************************************************

   TYPE log_file_record_t IS RECORD (
        file_spec    VARCHAR2(513),
        grp          NUMBER, 
        bytes        NUMBER,
        status       VARCHAR2(16)
        );

   TYPE log_file_table_t IS TABLE of log_file_record_t
        INDEX BY BINARY_INTEGER;
 
   lf_info log_file_table_t;  -- Log File Information
   max_lf        BINARY_INTEGER;  -- Total number of log file groups

   min_log_size CONSTANT NUMBER := 4194304;   -- Minimum size 4M
   rmd_log_size CONSTANT NUMBER := 15;        -- Recommended size 15M

-- *****************************************************************
-- Initialization Parameter Information 
-- *****************************************************************

   TYPE obsolete_record_t IS RECORD (
      name VARCHAR2(80),
      db_match BOOLEAN
      );

   TYPE obsolete_table_t IS TABLE of obsolete_record_t
      INDEX BY BINARY_INTEGER;

   op     obsolete_table_t;
   max_op BINARY_INTEGER;

   TYPE renamed_record_t IS RECORD (
      oldname VARCHAR2(80),
      newname VARCHAR2(80),
      db_match BOOLEAN
      );

   TYPE renamed_table_t IS TABLE of renamed_record_t
      INDEX BY BINARY_INTEGER;

   rp      renamed_table_t;
   max_rp  BINARY_INTEGER;

   TYPE special_record_t IS RECORD (
      oldname  VARCHAR2(80),
      oldvalue VARCHAR2(80),
      newname  VARCHAR2(80),
      newvalue VARCHAR2(80),
      db_match BOOLEAN
      );

   TYPE special_table_t IS TABLE of special_record_t
      INDEX BY BINARY_INTEGER;

   sp      special_table_t;
   max_sp  BINARY_INTEGER;

   TYPE required_record_t IS RECORD (
      name     VARCHAR2(80),
      newnumbervalue NUMBER,
      newstringvalue VARCHAR2(4000),
      type NUMBER,
      db_match BOOLEAN
      );

   TYPE required_table_t IS TABLE of required_record_t
      INDEX BY BINARY_INTEGER;

   reqp      required_table_t;
   max_reqp  BINARY_INTEGER;

   TYPE minvalue_record_t IS RECORD (
      name     VARCHAR2(80),
      minvalue NUMBER,
      oldvalue NUMBER,
      newvalue NUMBER,
      display  BOOLEAN
      );

   TYPE minvalue_table_t IS TABLE of minvalue_record_t
      INDEX BY BINARY_INTEGER;

   mp        minvalue_table_t;
   max_mp    BINARY_INTEGER;
   sps       NUMBER;  -- shared_pool_size
   cpu       NUMBER;  -- number of CPUs
   sesn      NUMBER;  -- number of sessions 
   sps_ovrhd NUMBER;  -- shared_pool_size overheads

   sp_idx BINARY_INTEGER;  -- shared_pool_size
   jv_idx BINARY_INTEGER;  -- java_pool_size
   tg_idx BINARY_INTEGER;  -- sga_target
   cs_idx BINARY_INTEGER;  -- cache_size
   pg_idx BINARY_INTEGER;  -- pga_aggreate_target
   mt_idx BINARY_INTEGER;  -- memory_target

-- *****************************************************************
-- Warning Information 
-- *****************************************************************

   sysaux_exists     BOOLEAN := FALSE; -- TRUE when sysaux tablespace exists
   sysaux_not_online BOOLEAN := FALSE; -- TRUE when sysaux is not online
   sysaux_not_perm   BOOLEAN := FALSE; -- TRUE when sysaux is not permanent
   sysaux_not_local  BOOLEAN := FALSE; -- TRUE when sysaux is not extent local
   sysaux_not_auto   BOOLEAN := FALSE; -- TRUE when sysaux is not auto seg 
   dip_user_exists   BOOLEAN := FALSE; -- TRUE when DIP user found in user$
   ocm_user_exists   BOOLEAN := FALSE; -- TRUE when OCM user found in user$
   cluster_dbs       BOOLEAN := FALSE; -- TRUE when "cluster_database" init
   nls_al24utffss    BOOLEAN := FALSE; -- TRUE when AL24UTFFSS found in
   utf8_al16utf16    BOOLEAN := FALSE; -- TRUE when AL16UTF16 nor UTF8 NCHAR
   owm_replication   BOOLEAN := FALSE; -- TRUE when wmsys.wm$replication_table
   dblinks           BOOLEAN := FALSE; -- TRUE when database links exist
   cdc_data          BOOLEAN := FALSE; -- TRUE when cdc data exists
   version_mismatch  BOOLEAN := FALSE; -- TRUE when dictionary != instance
   connect_role      BOOLEAN := FALSE; -- TRUE when connect role used
   invalid_objs      BOOLEAN := FALSE; -- TRUE when invalid objects exist
   ssl_users         BOOLEAN := FALSE; -- TRUE when potential SSL users
   timezone_old      BOOLEAN := FALSE; -- TRUE when older timezone version
   timezone_new      BOOLEAN := FALSE; -- TRUE when newer timezone version
   stale_stats       BOOLEAN := FALSE; -- TRUE when stale statistics found
   xe_upgrade        BOOLEAN := FALSE; -- TRUE when XE database being upgraded
   em_exists         BOOLEAN := FALSE; -- TRUE when EM in database
   snapshot_refresh  BOOLEAN := FALSE; -- TRUE when active snapshot refreshes
   recovery_files    BOOLEAN := FALSE; -- TRUE when files need media recovery
   files_backup_mode BOOLEAN := FALSE; -- TRUE when files are in backup mode
   pending_2pc_txn   BOOLEAN := FALSE; -- TRUE when pending distribution txns
   sync_standby_db   BOOLEAN := FALSE; -- TRUE when standby database needs sync

-- *****************************************************************
-- Global Constants and Variables
-- *****************************************************************

   idx          BINARY_INTEGER;
   type cursor_t IS REF CURSOR;
   reg_cursor   cursor_t;

   p_null       CHAR(1);
   p_user       VARCHAR2(30);
   p_cid        VARCHAR2(30);
   p_status     VARCHAR2(30);
   n_status     NUMBER;
   p_version    VARCHAR2(30);
   p_schema     VARCHAR2(30);
   n_schema     NUMBER;
   p_value      VARCHAR2(80);
   p_pos        INTEGER;
   p_count      INTEGER;
   p_char       CHAR(1);
   p_tsname     VARCHAR2(30);
   p_edition    VARCHAR2(128);

   sum_bytes      NUMBER;
   delta_kbytes   NUMBER;
   delta_sysaux   NUMBER;
   delta_queues   INTEGER;
   rows_processed INTEGER;
   nonsys_invalid_objs INTEGER;
   user_num       NUMBER;

   display_xml  BOOLEAN := FALSE;
   collect_diag BOOLEAN := FALSE;
   rerun        BOOLEAN := FALSE;
   inplace      BOOLEAN := FALSE;
   using_ASM    BOOLEAN := FALSE;
   SYS_todo     BOOLEAN := FALSE;
   warning_5000 BOOLEAN := FALSE;

   display_bad_obj  BOOLEAN := FALSE; -- to be turned on for debugging

   NO_SUCH_TABLE  EXCEPTION;
   PRAGMA exception_init(NO_SUCH_TABLE, -942);

  
-- *****************************************************************
-- ------------- INTERNAL FUNCTIONS AND PROCEDURES -----------------
-- *****************************************************************

--------------------------- store_renamed --------------------------------

PROCEDURE store_renamed (i   IN OUT BINARY_INTEGER,
                         old VARCHAR2,
                         new VARCHAR2)
IS
BEGIN
   i:= i+1;
   rp(i).oldname:=old;
   rp(i).newname:=new;
END store_renamed;

--------------------------- store_removed --------------------------------

PROCEDURE store_removed (i    IN OUT BINARY_INTEGER,
                         name VARCHAR2)
IS
BEGIN
   i:=i+1;
   op(i).name:=name;
END store_removed;

--------------------------- store_special --------------------------------

PROCEDURE store_special (i    IN OUT BINARY_INTEGER,
                         old  VARCHAR2,
                         oldv VARCHAR2,
                         new  VARCHAR2,
                         newv VARCHAR2)
IS
BEGIN
   i:= i+1;
   sp(i).oldname:=old;
   sp(i).oldvalue:=oldv;
   sp(i).newname:=new;
   sp(i).newvalue:=newv;
   
END store_special;

--------------------------- store_minvalue --------------------------------

PROCEDURE store_minvalue (i    IN OUT BINARY_INTEGER,
                          name  VARCHAR2,
                          minv   NUMBER)
IS
BEGIN
   i:= i+1;
   mp(i).name:=name;
   mp(i).minvalue:=minv;
   mp(i).display:=FALSE;

END store_minvalue;

--------------------------- store_comp -----------------------------------

PROCEDURE store_comp (i       BINARY_INTEGER,
                      schema  VARCHAR2,
                      version VARCHAR2,
                      status  NUMBER)
IS
BEGIN

   cmp_info(i).processed := TRUE;
   IF status = 0 THEN
      cmp_info(i).status := 'INVALID';
   ELSIF status = 1 THEN
      cmp_info(i).status := 'VALID';
   ELSIF status = 2 THEN
      cmp_info(i).status := 'LOADING';
   ELSIF status = 3 THEN
      cmp_info(i).status := 'LOADED';
   ELSIF status = 4 THEN
      cmp_info(i).status := 'UPGRADING';
   ELSIF status = 5 THEN
      cmp_info(i).status := 'UPGRADED';
   ELSIF status = 6 THEN
      cmp_info(i).status := 'DOWNGRADING';
   ELSIF status = 7 THEN
      cmp_info(i).status := 'DOWNGRADED';
   ELSIF status = 8 THEN
      cmp_info(i).status := 'REMOVING';
   ELSIF status = 9 THEN
      cmp_info(i).status := 'OPTION OFF';
   ELSIF status = 10 THEN
      cmp_info(i).status := 'NO SCRIPT';
   ELSIF status = 99 THEN
      cmp_info(i).status := 'REMOVED';
   ELSE
      cmp_info(i).status := NULL;
   END IF;
   cmp_info(i).version   := version;
   cmp_info(i).schema    := schema;
   SELECT default_tablespace INTO cmp_info(i).def_ts
   FROM dba_users WHERE username = schema;
EXCEPTION
   WHEN NO_DATA_FOUND THEN NULL;
END store_comp;


------------------------------ update_puiu_data ---------------------

PROCEDURE update_puiu_data (dtype varchar2, dname varchar2, delta number)
IS
BEGIN

    IF collect_diag THEN
       EXECUTE IMMEDIATE 'UPDATE sys.puiu$data SET puiu_delta = :delta ' ||
                  'WHERE d_type=:dtype and d_name= :dname'
       USING delta, dtype, dname;
       COMMIT;
    END IF;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN NULL;
END;

------------------------------ insert_puiu_data ---------------------

PROCEDURE insert_puiu_data (dtype varchar2, dname varchar2, delta number)
IS
BEGIN

    IF collect_diag AND NOT display_xml THEN
       EXECUTE IMMEDIATE 'INSERT INTO sys.puiu$data 
              (d_type, d_name, puiu_delta) VALUES (:dtype, :dname, :delta)'
       USING dtype, dname, delta;
       COMMIT;
    END IF;
EXCEPTION 
    WHEN DUP_VAL_ON_INDEX THEN NULL;
END;

-------------------------- is_comp_tablespace ------------------------------------
-- returns TRUE if some existing component has the tablespace as a default

FUNCTION is_comp_tablespace (tsname VARCHAR2) RETURN BOOLEAN
IS
BEGIN
    FOR i IN 1..max_components LOOP
        IF cmp_info(i).processed AND
           tsname = cmp_info(i).def_ts THEN
           RETURN TRUE;
        END IF;
    END LOOP;
    RETURN FALSE;
END is_comp_tablespace;

-------------------------- ts_has_queues ---------------------------------
-- returns TRUE if there is at least one queue in the tablespace

FUNCTION ts_has_queues (tsname VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   SELECT NULL INTO p_null FROM dba_tables t
   WHERE exists (SELECT 1
                 FROM dba_queues q
                 WHERE q.queue_table = t.table_name)
    AND t.tablespace_name = tsname
    AND rownum <=1;
   RETURN TRUE;
EXCEPTION
   WHEN NO_DATA_FOUND THEN RETURN FALSE;
END ts_has_queues;

-------------------------- ts_is_SYS_temporary ---------------------------------
-- returns TRUE if there is at least one queue in the tablespace

FUNCTION ts_is_SYS_temporary (tsname VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   SELECT NULL INTO p_null FROM dba_users
   WHERE username = 'SYS' AND temporary_tablespace = tsname;
   RETURN TRUE;
EXCEPTION
   WHEN NO_DATA_FOUND THEN RETURN FALSE;
END ts_is_SYS_temporary;

-------------------------- display_header -------------------------------------
PROCEDURE display_header
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(utlu_banner || TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'));
  DBMS_OUTPUT.PUT_LINE('Script Version: ' || utlu_version || utlu_patchset ||
                            ' Build: ' || utlu_buildrev);
  DBMS_OUTPUT.PUT_LINE('.');
END display_header;

-------------------------- display_banner -------------------------------------

PROCEDURE display_banner
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(
   '**********************************************************************');
END display_banner;

-------------------------- display_database -----------------------------------

PROCEDURE display_database
IS
BEGIN
   IF display_xml THEN
      DBMS_OUTPUT.PUT_LINE('<Database>');
      DBMS_OUTPUT.PUT_LINE('<database Name="' || db_name || '"/>');
      DBMS_OUTPUT.PUT_LINE('<database Version="' || db_version || '"/>');
      DBMS_OUTPUT.PUT_LINE('<database Compatibility="' || db_compat || '"/>');
      DBMS_OUTPUT.PUT_LINE('</Database>');
   ELSE
     display_banner;
     DBMS_OUTPUT.PUT_LINE('Database:');
     display_banner;
     DBMS_OUTPUT.PUT_LINE ('--> name:          ' || db_name );
     DBMS_OUTPUT.PUT_LINE ('--> version:       ' || db_version );
     DBMS_OUTPUT.PUT_LINE ('--> compatible:    ' || db_compat );
     DBMS_OUTPUT.PUT_LINE ('--> blocksize:     ' || db_block_size );
     IF xe_upgrade THEN
        DBMS_OUTPUT.PUT_LINE ('--> edition:       ' || 'XE' );
     END IF;
     IF NOT (dbv=920) THEN
        DBMS_OUTPUT.PUT_LINE ('--> platform:      ' || db_platform_name );
     END IF;
     DBMS_OUTPUT.PUT_LINE ('--> timezone file: V' || db_tz_version );
     DBMS_OUTPUT.PUT_LINE ('.');
   END IF;
END display_database;

------------------------------ display_logfiles -----------------------------
-- Display the names and sizes of all logfiles in lf_info

PROCEDURE display_logfiles
IS

BEGIN
   IF display_xml THEN
      IF max_lf > 0 THEN
         FOR i IN 1..max_lf LOOP
            DBMS_OUTPUT.PUT_LINE(
               '<RedologFile name="' || lf_info(i).file_spec || 
                 '" group="'  || TO_CHAR(lf_info(i).grp) ||
                 '" status="' || lf_info(i).status||
                 '" size="'   || TO_CHAR(rmd_log_size) || 
                 '" unit="MB"/>');
          END LOOP;
      END IF;
      DBMS_OUTPUT.PUT_LINE(
          '<RollbackSegment name="SYSTEM" size="90" unit="MB"/>');
   ELSE
      display_banner;
      DBMS_OUTPUT.PUT_LINE(
           'Logfiles: [make adjustments in the current environment]');
      display_banner;
      IF max_lf > 0 THEN
        FOR i IN 1..max_lf LOOP
            DBMS_OUTPUT.PUT_LINE('--> ' || lf_info(i).file_spec);
            DBMS_OUTPUT.PUT_LINE('.... status="' || lf_info(i).status ||
                                   '", group#="' || TO_CHAR(lf_info(i).grp) ||
                                   '"');
            DBMS_OUTPUT.PUT_LINE(
            '.... current size="' || TO_CHAR(lf_info(i).bytes/1024) || '" KB');

            DBMS_OUTPUT.PUT_LINE(
            '.... suggested new size="' || TO_CHAR(rmd_log_size) || 
                                           '" MB');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(
             'WARNING: one or more log files is less than 4MB.');
        DBMS_OUTPUT.PUT_LINE('Create additional log files larger ' ||
             'than 4MB, drop the smaller ones and then upgrade.');
      ELSE
         DBMS_OUTPUT.PUT_LINE(
         '--> The existing log files are adequate. No changes are required.');
      END IF;
      DBMS_OUTPUT.PUT_LINE ('.');
   END IF;
END display_logfiles;
 
----------------------- display_crs_xml -----------------------------
-- Display create rollback segment. Display is in xml format, only
-- for use by DBUA. Static. Note: DBMS_OUTPUT.PUT_LINE does no more than
-- 255 bytes.

PROCEDURE display_crs_xml
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE(
        '<CreateRollbackSegments value="ODMA_RBS01" revert="true">');
   DBMS_OUTPUT.PUT_LINE(
        '<InNewTablespace name="ODMA_RBS" size="70" unit="MB">');
   DBMS_OUTPUT.PUT_LINE(
        '<Datafile name="{ORACLE_BASE}/oradata/{DB_NAME}/odma_rbs.dbf"/>');
   DBMS_OUTPUT.PUT_LINE(
        '<Autoextend value="ON">');
   DBMS_OUTPUT.PUT_LINE(
        '<Next value="10" unit="MB"/>');
   DBMS_OUTPUT.PUT_LINE(
        '<Maxsize value="200" unit="MB"/>');
   DBMS_OUTPUT.PUT_LINE(
        '</Autoextend>');
   DBMS_OUTPUT.PUT_LINE(
        '<Storage>');
   DBMS_OUTPUT.PUT_LINE(
        '<Initial value="10" unit="MB"/>');
   DBMS_OUTPUT.PUT_LINE(
        '<Next value="10" unit="MB"/>');
   DBMS_OUTPUT.PUT_LINE(
        '<MinExtents value="1"/>');
   DBMS_OUTPUT.PUT_LINE(
        '<MaxExtents value="30"/>');
   DBMS_OUTPUT.PUT_LINE(
        '</Storage>');
   DBMS_OUTPUT.PUT_LINE(
        '</InNewTablespace>');
   DBMS_OUTPUT.PUT_LINE(
        '</CreateRollbackSegments>');

END display_crs_xml;

---------------------- display_sysaux ------------------------------
PROCEDURE display_sysaux 
IS

BEGIN
   IF display_xml THEN
      DBMS_OUTPUT.PUT_LINE('<SYSAUXtbs>');
   ELSE
      display_banner;
      DBMS_OUTPUT.PUT_LINE('SYSAUX Tablespace:');
      DBMS_OUTPUT.PUT_LINE('[Create tablespace in the Oracle ' ||
                            'Database 11.1 environment]');
      display_banner;
   END IF;

   IF sysaux_exists THEN
      IF display_xml THEN
          DBMS_OUTPUT.PUT_LINE('<SysauxTablespace present="true"/>');
          DBMS_OUTPUT.PUT_LINE('<Attributes>');
          DBMS_OUTPUT.PUT_LINE('<Size value="' || TO_CHAR(delta_sysaux) ||
                                           '" unit="MB"/>');
          IF sysaux_not_online THEN
             DBMS_OUTPUT.PUT_LINE('<Online value="false"/>');
          ELSE 
             DBMS_OUTPUT.PUT_LINE('<Online value="true"/>');
          END IF;

          IF sysaux_not_perm THEN
             DBMS_OUTPUT.PUT_LINE('<Permanent value="false"/>');
          ELSE 
             DBMS_OUTPUT.PUT_LINE('<Permanent value="true"/>');
          END IF;
          -- Online and Readwrite are together
          IF sysaux_not_online THEN
             DBMS_OUTPUT.PUT_LINE('<Readwrite value="false"/>');
          ELSE 
             DBMS_OUTPUT.PUT_LINE('<Readwrite value="true"/>');
          END IF;
          IF sysaux_not_local THEN
             DBMS_OUTPUT.PUT_LINE('<ExtentManagementLocal value="false"/>');
          ELSE 
             DBMS_OUTPUT.PUT_LINE('<ExtentManagementLocal value="true"/>');
          END IF;
          IF sysaux_not_auto THEN
             DBMS_OUTPUT.PUT_LINE(
                           '<SegmentSpaceManagementAuto value="false"/>');
          ELSE 
             DBMS_OUTPUT.PUT_LINE(
                           '<SegmentSpaceManagementAuto value="true"/>');
          END IF;
          DBMS_OUTPUT.PUT_LINE('</Attributes>');
      ELSE
          DBMS_OUTPUT.PUT_LINE('WARNING: SYSAUX tablespace is present.');
          DBMS_OUTPUT.PUT_LINE(
             '.... Minimum required size for database upgrade:' ||
             TO_CHAR(delta_sysaux) || ' MB');
          -- Online and Readwrite are together 
          IF sysaux_not_online THEN
             DBMS_OUTPUT.PUT_LINE('WARNING:.... OFFLINE');
          ELSE 
             DBMS_OUTPUT.PUT_LINE('.... Online');
          END IF;
          IF sysaux_not_perm THEN
             DBMS_OUTPUT.PUT_LINE('WARNING:.... NOT Permanent');
          ELSE 
             DBMS_OUTPUT.PUT_LINE('.... Permanent');
          END IF;
          -- Online and Readwrite are together
          IF sysaux_not_online THEN
             DBMS_OUTPUT.PUT_LINE('WARNING:.... NOT Readwrite');
          ELSE 
             DBMS_OUTPUT.PUT_LINE('.... Readwrite');
          END IF;
          IF sysaux_not_local THEN
             DBMS_OUTPUT.PUT_LINE(
             '.... WARNING:  NOT ExtentManagementLocal');
          ELSE 
             DBMS_OUTPUT.PUT_LINE('.... ExtentManagementLocal');
          END IF;

          IF sysaux_not_auto THEN
             DBMS_OUTPUT.PUT_LINE(
             'WARNING:.... NOT SegmentSpaceManagementAuto');
          ELSE 
             DBMS_OUTPUT.PUT_LINE(
             '.... SegmentSpaceManagementAuto');
          END IF; 
      END IF;
   ELSE  -- SYSAUX tablespace does not exist
      IF display_xml THEN
          DBMS_OUTPUT.PUT_LINE('<SysauxTablespace present="false"/>');
          DBMS_OUTPUT.PUT_LINE('<Attributes>');
          DBMS_OUTPUT.PUT_LINE('<Size value="' ||
                      TO_CHAR(delta_sysaux) || '" unit="MB"/>');
          DBMS_OUTPUT.PUT_LINE('</Attributes>');
      ELSE
          DBMS_OUTPUT.PUT_LINE('--> New "SYSAUX" tablespace ');
          DBMS_OUTPUT.PUT_LINE(
             '.... minimum required size for database upgrade: '  ||
                   TO_CHAR(delta_sysaux) || ' MB');
      END IF;
   END IF;
   IF display_xml THEN
      DBMS_OUTPUT.PUT_LINE('</SYSAUXtbs>');
   ELSE
     DBMS_OUTPUT.PUT_LINE ('.');
   END IF;
END display_sysaux;

--------------------------- display_components -----------------------------

PROCEDURE display_components
IS
   ui VARCHAR2(10);
BEGIN
   IF display_xml THEN
      DBMS_OUTPUT.NEW_LINE;
      DBMS_OUTPUT.PUT_LINE('<Components>');
      DBMS_OUTPUT.PUT_LINE( 
         '<Component id ="Oracle Server" type="SERVER" cid="RDBMS">');
      DBMS_OUTPUT.PUT_LINE(
          '<CEP value="{ORACLE_HOME}/rdbms/admin/rdbmsup.sql"/>');
      DBMS_OUTPUT.PUT_LINE(
          '<SupportedOracleVersions value="9.2.0,10.1.0, 10.2.0, 11.1.0"/>');
      DBMS_OUTPUT.PUT_LINE(   
         '<OracleVersion value ="'|| db_version || '"/>'); 
      DBMS_OUTPUT.PUT_LINE('</Component>');

      FOR i IN 3 .. max_components LOOP
         IF cmp_info(i).processed THEN
         DBMS_OUTPUT.PUT_LINE('<Component id="' || cmp_info(i).cname ||
                              '" cid="' || cmp_info(i).cid || 
                              '" script="' || cmp_info(i).script || '">');
         DBMS_OUTPUT.PUT_LINE('<OracleVersion value="' ||
                               cmp_info(i).version || '"/>');
         DBMS_OUTPUT.PUT_LINE('</Component>');
     END IF;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('</Components>');

ELSE
    DBMS_OUTPUT.new_line;
    display_banner;
    DBMS_OUTPUT.PUT_LINE (
      'Components: [The following database components will be ' ||
      'upgraded or installed]'); 
    display_banner;
    FOR i IN 1..max_components LOOP
        IF cmp_info(i).processed THEN
            IF cmp_info(i).install THEN
               ui := '[install]';
            ELSE
               ui := '[upgrade]';
            END IF;
            DBMS_OUTPUT.PUT_LINE(
            '--> ' || rpad(cmp_info(i).cname, 28) || ' ' ||
                      rpad(ui, 10) || ' ' ||
                      rpad(cmp_info(i).status, 9)); 
            IF dbv != 111 THEN
               IF (cmp_info(i).cid = 'DV') THEN
               DBMS_OUTPUT.PUT_LINE(
                  '... To successfully upgrade Oracle Database Vault, perform  ');
                  DBMS_OUTPUT.PUT_LINE(
                  '... a Custom install and select the Database Vault option.');
               ELSIF ((cmp_info(i).cid  = 'OLS') AND 
                     NOT cmp_info(dv).processed) THEN
                  DBMS_OUTPUT.PUT_LINE(
                  '... To successfully upgrade Oracle Label Security, perform  ');
                  DBMS_OUTPUT.PUT_LINE(
                  '... a Custom install and select the OLS option.');
               END IF;
            END IF;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('.');
END IF;

END display_components;

--------------------------- display_tablespaces -----------------------------
-- Display the names and sizes of all tablespaces in ts_info

PROCEDURE display_tablespaces
IS
BEGIN

   IF display_xml THEN
      DBMS_OUTPUT.PUT_LINE('<SystemResource>');
      DBMS_OUTPUT.PUT_LINE('<MinFreeSpace>');
      FOR i IN 1..max_ts LOOP
         IF ts_info(i).inc_by > 0 OR ts_info(i).addl > 0 THEN
            IF ts_info(i).fauto = FALSE AND ts_info(i).inc_by > 0 THEN
               DBMS_OUTPUT.PUT_LINE(
                    '<DefaultTablespace value="' || ts_info(i).name ||
                 '"> <AdditionalSize size="' ||
                             TO_CHAR(ROUND(ts_info(i).inc_by)) ||
                             '" unit="MB"/>' ||
                 ' <TotalSize size="' ||
                             TO_CHAR(ROUND(ts_info(i).min)) ||
                             '" unit="MB"/>');
               DBMS_OUTPUT.PUT_LINE(' </DefaultTablespace>');
            ELSE 
               -- Autoextend is ON
               IF ts_info(i).inc_by > 0 THEN
                  DBMS_OUTPUT.PUT_LINE(
                        '<DefaultTablespace value="' || ts_info(i).name ||
                     '"> <Datafile name="' || ts_info(i).fname ||
                    '"/> <AdditionalSize size="' ||
                             TO_CHAR(ROUND(ts_info(i).inc_by)) ||
                             '" unit="MB"' ||
                    '/> <TotalSize size="' ||
                             TO_CHAR(ROUND(ts_info(i).min)) ||
                             '" unit="MB"/>');
                  DBMS_OUTPUT.PUT_LINE(
                     '<Autoextend value="ON"> <Next value="10" unit="MB"/>' ||
                    ' <Maxsize value="' ||
                             TO_CHAR(ROUND(ts_info(i).min)) ||
                             '" unit="MB"/> ' ||
                     '</Autoextend>');
                  DBMS_OUTPUT.PUT_LINE('</DefaultTablespace>');
               ELSIF ts_info(i).addl > 0 THEN
                  DBMS_OUTPUT.PUT_LINE(
                        '<DefaultTablespace value="' || ts_info(i).name ||
                     '"> <Datafile name="' || ts_info(i).fname ||
                    '"/> <AdditionalAlloc size="' ||
                             TO_CHAR(ROUND(ts_info(i).addl)) ||
                             '" unit="MB"/>');
                  DBMS_OUTPUT.PUT_LINE('</DefaultTablespace>');
               END IF;
            END IF;
         END IF;
      END LOOP;

      display_logfiles;
      DBMS_OUTPUT.PUT_LINE('</MinFreeSpace>');

      -- Display the DBUA required create rollback segment static tags
      display_crs_xml;
      DBMS_OUTPUT.PUT_LINE('</SystemResource>');

      -- Report the SYSAUX tablespace
      IF dbv NOT IN (101,102) THEN
         display_sysaux;
      END IF;

   ELSE -- display TEXT output
      display_banner;
      DBMS_OUTPUT.PUT_LINE(
           'Tablespaces: [make adjustments in the current environment]');
      display_banner;
      IF max_ts > 0 THEN
         FOR i IN 1..max_ts LOOP
           IF ts_info(i).inc_by = 0 THEN
              DBMS_OUTPUT.PUT_LINE(
                '--> ' || ts_info(i).name || 
                     ' tablespace is adequate for the upgrade.');
              DBMS_OUTPUT.PUT_LINE(
                '.... minimum required size: ' ||
                TO_CHAR(ROUND(ts_info(i).min)) || ' MB');

              IF ts_info(i).addl > 0 THEN
                 DBMS_OUTPUT.PUT_LINE(
                     '.... AUTOEXTEND additional space required: ' ||
                     TO_CHAR(ROUND(ts_info(i).addl)) || ' MB');
              END IF;
           ELSE  -- need more space in tablespace
              DBMS_OUTPUT.PUT_LINE(
                'WARNING: --> ' || ts_info(i).name || 
                          ' tablespace is not large enough for the upgrade.');
              DBMS_OUTPUT.PUT_LINE(
                 '.... currently allocated size: ' ||
                  TO_CHAR(ROUND(ts_info(i).alloc)) || ' MB');
              DBMS_OUTPUT.PUT_LINE(
                 '.... minimum required size: ' ||
                  TO_CHAR(ROUND(ts_info(i).min)) || ' MB');
              DBMS_OUTPUT.PUT_LINE(
                 '.... increase current size by: ' ||
                  TO_CHAR(ROUND(ts_info(i).inc_by)) || ' MB');
              IF ts_info(i).fauto THEN
                 DBMS_OUTPUT.PUT_LINE(
                   '.... tablespace is AUTOEXTEND ENABLED.');
              ELSE 
                 DBMS_OUTPUT.PUT_LINE(
                  '.... tablespace is NOT AUTOEXTEND ENABLED.');
              END IF;    
           END IF; 
        END LOOP;

      DBMS_OUTPUT.PUT_LINE ('.');
      END IF;
   END IF;
END display_tablespaces;
 
------------------------------ display_rollback_segs ---------------------
-- Display information about public rollback segments

PROCEDURE display_rollback_segs
IS
  auto VARCHAR2(3);

BEGIN
   IF NOT display_xml THEN
      IF max_rs > 0 THEN
         display_banner;
         DBMS_OUTPUT.PUT_LINE('Rollback Segments: [make adjustments ' ||
                              'immediately prior to upgrading]');
         display_banner;
         -- Loop through the rs_info table
         FOR i IN 1..max_rs LOOP
            IF rs_info(i).auto > 0 THEN 
               auto:='ON'; 
            ELSE
               auto:='OFF'; 
            END IF;
            DBMS_OUTPUT.PUT_LINE(
                '--> ' || rs_info(i).seg_name || ' in tablespace ' || 
                          rs_info(i).tbs_name || ' is ' || 
                          rs_info(i).status ||
                          '; AUTOEXTEND is ' || auto);
            DBMS_OUTPUT.PUT_LINE(
                '.... currently allocated: ' || rs_info(i).inuse 
                      || 'K');
            DBMS_OUTPUT.PUT_LINE(
                '.... next extent size: ' || rs_info(i).next 
                      || 'K; max extents: ' || rs_info(i).max_ext);
         END LOOP;
         DBMS_OUTPUT.PUT_LINE(
               'WARNING: --> For the upgrade, use a large (minimum 70M) ' ||
                            'public rollback segment');
         IF max_rs >1 THEN
            DBMS_OUTPUT.PUT_LINE(
             'WARNING: --> Take smaller public rollback segments OFFLINE');
         END IF;
         DBMS_OUTPUT.PUT_LINE ('.');
      END IF;
   END IF;

END display_rollback_segs;

------------------------------- display_parameters ------------------------
-- Display any renamed, obsolete, and special parameters.

PROCEDURE display_parameters
IS

  changes_req BOOLEAN := FALSE;

BEGIN
  IF display_xml THEN
    DBMS_OUTPUT.PUT_LINE('<InitParams>');
    DBMS_OUTPUT.PUT_LINE('<Update>');

   -- minimum value parameters
    FOR i IN 1..max_mp LOOP
      IF mp(i).display THEN
        IF NOT (i = jv_idx and NOT cmp_info(javavm).processed) THEN
          IF NOT (i = mt_idx and mp(i).oldvalue IS NULL) THEN
             DBMS_OUTPUT.PUT_LINE('<Parameter name="' ||
                mp(i).name ||
                '" atleast="' ||
                TO_CHAR(ROUND(mp(i).newvalue)) ||
                '" type="NUMBER"/>');
           END IF;
        END IF;
      END IF;
    END LOOP;

    -- Parameters with new names
    FOR i IN 1..max_sp LOOP
       IF sp(i).db_match = TRUE AND
          sp(i).oldvalue IS NOT NULL AND
          sp(i).newvalue IS NULL THEN
          DBMS_OUTPUT.PUT_LINE(
             '<Parameter name="' || sp(i).newname ||
            '" setThis="' || sp(i).oldvalue || '" type="STRING"/>');
       END IF;
    END LOOP;

    -- Required values if missing
    FOR i IN 1..max_reqp LOOP
       IF reqp(i).db_match = TRUE THEN
          -- For values of type NUMBER
          IF reqp(i).type = 3 THEN
            DBMS_OUTPUT.PUT_LINE('<Parameter name="' ||
             reqp(i).name ||
             '" setThis="' ||
             TO_CHAR(ROUND(reqp(i).newnumbervalue)) ||
             '" type="NUMBER"/>');
          -- For values of type STRING
          ELSIF reqp(i).type = 2 THEN
            DBMS_OUTPUT.PUT_LINE('<Parameter name="' ||
             reqp(i).name ||
             '" setThis="' ||
             reqp(i).newstringvalue ||
             '" type="STRING"/>');
          END IF;
       END IF;
    END LOOP;

    -- Display the minimum compatibility static tag
    IF dbv = 920 OR (dbv IN (101,102) AND SUBSTR(db_compat,1,2)!='10') THEN
       DBMS_OUTPUT.PUT_LINE(
        '<Parameter name="compatible" atleast="10.1.0" type="VERSION"/>');
    END IF;

    DBMS_OUTPUT.PUT_LINE('</Update>');

    -- Static tags for Migration and NonHandled go here (XML, only)
    DBMS_OUTPUT.PUT_LINE('<Migration>');
--    DBMS_OUTPUT.PUT_LINE('<Parameter name="optimizer_mode" value="choose"/>');
    DBMS_OUTPUT.PUT_LINE('</Migration>');

    DBMS_OUTPUT.PUT_LINE('<NonHandled>');
    DBMS_OUTPUT.PUT_LINE('<Parameter name="remote_listener"/>');
    DBMS_OUTPUT.PUT_LINE('</NonHandled>');

    -- Renamed Parameters
    DBMS_OUTPUT.PUT_LINE('<Rename>');
    FOR i IN 1..max_rp LOOP
       IF rp(i).db_match = TRUE THEN
          DBMS_OUTPUT.PUT_LINE(
           '<Parameter oldName="' || rp(i).oldname || 
                    '" newName="' || rp(i).newname || '"/>');
       END IF;
    END LOOP;  

    -- Display parameters that have a new name and a new value
    FOR i IN 1..max_sp LOOP
       IF sp(i).db_match = TRUE AND
          sp(i).newvalue IS NOT NULL THEN
          DBMS_OUTPUT.PUT_LINE('<Parameter oldName="' || sp(i).oldname ||
           '" newName="' || sp(i).newname ||
           '" newValue="' || sp(i).newvalue || '"/>');
       END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('</Rename>');

    -- Display Obsolete Parameters to remove
    DBMS_OUTPUT.PUT_LINE('<Remove>');
    FOR i IN 1..max_op LOOP
       IF op(i).db_match = TRUE THEN
          DBMS_OUTPUT.PUT_LINE('<Parameter name="' ||
           op(i).name || '"/>');
       END IF;
    END LOOP;  
    DBMS_OUTPUT.PUT_LINE('</Remove>');
    DBMS_OUTPUT.PUT_LINE('</InitParams>');

  ELSE  -- Display TEXT parameter output
    display_banner;
    DBMS_OUTPUT.PUT_LINE(
      'Update Parameters: [Update Oracle Database 11.1 init.ora or spfile]');
    display_banner;

    -- Display the minimum compatibility static tag
    IF dbv = 920 OR (dbv IN (101,102) AND SUBSTR(db_compat,1,2)!='10') THEN
       DBMS_OUTPUT.PUT_LINE('WARNING: --> "compatible" must be '||
               'set to at least 10.1.0');
    changes_req := TRUE;
    END IF;

    -- parameters with minimum values
    FOR i IN 1..max_mp LOOP
      IF mp(i).display THEN
        IF NOT (i = jv_idx and NOT cmp_info(javavm).processed) THEN
          IF NOT (i = mt_idx and mp(i).oldvalue IS NULL) THEN
          changes_req := TRUE;
          IF mp(i).oldvalue IS NULL THEN
             -- Convert to M from bytes
             IF i IN (tg_idx,pg_idx,jv_idx,sp_idx) THEN
                DBMS_OUTPUT.PUT_LINE ('WARNING: --> "'||mp(i).name ||
                   '" is not currently defined and needs a value of at least ' ||
                   TO_CHAR(ROUND((mp(i).newvalue/1024)/1024)) || ' MB');
             ELSE
                DBMS_OUTPUT.PUT_LINE ('WARNING: --> "'||mp(i).name ||
                    '" is not currently defined and needs a value of at least '||
                     TO_CHAR(ROUND(mp(i).newvalue)));
             END IF;
          ELSE
           IF mp(i).oldvalue < mp(i).newvalue THEN
              IF i IN (tg_idx,pg_idx,jv_idx,sp_idx,mt_idx) THEN
                DBMS_OUTPUT.PUT_LINE(
                       'WARNING: --> "'||mp(i).name ||
                       '" needs to be increased to at least ' ||
                        TO_CHAR(ROUND((mp(i).newvalue/1024)/1024)) || ' MB');
                ELSE
                  IF (i = cs_idx) THEN
                     text_buffer := ' bytes';
                  ELSE
                     text_buffer := ' ';
                  END IF;
                  DBMS_OUTPUT.PUT_LINE(
                          'WARNING: --> "'||mp(i).name ||
                           '" needs to be increased to at least ' ||
                           TO_CHAR(ROUND(mp(i).newvalue)) || text_buffer);
	        END IF;
              ELSE
                -- Convert to M from bytes
                IF i IN (tg_idx,pg_idx,jv_idx,sp_idx,mt_idx) THEN 
                   DBMS_OUTPUT.PUT_LINE(
                      '--> "'||mp(i).name || '" is already at ' ||
                      TO_CHAR(ROUND((mp(i).oldvalue/1024)/1024)) ||
                      '; calculated minimum value is ' ||
                      TO_CHAR(ROUND((mp(i).newvalue/1024)/1024)) || ' MB');
                ELSE
                   DBMS_OUTPUT.PUT_LINE(
                       '--> "'||mp(i).name || '" is already at ' ||
                      TO_CHAR(ROUND(mp(i).oldvalue)) ||
                      '; calculated minimum value is ' ||
                      TO_CHAR(ROUND(mp(i).newvalue)));
                END IF;
             END IF;
          END IF; -- null oldvalue
         END IF; -- not (mt_idx and mt null oldvalue)
        END IF; -- not (jv_idx and not processed)
      END IF; -- display
    END LOOP;

    -- Required values if missing
    FOR i IN 1..max_reqp LOOP
       IF reqp(i).db_match = TRUE THEN
          changes_req := TRUE;
          IF reqp(i).type = 3 THEN
             DBMS_OUTPUT.PUT_LINE('WARNING: --> "' ||
              reqp(i).name || '" is not defined and must have a value=' ||
              TO_CHAR(ROUND(reqp(i).newnumbervalue)));
          ELSIF reqp(i).type = 2 THEN
             DBMS_OUTPUT.PUT_LINE('WARNING: --> "' ||
              reqp(i).name || '" is not defined and must have a value=' ||
              reqp(i).newstringvalue);
          END IF;
       END IF;
    END LOOP;

    IF  NOT changes_req THEN
       DBMS_OUTPUT.PUT_LINE(
           '-- No update parameter changes are required.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('.');

    display_banner;
    DBMS_OUTPUT.PUT_LINE(
    'Renamed Parameters: [Update Oracle Database 11.1 init.ora or spfile]');
    display_banner;
    changes_req := FALSE;

    -- renamed parameters
    FOR i IN 1..max_rp LOOP
       IF rp(i).db_match = TRUE THEN
          changes_req := TRUE;
          DBMS_OUTPUT.PUT_LINE('WARNING: --> "' || rp(i).oldname ||
           '" new name is "' || rp(i).newname || '"');
       END IF;
    END LOOP;

    -- renamed parameters with new values
    FOR i IN 1..max_sp LOOP
       IF sp(i).db_match = TRUE THEN
          changes_req := TRUE;
          IF sp(i).oldvalue IS NULL THEN
             DBMS_OUTPUT.PUT_LINE('WARNING: --> "' || sp(i).oldname ||
               '" new name is "' || sp(i).newname ||
               '" new value is "' || sp(i).newvalue || '"');
          ELSE
             DBMS_OUTPUT.PUT_LINE('WARNING: --> "' || sp(i).oldname ||
               '" old value was "' || sp(i).oldvalue || '";');
             DBMS_OUTPUT.PUT_LINE('.        --> new name is "' || 
               sp(i).newname || '", new value is "' || sp(i).newvalue || '"');
          END IF;
       END IF;
    END LOOP;

    IF  NOT changes_req THEN
       DBMS_OUTPUT.PUT_LINE(
       '-- No renamed parameters found. No changes are required.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('.');

    display_banner;
    DBMS_OUTPUT.PUT_LINE(
     'Obsolete/Deprecated Parameters: [Update Oracle Database 11.1 init.ora or spfile]');
    display_banner;
    changes_req := FALSE;

    -- obsolete (removed) parameters
    FOR i IN 1..max_op LOOP
       IF op(i).db_match = TRUE THEN
          changes_req := TRUE;
          IF op(i).name NOT IN ('background_dump_dest','core_dump_dest','user_dump_dest') THEN
             DBMS_OUTPUT.PUT_LINE('--> "' || op(i).name || '"');         
          ELSE
             -- bdump, cdump, udump deprecated by diagnostic_dest
             DBMS_OUTPUT.PUT_LINE('--> "' || op(i).name || '"' || ' replaced by  "diagnostic_dest"');
          END IF;
       END IF;
    END LOOP;  
    IF NOT changes_req THEN
       DBMS_OUTPUT.PUT_LINE(
       '-- No obsolete parameters found. No changes are required');
    END IF;

    DBMS_OUTPUT.PUT_LINE('.');
  END IF;
END display_parameters;

----------------- display_misc_warnings ------------------------------

procedure display_misc_warnings
IS

BEGIN
  
   IF display_xml THEN
      DBMS_OUTPUT.PUT_LINE('<Warnings>');
   
      IF version_mismatch THEN
          DBMS_OUTPUT.PUT_LINE('<warning name="VERSION_MISMATCH"/>');
      END IF;
   
      IF cluster_dbs THEN
          DBMS_OUTPUT.PUT_LINE('<warning name="CLUSTER_DATABASE"/>');
      END IF;

      IF dip_user_exists THEN
           DBMS_OUTPUT.PUT_LINE('<warning name="DIP_USER_PRESENT"/>');
      END IF;

      IF ocm_user_exists THEN
           DBMS_OUTPUT.PUT_LINE('<warning name="OCM_USER_PRESENT"/>');
      END IF;

      IF nls_al24utffss THEN
          DBMS_OUTPUT.PUT_LINE(
            '<warning name="DESUPPORTED_CHARSET_AL24UTFFSS"/>');
      END IF;

      IF utf8_al16utf16 THEN
          DBMS_OUTPUT.PUT_LINE(
            '<warning name="NCHAR_TYPE_NOT_SUPP"/>');
      END IF;

      IF owm_replication THEN
          DBMS_OUTPUT.PUT_LINE('<warning name="WMSYS_REPLICATION_PRESENT"/>');
      END IF;

      IF dblinks  THEN
          DBMS_OUTPUT.PUT_LINE('<warning name="DBLINKS_WITH_PASSWORDS"/>');
      END IF;

      IF cdc_data THEN
          DBMS_OUTPUT.PUT_LINE('<warning name="CDC_CHANGE_SOURCE"/>');
      END IF;

      IF connect_role THEN
          DBMS_OUTPUT.PUT_LINE('<warning name="CONNECT_ROLE_IN_USE"/>');
      END IF;

      IF invalid_objs THEN
          DBMS_OUTPUT.PUT_LINE('<warning name="INVALID_OBJECTS_EXIST"/>');
      END IF;

      IF ssl_users THEN
          DBMS_OUTPUT.PUT_LINE('<warning name="SSL_USERS_EXIST"/>');
      END IF;

      IF timezone_old THEN
          DBMS_OUTPUT.PUT_LINE('<warning name="OLD_TIME_ZONES_EXIST"/>');
      ELSIF timezone_new THEN
          DBMS_OUTPUT.PUT_LINE('<warning name="NEW_TIME_ZONES_EXIST"/>');
      END IF;

      IF stale_stats THEN
          DBMS_OUTPUT.PUT_LINE('<warning name="STALE_STATISTICS"/>');
      END IF;

      IF em_exists THEN
          DBMS_OUTPUT.PUT_LINE('<warning name="EM_PRESENT"/>');
      END IF;

      IF snapshot_refresh THEN -- TRUE when outstanding snapshot refreshes
          DBMS_OUTPUT.PUT_LINE('<warning name="REFRESHES_EXIST"/>');
      END IF;

      IF recovery_files THEN -- TRUE when files need media recovery
          DBMS_OUTPUT.PUT_LINE('<warning name="FILES_NEED_RECOVERY"/>');
      END IF;

      IF files_backup_mode THEN -- TRUE when files are in backup mode
          DBMS_OUTPUT.PUT_LINE('<warning name="FILES_BACKUP_MODE"/>');
      END IF;

      IF pending_2pc_txn THEN  -- TRUE when pending distribution txns
          DBMS_OUTPUT.PUT_LINE('<warning name="2PC_TXN_EXIST"/>');
      END IF;

      IF sync_standby_db THEN  -- TRUE when need to sync the standby db
          DBMS_OUTPUT.PUT_LINE('<warning name="SYNC_STANDBY_DB"/>');
      END IF;

      DBMS_OUTPUT.PUT_LINE('</Warnings>');

   ELSE
      IF version_mismatch or cluster_dbs OR dip_user_exists OR 
         nls_al24utffss OR ssl_users OR timezone_old OR timezone_new OR
         stale_stats OR
         utf8_al16utf16 OR owm_replication OR dblinks OR connect_role OR 
         invalid_objs OR cdc_data OR ocm_user_exists OR 
         em_exists THEN
            display_banner;
            DBMS_OUTPUT.PUT_LINE('Miscellaneous Warnings');
            display_banner;
      ELSE
         RETURN;
      END IF;

      IF version_mismatch THEN
         DBMS_OUTPUT.PUT_LINE(
             'WARNING: --> The database has not been patched to release ' ||
             db_version || '.');
         DBMS_OUTPUT.PUT_LINE('... Run catpatch.sql prior to upgrading.');
      END IF;

      IF cluster_dbs THEN
         DBMS_OUTPUT.PUT_LINE('WARNING: --> The "cluster_database" parameter is currently "TRUE"');
        DBMS_OUTPUT.PUT_LINE('.... and must be set to "FALSE" prior to running a manual upgrade.');
      END IF;

      IF dip_user_exists THEN
         DBMS_OUTPUT.PUT_LINE('WARNING: --> "DIP" user found in database.');
         DBMS_OUTPUT.PUT_LINE(
             '.... This is a generic account used for '||
             'connecting to ');
         DBMS_OUTPUT.PUT_LINE(
            '.... the Database when processing DIP ' ||
             'callback functions.');
         DBMS_OUTPUT.PUT_LINE(
             '.... Oracle may add additional privileges to this account '||
             'during the upgrade.');
      END IF;

      IF ocm_user_exists THEN
         DBMS_OUTPUT.PUT_LINE('WARNING: --> "ORACLE_OCM" user found in database.');
         DBMS_OUTPUT.PUT_LINE(
             '.... This is an internal account used by the '||
             'Oracle Configuration Manger. ');
         DBMS_OUTPUT.PUT_LINE(
             '.... Oracle recommends dropping this user prior to '||
             'upgrading.');
      END IF;

      IF nls_al24utffss THEN
         DBMS_OUTPUT.PUT_LINE('WARNING: --> "nls_characterset" has ' ||
               ' "AL24UTFFSS" character set.');
         DBMS_OUTPUT.PUT_LINE(
             ' * The database must be converted to a supported character ' ||
             'set prior to upgrading.');
      END IF;

      IF utf8_al16utf16 THEN
         DBMS_OUTPUT.PUT_LINE('WARNING: --> Your database is using an ' ||
                     'obsolete NCHAR character set.');
         DBMS_OUTPUT.PUT_LINE(
             'In Oracle Database 11g, the NCHAR data types ' ||
             '(NCHAR, NVARCHAR2, and NCLOB)');
         DBMS_OUTPUT.PUT_LINE('are limited to the Unicode character ' ||
              'set encoding (UTF8 and AL16UTF16), only.');
         DBMS_OUTPUT.PUT_LINE('See "Database Character Sets" in chapter 5' ||
             ' of the Oracle 11g Database Upgrade');
         DBMS_OUTPUT.PUT_LINE(' Guide for further information. ' );
      END IF;

      IF owm_replication THEN
         DBMS_OUTPUT.PUT_LINE(
           'WARNING: --> Workspace Manager replication is in use.');
         DBMS_OUTPUT.PUT_LINE(
           '.... Drop OWM replication support before upgrading:');
         DBMS_OUTPUT.PUT_LINE(
           '.... EXECUTE dbms_wm.DropReplicationSupport;');
      END IF;

      IF dblinks  THEN
         DBMS_OUTPUT.PUT_LINE(
           'WARNING: --> Passwords exist in some database links.');
         DBMS_OUTPUT.PUT_LINE(
           '.... Passwords will be encrypted during the upgrade.');
         DBMS_OUTPUT.PUT_LINE(
          '.... Downgrade of database links with passwords is not supported.');
      END IF;

      IF cdc_data THEN
         DBMS_OUTPUT.PUT_LINE(
           'WARNING: --> CDC change sources exist; for full 11.1 support, alter ');
         DBMS_OUTPUT.PUT_LINE(
           '.... the change source on the staging database after the upgrade.');
      END IF;

      IF connect_role THEN
         DBMS_OUTPUT.PUT_LINE(
           'WARNING: --> Deprecated CONNECT role granted to some user/roles.');
         DBMS_OUTPUT.PUT_LINE(
           '.... CONNECT role after upgrade has only CREATE SESSION privilege.');
      END IF;

      IF timezone_old THEN
         DBMS_OUTPUT.PUT_LINE(
         'WARNING: --> Database is using an old timezone file version.');
         DBMS_OUTPUT.PUT_LINE(
           '.... Patch the ' || db_version ||  ' database to timezone file version ' 
           || utlu_tz_version);
         DBMS_OUTPUT.PUT_LINE(
           ' .... BEFORE upgrading the database.  Re-run utlu111i.sql after');
         DBMS_OUTPUT.PUT_LINE(
         ' .... patching the database to record the new timezone file version.');
      ELSIF timezone_new THEN
         DBMS_OUTPUT.PUT_LINE(
        'WARNING: --> Database is using a timezone file greater than version ' 
           || utlu_tz_version || '.');
         DBMS_OUTPUT.PUT_LINE(
           '.... Patch the 11g ORACLE_HOME to timezone file version ' 
           || db_tz_version ); 
        DBMS_OUTPUT.PUT_LINE(
            '.... BEFORE upgrading the database.');
      END IF;

      IF stale_stats THEN
         DBMS_OUTPUT.PUT_LINE(
         'WARNING: --> Database contains stale optimizer statistics.');
         DBMS_OUTPUT.PUT_LINE(
           '.... Refer to the 11g Upgrade Guide for instructions to update' );
         DBMS_OUTPUT.PUT_LINE(
           '.... statistics prior to upgrading the database.');
         IF dbv = 920 THEN
           DBMS_OUTPUT.PUT_LINE(
             '.... The following command(s)s will update the statistics:');
           EXECUTE IMMEDIATE '
 BEGIN
   FOR schema in (select name from sys.user$ where name in 
       (''SYS'', ''SYSTEM'', ''WMSYS'',''MDSYS'',''CTXSYS'',''XDB'',''WKSYS'',''LBACSYS'',''ORDSYS'',
        ''ORDPLUGINS'',''SI_INFORMATION_SCHEMA'', ''OUTLN'', ''DBSNMP'')) LOOP
      DBMS_OUTPUT.PUT_LINE (''.... EXECUTE dbms_stats.gather_schema_stats('''''' || schema.name || 
                             '''''',options=>''''GATHER'''''');
      DBMS_OUTPUT.PUT_LINE (''           ,estimate_percent=>DBMS_STATS.AUTO_SAMPLE_SIZE'');
      DBMS_OUTPUT.PUT_LINE (''           ,method_opt=>''''FOR ALL COLUMNS SIZE AUTO'''''');
      DBMS_OUTPUT.PUT_LINE (''           ,cascade=>TRUE);'');
   END LOOP;
  END;';
         ELSE
           DBMS_OUTPUT.PUT_LINE(
             '.... The following command will update the statistics:');
           DBMS_OUTPUT.PUT_LINE(
             '.... EXECUTE dbms_stats.gather_dictionary_stats;');
         END IF;
      END IF;

      IF invalid_objs THEN
         DBMS_OUTPUT.PUT_LINE(
           'WARNING: --> Database contains INVALID objects prior to upgrade.');
         DBMS_OUTPUT.PUT_LINE( 
           '.... The list of invalid SYS/SYSTEM objects was written to');
         DBMS_OUTPUT.PUT_LINE(
           '.... registry$sys_inv_objs.');
         IF warning_5000 THEN
            DBMS_OUTPUT.PUT_LINE(
             '.... Because there were more than 5000 invalid non-SYS/SYSTEM objects');
            DBMS_OUTPUT.PUT_LINE(
             '.... the list was not stored in registry$nonsys_inv_objs.');
         ELSE
           DBMS_OUTPUT.PUT_LINE(
            '.... The list of non-SYS/SYSTEM objects was written to');
           DBMS_OUTPUT.PUT_LINE(
            '.... registry$nonsys_inv_objs.');
         END IF;
         DBMS_OUTPUT.PUT_LINE(
          '.... Use utluiobj.sql after the upgrade to identify any new invalid');
          DBMS_OUTPUT.PUT_LINE('.... objects due to the upgrade.');
         -- For upgrades that are not 'inplace' keep it simple.
         IF NOT inplace THEN
            FOR obj IN (SELECT owner, count(*) AS num FROM DBA_OBJECTS
                     WHERE status = 'INVALID' AND 
                           object_name NOT LIKE 'BIN$%' 
                     GROUP BY owner) LOOP
             DBMS_OUTPUT.PUT_LINE(
                '.... USER ' || obj.owner || ' has ' || obj.num || 
                ' INVALID objects.');
            END LOOP;
         ELSE
            -- For inplace upgrades, ignore objects that may be invalid
            -- due to their dependencies on other objects that may have changed
            -- Bug 4905742
            FOR obj IN (SELECT owner, count(*) AS num FROM DBA_OBJECTS
                     WHERE status = 'INVALID' AND 
                           object_name NOT LIKE 'BIN$%' AND 
                           object_name NOT IN 
                              (SELECT name FROM dba_dependencies
                                  START WITH referenced_name IN 
                                    (
                                    'V$SESSION',
                                    'V$DELETED_OBJECT',
                                    'V$MUTEX_SLEEP_HISTORY',
                                    'V$LOGMNR_SESSION',
                                    'V$RECOVERY_FILE_DEST',
                                    'V$FLASH_RECOVERY_AREA_USAGE',
                                    'V$ACTIVE_SESSION_HISTORY',
                                    'V$BUFFERED_SUBSCRIBERS',
                                    'GV$SESSION',
                                    'GV$SQLAREA_PLAN_HASH',
                                    'GV_$SQLAREA_PLAN_HASH',
                                    'GV$DELETED_OBJECT',
                                    'GV$MUTEX_SLEEP_HISTORY',
                                    'GV$LOGMNR_SESSION',
                                    'GV$RECOVERY_FILE_DEST',
                                    'GV$FLASH_RECOVERY_AREA_USAGE',
                                    'GV$ACTIVE_SESSION_HISTORY',
                                    'GV$BUFFERED_SUBSCRIBERS',
                                    'GV$RESTORE_POINT',
                                    'GV$SGA_TARGET_ADVICE',
                                    'DBMS_RCVMAN',
				    'GV$SQL',
                                    'RMJVM',
                                    'DBMS_ALERT',
				    'DBMS_SHARED_POOL',
                                    'MGMT_RESPONSE',
                                    'MGMT_RESPONSE_BASELINE',   
				    'GV$SQLAREA',  
				    'V$SQLAREA', 
                                    'GV$SQLSTATS',
                                    'V$SQLSTATS',
                                    'V$ASM_DISK',
                                    'GV$IOSTAT_FILE',
		            	    'V$PROPAGATION_RECEIVER',
				    'GV$PROPAGATION_RECEIVER',
                                    'V$STREAMS_CAPTURE','GV$STREAMS_CAPTURE',
                                    'V$BUFFERED_QUEUES' ,
                                    'GV$STREAMS_APPLY_COORDINATOR',
				    '_DBA_STREAMS_COMPONENT',
				    '_DBA_STREAMS_COMPONENT_LINK',
				    '_DBA_STREAMS_COMPONENT_EVENT',
                                    'V$PROPAGATION_SENDER',
                                    'GV$PROPAGATION_SENDER',
                                    'V$STREAMS_APPLY_COORDINATOR',
                                    'DBMS_STREAMS_ADV_ADM_UTL',
				    'GV$BUFFERED_QUEUES',
                                    'GV$RSRCMGRMETRIC_HISTORY',
                                    'GV$RSRC_CONSUMER_GROUP',
                                    'GV$RSRCMGRMETRIC',
                                    'GV$RSRC_CONS_GROUP_HISTORY',
                                    'V$RSRC_CONS_GROUP_HISTORY',
                                    'V$RSRCMGRMETRIC_HISTORY',
                                    'V$RSRC_CONSUMER_GROUP',
                                    'V$RSRCMGRMETRIC',
				    'GV$EVENT_HISTOGRAM',
				    'V$EVENT_HISTOGRAM',
			            'DBMS_FEATURE_RMAN_ZLIB', 
                                    'V$BACKUP_DATAFILE',
				    'GV$BACKUP_DATAFILE', 
				    'DBMS_ASH_INTERNAL',
				    'V$SQL',
                                    'GV$IOSTAT_FUNCTION',
                                    'GV_$IOSTAT_FUNCTION'
                            ) and referenced_type in ('VIEW','PACKAGE')
                                  CONNECT BY
                                    PRIOR name = referenced_name and 
                                    PRIOR type = referenced_type)
                     GROUP BY owner) LOOP
             DBMS_OUTPUT.PUT_LINE(
                '.... USER ' || obj.owner || ' has ' || obj.num || 
                ' INVALID objects.');
             END LOOP;

            -- For display of invalid object names during debugging.
            -- When needed for debug, set display_bad_obj to TRUE:
            --   display_bad_obj := TRUE;
            -- Default is FALSE.
            IF display_bad_obj THEN
              FOR obj IN (SELECT owner, object_name FROM DBA_OBJECTS
                       WHERE status = 'INVALID' AND 
                             object_name NOT LIKE 'BIN$%' AND 
                             object_name NOT IN 
                                (SELECT name FROM dba_dependencies
                                    START WITH referenced_name IN 
                                      (
                                      'V$SESSION',
                                      'V$DELETED_OBJECT',
                                      'V$MUTEX_SLEEP_HISTORY',
                                      'V$LOGMNR_SESSION',
                                      'V$RECOVERY_FILE_DEST',
                                      'V$FLASH_RECOVERY_AREA_USAGE',
                                      'V$ACTIVE_SESSION_HISTORY',
                                      'V$BUFFERED_SUBSCRIBERS',
                                      'GV$SESSION',
                                      'GV$SQLAREA_PLAN_HASH',
                                      'GV_$SQLAREA_PLAN_HASH',
                                      'GV$DELETED_OBJECT',
                                      'GV$MUTEX_SLEEP_HISTORY',
                                      'GV$LOGMNR_SESSION',
                                      'GV$RECOVERY_FILE_DEST',
                                      'GV$FLASH_RECOVERY_AREA_USAGE',
                                      'GV$ACTIVE_SESSION_HISTORY',
                                      'GV$BUFFERED_SUBSCRIBERS',
                                      'GV$RESTORE_POINT',
                                      'GV$SGA_TARGET_ADVICE',
                                      'DBMS_RCVMAN',
  				    'GV$SQL',
                                      'RMJVM',
                                      'DBMS_ALERT',
  				    'DBMS_SHARED_POOL',
                                      'MGMT_RESPONSE',
                                      'MGMT_RESPONSE_BASELINE',   
  				    'GV$SQLAREA',  
  				    'V$SQLAREA', 
                                      'GV$SQLSTATS',
                                      'V$SQLSTATS',
                                      'V$ASM_DISK',
                                      'GV$IOSTAT_FILE',
  		            	    'V$PROPAGATION_RECEIVER',
  				    'GV$PROPAGATION_RECEIVER',
                                      'V$STREAMS_CAPTURE','GV$STREAMS_CAPTURE',
                                      'V$BUFFERED_QUEUES' ,
                                      'GV$STREAMS_APPLY_COORDINATOR',
  				    '_DBA_STREAMS_COMPONENT',
  				    '_DBA_STREAMS_COMPONENT_LINK',
  				    '_DBA_STREAMS_COMPONENT_EVENT',
                                      'V$PROPAGATION_SENDER',
                                      'GV$PROPAGATION_SENDER',
                                      'V$STREAMS_APPLY_COORDINATOR',
                                      'DBMS_STREAMS_ADV_ADM_UTL',
  				    'GV$BUFFERED_QUEUES',
                                      'GV$RSRCMGRMETRIC_HISTORY',
                                      'GV$RSRC_CONSUMER_GROUP',
                                      'GV$RSRCMGRMETRIC',
                                      'GV$RSRC_CONS_GROUP_HISTORY',
                                      'V$RSRC_CONS_GROUP_HISTORY',
                                      'V$RSRCMGRMETRIC_HISTORY',
                                      'V$RSRC_CONSUMER_GROUP',
                                      'V$RSRCMGRMETRIC',
  				    'GV$EVENT_HISTOGRAM',
  				    'V$EVENT_HISTOGRAM',
  			            'DBMS_FEATURE_RMAN_ZLIB', 
                                      'V$BACKUP_DATAFILE',
  				    'GV$BACKUP_DATAFILE', 
  				    'DBMS_ASH_INTERNAL',
  				    'V$SQL',
                                      'GV$IOSTAT_FUNCTION',
                                      'GV_$IOSTAT_FUNCTION'
                              ) and referenced_type in ('VIEW','PACKAGE')
                                    CONNECT BY
                                      PRIOR name = referenced_name and 
                                      PRIOR type = referenced_type)
                       ) LOOP
               DBMS_OUTPUT.PUT_LINE(
                  '.... USER ' || obj.owner || ' has ' || obj.object_name || 
                  ' INVALID object.');
               END LOOP;
           END IF; -- END of 'IF display_bad_obj THEN'.
                   -- To be turned on during debug to display invalid obj names.

         END IF;
      END IF;

      IF ssl_users THEN
         DBMS_OUTPUT.PUT_LINE(
         'WARNING: --> Database contains globally authenticated users.');
         DBMS_OUTPUT.PUT_LINE(
           '.... Refer to the 11g Upgrade Guide to upgrade SSL users.');
      END IF;
 
      IF em_exists  THEN
         DBMS_OUTPUT.PUT_LINE(
           'WARNING: --> EM Database Control Repository exists in the database.');
         DBMS_OUTPUT.PUT_LINE(
           '.... Direct downgrade of EM Database Control is not supported. Refer to the');
         DBMS_OUTPUT.PUT_LINE(
           '.... 11g Upgrade Guide for instructions to save the EM data prior to upgrade.');
      END IF;

      IF snapshot_refresh THEN -- TRUE when outstanding snapshot refreshes
         DBMS_OUTPUT.PUT_LINE('WARNING: --> There are materialized view refreshes in progress.');
         DBMS_OUTPUT.PUT_LINE('.... Ensure all materialized view refreshes are complete prior to upgrade.');
      END IF;

      IF recovery_files THEN -- TRUE when files need media recovery
         DBMS_OUTPUT.PUT_LINE('WARNING: --> There are files which need media recovery.');
         DBMS_OUTPUT.PUT_LINE('.... Ensure no files need media recovery prior to upgrade.');
      END IF;

      IF files_backup_mode THEN -- TRUE when files are in backup mode
         DBMS_OUTPUT.PUT_LINE('WARNING: --> There are files in backup mode.');
         DBMS_OUTPUT.PUT_LINE('.... Ensure no files are in backup mode prior to upgrade.');
      END IF;

      IF pending_2pc_txn THEN  -- TRUE when pending distribution txns
         DBMS_OUTPUT.PUT_LINE('WARNING:--> There are outstanding unresolved distributed transactions.');
         DBMS_OUTPUT.PUT_LINE('.... Resolve outstanding distributed transactions prior to upgrade.');
      END IF;

      IF sync_standby_db THEN  -- TRUE when need to sync the standby db
          DBMS_OUTPUT.PUT_LINE('<warning name="SYNC_STANDBY_DB"/>');
         DBMS_OUTPUT.PUT_LINE('WARNING:--> Sync standby database prior to upgrade.');
      END IF;

      DBMS_OUTPUT.PUT_LINE('.');
   END IF;

END display_misc_warnings;

--------------------------- pvalue_to_number --------------------------------
-- This function converts a parameter string to a number. The function takes
-- into account that the parameter string may have a 'K' or 'M' multiplier
-- character.
FUNCTION pvalue_to_number (value_string VARCHAR2) RETURN NUMBER
IS
  ilen NUMBER;
  pvalue_number NUMBER;

BEGIN
    -- How long is the input string?
    ilen := LENGTH ( value_string );

    -- Is there a 'K' or 'M' in last position?
    IF SUBSTR(UPPER(value_string), ilen, 1) = 'K' THEN
         RETURN (1024 * TO_NUMBER (SUBSTR (value_string, 1, ilen-1)));

    ELSIF SUBSTR(UPPER(value_string), ilen, 1) = 'M' THEN
         RETURN (1024 * 1024 * TO_NUMBER (SUBSTR (value_string, 1, ilen-1)));
    END IF;

    -- A multiplier wasn't found. Simply convert this string to a number.
    RETURN (TO_NUMBER (value_string));

 END pvalue_to_number;

-- *****************************************************************
-- --------------------- MAIN PROGRAM ------------------------------
-- *****************************************************************
 
BEGIN

    -- Increase SERVEROUTPUT limit.
    DBMS_OUTPUT.ENABLE(900000);

    -- Check for SYSDBA
    SELECT USER INTO p_user
       FROM DUAL;
    IF p_user != 'SYS' THEN
        RAISE_APPLICATION_ERROR (-20000,
           'This script must be run AS SYSDBA');
    END IF;

    -- Turn on diagnostic collection
    BEGIN
        SELECT NULL INTO p_null FROM obj$
        WHERE owner#=0 AND type#=2 AND name='PUIU$DATA';
        collect_diag := TRUE;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;
 
-- *****************************************************************
-- Collect Database Information
-- *****************************************************************

   SELECT name    INTO db_name    from v$database;
   SELECT version INTO db_version from v$instance;
   SELECT value   INTO db_compat  from v$parameter
          WHERE name = 'compatible';
   SELECT value   INTO db_block_size FROM v$parameter
          WHERE name = 'db_block_size';
   SELECT value   INTO db_undo FROM v$parameter
          WHERE name = 'undo_management';
   SELECT value   INTO db_undo_tbs FROM v$parameter
          WHERE name = 'undo_tablespace';
   SELECT value into db_vlm from v$parameter 
          WHERE name = 'use_indirect_data_buffers';

   -- get platform information 
   BEGIN
      EXECUTE IMMEDIATE 'SELECT platform_id, platform_name
             FROM v$database'
      INTO db_platform_id, db_platform_name;
      IF db_platform_id NOT IN (1,7,10,15,16,17) THEN
         db_64 := TRUE; -- NOT 32 (solaris, windows, linux, vms, mac, sol x86)
      END IF;
   EXCEPTION                  -- check banner for 9.2
      WHEN OTHERS THEN 
         BEGIN
            SELECT NULL INTO p_null FROM v$version 
            WHERE INSTR(banner,'64') > 0 AND
                  INSTR(UPPER(banner),'ORACLE') > 0 AND
                  ROWNUM = 1;
            db_64 := TRUE;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN NULL;  -- no 64 bit banner
         END;
   END;

   -- determine if memory_target value is set
   BEGIN
      SELECT NULL INTO p_null FROM v$parameter WHERE name='memory_target';
         memory_target := TRUE;
   EXCEPTION               
     WHEN NO_DATA_FOUND THEN NULL;  -- memory_target value not set
   END;

   -- get time zone region version used by server
   BEGIN
      EXECUTE IMMEDIATE 'SELECT version from v$timezone_file'
      INTO db_tz_version;
   EXCEPTION
      -- no time zone version view in 9.2 (no v$timezone_file)
      -- determine time zone version based on UTLTZVER.SQL
      WHEN OTHERS THEN
       -- Initialize db_tz_version to '' (not 0) as we don't want a record with
       -- a numerical value for tz_version to be inserted into
       -- registry$database if db_tz_version is not found.  This tz_version
       -- value and count(*) of registry$database being non-zero are critical
       -- to the time zone check in catupstr.sql.
       -- NOTE: If db_tz_version for 92 is not found, we don't want catupstr.sql
       -- to error out in the time zone check.
       db_tz_version := '';

       -- checking if V7 (or higher) is used in 9i
       EXECUTE IMMEDIATE 
         'SELECT CASE
            TO_NUMBER(TO_CHAR(
              TO_TIMESTAMP_TZ(''20080405 23:00:00 Australia/Victoria'',
                              ''YYYYMMDD HH24:MI:SS TZR'') +
              to_dsinterval(''0 08:00:00''),''HH24''))
          WHEN 7 THEN 6
          WHEN 6 THEN 7 END
          FROM SYS.DUAL'
       INTO db_tz_version;

       -- checking if V6 is used in 9i
       IF db_tz_version = 6
       THEN 
         EXECUTE IMMEDIATE
           'SELECT CASE
              TO_NUMBER(TO_CHAR(
                TO_TIMESTAMP_TZ(''20070929 23:00:00 NZ'',
                                ''YYYYMMDD HH24:MI:SS TZR'') +
                to_dsinterval(''0 08:00:00''),''HH24''))
           WHEN 7 THEN 5
           WHEN 8 THEN 6 END
           FROM SYS.DUAL'
         INTO db_tz_version;
       END IF;

       -- checking if V5 is used in 9i
       IF db_tz_version = 5
       THEN 
         EXECUTE IMMEDIATE
           'SELECT CASE
              TO_NUMBER(TO_CHAR(
                TO_TIMESTAMP_TZ(''20070310 23:00:00 CUBA'',
                                ''YYYYMMDD HH24:MI:SS TZR'') +
                to_dsinterval(''0 08:00:00''),''HH24''))
           WHEN 7 THEN 4
           WHEN 8 THEN 5 END
           FROM SYS.DUAL'
         INTO db_tz_version;
       END IF;
 
       -- checking if V4 or lower is used in 9i
       IF db_tz_version = 4
       THEN
          EXECUTE IMMEDIATE 'SELECT COUNT(DISTINCT(tzname)), COUNT(tzname)
                     FROM v$timezone_names'
                     INTO tznames_dist, tznames_count;
          db_tz_version := 

          CASE 
            WHEN tznames_dist in (183, 355, 347)               THEN 1
            WHEN tznames_dist = 377                            THEN 2
            WHEN (tznames_dist = 186 and tznames_count = 636)  THEN 2
            WHEN (tznames_dist = 186 and tznames_count = 626)  THEN 3
            WHEN tznames_dist in (185, 386)                    THEN 3
            WHEN (tznames_dist = 387 and tznames_count = 1438) THEN 3
            WHEN (tznames_dist = 391 and tznames_count = 1457) THEN 4
            WHEN (tznames_dist = 188 and tznames_count = 637)  THEN 4
          END;
       END IF;

       -- checking if V8 is used or DSTv14 small file
       -- no DST rules changed, only tz's added
       IF db_tz_version = 7
       THEN
         EXECUTE IMMEDIATE 'SELECT COUNT(DISTINCT(tzname)), COUNT(tzname)
                             FROM v$timezone_names' 
                             INTO tznames_dist, tznames_count;         
         db_tz_version :=
         CASE
           WHEN (tznames_dist = 519 and tznames_count = 1858) THEN 7
           WHEN (tznames_dist = 188 and tznames_count =  637) THEN 7
           WHEN (tznames_dist = 199 and tznames_count =  755) THEN 14 
           WHEN (tznames_dist = 197 and tznames_count =  676) THEN '' -- UNKNOWN
           WHEN (tznames_dist > 519 and tznames_count > 1858) THEN 8
         END;
       END IF;
       -- checking if V9 is used
       IF db_tz_version = 8
       THEN
         EXECUTE IMMEDIATE
           'SELECT CASE
              TO_NUMBER(TO_CHAR(
                TO_TIMESTAMP_TZ(''20080531 23:00:00 Africa/Casablanca'',
                                ''YYYYMMDD HH24:MI:SS TZR'') +
                to_dsinterval(''0 08:00:00''),''HH24''))
            WHEN 8 THEN 9
            WHEN 7 THEN 7 END
            FROM SYS.DUAL'
            INTO db_tz_version;
       END IF;

       -- checking if V10, V11, V13, or V14 is used
       -- no need to check for DSTv12
       -- no DST rules changed
       IF db_tz_version = 9
       THEN
         EXECUTE IMMEDIATE 'SELECT COUNT(DISTINCT(tzname)), COUNT(tzname)
                            FROM v$timezone_names' 
                            INTO tznames_dist, tznames_count;
         db_tz_version :=
         CASE
             WHEN (tznames_dist = 548 and tznames_count = 1987) THEN 9
             WHEN (tznames_dist = 549 and tznames_count = 1992) THEN 10
             WHEN (tznames_dist = 551 and tznames_count = 2137) THEN 11
             WHEN (tznames_dist = 551 and tznames_count = 2141) THEN 13
             WHEN (tznames_dist = 556 and tznames_count = 2164) THEN 14
             -- the following 2 cases indicate Unknown db_tz_version
             WHEN (tznames_dist > 556 ) THEN ''
             WHEN (tznames_dist = 556 and tznames_count > 2164) THEN ''
         END;
       END IF;
   END; -- END OF get time zone region version used by server


   -- Update registry$database with tz version (create it if necessary)
   BEGIN
      EXECUTE IMMEDIATE 
         'UPDATE registry$database set tz_version = :1'
      USING db_tz_version;
   EXCEPTION WHEN OTHERS THEN 
      IF sqlcode = -904 THEN  -- registry$database exists but no tz_version
         EXECUTE IMMEDIATE
            'ALTER TABLE registry$database ADD (tz_version NUMBER)';
         EXECUTE IMMEDIATE
            'UPDATE registry$database set tz_version = :1'
         USING db_tz_version;
      END IF;
      IF sqlcode = -942 THEN -- no registry$database table so create it
         EXECUTE IMMEDIATE 
           'CREATE TABLE registry$database( 
             platform_id   NUMBER,       
             platform_name VARCHAR2(101),
             edition       VARCHAR2(30), 
             tz_version    NUMBER        
             )';

         IF substr(db_version,1,3) != '9.2' THEN -- no v$ views for 9.2
            EXECUTE IMMEDIATE
               'INSERT into registry$database 
                     (platform_id, platform_name, edition, tz_version) 
                VALUES ((select platform_id from v$database),
                        (select platform_name from v$database),
                         NULL,
                        (select version from v$timezone_file))';
         ELSE
            EXECUTE IMMEDIATE
              'INSERT into registry$database 
                 (platform_id, platform_name, edition, tz_version)
               VALUES (NULL, NULL, NULL, :1)'
            USING db_tz_version;
         END IF;
     END IF;
     COMMIT;
   END;
   IF display_xml THEN   -- check for DBUA override
      BEGIN
         SELECT null INTO p_null FROM obj$ 
         WHERE owner#=0 AND
               type#=2 AND
               name='PUIU$SETTZ';
         EXECUTE IMMEDIATE 
            'UPDATE registry$database set tz_version = :1'
         USING utlu_tz_version;
         db_tz_version := utlu_tz_version;
      EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
      END;
   END IF;

  -- Check for XE database 
   BEGIN
      EXECUTE IMMEDIATE
         'SELECT edition FROM registry$ WHERE cid=''CATPROC'''
         INTO p_edition;
      IF p_edition = 'XE' THEN 
         xe_upgrade := TRUE;
      END IF; -- XE edition
   EXCEPTION
      WHEN OTHERS THEN NULL;  -- no edition column
   END;      

   IF db_undo != 'AUTO' OR db_undo_tbs IS NULL THEN
      db_undo_tbs := 'NO UNDO TBS';  -- undo tbs is not in use
   END IF;

   vers  := SUBSTR(db_version,1,6);   -- get 3 digit version
   patch := SUBSTR(db_version,1,8);   -- get 4 digit version

   IF vers = '11.1.0' AND 
      patch = utlu_version THEN -- rerun or inplace
      BEGIN -- rerun or inplace upgrade since instance is current version
         EXECUTE IMMEDIATE 'SELECT version, prv_version FROM registry$ 
                            WHERE cid = ''CATPROC'''
                 INTO db_dict_version, db_prev_version;
         IF db_dict_version = db_version THEN  -- catproc upgraded, rerun 
            rerun := TRUE;
            vers := substr(db_prev_version,1,6);   -- use prev catproc version 
         ELSE -- 11g patch upgrade inplace
            inplace := TRUE;
            vers := substr(db_dict_version,1,6);   -- use CATPROC version 
            db_version := db_dict_version;
         END IF;
         
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            rerun := TRUE;  -- registry$ exists, but no CATPROC entry
      END;
   END IF;

   IF rerun THEN
      IF display_xml THEN
         DBMS_OUTPUT.PUT_LINE('<RDBMSUP version="' || utlu_version || '">');
         DBMS_OUTPUT.PUT_LINE(
             '<SupportedOracleVersions value="9.2.0, 10.1.0, 10.2.0, 11.1.0"/>');
         display_database;
         DBMS_OUTPUT.PUT_LINE(
            '<OracleVersion rerun="TRUE"/>');
         DBMS_OUTPUT.PUT_LINE('<Components>');
         IF vers IS NOT NULL THEN  -- If null, then is a newly created DB
            DBMS_OUTPUT.PUT_LINE(
               '<Component id ="Oracle Server" type="SERVER" cid="RDBMS">');
            DBMS_OUTPUT.PUT_LINE(
             '<CEP value="{ORACLE_HOME}/rdbms/admin/rdbmsup.sql"/>');
            DBMS_OUTPUT.PUT_LINE(
             '<SupportedOracleVersions value="9.2.0, 10.1.0, 10.2.0, 11.1,0"/>');
            DBMS_OUTPUT.PUT_LINE(
              '<OracleVersion value ="'|| db_version || '"/>');
            DBMS_OUTPUT.PUT_LINE('</Component>');
         END IF;
         DBMS_OUTPUT.PUT_LINE('</Components>');
         DBMS_OUTPUT.PUT_LINE('</RDBMSUP>');
      ELSE
         display_header;
         display_database;
         DBMS_OUTPUT.PUT_LINE('Database already upgraded; to rerun upgrade ' ||
             'use rdbms/admin/catupgrd.sql.');
      END IF;
      RETURN;
   END IF;

   IF vers = '9.2.0.' THEN 
      dbv := 920;
   ELSIF vers = '10.1.0' THEN 
      dbv := 101;
   ELSIF vers = '10.2.0' THEN 
      dbv := 102;
   ELSIF vers = '11.1.0' THEN
      dbv := 111;
   ELSE
        RAISE_APPLICATION_ERROR (-20000,
           'Version ' || db_version || 
           ' not supported for upgrade to release 11.1.0');
   END IF;


-- *****************************************************************
-- START of Constant Data
-- *****************************************************************

-- *****************************************************************
-- Constant Initialization Parameter Data
-- *****************************************************************
/*
   To identify new obsolete and deprecated parameters, use the 
   following queries and diff with the list from the prior release:

   select name from v$obsolete_parameter order by name;

   select name from v$parameter 
   where isdeprecated = 'TRUE' order by name; 
   
*/

-- Load Obsolete and Deprecated parameters

   -- Obsolete initialization parameters in release 8.0 --
   idx:=0;
   store_removed(idx,'checkpoint_process');
   store_removed(idx,'fast_cache_flush');
   store_removed(idx,'gc_db_locks');
   store_removed(idx,'gc_freelist_groups');
   store_removed(idx,'gc_rollback_segments');
   store_removed(idx,'gc_save_rollback_locks');
   store_removed(idx,'gc_segments');
   store_removed(idx,'gc_tablespaces');
   store_removed(idx,'io_timeout');
   store_removed(idx,'init_sql_files');
   store_removed(idx,'ipq_address');
   store_removed(idx,'ipq_net');
   store_removed(idx,'lm_domains');
   store_removed(idx,'lm_non_fault_tolerant');
   store_removed(idx,'mls_label_format');
   store_removed(idx,'optimizer_parallel_pass');
   store_removed(idx,'parallel_default_max_scans');
   store_removed(idx,'parallel_default_scan_size');
   store_removed(idx,'post_wait_device');
   store_removed(idx,'sequence_cache_hash_buckets');
   store_removed(idx,'unlimited_rollback_segments');
   store_removed(idx,'use_readv');
   store_removed(idx,'use_sigio');
   store_removed(idx,'v733_plans_enabled');

   -- Obsolete in 8.1
   store_removed(idx,'allow_partial_sn_results');
   store_removed(idx,'arch_io_slaves');
   store_removed(idx,'b_tree_bitmap_plans');
   store_removed(idx,'backup_disk_io_slaves');
   store_removed(idx,'cache_size_threshold');
   store_removed(idx,'cleanup_rollback_entries');
   store_removed(idx,'close_cached_open_cursors');
   store_removed(idx,'complex_view_merging');
   store_removed(idx,'db_block_checkpoint_batch');
   store_removed(idx,'db_block_lru_extended_statistics');
   store_removed(idx,'db_block_lru_statistics');
   store_removed(idx,'db_file_simultaneous_writes');
   store_removed(idx,'delayed_logging_block_cleanouts');
   store_removed(idx,'discrete_transactions_enabled');
   store_removed(idx,'distributed_recovery_connection_hold_time');
   store_removed(idx,'ent_domain_name');
   store_removed(idx,'fast_full_scan_enabled');
   store_removed(idx,'freeze_DB_for_fast_instance_recovery');
   store_removed(idx,'gc_latches');
   store_removed(idx,'gc_lck_procs');
   store_removed(idx,'job_queue_keep_connections');
   store_removed(idx,'large_pool_min_alloc');
   store_removed(idx,'lgwr_io_slaves');
   store_removed(idx,'lm_locks');
   store_removed(idx,'lm_procs');
   store_removed(idx,'lm_ress');
   store_removed(idx,'lock_sga_areas');
   store_removed(idx,'log_archive_buffer_size');
   store_removed(idx,'log_archive_buffers');
   store_removed(idx,'log_block_checksum');
   store_removed(idx,'log_files');
   store_removed(idx,'log_simultaneous_copies');
   store_removed(idx,'log_small_entry_max_size');
   store_removed(idx,'mts_rate_log_size');
   store_removed(idx,'mts_rate_scale');
   store_removed(idx,'ogms_home');
   store_removed(idx,'ops_admin_group');
   store_removed(idx,'optimizer_search_limit');
   store_removed(idx,'parallel_default_max_instances');
   store_removed(idx,'parallel_min_message_pool');
   store_removed(idx,'parallel_server_idle_time');
   store_removed(idx,'parallel_transaction_resource_timeout');
   store_removed(idx,'push_join_predicate');
   store_removed(idx,'reduce_alarm');
   store_removed(idx,'row_cache_cursors');
   store_removed(idx,'sequence_cache_entries');
   store_removed(idx,'sequence_cache_hash_buckets');
   store_removed(idx,'shared_pool_reserved_min_alloc');
   store_removed(idx,'snapshot_refresh_interval');
   store_removed(idx,'snapshot_refresh_keep_connections');
   store_removed(idx,'snapshot_refresh_processes');
   store_removed(idx,'sort_direct_writes');
   store_removed(idx,'sort_read_fac');
   store_removed(idx,'sort_spacemap_size');
   store_removed(idx,'sort_write_buffer_size');
   store_removed(idx,'sort_write_buffers');
   store_removed(idx,'spin_count');
   store_removed(idx,'temporary_table_locks');
   store_removed(idx,'use_ism');

   -- Obsolete in 9.0.1
   store_removed(idx,'always_anti_join');
   store_removed(idx,'always_semi_join');
   store_removed(idx,'db_block_lru_latches');
   store_removed(idx,'db_block_max_dirty_target');
   store_removed(idx,'gc_defer_time');
   store_removed(idx,'gc_releasable_locks');
   store_removed(idx,'gc_rollback_locks');
   store_removed(idx,'hash_multiblock_io_count');
   store_removed(idx,'instance_nodeset');
   store_removed(idx,'job_queue_interval');
   store_removed(idx,'ops_interconnects');
   store_removed(idx,'optimizer_percent_parallel');
   store_removed(idx,'sort_multiblock_read_count');
   store_removed(idx,'text_enable');

   -- Obsolete in 9.2
   store_removed(idx,'distributed_transactions');
   store_removed(idx,'max_transaction_branches');
   store_removed(idx,'parallel_broadcast_enabled');
   store_removed(idx,'standby_preserves_names');

   -- Obsolete in 10.1 (mts_ renames commented out)
   store_removed(idx,'dblink_encrypt_login');
   store_removed(idx,'hash_join_enabled');
   store_removed(idx,'log_parallelism');
   store_removed(idx,'max_rollback_segments');
--   store_removed(idx,'mts_circuits');
--   store_removed(idx,'mts_dispatchers');
   store_removed(idx,'mts_listener_address');
--   store_removed(idx,'mts_max_dispatchers');
--   store_removed(idx,'mts_max_servers');
   store_removed(idx,'mts_multiple_listeners');
--   store_removed(idx,'mts_servers');
   store_removed(idx,'mts_service');
--   store_removed(idx,'mts_sessions');
   store_removed(idx,'optimizer_max_permutations');
   store_removed(idx,'oracle_trace_collection_name');
   store_removed(idx,'oracle_trace_collection_path');
   store_removed(idx,'oracle_trace_collection_size');
   store_removed(idx,'oracle_trace_enable');
   store_removed(idx,'oracle_trace_facility_name');
   store_removed(idx,'oracle_trace_facility_path');
   store_removed(idx,'partition_view_enabled');
   store_removed(idx,'plsql_native_c_compiler');
   store_removed(idx,'plsql_native_linker');
   store_removed(idx,'plsql_native_make_file_name');
   store_removed(idx,'plsql_native_make_utility');
   store_removed(idx,'row_locking');
   store_removed(idx,'serializable');
   store_removed(idx,'transaction_auditing');
   store_removed(idx,'undo_suppress_errors');

   -- Deprecated in 10.1, no new value
   store_removed(idx,'global_context_pool_size');
   store_removed(idx,'log_archive_start');
   store_removed(idx,'max_enabled_roles');
   store_removed(idx,'parallel_automatic_tuning');

   store_removed(idx,'_average_dirties_half_life');
   store_removed(idx,'_compatible_no_recovery');
   store_removed(idx,'_db_no_mount_lock');
   store_removed(idx,'_lm_direct_sends');
   store_removed(idx,'_lm_multiple_receivers');
   store_removed(idx,'_lm_statistics');
   store_removed(idx,'_oracle_trace_events');
   store_removed(idx,'_oracle_trace_facility_version');
   store_removed(idx,'_seq_process_cache_const');

   -- Obsolete in 10.2  
   store_removed(idx,'enqueue_resources');

   -- Deprecated, but not renamed in 10.2
   store_removed(idx,'logmnr_max_persistent_sessions');
   store_removed(idx,'max_commit_propagation_delay');
   store_removed(idx,'remote_archive_enable');
   store_removed(idx,'serial_reuse');
   store_removed(idx,'sql_trace');

   -- Deprecated, but not renamed in 11.1
   store_removed(idx,'commit_write');
   store_removed(idx,'instance_groups');
   store_removed(idx,'log_archive_local_first');
   store_removed(idx,'remote_os_authent');
   store_removed(idx,'sql_version');
   store_removed(idx,'standby_archive_dest');
   store_removed(idx,'plsql_v2_compatibility');

   -- Instead a new parameter diagnostic_dest will replace all 3
   store_removed(idx,'background_dump_dest');
   store_removed(idx,'user_dump_dest');
   store_removed(idx,'core_dump_dest');

   store_removed(idx,'cpu_count');  -- should not be set in initialization
   -- Obsolete in 11.1  
   store_removed(idx,'_log_archive_buffer_size');
   store_removed(idx,'_fast_start_instance_recover_target');
   store_removed(idx,'_lm_rcv_buffer_size');
   store_removed(idx,'ddl_wait_for_locks');
   store_removed(idx,'remote_archive_enable');

   -- Sessions removed for XE upgrade only
   IF xe_upgrade THEN
      store_removed(idx,'sessions');   
   END IF;
   max_op := idx; 

-- Load Renamed parameters

   -- Initialization Parameters Renamed in Release 8.0 --
   idx:=0;
   store_renamed(idx,'async_read','disk_asynch_io');
   store_renamed(idx,'async_write','disk_asynch_io');
   store_renamed(idx,'ccf_io_size','db_file_direct_io_count');
   store_renamed(idx,'db_file_standby_name_convert','db_file_name_convert');
   store_renamed(idx,'db_writers','dbwr_io_slaves');
   store_renamed(idx,'log_file_standby_name_convert',
                     'log_file_name_convert');
   store_renamed(idx,'snapshot_refresh_interval','job_queue_interval');

   -- Initialization Parameters Renamed in Release 8.1.4 --
   store_renamed(idx,'mview_rewrite_enabled','query_rewrite_enabled');
   store_renamed(idx,'rewrite_integrity','query_rewrite_integrity');

   -- Initialization Parameters Renamed in Release 8.1.5 --
   store_renamed(idx,'nls_union_currency','nls_dual_currency');
   store_renamed(idx,'parallel_transaction_recovery',
                     'fast_start_parallel_rollback');

   -- Initialization Parameters Renamed in Release 9.0.1 --
   store_renamed(idx,'fast_start_io_target','fast_start_mttr_target');
   store_renamed(idx,'mts_circuits','circuits');
   store_renamed(idx,'mts_dispatchers','dispatchers');
   store_renamed(idx,'mts_max_dispatchers','max_dispatchers');
   store_renamed(idx,'mts_max_servers','max_shared_servers');
   store_renamed(idx,'mts_servers','shared_servers');
   store_renamed(idx,'mts_sessions','shared_server_sessions');
   store_renamed(idx,'parallel_server','cluster_database');
   store_renamed(idx,'parallel_server_instances',
                     'cluster_database_instances');

   -- Initialization Parameters Renamed in Release 9.2 --
   store_renamed(idx,'drs_start','dg_broker_start');

   -- Initialization Parameters Renamed in Release 10.1 --
   store_renamed(idx,'lock_name_space','db_unique_name');

   -- Initialization Parameters Renamed in Release 10.2 --
   -- none as of 4/1/05

   max_rp := idx; 

-- Initialize special initialization parameters

   idx := 0;
   store_special(idx,'rdbms_server_dn',NULL,'ldap_directory_access','SSL');
   store_special(idx,'plsql_compiler_flags','INTERPRETED',
                     'plsql_code_type','INTERPRETED');
   store_special(idx,'plsql_compiler_flags','NATIVE',
                     'plsql_code_type','NATIVE');
   store_special(idx,'plsql_debug','TRUE','plsql_optimize_level','1');
   store_special(idx,'plsql_compiler_flags','DEBUG',
                     'plsql_optimize_level','1');

   --  Only use these special parameters for databases 
   --  in which Very Large Memory is not enabled
   IF db_vlm = 'FALSE' THEN
      store_special(idx,'db_block_buffers',NULL,
                        'db_cache_size',NULL); 
      store_special(idx,'buffer_pool_recycle',NULL,
                        'db_recycle_cache_size',NULL); 
      store_special(idx,'buffer_pool_keep',NULL,
                        'db_keep_cache_size',NULL);  
   END IF;
   max_sp := idx;   

-- Initialization parameter with required values if missing
   reqp(1).name:= 'db_block_size';
   reqp(1).newnumbervalue := 2048;
   reqp(1).type := 3;

-- If undo_management is not specified, then it needs to be specified
-- "manual" since the default is changing to "auto".
   reqp(2).name:= 'undo_management';
   reqp(2).newstringvalue := 'MANUAL';
   reqp(2).type := 2;

   max_reqp :=2;

-- Initialize parameters with minimum values

   idx := 0;

   IF db_64 THEN  -- use larger pool sizes for 64-bit systems
      IF memory_target THEN
         store_minvalue(idx,'memory_target',   836*1024*1024); --  836 MB 
      END IF;
      mt_idx := idx;
      store_minvalue(idx,'sga_target',      672*1024*1024); --  672 MB 
      tg_idx := idx;
      store_minvalue(idx,'shared_pool_size',448*1024*1024); -- 448 MB
      sp_idx := idx;  
      store_minvalue(idx,'java_pool_size',  128*1024*1024); -- 128 MB
      jv_idx := idx;
   ELSE  -- 32 bit values
      IF memory_target THEN
         store_minvalue(idx,'memory_target',   436*1024*1024); --  436 MB 
      END IF;
      mt_idx := idx;
      store_minvalue(idx,'sga_target',      336*1024*1024); --  336 MB 
      tg_idx := idx;
      store_minvalue(idx,'shared_pool_size',224*1024*1024); -- 224 MB
      sp_idx := idx;  
      store_minvalue(idx,'java_pool_size',   64*1024*1024); -- 64 MB
      jv_idx := idx;
    END IF;

   store_minvalue(idx,'db_cache_size',    48*1024*1024); --  48 MB
   cs_idx := idx;
   store_minvalue(idx,'pga_aggregate_target', 24*1024*1024); --  24 MB
   pg_idx := idx;

   -- For XML output only for DBUA with EM config
   -- Minimum number of processes should be 150
   IF display_xml THEN
      store_minvalue(idx,'processes', 150);   
   END IF;
   max_mp := idx;

-- *****************************************************************
-- Store Constant Component Data
-- *****************************************************************

-- Clear all variable component data
   FOR i IN 1..max_comps LOOP
       cmp_info(i).sys_kbytes:=     0;
       cmp_info(i).sysaux_kbytes:=  0;
       cmp_info(i).def_ts_kbytes:=  0;
       cmp_info(i).ins_sys_kbytes:= 0;
       cmp_info(i).ins_def_kbytes:= 0;
       cmp_info(i).def_ts     := NULL;
       cmp_info(i).processed  := FALSE;
       cmp_info(i).install    := FALSE;
   END LOOP;

-- Load component id and name
   cmp_info(catalog).cid := 'CATALOG';
   cmp_info(catalog).cname := 'Oracle Catalog Views';
   cmp_info(catproc).cid := 'CATPROC';
   cmp_info(catproc).cname := 'Oracle Packages and Types';
   cmp_info(javavm).cid := 'JAVAVM';
   cmp_info(javavm).cname := 'JServer JAVA Virtual Machine';
   cmp_info(xml).cid := 'XML';
   cmp_info(xml).cname := 'Oracle XDK for Java';
   cmp_info(catjava).cid := 'CATJAVA';
   cmp_info(catjava).cname := 'Oracle Java Packages';
   cmp_info(xdb).cid := 'XDB';
   cmp_info(xdb).cname := 'Oracle XML Database';
   cmp_info(rac).cid := 'RAC';
   cmp_info(rac).cname := 'Real Application Clusters';
   cmp_info(owm).cid := 'OWM';
   cmp_info(owm).cname := 'Oracle Workspace Manager';
   cmp_info(odm).cid := 'ODM';
   cmp_info(odm).cname := 'Data Mining';
   cmp_info(mgw).cid := 'MGW';
   cmp_info(mgw).cname := 'Messaging Gateway';
   cmp_info(aps).cid := 'APS';
   cmp_info(aps).cname := 'OLAP Analytic Workspace';
   cmp_info(amd).cid := 'AMD';
   cmp_info(amd).cname := 'OLAP Catalog';
   cmp_info(xoq).cid := 'XOQ';
   cmp_info(xoq).cname := 'Oracle OLAP API';
   cmp_info(ordim).cid := 'ORDIM';
   cmp_info(ordim).cname := 'Oracle interMedia';
   cmp_info(sdo).cid := 'SDO';
   cmp_info(sdo).cname := 'Spatial';
   cmp_info(context).cid := 'CONTEXT';
   cmp_info(context).cname := 'Oracle Text';
   cmp_info(wk).cid := 'WK';
   cmp_info(wk).cname := 'Oracle Ultra Search';
   cmp_info(ols).cid := 'OLS';
   cmp_info(ols).cname := 'Oracle Label Security';
   cmp_info(exf).cid := 'EXF';
   cmp_info(exf).cname := 'Expression Filter';
   cmp_info(em).cid := 'EM';
   cmp_info(em).cname := 'EM Repository';
   cmp_info(rul).cid := 'RUL';
   cmp_info(rul).cname := 'Rule Manager';
   cmp_info(apex).cid := 'APEX';
   cmp_info(apex).cname := 'Oracle Application Express';
   cmp_info(dv).cid := 'DV';
   cmp_info(dv).cname := 'Oracle Database Vault'; 
   cmp_info(stats).cid := 'STATS';
   cmp_info(stats).cname := 'Gather Statistics';
   
-- Initialize script names
 IF dbv = 111 THEN
   cmp_info(catalog).script := '?/rdbms/admin/catalog.sql';
   cmp_info(catproc).script := '?/rdbms/admin/catproc.sql';
   cmp_info(javavm).script  := '?/javavm/install/jvmpatch.sql'; 
   cmp_info(xml).script     := '?/xdk/admin/xmlpatch.sql';
   cmp_info(xdb).script     := '?/rdbms/admin/xdbpatch.sql';
   cmp_info(rac).script     := '?/rdbms/admin/catclust.sql';
   cmp_info(ols).script     := '?/rdbms/admin/olspatch.sql';
   cmp_info(exf).script     := '?/rdbms/admin/exfpatch.sql';
   cmp_info(rul).script     := '?/rdbms/admin/rulpatch.sql';
   cmp_info(owm).script     := '?/rdbms/admin/owmpatch.sql';
   cmp_info(ordim).script   := '?/ord/im/admin/impatch.sql';
   cmp_info(sdo).script     := '?/md/admin/sdopatch.sql';
   cmp_info(context).script := '?/ctx/admin/ctxpatch.sql';
   cmp_info(wk).script      := '?/ultrasearch/admin/wkpatch.sql';
   cmp_info(mgw).script     := '?/mgw/admin/mgwpatch.sql';
   cmp_info(amd).script     := '?/olap/admin/amdpatch.sql';
   cmp_info(aps).script     := '?/olap/admin/apspatch.sql';
   cmp_info(xoq).script     := '?/olap/admin/xoqpatch.sql';
   cmp_info(em).script      := '?/sysman/admin/emdrep/sql/empatch.sql';
   cmp_info(apex).script    := '?/apex/apxpatch.sql';
   cmp_info(dv).script      := '?/rdbms/admin/dvpatch.sql';
 ELSE
   cmp_info(catalog).script := '?/rdbms/admin/catalog.sql';
   cmp_info(catproc).script := '?/rdbms/admin/catproc.sql';
   cmp_info(javavm).script  := '?/javavm/install/jvmdbmig.sql'; 
   cmp_info(xml).script     := '?/xdk/admin/xmldbmig.sql';
   cmp_info(xdb).script     := '?/rdbms/admin/xdbdbmig.sql';
   cmp_info(rac).script     := '?/rdbms/admin/catclust.sql';
   cmp_info(ols).script     := '?/rdbms/admin/olsdbmig.sql';
   cmp_info(exf).script     := '?/rdbms/admin/exfdbmig.sql';
   cmp_info(rul).script     := '?/rdbms/admin/ruldbmig.sql';
   cmp_info(owm).script     := '?/rdbms/admin/owmdbmig.sql';
   cmp_info(odm).script     := '?/rdbms/admin/odmdbmig.sql';
   cmp_info(ordim).script   := '?/ord/im/admin/imdbmig.sql';
   cmp_info(sdo).script     := '?/md/admin/sdodbmig.sql';
   cmp_info(context).script := '?/ctx/admin/ctxdbmig.sql';
   cmp_info(wk).script      := '?/ultrasearch/admin/wkdbmig.sql';
   cmp_info(mgw).script     := '?/mgw/admin/mgwdbmig.sql';
   cmp_info(amd).script     := '?/olap/admin/amddbmig.sql';
   cmp_info(aps).script     := '?/olap/admin/apsdbmig.sql';
   cmp_info(xoq).script     := '?/olap/admin/xoqdbmig.sql';
   cmp_info(em).script      := '?/sysman/admin/emdrep/sql/empatch.sql';
   cmp_info(apex).script    := '?/apex/apxdbmig.sql';
   cmp_info(dv).script      := '?/rdbms/admin/dvdbmig.sql';

 END IF;
-- *****************************************************************
-- Store Release Dependent Data
-- *****************************************************************

-- kbytes for component installs (into SYSTEM and DEFAULT tablespaces)
-- add 10% for 11g 
   cmp_info(javavm).ins_sys_kbytes:= 105972*1.1;
   cmp_info(xml).ins_sys_kbytes:=      4818*1.1;
   cmp_info(catjava).ins_sys_kbytes:=  5760*1.1;
   cmp_info(xdb).ins_sys_kbytes:=      8388*1.1;
   IF db_block_size = 16384 THEN
      cmp_info(xdb).ins_def_kbytes:= 110676*1.1;
   ELSE
      cmp_info(xdb).ins_def_kbytes:=  56064*1.1;
   END IF;
   cmp_info(ordim).ins_sys_kbytes:=   23064*1.1;
   cmp_info(ordim).ins_def_kbytes:=     448*1.1;
   cmp_info(em).ins_sys_kbytes:=      22528*1.1;
   cmp_info(em).ins_def_kbytes:=      51200*1.1;

   IF dbv=920 THEN
      cmp_info(catalog).sys_kbytes:= 479040-386944;
      cmp_info(catproc).sys_kbytes:=    512;
      cmp_info(javavm).sys_kbytes:=   94272;  
      cmp_info(xml).sys_kbytes:=       2176;  
      cmp_info(owm).sys_kbytes:=       1152;  
      cmp_info(mgw).sys_kbytes:=       1984;
      cmp_info(aps).sys_kbytes:=          0;
      cmp_info(amd).sys_kbytes:=       1088;
      cmp_info(ols).sys_kbytes:=         64;
      cmp_info(context).sys_kbytes:=   4480;  
      cmp_info(xdb).sys_kbytes:=       7808; 
      cmp_info(catjava).sys_kbytes:=   1088;
      cmp_info(ordim).sys_kbytes:=    19840;
      cmp_info(sdo).sys_kbytes:=      17280;
      cmp_info(wk).sys_kbytes:=        1152;
      cmp_info(apex).sys_kbytes:=     74560;
      cmp_info(xoq).sys_kbytes:=       2048;
      cmp_info(stats).sys_kbytes:=     6144;

      cmp_info(catalog).sysaux_kbytes:=  51264;
      cmp_info(catproc).sysaux_kbytes:=8832+256;--system + tsmsys
      cmp_info(aps).sysaux_kbytes:=      25856;
      cmp_info(xoq).sysaux_kbytes:=        704;
      cmp_info(stats).sysaux_kbytes:=     2688;

      cmp_info(amd).def_ts_kbytes:=        704; -- OLAPSYS
      cmp_info(context).def_ts_kbytes:=   1088; -- CTXSYS
      cmp_info(wk).def_ts_kbytes:=  2816+12288; -- WKSYS + WK_TEST
      cmp_info(odm).def_ts_kbytes:=        128; -- ODM 
      cmp_info(owm).def_ts_kbytes:=       6592; -- WMSYS
      cmp_info(ols).def_ts_kbytes:=        448; -- LBACSYS
      cmp_info(sdo).def_ts_kbytes:=      39296; -- MDSYS
      cmp_info(ordim).def_ts_kbytes:=    10496; -- ORDSYS
      cmp_info(catproc).def_ts_kbytes:= 8832+1536+256+192; 
                                           -- SYSTEM+dbsnmp+tsmsys+outln
      cmp_info(xdb).def_ts_kbytes:=       9920; -- XDB


    ELSIF dbv = 101 THEN

      cmp_info(catalog).sys_kbytes:= 573440-455232;
      cmp_info(catproc).sys_kbytes:=      0;  
      cmp_info(javavm).sys_kbytes:=   59712;  
      cmp_info(xml).sys_kbytes:=       8068; 
      cmp_info(owm).sys_kbytes:=       2176;  
      cmp_info(mgw).sys_kbytes:=       2368;
      cmp_info(aps).sys_kbytes:=        128;
      cmp_info(amd).sys_kbytes:=       1280; 
      cmp_info(ols).sys_kbytes:=       1024;
      cmp_info(em).sys_kbytes:=       51584;
      cmp_info(context).sys_kbytes:=   3072;  
      cmp_info(xdb).sys_kbytes:=      11008;  
      cmp_info(catjava).sys_kbytes:=      0;
      cmp_info(ordim).sys_kbytes:=     7488;
      cmp_info(sdo).sys_kbytes:=      15424;
      cmp_info(odm).sys_kbytes:=          0;
      cmp_info(wk).sys_kbytes:=        1088;
      cmp_info(exf).sys_kbytes:=       1024;
      cmp_info(apex).sys_kbytes:=     82048;
      cmp_info(xoq).sys_kbytes:=        768;
      cmp_info(stats).sys_kbytes:=     7360;

      cmp_info(catalog).sysaux_kbytes:=  70720-52032;
      cmp_info(catproc).sysaux_kbytes:=    832;  
      cmp_info(aps).sysaux_kbytes:=      14336;
      cmp_info(em).sysaux_kbytes:=         512;
      cmp_info(xoq).sysaux_kbytes:=        704;
      cmp_info(stats).sysaux_kbytes:=     3200;

      cmp_info(context).def_ts_kbytes:=    832; -- CTXSYS
      cmp_info(exf).def_ts_kbytes:=        640; -- EXFSYS
      cmp_info(apex).def_ts_kbytes:=     86400; -- FLOWS 
      cmp_info(sdo).def_ts_kbytes:=      37888; -- MDSYS
      cmp_info(amd).def_ts_kbytes:=         64; -- OLAPSYS
      cmp_info(ordim).def_ts_kbytes:=    10688; -- ORDSYS
      cmp_info(em).def_ts_kbytes:=       70976; -- SYSMAN 
      cmp_info(catproc).def_ts_kbytes:= 2944+1280+256+192; 
                                           -- SYSTEM+dbsnmp+tsmsys+outln
      cmp_info(wk).def_ts_kbytes:=         320; -- WKSYS + WK_TEST
      cmp_info(owm).def_ts_kbytes:=        640; -- WMSYS
      cmp_info(xdb).def_ts_kbytes:=      50944; -- XDB 

      cmp_info(ols).def_ts_kbytes:=        128; -- LBACSYS

   ELSIF dbv = 102 THEN
      cmp_info(catalog).sys_kbytes:= 616448-548544;
      cmp_info(catproc).sys_kbytes:=      0;  
      cmp_info(javavm).sys_kbytes:=   55616;  
      cmp_info(xml).sys_kbytes:=        704;  
      cmp_info(owm).sys_kbytes:=       4160;  
      cmp_info(mgw).sys_kbytes:=        256;
      cmp_info(aps).sys_kbytes:=        128;
      cmp_info(amd).sys_kbytes:=       1216;
      cmp_info(ols).sys_kbytes:=       1024;
      cmp_info(dv).sys_kbytes:=         240;
      cmp_info(em).sys_kbytes:=       46720;
      cmp_info(context).sys_kbytes:=   3136;  
      cmp_info(xdb).sys_kbytes:=       8128;  
      cmp_info(catjava).sys_kbytes:=   1024;
      cmp_info(ordim).sys_kbytes:=     5952;
      cmp_info(sdo).sys_kbytes:=      11840;
      cmp_info(odm).sys_kbytes:=          0;
      cmp_info(wk).sys_kbytes:=        1152;
      cmp_info(exf).sys_kbytes:=       1024;
      cmp_info(rul).sys_kbytes:=       1024;
      cmp_info(apex).sys_kbytes:=     82944;
      cmp_info(xoq).sys_kbytes:=          0;
      cmp_info(stats).sys_kbytes:=     5952;

      cmp_info(catalog).sysaux_kbytes:=  77056-60096;
      cmp_info(catproc).sysaux_kbytes:=    832;  
      cmp_info(aps).sysaux_kbytes:=       7424;
      cmp_info(xoq).sysaux_kbytes:=        704;
      cmp_info(stats).sysaux_kbytes:=     5120;

      cmp_info(context).def_ts_kbytes:=    896; -- CTXSYS
      cmp_info(exf).def_ts_kbytes:=        256; -- EXFSYS
      cmp_info(apex).def_ts_kbytes:=    103104; -- FLOWS_ 
      cmp_info(sdo).def_ts_kbytes:=      21696; -- MDSYS
      cmp_info(ordim).def_ts_kbytes:=    10688; -- ORDSYS
      cmp_info(em).def_ts_kbytes:=       69952; -- SYSMAN
      cmp_info(catproc).def_ts_kbytes:= 1856+832+0+64; 
                                           -- SYSTEM+dbsnmp+tsmsys+outln
      cmp_info(owm).def_ts_kbytes:=        256; -- WMSYS
      cmp_info(xdb).def_ts_kbytes:=      49088; -- XDB
      cmp_info(ols).def_ts_kbytes:=          0; -- LBACSYS
      cmp_info(dv).def_ts_kbytes:=           0; -- DVSYS

   ELSIF dbv = 111 THEN

      -- initial estimates of growth in patch release
      cmp_info(catalog).sys_kbytes:=   1024;
      cmp_info(catproc).sys_kbytes:=  10240;  
      cmp_info(catalog).sysaux_kbytes:=      0;
      cmp_info(catproc).sysaux_kbytes:=   1024;  

   END IF;

-- *****************************************************************
-- END of Constant Data
-- *****************************************************************

-- *****************************************************************
-- START of Collect Section
-- *****************************************************************

-- *****************************************************************
-- Collect Variable Component Information 
-- *****************************************************************


   BEGIN -- Get components
      
      IF dbv = 920 THEN  -- No namespace
         OPEN reg_cursor FOR 
              'SELECT cid, status, version, schema# ' ||
              'FROM registry$';
      ELSE
          OPEN reg_cursor FOR 
              'SELECT cid, status, version, schema# ' ||
              'FROM registry$ WHERE namespace =''SERVER''';
     END IF;

     LOOP
        FETCH reg_cursor INTO p_cid, n_status, p_version, n_schema;
        EXIT WHEN reg_cursor%NOTFOUND;
        IF n_status NOT IN (99,8) THEN -- not REMOVED or REMOVING
           SELECT name INTO p_schema FROM user$ 
                  WHERE user#=n_schema;
           FOR i IN 1..max_components LOOP
               IF p_cid = cmp_info(i).cid THEN
                  store_comp(i, p_schema, p_version, n_status);
                  EXIT; -- from component search loop
               END IF;
           END LOOP;  -- ignore if not in component list
        END IF;
     END LOOP;
     CLOSE reg_cursor;

     -- Ultra Search not in 10.1.0.2 registry so check schema
     IF NOT cmp_info(wk).processed THEN
        BEGIN
           SELECT NULL into p_null FROM user$ WHERE name = 'WKSYS';
           store_comp(wk, 'WKSYS', db_version, NULL);           
        EXCEPTION
           WHEN NO_DATA_FOUND THEN NULL;
        END;
     END IF;

      -- Check for HTML DB in 9.2.0 and 10.1 databases
      BEGIN
         EXECUTE IMMEDIATE 
            'SELECT FLOWS_010500.wwv_flows_release from dual'
         INTO p_version;
         store_comp(apex,'FLOWS_010500',p_version, NULL);
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;

      BEGIN
         EXECUTE IMMEDIATE 
            'SELECT FLOWS_010600.wwv_flows_release from dual'
         INTO p_version;
         store_comp(apex,'FLOWS_010600',p_version, NULL);
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;

      -- Check for APEX in 10.2 databases
      BEGIN
         EXECUTE IMMEDIATE 
            'SELECT FLOWS_020000.wwv_flows_release from dual'
         INTO p_version;
         store_comp(apex,'FLOWS_020000',p_version, NULL);
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;

      BEGIN
         EXECUTE IMMEDIATE 
            'SELECT FLOWS_020100.wwv_flows_release from dual'
         INTO p_version;
         store_comp(apex,'FLOWS_020100',p_version, NULL);
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END; 
            
     -- Database Vault  not in registry so check schema
     IF NOT cmp_info(dv).processed THEN
        BEGIN
           SELECT NULL into p_null FROM user$ WHERE name = 'DVSYS';
           store_comp(dv, 'DVSYS', '10.2.0', NULL);           
        EXCEPTION
           WHEN NO_DATA_FOUND THEN NULL;
        END;
     END IF;
 END; -- Get components

 IF dbv != 111 THEN -- install required components on major release only
   -- if SDO, ORDIM, WK, EXF, or ODM components are present, need JAVAVM
   IF NOT cmp_info(javavm).processed THEN
      IF cmp_info(ordim).processed OR cmp_info(wk).processed OR 
         cmp_info(exf).processed OR
         cmp_info(sdo).processed THEN
         store_comp(javavm, 'SYS', NULL, NULL);           
         cmp_info(javavm).install := TRUE;
         store_comp(catjava, 'SYS', NULL, NULL);           
         cmp_info(catjava).install := TRUE;
      END IF;
   END IF;
 
   -- If there is a JAVAVM component
   -- THEN include the CATJAVA component.
   IF cmp_info(javavm).processed AND NOT cmp_info(catjava).processed THEN
      store_comp(catjava, 'SYS', NULL, NULL);           
      cmp_info(catjava).install := TRUE;
   END IF;

   -- If interMedia or Spatial component, but no XML, Then
   -- install XML
   IF NOT cmp_info(xml).processed AND
         (cmp_info(ordim).processed OR cmp_info(sdo).processed) THEN
      store_comp(xml, 'SYS', NULL, NULL);           
      cmp_info(xml).install := TRUE;
   END IF;
   
   -- If XML, interMedia or Spatial component, but no XDB, Then
   -- install XDB
   IF NOT cmp_info(xdb).processed AND
         (cmp_info(ordim).processed OR cmp_info(sdo).processed OR
          cmp_info(xml).processed) THEN
      store_comp(xdb, 'XDB', NULL, NULL);           
      cmp_info(xdb).install := TRUE;
      cmp_info(xdb).def_ts := 'SYSAUX';
   END IF;
   
   -- If Spatial component, but no ORDIM, Then
   -- install ORDIM
   IF NOT cmp_info(ordim).processed AND
         (cmp_info(sdo).processed) THEN
      store_comp(ordim, 'ORDSYS', NULL, NULL);           
      cmp_info(ordim).install := TRUE;
      cmp_info(ordim).def_ts := 'SYSAUX';
   END IF;

 END IF;  -- not for patch release

-- *****************************************************************
-- Collect Variable Initialization Parameter Information
-- *****************************************************************

   -- Find renamed parameters in use
   FOR i IN 1..max_rp LOOP
      BEGIN
         SELECT NULL INTO p_null
         FROM v$parameter WHERE name = LOWER(rp(i).oldname) AND
              isdefault = 'FALSE';
         rp(i).db_match := TRUE;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         rp(i).db_match := FALSE;
      END;
   END LOOP;
 
   -- Find obsolete parameters in use
   FOR i IN 1..max_op LOOP
      BEGIN
         SELECT NULL INTO p_null
         FROM v$parameter WHERE name = LOWER(op(i).name) AND
              isdefault = 'FALSE';
         op(i).db_match := TRUE;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         op(i).db_match := FALSE;
      END;
   END LOOP;

   -- Find special parameters in use
   FOR i IN 1..max_sp LOOP
      BEGIN
         SELECT value INTO p_value
         FROM v$parameter WHERE name = LOWER(sp(i).oldname) AND
              isdefault = 'FALSE';
         IF sp(i).oldvalue IS NULL OR
            p_value = sp(i).oldvalue THEN
            sp(i).db_match := TRUE;

            -- calculate new values for cache size params (buffers x blocksize)
            IF sp(i).oldname = 'db_block_buffers' THEN
               sp(i).newvalue := TO_CHAR(TO_NUMBER(p_value) * db_block_size);
            ELSIF sp(i).oldname = 'buffer_pool_recycle' OR
                  sp(i).oldname = 'buffer_pool_keep' THEN
               IF INSTR(UPPER(p_value),'BUFFERS:') > 0 THEN  -- has keyword
                  IF INSTR(SUBSTR(p_value,INSTR(UPPER(p_value),
                          'BUFFERS:')+8),',') > 0  THEN 
                     -- has second keyword after BUFFERS
                     sp(i).newvalue := TO_CHAR(TO_NUMBER(SUBSTR(p_value,
                        INSTR(UPPER(p_value),'BUFFERS:')+8,
                        INSTR(p_value,',')-INSTR(UPPER(p_value),'BUFFERS:')-8))
                        * db_block_size);
                  ELSE -- no second keyword
                     sp(i).newvalue := TO_CHAR(TO_NUMBER(SUBSTR(p_value,
                        INSTR(UPPER(p_value),'BUFFERS:')+8)) * db_block_size);
                  END IF; -- second keyword
               ELSE -- no keywords, just number
                  sp(i).newvalue := TO_CHAR(TO_NUMBER(p_value) * db_block_size);
               END IF; -- keywords
            END IF; -- params with calculated values
         ELSE
	    -- plsql_compiler_flags may contain two values
            -- in this case we process the list of values
            IF (sp(i).oldname = 'plsql_compiler_flags') AND
               (INSTR(p_value,sp(i).oldvalue) > 0) THEN
                   -- If 'DEBUG' value found in list then make sure 
                   -- it is not finding NON_DEBUG                
                   -- (using premise that DEBUG and NON_DEBUG do not mix)
                   IF (sp(i).oldvalue='DEBUG' AND 
                      INSTR(p_value,'NON_DEBUG') = 0) OR 
                      (sp(i).oldvalue != 'DEBUG') THEN
                         sp(i).db_match := TRUE;
                   END IF;
            ELSE
               sp(i).db_match := FALSE;
            END IF;
         END IF;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         sp(i).db_match := FALSE;
      END;
   END LOOP;
 
 
  -- Find required values
   FOR i IN 1..max_reqp LOOP
      BEGIN
         SELECT value INTO p_value
         FROM v$parameter WHERE name = reqp(i).name AND
              isdefault = 'TRUE';
         IF reqp(i).name = 'db_block_size' THEN
            IF dbv = 920 THEN  -- db_block_size default changed in 10g
               reqp(i).db_match := TRUE;
            END IF;
         ELSIF reqp(i).name = 'undo_management' THEN
            IF dbv != 111 THEN
              reqp(i).db_match := TRUE;
            END IF;
         END IF;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         reqp(i).db_match := FALSE;
      END;
   END LOOP;

   -- Find values for initialization parameters with minimum values
   -- Convert to numeric values
   FOR i IN 1..max_mp LOOP
     IF i = sp_idx and dbv = 920 THEN
        -- This block of code is dealing with shared_pool_size
        SELECT SUM(bytes) INTO mp(sp_idx).oldvalue FROM v$sgastat
        WHERE pool='shared pool';

        SELECT value INTO p_value FROM v$parameter WHERE name = LOWER(mp(i).name);
        sps := pvalue_to_number(p_value);

        SELECT value INTO p_value FROM v$parameter WHERE name = 'cpu_count';
        cpu := pvalue_to_number(p_value);

        SELECT value INTO p_value FROM v$parameter WHERE name = 'sessions';
        sesn := pvalue_to_number(p_value);

        -- On a large database, the minimum of 144M may not be enough for shared 
        -- pool size, we have to factor in the number of CPU, the number of session,
        -- and some new added features. So here is the formula:
        -- Recommended minimum share_pool_size = mp(sp_idx).minvalue + 
        -- (Num_of_CPU * 2MB) +
        -- (Num_of_sessiions * 17408) + 
        -- (10% of the old shared_pool_size for overhead)
        sps_ovrhd := sps * 0.1;

        IF collect_diag THEN
          DBMS_OUTPUT.PUT_LINE('DIAG-sps_min: ' || mp(sp_idx).minvalue);
--          DBMS_OUTPUT.PUT_LINE('DIAG-cpu: ' || cpu 
--                    || ', cpu*2097152: ' || cpu * 2097152);
          DBMS_OUTPUT.PUT_LINE('DIAG-sesn: ' || sesn || ', sesn*17408: ' 
                                || sesn * 17408);
          DBMS_OUTPUT.PUT_LINE('DIAG-sps: ' || sps || 
                                ', sps_ovrhd(10%): ' || sps_ovrhd);
           mp(sp_idx).minvalue := mp(sp_idx).minvalue + 
/* avoid CPU dependency in DIAG mode (cpu * 2097152) +  */
                                (sesn * 17408) + 
                                (sps_ovrhd);
        ELSE
           mp(sp_idx).minvalue := mp(sp_idx).minvalue + 
                                (cpu * 2097152) + 
                                (sesn * 17408) + 
                                (sps_ovrhd);
        END IF;
     ELSE
        BEGIN
           SELECT value INTO p_value  
           FROM v$parameter WHERE name = LOWER(mp(i).name);
           mp(i).oldvalue := pvalue_to_number(p_value);

        EXCEPTION WHEN NO_DATA_FOUND THEN
           mp(i).oldvalue := NULL;
        END;
     END IF;
   END LOOP;

   IF mp(tg_idx).oldvalue != 0 THEN  -- SGA_TARGET in use
      IF dbv = 101 THEN
         mp(tg_idx).newvalue := mp(tg_idx).minvalue + mp(cs_idx).oldvalue +
                             mp(jv_idx).oldvalue;
      ELSE
         mp(tg_idx).newvalue := mp(tg_idx).minvalue;
      END IF;

      -- Check that SGA_TARGET is at least 50M greater than 
      -- shared pool + java pool (if either one is specified)
      IF (mp(sp_idx).oldvalue IS NOT NULL) OR 
         (mp(jv_idx).oldvalue IS NOT NULL) THEN 
         IF mp(tg_idx).newvalue < mp(sp_idx).oldvalue + mp(jv_idx).oldvalue +
                                  50*1024 
         THEN
            mp(tg_idx).newvalue :=  mp(sp_idx).oldvalue + 
                                    mp(jv_idx).oldvalue + 
                                    50*1024;
         END IF;
      END IF;
      IF mp(tg_idx).newvalue > mp(tg_idx).oldvalue THEN
           mp(tg_idx).display := TRUE;
      END IF;
      FOR i IN 1..max_mp LOOP
        IF i NOT IN (tg_idx,cs_idx,sp_idx,mt_idx) AND 
          (mp(i).oldvalue IS NULL OR
           mp(i).oldvalue < mp(i).minvalue) THEN  
           mp(i).display := TRUE;
           mp(i).newvalue := mp(i).minvalue;
        END IF;
      END LOOP;
   ELSE -- pool sizes included 
     FOR i IN 1..max_mp LOOP
       IF i NOT IN (tg_idx,mt_idx) AND 
          (mp(i).oldvalue IS NULL OR
           mp(i).oldvalue < mp(i).minvalue) THEN  
           mp(i).display := TRUE;
           mp(i).newvalue := mp(i).minvalue;
        END IF;
      END LOOP;
   END IF;

   -- For 11.1  check if MEMORY_TARGET is set and NON-ZERO 
   --then check that MEMORY_TARGET is at least 12M greater than 
   -- sga_target + pga_target (for cases where SGA_TARGET is in use)
   IF dbv = 111 AND memory_target AND (mp(mt_idx).oldvalue != 0) THEN 
         mp(mt_idx).newvalue := mp(mt_idx).minvalue;

      IF (mp(tg_idx).oldvalue != 0) THEN -- SGA_TARGET in use 
         IF (mp(mt_idx).newvalue < mp(tg_idx).oldvalue + mp(pg_idx).oldvalue + 
                                   12*1024) THEN
            -- Set MEMORY_TARGET equal to sga_target + pga_target + 12M
            mp(mt_idx).newvalue :=  mp(tg_idx).oldvalue +
                                    mp(pg_idx).oldvalue + 
                                    12*1024;
         END IF;
      ELSE  -- SGA_TARGET not in use
            -- Check that MEMORY_TARGET is at least 12M greater than 
            -- shared_pool + java pool + pga_aggregate + db_cache_size
            IF mp(mt_idx).newvalue < mp(sp_idx).oldvalue + mp(jv_idx).oldvalue
             + mp(pg_idx).oldvalue + mp(cs_idx).oldvalue + 12*1024 
            THEN
              -- Set MEMORY_TARGET equal to shared_pool + java_pool +
              -- pga_aggregate + db_cache_size + 12M
               mp(mt_idx).newvalue :=  mp(sp_idx).oldvalue + 
                                       mp(jv_idx).oldvalue +
                                       mp(pg_idx).oldvalue +                  
                                       mp(cs_idx).oldvalue +
                                       12*1024;
            END IF;
      END IF;

      -- If the newvalue is greater than the old value set the display TRUE
      IF mp(mt_idx).newvalue > mp(mt_idx).oldvalue THEN
           mp(mt_idx).display := TRUE;
           --Loop through other pool sizes to ignore warnings
           --If displaying MEMORY_TARGET warning then the other 
           --pool sizes do not need warnings
      END IF;

      -- If a minimum value is required for MEMORY_TARGET then
      -- do not output a minimum value for sga_target or pga_aggregate
      -- or shared pool or db_cache_size as these values
      -- are no longer considered once MEMORY_TARGET value is set.
      FOR i IN 1..max_mp LOOP
        IF i IN (tg_idx,pg_idx,sp_idx,cs_idx) AND mp(i).display THEN
           mp(i).display := FALSE;
        END IF;
      END LOOP;     
   END IF; -- 11.1 db and memory_target in use

-- *****************************************************************
-- Collect Tablespace Information
-- *****************************************************************

   idx := 0;
   FOR ts IN (SELECT tablespace_name, contents, extent_management 
                     FROM dba_tablespaces) LOOP
       IF ts.tablespace_name IN ('SYSTEM', 'SYSAUX', db_undo_tbs) OR 
          is_comp_tablespace(ts.tablespace_name) OR
          ts_has_queues (ts.tablespace_name) OR 
          ts_is_SYS_temporary (ts.tablespace_name) THEN

          idx:=idx+1;
          ts_info(idx).name  :=ts.tablespace_name;
          IF ts.contents = 'TEMPORARY' THEN      
             ts_info(idx).temporary := TRUE;
          ELSE
             ts_info(idx).temporary := FALSE;
          END IF;

          IF ts.extent_management = 'LOCAL' THEN
             ts_info(idx).localmanaged := TRUE;
          ELSE
             ts_info(idx).localmanaged := FALSE;
          END IF;

          -- Get number of kbytes used
          SELECT SUM(bytes) INTO sum_bytes
                 FROM dba_segments seg 
                 WHERE seg.tablespace_name = ts.tablespace_name;
          IF sum_bytes IS NULL THEN 
             ts_info(idx).inuse:=0;
          ELSIF sum_bytes <= 1024 THEN
             ts_info(idx).inuse:=1;
          ELSE
             ts_info(idx).inuse :=ROUND(sum_bytes/1024);
          END IF;  

          -- Get number of kbytes allocated
          IF ts_info(idx).temporary AND
             ts_info(idx).localmanaged THEN
             SELECT SUM(bytes) INTO sum_bytes
                    FROM dba_temp_files files 
                    WHERE files.tablespace_name = ts.tablespace_name;
          ELSE
             SELECT SUM(bytes) INTO sum_bytes
                    FROM dba_data_files files 
                    WHERE files.tablespace_name = ts.tablespace_name;
          END IF;
          IF sum_bytes IS NULL THEN 
             ts_info(idx).alloc:=0;
          ELSIF sum_bytes <= 1024 THEN
             ts_info(idx).alloc:=1;
          ELSE
             ts_info(idx).alloc:=ROUND(sum_bytes/1024);
          END IF;  
          
          -- Get number of kbytes of unused autoextend
          IF ts_info(idx).temporary AND 
             ts_info(idx).localmanaged THEN
             SELECT SUM(decode(maxbytes, 0, 0, maxbytes-bytes))
                    INTO sum_bytes
                    FROM dba_temp_files 
                    WHERE tablespace_name=ts.tablespace_name;
          ELSE
             SELECT SUM(decode(maxbytes, 0, 0, maxbytes-bytes))
                    INTO sum_bytes
                    FROM dba_data_files 
                    WHERE tablespace_name=ts.tablespace_name;
          END IF;
          IF sum_bytes IS NULL THEN 
             ts_info(idx).auto:=0;
          ELSIF sum_bytes <= 1024 THEN
             ts_info(idx).auto:=1;
          ELSE
             ts_info(idx).auto:=ROUND(sum_bytes/1024);
          END IF;  

          -- total available is allocated plus auto extend
          ts_info(idx).avail := ts_info(idx).alloc + ts_info(idx).auto;

      END IF;
   END LOOP;
   max_ts := idx;   -- max tablespaces of interest

   -- check for ASM 
   IF dbv != 920 THEN
      BEGIN
         EXECUTE IMMEDIATE 'SELECT NULL FROM v$asm_client 
                 WHERE rownum <=1'
         INTO P_NULL;
         using_ASM := TRUE;
      EXCEPTION 
         WHEN NO_DATA_FOUND THEN NULL;
      END;
   END IF;

-- *****************************************************************
-- Collect Public Rollback Information
-- *****************************************************************

   idx:=0;

   IF db_undo != 'AUTO' THEN  -- using rollback segments
      FOR rs IN (SELECT segment_name, next_extent, max_extents, status 
                 FROM dba_rollback_segs WHERE owner = 'PUBLIC' OR
                 (owner='SYS' AND segment_name != 'SYSTEM')) LOOP
        BEGIN
          SELECT tablespace_name, sum(bytes) INTO p_tsname, sum_bytes 
                 FROM dba_segments
                 WHERE segment_name = rs.segment_name
                 GROUP BY tablespace_name;
          IF sum_bytes < 1024 THEN
             sum_bytes := 1;
          ELSE
             sum_bytes := sum_bytes/1024;
          END IF;
        EXCEPTION WHEN NO_DATA_FOUND THEN
          sum_bytes := NULL;
        END;

        IF sum_bytes IS NOT NULL THEN
           idx:=idx + 1;
           rs_info(idx).tbs_name := p_tsname;
           rs_info(idx).seg_name := rs.segment_name;
           rs_info(idx).status := rs.status;
           rs_info(idx).next := rs.next_extent/1024;
           rs_info(idx).max_ext := rs.max_extents;
           rs_info(idx).status := rs.status;
           rs_info(idx).inuse := sum_bytes;
           SELECT ROUND(SUM(decode(maxbytes, 0, 0,maxbytes-bytes)/1024))
                  INTO rs_info(idx).auto
                  FROM dba_data_files 
                  WHERE tablespace_name=p_tsname;
        END IF;
      END LOOP;
   END IF;  -- using undo tablespace, not rollback

   max_rs := idx;

-- *****************************************************************
-- Collect Log File Information
-- *****************************************************************

   idx := 0;
   FOR log IN (SELECT lf.member, l.bytes, l.status, l.group#
            FROM  v$logfile lf, v$log l 
            WHERE lf.group# = l.group# 
            AND   l.bytes < min_log_size 
            ORDER BY l.status DESC) LOOP
      idx := idx + 1;
      lf_info(idx).file_spec := log.member;
      lf_info(idx).grp       := log.group#;
      lf_info(idx).bytes     := log.bytes;
      lf_info(idx).status    := log.status;
   END LOOP;
   max_lf := idx;

-- *****************************************************************
-- Collect Misc Information for Warnings
-- *****************************************************************

   -- Check for patch applied in DBs with registry
   BEGIN
      IF dbv IN (920,101) THEN  -- starting in 10.2, can't happen
         EXECUTE IMMEDIATE 
             'SELECT NULL FROM registry$ 
              WHERE cid = ''CATPROC'' AND version != :inst_version'
         INTO p_null USING db_version;
         version_mismatch := TRUE;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for RAC
   BEGIN
      SELECT NULL INTO p_null FROM v$parameter
      WHERE name = 'cluster_database' AND value = 'TRUE';
      cluster_dbs := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for pre-existing DIP user in pre-10.1 databases
   BEGIN
      SELECT NULL INTO p_null FROM user$ WHERE name='DIP';
      IF dbv = 920 THEN
         dip_user_exists:=TRUE;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for ORACLE_OCM user and no OCM packages 
   IF dbv != 111 THEN
    BEGIN
      SELECT  user# INTO user_num FROM user$ WHERE name='ORACLE_OCM';
      BEGIN
         SELECT NULL INTO p_NULL FROM sys.obj$  
                                 WHERE owner# = user_num AND
                                       name ='MGMT_DB_LL_METRICS' AND 
                                       type# = 9; 	   
      EXCEPTION
         WHEN NO_DATA_FOUND THEN ocm_user_exists := TRUE;
      END;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN ocm_user_exists := FALSE;
    END;
   END IF;

   -- Check for Database Character Set for use of AL24UTFFSS
   BEGIN
       SELECT NULL INTO p_null FROM v$nls_parameters
       WHERE parameter = 'NLS_CHARACTERSET' AND value = 'AL24UTFFSS';
       nls_AL24UTFFSS := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;
 
   -- Check for supported NCHAR character set
   BEGIN
       SELECT NULL INTO p_null FROM v$nls_parameters WHERE
       parameter='NLS_NCHAR_CHARACTERSET' AND
       value NOT IN ('UTF8','AL16UTF16');
       UTF8_AL16UTF16 := TRUE;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN NULL;
   END;
   
   -- Check for OWM replication
   IF cmp_info(owm).processed AND dbv IN (920, 101) THEN
      BEGIN
         -- Does this database have wmsys replication?
         SELECT NULL INTO p_null FROM obj$ o, user$ u
             WHERE o.name = 'WM$REPLICATION_TABLE'
             AND u.name='WMSYS'
             AND u.user#=o.owner# and o.type#=2;

         EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM wmsys.wm$replication_table'
              INTO rows_processed;

         IF rows_processed >0 THEN
            -- Is the Advanced Replication option installed?
            SELECT NULL INTO p_null FROM v$option
                WHERE parameter = 'Advanced replication' AND
                value = 'TRUE';
            -- If we made it this far then this installation has
            -- replication installed and is using it for OWM
            owm_replication := TRUE;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
      END;
   END IF;
 
   -- Check for database links
   BEGIN
      IF dbv IN (920,101) THEN
         SELECT NULL INTO p_null FROM link$ 
         WHERE (password IS NOT NULL OR 
            authpwd IS NOT NULL) AND rownum <=1;
         dblinks := TRUE;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for CDC streams
   BEGIN
      IF dbv IN (920, 101) THEN
         EXECUTE IMMEDIATE 'SELECT NULL 
             FROM dba_capture cap, dba_queues q, dba_queue_tables qt
             WHERE substr(cap.capture_name,4) = substr(q.name,4) AND
                     substr(q.name,4) = substr(qt.queue_table,4) AND
                     cap.queue_owner = q.owner AND
                     cap.queue_name = q.name AND
                     q.owner = qt.owner AND
                     q.queue_table = qt.queue_table AND
                     rownum <= 1'
         INTO p_null;
         cdc_data := TRUE;
       END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for CONNECT role
   BEGIN
     IF dbv IN (920,101) THEN
        SELECT NULL INTO p_null FROM dba_role_privs
        WHERE granted_role = 'CONNECT' AND
              grantee NOT IN (
                   'SYS', 'OUTLN', 'SYSTEM', 'CTXSYS', 'DBSNMP', 
                   'LOGSTDBY_ADMINISTRATOR', 'ORDSYS',  
                   'ORDPLUGINS',  'OEM_MONITOR', 'WKSYS', 'WKPROXY', 
                   'WK_TEST', 'WKUSER', 'MDSYS', 'LBACSYS', 'DMSYS',
                   'WMSYS',  'OLAPDBA', 'OLAPSVR', 'OLAP_USER',  
                   'OLAPSYS', 'EXFSYS', 'SYSMAN', 'MDDATA',
                   'SI_INFORMTN_SCHEMA','XDB', 'ODM') AND
            rownum <= 1;
         connect_role := TRUE;
     END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for INVALID objects
   -- For "inplace" upgrades check for invalid objects that can be excluded
   -- as they may have changed between releases and don't need to be reported.
   -- For all other types of upgrades, use the simple query below to 
   -- eliminate running the intricate queries except when they are needed.
   -- Bug 4905742
   BEGIN
      IF NOT inplace THEN
         SELECT NULL INTO p_null FROM dba_objects
         WHERE status = 'INVALID' AND object_name NOT LIKE 'BIN$%' AND 
               rownum <=1;
      ELSE   
         SELECT NULL INTO p_null FROM dba_objects
         WHERE status = 'INVALID' AND object_name NOT LIKE 'BIN$%' AND
               rownum <=1 AND
               object_name NOT IN (SELECT name FROM dba_dependencies
                                  START WITH referenced_name IN 
                                    (
                                    'V$SESSION',
                                    'V$DELETED_OBJECT',
                                    'V$MUTEX_SLEEP_HISTORY',
                                    'V$LOGMNR_SESSION',
                                    'V$RECOVERY_FILE_DEST',
                                    'V$FLASH_RECOVERY_AREA_USAGE',
                                    'V$ACTIVE_SESSION_HISTORY',
                                    'V$BUFFERED_SUBSCRIBERS',
                                    'GV$SESSION',
                                    'GV$SQLAREA_PLAN_HASH',
                                    'GV_$SQLAREA_PLAN_HASH',
                                    'GV$DELETED_OBJECT',
                                    'GV$MUTEX_SLEEP_HISTORY',
                                    'GV$LOGMNR_SESSION',
                                    'GV$RECOVERY_FILE_DEST',
                                    'GV$FLASH_RECOVERY_AREA_USAGE',
                                    'GV$ACTIVE_SESSION_HISTORY',
                                    'GV$BUFFERED_SUBSCRIBERS',
                                    'GV$RESTORE_POINT',
                                    'GV$SGA_TARGET_ADVICE',
                                    'DBMS_RCVMAN',
				    'GV$SQL',
                                    'RMJVM',
                                    'DBMS_ALERT',
				    'DBMS_SHARED_POOL',
                                    'MGMT_RESPONSE',
                                    'MGMT_RESPONSE_BASELINE',   
				    'GV$SQLAREA',  
				    'V$SQLAREA', 
                                    'GV$SQLSTATS',
                                    'V$SQLSTATS',
                                    'V$ASM_DISK',
                                    'GV$IOSTAT_FILE',
		            	    'V$PROPAGATION_RECEIVER',
				    'GV$PROPAGATION_RECEIVER',
                                    'V$STREAMS_CAPTURE','GV$STREAMS_CAPTURE',
                                    'V$BUFFERED_QUEUES' ,
                                    'GV$STREAMS_APPLY_COORDINATOR',
				    '_DBA_STREAMS_COMPONENT',
				    '_DBA_STREAMS_COMPONENT_LINK',
				    '_DBA_STREAMS_COMPONENT_EVENT',
                                    'V$PROPAGATION_SENDER',
                                    'GV$PROPAGATION_SENDER',
                                    'V$STREAMS_APPLY_COORDINATOR',
                                    'DBMS_STREAMS_ADV_ADM_UTL',
				    'GV$BUFFERED_QUEUES',
                                    'GV$RSRCMGRMETRIC_HISTORY',
                                    'GV$RSRC_CONSUMER_GROUP',
                                    'GV$RSRCMGRMETRIC',
                                    'GV$RSRC_CONS_GROUP_HISTORY',
                                    'V$RSRC_CONS_GROUP_HISTORY',
                                    'V$RSRCMGRMETRIC_HISTORY',
                                    'V$RSRC_CONSUMER_GROUP',
                                    'V$RSRCMGRMETRIC',
				    'GV$EVENT_HISTOGRAM',
				    'V$EVENT_HISTOGRAM',
			            'DBMS_FEATURE_RMAN_ZLIB', 
                                    'V$BACKUP_DATAFILE',
				    'GV$BACKUP_DATAFILE', 
				    'DBMS_ASH_INTERNAL',
				    'V$SQL',
                                    'GV$IOSTAT_FUNCTION',
                                    'GV_$IOSTAT_FUNCTION'
                                   ) and referenced_type in ('VIEW','PACKAGE')
                                  CONNECT BY
                                    PRIOR name = referenced_name and 
                                    PRIOR type = referenced_type); 
      END IF;
        invalid_objs := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- create a table to store invalid objects (create it if necessary)
   BEGIN
      BEGIN
         -- Drop the table first, just catch the 942 error and ignore
         EXECUTE IMMEDIATE
            'DROP TABLE registry$sys_inv_objs';
     EXCEPTION WHEN NO_SUCH_TABLE THEN NULL;
     END;
    
     -- Create invalid objects table and populate with all SYS and SYSTEM
     -- invalid objects
     EXECUTE IMMEDIATE 
           'CREATE TABLE registry$sys_inv_objs
              AS
            select owner,object_name,object_type
  		from dba_objects 
                where status !=''VALID'' AND owner in (''SYS'',''SYSTEM'') 
                order by owner';

     -- If there are less than 5000 non-sys invalid objects then create 
     -- another table with non-SYS/SYSTEM owned objects.
     -- If there are more than 5000 total then that is too many
     -- for utluiobj.sql to handle so output a message.
     SELECT count(*) INTO nonsys_invalid_objs  
            from dba_objects 
            where status !='VALID' AND owner NOT in ('SYS','SYSTEM');
     IF nonsys_invalid_objs > 5000 THEN
        warning_5000 := TRUE;
     ELSE
        BEGIN
           -- Drop the table first, just catch the 942 error and ignore
           EXECUTE IMMEDIATE
                 'DROP TABLE registry$nonsys_inv_objs';
        EXCEPTION WHEN NO_SUCH_TABLE THEN NULL;
        END;

        -- Populate the non-sys invalid objects table with non-SYS/SYSTEM
        -- owned objects
        EXECUTE IMMEDIATE
           'CREATE TABLE registry$nonsys_inv_objs AS                 
             select owner,object_name,object_type
  		from dba_objects 
                where status !=''VALID'' AND 
                      owner NOT in (''SYS'',''SYSTEM'')
                order by owner';
        COMMIT;
     END IF;                     
   END;

   -- Check for externally authenticated SSL users
   BEGIN
      IF dbv IN (920,101) THEN
         SELECT NULL INTO p_null FROM sys.user$ 
         WHERE ext_username IS NOT NULL AND 
               password = 'GLOBAL' and rownum <=1;
         ssl_users := TRUE;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- determine timezone_old / timezone_new
   IF dbv != 111 THEN
     IF db_tz_version < utlu_tz_version THEN
       timezone_old := TRUE;
     ELSIF  db_tz_version > utlu_tz_version THEN
       timezone_new := TRUE;
     END IF;
   END IF;


   -- Check for stale statistics
   IF dbv != 111 THEN
     FOR i IN 1..max_comps LOOP 
       IF cmp_info(i).processed and NOT cmp_info(i).install THEN
         p_count:=0;
         IF cmp_info(i).schema IS NOT NULL THEN
             EXECUTE IMMEDIATE '
               declare
                  p_otab dbms_stats.ObjectTab;
                  p_count NUMBER;
               begin
                  dbms_stats.gather_schema_stats(''' || cmp_info(i).schema ||
                        ''', options=>''list auto'', objlist=>p_otab);
                  p_count := 0;
                  for i in 1..p_otab.count loop
                    if p_otab(i).objname not like ''SYS_%'' 
                         and p_otab(i).objname not in (
                              ''CLU$'',''COL_USAGE$'',''FET$'',''INDPART$'',
                              ''MON_MODS$'',''TABPART$'',''HISTGRM$'',
                              ''MON_MODS_ALL$'',
                              ''HIST_HEAD$'',''IND$'',''TAB$'',
                              ''WRI$_OPTSTAT_OPR'',''PUIU$DATA'',
                              ''XDB$NLOCKS_CHILD_NAME_IDX'',
                              ''XDB$NLOCKS_PARENT_OID_IDX'',
                              ''XDB$NLOCKS_RAWTOKEN_IDX'', ''XDB$SCHEMA_URL'',
                              ''XDBHI_IDX'', ''XDB_PK_H_LINK'') THEN
                      p_count:= 1;
                      exit;
                    end if;
                  end loop;
                  :count := p_count;
               end;'
            USING OUT p_count;
            IF (p_count > 0) THEN
               stale_stats := TRUE;
               EXIT;  -- find just one schema
           END IF;
         END IF;
       END IF;
     END LOOP;
   END IF;

   -- if statistics are stale, add space for statistics gathering
   IF stale_stats THEN
      cmp_info(stats).processed := TRUE;
   END IF;

   -- if EM is in the database then set em_exists to TRUE
   IF cmp_info(em).processed and dbv != 111 THEN
      em_exists := TRUE;
  END IF;

   -- ensure that all snapshot/mv refreshes are successfully completed
   BEGIN
    SELECT NULL INTO p_null FROM obj$ o, user$ u, sum$ s 
                    WHERE o.obj# = s.obj# AND 
                          o.owner# = u.user# AND 
                          o.type# = 42 AND bitand(s.mflags, 8) = 8 AND
                          rownum <=1;
      snapshot_refresh:= TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for files that need media recovery
   BEGIN
      SELECT NULL INTO p_null FROM v$recover_file WHERE rownum <=1;
         recovery_files := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for files that are in backup mode
   BEGIN
      SELECT NULL INTO p_null FROM v$backup 
         WHERE status != 'NOT ACTIVE' AND rownum <=1;
         files_backup_mode := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;
   
   -- Check for pending distribution txns
   BEGIN
      SELECT NULL INTO p_null FROM dba_2pc_pending WHERE rownum <=1;
       pending_2pc_txn   := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

   -- Check for standby environment to warn that standby database needs sync
   BEGIN
     SELECT NULL INTO p_null FROM v$parameter
      WHERE name like 'log_archive_dest%' AND upper(value) LIKE 'SERVICE%'
         AND rownum <=1;
       sync_standby_db   := TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
   END;

-- *****************************************************************
-- Collect SYSAUX Information for Warnings
-- *****************************************************************

   IF dbv = 920 THEN
      BEGIN
        SELECT NULL INTO p_null FROM DBA_TABLESPACES
        WHERE tablespace_name = 'SYSAUX';
        -- SYSAUX already exists, so check attributes
        sysaux_exists := TRUE;

     -- permanent
        BEGIN 
           SELECT NULL INTO p_null FROM DBA_TABLESPACES
           WHERE tablespace_name = 'SYSAUX' AND
                 CONTENTS != 'PERMANENT';
           sysaux_not_perm := TRUE;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN NULL;
        END;

     -- online
        BEGIN
           SELECT NULL INTO p_null FROM DBA_TABLESPACES
           WHERE tablespace_name = 'SYSAUX' AND
                 STATUS != 'ONLINE';
           sysaux_not_online := TRUE;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN NULL;
        END;
 
     -- local extent management
        BEGIN
           SELECT NULL INTO p_null FROM DBA_TABLESPACES
           WHERE tablespace_name = 'SYSAUX' AND
                 extent_management != 'LOCAL';
           sysaux_not_local := TRUE;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN NULL;
        END;

     -- auto segment space management
        BEGIN 
           EXECUTE IMMEDIATE 'SELECT NULL FROM DBA_TABLESPACES
           WHERE tablespace_name = ''SYSAUX'' AND
                 segment_space_management != ''AUTO'''
           INTO p_null;
           sysaux_not_auto := TRUE;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN NULL;
        END;

      EXCEPTION -- No SYSAUX tablespace
         WHEN NO_DATA_FOUND THEN NULL;
      END;
   END IF; 

-- *****************************************************************
-- END of Collect Section
-- *****************************************************************

-- *****************************************************************
-- START of Calculate Section
-- *****************************************************************

-- *****************************************************************
-- Calculate Tablespace Requirements
-- *****************************************************************

    -- Look at all relevant tablespaces
   FOR t IN 1..max_ts LOOP
       delta_kbytes:=0;   -- initialize calculated tablespace delta

       IF ts_info(t).name = 'SYSTEM' THEN -- sum the component SYS kbytes
          FOR i IN 1..max_comps LOOP
              IF cmp_info(i).processed THEN
                 IF cmp_info(i).install THEN
                    delta_kbytes := delta_kbytes + cmp_info(i).ins_sys_kbytes;
                    IF collect_diag THEN
                       dbms_output.put_line('DIAG-CMPTS: SYS    ' || 
                             LPAD(cmp_info(i).cid, 10) || ' ' ||
                             LPAD(cmp_info(i).ins_sys_kbytes,10));   
                    END IF;
                 ELSE
                    delta_kbytes := delta_kbytes + cmp_info(i).sys_kbytes;
                    IF collect_diag THEN
                       dbms_output.put_line('DIAG-CMPTS: SYS    ' || 
                                LPAD(cmp_info(i).cid, 10) || ' ' ||
                                LPAD(cmp_info(i).sys_kbytes,10));
                    END IF;
                 END IF;
              END IF;
           END LOOP;
        END IF;  -- end of special SYSTEM tablespace processing

        IF ts_info(t).name = 'SYSAUX' THEN -- sum the component SYSAUX kbytes
          FOR i IN 1..max_comps LOOP
              IF cmp_info(i).processed THEN
                 delta_kbytes := delta_kbytes + cmp_info(i).sysaux_kbytes;
                 IF collect_diag THEN
                    dbms_output.put_line('DIAG-CMPTS: SYSAUX ' || 
                             LPAD(cmp_info(i).cid, 10) || ' ' ||
                             LPAD(cmp_info(i).sysaux_kbytes,10));
                 END IF;
              END IF;
           END LOOP;
        END IF;  -- end of special SYSAUX tablespace processing

        -- Now add in component default tablespace deltas
        -- def_tablespace_name is NULL for unprocessed comps
        FOR i IN 1..max_comps LOOP 
           IF ts_info(t).name = cmp_info(i).def_ts AND
              cmp_info(i).processed THEN
              IF cmp_info(i).install THEN  -- use install amount
                 delta_kbytes := delta_kbytes + cmp_info(i).ins_def_kbytes;
                 IF collect_diag THEN
                    dbms_output.put_line('DIAG-CMPTS: ' || 
                           RPAD(ts_info(t).name, 10) ||
                           LPAD(cmp_info(i).cid, 10) || ' ' ||
                           LPAD(cmp_info(i).ins_def_kbytes,10));   
                 END IF;
              ELSE  -- use default tablespace amount
                 delta_kbytes :=  delta_kbytes + cmp_info(i).def_ts_kbytes;
                 IF collect_diag THEN
                    dbms_output.put_line('DIAG-CMPTS: ' || 
                             RPAD(ts_info(t).name, 10) ||
                             LPAD(cmp_info(i).cid, 10) || ' ' ||
                             LPAD(cmp_info(i).def_ts_kbytes,10));
                    update_puiu_data('SCHEMA', 
                             ts_info(t).name || '-' || cmp_info(i).schema,
                             cmp_info(i).def_ts_kbytes);
                 END IF;
              END IF;
           END IF;
        END LOOP; -- end of default tablespace calculations 

        -- Now look for queues in user schemas
        SELECT count(*) INTO delta_queues 
        FROM dba_tables tb, dba_queues q
        WHERE q.queue_table = tb.table_name AND
              tb.tablespace_name = ts_info(t).name AND tb.owner NOT IN
              ('SYS','SYSTEM','MDSYS','ORDSYS','OLAPSYS','XDB',
               'LBACSYS','CTXSYS','ODM','DMSYS', 'WKSYS','WMSYS',
               'SYSMAN','EXFSYS');
        IF delta_queues > 0 THEN
           IF collect_diag THEN
              dbms_output.put_line('DIAG-QUES: ' || 
                          RPAD(ts_info(t).name, 10) ||
                          ' QUEUE count = ' || delta_queues);
           END IF;
           -- estimate 48K per queue
           delta_kbytes := delta_kbytes + delta_queues*48; 
        END IF;

        -- See if this is the temporary tablespace for SYS
        IF ts_is_SYS_temporary(ts_info(t).name) THEN
           delta_kbytes := delta_kbytes + 50*1024;  -- Add 50M for TEMP
        END IF;

        -- See if this is the UNDO tablespace - be sure 400M available
        IF ts_info(t).name = db_undo_tbs AND
           ts_info(t).alloc < (400*1024) THEN
              delta_kbytes := delta_kbytes + ((400 * 1024) - ts_info(t).alloc);
        END IF;

        -- If DBUA output, then add in EM install if not in database
        IF display_XML THEN  
           IF NOT cmp_info(em).processed THEN
              IF ts_info(t).name = 'SYSTEM' THEN 
                 delta_kbytes := delta_kbytes + cmp_info(em).ins_sys_kbytes;
              ELSIF ts_info(t).name = 'SYSAUX' THEN
                 delta_kbytes := delta_kbytes + cmp_info(em).ins_def_kbytes;
              END IF;
           END IF;
        END IF;

        -- Put a 20% safety factor on DELTA and round it off
        delta_kbytes := ROUND(delta_kbytes*1.20);            

        -- Finally, save DELTA value
        ts_info(t).delta := delta_kbytes;

        -- Recomendation for minimum tablespace size is
        -- the "delta" plus existing in use amount
        ts_info(t).min   := ts_info(t).inuse + ts_info(t).delta;
   
        IF collect_diag THEN
           DBMS_OUTPUT.PUT_LINE('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                              ' used =    ' || LPAD(ts_info(t).inuse,10));
           DBMS_OUTPUT.PUT_LINE('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                              ' delta=    ' || LPAD(ts_info(t).delta,10));
           DBMS_OUTPUT.PUT_LINE('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                              ' total req=' || LPAD(ts_info(t).min,10));
           DBMS_OUTPUT.PUT_LINE('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                           '    alloc=      ' || LPAD(ts_info(t).alloc,10));
           DBMS_OUTPUT.PUT_LINE('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                           '    auto_avail= ' || LPAD(ts_info(t).auto,10));
           DBMS_OUTPUT.PUT_LINE('DIAG-TS: ' || RPAD(ts_info(t).name,10) || 
                           '    total avail=' ||  LPAD(ts_info(t).avail,10));
        END IF;

        -- put calculated delta into puiu$data if it exists
        update_puiu_data('TABLESPACE', ts_info(t).name, delta_kbytes);

        -- convert to MB and round up(min required)/down (alloc and avail)
        ts_info(t).min :=   ROUND((ts_info(t).min+512)/1024);
        ts_info(t).alloc := ROUND((ts_info(t).alloc-512)/1024);
        ts_info(t).avail := ROUND((ts_info(t).avail-512)/1024);

        -- Determine amount of additional space needed
        -- independent of autoextend on/off
        IF ts_info(t).min > ts_info(t).alloc THEN
           ts_info(t).addl  := ts_info(t).min - ts_info(t).alloc;
        ELSE
           ts_info(t).addl := 0;
        END IF;

        -- Do we have enough space in the existing tablespace?
        IF ts_info(t).min < ts_info(t).avail  THEN
           ts_info(t).inc_by := 0;
        ELSE
           -- need to add space
           ts_info(t).inc_by := ts_info(t).min - ts_info(t).avail; 
        END IF;

        -- Find a file in the tablespace with autoextend on
        -- DBUA will use this information to add to autoextend
        -- or to check for total space on disk
        IF ts_info(t).addl > 0 OR ts_info(t).inc_by > 0 THEN
           ts_info(t).fauto := FALSE;
           IF ts_info(t).temporary AND
              ts_info(t).localmanaged THEN
              FOR f IN (SELECT file_name, autoextensible 
                        FROM dba_temp_files
                        WHERE tablespace_name = ts_info(t).name) LOOP
                  IF f.autoextensible= 'YES' THEN
                     ts_info(t).fname := f.file_name;
                     ts_info(t).fauto := TRUE;
                     EXIT;
                  END IF;
              END LOOP;
           ELSE
              FOR f IN (SELECT file_name, autoextensible 
                        FROM dba_data_files
                        WHERE tablespace_name = ts_info(t).name) LOOP
                  IF f.autoextensible= 'YES' THEN
                     ts_info(t).fname := f.file_name;
                     ts_info(t).fauto := TRUE;
                     EXIT;
                  END IF;
              END LOOP;
           END IF;
        END IF;
    END LOOP;  -- end of tablespace loop

-- *****************************************************************
-- Calculate SYSAUX Requirements for pre-10.1 databases
-- *****************************************************************

   delta_sysaux := 0;

   IF dbv = 920 THEN
   -- sum the component SYSAUX usage for earlier releases
      FOR i IN 1..max_comps LOOP
         IF cmp_info(i).processed THEN -- add upgrade amount
            delta_sysaux := delta_sysaux + cmp_info(i).sysaux_kbytes;
            IF collect_diag THEN
               dbms_output.put_line('DIAG-CMPTS:  SYSAUX ' || 
                                  LPAD(cmp_info(i).cid, 10) || ' ' ||
                                  LPAD(cmp_info(i).sysaux_kbytes,10));   
            END IF;
         END IF;
         IF cmp_info(i).install AND 
            cmp_info(i).def_ts = 'SYSAUX' THEN  -- add def_ts install amount also
            delta_sysaux := delta_sysaux + cmp_info(i).ins_def_kbytes;
            IF collect_diag THEN
               dbms_output.put_line('DIAG-CMPTS:  SYSAUX ' || 
                      LPAD(cmp_info(i).cid, 10) || ' ' ||
                      LPAD(cmp_info(i).ins_def_kbytes,10));   
            END IF;
         END IF;
       END LOOP;

       -- Add a base of 62000 bytes to our calculation
       delta_sysaux := delta_sysaux + 62000;

       IF collect_diag THEN
           DBMS_OUTPUT.PUT_LINE('DIAG-TS:   SYSAUX' || 
                              ' total req=' || LPAD(delta_sysaux,10));
       END IF;

    -- Put a 500MB (512000KB) floor on delta_sysaux
       IF delta_sysaux < 512000 THEN
          delta_sysaux := 512000;
       END IF;
   ELSE  -- SYSAUX handled as existing tablespace
     delta_sysaux := 0;
   END IF;

   delta_sysaux := ROUND(delta_sysaux/1024); -- convert to MB

-- *****************************************************************
-- END of Calculate Section
-- *****************************************************************

-- *****************************************************************
-- START of Display Section
-- *****************************************************************

   IF display_xml THEN
      DBMS_OUTPUT.PUT_LINE('<RDBMSUP version="' || utlu_version || '">');
      DBMS_OUTPUT.PUT_LINE(
          '<SupportedOracleVersions value="9.2.0, 10.1.0, 10.2.0, 11.1.0"/>');
      DBMS_OUTPUT.PUT_LINE(   
         '<OracleVersion value ="'|| vers || '"/>'); 
      display_database;
      display_parameters;
      display_components;
      display_tablespaces;
      display_misc_warnings;
      DBMS_OUTPUT.PUT_LINE('</RDBMSUP>');
   ELSE
      display_header;
      display_database;
      IF dbv = 920 THEN  -- database not upgraded yet
         display_logfiles;
      END IF;
      display_tablespaces;
      display_rollback_segs;
      display_parameters;
      display_components;
      display_misc_warnings;
      IF dbv = 920 THEN
         display_sysaux;
      END IF;
   END IF;

-- *****************************************************************
-- END of Display Section
-- *****************************************************************

END;
/

SET SERVEROUTPUT OFF

-- *****************************************************************
-- END utlu111i.sql
-- *****************************************************************
