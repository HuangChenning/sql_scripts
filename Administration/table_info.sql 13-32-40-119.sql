set lines 200
set verify off
set echo off
col owner for a10
col tablename for a25
col ANALYZED for a20
col indexname for a30
col columnname for a20
col bytes for a10
col tablespacename for a15
col temp for a4
col tablespace_name for a20
col index_type for a15
set feedback off
set serveroutput on
set pages 9999
accept table_name prompt 'ENTER YOU TABLE_NAME: ' 
variable i_table_name varchar2(30);
exec :i_table_name :=upper('&table_name');

PROMPT
PROMPT +----------------------------------------------------------------------------+
PROMPT | TABLE INFORMATION********************************************              |
PROMPT +----------------------------------------------------------------------------+

Select  a.Owner Owner,
                         a.Table_Name Tablename,
                         a.tablespace_name,
                         To_Char(a.Last_Analyzed, 'YYYY-MM-DD HH24:Mi:ss') Analyzed,
                         a.ini_trans,
                         a.Partitioned Partition,
			 a.temporary temp,
                         Bytes || 'M' bytes,
			 a.pct_free,
			 a.pct_used,
                         a.num_rows
        From Dba_Tables a,
                         (Select b.Segment_Name Segment_Name, Sum(b.Bytes/1024/1024) Bytes
                                        From Dba_Segments b
                                 Where b.Segment_Name = :i_table_name  
                                 Group By Segment_Name) c
 Where a.Table_Name = c.Segment_Name;
PROMPT
PROMPT +----------------------------------------------------------------------------+
PROMPT | OBJECT INFORMATION                                                         |
PROMPT +----------------------------------------------------------------------------+
col owner for a10;
col object_name for a30
col object_type for a10
col created for a20
col lastddltime for a20
col temporary for a15
select object_id,owner,object_name,object_type,status,to_char(created,'yyyy-mm-dd hh24:mi:ss') created,to_char(last_ddl_time,'yyyy-mm-dd hh24:mi:ss') lastddltime
,status,temporary from dba_objects where object_name=:i_table_name;


PROMPT
PROMPT +----------------------------------------------------------------------------+
PROMPT | SEGMENT INFORMATION                                                        |
PROMPT +----------------------------------------------------------------------------+


COLUMN segment_type                                  HEADING "Segment Type"
COLUMN bytes               FORMAT 9,999,999  HEADING "Bytes"
COLUMN extents             FORMAT 999,999,999        HEADING "Extents"
COLUMN initial_extent      FORMAT 999,999,999,999    HEADING "Initial|Extent"
COLUMN next_extent         FORMAT 999,999,999,999    HEADING "Next|Extent"
COLUMN min_extents         FORMAT 999                HEADING "Min|Extents"
COLUMN max_extents         FORMAT 9,999,999,999      HEADING "Max|Extents"
COLUMN pct_increase        FORMAT 999.00             HEADING "Pct|Increase"
COLUMN freelists                                     HEADING "Free|Lists"
COLUMN freelist_groups                               HEADING "Free|List Groups"

SELECT
    segment_type     segment_type
  , bytes/1024/1024||'M' as   bytes
  , extents          extents
  , initial_extent   initial_extent
  , next_extent      next_extent
  , min_extents      min_extents
  , max_extents      max_extents
  , pct_increase     pct_increase
  , freelists        freelists
  , freelist_groups  freelist_groups
FROM
    dba_segments
WHERE
 segment_name = :i_table_name
/




PROMPT
PROMPT +----------------------------------------------------------------------------+
PROMPT | COLUMNS                                                                    |
PROMPT +----------------------------------------------------------------------------+

COLUMN column_name         FORMAT A20                HEADING "Column Name"
COLUMN data_type           FORMAT A25                HEADING "Data Type"
COLUMN nullable            FORMAT A13                HEADing "Null?"

SELECT
    column_name
  , DECODE(nullable, 'Y', ' ', 'NOT NULL') nullable
  , DECODE(data_type
               , 'RAW',      data_type || '(' ||  data_length || ')'
               , 'CHAR',     data_type || '(' ||  data_length || ')'
               , 'VARCHAR',  data_type || '(' ||  data_length || ')'
               , 'VARCHAR2', data_type || '(' ||  data_length || ')'
               , 'NUMBER', NVL2(   data_precision
                                 , DECODE(    data_scale
                                            , 0
                                            , data_type || '(' || data_precision || ')'
                                            , data_type || '(' || data_precision || ',' || data_scale || ')'
                                   )
                                 , data_type)
               , data_type
    ) data_type
FROM
    dba_tab_columns
WHERE
   table_name = :i_table_name
ORDER BY
    column_id
/
PROMPT +----------------------------------------------------------------------------+
PROMPT | INDEXES                                                                    |
PROMPT +----------------------------------------------------------------------------+

Select b.Index_Owner Owner,
                         a.table_name Tablename,
                         a.Tablespace_Name Tablespacename,
                         b.Index_Name Indexname,
                         a.status,
                         a.index_type,
                         a.num_rows,
                         b.Column_Name Columnname,
                         b.Column_Position Columnpost
        From Dba_Indexes a, Dba_Ind_Columns b
 Where
         a.Table_Name = :i_Table_Name
         And b.Index_Name = a.Index_Name
         order by Indexname
/


PROMPT
PROMPT +----------------------------------------------------------------------------+
PROMPT | CONSTRAINTS                                                                |
PROMPT +----------------------------------------------------------------------------+

COLUMN constraint_name     FORMAT A18                HEADING "Constraint Name"
COLUMN constraint_type     FORMAT A11                HEADING "Constraint|Type"
COLUMN search_condition    FORMAT A15                HEADING "Search Condition"
COLUMN r_constraint_name   FORMAT A20                HEADING "R / Constraint Name"
COLUMN delete_rule         FORMAT A11                HEADING "Delete Rule"
COLUMN status                                        HEADING "Status"

BREAK ON constraint_name ON constraint_type

SELECT
    a.constraint_name
  , DECODE(a.constraint_type
             , 'P', 'Primary Key'
             , 'C', 'Check'
             , 'R', 'Referential'
             , 'V', 'View Check'
             , 'U', 'Unique'
             , a.constraint_type
    ) constraint_type
  , b.column_name
  , a.search_condition
  , NVL2(a.r_owner, a.r_owner || '.' ||  a.r_constraint_name, null) r_constraint_name
  , a.delete_rule
  , a.status
FROM
    dba_constraints  a
  , dba_cons_columns b
WHERE
 a.table_name       = :i_table_name
  AND a.constraint_name  = b.constraint_name
  AND b.table_name       = :i_table_name
ORDER BY
    a.constraint_name
  , b.position
/

PROMPT
PROMPT +----------------------------------------------------------------------------+
PROMPT | PARTITIONS (TABLE)                                                         |
PROMPT +----------------------------------------------------------------------------+

COLUMN partition_name                                HEADING "Partition Name"
COLUMN column_name         FORMAT A20                HEADING "Column Name"
COLUMN tablespace_name     FORMAT A28                HEADING "Tablespace"
COLUMN composite           FORMAT A9                 HEADING "Composite"
COLUMN subpartition_count                            HEADING "Sub. Part.|Count"
COLUMN logging             FORMAT A7                 HEADING "Logging"
COLUMN high_value          FORMAT A13                HEADING "High Value" TRUNC

BREAK ON partition_name

SELECT
    a.partition_name
  , b.column_name
  , a.tablespace_name
  , a.composite
  , a.subpartition_count
  , a.logging
FROM
    dba_tab_partitions    a
  , dba_part_key_columns  b
WHERE
   a.table_name         = :i_table_name
  AND RTRIM(b.object_type) = 'TABLE'
  AND b.owner              = a.table_owner
  AND b.name               = a.table_name
ORDER BY
    a.partition_position
  , b.column_position
/

PROMPT
PROMPT +----------------------------------------------------------------------------+
PROMPT | PARTITIONS (INDEX)                                                         |
PROMPT +----------------------------------------------------------------------------+

COLUMN index_name              FORMAT A25                HEADING "Index Name"
COLUMN partitioning_type       FORMAT A9                 HEADING "Type"
COLUMN partition_count         FORMAT 99999              HEADING "Part.|Count"
COLUMN partitioning_key_count  FORMAT 99999              HEADING "Part.|Key Count"
COLUMN locality                FORMAT A8                 HEADING "Locality"
COLUMN alignment               FORMAT A12                HEADING "Alignment"

SELECT
    a.owner || '.' || a.index_name   index_name
  , b.column_name
  , a.partitioning_type
  , a.partition_count
  , a.partitioning_key_count
  , a.locality
  , a.alignment
FROM
    dba_part_indexes      a
  , dba_part_key_columns  b
WHERE
 a.table_name         = :i_table_name
  AND RTRIM(b.object_type) = 'INDEX'
  AND b.owner              = a.owner
  AND b.name               = a.index_name
ORDER BY
    a.index_name
  , b.column_position
/


PROMPT +----------------------------------------------------------------------------+
PROMPT | TRIGGERS                                                                   |
PROMPT +----------------------------------------------------------------------------+

COLUMN trigger_name            FORMAT A25                HEADING "Trigger Name"
COLUMN trigger_type            FORMAT A18                HEADING "Type"
COLUMN triggering_event        FORMAT A9                 HEADING "Trig.|Event"
COLUMN referencing_names       FORMAT A65                HEADING "Referencing Names" newline
COLUMN when_clause             FORMAT A65                HEADING "When Clause" newline
COLUMN trigger_body            FORMAT A65                HEADING "Trigger Body" newline

SELECT
    owner || '.' || trigger_name  trigger_name
  , trigger_type
  , triggering_event
  , status
  , referencing_names
  , when_clause
  , trigger_body
FROM
    dba_triggers
WHERE
   table_name  = :i_table_name
ORDER BY
     trigger_name
/

