#定义变量
dev_name=$1
extent_begin_num=$2
extent_end_num=$3
disk_type=''
#如果参数不等于3，那么退出程序运行
#1
if [ $# -ne 3 ];then
	printf "PLEASE INPUT THREE PARAMETER\n"
	printf "asm_disk_header_type.sh devname begin_extent_number end_extent_number\n"
	#1
	#判断设备是否存在，如果不存在就异常限出
	elif [ ! -e $1 ];then
		printf "device name %s NOT FIND,PLEASE CONFIRM DEV NAME\n" $dev_name
		#判断参数2是否大于参数3，如果大于就异常退出
		elif [ $extent_begin_num -gt $extent_end_num ];then
			printf "extent begin name %s > extent end  name %s,should %s <= %s\n" $extent_begin_num $extent_end_num  $extent_begin_num $extent_end_num
		  else
			  #输出格式
        printf "EXTENT NUMBER       BLOCK NUMBER      DISK TYPE         \n"
        while [ $extent_begin_num -le $extent_end_num ]
        do
        block_num=0
        while [ $block_num -le 255 ]
        do
        #只输出kfbh.type的值
        disk_type=`kfed read dev=$1 blksz=4096 aunum=$extent_begin_num  blknum=$block_num|grep kfbh.type| awk '{print $5;}' | sed 's/^ *//g' | sed 's/ *$//g'`
        printf "%-21d%-17d%-18s\n" ${extent_begin_num} ${block_num} ${disk_type}
        #块号递增
        block_num=`expr $block_num + 1`
        done
        #区号递增
        extent_begin_num=`expr $extent_begin_num + 1`
        done
        #1
fi
