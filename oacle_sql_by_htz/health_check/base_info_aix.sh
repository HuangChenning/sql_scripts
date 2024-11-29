echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ hostname @@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
hostname 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ uname -M @@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
uname -M 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ uname -a @@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
uname -a 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ oslevel -r @@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
oslevel -r 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ bootinfo -K @@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
bootinfo -K 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ bootinfo -y @@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
bootinfo -y 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ lsdev -Cc processor @@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
lsdev -Cc processor 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ lsattr -El proc0 @@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
lsattr -El proc0 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ lsvg rootvg @@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
lsvg rootvg 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ lsattr -El mem0 @@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
lsattr -El mem0 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ lsps -a @@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
lsps -a 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ df -k @@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
df -k 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ sar -u 20 10 @@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
sar -u 20 10 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ iostat 20 10 @@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
iostat 20 10 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ vmstat 20 10 @@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
vmstat 20 10 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ svmon -G -i 6 5 @@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#REM 内存使用情况
#REM all statistics are in units of 4096-byte pages
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
svmon -G -i 6 5 

#REM (查最占内存的10个进程) 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ svmon -P -t 10 @@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
svmon -P -t 10 

#REM Swapping
#REM 整个Process ---硬盘(Disk)开销很大，影响行能
#REM System V: sar  -w 5 10
#REM BSD UNIX: vmstat - S 5 10
#REM 性能改善：0 －100％
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ sar -w 5 10 @@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@            
sar -w 5 10 
#REM Paging
#REM Process所用的某些页－硬盘对性能有影响
#REM System V: sar -p
#REM BSD UNIX: vmstat - S
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ errpt @@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
errpt 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ ps -ef | sort +3 -r |head -n 5 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ps -ef | sort +3 -r |head -n 5 

#REM ps auxwww|head -n 11看前10位用cpu
#REM
#REM 再详细的请用tprof命令
#REM tprof -x sleep 300    5分钟观察
#REM truss -o /tmp/mytruss -fae -p <pid of process>
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ lssrc -g cluster @@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
lssrc -g cluster 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ ipcs -mb @@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ipcs -mb 
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@ vmo -a @@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
vmo -a

