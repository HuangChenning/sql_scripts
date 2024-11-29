#!/bin/bash

## The script tests the integrity of the pre-requisite installed packages and
## points packages that are not installed ( 32 bit and 64 bit packages) for 
## Oracle 11gR2 installation on Linux x86_64 server and Linux x86 server. 
## The script output shows any package whose dependent files have 
## been deleted accidently.

## Version 1.1
## Edited Jan 14, 2013
## Author : Prakash V

stamp=`date +%F_%H-%M-%S`
touch /tmp/precheck_$stamp.log
outdv="---------------------------------------------------------"

echo "
############################ RPM Integrity Check Results ##################################
1. If a package is not installed, this will be mentioned as :
   Package <package> is not installed.
2. If some dependant file is missing from an installed package, this will be mentioned as :
   missing file from <package name>
3. If no issues with the installed packages, no errors will be displayed in the log.
###########################################################################################    " >> /tmp/precheck_$stamp.log

echo >> /tmp/precheck_$stamp.log
echo >> /tmp/precheck_$stamp.log
echo
outprint()
{

	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package $i not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				else
				    echo $a >> /tmp/precheck_$stamp.log
					echo "Successfully verified the package : $rpm1 " >> /tmp/precheck_$stamp.log
					echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi
}

enout()
{
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo "#########################################################" >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log
	echo " ENVIRONMENT VARIABLE SETTINGS " >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log
	echo "#########################################################" >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log

	env  >> /tmp/precheck_$stamp.log

	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo "#########################################################" >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log
	echo " BASH PROFILE SETTINGS " >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log
	echo "#########################################################" >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log

	cat ~/.bash_profile >> /tmp/precheck_$stamp.log

	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo "#########################################################" >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log
	echo " SERVER UPTIME " >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log
	echo "#########################################################" >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log

	uptime >> /tmp/precheck_$stamp.log

	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo "#########################################################" >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log
	echo
	echo
	echo
	echo "#########################################################" >> /tmp/precheck_$stamp.log
	echo " The Kernel Parameter Settings "    >> /tmp/precheck_$stamp.log
	echo " ============================ "     >> /tmp/precheck_$stamp.log
	echo "#########################################################" >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	
	
	### kernel.shmall = 1/2 of physical memory in pages, this will be the value 2097152. See Note 301830.1 for more information.
	### kernel.shmmax = 1/2 of physical memory in bytes. This would be the value 2147483648 for a system with 4GB of physical RAM.

	Totmemory=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`
	Totmem=`expr $Totmemory \\* 1024`
	pgsz=`getconf PAGESIZE`
	calone=`expr $Totmem / $pgsz`
	orgval=`cat /proc/sys/kernel/shmall`
	if [ $orgval -lt $calone ]; then
	echo " The Kernel.shmall minimum value for Installation is : 2097152.
		Found the value : $calone " >> /tmp/precheck_$stamp.log
	else
	echo "The kernel.shmall value is correct "  >> /tmp/precheck_$stamp.log
	fi

	##kernel.shmmax
	kbmem=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`
	val=`expr $kbmem \\* 1024 / 2`
	maxval=`cat /proc/sys/kernel/shmmax`
	if [ $maxval -lt $val ]; then
	echo " The Kernel.shmmax minimum value for Installation is : 2147483648
		Found the value : $val "  >> /tmp/precheck_$stamp.log
	else
	echo " The kernel.shmmax value is correct "  >> /tmp/precheck_$stamp.log
	fi

	shmmni=`cat /proc/sys/kernel/shmmni`
	if [ $shmmni -lt 4096 ]; then
	echo " The shmmni value is less than 4096 .
       The recommended value is 4096 "     >> /tmp/precheck_$stamp.log
	else
	echo " The value for shmmni is : $shmmni " >> /tmp/precheck_$stamp.log
	fi

	##  To display the current values of the semaphore kernel parameters, use:
	### cat /proc/sys/kernel/sem
	### 250 32000 32 4096
	### The four values displayed are:
    ### SEMMSL . maximum number of semaphores per set or array.
    ### SEMMNS . maximum number of semaphores system.wide. This values is determined by Maximum Number of Arrays * Maximum Semaphores/array.
    ### SEMOPM . maximum number of operations allowed for one semop call.
    ### SEMMNI . maximum number of semaphore identifiers (sets).

	sem=` cat /proc/sys/kernel/sem`
	semmsl=`cat /proc/sys/kernel/sem | awk '{print $1}'`
	semmns=`cat /proc/sys/kernel/sem | awk '{print $2}'`
	semopm=`cat /proc/sys/kernel/sem | awk '{print $3}'`
	semmni=`cat /proc/sys/kernel/sem | awk '{print $4}'`

	if   [ $semmsl -lt 250 ]; then
	echo " The value of kernel.sem is incorrect. Please review the install Document
			The recommended value is : 250 32000 100 128 "    >> /tmp/precheck_$stamp.log
	elif [ $semmns -lt 32000 ]; then
	echo " The value of kernel.sem is incorrect. Please review the install Document
			The recommended value is : 250 32000 100 128 "    >> /tmp/precheck_$stamp.log
	elif [ $semopm -lt 100 ]; then
	echo " The value of kernel.sem is incorrect. Please review the install Document
			The recommended value is : 250 32000 100 128 "    >> /tmp/precheck_$stamp.log
	elif [ $semmni -lt 128 ]; then
	echo " The value of kernel.sem is incorrect. Please review the install Document
			The recommended value is : 250 32000 100 128 "   >> /tmp/precheck_$stamp.log
	else
	echo " The value of parameter kernel.sem is : $sem "     >> /tmp/precheck_$stamp.log
	fi

	filemax=`cat /proc/sys/fs/file-max`
	if [ $filemax -lt 6815744 ]; then
	echo " The fs.file-max value is less than 6815744.
			The recommended value is : 6815744 "     >> /tmp/precheck_$stamp.log
	else
	echo " The value for fs.file-max is : $filemax "  >> /tmp/precheck_$stamp.log
	fi

	aiomax=`cat /proc/sys/fs/aio-max-nr`
	if [ $aiomax -lt 1048576 ]; then
	echo " The fs.aio-max-nr value is less than : 1048576   
			The recommended value is : 1048576 "  >> /tmp/precheck_$stamp.log
	else
	echo " The value for fs.aio-max-nr is : $aiomax "  >> /tmp/precheck_$stamp.log
	fi

	portrange=`cat /proc/sys/net/ipv4/ip_local_port_range`
	val1=`cat /proc/sys/net/ipv4/ip_local_port_range | awk '{print $1}'`
	val2=`cat /proc/sys/net/ipv4/ip_local_port_range | awk '{print $2}'`
	if [[ $val1 == 9000  && $val2 == 65500 ]];then
	echo " The value for net.ipv4.ip_local_port_range is : $portrange "   >> /tmp/precheck_$stamp.log
	else
	echo " The value of net.ipv4.ip_local_port_range  is incorrect. Please review the install Document.
			The recommended value is : 9000 65500 "  >> /tmp/precheck_$stamp.log
	fi    

	rmemd=`cat /proc/sys/net/core/rmem_default`
	if [ $rmemd -lt 262144 ]; then
	echo " The net.core.rmem_default value is less than : 262144
			The recommended value is : 262144 "    >> /tmp/precheck_$stamp.log
	else
	echo " The value for net.core.rmem_default is : $rmemd "   >> /tmp/precheck_$stamp.log
	fi

	rmemm=`cat /proc/sys/net/core/rmem_max`
	if [ $rmemm -lt 4194304 ]; then
	echo " The net.core.rmem_max value is less than : 4194304
			The recommended value is : 4194304 "      >> /tmp/precheck_$stamp.log
	else
	echo " The value for net.core.rmem_max is : $rmemm "   >> /tmp/precheck_$stamp.log
	fi

	wmemd=`cat /proc/sys/net/core/wmem_default`
	if [ $wmemd -lt 262144 ]; then
	echo " The net.core.wmem_default value is less than : 262144
			The recommended value is : 262144 "       >> /tmp/precheck_$stamp.log
	else
	echo " The value for net.core.wmem_default value is : $wmemd "   >> /tmp/precheck_$stamp.log
	fi

	wmemm=`cat /proc/sys/net/core/wmem_max`
	if [ $wmemm -lt 1048576 ]; then
	echo " The net.core.wmem_max value is less than : 1048576
			The recommended value is : 1048576 "    >> /tmp/precheck_$stamp.log
	else
	echo " The value for net.core.wmem_max value is : $wmemm "   >> /tmp/precheck_$stamp.log
	fi

	echo
	echo " ======================================================"  >> /tmp/precheck_$stamp.log
	echo
	echo
	echo " The /etc/security/limits.conf  values "    >> /tmp/precheck_$stamp.log
	echo " The expected ulimit values are :
	-------------------------------
      oracle              soft    nproc    2047
      oracle              hard   nproc     16384
      oracle              soft    nofile    1024
      oracle              hard   nofile    65536
      oracle              soft    stack    10240
      oracle              hard   stack     10240 "  >> /tmp/precheck_$stamp.log

	echo " The current value in the server is :
	------------------------------------ "    >> /tmp/precheck_$stamp.log

	cat /etc/security/limits.conf | grep -v "#"   >> /tmp/precheck_$stamp.log

	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo "##########################################################" >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log
	echo " ##############  Virtualization review ################### " >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log

	grep -i vmware /proc/scsi/scsi /proc/ide/*/model >> /tmp/precheck_$stamp.log 2>&1

	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo "##########################################################" >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log
	echo " ##############  Check for System Java version and bit , gcc version and Kernel version ################### " >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log

	echo "#######Java version #####" >> /tmp/precheck_$stamp.log
	java -d32 -version >> /tmp/precheck_$stamp.log 2>&1
	echo  >> /tmp/precheck_$stamp.log
	echo "#######  gcc version #####" >> /tmp/precheck_$stamp.log
	gcc --version >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo "#######Kernel release #####" >> /tmp/precheck_$stamp.log
	uname -r >> /tmp/precheck_$stamp.log

	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	
	echo "Execution completed !!! 
	Please upload the file : /tmp/precheck_$stamp.log to Oracle Support.
	Thank you. "
}

	echo " Enter the respective value "
	echo " 1 : Oracle 11gR2 pre-check "
	echo " 2 : Oracle 12c release 1  pre-check "
	read -p 'Enter 1 or 2 : ' value

	case $value in
	1)	
	clear
	if [ `getconf LONG_BIT` == 32 ];
	then
	
	if [ -e /etc/SuSE-release ]; 
     then
       if ((`cat /etc/SuSE-release | grep "Server" | awk '{print $5}'|sed -e 's|\..*$||'`== 10));	
	      then
	      SUSE1032bit=( binutils gcc-c++ glibc ksh libaio libgcc libstdc++ make gcc libmudflap glibc-devel libaio-devel libelf libstdc++-devel sysstat cvuqdisk unixODBC unixODBC-devel )
		  for i in "${SUSE1032bit[@]}"
			do
				rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | egrep -e "i386|i586|i686" | cut -d' ' -f1` 
				outprint	
			done

			tocheck=compat-libstdc++
			rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE}\n" $tocheck`
			outprint
			enout
	
		  
	     elif ((`cat /etc/SuSE-release | grep "Server" | awk '{print $5}'|sed -e 's|\..*$||'`== 11));	
	     then
         SUSE1132bit=( binutils glibc ksh libstdc++33 libstdc++44 libaio libgcc make libaio-devel sysstat glibc-devel linux-kernel-headers gcc libstdc++43 gcc-c++ libstdc++-devel gcc43 gcc43-c++ )
		  
		 for i in "${SUSE1132bit[@]}"
			do
				rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | egrep -e "i386|i586|i686" | cut -d' ' -f1` 
				outprint	
			done
			enout
		  
      else
      echo " Not Certified "
  	fi

 ## The pre-requirement for for RHEL 4 ( 32 bit ) on 11gR2 is checked below
 elif ((`cat /etc/redhat-release | grep "release" | awk '{print $7}'|sed -e 's|\..*$||'`== 4));
 then

	echo "Executing the pre-requisite check for RHEL 4 (32 bit) on 11gR2 ......"
	echo
	echo $outdv >> /tmp/precheck_$stamp.log

	RHEL432bit=( gcc elfutils-libelf-devel elfutils-libelf gcc-c++ glibc glibc-common glibc-devel libaio libaio-devel libgcc libstdc++-devel sysstat binutils libstdc++ make pdksh unixODBC-devel unixODBC glibc-headers glibc-kernheaders )
	
    for i in "${RHEL432bit[@]}"
	do
		rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | egrep -e "i386|i586|i686" | cut -d' ' -f1` 
		outprint	
	done

	tocheck=compat-libstdc++-*
	rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE}\n" $tocheck`
	outprint

	echo >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log	 
	enout

#############################################################################
## The following is for 11gR2 installation on RHEL 5 (32 bit) server ##


elif ((`cat /etc/redhat-release | grep "release" | awk '{print $7}'|sed -e 's|\..*$||'`== 5));

then
echo " Executing the pre-requisite check for 11gR2 installation on RHEL 5 (32 bit)......"
echo
echo "*************************************************" >> /tmp/precheck_$stamp.log

	RHEL532bit=( gcc elfutils-libelf-devel elfutils-libelf-devel-static gcc-c++ glibc glibc-common glibc-devel libaio libaio-devel libgcc libstdc++-devel sysstat binutils libstdc++ make unixODBC-devel unixODBC glibc-headers kernel-headers elfutils-libelf ksh libgomp )

  for i in "${RHEL532bit[@]}"
	do
		rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | egrep -e "i386|i586|i686" | cut -d' ' -f1` 
		outprint	
	done

	tocheck=compat-libstdc++
	rpm1=`rpm -qa | grep $tocheck`
	outprint
   	
	echo >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log	 
	enout	

fi

else

###########################################################################
## The pre-requirement for RHEL 4 ( 64 bit )  on 11gR2 ##

if [ -e /etc/SuSE-release ]; 
   then
   if ((`cat /etc/SuSE-release | grep "Server" | awk '{print $5}'|sed -e 's|\..*$||'`== 10));	
	  then
	   SUSE1064bit=( binutils glibc libaio libaio-32bit libgcc libstdc++ make numactl glibc-devel glibc-devel-32bit libstdc++-devel libelf gcc libmudflap gcc-c++ libaio-devel libaio-devel-32bit sysstat )
	   
	   for i in "${SUSE1064bit[@]}"
		do
			rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | grep x86_64 | cut -d' ' -f1` 
			outprint	
		done
	
		tocheck=compat-libstdc++*
		rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" | grep $tocheck | grep x86_64 | cut -d' ' -f1`
		outprint
		enout
	   
	 elif ((`cat /etc/SuSE-release | grep "Server" | awk '{print $5}'|sed -e 's|\..*$||'`== 11));	
	  then
       SUSE1164bit=( binutils glibc glibc-32bit ksh libaio libaio-32bit libstdc++33 libstdc++33-32bit libstdc++43 libstdc++43-32bit libgcc43 make libaio-devel libaio-devel-32bit sysstat glibc-devel gcc glibc-devel-32bit gcc-32bit libstdc++43-devel gcc-c++ libstdc++43-devel-32bit libstdc++-devel linux-kernel-headers gcc43 libgomp43-32bit gcc43-32bit gcc43-c++ )

	   for i in "${SUSE1164bit[@]}"
		do
			rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | grep x86_64 | cut -d' ' -f1` 
			outprint
		done
		enout
    else
    echo " Not Certified "
  fi	

elif ((`cat /etc/redhat-release | grep "release" | awk '{print $7}'|sed -e 's|\..*$||'`== 4));
	then

	echo " Checking RHEL 4 (64 bit) 11gR2 installation ..............."
	echo
	echo $outdv >> /tmp/precheck_$stamp.log

	RHEL464bit=( gcc elfutils-libelf gcc-c++ glibc glibc-common glibc-devel libaio libaio-devel libstdc++-devel sysstat binutils expat libgcc libstdc++ make pdksh unixODBC unixODBC-devel  glibc-headers numactl elfutils-libelf-devel )

	for i in "${RHEL464bit[@]}"
	do
		rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | grep x86_64 | cut -d' ' -f1` 
		outprint	
	done
		
	tocheck=compat-libstdc++*
	rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" | grep $tocheck | grep x86_64 | cut -d' ' -f1`
	outprint

	tocheck=compat-libstdc++*
	rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package compat-libstdc++(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi

	tocheck=glibc
	rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package glibc(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi

	tocheck=glibc-devel
	rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package glibc-devel(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi

	tocheck=libaio
	rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package libaio(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi

	tocheck=libaio-devel
	rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package libaio-devel(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi


    tocheck=libgcc-*
	rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package libgcc(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi

	tocheck=libstdc++
	rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

	echo " Package libstdc++(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi

	tocheck=unixODBC-*
	rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package unixODBC(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi

	tocheck=unixODBC-devel
	rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package unixODBC-devel(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi
	
	echo >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log	 
	enout

#############################################################################
## The following is for 11gR2 installation on RHEL 5 server ##


elif ((`cat /etc/redhat-release | grep "release" | awk '{print $7}'|sed -e 's|\..*$||'`== 5));
then
echo " Checking for 11gR2 installation on RHEL 5 server (64 bit)........"
echo

	RHEL564bit=( binutils elfutils-libelf glibc glibc-common ksh libaio libgcc libstdc++ make unixODBC unixODBC-devel elfutils-libelf-devel elfutils-libelf-devel-static gcc gcc-c++ glibc-devel glibc-headers kernel-headers  libgomp libstdc++-devel sysstat libaio-devel )

	for i in "${RHEL564bit[@]}"
	do
		rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | grep x86_64 | cut -d' ' -f1` 
		outprint	
	done
	

	tocheck=compat-libstdc++*
	rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" | grep $tocheck | grep x86_64 | cut -d' ' -f1`
	outprint

	tocheck=compat-libstdc++*
	rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" | grep $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package compat-libstdc++ (32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi


	tocheck=glibc
	rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package glibc(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi


	tocheck=libaio
	rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package libaio(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi

	tocheck=libgcc
	rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package libgcc(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi


	tocheck=libstdc++
	rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package libstdc++(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi


	tocheck=unixODBC
	rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package unixODBC(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi

	tocheck=unixODBC-devel
	rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package unixODBC-devel(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi

	tocheck=glibc-devel
	rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package glibc-devel(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi

	tocheck=libaio-devel
	rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
	echo $rpm1 | grep -i  "not installed" >> /dev/null
	if [[ $rpm1 == '' || $? == 0 ]];then

                echo " Package libaio-devel(32 bit) not installed " >> /tmp/precheck_$stamp.log
                echo $outdv >> /tmp/precheck_$stamp.log
                else
                echo " Checking the integrity for : $rpm1 "
				a=`rpm -V $rpm1 2>>/dev/null | awk '/missing/{print $0 "\n"}'`
				if [ -n "$a" ]
                then
					echo $a >> /tmp/precheck_$stamp.log
					echo >> /tmp/precheck_$stamp.log
                    echo "The above message is for package : $rpm1  " >> /tmp/precheck_$stamp.log
                    echo $outdv >> /tmp/precheck_$stamp.log
				fi
		fi
	
	echo >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log	 
	enout
	

### The following section is for 11.2.0.3 Install pre-requirements on RHEL 6
############################################################################


elif ((`cat /etc/redhat-release | grep "release" | awk '{print $7}'|sed -e 's|\..*$||'`== 6));
then
echo " Checking for RHEL 6 ( 64 bit) pre-requirement ..............."
echo

	RHEL664bit=( binutils glibc ksh libaio libgcc libstdc++ make compat-libcap1 gcc gcc-c++ glibc-devel libaio-devel libstdc++-devel sysstat glibc-headers )
	for i in "${RHEL664bit[@]}"
	do
		rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | grep x86_64 | cut -d' ' -f1` 
		outprint	
	done


	tocheck=compat-libstdc++
    rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" | grep $tocheck | grep x86_64 | cut -d' ' -f1`
	outprint

	echo >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log
	echo "*********************************************************"  >> /tmp/precheck_$stamp.log
	echo " The below check is for the 32 bit client installation pre-requirements "  >> /tmp/precheck_$stamp.log
	echo "*********************************************************"  >> /tmp/precheck_$stamp.log

	echo >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log
	echo  >> /tmp/precheck_$stamp.log

	RHEL632bit=( glibc glibc-devel libaio libaio-devel libgcc libstdc++ libstdc++-devel )

	for i in "${RHEL632bit[@]}"
	do
		rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | egrep -e "i386|i586|i686" | cut -d' ' -f1` 
		outprint	
	done
	
	tocheck=compat-libstdc++-
	rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" | grep $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
    outprint

	echo >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log	 
	enout 

else
echo `cat /etc/redhat-release` >> /tmp/precheck_$stamp.log
echo " Execution completed !!! 
Please upload the file : /tmp/precheck_$stamp.log to Oracle Support. 
Thank you. "

fi
fi
;;

2)
clear

if [ `getconf LONG_BIT` == 32 ];
then
 echo " Oracle 12 c is Not Certified on 32 bit Linux"

else

if [ -e /etc/SuSE-release ]; 
 then
    if ((`cat /etc/SuSE-release | grep "Server" | awk '{print $5}'|sed -e 's|\..*$||'`== 11));	
	  then
	   SUSE1164bit12c=( binutils glibc ksh libaio libstdc++33 libstdc++33-32bit libstdc++46 libgcc46 make gcc gcc-c++ glibc-devel libaio-devel libstdc++43-devel sysstat libcap1 libstdc++-devel-4.3  cpp linux-kernel-headers gcc43 gcc43-c++ )
 
      for i in "${SUSE1164bit12c[@]}"
		do
			rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | grep x86_64 | cut -d' ' -f1` 
			outprint	
		done
		enout
	else
		echo " Not certified "
	fi	
		
  elif ((`cat /etc/redhat-release | grep "release" | awk '{print $7}'|sed -e 's|\..*$||'`== 5));
  then
    echo " RHEL 5 Installation check for Oracle 12c "
    echo
	echo $outdv >> /tmp/precheck_$stamp.log
 
    RHEL512c64bit=( binutils glibc ksh libaio libgcc libstdc++ libXext libXtst libX11 libXau libXi make gcc gcc-c++ glibc-devel libaio-devel libstdc++-devel sysstat )
	
	for i in "${RHEL512c64bit[@]}"
	do
		rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | grep x86_64 | cut -d' ' -f1` 
		outprint	
	done
 
 	tocheck=compat-libstdc++
    rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" | grep $tocheck | grep x86_64 | cut -d' ' -f1`
	outprint
 
echo >> /tmp/precheck_$stamp.log
echo >> /tmp/precheck_$stamp.log
echo >> /tmp/precheck_$stamp.log
echo >> /tmp/precheck_$stamp.log
echo "#########################################################" >> /tmp/precheck_$stamp.log
echo >> /tmp/precheck_$stamp.log
echo " Integrity check results for 12.1 , 32 bit client software Installation" >> /tmp/precheck_$stamp.log
echo
echo
echo "*********************************************************"
echo " The below check is for the 32 bit client installation pre-requirements "
echo "*********************************************************"
echo >> /tmp/precheck_$stamp.log
echo "#########################################################" >> /tmp/precheck_$stamp.log
echo >> /tmp/precheck_$stamp.log
echo >> /tmp/precheck_$stamp.log
echo >> /tmp/precheck_$stamp.log

	RHEL512c32bit=( glibc glibc-devel libaio libaio-devel libgcc libstdc++ libXext libXtst libX11 libXau libXi )
	for i in "${RHEL512c32bit[@]}"
	do
		rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | egrep -e "i386|i586|i686" | cut -d' ' -f1` 
		outprint	
	done

	tocheck=compat-libstdc++-*
	rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" | grep $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
    outprint

	echo >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log 
	enout

elif ((`cat /etc/redhat-release | grep "release" | awk '{print $7}'|sed -e 's|\..*$||'`== 6));
then

    echo " RHEL 6 Installation check for Oracle 12c "
    echo
	echo $outdv >> /tmp/precheck_$stamp.log
 
	RHEL612c64bit=( binutils glibc libgcc libstdc++ libaio libXext libXtst libX11 libXau libxcb libXi make sysstat compat-libcap1  gcc gcc-c++ glibc-devel ksh libstdc++-devel libaio-devel glibc-headers compat-libcap1 gcc gcc-c++ glibc-devel ksh libstdc++-devel libaio-devel )
	
	for i in "${RHEL612c64bit[@]}"
	do
		rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | grep x86_64 | cut -d' ' -f1` 
		outprint	
	done
 
 	tocheck=compat-libstdc++
	rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" | grep $tocheck | grep x86_64 | cut -d' ' -f1`
    outprint

echo  >> /tmp/precheck_$stamp.log
echo  >> /tmp/precheck_$stamp.log
echo  >> /tmp/precheck_$stamp.log
echo "#########################################################" >> /tmp/precheck_$stamp.log
echo >> /tmp/precheck_$stamp.log
echo " Integrity check results for 12.1 , 32 bit client software " >> /tmp/precheck_$stamp.log

echo
echo
echo "*********************************************************"
echo " The below check is for the 32 bit client installation pre-requirements "
echo "*********************************************************"

echo >> /tmp/precheck_$stamp.log
echo "#########################################################" >> /tmp/precheck_$stamp.log
echo  >> /tmp/precheck_$stamp.log
echo  >> /tmp/precheck_$stamp.log
echo  >> /tmp/precheck_$stamp.log

    RHEL612c32bit=( glibc glibc-devel libaio libaio-devel libgcc libstdc++ libXext libXtst libX11 libXau libXi libstdc++-devel libxcb )
	
	for i in "${RHEL612c32bit[@]}"
	do
		rpm1=`rpm -q --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" $i | egrep -e "i386|i586|i686" | cut -d' ' -f1` 
		outprint	
	done

	tocheck=compat-libstdc++-*
	rpm1=`rpm -qa --queryformat "%{NAME}-%{VERSION}-%{RELEASE} (%{ARCH})\n" | grep $tocheck | egrep -e "i386|i586|i686" | cut -d' ' -f1`
    outprint
	
	echo >> /tmp/precheck_$stamp.log
	echo >> /tmp/precheck_$stamp.log
	enout   
	 	
fi
fi
;;
*)
clear
echo " Please enter 1 or 2 "
sleep 1
exit 0
;;
esac
