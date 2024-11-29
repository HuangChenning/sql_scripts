echo  "please input direcotry default /tmp:"
read dir
if [ ! -z "$dir" ];then
   if [ ! -d "$dir" ];then
         mkdir -p $dir
   fi
  else 
    dir=/tmp   
fi
echo  "please input file name default control.ctl:"
read file_name
if [ -z "$file_name" ];then
      file_name=control.ctl
fi

if [ -f "$dir/$file_name" ];then
rm -rf $dir/$file_name
fi

sqlplus -s / as sysdba<<EOF
alter database backup controlfile to trace as '$dir/$file_name';
exit
EOF
num=`cat $dir/$file_name |grep -v '-'|grep -v ^$|sed 's/^    //'|sed 's/^  //'|wc -l`
num_1=`expr $(($num/2))`
cat $dir/$file_name |grep -v '-'|grep -v ^$|sed 's/^    //'|sed 's/^  //'|head -`echo $num_1`>$dir/$file_name
