#!/bin/bash
path_num=0;
file_num=0;
total_path_num=$1
cat test.txt |while read a b
do
   if [ "$last_tbname" = "$a" ];then
                ((file_num++));
   else
          file_num=1
   fi
   if [ $path_num -lt $total_path_num ];then
          ((path_num++))
   else 
          path_num=1
   fi
   printf "set newname file \'%s\' to \'/oradata%d/%s%d.dbf\';\n"  $b $path_num  $a $file_num;
   last_tbname=$a;
done


#select *                                                                                              
#  from (select 'set newname file ' || chr(39) || file_name || chr(39) ||                              
#               ' to ' || chr(39) || '/oradata' || path_num || '/' ||                                  
#               lower(tablespace_name) || file_num || '.dbf ' || chr(39) || ';' filename,              
#               sum(bytes) over(partition by '/oradata' || path_num order by relative_fno) total_size, 
#               relative_fno rfno                                                                      
#          from (select tablespace_name,                                                               
#                       file_name,                                                                     
#                       relative_fno,                                                                  
#                       row_number() over(partition by tablespace_name order by relative_fno) file_num,
#                       a.bytes,                                                                       
#                       mod(file_id, &&directory_num) + 1 path_num                                     
#                  from dba_data_files a))                                                             
#minus                                                                                                 
#select *                                                                                              
#  from (select 'set newname file ' || chr(39) || file_name || chr(39) ||                              
#               ' to ' || chr(39) || '/oradata' || path_num || '/' ||                                  
#               lower(tablespace_name) || file_num || '.dbf ' || chr(39) || ';' filename,              
#               sum(bytes) over(partition by '/oradata' || path_num order by relative_fno) total_size, 
#               relative_fno rfno                                                                      
#          from (select tablespace_name,                                                               
#                       file_name,                                                                     
#                       relative_fno,                                                                  
#                       row_number() over(partition by tablespace_name order by relative_fno) file_num,
#                       a.bytes,                                                                       
#                       mod(file_id, &&directory_num) + 1 path_num                                     
#                  from dba_data_files a))                                                             
# where total_size > &directory_size * 1024 * 1024                                                     
