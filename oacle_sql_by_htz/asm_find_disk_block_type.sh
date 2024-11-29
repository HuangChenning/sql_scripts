extent_size=$1
bblock=$2
eblock=$3
name=$4
status=$6
type=$5
block_type=''
op='READ'
while (($bblock<=$eblock))
do
block_type=`kfed read  $4 blkn=$bblock |grep "$type"|egrep "$status"`
if [ "$?" = "0" ];then
   block_type=`echo $block_type|awk -F\: '{print $3'} |sed 's/ //'`
   ((block1=$bblock+1))
   ((blocks=${extent_size}*1024))
   ((extent_block=$blocks/4))
   ((extent_number=$block1/$extent_block))
   ((block2=$bblock%$extent_block))
   echo "$block_type--blocks number--$bblock--extent number---${extent_number}----block number---$block2------"
fi
bblock=$(($bblock+1))
done