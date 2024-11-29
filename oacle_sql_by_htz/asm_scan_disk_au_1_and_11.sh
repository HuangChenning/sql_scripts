#!/bin/bash
# Usage: scan.sh <path> <AU size>
i=0
asize=$2
j=`expr $2 / 4096`
rm list.txt
echo AUSZIE=$asize >> list.txt
while [ 1 ]
do
echo $1 aunum=0 blknum=$i >> list.txt
kfed read $1 ausz=$asize aunum=0 blknum=$i | grep kfbh.type >> list.txt
echo $1 aunum=11 blknum=$i >> list.txt
kfed read $1 ausz=$asize aunum=11 blknum=$i | grep kfbh.type >> list.txt
i=$[$i+1]
if [ $j -eq $i ]; then
  echo $i Blocks scanned >> list.txt
  exit 0
fi
done