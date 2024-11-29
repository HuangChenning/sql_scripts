-- &1 owner
-- &2 date  1310，当前月
-- ACCT_ITEM_OWE 导入的目标表是上月
-- 其他4张表导入的目标库是本月


-- A区
-- @impstat.sql ACCT_DY  1310
-- @impstat.sql ACCT_GZ  1310
-- @impstat.sql ACCT_MY  1310
-- @impstat.sql ACCT_GA  1310
-- @impstat.sql ACCT_YB  1310
-- @impstat.sql ACCT_NC  1310
-- @impstat.sql ACCT_AB  1310
-- @impstat.sql ACCT_ZY  1310
-- @impstat.sql ACCT_LES 1310
-- @impstat.sql ACCT_NJ  1310
-- @impstat.sql ACCT_MS  1310
-- @impstat.sql ACCT_YA  1310
-- @impstat.sql ACCT_ZG  1310
-- @impstat.sql ACCT_LZ  1310
-- 
-- 
-- B区
-- @impstat.sql ACCT_CD  1310
-- @impstat.sql ACCT_LS  1310
-- @impstat.sql ACCT_SN  1310
-- @impstat.sql ACCT_PZH 1310
-- @impstat.sql ACCT_BZ  1310
-- @impstat.sql ACCT_GY  1310
-- @impstat.sql ACCT_DZ  1310

SET VERIFY OFF
SET FEEDBACK ON
set linesize 170 pagesize 999
col owner for a10

---------------------------------------------------------------------------------------------------
exec dbms_stats.CREATE_STAT_TABLE('SYSTEM','OLM_STAT_TABLE');
exec dbms_stats.export_table_stats('&&1','PAYMENT_11308',stattab=>'OLM_STAT_TABLE',statown=>'SYSTEM',cascade=>true);

update system.OLM_STAT_TABLE set c1='PAYMENT_1&&2' where c1='PAYMENT_11308';
update system.olm_stat_table set c1='IDX_PAYMENT_&2'||'_O_P_S_N'      where c1='IDX_PAYMENT_1308_O_P_S_N'     ; 
update system.olm_stat_table set c1='IDX_PAYMENT_&2'||'_S_C'          where c1='IDX_PAYMENT_1308_S_C'         ; 
update system.olm_stat_table set c1='IDX_PAYMENT_&2'||'_S_S'          where c1='IDX_PAYMENT_1308_S_S'         ; 
update system.olm_stat_table set c1='IDX_PAYMENT_&2'||'_STATE_DATE'   where c1='IDX_PAYMENT_1308_STATE_DATE'  ; 
update system.olm_stat_table set c1='IDX_PAYMENT_&2'||'_C_DATE'       where c1='IDX_PAYMENT_1308_C_DATE'      ; 
update system.olm_stat_table set c1='IDX_PAYMENT_&2'||'_P_METHOD'     where c1='IDX_PAYMENT_1308_P_METHOD'    ; 
update system.olm_stat_table set c1='IDX_PAYMENT_&2'||'_P_DATE'       where c1='IDX_PAYMENT_1308_P_DATE'      ; 
update system.olm_stat_table set c1='IDX_PAYMENT_&2'||'_PAYED_METHOD' where c1='IDX_PAYMENT_1308_PAYED_METHOD'; 
update system.olm_stat_table set c1='IDX_PAYMENT_&2'||'_ACCT_ID'      where c1='IDX_PAYMENT_1308_ACCT_ID'     ; 
update system.olm_stat_table set c1='PK_PAYMENT_1&2'||''              where c1='PK_PAYMENT_11308'             ; 
update system.olm_stat_table set c1='IDX_PAYMENT_1&2'||'_001'         where c1='IDX_PAYMENT_11308_001'        ;     
commit;

exec dbms_stats.import_table_stats('&1','PAYMENT_1&2',stattab=>'OLM_STAT_TABLE',statown=>'SYSTEM',cascade=>true);
exec dbms_stats.DROP_STAT_TABLE('SYSTEM','OLM_STAT_TABLE');

select owner,table_name,NUM_ROWS,USER_STATS,LAST_ANALYZED from dba_tables
where table_name = 'PAYMENT_1&2' and owner='&1';           
select owner,table_name,index_name,NUM_ROWS,USER_STATS,LAST_ANALYZED from dba_indexes
where table_name = 'PAYMENT_1&2' and owner='&1'                        
order by 2,3;       

---------------------------------------------------------------------------------------------------
exec dbms_stats.CREATE_STAT_TABLE('SYSTEM','OLM_STAT_TABLE');
exec dbms_stats.export_table_stats('&1','BILL_11308',stattab=>'OLM_STAT_TABLE',statown=>'SYSTEM',cascade=>true);

update system.OLM_STAT_TABLE set c1='BILL_1&2' where c1='BILL_11308';
update system.olm_stat_table set c1='PK_BILL_1&2'||''            where c1='PK_BILL_11308'           ;
update system.olm_stat_table set c1='IDX_BILL_1&2'||'_001'       where c1='IDX_BILL_11308_001'      ;
update system.olm_stat_table set c1='IDX_BILL_&2'||'_PAYMENT_ID' where c1='IDX_BILL_1308_PAYMENT_ID';
update system.olm_stat_table set c1='IDX_BILL_&2'||'_ACCT_ID'    where c1='IDX_BILL_1308_ACCT_ID'   ;
update system.olm_stat_table set c1='IDX_BILL_&2'||'_C_DATE'     where c1='IDX_BILL_1308_C_DATE'    ;
update system.olm_stat_table set c1='IDX_BILL_&2'||'_P_METHOD'   where c1='IDX_BILL_1308_P_METHOD'  ;
update system.olm_stat_table set c1='IDX_BILL_&2'||'_SERV_ID'    where c1='IDX_BILL_1308_SERV_ID'   ;
update system.olm_stat_table set c1='IDX_BILL_&2'||'_STAFF_ID'   where c1='IDX_BILL_1308_STAFF_ID'  ;
update system.olm_stat_table set c1='IDX_BILL_&2'||'_B_CYCLE_ID' where c1='IDX_BILL_1308_B_CYCLE_ID';   
commit;

exec dbms_stats.import_table_stats('&1','BILL_1&2',stattab=>'OLM_STAT_TABLE',statown=>'SYSTEM',cascade=>true);
exec dbms_stats.DROP_STAT_TABLE('SYSTEM','OLM_STAT_TABLE');

select owner,table_name,NUM_ROWS,USER_STATS,LAST_ANALYZED from dba_tables
where table_name = 'BILL_1&2' and owner='&1';           
select owner,table_name,index_name,NUM_ROWS,USER_STATS,LAST_ANALYZED from dba_indexes
where table_name = 'BILL_1&2' and owner='&1'                        
order by 2,3;     

---------------------------------------------------------------------------------------------------
exec dbms_stats.CREATE_STAT_TABLE('SYSTEM','OLM_STAT_TABLE');
exec dbms_stats.export_table_stats('&1','A_BILL_OWE_11308',stattab=>'OLM_STAT_TABLE',statown=>'SYSTEM',cascade=>true);

update system.OLM_STAT_TABLE set c1='A_BILL_OWE_1&2' where c1='A_BILL_OWE_11308';
update system.olm_stat_table set c1='PK_A_BILL_OWE_1&2'||''       where c1='PK_A_BILL_OWE_11308'      ;
update system.olm_stat_table set c1='IDX_BILL_OWE_&2'||'_ACCT_ID' where c1='IDX_BILL_OWE_1308_ACCT_ID';
update system.olm_stat_table set c1='IDX_BILL_OWE_&2'||'_SERV_ID' where c1='IDX_BILL_OWE_1308_SERV_ID';
update system.olm_stat_table set c1='IDX_BILL_OWE_&2'||'_S_D'     where c1='IDX_BILL_OWE_1308_S_D'    ;
update system.olm_stat_table set c1='IDX_BILL_OWE_&2'||'_BILL_ID' where c1='IDX_BILL_OWE_1308_BILL_ID';
update system.olm_stat_table set c1='IDX_BILL_OWE_&2'||'_A_I'     where c1='IDX_BILL_OWE_1308_A_I'    ;  
commit;

exec dbms_stats.import_table_stats('&1','A_BILL_OWE_1&2',stattab=>'OLM_STAT_TABLE',statown=>'SYSTEM',cascade=>true);
exec dbms_stats.DROP_STAT_TABLE('SYSTEM','OLM_STAT_TABLE');

select owner,table_name,NUM_ROWS,USER_STATS,LAST_ANALYZED from dba_tables
where table_name = 'A_BILL_OWE_1&2' and owner='&1';           
select owner,table_name,index_name,NUM_ROWS,USER_STATS,LAST_ANALYZED from dba_indexes
where table_name = 'A_BILL_OWE_1&2' and owner='&1'                        
order by 2,3;    

---------------------------------------------------------------------------------------------------
exec dbms_stats.CREATE_STAT_TABLE('SYSTEM','OLM_STAT_TABLE');
exec dbms_stats.export_table_stats('&1','BALANCE_ACCT_ITEM_PAYED_11308',stattab=>'OLM_STAT_TABLE',statown=>'SYSTEM',cascade=>true);

update system.OLM_STAT_TABLE set c1='BALANCE_ACCT_ITEM_PAYED_1&2' where c1='BALANCE_ACCT_ITEM_PAYED_11308';
update system.olm_stat_table set c1='IDX_B_A_I_P_PAYOUT_ID_1&2'||'' where c1='IDX_B_A_I_P_PAYOUT_ID_11308';
update system.olm_stat_table set c1='IDX_B_A_I_P_ITEM_ID_1&2'||''   where c1='IDX_B_A_I_P_ITEM_ID_11308'  ;
commit;

exec dbms_stats.import_table_stats('&1','BALANCE_ACCT_ITEM_PAYED_1&2',stattab=>'OLM_STAT_TABLE',statown=>'SYSTEM',cascade=>true);
exec dbms_stats.DROP_STAT_TABLE('SYSTEM','OLM_STAT_TABLE');

select owner,table_name,NUM_ROWS,USER_STATS,LAST_ANALYZED from dba_tables
where table_name = 'BALANCE_ACCT_ITEM_PAYED_1&2' and owner='&1';           
select owner,table_name,index_name,NUM_ROWS,USER_STATS,LAST_ANALYZED from dba_indexes
where table_name = 'BALANCE_ACCT_ITEM_PAYED_1&2' and owner='&1'                        
order by 2,3;    

---------------------------------------------------------------------------------------------------
col mon new_value mon noprint
select to_char(add_months(to_date('&2','yymm'),-1),'yymm') mon from dual;

exec dbms_stats.CREATE_STAT_TABLE('SYSTEM','OLM_STAT_TABLE');
exec dbms_stats.export_table_stats('&1','ACCT_ITEM_OWE_11308',stattab=>'OLM_STAT_TABLE',statown=>'SYSTEM',cascade=>true);

update system.OLM_STAT_TABLE set c1='ACCT_ITEM_OWE_1&mon' where c1='ACCT_ITEM_OWE_11308';
update system.OLM_STAT_TABLE set c1='IDX_ACCT_ITEM_1&mon'||'_ACCT_STATE' where c1='IDX_ACCT_ITEM_11308_ACCT_STATE';
update system.OLM_STAT_TABLE set c1='IDX_ACCT_ITEM_OWE_&mon'||'_ACCT_ID' where c1='IDX_ACCT_ITEM_OWE_1308_ACCT_ID';
update system.OLM_STAT_TABLE set c1='IDX_ACCT_ITEM_OWE_&mon'||'_A_I' where c1='IDX_ACCT_ITEM_OWE_1308_A_I';    
update system.OLM_STAT_TABLE set c1='IDX_ACCT_ITEM_OWE_&mon'||'_BILL_ID' where c1='IDX_ACCT_ITEM_OWE_1308_BILL_ID';
update system.OLM_STAT_TABLE set c1='IDX_ACCT_ITEM_OWE_&mon'||'_SERV_ID' where c1='IDX_ACCT_ITEM_OWE_1308_SERV_ID';
update system.OLM_STAT_TABLE set c1='IDX_ACCT_ITEM_OWE_&mon'||'_S_D' where c1='IDX_ACCT_ITEM_OWE_1308_S_D';    
update system.OLM_STAT_TABLE set c1='PK_ACCT_ITEM_OWE_1&mon' where c1='PK_ACCT_ITEM_OWE_11308';        
commit;

exec dbms_stats.import_table_stats('&1','ACCT_ITEM_OWE_1&mon',stattab=>'OLM_STAT_TABLE',statown=>'SYSTEM',cascade=>true);
exec dbms_stats.DROP_STAT_TABLE('SYSTEM','OLM_STAT_TABLE');

select owner,table_name,NUM_ROWS,USER_STATS,LAST_ANALYZED from dba_tables
where table_name = 'ACCT_ITEM_OWE_1&mon' and owner='&1';           
select owner,table_name,index_name,NUM_ROWS,USER_STATS,LAST_ANALYZED from dba_indexes
where table_name = 'ACCT_ITEM_OWE_1&mon' and owner='&1'                        
order by 2,3;                              

undefine 1
undefine 2
undefine mon


