#!/bin/sh

#kmtune

nproc=`kctune | grep nproc | awk '{print $2}'`

if [ $nproc -lt 16384 ]; then
nproc=16384
fi

ksi_alloc_max=`/usr/bin/expr $nproc \* 8`
executable_stack=0
max_thread_proc=1024
maxdsiz=1073741824
maxdsiz_64bit=2147483648
maxssiz=134217728
maxssiz_64bit=1073741824
maxuprc=`/usr/bin/expr $nproc \* 9 \/ 10 +1`
msgtql=$nproc
msgmap=`/usr/bin/expr $msgtql + 2`
msgmni=$nproc
msgseg=32767
ninode=`/usr/bin/expr $nproc \* 8 + 2048`
ncsize=`/usr/bin/expr $ninode + 1024`
nfile=`/usr/bin/expr $nproc \* 15 + 2048`
nflocks=$nproc
nkthread=`/usr/bin/expr $nproc \* 7 \/ 4 + 16`
semmni=$nproc
semmns=`/usr/bin/expr $semmni \* 2`
semmnu=`/usr/bin/expr $nproc - 4`
semvmx=32767
shmmax=107374182400
shmmni=512
shmseg=120
vps_ceiling=64
echo "nkthread="$nkthread
echo "nproc="$nproc
echo "ksi_alloc_max="$ksi_alloc_max
echo "executable_stack="$executable_stack
echo "max_thread_proc="$max_thread_proc
echo "maxdsiz="$maxdsiz
echo "maxdsiz_64bit="$maxdsiz_64bit
echo "maxssiz="$maxssiz
echo "maxssiz_64bit="$maxssiz_64bit
echo "maxuprc="$maxuprc
echo "msgtql="$msgtql
echo "msgmap="$msgmap
echo "msgmni="$msgmni
echo "msgseg="$msgseg
echo "ninode="$ninode
echo "ncsize="$ncsize
echo "nfile="$nfile
echo "nflocks="$nflocks
echo "semmni="$semmni
echo "semmns="$semmns
echo "semmnu="$semmnu
echo "semvmx="$semvmx
echo "shmmax="$shmmax
echo "shmmni="$shmmni
echo "shmseg="$shmseg
echo "vps_ceiling="$vps_ceiling


kctune -s nkthread=$nkthread
kctune -s nproc=$nporc
kctune -s ksi_alloc_max=$ksi_alloc_max
kctune -s ksi_alloc_max=$ksi_alloc_max
kctune -s executable_stack=$executable_stack
kctune -s max_thread_proc=$max_thread_proc
kctune -s maxdsiz=$maxdsiz
kctune -s maxdsiz_64bit=$maxdsiz_64bit
kctune -s maxssiz=$maxssiz
kctune -s maxssiz_64bit=$maxssiz_64bit
kctune -s maxuprc=$maxuprc
kctune -s msgtql=$msgtql
kctune -s msgmap=$msgmap
kctune -s msgmni=$msgmni
kctune -s msgseg=$msgseg
kctune -s ninode=$ninode
kctune -s ncsize=$ncsize
kctune -s nfile=$nfile
kctune -s nflocks=$nflocks
kctune -s semmni=$semmni
kctune -s semmns=$semmns
kctune -s semmnu=$semmnu
kctune -s semvmx=$semvmx
kctune -s shmmax=$shmmax
kctune -s shmmni=$shmmni
kctune -s shmseg=$shmseg
kctune -s vps_ceiling=$vps_ceiling