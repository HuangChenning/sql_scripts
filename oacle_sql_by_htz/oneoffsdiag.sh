#!/bin/sh
#
# Copyright (c) 2003, 2010, Oracle and/or its affiliates. All rights reserved.
#
# DESCRIPTION
#   oneoffsdiag.sh script checks whether oneoff patches recorded in $ORACLE_HOME/inventory/ContentsXML/comps.xml
#                  is physically present in $ORACLE_HOME/inventory/oneoffs directory
#                  This script helps to trouble shoot errors like
#                                        "LsInventory Session failed: Unable to create patchObject
#                                         OPatch failed with error code 73"
# USAGE
#   ./oneoffsdiag.sh
#
# NOTES
#   Search for Note ID 1441309.1 in My Oracle Support
#
# ###########################
#
# Author : uaswatha
# Date   : 27/2/2012
#
# ###########################
#
# Modified         (DD/MM/YYYY)
#
#
#####################################################################################################

UNAME=`which uname`
PLATFORMNAME=`$UNAME`;

case $PLATFORMNAME in
    AIX)
        ORA_INST_LOC='/etc'
        LLS='/usr/bin/ls -l'
        LS='/usr/bin/ls'
        ID='/usr/bin/id'
        GREP='/usr/bin/grep'
        ENV='/usr/bin/env'
        UNAME='/usr/bin/uname'
        WHICH='/usr/bin/which'
        FILE='/usr/bin/file'
        WC='/usr/bin/wc'
        SORT='/usr/bin/sort'
        CAT='/usr/bin/cat'
        ZIP='/usr/bin/zip -q -j'
        MKDIR='/usr/bin/mkdir'
        CP='/usr/bin/cp'
        OSLEVEL='/usr/bin/oslevel'
        AWK='/usr/bin/awk'
        DATE='/usr/bin/date'
        BASENAME='/usr/bin/basename'

        HARDPLATFORM=`$UNAME -M`
        HOSTNAME=`$UNAME -n`
        RELEASE=`$UNAME -r`
        VERSION=`$UNAME -v`
        KERNELRELEASE="$VERSION.$RELEASE"
      ;;
    Linux)
        ORA_INST_LOC='/etc'
        LLS='/bin/ls -l'
        LS='/bin/ls'
        ID='/usr/bin/id'
        GREP='/bin/grep'
        ENV='/usr/bin/env'
        UNAME='/bin/uname'
        WHICH='/usr/bin/which'
        FILE='/usr/bin/file'
        WC='/usr/bin/wc'
        SORT='/bin/sort'
        CAT='/bin/cat'
        GREP='/bin/grep'
        ZIP='/usr/bin/zip -q -j'
        MKDIR='/bin/mkdir'
        DATE='/bin/date'
        CP='/bin/cp'
        AWK='/usr/bin/awk'
        BASENAME='/bin/basename'

        HARDPLATFORM=`$UNAME -i`
        HOSTNAME=`$UNAME -n`
        KERNELRELEASE=`$UNAME -r`
      ;;
    HP)
        ORA_INST_LOC='/etc'
        LLS='/usr/bin/ll'
        LS='/usr/bin/ls'
        ID='/usr/bin/id'
        GREP='/usr/bin/grep'
        ENV='/usr/bin/env'
        UNAME='/usr/bin/uname'
        WHICH='/usr/bin/which'
        FILE='/usr/bin/file'
        WC='/usr/bin/wc'
        SORT='/usr/bin/sort'
        CAT='/usr/bin/cat'
        GREP='/usr/bin/grep'
        ZIP='/usr/bin/zip -q -j'
        MKDIR='/usr/bin/mkdir'
        DATE='/usr/bin/date'
        CP='/usr/bin/cp'
        AWK='/usr/bin/awk'
        BASENAME='/usr/bin/basename'

        HARDPLATFORM=`$UNAME -m`
        HOSTNAME=`$UNAME -n`
        KERNELRELEASE=`$UNAME -s $UNAME -r`
      ;;
    IBM)
        ORA_INST_LOC='/etc'
      ;;
    SunOS)
        ORA_INST_LOC='/var/opt/oracle'
        LLS='/usr/bin/ls -l'
        LS='/usr/bin/ls'
        ID='/usr/bin/id'
        GREP='/usr/bin/grep'
        ENV='/usr/bin/env'
        UNAME='/usr/bin/uname'
        WHICH='/usr/bin/which'
        FILE='/usr/bin/file'
        WC='/usr/bin/wc'
        SORT='/usr/bin/sort'
        CAT='/usr/bin/cat'
        ZIP='/usr/bin/zip -q -j'
        CP='/usr/bin/cp'
        DATE='/usr/bin/date'
        AWK='/usr/bin/awk'
        BASENAME='/usr/bin/basename'

        HARDPLATFORM="`$UNAME -i`" "$`UNAME -p`"
        HOSTNAME=`$UNAME -n`
        KERNELRELEASE="`$UNAME -r`" "`$UNAME -v`"
      ;;
esac

LOGDIR="/tmp/opatchdiag"
INVFILE='ContentsXML/inventory.xml'   #### Central Inventory file
COMPSFILE='ContentsXML/comps.xml'     #### Central Inventory file
ORA_INST_FILENAME='oraInst.loc'
FILEDATE="`$DATE +%d_%m_%y_%H_%M_%S`"

echo $KERNELRELEASE


echo -n "Currently LOGDIR is $LOGDIR, do you want to change it [Y/N] "
read CHLOG

while ( [ "$CHLOG" != "Y" ] && [ "$CHLOG" != "N" ] ) && ( [ "$CHLOG" != "y" ] && [ "$CHLOG" != "n" ] )
do
   echo -n "Please enter [Y/N] : "
   read CHLOG
done;

if [ "$CHLOG" = "Y" ] || [ "$CHLOG" = "y" ]; then
   echo -n "Enter directory location where you have permission : "
   read LOGDIR
   if [ ! -O "$LOGDIR" ]; then
      echo "Either directory does not exists or not owned by current user"
      echo "hence retaining /tmp/opatchdiag as LOGDIR"
      echo
      LOGDIR="/tmp/opatchdiag"
   fi
fi
#determine LOGDIR

if [ ! -d "$LOGDIR" ];then
      mkdir -p $LOGDIR
fi

echo "Logdir : " $LOGDIR

LOGFILE="$LOGDIR/oneoffsdiag.log"
ORACLE_CENTRAL_INVENTORY=`$GREP "inventory_loc" $ORA_INST_LOC/oraInst.loc | awk -F'=' '{print $2}'`

if [ ${ORACLE_BASE:-x} = 'x' ]; then
    echo "Oracle Base not set"
    echo -n "Enter Oracle Base path : "
    read ORACLEBASE
    echo $ORACLEBASE
else
    ORACLEBASE=$ORACLE_BASE
    echo "Current Oracle Base is $ORACLE_BASE"
fi

if [ ! -d $ORACLEBASE ] || [ "$ORACLEBASE" = "" ] ; then
   echo "You need to enter valid ORACLE_BASE path..."
   exit 1
fi

####echo Test ${ORACLEBASE}${INVFILE}
####if [ ! -f ${ORACLEBASE}${INVFILE} ]; then
if [ ! -f ${ORACLE_CENTRAL_INVENTORY}/${INVFILE} ]; then
    echo "Inventory file missing....think you have not entered valid ORACLE_BASE"
    echo "Enter valid ORACLE_BASE path"
    exit 1
fi

#if [ "$ORACLEBASE" != */ ]; then
#   ORACLEBASE="$ORACLEBASE"/
#fi

[[ $ORACLEBASE != */ ]] && ORACLEBASE="$ORACLEBASE"/

####echo $ORACLEBASE


if [ ${ORACLE_HOME:-x} = 'x' ]; then
    echo "Oracle Home not set"
    echo -n "Enter Oracle home path : "
    read ORACLEHOME
    echo $ORACLEHOME
else
    ORACLEHOME=$ORACLE_HOME
    echo "Current Oracle Home is $ORACLE_HOME"
fi

if [ ! -d $ORACLEHOME ] || [ "$ORACLEHOME" = "" ]; then
   echo "You need to enter valid ORACLE_HOME path..."
   exit 1
fi

[[ $ORACLEHOME = */ ]] && ORACLEHOME=`echo $ORACLEHOME | sed -e 's/\/$//g'`
CHECK_OH=`$GREP -w $ORACLEHOME ${ORACLE_CENTRAL_INVENTORY}/${INVFILE}`

#if [ ${CHECK_OH:-x} = 'x' ]; then

if [ $? -ne 0 ]; then
    echo "Not able to find $ORACLEHOME in ${ORACLE_CENTRAL_INVENTORY}/${INVFILE}'}"
    echo "think you have entered invalid ORACLE_HOME path"
    echo "Enter valid ORACLE_HOME path"
    exit 1
fi



#AWK='/usr/bin/awk'
#ORACLEHOME='/u03/app/oracle/OraHome_11202g'
#ORACLEBASE='/u01/app/oracle'

export ORACLE_HOME=$ORACLEHOME
export ORACLE_BASE=$ORACLEBASE

cd $ORACLEHOME/OPatch
#####./opatch lsinventory | grep "applied on"|awk '{printf "%s ", $2}'>/tmp/oneoffs

grep "<ONEOFF REF_ID=\".*\" ROLLBACK=\".*\"" $ORACLEHOME/inventory/ContentsXML/comps.xml|awk '{print $4}'|awk -F"\"" '{print $2}' 2>&1 >$LOGDIR/oneoffs

####grep "<ONEOFF " $ORACLEHOME/inventory/ContentsXML/comps.xml|awk '{print $4}'|awk -F"\"" '{print $2}' 2>&1 >/tmp/oneoffs

echo "********************************************************************************************" >$LOGFILE
echo -e "Patch ID\t\tDirectory exists\t\tinventory.xml\t\taction.xml" >>$LOGFILE
echo -e "\t\t\t$ORADCLEHOME/inventory/oneoffs">>$LOGFILE
echo "********************************************************************************************">>$LOGFILE

for i in `cat $LOGDIR/oneoffs`
do
   echo -n -e "$i\t\t" >>$LOGFILE
   if [ -d $ORACLEHOME/inventory/$i ]; then
         echo -n -e "Yes\t\t\t">>$LOGFILE
      if [ -f  $ORACLEHOME/inventory/$i/etc/config/inventory.xml ] ; then
           echo -n -e "Yes\t\t\t">>$LOGFILE
      elif [ -f  $ORACLEHOME/inventory/$i/etc/config/inventory ] ; then
           echo -n -e "Yes\t\t\t">>$LOGFILE
      else
           echo -n -e "No\t\t\t">>$LOGFILE
      fi
      if [ -f  $ORACLEHOME/inventory/$i/etc/config/actions.xml ] ; then
           echo "Yes">>$LOGFILE
      elif [ -f  $ORACLEHOME/inventory/$i/etc/config/actions ] ; then
           echo "Yes">>$LOGFILE
      else
           echo "No">>$LOGFILE
      fi
   else
      echo "ONEOFF DIRECTORY $i not FOUND !!!">>$LOGFILE
   fi
done
 
echo "********************************************************************************************">>$LOGFILE
echo "oneoffs"
echo "********************************************************************************************"
cat $LOGDIR/oneoffs
echo "********************************************************************************************"
echo "oneoffsdiag.log"
cat $LOGDIR/oneoffsdiag.log
