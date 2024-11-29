#!/bin/bash
#set -x
export ORAENV_ASK=NO
export ORACLE_SID=+ASM
. oraenv

i=0
ret=0
tab_cnt=0;
blk_typ='';

while [ "$blk_typ" != "KFBTYP_INVALID" ];
do
  blk_typ=`kfed read $1 blkn=$i | grep kfbh.type | awk '{print $5;}' | sed 's/^ *//g' | sed 's/ *$//g' `
  ret=$?
  if [ "$blk_typ" = "KFBTYP_DISKHEAD" ]; then
    t[$i]=$i
  fi
  let i=$i+1
done
echo "list of header block with KFBTYP_DISKHEAD type"
echo ${t[@]}