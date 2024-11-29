#!/bin/bash

## This script checks :
## a. If a Solaris pre-requisite package for Oracle 11gR2 installation, is installed to the OS.
##    If not, will show in the output. 
## b. Checks the integrity of the installed packages.
##    If the dependant files of the package are deleted/corrupted, this will be shown in the output.


##    Version 1.0
##    Jan/27/2013

stamp=`date +%F_%H-%M-%S`
touch /tmp/precheck_$stamp.log
outdv="---------------------------------------------------------"

echo "
$outdv
How to read the Output log file  :
1. If there are no messages/output logged , then the installation is successfull.
2. If a package is not installed, this will be mentioned as :
   ERROR: Information for PACKAGE not found 
3. If some dependant file is missing from an installed package, this will be mentioned as :
   missing file from <package name>
$outdv    " >> /tmp/precheck_$stamp.log

echo >> /tmp/precheck_$stamp.log
echo >> /tmp/precheck_$stamp.log

echo
	   
outprint()
{

        a=`pkgchk $pgchk 2>&1`
        if [ -n "$a" ]
		then
        	echo $a >> /tmp/precheck_$stamp.log 2>&1
		    echo  >> /tmp/precheck_$stamp.log 
			echo "The above message is for package : $pgchk  " >> /tmp/precheck_$stamp.log
			echo $outdv >> /tmp/precheck_$stamp.log
        fi
}

maincontent()
{

	echo " Executing the pre-requisite check for 11gR2 installation on Solaris server......"
	echo

	pgchk="SUNWarc"
	pkginfo $pgchk >> /dev/null 2>&1	
	if [ `echo $?` != 0 ];
	then
		echo " Package SUNWarc not installed " >> /tmp/precheck_$stamp.log
		echo $outdv >> /tmp/precheck_$stamp.log
		else
        echo " Checking the integrity for : $pgchk "        
		outprint
	fi

	pgchk="SUNWbtool"	
	pkginfo $pgchk >> /dev/null 2>&1
	if [ `echo $?` != 0 ];
	then
		echo " Package SUNWbtool not installed " >> /tmp/precheck_$stamp.log
		echo $outdv >> /tmp/precheck_$stamp.log
		else
        echo " Checking the integrity for : $pgchk "        
		outprint
	fi

	pgchk="SUNWcs1"	
	pkginfo $pgchk >> /dev/null 2>&1
	if [ `echo $?` != 0 ];
	then
		echo " Package SUNWarc not installed " >> /tmp/precheck_$stamp.log
		echo $outdv >> /tmp/precheck_$stamp.log
		else
        echo " Checking the integrity for : $pgchk "        
		outprint
	fi
	
	pgchk="SUNWhea"
	pkginfo $pgchk >> /dev/null 2>&1
	if [ `echo $?` != 0 ];
	then
		echo " Package SUNWhea not installed " >> /tmp/precheck_$stamp.log
		echo $outdv >> /tmp/precheck_$stamp.log
		else
        echo " Checking the integrity for : $pgchk "        
		outprint
	fi

	pgchk="SUNWil5cs"
	pkginfo SUNWil5cs >> /dev/null 2>&1
	if [ `echo $?` != 0 ];
	then
		echo " Package SUNWil5cs not installed " >> /tmp/precheck_$stamp.log
		echo $outdv >> /tmp/precheck_$stamp.log
		else
        echo " Checking the integrity for : $pgchk "        
		outprint
	fi


	pgchk="SUNWilcs"	
	pkginfo $pgchk >> /dev/null 2>&1
	if [ `echo $?` != 0 ];
	then
		echo " Package SUNWilcs not installed " >> /tmp/precheck_$stamp.log
		echo $outdv >> /tmp/precheck_$stamp.log
		else
        echo " Checking the integrity for : $pgchk "        
		outprint
	fi

	
	pgchk="SUNWilof"	
	pkginfo $pgchk >> /dev/null 2>&1
	if [ `echo $?` != 0 ];
	then
		echo " Package SUNWilof not installed " >> /tmp/precheck_$stamp.log
		echo $outdv >> /tmp/precheck_$stamp.log
		else
        echo " Checking the integrity for : $pgchk "        
		outprint
	fi

	pgchk="SUNWlibC"	
	pkginfo SUNWlibC >> /dev/null 2>&1
	if [ `echo $?` != 0 ];
	then
		echo " Package SUNWlibC not installed " >> /tmp/precheck_$stamp.log
		echo $outdv >> /tmp/precheck_$stamp.log
		else
        echo " Checking the integrity for : $pgchk "        
		outprint
	fi

	pgchk="SUNWlibm"	
	pkginfo $pgchk >> /dev/null 2>&1
	if [ `echo $?` != 0 ];
	then
		echo " Package SUNWlibm not installed " >> /tmp/precheck_$stamp.log
		echo $outdv >> /tmp/precheck_$stamp.log
		else
        echo " Checking the integrity for : $pgchk "        
		outprint
	fi
	

	pgchk="SUNWlibms"	
	pkginfo SUNWlibms >> /dev/null 2>&1
	if [ `echo $?` != 0 ];
	then
		echo " Package SUNWlibms not installed " >> /tmp/precheck_$stamp.log
		echo $outdv >> /tmp/precheck_$stamp.log
		else
        echo " Checking the integrity for : $pgchk "        
		outprint
	fi
	

	pgchk="SUNWsprot"	
	pkginfo $pgchk >> /dev/null 2>&1
	if [ `echo $?` != 0 ];
	then
		echo " Package SUNWsprot not installed " >> /tmp/precheck_$stamp.log
		echo $outdv >> /tmp/precheck_$stamp.log
		else
        echo " Checking the integrity for : $pgchk "        
		outprint
	fi


	pgchk="SUNWtoo"	
	pkginfo $pgchk >> /dev/null 2>&1
	if [ `echo $?` != 0 ];
	then
		echo " Package SUNWtoo not installed " >> /tmp/precheck_$stamp.log
		echo $outdv >> /tmp/precheck_$stamp.log
		else
        echo " Checking the integrity for : $pgchk "        
		outprint
	fi

	
	
	pgchk="SUNWxwfnt"	
	pkg1=`pkginfo $pgchk >> /dev/null 2>&1`
	if [ `echo $?` != 0 ];
	then
		echo " Package SUNWxwfnt not installed " >> /tmp/precheck_$stamp.log
		echo $outdv >> /tmp/precheck_$stamp.log
		else
        echo " Checking the integrity for : $pgchk "        
		outprint
	fi
}

# Get OS version
osver=`uname -r`

# Check OS version
if [ ${osver} = "5.10" ]; then
 updlevel=` cat /etc/release | head -1 | sed 's/.*_u\(.*\)wos.*/\1/'`
 if [ $updlevel -gt 5 ];
 then
  maincontent
  echo "Execution completed !!! 
        Please upload the file : /tmp/precheck_$stamp.log to Oracle Support. 
        Thank you. "
  else
 echo " The Operating System is not in the Supported update level.
        The update level should be 6 or higher "		
 fi		

elif [ ${osver} = "5.11" ]; then
  maincontent
  echo "Execution completed !!! 
Please upload the file : /tmp/precheck_$stamp.log to Oracle Support. 
Thank you. "  
  else
echo "Unknown or unsupported OS version"
fi
