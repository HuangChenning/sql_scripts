:
# evon.sh - Sets events on processes for a given Oracle instance id
#
# NOTE: This script is supplied on an "as is" basis and should be tested
#       by the user before it is used.
#
# Written by Kev Quinn

ME=`basename $0`

if [ "$ORACLE_SID" = "" ]
then
 echo "$ME: Error, must have ORACLE_SID defined."
 exit 1
fi

# The following is used to identify the processes to be posted.
STEM="oracle${ORACLE_SID}"

cat - <<!
WARNING
~~~~~~~
 Proceeding with this command will post ALL Oracle shadow processes that
 are used by instance [$ORACLE_SID] with ORADEBUG commands that will affect
 the way these processes execute.

 If you DO want to continue then please type 'Y' or 'y'. 
 Any other response will be assumed to mean that we should abort this
 command.

Please enter response :
!

read trash 
case "$trash" in
 y|Y) 
     ;;
 *)
   echo "$ME: Command aborted."
   exit 2 
     ;;
esac

TMPFILE="/tmp/evon.$$"
CNT=0

echo "Date `date` - Instance $ORACLE_SID" > $TMPFILE
echo "Events were set ON for the following Oracle processes :" >> $TMPFILE

for proc in `ps -ef | grep "$STEM" | awk '/grep/ {next} \
{print $2}'`
do
 echo "Setting events for process $proc"
 echo "$proc" >> $TMPFILE
 CNT=`echo "$CNT+1"|bc`
 svrmgrl <<!
connect internal
oradebug setospid $proc 
oradebug event immediate trace name trace_buffer_on level 102400
oradebug event 10998 trace name context forever, level 255
!
done

cat - <<!

Script completed - $CNT processes were posted
~~~~~~~~~~~~~~~~
 For a full list of processes that have been posted please see the
 file named $TMPFILE

 Once reviewed this file can be deleted.
!
