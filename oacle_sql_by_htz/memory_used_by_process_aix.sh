#/usr/bin/ksh
print "shell is run using oracle user"
print "ps v"
ps v $1|grep -v PID|awk '{ total=($7-$10)} END {print total/1024 "MB"}'

print "svmon"
svmon -O unit=KB,segment=category,filtercat=exclusive,summary=basic -P $1|grep $1|grep -v 'process does not exist'|awk '{print $3/1024 "MB"}'