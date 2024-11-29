:
# trcsummary		RPOWELL@UK.ORACLE.COM
#
# To use this wrapper script you need to set AWK to the relevant awk
# command on your machine. This may need to be 'nawk' rather than 'awk'
# to allow the trcsummary.awk script to work.
#
# You should also set DIR to the directory holding 'trcsummary.awk'
# If DIR is not set it defaults to $INFO_HOME/suptools/etc/trcsummary.awk
#  if INFO_HOME is set and '.' if not.
#
if [ "$1" = "" ]; then
	echo "Usage: `basename $0` tracefile"
	exit
fi;
#
if [ "$AWK" = "" ]; then
	echo "This script needs \$AWK set to know which AWK to use"
	exit
fi;
if [ "$DIR" = "" ]; then
	if [ "$INFO_HOME" = "" ]; then
		DIR=.
	else
		DIR=$INFO_HOME/suptools/etc
	fi;
fi;
DEBUG=0
VERBOSE=0
FILENAME=
if [ "$1" = "" ]; then
        echo "Usage: `basename $0` [-d] [-v] tracefile"
        echo "  sql = Show User statements and Plans from trace file"
        echo "  full = Show recursive statements also"
        echo "  -d = Debug mode"
        echo "  -v = Verbose mode"
        exit
fi;
for i in $* 
do
        if [ "$i" = "-d" ]; then
                DEBUG=1
        else
        if [ "$i" = "-v" ]; then
                VERBOSE=1
        else
        if [ "$i" = "sql" ]; then
                DEPTH=1
        else
        if [ "$i" = "full" ]; then
                DEPTH=9999
        else
                FILENAME=$i
        fi; fi; fi; fi; 
        shift
done;
#
$AWK -v DBG=$DEBUG -v VERBOSE=$VERBOSE -v DEPTH=$DEPTH \
        -F'=' -f $DIR/trcsummary.awk $FILENAME
#
