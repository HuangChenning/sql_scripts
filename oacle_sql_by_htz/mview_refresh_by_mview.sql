set echo off
set lines 200
set pages 40
set verify off
set heading on
PROMPT '-------------------------------------------------------------------------------------'
PROMPT 'C   COMPLETE指定完成刷新                                                             '
PROMPT 'F  FAST 指定快速刷新，只能刷新LOCAL MVIEW，并且得有日志                              '
PROMPT 'P  FAST_PCT Refreshes by recomputing the rows in the materialized                    '
PROMPT '   view affected by changed partitions in the detail tables.                         '
PROMPT '?  FORCEAttempts a fast refresh. If that is not possible, it does a complete refresh.'
PROMPT '-------------------------------------------------------------------------------------'
PROMPT 'mview_owner_list输入schema.mview_name,schme.mview_name,多个mview用,隔开--------------'
exec dbms_mview.refresh(upper('&mview_owner_list'),'&refresh_mode');

