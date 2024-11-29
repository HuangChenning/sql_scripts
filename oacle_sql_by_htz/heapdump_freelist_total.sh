sqlplus -s '/ as sysdba' > ./htz_heapdump2.log<<EOF
oradebug setmypid;
oradebug dump heapdump 2;
oradebug tracefile_name;
exit
EOF
chmod 770 ./heapdump_freelist.sh
sh ./heapdump_freelist.sh `cat ./htz_heapdump2.log|grep trc`