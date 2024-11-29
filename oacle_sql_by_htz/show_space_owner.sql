CREATE OR REPLACE PROCEDURE show_space_owner (
   i_owner   IN VARCHAR2 DEFAULT USER,
   i_type    IN VARCHAR2 DEFAULT 'TABLE')
AS
   l_free_blks            NUMBER;
   l_total_blocks         NUMBER;
   l_total_bytes          NUMBER;
   l_unused_blocks        NUMBER;
   l_unused_bytes         NUMBER;
   l_LastUsedExtFileId    NUMBER;
   l_LastUsedExtBlockId   NUMBER;
   l_LAST_USED_BLOCK      NUMBER;
   l_segment_space_mgmt   VARCHAR2 (255);
   l_unformatted_blocks   NUMBER;
   l_unformatted_bytes    NUMBER;
   l_fs1_blocks           NUMBER;
   l_fs1_bytes            NUMBER;
   l_fs2_blocks           NUMBER;
   l_fs2_bytes            NUMBER;
   l_fs3_blocks           NUMBER;
   l_fs3_bytes            NUMBER;
   l_fs4_blocks           NUMBER;
   l_fs4_bytes            NUMBER;
   l_full_blocks          NUMBER;
   l_full_bytes           NUMBER;
BEGIN
   DBMS_OUTPUT.put_line (
         RPAD ('owner', 20)
      || RPAD ('object_name', 20)
      || RPAD ('partition_name', 20, ' ')
      || RPAD ('object_type', 20)
      || RPAD ('total_full', 15)
      || RPAD ('free_0~25%', 15)
      || RPAD ('free_25~50%', 15)
      || RPAD ('free_50~75%', 15)
      || RPAD ('free_75~100%', 15)
      || RPAD ('unformatted', 15));

   FOR x
      IN (SELECT owner,
                 segment_name object_name,
                 partition_name,
                 segment_type object_type
            FROM dba_segments a
           WHERE     owner = UPPER (i_owner)
                 AND segment_type IN
                        (UPPER (i_type), UPPER (i_type) || ' PARTITION'))
   LOOP
      DBMS_SPACE.space_usage (x.owner,
                              x.object_name,
                              x.object_type,
                              l_unformatted_blocks,
                              l_unformatted_bytes,
                              l_fs1_blocks,
                              l_fs1_bytes,
                              l_fs2_blocks,
                              l_fs2_bytes,
                              l_fs3_blocks,
                              l_fs3_bytes,
                              l_fs4_blocks,
                              l_fs4_bytes,
                              l_full_blocks,
                              l_full_bytes,
                              x.partition_name);  
      DBMS_OUTPUT.put_line (
            RPAD (x.owner, 20)
         || RPAD (x.object_name, 20)
         || RPAD (nvl(x.partition_name,' '), 20,' ')
         || RPAD (x.object_type, 20)
         || RPAD (l_full_blocks, 15)
         || RPAD (l_fs1_blocks, 15)
         || RPAD (l_fs2_blocks, 15)
         || RPAD (l_fs3_blocks, 15)
         || RPAD (l_fs4_blocks, 15)
         || RPAD (l_unformatted_blocks, 15));
   END LOOP;
END;
/