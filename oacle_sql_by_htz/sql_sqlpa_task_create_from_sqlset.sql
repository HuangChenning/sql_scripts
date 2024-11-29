set echo off
set lines 2000 pages 4000 verify off heading on
/* Formatted on 2014/9/12 14:06:13 (QP5 v5.240.12305.39446) */
@sql_sqlset
@db_advisor_task_by_sqlpa.sql
DECLARE
   v_sqlset_name    VARCHAR2 (1000);
   v_basic_filter   VARCHAR2 (1000);
   v_order_by       VARCHAR2 (1000);
   v_top_sql        VARCHAR2 (1000);
   v_task_name      VARCHAR2 (1000);
   v_description    VARCHAR2 (1000);
   v_sqlset_owner   VARCHAR2 (1000);
   v_total          VARCHAR2 (1000);
BEGIN
   v_sqlset_name := '&sqlset_name';
   v_sqlset_owner := NVL (UPPER ('&sqlset_owner'), NULL);
   v_task_name := '&task_name';
   v_description := '&task_desc';
   v_basic_filter := NVL ('&basic_filter', NULL);
   v_order_by := NVL ('&order_by', NULL);
   v_top_sql := NVL ('&top_sql', NULL);
   v_total :=
      DBMS_SQLPA.CREATE_ANALYSIS_TASK (sqlset_name    => v_sqlset_name,
                                       basic_filter   => v_basic_filter,
                                       order_by       => v_order_by,
                                       top_sql        => v_top_sql,
                                       task_name      => v_task_name,
                                       description    => v_description,
                                       sqlset_owner   => v_sqlset_owner);
END;
/
@db_advisor_task_by_sqlpa.sql