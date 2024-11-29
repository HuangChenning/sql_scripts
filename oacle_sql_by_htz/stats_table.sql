set echo off
set verify off
set lines 170
set pages 10

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | DBMS_STATS.GATHER_TABLE_STATS                                          |
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT ownname prompt 'Enter Search Object Owner (i.e. SCOTT) : '
ACCEPT objectname prompt 'Enter Search Object Name (i.e. DEPT) : '

PROMPT +------------------------------------------------------------------------+
PROMPT | Please input partition name,if not ,please enter                       |
PROMPT +------------------------------------------------------------------------+
PROMPT
ACCEPT partname prompt 'Enter Search Partition Name (i.e. TAR_PART_1) : ' 

PROMPT +------------------------------------------------------------------------+
PROMPT | Please input  estimate_percent[0.000001,100] ,defalut vaule please enter|
PROMPT | usually advising use 30,if segment_size<1G,100,if segment_size<5G,50    |
PROMPT | if segment_size >5G USE 30                                             |
PROMPT +------------------------------------------------------------------------+
PROMPT
ACCEPT percent prompt 'Enter Search estimate_percent (i.e. 20) : '

PROMPT +------------------------------------------------------------------------+
PROMPT |  method_opt - method options of the following format                   |
PROMPT +------------------------------------------------------------------------|
PROMPT |      method_opt  := FOR ALL [INDEXED | HIDDEN] COLUMNS [size_clause]   |
PROMPT |                     FOR COLUMNS [size_clause]                          |
PROMPT |                       column|attribute [size_clause]                   |
PROMPT |                       [,column|attribute [size_clause] ... ]           |
PROMPT |                                                                        |
PROMPT |      size_clause := SIZE [integer | auto | skewonly | repeat],         |
PROMPT |                     where integer is between 1 and 254                 |
PROMPT |                                                                        |
PROMPT |      column      := column name | extension name | extension           |
PROMPT |                                                                        |
PROMPT |   default is FOR ALL COLUMNS SIZE AUTO.                                |
PROMPT |   if one new system,use default value,but if old system，              |
PROMPT |   advising use"for all columns size repeat",only when you gather       |
PROMPT |   specity column information ,repeat就是重复上一次的，意思就           |
PROMPT |   列上面已经存在直方图的，就收集直方图，并且桶的数据与原来的相等       |
PROMPT |                                                                        |
PROMPT |   for columns size 10 column1 column2 column3                          |
PROMPT |   for columns column1 size 10 column2 size 1                           |
PROMPT |   for columns size 10 column1 for columns size 20 column2              |
PROMPT |   for table                                                            |
PROMPT |   for all columns size 1                                               |
PROMPT +------------------------------------------------------------------------+

ACCEPT method_opt prompt 'Enter Search method_opt (i.e. ) : '

PROMPT
PROMPT +------------------------------------------------------------------------+ 
PROMPT |  cascade - gather statistics on the indexes for this table.              
PROMPT +------------------------------------------------------------------------+ 
PROMPT |   Use the constant DBMS_STATS.AUTO_CASCADE to have Oracle determine    | 
PROMPT |   whether index stats to be collected or not. This is the default.     | 
PROMPT |   The default value can be changed using set_param procedure.          | 
PROMPT |   Using this option is equivalent to running the gather_index_stats    | 
PROMPT |   procedure on each of the table's indexes.                            | 
PROMPT +------------------------------------------------------------------------+ 
PROMPT
ACCEPT cascade prompt 'Enter Search cascade  (i.e. true ) : ' default 'true'
PROMPT

PROMPT +----------------------------------------------------------------------------------+
PROMPT |Granularity of statistics to collect (only pertinent if the table is partitioned).|
PROMPT +----------------------------------------------------------------------------------+
PROMPT |'ALL' - Gathers all (subpartition, partition, and global) statistics              |
PROMPT |'APPROX_GLOBAL AND PARTITION' - similar to 'GLOBAL AND PARTITION'                 |
PROMPT |'AUTO'- Determines the granularity based on the partitioning type.                |
PROMPT |        This is the default value.                                                |
PROMPT |'DEFAULT' - Gathers global and partition-level statistics.                        |
PROMPT |        This option is obsolete, and while currently supported,                   |
PROMPT |'GLOBAL' - Gathers global statistics                                              |
PROMPT |'GLOBAL AND PARTITION' - Gathers the global and partition level statistics.       |
PROMPT |         No subpartition level statistics are gathered                            |
PROMPT |         even if it is a composite partitioned object.                            |
PROMPT |'PARTITION '- Gathers partition-level statistics                                  |
PROMPT |'SUBPARTITION' - Gathers subpartition-level statistics.                           |
PROMPT +----------------------------------------------------------------------------------+

ACCEPT granularity prompt 'Enter Search Granularity  (i.e. AUTO ) : ' default 'AUTO'
PROMPT
PROMPT +------------------------------------------------------------------------+  
PROMPT |   degree - degree of parallelism (NULL means use of table default value|  
PROMPT +------------------------------------------------------------------------+  
PROMPT |   which was specified by DEGREE clause in CREATE/ALTER TABLE statement)|  
PROMPT |    Use the constant DBMS_STATS.DEFAULT_DEGREE for the default value    |  
PROMPT |    based on the initialization parameters.                             |  
PROMPT |    default for degree is NULL.                                         |  
PROMPT +------------------------------------------------------------------------+  

ACCEPT degree prompt 'Enter Search degree (i.e. 3 ) : '    
                        

BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => UPPER('&ownname'),
                                TABNAME          => UPPER('&objectname'),
                                partname         => '&partname',
                                estimate_percent => '&percent',
                                method_opt       => UPPER('&method_opt'),
                                no_invalidate    => FALSE,
                                degree           => '&degree',
                                cascade          => &cascade,
                                granularity      => UPPER('&granularity'));
END;
/
undefine ownname;
undefine objectname
undefine partname
undefine percent;
undefine method_opt
undefine degree
undefine cascade
undefine granularity
