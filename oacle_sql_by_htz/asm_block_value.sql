#�������
#���ڲ�ѯ����ÿһ�еļ�¼
dev_name=$1
extent_begin_num=$2
extent_end_num=$3
disk_type=''
#�������������3����ô�˳���������
#1
if [ $# -ne 3 ];then
	printf "PLEASE INPUT THREE PARAMETER\n"
	printf "asm_disk_header_type.sh devname begin_extent_number end_extent_number\n"
	#1
	#�ж��豸�Ƿ���ڣ���������ھ��쳣�޳�
	elif [ ! -e $1 ];then
		printf "device name %s NOT FIND,PLEASE CONFIRM DEV NAME\n" $dev_name
		#�жϲ���2�Ƿ���ڲ���3��������ھ��쳣�˳�
		elif [ $extent_begin_num -gt $extent_end_num ];then
			printf "extent begin name %s > extent end  name %s,should %s <= %s\n" $extent_begin_num $extent_end_num  $extent_begin_num $extent_end_num
		  else
			  #�����ʽ
        printf "EXTENT NUMBER       BLOCK NUMBER      DISK TYPE         \n"
        while [ $extent_begin_num -le $extent_end_num ]
        do
        block_num=0
        while [ $block_num -le 255 ]
        do
        #ֻ���kfbh.type��ֵ
        disk_type=`kfed read dev=$1 blksz=4096 aunum=$extent_begin_num  blknum=$block_num|awk -F\; '/block.blk/ {print $1}'`
#        printf "%d\t%d\t%s \n" ${extent_begin_num} ${block_num} ${disk_type}
        echo "${extent_begin_num}       ${block_num}     ${disk_type}"
        #��ŵ���
        block_num=`expr $block_num + 1`
        done
        #���ŵ���
        extent_begin_num=`expr $extent_begin_num + 1`
        done
        #1
fi
