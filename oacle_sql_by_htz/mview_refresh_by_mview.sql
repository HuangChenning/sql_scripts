set echo off
set lines 200
set pages 40
set verify off
set heading on
PROMPT '-------------------------------------------------------------------------------------'
PROMPT 'C   COMPLETEָ�����ˢ��                                                             '
PROMPT 'F  FAST ָ������ˢ�£�ֻ��ˢ��LOCAL MVIEW�����ҵ�����־                              '
PROMPT 'P  FAST_PCT Refreshes by recomputing the rows in the materialized                    '
PROMPT '   view affected by changed partitions in the detail tables.                         '
PROMPT '?  FORCEAttempts a fast refresh. If that is not possible, it does a complete refresh.'
PROMPT '-------------------------------------------------------------------------------------'
PROMPT 'mview_owner_list����schema.mview_name,schme.mview_name,���mview��,����--------------'
exec dbms_mview.refresh(upper('&mview_owner_list'),'&refresh_mode');

