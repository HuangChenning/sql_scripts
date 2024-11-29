set echo off;
set lines 280 pages 10000 verify off
SET SERVEROUTPUT ON
PROMPT '*************************************************************************************************************************************************************';
PROMPT 'COMP_NOCOMPRESS                NUMBER            1           No compression                                                                                  ';                                                                         
PROMPT 'COMP_ADVANCED                  NUMBER            2           Advanced compression level                                                                      ';
PROMPT 'COMP_QUERY_HIGH                NUMBER            4           High compression level for query operations                                                     ';
PROMPT 'COMP_QUERY_LOW                 NUMBER            8           Low compression level for query operations                                                      ';
PROMPT 'COMP_ARCHIVE_HIGH              NUMBER            16          High compression level for archive operations                                                   ';
PROMPT 'COMP_ARCHIVE_LOW               NUMBER            32          Low compression level for archive operations                                                    ';
PROMPT 'COMP_BLOCK                     NUMBER            64          Compressed row                                                                                  ';
PROMPT 'COMP_LOB_HIGH                  NUMBER            128         High compression level for LOB operations                                                       ';
PROMPT 'COMP_LOB_MEDIUM                NUMBER            256         Medium compression level for LOB operations                                                     ';
PROMPT 'COMP_LOB_LOW                   NUMBER            512         Low compression level for LOB operations                                                        ';
PROMPT 'COMP_INDEX_ADVANCED_LOW        NUMBER            2048        Low compression level for indexes                                                               ';
PROMPT 'COMP_RATIO_LOB_MINROWS         NUMBER            1000        Minimum required number of LOBs in the object for which LOB compression ratio is to be estimated';
PROMPT 'COMP_BASIC                     NUMBER            4096        Basic compression level                                                                         ';
PROMPT 'COMP_RATIO_LOB_MAXROWS         NUMBER            5000        Maximum number of LOBs used to compute the LOB compression ratio                                ';
PROMPT 'COMP_INMEMORY_NOCOMPRESS       NUMBER            8192        In-Memory with no compression                                                                   ';
PROMPT 'COMP_INMEMORY_DML              NUMBER            16384       In-Memory compression level for DML                                                             ';
PROMPT 'COMP_INMEMORY_QUERY_LOW        NUMBER            32768       In-Memory compression level optimized for query performance                                     ';
PROMPT 'COMP_INMEMORY_QUERY_HIGH       NUMBER            65536       In-Memory compression level optimized on query performance as well as space saving              ';
PROMPT 'COMP_INMEMORY_CAPACITY_LOW     NUMBER            32768       In-Memory low compression level optimizing for capacity                                         ';
PROMPT 'COMP_INMEMORY_CAPACITY_HIGH    NUMBER            65536       In-Memory high compression level optimizing for capacity                                        ';
PROMPT 'COMP_RATIO_MINROWS             NUMBER            1000000     Minimum required number of rows in the object for which HCC ratio is to be estimated            ';
PROMPT 'COMP_RATIO_ALLROWS             NUMBER            -1          To indicate the use of all the rows in the object to estimate HCC ratio                         ';
PROMPT 'OBJTYPE_TABLE                  PLS_INTEGER       1           Identifies the object whose compression ratio is estimated as of type table                     ';
PROMPT 'OBJTYPE_INDEX                  PLS_INTEGER       2           Identifies the object whose compression ratio is estimated as of type index                     ';
PROMPT '*************************************************************************************************************************************************************';
PROMPT '此过程将消耗大量的资源，消耗的资源跟对象的大小有关系，此过程可能运行很久';
undefine tablespace;
undefine owner;
undefine objectname;
DECLARE
  l_blkcnt_cmp    PLS_INTEGER;
  l_blkcnt_uncmp  PLS_INTEGER;
  l_row_cmp       PLS_INTEGER;
  l_row_uncmp     PLS_INTEGER;
  l_cmp_ratio     NUMBER;
  l_segment_size  NUMBER;
  l_comptype_str  VARCHAR2(32767);
BEGIN
  DBMS_COMPRESSION.get_compression_ratio (
    scratchtbsname  => upper('&&tablespace'),
    ownname         => upper('&&owner'),
    objname         => upper('&&objectname'),
    subobjname      => NULL,
    comptype        => &comp_type_number,
    blkcnt_cmp      => l_blkcnt_cmp,
    blkcnt_uncmp    => l_blkcnt_uncmp,
    row_cmp         => l_row_cmp,
    row_uncmp       => l_row_uncmp,
    cmp_ratio       => l_cmp_ratio,
    comptype_str    => l_comptype_str,
    subset_numrows  => DBMS_COMPRESSION.comp_ratio_allrows,
    objtype         => DBMS_COMPRESSION.objtype_table
  );
  select sum(bytes) into  l_segment_size from dba_segments where owner=upper('&&owner') and segment_name=upper('&&objectname');
  
  DBMS_OUTPUT.put_line('Number of blocks used (compressed)       : ' ||  l_blkcnt_cmp);
  DBMS_OUTPUT.put_line('Number of blocks used (uncompressed)     : ' ||  l_blkcnt_uncmp);
  DBMS_OUTPUT.put_line('Number of rows in a block (compressed)   : ' ||  l_row_cmp);
  DBMS_OUTPUT.put_line('Number of rows in a block (uncompressed) : ' ||  l_row_uncmp);
  DBMS_OUTPUT.put_line('Size of compressed 											 : ' ||  l_segment_size/l_cmp_ratio);
  DBMS_OUTPUT.put_line('Compression ratio                        : ' ||  l_cmp_ratio);
  DBMS_OUTPUT.put_line('Compression type                         : ' ||  l_comptype_str);
END;
/

undefine tablespace;
undefine owner;
undefine objectname;

