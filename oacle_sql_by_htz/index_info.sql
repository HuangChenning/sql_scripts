
SET ECHO        OFF
SET FEEDBACK    OFF
SET HEADING     ON
SET LINESIZE    180
SET PAGESIZE    50000
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
set verify off
PROMPT +------------------------------------------------------------------------+
PROMPT | Calculate Index Fragmentation for a Specified Index                    |
PROMPT +------------------------------------------------------------------------+

PROMPT 
ACCEPT owner prompt 'Enter index name owner : '
ACCEPT index_name CHAR prompt 'Enter index name index_name : '
ACCEPT scinname prompt 'Enter schema and index name (scoot.pkdept) : '
ANALYZE INDEX &scinname VALIDATE STRUCTURE;
 
COLUMN name           HEADING 'Index Name'          FORMAT a30
COLUMN del_lf_rows    HEADING 'Deleted|Leaf Rows'   FORMAT 999,999,999,999,999
COLUMN lf_rows_used   HEADING 'Used|Leaf Rows'      FORMAT 999,999,999,999,999
COLUMN ibadness       HEADING '% Deleted|Leaf Rows' FORMAT 999.99999
 
SELECT
    name
  , del_lf_rows
  , lf_rows - del_lf_rows lf_rows_used
  , TO_CHAR( del_lf_rows /(DECODE(lf_rows,0,0.01,lf_rows))*100,'999.99999') ibadness
FROM   index_stats
/
 
PROMPT 
PROMPT Consider rebuilding any index if % of Deleted Leaf Rows is > 20%
PROMPT 

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display index size for a Specified Index                               |
PROMPT +------------------------------------------------------------------------+
COLUMN NAME FORMAT A15
COLUMN BLOCKS HEADING "ALLOCATED|BLOCKS"
COLUMN LF_BLKS HEADING "LEAF|BLOCKS"
COLUMN BR_BLKS HEADING "BRANCH|BLOCKS"
COLUMN EMPTY HEADING "UNUSED|BLOCKS"
COLUMN TOTAL_SIZE HEADING "TOTAL|SIZE"
COLUMN USER_SIZE HEADING "USED|SIZE"
COLUMN FREE_SIZE HEADING "PCT_USED"


SELECT NAME, BLOCKS, LF_BLKS, BR_BLKS, BLOCKS-(LF_BLKS + BR_BLKS) EMPTY, BTREE_SPACE TOTAL_SIZE, USED_SPACE USER_SIZE , PCT_USED  FROM INDEX_STATS; 


PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Calculate Index Statistics for a Specified Index                       |
PROMPT +------------------------------------------------------------------------+
SET ECHO        OFF
SET FEEDBACK    OFF
SET HEADING     OFF
SET LINESIZE    180
SET PAGESIZE    50000
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
SET VERIFY      OFF

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES
  
COLUMN name                   newline
COLUMN headsep                newline
COLUMN height                 newline
COLUMN blocks                 newline
COLUMN lf_rows                newline
COLUMN lf_blks                newline
COLUMN lf_rows_len            newline
COLUMN lf_blk_len             newline
COLUMN br_rows                newline
COLUMN br_blks                newline
COLUMN br_rows_len            newline
COLUMN br_blk_len             newline
COLUMN del_lf_rows            newline
COLUMN del_lf_rows_len        newline
COLUMN distinct_keys          newline
COLUMN most_repeated_key      newline
COLUMN btree_space            newline
COLUMN used_space               newline
COLUMN pct_used               newline
COLUMN rows_per_key           newline
COLUMN blks_gets_per_access   newline


SELECT  
    name
  , '----------------------------------------------------------------------------'      headsep
  , 'height               ' ||to_char(height,     '999,999,990')                        height
  , 'blocks               ' ||to_char(blocks,     '999,999,990')                        blocks
  , 'del_lf_rows          ' ||to_char(del_lf_rows,'999,999,990')                        del_lf_rows
  , 'del_lf_rows_len      ' ||to_char(del_lf_rows_len,'999,999,990')                    del_lf_rows_len
  , 'distinct_keys        ' ||to_char(distinct_keys,'999,999,990')                      distinct_keys
  , 'most_repeated_key    ' ||to_char(most_repeated_key,'999,999,990')                  most_repeated_key
  , 'btree_space          ' ||to_char(btree_space,'999,999,990')                        btree_space
  , 'used_space           ' ||to_char(used_space,'999,999,990')                         used_space
  , 'pct_used             ' ||to_char(pct_used,'990')                                   pct_used
  , 'rows_per_key         ' ||to_char(rows_per_key,'999,999,990')                       rows_per_key
  , 'blks_gets_per_access ' ||to_char(blks_gets_per_access,'999,999,990')               blks_gets_per_access
  , 'lf_rows              ' ||to_char(lf_rows,    '999,999,990') || '        ' || +  
    'br_rows              ' ||to_char(br_rows,    '999,999,990')                        br_rows
  , 'lf_blks              ' ||to_char(lf_blks,    '999,999,990') || '        ' || +
    'br_blks              ' ||to_char(br_blks,    '999,999,990')                        br_blks
  , 'lf_rows_len          ' ||to_char(lf_rows_len,'999,999,990') || '        ' || +
    'br_rows_len          ' ||to_char(br_rows_len,'999,999,990')                        br_rows_len
  , 'lf_blk_len           ' ||to_char(lf_blk_len, '999,999,990') || '        ' || +
    'br_blk_len           ' ||to_char(br_blk_len, '999,999,990')                        br_blk_len
FROM
  index_stats
/  
  
REM REQUIREMENTS: 
REM    SELECT on DBA_IND_COLUMNS and DBA_INDEXES 
REM ------------------------------------------------------------------------ 
REM PURPOSE: 
REM Shows the index keys for a particular table. 
REM ------------------------------------------------------------------------ 


PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | display schema index name column                                       |
PROMPT +------------------------------------------------------------------------+ 

col uniq    format a10 heading 'Uniqueness'   
col indname format a40 heading 'Index Name'  
col colname format a25 heading 'Column Name'  
 
 
select 
  ind.uniqueness                  uniq, 
  ind.owner||'.'||col.index_name  indname, 
  col.column_name                 colname 
from 
  dba_ind_columns  col, 
  dba_indexes      ind 
where 
  ind.owner = upper('&&owner') 
    and 
  ind.index_name = upper('&&index_name') 
    and 
  col.index_owner = ind.owner  
    and 
  col.index_name = ind.index_name 
order by 
  col.index_name, 
  col.column_position 
/ 
 
set verify on

