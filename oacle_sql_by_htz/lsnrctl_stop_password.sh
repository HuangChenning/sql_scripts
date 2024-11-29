#!/bin/sh

#
# Sample shutdown script for a password-protected Oracle listener
# Support program for Oracle MetaLink Note 361919.1
#
#
# Written by Adrian Penisoara <adrian.penisoara@oracle.com>
# Copyright (c) 2007 Oracle Corp, Adrian Penisoara
#
# Usage: lsnr_passwd_shutdown.sh [listener name] [password]
#
# Report bugs to <adrian.penisoara@oracle.com>
#

#
# Prerequisites:
#  * you must run this script as the Oracle OS user
#      (e.g. "su oracle -c lsnr_passwd_shutdown.sh MYLISTENER")
#  * you must have the proper environment defined for your Oracle Home
#      (at least PATH, ORACLE_HOME and eventually TNS_ADMIN)
#
# ***NOTE***
#  This script does not work with Oracle 10g or higher versions since
#  the lsnrctl "set password" command will no longer accept an encrypted
#  password as argument
#

LSNRCTL="lsnrctl"

# Check for the proper Oracle environment
if [ "X$ORACLE_HOME" == "X" ]; then
	echo "Error: ORACLE_HOME not defined !"
	exit 1
fi

if [ "`which $LSNRCTL`" == "X" ]; then
	echo "Error: $LSNRCTL binary not found in PATH !"
	exit 2
fi

# Save listener name argument
if [ "X$1" != "X" ]; then
	lsnr_name="$1"
else
	lsnr_name=LISTENER
fi

# Get listener.ora path
if [ "X$TNS_ADMIN" != "X" ]; then
	lsnr_config="$TNS_ADMIN/listener.ora"
else
	lsnr_config="$ORACLE_HOME/network/admin/listener.ora"
fi

if [ ! -r "$lsnr_config" ]; then
	echo "Error: cannot read listener config file $lsnr_config"
	exit 3
fi

# Get the encrypted password
lsnr_passwd="$2"

# Warn about undetected passwords
if [ "X$lsnr_passwd" == "X" ]; then
	echo "warning: password for listener $lsnr_name was not detected in $lsnr_config"
	echo "warning: will shut down listener $lsnr_name without a password"
fi

# Shutdown sequence
(
  echo "set current_listener $lsnr_name"
  if [ "X$lsnr_passwd" != "X" ]; then
	echo "set password $lsnr_passwd"
  fi
  echo "stop"
) | $LSNRCTL 

