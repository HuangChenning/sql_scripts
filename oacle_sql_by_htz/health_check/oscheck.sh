SYSTEM=`uname -s`
echo "## OSINFO ##################################"
echo $SYSTEM
uname -a
if [ $SYSTEM = "Linux" ] ; then
  echo "## RELEASE###################################"
  /usr/bin/lsb_release -a
  /bin/uname -a
  echo "## CPU #####################################"
  cat /proc/cpuinfo|grep processor |wc -l
  echo "## MEMORY ##################################"
  free
  echo "## FS USAGE ################################"
  df -h
  echo "## CPU USAGE ###############################"
  /usr/bin/sar 5 10
  echo "## sysct.conf ###############################"
  cat /etc/sysctl.conf|grep -v ^$|grep -v ^#
  echo "###########multipath.conf"
  cat /etc/multipath.conf|grep -v ^$|grep ^#
  echo "###########meminfo##########################"
  /bin/cat /proc/meminfo
  echo "##route####################################"
  /bin/netstat -rn
  echo "##crontab##################################"
  /usr/bin/crontab -l
  echo "##message##################################"
  /bin/dmesg
  echo "##ifconfig#################################"
  /sbin/ifconfig -a
  for i in `/sbin/ifconfig -a|grep bond|awk -F\: '{print $1}'|awk '{print $1}'|sort -u`;
    do
      cat   /proc/net/bonding/$i;
      cat /etc/sysconfig/network-scripts/ifcfg-$i;
      for b in `grep "Slave Interface" /proc/net/bonding/bond0|awk -F\: '{print $2}'|awk '{print $1}'`;
       do
       cat /etc/sysconfig/network-scripts/ifcfg-$b;
       done
    done
  echo "##limit####################################"
  /bin/cat /etc/security/limits.conf |grep -v ^#|grep -v ^$
  ulimit -a
  echo "###########id##############################"
  id oracle
  id grid
  echo "##########package##########################"
  /bin/rpm -qa --qf '%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n'
  echo "##########service##########################"
  /sbin/chkconfig --list
elif [ $SYSTEM = "AIX" ] ; then
	echo "##oslevel###################################"
  oslevel -s
  echo "## CPU #####################################"
  lsdev -C |grep Process |wc -l
  echo "## PRTCONF #####################################"
  prtconf
  echo "## MEMORY ##################################"
  /usr/sbin/lsattr -HE -l sys0 -a realmem
  echo "## PAGE ####################################"
  /usr/sbin/lsps -a
    echo "## VMSTAT####################################"
  vmstat -v
  echo "## FS USAGE ################################"
  df -m
  echo "## CPU USAGE ###############################"
  iostat -t 5 10
  echo "## HACMP####################################"
  if [ `/usr/bin/lslpp -l|/usr/bin/grep "cluster.es.server.rte"|wc -l` -gt 0 ];then
     /usr/es/sbin/cluster/utilities/clshowres
     /usr/es/sbin/cluster/utilities/clshowsrv -v
     /usr/es/sbin/cluster/utilities/cltopinfo
     /usr/es/sbin/cluster/utilities/cllsif
     tail -10000 /var/hacmp/adm/cluster.log
  fi
  echo "#######no####################################"
  /usr/sbin/no -a
  echo "##errpt#####################################"
  /usr/bin/errpt
  /usr/bin/errpt -a
  echo "##TZ#####################################"
  echo $TZ
elif [ $SYSTEM = "HP-UX" ] ; then
  echo "## CPU #####################################"
  /usr/bin/sar -M 1 1|awk 'END {print NR-5}'
  echo "## MEMORY ##################################"
  /usr/contrib/bin/machinfo
  echo "## PAGE ####################################"
  /usr/sbin/swapinfo -a
  echo "## FS USAGE ################################"
  bdf
  echo "## CPU USAGE ###############################"
  sar 5 10
  echo "## messages"
  tail -10000 /var/adm/syslog/syslog.log|grep -v "SSH: Server;"|grep -v "Received disconnect"|grep -v "Failed password"|grep -v "Did not receive identification"|grep -v "Accepted password"|grep -v "fatal: Read from socket"
  echo "#################Kctune######################"
  /usr/sbin/kctune
  echo "############################################"
  echo "########netstat#############################"
  netstat -in
  echo "######################crontab -l ###########"
  crontab -l
  echo "######################swlist################"
  /usr/sbin/swlist

elif [ $SYSTEM = "SunOS" ] ; then
  echo "## OS RELEASE#############################"
  /bin/showrev
fi
echo "## PAGING ##################################"
vmstat 5 10
echo "## IPCS ####################################"
ipcs -ma

