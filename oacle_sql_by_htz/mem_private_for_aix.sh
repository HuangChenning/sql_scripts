echo "Enter pid number"
read pid
procmap $pid|grep write|grep -v grep|awk '{print $2}'|awk -FK '{sum +=$1};END {print sum/1024 "mb"}'