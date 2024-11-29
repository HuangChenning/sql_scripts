set heading on pages 1000  lines 10000  verify off                                                                                                                                                  
col sql_text for a131
col num for 99999999999
col sql_id for a17   
col pert for a6
col mem_m for 99999
undefine count_number                                                                                                           
--select 'select sql_text from v$sql where FORCE_MATCHING_SIGNATURE=' ||
--       FORCE_MATCHING_SIGNATURE || ' and rownum=1;' sql,
--       count(1)
--  from v$sql
-- where FORCE_MATCHING_SIGNATURE > 0
--   and FORCE_MATCHING_SIGNATURE != EXACT_MATCHING_SIGNATURE
-- group by FORCE_MATCHING_SIGNATURE
--having count(1) > &count_number
-- order by 2;  
 
  SELECT t_count num,
         ROUND ( (t_count / total), 4) * 100 || '%' PERT,
         TRUNC (m_sum / 1024 / 1024) mem_m,
         sql_id,
         SUBSTR (sql_text, 1, 130) sql_text
    FROM (SELECT sql_text,
                 sql_id,
                 FORCE_MATCHING_SIGNATURE,
                 COUNT (*) OVER (PARTITION BY FORCE_MATCHING_SIGNATURE) t_count,
                 SUM (SHARABLE_MEM)
                    OVER (PARTITION BY FORCE_MATCHING_SIGNATURE)
                    m_sum,
                 COUNT (*) OVER () total,
                 ROW_NUMBER ()
                 OVER (PARTITION BY FORCE_MATCHING_SIGNATURE ORDER BY sql_id)
                    t_row
            FROM gv$sqlarea a
           WHERE     FORCE_MATCHING_SIGNATURE > 0
                 AND FORCE_MATCHING_SIGNATURE != EXACT_MATCHING_SIGNATURE)
   WHERE t_count > &count_number AND t_row = 1
ORDER BY t_count;
undefine count_number  