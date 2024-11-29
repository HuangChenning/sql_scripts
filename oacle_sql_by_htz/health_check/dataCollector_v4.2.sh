####################################################################################################
##                                                                                                ##
## Author : HongyeDBA @ Enmotech                                                                  ##
##                                                                                                ##
##------------------------------------------------------------------------------------------------##
##                +d:                                                                             ##
##                `hds`                   .`                                                      ##
##                 -ddh+`                /h`                                                      ##
##                  odddh+              /hy`                                                      ##
##                  .hdhhhhs.`        ./hhy.                                                      ##
##                  `shhhhhhhh/`     /yhyhy-                                                      ##
##                   ohhhhhhhhho.  `/hhyyhh:                                                      ##
##                   -hhhhyhhhhhh: ohhhshhy/                                                      ##
##                    -yhhhyyhhhhy+hhhyyyyy:                                                      ##
##                    `shhhhyyhhhhhyyyoyyyy-                                                      ##
##                `.``` :yhhhsyhyyyyyssyyy+    .-`-:-`                                            ##
##     `.``-::osysyhhhhysshhyyssyyyyy+yyys+oyyyyyy+.                                              ##
##    `:osyhhhyyyhhhhhhhyyy[ HongyeDBA ]yyyyssyys:                                                ##
##         ./syhyyyyysssyyyyyyyyssyy+yyyssssyyo.                                                  ##
##            `:+osyyyyysssoooosysoossoo++/:.                                                     ##
##                 .:/+//+syyyysoo/:/+sys/`                                                       ##
##                    `:syyyyyssoo+.`   `.`                                                       ##
##                   :yyyssssssoy/  `.                                                            ##
##                 :syysso+/-` `-    `.                                                           ##
##               -+o/:-.`             `.                                                          ##
##              ``                     `.                                                         ##
##                                      `.                                                        ##
####################################################################################################
##         |      |                  |                                                            ##
## Version | Beta | Complete Time    | Description                                                ##
##---------|------|------------------|------------------------------------------------------------##
##     1.0 |      | 2013-01-05 16:50 | First Edition                                              ##
##     1.1 |      | 2013-01-10 12:00 | Bug Fixed                                                  ##
##     1.2 |      | 2013-01-22 15:11 | Add More Profile, Top Waits, Controller ,                  ##
##         |      |                  | Bug Fixed                                                  ##
##     1.3 |      | 2013-01-29 12:44 | Add -d Option, Support Input DBID                          ##
##         |      |                  | Bug Fixed                                                  ##
##     1.4 |      | 2013-02-16 17:17 | Bug Fixed                                                  ##
##     1.5 |      | 2013-02-22 11:11 | Collect More Statistics for SQL Report                     ##
##     1.6 |      | 2013-07-17 22:22 | Add Top Days Controller, default 8 Days                    ##
##         |      |                  | Support Statspack Collection                               ##
##         |      |                  | Tuning Some Collect SQL used in the tools                  ##
####################################################################################################
##     2.0 |      | 2013-08-08 19:30 | Directly Create Graphic HTML for AWR                       ##
##         |      |                  | Change Script Name to getDBData                            ##
##         |      |                  | Fix Some little Bugs                                       ##
##         |      |                  | Fix Time Limit Bug when use -d option                      ##
##---------|------|------------------|------------------------------------------------------------##
##     2.1 |      | 2013-08-11 03:30 | Directly Create Graphic HTML for Wait Event                ##
##         |      |                  | add get_awrdump() function, collect awr dump               ##
##         |      |                  | add get_metadata() function, collect metadata              ##
####################################################################################################
##     3.0 |      | 2013-08-14 22:11 | Rename Scripts to dataCollector                            ##
##         |      |                  | Merge getOSData Script into dataCollector                  ##
##         |      |                  | Merge snapshot Script into dataCollector                   ##
##         |      |                  | Add Colored Help Message                                   ##
##         |      |                  | Add -u option, allow system and sys users                  ##
##---------|------|------------------|------------------------------------------------------------##
##     3.1 |      | 2013-08-20 23:57 | Fix Grid Discovery in 11g RAC                              ##
##         |      |                  | Fix ASM Alert Collection in 11g RAC                        ##
##         |      |                  | Fix input user cannot work in getOSData                    ##
##         |      |                  | Fix snapshot script in non-sys user                        ##
##         |      |                  | Add more tips to show errors or warnings                   ##
##         |      |                  | Add CPU Time Graphic in AWR Info Section                   ##
##         |      |                  | Add Function get_spdump() to Collect Statspack Dump        ##
##         |      |                  | Change default setting : not collect AWR at night          ##
##         |      |                  | More Effective in auto get CRS or Grid Home                ##
##         |      |                  | Some other changes that I cannot remember                  ##
##---------|------|------------------|------------------------------------------------------------##
##     3.2 |      | 2013-08-29 17:37 | Create HTML Graphic Trend for STATSPACK                    ##
##         |      |                  | Fix Oracle Environment not Set Bug                         ##
##         |      |                  | Add More Control for any other Graphic you want            ##
##---------|------|------------------|------------------------------------------------------------##
##     3.3 |      | 2013-09-06 13:50 | Fix -g option in Oracle 9i with STATSPACK Collected        ##
##         |      |                  | Fix OS Info Collected into Wrong Result File               ##
##         |      |                  | Fix Shell Environment Setting Error                        ##
##         |      |                  | Add More Types of log, Mark Error Message with Red         ##
##         |      |                  | Fix Conflict between -d option and SQL Script              ##
##         |      |                  | Fix Oracle Environment Error in OS Data Scripts            ##
##         |      |                  | Show Data to be Collected Tips for user Conform            ##
##         |      |                  | Add -q Option to choose which SQL Script to use            ##
##         |      |                  | Fix Logical Read Calculation Method                        ##
##---------|------|------------------|------------------------------------------------------------##
##     3.4 |      | 2013-09-19 21:30 | Add    : Mostly Used Command                               ##
##         |      |                  | Modify : Directory Structure to meet File Server           ##
##         |      |                  | Modify : Hostname use non-domain name                      ##
##         |      |                  | Fix Bug: Top AWR in the Edge of the Time Type              ##
##         |      |                  | Add    : Add -I to user Interactive Mode                   ##
##---------|------|------------------|------------------------------------------------------------##
##     3.5 |      | 2013-10-12 17:52 | Fix Bug: Hostname, prtconf(AIX), SQL STMT                  ##
##         |      |                  | Modify : Linux Needed Packages Check                       ##
##         |      |                  | Modify : More Time Controller in Interactive Mode          ##
##         |      |                  | Fix Bug: NLS Parameter has Blank when Using export         ##
##         |      |                  | Fix Bug: Instance Number not Sequence from 1               ##
##         |      |                  | Add    : Add -z to Remove and Pack Automatic               ##
##         |      |                  | Fix Bug: No Records in STATS$DATABASE_INSTANCE             ##
##         |      |                  | Modify : Merge Stat Graphic into one HTML                  ##
##         |      |                  | Modify : Remove -I Option and Make it Default              ##
##         |      |                  | Modify : Reduce Command Code to 5 Number                   ##
##---------|------|------------------|------------------------------------------------------------##
##     3.6 |  [a] | 2013-10-12 22:52 | Fix Bug: Endless Opatch, Wrapped Alert Name                ##
##         |  [b] | 2013-10-14 17:57 | Fix Bug: OSinfo in HP-UX, get_dbinfo scene, GV$DB          ##
##         |  [b] | 2013-10-15 19:17 | Fix Bug: Alertfile Last Date Before Our Begin Date         ##
##         |  [c] | 2013-10-20 20:07 | Fix Bug: Graphic Error in Statspack with new Method        ##
##         |  [c] | 2013-10-20 22:52 | Modify : Fixed AWR Graphic with Top Points Removed         ##
##         |  [c] | 2013-10-26 20:36 | Modify : Split Parse Function, Call with Init Func         ##
##         |  [c] | 2013-10-27 10:45 | Add    : Add -S to Control Snapshot Collection             ##
##         |  [c] | 2013-10-27 23:45 | Add    : Add OS Load Collection in Current Execution       ##
##         |  [c] | 2013-10-28 00:36 | Modify : Move Script's Log into Others Directory           ##
##         |  [c] | 2013-10-28 19:16 | Modify : Add sqlrpt_optimizer to Merge same SQL            ##
##         |  [d] | 2013-10-29 17:16 | Add    : Add Links between SQL Report and AWR Report       ##
##         |  [d] | 2013-10-29 23:56 | Add    : Add Index File with AWR Report Links              ##
##         |  [d] | 2013-10-30 10:56 | Add    : Add Other Reports Links to Index File             ##
##         |  [e] | 2013-10-30 23:38 | Add    : Add SQL Reports to Index File, Fix Grid Width     ##
##         |  [e] | 2013-10-30 23:38 | Modify : Change Bucket Selection, Support Multi-Select     ##
##         |  [e] | 2013-11-03 02:21 | Add    : Add Alert Errors to Report Index File             ##
##         |  [f] | 2013-12-10 20:21 | Add    : Add -T option, allow input AWR Collection Days    ##
##         |  [f] | 2013-12-10 21:40 | Add    : Add -e option, Set AWR Time Calculate Method      ##
##         |  [f] | 2013-12-11 13:29 | Modify : Modify Alert Scanner, Capture Start/Stop/Alert    ##
##         |  [f] | 2013-12-16 20:45 | Fix Bug: Solaris Swap size Collection Method Error         ##
##         |  [g] | 2014-01-23 10:40 | Add    : Add Import Script to Load Metadata into DB        ##
##         |  [g] | 2014-01-23 10:40 | Modify : Modify SQL Report in -d Condition with More Data  ##
####################################################################################################
##     4.0 |  [a] | 2014-01-23 17:04 | Modify : Change All Chinese Message to English             ##
##         |      |                  | Modify : Modify Metadata Importer, Add Error Checker       ##
##         |  [a] | 2014-01-24 13:44 | Add    : Add Bind Value Information into SQL Report        ##
##         |      |                  | Modify : Move Index File into Root of Result Directory     ##
##         |  [a] | 2014-01-27 21:44 | Fix Bug: Fix Bug in : no AWR, Statspack, SQL Report        ##
##         |      |                  | Fix Bug: Alert Collection Eneless Bug: Latest Date Too Old ##
##         |      |                  | Modify : Alert Message with Colors                         ##
##         |      |                  | Fix Bug: Alert Error Table doesnot Show First Time         ##
##         |  [a] | 2014-02-22 11:14 | Fix Bug: Memory in AIX and Listener Status Result          ##
##         |  [a] | 2014-03-03 16:24 | Add    : Add -r Option to Collect RAC Data in One Node     ##
##         |      |                  | Add    : Add -n Option to Collect Data in Silent Mode      ##
##---------|------|------------------|------------------------------------------------------------##
##     4.1 |  [-] | 2014-03-03 17:14 | -------> Script Released                                   ##
##         |  [a] | 2014-03-24 15:54 | Modify : Add Hint /*+ RULE */ to Avoid Hang in Select      ##
##         |  [a] | 2014-03-26 11:34 | Fix Bug: Fix AWR/SQL/Dump Collection Bug in 11.2.0.4       ##
##         |      |                  | Fix Bug: Fix Snapshot Index Title Error                    ##
##         |  [b] | 2014-05-14 15:00 | Modify : Show AWR End Time in Index File                   ##
##         |      |                  | Modify : Change Fixed Stats from [5, 3] to [3, 8]          ##
##         |  [b] | 2014-05-18 09:33 | Fix Bug: Fixed MaxSize < Size in Tablespace Section        ##
##---------|------|------------------|------------------------------------------------------------##
##     4.2 |  [-] | 2014-05-22 14:04 | -------> Script Released                                   ##
##         |      |                  |                                                            ##
####################################################################################################
#
# Functions List Below :
#   Function set_oraEnv()        : Set Oracle Related Environment
#   Functions check and parse    : Check and Parse User Input
#   Function list_collected()    : List All Data to be Collected with the Scripts
#   Function create_Dir()        : Create All Needed Directories
#   Function initialization()    : Check User Inputs
#   Function get_dbinfo()        : Get Needed Database information
#   Function calculate_time()    : Calculate AWR Collection Time
#   Function get_awrrpt()        : Get AWR Report in HTML Format
#   Function get_awrinfo()       : Get AWR Stat Information in txt Format, for Trend Graphic
#   Function begin_statGraphic() : Write Begin info to Graphic HTML File
#   Function end_statGraphic()   : Write End info to Graphic HTML File
#   Function get_awr_needed()    : Get Needed information for Generate AWR Report
#   Function get_sql_needed()    : Get Needed information for Generate AWR SQL Report
#   Function get_sqlrpt()        : Get SQL Report in HTML Format
#   Function get_top_waits()     : Get Top N Waits in Generated Report
#   Function get_awr_profile()   : Get AWR Profile Information
#   Function build_index()       : Build Report Index File
#   Function rpt_optimizer()     : Optimizer AWR or STATSPACK Need File, Merge same Report
#   Function get_sprpt()         : Get STATSPACK Report in TEXT Format
#   Function get_spinfo()        : Get STATSPACK Stat Information in txt Format, for Trend Graphic
#   Function sqlrpt_optimizer()  : Optimizer SQL Need File, Merge same SQL
#   Function get_sp_needed()     : Get Needed information for Generate STATSPACK Report
#   Function get_spsql_needed()  : Get Needed information for Generate STATSPACK SQL Report
#   Function get_spsqrpt()       : Get STATSPACK SQL Report in TEXT Format
#   Function make_html_graphic() : Create HTML Header for Graphic HTML
#   Function make_sql_script()   : Create Enmotech SQL Report Script
#   Function make_os_scripts()   : Create getOSData Scripts
#   Function make_snap_scripts() : Create Enmotech Snapshot Scripts
#   Function get_snapshot()      : Collect Snapshot Result
#   Function get_osdata()        : Get OS Data by getOSData Scripts
#   Function get_osload()        : Start/Stop OS Load in backgroud
#   Function get_awrdump()       : Get AWR Dump File
#   Function get_spdump()        : Get STATSPACK Dump File
#   Function make_metaScripts()  : Create Metadata Import Scripts
#   Function get_metadata()      : Export Metadata
#   Function interactive_mode()  : Add or Remove needed Data in the Bucket
#   Main Function                : Main Function for the Program
#
#########################################################################################################
##                                                                                                     ##
## Prepared Environments                                                                               ##
##                                                                                                     ##
#########################################################################################################
__SCRIPT_NAME=${0}                 # Get Current Script Name
__CURRENT_OSUSER=${USER}           # Get Current Logon User
__OS_PLATFORM=`uname`              # Get Current OS Platform
__ORACLE_HOME=${ORACLE_HOME}       # Get Oracle Home from Environment
__ORACLE_SID=${ORACLE_SID}         # Get Oracle SID from Environment
__ORAENV_SETTINGS=""
__INST_NUM=0                       # We will get instance number from database if the value is 0
__DBID=""                          # We will get DBID from v$database if the value is ""
__DB_BLOCK_SIZE=0                  # We will get DBID from v$parameter
__DB_VERSION=10                    # We will get DB Version from v$instance
__DB_ROLE=''                       # We will get DB Role from v$database
__DB_VERSION_MAJOR=0
__DB_VERSION_MINOR=2
__SCRIPT_VERSION="4.2"
__SNAP_VERSION=-1
__HOSTNAME=`hostname -s 2>/dev/null`
if [ "${__HOSTNAME}" = "" ]; then
  __HOSTNAME=`hostname`
fi

# Directories in the Scripts
__RESULT_DIR=dataCollector_${__HOSTNAME}_${__ORACLE_SID}_`date +"%Y%m%d"`
__DUMP_DIR=${__RESULT_DIR}/Data
__SCRIPT_DIR=${__RESULT_DIR}/Logs
__OSDATA_DIR=${__RESULT_DIR}/OS_Info
__AWRRPT_DIR=${__RESULT_DIR}/AWR_Reports
__SPRPT_DIR=${__RESULT_DIR}/AWR_Reports
__SQLRPT_DIR=${__RESULT_DIR}/SQL_Reports
__STAT_DIR=${__RESULT_DIR}/Charts
__PROFILE_DIR=${__RESULT_DIR}/Charts
__TRACE_DIR=${__RESULT_DIR}/Trace
__REPORT_DIR=${__RESULT_DIR}/Reports
__OTHER_DIR=${__RESULT_DIR}/Others

# Files in the Scripts
__SQL_FILE=${__OTHER_DIR}/sql_executed.sql
__RPT_NEEDED=${__OTHER_DIR}/rpt_needed.info
__SQL_NEEDED=${__OTHER_DIR}/sql_needed.info
__SQL_SCRIPT=''
__SNAP_SCRIPT=${__OTHER_DIR}/snapshot_v
__SNAP_LOGFILE=${__OTHER_DIR}/snapshot.log
__INSTANCE_INFO_FILE=${__OTHER_DIR}/instance.info
__OS_SCRIPT=${__OTHER_DIR}/osDataCollector.pl
__GRAPHIC_HEADER=${__OTHER_DIR}/graphic_header.tmp
__STATS_GRAPHIC_FILE=${__STAT_DIR}/awrStats.html
__WAITS_GRAPHIC_HTML=${__STAT_DIR}/awr_top_waits.html
__STATS_GRAPHIC_END=${__SCRIPT_DIR}/awrStats.end
__INDEX_HTML=${__RESULT_DIR}/index.html
__INDEX_INFO=${__OTHER_DIR}/index.info
__ALERT_HTML=${__OTHER_DIR}/alertHTML.info

# Control Variables
__RPT_LIMIT=3
__SQL_LIMIT=5
__WAIT_LIMIT=5
__TOP_LIMIT=8
__AWR_TIME_BEGIN=""
__AWR_TIME_END=""
__AWR_TIME_TYPE='Direct'
__TOP_DAYS=9
__USE_STATSPACK=0
__SNAPSHOT_TYPE='B'
__SQLPLUS_USER="sys/oracle"
__PERFSTAT_USER="PERFSTAT"
__SHELL=`echo $SHELL`
__OTHER_GRAPHIC=""
__OSLOAD_COLLECTED="0"
__SQL_TYPE="M"
__INTERACTIVE_MODE="0"
__PACK_RESULT=0
__USER_INPUT_CHAR=""
__SILENT_MODE=0
__RAC_NODES=""

# Variables for Fixed Graphic Trendline
__GRAPHIC_FIX_MAXMULTIPLE=3
__GRAPHIC_FIX_MAXTIMES=8
__GRAPHIC_FIX_FILE=${__STAT_DIR}/awrStats_fixed.html

# dbtime , logical , physical
__STAT_NAME="none"
__LOGFILE=dataCollector_v${__SCRIPT_VERSION}.log
__ERRORFILE=dataCollector_v${__SCRIPT_VERSION}.err
__DELETE_FILE=${__OTHER_DIR}/removeTempFile.sh

# Commands
__C_CODE="initByHongyeDBA"
__C_AWR_DBTIME="1"
__C_AWR_LOGICAL="1"
__C_AWR_PHYSICAL="0"
__C_AWR_DAY="1"
__C_AWR_NIGHT="0"
__C_SQL_ELAPSE="1"
__C_SQL_BUFFER="1"
__C_SQL_DISK="0"
__C_SQL_EXECUTION="0"
__C_SQL_DAY="1"
__C_SQL_NIGHT="0"
__C_AWR_STATS="1"
__C_AWR_PROFILE="1"
__C_AWR_WAIT="1"
__C_METADATA="0"
__C_AWRDUMP="0"

# Variable for getOSData Scripts
__X_CODE="11111"
__DB_ALERT_FILE=""
__ASM_ALERT_FILE=""
__BEGIN_TIME=""

# Main Code Collect Option
__M_CODE="111"
__M_OSDATA=1
__M_DBDATA=1
__M_SNAPSHOT=1

# OS Load Parameters
__OSLOAD_RESULT=${__OSDATA_DIR}/osLoad.txt
__OSLOAD_SWITCHER=${__OTHER_DIR}/osLoadSwitcher.info
__OSLOAD_SCRIPT=${__OTHER_DIR}/osLoad.sh

print_log(){
  # Parameters :
  # $1   : Function Name
  # $2   : Log Type, Null for Normal Message
  #        0  ==> Normal Message
  #        1  ==> Need User Input
  #        2  ==> Show Red Message
  #        3  ==> Show Blink Message
  #        4  ==> Print SQL Statement into SQL File
  #        5  ==> Add File to Remove File Scripts
  #        6  ==> Show Message with Blue Background and White Font
  #        8  ==> Collect Data with Interactive Mode
  #        9  ==> Only Write to Logfile
  # $3~$9: All Messages
  MYDATE=`date +"%Y-%m-%d %H:%M:%S"`
  case ${2} in
  1)
    printf "%18s%22s : %s\n%s" "${MYDATE}" "$1" "$4$5$6$7$8$9" "==========[ Waiting for input ]=========> " | tee -a ${__LOGFILE}
    if [ "$3" = "Y" ]; then
      stty -echo
      read __USER_INPUT_CHAR
      stty echo
      echo ""
    else
      read __USER_INPUT_CHAR
    fi
    printf "%s\n" "${__USER_INPUT_CHAR}" >> ${__LOGFILE}
  ;;
  2)
    printf "%18s%22s : \033[31m%s\033[0m \n" "${MYDATE}" "$1" "$3$4$5$6$7$8$9"
    printf "%18s%22s : %s\n" "${MYDATE}" "$1" "$3$4$5$6$7$8$9" >> ${__LOGFILE}
  ;;
  3)
    printf "%18s%22s : \33[5m%s\033[0m \n" "${MYDATE}" "$1" "$3$4$5$6$7$8$9"
    printf "%18s%22s : %s\n" "${MYDATE}" "$1" "$3$4$5$6$7$8$9" >> ${__LOGFILE}
  ;;
  4) printf ">>>>>>>>>>>>>>>>>>>> : Function : %s , Comment : %s\n%s\n================================================================\n\n" "$1" "$3" "$4" >> ${__SQL_FILE} ;;
  5) echo "rm `pwd`/${3} 2>/dev/null" >> ${__DELETE_FILE} ;;
  6)
    printf "%18s%22s : \033[34m%s\033[0m \n" "${MYDATE}" "$1" "$3$4$5$6$7$8$9"
    printf "%18s%22s : %s\n" "${MYDATE}" "$1" "$3$4$5$6$7$8$9" >> ${__LOGFILE}
  ;;
  8)
    printf "%18s%22s : %s\n%s" "${MYDATE}" "$1" "$4$5$6$7$8$9" "==========[ Waiting for input ]=========> DC_${__SCRIPT_VERSION} [$3] > " | tee -a ${__LOGFILE}
    read __USER_INPUT_CHAR
    printf "%s\n" "${__USER_INPUT_CHAR}" >> ${__LOGFILE}
  ;;
  9)
    printf "%18s%22s : %s\n" "${MYDATE}" "$1" "$3$4$5$6$7$8$9" >> ${__LOGFILE}
  ;;
  *) printf "%18s%22s : %s\n" "${MYDATE}" "$1" "$3$4$5$6$7$8$9" | tee -a ${__LOGFILE} ;;
  esac
}

__COLORED_HELP_MESSAGE="\033[41;37m           Name : dataCollector_v${__SCRIPT_VERSION}.sh                                                                     \033[0m
\033[41;37m        Version : ${__SCRIPT_VERSION}                                                                                       \033[0m
\033[41;37m         Author : HongyeDBA@Enmotech                                                                        \033[0m
\033[41;37m    Last Modify : 2014-03-03 16:24                                                                          \033[0m
\033[41;37m  \033[44;37m        Usage : ./dataCollector_v${__SCRIPT_VERSION}.sh [options [option args]]                                         \033[41;37m  \033[0m
\033[41;37m  \033[0m\033[44;37m      Options :                                                                                         \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-a :\033[0m Collect All Data                                                                   \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-b :\033[0m Input Begin Time [20121212] when Alert been Collected, default 31 days ago         \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-c :\033[0m Input Command Code, 5 Number Separated by [.], see also \033[34m\033[4m\"Command Code\"\033[0m Section     \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-d :\033[0m Input DBID, Default: get DBID from V\$DATABASE                                      \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-e :\033[0m Time Calculation Type Set to [Truncated Day], Default is [Direct Calculate]        \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-f :\033[0m Input DB Alert Manual, Default: get it from Running Instance                       \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-F :\033[0m Input ASM Alert Manual, Default: get it from Running Instance                      \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-g :\033[0m Input Other AWR/STATSPACK Stat Graphic as [G1#G2...], Gn format as below :         \033[41;37m  \033[0m
\033[41;37m  \033[0m                     <FILE>|<STAT NAME>|<CONVERT OPTION>|<HTML TITLE>|<HTML SUB TITLE>|<HTML_Y>|<TYPE>  \033[41;37m  \033[0m
\033[41;37m  \033[0m                     \033[31m>>> !!! Do not Use Without Fully Understand this Option !!! <<<                    \033[41;37m  \033[0m
\033[41;37m  \033[0m                     \033[34mExample: cputime|DB CPU|/1000000|CPU Time|Unit：CPU Time/s|CPU Time|T              \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-h :\033[0m Show the help message                                                              \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-i :\033[0m Input ORACLE_SID                                                                   \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-l :\033[0m Input Report Limit , Means Top n AWR or STATSPACK Report, default 3                \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-L :\033[0m Input Top SQL Limit, Means Top n SQL Report, default 5                             \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-m :\033[0m Input Main Collection Catagory, default [111], see also \033[34m\033[4m\"Command Code\"\033[0m Section     \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-n :\033[0m Run in Silent Mode, no Need to Input                                               \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-o :\033[0m Input ORACLE_HOME                                                                  \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-p :\033[0m collect STATSPACK instead of AWR, (for 9i or force collect STATSPACK)              \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-q :\033[0m Input SQL Report Type, Valid Values are : B(Basic), M(Middle), H(High), R(Repo)    \033[41;37m  \033[0m
\033[41;37m  \033[0m                     Default: M, But when -d is Specified, then SQL Report set to R (Enmo Repository)   \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-r :\033[0m Input RAC Node as [Node2:Node3:...], Avaliable in Linux                            \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-s :\033[0m Input Snapshot Version, Valid Values are : 10, 9                                   \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-S :\033[0m Input Snapshot Type, Valid Values are : A(All = B + S), B(Basic), S(Supplemental)  \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-t :\033[0m Input Time Limit, Means Begin from Top n Days Before Today, default 8              \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-T :\033[0m Input Top Days, Collect n Days from Begin Time Limit, default 9                    \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-u :\033[0m Input Login User to SQL*PLUS, eg. 'sys[/oracle]'(username in lower case)           \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-v :\033[0m Show Version                                                                       \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-w :\033[0m Input Top Wait Limit, Means Top n Waits Events to be collected , default 5         \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-x :\033[0m Input OSData Code, 5 Characters default [11111], see also \033[34m\033[4m\"Command Code\"\033[0m Section   \033[41;37m  \033[0m
\033[41;37m  \033[0m                \033[31m-z :\033[0m Remove Tempfile and Pack Result Directory at the End of Script                     \033[41;37m  \033[0m
\033[41;37m  \033[0m\033[44;37m Command Code :                                                                                         \033[41;37m  \033[0m
\033[41;37m  \033[0m\033[44;37m -c    Must Followed 5 Number, Separated by [.], Code in [] Means Default Value :                       \033[41;37m  \033[0m
\033[41;37m  \033[0m     \033[31mChar 1  :\033[0m  AWR Category, Bit Signs :\033[31m  4 = DB Time, 2 = Logical, 1 = Physical                       \033[41;37m  \033[0m
\033[41;37m  \033[0m                Mostly Use:\033[34m [6] =(110) DB Time + Logical\033[0m, 7 =(111) DB Time + Logical + Physical         \033[41;37m  \033[0m
\033[41;37m  \033[0m     \033[31mChar 2  :\033[0m  SQL Category, Bit Signs :\033[31m  8 = Elapsed, 4 = Logical, 2 = Physical, 1 = Execution        \033[41;37m  \033[0m
\033[41;37m  \033[0m                Mostly Use:\033[34m [12] =(1100) Elaspe + Logical\033[0m, 14 =(1110) Elaspe + Logical + Physical       \033[41;37m  \033[0m
\033[41;37m  \033[0m     \033[31mChar 3  :\033[0m  Time Category, Bit Signs :\033[31m  8 = Day AWR, 4 = Night AWR, 2 = Day SQL, 1 = Night SQL      \033[41;37m  \033[0m
\033[41;37m  \033[0m                Mostly Use:\033[34m [10] =(1010) Day AWR + Day SQL\033[0m, 12 =(1100) Day AWR + Night AWR              \033[41;37m  \033[0m
\033[41;37m  \033[0m                            15 = (1111) = Day AWR + Night AWR + Day SQL + Night SQL                     \033[41;37m  \033[0m
\033[41;37m  \033[0m     \033[31mChar 4  :\033[0m  Other Type, Bit Signs :\033[31m  4 = AWR Profile, 2 = Graphic Statistics, 1 = Top Waits         \033[41;37m  \033[0m
\033[41;37m  \033[0m                Mostly Use:\033[34m [7] =(111) Profile + Statistics + Waits\033[0m, 3 =(011) Statistics + Waits        \033[41;37m  \033[0m
\033[41;37m  \033[0m     \033[31mChar 5  :\033[0m  Dump Catagory, Bit Signs :\033[31m  2 = Dump AWR, 1 = Dump Metadata                             \033[41;37m  \033[0m
\033[41;37m  \033[0m                Mostly Use:\033[34m [0] =(00) Not Dump AWR and Metadata\033[0m, 3 =(11) Dump AWR + Dump Metadata       \033[41;37m  \033[0m
\033[41;37m  \033[0m\033[44;37m -m    Must Followed 3 Characters, Code in [] Means Default Value :                                     \033[41;37m  \033[0m
\033[41;37m  \033[0m     \033[31mChar 1  :\033[0m  [1] = Collect DB Catagory Info       0  = Not Collect                                   \033[41;37m  \033[0m
\033[41;37m  \033[0m     \033[31mChar 2  :\033[0m  [1] = Collect OS Catagory Info       0  = Not Collect                                   \033[41;37m  \033[0m
\033[41;37m  \033[0m     \033[31mChar 3  :\033[0m  [1] = Collect Snapshot Result        0  = Not Collect                                   \033[41;37m  \033[0m
\033[41;37m  \033[0m\033[44;37m -x    Must Followed 5 Characters, Code in [] Means Default Value :                                     \033[41;37m  \033[0m
\033[41;37m  \033[0m     \033[31mChar 1  :\033[0m  [1] = Collect DB ALert               0  = Not Collect                                   \033[41;37m  \033[0m
\033[41;37m  \033[0m     \033[31mChar 2  :\033[0m  [1] = Collect ASM ALert              0  = Not Collect                                   \033[41;37m  \033[0m
\033[41;37m  \033[0m     \033[31mChar 3  :\033[0m  [1] = Collect CRS Log                0  = Not Collect                                   \033[41;37m  \033[0m
\033[41;37m  \033[0m     \033[31mChar 4  :\033[0m  [1] = Collect OS Report              0  = Not Collect                                   \033[41;37m  \033[0m
\033[41;37m  \033[0m     \033[31mChar 5  :\033[0m  [1] = Collect Listener               0  = Not Collect                                   \033[41;37m  \033[0m
\033[41;37m  \033[44;37m                                                                                                        \033[41;37m  \033[0m
\033[41;37m  \033[44;37m Mostly Used Command List Below :                                                                       \033[41;37m  \033[0m
\033[41;37m  \033[0m      0. Collect All Default                 : ./dataCollector_v${__SCRIPT_VERSION}.sh                                  \033[41;37m  \033[0m
\033[41;37m  \033[0m      1. Collect All Data                    : ./dataCollector_v${__SCRIPT_VERSION}.sh -a                               \033[41;37m  \033[0m
\033[41;37m  \033[0m      2. Collect Only Grphic                 : ./dataCollector_v${__SCRIPT_VERSION}.sh -m 100 -c 0.0.0.3.0              \033[41;37m  \033[0m
\033[41;37m  \033[0m      3. Collect Only DB Data                : ./dataCollector_v${__SCRIPT_VERSION}.sh -m 100                           \033[41;37m  \033[0m
\033[41;37m  \033[0m      4. Collect Only OS Data                : ./dataCollector_v${__SCRIPT_VERSION}.sh -m 010                           \033[41;37m  \033[0m
\033[41;37m  \033[0m      5. Collect Only Snapshot               : ./dataCollector_v${__SCRIPT_VERSION}.sh -m 001                           \033[41;37m  \033[0m
\033[41;37m  \033[0m      6. Collect AWR without SQL             : ./dataCollector_v${__SCRIPT_VERSION}.sh -m 100 -c 6.0.12.7.0             \033[41;37m  \033[0m
\033[41;37m  \033[0m      7. Collect Dump of AWR and Metadata    : ./dataCollector_v${__SCRIPT_VERSION}.sh -m 100 -c 0.0.0.0.3              \033[41;37m  \033[0m
\033[41;37m  \033[0m      8. Collect AWR from imported DB        : ./dataCollector_v${__SCRIPT_VERSION}.sh -m 100 -d <DBID>                 \033[41;37m  \033[0m
\033[41;37m  \033[0m      9. Collect Default with Basic SQL      : ./dataCollector_v${__SCRIPT_VERSION}.sh -q B                             \033[41;37m  \033[0m
\033[41;37m  \033[0m     10. Collect RAC Data on One Node        : ./dataCollector_v${__SCRIPT_VERSION}.sh -r Node2:Node3                   \033[41;37m  \033[0m
\033[41;37m                                                                                                            \033[0m"

# get input options
while getopts ab:c:d:ef:g:F:hi:l:L:m:no:pq:r:s:S:t:T:u:vw:x:z OPT
do
  case ${OPT} in
  a)
    __C_CODE="7.15.15.7.3"
    __X_CODE="11111"
    __M_CODE="111"
    __SNAPSHOT_TYPE="A"
    __SQL_TYPE="H"
    print_log "[prepare_env]" "" "User Specified to Collect All Data, Can be Overriding by other Options"
  ;;
  b)
    __BEGIN_TIME=${OPTARG}
    print_log "[prepare_env]" "" "Get ALert Begin Time From User Input [${__BEGIN_TIME}]"
  ;;
  c)
    __C_CODE=${OPTARG}
    print_log "[prepare_env]" "" "Get Command String From User Input [${__C_CODE}]"
  ;;
  d)
    __DBID=${OPTARG}
    print_log "[prepare_env]" "" "Get Oracle DBID From User Input [${__DBID}]"
  ;;
  e)
    __AWR_TIME_TYPE='Truncate'
    print_log "[prepare_env]" "" "Set AWR Time Calculation Method to [Truncated Day]"
  ;;
  f)
    __DB_ALERT_FILE=${OPTARG}
    print_log "[prepare_env]" "" "Get DB Alertfile From User Input [${__DB_ALERT_FILE}]"
  ;;
  g)
    __OTHER_GRAPHIC=${OPTARG}#
    print_log "[prepare_env]" "" "Get Other Graphic From User Input [${__OTHER_GRAPHIC}]"
  ;;
  F)
    __ASM_ALERT_FILE=${OPTARG}
    print_log "[prepare_env]" "" "Get ASM Alertfile From User Input [${__ASM_ALERT_FILE}]"
  ;;
  h)
   if [ "`echo ${__COLORED_HELP_MESSAGE} | grep '033\[31m'`" = "" ]; then
     echo "${__COLORED_HELP_MESSAGE}"
   else
     echo -e "${__COLORED_HELP_MESSAGE}"
   fi
   exit 0
  ;;
  i)
    __ORACLE_SID=${OPTARG}
    print_log "[prepare_env]" "" "Get Oracle SID From User Input [${OPTARG}]"
  ;;
  l)
    __RPT_LIMIT=${OPTARG}
    print_log "[prepare_env]" "" "Get AWR Limit From User Input [${OPTARG}]"
  ;;
  L)
    __SQL_LIMIT=${OPTARG}
    print_log "[prepare_env]" "" "Get SQL Limit From User Input [${OPTARG}]"
  ;;
  m)
    __M_CODE=${OPTARG}
    print_log "[prepare_env]" "" "Get Main Catagory Code From User Input [${OPTARG}]"
  ;;
  n)
    __SILENT_MODE=1
    print_log "[prepare_env]" "" "Collect Data in Silent Mode"
  ;;
  o)
    __ORACLE_HOME=${OPTARG}
    print_log "[prepare_env]" "" "Get Oracle Home From User Input [${OPTARG}]"
  ;;
  p)
    __USE_STATSPACK=1
    print_log "[prepare_env]" "" "We collect STATSPACK instead of AWR"
  ;;
  q)
    __SQL_TYPE=${OPTARG}
    print_log "[prepare_env]" "" "Get SQL Type From User Input [${OPTARG}]"
  ;;
  r)
    __RAC_NODES=${OPTARG}
    print_log "[prepare_env]" "" "Get RAC Nodes Information From User Input [${OPTARG}]"
  ;;
  s)
    __SNAP_VERSION=${OPTARG}
    print_log "[prepare_env]" "" "Get Snapshot Script Version From User Input [${OPTARG}]"
  ;;
  S)
    __SNAPSHOT_TYPE=${OPTARG}
    print_log "[prepare_env]" "" "Get Snapshot Type From User Input [${OPTARG}]"
  ;;
  t)
    __TOP_LIMIT=${OPTARG}
    print_log "[prepare_env]" "" "Get TOP Time Limit From User Input [${OPTARG}]"
  ;;
  T)
    __TOP_DAYS=${OPTARG}
    print_log "[prepare_env]" "" "Get TOP Days From User Input [${OPTARG}]"
  ;;
  u)
    __SQLPLUS_USER=${OPTARG}
    print_log "[prepare_env]" "" "Get SQL*PLUS Login Info [${OPTARG}]"
  ;;
  v)
    print_log "[prepare_env]" "" "Current Script Version [${__SCRIPT_VERSION}]"
    exit 0
  ;;
  w)
    __WAIT_LIMIT=${OPTARG}
    print_log "[prepare_env]" "" "Get Wait Limit From User Input [${OPTARG}]"
  ;;
  x)
    __X_CODE=${OPTARG}
    print_log "[prepare_env]" "" "Get OSData Code From User Input [${OPTARG}]"
  ;;
  z)
    __PACK_RESULT=1
    print_log "[prepare_env]" "" "We will Remove Tempfile and Pack Result Directory at the End of the Script"
  ;;
  *)
   if [ "`echo ${__COLORED_HELP_MESSAGE} | grep '033\[31m'`" = "" ]; then
     echo "${__COLORED_HELP_MESSAGE}"
   else
     echo -e "${__COLORED_HELP_MESSAGE}"
   fi
   exit 0
  ;;
  esac
done
print_log "[prepare_env]" "9" "Script Environment OK"

#########################################################################################################
##                                                                                                     ##
## Funtion set_oraEnv(): Set Oracle Environments                                                       ##
##                                                                                                     ##
#########################################################################################################
set_oraEnv(){
  if [ "${__ORACLE_HOME}" = "" ]; then
    print_log "[set_oraEnv]" "2" "[Error] Oracle Home Environment is not Set and not Input with Option, Program abort ......"
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  elif [ "${__ORACLE_SID}" = "" ]; then
    print_log "[set_oraEnv]" "2" "[Error] Oracle SID Environment is not Set and not Input with Option, Program abort ......"
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  else
    USER_SHELL=`grep 'csh' ${__SHELL}`
    if [ "${USER_SHELL}" != "" ]; then
      print_log "[set_oraEnv]" "" "Set Oracle Environment with setenv Command"
      __ORAENV_SETTINGS="setenv ORACLE_HOME ${__ORACLE_HOME} ; setenv ORACLE_SID ${__ORACLE_SID}"
      setenv ORACLE_HOME ${__ORACLE_HOME}; setenv ORACLE_SID ${__ORACLE_SID}
    else
      print_log "[set_oraEnv]" "" "Set Oracle Environment with export Command"
      __ORAENV_SETTINGS="ORACLE_HOME=${__ORACLE_HOME} ; ORACLE_SID=${__ORACLE_SID} ; export ORACLE_HOME ORACLE_SID"
      ORACLE_HOME=${__ORACLE_HOME}; ORACLE_SID=${__ORACLE_SID}; export ORACLE_HOME ORACLE_SID
    fi
    print_log "[set_oraEnv]" "" "Oracle Environment is Set with [${__ORAENV_SETTINGS}]"
  fi
  print_log "[set_oraEnv]" "9" "Oracle Environment OK"
}

#########################################################################################################
##                                                                                                     ##
## Funtions Check and Parse User Input                                                                 ##
##                                                                                                     ##
#########################################################################################################
check_DBUser(){
  SQLPLUS_LOGIN_USERNAME="`echo "${__SQLPLUS_USER}//" | cut -d '/' -f 1`"
  SQLPLUS_LOGIN_PASSWORD="`echo "${__SQLPLUS_USER}//" | cut -d '/' -f 2`"
  print_log "[check_DBUser]" "9" "Check User is [${SQLPLUS_LOGIN_USERNAME}/${SQLPLUS_LOGIN_PASSWORD}]"
  if [ "${SQLPLUS_LOGIN_PASSWORD}" != "" ] && [ "${SQLPLUS_LOGIN_USERNAME}" = "sys" ]; then
      __SQLPLUS_USER="${SQLPLUS_LOGIN_USERNAME}/${SQLPLUS_LOGIN_PASSWORD} as sysdba"
  fi
  while [ "${SQLPLUS_LOGIN_PASSWORD}" = "" ]
  do
    LOGIN_ATTEMP=""
    print_log "[check_DBUser]" "1" "Y" "Password is Null or Incorrect, Please input Password for [${SQLPLUS_LOGIN_USERNAME}] (Q/q for Quit) : "
    SQLPLUS_LOGIN_PASSWORD=${__USER_INPUT_CHAR}
    if [ "${SQLPLUS_LOGIN_PASSWORD}" = "Q" ] || [ "${SQLPLUS_LOGIN_PASSWORD}" = "q" ]; then
      __M_CODE="010"
      if [ "${__DB_ALERT_FILE}" = "" ]; then
        __X_CODE="0"
      else
        __X_CODE="1"
      fi
      if [ "${__ASM_ALERT_FILE}" = "" ]; then
        __X_CODE="${__X_CODE}0"
      else
        __X_CODE="${__X_CODE}1"
      fi
      __X_CODE="${__X_CODE}111"
      print_log "[check_DBUser]" "2" "[Warnning] No SQL*PLUS Password, then only OS Related Info can be collected"
    elif [ "${SQLPLUS_LOGIN_USERNAME}" = "sys" ]; then
      # Test sys User Login
      SQLPLUS_LOGIN_PASSWORD="${SQLPLUS_LOGIN_PASSWORD} as sysdba"
      print_log "[check_DBUser]" "" "Test Password with User [sys]"
      LOGIN_ATTEMP=`${__ORAENV_SETTINGS}; echo "exit" | ${__ORACLE_HOME}/bin/sqlplus -L "${SQLPLUS_LOGIN_USERNAME}/${SQLPLUS_LOGIN_PASSWORD}" | grep "^ORA-"`
    else
      # Test other SQL*PLUS User Login
      print_log "[check_DBUser]" "" "Test Password with User [${SQLPLUS_LOGIN_USERNAME}]"
      LOGIN_ATTEMP=`${__ORAENV_SETTINGS}; echo "exit" | ${__ORACLE_HOME}/bin/sqlplus -L "${SQLPLUS_LOGIN_USERNAME}/${SQLPLUS_LOGIN_PASSWORD}" | grep "^ORA-"`
    fi
    # if Input an Incorrect Password, then Input again
    if [ "${LOGIN_ATTEMP}" = "" ]; then
      __SQLPLUS_USER="${SQLPLUS_LOGIN_USERNAME}/${SQLPLUS_LOGIN_PASSWORD}"
      if [ "${SQLPLUS_LOGIN_USERNAME}" != "sys" ]; then
        __C_METADATA=0
      fi
      print_log "[check_DBUser]" "" "Test Login with SQL*PLUS Successfully "
    else
      SQLPLUS_LOGIN_PASSWORD=""
    fi
  done
}

parse_dbid(){
  # Parse DBID String
  if [ "${__DBID}" != "" ]; then
    __M_CODE="100"
    __SQL_TYPE="R"
  fi
}

parse_sqlType(){
  # Parse SQL Type String
  if [ "${__SQL_TYPE}" != "B" ] && [ "${__SQL_TYPE}" != "M" ] && [ "${__SQL_TYPE}" != "H" ] && [ "${__SQL_TYPE}" != "R" ]; then
    print_log "[parse_sqlType]" "2" "[Warnning] invalid SQL Type from input [${__SQL_TYPE}], Use Default [M]"
    __SQL_TYPE='M'
  fi
}

parse_snapType(){
  # Parse Snapshot Type String
  if [ "${__SNAPSHOT_TYPE}" != "B" ] && [ "${__SNAPSHOT_TYPE}" != "S" ] && [ "${__SNAPSHOT_TYPE}" != "A" ]; then
    print_log "[parse_snapType]" "2" "[Warnning] invalid Snapshot Type from input [${__SNAPSHOT_TYPE}], Use Default [B]"
    __SNAPSHOT_TYPE='B'
  fi
}

parse_snapVer(){
  # Parse Snapshot Version
  if [ "${__SNAP_VERSION}" != "10" ] && [ "${__SNAP_VERSION}" != "9" ] && [ "${__SNAP_VERSION}" != "-1" ]; then
    print_log "[parse_snapVer]" "2" "Cannot Recognize Snapshot Version [${__SNAP_VERSION}], Set it to Default"
    __SNAP_VERSION=-1
  fi
}

parse_cCode(){
  # Parse Command String
  if [ "${__C_CODE}" != 'initByHongyeDBA' ]; then
    AWR_CATAGORY=`echo ${__C_CODE} | cut -d '.' -f 1`
    SQL_CATAGORY=`echo ${__C_CODE} | cut -d '.' -f 2`
    TIME_CATAGORY=`echo ${__C_CODE} | cut -d '.' -f 3`
    OTHER_CATAGORY=`echo ${__C_CODE} | cut -d '.' -f 4`
    DUMP_CATAGORY=`echo ${__C_CODE} | cut -d '.' -f 5`
    COMMAND_CODE_OK=0
    if [ ${AWR_CATAGORY} -ge 0 ] && [ ${AWR_CATAGORY} -le 7 ] && [ ${SQL_CATAGORY} -ge 0 ] && [ ${SQL_CATAGORY} -le 15 ] && [ ${TIME_CATAGORY} -ge 0 ] && [ ${TIME_CATAGORY} -le 15 ] && [ ${OTHER_CATAGORY} -ge 0 ] && [ ${OTHER_CATAGORY} -le 7 ] && [ ${DUMP_CATAGORY} -ge 0 ] && [ ${DUMP_CATAGORY} -le 3 ] 2>/dev/null
    then
      COMMAND_CODE_OK=1
      let "__C_AWR_PHYSICAL=${AWR_CATAGORY}%2"
      let "__C_AWR_LOGICAL=(${AWR_CATAGORY}/2)%2"
      let "__C_AWR_DBTIME=(${AWR_CATAGORY}/4)%2"
      let "__C_SQL_EXECUTION=${SQL_CATAGORY}%2"
      let "__C_SQL_DISK=(${SQL_CATAGORY}/2)%2"
      let "__C_SQL_BUFFER=(${SQL_CATAGORY}/4)%2"
      let "__C_SQL_ELAPSE=(${SQL_CATAGORY}/8)%2"
      let "__C_SQL_NIGHT=${TIME_CATAGORY}%2"
      let "__C_SQL_DAY=(${TIME_CATAGORY}/2)%2"
      let "__C_AWR_NIGHT=(${TIME_CATAGORY}/4)%2"
      let "__C_AWR_DAY=(${TIME_CATAGORY}/8)%2"
      let "__C_AWR_WAIT=${OTHER_CATAGORY}%2"
      let "__C_AWR_STATS=(${OTHER_CATAGORY}/2)%2"
      let "__C_AWR_PROFILE=(${OTHER_CATAGORY}/4)%2"
      let "__C_METADATA=${DUMP_CATAGORY}%2"
      let "__C_AWRDUMP=(${DUMP_CATAGORY}/2)%2"
      print_log "[parse_cCode]" "" "Value check Valid for __C_AWR_DBTIME    =[${__C_AWR_DBTIME}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_AWR_LOGICAL   =[${__C_AWR_LOGICAL}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_AWR_PHYSICAL  =[${__C_AWR_PHYSICAL}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_AWR_DAY       =[${__C_AWR_DAY}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_AWR_NIGHT     =[${__C_AWR_NIGHT}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_SQL_ELAPSE    =[${__C_SQL_ELAPSE}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_SQL_BUFFER    =[${__C_SQL_BUFFER}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_SQL_DISK      =[${__C_SQL_DISK}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_SQL_EXECUTION =[${__C_SQL_EXECUTION}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_SQL_DAY       =[${__C_SQL_DAY}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_SQL_NIGHT     =[${__C_SQL_NIGHT}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_AWR_PROFILE   =[${__C_AWR_PROFILE}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_AWR_WAIT      =[${__C_AWR_WAIT}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_AWRDUMP       =[${__C_AWRDUMP}]"
      print_log "[parse_cCode]" "" "Value check Valid for __C_METADATA      =[${__C_METADATA}]"
    fi
    if [ ${COMMAND_CODE_OK} -eq 0 ]; then
      print_log "[check_userInput]" "2" "[Warnning] Command Code Invalid [${__C_CODE}], Using Default Value"
      __C_AWR_DBTIME=1
      __C_AWR_LOGICAL=1
      __C_AWR_PHYSICAL=0
      __C_AWR_DAY=1
      __C_AWR_NIGHT=0
      __C_SQL_ELAPSE=1
      __C_SQL_BUFFER=1
      __C_SQL_DISK=0
      __C_SQL_EXECUTION=0
      __C_SQL_DAY=1
      __C_SQL_NIGHT=0
      __C_AWR_PROFILE=1
      __C_AWR_WAIT=1
      __C_AWRDUMP=0
      __C_METADATA=0
    fi
  fi

  # Parse AWR and SQL Report Time
  if [ "${__C_AWR_DAY}${__C_AWR_NIGHT}" = "11" ]; then
    __C_AWR_DBTIME=${__C_AWR_DBTIME}A
    __C_AWR_LOGICAL=${__C_AWR_LOGICAL}A
    __C_AWR_PHYSICAL=${__C_AWR_PHYSICAL}A
  elif [ "${__C_AWR_DAY}" = "1" ]; then
    __C_AWR_DBTIME=${__C_AWR_DBTIME}D
    __C_AWR_LOGICAL=${__C_AWR_LOGICAL}D
    __C_AWR_PHYSICAL=${__C_AWR_PHYSICAL}D
  elif [ "${__C_AWR_NIGHT}" = "1" ]; then
    __C_AWR_DBTIME=${__C_AWR_DBTIME}N
    __C_AWR_LOGICAL=${__C_AWR_LOGICAL}N
    __C_AWR_PHYSICAL=${__C_AWR_PHYSICAL}N
  else
    print_log "[check_userInput]" "2" "[Warnning] No Time Option Specified, Cannot Collect AWR Report"
    __C_AWR_DBTIME=0D
    __C_AWR_LOGICAL=0D
    __C_AWR_PHYSICAL=0D
  fi
  if [ "${__C_SQL_DAY}${__C_SQL_NIGHT}" = "11" ]; then
    __C_SQL_ELAPSE=${__C_SQL_ELAPSE}A
    __C_SQL_BUFFER=${__C_SQL_BUFFER}A
    __C_SQL_DISK=${__C_SQL_DISK}A
    __C_SQL_EXECUTION=${__C_SQL_EXECUTION}A
  elif [ "${__C_SQL_DAY}" = "1" ]; then
    __C_SQL_ELAPSE=${__C_SQL_ELAPSE}D
    __C_SQL_BUFFER=${__C_SQL_BUFFER}D
    __C_SQL_DISK=${__C_SQL_DISK}D
    __C_SQL_EXECUTION=${__C_SQL_EXECUTION}D
  elif [ "${__C_SQL_NIGHT}" = "1" ]; then
    __C_SQL_ELAPSE=${__C_SQL_ELAPSE}N
    __C_SQL_BUFFER=${__C_SQL_BUFFER}N
    __C_SQL_DISK=${__C_SQL_DISK}N
    __C_SQL_EXECUTION=${__C_SQL_EXECUTION}N
  else
    print_log "[check_userInput]" "2" "[Warnning] No Time Option Specified, Cannot Collect SQL Report"
    __C_SQL_ELAPSE=0D
    __C_SQL_BUFFER=0D
    __C_SQL_DISK=0D
    __C_SQL_EXECUTION=0D
  fi
}

parse_xCode(){
  # Parse OSData Command String
  if [ ${#__X_CODE} -ne 5 ]; then
    print_log "[parse_xCode]" "2" "[Warnning] X Code does not Followed 5 Characters, Using Default Value"
    __X_CODE="11111"
  else
    X_CODE_1=`echo ${__X_CODE} | cut -c 1`
    X_CODE_2=`echo ${__X_CODE} | cut -c 2`
    X_CODE_3=`echo ${__X_CODE} | cut -c 3`
    X_CODE_4=`echo ${__X_CODE} | cut -c 4`
    X_CODE_5=`echo ${__X_CODE} | cut -c 5`
    if [ "${X_CODE_1}" != "0" ] && [ "${X_CODE_1}" != "1" ]; then
      print_log "[parse_xCode]" "2" "[Warnning] OSData Command Code have invalid char at Position: 1, Set it to Default"
      X_CODE_1=1
    elif [ "${X_CODE_2}" != "0" ] && [ "${X_CODE_2}" != "1" ]; then
      print_log "[parse_xCode]" "2" "[Warnning] OSData Command Code have invalid char at Position: 2, Set it to Default"
      X_CODE_2=1
    elif [ "${X_CODE_3}" != "0" ] && [ "${X_CODE_3}" != "1" ]; then
      print_log "[parse_xCode]" "2" "[Warnning] OSData Command Code have invalid char at Position: 3, Set it to Default"
      X_CODE_3=1
    elif [ "${X_CODE_4}" != "0" ] && [ "${X_CODE_4}" != "1" ]; then
      print_log "[parse_xCode]" "2" "[Warnning] OSData Command Code have invalid char at Position: 4, Set it to Default"
      X_CODE_4=1
    elif [ "${X_CODE_5}" != "0" ] && [ "${X_CODE_5}" != "1" ]; then
      print_log "[parse_xCode]" "2" "[Warnning] OSData Command Code have invalid char at Position: 5, Set it to Default"
      X_CODE_5=1
    fi
    __X_CODE="${X_CODE_1}${X_CODE_2}${X_CODE_3}${X_CODE_4}${X_CODE_5}"
  fi
}

parse_mCode(){
  # Parse Main Catagory Code
  if [ ${#__M_CODE} -ne 3 ]; then
    print_log "[parse_mCode]" "2" "[Warnning] Main Code does not Followed 3 Characters, Using Default"
    __M_CODE="111"
  else
    M_CODE_1=`echo ${__M_CODE} | cut -c 1`
    M_CODE_2=`echo ${__M_CODE} | cut -c 2`
    M_CODE_3=`echo ${__M_CODE} | cut -c 3`
    if [ "${M_CODE_1}" != "0" ] && [ "${M_CODE_1}" != "1" ]; then
      print_log "[parse_mCode]" "2" "[Warnning] Main Code have invalid char at Position: 1, Set it to Default"
      M_CODE_1=1
    elif [ "${M_CODE_2}" != "0" ] && [ "${M_CODE_2}" != "1" ]; then
      print_log "[parse_mCode]" "2" "[Warnning] Main Code have invalid char at Position: 2, Set it to Default"
      M_CODE_2=1
    elif [ "${M_CODE_3}" != "0" ] && [ "${M_CODE_3}" != "1" ]; then
      print_log "[parse_mCode]" "2" "[Warnning] Main Code have invalid char at Position: 3, Set it to Default"
      M_CODE_3=1
    fi
    __M_DBDATA=${M_CODE_1}
    __M_OSDATA=${M_CODE_2}
    __M_SNAPSHOT=${M_CODE_3}
  fi
}

#########################################################################################################
##                                                                                                     ##
## Funtion list_collected(): List All Data to be Collected with the Scripts                            ##
##                                                                                                     ##
#########################################################################################################
list_collected(){
  COLLECTION_ORDER=1
  COLLECTION_TEXT=""
  COLLECTION_SIGN=""
  print_log "[list_collected]" "2" "[Warnning] All Data to be Collected list Below :"
  if [ "${__M_DBDATA}" = "1" ]; then
    COLLECTION_TEXT="==> ${COLLECTION_ORDER}. AWR Report : "
    if [ "${__C_AWR_DBTIME}" = "1D" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}DB Time [Day]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_AWR_DBTIME}" = "1N" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}DB Time [Night]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_AWR_DBTIME}" = "1A" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}DB Time [All]"
      COLLECTION_SIGN=" + "
    fi
    if [ "${__C_AWR_LOGICAL}" = "1D" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Logical Read [Day]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_AWR_LOGICAL}" = "1N" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Logical Read [Night]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_AWR_LOGICAL}" = "1A" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Logical Read [All]"
      COLLECTION_SIGN=" + "
    fi
    if [ "${__C_AWR_PHYSICAL}" = "1D" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Physical Read [Day]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_AWR_PHYSICAL}" = "1N" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Physical Read [Night]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_AWR_PHYSICAL}" = "1A" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Physical Read [All]"
      COLLECTION_SIGN=" + "
    fi
    if [ "${COLLECTION_SIGN}" = " + " ]; then
      print_log "[list_collected]" "6" "${COLLECTION_TEXT}"
      let "COLLECTION_ORDER=${COLLECTION_ORDER}+1"
    fi

    COLLECTION_TEXT="==> ${COLLECTION_ORDER}. SQL Report : "
    COLLECTION_SIGN=""
    if [ "${__C_SQL_ELAPSE}" = "1D" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Elapsed Time [Day]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_SQL_ELAPSE}" = "1N" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Elapsed Time [Night]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_SQL_ELAPSE}" = "1A" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Elapsed Time [All]"
      COLLECTION_SIGN=" + "
    fi
    if [ "${__C_SQL_BUFFER}" = "1D" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Logical Read [Day]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_SQL_BUFFER}" = "1N" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Logical Read [Night]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_SQL_BUFFER}" = "1A" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Logical Read [All]"
      COLLECTION_SIGN=" + "
    fi
    if [ "${__C_SQL_DISK}" = "1D" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Physical Read [Day]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_SQL_DISK}" = "1N" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Physical Read [Night]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_SQL_DISK}" = "1A" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Physical Read [All]"
      COLLECTION_SIGN=" + "
    fi
    if [ "${__C_SQL_EXECUTION}" = "1D" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Executions [Day]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_SQL_EXECUTION}" = "1N" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Executions [Night]"
      COLLECTION_SIGN=" + "
    elif [ "${__C_SQL_EXECUTION}" = "1A" ]; then
      COLLECTION_TEXT="${COLLECTION_TEXT}${COLLECTION_SIGN}Executions [All]"
      COLLECTION_SIGN=" + "
    fi
    if [ "${COLLECTION_SIGN}" = " + " ]; then
      print_log "[list_collected]" "6" "${COLLECTION_TEXT}"
      let "COLLECTION_ORDER=${COLLECTION_ORDER}+1"
    fi

    if [ "${__C_AWR_STATS}" = "1" ]; then
      print_log "[list_collected]" "6" "==> ${COLLECTION_ORDER}. Get AWR Statistics (including Graphic HTML)"
      let "COLLECTION_ORDER=${COLLECTION_ORDER}+1"
    fi
    if [ "${__C_AWR_PROFILE}" = "1" ]; then
      print_log "[list_collected]" "6" "==> ${COLLECTION_ORDER}. Get AWR Profile"
      let "COLLECTION_ORDER=${COLLECTION_ORDER}+1"
    fi
    if [ "${__C_AWR_WAIT}" = "1" ]; then
      print_log "[list_collected]" "6" "==> ${COLLECTION_ORDER}. Get AWR Wait Event (including Graphic HTML)"
      let "COLLECTION_ORDER=${COLLECTION_ORDER}+1"
    fi
    if [ "${__C_METADATA}" = "1" ]; then
      print_log "[list_collected]" "6" "==> ${COLLECTION_ORDER}. Get Database Metadata"
      let "COLLECTION_ORDER=${COLLECTION_ORDER}+1"
    fi
    if [ "${__C_AWRDUMP}" = "1" ]; then
      print_log "[list_collected]" "6" "==> ${COLLECTION_ORDER}. Get AWR Dump File"
      let "COLLECTION_ORDER=${COLLECTION_ORDER}+1"
    fi
  fi
  if [ "${__M_OSDATA}" = "1" ]; then
    print_log "[list_collected]" "6" "==> ${COLLECTION_ORDER}. Get OS Related Data (including Alert)"
    let "COLLECTION_ORDER=${COLLECTION_ORDER}+1"
  fi
  if [ "${__M_SNAPSHOT}" = "1" ]; then
    print_log "[list_collected]" "6" "==> ${COLLECTION_ORDER}. Get Database Snapshot with Type [${__SNAPSHOT_TYPE}]"
  fi
}

#########################################################################################################
##                                                                                                     ##
## Funtion create_Dir(): Create All Needed Directories                                                 ##
##                                                                                                     ##
#########################################################################################################
create_Dir(){
  # do when the directory is already exist
  if [ -d ${__RESULT_DIR} ]; then
    if [ ${__SILENT_MODE} -eq 1 ]; then
      rm -rf ${__RESULT_DIR} 2>/dev/null
      print_log "[create_Dir]" "" "Result Directory [${__RESULT_DIR}] already Removed due to Silent Mode Used"
    else
      print_log "[create_Dir]" "1" "N" "Result Directory [${__RESULT_DIR}] exists, Remove(R), Backup(B), Overwrite(O) Default R : "
      if [ "${__USER_INPUT_CHAR}" = "B" ] || [ "${__USER_INPUT_CHAR}" = "b" ]; then
        DIR_BACKUP=${__RESULT_DIR}_BAK`date +"%Y%m%d%H%M%S"`
        mv ${__RESULT_DIR} ${DIR_BACKUP}
        print_log "[create_Dir]" "" "esult Directory [${__RESULT_DIR}] already Backup to [${DIR_BACKUP}]"
      elif [ "${__USER_INPUT_CHAR}" = "R" ] || [ "${__USER_INPUT_CHAR}" = "r" ] || [ "${__USER_INPUT_CHAR}" = "" ]; then
        rm -rf ${__RESULT_DIR} 2>/dev/null
        print_log "[create_Dir]" "" "Result Directory [${__RESULT_DIR}] already Removed "
      elif [ "${__USER_INPUT_CHAR}" = "O" ] || [ "${__USER_INPUT_CHAR}" = "o" ]; then
        print_log "[create_Dir]" "" "no Operation, Overwrite Conflict Files"
      else
        print_log "[create_Dir]" "2" "[ERROR] Result Directory [${__RESULT_DIR}] already Existed , and You didn't Tell What to do , Program exit ..."
        echo "FALSE" > ${__OSLOAD_SWITCHER}
        exit 1
      fi
    fi
  fi

  print_log "[create_Dir]" "" "Create All Needed Directories ... "
  mkdir -p ${__DUMP_DIR}
  mkdir -p ${__SCRIPT_DIR}
  mkdir -p ${__OSDATA_DIR}
  mkdir -p ${__AWRRPT_DIR}
  mkdir -p ${__SQLRPT_DIR}
  mkdir -p ${__STAT_DIR}
  mkdir -p ${__TRACE_DIR}
  mkdir -p ${__REPORT_DIR}
  mkdir -p ${__OTHER_DIR}
  mv ${__LOGFILE} ${__OTHER_DIR}/
  __LOGFILE=${__OTHER_DIR}/${__LOGFILE}
  __ERRORFILE=${__OTHER_DIR}/${__ERRORFILE}
}

#########################################################################################################
##                                                                                                     ##
## Funtion initialization(): initialization for Script                                                 ##
##                                                                                                     ##
#########################################################################################################
initialization(){

  BEGIN_HOUR=`date +"%H"`
  BEGIN_MINUTE=`date +"%M"`
  BEGIN_SECOND=`date +"%S"`

  # 1. Check Conflict of SQL Report and AWR Report
  if [ "${__C_SQL_NIGHT}${__C_AWR_NIGHT}" = "10" ]; then
    print_log "[initialization]" "2" "[Warnning] cannot Get Night SQL Because Night AWR is disabled, Night SQL ignored"
    __C_SQL_NIGHT=0
  fi
  if [ "${__C_SQL_DAY}${__C_AWR_DAY}" = "10" ]; then
    print_log "[initialization]" "2" "[Warnning] cannot Get DAY SQL Because DAY AWR is disabled, DAY SQL ignored"
    __C_SQL_DAY=0
  fi

  # 2. Check Conflict of __DBID and __C_METADATA
  if [ "${__DBID}" != "" ] && [ "${__C_METADATA}" = "1" ]; then
    print_log "[initialization]" "2" "[Warnning] Cannot Get Metadata when Input DBID, Metadata Collection ignored"
    __C_METADATA=0
  fi

  # 3. Check Conflict of __DBID and __C_AWRDUMP
  if [ "${__DBID}" != "" ] && [ "${__C_AWRDUMP}" = "1" ]; then
    print_log "[initialization]" "2" "[Warnning] Cannot Get AWR Dump when Input DBID, AWR Dump Collection ignored"
    __C_AWRDUMP=0
  fi

  # 4. Check Conflict of __DBID and __M_SNAPSHOT
  if [ "${__DBID}" != "" ] && [ "${__M_SNAPSHOT}" = "1" ]; then
    print_log "[initialization]" "2" "[Warnning] Cannot Get Snapshot when Input DBID, Snapshot Collection ignored"
    __M_SNAPSHOT=0
  fi

  # 5. Check Conflict of __DBID and __M_OSDATA
  if [ "${__DBID}" != "" ] && [ "${__M_OSDATA}" = "1" ]; then
    print_log "[initialization]" "2" "[Warnning] Cannot Get OS Data when Input DBID, OS Data Collection ignored"
    __M_OSDATA=0
  fi

  # Create Directories and Parse Inputs
  create_Dir
  set_oraEnv
  check_DBUser
  parse_dbid
  parse_sqlType
  parse_snapType
  parse_snapVer
  parse_cCode
  parse_xCode
  parse_mCode
}

#########################################################################################################
##                                                                                                     ##
## Funtion get_dbinfo(): Get DB Info , including Instance count and DBID                               ##
##                                                                                                     ##
#########################################################################################################
get_dbinfo(){

  # Get DB Version
  print_log "[get_dbinfo]" "" "Begin Collect Basic Database Information : DBID, Instance Count, Block Size, Max Time"

  DB_INFO_TMP=${__OTHER_DIR}/db_info.tmp
  echo "ORA-00000" > ${DB_INFO_TMP}

  if [ "${__DBID}" = "" ]; then
    SQL_EXEC="SET LINESIZE 1000 PAGESIZE 0 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON AUTOT OFF
 SPOOL ${DB_INFO_TMP}
 SELECT /*+ RULE */ VERSION FROM V\$INSTANCE;
 SPOOL OFF
 EXIT"
  elif [ ${__USE_STATSPACK} -eq 0 ]; then
    SQL_EXEC="SET LINESIZE 1000 PAGESIZE 0 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON AUTOT OFF
 SPOOL ${DB_INFO_TMP}
 SELECT /*+ RULE */ * FROM (SELECT VERSION FROM DBA_HIST_DATABASE_INSTANCE WHERE DBID=${__DBID} ORDER BY STARTUP_TIME DESC) WHERE ROWNUM=1;
 SPOOL OFF
 EXIT"
  else
    SQL_EXEC="SET LINESIZE 1000 PAGESIZE 0 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON AUTOT OFF
 SPOOL ${DB_INFO_TMP}
 SELECT /*+ RULE */ * FROM (SELECT VERSION FROM STATS\$DATABASE_INSTANCE WHERE DBID=${__DBID} ORDER BY STARTUP_TIME DESC) WHERE ROWNUM=1;
 SPOOL OFF
 EXIT"
  fi

  print_log "[get_dbinfo]" "4" "DB Informations - Get Version" "${SQL_EXEC}"
  ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1> /dev/null 2>>${__ERRORFILE} <<EOF
  ${SQL_EXEC}
EOF
  if [ "`cat ${DB_INFO_TMP} | grep '^ORA-'`" != "" ]; then
    print_log "[get_dbinfo]" "2" "[Error] Cannot Execute SQL with [${__ORACLE_HOME}/bin/sqlplus -s \"${__SQLPLUS_USER}\"], Program abort ..."
    print_log "[get_dbinfo]" "2" "[Cause] `cat ${DB_INFO_TMP} | grep '^ORA-' | sort -u`"
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  fi
  __DB_VERSION=`tail -1 ${DB_INFO_TMP}`
  __DB_VERSION_MAJOR=`tail -1 ${DB_INFO_TMP} | cut -d '.' -f 1`
  __DB_VERSION_MINOR=`tail -1 ${DB_INFO_TMP} | cut -d '.' -f 2`
  print_log "[get_dbinfo]" "" "Get DB Version [${__DB_VERSION}] with Major [${__DB_VERSION_MAJOR}] and Minor [${__DB_VERSION_MINOR}]"
  if [ ${__DB_VERSION_MAJOR}${__DB_VERSION_MINOR} -le 101 ]; then
    __USE_STATSPACK=1
  elif [ ${__USE_STATSPACK} -eq 1 ]; then
    print_log "[get_dbinfo]" "2" "[Warnning] Get DB Version [${__DB_VERSION}], But user request to collect STATSPACK instead of AWR"
  else
    print_log "[get_dbinfo]" "" "DB Version is [${__DB_VERSION}], We are going to collect AWR Data"
  fi

  # Make Get DB Information SQL
  if [ "${__DBID}" = "" ]; then
    SQL_EXEC="SET LINESIZE 1000 PAGESIZE 0 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON AUTOT OFF
  SPOOL ${DB_INFO_TMP}
 SELECT (SELECT /*+ RULE */ DBID FROM V\$DATABASE)
        ||'|'||(SELECT /*+ RULE */ COUNT(*) FROM GV\$INSTANCE)
        ||'|'||(SELECT /*+ RULE */ DISTINCT VALUE FROM V\$PARAMETER WHERE NAME='db_block_size')
   FROM DUAL;
  SPOOL OFF
  SPOOL ${__INSTANCE_INFO_FILE}
 SELECT /*+ RULE */ INSTANCE_NUMBER||' '||INSTANCE_NAME FROM GV\$INSTANCE;
  SPOOL OFF
 EXIT";
  elif [ ${__USE_STATSPACK} -eq 0 ]; then
    SQL_EXEC="SET LINESIZE 1000 PAGESIZE 0 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON AUTOT OFF
  SPOOL ${DB_INFO_TMP}
 SELECT (SELECT /*+ RULE */ ${__DBID}||'|'||COUNT(DISTINCT INSTANCE_NUMBER) DB_INST FROM DBA_HIST_DATABASE_INSTANCE WHERE DBID=${__DBID})
        ||'|'||(SELECT /*+ RULE */ DISTINCT VALUE FROM DBA_HIST_PARAMETER
                 WHERE PARAMETER_NAME='db_block_size' AND DBID=${__DBID})
   FROM DUAL;
  SPOOL OFF
  SPOOL ${__INSTANCE_INFO_FILE}
 SELECT /*+ RULE */ INSTANCE_NUMBER, INSTANCE_NAME FROM DBA_HIST_DATABASE_INSTANCE
  WHERE DBID = ${__DBID}
    AND (INSTANCE_NUMBER, STARTUP_TIME) IN
        (SELECT /*+ RULE */ INSTANCE_NUMBER, MAX(STARTUP_TIME) FROM DBA_HIST_DATABASE_INSTANCE WHERE DBID = ${__DBID} GROUP BY INSTANCE_NUMBER);
  SPOOL OFF
 EXIT";
  else
    SQL_EXEC="SET LINESIZE 1000 PAGESIZE 0 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON AUTOT OFF
 SPOOL ${DB_INFO_TMP}
 SELECT (SELECT /*+ RULE */ ${__DBID}||'|'||COUNT(*) FROM STATS\$DATABASE_INSTANCE WHERE DBID=${__DBID})
        ||'|'||(SELECT /*+ RULE */ DISTINCT VALUE FROM STATS\$PARAMETER WHERE NAME='db_block_size' AND DBID=${__DBID})
   FROM DUAL;
  SPOOL OFF
  SPOOL ${__INSTANCE_INFO_FILE}
 SELECT /*+ RULE */ INSTANCE_NUMBER, INSTANCE_NAME FROM STATS\$DATABASE_INSTANCE
  WHERE DBID = ${__DBID}
    AND (INSTANCE_NUMBER, STARTUP_TIME) IN
        (SELECT /*+ RULE */ INSTANCE_NUMBER, MAX(STARTUP_TIME) FROM STATS\$DATABASE_INSTANCE WHERE DBID = ${__DBID} GROUP BY INSTANCE_NUMBER);
  SPOOL OFF
 EXIT";
  fi

  # Write SQL to SQL File
  print_log "[get_dbinfo]" "4" "DB Informations" "${SQL_EXEC}"

  # Get DB Information with SQL*PLUS tools
  ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1> /dev/null 2>>${__ERRORFILE} <<EOF
  ${SQL_EXEC}
EOF
  if [ -f "${DB_INFO_TMP}" ] && [ "`cat ${DB_INFO_TMP} | grep '^ORA-'`" != "" ]; then
    print_log "[get_dbinfo]" "2" "[Error] Cannot Execute SQL with [${__ORACLE_HOME}/bin/sqlplus -s \"${__SQLPLUS_USER}\"], Program abort ..."
    print_log "[get_dbinfo]" "2" "[Cause] `cat ${DB_INFO_TMP} | grep '^ORA-' | sort -u`"
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  elif [ ! -f "${DB_INFO_TMP}" ]; then
    print_log "[get_dbinfo]" "2" "[Error] no DB Info file Created, Program abort ..."
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  fi
  print_log "[get_dbinfo]" "" "Successfully Get DB Info from Running Database"
  DB_INFO_LINE=`tail -1 ${DB_INFO_TMP}`

  # Split DB Information from Result File
  __DBID=`echo ${DB_INFO_LINE} | cut -f 1 -d '|'`
  __INST_NUM=`echo ${DB_INFO_LINE} | cut -f 2 -d '|'`
  __DB_BLOCK_SIZE=`echo ${DB_INFO_LINE} | cut -f 3 -d '|'`
  if [ "${__DBID}|" = "|" ] || [ "${__INST_NUM}|" = "|" ] || [ "${__DB_BLOCK_SIZE}|" = "|" ]; then
    print_log "[get_dbinfo]" "" "[Error] Cannot Get Enough Information from Running Database, Program abort ..."
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  else
    print_log "[get_dbinfo]" "" "Get DB Info as DBID = [${__DBID}], Instance Count = [${__INST_NUM}], Block Size = [${__DB_BLOCK_SIZE}]"
  fi

  # Write DB Info Temp File to remove script
  print_log "[get_dbinfo]" "5" "${DB_INFO_TMP}"
}

#########################################################################################################
##                                                                                                     ##
## Function calculate_time(): Calculate AWR Collection Time                                            ##
##                                                                                                     ##
#########################################################################################################
calculate_time(){
  print_log "[calculate_time]" "" "Calculate AWR Collection Time, Related Parameters: Time Limite = [${__TOP_LIMIT}], Top Days = [${__TOP_DAYS}]"

  # Get DBID Value for AWR Time Calculation
  if [ "${__DBID}" = "" ]; then
    TIMECALDBID='(SELECT DBID FROM V$DATABASE)'
  else
    TIMECALDBID="${__DBID}"
  fi

  # Use AWR Calculation Method
  if [ "${__AWR_TIME_TYPE}" = "Truncate" ]; then
    TIMECALTYPE='TRUNC(T)'
  else
    TIMECALTYPE='T'
  fi

  # Get AWR Collection Begin and End Time
  if [ ${__USE_STATSPACK} -eq 1 ]; then
    TIMECALTAB="(SELECT /*+ RULE */ CASE WHEN MIN(SNAP_TIME) > SYSDATE - ${__TOP_LIMIT} THEN MIN(SNAP_TIME) ELSE SYSDATE - ${__TOP_LIMIT} END T FROM STATS\$SNAPSHOT WHERE DBID = ${TIMECALDBID})"
  else
    TIMECALTAB="(SELECT /*+ RULE */ CASE WHEN MIN(END_INTERVAL_TIME) > SYSDATE - ${__TOP_LIMIT} THEN MIN(END_INTERVAL_TIME) ELSE SYSDATE - ${__TOP_LIMIT} END T FROM DBA_HIST_SNAPSHOT WHERE DBID = ${TIMECALDBID})"
  fi

  # Merge SQL Statement
  AWR_TIME_CAL_FILE=${__OTHER_DIR}/awrTimeCalculation.tmp
  SQL_EXEC="SET LINES 222 PAGES 0 TIMI OFF TI OFF AUTOT OFF TRIM ON TRIMS ON
 SPOOL ${AWR_TIME_CAL_FILE}
 SELECT /*+ RULE */ TO_CHAR(${TIMECALTYPE}, 'YYYYMMDDHH24MI')||'#'||TO_CHAR(${TIMECALTYPE} + ${__TOP_DAYS}, 'YYYYMMDDHH24MI')
   FROM ${TIMECALTAB};
 SPOOL OFF
 EXIT"
  print_log "[calculate_time]" "4" "AWR Time Calculation" "${SQL_EXEC}"

  # Get Time from Database
  ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1>/dev/null 2>>${__ERRORFILE} <<EOF
 ${SQL_EXEC}
EOF

  __AWR_TIME_BEGIN=`cat ${AWR_TIME_CAL_FILE} | grep -v '^$' | cut -d '#' -f 1`
  __AWR_TIME_END=`cat ${AWR_TIME_CAL_FILE} | grep -v '^$' | cut -d '#' -f 2`
  if [ "${__AWR_TIME_BEGIN}" = "" ] || [ "${__AWR_TIME_END}" = "" ]; then
    print_log "[calculate_time]" "" "[Error] Cannot Get AWR Time from Running Database, Program abort ..."
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  else
    print_log "[calculate_time]" "" "AWR Collection Time is Begin from [${__AWR_TIME_BEGIN}] and End to [${__AWR_TIME_END}]"
  fi

  # Write DB Info Temp File to remove script
  print_log "[calculate_time]" "5" "${AWR_TIME_CAL_FILE}"
}

#########################################################################################################
##                                                                                                     ##
## Function get_awr_needed(): Get AWR info which needed to generate report                             ##
##   Result write into ${__RPT_NEEDED} file                                                            ##
##   Format :<BEGIN_TIME> <BEGIN_ID> <END_TIME> <END_ID> <INST_ID> <STAT_NAME> <TIME_TYPE> <STAT_LEVEL>##
##                                                                                                     ##
#########################################################################################################
get_awr_needed(){

  print_log "[get_awr_needed]" "" "Begin Collect AWR Needed Information"
  # Get Input Parameters
  if [ "$1" = "dbtime" ]; then
    __STAT_NAME="dbtime"
    SQL_1="
                          FROM DBA_HIST_SYS_TIME_MODEL
                         WHERE STAT_NAME = 'DB time'"
  elif [ "$1" = "logical" ]; then
    __STAT_NAME="logical"
    SQL_1="
                          FROM DBA_HIST_SYSSTAT
                         WHERE STAT_NAME IN ('db block gets','consistent gets')"
  elif [ "$1" = "physical" ]; then
    __STAT_NAME="physical"
    SQL_1="
                          FROM DBA_HIST_SYSSTAT
                         WHERE STAT_NAME = 'physical reads'"
  else
    print_log "[get_awr_needed]" "2" "[Error] Cannot Get Corrrect Input for Function [get_awr_needed()] with \$1 = [$1], Program abort ..."
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  fi
  TIME_CONDITION="$2"
  if [ "$2" != "D" ] && [ "$2" != "N" ]; then
    print_log "[get_awr_needed]" "2" "[Error] Cannot Get Corrrect Input for Function [get_awr_needed()] with \$2 = [$2] , Program abort ..."
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  fi
  print_log "[get_awr_needed]" "" "Get AWR Needed Information for STAT_NAME = [${__STAT_NAME}] TIME_TYPE = [${TIME_CONDITION}]"

  # Add Time Control
  RESULT_TMP="${__RPT_NEEDED}.tmp"
  SQL_1="SELECT STAT_INFO||ROWNUM
  FROM (SELECT STAT_INFO
          FROM ( SELECT /*+ RULE */ T.INSTANCE_NUMBER
                        ||' '||TO_CHAR(T.BEGIN_INTERVAL_TIME, 'YYYYMMDDHH24MI')
                        ||' '||(LAG(T.SNAP_ID) OVER (ORDER BY S.SNAP_ID))
                        ||' '||TO_CHAR(T.END_INTERVAL_TIME, 'YYYYMMDDHH24MI')
                        ||' '||T.SNAP_ID
                        ||' ${__STAT_NAME} ${TIME_CONDITION} ' STAT_INFO
                      , (VALUE - LAG(VALUE) OVER (ORDER BY S.SNAP_ID)) STAT_VALUE
                      , TO_CHAR(T.END_INTERVAL_TIME,'HH24') TIME_TIPS
                   FROM DBA_HIST_SNAPSHOT T,
                      ( SELECT /*+ RULE */ SNAP_ID, CASE WHEN SUM(VALUE)>=0 THEN SUM(VALUE) ELSE 0 END VALUE${SQL_1}
                           AND DBID = ${__DBID}
                           AND INSTANCE_NUMBER = "
  SQL_2="
                         GROUP BY SNAP_ID) S
                  WHERE S.SNAP_ID = T.SNAP_ID
                    AND T.DBID = ${__DBID}
                    AND T.INSTANCE_NUMBER = "
  if [ "${TIME_CONDITION}" = "D" ]; then
    SQL_3="
                    AND T.END_INTERVAL_TIME BETWEEN TO_DATE('${__AWR_TIME_BEGIN}', 'YYYYMMDDHH24MI') AND TO_DATE('${__AWR_TIME_END}', 'YYYYMMDDHH24MI')
                  ORDER BY STAT_VALUE DESC)
         WHERE STAT_VALUE IS NOT NULL
           AND TIME_TIPS BETWEEN '09' AND '18')
 WHERE ROWNUM <= ${__RPT_LIMIT};"
  else
    SQL_3="
                    AND T.END_INTERVAL_TIME BETWEEN TO_DATE('${__AWR_TIME_BEGIN}', 'YYYYMMDDHH24MI') AND TO_DATE('${__AWR_TIME_END}', 'YYYYMMDDHH24MI')
                  ORDER BY STAT_VALUE DESC)
         WHERE STAT_VALUE IS NOT NULL
           AND (TIME_TIPS < '09' OR TIME_TIPS > '18'))
 WHERE ROWNUM <= ${__RPT_LIMIT};"
  fi

  # Loop to Collect All Instance Data
  while read INST_NUM INST_NAME
  do
    print_log "[get_awr_needed]" "" "Get AWR Needed Information for instance [${INST_NUM}]"
    SQL="SET LINESIZE 1000 PAGESIZE 1000 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON HEAD OFF AUTOT OFF
 SPOOL ${RESULT_TMP} APPEND
 ${SQL_1} ${INST_NUM} ${SQL_2} ${INST_NUM} ${SQL_3}
 SPOOL OFF
 EXIT"
    print_log "[get_awr_needed]" "4" "AWR Needed info Collection" "${SQL}"

    ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" <<EOF 1>/dev/null 2>>${__ERRORFILE}
    ${SQL}
EOF
    if [ -f "${RESULT_TMP}" ] && [ "`cat ${RESULT_TMP} | grep '^ORA-'`" != "" ]; then
      print_log "[get_awr_needed]" "2" "[Error] Cannot Execute SQL with [${__ORACLE_HOME}/bin/sqlplus -s \"${__SQLPLUS_USER}\"], Program abort ..."
      print_log "[get_awr_needed]" "2" "[Cause] `cat ${RESULT_TMP} | grep '^ORA-' | sort -u`"
      echo "FALSE" > ${__OSLOAD_SWITCHER}
      exit 1
    elif [ ! -f "${RESULT_TMP}" ]; then
      print_log "[get_awr_needed]" "2" "[Error] no Result Created for Statname = [${__STAT_NAME}] and Timetype = [${TIME_CONDITION}]"
      echo "FALSE" > ${__OSLOAD_SWITCHER}
      exit 1
    else
      print_log "[get_awr_needed]" "" "Successfully Created Needed info for Statname = [${__STAT_NAME}] and Timetype = [${TIME_CONDITION}]"
    fi
  done <${__INSTANCE_INFO_FILE}

  # Remove Blank Line in Result File and Write Temp File to remove script
  grep -v "^$" ${RESULT_TMP} >> ${__RPT_NEEDED}
  print_log "[get_awr_needed]" "5" "${RESULT_TMP}"
}

#########################################################################################################
##                                                                                                     ##
## Function get_sp_needed(): Get STATSPACK info which needed to generate report                        ##
##   Result write into ${__RPT_NEEDED} file                                                            ##
##   Format :<BEGIN_TIME> <BEGIN_ID> <END_TIME> <END_ID> <INST_ID> <STAT_NAME> <TIME_TYPE> <STAT_LEVEL>##
##                                                                                                     ##
#########################################################################################################
get_sp_needed(){

  print_log "[get_sp_needed]" "" "Begin Collect Statspack Needed Information"
  if [ "$1" = "logical" ]; then
    __STAT_NAME="logical"
    STAT_FILL_SQL="db block gets', 'consistent gets"
  elif [ "$1" = "physical" ]; then
    __STAT_NAME="physical"
    STAT_FILL_SQL="physical reads"
  else
    print_log "[get_sp_needed]" "2" "[Error] Cannot Get Corrrect Input for Function [get_sp_needed()] with \$1 = [$1] , Program abort ..."
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  fi

  TIME_CONDITION="$2"
  if [ "$2" != "D" ] && [ "$2" != "N" ]; then
    print_log "[get_sp_needed]" "2" "[Error] Cannot Get Corrrect Input for Function [get_sp_needed()] with \$2 = [$2] , Program abort ..."
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  fi
  print_log "[get_sp_needed]" "" "Get STATSPACK Needed Information for STAT_NAME=[${__STAT_NAME}] TIME_TYPE=[${TIME_CONDITION}]"

  # Add Time Control
  RESULT_TMP=${__RPT_NEEDED}.tmp
  SQL_1="SELECT SP_INFO||ROWNUM SP_INFO
  FROM (SELECT /*+ RULE */ II||' '||BT||' '||BI||' '||ET||' '||EI||' ${__STAT_NAME} ${TIME_CONDITION} ' SP_INFO
          FROM (SELECT LAG(TO_CHAR(SN.SNAP_TIME, 'YYYYMMDDHH24MI')) OVER(ORDER BY SN.SNAP_ID) BT
                     , LAG(SN.SNAP_ID) OVER(ORDER BY SN.SNAP_ID) BI
                     , TO_CHAR(SN.SNAP_TIME, 'YYYYMMDDHH24MI') ET
                     , SN.SNAP_ID EI
                     , SN.INSTANCE_NUMBER II
                     , ROUND(VALUE - LAG(VALUE) OVER(ORDER BY SN.SNAP_ID)) LR
                     , TO_CHAR(SN.SNAP_TIME,'HH24') TIME_TIPS
                  FROM STATS\$SNAPSHOT SN,
                     ( SELECT /*+ RULE */ SNAP_ID, SUM(VALUE) VALUE
                         FROM STATS\$SYSSTAT
                        WHERE NAME in ('${STAT_FILL_SQL}')
                          AND DBID = ${__DBID}
                          AND INSTANCE_NUMBER = "
  SQL_2="
                        GROUP BY SNAP_ID) SY
                 WHERE SY.SNAP_ID = SN.SNAP_ID
                   AND SN.SNAP_TIME BETWEEN TO_DATE('${__AWR_TIME_BEGIN}', 'YYYYMMDDHH24MI') AND TO_DATE('${__AWR_TIME_END}', 'YYYYMMDDHH24MI')
                   AND SN.DBID = ${__DBID}
                   AND SN.INSTANCE_NUMBER = "
  if [ "${TIME_CONDITION}" = "D" ]; then
    SQL_3=")
         WHERE BI IS NOT NULL AND LR > 0
           AND TIME_TIPS BETWEEN '09' AND '18'
         ORDER BY LR Desc)
 WHERE ROWNUM <= ${__RPT_LIMIT};"
  elif [ "${TIME_CONDITION}" = "N" ]; then
    SQL_3=")
         WHERE BI IS NOT NULL AND LR > 0
           AND (TIME_TIPS < '09' OR TIME_TIPS > '18')
         ORDER BY LR Desc)
 WHERE ROWNUM <= ${__RPT_LIMIT};"
  else
    SQL_3=")
         WHERE BI IS NOT NULL AND LR > 0
         ORDER BY LR Desc)
 WHERE ROWNUM <= ${__RPT_LIMIT};"
  fi

  # Loop to Collect All Instance Data
  while read INST_NUM INST_NAME
  do
    print_log "[get_sp_needed]" "" "Get STATSPACK Needed Information for instance [${INST_NUM}]"
    SQL="SET LINESIZE 1000 PAGESIZE 1000 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON HEAD OFF AUTOT OFF
 SPOOL ${RESULT_TMP}
 ${SQL_1} ${INST_NUM} ${SQL_2} ${INST_NUM} ${SQL_3}
 SPOOL OFF
 EXIT"
    print_log "[get_sp_needed]" "4" "Statspack Needed info Collection" "${SQL}"
    ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1>/dev/null 2>>${__ERRORFILE} <<EOF
    ${SQL}
EOF
    if [ -f "${RESULT_TMP}" ] && [ "`cat ${RESULT_TMP} | grep '^ORA-'`" != "" ]; then
      print_log "[get_sp_needed]" "2" "[Error] Cannot Execute SQL with [${__ORACLE_HOME}/bin/sqlplus -s \"${__SQLPLUS_USER}\"], Program abort ..."
      print_log "[get_sp_needed]" "2" "[Cause] `cat ${RESULT_TMP} | grep '^ORA-' | sort -u`"
      echo "FALSE" > ${__OSLOAD_SWITCHER}
      exit 1
    elif [ ! -f "${RESULT_TMP}" ]; then
      print_log "[get_sp_needed]" "2" "[Error] no Result Created for Statname = [${__STAT_NAME}] and Timetype = [${TIME_CONDITION}]"
      echo "FALSE" > ${__OSLOAD_SWITCHER}
      exit 1
    else
      print_log "[get_sp_needed]" "" "Successfully Created Needed info for Statname = [${__STAT_NAME}] and Timetype = [${TIME_CONDITION}]"
    fi
  done <${__INSTANCE_INFO_FILE}

  # Remove Blank Line in Result File and Write Temp File to remove script
  touch ${__RPT_NEEDED}
  grep -v "^$" ${RESULT_TMP} >> ${__RPT_NEEDED}
  print_log "[get_sp_needed]" "5" "${RESULT_TMP}"
}

#########################################################################################################
##                                                                                                     ##
## Function build_index(): Build Report Index File                                                     ##
##                                                                                                     ##
#########################################################################################################
build_index(){

  print_log "[build_index]" "" "Building Index File Header"
  cat > ${__INDEX_HTML} <<EOFINDEX
 <HTML><HEAD><TITLE>Report Index</TITLE>
 <style type="text/css">
 body.awr {font:bold 10pt Arial,Helvetica,Geneva,sans-serif;color:black; background:White;}
 pre.awr  {font:8pt Courier;color:black; background:White;}
 h1.awr   {font:bold 20pt Arial,Helvetica,Geneva,sans-serif;color:#336699;background-color:White;border-bottom:1px solid #cccc99;margin-top:0pt; margin-bottom:0pt;padding:0px 0px 0px 0px;}
 h2.awr   {font:bold 18pt Arial,Helvetica,Geneva,sans-serif;color:#336699;background-color:White;margin-top:4pt; margin-bottom:0pt;}
 h3.awr   {font:bold 16pt Arial,Helvetica,Geneva,sans-serif;color:#336699;background-color:White;margin-top:4pt; margin-bottom:0pt;}
 li.awr   {font: 9pt Arial,Helvetica,Geneva,sans-serif; color:black; background:White;}
 th.awrnobg {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:black; background:White;padding-left:4px; padding-right:4px;padding-bottom:2px}
 th.awrnbg  {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:Black; background:#EEEEE0;padding-left:4px; padding-right:4px;padding-bottom:2px}
 th.awrmbg  {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:Black; background:#EEB422;padding-left:4px; padding-right:4px;padding-bottom:2px}
 th.awrbg {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:White; background:#0066CC;padding-left:4px; padding-right:4px;padding-bottom:1px}
 td.awrnc {font:10pt Arial,Helvetica,Geneva,sans-serif;color:black;background:White;vertical-align:top;}
 td.awrc  {font:10pt Arial,Helvetica,Geneva,sans-serif;color:black;background:#FFFFCC; vertical-align:top;}
 a.awr    {font:bold 8pt Arial,Helvetica,sans-serif;color:#663300; vertical-align:top;margin-top:0pt; margin-bottom:0pt;}
 </style></HEAD><BODY class='awr'>
 <H1 class='awr'> HTML Reports Index </H1><p>
 <li>Copyright (c) 2012-2012 Hongye DBA. All rights reserved. (www.enmotech.com)</li><p>
 <br><H3 class='awr'> AWR Reports </H3><p><table border=1 WIDTH=300></table> <p> <table border=1 WIDTH=1000>
 <tr HEIGHT=30> <th class=awrbg WIDTH=12% rowspan=2>Inst No.</th> <th class=awrbg WIDTH=5% rowspan=2>Level</th> <th class=awrbg WIDTH=28% colspan=2>DB Time</th> <th class=awrbg WIDTH=28% colspan=2>Logical Read</th> <th class=awrbg WIDTH=28% colspan=2>Physical Read</th> </tr>
 <tr> <th class=awrmbg WIDTH=13%>Day</th> <th class=awrmbg WIDTH=13%>Night</th> <th class=awrmbg WIDTH=13%>Day</th> <th class=awrmbg WIDTH=13%>Night</th> <th class=awrmbg WIDTH=13%>Day</th> <th class=awrmbg WIDTH=13%>Night</th> </tr>
EOFINDEX

  print_log "[build_index]" "" "Building Index of AWR Reports"
  DBTIME_D=""
  DBTIME_N=""
  LOGICAL_D=""
  LOGICAL_N=""
  PHYSICAL_D=""
  PHYSICAL_N=""
  AWR_DIR=`echo "${__AWRRPT_DIR}" | cut -d '/' -f 2`
  SQL_DIR=`echo "${__SQLRPT_DIR}" | cut -d '/' -f 2`
  CHART_DIR=`echo "${__STAT_DIR}" | cut -d '/' -f 2`
  LOG_DIR=`echo "${__SCRIPT_DIR}" | cut -d '/' -f 2`
  OS_DIR=`echo "${__OSDATA_DIR}" | cut -d '/' -f 2`
  TRACE_DIR=`echo "${__TRACE_DIR}" | cut -d '/' -f 2`
  while read INST_ID INST_NAME
  do
    #for ((STATLEVEL=1;STATLEVEL<=${__RPT_LIMIT};STATLEVEL++))
    STATLEVEL=0
    while [ ${STATLEVEL} -lt ${__RPT_LIMIT} ]
    do
      let "STATLEVEL+=1"
      DBTIME_D=`cat ${__RPT_NEEDED} 2>${__ERRORFILE} |grep "^${INST_ID}" | grep "_dD${STATLEVEL}_" | cut -f 4 -d ' '`
      DBTIME_N=`cat ${__RPT_NEEDED} 2>${__ERRORFILE} |grep "^${INST_ID}" | grep "_dN${STATLEVEL}_" | cut -f 4 -d ' '`
      LOGICAL_D=`cat ${__RPT_NEEDED} 2>${__ERRORFILE} |grep "^${INST_ID}" | grep "_lD${STATLEVEL}_" | cut -f 4 -d ' '`
      LOGICAL_N=`cat ${__RPT_NEEDED} 2>${__ERRORFILE} |grep "^${INST_ID}" | grep "_lN${STATLEVEL}_" | cut -f 4 -d ' '`
      PHYSICAL_D=`cat ${__RPT_NEEDED} 2>${__ERRORFILE} |grep "^${INST_ID}" | grep "_pD${STATLEVEL}_" | cut -f 4 -d ' '`
      PHYSICAL_N=`cat ${__RPT_NEEDED} 2>${__ERRORFILE} |grep "^${INST_ID}" | grep "_pN${STATLEVEL}_" | cut -f 4 -d ' '`

      # Get Report End Time
      DBTIME_D_TIME=`echo $DBTIME_D | cut -d '.' -f 1`
      while [ "$FIRST_PART" != "$DBTIME_D_TIME" ];
      do
        FIRST_PART=`echo $DBTIME_D_TIME | cut -d '_' -f 1`
        DBTIME_D_TIME=`echo $DBTIME_D_TIME | cut -d '_' -f 2-`
      done
      DBTIME_D_TIME="`echo $DBTIME_D_TIME | cut -c 1-4`-`echo $DBTIME_D_TIME | cut -c 5-6`-`echo $DBTIME_D_TIME | cut -c 7-8` `echo $DBTIME_D_TIME | cut -c 9-10`:`echo $DBTIME_D_TIME | cut -c 11-12`"
      DBTIME_N_TIME=`echo $DBTIME_N | cut -d '.' -f 1`
      while [ "$FIRST_PART" != "$DBTIME_N_TIME" ];
      do
        FIRST_PART=`echo $DBTIME_N_TIME | cut -d '_' -f 1`
        DBTIME_N_TIME=`echo $DBTIME_N_TIME | cut -d '_' -f 2-`
      done
      DBTIME_N_TIME="`echo $DBTIME_N_TIME | cut -c 1-4`-`echo $DBTIME_N_TIME | cut -c 5-6`-`echo $DBTIME_N_TIME | cut -c 7-8` `echo $DBTIME_N_TIME | cut -c 9-10`:`echo $DBTIME_N_TIME | cut -c 11-12`"
      LOGICAL_D_TIME=`echo $LOGICAL_D | cut -d '.' -f 1`
      while [ "$FIRST_PART" != "$LOGICAL_D_TIME" ];
      do
        FIRST_PART=`echo $LOGICAL_D_TIME | cut -d '_' -f 1`
        LOGICAL_D_TIME=`echo $LOGICAL_D_TIME | cut -d '_' -f 2-`
      done
      LOGICAL_D_TIME="`echo $LOGICAL_D_TIME | cut -c 1-4`-`echo $LOGICAL_D_TIME | cut -c 5-6`-`echo $LOGICAL_D_TIME | cut -c 7-8` `echo $LOGICAL_D_TIME | cut -c 9-10`:`echo $LOGICAL_D_TIME | cut -c 11-12`"
      LOGICAL_N_TIME=`echo $LOGICAL_N | cut -d '.' -f 1`
      while [ "$FIRST_PART" != "$LOGICAL_N_TIME" ];
      do
        FIRST_PART=`echo $LOGICAL_N_TIME | cut -d '_' -f 1`
        LOGICAL_N_TIME=`echo $LOGICAL_N_TIME | cut -d '_' -f 2-`
      done
      LOGICAL_N_TIME="`echo $LOGICAL_N_TIME | cut -c 1-4`-`echo $LOGICAL_N_TIME | cut -c 5-6`-`echo $LOGICAL_N_TIME | cut -c 7-8` `echo $LOGICAL_N_TIME | cut -c 9-10`:`echo $LOGICAL_N_TIME | cut -c 11-12`"
      PHYSICAL_D_TIME=`echo $PHYSICAL_D | cut -d '.' -f 1`
      while [ "$FIRST_PART" != "$PHYSICAL_D_TIME" ];
      do
        FIRST_PART=`echo $PHYSICAL_D_TIME | cut -d '_' -f 1`
        PHYSICAL_D_TIME=`echo $PHYSICAL_D_TIME | cut -d '_' -f 2-`
      done
      PHYSICAL_D_TIME="`echo $PHYSICAL_D_TIME | cut -c 1-4`-`echo $PHYSICAL_D_TIME | cut -c 5-6`-`echo $PHYSICAL_D_TIME | cut -c 7-8` `echo $PHYSICAL_D_TIME | cut -c 9-10`:`echo $PHYSICAL_D_TIME | cut -c 11-12`"
      PHYSICAL_N_TIME=`echo $PHYSICAL_N | cut -d '.' -f 1`
      while [ "$FIRST_PART" != "$PHYSICAL_N_TIME" ];
      do
        FIRST_PART=`echo $PHYSICAL_N_TIME | cut -d '_' -f 1`
        PHYSICAL_N_TIME=`echo $PHYSICAL_N_TIME | cut -d '_' -f 2-`
      done
      PHYSICAL_N_TIME="`echo $PHYSICAL_N_TIME | cut -c 1-4`-`echo $PHYSICAL_N_TIME | cut -c 5-6`-`echo $PHYSICAL_N_TIME | cut -c 7-8` `echo $PHYSICAL_N_TIME | cut -c 9-10`:`echo $PHYSICAL_N_TIME | cut -c 11-12`"

    if [ ${STATLEVEL} -eq 1 ]; then
      # Write First Line, Instance ID Need RowSpan
      echo "<tr><th class=awrnbg rowspan=${__RPT_LIMIT}>${INST_ID}<br>${INST_NAME}</th><th class=awrnbg>1</th>" >> ${__INDEX_HTML}
    else
      echo "<tr><th class=awrnbg>${STATLEVEL}</th>" >> ${__INDEX_HTML}
    fi
    if [ -d "${__AWRRPT_DIR}/${DBTIME_D}" ]; then
      echo "<td class=awrnc>N/A</td>" >> ${__INDEX_HTML}
    else
      echo "<td class=awrnc><a href='${AWR_DIR}/${DBTIME_D}'>$DBTIME_D_TIME</a></td>" >> ${__INDEX_HTML}
    fi
    if [ -d "${__AWRRPT_DIR}/${DBTIME_N}" ]; then
      echo "<td class=awrc>N/A</td>" >> ${__INDEX_HTML}
    else
      echo "<td class=awrc><a href='${AWR_DIR}/${DBTIME_N}'>$DBTIME_N_TIME</a></td>" >> ${__INDEX_HTML}
    fi
    if [ -d "${__AWRRPT_DIR}/${LOGICAL_D}" ]; then
      echo "<td class=awrnc>N/A</td>" >> ${__INDEX_HTML}
    else
      echo "<td class=awrnc><a href='${AWR_DIR}/${LOGICAL_D}'>$LOGICAL_D_TIME</a></td>" >> ${__INDEX_HTML}
    fi
    if [ -d "${__AWRRPT_DIR}/${LOGICAL_N}" ]; then
      echo "<td class=awrc>N/A</td>" >> ${__INDEX_HTML}
    else
      echo "<td class=awrc><a href='${AWR_DIR}/${LOGICAL_N}'>$LOGICAL_N_TIME</a></td>" >> ${__INDEX_HTML}
    fi
    if [ -d "${__AWRRPT_DIR}/${PHYSICAL_D}" ]; then
      echo "<td class=awrnc>N/A</td>" >> ${__INDEX_HTML}
    else
      echo "<td class=awrnc><a href='${AWR_DIR}/${PHYSICAL_D}'>$PHYSICAL_D_TIME</a></td>" >> ${__INDEX_HTML}
    fi
    if [ -d "${__AWRRPT_DIR}/${PHYSICAL_N}" ]; then
      echo "<td class=awrc>N/A</td></tr>" >> ${__INDEX_HTML}
    else
      echo "<td class=awrc><a href='${AWR_DIR}/${PHYSICAL_N}'>$PHYSICAL_N_TIME</a></td></tr>" >> ${__INDEX_HTML}
    fi
    done
  done < ${__INSTANCE_INFO_FILE}
  echo "</table>" >>${__INDEX_HTML}

  # Building Index of Other Reports: Snapshot, Trendline, OS Report
  print_log "[build_index]" "" "Building Index of Other Reports"
  echo "<br><H3 class='awr'> Other Reports </H3><p> <table border=1 WIDTH=300></table> <p> <table border=1 WIDTH=700>" >> ${__INDEX_HTML}
  FILE_EXISTS=`cd ${__AWRRPT_DIR}; ls enmotech_report_* 2>/dev/null | grep 'Basic'`
  if [ "${FILE_EXISTS}" = "" ]; then
    echo "<tr><th class=awrbg width=30% align=left>Snapshot (Basic)</th> <td class=awrnc>N/A </td></tr>" >> ${__INDEX_HTML}
  else
    echo "<tr><th class=awrbg width=30% align=left>Snapshot (Basic)</th> <td class=awrnc><a href='${AWR_DIR}/${FILE_EXISTS}'>${FILE_EXISTS}</a> </td></tr>" >> ${__INDEX_HTML}
  fi
  FILE_EXISTS=`cd ${__AWRRPT_DIR}; ls enmotech_report_* 2>/dev/null | grep 'Supplement'`
  if [ "${FILE_EXISTS}" = "" ]; then
    echo "<tr><th class=awrbg width=30% align=left>Snapshot (Supplement)</th> <td class=awrnc>N/A </td></tr>" >> ${__INDEX_HTML}
  else
    echo "<tr><th class=awrbg width=30% align=left>Snapshot (Supplement)</th> <td class=awrnc><a href='${AWR_DIR}/${FILE_EXISTS}'>${FILE_EXISTS}</a> </td></tr>" >> ${__INDEX_HTML}
  fi
  if [ -f "${__STATS_GRAPHIC_FILE}" ]; then
    FILE_EXISTS=`echo "${__STATS_GRAPHIC_FILE}" | cut -d '/' -f 3`
    echo "<tr><th class=awrbg width=30% align=left>Trendline</th> <td class=awrnc><a href='${CHART_DIR}/${FILE_EXISTS}'>${FILE_EXISTS}</a> </td></tr>" >> ${__INDEX_HTML}
  else
    echo "<tr><th class=awrbg width=30% align=left>Trendline</th> <td class=awrnc>N/A </td></tr>" >> ${__INDEX_HTML}
  fi
  if [ -f "${__GRAPHIC_FIX_FILE}" ]; then
    FILE_EXISTS=`echo "${__GRAPHIC_FIX_FILE}" | cut -d '/' -f 3`
    echo "<tr><th class=awrbg width=30% align=left>Trendline (Fixed)</th> <td class=awrnc><a href='${CHART_DIR}/${FILE_EXISTS}'>${FILE_EXISTS}</a> </td></tr>" >> ${__INDEX_HTML}
  else
    echo "<tr><th class=awrbg width=30% align=left>Trendline (Fixed)</th> <td class=awrnc>N/A </td></tr>" >> ${__INDEX_HTML}
  fi
  if [ -f "${__WAITS_GRAPHIC_HTML}" ]; then
    FILE_EXISTS=`echo "${__WAITS_GRAPHIC_HTML}" | cut -d '/' -f 3`
    echo "<tr><th class=awrbg width=30% align=left>Wait Events</th> <td class=awrnc><a href='${CHART_DIR}/${FILE_EXISTS}'>${FILE_EXISTS}</a> </td></tr>" >> ${__INDEX_HTML}
  else
    echo "<tr><th class=awrbg width=30% align=left>Wait Events</th> <td class=awrnc>N/A </td></tr>" >> ${__INDEX_HTML}
  fi
  FILE_EXISTS="os_report_${__HOSTNAME}.html"
  if [ -f "${__OSDATA_DIR}/${FILE_EXISTS}" ]; then
    echo "<tr><th class=awrbg width=30% align=left>OS Report</th> <td class=awrnc><a href='${OS_DIR}/${FILE_EXISTS}'>${FILE_EXISTS}</a> </td></tr>" >> ${__INDEX_HTML}
  else
    echo "<tr><th class=awrbg width=30% align=left>OS Report</th> <td class=awrnc>N/A </td></tr>" >> ${__INDEX_HTML}
  fi
  echo "</table>" >> ${__INDEX_HTML}

  # Add Alert Errors
  cat ${__ALERT_HTML} >> ${__INDEX_HTML} 2>/dev/null
  # Change File Type to HTML
  for TRCFILE in `ls ${__TRACE_DIR}/* 2>/dev/null`
  do
    mv ${TRCFILE} ${TRCFILE}.html
  done
  for ALTERFILE in `ls ${__SCRIPT_DIR}/alert_*.log 2>/dev/null`
  do
    mv ${ALTERFILE} ${ALTERFILE}.html
  done

  # Merge SQL Report into AWR Reports, and Build SQL Report Index
  echo "</table> <br><H3 class='awr'> SQL Reports </H3><p> <table border=1 WIDTH=300></table> <p> <table border=1 WIDTH=600> <tr HEIGHT=30><th class=awrbg width=15%>SQL ID</th> <th class=awrbg width=10%>Inst No.</th> <th class=awrbg width=15%>Begin Snap ID</th> <th class=awrbg width=15%>End Snap ID</th> <th class=awrbg width=15%>Report Link</th></tr>" >> ${__INDEX_HTML}
  LINE_COLOR=""
  touch ${__SQL_NEEDED}
  while read SQL_ID INST_ID BEGIN_ID END_ID SQLRPT_FILENAME
  do
    if [ -f "${__SQLRPT_DIR}/${SQLRPT_FILENAME}" ]; then
      print_log "[build_index]" "" "Linked SQL Report with SQL_ID = [${SQL_ID}] into AWR Report"
      echo "<tr><td class=awr${LINE_COLOR}c>${SQL_ID}</td><td class=awr${LINE_COLOR}c>${INST_ID}</td><td class=awr${LINE_COLOR}c>${BEGIN_ID}</td><td class=awr${LINE_COLOR}c>${END_ID}</td><td class=awr${LINE_COLOR}c><a href='${SQL_DIR}/${SQLRPT_FILENAME}'>see Report</a></td></tr>" >> ${__INDEX_HTML}
      if [ "${LINE_COLOR}" = "" ]; then
        LINE_COLOR="n"
      else
        LINE_COLOR=""
      fi
      for AWRRPT in `cd ${__AWRRPT_DIR}; ls awrrpt_${INST_ID}_*.html`
      do
        cp ${__AWRRPT_DIR}/${AWRRPT} ${__OTHER_DIR}/awrrpt_for_merge.tmp
        sed "s@#${SQL_ID}@../SQL_Reports/${SQLRPT_FILENAME}@" ${__OTHER_DIR}/awrrpt_for_merge.tmp > ${__AWRRPT_DIR}/${AWRRPT}
      done
    else
      print_log "[build_index]" "" "SQL Report with SQL ID [${SQL_ID}] does not exists, Skip Link ..."
    fi
  done < ${__SQL_NEEDED}
  echo "</table> </BODY></HTML>" >> ${__INDEX_HTML}

  print_log "[build_index]" "5" "${__OTHER_DIR}/awrrpt_for_merge.tmp"
  print_log "[build_index]" "" "Index File Generated Successfully in [${__INDEX_HTML}]"
}

#########################################################################################################
##                                                                                                     ##
## Function rpt_optimizer(): Optimizer AWR or STATSPACK Need File, Merge same Report                   ##
##                                                                                                     ##
#########################################################################################################
rpt_optimizer(){

  print_log "[rpt_optimizer]" "" "AWR/Statspack Report Optimization, Merge Same Report in [${__SQL_NEEDED}]"
  REPORT_TYPE=${1}

  # Sort AWR List File to Make it possible to skip same AWR
  sort -u ${__RPT_NEEDED} > ${__RPT_NEEDED}.tmp

  # Generate HTML AWR Report
  RPT_COUNT=1
  PREV_INSTID=0
  PREV_BID=0
  PREV_EID=0
  PREV_BTIME=""
  PREV_ETIME=""
  PREV_TYPE=""
  echo "" > ${__RPT_NEEDED}
  while read INST_ID BEGIN_TIME BEGIN_ID END_TIME END_ID STAT_NAME TIME_TYPE STAT_LEVEL
  do
    if [ "${PREV_INSTID}" = "${INST_ID}" ] && [ "${PREV_BID}" = "${BEGIN_ID}" ]; then
      PREV_TYPE="${PREV_TYPE}_`echo ${STAT_NAME} | cut -c 1`${TIME_TYPE}${STAT_LEVEL}"
      PREV_INSTID=${INST_ID}
    else
      if [ "${PREV_TYPE}" != "" ]; then
        let "RPT_COUNT+=1"
        echo "${PREV_INSTID} ${PREV_BID} ${PREV_EID} ${REPORT_TYPE}_${PREV_INSTID}${PREV_TYPE}_${PREV_BTIME}_${PREV_ETIME}.html ${PREV_TYPE}" >>${__RPT_NEEDED}
      fi
      PREV_BID=${BEGIN_ID}
      PREV_EID=${END_ID}
      PREV_BTIME=${BEGIN_TIME}
      PREV_ETIME=${END_TIME}
      PREV_TYPE="_`echo ${STAT_NAME} | cut -c 1`${TIME_TYPE}${STAT_LEVEL}"
      PREV_INSTID=${INST_ID}
    fi
  done < ${__RPT_NEEDED}.tmp

  if [ ${PREV_BID} -gt 0 ]; then
    echo "${PREV_INSTID} ${PREV_BID} ${PREV_EID} ${REPORT_TYPE}_${PREV_INSTID}${PREV_TYPE}_${PREV_BTIME}_${PREV_ETIME}.html ${PREV_TYPE}" >>${__RPT_NEEDED}
    grep -v "^$" ${__RPT_NEEDED} >${__RPT_NEEDED}.tmp
    mv ${__RPT_NEEDED}.tmp ${__RPT_NEEDED}
    print_log "[rpt_optimizer]" "" "Find [${RPT_COUNT}] different Report's Info in Report Optimizer"
  else
    print_log "[rpt_optimizer]" "" "Find [0] different Report's Info in Report Optimizer"
  fi

  print_log "[rpt_optimizer]" "" "Report Optimization Successfully Completed"
}

#########################################################################################################
##                                                                                                     ##
## Function get_awrrpt(): Get AWR Report in HTML Format                                                ##
##   Result write into ${__AWRRPT_DIR} directory                                                       ##
##                                                                                                     ##
#########################################################################################################
get_awrrpt(){

  print_log "[get_awrrpt]" "" "Begin Collect AWR Result into HTML File"
  rpt_optimizer "awrrpt"

  # Generate HTML AWR Report
  ALLAWR=`cat ${__RPT_NEEDED} | grep -v '^$' | wc -l`
  CURAWR=0
  if [ ${ALLAWR} -gt 0 ]; then
    while read INST_ID BEGIN_ID END_ID FILE_NAME TIME_TYPE
    do
      let "CURAWR=${CURAWR}+1"
      print_log "[get_awrrpt]" "" "Get AWR Report [ ${CURAWR} of ${ALLAWR} ]: BI=[${BEGIN_ID}] EI=[${END_ID}] II=[${INST_ID}] TT=[${TIME_TYPE}]"
      SQL_EXEC="SET LINESIZE 1000 PAGESIZE 1000 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON AUTOT OFF
 DEFINE REPORT_TYPE='html'
 DEFINE DBID=${__DBID}
 DEFINE INST_NUM=${INST_ID}
 DEFINE NUM_DAYS=0
 DEFINE BEGIN_SNAP=${BEGIN_ID}
 DEFINE END_SNAP=${END_ID}
 DEFINE REPORT_NAME=${FILE_NAME}
 @?/rdbms/admin/awrrpti
 EXIT"
      print_log "[get_awrrpt]" "4" "AWR Report Created" "${SQL_EXEC}"
      ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 2>> ${__ERRORFILE} 1>/dev/null <<EOF
      ${SQL_EXEC}
EOF
      if [ -f "${FILE_NAME}" ] && [ "`cat ${FILE_NAME} | grep '^ORA-'`" != "" ]; then
        print_log "[get_awrrpt]" "2" "[Warnning] Something 'ORA-' in AWR Report [${FILE_NAME}]"
        print_log "[get_awrrpt]" "2" "[Cause] `cat ${FILE_NAME} | grep '^ORA-' | sort -u`"
      elif [ ! -f "${FILE_NAME}" ]; then
        print_log "[get_awrrpt]" "2" "[Warnning] Cannot Get AWR Report, I think meybe a instance restart occured"
      fi
    done < ${__RPT_NEEDED}

    # move AWR Report to the ${__AWRRPT_DIR} directory
    mv awrrpt_* ${__AWRRPT_DIR}/ 2>/dev/null
    if [ $? -eq 0 ]; then
      print_log "[get_awrrpt]" "" "Seccessfully Move AWR Reports into [${__AWRRPT_DIR}] directory"
    else
      print_log "[get_awrrpt]" "2" "[Warnning] move AWR Report Error, maybe no AWR Report Collected, Continue other Collections ..."
    fi
  fi
}

#########################################################################################################
##                                                                                                     ##
## Function get_sprpt(): Get STATSPACK Report in TEXT Format                                           ##
##   Result write into ${__SPRPT_DIR} directory                                                        ##
##                                                                                                     ##
#########################################################################################################
get_sprpt(){

  print_log "[get_sprpt]" "" "Begin Collect Statspack Result into Text File"
  rpt_optimizer "sprpt"

  # Generate Text STATSPACK Report
  ALLSP=`cat ${__RPT_NEEDED} | grep -v '^$' | wc -l`
  CURSP=0
  if [ ${ALLSP} -gt 0 ]; then
    while read INST_ID BEGIN_ID END_ID FILE_NAME TIME_TYPE
    do
      let "CURSP=${CURSP}+1"
      print_log "[get_sprpt]" "" "Get SP Report [ ${CURSP} of ${ALLSP} ]: BI=[${BEGIN_ID}] EI=[${END_ID}] II=[${INST_ID}] TT=[${TIME_TYPE}]"
      SQL_EXEC="SET LINESIZE 1000 PAGESIZE 1000 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON AUTOT OFF
 DEFINE DBID=${__DBID}
 DEFINE INST_NUM=${INST_ID}
 DEFINE NUM_DAYS=0
 DEFINE BEGIN_SNAP=${BEGIN_ID}
 DEFINE END_SNAP=${END_ID}
 DEFINE REPORT_NAME=${FILE_NAME}
 @?/rdbms/admin/sprepins.sql
 EXIT"
      print_log "[get_sprpt]" "4" "Statspack Repor Created" "${SQL_EXEC}"
      ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 2>> ${__ERRORFILE} 1>/dev/null <<EOF
      ${SQL_EXEC}
EOF
      if [ -f "${FILE_NAME}" ] && [ "`cat ${FILE_NAME} | grep '^ORA-'`" != "" ]; then
        print_log "[get_sprpt]" "2" "[Warnning] Something 'ORA-' in STATSPACK Report [${FILE_NAME}]"
        print_log "[get_sprpt]" "2" "[Cause] `cat ${FILE_NAME} | grep '^ORA-' | sort -u`"
      elif [ ! -f "${FILE_NAME}" ]; then
        print_log "[get_sprpt]" "2" "[Warnning] Cannot Get STATSPACK Report, I think meybe a instance restart occured"
      fi
    done < ${__RPT_NEEDED}

   # move STATSPACK Report to the ${__SPRPT_DIR} directory
    mv sprpt_* ${__SPRPT_DIR}/ 2>/dev/null
    if [ $? -eq 0 ]; then
      print_log "[get_sprpt]" "" "Seccessfully STATSPACK Reports into [${__SPRPT_DIR}] directory"
    else
      print_log "[get_sprpt]" "2" "[Warnning] move STATSPACK Report Error, maybe no STATPACK Report Collected, Continue other Collections ..."
    fi
  fi
}

#########################################################################################################
##                                                                                                     ##
## Function get_awrinfo(): Get AWR Stat Information in Html and txt Format                             ##
##   Result write into ${__STAT_DIR} directory                                                         ##
##                                                                                                     ##
#########################################################################################################
get_awrinfo(){

  print_log "[get_awrinfo]" "" "Begin Collect AWR Statistics Info with Text and HTML File"
  if [ "$1" = "" ] && [ "$2" = "" ] && [ "$3" = "" ] && [ "$4" = "" ] && [ "$5" = "" ] && [ "$6" = "" ] && [ "$7" = "" ]; then
    print_log "[get_awrinfo]" "2" "[Error] not Enough Info: TYPE=[$7], FILE=[$1], Y=[$6], TITLE=[$4], NAME=[$2], OPT=[$3], SUB=[$5]"
  else
    print_log "[get_awrinfo]" "" "AWR STAT Info: FILE=[$1], STAT=[$2], CONVERT=[$3], TITLE=[$4], SUB_TITLE=[$5], HTML_Y=[$6], TYPE=[$7]"
    STAT_FILE_NAME=$1
    STAT_NAME=$2
    CONVERT_OPT=$3
    HTML_TITLE=$4
    HTML_SUB_TITLE=$5
    HTML_Y=$6
    STAT_TYPE=$7
    if [ "${STAT_FILE_NAME}" = "dbtime" ] || [ "${STAT_FILE_NAME}" = "cputime" ]; then
      echo "<script type='text/javascript'>\$(function () {\$('#${STAT_FILE_NAME}').highcharts({chart: {type: 'spline'}, title: {text: '${HTML_TITLE}'}, subtitle: {text: '${HTML_SUB_TITLE}'}, xAxis: {title: {text: 'Snap Time'}, type: 'datetime'}, yAxis: {title: {text: '${HTML_Y}'}, min: 0, labels: {format : '{value:,.2f}'}}, tooltip: {formatter: function() {return '<b>Inst No.: '+ this.series.name +'</b><br/><b>Time: </b>'+ Highcharts.dateFormat('%Y-%m-%d %H:%M', this.x) +'<br/><b>${HTML_Y} : </b>'+ this.y; } }, series: [{" >> ${__STATS_GRAPHIC_FILE}
      echo "<script type='text/javascript'>\$(function () {\$('#${STAT_FILE_NAME}').highcharts({chart: {type: 'spline'}, title: {text: '${HTML_TITLE}'}, subtitle: {text: '${HTML_SUB_TITLE}'}, xAxis: {title: {text: 'Snap Time'}, type: 'datetime'}, yAxis: {title: {text: '${HTML_Y}'}, min: 0, labels: {format : '{value:,.2f}'}}, tooltip: {formatter: function() {return '<b>Inst No.: '+ this.series.name +'</b><br/><b>Time: </b>'+ Highcharts.dateFormat('%Y-%m-%d %H:%M', this.x) +'<br/><b>${HTML_Y} : </b>'+ this.y; } }, series: [{" >> ${__GRAPHIC_FIX_FILE}
    else
      echo "<script type='text/javascript'>\$(function () {\$('#${STAT_FILE_NAME}').highcharts({chart: {type: 'spline'}, title: {text: '${HTML_TITLE}'}, subtitle: {text: '${HTML_SUB_TITLE}'}, xAxis: {title: {text: 'Snap Time'}, type: 'datetime'}, yAxis: {title: {text: '${HTML_Y}'}, min: 0, labels: {format : '{value:,.0f}'}}, tooltip: {formatter: function() {return '<b>Inst No.: '+ this.series.name +'</b><br/><b>Time: </b>'+ Highcharts.dateFormat('%Y-%m-%d %H:%M', this.x) +'<br/><b>${HTML_Y} : </b>'+ this.y; } }, series: [{" >> ${__STATS_GRAPHIC_FILE}
      echo "<script type='text/javascript'>\$(function () {\$('#${STAT_FILE_NAME}').highcharts({chart: {type: 'spline'}, title: {text: '${HTML_TITLE}'}, subtitle: {text: '${HTML_SUB_TITLE}'}, xAxis: {title: {text: 'Snap Time'}, type: 'datetime'}, yAxis: {title: {text: '${HTML_Y}'}, min: 0, labels: {format : '{value:,.0f}'}}, tooltip: {formatter: function() {return '<b>Inst No.: '+ this.series.name +'</b><br/><b>Time: </b>'+ Highcharts.dateFormat('%Y-%m-%d %H:%M', this.x) +'<br/><b>${HTML_Y} : </b>'+ this.y; } }, series: [{" >> ${__GRAPHIC_FIX_FILE}
    fi
    if [ "${STAT_TYPE}" = "T" ]; then
      STAT_TABLE='DBA_HIST_SYS_TIME_MODEL A, DBA_HIST_SYS_TIME_MODEL B'
    elif [ "${STAT_TYPE}" = "S" ]; then
      STAT_TABLE='DBA_HIST_SYSSTAT A, DBA_HIST_SYSSTAT B'
    else
      print_log "[get_awrinfo]" "2" "[Warnning] unKnown Stats Type = [${STAT_TYPE}] for Stats Name = [${STAT_NAME}], Program exit ..."
      echo "FALSE" > ${__OSLOAD_SWITCHER}
      exit 1
    fi

    # Loop to Collect All Instance Data
    NEED_ENDCHAR=0
    while read INST_NUM INST_NAME
    do
      # If current collected instance is not the first instance, then add HTML Text
      if [ ${NEED_ENDCHAR} -ne 0 ]; then
        echo "]}, {name:'${INST_NAME}', data:[" >> ${__STATS_GRAPHIC_FILE}
        echo "]}, {name:'${INST_NAME}', data:[" >> ${__GRAPHIC_FIX_FILE}
      else
        echo "name:'${INST_NAME}', data:[" >> ${__STATS_GRAPHIC_FILE}
        echo "name:'${INST_NAME}', data:[" >> ${__GRAPHIC_FIX_FILE}
      fi
      NEED_ENDCHAR=1
      print_log "[get_awrinfo]" "" "Get AWR Stats Information for Instance Number [${INST_NUM}]"
      RESULT="${__STAT_DIR}/${STAT_FILE_NAME}_${INST_NUM}.txt"
      SQL_1_EXEC="SET LINESIZE 1000 PAGESIZE 1000 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON AUTOT OFF
 SPOOL ${RESULT}.tmp
 SELECT END_TIME, ROUND(${STAT_FILE_NAME}${CONVERT_OPT}, 1) ${STAT_FILE_NAME}
   FROM ( SELECT /*+ RULE */ TO_CHAR(C.END_INTERVAL_TIME, 'YYYY-MM-DD HH24:MI') END_TIME, CASE WHEN SUM(A.VALUE-B.VALUE) > 0 THEN ROUND(SUM((A.VALUE-B.VALUE)/C.INTERVAL_2_S)) ELSE 0 END ${STAT_FILE_NAME}
            FROM ${STAT_TABLE},
                 (SELECT /*+ RULE */ SNAP_ID, INSTANCE_NUMBER, END_INTERVAL_TIME, (CAST(END_INTERVAL_TIME AS DATE) - CAST(BEGIN_INTERVAL_TIME AS DATE))*86400 INTERVAL_2_S
                    FROM DBA_HIST_SNAPSHOT
                   WHERE END_INTERVAL_TIME BETWEEN TO_DATE('${__AWR_TIME_BEGIN}', 'YYYYMMDDHH24MI') AND TO_DATE('${__AWR_TIME_END}', 'YYYYMMDDHH24MI')
                     AND DBID = ${__DBID}) C
           WHERE A.STAT_NAME in ('${STAT_NAME}')
             AND B.STAT_ID = A.STAT_ID
             AND A.SNAP_ID = B.SNAP_ID + 1
             AND A.SNAP_ID = C.SNAP_ID
             AND A.DBID = ${__DBID}
             AND B.DBID = A.DBID
             AND A.INSTANCE_NUMBER = B.INSTANCE_NUMBER
             AND A.INSTANCE_NUMBER = C.INSTANCE_NUMBER
             AND A.INSTANCE_NUMBER = ${INST_NUM}
           GROUP BY C.END_INTERVAL_TIME)
  ORDER BY 1;
 SPOOL OFF"
      SQL_2_EXEC="SET HEADING OFF PAGES 0 LINES 1111 AUTOT OFF
 BREAK ON REPORT
 COMPUTE AVG LABEL 'AVERAGE' OF STAT_VALUE ON REPORT
 SPOOL ${__STATS_GRAPHIC_FILE}.orig
 SELECT '[Date.UTC('||substr(END_TIME,1,4)||','||(to_number(substr(END_TIME,5,2)-1))||','||substr(END_TIME,7,2)||','||substr(END_TIME,9,2)||','||substr(END_TIME,11,2)||'),' STAT_NAME, ROUND(${STAT_FILE_NAME}${CONVERT_OPT}, 2) STAT_VALUE
   FROM ( SELECT /*+ RULE */ TO_CHAR(C.END_INTERVAL_TIME, 'YYYYMMDDHH24MI') END_TIME, CASE WHEN SUM(A.VALUE-B.VALUE) > 0 THEN ROUND(SUM((A.VALUE-B.VALUE)/C.INTERVAL_2_S)) ELSE 0 END ${STAT_FILE_NAME}
            FROM ${STAT_TABLE},
                 (SELECT /*+ RULE */ SNAP_ID, INSTANCE_NUMBER, END_INTERVAL_TIME, (CAST(END_INTERVAL_TIME AS DATE) - CAST(BEGIN_INTERVAL_TIME AS DATE))*86400 INTERVAL_2_S FROM DBA_HIST_SNAPSHOT
                   WHERE END_INTERVAL_TIME BETWEEN TO_DATE('${__AWR_TIME_BEGIN}', 'YYYYMMDDHH24MI') AND TO_DATE('${__AWR_TIME_END}', 'YYYYMMDDHH24MI')
                     AND DBID = ${__DBID}) C
           WHERE A.STAT_NAME in ('${STAT_NAME}')
             AND B.STAT_ID = A.STAT_ID
             AND A.SNAP_ID = B.SNAP_ID + 1
             AND A.SNAP_ID = C.SNAP_ID
             AND A.DBID = ${__DBID}
             AND B.DBID = A.DBID
             AND A.INSTANCE_NUMBER = B.INSTANCE_NUMBER
             AND A.INSTANCE_NUMBER = C.INSTANCE_NUMBER
             AND A.INSTANCE_NUMBER = ${INST_NUM}
           GROUP BY C.END_INTERVAL_TIME ORDER BY 1 );
 SPOOL OFF
 EXIT"
      # Write SQLs to SQL File
      print_log "[get_awrinfo]" "4" "AWR Statistics Info with Text File" "${SQL_1_EXEC}"
      print_log "[get_awrinfo]" "4" "AWR Statistics Info with Html File" "${SQL_2_EXEC}"
      # Executed SQLs in SQL*Plus Tools
      ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1> /dev/null 2>>${__ERRORFILE} <<EOFSQLPLUS
      ${SQL_1_EXEC}
      ${SQL_2_EXEC}
EOFSQLPLUS
      if [ -f "${RESULT}.tmp" ]; then
        print_log "[get_awrinfo]" "5" "${RESULT}.tmp"
        if [ "`cat ${RESULT}.tmp  | grep '^ORA-'`" != "" ]; then
          print_log "[get_awrinfo]" "2" "[Error] Cannot Get AWR Stat info into Text File, Program abort ..."
          print_log "[get_awrinfo]" "2" "[Cause] `cat ${RESULT}.tmp | grep '^ORA-' | sort -u`"
          echo "FALSE" > ${__OSLOAD_SWITCHER}
          exit 1
        else
          egrep -v "^--|^$" ${RESULT}.tmp >${RESULT}
        fi
      else
        print_log "[get_awrinfo]" "2" "[Error] no AWR Stat info Result File for [${STAT_NAME}], Program abort ..."
        echo "FALSE" > ${__OSLOAD_SWITCHER}
        exit 1
      fi
      if [ -f "${__STATS_GRAPHIC_FILE}.orig" ] && [ "`cat ${__STATS_GRAPHIC_FILE}.orig  | grep '^ORA-'`" != "" ]; then
        print_log "[get_awrinfo]" "2" "[Error] Cannot Get AWR Stat info into HTML File, Program abort ..."
        print_log "[get_awrinfo]" "2" "[Cause] `cat ${__STATS_GRAPHIC_FILE} | grep '^ORA-' | sort -u`"
        echo "FALSE" > ${__OSLOAD_SWITCHER}
        exit 1
      elif [ ! -f "${__STATS_GRAPHIC_FILE}.orig" ]; then
        print_log "[get_awrinfo]" "2" "[Error] no AWR Graphic Stat info Result File for [${__STATS_GRAPHIC_FILE}], Program abort ..."
        echo "FALSE" > ${__OSLOAD_SWITCHER}
        exit 1
      else
        AVG_VALUE=`cat ${__STATS_GRAPHIC_FILE}.orig | grep "AVERAGE" | cut -d ' ' -f 2-`
        AVG_VALUE=`echo ${AVG_VALUE}`
        AVG_VALUE=`echo "scale=6;(${AVG_VALUE}*${__GRAPHIC_FIX_MAXMULTIPLE})/1" | bc`
        cat ${__STATS_GRAPHIC_FILE}.orig | grep -v 'AVERAGE' | grep -v '\-\-\-\-' > ${__STATS_GRAPHIC_FILE}.tmp
        MAX_COUNT=0

        # Calculate Max Value Count
        while read WORD_1 WORD_2
        do
          if [ `echo "scale=0;${AVG_VALUE}*1000000/1" | bc` -gt 0 ] && [ `echo "scale=0;${WORD_2}/${AVG_VALUE}" | bc` -ge 1 ]; then
            let "MAX_COUNT=${MAX_COUNT}+1"
          fi
        done < ${__STATS_GRAPHIC_FILE}.tmp

        print_log "[get_awrinfo]" "" "Max Count = [${MAX_COUNT}], Avg Value = [${AVG_VALUE}], Max Times = [${__GRAPHIC_FIX_MAXTIMES}], Max Multiples = [${__GRAPHIC_FIX_MAXMULTIPLE}]"
        # Write Graphic
        while read WORD_1 WORD_2
        do
          #echo "WORD 1 : [${WORD_1}], WORD 2 : [${WORD_2}], MAX Count [${MAX_COUNT}], AVG Value [${AVG_VALUE}], Max Times [${__GRAPHIC_FIX_MAXTIMES}]"
          echo "${WORD_1}${WORD_2}]," >> ${__STATS_GRAPHIC_FILE}
          if [ ${MAX_COUNT} -gt ${__GRAPHIC_FIX_MAXTIMES} ]; then
            echo "${WORD_1}${WORD_2}]," >> ${__GRAPHIC_FIX_FILE}
          elif [ `echo "scale=0;${AVG_VALUE}*1000000/1" | bc` -gt 0 ] && [ `echo "scale=0;${WORD_2}/${AVG_VALUE}" | bc` -lt 1 ]; then
            echo "${WORD_1}${WORD_2}]," >> ${__GRAPHIC_FIX_FILE}
          fi
        done < ${__STATS_GRAPHIC_FILE}.tmp

        # Write Removable File
        print_log "[get_awrinfo]" "5" "${__STATS_GRAPHIC_FILE}.orig"
        print_log "[get_awrinfo]" "5" "${__STATS_GRAPHIC_FILE}.tmp"
      fi
    done <${__INSTANCE_INFO_FILE}

    echo '] }] }); }); </script> ' >> ${__STATS_GRAPHIC_FILE}
    echo '] }] }); }); </script> ' >> ${__GRAPHIC_FIX_FILE}
    echo "<font face=courier-bold color=darkgreen size=3> =====> Trendline for [${STAT_FILE_NAME}] :</font><hr width=350 size=1 color=grey align=left><p> <div id='${STAT_FILE_NAME}' style='min-width: 500px; height: 400px; margin: auto 20px 50px 20px'></div>" >> ${__STATS_GRAPHIC_END}
  fi
}

#########################################################################################################
##                                                                                                     ##
## Function begin_statGraphic(): Write Begin info to Graphic HTML File                                 ##
##                                                                                                     ##
#########################################################################################################
begin_statGraphic(){

  isFixed=$1
  make_html_header
  echo "" > ${__STATS_GRAPHIC_END}
  cat ${__GRAPHIC_HEADER} >${__STATS_GRAPHIC_FILE} 2>/dev/null
  if [ $? -eq 0 ]; then
    print_log "[begin_statGraphic]" "" "Complete Construct Graphic Trend File as [${__STATS_GRAPHIC_FILE}]"
  else
    print_log "[begin_statGraphic]" "2" "Cannot Construct Graphic Trend File, check [${__GRAPHIC_HEADER}]"
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  fi

  if [ ${isFixed} -eq 1 ]; then
    cat ${__GRAPHIC_HEADER} >${__GRAPHIC_FIX_FILE} 2>/dev/null
    print_log "[begin_statGraphic]" "" "Complete Construct Graphic Trend Fixed File as [${__GRAPHIC_FIX_FILE}]"
  fi
}

#########################################################################################################
##                                                                                                     ##
## Function end_statGraphic(): Write End info to Graphic HTML File                                     ##
##                                                                                                     ##
#########################################################################################################
end_statGraphic(){

  isFixed=$1
  echo '</head> <body bgcolor=#EEEEEE><br> <font face=courier-bold color=#CD8500 size=6pt>Oracle Statsitics Trendline</font><p> <table border=1 bgcolor=#9acd32><tr> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td></tr></table><p><br>' >> ${__STATS_GRAPHIC_FILE}
  cat ${__STATS_GRAPHIC_END} >> ${__STATS_GRAPHIC_FILE} 2>/dev/null
  if [ $? -eq 0 ]; then
    echo ' </body> </html>' >> ${__STATS_GRAPHIC_FILE}
    print_log "[end_statGraphic]" "" "Complete End Graphic Trend File into [${__STATS_GRAPHIC_FILE}]"
  else
    print_log "[end_statGraphic]" "2" "Cannot End Graphic Trend File, check [${__STATS_GRAPHIC_END}]"
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  fi

  if [ ${isFixed} -eq 1 ]; then
    echo '</head> <body bgcolor=#EEEEEE><br> <font face=courier-bold color=#CD8500 size=6pt>Oracle Statsitics Trendline (Fixed)</font><p> <table border=1 bgcolor=#9acd32><tr> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td></tr></table><p><br>' >> ${__GRAPHIC_FIX_FILE}
    cat ${__STATS_GRAPHIC_END} >> ${__GRAPHIC_FIX_FILE} 2>/dev/null
    echo ' </body> </html>' >> ${__GRAPHIC_FIX_FILE}
    print_log "[end_statGraphic]" "" "Complete End Graphic Trend Fixed File into [${__GRAPHIC_FIX_FILE}]"
  fi
  print_log "[get_spinfo]" "5" "${__GRAPHIC_HEADER}"
  print_log "[get_spinfo]" "5" "${__STATS_GRAPHIC_END}"
}

#########################################################################################################
##                                                                                                     ##
## Function get_spinfo(): Get STATSPACK Stat Information in txt Format                                 ##
##   Result write into ${__STAT_DIR} directory                                                         ##
##                                                                                                     ##
#########################################################################################################
get_spinfo(){

  print_log "[get_spinfo]" "" "Begin Collect Statspack Statistics Info with Text and HTML File"
  if [ "$1" = "" ] && [ "$2" = "" ] && [ "$3" = "" ] && [ "$4" = "" ] && [ "$5" = "" ] && [ "$6" = "" ] && [ "$7" = "" ]; then
    print_log "[get_spinfo]" "2" "[Error] not Enough Info: TYPE=[$7], FILE=[$1], Y=[$6], TITLE=[$4], NAME=[$2], OPT=[$3], SUB=[$5]"
    print_log "[get_spinfo]" "" "Collection for ${1} ignored !"
  else
    print_log "[get_spinfo]" "" "STATSPACK STAT Info: FILE=[$1], STAT=[$2], CONVERT=[$3], TITLE=[$4], SUB_TITLE=[$5], HTML_Y=[$6], TYPE=[$7]"
    STAT_FILE_NAME=$1
    STAT_NAME=$2
    CONVERT_OPT=$3
    HTML_TITLE=$4
    HTML_SUB_TITLE=$5
    HTML_Y=$6
    STAT_TYPE=$7
    STAT_TABLE=""
    echo "<script type='text/javascript'> \$(function () {\$('#${STAT_FILE_NAME}').highcharts({chart: {type: 'spline'}, title: {text: '${HTML_TITLE}'}, subtitle: {text: '${HTML_SUB_TITLE}'}, xAxis: {title: {text: 'Snap Time'}, type: 'datetime'}, yAxis: {title: {text: '${HTML_Y}'}, min: 0, labels: {format : '{value:,.0f}'}}, tooltip: {formatter: function() {return '<b>Inst No.: '+ this.series.name +'</b><br/><b>Time: </b>'+ Highcharts.dateFormat('%Y-%m-%d %H:%M', this.x) +'<br/><b>${HTML_Y} : </b>'+ this.y; } }, series: [{ " >> ${__STATS_GRAPHIC_FILE}

    if [ "${STAT_TYPE}" = "T" ]; then
      STAT_TABLE="(SELECT /*+ RULE */ SNAP_ID, INSTANCE_NUMBER, SUM(VALUE) VALUE
                  FROM STATS\$SYS_TIME_MODEL T1, STATS\$TIME_MODEL_STATNAME T2
                 WHERE STAT_ID = (SELECT STAT_ID FROM STATS\$TIME_MODEL_STATNAME WHERE DBID=${__DBID} AND STAT_NAME IN ('${STAT_NAME}'))
                   AND DBID = ${__DBID}
                 GROUP BY SNAP_ID, INSTANCE_NUMBER) SY"
    elif [ "${STAT_TYPE}" = "S" ]; then
      STAT_TABLE="(SELECT /*+ RULE */ SNAP_ID, INSTANCE_NUMBER, SUM(VALUE) VALUE
                  FROM STATS\$SYSSTAT
                 WHERE DBID=${__DBID} AND NAME IN ('${STAT_NAME}')
                 GROUP BY SNAP_ID, INSTANCE_NUMBER) SY"
    fi

    # Loop to get All Instance Data
    FIRST_LINE=1
    while read INST_NUM INST_NAME
    do
      print_log "[get_spinfo]" "" "Get STATSPACK Stats Information for Instance Number [${INST_NUM}]"
      RESULT="${__STAT_DIR}/${STAT_FILE_NAME}_${INST_NUM}.txt"
      SQL_1_EXEC="SET LINESIZE 1000 PAGESIZE 1000 AUTOT OFF TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON
 SPOOL ${RESULT}.tmp
 SELECT /*+ RULE */ TO_CHAR(SN.SNAP_TIME, 'YYYY-MM-DD HH24:MI:SS') SNAP_TIME,
        CASE WHEN SY.VALUE > LAG(SY.VALUE) OVER(ORDER BY SY.SNAP_ID)
             THEN ROUND((SY.VALUE - LAG(SY.VALUE) OVER(ORDER BY SY.SNAP_ID))${CONVERT_OPT}/DECODE(INTERVAL_2_S, 0, 1, INTERVAL_2_S), 1)
             ELSE 0 END ${STAT_FILE_NAME}
   FROM ${STAT_TABLE},
        (SELECT /*+ RULE */ DBID, INSTANCE_NUMBER, SNAP_ID, SNAP_TIME,
                NVL((SNAP_TIME - LAG(SNAP_TIME) OVER (ORDER BY SNAP_TIME))*86400, 1) INTERVAL_2_S
           FROM STATS\$SNAPSHOT) SN
  WHERE SY.SNAP_ID = SN.SNAP_ID
    AND SN.SNAP_TIME BETWEEN TO_DATE('${__AWR_TIME_BEGIN}', 'YYYYMMDDHH24MI') AND TO_DATE('${__AWR_TIME_END}', 'YYYYMMDDHH24MI')
    AND SN.DBID = ${__DBID}
    AND SY.INSTANCE_NUMBER = SN.INSTANCE_NUMBER
    AND SY.INSTANCE_NUMBER = ${INST_NUM}
  ORDER BY SN.SNAP_TIME;
 SPOOL OFF"
      SQL_2_EXEC="SET HEADING OFF PAGES 0 LINES 1111 AUTOT OFF
 SPOOL ${__STATS_GRAPHIC_FILE}.tmp
 SELECT /*+ RULE */ (CASE WHEN ${FIRST_LINE} = 1 THEN '' ELSE ']}, {' END)||'name: ''${INST_NAME}'', data:[' FROM DUAL
  UNION ALL
 SELECT '[Date.UTC('||SNAP_YEAR||','||SNAP_MONTH||LEFT_TIME||'), '||${STAT_FILE_NAME}||'],'
   FROM (SELECT /*+ RULE */ TO_CHAR(SN.SNAP_TIME, 'YYYY') SNAP_YEAR
              , TO_NUMBER(TO_CHAR(SN.SNAP_TIME, 'MM'))-1 SNAP_MONTH
              , TO_CHAR(SN.SNAP_TIME, ',DD,HH24,MI') LEFT_TIME
              , CASE WHEN SY.VALUE > LAG(SY.VALUE) OVER(ORDER BY SY.SNAP_ID)
                THEN ROUND((SY.VALUE - LAG(SY.VALUE) OVER(ORDER BY SY.SNAP_ID))${CONVERT_OPT}/DECODE(INTERVAL_2_S, 0, 1, INTERVAL_2_S), 2)
                ELSE 0 END ${STAT_FILE_NAME}
           FROM ${STAT_TABLE},
                (SELECT /*+ RULE */ DBID, INSTANCE_NUMBER, SNAP_ID, SNAP_TIME,
                        NVL((SNAP_TIME - LAG(SNAP_TIME) OVER (ORDER BY SNAP_TIME))*86400, 1) INTERVAL_2_S
                   FROM STATS\$SNAPSHOT) SN
          WHERE SY.SNAP_ID = SN.SNAP_ID
            AND SN.SNAP_TIME BETWEEN TO_DATE('${__AWR_TIME_BEGIN}', 'YYYYMMDDHH24MI') AND TO_DATE('${__AWR_TIME_END}', 'YYYYMMDDHH24MI')
            AND SN.DBID = ${__DBID}
            AND SY.INSTANCE_NUMBER = SN.INSTANCE_NUMBER
            AND SY.INSTANCE_NUMBER = ${INST_NUM}
          ORDER BY SN.SNAP_TIME);
 SPOOL OFF
 EXIT"
      # Write SQLs to SQL File
      print_log "[get_spinfo]" "4" "Statspack Statistics Info with Text File" "${SQL_1_EXEC}"
      print_log "[get_spinfo]" "4" "Statspack Statistics Info with Html File" "${SQL_2_EXEC}"
      # Executed SQLs in SQL*Plus Tools
      ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1> /dev/null 2>>${__ERRORFILE} <<EOF
      ${SQL_1_EXEC}
      ${SQL_2_EXEC}
EOF
      if [ -f "${RESULT}.tmp" ] && [ "`cat ${RESULT}.tmp  | grep '^ORA-'`" != "" ]; then
        print_log "[get_spinfo]" "2" "[Error] Cannot Get STATSPACK Stat [${STAT_FILE_NAME}] info into Text File"
        print_log "[get_spinfo]" "2" "[Cause] `cat ${RESULT}.tmp | grep '^ORA-' | sort -u`"
        print_log "[get_spinfo]" "5" "${RESULT}.tmp"
      elif [ ! -f "${RESULT}.tmp" ]; then
        print_log "[get_spinfo]" "2" "[Error] no STATSPACK Stat File [${STAT_FILE_NAME}] Created, Statspack Text Info ignored ..."
      else
        egrep -v "^--|^$" ${RESULT}.tmp > ${RESULT}
      fi
      if [ -f "${__STATS_GRAPHIC_FILE}.tmp" ] && [ "`cat ${__STATS_GRAPHIC_FILE}.tmp | grep '^ORA-'`" != "" ]; then
        print_log "[get_spinfo]" "2" "[Error] STATSPACK Graphic Trend File [${STAT_FILE_NAME}] has Error in it"
        print_log "[get_spinfo]" "2" "[Cause] `cat ${__STATS_GRAPHIC_FILE}.tmp | grep '^ORA-' | sort -u`"
        print_log "[get_spinfo]" "5" "${__STATS_GRAPHIC_FILE}.tmp"
      elif [ ! -f "${__STATS_GRAPHIC_FILE}.tmp" ]; then
        print_log "[get_spinfo]" "2" "[Error] no STATSPACK Graphic Trend File for [${STAT_FILE_NAME}] Created, Statspack Html Info ignored ..."
      else
        egrep -v "^--|^$" ${__STATS_GRAPHIC_FILE}.tmp >> ${__STATS_GRAPHIC_FILE}
      fi
      FIRST_LINE=0
    done <${__INSTANCE_INFO_FILE}

    # Complete Trend HTML File
    echo '] }] }); }); </script> ' >> ${__STATS_GRAPHIC_FILE}
    echo "<font face=courier-bold color=darkgreen size=3> =====> Trendline for [${STAT_FILE_NAME}] :</font><hr width=350 size=1 color=grey align=left><p> <div id='${STAT_FILE_NAME}' style='min-width: 500px; height: 400px; margin: auto 20px 50px 20px'></div>" >> ${__STATS_GRAPHIC_END}
  fi
}

#########################################################################################################
##                                                                                                     ##
## Function get_sql_needed(): Get Needed information for Generate SQL Report                           ##
##   Result write into ${__SQL_NEEDED} file                                                            ##
##   Format: <SQL_ID> <INST> <BEGIN_ID> <END_ID> <STAT_NAME> <TIME_TYPE> <STAT_LV> <SQL_TYPE> <SQL_LV> ##
##                                                                                                     ##
#########################################################################################################
get_sql_needed(){

  print_log "[get_sql_needed]" "" "Begin Collect AWR SQL Needed Information"
  SQL_TYPE=${1}
  TIME_TYPE=${2}
  if [ "$1" = "" ] || [ "$1" = "" ]; then
    print_log "[get_sql_needed]" "2" "[Error] Cannot Get Correct Input for [get_sql_needed{}] with \$1 = [$1] and \$2 = [$2]"
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  else
    print_log "[get_sql_needed]" "" "Get Needed Generate SQL Report for SQL TYPE = [${SQL_TYPE}], Time Type = [${TIME_TYPE}]"
  fi

  # Sort SQL Needed Info and Grep Correct Time Data
  RESULT_TMP=${__SQL_NEEDED}.tmp
  if [ -n ${TIME_TYPE} ]; then
    cut -d ' ' -f 1,3,5,6,7,8 ${__RPT_NEEDED} | grep " ${TIME_TYPE} " > ${RESULT_TMP}
  else
    cut -d ' ' -f 1,3,5,6,7,8 ${__RPT_NEEDED} > ${RESULT_TMP}
  fi

  # Loop to collect all needed SQL Info for all collected AWR
  while read INST_ID BEGIN_ID END_ID STAT_NAME TIME_TYPE STAT_LEVEL
  do
    print_log "[get_sql_needed]" "" "Get Needed SQL Report for BI=[${BEGIN_ID}] EI=[${END_ID}] II=[${INST_ID}] SN=[${STAT_NAME}] TT=[${TIME_TYPE}] SL=[${STAT_LEVEL}]"
    SQL="SET LINESIZE 1000 PAGESIZE 0 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON HEADING OFF AUTOT OFF
 SPOOL ${__SQL_NEEDED} APPEND
 SELECT AWR_SQL_INFO||' '||rownum
   FROM (SELECT /*+ RULE */ SQL_ID||' ${INST_ID} ${BEGIN_ID} ${END_ID} ${STAT_NAME} ${TIME_TYPE} ${STAT_LEVEL} ${SQL_TYPE}' AWR_SQL_INFO
           FROM DBA_HIST_SQLSTAT WHERE SNAP_ID=${END_ID} AND DBID=${__DBID} AND INSTANCE_NUMBER=${INST_ID} ORDER BY ${SQL_TYPE}_DELTA DESC)
  WHERE ROWNUM<=${__SQL_LIMIT};
 SPOOL OFF
 EXIT"
    print_log "[get_sql_needed]" "4" "Get SQL Needed Infomation" "${SQL}"
    ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1>/dev/null 2>>${__ERRORFILE} <<EOF
    ${SQL}
EOF
    if [ -f "${__SQL_NEEDED}" ] && [ "`cat ${__SQL_NEEDED} | grep '^ORA-'`" != "" ]; then
      print_log "[get_sql_needed]" "2" "[Error] Cannot Get SQL Needed info for AWR from Database, Program abort ..."
      print_log "[get_sql_needed]" "2" "[Cause] `cat ${__SQL_NEEDED} | grep '^ORA-' | sort -u`"
      echo "FALSE" > ${__OSLOAD_SWITCHER}
      exit 1
    elif [ ! -f "${__SQL_NEEDED}" ]; then
      print_log "[get_sql_needed]" "2" "[Error] no SQL Needed info Result for AWR from Database, Program abort ..."
      echo "FALSE" > ${__OSLOAD_SWITCHER}
      exit 1
    fi
  done < ${RESULT_TMP}

  # Write Temp File into remove script
  print_log "[get_sql_needed]" "5" "${RESULT_TMP}"
}

#########################################################################################################
##                                                                                                     ##
## Function get_spsql_needed(): Get Needed information for Generate SQL Report                         ##
##   Result write into ${__SQL_NEEDED} file                                                            ##
##   Format: <SQL_ID> <INST> <BEGIN_ID> <END_ID> <STAT_NAME> <TIME_TYPE> <STAT_LV> <SQL_TYPE> <SQL_LV> ##
##                                                                                                     ##
#########################################################################################################
get_spsql_needed(){

  print_log "[get_spsql_needed]" "" "Begin Collect Statspack SQL Needed Information"
  SQL_TYPE=${1}
  TIME_TYPE=${2}
  if [ "$1" = "" ] || [ "$1" = "" ]; then
    print_log "[get_spsql_needed]" "2" "[Error] Cannot Get Correct Input for [get_spsql_needed{}] with \$1 = [$1] and \$2 = [$2]"
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  else
    print_log "[get_spsql_needed]" "" "Get Needed Generate SQL Report for SQL TYPE = [${SQL_TYPE}], Time Type = [${TIME_TYPE}]"
  fi

  # Sort SQL Needed Info and Grep Correct Time Data
  RESULT_SQL_TMP=${__RPT_NEEDED}.tmp
  RESULT_TMP=${__SQL_NEEDED}.tmp
  if [ -n ${TIME_TYPE} ]; then
    cut -d ' ' -f 1,3,5,6,7,8 ${__RPT_NEEDED} | grep ${TIME_TYPE} > ${RESULT_SQL_TMP}
  else
    cut -d ' ' -f 1,3,5,6,7,8 ${__RPT_NEEDED} > ${RESULT_SQL_TMP}
  fi

  # Loop to collect all needed SQL Info for all collected STATPACK
  while read INST_ID BEGIN_ID END_ID STAT_NAME TIME_TYPE STAT_LEVEL
  do
    print_log "[get_spsql_needed]" "" "Get Needed SQL Report for BI=[${BEGIN_ID}] EI=[${END_ID}] II=[${INST_ID}] SN=[${STAT_NAME}] TT=[${TIME_TYPE}] SL=[${STAT_LEVEL}]"
    if [ ${__DB_VERSION_MAJOR} -eq 9 ]; then
      SQL="SELECT SQL_INFO||' '||rownum
  FROM (SELECT /*+ RULE */ E.HASH_VALUE||' ${INST_ID} ${BEGIN_ID} ${END_ID} ${STAT_NAME} ${TIME_TYPE} ${STAT_LEVEL} ${SQL_TYPE}' SQL_INFO
          FROM STATS\$SQL_SUMMARY B, STATS\$SQL_SUMMARY E
         WHERE B.SNAP_ID=${BEGIN_ID}
           AND E.SNAP_ID=${END_ID}
           AND B.HASH_VALUE=E.HASH_VALUE
           AND B.DBID=${__DBID}
           AND E.DBID=${__DBID}
           AND B.INSTANCE_NUMBER=${INST_ID}
           AND E.INSTANCE_NUMBER=${INST_ID}
         ORDER BY (E.${SQL_TYPE} - B.${SQL_TYPE}))
 WHERE ROWNUM<=${__SQL_LIMIT};"
    elif [ ${__DB_VERSION_MAJOR} -ge 10 ]; then
      SQL="SELECT SQL_INFO||' '||rownum
  FROM (SELECT /*+ RULE */ E.OLD_HASH_VALUE||' ${INST_ID} ${BEGIN_ID} ${END_ID} ${STAT_NAME} ${TIME_TYPE} ${STAT_LEVEL} ${SQL_TYPE}' SQL_INFO
          FROM STATS\$SQL_SUMMARY B, STATS\$SQL_SUMMARY E
         WHERE B.SNAP_ID=${BEGIN_ID}
           AND E.SNAP_ID=${END_ID}
           AND B.OLD_HASH_VALUE=E.OLD_HASH_VALUE
           AND B.DBID=${__DBID}
           AND E.DBID=${__DBID}
           AND B.INSTANCE_NUMBER=${INST_ID}
           AND E.INSTANCE_NUMBER=${INST_ID}
         ORDER BY (E.${SQL_TYPE} - B.${SQL_TYPE}))
 WHERE ROWNUM<=${__SQL_LIMIT};"
    fi
    SQL="SET LINESIZE 1000 PAGESIZE 0 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON HEADING OFF AUTOT OFF
 SPOOL ${RESULT_TMP}
 ${SQL}
 SPOOL OFF
 EXIT"
    print_log "[get_spsql_needed]" "4" "SQL Needed info in the Statspack" "${SQL}"
    ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1>/dev/null 2>> ${__ERRORFILE} <<EOF
    ${SQL}
EOF
    if [ -f "${RESULT_TMP}" ] && [ "`cat ${RESULT_TMP}  | grep '^ORA-'`" != "" ]; then
      print_log "[get_spsql_needed]" "2" "[Error] Cannot Get SQL Needed info for STATPACK from Database, Program abort ..."
      print_log "[get_spsql_needed]" "2" "[Cause] `cat ${RESULT_TMP} | grep '^ORA-' | sort -u`"
      echo "FALSE" > ${__OSLOAD_SWITCHER}
      exit 1
    elif [ ! -f "${RESULT_TMP}" ]; then
      print_log "[get_spsql_needed]" "2" "[Error] no SQL Needed info Result for STATPACK from Database, Program abort ..."
      echo "FALSE" > ${__OSLOAD_SWITCHER}
      exit 1
    fi
  done < ${RESULT_SQL_TMP}

  # Write Temp File into remove script
  grep -v "^$" ${RESULT_TMP} >> ${__SQL_NEEDED} 2>/dev/null
  print_log "[get_spsql_needed]" "5" "${RESULT_TMP}"
}

#########################################################################################################
##                                                                                                     ##
## Function sqlrpt_optimizer(): Optimizer SQL Need File, Merge same SQL                                ##
##                                                                                                     ##
#########################################################################################################
sqlrpt_optimizer(){

  print_log "[sqlrpt_optimizer]" "" "SQL Report Optimization, Merge Same SQL in [${__SQL_NEEDED}]"
  sort -u ${__SQL_NEEDED} > ${__SQL_NEEDED}.tmp

  PREV_SQLID_HASH=""
  PREV_BID=""
  PREV_EID=""
  PREV_INSTID=""
  SQL_COUNT=0
  echo "" > ${__SQL_NEEDED}
  while read SQLID_HASH INST_ID BEGIN_ID END_ID STAT_NAME TIME_TYPE STAT_LEVEL SQL_TYPE SQL_LEVEL
  do
    if [ "${PREV_SQLID_HASH}" = "${SQLID_HASH}" ] && [ "${PREV_INSTID}" = "${INST_ID}" ]; then
      if [ $PREV_EID -lt ${END_ID} ]; then
        PREV_EID=${END_ID}
      fi
      if [ $PREV_BID -gt ${BEGIN_ID} ]; then
        PREV_BID=${BEGIN_ID}
      fi
    else
      if [ "${PREV_SQLID_HASH}" != "" ]; then
        let "SQL_COUNT+=1"
        echo "${PREV_SQLID_HASH} ${PREV_INSTID} ${PREV_BID} ${PREV_EID} sqlrpt_${PREV_INSTID}_${PREV_SQLID_HASH}_${PREV_BID}_${PREV_EID}.html" >> ${__SQL_NEEDED}
      fi
      PREV_SQLID_HASH=${SQLID_HASH}
      PREV_INSTID=${INST_ID}
      PREV_BID=${BEGIN_ID}
      PREV_EID=${END_ID}
    fi
  done < ${__SQL_NEEDED}.tmp

  if [ "${PREV_SQLID_HASH}" != "" ]; then
    echo "${PREV_SQLID_HASH} ${PREV_INSTID} ${PREV_BID} ${PREV_EID} sqlrpt_${PREV_INSTID}_${PREV_SQLID_HASH}_${PREV_BID}_${PREV_EID}.html" >> ${__SQL_NEEDED}
    grep -v "^$" ${__SQL_NEEDED} >${__SQL_NEEDED}.tmp
    mv ${__SQL_NEEDED}.tmp ${__SQL_NEEDED}
  fi

  print_log "[sqlrpt_optimizer]" "" "Find [${SQL_COUNT}] different SQLs in SQL Report Optimizer"
  print_log "[sqlrpt_optimizer]" "" "SQL Report Optimization Successfully Completed"
}

#########################################################################################################
##                                                                                                     ##
## Function get_sqlrpt(): Get SQL Report in HTML Format                                                ##
##   Result write into ${__SQLRPT_DIR} directory                                                       ##
##                                                                                                     ##
#########################################################################################################
get_sqlrpt(){

  print_log "[get_sqlrpt]" "" "Get SQL Report within AWR Listed in [${__SQL_NEEDED}] file "
  sqlrpt_optimizer
  make_sql_script

  # Loop to Collect All SQL Info using Enmotech SQL Script
  ALLSQL=`cat ${__SQL_NEEDED} | grep -v '^$' | wc -l`
  CURSQL=0
  if [ $ALLSQL -gt 0 ]; then
    while read SQL_ID INST_ID BEGIN_ID END_ID FILE_NAME
    do
      let "CURSQL=${CURSQL}+1"
      print_log "[get_sqlrpt]" "" "Get SQL Report [ ${CURSQL} of ${ALLSQL} ]: BI=[${BEGIN_ID}] EI=[${END_ID}] II=[${INST_ID}] SI=[${SQL_ID}]"
      SQL="SET LINESIZE 1000 PAGESIZE 1000 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON AUTOT OFF
 DEFINE REPORT_TYPE='HTML'
 DEFINE DBID=${__DBID}
 DEFINE INST_NUM=${INST_ID}
 DEFINE NUM_DAYS=1
 DEFINE BEGIN_SNAP=${BEGIN_ID}
 DEFINE END_SNAP=${END_ID}
 DEFINE SQL_ID=${SQL_ID}
 DEFINE REPORT_NAME='${FILE_NAME}'
 @${__SQL_SCRIPT}
 EXIT"
      print_log "[get_sqlrpt]" "4" "SQL Report with HTML Format Created" "${SQL}"
      ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1> /dev/null 2>>${__ERRORFILE} <<EOF
      ${SQL}
EOF
      if [ -f "${FILE_NAME}" ] && [ "`cat ${FILE_NAME} | grep '^ORA-'`" != "" ]; then
        print_log "[get_sqlrpt]" "2" "[Warnning] Something 'ORA-' in SQL Report [${FILE_NAME}]"
        print_log "[get_sqlrpt]" "2" "[Cause] `cat ${FILE_NAME} | grep '^ORA-' | sort -u`"
      elif [ ! -f "${FILE_NAME}" ]; then
        print_log "[get_sqlrpt]" "2" "[Warnning] Cannot Get SQL Report, I think meybe a instance restart occured"
      fi
    done < ${__SQL_NEEDED}

    # move SQL Report to the SQL Report directory
    mv sqlrpt_* ${__SQLRPT_DIR}/ 2>/dev/null
    if [ $? -eq 0 ]; then
      print_log "[get_sqlrpt]" "" "Successfully Move SQL Report into [${__SQLRPT_DIR}] directory"
    else
      print_log "[get_sqlrpt]" "2" "[Error] move SQL Report Error, maybe no AWR SQL Report Collected"
    fi
  fi
}

#########################################################################################################
##                                                                                                     ##
## Function get_spsqlrpt(): Get STATSPACK SQL Report in TEXT Format                                    ##
##   Result write into ${__SQLRPT_DIR} directory                                                       ##
##                                                                                                     ##
#########################################################################################################
get_spsqlrpt(){

  print_log "[get_spsqlrpt]" "" "Get SQL Report within STATSPACK Listed in [${__SQL_NEEDED}] file"
  sqlrpt_optimizer

  # Loop to Collect All Needed SQL Report in STATPACK Report
  ALLSQL=`cat ${__SQL_NEEDED} | grep -v '^$' | wc -l`
  CURSQL=0

  if [ $ALLSQL -gt 0 ]; then
    while read HASH_VALUE INST_ID BEGIN_ID END_ID FILE_NAME
    do
      let "CURSQL=${CURSQL}+1"
      print_log "[get_spsqlrpt]" "" "Get SQL Report [ ${CURSQL} of ${ALLSQL} ]: BI=[${BEGIN_ID}] EI=[${END_ID}] II=[${INST_ID}] HV=[${HASH_VALUE}]"
      SQL="SET LINESIZE 1000 PAGESIZE 1000 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON AUTOT OFF
 DEFINE DBID=${__DBID}
 DEFINE INST_NUM=${INST_ID}
 DEFINE NUM_DAYS=0
 DEFINE BEGIN_SNAP=${BEGIN_ID}
 DEFINE END_SNAP=${END_ID}
 DEFINE HASH_VALUE=${HASH_VALUE}
 DEFINE REPORT_NAME=${FILE_NAME}
 @?/rdbms/admin/sprepsql.sql
 EXIT"
      print_log "[get_spsqlrpt]" "4" "Statspack SQL Report Created" "${SQL}"
      ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1>/dev/null 2>>${__ERRORFILE} <<EOF
      ${SQL}
EOF
      if [ -f "${FILE_NAME}" ] && [ "`cat ${FILE_NAME} | grep '^ORA-'`" != "" ]; then
        print_log "[get_spsqlrpt]" "2" "[Warnning] Something 'ORA-' in STATSPACK SQL Report [${FILE_NAME}]"
        print_log "[get_spsqlrpt]" "2" "[Cause] `cat ${FILE_NAME} | grep '^ORA-' | sort -u`"
      elif [ ! -f "${FILE_NAME}" ]; then
        print_log "[get_spsqlrpt]" "2" "[Warnning] Cannot Get SQL Report, I think meybe a instance restart occured"
      fi
    done < ${__SQL_NEEDED}

    # move SQL Report to the SQL Report directory
    mv spsqlrpt_* ${__SQLRPT_DIR}/ 2>/dev/null
    if [ $? -eq 0 ]; then
      print_log "[get_spsqlrpt]" "" "Successfully Move SQL Report into [${__SQLRPT_DIR}] directory"
    else
      print_log "[get_spsqlrpt]" "2" "[Error] move SQL Report Error, maybe no STATPACK SQL Report Collected"
    fi
  fi
}

#########################################################################################################
##                                                                                                     ##
## Function get_top_waits(): Get Top N Waits in Generated Report                                       ##
##   Result write into ${__PROFILE_DIR} Directory                                                      ##
##                                                                                                     ##
#########################################################################################################
get_top_waits(){

  print_log "[get_top_waits]" "" "Begin Collect Wait Event Statistics with Text and HTML File"
  # Make Trend HTMP Header and define Top Waits File
  make_html_header
  print_log "[get_top_waits]" "" "Get Top [${__WAIT_LIMIT}] Waits in Generated Report into [${__PROFILE_DIR}] Directory"
  TOP_WAIT_NAME=${__PROFILE_DIR}/awr_top_waits.txt
  cp ${__GRAPHIC_HEADER} ${__WAITS_GRAPHIC_HTML}
  echo '<script type="text/javascript"> $(function () {var colors = Highcharts.getOptions().colors, name = "每日Top等待事件汇总",' >> ${__WAITS_GRAPHIC_HTML}

  # Create SQLs and write them to SQL File
  SQL="SET LINESIZE 1000 PAGESIZE 0 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON AUTOT OFF
 SPOOL ${TOP_WAIT_NAME}
 SELECT W.SNAP_ID ||'|'|| W.INSTANCE_NUMBER ||'|'|| W.LV ||'|'|| W.EVENT_NAME ||'|'|| W.TOTAL_WAITS ||'|'|| ROUND(W.TIME_WAITED_MICRO/1000000) ||'|'|| ROUND(W.TIME_WAITED_MICRO/W.TOTAL_WAITS/1000) ||'|'|| ROUND(W.TIME_WAITED_MICRO/T.DB_TIME*100,1) ||'|'|| W.WAIT_CLASS
   FROM ( SELECT /*+ RULE */ ROW_NUMBER() OVER(PARTITION BY INSTANCE_NUMBER,SNAP_ID ORDER BY TIME_WAITED_MICRO DESC) LV , SNAP_ID , INSTANCE_NUMBER , EVENT_NAME , TOTAL_WAITS , TIME_WAITED_MICRO , WAIT_CLASS
            FROM ( SELECT SNAP_ID , INSTANCE_NUMBER , EVENT_NAME
                        , CASE WHEN TOTAL_WAITS > LAG(TOTAL_WAITS) OVER(PARTITION BY INSTANCE_NUMBER, EVENT_NAME ORDER BY SNAP_ID)
                               THEN TOTAL_WAITS - LAG(TOTAL_WAITS) OVER(PARTITION BY INSTANCE_NUMBER, EVENT_NAME ORDER BY SNAP_ID) ELSE 1 END TOTAL_WAITS
                        , CASE WHEN TIME_WAITED_MICRO > LAG(TIME_WAITED_MICRO) OVER(PARTITION BY INSTANCE_NUMBER, EVENT_NAME ORDER BY SNAP_ID)
                               THEN TIME_WAITED_MICRO - LAG(TIME_WAITED_MICRO) OVER(PARTITION BY INSTANCE_NUMBER, EVENT_NAME ORDER BY SNAP_ID) ELSE 0 END TIME_WAITED_MICRO
                        , WAIT_CLASS
                     FROM DBA_HIST_SYSTEM_EVENT
                    WHERE DBID = ${__DBID} AND WAIT_CLASS <> 'Idle'
                    UNION ALL
                   SELECT SNAP_ID , INSTANCE_NUMBER , 'CPU time', NULL
                        , CASE WHEN VALUE > LAG(VALUE) OVER (PARTITION BY INSTANCE_NUMBER ORDER BY SNAP_ID)
                               THEN VALUE - LAG(VALUE) OVER (PARTITION BY INSTANCE_NUMBER ORDER BY SNAP_ID) ELSE 0 END
                        , NULL
                     FROM DBA_HIST_SYS_TIME_MODEL
                    WHERE DBID = ${__DBID} AND STAT_ID = 2748282437)) W,
                 ( SELECT SNAP_ID,INSTANCE_NUMBER, (VALUE - LAG(VALUE) OVER (PARTITION BY INSTANCE_NUMBER ORDER BY SNAP_ID)) DB_TIME
                     FROM DBA_HIST_SYS_TIME_MODEL
                    WHERE DBID = ${__DBID} AND STAT_ID = 3649082374) T
  WHERE W.INSTANCE_NUMBER = T.INSTANCE_NUMBER AND W.SNAP_ID = T.SNAP_ID AND T.DB_TIME > 0 AND W.LV <= ${__WAIT_LIMIT};
 SPOOL OFF"
  SQL_HTML="SET HEADING OFF PAGES 0 LINES 1111 PAGES 0
 SPOOL ${__WAITS_GRAPHIC_HTML} APPEND
 SELECT /*+ RULE */ CASE WHEN FIRST_VALUE(CONTENT) OVER (PARTITION BY END_TIME) = CONTENT
                     THEN 'DATE_'||REPLACE(END_TIME, ',')||' = ['||CONTENT
                     WHEN LAST_VALUE(CONTENT) OVER (PARTITION BY END_TIME) = CONTENT
                     THEN CONTENT||'],'
                 ELSE CONTENT END TYPE FROM
 (SELECT '{x: Date.UTC('||SUBSTR(END_TIME, 1, 4)||','||(TO_NUMBER(SUBSTR(END_TIME, 5,2))-1)||SUBSTR(END_TIME, 7)||'),'
     || ' y: '|| ROUND(W.TIME_WAITED_MICRO/1000000) ||','
     || ' color: ''#'|| COLOR_TIPS ||''','
     || ' name: ''<br/><b>Inst No. :'|| W.INSTANCE_NUMBER ||'</b> <br/><b>Event : </b>'||W.EVENT_NAME ||'''},' content
     , SUBSTR(END_TIME, 1, 9) END_TIME
   FROM ( SELECT ROW_NUMBER() OVER(PARTITION BY INSTANCE_NUMBER,SNAP_ID ORDER BY TIME_WAITED_MICRO DESC) LV , SNAP_ID , INSTANCE_NUMBER , EVENT_NAME , TIME_WAITED_MICRO , SUBSTR(LTRIM(TO_CHAR(EVENT_ID, 'XXXXXXXXXXXX')), 0, 6) COLOR_TIPS
            FROM ( SELECT  /*+ RULE */ SNAP_ID , INSTANCE_NUMBER , EVENT_NAME , EVENT_ID
                        , CASE WHEN TIME_WAITED_MICRO > LAG(TIME_WAITED_MICRO) OVER(PARTITION BY INSTANCE_NUMBER, EVENT_NAME ORDER BY SNAP_ID)
                               THEN TIME_WAITED_MICRO - LAG(TIME_WAITED_MICRO) OVER(PARTITION BY INSTANCE_NUMBER, EVENT_NAME ORDER BY SNAP_ID) ELSE 0 END TIME_WAITED_MICRO
                     FROM DBA_HIST_SYSTEM_EVENT
                    WHERE DBID = ${__DBID} AND WAIT_CLASS <> 'Idle'
                    UNION ALL
                   SELECT  /*+ RULE */ SNAP_ID , INSTANCE_NUMBER , 'CPU time', 16711680
                        , CASE WHEN VALUE > LAG(VALUE) OVER (PARTITION BY INSTANCE_NUMBER ORDER BY SNAP_ID)
                               THEN VALUE - LAG(VALUE) OVER (PARTITION BY INSTANCE_NUMBER ORDER BY SNAP_ID) ELSE 0 END
                     FROM DBA_HIST_SYS_TIME_MODEL
                    WHERE DBID = ${__DBID} AND STAT_ID = 2748282437)
           WHERE TIME_WAITED_MICRO IS NOT NULL) W,
         ( SELECT  /*+ RULE */ INSTANCE_NUMBER, SNAP_ID, TO_CHAR(END_INTERVAL_TIME, 'YYYYMM,DD,HH24,MI') END_TIME FROM DBA_HIST_SNAPSHOT WHERE DBID = ${__DBID}) T
  WHERE W.INSTANCE_NUMBER = T.INSTANCE_NUMBER AND W.SNAP_ID = T.SNAP_ID AND W.LV <= ${__WAIT_LIMIT}
  ORDER BY END_TIME, TIME_WAITED_MICRO)
  UNION ALL
 SELECT 'data = [ ' FROM DUAL
  UNION ALL
 SELECT CONTENT FROM
 (SELECT '{x: Date.UTC('||end_year||', '||(TO_NUMBER(end_month)-1)||', '||end_day||'),'
     || ' y: '|| TIME_WAITED ||','
     || ' color: ''#'|| decode(end_hour, '00', 'CB6762', '01', '919191', '02', '69A2DB', '03', '1DB641', '04', '363EB9', '05', '82429B', '06', '9AA953'
     , '07', 'CC60C1', '08', 'A5BAD4', '09', '9C72EB', '10', '74BCAC', '11', 'E13B91', '12', 'D9A053', '13', '313C68', '14', '36B499', '15', 'E2D857'
     , '16', 'FF807B', '17', '326653', '18', '298DC9', '19', 'EE83E6', '20', 'EB2E39', '21', '6C55EC', '22', 'D6DEDB', '23', 'DB91A7') ||''','
   || ' name: ''<br/><b>Hour :'|| end_hour ||':00</b>'', drilldown: {data: date_'||end_year||end_month||end_day||'}}, ' content
   FROM (select to_char(end_interval_time, 'yyyy') end_year , to_char(end_interval_time, 'mm') end_month , to_char(end_interval_time, 'dd') end_day , to_char(end_interval_time, 'hh24') end_hour , ROUND(SUM(W.TIME_WAITED_MICRO)/1000000) time_waited
           from (SELECT ROW_NUMBER() OVER(PARTITION BY INSTANCE_NUMBER,SNAP_ID ORDER BY TIME_WAITED_MICRO DESC) LV , SNAP_ID , INSTANCE_NUMBER , TIME_WAITED_MICRO
            FROM ( SELECT /*+ RULE */ SNAP_ID, INSTANCE_NUMBER, TIME_WAITED_MICRO - LAG(TIME_WAITED_MICRO) OVER(PARTITION BY INSTANCE_NUMBER, EVENT_NAME ORDER BY SNAP_ID) TIME_WAITED_MICRO
                     FROM DBA_HIST_SYSTEM_EVENT
                    WHERE DBID = ${__DBID} AND WAIT_CLASS <> 'Idle'
                    UNION ALL
                   SELECT /*+ RULE */ SNAP_ID , INSTANCE_NUMBER , (VALUE - LAG(VALUE) OVER (PARTITION BY INSTANCE_NUMBER ORDER BY SNAP_ID))
                     FROM DBA_HIST_SYS_TIME_MODEL
                    WHERE DBID = ${__DBID} AND STAT_ID = 2748282437)
           WHERE TIME_WAITED_MICRO IS NOT NULL) W,
         ( SELECT /*+ RULE */ INSTANCE_NUMBER, SNAP_ID, END_INTERVAL_TIME FROM DBA_HIST_SNAPSHOT WHERE DBID = ${__DBID}) T
  WHERE W.INSTANCE_NUMBER = T.INSTANCE_NUMBER AND W.SNAP_ID = T.SNAP_ID AND W.LV <= ${__WAIT_LIMIT}
  GROUP BY to_char(end_interval_time, 'yyyy'), to_char(end_interval_time, 'mm'), to_char(end_interval_time, 'dd'), to_char(end_interval_time, 'hh24'))
  ORDER BY end_hour desc)
  UNION ALL
 SELECT ']' FROM DUAL;
 SPOOL OFF
 EXIT"
  print_log "[get_top_waits]" "4" "Get Top Waits with Text Result" "${SQL}"
  print_log "[get_top_waits]" "4" "Get Top Waits with Html Result" "${SQL_HTML}"

  # Get Data from Database using SQL*PLUS
  ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1> /dev/null 2>>${__ERRORFILE} <<EOF
  ${SQL}
  ${SQL_HTML}
EOF
  if [ -f "${TOP_WAIT_NAME}" ] && [ "`cat ${TOP_WAIT_NAME}  | grep '^ORA-'`" != "" ]; then
    print_log "[get_top_waits]" "2" "[Error] Cannot Get Top Waits from Running Database , Program abort ..."
    print_log "[get_top_waits]" "2" "[Cause] `cat ${TOP_WAIT_NAME}  | grep '^ORA-' | sort -u`"
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  elif [ ! -f "${TOP_WAIT_NAME}" ]; then
    print_log "[get_top_waits]" "2" "[Error] no Top Waits Result File from Running Database , Program abort ..."
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  fi

  # Complete Top Wait Trend HTML
  cat >> ${__WAITS_GRAPHIC_HTML} <<ENDOFWAITHTML
 function setChart( name, data, color) {chart.series[0].remove(false); chart.addSeries({ name: name, data: data, color: color || 'white'}, false); chart.redraw(); }
     var chart = \$('#container').highcharts({
         chart: {type: 'column'}, title: {text: 'Top Waits Trendline'}, subtitle: {text: 'Drill Down Allowed：Click to Enter and Back.'}, xAxis: {type: 'datetime'}, yAxis: {title: {text: 'Wait Time : s'}}, plotOptions: {sorted: true, column: {stacking: 'normal', cursor: 'pointer', point: {events: {click: function() {var drilldown = this.drilldown; if (drilldown) {setChart(Highcharts.dateFormat('%Y-%m-%d Detail Top Waits', this.x), drilldown.data, 'black'); } else {setChart(name, data, 'black'); } } } }, dataLabels: {enabled: false, color: 'black', style: {fontWeight: 'bold'}, formatter: function() {return this.y ; } } } }, tooltip: {formatter: function() {var p = this.point, s = '<b>Time : </b>'+ Highcharts.dateFormat('%Y-%m-%d %H:%M', this.x) + this.point.name +'<br/><b>Wait Time :'+ this.y +'</b><br/>'; if (p.drilldown) {s += 'Click for Detail'; } else {s += 'Click  for '; } return s; } }, series: [{name: name, data: data, color: 'black', }], exporting: {enabled: false } }) .highcharts(); }); </script> </head> <body bgcolor=#EEEEEE><br> <font face=courier-bold color=#CD8500 size=6pt>Oracle Top Waits Graphic Trendline</font><p> <table border=1 bgcolor=#9acd32><tr> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td><td width=5px></td> <td width=40px></td></tr></table><p><br> <div id="container" style="min-width: 310px; height: 400px; margin: auto 20px 30px 20px"></div> </body> </html>
ENDOFWAITHTML
}

#########################################################################################################
##                                                                                                     ##
## Function get_awr_profile(): Get AWR Profile Information                                             ##
##   Result write into ${__PROFILE_DIR} Directory                                                      ##
##                                                                                                     ##
#########################################################################################################
get_awr_profile(){

  print_log "[get_awr_profile]" "" "Get AWR Profile Information into [${__PROFILE_DIR}] Directory"
  PROFILE_NAME=${__PROFILE_DIR}/awr_profile.txt

  SQL="SET LINESIZE 1000 PAGESIZE 0 TIME OFF TIMING OFF FEEDBACK OFF TRIMOUT ON TRIMSPOOL ON AUTOT OFF
 SPOOL ${PROFILE_NAME}
 SELECT /*+ RULE */ DS.SNAP_ID
        ||'|'|| DS.DBID
        ||'|'|| DS.DB_NAME
        ||'|'|| DS.INSTANCE_NUMBER
        ||'|'|| DS.INSTANCE_NAME
        ||'|'|| DS.VERSION
        ||'|'|| DS.PARALLEL
        ||'|'|| DS.HOST_NAME
        ||'|'|| TO_CHAR(DS.BEGIN_INTERVAL_TIME,'YYYY-MM-DD HH24:MI:SS')
        ||'|'|| TO_CHAR(DS.END_INTERVAL_TIME,'YYYY-MM-DD HH24:MI:SS')
        ||'|'|| DS.INTERVAL_2_S
        ||'|'|| OS.NUM_CPUS
        ||'|'|| round(OS.MEMORY_MB)
        ||'|'|| CASE WHEN SS.REDO_SIZE > LAG(SS.REDO_SIZE) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.REDO_SIZE - LAG(SS.REDO_SIZE) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.LOGICAL_READ > LAG(SS.LOGICAL_READ) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.LOGICAL_READ - LAG(SS.LOGICAL_READ) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.LOGICAL_READ_BYTES > LAG(SS.LOGICAL_READ_BYTES) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.LOGICAL_READ_BYTES - LAG(SS.LOGICAL_READ_BYTES) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.PHYSICAL_WRITES > LAG(SS.PHYSICAL_WRITES) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.PHYSICAL_WRITES - LAG(SS.PHYSICAL_WRITES) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.PHYSICAL_WRITE_BYTES > LAG(SS.PHYSICAL_WRITE_BYTES) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.PHYSICAL_WRITE_BYTES - LAG(SS.PHYSICAL_WRITE_BYTES) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.PHYSICAL_READS > LAG(SS.PHYSICAL_READS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.PHYSICAL_READS - LAG(SS.PHYSICAL_READS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.PHYSICAL_READ_BYTES > LAG(SS.PHYSICAL_READ_BYTES) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.PHYSICAL_READ_BYTES - LAG(SS.PHYSICAL_READ_BYTES) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.PARSE_TOTAL > LAG(SS.PARSE_TOTAL) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.PARSE_TOTAL - LAG(SS.PARSE_TOTAL) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.PARSE_HARD > LAG(SS.PARSE_HARD) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.PARSE_HARD - LAG(SS.PARSE_HARD) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.DB_BLOCK_GETS > LAG(SS.DB_BLOCK_GETS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.DB_BLOCK_GETS - LAG(SS.DB_BLOCK_GETS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.CONSISTENT_GETS > LAG(SS.CONSISTENT_GETS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.CONSISTENT_GETS - LAG(SS.CONSISTENT_GETS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.DB_BLOCK_CHANGES > LAG(SS.DB_BLOCK_CHANGES) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.DB_BLOCK_CHANGES - LAG(SS.DB_BLOCK_CHANGES) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.EXECUTES > LAG(SS.EXECUTES) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.EXECUTES - LAG(SS.EXECUTES) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.USER_CALLS > LAG(SS.USER_CALLS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.USER_CALLS - LAG(SS.USER_CALLS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.USER_COMMITS > LAG(SS.USER_COMMITS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.USER_COMMITS - LAG(SS.USER_COMMITS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.USER_ROLLBACKS > LAG(SS.USER_ROLLBACKS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.USER_ROLLBACKS - LAG(SS.USER_ROLLBACKS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.SORT_DISK > LAG(SS.SORT_DISK) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.SORT_DISK - LAG(SS.SORT_DISK) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.SORT_MEMORY > LAG(SS.SORT_MEMORY) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.SORT_MEMORY - LAG(SS.SORT_MEMORY) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| CASE WHEN SS.TRANSACTIONS > LAG(SS.TRANSACTIONS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                     THEN SS.TRANSACTIONS - LAG(SS.TRANSACTIONS) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID) ELSE 0 END
        ||'|'|| TRIM(TO_CHAR(CASE WHEN TS.HARD_PARSE_TIME > LAG(TS.HARD_PARSE_TIME) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                                  THEN (TS.HARD_PARSE_TIME - LAG(TS.HARD_PARSE_TIME) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID))/DS.INTERVAL_2_S ELSE 0 END , '9999990.99'))
        ||'|'|| TRIM(TO_CHAR(CASE WHEN TS.DB_TIME > LAG(TS.DB_TIME) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                                  THEN (TS.DB_TIME - LAG(TS.DB_TIME) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID))/DS.INTERVAL_2_S ELSE 0 END , '9999990.99'))
        ||'|'|| TRIM(TO_CHAR(CASE WHEN TS.PARSE_TIME > LAG(TS.PARSE_TIME) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                                  THEN (TS.PARSE_TIME - LAG(TS.PARSE_TIME) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID))/DS.INTERVAL_2_S ELSE 0 END , '9999990.99'))
        ||'|'|| TRIM(TO_CHAR(CASE WHEN TS.PLSQL_EXECUTION_TIME > LAG(TS.PLSQL_EXECUTION_TIME) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                                  THEN (TS.PLSQL_EXECUTION_TIME - LAG(TS.PLSQL_EXECUTION_TIME) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID))/DS.INTERVAL_2_S ELSE 0 END , '9999990.99'))
        ||'|'|| TRIM(TO_CHAR(CASE WHEN TS.SQL_EXECUTE_TIME > LAG(TS.SQL_EXECUTE_TIME) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID)
                                  THEN (TS.SQL_EXECUTE_TIME - LAG(TS.SQL_EXECUTE_TIME) OVER (ORDER BY DS.INSTANCE_NAME, DS.SNAP_ID))/DS.INTERVAL_2_S ELSE 0 END , '9999990.99'))
   FROM ( SELECT SNAP_ID, DBID, INSTANCE_NUMBER
               , MAX(DECODE(STAT_NAME,'redo size',VALUE,0)) REDO_SIZE
               , MAX(DECODE(STAT_NAME,'db block gets',VALUE,0)) LOGICAL_READ
               , MAX(DECODE(STAT_NAME,'db block gets',VALUE,0))*BLK_SIZE LOGICAL_READ_BYTES
               , MAX(DECODE(STAT_NAME,'physical writes',VALUE,0)) PHYSICAL_WRITES
               , MAX(DECODE(STAT_NAME,'physical write bytes',VALUE,0)) PHYSICAL_WRITE_BYTES
               , MAX(DECODE(STAT_NAME,'physical reads',VALUE,0)) PHYSICAL_READS
               , MAX(DECODE(STAT_NAME,'physical read bytes',VALUE,0)) PHYSICAL_READ_BYTES
               , MAX(DECODE(STAT_NAME,'parse count (total)',VALUE,0)) PARSE_TOTAL
               , MAX(DECODE(STAT_NAME,'parse count (hard)',VALUE,0)) PARSE_HARD
               , MAX(DECODE(STAT_NAME,'db block gets',VALUE,0)) DB_BLOCK_GETS
               , MAX(DECODE(STAT_NAME,'consistent gets',VALUE,0)) CONSISTENT_GETS
               , MAX(DECODE(STAT_NAME,'db block changes',VALUE,0)) DB_BLOCK_CHANGES
               , MAX(DECODE(STAT_NAME,'execute count',VALUE,0)) EXECUTES
               , MAX(DECODE(STAT_NAME,'user calls',VALUE,0)) USER_CALLS
               , MAX(DECODE(STAT_NAME,'user commits',VALUE,0)) USER_COMMITS
               , MAX(DECODE(STAT_NAME,'user rollbacks',VALUE,0)) USER_ROLLBACKS
               , MAX(DECODE(STAT_NAME,'sorts (disk)',VALUE,0)) SORT_DISK
               , MAX(DECODE(STAT_NAME,'sorts (memory)',VALUE,0)) SORT_MEMORY
               , (MAX(DECODE(STAT_NAME,'user commits',VALUE,0))+MAX(DECODE(STAT_NAME,'user rollbacks',VALUE,0))) TRANSACTIONS
          FROM ( SELECT S.SNAP_ID, S.DBID, S.INSTANCE_NUMBER, S.STAT_NAME, S.VALUE, BS.VALUE BLK_SIZE
                   FROM DBA_HIST_SYSSTAT S, (SELECT VALUE FROM V\$PARAMETER WHERE NAME='db_block_size') BS
                  WHERE S.STAT_NAME in ( 'db block gets','user commits','user rollbacks','redo size','physical writes','physical write bytes','physical reads','physical read bytes','parse count (total)','parse count (hard)','db block gets','consistent gets','db block changes','user calls','sorts (disk)','sorts (memory)'))
         GROUP BY SNAP_ID, DBID, INSTANCE_NUMBER, BLK_SIZE ) SS,
        ( SELECT SNAP_ID, DBID, INSTANCE_NUMBER
               , ROUND(MAX(DECODE(STAT_NAME,'hard parse elapsed time',VALUE,0))/1000000, 2) HARD_PARSE_TIME
               , ROUND(MAX(DECODE(STAT_NAME,'DB time',VALUE,0))/1000000, 2) DB_TIME
               , ROUND(MAX(DECODE(STAT_NAME,'parse time elapsed',VALUE,0))/1000000, 2) PARSE_TIME
               , ROUND(MAX(DECODE(STAT_NAME,'PL/SQL execution elapsed time',VALUE,0))/1000000, 2) PLSQL_EXECUTION_TIME
               , ROUND(MAX(DECODE(STAT_NAME,'sql execute elapsed time',VALUE,0))/1000000, 2) SQL_EXECUTE_TIME
            FROM ( SELECT S.SNAP_ID, S.DBID, S.INSTANCE_NUMBER, S.STAT_NAME, S.VALUE
                     FROM DBA_HIST_SYS_TIME_MODEL S
                    WHERE S.STAT_NAME in ( 'hard parse elapsed time','DB time','parse time elapsed','PL/SQL execution elapsed time','sql execute elapsed time'))
           GROUP BY SNAP_ID, DBID, INSTANCE_NUMBER ) TS,
        ( SELECT SNAP_ID, S.DBID, INSTANCE_NUMBER, MAX(DECODE(STAT_NAME,'NUM_CPUS', VALUE,0)) NUM_CPUS, MAX(DECODE(STAT_NAME,'PHYSICAL_MEMORY_BYTES', VALUE/1048576 ,0)) MEMORY_MB
            FROM DBA_HIST_OSSTAT S
           WHERE S.STAT_NAME IN ('NUM_CPUS', 'PHYSICAL_MEMORY_BYTES')
           GROUP BY SNAP_ID, S.DBID, INSTANCE_NUMBER) OS,
        ( SELECT D.DBID, D.INSTANCE_NUMBER, D.PARALLEL, D.VERSION, D.DB_NAME, D.INSTANCE_NAME, D.HOST_NAME, S.SNAP_ID, S.BEGIN_INTERVAL_TIME, S.END_INTERVAL_TIME,
                 ( to_number(substr(to_char(END_INTERVAL_TIME-BEGIN_INTERVAL_TIME),2,9))*86400
                 + to_number(substr(to_char(END_INTERVAL_TIME-BEGIN_INTERVAL_TIME),12,2))*3600
                 + to_number(substr(to_char(END_INTERVAL_TIME-BEGIN_INTERVAL_TIME),15,2))*60
                 + to_number(substr(to_char(END_INTERVAL_TIME-BEGIN_INTERVAL_TIME),18,2))) INTERVAL_2_S
            FROM DBA_HIST_DATABASE_INSTANCE D, DBA_HIST_SNAPSHOT S
           WHERE D.DBID = S.DBID
             AND D.INSTANCE_NUMBER = S.INSTANCE_NUMBER
             AND D.STARTUP_TIME = S.STARTUP_TIME ) DS
  WHERE SS.SNAP_ID = OS.SNAP_ID
    AND SS.SNAP_ID = DS.SNAP_ID
    AND SS.SNAP_ID = TS.SNAP_ID
    AND SS.INSTANCE_NUMBER = OS.INSTANCE_NUMBER
    AND SS.INSTANCE_NUMBER = TS.INSTANCE_NUMBER
    AND SS.INSTANCE_NUMBER = DS.INSTANCE_NUMBER
    AND SS.DBID = OS.DBID
    AND SS.DBID = DS.DBID
    AND SS.DBID = TS.DBID
    AND SS.DBID = ${__DBID}
  ORDER BY DS.SNAP_ID;
 SPOOL OFF
 EXIT"
  print_log "[get_awr_profile]" "4" "AWR Profile Collection" "${SQL}"
  ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1> /dev/null 2>>${__ERRORFILE} <<EOF
  ${SQL}
EOF

  if [ -f "${PROFILE_NAME}" ] && [ "`cat ${PROFILE_NAME}  | grep '^ORA-'`" != "" ]; then
    print_log "[get_awr_profile]" "2" "[Error] Cannot Get AWR Profile from Running Database, Continue other Collections"
    print_log "[get_awr_profile]" "2" "[Cause] `cat ${PROFILE_NAME}  | grep '^ORA-' | sort -u`"
  elif [ ! -f "${PROFILE_NAME}" ]; then
    print_log "[get_awr_profile]" "2" "[Error] no AWR Profile Result File from Running Database, Continue other Collections"
  fi
}

#########################################################################################################
##                                                                                                     ##
## Function make_sql_script(): Create SQL Report by Enmotech                                           ##
##                                                                                                     ##
#########################################################################################################
make_sql_script(){

  if [ "${__SQL_TYPE}" = "B" ]; then
    __SQL_SCRIPT="${__ORACLE_HOME}/rdbms/admin/awrsqrpi.sql"
  else
    SQL_SCRIPT_1=${__OTHER_DIR}/enmo_sqlrpi.file1
    SQL_SCRIPT_2=${__OTHER_DIR}/enmo_sqlrpi.file2
    cat > ${SQL_SCRIPT_1} <<"ENDOFSQLSCRIPT"
 clear break compute
 repfooter off
 ttitle off
 btitle off
 set echo off veri off feedback off heading on space 1 flush on pause off termout on numwidth 10 underline on pagesize 60 linesize 80 newpage 1 recsep off trimspool on trimout on define "&" concat "." serveroutput on

 -- Request the DB Id and Instance Number, if they are not specified
 column instt_num  heading "Inst Num"  format 99999;
 column instt_name heading "Instance"  format a12;
 column dbb_name   heading "DB Name"   format a12;
 column dbbid      heading "DB Id"     format a12 just c;
 column host       heading "Host"      format a12;

 prompt Instances in this Workload Repository schema
 prompt ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 select distinct (case when cd.dbid = wr.dbid and cd.name = wr.db_name and ci.instance_number = wr.instance_number and ci.instance_name = wr.instance_name and ci.host_name = wr.host_name then '* 'else '  ' end)||wr.dbid dbbid , wr.instance_number instt_num , wr.db_name dbb_name , wr.instance_name instt_name , wr.host_name host
   from dba_hist_database_instance wr, v$database cd, v$instance ci;
 prompt Using &&dbid for database Id
 prompt Using &&inst_num for instance number

 --  Set up the binds for dbid and instance_number, and Error reporting
 variable dbid       number;
 variable inst_num   number;
 variable max_snap_time char(10);
 declare
   cursor cidnum is select 'X' from dba_hist_database_instance where instance_number = :inst_num and dbid = :dbid;
   cursor csnapid is select to_char(max(end_interval_time),'dd/mm/yyyy') from dba_hist_snapshot where instance_number = :inst_num and dbid = :dbid;
   vx char(1);
 begin
   :dbid      :=  &dbid;
   :inst_num  :=  &inst_num;
   -- Check Database Id/Instance Number is a valid pair
   open cidnum;
   fetch cidnum into vx;
   if cidnum%notfound then
     raise_application_error(-20200, 'Database/Instance ' || :dbid || '/' || :inst_num || ' does not exist in DBA_HIST_DATABASE_INSTANCE');
   end if;
   close cidnum;
   -- Check Snapshots exist for Database Id/Instance Number
   open csnapid;
   fetch csnapid into :max_snap_time;
   if csnapid%notfound then
     raise_application_error(-20200, 'No snapshots exist for Database/Instance '||:dbid||'/'||:inst_num);
   end if;
   close csnapid;
 end;
 /
 whenever sqlerror exit;

 --  Ask how many days of snapshots to display
 set termout on;
 column instart_fmt noprint;
 column inst_name   format a12      heading 'Instance';
 column db_name     format a12      heading 'DB Name';
 column snap_id     format 99999990 heading 'Snap Id';
 column snapdat     format a18      heading 'Snap Started' just c;
 column lvl         format 99       heading 'Snap|Level';

 prompt Specify the number of days of snapshots to choose from
 prompt ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 prompt Entering the number of days (n) will result in the most recent
 prompt (n) days of snapshots being listed.  Pressing <return> without
 prompt specifying a number lists all completed snapshots.

 set heading off;
 column num_days new_value num_days noprint;
 select 'Listing '|| decode( nvl('&&num_days', 3.14) , 0 , 'no snapshots', 3.14 , 'all Completed Snapshots', 1 , 'the last day''s Completed Snapshots', 'the last &num_days days of Completed Snapshots') , nvl('&&num_days', 3.14)  num_days
   from dual;
 set heading on;

 -- List available snapshots
 break on inst_name on db_name on host on instart_fmt skip 1
 ttitle off;

 select to_char(s.startup_time,'dd Mon "at" HH24:mi:ss') instart_fmt , di.instance_name inst_name , di.db_name db_name , s.snap_id snap_id , to_char(s.end_interval_time,'dd Mon YYYY HH24:mi') snapdat , s.snap_level lvl
   from dba_hist_snapshot s , dba_hist_database_instance di
  where s.dbid = :dbid and di.dbid = :dbid and s.instance_number = :inst_num and di.instance_number = :inst_num and di.dbid = s.dbid and di.instance_number = s.instance_number and di.startup_time = s.startup_time and s.end_interval_time >= decode( &num_days , 0 , to_date('31-JAN-9999','DD-MON-YYYY') , 3.14, s.end_interval_time , to_date(:max_snap_time,'dd/mm/yyyy') - (&num_days-1))
  order by db_name, instance_name, snap_id;

 clear break;
 ttitle off;

 --  Ask for the snapshots Id's which are to be compared
 prompt Specify the Begin and End Snapshot Ids
 prompt ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 prompt Begin Snapshot Id specified: &&begin_snap
 prompt
 prompt End   Snapshot Id specified: &&end_snap

 --  Set up the snapshot-related binds, and Error reporting
 variable bid        number;
 variable eid        number;
 declare
   cursor cspid(vspid dba_hist_snapshot.snap_id%type) is select end_interval_time , startup_time from dba_hist_snapshot where snap_id = vspid and instance_number = :inst_num and dbid = :dbid;
   bsnapt  dba_hist_snapshot.end_interval_time%type;
   bstart  dba_hist_snapshot.startup_time%type;
   esnapt  dba_hist_snapshot.end_interval_time%type;
   estart  dba_hist_snapshot.startup_time%type;
 begin
   :bid :=  &begin_snap;
   :eid :=  &end_snap;
   -- Check Begin Snapshot id is valid, get corresponding instance startup time
   open cspid(:bid);
   fetch cspid into bsnapt, bstart;
   if cspid%notfound then
     raise_application_error(-20200, 'Begin Snapshot Id '||:bid||' does not exist for this database/instance');
   end if;
   close cspid;
   -- Check End Snapshot id is valid and get corresponding instance startup time
   open cspid(:eid);
   fetch cspid into esnapt, estart;
   if cspid%notfound then
     raise_application_error(-20200, 'End Snapshot Id '||:eid||' does not exist for this database/instance');
   end if;
   if esnapt <= bsnapt then
     raise_application_error(-20200, 'End Snapshot Id '||:eid||' must be greater than Begin Snapshot Id '||:bid);
   end if;
   close cspid;
   -- Check startup time is same for begin and end snapshot ids
   if ( bstart != estart) then
     raise_application_error(-20200, 'The instance was shutdown between snapshots '||:bid||' and '||:eid);
   end if;
 end;
 /
 whenever sqlerror exit;

 -- Get the SQL ID from the user
 prompt Specify the SQL Id
 prompt ~~~~~~~~~~~~~~~~~~
 prompt SQL ID specified:  &&sql_id

 -- Assign value to bind variable
 variable sqlid  VARCHAR2(13);
 exec :sqlid := '&sql_id';

 whenever sqlerror exit;
 declare
   cursor csqlid(vsqlid dba_hist_sqlstat.sql_id%type) is select sql_id from dba_hist_sqlstat where snap_id > :bid and snap_id <= :eid and instance_number = :inst_num and dbid = :dbid and sql_id = vsqlid;
   inpsqlid dba_hist_sqlstat.sql_id%type;
 begin
 -- Check if the sqlid is valid. It mustcontain an entry in the
 -- DBA_HIST_SQLSTAT table for the specified sqlid
   open csqlid(:sqlid);
   fetch csqlid into inpsqlid;
   if csqlid%notfound then
     raise_application_error(-20025, 'SQL ID '||:sqlid||' does not exist for this database/instance');
   end if;
 end;
 /
 whenever sqlerror continue;

 -- Get the name of the report.
 clear break compute;
 repfooter off;
 ttitle off;
 btitle off;
 set heading on timing off veri off space 1 flush on pause off termout on numwidth 10 echo off feedback off pagesize 60 linesize 80 newpage 1 recsep off trimspool on trimout on define "&" concat "." serveroutput on underline on

 set termout off;
 column dflt_name new_value dflt_name noprint;
 select 'enmotech_sqlrpt_'||:inst_num||'_'||:bid||'_'||:eid||'_'||:sqlid||'.html' dflt_name from dual;
 set termout on;

 prompt Specify the Report Name
 prompt ~~~~~~~~~~~~~~~~~~~~~~~
 prompt The default report file name is &dflt_name..  To use this name,
 prompt press <return> to continue, otherwise enter an alternative.

 set heading off;
 column report_name new_value report_name noprint;
 select 'Using the report name ' || nvl('&&report_name','&dflt_name') , nvl('&&report_name','&dflt_name') report_name from dual;

 undefine dflt_name
 set heading off pagesize 50000 echo off feedback off linesize 8000 termout on;
 spool &report_name;

 select 'WARNING: timed_statistics setting changed between begin/end snaps: TIMINGS ARE INVALID'
   from dual
  where not exists
       (select null
          from dba_hist_parameter b , dba_hist_parameter e
         where b.snap_id = :bid and e.snap_id = :eid and b.dbid = :dbid and e.dbid = :dbid and b.instance_number = :inst_num and e.instance_number = :inst_num and b.parameter_hash = e.parameter_hash and b.parameter_name = 'timed_statistics'and b.value = e.value);
 select output from table(dbms_workload_repository.awr_sql_report_html( :dbid, :inst_num, :bid, :eid, :sqlid));

 --=========================================================================
 --|   Statistics Content
 --=========================================================================
 prompt <a class='awr' name="contents"></a> <hr width="100%"> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>More Statistics</b></font><hr align="left" width="460"> -
 <table width="80%" border="1"> <tr><th colspan="4" class='awrbg'>All Contents</th></tr> -
 <tr> <td nowrap align="center" class='awrc' width="25%"><a class="awr" href="#all_related_tables">All Related Tables</a></td> -
 <td nowrap align="center" class='awrc' width="25%"><a class="awr" href="#table_descriptions">Table Descriptions</a></td> -
 <td nowrap align="center" class='awrc' width="25%"><a class="awr" href="#all_related_indexes">All Related Indexes</a></td> -
 <td nowrap align="center" class='awrc' width="25%"><a class="awr" href="#index_columns_detail">Index Columns Detail</a></td></tr> -
 <tr> <td nowrap align="center" class='awrnc' width="25%"><a class="awr" href="#segment_size">Segment Size</a></td> -
 <td nowrap align="center" class='awrnc' width="25%"><a class="awr" href="#table_constraints">Table Constraints</a></td> -
 <td nowrap align="center" class='awrnc' width="25%"><a class="awr" href="#partition_statistics">Partition Statistics</a></td> -
 <td nowrap align="center" class='awrnc' width="25%"><a class="awr" href="#lob_statistics">Lob Statistics</a></td></tr> -
 <tr> <td nowrap align="center" class='awrc' width="25%"><a class="awr" href="#bind_value">Bind Value</a></td> -
 <td nowrap align="center" class='awrc' width="25%"><a class="awr" href="#"></a></td> -
 <td nowrap align="center" class='awrc' width="25%"><a class="awr" href="#"></a></td> -
 <td nowrap align="center" class='awrc' width="25%"><a class="awr" href="#"></a></td></tr>
ENDOFSQLSCRIPT

    # Get Source of Metadata
    if [ "${__SQL_TYPE}" = "R" ]; then
      META_TABLES="(SELECT * FROM ENMO_TABLES WHERE DBID = ${__DBID} AND LOAD_DATE = (SELECT LATEST_DATE FROM ENMO_LATEST_INFO WHERE DBID = ${__DBID}))"
      META_INDEXES="(SELECT * FROM ENMO_INDEXES WHERE DBID = ${__DBID} AND LOAD_DATE = (SELECT LATEST_DATE FROM ENMO_LATEST_INFO WHERE DBID = ${__DBID}))"
      META_TAB_COLUMNS="(SELECT * FROM ENMO_TAB_COLUMNS WHERE DBID = ${__DBID} AND LOAD_DATE = (SELECT LATEST_DATE FROM ENMO_LATEST_INFO WHERE DBID = ${__DBID}))"
      META_IND_COLUMNS="(SELECT * FROM ENMO_IND_COLUMNS WHERE DBID = ${__DBID} AND LOAD_DATE = (SELECT LATEST_DATE FROM ENMO_LATEST_INFO WHERE DBID = ${__DBID}))"
      META_SEGMENTS="(SELECT * FROM ENMO_SEGMENTS WHERE DBID = ${__DBID} AND LOAD_DATE = (SELECT LATEST_DATE FROM ENMO_LATEST_INFO WHERE DBID = ${__DBID}))"
      META_CONSTRAINTS="(SELECT * FROM ENMO_CONSTRAINTS WHERE DBID = ${__DBID} AND LOAD_DATE = (SELECT LATEST_DATE FROM ENMO_LATEST_INFO WHERE DBID = ${__DBID}))"
      META_PART_KEY_COLUMNS="(SELECT * FROM ENMO_PART_KEY_COLUMNS WHERE DBID = ${__DBID} AND LOAD_DATE = (SELECT LATEST_DATE FROM ENMO_LATEST_INFO WHERE DBID = ${__DBID}))"
      META_SUBPART_KEY_COLUMNS="(SELECT * FROM ENMO_SUBPART_KEY_COLUMNS WHERE DBID = ${__DBID} AND LOAD_DATE = (SELECT LATEST_DATE FROM ENMO_LATEST_INFO WHERE DBID = ${__DBID}))"
      META_PART_TABLES="(SELECT * FROM ENMO_PART_TABLES WHERE DBID = ${__DBID} AND LOAD_DATE = (SELECT LATEST_DATE FROM ENMO_LATEST_INFO WHERE DBID = ${__DBID}))"
      META_PART_INDEXES="(SELECT * FROM ENMO_PART_INDEXES WHERE DBID = ${__DBID} AND LOAD_DATE = (SELECT LATEST_DATE FROM ENMO_LATEST_INFO WHERE DBID = ${__DBID}))"
      META_TAB_PARTITIONS="(SELECT * FROM ENMO_TAB_PARTITIONS WHERE DBID = ${__DBID} AND LOAD_DATE = (SELECT LATEST_DATE FROM ENMO_LATEST_INFO WHERE DBID = ${__DBID}))"
      META_IND_PARTITIONS="(SELECT * FROM ENMO_IND_PARTITIONS WHERE DBID = ${__DBID} AND LOAD_DATE = (SELECT LATEST_DATE FROM ENMO_LATEST_INFO WHERE DBID = ${__DBID}))"
      META_LOBS="(SELECT * FROM ENMO_LOBS WHERE DBID = ${__DBID} AND LOAD_DATE = (SELECT LATEST_DATE FROM ENMO_LATEST_INFO WHERE DBID = ${__DBID}))"
    else
      META_TABLES="DBA_TABLES"
      META_INDEXES="DBA_INDEXES"
      META_TAB_COLUMNS="DBA_TAB_COLUMNS"
      META_IND_COLUMNS="DBA_IND_COLUMNS"
      META_SEGMENTS="DBA_SEGMENTS"
      META_CONSTRAINTS="DBA_CONSTRAINTS"
      META_PART_KEY_COLUMNS="DBA_PART_KEY_COLUMNS"
      META_SUBPART_KEY_COLUMNS="DBA_SUBPART_KEY_COLUMNS"
      META_PART_TABLES="DBA_PART_TABLES"
      META_PART_INDEXES="DBA_PART_INDEXES"
      META_TAB_PARTITIONS="DBA_TAB_PARTITIONS"
      META_IND_PARTITIONS="DBA_IND_PARTITIONS"
      META_LOBS="DBA_LOBS"
    fi

    # Make Metadata Scripts
    cat > ${SQL_SCRIPT_2} <<ENDOFSQLSCRIPT
 --=========================================================================
 --|   All Related Tables
 --=========================================================================
 prompt </table> <p><a class='awr' name="all_related_tables"></a>
 set termout on heading off
 prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>All Related Tables</b></font><hr align="left" width="460"> <font class="awr"> <li>   Lines with Red Color means used in the plan ! </li></font></br>
 prompt <table width='80%' border="1"><tr><th class='awrbg'>Owner</th><th class='awrbg'>Table Name</th><th class='awrbg'>Tablespace</th><th class='awrbg'>Table Type</th><th class='awrbg'>Status</th><th class='awrbg'>Rows</th><th class='awrbg'>Blocks</th><th class='awrbg'>Avg Row Len</th><th class='awrbg'>Chain Count</th><th class='awrbg'>Degree</th><th class='awrbg'>Cache</th><th class='awrbg'>Analyzed</th></tr>
 select '<tr> <td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'T','<font color="red"><b>'||owner||'</b></font>',owner)||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'T','<font color="red"><b>'||table_name||'</b></font>',table_name)||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'T','<font color="red"><b>'||tablespace_name||'</b></font>',tablespace_name)||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'T','<font color="red"><b>'||table_type||'</b></font>',table_type)||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'T','<font color="red"><b>'||status||'</b></font>',status)||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'T','<font color="red"><b>'||num_rows||'</b></font>',num_rows)||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'T','<font color="red"><b>'||blocks||'</b></font>',blocks)||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'T','<font color="red"><b>'||avg_row_len||'</b></font>',avg_row_len)||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'T','<font color="red"><b>'||chain_cnt||'</b></font>',chain_cnt)||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'T','<font color="red"><b>'||degree||'</b></font>',degree)||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'T','<font color="red"><b>'||cache||'</b></font>',cache)||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'T','<font color="red"><b>'||to_char(last_analyzed,'yyyy-mm-dd hh24:mi:ss')||'</b></font>',to_char(last_analyzed,'yyyy-mm-dd hh24:mi:ss'))||'</td></tr>'
   from (select s.tips, t.owner, t.table_name, t.tablespace_name, case when t.cluster_name is not null then 'Cluster Table'when t.iot_name is not null then 'IOT'when t.partitioned='YES' then 'Partition Table'else 'Normal Table'end table_type, t.status, t.num_rows, t.blocks, t.avg_row_len, t.chain_cnt, t.degree, t.cache, t.last_analyzed
       from ${META_TABLES} t,
            (select s.object_owner owner, NVL(i.table_name, s.object_name) object_name, max(decode(object_type,'TABLE','T','I')) tips
             from ${META_INDEXES} i,dba_hist_sql_plan s
            where s.sql_id=:sqlid and s.dbid=:dbid and s.object_owner=i.owner(+) and s.object_name=i.index_name(+)
           group by object_owner, NVL(i.table_name, s.object_name)) s
      where t.owner=s.owner and t.table_name=s.object_name);
 prompt </table> <p> <br /><a class='awr' HREF="#top">Back to Top</a> <br /><a class='awr' HREF="#contents">Back to More Statisticss</a><p />

 --=========================================================================
 --|   Table Descriptions
 --=========================================================================
 prompt <a class='awr' name="table_descriptions"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Table Descriptions</b></font><hr align="left" width="460"> <table width='80%' border="1"> - <tr><th class='awrbg'>Owner</th> <th class='awrbg'>Table Name</th> <th class='awrbg'>Column Name</th> <th class='awrbg'>Data Type</th> <th class='awrbg'>Data Length</th> <th class='awrbg'>is Null</th> <th class='awrbg'>Distinct Num</th> <th class='awrbg'>Buckets Num</th> <th class='awrbg'>Histogram Type</th> <th class='awrbg'>Analyzed</th></tr>

 select '<tr> <td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||owner||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||table_name||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||column_name||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||data_type||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||data_length||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||nullable||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||num_distinct||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||num_buckets||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(histogram,'NONE','NONE','<a class=''awr'' HREF="#'||owner||'_'||table_name||'_'||column_name||'">'||histogram||'</a>')||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||to_char(last_analyzed,'yyyy-mm-dd hh24:mi:ss')||'</td> </tr>'
   from (select t.owner, t.table_name, t.column_name, t.data_type, t.data_length, t.nullable, t.num_distinct, t.num_buckets, t.histogram, t.last_analyzed
       from ${META_TAB_COLUMNS} t,
              (select distinct s.object_owner owner,
                      decode(object_type,'TABLE',s.object_name,i.table_name) object_name
                 from ${META_INDEXES} i,dba_hist_sql_plan s
                where s.sql_id=:sqlid and s.dbid=:dbid and s.object_owner=i.owner(+) and s.object_name=i.index_name(+)) p
          where t.owner=p.owner and t.table_name=p.object_name
          order by t.owner,t.table_name,t.column_id);
 prompt </table> <p> <br /><a class='awr' HREF="#top">Back to Top</a> <br /><a class='awr' HREF="#contents">Back to More Statisticss</a><p />

 --=========================================================================
 --|   All Related Indexes
 --=========================================================================
 prompt <a class='awr' name="all_related_indexes"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>All Related Indexes</b></font><hr align="left" width="460"> <font class="awr"> <li>   Lines with Red Color means used in the plan ! </li></font></br>
 prompt <table width='100%' border="1"><tr><th class='awrbg'>Index Owner</th><th class='awrbg'>Index Name</th><th class='awrbg'>Index Type</th><th class='awrbg'>Tablespace</th><th class='awrbg'>Table Owner</th><th class='awrbg'>Table Name</th><th class='awrbg'>Unique</th><th class='awrbg'>Blevel</th><th class='awrbg'>Leaf Blks</th><th class='awrbg'>Dictinct Keys</th><th class='awrbg'>Cluster Factor</th><th class='awrbg'>Num Rows</th><th class='awrbg'>Analyzed</th><th class='awrbg'>Degree</th><th class='awrbg'>Partitioned</th></tr>
 select '<tr><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||owner||'</b></font>',owner)||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">') ||decode(tips,'I','<font color="red"><b>'||index_name||'</b></font>',index_name)||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||index_type||'</b></font>',index_type)||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||tablespace_name||'</b></font>',tablespace_name)||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||table_owner||'</b></font>',table_owner)||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||table_name||'</b></font>',table_name)||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||uniqueness||'</b></font>',uniqueness)||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||blevel||'</b></font>',blevel)||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||leaf_blocks||'</b></font>',leaf_blocks)||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||distinct_keys||'</b></font>',distinct_keys)||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||clustering_factor||'</b></font>',clustering_factor)||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||num_rows||'</b></font>',num_rows)||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||to_char(last_analyzed,'yyyy-mm-dd hh24:mi:ss')||'</b></font>',to_char(last_analyzed,'yyyy-mm-dd hh24:mi:ss'))||'</td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||degree||'</b></font>',degree)||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||partitioned||'</b></font>',partitioned)||'</td></tr>'
   from (select * from ${META_INDEXES} i,
      ( select object_name, object_owner, min(tips) tips
          from (select 'I' tips, object_name, object_owner from dba_hist_sql_plan where sql_id=:sqlid and dbid=:dbid and object_type='INDEX'
         union all
        select 'T', d.index_name,s.object_owner
          from dba_hist_sql_plan s,${META_INDEXES} d
         where s.sql_id=:sqlid and s.dbid=:dbid and s.object_owner=d.table_owner and s.object_name=d.table_name and s.object_type='TABLE')
         group by object_name, object_owner) p
  where i.owner=p.object_owner and p.object_name =i.index_name
  order by table_owner,table_name);
 prompt </table> <p> <br /><a class='awr' HREF="#top">Back to Top</a> <br /><a class='awr' HREF="#contents">Back to More Statisticss</a><p />

 --=========================================================================
 --|   Index Columns Detail
 --=========================================================================
 prompt <a class='awr' name="index_columns_detail"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Index Columns Detail</b></font><hr align="left" width="460"> <font class="awr"> <li>   Lines with Red Color means used in the plan ! </li></font></br>
 prompt <table width='60%' border="1"> <tr><th class='awrbg'>Index Owner</th> <th class='awrbg'>Index Name</th> <th class='awrbg'>Table Owner</th> <th class='awrbg'>Table Name</th> <th class='awrbg'>Column Name</th> <th class='awrbg'>Position</th> <th class='awrbg'>Descend</th></tr>
 select '<tr><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||index_owner||'</b></font>',index_owner)||'</b></font></td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||index_name||'</b></font>',index_name)||'</b></font></td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||table_owner||'</b></font>',table_owner)||'</b></font></td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||table_name||'</b></font>',table_name)||'</b></font></td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||column_name||'</b></font>',column_name)||'</b></font></td><td align="right" class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||column_position||'</b></font>',column_position)||'</b></font></td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||decode(tips,'I','<font color="red"><b>'||descend||'</b></font>',descend )||'</b></font></td></tr>'
 from ( select p.tips, i.index_owner, i.index_name, i.table_owner, i.table_name, i.column_name, i.column_position, i.descend
          from ${META_IND_COLUMNS} i,
      ( select object_name, object_owner, min(tips) tips
          from (select 'I' tips, object_name, object_owner from dba_hist_sql_plan where sql_id=:sqlid and dbid=:dbid and object_type='INDEX'
         union all
        select 'T', d.index_name,s.object_owner
          from dba_hist_sql_plan s, ${META_INDEXES} d
         where s.sql_id=:sqlid and s.dbid=:dbid and s.object_owner=d.table_owner and s.object_name=d.table_name and s.object_type='TABLE')
         group by object_name, object_owner) p
         where i.index_owner=p.object_owner and p.object_name =i.index_name
         order by index_owner,index_name,column_position);
 prompt </table> <p> <br /><a class='awr' HREF="#top">Back to Top</a> <br /><a class='awr' HREF="#contents">Back to More Statisticss</a><p />

 --=========================================================================
 --|   Segment Size
 --=========================================================================
 prompt <a class='awr' name="segment_size"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Segment Size</b></font><hr align="left" width="460">
 prompt <table width='80%' border="1"> <tr><th class='awrbg'>Owner</th> <th class='awrbg'>Segmet Name</th> <th class='awrbg'>Segment Type</th> <th class='awrbg'>Tablespace Name</th> <th class='awrbg'>Size_MB</th></tr>
 select '<tr><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||owner||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||SEGMENT_NAME||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||SEGMENT_TYPE||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||TABLESPACE_NAME||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||round(bytes/1048576)
 from (select owner, segment_name, segment_type, tablespace_name, bytes
 from ${META_SEGMENTS} s,
 (select object_owner, object_name from dba_hist_sql_plan where sql_id=:sqlid and dbid=:dbid
 union
 select table_owner, table_name from ${META_INDEXES} i where exists (select 1 from dba_hist_sql_plan where sql_id=:sqlid and dbid=:dbid and i.owner=object_owner and i.index_name=object_name)
 union
 select owner, index_name from ${META_INDEXES} i where exists (select 1 from dba_hist_sql_plan where sql_id=:sqlid and dbid=:dbid and i.owner=object_owner and i.table_name=object_name)) p
 where s.owner=p.object_owner
 and s.SEGMENT_NAME=p.object_name
 order by owner, SEGMENT_NAME);
 prompt </table> <p> <br /><a class='awr' HREF="#top">Back to Top</a> <br /><a class='awr' HREF="#contents">Back to More Statisticss</a><p />

 --=========================================================================
 --|   Table Constraints
 --=========================================================================
 prompt <a class='awr' name="table_constraints"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Table Constraints</b></font><hr align="left" width="460">
 prompt <table width='80%' border="1"> <tr><th class='awrbg'>Owner</th> <th class='awrbg'>Table Name</th> <th class='awrbg'>Constraint Name</th> <th class='awrbg'>Constraint Type</th> <th class='awrbg'>Ref. Owner</th> <th class='awrbg'>Ref. Constraint</th> <th class='awrbg'>Status</th> <th class='awrbg'>Deferred</th> <th class='awrbg'>Validated</th> <th class='awrbg'>Last Change</th></tr>

 select '<tr><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||owner||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||table_name||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||constraint_name||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||constraint_type||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||r_owner||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||r_constraint_name||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||status||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||deferred||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||validated||'</td><td class="awr'||decode(mod(rownum,2),0,'nc">','c">')||to_char(last_change,'yyyy-mm-dd hh24:mi:ss')||'</td> </tr>'
   from ( select c.owner, table_name, constraint_name, decode(constraint_type , 'C', 'Check', 'P', 'Primary Key', 'U', 'Unique Key', 'R', 'Foreign Key', 'V', 'With Check on View', 'O', 'Read Only on View', 'H', 'Hash Expression', 'F', 'Ref Column Involved', 'S', 'Supplemental Logging', constraint_type) constraint_type, r_owner, r_constraint_name, status, deferred, validated, last_change
            from ${META_CONSTRAINTS} c,
           (select distinct s.object_owner owner,
                   decode(object_type,'TABLE',s.object_name,i.table_name) object_name
              from ${META_INDEXES} i,dba_hist_sql_plan s
             where s.sql_id=:sqlid and s.dbid=:dbid and s.object_owner=i.owner(+) and s.object_name=i.index_name(+)) p
           where c.owner=p.owner and c.table_name=p.object_name
           order by c.owner,table_name,constraint_type);
 prompt </table> <p> <br /><a class='awr' HREF="#top">Back to Top</a> <br /><a class='awr' HREF="#contents">Back to More Statisticss</a><p />

 --=========================================================================
 --|   Partition Objects : Table and Index
 --=========================================================================
 prompt <a class='awr' name="partition_statistics"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Partition Statistics</b></font><hr align="left" width="460">

 --Partition Summary
 prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Partition Summary</b></font><hr align="left" width="460"><table width='80%' border="1"> <tr><th class='awrbg'>Owner</th><th class='awrbg'>Object Name</th> <th class='awrbg'>Object Type</th> - <th class='awrbg'>Partition Type</th> <th class='awrbg'>Partition Count</th> <th class='awrbg'>Partition Column</th> <th class='awrbg'>SubPartition Type</th> <th class='awrbg'>SubPartition Count</th> <th class='awrbg'>SubPartition Column</th></tr>

 select '<tr><td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||o.owner||'</td><td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||o.tname||'</td><td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||pc.object_type||'</td><td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||o.ptype||'</td><td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||o.pcount||'</td><td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||pc.columns||'</td><td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||o.sptype||'</td><td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||o.spcount||'</td><td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||spc.columns||'</td></tr>'
   from ( select owner,object_type,name,max(decode(column_position,1,column_name,null))||max(decode(column_position,2,', '||column_name,null))||max(decode(column_position,3,', '||column_name,null))||max(decode(column_position,4,', '||column_name,null))||max(decode(column_position,5,', '||column_name,null)) columns
            from ${META_PART_KEY_COLUMNS}
           group by owner,object_type,name) pc,
        ( select owner,name,max(decode(column_position,1,column_name,null))||max(decode(column_position,2,', '||column_name,null))||max(decode(column_position,3,', '||column_name,null))||max(decode(column_position,4,', '||column_name,null))||max(decode(column_position,5,', '||column_name,null)) columns
            from ${META_SUBPART_KEY_COLUMNS}
           group by owner,object_type,name) spc,
        ( select OWNER, TABLE_NAME tname, PARTITIONING_TYPE ptype, SUBPARTITIONING_TYPE sptype, PARTITION_COUNT pcount, DEF_SUBPARTITION_COUNT spcount
            from ${META_PART_TABLES}
           union all
          select OWNER, INDEX_NAME tname, PARTITIONING_TYPE ptype, SUBPARTITIONING_TYPE sptype, PARTITION_COUNT pcount, DEF_SUBPARTITION_COUNT spcount
            from ${META_PART_INDEXES}) o,
      ( select object_owner, object_name
        from dba_hist_sql_plan
       where sql_id=:sqlid and dbid=:dbid and object_name is not null
           union
      select owner, table_name
        from dba_hist_sql_plan s1, ${META_INDEXES} i1
       where sql_id=:sqlid and s1.dbid=:dbid and s1.object_type='INDEX'and s1.object_owner=i1.owner and s1.object_name=i1.index_name
           union
          select owner, index_name
        from dba_hist_sql_plan s2, ${META_INDEXES} i2
       where sql_id=:sqlid and s2.dbid=:dbid and s2.object_type='TABLE'and s2.object_owner=i2.owner and s2.object_name=i2.table_name) p
  where p.object_owner=pc.owner and p.object_owner=spc.owner(+) and p.object_owner=o.owner and p.object_name=pc.name and p.object_name=spc.name(+) and p.object_name=o.tname;
 prompt </table> <p>

 --Partition Table Detial
 prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Partition Table Detail</b></font><hr align="left" width="460"> <table width='100%' border="1"> <tr><th class='awrbg'>Owner</th> <th class='awrbg'>Table Name</th> <th class='awrbg'>Partition No.</th> <th class='awrbg'>Partition Name</th> <th class='awrbg'>Sub Count</th> <th class='awrbg'>Tbs. Name</th> <th class='awrbg'>Rows</th> <th class='awrbg'>Blocks</th> <th class='awrbg'>Avg Space</th> <th class='awrbg'>Chaines</th> <th class='awrbg'>Avg Row Len</th> <th class='awrbg'>Last Analyzed</th></tr>

 select '<tr><td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||table_owner||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||table_name||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||partition_position||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||partition_name||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||subpartition_count||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||tablespace_name||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||num_rows||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||blocks||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||avg_space||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||chain_cnt||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||avg_row_len||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||to_char(last_analyzed,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>'
   from ${META_TAB_PARTITIONS} tp,
           (select distinct s.object_owner owner,
                   decode(object_type,'TABLE',s.object_name,i.table_name) object_name
              from ${META_INDEXES} i, dba_hist_sql_plan s
             where s.sql_id=:sqlid and s.dbid=:dbid and s.object_owner=i.owner(+) and s.object_name=i.index_name(+)) p
  where tp.table_owner=p.owner and tp.table_name=p.object_name
  order by table_owner,table_name,partition_position;
 prompt </table> <p>

 --Partition Index Detial
 prompt <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Partition Index Detail</b></font><hr align="left" width="460"><table width='100%' border="1"> <tr><th class='awrbg'>Owner</th> <th class='awrbg'>Index Name</th> <th class='awrbg'>Partition No.</th> <th class='awrbg'>Partition Name</th> <th class='awrbg'>Status</th> <th class='awrbg'>Sub Count</th> <th class='awrbg'>Tbs. Name</th> <th class='awrbg'>Blevel</th> <th class='awrbg'>Leaf Blocks</th> <th class='awrbg'>Distinct</th> <th class='awrbg'>Cluster Factor</th> <th class='awrbg'>Rows</th> <th class='awrbg'>Last Analyzed</th></tr>

 select '<tr><td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||index_owner||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||index_name||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||partition_position||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||partition_name||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||status||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||subpartition_count||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||tablespace_name||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||blevel||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||leaf_blocks||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||distinct_keys||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||clustering_factor||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||num_rows||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||to_char(last_analyzed,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>'
   from ${META_IND_PARTITIONS} ip,
     (select decode(s.object_type,'INDEX',s.object_name,d.index_name) object_name,s.object_owner
        from dba_hist_sql_plan s, ${META_INDEXES} d
       where s.sql_id=:sqlid and s.dbid=:dbid
         and ((s.object_owner=d.owner and s.object_name=d.index_name and s.object_type='INDEX')
          or (s.object_owner=d.table_owner and s.object_name=d.table_name and s.object_type='TABLE'))
       group by decode(s.object_type,'INDEX',s.object_name,d.index_name),s.object_owner) p
  where ip.index_owner=p.object_owner and ip.index_name=p.object_name
  order by index_owner,index_name,partition_position;
 prompt </table> <p> <br /><a class='awr' HREF="#top">Back to Top</a><br /><a class='awr' HREF="#contents">Back to More Statisticss</a><p />

 --=========================================================================
 --|   Lob Statistics
 --=========================================================================
 prompt <a class='awr' name="lob_statistics"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Lob Statistics</b></font><hr align="left" width="460"><table width='100%' border="1"> <tr><th class='awrbg'>Owner</th> <th class='awrbg'>Table Name</th> <th class='awrbg'>Column Name</th> <th class='awrbg'>Segment Name</th> <th class='awrbg'>Tablespace Name</th> <th class='awrbg'>Index Name</th> <th class='awrbg'>Chunk</th> <th class='awrbg'>Pct Version</th> <th class='awrbg'>Retention</th> <th class='awrbg'>Cache</th> <th class='awrbg'>In Row</th> <th class='awrbg'>Format</th> <th class='awrbg'>Partitioned</th></tr>

 select '<tr><td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||l.owner||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||table_name||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||column_name||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||segment_name||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||tablespace_name||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||index_name||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||chunk||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||pctversion||'</td> <td align="right" class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||retention||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||cache||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||in_row||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||format||'</td> <td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||partitioned||'</td></tr>'
   from ${META_LOBS} l,
      (select distinct s.object_owner owner, decode(object_type,'TABLE',s.object_name,i.table_name) object_name
         from ${META_INDEXES} i,dba_hist_sql_plan s
        where s.sql_id=:sqlid and s.dbid=:dbid and s.object_owner=i.owner(+) and s.object_name=i.index_name(+)) p
  where l.owner=p.owner and l.table_name=p.object_name
  order by l.owner, table_name;
 prompt </table> <p> <br /><a class='awr' HREF="#top">Back to Top</a> <br /><a class='awr' HREF="#contents">Back to More Statisticss</a><p />

 --=========================================================================
 --|   Bind Value
 --=========================================================================
 prompt <a class='awr' name="bind_value"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Bind Value</b></font><hr align="left" width="460"> <font class="awr"> <li>   Lines with Red Color means used in the plan ! </li></font></br>
 prompt <table width='70%' border="1"> <tr><th class='awrbg'>Snap ID</th> <th class='awrbg'>Instance Number</th> <th class='awrbg'>Position</th> <th class='awrbg'>Name</th> <th class='awrbg'>Data Type</th> <th class='awrbg'>Last Captured</th> <th class='awrbg'>Value String</th></tr>
 SELECT '<tr><td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||decode(SNAP_ID, :eid, '<font color=red>','')||SNAP_ID||decode(SNAP_ID, :eid, '</font>','')||'<td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||decode(SNAP_ID, :eid, '<font color=red>','')||INSTANCE_NUMBER||decode(SNAP_ID, :eid, '</font>','')||'<td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||decode(SNAP_ID, :eid, '<font color=red>','')||POSITION||decode(SNAP_ID, :eid, '</font>','')||'<td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||decode(SNAP_ID, :eid, '<font color=red>','')||NAME||decode(SNAP_ID, :eid, '</font>','')||'<td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||decode(SNAP_ID, :eid, '<font color=red>','')||DATATYPE_STRING||decode(SNAP_ID, :eid, '</font>','')||'<td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||decode(SNAP_ID, :eid, '<font color=red>','')||LAST_CAPTURED||decode(SNAP_ID, :eid, '</font>','')||'<td class=''awr'||decode(mod(rownum,2),0,'n','')||'c''>'||decode(SNAP_ID, :eid, '<font color=red>','')||VALUE_STRING||decode(SNAP_ID, :eid, '</font>','')||'</td></tr>'
   FROM DBA_HIST_SQLBIND WHERE DBID = :dbid AND SQL_ID = :sqlid AND WAS_CAPTURED = 'YES'
  ORDER BY SNAP_ID, INSTANCE_NUMBER, POSITION;
 prompt </table> <p> <br /><a class='awr' HREF="#top">Back to Top</a> <br /><a class='awr' HREF="#contents">Back to More Statisticss</a><p />
ENDOFSQLSCRIPT

    if [ "${__SQL_TYPE}" = "H" ]; then
      print_log "[make_sql_script]" "" "Create High SQL Report Script Modified by Enmotech"
      __SQL_SCRIPT=${__OTHER_DIR}/enmo_sqlrpi_h.sql
      mv ${SQL_SCRIPT_1} ${__SQL_SCRIPT}
      echo 'prompt <tr><td nowrap align="center" class="awrc" width="25%"><a class="awr" href="#columns_histogram">Columns Histogram</a></td><td class="awrc"></td><td  class="awrc"></td><td  class="awrc"></td></tr>' >> ${__SQL_SCRIPT}
      cat ${SQL_SCRIPT_2} >> ${__SQL_SCRIPT}
      print_log "[make_sql_script]" "5" "${SQL_SCRIPT_2}"
    cat >> ${__SQL_SCRIPT} <<"ENDOFSQLSCRIPT"
 --=========================================================================
 --|   Columns Histogram
 --=========================================================================
 prompt <a class='awr' name="columns_histogram"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Columns Histogram</b></font><hr align="left" width="460">
 set serveroutput on size unlimited
 declare
   color_tips   varchar2(5);
   cn           number;
   cv           varchar2(32);
   cd           date;
   cnv          nvarchar2(32);
   cr           rowid;
   cc           char(32);
   l_data_type  varchar2(100) :='';
   l_low_value  varchar2(32767);
   l_high_value varchar2(32767);
   l_value_str  varchar2(4000);
   l_real_value varchar2(4000);
 begin
   dbms_output.put_line('<a name="histogram_contents"> <tr><th align="right" class="awrbg">Histogram No.</th><th align="left" class="awrbg">Histogram</th></tr><table width="60%" border="1">');
   for x in (select rownum id, histogram, owner, table_name, column_name from dba_tab_columns where (owner, table_name) in (select distinct OBJECT_OWNER, OBJECT_NAME from dba_hist_sql_plan where object_owner is not null and sql_id = :sqlid and s.dbid=:dbid) and histogram != 'NONE') loop
     select decode(mod(x.id, 2), 0, 'n', '') into color_tips from dual;
     dbms_output.put_line('<tr> <td nowrap align="right" class="awr' || color_tips || 'c" width="30%"> ' || x.id || ' </td> <td nowrap align="left" class="awr' || color_tips || 'c" width="70%"><a class="awr" href="#' || x.owner || '_' || x.table_name || '_' || x.column_name || '"> Histogram : ' || x.histogram || ' on ' || x.owner || '.' || x.table_name || '.' || x.column_name || '</a></td> ');
   end loop;
   dbms_output.put_line('</table> </p>');
   for x in (select histogram, owner, table_name, column_name from dba_tab_columns where (owner, table_name) in (select distinct OBJECT_OWNER, OBJECT_NAME from dba_hist_sql_plan where object_owner is not null and sql_id = :sqlid and s.dbid=:dbid) and histogram != 'NONE') loop
     dbms_output.put_line('<a name="' || x.owner || '_'|| x.table_name || '_' ||x.column_name || '"> <font size="+1" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b> Histogram : '||x.histogram || ' on ' || x.owner || '.' ||x.table_name || '.' || x.column_name ||'</b></font><hr align="left" width="333"><table width="80%" border="1"> <tr> <th class="awrbg">Owner</th> <th class="awrbg">table Name</th> <th class="awrbg">Column Name</th> <th class="awrbg">Histogram</th> <th class="awrbg">Data Type</th><th class="awrbg">Num Nulls</th> <th class="awrbg">Density</th> <th class="awrbg">Num Distinct</th> <th class="awrbg">Bound</th></tr>');
     for y in (select data_type, decode(nullable, 'Y', to_char(num_nulls), 'N') num_nulls, density, num_distinct, low_value, high_value from dba_tab_columns where owner = x.owner and table_name = x.table_name and column_name = x.column_name) loop
     l_data_type := y.data_type;
     if (y.data_type = 'NUMBER') then
         dbms_stats.convert_raw_value(y.low_value, cn);
         l_low_value:=to_char(cn);
         dbms_stats.convert_raw_value(y.high_value, cn);
         l_high_value:=to_char(cn);
       elsif (y.data_type = 'VARCHAR2') then
         dbms_stats.convert_raw_value(y.low_value, cv);
         l_low_value:=cv;
         dbms_stats.convert_raw_value(y.high_value, cv);
         l_high_value:=cv;
       elsif (y.data_type = 'DATE') then
         dbms_stats.convert_raw_value(y.low_value, cd);
         l_low_value:=to_char(cd,'yyyy-mm-dd hh24:mi:ss');
         dbms_stats.convert_raw_value(y.high_value, cd);
         l_high_value:=to_char(cd,'yyyy-mm-dd hh24:mi:ss');
       elsif (y.data_type = 'NVARCHAR2') then
         dbms_stats.convert_raw_value(y.low_value, cnv);
         l_low_value:=to_char(cnv);
         dbms_stats.convert_raw_value(y.high_value, cnv);
         l_high_value:=to_char(cnv);
       elsif (y.data_type = 'ROWID') then
         dbms_stats.convert_raw_value(y.low_value, cr);
         l_low_value:=to_char(cr);
         dbms_stats.convert_raw_value(y.high_value, cr);
         l_high_value:=to_char(cr);
       elsif (y.data_type = 'CHAR') then
         dbms_stats.convert_raw_value(y.low_value, cc);
         l_low_value:=cc;
         dbms_stats.convert_raw_value(y.high_value, cc);
         l_high_value:=cc;
       else
         l_low_value:=y.low_value;
         l_high_value:=y.high_value;
       end if;
       dbms_output.put_line('<tr><td class="awrc">'||x.owner||'</td> <td class="awrc">' || x.table_name ||'</td><td class="awrc">'||x.column_name ||'</td> <td class="awrc">' || x.histogram ||'</td> <td class="awrc">' || y.data_type ||'</td><td class="awrc">' || y.num_nulls  ||'</td> <td align="right" class="awrc">' || y.density ||'</td><td align="right" class="awrc">' ||y.num_distinct ||'</td><td class="awrc">' ||l_low_value||' -- '||l_high_value || '</td></tr>');
     end loop;
     dbms_output.put_line('<table></p> <table width="60%" border="1"> <tr> <th class="awrbg">Owner</th> <th class="awrbg">table Name</th> <th class="awrbg">Column Name</th> <th class="awrbg">Endpoint No.</th> <th class="awrbg">Endpoint Value</th> <th class="awrbg">Actual Value</th></tr>');
     for z in (select rownum id, endpoint_number, endpoint_value, endpoint_actual_value from dba_tab_histograms where owner = x.owner and table_name = x.table_name and column_name = x.column_name order by endpoint_number) loop
       select decode(mod(z.id, 2), 0, 'n', '') into color_tips from dual;
     if l_data_type IN ('CHAR', 'VARCHAR2', 'NCHAR', 'NVARCHAR2') THEN
       l_value_str:= to_char(z.endpoint_value,'fm'||rpad('x',62,'x'));
         l_real_value:='';
         while ( l_value_str is not null ) loop
           l_real_value := l_real_value || chr(to_number(substr(l_value_str,1,2),'xx'));
           l_value_str := substr( l_value_str, 3 );
         end loop;
       ELSE
         l_real_value:=to_char(z.endpoint_value);
       END if;
       dbms_output.put_line('<tr><td class="awr' || color_tips || 'c">'||x.owner||'</td> <td class="awr' || color_tips || 'c">' || x.table_name ||'</td> <td class="awr' || color_tips || 'c">'||x.column_name||'</td> <td align="right" class="awr' || color_tips || 'c">'||z.endpoint_number ||'</td> <td align="right" class="awr' || color_tips || 'c">' ||substr(l_real_value, 1, 100) ||'</td> <td align="right" class="awr' || color_tips || 'c">' ||substr(z.endpoint_actual_value, 1, 100)|| '</td></tr>');
     end loop;
     dbms_output.put_line('<table></p> <br /><a class="awr" HREF="#top">Back to Top</a> <br /><a class="awr" HREF="#contents">Back to More Statisticss</a> <br /><a class="awr" HREF="#histogram_contents">Back to Histogram Contents</a><p />');
   end loop;
 end;
 /
ENDOFSQLSCRIPT
    else
      print_log "[make_sql_script]" "" "Create Middle SQL Report Script Modified by Enmotech"
      __SQL_SCRIPT=${__OTHER_DIR}/enmo_sqlrpi_m.sql
      mv ${SQL_SCRIPT_1} ${__SQL_SCRIPT}
      cat ${SQL_SCRIPT_2} >> ${__SQL_SCRIPT}
      print_log "[make_sql_script]" "5" "${SQL_SCRIPT_2}"
    fi
    cat >> ${__SQL_SCRIPT} <<"ENDOFSQLSCRIPT"
 --=========================================================================
 --|   Game Over !
 --=========================================================================
 spool off;
 prompt Report written to &report_name.

 -- undefine report name (created in awrinpnm.sql)
 undefine :report_name
 undefine :sql_id
 undefine :dbid
 undefine :inst_num
 undefine :NO_OPTIONS
 undefine :top_n_events
 undefine :num_days
 undefine :top_n_sql
 undefine :top_pct_sql
 undefine :sh_mem_threshold
 undefine :top_n_segstat

 whenever sqlerror continue;
 --  End of script file;
ENDOFSQLSCRIPT
  fi
}

#########################################################################################################
##                                                                                                     ##
## Function make_html_header(): Create Graphic Header for HTML                                         ##
##                                                                                                     ##
#########################################################################################################
make_html_header(){

  print_log "[make_html_header]" "" "Begin Create Html Graphic Header into [${__GRAPHIC_HEADER}]"
  if [ ! -f "${__GRAPHIC_HEADER}" ]; then
    cat > ${__GRAPHIC_HEADER} <<EOFOFGRAPHICHTML
 <!DOCTYPE HTML>
 <html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"> <title>Trend for DB : ${__DBID} </title>
EOFOFGRAPHICHTML
    cat >> ${__GRAPHIC_HEADER} <<"EOFOFGRAPHICHTML"
 <!DOCTYPE HTML>
 <html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"> <title>Trend for DB : 2391578385 </title>
 <script type="text/javascript">
 /*! jQuery v1.9.1 | (c) 2005, 2012 jQuery Foundation, Inc. | jquery.org/license @ sourceMappingURL=jquery.min.map */
 (function(e,t){var n,r,i=typeof t,o=e.document,a=e.location,s=e.jQuery,u=e.$,l={},c=[],p="1.9.1",f=c.concat,d=c.push,h=c.slice,g=c.indexOf,m=l.toString,y=l.hasOwnProperty,v=p.trim,b=function(e,t){return new b.fn.init(e,t,r)},x=/[+-]?(?:\d*\.|)\d+(?:[eE][+-]?\d+|)/.source,w=/\S+/g,T=/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g,N=/^(?:(<[\w\W]+>)[^>]*|#([\w-]*))$/,C=/^<(\w+)\s*\/?>(?:<\/\1>|)$/,k=/^[\],:{}\s]*$/,E=/(?:^|:|,)(?:\s*\[)+/g,S=/\\(?:["\\\/bfnrt]|u[\da-fA-F]{4})/g,A=/"[^"\\\r\n]*"|true|false|null|-?(?:\d+\.|)\d+(?:[eE][+-]?\d+|)/g,j=/^-ms-/,D=/-([\da-z])/gi,L=function(e,t){return t.toUpperCase()},H=function(e){(o.addEventListener||"load"===e.type||"complete"===o.readyState)&&(q(),b.ready())},q=function(){o.addEventListener?(o.removeEventListener("DOMContentLoaded",H,!1),e.removeEventListener("load",H,!1)):(o.detachEvent("onreadystatechange",H),e.detachEvent("onload",H))};b.fn=b.prototype={jquery:p,constructor:b,init:function(e,n,r){var i,a;if(!e)return this;if("string"==typeof e){if(i="<"===e.charAt(0)&&">"===e.charAt(e.length-1)&&e.length>=3?[null,e,null]:N.exec(e),!i||!i[1]&&n)return!n||n.jquery?(n||r).find(e):this.constructor(n).find(e);if(i[1]){if(n=n instanceof b?n[0]:n,b.merge(this,b.parseHTML(i[1],n&&n.nodeType?n.ownerDocument||n:o,!0)),C.test(i[1])&&b.isPlainObject(n))for(i in n)b.isFunction(this[i])?this[i](n[i]):this.attr(i,n[i]);return this}if(a=o.getElementById(i[2]),a&&a.parentNode){if(a.id!==i[2])return r.find(e);this.length=1,this[0]=a}return this.context=o,this.selector=e,this}return e.nodeType?(this.context=this[0]=e,this.length=1,this):b.isFunction(e)?r.ready(e):(e.selector!==t&&(this.selector=e.selector,this.context=e.context),b.makeArray(e,this))},selector:"",length:0,size:function(){return this.length},toArray:function(){return h.call(this)},get:function(e){return null==e?this.toArray():0>e?this[this.length+e]:this[e]},pushStack:function(e){var t=b.merge(this.constructor(),e);return t.prevObject=this,t.context=this.context,t},each:function(e,t){return b.each(this,e,t)},ready:function(e){return b.ready.promise().done(e),this},slice:function(){return this.pushStack(h.apply(this,arguments))},first:function(){return this.eq(0)},last:function(){return this.eq(-1)},eq:function(e){var t=this.length,n=+e+(0>e?t:0);return this.pushStack(n>=0&&t>n?[this[n]]:[])},map:function(e){return this.pushStack(b.map(this,function(t,n){return e.call(t,n,t)}))},end:function(){return this.prevObject||this.constructor(null)},push:d,sort:[].sort,splice:[].splice},b.fn.init.prototype=b.fn,b.extend=b.fn.extend=function(){var e,n,r,i,o,a,s=arguments[0]||{},u=1,l=arguments.length,c=!1;for("boolean"==typeof s&&(c=s,s=arguments[1]||{},u=2),"object"==typeof s||b.isFunction(s)||(s={}),l===u&&(s=this,--u);l>u;u++)if(null!=(o=arguments[u]))for(i in o)e=s[i],r=o[i],s!==r&&(c&&r&&(b.isPlainObject(r)||(n=b.isArray(r)))?(n?(n=!1,a=e&&b.isArray(e)?e:[]):a=e&&b.isPlainObject(e)?e:{},s[i]=b.extend(c,a,r)):r!==t&&(s[i]=r));return s},b.extend({noConflict:function(t){return e.$===b&&(e.$=u),t&&e.jQuery===b&&(e.jQuery=s),b},isReady:!1,readyWait:1,holdReady:function(e){e?b.readyWait++:b.ready(!0)},ready:function(e){if(e===!0?!--b.readyWait:!b.isReady){if(!o.body)return setTimeout(b.ready);b.isReady=!0,e!==!0&&--b.readyWait>0||(n.resolveWith(o,[b]),b.fn.trigger&&b(o).trigger("ready").off("ready"))}},isFunction:function(e){return"function"===b.type(e)},isArray:Array.isArray||function(e){return"array"===b.type(e)},isWindow:function(e){return null!=e&&e==e.window},isNumeric:function(e){return!isNaN(parseFloat(e))&&isFinite(e)},type:function(e){return null==e?e+"":"object"==typeof e||"function"==typeof e?l[m.call(e)]||"object":typeof e},isPlainObject:function(e){if(!e||"object"!==b.type(e)||e.nodeType||b.isWindow(e))return!1;try{if(e.constructor&&!y.call(e,"constructor")&&!y.call(e.constructor.prototype,"isPrototypeOf"))return!1}catch(n){return!1}var r;for(r in e);return r===t||y.call(e,r)},isEmptyObject:function(e){var t;for(t in e)return!1;return!0},error:function(e){throw Error(e)},parseHTML:function(e,t,n){if(!e||"string"!=typeof e)return null;"boolean"==typeof t&&(n=t,t=!1),t=t||o;var r=C.exec(e),i=!n&&[];return r?[t.createElement(r[1])]:(r=b.buildFragment([e],t,i),i&&b(i).remove(),b.merge([],r.childNodes))},parseJSON:function(n){return e.JSON&&e.JSON.parse?e.JSON.parse(n):null===n?n:"string"==typeof n&&(n=b.trim(n),n&&k.test(n.replace(S,"@").replace(A,"]").replace(E,"")))?Function("return "+n)():(b.error("Invalid JSON: "+n),t)},parseXML:function(n){var r,i;if(!n||"string"!=typeof n)return null;try{e.DOMParser?(i=new DOMParser,r=i.parseFromString(n,"text/xml")):(r=new ActiveXObject("Microsoft.XMLDOM"),r.async="false",r.loadXML(n))}catch(o){r=t}return r&&r.documentElement&&!r.getElementsByTagName("parsererror").length||b.error("Invalid XML: "+n),r},noop:function(){},globalEval:function(t){t&&b.trim(t)&&(e.execScript||function(t){e.eval.call(e,t)})(t)},camelCase:function(e){return e.replace(j,"ms-").replace(D,L)},nodeName:function(e,t){return e.nodeName&&e.nodeName.toLowerCase()===t.toLowerCase()},each:function(e,t,n){var r,i=0,o=e.length,a=M(e);if(n){if(a){for(;o>i;i++)if(r=t.apply(e[i],n),r===!1)break}else for(i in e)if(r=t.apply(e[i],n),r===!1)break}else if(a){for(;o>i;i++)if(r=t.call(e[i],i,e[i]),r===!1)break}else for(i in e)if(r=t.call(e[i],i,e[i]),r===!1)break;return e},trim:v&&!v.call("\ufeff\u00a0")?function(e){return null==e?"":v.call(e)}:function(e){return null==e?"":(e+"").replace(T,"")},makeArray:function(e,t){var n=t||[];return null!=e&&(M(Object(e))?b.merge(n,"string"==typeof e?[e]:e):d.call(n,e)),n},inArray:function(e,t,n){var r;if(t){if(g)return g.call(t,e,n);for(r=t.length,n=n?0>n?Math.max(0,r+n):n:0;r>n;n++)if(n in t&&t[n]===e)return n}return-1},merge:function(e,n){var r=n.length,i=e.length,o=0;if("number"==typeof r)for(;r>o;o++)e[i++]=n[o];else while(n[o]!==t)e[i++]=n[o++];return e.length=i,e},grep:function(e,t,n){var r,i=[],o=0,a=e.length;for(n=!!n;a>o;o++)r=!!t(e[o],o),n!==r&&i.push(e[o]);return i},map:function(e,t,n){var r,i=0,o=e.length,a=M(e),s=[];if(a)for(;o>i;i++)r=t(e[i],i,n),null!=r&&(s[s.length]=r);else for(i in e)r=t(e[i],i,n),null!=r&&(s[s.length]=r);return f.apply([],s)},guid:1,proxy:function(e,n){var r,i,o;return"string"==typeof n&&(o=e[n],n=e,e=o),b.isFunction(e)?(r=h.call(arguments,2),i=function(){return e.apply(n||this,r.concat(h.call(arguments)))},i.guid=e.guid=e.guid||b.guid++,i):t},access:function(e,n,r,i,o,a,s){var u=0,l=e.length,c=null==r;if("object"===b.type(r)){o=!0;for(u in r)b.access(e,n,u,r[u],!0,a,s)}else if(i!==t&&(o=!0,b.isFunction(i)||(s=!0),c&&(s?(n.call(e,i),n=null):(c=n,n=function(e,t,n){return c.call(b(e),n)})),n))for(;l>u;u++)n(e[u],r,s?i:i.call(e[u],u,n(e[u],r)));return o?e:c?n.call(e):l?n(e[0],r):a},now:function(){return(new Date).getTime()}}),b.ready.promise=function(t){if(!n)if(n=b.Deferred(),"complete"===o.readyState)setTimeout(b.ready);else if(o.addEventListener)o.addEventListener("DOMContentLoaded",H,!1),e.addEventListener("load",H,!1);else{o.attachEvent("onreadystatechange",H),e.attachEvent("onload",H);var r=!1;try{r=null==e.frameElement&&o.documentElement}catch(i){}r&&r.doScroll&&function a(){if(!b.isReady){try{r.doScroll("left")}catch(e){return setTimeout(a,50)}q(),b.ready()}}()}return n.promise(t)},b.each("Boolean Number String Function Array Date RegExp Object Error".split(" "),function(e,t){l["[object "+t+"]"]=t.toLowerCase()});function M(e){var t=e.length,n=b.type(e);return b.isWindow(e)?!1:1===e.nodeType&&t?!0:"array"===n||"function"!==n&&(0===t||"number"==typeof t&&t>0&&t-1 in e)}r=b(o);var _={};function F(e){var t=_[e]={};return b.each(e.match(w)||[],function(e,n){t[n]=!0}),t}b.Callbacks=function(e){e="string"==typeof e?_[e]||F(e):b.extend({},e);var n,r,i,o,a,s,u=[],l=!e.once&&[],c=function(t){for(r=e.memory&&t,i=!0,a=s||0,s=0,o=u.length,n=!0;u&&o>a;a++)if(u[a].apply(t[0],t[1])===!1&&e.stopOnFalse){r=!1;break}n=!1,u&&(l?l.length&&c(l.shift()):r?u=[]:p.disable())},p={add:function(){if(u){var t=u.length;(function i(t){b.each(t,function(t,n){var r=b.type(n);"function"===r?e.unique&&p.has(n)||u.push(n):n&&n.length&&"string"!==r&&i(n)})})(arguments),n?o=u.length:r&&(s=t,c(r))}return this},remove:function(){return u&&b.each(arguments,function(e,t){var r;while((r=b.inArray(t,u,r))>-1)u.splice(r,1),n&&(o>=r&&o--,a>=r&&a--)}),this},has:function(e){return e?b.inArray(e,u)>-1:!(!u||!u.length)},empty:function(){return u=[],this},disable:function(){return u=l=r=t,this},disabled:function(){return!u},lock:function(){return l=t,r||p.disable(),this},locked:function(){return!l},fireWith:function(e,t){return t=t||[],t=[e,t.slice?t.slice():t],!u||i&&!l||(n?l.push(t):c(t)),this},fire:function(){return p.fireWith(this,arguments),this},fired:function(){return!!i}};return p},b.extend({Deferred:function(e){var t=[["resolve","done",b.Callbacks("once memory"),"resolved"],["reject","fail",b.Callbacks("once memory"),"rejected"],["notify","progress",b.Callbacks("memory")]],n="pending",r={state:function(){return n},always:function(){return i.done(arguments).fail(arguments),this},then:function(){var e=arguments;return b.Deferred(function(n){b.each(t,function(t,o){var a=o[0],s=b.isFunction(e[t])&&e[t];i[o[1]](function(){var e=s&&s.apply(this,arguments);e&&b.isFunction(e.promise)?e.promise().done(n.resolve).fail(n.reject).progress(n.notify):n[a+"With"](this===r?n.promise():this,s?[e]:arguments)})}),e=null}).promise()},promise:function(e){return null!=e?b.extend(e,r):r}},i={};return r.pipe=r.then,b.each(t,function(e,o){var a=o[2],s=o[3];r[o[1]]=a.add,s&&a.add(function(){n=s},t[1^e][2].disable,t[2][2].lock),i[o[0]]=function(){return i[o[0]+"With"](this===i?r:this,arguments),this},i[o[0]+"With"]=a.fireWith}),r.promise(i),e&&e.call(i,i),i},when:function(e){var t=0,n=h.call(arguments),r=n.length,i=1!==r||e&&b.isFunction(e.promise)?r:0,o=1===i?e:b.Deferred(),a=function(e,t,n){return function(r){t[e]=this,n[e]=arguments.length>1?h.call(arguments):r,n===s?o.notifyWith(t,n):--i||o.resolveWith(t,n)}},s,u,l;if(r>1)for(s=Array(r),u=Array(r),l=Array(r);r>t;t++)n[t]&&b.isFunction(n[t].promise)?n[t].promise().done(a(t,l,n)).fail(o.reject).progress(a(t,u,s)):--i;return i||o.resolveWith(l,n),o.promise()}}),b.support=function(){var t,n,r,a,s,u,l,c,p,f,d=o.createElement("div");if(d.setAttribute("className","t"),d.innerHTML="  <link/><table></table><a href='/a'>a</a><input type='checkbox'/>",n=d.getElementsByTagName("*"),r=d.getElementsByTagName("a")[0],!n||!r||!n.length)return{};s=o.createElement("select"),l=s.appendChild(o.createElement("option")),a=d.getElementsByTagName("input")[0],r.style.cssText="top:1px;float:left;opacity:.5",t={getSetAttribute:"t"!==d.className,leadingWhitespace:3===d.firstChild.nodeType,tbody:!d.getElementsByTagName("tbody").length,htmlSerialize:!!d.getElementsByTagName("link").length,style:/top/.test(r.getAttribute("style")),hrefNormalized:"/a"===r.getAttribute("href"),opacity:/^0.5/.test(r.style.opacity),cssFloat:!!r.style.cssFloat,checkOn:!!a.value,optSelected:l.selected,enctype:!!o.createElement("form").enctype,html5Clone:"<:nav></:nav>"!==o.createElement("nav").cloneNode(!0).outerHTML,boxModel:"CSS1Compat"===o.compatMode,deleteExpando:!0,noCloneEvent:!0,inlineBlockNeedsLayout:!1,shrinkWrapBlocks:!1,reliableMarginRight:!0,boxSizingReliable:!0,pixelPosition:!1},a.checked=!0,t.noCloneChecked=a.cloneNode(!0).checked,s.disabled=!0,t.optDisabled=!l.disabled;try{delete d.test}catch(h){t.deleteExpando=!1}a=o.createElement("input"),a.setAttribute("value",""),t.input=""===a.getAttribute("value"),a.value="t",a.setAttribute("type","radio"),t.radioValue="t"===a.value,a.setAttribute("checked","t"),a.setAttribute("name","t"),u=o.createDocumentFragment(),u.appendChild(a),t.appendChecked=a.checked,t.checkClone=u.cloneNode(!0).cloneNode(!0).lastChild.checked,d.attachEvent&&(d.attachEvent("onclick",function(){t.noCloneEvent=!1}),d.cloneNode(!0).click());for(f in{submit:!0,change:!0,focusin:!0})d.setAttribute(c="on"+f,"t"),t[f+"Bubbles"]=c in e||d.attributes[c].expando===!1;return d.style.backgroundClip="content-box",d.cloneNode(!0).style.backgroundClip="",t.clearCloneStyle="content-box"===d.style.backgroundClip,b(function(){var n,r,a,s="padding:0;margin:0;border:0;display:block;box-sizing:content-box;-moz-box-sizing:content-box;-webkit-box-sizing:content-box;",u=o.getElementsByTagName("body")[0];u&&(n=o.createElement("div"),n.style.cssText="border:0;width:0;height:0;position:absolute;top:0;left:-9999px;margin-top:1px",u.appendChild(n).appendChild(d),d.innerHTML="<table><tr><td></td><td>t</td></tr></table>",a=d.getElementsByTagName("td"),a[0].style.cssText="padding:0;margin:0;border:0;display:none",p=0===a[0].offsetHeight,a[0].style.display="",a[1].style.display="none",t.reliableHiddenOffsets=p&&0===a[0].offsetHeight,d.innerHTML="",d.style.cssText="box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;padding:1px;border:1px;display:block;width:4px;margin-top:1%;position:absolute;top:1%;",t.boxSizing=4===d.offsetWidth,t.doesNotIncludeMarginInBodyOffset=1!==u.offsetTop,e.getComputedStyle&&(t.pixelPosition="1%"!==(e.getComputedStyle(d,null)||{}).top,t.boxSizingReliable="4px"===(e.getComputedStyle(d,null)||{width:"4px"}).width,r=d.appendChild(o.createElement("div")),r.style.cssText=d.style.cssText=s,r.style.marginRight=r.style.width="0",d.style.width="1px",t.reliableMarginRight=!parseFloat((e.getComputedStyle(r,null)||{}).marginRight)),typeof d.style.zoom!==i&&(d.innerHTML="",d.style.cssText=s+"width:1px;padding:1px;display:inline;zoom:1",t.inlineBlockNeedsLayout=3===d.offsetWidth,d.style.display="block",d.innerHTML="<div></div>",d.firstChild.style.width="5px",t.shrinkWrapBlocks=3!==d.offsetWidth,t.inlineBlockNeedsLayout&&(u.style.zoom=1)),u.removeChild(n),n=d=a=r=null)}),n=s=u=l=r=a=null,t}();var O=/(?:\{[\s\S]*\}|\[[\s\S]*\])$/,B=/([A-Z])/g;function P(e,n,r,i){if(b.acceptData(e)){var o,a,s=b.expando,u="string"==typeof n,l=e.nodeType,p=l?b.cache:e,f=l?e[s]:e[s]&&s;if(f&&p[f]&&(i||p[f].data)||!u||r!==t)return f||(l?e[s]=f=c.pop()||b.guid++:f=s),p[f]||(p[f]={},l||(p[f].toJSON=b.noop)),("object"==typeof n||"function"==typeof n)&&(i?p[f]=b.extend(p[f],n):p[f].data=b.extend(p[f].data,n)),o=p[f],i||(o.data||(o.data={}),o=o.data),r!==t&&(o[b.camelCase(n)]=r),u?(a=o[n],null==a&&(a=o[b.camelCase(n)])):a=o,a}}function R(e,t,n){if(b.acceptData(e)){var r,i,o,a=e.nodeType,s=a?b.cache:e,u=a?e[b.expando]:b.expando;if(s[u]){if(t&&(o=n?s[u]:s[u].data)){b.isArray(t)?t=t.concat(b.map(t,b.camelCase)):t in o?t=[t]:(t=b.camelCase(t),t=t in o?[t]:t.split(" "));for(r=0,i=t.length;i>r;r++)delete o[t[r]];if(!(n?$:b.isEmptyObject)(o))return}(n||(delete s[u].data,$(s[u])))&&(a?b.cleanData([e],!0):b.support.deleteExpando||s!=s.window?delete s[u]:s[u]=null)}}}b.extend({cache:{},expando:"jQuery"+(p+Math.random()).replace(/\D/g,""),noData:{embed:!0,object:"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000",applet:!0},hasData:function(e){return e=e.nodeType?b.cache[e[b.expando]]:e[b.expando],!!e&&!$(e)},data:function(e,t,n){return P(e,t,n)},removeData:function(e,t){return R(e,t)},_data:function(e,t,n){return P(e,t,n,!0)},_removeData:function(e,t){return R(e,t,!0)},acceptData:function(e){if(e.nodeType&&1!==e.nodeType&&9!==e.nodeType)return!1;var t=e.nodeName&&b.noData[e.nodeName.toLowerCase()];return!t||t!==!0&&e.getAttribute("classid")===t}}),b.fn.extend({data:function(e,n){var r,i,o=this[0],a=0,s=null;if(e===t){if(this.length&&(s=b.data(o),1===o.nodeType&&!b._data(o,"parsedAttrs"))){for(r=o.attributes;r.length>a;a++)i=r[a].name,i.indexOf("data-")||(i=b.camelCase(i.slice(5)),W(o,i,s[i]));b._data(o,"parsedAttrs",!0)}return s}return"object"==typeof e?this.each(function(){b.data(this,e)}):b.access(this,function(n){return n===t?o?W(o,e,b.data(o,e)):null:(this.each(function(){b.data(this,e,n)}),t)},null,n,arguments.length>1,null,!0)},removeData:function(e){return this.each(function(){b.removeData(this,e)})}});function W(e,n,r){if(r===t&&1===e.nodeType){var i="data-"+n.replace(B,"-$1").toLowerCase();if(r=e.getAttribute(i),"string"==typeof r){try{r="true"===r?!0:"false"===r?!1:"null"===r?null:+r+""===r?+r:O.test(r)?b.parseJSON(r):r}catch(o){}b.data(e,n,r)}else r=t}return r}function $(e){var t;for(t in e)if(("data"!==t||!b.isEmptyObject(e[t]))&&"toJSON"!==t)return!1;return!0}b.extend({queue:function(e,n,r){var i;return e?(n=(n||"fx")+"queue",i=b._data(e,n),r&&(!i||b.isArray(r)?i=b._data(e,n,b.makeArray(r)):i.push(r)),i||[]):t},dequeue:function(e,t){t=t||"fx";var n=b.queue(e,t),r=n.length,i=n.shift(),o=b._queueHooks(e,t),a=function(){b.dequeue(e,t)};"inprogress"===i&&(i=n.shift(),r--),o.cur=i,i&&("fx"===t&&n.unshift("inprogress"),delete o.stop,i.call(e,a,o)),!r&&o&&o.empty.fire()},_queueHooks:function(e,t){var n=t+"queueHooks";return b._data(e,n)||b._data(e,n,{empty:b.Callbacks("once memory").add(function(){b._removeData(e,t+"queue"),b._removeData(e,n)})})}}),b.fn.extend({queue:function(e,n){var r=2;return"string"!=typeof e&&(n=e,e="fx",r--),r>arguments.length?b.queue(this[0],e):n===t?this:this.each(function(){var t=b.queue(this,e,n);b._queueHooks(this,e),"fx"===e&&"inprogress"!==t[0]&&b.dequeue(this,e)})},dequeue:function(e){return this.each(function(){b.dequeue(this,e)})},delay:function(e,t){return e=b.fx?b.fx.speeds[e]||e:e,t=t||"fx",this.queue(t,function(t,n){var r=setTimeout(t,e);n.stop=function(){clearTimeout(r)}})},clearQueue:function(e){return this.queue(e||"fx",[])},promise:function(e,n){var r,i=1,o=b.Deferred(),a=this,s=this.length,u=function(){--i||o.resolveWith(a,[a])};"string"!=typeof e&&(n=e,e=t),e=e||"fx";while(s--)r=b._data(a[s],e+"queueHooks"),r&&r.empty&&(i++,r.empty.add(u));return u(),o.promise(n)}});var I,z,X=/[\t\r\n]/g,U=/\r/g,V=/^(?:input|select|textarea|button|object)$/i,Y=/^(?:a|area)$/i,J=/^(?:checked|selected|autofocus|autoplay|async|controls|defer|disabled|hidden|loop|multiple|open|readonly|required|scoped)$/i,G=/^(?:checked|selected)$/i,Q=b.support.getSetAttribute,K=b.support.input;b.fn.extend({attr:function(e,t){return b.access(this,b.attr,e,t,arguments.length>1)},removeAttr:function(e){return this.each(function(){b.removeAttr(this,e)})},prop:function(e,t){return b.access(this,b.prop,e,t,arguments.length>1)},removeProp:function(e){return e=b.propFix[e]||e,this.each(function(){try{this[e]=t,delete this[e]}catch(n){}})},addClass:function(e){var t,n,r,i,o,a=0,s=this.length,u="string"==typeof e&&e;if(b.isFunction(e))return this.each(function(t){b(this).addClass(e.call(this,t,this.className))});if(u)for(t=(e||"").match(w)||[];s>a;a++)if(n=this[a],r=1===n.nodeType&&(n.className?(" "+n.className+" ").replace(X," "):" ")){o=0;while(i=t[o++])0>r.indexOf(" "+i+" ")&&(r+=i+" ");n.className=b.trim(r)}return this},removeClass:function(e){var t,n,r,i,o,a=0,s=this.length,u=0===arguments.length||"string"==typeof e&&e;if(b.isFunction(e))return this.each(function(t){b(this).removeClass(e.call(this,t,this.className))});if(u)for(t=(e||"").match(w)||[];s>a;a++)if(n=this[a],r=1===n.nodeType&&(n.className?(" "+n.className+" ").replace(X," "):"")){o=0;while(i=t[o++])while(r.indexOf(" "+i+" ")>=0)r=r.replace(" "+i+" "," ");n.className=e?b.trim(r):""}return this},toggleClass:function(e,t){var n=typeof e,r="boolean"==typeof t;return b.isFunction(e)?this.each(function(n){b(this).toggleClass(e.call(this,n,this.className,t),t)}):this.each(function(){if("string"===n){var o,a=0,s=b(this),u=t,l=e.match(w)||[];while(o=l[a++])u=r?u:!s.hasClass(o),s[u?"addClass":"removeClass"](o)}else(n===i||"boolean"===n)&&(this.className&&b._data(this,"__className__",this.className),this.className=this.className||e===!1?"":b._data(this,"__className__")||"")})},hasClass:function(e){var t=" "+e+" ",n=0,r=this.length;for(;r>n;n++)if(1===this[n].nodeType&&(" "+this[n].className+" ").replace(X," ").indexOf(t)>=0)return!0;return!1},val:function(e){var n,r,i,o=this[0];{if(arguments.length)return i=b.isFunction(e),this.each(function(n){var o,a=b(this);1===this.nodeType&&(o=i?e.call(this,n,a.val()):e,null==o?o="":"number"==typeof o?o+="":b.isArray(o)&&(o=b.map(o,function(e){return null==e?"":e+""})),r=b.valHooks[this.type]||b.valHooks[this.nodeName.toLowerCase()],r&&"set"in r&&r.set(this,o,"value")!==t||(this.value=o))});if(o)return r=b.valHooks[o.type]||b.valHooks[o.nodeName.toLowerCase()],r&&"get"in r&&(n=r.get(o,"value"))!==t?n:(n=o.value,"string"==typeof n?n.replace(U,""):null==n?"":n)}}}),b.extend({valHooks:{option:{get:function(e){var t=e.attributes.value;return!t||t.specified?e.value:e.text}},select:{get:function(e){var t,n,r=e.options,i=e.selectedIndex,o="select-one"===e.type||0>i,a=o?null:[],s=o?i+1:r.length,u=0>i?s:o?i:0;for(;s>u;u++)if(n=r[u],!(!n.selected&&u!==i||(b.support.optDisabled?n.disabled:null!==n.getAttribute("disabled"))||n.parentNode.disabled&&b.nodeName(n.parentNode,"optgroup"))){if(t=b(n).val(),o)return t;a.push(t)}return a},set:function(e,t){var n=b.makeArray(t);return b(e).find("option").each(function(){this.selected=b.inArray(b(this).val(),n)>=0}),n.length||(e.selectedIndex=-1),n}}},attr:function(e,n,r){var o,a,s,u=e.nodeType;if(e&&3!==u&&8!==u&&2!==u)return typeof e.getAttribute===i?b.prop(e,n,r):(a=1!==u||!b.isXMLDoc(e),a&&(n=n.toLowerCase(),o=b.attrHooks[n]||(J.test(n)?z:I)),r===t?o&&a&&"get"in o&&null!==(s=o.get(e,n))?s:(typeof e.getAttribute!==i&&(s=e.getAttribute(n)),null==s?t:s):null!==r?o&&a&&"set"in o&&(s=o.set(e,r,n))!==t?s:(e.setAttribute(n,r+""),r):(b.removeAttr(e,n),t))},removeAttr:function(e,t){var n,r,i=0,o=t&&t.match(w);if(o&&1===e.nodeType)while(n=o[i++])r=b.propFix[n]||n,J.test(n)?!Q&&G.test(n)?e[b.camelCase("default-"+n)]=e[r]=!1:e[r]=!1:b.attr(e,n,""),e.removeAttribute(Q?n:r)},attrHooks:{type:{set:function(e,t){if(!b.support.radioValue&&"radio"===t&&b.nodeName(e,"input")){var n=e.value;return e.setAttribute("type",t),n&&(e.value=n),t}}}},propFix:{tabindex:"tabIndex",readonly:"readOnly","for":"htmlFor","class":"className",maxlength:"maxLength",cellspacing:"cellSpacing",cellpadding:"cellPadding",rowspan:"rowSpan",colspan:"colSpan",usemap:"useMap",frameborder:"frameBorder",contenteditable:"contentEditable"},prop:function(e,n,r){var i,o,a,s=e.nodeType;if(e&&3!==s&&8!==s&&2!==s)return a=1!==s||!b.isXMLDoc(e),a&&(n=b.propFix[n]||n,o=b.propHooks[n]),r!==t?o&&"set"in o&&(i=o.set(e,r,n))!==t?i:e[n]=r:o&&"get"in o&&null!==(i=o.get(e,n))?i:e[n]},propHooks:{tabIndex:{get:function(e){var n=e.getAttributeNode("tabindex");return n&&n.specified?parseInt(n.value,10):V.test(e.nodeName)||Y.test(e.nodeName)&&e.href?0:t}}}}),z={get:function(e,n){var r=b.prop(e,n),i="boolean"==typeof r&&e.getAttribute(n),o="boolean"==typeof r?K&&Q?null!=i:G.test(n)?e[b.camelCase("default-"+n)]:!!i:e.getAttributeNode(n);return o&&o.value!==!1?n.toLowerCase():t},set:function(e,t,n){return t===!1?b.removeAttr(e,n):K&&Q||!G.test(n)?e.setAttribute(!Q&&b.propFix[n]||n,n):e[b.camelCase("default-"+n)]=e[n]=!0,n}},K&&Q||(b.attrHooks.value={get:function(e,n){var r=e.getAttributeNode(n);return b.nodeName(e,"input")?e.defaultValue:r&&r.specified?r.value:t},set:function(e,n,r){return b.nodeName(e,"input")?(e.defaultValue=n,t):I&&I.set(e,n,r)}}),Q||(I=b.valHooks.button={get:function(e,n){var r=e.getAttributeNode(n);return r&&("id"===n||"name"===n||"coords"===n?""!==r.value:r.specified)?r.value:t},set:function(e,n,r){var i=e.getAttributeNode(r);return i||e.setAttributeNode(i=e.ownerDocument.createAttribute(r)),i.value=n+="","value"===r||n===e.getAttribute(r)?n:t}},b.attrHooks.contenteditable={get:I.get,set:function(e,t,n){I.set(e,""===t?!1:t,n)}},b.each(["width","height"],function(e,n){b.attrHooks[n]=b.extend(b.attrHooks[n],{set:function(e,r){return""===r?(e.setAttribute(n,"auto"),r):t}})})),b.support.hrefNormalized||(b.each(["href","src","width","height"],function(e,n){b.attrHooks[n]=b.extend(b.attrHooks[n],{get:function(e){var r=e.getAttribute(n,2);return null==r?t:r}})}),b.each(["href","src"],function(e,t){b.propHooks[t]={get:function(e){return e.getAttribute(t,4)}}})),b.support.style||(b.attrHooks.style={get:function(e){return e.style.cssText||t},set:function(e,t){return e.style.cssText=t+""}}),b.support.optSelected||(b.propHooks.selected=b.extend(b.propHooks.selected,{get:function(e){var t=e.parentNode;return t&&(t.selectedIndex,t.parentNode&&t.parentNode.selectedIndex),null}})),b.support.enctype||(b.propFix.enctype="encoding"),b.support.checkOn||b.each(["radio","checkbox"],function(){b.valHooks[this]={get:function(e){return null===e.getAttribute("value")?"on":e.value}}}),b.each(["radio","checkbox"],function(){b.valHooks[this]=b.extend(b.valHooks[this],{set:function(e,n){return b.isArray(n)?e.checked=b.inArray(b(e).val(),n)>=0:t}})});var Z=/^(?:input|select|textarea)$/i,et=/^key/,tt=/^(?:mouse|contextmenu)|click/,nt=/^(?:focusinfocus|focusoutblur)$/,rt=/^([^.]*)(?:\.(.+)|)$/;function it(){return!0}function ot(){return!1}b.event={global:{},add:function(e,n,r,o,a){var s,u,l,c,p,f,d,h,g,m,y,v=b._data(e);if(v){r.handler&&(c=r,r=c.handler,a=c.selector),r.guid||(r.guid=b.guid++),(u=v.events)||(u=v.events={}),(f=v.handle)||(f=v.handle=function(e){return typeof b===i||e&&b.event.triggered===e.type?t:b.event.dispatch.apply(f.elem,arguments)},f.elem=e),n=(n||"").match(w)||[""],l=n.length;while(l--)s=rt.exec(n[l])||[],g=y=s[1],m=(s[2]||"").split(".").sort(),p=b.event.special[g]||{},g=(a?p.delegateType:p.bindType)||g,p=b.event.special[g]||{},d=b.extend({type:g,origType:y,data:o,handler:r,guid:r.guid,selector:a,needsContext:a&&b.expr.match.needsContext.test(a),namespace:m.join(".")},c),(h=u[g])||(h=u[g]=[],h.delegateCount=0,p.setup&&p.setup.call(e,o,m,f)!==!1||(e.addEventListener?e.addEventListener(g,f,!1):e.attachEvent&&e.attachEvent("on"+g,f))),p.add&&(p.add.call(e,d),d.handler.guid||(d.handler.guid=r.guid)),a?h.splice(h.delegateCount++,0,d):h.push(d),b.event.global[g]=!0;e=null}},remove:function(e,t,n,r,i){var o,a,s,u,l,c,p,f,d,h,g,m=b.hasData(e)&&b._data(e);if(m&&(c=m.events)){t=(t||"").match(w)||[""],l=t.length;while(l--)if(s=rt.exec(t[l])||[],d=g=s[1],h=(s[2]||"").split(".").sort(),d){p=b.event.special[d]||{},d=(r?p.delegateType:p.bindType)||d,f=c[d]||[],s=s[2]&&RegExp("(^|\\.)"+h.join("\\.(?:.*\\.|)")+"(\\.|$)"),u=o=f.length;while(o--)a=f[o],!i&&g!==a.origType||n&&n.guid!==a.guid||s&&!s.test(a.namespace)||r&&r!==a.selector&&("**"!==r||!a.selector)||(f.splice(o,1),a.selector&&f.delegateCount--,p.remove&&p.remove.call(e,a));u&&!f.length&&(p.teardown&&p.teardown.call(e,h,m.handle)!==!1||b.removeEvent(e,d,m.handle),delete c[d])}else for(d in c)b.event.remove(e,d+t[l],n,r,!0);b.isEmptyObject(c)&&(delete m.handle,b._removeData(e,"events"))}},trigger:function(n,r,i,a){var s,u,l,c,p,f,d,h=[i||o],g=y.call(n,"type")?n.type:n,m=y.call(n,"namespace")?n.namespace.split("."):[];if(l=f=i=i||o,3!==i.nodeType&&8!==i.nodeType&&!nt.test(g+b.event.triggered)&&(g.indexOf(".")>=0&&(m=g.split("."),g=m.shift(),m.sort()),u=0>g.indexOf(":")&&"on"+g,n=n[b.expando]?n:new b.Event(g,"object"==typeof n&&n),n.isTrigger=!0,n.namespace=m.join("."),n.namespace_re=n.namespace?RegExp("(^|\\.)"+m.join("\\.(?:.*\\.|)")+"(\\.|$)"):null,n.result=t,n.target||(n.target=i),r=null==r?[n]:b.makeArray(r,[n]),p=b.event.special[g]||{},a||!p.trigger||p.trigger.apply(i,r)!==!1)){if(!a&&!p.noBubble&&!b.isWindow(i)){for(c=p.delegateType||g,nt.test(c+g)||(l=l.parentNode);l;l=l.parentNode)h.push(l),f=l;f===(i.ownerDocument||o)&&h.push(f.defaultView||f.parentWindow||e)}d=0;while((l=h[d++])&&!n.isPropagationStopped())n.type=d>1?c:p.bindType||g,s=(b._data(l,"events")||{})[n.type]&&b._data(l,"handle"),s&&s.apply(l,r),s=u&&l[u],s&&b.acceptData(l)&&s.apply&&s.apply(l,r)===!1&&n.preventDefault();if(n.type=g,!(a||n.isDefaultPrevented()||p._default&&p._default.apply(i.ownerDocument,r)!==!1||"click"===g&&b.nodeName(i,"a")||!b.acceptData(i)||!u||!i[g]||b.isWindow(i))){f=i[u],f&&(i[u]=null),b.event.triggered=g;try{i[g]()}catch(v){}b.event.triggered=t,f&&(i[u]=f)}return n.result}},dispatch:function(e){e=b.event.fix(e);var n,r,i,o,a,s=[],u=h.call(arguments),l=(b._data(this,"events")||{})[e.type]||[],c=b.event.special[e.type]||{};if(u[0]=e,e.delegateTarget=this,!c.preDispatch||c.preDispatch.call(this,e)!==!1){s=b.event.handlers.call(this,e,l),n=0;while((o=s[n++])&&!e.isPropagationStopped()){e.currentTarget=o.elem,a=0;while((i=o.handlers[a++])&&!e.isImmediatePropagationStopped())(!e.namespace_re||e.namespace_re.test(i.namespace))&&(e.handleObj=i,e.data=i.data,r=((b.event.special[i.origType]||{}).handle||i.handler).apply(o.elem,u),r!==t&&(e.result=r)===!1&&(e.preventDefault(),e.stopPropagation()))}return c.postDispatch&&c.postDispatch.call(this,e),e.result}},handlers:function(e,n){var r,i,o,a,s=[],u=n.delegateCount,l=e.target;if(u&&l.nodeType&&(!e.button||"click"!==e.type))for(;l!=this;l=l.parentNode||this)if(1===l.nodeType&&(l.disabled!==!0||"click"!==e.type)){for(o=[],a=0;u>a;a++)i=n[a],r=i.selector+" ",o[r]===t&&(o[r]=i.needsContext?b(r,this).index(l)>=0:b.find(r,this,null,[l]).length),o[r]&&o.push(i);o.length&&s.push({elem:l,handlers:o})}return n.length>u&&s.push({elem:this,handlers:n.slice(u)}),s},fix:function(e){if(e[b.expando])return e;var t,n,r,i=e.type,a=e,s=this.fixHooks[i];s||(this.fixHooks[i]=s=tt.test(i)?this.mouseHooks:et.test(i)?this.keyHooks:{}),r=s.props?this.props.concat(s.props):this.props,e=new b.Event(a),t=r.length;while(t--)n=r[t],e[n]=a[n];return e.target||(e.target=a.srcElement||o),3===e.target.nodeType&&(e.target=e.target.parentNode),e.metaKey=!!e.metaKey,s.filter?s.filter(e,a):e},props:"altKey bubbles cancelable ctrlKey currentTarget eventPhase metaKey relatedTarget shiftKey target timeStamp view which".split(" "),fixHooks:{},keyHooks:{props:"char charCode key keyCode".split(" "),filter:function(e,t){return null==e.which&&(e.which=null!=t.charCode?t.charCode:t.keyCode),e}},mouseHooks:{props:"button buttons clientX clientY fromElement offsetX offsetY pageX pageY screenX screenY toElement".split(" "),filter:function(e,n){var r,i,a,s=n.button,u=n.fromElement;return null==e.pageX&&null!=n.clientX&&(i=e.target.ownerDocument||o,a=i.documentElement,r=i.body,e.pageX=n.clientX+(a&&a.scrollLeft||r&&r.scrollLeft||0)-(a&&a.clientLeft||r&&r.clientLeft||0),e.pageY=n.clientY+(a&&a.scrollTop||r&&r.scrollTop||0)-(a&&a.clientTop||r&&r.clientTop||0)),!e.relatedTarget&&u&&(e.relatedTarget=u===e.target?n.toElement:u),e.which||s===t||(e.which=1&s?1:2&s?3:4&s?2:0),e}},special:{load:{noBubble:!0},click:{trigger:function(){return b.nodeName(this,"input")&&"checkbox"===this.type&&this.click?(this.click(),!1):t}},focus:{trigger:function(){if(this!==o.activeElement&&this.focus)try{return this.focus(),!1}catch(e){}},delegateType:"focusin"},blur:{trigger:function(){return this===o.activeElement&&this.blur?(this.blur(),!1):t},delegateType:"focusout"},beforeunload:{postDispatch:function(e){e.result!==t&&(e.originalEvent.returnValue=e.result)}}},simulate:function(e,t,n,r){var i=b.extend(new b.Event,n,{type:e,isSimulated:!0,originalEvent:{}});r?b.event.trigger(i,null,t):b.event.dispatch.call(t,i),i.isDefaultPrevented()&&n.preventDefault()}},b.removeEvent=o.removeEventListener?function(e,t,n){e.removeEventListener&&e.removeEventListener(t,n,!1)}:function(e,t,n){var r="on"+t;e.detachEvent&&(typeof e[r]===i&&(e[r]=null),e.detachEvent(r,n))},b.Event=function(e,n){return this instanceof b.Event?(e&&e.type?(this.originalEvent=e,this.type=e.type,this.isDefaultPrevented=e.defaultPrevented||e.returnValue===!1||e.getPreventDefault&&e.getPreventDefault()?it:ot):this.type=e,n&&b.extend(this,n),this.timeStamp=e&&e.timeStamp||b.now(),this[b.expando]=!0,t):new b.Event(e,n)},b.Event.prototype={isDefaultPrevented:ot,isPropagationStopped:ot,isImmediatePropagationStopped:ot,preventDefault:function(){var e=this.originalEvent;this.isDefaultPrevented=it,e&&(e.preventDefault?e.preventDefault():e.returnValue=!1)},stopPropagation:function(){var e=this.originalEvent;this.isPropagationStopped=it,e&&(e.stopPropagation&&e.stopPropagation(),e.cancelBubble=!0)},stopImmediatePropagation:function(){this.isImmediatePropagationStopped=it,this.stopPropagation()}},b.each({mouseenter:"mouseover",mouseleave:"mouseout"},function(e,t){b.event.special[e]={delegateType:t,bindType:t,handle:function(e){var n,r=this,i=e.relatedTarget,o=e.handleObj;
 return(!i||i!==r&&!b.contains(r,i))&&(e.type=o.origType,n=o.handler.apply(this,arguments),e.type=t),n}}}),b.support.submitBubbles||(b.event.special.submit={setup:function(){return b.nodeName(this,"form")?!1:(b.event.add(this,"click._submit keypress._submit",function(e){var n=e.target,r=b.nodeName(n,"input")||b.nodeName(n,"button")?n.form:t;r&&!b._data(r,"submitBubbles")&&(b.event.add(r,"submit._submit",function(e){e._submit_bubble=!0}),b._data(r,"submitBubbles",!0))}),t)},postDispatch:function(e){e._submit_bubble&&(delete e._submit_bubble,this.parentNode&&!e.isTrigger&&b.event.simulate("submit",this.parentNode,e,!0))},teardown:function(){return b.nodeName(this,"form")?!1:(b.event.remove(this,"._submit"),t)}}),b.support.changeBubbles||(b.event.special.change={setup:function(){return Z.test(this.nodeName)?(("checkbox"===this.type||"radio"===this.type)&&(b.event.add(this,"propertychange._change",function(e){"checked"===e.originalEvent.propertyName&&(this._just_changed=!0)}),b.event.add(this,"click._change",function(e){this._just_changed&&!e.isTrigger&&(this._just_changed=!1),b.event.simulate("change",this,e,!0)})),!1):(b.event.add(this,"beforeactivate._change",function(e){var t=e.target;Z.test(t.nodeName)&&!b._data(t,"changeBubbles")&&(b.event.add(t,"change._change",function(e){!this.parentNode||e.isSimulated||e.isTrigger||b.event.simulate("change",this.parentNode,e,!0)}),b._data(t,"changeBubbles",!0))}),t)},handle:function(e){var n=e.target;return this!==n||e.isSimulated||e.isTrigger||"radio"!==n.type&&"checkbox"!==n.type?e.handleObj.handler.apply(this,arguments):t},teardown:function(){return b.event.remove(this,"._change"),!Z.test(this.nodeName)}}),b.support.focusinBubbles||b.each({focus:"focusin",blur:"focusout"},function(e,t){var n=0,r=function(e){b.event.simulate(t,e.target,b.event.fix(e),!0)};b.event.special[t]={setup:function(){0===n++&&o.addEventListener(e,r,!0)},teardown:function(){0===--n&&o.removeEventListener(e,r,!0)}}}),b.fn.extend({on:function(e,n,r,i,o){var a,s;if("object"==typeof e){"string"!=typeof n&&(r=r||n,n=t);for(a in e)this.on(a,n,r,e[a],o);return this}if(null==r&&null==i?(i=n,r=n=t):null==i&&("string"==typeof n?(i=r,r=t):(i=r,r=n,n=t)),i===!1)i=ot;else if(!i)return this;return 1===o&&(s=i,i=function(e){return b().off(e),s.apply(this,arguments)},i.guid=s.guid||(s.guid=b.guid++)),this.each(function(){b.event.add(this,e,i,r,n)})},one:function(e,t,n,r){return this.on(e,t,n,r,1)},off:function(e,n,r){var i,o;if(e&&e.preventDefault&&e.handleObj)return i=e.handleObj,b(e.delegateTarget).off(i.namespace?i.origType+"."+i.namespace:i.origType,i.selector,i.handler),this;if("object"==typeof e){for(o in e)this.off(o,n,e[o]);return this}return(n===!1||"function"==typeof n)&&(r=n,n=t),r===!1&&(r=ot),this.each(function(){b.event.remove(this,e,r,n)})},bind:function(e,t,n){return this.on(e,null,t,n)},unbind:function(e,t){return this.off(e,null,t)},delegate:function(e,t,n,r){return this.on(t,e,n,r)},undelegate:function(e,t,n){return 1===arguments.length?this.off(e,"**"):this.off(t,e||"**",n)},trigger:function(e,t){return this.each(function(){b.event.trigger(e,t,this)})},triggerHandler:function(e,n){var r=this[0];return r?b.event.trigger(e,n,r,!0):t}}),function(e,t){var n,r,i,o,a,s,u,l,c,p,f,d,h,g,m,y,v,x="sizzle"+-new Date,w=e.document,T={},N=0,C=0,k=it(),E=it(),S=it(),A=typeof t,j=1<<31,D=[],L=D.pop,H=D.push,q=D.slice,M=D.indexOf||function(e){var t=0,n=this.length;for(;n>t;t++)if(this[t]===e)return t;return-1},_="[\\x20\\t\\r\\n\\f]",F="(?:\\\\.|[\\w-]|[^\\x00-\\xa0])+",O=F.replace("w","w#"),B="([*^$|!~]?=)",P="\\["+_+"*("+F+")"+_+"*(?:"+B+_+"*(?:(['\"])((?:\\\\.|[^\\\\])*?)\\3|("+O+")|)|)"+_+"*\\]",R=":("+F+")(?:\\(((['\"])((?:\\\\.|[^\\\\])*?)\\3|((?:\\\\.|[^\\\\()[\\]]|"+P.replace(3,8)+")*)|.*)\\)|)",W=RegExp("^"+_+"+|((?:^|[^\\\\])(?:\\\\.)*)"+_+"+$","g"),$=RegExp("^"+_+"*,"+_+"*"),I=RegExp("^"+_+"*([\\x20\\t\\r\\n\\f>+~])"+_+"*"),z=RegExp(R),X=RegExp("^"+O+"$"),U={ID:RegExp("^#("+F+")"),CLASS:RegExp("^\\.("+F+")"),NAME:RegExp("^\\[name=['\"]?("+F+")['\"]?\\]"),TAG:RegExp("^("+F.replace("w","w*")+")"),ATTR:RegExp("^"+P),PSEUDO:RegExp("^"+R),CHILD:RegExp("^:(only|first|last|nth|nth-last)-(child|of-type)(?:\\("+_+"*(even|odd|(([+-]|)(\\d*)n|)"+_+"*(?:([+-]|)"+_+"*(\\d+)|))"+_+"*\\)|)","i"),needsContext:RegExp("^"+_+"*[>+~]|:(even|odd|eq|gt|lt|nth|first|last)(?:\\("+_+"*((?:-\\d)?\\d*)"+_+"*\\)|)(?=[^-]|$)","i")},V=/[\x20\t\r\n\f]*[+~]/,Y=/^[^{]+\{\s*\[native code/,J=/^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/,G=/^(?:input|select|textarea|button)$/i,Q=/^h\d$/i,K=/'|\\/g,Z=/\=[\x20\t\r\n\f]*([^'"\]]*)[\x20\t\r\n\f]*\]/g,et=/\\([\da-fA-F]{1,6}[\x20\t\r\n\f]?|.)/g,tt=function(e,t){var n="0x"+t-65536;return n!==n?t:0>n?String.fromCharCode(n+65536):String.fromCharCode(55296|n>>10,56320|1023&n)};try{q.call(w.documentElement.childNodes,0)[0].nodeType}catch(nt){q=function(e){var t,n=[];while(t=this[e++])n.push(t);return n}}function rt(e){return Y.test(e+"")}function it(){var e,t=[];return e=function(n,r){return t.push(n+=" ")>i.cacheLength&&delete e[t.shift()],e[n]=r}}function ot(e){return e[x]=!0,e}function at(e){var t=p.createElement("div");try{return e(t)}catch(n){return!1}finally{t=null}}function st(e,t,n,r){var i,o,a,s,u,l,f,g,m,v;if((t?t.ownerDocument||t:w)!==p&&c(t),t=t||p,n=n||[],!e||"string"!=typeof e)return n;if(1!==(s=t.nodeType)&&9!==s)return[];if(!d&&!r){if(i=J.exec(e))if(a=i[1]){if(9===s){if(o=t.getElementById(a),!o||!o.parentNode)return n;if(o.id===a)return n.push(o),n}else if(t.ownerDocument&&(o=t.ownerDocument.getElementById(a))&&y(t,o)&&o.id===a)return n.push(o),n}else{if(i[2])return H.apply(n,q.call(t.getElementsByTagName(e),0)),n;if((a=i[3])&&T.getByClassName&&t.getElementsByClassName)return H.apply(n,q.call(t.getElementsByClassName(a),0)),n}if(T.qsa&&!h.test(e)){if(f=!0,g=x,m=t,v=9===s&&e,1===s&&"object"!==t.nodeName.toLowerCase()){l=ft(e),(f=t.getAttribute("id"))?g=f.replace(K,"\\$&"):t.setAttribute("id",g),g="[id='"+g+"'] ",u=l.length;while(u--)l[u]=g+dt(l[u]);m=V.test(e)&&t.parentNode||t,v=l.join(",")}if(v)try{return H.apply(n,q.call(m.querySelectorAll(v),0)),n}catch(b){}finally{f||t.removeAttribute("id")}}}return wt(e.replace(W,"$1"),t,n,r)}a=st.isXML=function(e){var t=e&&(e.ownerDocument||e).documentElement;return t?"HTML"!==t.nodeName:!1},c=st.setDocument=function(e){var n=e?e.ownerDocument||e:w;return n!==p&&9===n.nodeType&&n.documentElement?(p=n,f=n.documentElement,d=a(n),T.tagNameNoComments=at(function(e){return e.appendChild(n.createComment("")),!e.getElementsByTagName("*").length}),T.attributes=at(function(e){e.innerHTML="<select></select>";var t=typeof e.lastChild.getAttribute("multiple");return"boolean"!==t&&"string"!==t}),T.getByClassName=at(function(e){return e.innerHTML="<div class='hidden e'></div><div class='hidden'></div>",e.getElementsByClassName&&e.getElementsByClassName("e").length?(e.lastChild.className="e",2===e.getElementsByClassName("e").length):!1}),T.getByName=at(function(e){e.id=x+0,e.innerHTML="<a name='"+x+"'></a><div name='"+x+"'></div>",f.insertBefore(e,f.firstChild);var t=n.getElementsByName&&n.getElementsByName(x).length===2+n.getElementsByName(x+0).length;return T.getIdNotName=!n.getElementById(x),f.removeChild(e),t}),i.attrHandle=at(function(e){return e.innerHTML="<a href='#'></a>",e.firstChild&&typeof e.firstChild.getAttribute!==A&&"#"===e.firstChild.getAttribute("href")})?{}:{href:function(e){return e.getAttribute("href",2)},type:function(e){return e.getAttribute("type")}},T.getIdNotName?(i.find.ID=function(e,t){if(typeof t.getElementById!==A&&!d){var n=t.getElementById(e);return n&&n.parentNode?[n]:[]}},i.filter.ID=function(e){var t=e.replace(et,tt);return function(e){return e.getAttribute("id")===t}}):(i.find.ID=function(e,n){if(typeof n.getElementById!==A&&!d){var r=n.getElementById(e);return r?r.id===e||typeof r.getAttributeNode!==A&&r.getAttributeNode("id").value===e?[r]:t:[]}},i.filter.ID=function(e){var t=e.replace(et,tt);return function(e){var n=typeof e.getAttributeNode!==A&&e.getAttributeNode("id");return n&&n.value===t}}),i.find.TAG=T.tagNameNoComments?function(e,n){return typeof n.getElementsByTagName!==A?n.getElementsByTagName(e):t}:function(e,t){var n,r=[],i=0,o=t.getElementsByTagName(e);if("*"===e){while(n=o[i++])1===n.nodeType&&r.push(n);return r}return o},i.find.NAME=T.getByName&&function(e,n){return typeof n.getElementsByName!==A?n.getElementsByName(name):t},i.find.CLASS=T.getByClassName&&function(e,n){return typeof n.getElementsByClassName===A||d?t:n.getElementsByClassName(e)},g=[],h=[":focus"],(T.qsa=rt(n.querySelectorAll))&&(at(function(e){e.innerHTML="<select><option selected=''></option></select>",e.querySelectorAll("[selected]").length||h.push("\\["+_+"*(?:checked|disabled|ismap|multiple|readonly|selected|value)"),e.querySelectorAll(":checked").length||h.push(":checked")}),at(function(e){e.innerHTML="<input type='hidden' i=''/>",e.querySelectorAll("[i^='']").length&&h.push("[*^$]="+_+"*(?:\"\"|'')"),e.querySelectorAll(":enabled").length||h.push(":enabled",":disabled"),e.querySelectorAll("*,:x"),h.push(",.*:")})),(T.matchesSelector=rt(m=f.matchesSelector||f.mozMatchesSelector||f.webkitMatchesSelector||f.oMatchesSelector||f.msMatchesSelector))&&at(function(e){T.disconnectedMatch=m.call(e,"div"),m.call(e,"[s!='']:x"),g.push("!=",R)}),h=RegExp(h.join("|")),g=RegExp(g.join("|")),y=rt(f.contains)||f.compareDocumentPosition?function(e,t){var n=9===e.nodeType?e.documentElement:e,r=t&&t.parentNode;return e===r||!(!r||1!==r.nodeType||!(n.contains?n.contains(r):e.compareDocumentPosition&&16&e.compareDocumentPosition(r)))}:function(e,t){if(t)while(t=t.parentNode)if(t===e)return!0;return!1},v=f.compareDocumentPosition?function(e,t){var r;return e===t?(u=!0,0):(r=t.compareDocumentPosition&&e.compareDocumentPosition&&e.compareDocumentPosition(t))?1&r||e.parentNode&&11===e.parentNode.nodeType?e===n||y(w,e)?-1:t===n||y(w,t)?1:0:4&r?-1:1:e.compareDocumentPosition?-1:1}:function(e,t){var r,i=0,o=e.parentNode,a=t.parentNode,s=[e],l=[t];if(e===t)return u=!0,0;if(!o||!a)return e===n?-1:t===n?1:o?-1:a?1:0;if(o===a)return ut(e,t);r=e;while(r=r.parentNode)s.unshift(r);r=t;while(r=r.parentNode)l.unshift(r);while(s[i]===l[i])i++;return i?ut(s[i],l[i]):s[i]===w?-1:l[i]===w?1:0},u=!1,[0,0].sort(v),T.detectDuplicates=u,p):p},st.matches=function(e,t){return st(e,null,null,t)},st.matchesSelector=function(e,t){if((e.ownerDocument||e)!==p&&c(e),t=t.replace(Z,"='$1']"),!(!T.matchesSelector||d||g&&g.test(t)||h.test(t)))try{var n=m.call(e,t);if(n||T.disconnectedMatch||e.document&&11!==e.document.nodeType)return n}catch(r){}return st(t,p,null,[e]).length>0},st.contains=function(e,t){return(e.ownerDocument||e)!==p&&c(e),y(e,t)},st.attr=function(e,t){var n;return(e.ownerDocument||e)!==p&&c(e),d||(t=t.toLowerCase()),(n=i.attrHandle[t])?n(e):d||T.attributes?e.getAttribute(t):((n=e.getAttributeNode(t))||e.getAttribute(t))&&e[t]===!0?t:n&&n.specified?n.value:null},st.error=function(e){throw Error("Syntax error, unrecognized expression: "+e)},st.uniqueSort=function(e){var t,n=[],r=1,i=0;if(u=!T.detectDuplicates,e.sort(v),u){for(;t=e[r];r++)t===e[r-1]&&(i=n.push(r));while(i--)e.splice(n[i],1)}return e};function ut(e,t){var n=t&&e,r=n&&(~t.sourceIndex||j)-(~e.sourceIndex||j);if(r)return r;if(n)while(n=n.nextSibling)if(n===t)return-1;return e?1:-1}function lt(e){return function(t){var n=t.nodeName.toLowerCase();return"input"===n&&t.type===e}}function ct(e){return function(t){var n=t.nodeName.toLowerCase();return("input"===n||"button"===n)&&t.type===e}}function pt(e){return ot(function(t){return t=+t,ot(function(n,r){var i,o=e([],n.length,t),a=o.length;while(a--)n[i=o[a]]&&(n[i]=!(r[i]=n[i]))})})}o=st.getText=function(e){var t,n="",r=0,i=e.nodeType;if(i){if(1===i||9===i||11===i){if("string"==typeof e.textContent)return e.textContent;for(e=e.firstChild;e;e=e.nextSibling)n+=o(e)}else if(3===i||4===i)return e.nodeValue}else for(;t=e[r];r++)n+=o(t);return n},i=st.selectors={cacheLength:50,createPseudo:ot,match:U,find:{},relative:{">":{dir:"parentNode",first:!0}," ":{dir:"parentNode"},"+":{dir:"previousSibling",first:!0},"~":{dir:"previousSibling"}},preFilter:{ATTR:function(e){return e[1]=e[1].replace(et,tt),e[3]=(e[4]||e[5]||"").replace(et,tt),"~="===e[2]&&(e[3]=" "+e[3]+" "),e.slice(0,4)},CHILD:function(e){return e[1]=e[1].toLowerCase(),"nth"===e[1].slice(0,3)?(e[3]||st.error(e[0]),e[4]=+(e[4]?e[5]+(e[6]||1):2*("even"===e[3]||"odd"===e[3])),e[5]=+(e[7]+e[8]||"odd"===e[3])):e[3]&&st.error(e[0]),e},PSEUDO:function(e){var t,n=!e[5]&&e[2];return U.CHILD.test(e[0])?null:(e[4]?e[2]=e[4]:n&&z.test(n)&&(t=ft(n,!0))&&(t=n.indexOf(")",n.length-t)-n.length)&&(e[0]=e[0].slice(0,t),e[2]=n.slice(0,t)),e.slice(0,3))}},filter:{TAG:function(e){return"*"===e?function(){return!0}:(e=e.replace(et,tt).toLowerCase(),function(t){return t.nodeName&&t.nodeName.toLowerCase()===e})},CLASS:function(e){var t=k[e+" "];return t||(t=RegExp("(^|"+_+")"+e+"("+_+"|$)"))&&k(e,function(e){return t.test(e.className||typeof e.getAttribute!==A&&e.getAttribute("class")||"")})},ATTR:function(e,t,n){return function(r){var i=st.attr(r,e);return null==i?"!="===t:t?(i+="","="===t?i===n:"!="===t?i!==n:"^="===t?n&&0===i.indexOf(n):"*="===t?n&&i.indexOf(n)>-1:"$="===t?n&&i.slice(-n.length)===n:"~="===t?(" "+i+" ").indexOf(n)>-1:"|="===t?i===n||i.slice(0,n.length+1)===n+"-":!1):!0}},CHILD:function(e,t,n,r,i){var o="nth"!==e.slice(0,3),a="last"!==e.slice(-4),s="of-type"===t;return 1===r&&0===i?function(e){return!!e.parentNode}:function(t,n,u){var l,c,p,f,d,h,g=o!==a?"nextSibling":"previousSibling",m=t.parentNode,y=s&&t.nodeName.toLowerCase(),v=!u&&!s;if(m){if(o){while(g){p=t;while(p=p[g])if(s?p.nodeName.toLowerCase()===y:1===p.nodeType)return!1;h=g="only"===e&&!h&&"nextSibling"}return!0}if(h=[a?m.firstChild:m.lastChild],a&&v){c=m[x]||(m[x]={}),l=c[e]||[],d=l[0]===N&&l[1],f=l[0]===N&&l[2],p=d&&m.childNodes[d];while(p=++d&&p&&p[g]||(f=d=0)||h.pop())if(1===p.nodeType&&++f&&p===t){c[e]=[N,d,f];break}}else if(v&&(l=(t[x]||(t[x]={}))[e])&&l[0]===N)f=l[1];else while(p=++d&&p&&p[g]||(f=d=0)||h.pop())if((s?p.nodeName.toLowerCase()===y:1===p.nodeType)&&++f&&(v&&((p[x]||(p[x]={}))[e]=[N,f]),p===t))break;return f-=i,f===r||0===f%r&&f/r>=0}}},PSEUDO:function(e,t){var n,r=i.pseudos[e]||i.setFilters[e.toLowerCase()]||st.error("unsupported pseudo: "+e);return r[x]?r(t):r.length>1?(n=[e,e,"",t],i.setFilters.hasOwnProperty(e.toLowerCase())?ot(function(e,n){var i,o=r(e,t),a=o.length;while(a--)i=M.call(e,o[a]),e[i]=!(n[i]=o[a])}):function(e){return r(e,0,n)}):r}},pseudos:{not:ot(function(e){var t=[],n=[],r=s(e.replace(W,"$1"));return r[x]?ot(function(e,t,n,i){var o,a=r(e,null,i,[]),s=e.length;while(s--)(o=a[s])&&(e[s]=!(t[s]=o))}):function(e,i,o){return t[0]=e,r(t,null,o,n),!n.pop()}}),has:ot(function(e){return function(t){return st(e,t).length>0}}),contains:ot(function(e){return function(t){return(t.textContent||t.innerText||o(t)).indexOf(e)>-1}}),lang:ot(function(e){return X.test(e||"")||st.error("unsupported lang: "+e),e=e.replace(et,tt).toLowerCase(),function(t){var n;do if(n=d?t.getAttribute("xml:lang")||t.getAttribute("lang"):t.lang)return n=n.toLowerCase(),n===e||0===n.indexOf(e+"-");while((t=t.parentNode)&&1===t.nodeType);return!1}}),target:function(t){var n=e.location&&e.location.hash;return n&&n.slice(1)===t.id},root:function(e){return e===f},focus:function(e){return e===p.activeElement&&(!p.hasFocus||p.hasFocus())&&!!(e.type||e.href||~e.tabIndex)},enabled:function(e){return e.disabled===!1},disabled:function(e){return e.disabled===!0},checked:function(e){var t=e.nodeName.toLowerCase();return"input"===t&&!!e.checked||"option"===t&&!!e.selected},selected:function(e){return e.parentNode&&e.parentNode.selectedIndex,e.selected===!0},empty:function(e){for(e=e.firstChild;e;e=e.nextSibling)if(e.nodeName>"@"||3===e.nodeType||4===e.nodeType)return!1;return!0},parent:function(e){return!i.pseudos.empty(e)},header:function(e){return Q.test(e.nodeName)},input:function(e){return G.test(e.nodeName)},button:function(e){var t=e.nodeName.toLowerCase();return"input"===t&&"button"===e.type||"button"===t},text:function(e){var t;return"input"===e.nodeName.toLowerCase()&&"text"===e.type&&(null==(t=e.getAttribute("type"))||t.toLowerCase()===e.type)},first:pt(function(){return[0]}),last:pt(function(e,t){return[t-1]}),eq:pt(function(e,t,n){return[0>n?n+t:n]}),even:pt(function(e,t){var n=0;for(;t>n;n+=2)e.push(n);return e}),odd:pt(function(e,t){var n=1;for(;t>n;n+=2)e.push(n);return e}),lt:pt(function(e,t,n){var r=0>n?n+t:n;for(;--r>=0;)e.push(r);return e}),gt:pt(function(e,t,n){var r=0>n?n+t:n;for(;t>++r;)e.push(r);return e})}};for(n in{radio:!0,checkbox:!0,file:!0,password:!0,image:!0})i.pseudos[n]=lt(n);for(n in{submit:!0,reset:!0})i.pseudos[n]=ct(n);function ft(e,t){var n,r,o,a,s,u,l,c=E[e+" "];if(c)return t?0:c.slice(0);s=e,u=[],l=i.preFilter;while(s){(!n||(r=$.exec(s)))&&(r&&(s=s.slice(r[0].length)||s),u.push(o=[])),n=!1,(r=I.exec(s))&&(n=r.shift(),o.push({value:n,type:r[0].replace(W," ")}),s=s.slice(n.length));for(a in i.filter)!(r=U[a].exec(s))||l[a]&&!(r=l[a](r))||(n=r.shift(),o.push({value:n,type:a,matches:r}),s=s.slice(n.length));if(!n)break}return t?s.length:s?st.error(e):E(e,u).slice(0)}function dt(e){var t=0,n=e.length,r="";for(;n>t;t++)r+=e[t].value;return r}function ht(e,t,n){var i=t.dir,o=n&&"parentNode"===i,a=C++;return t.first?function(t,n,r){while(t=t[i])if(1===t.nodeType||o)return e(t,n,r)}:function(t,n,s){var u,l,c,p=N+" "+a;if(s){while(t=t[i])if((1===t.nodeType||o)&&e(t,n,s))return!0}else while(t=t[i])if(1===t.nodeType||o)if(c=t[x]||(t[x]={}),(l=c[i])&&l[0]===p){if((u=l[1])===!0||u===r)return u===!0}else if(l=c[i]=[p],l[1]=e(t,n,s)||r,l[1]===!0)return!0}}function gt(e){return e.length>1?function(t,n,r){var i=e.length;while(i--)if(!e[i](t,n,r))return!1;return!0}:e[0]}function mt(e,t,n,r,i){var o,a=[],s=0,u=e.length,l=null!=t;for(;u>s;s++)(o=e[s])&&(!n||n(o,r,i))&&(a.push(o),l&&t.push(s));return a}function yt(e,t,n,r,i,o){return r&&!r[x]&&(r=yt(r)),i&&!i[x]&&(i=yt(i,o)),ot(function(o,a,s,u){var l,c,p,f=[],d=[],h=a.length,g=o||xt(t||"*",s.nodeType?[s]:s,[]),m=!e||!o&&t?g:mt(g,f,e,s,u),y=n?i||(o?e:h||r)?[]:a:m;if(n&&n(m,y,s,u),r){l=mt(y,d),r(l,[],s,u),c=l.length;while(c--)(p=l[c])&&(y[d[c]]=!(m[d[c]]=p))}if(o){if(i||e){if(i){l=[],c=y.length;while(c--)(p=y[c])&&l.push(m[c]=p);i(null,y=[],l,u)}c=y.length;while(c--)(p=y[c])&&(l=i?M.call(o,p):f[c])>-1&&(o[l]=!(a[l]=p))}}else y=mt(y===a?y.splice(h,y.length):y),i?i(null,a,y,u):H.apply(a,y)})}function vt(e){var t,n,r,o=e.length,a=i.relative[e[0].type],s=a||i.relative[" "],u=a?1:0,c=ht(function(e){return e===t},s,!0),p=ht(function(e){return M.call(t,e)>-1},s,!0),f=[function(e,n,r){return!a&&(r||n!==l)||((t=n).nodeType?c(e,n,r):p(e,n,r))}];for(;o>u;u++)if(n=i.relative[e[u].type])f=[ht(gt(f),n)];else{if(n=i.filter[e[u].type].apply(null,e[u].matches),n[x]){for(r=++u;o>r;r++)if(i.relative[e[r].type])break;return yt(u>1&&gt(f),u>1&&dt(e.slice(0,u-1)).replace(W,"$1"),n,r>u&&vt(e.slice(u,r)),o>r&&vt(e=e.slice(r)),o>r&&dt(e))}f.push(n)}return gt(f)}function bt(e,t){var n=0,o=t.length>0,a=e.length>0,s=function(s,u,c,f,d){var h,g,m,y=[],v=0,b="0",x=s&&[],w=null!=d,T=l,C=s||a&&i.find.TAG("*",d&&u.parentNode||u),k=N+=null==T?1:Math.random()||.1;for(w&&(l=u!==p&&u,r=n);null!=(h=C[b]);b++){if(a&&h){g=0;while(m=e[g++])if(m(h,u,c)){f.push(h);break}w&&(N=k,r=++n)}o&&((h=!m&&h)&&v--,s&&x.push(h))}if(v+=b,o&&b!==v){g=0;while(m=t[g++])m(x,y,u,c);if(s){if(v>0)while(b--)x[b]||y[b]||(y[b]=L.call(f));y=mt(y)}H.apply(f,y),w&&!s&&y.length>0&&v+t.length>1&&st.uniqueSort(f)}return w&&(N=k,l=T),x};return o?ot(s):s}s=st.compile=function(e,t){var n,r=[],i=[],o=S[e+" "];if(!o){t||(t=ft(e)),n=t.length;while(n--)o=vt(t[n]),o[x]?r.push(o):i.push(o);o=S(e,bt(i,r))}return o};function xt(e,t,n){var r=0,i=t.length;for(;i>r;r++)st(e,t[r],n);return n}function wt(e,t,n,r){var o,a,u,l,c,p=ft(e);if(!r&&1===p.length){if(a=p[0]=p[0].slice(0),a.length>2&&"ID"===(u=a[0]).type&&9===t.nodeType&&!d&&i.relative[a[1].type]){if(t=i.find.ID(u.matches[0].replace(et,tt),t)[0],!t)return n;e=e.slice(a.shift().value.length)}o=U.needsContext.test(e)?0:a.length;while(o--){if(u=a[o],i.relative[l=u.type])break;if((c=i.find[l])&&(r=c(u.matches[0].replace(et,tt),V.test(a[0].type)&&t.parentNode||t))){if(a.splice(o,1),e=r.length&&dt(a),!e)return H.apply(n,q.call(r,0)),n;break}}}return s(e,p)(r,t,d,n,V.test(e)),n}i.pseudos.nth=i.pseudos.eq;function Tt(){}i.filters=Tt.prototype=i.pseudos,i.setFilters=new Tt,c(),st.attr=b.attr,b.find=st,b.expr=st.selectors,b.expr[":"]=b.expr.pseudos,b.unique=st.uniqueSort,b.text=st.getText,b.isXMLDoc=st.isXML,b.contains=st.contains}(e);var at=/Until$/,st=/^(?:parents|prev(?:Until|All))/,ut=/^.[^:#\[\.,]*$/,lt=b.expr.match.needsContext,ct={children:!0,contents:!0,next:!0,prev:!0};b.fn.extend({find:function(e){var t,n,r,i=this.length;if("string"!=typeof e)return r=this,this.pushStack(b(e).filter(function(){for(t=0;i>t;t++)if(b.contains(r[t],this))return!0}));for(n=[],t=0;i>t;t++)b.find(e,this[t],n);return n=this.pushStack(i>1?b.unique(n):n),n.selector=(this.selector?this.selector+" ":"")+e,n},has:function(e){var t,n=b(e,this),r=n.length;return this.filter(function(){for(t=0;r>t;t++)if(b.contains(this,n[t]))return!0})},not:function(e){return this.pushStack(ft(this,e,!1))},filter:function(e){return this.pushStack(ft(this,e,!0))},is:function(e){return!!e&&("string"==typeof e?lt.test(e)?b(e,this.context).index(this[0])>=0:b.filter(e,this).length>0:this.filter(e).length>0)},closest:function(e,t){var n,r=0,i=this.length,o=[],a=lt.test(e)||"string"!=typeof e?b(e,t||this.context):0;for(;i>r;r++){n=this[r];while(n&&n.ownerDocument&&n!==t&&11!==n.nodeType){if(a?a.index(n)>-1:b.find.matchesSelector(n,e)){o.push(n);break}n=n.parentNode}}return this.pushStack(o.length>1?b.unique(o):o)},index:function(e){return e?"string"==typeof e?b.inArray(this[0],b(e)):b.inArray(e.jquery?e[0]:e,this):this[0]&&this[0].parentNode?this.first().prevAll().length:-1},add:function(e,t){var n="string"==typeof e?b(e,t):b.makeArray(e&&e.nodeType?[e]:e),r=b.merge(this.get(),n);return this.pushStack(b.unique(r))},addBack:function(e){return this.add(null==e?this.prevObject:this.prevObject.filter(e))}}),b.fn.andSelf=b.fn.addBack;function pt(e,t){do e=e[t];while(e&&1!==e.nodeType);return e}b.each({parent:function(e){var t=e.parentNode;return t&&11!==t.nodeType?t:null},parents:function(e){return b.dir(e,"parentNode")},parentsUntil:function(e,t,n){return b.dir(e,"parentNode",n)},next:function(e){return pt(e,"nextSibling")},prev:function(e){return pt(e,"previousSibling")},nextAll:function(e){return b.dir(e,"nextSibling")},prevAll:function(e){return b.dir(e,"previousSibling")},nextUntil:function(e,t,n){return b.dir(e,"nextSibling",n)},prevUntil:function(e,t,n){return b.dir(e,"previousSibling",n)},siblings:function(e){return b.sibling((e.parentNode||{}).firstChild,e)},children:function(e){return b.sibling(e.firstChild)},contents:function(e){return b.nodeName(e,"iframe")?e.contentDocument||e.contentWindow.document:b.merge([],e.childNodes)}},function(e,t){b.fn[e]=function(n,r){var i=b.map(this,t,n);return at.test(e)||(r=n),r&&"string"==typeof r&&(i=b.filter(r,i)),i=this.length>1&&!ct[e]?b.unique(i):i,this.length>1&&st.test(e)&&(i=i.reverse()),this.pushStack(i)}}),b.extend({filter:function(e,t,n){return n&&(e=":not("+e+")"),1===t.length?b.find.matchesSelector(t[0],e)?[t[0]]:[]:b.find.matches(e,t)},dir:function(e,n,r){var i=[],o=e[n];while(o&&9!==o.nodeType&&(r===t||1!==o.nodeType||!b(o).is(r)))1===o.nodeType&&i.push(o),o=o[n];return i},sibling:function(e,t){var n=[];for(;e;e=e.nextSibling)1===e.nodeType&&e!==t&&n.push(e);return n}});function ft(e,t,n){if(t=t||0,b.isFunction(t))return b.grep(e,function(e,r){var i=!!t.call(e,r,e);return i===n});if(t.nodeType)return b.grep(e,function(e){return e===t===n});if("string"==typeof t){var r=b.grep(e,function(e){return 1===e.nodeType});if(ut.test(t))return b.filter(t,r,!n);t=b.filter(t,r)}return b.grep(e,function(e){return b.inArray(e,t)>=0===n})}function dt(e){var t=ht.split("|"),n=e.createDocumentFragment();if(n.createElement)while(t.length)n.createElement(t.pop());return n}var ht="abbr|article|aside|audio|bdi|canvas|data|datalist|details|figcaption|figure|footer|header|hgroup|mark|meter|nav|output|progress|section|summary|time|video",gt=/ jQuery\d+="(?:null|\d+)"/g,mt=RegExp("<(?:"+ht+")[\\s/>]","i"),yt=/^\s+/,vt=/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi,bt=/<([\w:]+)/,xt=/<tbody/i,wt=/<|&#?\w+;/,Tt=/<(?:script|style|link)/i,Nt=/^(?:checkbox|radio)$/i,Ct=/checked\s*(?:[^=]|=\s*.checked.)/i,kt=/^$|\/(?:java|ecma)script/i,Et=/^true\/(.*)/,St=/^\s*<!(?:\[CDATA\[|--)|(?:\]\]|--)>\s*$/g,At={option:[1,"<select multiple='multiple'>","</select>"],legend:[1,"<fieldset>","</fieldset>"],area:[1,"<map>","</map>"],param:[1,"<object>","</object>"],thead:[1,"<table>","</table>"],tr:[2,"<table><tbody>","</tbody></table>"],col:[2,"<table><tbody></tbody><colgroup>","</colgroup></table>"],td:[3,"<table><tbody><tr>","</tr></tbody></table>"],_default:b.support.htmlSerialize?[0,"",""]:[1,"X<div>","</div>"]},jt=dt(o),Dt=jt.appendChild(o.createElement("div"));At.optgroup=At.option,At.tbody=At.tfoot=At.colgroup=At.caption=At.thead,At.th=At.td,b.fn.extend({text:function(e){return b.access(this,function(e){return e===t?b.text(this):this.empty().append((this[0]&&this[0].ownerDocument||o).createTextNode(e))},null,e,arguments.length)},wrapAll:function(e){if(b.isFunction(e))return this.each(function(t){b(this).wrapAll(e.call(this,t))});if(this[0]){var t=b(e,this[0].ownerDocument).eq(0).clone(!0);this[0].parentNode&&t.insertBefore(this[0]),t.map(function(){var e=this;while(e.firstChild&&1===e.firstChild.nodeType)e=e.firstChild;return e}).append(this)}return this},wrapInner:function(e){return b.isFunction(e)?this.each(function(t){b(this).wrapInner(e.call(this,t))}):this.each(function(){var t=b(this),n=t.contents();n.length?n.wrapAll(e):t.append(e)})},wrap:function(e){var t=b.isFunction(e);return this.each(function(n){b(this).wrapAll(t?e.call(this,n):e)})},unwrap:function(){return this.parent().each(function(){b.nodeName(this,"body")||b(this).replaceWith(this.childNodes)}).end()},append:function(){return this.domManip(arguments,!0,function(e){(1===this.nodeType||11===this.nodeType||9===this.nodeType)&&this.appendChild(e)})},prepend:function(){return this.domManip(arguments,!0,function(e){(1===this.nodeType||11===this.nodeType||9===this.nodeType)&&this.insertBefore(e,this.firstChild)})},before:function(){return this.domManip(arguments,!1,function(e){this.parentNode&&this.parentNode.insertBefore(e,this)})},after:function(){return this.domManip(arguments,!1,function(e){this.parentNode&&this.parentNode.insertBefore(e,this.nextSibling)})},remove:function(e,t){var n,r=0;for(;null!=(n=this[r]);r++)(!e||b.filter(e,[n]).length>0)&&(t||1!==n.nodeType||b.cleanData(Ot(n)),n.parentNode&&(t&&b.contains(n.ownerDocument,n)&&Mt(Ot(n,"script")),n.parentNode.removeChild(n)));return this},empty:function(){var e,t=0;for(;null!=(e=this[t]);t++){1===e.nodeType&&b.cleanData(Ot(e,!1));while(e.firstChild)e.removeChild(e.firstChild);e.options&&b.nodeName(e,"select")&&(e.options.length=0)}return this},clone:function(e,t){return e=null==e?!1:e,t=null==t?e:t,this.map(function(){return b.clone(this,e,t)})},html:function(e){return b.access(this,function(e){var n=this[0]||{},r=0,i=this.length;if(e===t)return 1===n.nodeType?n.innerHTML.replace(gt,""):t;if(!("string"!=typeof e||Tt.test(e)||!b.support.htmlSerialize&&mt.test(e)||!b.support.leadingWhitespace&&yt.test(e)||At[(bt.exec(e)||["",""])[1].toLowerCase()])){e=e.replace(vt,"<$1></$2>");try{for(;i>r;r++)n=this[r]||{},1===n.nodeType&&(b.cleanData(Ot(n,!1)),n.innerHTML=e);n=0}catch(o){}}n&&this.empty().append(e)},null,e,arguments.length)},replaceWith:function(e){var t=b.isFunction(e);return t||"string"==typeof e||(e=b(e).not(this).detach()),this.domManip([e],!0,function(e){var t=this.nextSibling,n=this.parentNode;n&&(b(this).remove(),n.insertBefore(e,t))})},detach:function(e){return this.remove(e,!0)},domManip:function(e,n,r){e=f.apply([],e);var i,o,a,s,u,l,c=0,p=this.length,d=this,h=p-1,g=e[0],m=b.isFunction(g);if(m||!(1>=p||"string"!=typeof g||b.support.checkClone)&&Ct.test(g))return this.each(function(i){var o=d.eq(i);m&&(e[0]=g.call(this,i,n?o.html():t)),o.domManip(e,n,r)});if(p&&(l=b.buildFragment(e,this[0].ownerDocument,!1,this),i=l.firstChild,1===l.childNodes.length&&(l=i),i)){for(n=n&&b.nodeName(i,"tr"),s=b.map(Ot(l,"script"),Ht),a=s.length;p>c;c++)o=l,c!==h&&(o=b.clone(o,!0,!0),a&&b.merge(s,Ot(o,"script"))),r.call(n&&b.nodeName(this[c],"table")?Lt(this[c],"tbody"):this[c],o,c);if(a)for(u=s[s.length-1].ownerDocument,b.map(s,qt),c=0;a>c;c++)o=s[c],kt.test(o.type||"")&&!b._data(o,"globalEval")&&b.contains(u,o)&&(o.src?b.ajax({url:o.src,type:"GET",dataType:"script",async:!1,global:!1,"throws":!0}):b.globalEval((o.text||o.textContent||o.innerHTML||"").replace(St,"")));l=i=null}return this}});function Lt(e,t){return e.getElementsByTagName(t)[0]||e.appendChild(e.ownerDocument.createElement(t))}function Ht(e){var t=e.getAttributeNode("type");return e.type=(t&&t.specified)+"/"+e.type,e}function qt(e){var t=Et.exec(e.type);return t?e.type=t[1]:e.removeAttribute("type"),e}function Mt(e,t){var n,r=0;for(;null!=(n=e[r]);r++)b._data(n,"globalEval",!t||b._data(t[r],"globalEval"))}function _t(e,t){if(1===t.nodeType&&b.hasData(e)){var n,r,i,o=b._data(e),a=b._data(t,o),s=o.events;if(s){delete a.handle,a.events={};for(n in s)for(r=0,i=s[n].length;i>r;r++)b.event.add(t,n,s[n][r])}a.data&&(a.data=b.extend({},a.data))}}function Ft(e,t){var n,r,i;if(1===t.nodeType){if(n=t.nodeName.toLowerCase(),!b.support.noCloneEvent&&t[b.expando]){i=b._data(t);for(r in i.events)b.removeEvent(t,r,i.handle);t.removeAttribute(b.expando)}"script"===n&&t.text!==e.text?(Ht(t).text=e.text,qt(t)):"object"===n?(t.parentNode&&(t.outerHTML=e.outerHTML),b.support.html5Clone&&e.innerHTML&&!b.trim(t.innerHTML)&&(t.innerHTML=e.innerHTML)):"input"===n&&Nt.test(e.type)?(t.defaultChecked=t.checked=e.checked,t.value!==e.value&&(t.value=e.value)):"option"===n?t.defaultSelected=t.selected=e.defaultSelected:("input"===n||"textarea"===n)&&(t.defaultValue=e.defaultValue)}}b.each({appendTo:"append",prependTo:"prepend",insertBefore:"before",insertAfter:"after",replaceAll:"replaceWith"},function(e,t){b.fn[e]=function(e){var n,r=0,i=[],o=b(e),a=o.length-1;for(;a>=r;r++)n=r===a?this:this.clone(!0),b(o[r])[t](n),d.apply(i,n.get());return this.pushStack(i)}});function Ot(e,n){var r,o,a=0,s=typeof e.getElementsByTagName!==i?e.getElementsByTagName(n||"*"):typeof e.querySelectorAll!==i?e.querySelectorAll(n||"*"):t;if(!s)for(s=[],r=e.childNodes||e;null!=(o=r[a]);a++)!n||b.nodeName(o,n)?s.push(o):b.merge(s,Ot(o,n));return n===t||n&&b.nodeName(e,n)?b.merge([e],s):s}function Bt(e){Nt.test(e.type)&&(e.defaultChecked=e.checked)}b.extend({clone:function(e,t,n){var r,i,o,a,s,u=b.contains(e.ownerDocument,e);if(b.support.html5Clone||b.isXMLDoc(e)||!mt.test("<"+e.nodeName+">")?o=e.cloneNode(!0):(Dt.innerHTML=e.outerHTML,Dt.removeChild(o=Dt.firstChild)),!(b.support.noCloneEvent&&b.support.noCloneChecked||1!==e.nodeType&&11!==e.nodeType||b.isXMLDoc(e)))for(r=Ot(o),s=Ot(e),a=0;null!=(i=s[a]);++a)r[a]&&Ft(i,r[a]);if(t)if(n)for(s=s||Ot(e),r=r||Ot(o),a=0;null!=(i=s[a]);a++)_t(i,r[a]);else _t(e,o);return r=Ot(o,"script"),r.length>0&&Mt(r,!u&&Ot(e,"script")),r=s=i=null,o},buildFragment:function(e,t,n,r){var i,o,a,s,u,l,c,p=e.length,f=dt(t),d=[],h=0;for(;p>h;h++)if(o=e[h],o||0===o)if("object"===b.type(o))b.merge(d,o.nodeType?[o]:o);else if(wt.test(o)){s=s||f.appendChild(t.createElement("div")),u=(bt.exec(o)||["",""])[1].toLowerCase(),c=At[u]||At._default,s.innerHTML=c[1]+o.replace(vt,"<$1></$2>")+c[2],i=c[0];while(i--)s=s.lastChild;if(!b.support.leadingWhitespace&&yt.test(o)&&d.push(t.createTextNode(yt.exec(o)[0])),!b.support.tbody){o="table"!==u||xt.test(o)?"<table>"!==c[1]||xt.test(o)?0:s:s.firstChild,i=o&&o.childNodes.length;while(i--)b.nodeName(l=o.childNodes[i],"tbody")&&!l.childNodes.length&&o.removeChild(l)
 }b.merge(d,s.childNodes),s.textContent="";while(s.firstChild)s.removeChild(s.firstChild);s=f.lastChild}else d.push(t.createTextNode(o));s&&f.removeChild(s),b.support.appendChecked||b.grep(Ot(d,"input"),Bt),h=0;while(o=d[h++])if((!r||-1===b.inArray(o,r))&&(a=b.contains(o.ownerDocument,o),s=Ot(f.appendChild(o),"script"),a&&Mt(s),n)){i=0;while(o=s[i++])kt.test(o.type||"")&&n.push(o)}return s=null,f},cleanData:function(e,t){var n,r,o,a,s=0,u=b.expando,l=b.cache,p=b.support.deleteExpando,f=b.event.special;for(;null!=(n=e[s]);s++)if((t||b.acceptData(n))&&(o=n[u],a=o&&l[o])){if(a.events)for(r in a.events)f[r]?b.event.remove(n,r):b.removeEvent(n,r,a.handle);l[o]&&(delete l[o],p?delete n[u]:typeof n.removeAttribute!==i?n.removeAttribute(u):n[u]=null,c.push(o))}}});var Pt,Rt,Wt,$t=/alpha\([^)]*\)/i,It=/opacity\s*=\s*([^)]*)/,zt=/^(top|right|bottom|left)$/,Xt=/^(none|table(?!-c[ea]).+)/,Ut=/^margin/,Vt=RegExp("^("+x+")(.*)$","i"),Yt=RegExp("^("+x+")(?!px)[a-z%]+$","i"),Jt=RegExp("^([+-])=("+x+")","i"),Gt={BODY:"block"},Qt={position:"absolute",visibility:"hidden",display:"block"},Kt={letterSpacing:0,fontWeight:400},Zt=["Top","Right","Bottom","Left"],en=["Webkit","O","Moz","ms"];function tn(e,t){if(t in e)return t;var n=t.charAt(0).toUpperCase()+t.slice(1),r=t,i=en.length;while(i--)if(t=en[i]+n,t in e)return t;return r}function nn(e,t){return e=t||e,"none"===b.css(e,"display")||!b.contains(e.ownerDocument,e)}function rn(e,t){var n,r,i,o=[],a=0,s=e.length;for(;s>a;a++)r=e[a],r.style&&(o[a]=b._data(r,"olddisplay"),n=r.style.display,t?(o[a]||"none"!==n||(r.style.display=""),""===r.style.display&&nn(r)&&(o[a]=b._data(r,"olddisplay",un(r.nodeName)))):o[a]||(i=nn(r),(n&&"none"!==n||!i)&&b._data(r,"olddisplay",i?n:b.css(r,"display"))));for(a=0;s>a;a++)r=e[a],r.style&&(t&&"none"!==r.style.display&&""!==r.style.display||(r.style.display=t?o[a]||"":"none"));return e}b.fn.extend({css:function(e,n){return b.access(this,function(e,n,r){var i,o,a={},s=0;if(b.isArray(n)){for(o=Rt(e),i=n.length;i>s;s++)a[n[s]]=b.css(e,n[s],!1,o);return a}return r!==t?b.style(e,n,r):b.css(e,n)},e,n,arguments.length>1)},show:function(){return rn(this,!0)},hide:function(){return rn(this)},toggle:function(e){var t="boolean"==typeof e;return this.each(function(){(t?e:nn(this))?b(this).show():b(this).hide()})}}),b.extend({cssHooks:{opacity:{get:function(e,t){if(t){var n=Wt(e,"opacity");return""===n?"1":n}}}},cssNumber:{columnCount:!0,fillOpacity:!0,fontWeight:!0,lineHeight:!0,opacity:!0,orphans:!0,widows:!0,zIndex:!0,zoom:!0},cssProps:{"float":b.support.cssFloat?"cssFloat":"styleFloat"},style:function(e,n,r,i){if(e&&3!==e.nodeType&&8!==e.nodeType&&e.style){var o,a,s,u=b.camelCase(n),l=e.style;if(n=b.cssProps[u]||(b.cssProps[u]=tn(l,u)),s=b.cssHooks[n]||b.cssHooks[u],r===t)return s&&"get"in s&&(o=s.get(e,!1,i))!==t?o:l[n];if(a=typeof r,"string"===a&&(o=Jt.exec(r))&&(r=(o[1]+1)*o[2]+parseFloat(b.css(e,n)),a="number"),!(null==r||"number"===a&&isNaN(r)||("number"!==a||b.cssNumber[u]||(r+="px"),b.support.clearCloneStyle||""!==r||0!==n.indexOf("background")||(l[n]="inherit"),s&&"set"in s&&(r=s.set(e,r,i))===t)))try{l[n]=r}catch(c){}}},css:function(e,n,r,i){var o,a,s,u=b.camelCase(n);return n=b.cssProps[u]||(b.cssProps[u]=tn(e.style,u)),s=b.cssHooks[n]||b.cssHooks[u],s&&"get"in s&&(a=s.get(e,!0,r)),a===t&&(a=Wt(e,n,i)),"normal"===a&&n in Kt&&(a=Kt[n]),""===r||r?(o=parseFloat(a),r===!0||b.isNumeric(o)?o||0:a):a},swap:function(e,t,n,r){var i,o,a={};for(o in t)a[o]=e.style[o],e.style[o]=t[o];i=n.apply(e,r||[]);for(o in t)e.style[o]=a[o];return i}}),e.getComputedStyle?(Rt=function(t){return e.getComputedStyle(t,null)},Wt=function(e,n,r){var i,o,a,s=r||Rt(e),u=s?s.getPropertyValue(n)||s[n]:t,l=e.style;return s&&(""!==u||b.contains(e.ownerDocument,e)||(u=b.style(e,n)),Yt.test(u)&&Ut.test(n)&&(i=l.width,o=l.minWidth,a=l.maxWidth,l.minWidth=l.maxWidth=l.width=u,u=s.width,l.width=i,l.minWidth=o,l.maxWidth=a)),u}):o.documentElement.currentStyle&&(Rt=function(e){return e.currentStyle},Wt=function(e,n,r){var i,o,a,s=r||Rt(e),u=s?s[n]:t,l=e.style;return null==u&&l&&l[n]&&(u=l[n]),Yt.test(u)&&!zt.test(n)&&(i=l.left,o=e.runtimeStyle,a=o&&o.left,a&&(o.left=e.currentStyle.left),l.left="fontSize"===n?"1em":u,u=l.pixelLeft+"px",l.left=i,a&&(o.left=a)),""===u?"auto":u});function on(e,t,n){var r=Vt.exec(t);return r?Math.max(0,r[1]-(n||0))+(r[2]||"px"):t}function an(e,t,n,r,i){var o=n===(r?"border":"content")?4:"width"===t?1:0,a=0;for(;4>o;o+=2)"margin"===n&&(a+=b.css(e,n+Zt[o],!0,i)),r?("content"===n&&(a-=b.css(e,"padding"+Zt[o],!0,i)),"margin"!==n&&(a-=b.css(e,"border"+Zt[o]+"Width",!0,i))):(a+=b.css(e,"padding"+Zt[o],!0,i),"padding"!==n&&(a+=b.css(e,"border"+Zt[o]+"Width",!0,i)));return a}function sn(e,t,n){var r=!0,i="width"===t?e.offsetWidth:e.offsetHeight,o=Rt(e),a=b.support.boxSizing&&"border-box"===b.css(e,"boxSizing",!1,o);if(0>=i||null==i){if(i=Wt(e,t,o),(0>i||null==i)&&(i=e.style[t]),Yt.test(i))return i;r=a&&(b.support.boxSizingReliable||i===e.style[t]),i=parseFloat(i)||0}return i+an(e,t,n||(a?"border":"content"),r,o)+"px"}function un(e){var t=o,n=Gt[e];return n||(n=ln(e,t),"none"!==n&&n||(Pt=(Pt||b("<iframe frameborder='0' width='0' height='0'/>").css("cssText","display:block !important")).appendTo(t.documentElement),t=(Pt[0].contentWindow||Pt[0].contentDocument).document,t.write("<!doctype html><html><body>"),t.close(),n=ln(e,t),Pt.detach()),Gt[e]=n),n}function ln(e,t){var n=b(t.createElement(e)).appendTo(t.body),r=b.css(n[0],"display");return n.remove(),r}b.each(["height","width"],function(e,n){b.cssHooks[n]={get:function(e,r,i){return r?0===e.offsetWidth&&Xt.test(b.css(e,"display"))?b.swap(e,Qt,function(){return sn(e,n,i)}):sn(e,n,i):t},set:function(e,t,r){var i=r&&Rt(e);return on(e,t,r?an(e,n,r,b.support.boxSizing&&"border-box"===b.css(e,"boxSizing",!1,i),i):0)}}}),b.support.opacity||(b.cssHooks.opacity={get:function(e,t){return It.test((t&&e.currentStyle?e.currentStyle.filter:e.style.filter)||"")?.01*parseFloat(RegExp.$1)+"":t?"1":""},set:function(e,t){var n=e.style,r=e.currentStyle,i=b.isNumeric(t)?"alpha(opacity="+100*t+")":"",o=r&&r.filter||n.filter||"";n.zoom=1,(t>=1||""===t)&&""===b.trim(o.replace($t,""))&&n.removeAttribute&&(n.removeAttribute("filter"),""===t||r&&!r.filter)||(n.filter=$t.test(o)?o.replace($t,i):o+" "+i)}}),b(function(){b.support.reliableMarginRight||(b.cssHooks.marginRight={get:function(e,n){return n?b.swap(e,{display:"inline-block"},Wt,[e,"marginRight"]):t}}),!b.support.pixelPosition&&b.fn.position&&b.each(["top","left"],function(e,n){b.cssHooks[n]={get:function(e,r){return r?(r=Wt(e,n),Yt.test(r)?b(e).position()[n]+"px":r):t}}})}),b.expr&&b.expr.filters&&(b.expr.filters.hidden=function(e){return 0>=e.offsetWidth&&0>=e.offsetHeight||!b.support.reliableHiddenOffsets&&"none"===(e.style&&e.style.display||b.css(e,"display"))},b.expr.filters.visible=function(e){return!b.expr.filters.hidden(e)}),b.each({margin:"",padding:"",border:"Width"},function(e,t){b.cssHooks[e+t]={expand:function(n){var r=0,i={},o="string"==typeof n?n.split(" "):[n];for(;4>r;r++)i[e+Zt[r]+t]=o[r]||o[r-2]||o[0];return i}},Ut.test(e)||(b.cssHooks[e+t].set=on)});var cn=/%20/g,pn=/\[\]$/,fn=/\r?\n/g,dn=/^(?:submit|button|image|reset|file)$/i,hn=/^(?:input|select|textarea|keygen)/i;b.fn.extend({serialize:function(){return b.param(this.serializeArray())},serializeArray:function(){return this.map(function(){var e=b.prop(this,"elements");return e?b.makeArray(e):this}).filter(function(){var e=this.type;return this.name&&!b(this).is(":disabled")&&hn.test(this.nodeName)&&!dn.test(e)&&(this.checked||!Nt.test(e))}).map(function(e,t){var n=b(this).val();return null==n?null:b.isArray(n)?b.map(n,function(e){return{name:t.name,value:e.replace(fn,"\r\n")}}):{name:t.name,value:n.replace(fn,"\r\n")}}).get()}}),b.param=function(e,n){var r,i=[],o=function(e,t){t=b.isFunction(t)?t():null==t?"":t,i[i.length]=encodeURIComponent(e)+"="+encodeURIComponent(t)};if(n===t&&(n=b.ajaxSettings&&b.ajaxSettings.traditional),b.isArray(e)||e.jquery&&!b.isPlainObject(e))b.each(e,function(){o(this.name,this.value)});else for(r in e)gn(r,e[r],n,o);return i.join("&").replace(cn,"+")};function gn(e,t,n,r){var i;if(b.isArray(t))b.each(t,function(t,i){n||pn.test(e)?r(e,i):gn(e+"["+("object"==typeof i?t:"")+"]",i,n,r)});else if(n||"object"!==b.type(t))r(e,t);else for(i in t)gn(e+"["+i+"]",t[i],n,r)}b.each("blur focus focusin focusout load resize scroll unload click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select submit keydown keypress keyup error contextmenu".split(" "),function(e,t){b.fn[t]=function(e,n){return arguments.length>0?this.on(t,null,e,n):this.trigger(t)}}),b.fn.hover=function(e,t){return this.mouseenter(e).mouseleave(t||e)};var mn,yn,vn=b.now(),bn=/\?/,xn=/#.*$/,wn=/([?&])_=[^&]*/,Tn=/^(.*?):[ \t]*([^\r\n]*)\r?$/gm,Nn=/^(?:about|app|app-storage|.+-extension|file|res|widget):$/,Cn=/^(?:GET|HEAD)$/,kn=/^\/\//,En=/^([\w.+-]+:)(?:\/\/([^\/?#:]*)(?::(\d+)|)|)/,Sn=b.fn.load,An={},jn={},Dn="*/".concat("*");try{yn=a.href}catch(Ln){yn=o.createElement("a"),yn.href="",yn=yn.href}mn=En.exec(yn.toLowerCase())||[];function Hn(e){return function(t,n){"string"!=typeof t&&(n=t,t="*");var r,i=0,o=t.toLowerCase().match(w)||[];if(b.isFunction(n))while(r=o[i++])"+"===r[0]?(r=r.slice(1)||"*",(e[r]=e[r]||[]).unshift(n)):(e[r]=e[r]||[]).push(n)}}function qn(e,n,r,i){var o={},a=e===jn;function s(u){var l;return o[u]=!0,b.each(e[u]||[],function(e,u){var c=u(n,r,i);return"string"!=typeof c||a||o[c]?a?!(l=c):t:(n.dataTypes.unshift(c),s(c),!1)}),l}return s(n.dataTypes[0])||!o["*"]&&s("*")}function Mn(e,n){var r,i,o=b.ajaxSettings.flatOptions||{};for(i in n)n[i]!==t&&((o[i]?e:r||(r={}))[i]=n[i]);return r&&b.extend(!0,e,r),e}b.fn.load=function(e,n,r){if("string"!=typeof e&&Sn)return Sn.apply(this,arguments);var i,o,a,s=this,u=e.indexOf(" ");return u>=0&&(i=e.slice(u,e.length),e=e.slice(0,u)),b.isFunction(n)?(r=n,n=t):n&&"object"==typeof n&&(a="POST"),s.length>0&&b.ajax({url:e,type:a,dataType:"html",data:n}).done(function(e){o=arguments,s.html(i?b("<div>").append(b.parseHTML(e)).find(i):e)}).complete(r&&function(e,t){s.each(r,o||[e.responseText,t,e])}),this},b.each(["ajaxStart","ajaxStop","ajaxComplete","ajaxError","ajaxSuccess","ajaxSend"],function(e,t){b.fn[t]=function(e){return this.on(t,e)}}),b.each(["get","post"],function(e,n){b[n]=function(e,r,i,o){return b.isFunction(r)&&(o=o||i,i=r,r=t),b.ajax({url:e,type:n,dataType:o,data:r,success:i})}}),b.extend({active:0,lastModified:{},etag:{},ajaxSettings:{url:yn,type:"GET",isLocal:Nn.test(mn[1]),global:!0,processData:!0,async:!0,contentType:"application/x-www-form-urlencoded; charset=UTF-8",accepts:{"*":Dn,text:"text/plain",html:"text/html",xml:"application/xml, text/xml",json:"application/json, text/javascript"},contents:{xml:/xml/,html:/html/,json:/json/},responseFields:{xml:"responseXML",text:"responseText"},converters:{"* text":e.String,"text html":!0,"text json":b.parseJSON,"text xml":b.parseXML},flatOptions:{url:!0,context:!0}},ajaxSetup:function(e,t){return t?Mn(Mn(e,b.ajaxSettings),t):Mn(b.ajaxSettings,e)},ajaxPrefilter:Hn(An),ajaxTransport:Hn(jn),ajax:function(e,n){"object"==typeof e&&(n=e,e=t),n=n||{};var r,i,o,a,s,u,l,c,p=b.ajaxSetup({},n),f=p.context||p,d=p.context&&(f.nodeType||f.jquery)?b(f):b.event,h=b.Deferred(),g=b.Callbacks("once memory"),m=p.statusCode||{},y={},v={},x=0,T="canceled",N={readyState:0,getResponseHeader:function(e){var t;if(2===x){if(!c){c={};while(t=Tn.exec(a))c[t[1].toLowerCase()]=t[2]}t=c[e.toLowerCase()]}return null==t?null:t},getAllResponseHeaders:function(){return 2===x?a:null},setRequestHeader:function(e,t){var n=e.toLowerCase();return x||(e=v[n]=v[n]||e,y[e]=t),this},overrideMimeType:function(e){return x||(p.mimeType=e),this},statusCode:function(e){var t;if(e)if(2>x)for(t in e)m[t]=[m[t],e[t]];else N.always(e[N.status]);return this},abort:function(e){var t=e||T;return l&&l.abort(t),k(0,t),this}};if(h.promise(N).complete=g.add,N.success=N.done,N.error=N.fail,p.url=((e||p.url||yn)+"").replace(xn,"").replace(kn,mn[1]+"//"),p.type=n.method||n.type||p.method||p.type,p.dataTypes=b.trim(p.dataType||"*").toLowerCase().match(w)||[""],null==p.crossDomain&&(r=En.exec(p.url.toLowerCase()),p.crossDomain=!(!r||r[1]===mn[1]&&r[2]===mn[2]&&(r[3]||("http:"===r[1]?80:443))==(mn[3]||("http:"===mn[1]?80:443)))),p.data&&p.processData&&"string"!=typeof p.data&&(p.data=b.param(p.data,p.traditional)),qn(An,p,n,N),2===x)return N;u=p.global,u&&0===b.active++&&b.event.trigger("ajaxStart"),p.type=p.type.toUpperCase(),p.hasContent=!Cn.test(p.type),o=p.url,p.hasContent||(p.data&&(o=p.url+=(bn.test(o)?"&":"?")+p.data,delete p.data),p.cache===!1&&(p.url=wn.test(o)?o.replace(wn,"$1_="+vn++):o+(bn.test(o)?"&":"?")+"_="+vn++)),p.ifModified&&(b.lastModified[o]&&N.setRequestHeader("If-Modified-Since",b.lastModified[o]),b.etag[o]&&N.setRequestHeader("If-None-Match",b.etag[o])),(p.data&&p.hasContent&&p.contentType!==!1||n.contentType)&&N.setRequestHeader("Content-Type",p.contentType),N.setRequestHeader("Accept",p.dataTypes[0]&&p.accepts[p.dataTypes[0]]?p.accepts[p.dataTypes[0]]+("*"!==p.dataTypes[0]?", "+Dn+"; q=0.01":""):p.accepts["*"]);for(i in p.headers)N.setRequestHeader(i,p.headers[i]);if(p.beforeSend&&(p.beforeSend.call(f,N,p)===!1||2===x))return N.abort();T="abort";for(i in{success:1,error:1,complete:1})N[i](p[i]);if(l=qn(jn,p,n,N)){N.readyState=1,u&&d.trigger("ajaxSend",[N,p]),p.async&&p.timeout>0&&(s=setTimeout(function(){N.abort("timeout")},p.timeout));try{x=1,l.send(y,k)}catch(C){if(!(2>x))throw C;k(-1,C)}}else k(-1,"No Transport");function k(e,n,r,i){var c,y,v,w,T,C=n;2!==x&&(x=2,s&&clearTimeout(s),l=t,a=i||"",N.readyState=e>0?4:0,r&&(w=_n(p,N,r)),e>=200&&300>e||304===e?(p.ifModified&&(T=N.getResponseHeader("Last-Modified"),T&&(b.lastModified[o]=T),T=N.getResponseHeader("etag"),T&&(b.etag[o]=T)),204===e?(c=!0,C="nocontent"):304===e?(c=!0,C="notmodified"):(c=Fn(p,w),C=c.state,y=c.data,v=c.error,c=!v)):(v=C,(e||!C)&&(C="error",0>e&&(e=0))),N.status=e,N.statusText=(n||C)+"",c?h.resolveWith(f,[y,C,N]):h.rejectWith(f,[N,C,v]),N.statusCode(m),m=t,u&&d.trigger(c?"ajaxSuccess":"ajaxError",[N,p,c?y:v]),g.fireWith(f,[N,C]),u&&(d.trigger("ajaxComplete",[N,p]),--b.active||b.event.trigger("ajaxStop")))}return N},getScript:function(e,n){return b.get(e,t,n,"script")},getJSON:function(e,t,n){return b.get(e,t,n,"json")}});function _n(e,n,r){var i,o,a,s,u=e.contents,l=e.dataTypes,c=e.responseFields;for(s in c)s in r&&(n[c[s]]=r[s]);while("*"===l[0])l.shift(),o===t&&(o=e.mimeType||n.getResponseHeader("Content-Type"));if(o)for(s in u)if(u[s]&&u[s].test(o)){l.unshift(s);break}if(l[0]in r)a=l[0];else{for(s in r){if(!l[0]||e.converters[s+" "+l[0]]){a=s;break}i||(i=s)}a=a||i}return a?(a!==l[0]&&l.unshift(a),r[a]):t}function Fn(e,t){var n,r,i,o,a={},s=0,u=e.dataTypes.slice(),l=u[0];if(e.dataFilter&&(t=e.dataFilter(t,e.dataType)),u[1])for(i in e.converters)a[i.toLowerCase()]=e.converters[i];for(;r=u[++s];)if("*"!==r){if("*"!==l&&l!==r){if(i=a[l+" "+r]||a["* "+r],!i)for(n in a)if(o=n.split(" "),o[1]===r&&(i=a[l+" "+o[0]]||a["* "+o[0]])){i===!0?i=a[n]:a[n]!==!0&&(r=o[0],u.splice(s--,0,r));break}if(i!==!0)if(i&&e["throws"])t=i(t);else try{t=i(t)}catch(c){return{state:"parsererror",error:i?c:"No conversion from "+l+" to "+r}}}l=r}return{state:"success",data:t}}b.ajaxSetup({accepts:{script:"text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"},contents:{script:/(?:java|ecma)script/},converters:{"text script":function(e){return b.globalEval(e),e}}}),b.ajaxPrefilter("script",function(e){e.cache===t&&(e.cache=!1),e.crossDomain&&(e.type="GET",e.global=!1)}),b.ajaxTransport("script",function(e){if(e.crossDomain){var n,r=o.head||b("head")[0]||o.documentElement;return{send:function(t,i){n=o.createElement("script"),n.async=!0,e.scriptCharset&&(n.charset=e.scriptCharset),n.src=e.url,n.onload=n.onreadystatechange=function(e,t){(t||!n.readyState||/loaded|complete/.test(n.readyState))&&(n.onload=n.onreadystatechange=null,n.parentNode&&n.parentNode.removeChild(n),n=null,t||i(200,"success"))},r.insertBefore(n,r.firstChild)},abort:function(){n&&n.onload(t,!0)}}}});var On=[],Bn=/(=)\?(?=&|$)|\?\?/;b.ajaxSetup({jsonp:"callback",jsonpCallback:function(){var e=On.pop()||b.expando+"_"+vn++;return this[e]=!0,e}}),b.ajaxPrefilter("json jsonp",function(n,r,i){var o,a,s,u=n.jsonp!==!1&&(Bn.test(n.url)?"url":"string"==typeof n.data&&!(n.contentType||"").indexOf("application/x-www-form-urlencoded")&&Bn.test(n.data)&&"data");return u||"jsonp"===n.dataTypes[0]?(o=n.jsonpCallback=b.isFunction(n.jsonpCallback)?n.jsonpCallback():n.jsonpCallback,u?n[u]=n[u].replace(Bn,"$1"+o):n.jsonp!==!1&&(n.url+=(bn.test(n.url)?"&":"?")+n.jsonp+"="+o),n.converters["script json"]=function(){return s||b.error(o+" was not called"),s[0]},n.dataTypes[0]="json",a=e[o],e[o]=function(){s=arguments},i.always(function(){e[o]=a,n[o]&&(n.jsonpCallback=r.jsonpCallback,On.push(o)),s&&b.isFunction(a)&&a(s[0]),s=a=t}),"script"):t});var Pn,Rn,Wn=0,$n=e.ActiveXObject&&function(){var e;for(e in Pn)Pn[e](t,!0)};function In(){try{return new e.XMLHttpRequest}catch(t){}}function zn(){try{return new e.ActiveXObject("Microsoft.XMLHTTP")}catch(t){}}b.ajaxSettings.xhr=e.ActiveXObject?function(){return!this.isLocal&&In()||zn()}:In,Rn=b.ajaxSettings.xhr(),b.support.cors=!!Rn&&"withCredentials"in Rn,Rn=b.support.ajax=!!Rn,Rn&&b.ajaxTransport(function(n){if(!n.crossDomain||b.support.cors){var r;return{send:function(i,o){var a,s,u=n.xhr();if(n.username?u.open(n.type,n.url,n.async,n.username,n.password):u.open(n.type,n.url,n.async),n.xhrFields)for(s in n.xhrFields)u[s]=n.xhrFields[s];n.mimeType&&u.overrideMimeType&&u.overrideMimeType(n.mimeType),n.crossDomain||i["X-Requested-With"]||(i["X-Requested-With"]="XMLHttpRequest");try{for(s in i)u.setRequestHeader(s,i[s])}catch(l){}u.send(n.hasContent&&n.data||null),r=function(e,i){var s,l,c,p;try{if(r&&(i||4===u.readyState))if(r=t,a&&(u.onreadystatechange=b.noop,$n&&delete Pn[a]),i)4!==u.readyState&&u.abort();else{p={},s=u.status,l=u.getAllResponseHeaders(),"string"==typeof u.responseText&&(p.text=u.responseText);try{c=u.statusText}catch(f){c=""}s||!n.isLocal||n.crossDomain?1223===s&&(s=204):s=p.text?200:404}}catch(d){i||o(-1,d)}p&&o(s,c,p,l)},n.async?4===u.readyState?setTimeout(r):(a=++Wn,$n&&(Pn||(Pn={},b(e).unload($n)),Pn[a]=r),u.onreadystatechange=r):r()},abort:function(){r&&r(t,!0)}}}});var Xn,Un,Vn=/^(?:toggle|show|hide)$/,Yn=RegExp("^(?:([+-])=|)("+x+")([a-z%]*)$","i"),Jn=/queueHooks$/,Gn=[nr],Qn={"*":[function(e,t){var n,r,i=this.createTween(e,t),o=Yn.exec(t),a=i.cur(),s=+a||0,u=1,l=20;if(o){if(n=+o[2],r=o[3]||(b.cssNumber[e]?"":"px"),"px"!==r&&s){s=b.css(i.elem,e,!0)||n||1;do u=u||".5",s/=u,b.style(i.elem,e,s+r);while(u!==(u=i.cur()/a)&&1!==u&&--l)}i.unit=r,i.start=s,i.end=o[1]?s+(o[1]+1)*n:n}return i}]};function Kn(){return setTimeout(function(){Xn=t}),Xn=b.now()}function Zn(e,t){b.each(t,function(t,n){var r=(Qn[t]||[]).concat(Qn["*"]),i=0,o=r.length;for(;o>i;i++)if(r[i].call(e,t,n))return})}function er(e,t,n){var r,i,o=0,a=Gn.length,s=b.Deferred().always(function(){delete u.elem}),u=function(){if(i)return!1;var t=Xn||Kn(),n=Math.max(0,l.startTime+l.duration-t),r=n/l.duration||0,o=1-r,a=0,u=l.tweens.length;for(;u>a;a++)l.tweens[a].run(o);return s.notifyWith(e,[l,o,n]),1>o&&u?n:(s.resolveWith(e,[l]),!1)},l=s.promise({elem:e,props:b.extend({},t),opts:b.extend(!0,{specialEasing:{}},n),originalProperties:t,originalOptions:n,startTime:Xn||Kn(),duration:n.duration,tweens:[],createTween:function(t,n){var r=b.Tween(e,l.opts,t,n,l.opts.specialEasing[t]||l.opts.easing);return l.tweens.push(r),r},stop:function(t){var n=0,r=t?l.tweens.length:0;if(i)return this;for(i=!0;r>n;n++)l.tweens[n].run(1);return t?s.resolveWith(e,[l,t]):s.rejectWith(e,[l,t]),this}}),c=l.props;for(tr(c,l.opts.specialEasing);a>o;o++)if(r=Gn[o].call(l,e,c,l.opts))return r;return Zn(l,c),b.isFunction(l.opts.start)&&l.opts.start.call(e,l),b.fx.timer(b.extend(u,{elem:e,anim:l,queue:l.opts.queue})),l.progress(l.opts.progress).done(l.opts.done,l.opts.complete).fail(l.opts.fail).always(l.opts.always)}function tr(e,t){var n,r,i,o,a;for(i in e)if(r=b.camelCase(i),o=t[r],n=e[i],b.isArray(n)&&(o=n[1],n=e[i]=n[0]),i!==r&&(e[r]=n,delete e[i]),a=b.cssHooks[r],a&&"expand"in a){n=a.expand(n),delete e[r];for(i in n)i in e||(e[i]=n[i],t[i]=o)}else t[r]=o}b.Animation=b.extend(er,{tweener:function(e,t){b.isFunction(e)?(t=e,e=["*"]):e=e.split(" ");var n,r=0,i=e.length;for(;i>r;r++)n=e[r],Qn[n]=Qn[n]||[],Qn[n].unshift(t)},prefilter:function(e,t){t?Gn.unshift(e):Gn.push(e)}});function nr(e,t,n){var r,i,o,a,s,u,l,c,p,f=this,d=e.style,h={},g=[],m=e.nodeType&&nn(e);n.queue||(c=b._queueHooks(e,"fx"),null==c.unqueued&&(c.unqueued=0,p=c.empty.fire,c.empty.fire=function(){c.unqueued||p()}),c.unqueued++,f.always(function(){f.always(function(){c.unqueued--,b.queue(e,"fx").length||c.empty.fire()})})),1===e.nodeType&&("height"in t||"width"in t)&&(n.overflow=[d.overflow,d.overflowX,d.overflowY],"inline"===b.css(e,"display")&&"none"===b.css(e,"float")&&(b.support.inlineBlockNeedsLayout&&"inline"!==un(e.nodeName)?d.zoom=1:d.display="inline-block")),n.overflow&&(d.overflow="hidden",b.support.shrinkWrapBlocks||f.always(function(){d.overflow=n.overflow[0],d.overflowX=n.overflow[1],d.overflowY=n.overflow[2]}));for(i in t)if(a=t[i],Vn.exec(a)){if(delete t[i],u=u||"toggle"===a,a===(m?"hide":"show"))continue;g.push(i)}if(o=g.length){s=b._data(e,"fxshow")||b._data(e,"fxshow",{}),"hidden"in s&&(m=s.hidden),u&&(s.hidden=!m),m?b(e).show():f.done(function(){b(e).hide()}),f.done(function(){var t;b._removeData(e,"fxshow");for(t in h)b.style(e,t,h[t])});for(i=0;o>i;i++)r=g[i],l=f.createTween(r,m?s[r]:0),h[r]=s[r]||b.style(e,r),r in s||(s[r]=l.start,m&&(l.end=l.start,l.start="width"===r||"height"===r?1:0))}}function rr(e,t,n,r,i){return new rr.prototype.init(e,t,n,r,i)}b.Tween=rr,rr.prototype={constructor:rr,init:function(e,t,n,r,i,o){this.elem=e,this.prop=n,this.easing=i||"swing",this.options=t,this.start=this.now=this.cur(),this.end=r,this.unit=o||(b.cssNumber[n]?"":"px")},cur:function(){var e=rr.propHooks[this.prop];return e&&e.get?e.get(this):rr.propHooks._default.get(this)},run:function(e){var t,n=rr.propHooks[this.prop];return this.pos=t=this.options.duration?b.easing[this.easing](e,this.options.duration*e,0,1,this.options.duration):e,this.now=(this.end-this.start)*t+this.start,this.options.step&&this.options.step.call(this.elem,this.now,this),n&&n.set?n.set(this):rr.propHooks._default.set(this),this}},rr.prototype.init.prototype=rr.prototype,rr.propHooks={_default:{get:function(e){var t;return null==e.elem[e.prop]||e.elem.style&&null!=e.elem.style[e.prop]?(t=b.css(e.elem,e.prop,""),t&&"auto"!==t?t:0):e.elem[e.prop]},set:function(e){b.fx.step[e.prop]?b.fx.step[e.prop](e):e.elem.style&&(null!=e.elem.style[b.cssProps[e.prop]]||b.cssHooks[e.prop])?b.style(e.elem,e.prop,e.now+e.unit):e.elem[e.prop]=e.now}}},rr.propHooks.scrollTop=rr.propHooks.scrollLeft={set:function(e){e.elem.nodeType&&e.elem.parentNode&&(e.elem[e.prop]=e.now)}},b.each(["toggle","show","hide"],function(e,t){var n=b.fn[t];b.fn[t]=function(e,r,i){return null==e||"boolean"==typeof e?n.apply(this,arguments):this.animate(ir(t,!0),e,r,i)}}),b.fn.extend({fadeTo:function(e,t,n,r){return this.filter(nn).css("opacity",0).show().end().animate({opacity:t},e,n,r)},animate:function(e,t,n,r){var i=b.isEmptyObject(e),o=b.speed(t,n,r),a=function(){var t=er(this,b.extend({},e),o);a.finish=function(){t.stop(!0)},(i||b._data(this,"finish"))&&t.stop(!0)};return a.finish=a,i||o.queue===!1?this.each(a):this.queue(o.queue,a)},stop:function(e,n,r){var i=function(e){var t=e.stop;delete e.stop,t(r)};return"string"!=typeof e&&(r=n,n=e,e=t),n&&e!==!1&&this.queue(e||"fx",[]),this.each(function(){var t=!0,n=null!=e&&e+"queueHooks",o=b.timers,a=b._data(this);if(n)a[n]&&a[n].stop&&i(a[n]);else for(n in a)a[n]&&a[n].stop&&Jn.test(n)&&i(a[n]);for(n=o.length;n--;)o[n].elem!==this||null!=e&&o[n].queue!==e||(o[n].anim.stop(r),t=!1,o.splice(n,1));(t||!r)&&b.dequeue(this,e)})},finish:function(e){return e!==!1&&(e=e||"fx"),this.each(function(){var t,n=b._data(this),r=n[e+"queue"],i=n[e+"queueHooks"],o=b.timers,a=r?r.length:0;for(n.finish=!0,b.queue(this,e,[]),i&&i.cur&&i.cur.finish&&i.cur.finish.call(this),t=o.length;t--;)o[t].elem===this&&o[t].queue===e&&(o[t].anim.stop(!0),o.splice(t,1));for(t=0;a>t;t++)r[t]&&r[t].finish&&r[t].finish.call(this);delete n.finish})}});function ir(e,t){var n,r={height:e},i=0;for(t=t?1:0;4>i;i+=2-t)n=Zt[i],r["margin"+n]=r["padding"+n]=e;return t&&(r.opacity=r.width=e),r}b.each({slideDown:ir("show"),slideUp:ir("hide"),slideToggle:ir("toggle"),fadeIn:{opacity:"show"},fadeOut:{opacity:"hide"},fadeToggle:{opacity:"toggle"}},function(e,t){b.fn[e]=function(e,n,r){return this.animate(t,e,n,r)}}),b.speed=function(e,t,n){var r=e&&"object"==typeof e?b.extend({},e):{complete:n||!n&&t||b.isFunction(e)&&e,duration:e,easing:n&&t||t&&!b.isFunction(t)&&t};return r.duration=b.fx.off?0:"number"==typeof r.duration?r.duration:r.duration in b.fx.speeds?b.fx.speeds[r.duration]:b.fx.speeds._default,(null==r.queue||r.queue===!0)&&(r.queue="fx"),r.old=r.complete,r.complete=function(){b.isFunction(r.old)&&r.old.call(this),r.queue&&b.dequeue(this,r.queue)},r},b.easing={linear:function(e){return e},swing:function(e){return.5-Math.cos(e*Math.PI)/2}},b.timers=[],b.fx=rr.prototype.init,b.fx.tick=function(){var e,n=b.timers,r=0;for(Xn=b.now();n.length>r;r++)e=n[r],e()||n[r]!==e||n.splice(r--,1);n.length||b.fx.stop(),Xn=t},b.fx.timer=function(e){e()&&b.timers.push(e)&&b.fx.start()},b.fx.interval=13,b.fx.start=function(){Un||(Un=setInterval(b.fx.tick,b.fx.interval))},b.fx.stop=function(){clearInterval(Un),Un=null},b.fx.speeds={slow:600,fast:200,_default:400},b.fx.step={},b.expr&&b.expr.filters&&(b.expr.filters.animated=function(e){return b.grep(b.timers,function(t){return e===t.elem}).length}),b.fn.offset=function(e){if(arguments.length)return e===t?this:this.each(function(t){b.offset.setOffset(this,e,t)});var n,r,o={top:0,left:0},a=this[0],s=a&&a.ownerDocument;if(s)return n=s.documentElement,b.contains(n,a)?(typeof a.getBoundingClientRect!==i&&(o=a.getBoundingClientRect()),r=or(s),{top:o.top+(r.pageYOffset||n.scrollTop)-(n.clientTop||0),left:o.left+(r.pageXOffset||n.scrollLeft)-(n.clientLeft||0)}):o},b.offset={setOffset:function(e,t,n){var r=b.css(e,"position");"static"===r&&(e.style.position="relative");var i=b(e),o=i.offset(),a=b.css(e,"top"),s=b.css(e,"left"),u=("absolute"===r||"fixed"===r)&&b.inArray("auto",[a,s])>-1,l={},c={},p,f;u?(c=i.position(),p=c.top,f=c.left):(p=parseFloat(a)||0,f=parseFloat(s)||0),b.isFunction(t)&&(t=t.call(e,n,o)),null!=t.top&&(l.top=t.top-o.top+p),null!=t.left&&(l.left=t.left-o.left+f),"using"in t?t.using.call(e,l):i.css(l)}},b.fn.extend({position:function(){if(this[0]){var e,t,n={top:0,left:0},r=this[0];return"fixed"===b.css(r,"position")?t=r.getBoundingClientRect():(e=this.offsetParent(),t=this.offset(),b.nodeName(e[0],"html")||(n=e.offset()),n.top+=b.css(e[0],"borderTopWidth",!0),n.left+=b.css(e[0],"borderLeftWidth",!0)),{top:t.top-n.top-b.css(r,"marginTop",!0),left:t.left-n.left-b.css(r,"marginLeft",!0)}}},offsetParent:function(){return this.map(function(){var e=this.offsetParent||o.documentElement;while(e&&!b.nodeName(e,"html")&&"static"===b.css(e,"position"))e=e.offsetParent;return e||o.documentElement})}}),b.each({scrollLeft:"pageXOffset",scrollTop:"pageYOffset"},function(e,n){var r=/Y/.test(n);b.fn[e]=function(i){return b.access(this,function(e,i,o){var a=or(e);return o===t?a?n in a?a[n]:a.document.documentElement[i]:e[i]:(a?a.scrollTo(r?b(a).scrollLeft():o,r?o:b(a).scrollTop()):e[i]=o,t)},e,i,arguments.length,null)}});function or(e){return b.isWindow(e)?e:9===e.nodeType?e.defaultView||e.parentWindow:!1}b.each({Height:"height",Width:"width"},function(e,n){b.each({padding:"inner"+e,content:n,"":"outer"+e},function(r,i){b.fn[i]=function(i,o){var a=arguments.length&&(r||"boolean"!=typeof i),s=r||(i===!0||o===!0?"margin":"border");return b.access(this,function(n,r,i){var o;return b.isWindow(n)?n.document.documentElement["client"+e]:9===n.nodeType?(o=n.documentElement,Math.max(n.body["scroll"+e],o["scroll"+e],n.body["offset"+e],o["offset"+e],o["client"+e])):i===t?b.css(n,r,s):b.style(n,r,i,s)},n,a?i:t,a,null)}})}),e.jQuery=e.$=b,"function"==typeof define&&define.amd&&define.amd.jQuery&&define("jquery",[],function(){return b})})(window);
 /* Highcharts JS v3.0.2 (2013-06-05) (c) 2009-2013 Torstein HÃnsi License: www.highcharts.com/license */
 eval(function(p,a,c,k,e,d){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--){d[e(c)]=k[c]||e(c)}k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1};while(c--){if(k[c]){p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c])}}return p}('(1b(){1b v(a,b){1c c;a||(a={});1k(c in b)a[c]=b[c];1d a}1b x(){1c a,b=2L.1h,c={},d=1b(a,b){1c c,h;1k(h in b)b.kq(h)&&(c=b[h],3q a!=="67"&&(a={}),a[h]=c&&3q c==="67"&&g7.1w.7g.1Y(c)!=="[67 5B]"&&3q c.k6!=="6V"?d(a[h]||{},c):b[h]);1d a};1k(a=0;a<b;a++)c=d(c,2L[a]);1d c}1b u(a,b){1d iO(a,b||10)}1b fa(a){1d 3q a==="dZ"}1b V(a){1d 3q a==="67"}1b 4V(a){1d g7.1w.7g.1Y(a)==="[67 5B]"}1b 5G(a){1d 3q a==="6V"}1b ka(a){1d I.8e(a)/I.cO}1b da(a){1d I.6B(10,a)}1b ga(a,b){1k(1c c=a.1h;c--;)if(a[c]===b){a.2X(c,1);3R}}1b r(a){1d a!==y&&a!==1g}1b A(a,b,c){1c d,e;if(fa(b))r(c)?a.bS(b,c):a&&a.gi&&(e=a.gi(b));1m if(r(b)&&V(b))1k(d in b)a.bS(d,b[d]);1d e}1b ha(a){1d 4V(a)?a:[a]}1b o(){1c a=2L,b,c,d=a.1h;1k(b=0;b<d;b++)if(c=a[b],3q c!=="kg"&&c!==1g)1d c}1b L(a,b){if(5c&&b&&b.1T!==y)b.ei="jy(1T="+b.1T*36+")";v(a.1p,b)}1b U(a,b,c,d,e){a=z.2l(a);b&&v(a,b);e&&L(a,{2Q:0,jC:S,7q:0});c&&L(a,c);d&&d.2x(a);1d a}1b ea(a,b){1c c=1b(){};c.1w=2f a;v(c.1w,b);1d c}1b 4K(a,b,c,d){1c e=N.5u,f=b===-1?((a||0).7g().2p(".")[1]||"").1h:3v(b=Q(b))?2:b,b=c===3Z 0?e.b4:c,d=d===3Z 0?e.cT:d,e=a<0?"-":"",c=fJ(u(a=Q(+a||0).fC(f))),g=c.1h>3?c.1h%3:0;1d e+(g?c.61(0,g)+d:"")+c.61(g).1J(/(\\d{3})(?=\\d)/g,"$1"+d)+(f?b+Q(a-c).fC(f).3t(2):"")}1b 4n(a,b){1d 5B((b||2)+1-fJ(a).1h).2q(0)+a}1b aQ(a,b,c){1c d=a[b];a[b]=1b(){1c a=5B.1w.3t.1Y(2L);a.bF(d);1d c.2o(1a,a)}}1b 34(a,b){1k(1c c="{",d=!1,e,f,g,h,i,j=[];(c=a.3H(c))!==-1;){e=a.3t(0,c);if(d){f=e.2p(":");g=f.3u().2p(".");i=g.1h;e=b;1k(h=0;h<i;h++)e=e[g[h]];if(f.1h)f=f.2q(":"),g=/\\.([0-9])/,h=N.5u,i=3Z 0,/f$/.2i(f)?(i=(i=f.9b(g))?i[1]:-1,e=4K(e,i,h.b4,f.3H(",")>-1?h.cT:"")):e=7X(f,e)}j.1o(e);a=a.3t(c+1);c=(d=!d)?"}":"{"}j.1o(a);1d j.2q("")}1b ib(a,b,c,d){1c e,c=o(c,1);e=a/c;b||(b=[1,2,2.5,5,10],d&&d.jk===!1&&(c===1?b=[1,2,5,10]:c<=0.1&&(b=[1/c])));1k(d=0;d<b.1h;d++)if(a=b[d],e<=(b[d]+(b[d+1]||b[d]))/2)3R;a*=c;1d a}1b cJ(a,b){1c c=b||[[aJ,[1,2,5,10,20,25,50,36,jN,8x]],[jb,[1,2,5,10,15,30]],[6Q,[1,2,5,10,15,30]],[6E,[1,2,3,4,6,8,12]],[oa,[1,2]],[6N,[1,2]],[5Q,[1,2,3,4,6]],[4R,1g]],d=c[c.1h-1],e=E[d[0]],f=d[1],g;1k(g=0;g<c.1h;g++)if(d=c[g],e=E[d[0]],f=d[1],c[g+1]&&a<=(e*f[f.1h-1]+E[c[g+1][0]])/2)3R;e===E[4R]&&a<5*e&&(f=[1,2,5]);e===E[4R]&&a<5*e&&(f=[1,2,5]);c=ib(a/e,f);1d{gO:e,gX:c,h3:d[0]}}1b cN(a,b,c,d){1c e=[],f={},g=N.6I.cm,h,i=2f 6h(b),j=a.gO,k=a.gX;if(r(b)){j>=E[jb]&&(i.m3(0),i.mg(j>=E[6Q]?0:k*T(i.i5()/k)));if(j>=E[6Q])i[dL](j>=E[6E]?0:k*T(i[kb]()/ k)); if (j >= E[6E]) i[dP](j >= E[oa] ? 0 : k * T(i[lb]()/k));if(j>=E[oa])i[mb](j>=E[5Q]?1:k*T(i[6C]()/ k)); j >= E[5Q] && (i[cp](j >= E[4R] ? 0 : k * T(i[6M]() /k)),h=i[6W]());j>=E[4R]&&(h-=h%k,i[aM](h));if(j===E[6N])i[mb](i[6C]()-i[nb]()+o(d,1));b=1;h=i[6W]();1k(1c d=i.fg(),m=i[6M](),l=i[6C](),p=g?0:(aC+i.mj()*i2)%aC;d<c;)e.1o(d),j===E[4R]?d=6J(h+b*k,0):j===E[5Q]?d=6J(h,m+b*k):!g&&(j===E[oa]||j===E[6N])?d=6J(h,m,l+b*k*(j===E[oa]?1:7)):d+=j*k,b++;e.1o(d);n(ob(e,1b(a){1d j<=E[6E]&&a%E[oa]===p}),1b(a){f[a]=oa})}e.h6=v(a,{h7:f,mi:j*k});1d e}1b bc(){1a.2b=1a.1r=0}1b cV(a,b){1c c=a.1h,d,e;1k(e=0;e<c;e++)a[e].8p=e;a.5Y(1b(a,c){d=b(a,c);1d d===0?a.8p-c.8p:d});1k(e=0;e<c;e++)29 a[e].8p}1b 4X(a){1k(1c b=a.1h,c=a[0];b--;)a[b]<c&&(c=a[b]);1d c}1b pa(a){1k(1c b=a.1h,c=a[0];b--;)a[b]>c&&(c=a[b]);1d c}1b 5j(a,b){1k(1c c in a)a[c]&&a[c]!==b&&a[c].1t&&a[c].1t(),29 a[c]}1b 6e(a){$a||($a=U(4C));a&&$a.2x(a);$a.4s=""}1b 40(a,b){1c c="3F lJ #"+a+": 7s.2j.62/lx/"+a;if(b)lr c;1m O.eu&&eu.8e(c)}1b ia(a){1d 7L(a.gZ(14))}1b 4Y(a,b){4F=o(a,b.2W)}1b aw(){1c a=N.6I.cm,b=a?"kZ":"2S",c=a?"ki":"b6";6J=a?6h.lO:1b(a,b,c,g,h,i){1d(2f 6h(a,b,o(c,1),o(g,0),o(h,0),o(i,0))).fg()};kb=b+"fr";lb=b+"fs";nb=b+"my";6C=b+"6h";6M=b+"fq";6W=b+"fl";dL=c+"fr";dP=c+"fs";mb=c+"6h";cp=c+"fq";aM=c+"fl"}1b 4l(){}1b 5k(a,b,c,d){1a.2e=a;1a.3a=b;1a.1F=c||"";1a.3A=!0;!c&&!d&&1a.c5()}1b pb(a,b){1a.2e=a;if(b)1a.1e=b,1a.id=b.id}1b cw(a,b,c,d,e,f){1c g=a.1j.1R;1a.2e=a;1a.gq=c;1a.1e=b;1a.x=d;1a.cr=e;1a.6X=f==="6X";1a.91={1y:b.1y||(g?c?"1z":"2a":"1Q"),3c:b.3c||(g?"4f":c?"3m":"1H"),y:o(b.y,g?4:c?14:-6),x:o(b.x,g?c?-6:6:0)};1a.3B=b.3B||(g?c?"2a":"1z":"1Q")}1b ab(){1a.1K.2o(1a,2L)}1b 9l(){1a.1K.2o(1a,2L)}1b 9v(a,b){1a.1K(a,b)}1b 9w(a,b){1a.1K(a,b)}1b 9G(){1a.1K.2o(1a,2L)}1c y,z=m0,O=jL,I=7h,t=I.b3,T=I.k1,ja=I.k4,q=I.1x,K=I.1u,Q=I.jl,Y=I.jF,ca=I.km,5E=I.k9,bb=5E*2/i9,4Q=jH.mu,cz=O.lH,5c=/lk/i.2i(4Q)&&!cz,cb=z.mf===8,db=/g6/.2i(4Q),eb=/iL/.2i(4Q),bH=/(mc|mn|lQ lP)/.2i(4Q),4j="66://7s.bv.bw/lZ/6R",Z=!!z.6p&&!!z.6p(4j,"6R").jS,gj=eb&&iO(4Q.2p("iL/")[1],10)<4,$=!Z&&!5c&&!!z.2l("aR").jX,64,fb=z.kA.ap!==y,bJ={},8U=0,$a,N,7X,4F,9N,E,48=1b(){},4L=[],4C="97",S="kO",ee="44(e6,e6,e6,"+(Z?1.kN-4:0.kK)+")",aJ="c3",jb="c4",6Q="cD",6E="cE",oa="89",6N="cF",5Q="cG",4R="cC",bO="1q-1f",6J,kb,lb,nb,6C,6M,6W,dL,dP,mb,cp,aM,aa={};O.3F=O.3F?40(16,!0):{};7X=1b(a,b,c){if(!r(b)||3v(b))1d"kt ks";1c a=o(a,"%Y-%m-%d %H:%M:%S"),d=2f 6h(b),e,f=d[lb](),g=d[nb](),h=d[6C](),i=d[6M](),j=d[6W](),k=N.5u,m=k.jc,d=v({a:m[g].61(0,3),A:m[g],d:4n(h),e:h,b:k.iT[i],B:k.hK[i],m:4n(i+1),y:j.7g().61(2,2),Y:j,H:4n(f),I:4n(f%12||12),l:f%12||12,M:4n(d[kb]()),p:f<12?"kc":"ke",P:f<12?"am":"pm",S:4n(d.i5()),L:4n(t(b%3E),3)},3F.kL);1k(e in d)1k(;a.3H("%"+e)!==-1;)a=a.1J("%"+e,3q d[e]==="1b"?d[e](b):d[e]);1d c?a.61(0,1).kJ()+a.61(1):a};bc.1w={fe:1b(a){if(1a.1r>=a)1a.1r=0},eh:1b(a){if(1a.2b>=a)1a.2b=0}};E=1b(){1k(1c a=0,b=2L,c=b.1h,d={};a<c;a++)d[b[a++]]=b[a];1d d}(aJ,1,jb,3E,6Q,i2,6E,kI,oa,aC,6N,kE,5Q,kT,4R,jt);9N={1K:1b(a,b,c){1c b=b||"",d=a.3u,e=b.3H("C")>-1,f=e?7:3,g,b=b.2p(" "),c=[].2g(c),h,i,j=1b(a){1k(g=a.1h;g--;)a[g]==="M"&&a.2X(g+1,0,a[g+1],a[g+2],a[g+1],a[g+2])};e&&(j(b),j(c));a.eA&&(h=b.2X(b.1h-6,6),i=c.2X(c.1h-6,6));if(d<=c.1h/f)1k(;d--;)c=[].2g(c).2X(0,f).2g(c);a.3u=0;if(b.1h)1k(a=c.1h;b.1h<a;)d=[].2g(b).2X(b.1h-f,f),e&&(d[f-6]=d[f-2],d[f-5]=d[f-1]),b=b.2g(d);h&&(b=b.2g(h),c=c.2g(i));1d[b,c]},5h:1b(a,b,c,d){1c e=[],f=a.1h;if(c===1)e=d;1m if(f===b.1h&&c<1)1k(;f--;)d=7L(a[f]),e[f]=3v(d)?a[f]:c*7L(b[f]-d)+d;1m e=b;1d e}};(1b(a){O.b2=O.b2||a&&{1K:1b(b){1c c=a.fx,d=c.5h,e,f=a.jp,g=f&&f.jo;e=a.jG.1T;a.fT(a.gh,{jW:1b(a,b,c,d,e){1d-d*(b/=e)*(b-2)+c}});a.7t(["aU","iQ","1f","1l","1T"],1b(a,b){1c e=d,k,m;b==="aU"?e=c.1w:b==="iQ"&&f&&(e=g[b],b="b6");(k=e[b])&&(e[b]=1b(c){c=a?c:1a;m=c.iF;1d m.1i?m.1i(c.k2,b==="aU"?y:c.cl):k.2o(1a,2L)})});aQ(e,"2S",1b(a,b,c){1d b.1i?b.1T||0:a.1Y(1a,b,c)});e=1b(a){1c c=a.iF,d;if(!a.iy)d=b.1K(c,c.d,c.b0),a.3l=d[0],a.37=d[1],a.iy=!0;c.1i("d",b.5h(a.3l,a.37,a.3a,c.b0))};f?g.d={b6:e}:d.d=e;1a.7t=5B.1w.iv?1b(a,b){1d 5B.1w.iv.1Y(a,b)}:1b(a,b){1k(1c c=0,d=a.1h;c<d;c++)if(b.1Y(a[c],a[c],c,a)===!1)1d c};a.fn.2j=1b(){1c a="cv",b=2L,c,d;fa(b[0])&&(a=b[0],b=5B.1w.3t.1Y(b,1));c=b[0];if(c!==y)c.1j=c.1j||{},c.1j.3P=1a[0],2f 3F[a](c,b[1]),d=1a;c===y&&(d=4L[A(1a[0],"1V-2j-1j")]);1d d}},bg:a.bg,af:a.af,hx:1b(b,c){1d a(b)[c]()},a5:a.a5,bE:1b(a,c){1k(1c d=[],e=0,f=a.1h;e<f;e++)d[e]=c.1Y(a[e],a[e],e,a);1d d},2Y:1b(b){1d a(b).2Y()},bP:1b(b,c,d){a(b).jQ(c,d)},bM:1b(b,c,d){1c e=z.iA?"iA":"hV";z[e]&&b&&!b[e]&&(b[e]=1b(){});a(b).kD(c,d)},hj:1b(b,c,d,e){1c f=a.kU(c),g="lX"+c,h;!5c&&d&&(29 d.m1,29 d.m5);v(f,d);b[c]&&(b[g]=b[c],b[c]=1g);a.7t(["6t","m4"],1b(a,b){1c c=f[b];f[b]=1b(){gK{c.1Y(f)}gL(a){b==="6t"&&(h=!0)}}});a(b).aA(f);b[g]&&(b[c]=b[g],b[g]=1g);e&&!f.m8()&&!h&&e(f)},hm:1b(a){1c c=a.as||a;if(c.5z===y)c.5z=a.5z,c.7I=a.7I;1d c},1B:1b(b,c,d){1c e=a(b);if(!b.1p)b.1p={};if(c.d)b.b0=c.d,c.d=1;e.5w();e.1B(c,d)},5w:1b(b){a(b).5w()}}})(O.mq);1c W=O.b2,M=W||{};W&&W.1K.1Y(W,9N);1c gb=M.hx,h5=M.bg,la=M.af,n=M.7t,ob=M.a5,j7=M.2Y,59=M.bE,J=M.bP,ba=M.bM,D=M.hj,ah=M.hm,96=M.1B,6i=M.5w,M={1N:!0,1y:"1Q",x:0,y:15,1p:{1r:"#l9",3b:"4x",2z:"h0",7K:"li"}};N={74:"#l5,#lB,#lz,#lE,#lG,#ly,#lw,#lu,#jO,#k0".2p(","),4q:["4i","fZ","bA","6z","6z-7C"],5u:{6f:"ju...",hK:"kM,jM,l3,lv,iU,ln,lo,lF,lI,lA,l1,l7".2p(","),iT:"ld,mk,m9,ml,iU,mt,mp,lR,lS,lU,lN,jI".2p(","),jc:"k3,jq,kC,kB,ku,ko,kn".2p(","),b4:".",ek:"k,M,G,T,P,E".2p(","),iJ:"eY 46",iK:"eY 46 kp 1:1",cT:","},6I:{cm:!0,hU:"66://eV.2j.62/3.0.2/kk/aR-k7.js",fS:"66://eV.2j.62/3.0.2/kh/9R-kw-bo.kS"},1j:{3o:"#kP",3S:5,dv:"6Y",dn:!0,8O:10,8A:10,8P:15,8Q:10,1p:{5Z:\'"f3 kz", "f3 kG jj", jm, jU, jY, jT-jK\',2z:"c6"},5F:"#7r",iP:"#9k",6a:{iI:{1D:20},2F:{1y:"2a",x:-10,y:10}}},1W:{1C:"cv 1W",1y:"1Q",y:15,1p:{1r:"#ci",2z:"jR"}},4t:{1C:"",1y:"1Q",y:30,1p:{1r:"#gC"}},dm:{6Y:{d6:!1,hS:!1,2W:{4B:3E},39:{},2N:2,2k:{1N:!0,2N:0,4m:4,6y:"#7r",3N:{2V:{1N:!0},2u:{78:"#7r",6y:"#hL",2N:2}}},28:{39:{}},4S:x(M,{1N:!1,5g:1b(){1d 4K(1a.y,-1)},3c:"3m",y:0}),d4:lY,3C:0,aS:!0,3N:{2V:{2k:{}},2u:{2k:{}}},6r:!0}},2y:{1p:{2F:"42",1r:"#m2"}},3k:{1N:!0,1y:"1Q",aZ:"aV",8c:1b(){1d 1a.38},3d:1,3o:"#ft",3S:5,aX:{hs:"#ci",ht:"#eQ"},1Z:!1,7w:{3b:"3w",1r:"#ci",2z:"c6"},hk:{1r:"#lL"},7y:{1r:"#eQ"},hn:{2F:"42",1f:"f4",1l:"f4"},9u:16,a2:5,3c:"3m",x:0,y:0,1W:{1p:{94:"92"}}},6f:{iG:{94:"92",2F:"aP",1H:"mo"},1p:{2F:"42",5F:"mr",1T:0.5,3B:"1Q"}},2H:{1N:!0,2W:Z,5F:"44(5S, 5S, 5S, .85)",3d:1,3S:3,8a:{c3:"%Y-%m-%d %H:%M:%S.%L",c4:"%Y-%m-%d %H:%M:%S",cD:"%Y-%m-%d %H:%M",cE:"%Y-%m-%d %H:%M",89:"%Y-%m-%d %H:%M",cF:"mv bh %A, %b %e, %Y",cG:"%Y-%m-%d",cC:"%Y-%m-%d %H:%M"},dY:\'<2O 1p="9V-6A: im">{28.6L}</2O><br/>\',aN:\'<2O 1p="1r:{1n.1r}">{1n.38}</2O>: <b>{28.y}</b><br/>\',1Z:!0,gz:bH?25:10,1p:{1r:"#mm",3b:"4x",2z:"c6",2Q:"me",bN:"g5"}},6H:{1N:!0,1C:"md @ lK",4r:"66://7s.lc.62",2F:{1y:"2a",x:-10,3c:"3m",y:-10},1p:{3b:"3w",1r:"#ft",2z:"l6"}}};1c X=N.dm,W=X.6Y;aw();1c ma=1b(a){1c b=[],c,d;(1b(a){a&&a.2J?d=59(a.2J,1b(a){1d ma(a[1])}):(c=/44\\(\\s*([0-9]{1,3})\\s*,\\s*([0-9]{1,3})\\s*,\\s*([0-9]{1,3})\\s*,\\s*([0-9]?(?:\\.[0-9]+)?)\\s*\\)/.cf(a))?b=[u(c[1]),u(c[2]),u(c[3]),7L(c[4],10)]:(c=/#([a-fA-cg-9]{2})([a-fA-cg-9]{2})([a-fA-cg-9]{2})/.cf(a))?b=[u(c[1],16),u(c[2],16),u(c[3],16),1]:(c=/56\\(\\s*([0-9]{1,3})\\s*,\\s*([0-9]{1,3})\\s*,\\s*([0-9]{1,3})\\s*\\)/.cf(a))&&(b=[u(c[1]),u(c[2]),u(c[3]),1])})(a);1d{2S:1b(c){1c f;d?(f=x(a),f.2J=[].2g(f.2J),n(d,1b(a,b){f.2J[b]=[f.2J[b][0],a.2S(c)]})):f=b&&!3v(b[0])?c==="56"?"56("+b[0]+","+b[1]+","+b[2]+")":c==="a"?b[3]:"44("+b.2q(",")+")":a;1d f},9f:1b(a){if(d)n(d,1b(b){b.9f(a)});1m if(5G(a)&&a!==0){1c c;1k(c=0;c<3;c++)b[c]+=u(a*5S),b[c]<0&&(b[c]=0),b[c]>5S&&(b[c]=5S)}1d 1a},44:b,ew:1b(a){b[3]=a;1d 1a}}};4l.1w={1K:1b(a,b){1a.1A=b==="2O"?U(b):z.6p(4j,b);1a.1v=a;1a.5s={}},1T:1,1B:1b(a,b,c){b=o(b,4F,!0);6i(1a);if(b){b=x(b);if(c)b.7f=c;96(1a,a,b)}1m 1a.1i(a),c&&c()},1i:1b(a,b){1c c,d,e,f,g=1a.1A,h=g.84.8J(),i=1a.1v,j,k=1a.5s,m=1a.6u,l,p,s=1a;fa(a)&&r(b)&&(c=a,a={},a[c]=b);if(fa(a))c=a,h==="4i"?c={x:"cx",y:"cy"}[c]||c:c==="5t"&&(c="1q-1f"),s=A(g,c)||1a[c]||0,c!=="d"&&c!=="2s"&&(s=7L(s));1m{1k(c in a)if(j=!1,d=a[c],e=k[c]&&k[c].1Y(1a,d,c),e!==!1){e!==y&&(d=e);if(c==="d")d&&d.2q&&(d=d.2q(" ")),/(lm| {2}|^$)/.2i(d)&&(d="M 0 0");1m if(c==="x"&&h==="1C")1k(e=0;e<g.7n.1h;e++)f=g.7n[e],A(f,"x")===A(g,"x")&&A(f,"x",d);1m if(1a.26&&(c==="x"||c==="y"))p=!0;1m if(c==="1I")d=i.1r(d,g,c);1m if(h==="4i"&&(c==="x"||c==="y"))c={x:"cx",y:"cy"}[c]||c;1m if(h==="2I"&&c==="r")A(g,{fG:d,fF:d}),j=!0;1m if(c==="2C"||c==="2n"||c==="26"||c==="3c"||c==="7c"||c==="54")j=p=!0;1m if(c==="1q")d=i.1r(d,g,c);1m if(c==="4g")if(c="1q-le",d=d&&d.8J(),d==="bk")d=S;1m{if(d){d=d.1J("jA","3,1,1,1,1,1,").1J("lW","3,1,1,1").1J("kl","1,1,").1J("kr","3,1,").1J("kf","8,3,").1J(/lM/g,"1,3,").1J("mx","4,3,").1J(/,$/,"").2p(",");1k(e=d.1h;e--;)d[e]=u(d[e])*a["1q-1f"];d=d.2q(",")}}1m if(c==="1f")d=u(d);1m if(c==="1y")c="1C-l0",d={1z:"3l",1Q:"4f",2a:"37"}[d];1m if(c==="1W")e=g.8n("1W")[0],e||(e=z.6p(4j,"1W"),g.2x(e)),e.gE=d;c==="5t"&&(c="1q-1f");if(c==="1q-1f"||c==="1q"){1a[c]=d;if(1a.1q&&1a["1q-1f"])A(g,"1q",1a.1q),A(g,"1q-1f",1a["1q-1f"]),1a.cP=!0;1m if(c==="1q-1f"&&d===0&&1a.cP)g.d2("1q"),1a.cP=!1;j=!0}1a.65&&/^(x|y|1f|1l|r|3l|37|4A|5J|5M)/.2i(c)&&(l||(1a.bI(a),l=!0),j=!0);if(m&&/^(1f|1l|2s|x|y|d|58)$/.2i(c))1k(e=m.1h;e--;)A(m[e],c,c==="1l"?q(d-(m[e].gQ||0),0):d);if((c==="1f"||c==="1l")&&h==="2I"&&d<0)d=0;1a[c]=d;c==="1C"?(d!==1a.8F&&29 1a.4N,1a.8F=d,1a.4y&&i.8C(1a)):j||A(g,c,d)}p&&1a.5D()}1d s},d0:1b(a){A(1a.1A,"3V",A(1a.1A,"3V")+" "+a);1d 1a},bI:1b(a){1c b=1a;n("x,y,r,3l,37,1f,1l,4A,5J,5M".2p(","),1b(c){b[c]=o(a[c],b[c])});b.1i({d:b.1v.4q[b.65](b.x,b.y,b.1f,b.1l,b)})},2G:1b(a){1d 1a.1i("2G-2v",a?"3I("+1a.1v.3I+"#"+a.id+")":S)},4U:1b(a,b,c,d,e){1c f,g={},h={},i,a=a||1a.5t||1a.1i&&1a.1i("1q-1f")||0;i=t(a)%2/2;h.x=T(b||1a.x||0)+i;h.y=T(c||1a.y||0)+i;h.1f=T((d||1a.1f||0)-2*i);h.1l=T((e||1a.1l||0)-2*i);h.5t=a;1k(f in h)1a[f]!==h[f]&&(1a[f]=g[f]=h[f]);1d g},1G:1b(a){1c b=1a.1A,c=a&&a.1f&&b.84.8J()==="1C",d,e="",f=1b(a,b){1d"-"+b.8J()};if(a&&a.1r)a.1I=a.1r;1a.4a=a=v(1a.4a,a);$&&c&&29 a.1f;if(5c&&!Z)c&&29 a.1f,L(1a.1A,a);1m{1k(d in a)e+=d.1J(/([A-Z])/g,f)+":"+a[d]+";";A(b,"1p",e)}c&&1a.4y&&1a.1v.8C(1a);1d 1a},on:1b(a,b){if(fb&&a==="3h")1a.1A.ap=1b(a){a.6t();b()};1a.1A["on"+a]=b;1d 1a},hu:1b(a){1a.1A.bm=a;1d 1a},1L:1b(a,b){1d 1a.1i({2C:a,2n:b})},fw:1b(){1a.1R=!0;1a.5D();1d 1a},bZ:1b(a){1c b=1a.1A;if(b=a&&b.bj==="bK"&&a.1f)29 a.1f,1a.cH=b,1a.5D();1a.4a=v(1a.4a,a);L(1a.1A,a);1d 1a},h1:1b(){1c a=1a.1A,b=1a.4N;if(!b){if(a.84==="1C")a.1p.2F="42";b=1a.4N={x:a.eI,y:a.fD,1f:a.3X,1l:a.7j}}1d b},8d:1b(){if(1a.4y){1c a=1a.1v,b=1a.1A,c=1a.2C||0,d=1a.2n||0,e=1a.x||0,f=1a.y||0,g=1a.3B||"1z",h={1z:0,1Q:0.5,2a:1}[g],i=g&&g!=="1z",j=1a.6u;L(b,{be:c,bd:d});j&&n(j,1b(a){L(a,{be:c+1,bd:d+1})});1a.1R&&n(b.7n,1b(c){a.bD(c,b)});if(b.bj==="bK"){1c k,m,j=1a.26,l,p=0,s=1,p=0,8I;l=u(1a.cH);1c B=1a.gF||0,w=1a.gJ||0,G=[j,g,b.4s,1a.cH].2q(",");k={};if(G!==1a.gI){if(r(j))a.68?(B=5c?"-ms-58":db?"-iq-58":eb?"lq":cz?"-o-58":"",k[B]=k.58="cB("+j+"lp)"):(p=j*bb,s=Y(p),p=ca(p),k.ei=j?["lC:ll.l2.l4(kW=",s,", kV=",-p,", kX=",p,", kY=",s,", lg=\'7Q lh\')"].2q(""):S),L(b,k);k=o(1a.lj,b.3X);m=o(1a.lf,b.7j);if(k>l&&/[ \\-]/.2i(b.gE||b.l8))L(b,{1f:l+"px",3y:"6k",bN:"ip"}),k=l;l=a.95(b.1p.2z).b;B=s<0&&-k;w=p<0&&-m;8I=s*p<0;B+=p*l*(8I?1-h:h);w-=s*l*(j?8I?h:1-h:1);i&&(B-=k*h*(s<0?-1:1),j&&(w-=m*h*(p<0?-1:1)),L(b,{3B:g}));1a.gF=B;1a.gJ=w}L(b,{1z:e+B+"px",1H:f+w+"px"});if(db)m=b.7j;1a.gI=G}}1m 1a.bL=!0},5D:1b(){1c a=1a.2C||0,b=1a.2n||0,c=1a.7c,d=1a.54,e=1a.1R,f=1a.26;e&&(a+=1a.1i("1f"),b+=1a.1i("1l"));a=["1L("+a+","+b+")"];e?a.1o("cB(90) ax(-1,1)"):f&&a.1o("cB("+f+" "+(1a.x||0)+" "+(1a.y||0)+")");(r(c)||r(d))&&a.1o("ax("+o(c,1)+" "+o(d,1)+")");a.1h&&A(1a.1A,"58",a.2q(" "))},mh:1b(){1c a=1a.1A;a.41.2x(a);1d 1a},1y:1b(a,b,c){1c d,e,f,g,h={};e=1a.1v;f=e.6m;if(a){if(1a.91=a,1a.bR=b,!c||fa(c))1a.bz=d=c||"1v",ga(f,1a),f.1o(1a),c=1g}1m a=1a.91,b=1a.bR,d=1a.bz;c=o(c,e[d],e);d=a.1y;e=a.3c;f=(c.x||0)+(a.x||0);g=(c.y||0)+(a.y||0);if(d==="2a"||d==="1Q")f+=(c.1f-(a.1f||0))/{2a:1,1Q:2}[d];h[b?"2C":"x"]=t(f);if(e==="3m"||e==="4f")g+=(c.1l-(a.1l||0))/({3m:1,4f:2}[e]||1);h[b?"2n":"y"]=t(g);1a[1a.gr?"1B":"1i"](h);1a.gr=!0;1a.a0=h;1d 1a},31:1b(){1c a=1a.4N,b=1a.1v,c,d=1a.26;c=1a.1A;1c e=1a.4a,f=d*bb;if(!a){if(c.mw===4j||b.6w){gK{a=c.31?v({},c.31()):{1f:c.3X,1l:c.7j}}gL(g){}if(!a||a.1f<0)a={1f:0,1l:0}}1m a=1a.h1();if(b.68){b=a.1f;c=a.1l;if(5c&&e&&e.2z==="h0"&&c.gZ(3)==="22.7")a.1l=c=14;if(d)a.1f=Q(c*ca(f))+Q(b*Y(f)),a.1l=Q(c*Y(f))+Q(b*ca(f))}1a.4N=a}1d a},3K:1b(){1d 1a.1i({2s:"1E"})},2D:1b(){1d 1a.1i({2s:"3i"})},f0:1b(a){1c b=1a;b.1B({1T:0},{4B:a||lT,7f:1b(){b.2D()}})},1s:1b(a){1c b=1a.1v,c=a||b,d=c.1A||b.3s,e=d.7n,f=1a.1A,g=A(f,"1D"),h;if(a)1a.g4=a;1a.gP=a&&a.1R;1a.8F!==3Z 0&&b.8C(1a);if(g)c.gY=!0,g=u(g);if(c.gY)1k(c=0;c<e.1h;c++)if(a=e[c],b=A(a,"1D"),a!==f&&(u(b)>g||!r(g)&&r(b))){d.bX(f,a);h=!0;3R}h||d.2x(f);1a.4y=!0;D(1a,"1s");1d 1a},8f:1b(a){1c b=a.41;b&&b.9a(a)},1t:1b(){1c a=1a,b=a.1A||{},c=a.6u,d,e;b.cU=b.lV=b.m6=b.hH=b.28=1g;6i(a);if(a.7v)a.7v=a.7v.1t();if(a.2J){1k(e=0;e<a.2J.1h;e++)a.2J[e]=a.2J[e].1t();a.2J=1g}a.8f(b);c&&n(c,1b(b){a.8f(b)});a.bz&&ga(a.1v.6m,a);1k(d in a)29 a[d];1d 1g},1Z:1b(a,b,c){1c d=[],e,f,g=1a.1A,h,i,j,k;if(a){i=o(a.1f,3);j=(a.1T||0.15)/i;k=1a.gP?"(-1,-1)":"("+o(a.ge,1)+", "+o(a.fW,1)+")";1k(e=1;e<=i;e++){f=g.i1(0);h=i*2+1-2*e;A(f,{g9:"gc",1q:a.1r||"9J","1q-1T":j*e,"1q-1f":h,58:"1L"+k,1I:S});if(c)A(f,"1l",q(A(f,"1l")-h,0)),f.gQ=h;b?b.1A.2x(f):g.41.bX(f,g);d.1o(f)}1a.6u=d}1d 1a}};1c 4z=1b(){1a.1K.2o(1a,2L)};4z.1w={9o:4l,1K:1b(a,b,c,d){1c e=dk,f;f=1a.2l("6R").1i({fO:4j,is:"1.1"});a.2x(f.1A);1a.68=!0;1a.3s=f.1A;1a.6s=f;1a.6m=[];1a.3I=(eb||db)&&z.8n("jP").1h?e.4r.1J(/#.*?$/,"").1J(/([\\(\'\\)])/g,"\\\\$1").1J(/ /g,"%20"):"";1a.2l("jJ").1s().1A.2x(z.bG("jZ jV 3F 3.0.2"));1a.6j=1a.2l("6j").1s();1a.6w=d;1a.9e={};1a.5P(b,c,!1);1c g;if(eb&&a.fQ)1a.bi=b=1b(){L(a,{1z:0,1H:0});g=a.fQ();L(a,{1z:ja(g.1z)-g.1z+"px",1H:ja(g.1H)-g.1H+"px"})},b(),J(O,"5I",b)},3U:1b(){1d!1a.6s.31().1f},1t:1b(){1c a=1a.6j;1a.3s=1g;1a.6s=1a.6s.1t();5j(1a.9e||{});1a.9e=1g;if(a)1a.6j=a.1t();1a.bi&&ba(O,"5I",1a.bi);1d 1a.6m=1g},2l:1b(a){1c b=2f 1a.9o;b.1K(1a,a);1d b},d8:1b(){},8C:1b(a){1k(1c b=a.1A,c=1a,d=c.6w,e=o(a.8F,"").7g().1J(/<(b|fR)>/g,\'<2O 1p="9V-jr:92">\').1J(/<(i|em)>/g,\'<2O 1p="9V-1p:jn">\').1J(/<a/g,"<2O").1J(/<\\/(b|fR|i|em|a)>/g,"</2O>").2p(/<br.*?>/g),f=b.7n,g=/1p="([^"]+)"/,h=/4r="([^"]+)"/,i=A(b,"x"),j=a.4a,k=j&&j.1f&&u(j.1f),m=j&&j.7K,l=f.1h;l--;)b.9a(f[l]);k&&!a.4y&&1a.3s.2x(b);e[e.1h-1]===""&&e.9p();n(e,1b(e,f){1c l,o=0,e=e.1J(/<2O/g,"|||<2O").1J(/<\\/2O>/g,"</2O>|||");l=e.2p("|||");n(l,1b(e){if(e!==""||l.1h===1){1c p={},n=z.6p(4j,"fB"),q;g.2i(e)&&(q=e.9b(g)[1].1J(/(;| |^)1r([ :])/,"$jD$2"),A(n,"1p",q));h.2i(e)&&!d&&(A(n,"cU",\'dk.4r="\'+e.9b(h)[1]+\'"\'),L(n,{3b:"3w"}));e=(e.1J(/<(.|\\n)*?>/g,"")||" ").1J(/&lt;/g,"<").1J(/&gt;/g,">");n.2x(z.bG(e));o?p.dx=0:p.x=i;A(n,p);!o&&f&&(!Z&&d&&L(n,{3y:"6k"}),A(n,"dy",m||c.95(/px$/.2i(n.1p.2z)?n.1p.2z:j.2z).h,db&&n.7j));b.2x(n);o++;if(k)1k(1c e=e.1J(/([^\\^])-/g,"$1- ").2p(" "),r,t=[];e.1h||t.1h;)29 a.4N,r=a.31().1f,p=r>k,!p||e.1h===1?(e=t,t=[],e.1h&&(n=z.6p(4j,"fB"),A(n,{dy:m||16,x:i}),q&&A(n,"1p",q),b.2x(n),r>k&&(k=r))):(n.9a(n.jB),t.bF(e.9p())),e.1h&&n.2x(z.bG(e.2q(" ").1J(/- /g,"-")))}})})},aH:1b(a,b,c,d,e,f,g){1c h=1a.27(a,b,c,1g,1g,1g,1g,1g,"aH"),i=0,j,k,m,l,p,a={bp:0,bq:0,bs:0,bn:1},e=x({"1q-1f":1,1q:"#jw",1I:{4W:a,2J:[[0,"#jv"],[1,"#jx"]]},r:2,2Q:5,1p:{1r:"9J"}},e);m=e.1p;29 e.1p;f=x(e,{1q:"#fI",1I:{4W:a,2J:[[0,"#k5"],[1,"#kF"]]}},f);l=f.1p;29 f.1p;g=x(e,{1q:"#fI",1I:{4W:a,2J:[[0,"#kx"],[1,"#ky"]]}},g);p=g.1p;29 g.1p;J(h.1A,"g1",1b(){h.1i(f).1G(l)});J(h.1A,"au",1b(){j=[e,f,g][i];k=[m,l,p][i];h.1i(j).1G(k)});h.35=1b(a){(i=a)?a===2&&h.1i(g).1G(p):h.1i(e).1G(m)};1d h.on("3h",1b(){d.1Y(h)}).1i(e).1G(v({3b:"4x"},m))},8o:1b(a,b){a[1]===a[4]&&(a[1]=a[4]=t(a[1])-b%2/2);a[2]===a[5]&&(a[2]=a[5]=t(a[2])+b%2/2);1d a},2v:1b(a){1c b={1I:S};4V(a)?b.d=a:V(a)&&v(b,a);1d 1a.2l("2v").1i(b)},4i:1b(a,b,c){a=V(a)?a:{x:a,y:b,r:c};1d 1a.2l("4i").1i(a)},5V:1b(a,b,c,d,e,f){if(V(a))b=a.y,c=a.r,d=a.4A,e=a.3l,f=a.37,a=a.x;1d 1a.2b("5V",a||0,b||0,c||0,c||0,{4A:d||0,3l:e||0,37:f||0})},2I:1b(a,b,c,d,e,f){e=V(a)?a.r:e;e=1a.2l("2I").1i({fG:e,fF:e,1I:S});1d e.1i(V(a)?a:e.4U(f,a,b,q(c,0),q(d,0)))},5P:1b(a,b,c){1c d=1a.6m,e=d.1h;1a.1f=a;1a.1l=b;1k(1a.6s[o(c,!0)?"1B":"1i"]({1f:a,1l:b});e--;)d[e].1y()},g:1b(a){1c b=1a.2l("g");1d r(a)?b.1i({"3V":"2j-"+a}):b},7T:1b(a,b,c,d,e){1c f={kR:S};2L.1h>1&&v(f,{x:b,y:c,1f:d,1l:e});f=1a.2l("7T").1i(f);f.1A.gg?f.1A.gg("66://7s.bv.bw/h4/kv","4r",a):f.1A.bS("hc-6R-4r",a);1d f},2b:1b(a,b,c,d,e,f){1c g,h=1a.4q[a],h=h&&h(t(b),t(c),d,e,f),i=/^3I\\((.*?)\\)$/,j,k;if(h)g=1a.2v(h),v(g,{65:a,x:b,y:c,1f:d,1l:e}),f&&v(g,f);1m if(i.2i(a))k=1b(a,b){a.1A&&(a.1i({1f:b[0],1l:b[1]}),a.bR||a.1L(t((d-b[0])/2),t((e-b[1])/2)))},j=a.9b(i)[1],a=bJ[j],g=1a.7T(j).1i({x:b,y:c}),g.g3=!0,a?k(g,a):(g.1i({1f:0,1l:0}),U("bB",{kd:1b(){k(g,bJ[j]=[1a.1f,1a.1l])},bC:j}));1d g},4q:{4i:1b(a,b,c,d){1c e=0.k8*c;1d["M",a+c/2,b,"C",a+c+e,b,a+c+e,b+d,a+c/ 2, b + d, "C", a - e, b + d, a - e, b, a + c/2,b,"Z"]},bA:1b(a,b,c,d){1d["M",a,b,"L",a+c,b,a+c,b+d,a,b+d,"Z"]},6z:1b(a,b,c,d){1d["M",a+c/ 2, b, "L", a + c, b + d, a, b + d, "Z"] }, "6z-7C": 1b (a, b, c, d) { 1d ["M", a, b, "L", a + c, b, a + c/2,b+d,"Z"]},fZ:1b(a,b,c,d){1d["M",a+c/ 2, b, "L", a + c, b + d/2,a+c/ 2, b + d, a, b + d /2,"Z"]},5V:1b(a,b,c,d,e){1c f=e.3l,c=e.r||c||d,g=e.37-0.9P,d=e.4A,h=e.gR,i=Y(f),j=ca(f),k=Y(g),g=ca(g),e=e.37-f<5E?0:1;1d["M",a+c*i,b+c*j,"A",c,c,0,e,1,a+c*k,b+c*g,h?"M":"L",a+d*k,b+d*g,"A",d,d,0,e,0,a+d*i,b+d*j,h?"":"Z"]}},2R:1b(a,b,c,d){1c e="2j-"+8U++,f=1a.2l("7v").1i({id:e}).1s(1a.6j),a=1a.2I(a,b,c,d,0).1s(f);a.id=e;a.7v=f;1d a},1r:1b(a,b,c){1c d=1a,e,f=/^44/,g,h,i,j,k,m,l,p=[];a&&a.4W?g="4W":a&&a.7V&&(g="7V");if(g){c=a[g];h=d.9e;j=a.2J;b=b.bm;4V(c)&&(a[g]=c={bp:c[0],bq:c[1],bs:c[2],bn:c[3],bQ:"g2"});g==="7V"&&b&&!r(c.bQ)&&(c=x(c,{cx:b[0]-b[2]/ 2 + c.cx * b[2], cy: b[1] - b[2] /2+c.cy*b[2],r:c.r*b[2],bQ:"g2"}));1k(l in c)l!=="id"&&p.1o(l,c[l]);1k(l in j)p.1o(j[l]);p=p.2q(",");h[p]?a=h[p].id:(c.id=a="2j-"+8U++,h[p]=i=d.2l(g).1i(c).1s(d.6j),i.2J=[],n(j,1b(a){f.2i(a[1])?(e=ma(a[1]),k=e.2S("56"),m=e.2S("a")):(k=a[1],m=1);a=d.2l("5w").1i({2Y:a[0],"5w-1r":k,"5w-1T":m}).1s(i);i.2J.1o(a)}));1d"3I("+d.3I+"#"+a+")"}1m 1d f.2i(a)?(e=ma(a),A(b,c+"-1T",e.2S("a")),e.2S("56")):(b.d2(c+"-1T"),a)},1C:1b(a,b,c,d){1c e=N.1j.1p,f=$||!Z&&1a.6w;if(d&&!1a.6w)1d 1a.8M(a,b,c);b=t(o(b,0));c=t(o(c,0));a=1a.2l("1C").1i({x:b,y:c,1C:a}).1G({5Z:e.5Z,2z:e.2z});f&&a.1G({2F:"42"});a.x=b;a.y=c;1d a},8M:1b(a,b,c){1c d=N.1j.1p,e=1a.2l("2O"),f=e.5s,g=e.1A,h=e.1v;f.1C=1b(a){a!==g.4s&&29 1a.4N;g.4s=a;1d!1};f.x=f.y=f.1y=1b(a,b){b==="1y"&&(b="3B");e[b]=a;e.8d();1d!1};e.1i({1C:a,x:t(b),y:t(c)}).1G({2F:"42",bN:"g5",5Z:d.5Z,2z:d.2z});e.1G=e.bZ;if(h.68)e.1s=1b(a){1c b,c=h.3s.41,d=[];if(a){if(b=a.97,!b){1k(;a;)d.1o(a),a=a.g4;n(d.df(),1b(a){1c d;b=a.97=a.97||U(4C,{5i:A(a.1A,"3V")},{2F:"42",1z:(a.2C||0)+"px",1H:(a.2n||0)+"px"},b||c);d=b.1p;v(a.5s,{2C:1b(a){d.1z=a+"px"},2n:1b(a){d.1H=a+"px"},2s:1b(a,b){d[b]=a}})})}}1m b=c;b.2x(g);e.4y=!0;e.bL&&e.8d();1d e};1d e},95:1b(a){1c a=u(a||11),a=a<24?a+4:t(a*1.2),b=t(a*0.8);1d{h:a,b:b}},27:1b(a,b,c,d,e,f,g,h,i){1b j(){1c a,b;a=o.1A.1p;w=(5N===3Z 0||87===3Z 0||s.4a.3B)&&o.31();s.1f=(5N||w.1f||0)+2*q+hb;s.1l=(87||w.1l||0)+2*q;A=q+p.95(a&&a.2z).b;if(z){if(!B)a=t(-G*q),b=h?-A:0,s.3s=B=d?p.2b(d,a,b,s.1f,s.1l):p.2I(a,b,s.1f,s.1l,0,u[bO]),B.1s(s);B.g3||B.1i(x({1f:s.1f,1l:s.1l},u));u=1g}}1b k(){1c a=s.4a,a=a&&a.3B,b=hb+q*(1-G),c;c=h?0:A;if(r(5N)&&(a==="1Q"||a==="2a"))b+={1Q:0.5,2a:1}[a]*(5N-w.1f);(b!==o.x||c!==o.y)&&o.1i({x:b,y:c});o.x=b;o.y=c}1b m(a,b){B?B.1i(a,b):u[a]=b}1b l(){o.1s(s);s.1i({1C:a,x:b,y:c});B&&r(e)&&s.1i({5J:e,5M:f})}1c p=1a,s=p.g(i),o=p.1C("",0,0,g).1i({1D:1}),B,w,G=0,q=3,hb=0,5N,87,P,H,C=0,u={},A,g=s.5s,z;J(s,"1s",l);g.1f=1b(a){5N=a;1d!1};g.1l=1b(a){87=a;1d!1};g.2Q=1b(a){r(a)&&a!==q&&(q=a,k());1d!1};g.pp=1b(a){r(a)&&a!==hb&&(hb=a,k());1d!1};g.1y=1b(a){G={1z:0,1Q:0.5,2a:1}[a];1d!1};g.1C=1b(a,b){o.1i(b,a);j();k();1d!1};g[bO]=1b(a,b){z=!0;C=a%2/2;m(b,a);1d!1};g.1q=g.1I=g.r=1b(a,b){b==="1I"&&(z=!0);m(b,a);1d!1};g.5J=1b(a,b){e=a;m(b,a+C-P);1d!1};g.5M=1b(a,b){f=a;m(b,a-H);1d!1};g.x=1b(a){s.x=a;a-=G*((5N||w.1f)+q);P=t(a);s.1i("2C",P);1d!1};g.y=1b(a){H=s.y=t(a);s.1i("2n",H);1d!1};1c E=s.1G;1d v(s,{1G:1b(a){if(a){1c b={},a=x(a);n("2z,94,5Z,1r,7K,1f,pt".2p(","),1b(c){a[c]!==y&&(b[c]=a[c],29 a[c])});o.1G(b)}1d E.1Y(s,a)},31:1b(){1d{1f:w.1f+2*q,1l:w.1l+2*q,x:w.x-q,y:w.y-q}},1Z:1b(a){B&&B.1Z(a);1d s},1t:1b(){ba(s,"1s",l);ba(s.1A,"g1");ba(s.1A,"au");o&&(o=o.1t());B&&(B=B.1t());4l.1w.1t.1Y(s);s=p=j=k=m=l=1g}})}};64=4z;1c F;if(!Z&&!$){3F.pw=F={1K:1b(a,b){1c c=["<",b,\' c2="f" g8="f"\'],d=["2F: ","42",";"],e=b===4C;(b==="5O"||e)&&d.1o("1z:0;1H:0;1f:fY;1l:fY;");d.1o("2s: ",e?"3i":"1E");c.1o(\' 1p="\',d.2q(""),\'"/>\');if(b)c=e||b==="2O"||b==="bB"?c.2q(""):a.5d(c),1a.1A=U(c);1a.1v=a;1a.5s={}},1s:1b(a){1c b=1a.1v,c=1a.1A,d=b.3s,d=a?a.1A||a:d;a&&a.1R&&b.bD(c,d);d.2x(c);1a.4y=!0;1a.bL&&!1a.pl&&1a.5D();D(1a,"1s");1d 1a},5D:4l.1w.8d,1i:1b(a,b){1c c,d,e,f=1a.1A||{},g=f.1p,h=f.84,i=1a.1v,j=1a.65,k,m=1a.6u,l,p=1a.5s,s=1a;fa(a)&&r(b)&&(c=a,a={},a[c]=b);if(fa(a))c=a,s=c==="5t"||c==="1q-1f"?1a.c1:1a[c];1m 1k(c in a)if(d=a[c],l=!1,e=p[c]&&p[c].1Y(1a,d,c),e!==!1&&d!==1g){e!==y&&(d=e);if(j&&/^(x|y|r|3l|37|1f|1l|4A|5J|5M)/.2i(c))k||(1a.bI(a),k=!0),l=!0;1m if(c==="d"){d=d||[];1a.d=d.2q(" ");e=d.1h;l=[];1k(1c o;e--;)if(5G(d[e]))l[e]=t(d[e]*10)-5;1m if(d[e]==="Z")l[e]="x";1m if(l[e]=d[e],d.gM&&(d[e]==="34"||d[e]==="at"))o=d[e]==="34"?1:-1,l[e+5]===l[e+7]&&(l[e+7]-=o),l[e+6]===l[e+8]&&(l[e+8]-=o);d=l.2q(" ")||"x";f.2v=d;if(m)1k(e=m.1h;e--;)m[e].2v=m[e].bY?1a.c0(d,m[e].bY):d;l=!0}1m if(c==="2s"){if(m)1k(e=m.1h;e--;)m[e].1p[c]=d;h==="bT"&&(d=d==="3i"?"-py":0,cb||(g[c]=d?"1E":"3i"),c="1H");g[c]=d;l=!0}1m if(c==="1D")d&&(g[c]=d),l=!0;1m if(la(c,["x","y","1f","1l"])!==-1)1a[c]=d,c==="x"||c==="y"?c={x:"1z",y:"1H"}[c]:d=q(0,d),1a.bU?(1a[c]=d,1a.bU()):g[c]=d,l=!0;1m if(c==="3V"&&h==="bT")f.5i=d;1m if(c==="1q")d=i.1r(d,f,c),c="pI";1m if(c==="1q-1f"||c==="5t")f.g8=d?!0:!1,c="c1",1a[c]=d,5G(d)&&(d+="px");1m if(c==="4g")(f.8n("1q")[0]||U(i.5d(["<1q/>"]),1g,1g,f))[c]=d||"bk",1a.4g=d,l=!0;1m if(c==="1I")if(h==="bK")g.1r=d;1m{if(h!=="fL")f.c2=d!==S?!0:!1,d=i.1r(d,f,c,1a),c="pO"}1m if(c==="1T")l=!0;1m if(h==="5O"&&c==="26")1a[c]=d,f.1p.1z=-t(ca(d*bb)+1)+"px",f.1p.1H=t(Y(d*bb))+"px";1m if(c==="2C"||c==="2n"||c==="26")1a[c]=d,1a.5D(),l=!0;1m if(c==="1C")1a.4N=1g,f.4s=d,l=!0;l||(cb?f[c]=d:A(f,c,d))}1d s},2G:1b(a){1c b=1a,c;a?(c=a.bV,ga(c,b),c.1o(b),b.7E=1b(){ga(c,b)},a=a.bW(b)):(b.7E&&b.7E(),a={2G:cb?"9U":"2I(7Q)"});1d b.1G(a)},1G:4l.1w.bZ,8f:1b(a){a.41&&6e(a)},1t:1b(){1a.7E&&1a.7E();1d 4l.1w.1t.2o(1a)},on:1b(a,b){1a.1A["on"+a]=1b(){1c a=O.gx;a.5p=a.hB;b(a)};1d 1a},c0:1b(a,b){1c c,a=a.2p(/[ ,]/);c=a.1h;if(c===9||c===11)a[c-4]=a[c-2]=u(a[c-2])-10*b;1d a.2q(" ")},1Z:1b(a,b,c){1c d=[],e,f=1a.1A,g=1a.1v,h,i=f.1p,j,k=f.2v,m,l,p,s;k&&3q k.6g!=="dZ"&&(k="x");l=k;if(a){p=o(a.1f,3);s=(a.1T||0.15)/p;1k(e=1;e<=3;e++){m=p*2+1-2*e;c&&(l=1a.c0(k.6g,m+0.5));j=[\'<5O g9="gc" c1="\',m,\'" c2="pi" 2v="\',l,\'" gT="10 10" 1p="\',f.1p.fE,\'" />\'];h=U(g.5d(j),1g,{1z:u(i.1z)+o(a.ge,1),1H:u(i.1H)+o(a.fW,1)});if(c)h.bY=m+1;j=[\'<1q 1r="\',a.1r||"9J",\'" 1T="\',s*e,\'"/>\'];U(g.5d(j),1g,1g,h);b?b.1A.2x(h):f.41.bX(h,f);d.1o(h)}1a.6u=d}1d 1a}};F=ea(4l,F);1c na={9o:F,fN:4Q.3H("oM 8.0")>-1,1K:1b(a,b,c){1c d,e;1a.6m=[];d=1a.2l(4C);e=d.1A;e.1p.2F="aP";a.2x(d.1A);1a.fV=!0;1a.3s=e;1a.6s=d;1a.5P(b,c,!1);if(!z.fH.5a)z.fH.1s("5a","gl:gm-gS-62:9R"),z.oR().fE="5a\\\\:1I, 5a\\\\:2v, 5a\\\\:5O, 5a\\\\:1q{ bt:3I(#4x#bu); 3y: bl-6k; } "},3U:1b(){1d!1a.3s.3X},2R:1b(a,b,c,d){1c e=1a.2l(),f=V(a);1d v(e,{bV:[],1z:f?a.x:a,1H:f?a.y:b,1f:f?a.1f:c,1l:f?a.1l:d,bW:1b(a){1c b=a.1A,c=b.84,a=a.1R,d=1a.1H-(c==="5O"?b.fD:0),e=1a.1z,b=e+1a.1f,f=d+1a.1l,d={2G:"2I("+t(a?e:d)+"px,"+t(a?f:b)+"px,"+t(a?b:f)+"px,"+t(a?d:e)+"px)"};!a&&cb&&c==="bT"&&v(d,{1f:b+"px",1l:f+"px"});1d d},bU:1b(){n(e.bV,1b(a){a.1G(e.bW(a))})}})},1r:1b(a,b,c,d){1c e=1a,f,g=/^44/,h,i,j=S;a&&a.4W?i="bo":a&&a.7V&&(i="oz");if(i){1c k,m,l=a.4W||a.7V,p,s,o,B,w,q="",a=a.2J,r,t=[],y=1b(){h=[\'<1I 74="\'+t.2q(",")+\'" 1T="\',o,\'" o:oG="\',s,\'" 1F="\',i,\'" \',q,\'oS="36%" p6="p9" />\'];U(e.5d(h),1g,1g,b)};p=a[0];r=a[a.1h-1];p[0]>0&&a.bF([0,p[1]]);r[0]<1&&a.1o([1,r[1]]);n(a,1b(a,b){g.2i(a[1])?(f=ma(a[1]),k=f.2S("56"),m=f.2S("a")):(k=a[1],m=1);t.1o(a[0]*36+"% "+k);b?(o=m,B=k):(s=m,w=k)});if(c==="1I")if(i==="bo")c=l.bp||l[0]||0,a=l.bq||l[1]||0,p=l.bs||l[2]||0,l=l.bn||l[3]||0,q=\'7z="\'+(90-I.pu((l-a)/(p-c))*ic/5E)+\'"\',y();1m{1c j=l.r,v=j*2,P=j*2,H=l.cx,C=l.cy,x=b.bm,u,j=1b(){x&&(u=d.31(),H+=(x[0]-u.x)/u.1f-0.5,C+=(x[1]-u.y)/ u.1l - 0.5, v *= x[2]/u.1f,P*=x[2]/u.1l);q=\'bC="\'+N.6I.fS+\'" 6A="\'+v+","+P+\'" pJ="0.5,0.5" 2F="\'+H+","+C+\'" pv="\'+w+\'" \';y()};d.4y?j():J(d,"1s",j);j=B}1m j=k}1m if(g.2i(a)&&b.bj!=="fL")f=ma(a),h=["<",c,\' 1T="\',f.2S("a"),\'"/>\'],U(1a.5d(h),1g,1g,b),j=f.2S("56");1m{j=b.8n(c);if(j.1h)j[0].1T=1,j[0].1F="bk";j=a}1d j},5d:1b(a){1c b=1a.fN,a=a.2q("");b?(a=a.1J("/>",\' fO="gl:gm-gS-62:9R" />\'),a=a.3H(\'1p="\')===-1?a.1J("/>",\' 1p="3y:bl-6k;bt:3I(#4x#bu);" />\'):a.1J(\'1p="\',\'1p="3y:bl-6k;bt:3I(#4x#bu);\')):a=a.1J("<","<5a:");1d a},1C:4z.1w.8M,2v:1b(a){1c b={gT:"10 10"};4V(a)?b.d=a:V(a)&&v(b,a);1d 1a.2l("5O").1i(b)},4i:1b(a,b,c){1c d=1a.2b("4i");if(V(a))c=a.r,b=a.y,a=a.x;d.gN=!0;1d d.1i({x:a,y:b,1f:2*c,1l:2*c})},g:1b(a){1c b;a&&(b={5i:"2j-"+a,"3V":"2j-"+a});1d 1a.2l(4C).1i(b)},7T:1b(a,b,c,d,e){1c f=1a.2l("bB").1i({bC:a});2L.1h>1&&f.1i({x:b,y:c,1f:d,1l:e});1d f},2I:1b(a,b,c,d,e,f){if(V(a))b=a.y,c=a.1f,d=a.1l,f=a.5t,a=a.x;1c g=1a.2b("2I");g.r=e;1d g.1i(g.4U(f,a,b,q(c,0),q(d,0)))},bD:1b(a,b){1c c=b.1p;L(a,{pK:"x",1z:u(c.1f)-1,1H:u(c.1l)-1,26:-90})},4q:{5V:1b(a,b,c,d,e){1c f=e.3l,g=e.37,h=e.r||c||d,c=e.4A,d=Y(f),i=ca(f),j=Y(g),k=ca(g);if(g-f===0)1d["x"];f=["34",a-h,b-h,a+h,b+h,a+h*d,b+h*i,a+h*j,b+h*k];e.gR&&!c&&f.1o("e","M",a,b);f.1o("at",a-c,b-c,a+c,b+c,a+c*j,b+c*k,a+c*d,b+c*i,"x","e");f.gM=!0;1d f},4i:1b(a,b,c,d,e){e&&e.gN&&(a-=c/2,b-=d/ 2); 1d ["34", a, b, a + c, b + d, a + c, b + d/2,a+c,b+d/2,"e"]},2I:1b(a,b,c,d,e){1c f=a+c,g=b+d,h;!r(e)||!e.r?f=4z.1w.4q.bA.2o(0,2L):(h=K(e.r,c,d),f=["M",a+h,b,"L",f-h,b,"34",f-2*h,b,f,b+2*h,f-h,b,f,b+h,"L",f,g-h,"34",f-2*h,g-2*h,f,g,f,g-h,f-h,g,"L",a+h,g,"34",a,g-2*h,a+2*h,g,a+h,g,a,g-h,"L",a,b+h,"34",a,b,a+2*h,b+2*h,a,b+h,a+h,b,"x","e"]);1d f}}};3F.pB=F=1b(){1a.1K.2o(1a,2L)};F.1w=x(4z.1w,na);64=F}1c dS;if($)3F.pA=F=1b(){4j="66://7s.bv.bw/h4/oB"},F.1w.4q={},dS=1b(){1b a(){1c a=b.1h,d;1k(d=0;d<a;d++)b[d]();b=[]}1c b=[];1d{1o:1b(c,d){b.1h===0&&h5(d,a);b.1o(c)}}}(),64=F;5k.1w={c5:1b(){1c a=1a.2e,b=a.1e,c=a.1j,d=a.2P,e=a.3r,f=a.1n[0]&&a.1n[0].e5,g=1a.3a,h=b.2y,i=a.3D,d=d&&e&&!h.5h&&!h.5b&&!h.26&&c.2K/i.1h||!d&&(c.8N||c.2K/2),j=g===i[0],k=g===i[i.1h-1],f=e?o(e[g],f&&f[g],g):g,e=1a.27,i=i.h6,m;a.5T&&i&&(m=b.8a[i.h7[g]||i.h3]);1a.9c=j;1a.9g=k;b=a.8c.1Y({2e:a,1j:c,9c:j,9g:k,ef:m,6g:a.2U?ia(da(f)):f});g=d&&{1f:q(1,t(d-2*(h.2Q||10)))+"px"};g=v(g,h.1p);if(r(e))e&&e.1i({1C:b}).1G(g);1m{d={1y:h.1y};if(5G(h.26))d.26=h.26;1a.27=r(b)&&h.1N?c.1v.1C(b,0,0,h.4w).1i(d).1G(g).1s(a.ck):1g}},fk:1b(){1c a=1a.27,b=1a.2e;1d a?(1a.h2=a.31())[b.2P?"1l":"1f"]:0},bx:1b(){1c a=1a.2e.1e.2y,b=1a.h2.1f,a=b*{1z:0,1Q:0.5,2a:1}[a.1y]-a.x;1d[-a,b-a]},9i:1b(a,b){1c c=!0,d=1a.2e,e=d.1j,f=1a.9c,g=1a.9g,h=b.x,i=d.3L,j=d.3D;if(f||g){1c k=1a.bx(),m=k[0],k=k[1],e=e.1U,l=e+d.2r,j=(d=d.7M[j[a+(f?1:-1)]])&&d.27.by&&d.27.by.x+d.bx()[f?0:1];f&&!i||g&&i?h+m<e&&(h=e-m,d&&h+k>j&&(c=!1)):h+k>l&&(h=l-k,d&&h+m<j&&(c=!1));b.x=h}1d c},8l:1b(a,b,c,d){1c e=1a.2e,f=e.1j,g=d&&f.8B||f.3g;1d{x:a?e.1L(b+c,1g,1g,d)+e.8b:e.1z+e.2Y+(e.4k?(d&&f.e1||f.3f)-e.2a-e.1z:0),y:a?g-e.3m+e.2Y-(e.4k?e.1l:0):g-e.1L(b+c,1g,1g,d)-e.8b}},gs:1b(a,b,c,d,e,f,g,h){1c i=1a.2e,j=i.5o,k=i.3L,i=i.5b,a=a+e.x-(f&&d?f*j*(k?-1:1):0),b=b+e.y-(f&&!d?f*j*(k?1:-1):0);r(e.y)||(b+=u(c.4a.7K)*0.9-c.31().1l/2);i&&(b+=g/(h||1)%i*16);1d{x:a,y:b}},gv:1b(a,b,c,d,e,f){1d f.8o(["M",a,b,"L",a+(e?0:-c),b+(e?c:0)],d)},2d:1b(a,b,c){1c d=1a.2e,e=d.1e,f=d.1j.1v,g=d.2P,h=1a.1F,i=1a.27,j=1a.3a,k=e.2y,m=1a.gu,l=h?h+"p5":"fp",p=h?h+"gV":"oY",s=e[l+"oJ"],n=e[l+"p0"],B=e[l+"p1"],w=e[p+"p2"],l=e[p+"je"]||0,q=e[p+"gn"],r=e[p+"oZ"],p=1a.gw,t=k.5h,v=!0,u=d.ch,P=1a.8l(g,j,u,b),H=P.x,P=P.y,C=g&&H===d.3a||!g&&P===d.3a+d.2r?-1:1,x=d.5b;1a.6x=!0;if(s){j=d.6c(j+u,s*C,b,!0);if(m===y){m={1q:n,"1q-1f":s};if(B)m.4g=B;if(!h)m.1D=1;if(b)m.1T=0;1a.gu=m=s?f.2v(j).1i(m).1s(d.cj):1g}if(!b&&m&&j)m[1a.3A?"1i":"1B"]({d:j,1T:c})}if(l&&w)r==="ih"&&(w=-w),d.4k&&(w=-w),b=1a.gv(H,P,w,l*C,g,f),p?p.1B({d:b,1T:c}):1a.gw=f.2v(b).1i({1q:q,"1q-1f":l,1T:c}).1s(d.6d);if(i&&!3v(H))i.by=P=1a.gs(H,P,i,g,k,u,a,t),1a.9c&&!o(e.oU,1)||1a.9g&&!o(e.gD,1)?v=!1:!x&&g&&k.ig==="iR"&&!1a.9i(a,P)&&(v=!1),t&&a%t&&(v=!1),v&&!3v(P.y)?(P.1T=c,i[1a.3A?"1i":"1B"](P),1a.3A=!1):i.1i("y",-aq)},1t:1b(){5j(1a,1a.2e)}};pb.1w={2d:1b(){1c a=1a,b=a.2e,c=b.2P,d=(b.3C||0)/2,e=a.1e,f=e.27,g=a.27,h=e.1f,i=e.eK,j=e.bh,k=r(j)&&r(i),m=e.6g,l=e.5W,p=a.gp,s=[],n,B=e.1r,w=e.1D,G=e.39,t=b.1j.1v;b.2U&&(j=ka(j),i=ka(i),m=ka(m));if(h){if(s=b.6c(m,h),d={1q:B,"1q-1f":h},l)d.4g=l}1m if(k){if(j=q(j,b.1u-d),i=K(i,b.1x+d),s=b.eE(j,i,e),d={1I:B},e.3d)d.1q=e.3o,d["1q-1f"]=e.3d}1m 1d;if(r(w))d.1D=w;if(p)s?p.1B({d:s},1g,p.go):(p.2D(),p.go=1b(){p.3K()});1m if(s&&s.1h&&(a.gp=p=t.2v(s).1i(d).1s(),G))1k(n in e=1b(b){p.on(b,1b(c){G[b].2o(a,[c])})},G)e(n);if(f&&r(f.1C)&&s&&s.1h&&b.1f>0&&b.1l>0){f=x({1y:c&&k&&"1Q",x:c?!k&&4:10,3c:!c&&k&&"4f",y:c?k?16:10:k?6:-4,26:c&&!k&&90},f);if(!g)a.27=g=t.1C(f.1C,0,0).1i({1y:f.3B||f.1y,26:f.26,1D:w}).1G(f.1p).1s();b=[s[1],s[4],o(s[6],s[1])];s=[s[2],s[5],o(s[7],s[2])];c=4X(b);k=4X(s);g.1y(f,!1,{x:c,y:k,1f:pa(b)-c,1l:pa(s)-k});g.3K()}1m g&&g.2D();1d a},1t:1b(){ga(1a.2e.6D,1a);5j(1a,1a.2e)}};cw.1w={1t:1b(){5j(1a,1a.2e)},ej:1b(a){1a.7b=1a.4e=a},2d:1b(a){1c b=1a.1e,c=b.7Y,c=c?34(c,1a):b.5g.1Y(1a);1a.27?1a.27.1i({1C:c,2s:"3i"}):1a.27=1a.2e.1j.1v.1C(c,0,0,b.4w).1G(b.1p).1i({1y:1a.3B,26:b.26,2s:"3i"}).1s(a)},hZ:1b(a,b){1c c=1a.2e,d=c.1j,e=d.1R,f=1a.gq,g=c.1L(1a.6X?36:1a.4e,0,0,0,1),c=c.1L(0),c=Q(g-c),h=d.1M[0].1L(1a.x)+a,i=d.33,f={x:e?f?g:g-c:h,y:e?i-h-b:f?i-g-c:i-g,1f:e?c:b,1l:e?b:c};if(e=1a.27)e.1y(1a.91,1g,f),f=e.a0,e.1i({2s:1a.1e.gf===!1||d.3M(f.x,f.y)?Z?"9U":"1E":"3i"})}};ab.1w={eG:{8a:{c3:"%H:%M:%S.%L",c4:"%H:%M:%S",cD:"%m-%d %H:%M",cE:"%m-%d %H:%M",89:"%Y-%m-%d",cF:"%e. %b",cG:"%Y-%m",cC:"%Y"},cd:!1,oV:"#9k",2y:M,6y:"#gA",2N:1,cR:0.gH,cQ:0.gH,oW:"#oX",p3:1,p4:"#pd",pe:2,pf:"gB",cK:1,ct:!1,pc:"#gA",p8:5,en:"dC",83:36,oT:"gB",fj:1,1W:{1y:"4f",1p:{1r:"#gC",94:"92"}},1F:"oE"},eF:{cd:!0,oF:1,83:72,gD:!0,2y:{1y:"2a",x:-8,y:3},2N:0,cQ:0.h8,cR:0.h8,ct:!0,fj:0,1W:{26:el,1C:"oA"},c8:{1N:!1,5g:1b(){1d 4K(1a.4e,-1)},1p:M.1p}},et:{2y:{1y:"2a",x:-8,y:1g},1W:{26:el}},ev:{2y:{1y:"1z",x:8,y:1g},1W:{26:90}},ex:{2y:{1y:"1Q",x:0,y:14},1W:{26:0}},ez:{2y:{1y:"1Q",x:0,y:-5},1W:{26:0}},1K:1b(a,b){1c c=b.iH;1a.2P=a.1R?!c:c;1a.7u=(1a.3Q=c)?"x":"y";1a.4k=b.4k;1a.8h=1a.2P?1a.4k?0:2:1a.4k?1:3;1a.7A(b);1c d=1a.1e,e=d.1F;1a.8c=d.2y.5g||1a.eD;1a.5b=1a.2P&&d.2y.5b;1a.4u=b;1a.8m=0;1a.1j=a;1a.3L=d.3L;1a.7k=d.7k!==!1;1a.3r=d.3r||e==="6U";1a.2U=e==="oH";1a.5T=e==="fy";1a.5f=r(d.8G);1a.ch=1a.3r&&d.en==="dC"?0.5:0;1a.7M={};1a.cs={};1a.6D=[];1a.co={};1a.2r=0;1a.49=1a.gy=d.49||d.oI;1a.81=d.81;1a.2Y=d.2Y||0;1a.4o={};1a.eo=0;1a.1u=1a.1x=1g;1c f,d=1a.1e.39;la(1a,a.2Z)===-1&&(a.2Z.1o(1a),a[c?"1M":"23"].1o(1a));1a.1n=1a.1n||[];if(a.1R&&c&&1a.3L===y)1a.3L=!0;1a.oP=1a.oQ=1a.h9;1k(f in d)J(1a,f,d[f]);if(1a.2U)1a.es=ka,1a.cA=da},7A:1b(a){1a.1e=x(1a.eG,1a.3Q?{}:1a.eF,[1a.ez,1a.ev,1a.ex,1a.et][1a.8h],x(N[1a.3Q?"1M":"23"],a))},6n:1b(a,b){1c c=1a.1j,a=c.1e[1a.7u+"9y"][1a.1e.2A]=x(1a.4u,a);1a.1t();1a.cq=!1;1a.1K(c,a);c.4D=!0;o(b,!0)&&c.2m()},3G:1b(a){1c b=1a.1j,c=1a.7u+"9y";n(1a.1n,1b(a){a.3G(!1)});ga(b.2Z,1a);ga(b[c],1a);b.1e[c].2X(1a.1e.2A,1);n(b[c],1b(a,b){a.1e.2A=b});1a.1t();b.4D=!0;o(a,!0)&&b.2m()},eD:1b(){1c a=1a.2e,b=1a.6g,c=a.3r,d=1a.ef,e=N.5u.ek,f=e&&e.1h,g,h=a.1e.2y.7Y,a=a.2U?b:a.2E;if(h)g=34(h,1a);1m if(c)g=b;1m if(d)g=7X(d,b);1m if(f&&a>=3E)1k(;f--&&g===y;)c=7h.6B(3E,f+1),a>=c&&e[f]!==1g&&(g=4K(b/c,-1)+e[f]);g===y&&(g=b>=3E?4K(b,0):4K(b,-1));1d g},f7:1b(){1c a=1a,b=a.1j,c=a.4o,d=[],e=[],f=a.eo+=1,g,h;a.c9=!1;a.2t=a.2w=1g;n(a.1n,1b(g){if(g.1E||!b.1e.1j.dn){1c j=g.1e,k,m,l,p,s,n,B,w,G,t=j.4b,v,u=[],x=0;a.c9=!0;if(a.2U&&t<=0)t=j.4b=1g;if(a.3Q){if(j=g.4v,j.1h)a.2t=K(o(a.2t,j[0]),4X(j)),a.2w=q(o(a.2w,j[0]),pa(j))}1m{1c P,H,C,A=g.dW,z=g.1M.6o(),E=!!g.8k;k=j.3z;a.8t=k==="6X";if(k)s=j.cr,p=g.1F+o(s,""),n="-"+p,g.7Z=p,m=d[p]||[],d[p]=m,l=e[n]||[],e[n]=l;if(a.8t)a.2t=0,a.2w=99;j=g.8X;B=g.do;v=B.1h;1k(h=0;h<v;h++){w=j[h];G=B[h];if(k)H=(P=G<t)?l:m,C=P?n:p,r(H[w])?(H[w]=ia(H[w]+G),G=[G,H[w]]):H[w]=G,c[C]||(c[C]={}),c[C][w]||(c[C][w]=2f cw(a,a.1e.c8,P,w,s,k)),c[C][w].ej(H[w]),c[C][w].eq=f;if(G!==1g&&G!==y&&(!a.2U||G.1h||G>0))if(E&&(G=g.8k(G)),g.oN||A||(j[h+1]||w)>=z.1u&&(j[h-1]||w)<=z.1x)if(w=G.1h)1k(;w--;)G[w]!==1g&&(u[x++]=G[w]);1m u[x++]=G}if(!a.8t&&u.1h)g.2t=k=4X(u),g.2w=g=pa(u),a.2t=K(o(a.2t,k),k),a.2w=q(o(a.2w,g),g);if(r(t))if(a.2t>=t)a.2t=t,a.eg=!0;1m if(a.2w<t)a.2w=t,a.er=!0}}});1k(g in c)1k(h in c[g])c[g][h].eq<f&&(c[g][h].1t(),29 c[g][h])},1L:1b(a,b,c,d,e,f){1c g=1a.2r,h=1,i=0,j=d?1a.ey:1a.5o,d=d?1a.5U:1a.1u,k=1a.8m,e=(1a.1e.ph||1a.2U&&e)&&1a.cA;if(!j)j=1a.5o;c&&(h*=-1,i=g);1a.3L&&(h*=-1,i-=h*g);b?(a=a*h+i,a-=k,a=a/j+d,e&&(a=1a.cA(a))):(e&&(a=1a.es(a)),a=h*(a-d)*j+i+h*k+(f?j*1a.3C/2:0));1d a},7W:1b(a,b){1d 1a.1L(a,!1,!1a.2P,1g,!0)+(b?0:1a.3a)},8i:1b(a,b){1d 1a.1L(a-(b?0:1a.3a),!0,!1a.2P,1g,!0)},6c:1b(a,b,c,d){1c e=1a.1j,f=1a.1z,g=1a.1H,h,i,j,a=1a.1L(a,1g,1g,c),k=c&&e.8B||e.3g,m=c&&e.e1||e.3f,l;h=1a.8b;c=i=t(a+h);h=j=t(k-a-h);if(3v(a))l=!0;1m if(1a.2P){if(h=g,j=k-1a.3m,c<f||c>f+1a.1f)l=!0}1m if(c=f,i=m-1a.2a,h<g||h>g+1a.1l)l=!0;1d l&&!d?1g:e.1v.8o(["M",c,h,"L",i,j],b||0)},eE:1b(a,b){1c c=1a.6c(b),d=1a.6c(a);d&&c?d.1o(c[4],c[5],c[1],c[2]):d=1g;1d d},8s:1b(a,b,c){1k(1c d,b=ia(T(b/a)*a),c=ia(ja(c/a)*a),e=[];b<=c;){e.1o(b);b=ia(b+a);if(b===d)3R;d=b}1d e},cM:1b(a,b,c,d){1c e=1a.1e,f=1a.2r,g=[];if(!d)1a.cI=1g;if(a>=0.5)a=t(a),g=1a.8s(a,b,c);1m if(a>=0.oL)1k(1c f=T(b),h,i,j,k,m,e=a>0.3?[1,2,4]:a>0.15?[1,2,4,6,8]:[1,2,3,4,5,6,7,8,9];f<c+1&&!m;f++){i=e.1h;1k(h=0;h<i&&!m;h++)j=ka(da(f)*e[h]),j>b&&(!d||k<=c)&&g.1o(k),k>c&&(m=!0),k=j}1m if(b=da(b),c=da(c),a=e[d?"5m":"2E"],a=o(a==="7Q"?1g:a,1a.cI,(c-b)*(e.83/(d?5:1))/ ((d ? f/1a.3D.1h:f)||1)),a=ib(a,1g,I.6B(10,T(I.8e(a)/ I.cO))), g = 59(1a.8s(a, b, c), ka), !d) 1a.cI = a /5;if(!d)1a.2E=a;1d g},eJ:1b(){1c a=1a.1e,b=1a.3D,c=1a.5m,d=[],e;if(1a.2U){e=b.1h;1k(a=1;a<e;a++)d=d.2g(1a.cM(c,b[a-1],b[a],!0))}1m if(1a.5T&&a.5m==="7Q")d=d.2g(cN(cJ(c),1a.1u,1a.1x,a.cK)),d[0]<1a.1u&&d.3u();1m 1k(b=1a.1u+(b[0]-1a.1u)%c;b<=1a.1x;b+=c)d.1o(b);1d d},eH:1b(){1c a=1a.1e,b=1a.1u,c=1a.1x,d,e=1a.2w-1a.2t>=1a.49,f,g,h,i,j;if(1a.3Q&&1a.49===y&&!1a.2U)r(a.1u)||r(a.1x)?1a.49=1g:(n(1a.1n,1b(a){i=a.4v;1k(g=j=a.7d?1:i.1h-1;g>0;g--)if(h=i[g]-i[g-1],f===y||h<f)f=h}),1a.49=K(f*5,1a.2w-1a.2t));if(c-b<1a.49){1c k=1a.49;d=(k-c+b)/2;d=[b-d,o(a.1u,b-d)];if(e)d[2]=1a.2t;b=pa(d);c=[b+k,o(a.1x,b+k)];if(e)c[2]=1a.2w;c=4X(c);c-b<k&&(d[0]=c-k,d[1]=o(a.1u,c-k),b=pa(d))}1a.1u=b;1a.1x=c},dO:1b(a){1c b=1a.1x-1a.1u,c=0,d,e=0,f=0,g=1a.5e,h=1a.5o;if(1a.3Q)g?(e=g.cu,f=g.eB):n(1a.1n,1b(a){1c g=a.3C,h=a.1e.gU,m=a.6G;g>b&&(g=0);c=q(c,g);e=q(e,h?0:g/2);f=q(f,h==="on"?0:g);!a.4H&&r(m)&&(d=r(d)?K(d,m):m)}),g=1a.dT&&d?1a.dT/ d : 1, 1a.cu = e *= g, 1a.eB = f *= g, 1a.3C = K(c, b), 1a.6G = d; if (a) 1a.ey = h; 1a.pF = 1a.5o = h = 1a.2r /(b+f||1);1a.8b=1a.2P?1a.1z:1a.3m;1a.8m=h*e},dD:1b(a){1c b=1a,c=b.1j,d=b.1e,e=b.2U,f=b.5T,g=b.3Q,h=b.5f,i=b.1e.pG,j=d.cQ,k=d.cR,m=d.2E,l=d.pL,p=d.83,s=b.3r;h?(b.5e=c[g?"1M":"23"][d.8G],c=b.5e.6o(),b.1u=o(c.1u,c.2t),b.1x=o(c.1x,c.2w),d.1F!==b.5e.1e.1F&&40(11,1)):(b.1u=o(b.4J,d.1u,b.2t),b.1x=o(b.4P,d.1x,b.2w));if(e)!a&&K(b.1u,o(b.2t,b.1u))<=0&&40(10,1),b.1u=ia(ka(b.1u)),b.1x=ia(ka(b.1x));if(b.81&&(b.4J=b.1u=q(b.1u,b.1x-b.81),b.4P=b.1x,a))b.81=1g;b.eC&&b.eC();b.eH();if(!s&&!b.8t&&!h&&r(b.1u)&&r(b.1x)&&(c=b.1x-b.1u)){if(!r(d.1u)&&!r(b.4J)&&k&&(b.2t<0||!b.eg))b.1u-=c*k;if(!r(d.1x)&&!r(b.4P)&&j&&(b.2w>0||!b.er))b.1x+=c*j}b.2E=b.1u===b.1x||b.1u===3Z 0||b.1x===3Z 0?1:h&&!m&&p===b.5e.1e.83?b.5e.2E:o(m,s?1:(b.1x-b.1u)*p/(b.2r||1));g&&!a&&n(b.1n,1b(a){a.9s(b.1u!==b.5U||b.1x!==b.ce)});b.dO(!0);b.ep&&b.ep();if(b.fu)b.2E=b.fu(b.2E);if(!m&&b.2E<l)b.2E=l;if(!f&&!e&&(a=I.6B(10,T(I.8e(b.2E)/I.cO)),!m))b.2E=ib(b.2E,1g,a,d);b.5m=d.5m==="7Q"&&b.2E?b.2E/5:d.5m;b.3D=i=d.3D?[].2g(d.3D):i&&i.2o(b,[b.1u,b.1x]);if(!i)i=f?(b.pk||cN)(cJ(b.2E,d.pq),b.1u,b.1x,d.cK,b.mz,b.6G,!0):e?b.cM(b.2E,b.1u,b.1x):b.8s(b.2E,b.1u,b.1x),b.3D=i;if(!h)e=i[0],f=i[i.1h-1],h=b.cu||0,d.ct?b.1u=e:b.1u-h>e&&i.3u(),d.cd?b.1x=f:b.1x+h<f&&i.9p(),i.1h===1&&(b.1u-=0.9P,b.1x+=0.9P)},dt:1b(){1c a=1a.1j,b=a.5K||{},c=1a.3D,d=1a.fh=[1a.7u,1a.3a,1a.2r].2q("-");if(!1a.5f&&!1a.5T&&c&&c.1h>(b[d]||0)&&1a.1e.b9!==!1)b[d]=c.1h;a.5K=b},ix:1b(){1c a=1a.fh,b=1a.3D,c=1a.1j.5K;if(c&&c[a]&&!1a.5T&&!1a.3r&&!1a.5f&&1a.1e.b9!==!1){1c d=1a.fc,e=b.1h;1a.fc=a=c[a];if(e<a){1k(;b.1h<a;)b.1o(ia(b[b.1h-1]+1a.2E));1a.5o*=(e-1)/(a-1);1a.1x=b[b.1h-1]}if(r(d)&&a!==d)1a.1S=!0}},8K:1b(){1c a=1a.4o,b,c,d,e;1a.5U=1a.1u;1a.ce=1a.1x;1a.f6=1a.2r;1a.e3();e=1a.2r!==1a.f6;n(1a.1n,1b(a){if(a.5A||a.1S||a.1M.1S)d=!0});if(e||d||1a.5f||1a.dX||1a.4J!==1a.f8||1a.4P!==1a.f9)if(1a.dX=!1,1a.f7(),1a.dD(),1a.f8=1a.4J,1a.f9=1a.4P,!1a.1S)1a.1S=e||1a.1u!==1a.5U||1a.1x!==1a.ce;if(!1a.3Q)1k(b in a)1k(c in a[b])a[b][c].7b=a[b][c].4e;1a.dt()},9h:1b(a,b,c,d,e){1c f=1a,g=f.1j,c=o(c,!0),e=v(e,{1u:a,1x:b});D(f,"9h",e,1b(){f.4J=a;f.4P=b;f.b7=!0;c&&g.2m(d)})},46:1b(a,b){1a.pz||(a<=1a.2t&&(a=y),b>=1a.2w&&(b=y));1a.ie=a!==y||b!==y;1a.9h(a,b,!1,y,{aA:"46"});1d!0},e3:1b(){1c a=1a.1j,b=1a.1e,c=b.eI||0,d=b.pM||0,e=1a.2P,f,g;1a.1z=g=o(b.1z,a.1U+c);1a.1H=f=o(b.1H,a.1X);1a.1f=c=o(b.1f,a.2K-c+d);1a.1l=b=o(b.1l,a.33);1a.3m=a.3g-b-f;1a.2a=a.3f-c-g;1a.2r=q(e?c:b,0);1a.3a=e?g:f},6o:1b(){1c a=1a.2U;1d{1u:a?ia(da(1a.1u)):1a.1u,1x:a?ia(da(1a.1x)):1a.1x,2t:1a.2t,2w:1a.2w,4J:1a.4J,4P:1a.4P}},dj:1b(a){1c b=1a.2U,c=b?da(1a.1u):1a.1u,b=b?da(1a.1x):1a.1x;c>a||a===1g?a=c:b<a&&(a=b);1d 1a.1L(a,0,1,0,1)},ow:1b(a){1a.8g(a,"eM")},nf:1b(a){1a.8g(a,"eL")},8g:1b(a,b){1c c=(2f pb(1a,a)).2d(),d=1a.4u;b&&(d[b]=d[b]||[],d[b].1o(a));1a.6D.1o(c);1d c},ik:1b(){1c a=1a,b=a.1j,c=b.1v,d=a.1e,e=a.3D,f=a.7M,g=a.2P,h=a.8h,i=b.1R?[1,0,3,2][h]:h,j,k=0,m,l=0,p=d.1W,s=d.2y,t=0,B=b.dQ,w=b.dG,G=[-1,1,1,-1][h],v;a.eS=b=a.c9||r(a.1u)&&r(a.1x)&&!!e;a.eO=j=b||o(d.ne,!0);if(!a.6d)a.cj=c.g("fp").1i({1D:d.ng||1}).1s(),a.6d=c.g("2e").1i({1D:d.1D||2}).1s(),a.ck=c.g("2e-2y").1i({1D:s.1D||7}).1s();if(b||a.5f)n(e,1b(b){f[b]?f[b].c5():f[b]=2f 5k(a,b)}),n(e,1b(a){if(h===0||h===2||{1:"1z",3:"2a"}[h]===s.1y)t=q(f[a].fk(),t)}),a.5b&&(t+=(a.5b-1)*16);1m 1k(v in f)f[v].1t(),29 f[v];if(p&&p.1C&&p.1N!==!1){if(!a.5l)a.5l=c.1C(p.1C,0,0,p.4w).1i({1D:7,26:p.26||0,1y:p.3B||{dw:"1z",4f:"1Q",fo:"2a"}[p.1y]}).1G(p.1p).1s(a.6d),a.5l.3A=!0;if(j)k=a.5l.31()[g?"1l":"1f"],l=o(p.7q,g?5:10),m=p.2Y;a.5l[j?"3K":"2D"]()}a.2Y=G*o(d.2Y,B[h]);a.c7=o(m,t+l+(h!==2&&t&&G*d.2y[g?"y":"x"]));B[h]=q(B[h],a.c7+k+G*a.2Y);w[i]=q(w[i],d.2N)},eT:1b(a){1c b=1a.1j,c=1a.4k,d=1a.2Y,e=1a.2P,f=1a.1z+(c?1a.1f:0)+d;1a.nh=d=b.3g-1a.3m-(c?1a.1l:0)+d;c||(a*=-1);1d b.1v.8o(["M",e?1a.1z:f,e?d:1a.1H,"L",e?b.3f-1a.2a:f,e?d:b.3g-1a.3m],a)},eU:1b(){1c a=1a.2P,b=1a.1z,c=1a.1H,d=1a.2r,e=1a.1e.1W,f=a?b:c,g=1a.4k,h=1a.2Y,i=u(e.1p.2z||12),d={dw:f+(a?0:d),4f:f+d/2,fo:f+(a?d:0)}[e.1y],b=(a?c+1a.1l:b)+(a?1:-1)*(g?-1:1)*1a.c7+(1a.8h===2?i:0);1d{x:a?d:b+(g?1a.1f:0)+h+(e.x||0),y:a?b-(g?1a.1l:0)+h:d+(e.y||0)}},2d:1b(){1c a=1a,b=a.1j,c=b.1v,d=a.1e,e=a.2U,f=a.5f,g=a.3D,h=a.5l,i=a.4o,j=a.7M,k=a.cs,m=a.co,l=d.c8,p=d.ni,s=a.ch,o=d.2N,B,w=b.55&&r(a.5U)&&!3v(a.5U);B=a.eS;1c q=a.eO,t,v;n([j,k,m],1b(a){1k(1c b in a)a[b].6x=!1});if(B||f)if(a.5m&&!a.3r&&n(a.eJ(),1b(b){k[b]||(k[b]=2f 5k(a,b,"nd"));w&&k[b].3A&&k[b].2d(1g,!0);k[b].2d(1g,!1,1)}),g.1h&&(n(g.3t(1).2g([g[0]]),1b(b,c){c=c===g.1h-1?0:c+1;if(!f||b>=a.1u&&b<=a.1x)j[b]||(j[b]=2f 5k(a,b)),w&&j[b].3A&&j[b].2d(c,!0),j[b].2d(c,!1,1)}),s&&a.1u===0&&(j[-1]||(j[-1]=2f 5k(a,-1,1g,!0)),j[-1].2d(-1))),p&&n(g,1b(b,c){if(c%2===0&&b<a.1x)m[b]||(m[b]=2f pb(a)),t=b+s,v=g[c+1]!==y?g[c+1]+s:a.1x,m[b].1e={bh:e?da(t):t,eK:e?da(v):v,1r:p},m[b].2d(),m[b].6x=!0}),!a.cq)n((d.eL||[]).2g(d.eM||[]),1b(b){a.8g(b)}),a.cq=!0;n([j,k,m],1b(a){1c c,d,e=[],f=4F?4F.4B||8x:0,g=1b(){1k(d=e.1h;d--;)a[e[d]]&&!a[e[d]].6x&&(a[e[d]].1t(),29 a[e[d]])};1k(c in a)if(!a[c].6x)a[c].2d(c,!1,0),a[c].6x=!1,e.1o(c);a===m||!b.55||!f?g():f&&57(g,f)});if(o)B=a.eT(o),a.7O?a.7O.1B({d:B}):a.7O=c.2v(B).1i({1q:d.6y,"1q-1f":o,1D:7}).1s(a.6d),a.7O[q?"3K":"2D"]();if(h&&q)h[h.3A?"1i":"1B"](a.eU()),h.3A=!1;if(l&&l.1N){1c u,x,d=a.cn;if(!d)a.cn=d=c.g("cr-2y").1i({2s:"1E",1D:6}).1s();d.1L(b.1U,b.1X);1k(u in i)1k(x in c=i[u],c)c[x].2d(d)}a.1S=!1},h9:1b(a){1k(1c b=1a.6D,c=b.1h;c--;)b[c].id===a&&b[c].1t()},dB:1b(a,b){1a.6n({1W:a},b)},2m:1b(){1c a=1a.1j.3w;a.5x&&a.5x(!0);1a.2d();n(1a.6D,1b(a){a.2d()});n(1a.1n,1b(a){a.1S=!0})},nc:1b(a,b){1a.6n({3r:a},b)},1t:1b(){1c a=1a,b=a.4o,c;ba(a);1k(c in b)5j(b[c]),b[c]=1g;n([a.7M,a.cs,a.co,a.6D],1b(a){5j(a)});n("cn,7O,6d,cj,ck,5l".2p(","),1b(b){a[b]&&(a[b]=a[b].1t())})}};9l.1w={1K:1b(a,b){1c c=b.3d,d=b.1p,e=u(d.2Q);1a.1j=a;1a.1e=b;1a.5v=[];1a.cl={x:0,y:0};1a.3U=!0;1a.27=a.1v.27("",0,0,b.5O,1g,1g,b.4w,1g,"2H").1i({2Q:e,1I:b.5F,"1q-1f":c,r:b.3S,1D:8}).1G(d).1G({2Q:0}).2D().1s();$||1a.27.1Z(b.1Z);1a.4I=b.4I},1t:1b(){n(1a.5v,1b(a){a&&a.1t()});if(1a.27)1a.27=1a.27.1t();5n(1a.8u);5n(1a.88)},9d:1b(a,b,c,d){1c e=1a,f=e.cl,g=e.1e.2W!==!1&&!e.3U;v(f,{x:g?(2*f.x+a)/3:a,y:g?(f.y+b)/ 2 : b, 5J: g ? (2 * f.5J + c)/3:c,5M:g?(f.5M+d)/2:d});e.27.1i(f);if(g&&(Q(a-f.x)>1||Q(b-f.y)>1))5n(1a.88),1a.88=57(1b(){e&&e.9d(a,b,c,d)},32)},2D:1b(){1c a=1a,b;5n(1a.8u);if(!1a.3U)b=1a.1j.3W,1a.8u=57(1b(){a.27.f0();a.3U=!0},o(1a.1e.n6,8x)),b&&n(b,1b(a){a.35()}),1a.1j.3W=1g},j4:1b(){n(1a.5v,1b(a){a&&a.2D()})},a9:1b(a,b){1c c,d=1a.1j,e=d.1R,f=d.1X,g=0,h=0,i,a=ha(a);c=a[0].iD;1a.6q&&b&&(b.3j===y&&(b=d.3w.4O(b)),c=[b.3j-d.1U,b.3e-f]);c||(n(a,1b(a){i=a.1n.23;g+=a.1P;h+=(a.eZ?(a.eZ+a.n7)/2:a.2c)+(!e&&i?i.1H-f:0)}),g/= a.1h, h /=a.1h,c=[e?d.2K-h:g,1a.4I&&!e&&a.1h>1&&b?b.3e-f:e?d.33-g:h]);1d 59(c,t)},8l:1b(a,b,c){1c d=1a.1j,e=d.1U,f=d.1X,g=d.2K,h=d.33,i=o(1a.1e.9z,12),j=c.1P,c=c.2c,d=j+e+(d.1R?i:-a-i),k=c-b+f+15,m;d<7&&(d=e+q(j,0)+i);d+a>e+g&&(d-=d+a-(e+g),k=c-b+f-i,m=!0);k<f+5&&(k=f+5,m&&c>=k&&c<=k+b&&(k=c+f+i));k+b>f+h&&(k=q(f,f+h-b-i));1d{x:d,y:k}},eW:1b(a){1c b=1a.2h||ha(1a),c=b[0].1n,d;d=[c.fz(b[0])];n(b,1b(a){c=a.1n;d.1o(c.8y&&c.8y(a)||a.28.8y(c.6T.aN))});d.1o(a.1e.n9||"");1d d.2q("")},8z:1b(a,b){1c c=1a.1j,d=1a.27,e=1a.1e,f,g,h,i={},j,k=[];j=e.5g||1a.eW;1c i=c.3W,m,l=e.5v;h=1a.4I;5n(1a.8u);1a.6q=ha(a)[0].1n.6T.6q;g=1a.a9(a,b);f=g[0];g=g[1];h&&(!a.1n||!a.1n.4H)?(c.3W=a,i&&n(i,1b(a){a.35()}),n(a,1b(a){a.35("2V");k.1o(a.9S())}),i={x:a[0].6U,y:a[0].y},i.2h=k,a=a[0]):i=a.9S();j=j.1Y(i,1a);i=a.1n;h=h||!i.45||i.hP||c.3M(f,g);j===!1||!h?1a.2D():(1a.3U&&(6i(d),d.1i("1T",1).3K()),d.1i({1C:j}),m=e.3o||a.1r||i.1r||"#f2",d.1i({1q:m}),1a.a4({1P:f,2c:g}),1a.3U=!1);if(l){l=ha(l);1k(d=l.1h;d--;)if(e=a.1n[d?"23":"1M"],l[d]&&e)if(h=d?o(a.fU,a.y):a.x,e.2U&&(h=ka(h)),e=e.6c(h,1),1a.5v[d])1a.5v[d].1i({d:e,2s:"1E"});1m{h={"1q-1f":l[d].1f||1,1q:l[d].1r||"#9k",1D:l[d].1D||2};if(l[d].5W)h.4g=l[d].5W;1a.5v[d]=c.1v.2v(e).1i(h).1s()}}D(c,"n8",{1C:j,x:f+c.1U,y:g+c.1X,3o:m})},a4:1b(a){1c b=1a.1j,c=1a.27,c=(1a.1e.nj||1a.8l).1Y(1a,c.1f,c.1l,a);1a.9d(t(c.x),t(c.y),a.1P+b.1U,a.2c+b.1X)}};9v.1w={1K:1b(a,b){1c c=$?"":b.1j.nk,d=a.1R,e;1a.1e=b;1a.1j=a;1a.aE=e=/x/.2i(c);1a.aD=c=/y/.2i(c);1a.ao=e&&!d||c&&d;1a.aj=c&&!d||e&&d;1a.ai=[];1a.jd={};if(b.2H.1N)a.2H=2f 9l(a,b.2H);1a.hM()},4O:1b(a){1c b,c,d,a=a||O.gx;if(!a.5p)a.5p=a.hB;a=ah(a);d=a.5r?a.5r.iS(0):a;1a.8r=b=j7(1a.1j.3x);d.5z===y?(c=a.x,b=a.y):(c=d.5z-b.1z,b=d.7I-b.1H);1d v(a,{3j:t(c),3e:t(b)})},jh:1b(a){1c b={1M:[],23:[]};n(1a.1j.2Z,1b(c){b[c.3Q?"1M":"23"].1o({2e:c,6g:c.8i(a[c.2P?"3j":"3e"])})});1d b},j6:1b(a){1c b=1a.1j;1d b.1R?b.33+b.1X-a.3e:a.3j-b.1U},8q:1b(a){1c b=1a.1j,c=b.1n,d=b.2H,e,f=b.4h,g=b.3J,h,i,j=b.3f,k=1a.j6(a);if(d&&1a.1e.2H.4I&&(!g||!g.4H)){e=[];h=c.1h;1k(i=0;i<h;i++)if(c[i].1E&&c[i].1e.cX!==!1&&!c[i].4H&&c[i].6S.1h&&(b=c[i].6S[k],b.1n))b.a1=Q(k-b.51),j=K(j,b.a1),e.1o(b);1k(h=e.1h;h--;)e[h].a1>j&&e.2X(h,1);if(e.1h&&e[0].51!==1a.a6)d.8z(e,a),1a.a6=e[0].51}if(g&&g.3Y){if((b=g.6S[k])&&b!==f)b.53(a)}1m d&&d.6q&&!d.3U&&(a=d.a9([{}],a),d.a4({1P:a[0],2c:a[1]}))},5x:1b(a){1c b=1a.1j,c=b.3J,d=b.4h,e=b.2H,b=e&&e.4I?b.3W:d;(a=a&&e&&b)&&ha(b)[0].1P===y&&(a=!1);if(a)e.8z(b);1m{if(d)d.3T();if(c)c.3T();e&&(e.2D(),e.j4());1a.a6=1g}},ak:1b(a,b){1c c=1a.1j;n(c.1n,1b(d){d.1M&&d.1M.7k&&(d.1O.1i(a),d.3n&&(d.3n.1i(a),d.3n.2G(b?c.2R:1g)),d.5q&&d.5q.1i(a))});c.2R.1i(b||c.8j)},ad:1b(a,b,c,d,e,f,g){1c h=1a.1j,i=a?"x":"y",j=a?"X":"Y",k="1j"+j,m=a?"1f":"1l",l=h["j9"+(a?"nt":"ns")],p,s,o=1,n=h.1R,w=h.bf[a?"h":"v"],q=b.1h===1,t=b[0][k],r=c[0][k],v=!q&&b[1][k],u=!q&&c[1][k],x,c=1b(){!q&&Q(t-v)>20&&(o=Q(r-u)/Q(t-v));s=(l-r)/ o + t; p = h["j9" + (a ? "je" : "nu")] /o};c();b=s;b<w.1u?(b=w.1u,x=!0):b+p>w.1x&&(b=w.1x-p,x=!0);x?(r-=0.8*(r-g[i][0]),q||(u-=0.8*(u-g[i][1])),c()):g[i]=[r,u];n||(f[i]=s-l,f[m]=p);f=n?1/o:o;e[m]=p;e[i]=b;d[n?a?"54":"7c":"ax"+j]=o;d["1L"+j]=f*l+(r-f*t)},8v:1b(a){1c b=1a,c=b.1j,d=b.ai,e=c.2H&&c.2H.1e.nv,f=a.5r,g=f.1h,h=b.jd,i=b.ao||b.ox,j=b.aj||b.nw,k=i||j,m=b.3p,l={},p={};a.1F==="9W"&&(e||k)&&a.6t();59(f,1b(a){1d b.4O(a)});if(a.1F==="9W")n(f,1b(a,b){d[b]={3j:a.3j,3e:a.3e}}),h.x=[d[0].3j,d[1]&&d[1].3j],h.y=[d[0].3e,d[1]&&d[1].3e],n(c.2Z,1b(a){if(a.7k){1c b=c.bf[a.2P?"h":"v"],d=a.8m,e=a.7W(a.2t),f=a.7W(a.2w),g=K(e,f),e=q(e,f);b.1u=K(a.3a,g-d);b.1x=q(a.3a+a.2r,e+d)}});1m if(d.1h){if(!m)b.3p=m=v({1t:48},c.7S);i&&b.ad(!0,d,f,l,m,p,h);j&&b.ad(!1,d,f,l,m,p,h);b.al=k;b.ak(l,p);!k&&e&&g===1&&1a.8q(b.4O(a))}},j1:1b(a){1c b=1a.1j;b.ae=a.1F;b.ag=!1;b.7G=1a.7G=a.3j;1a.iW=a.3e},j0:1b(a){1c b=1a.1j,c=b.1e.1j,d=a.3j,a=a.3e,e=1a.ao,f=1a.aj,g=b.1U,h=b.1X,i=b.2K,j=b.33,k,m=1a.7G,l=1a.iW;d<g?d=g:d>g+i&&(d=g+i);a<h?a=h:a>h+j&&(a=h+j);1a.7F=7h.nr(7h.6B(m-d,2)+7h.6B(l-a,2));if(1a.7F>10){k=b.3M(m-g,l-h);if(b.5X&&(1a.aE||1a.aD)&&k&&!1a.3p)1a.3p=b.1v.2I(g,h,e?1:i,f?1:j,0).1i({1I:c.nq||"44(69,nm,nl,0.25)",1D:7}).1s();1a.3p&&e&&(e=d-m,1a.3p.1i({1f:Q(e),x:(e>0?0:e)+m}));1a.3p&&f&&(e=a-l,1a.3p.1i({1l:Q(e),y:(e>0?0:e)+l}));k&&!1a.3p&&c.nn&&b.aB(d)}},av:1b(a){1c b=1a.1j,c=1a.al;if(1a.3p){1c d={1M:[],23:[],as:a.as||a},e=1a.3p,f=e.x,g=e.y,h;if(1a.7F||c)n(b.2Z,1b(a){if(a.7k){1c b=a.2P,c=a.8i(b?f:g),b=a.8i(b?f+e.1f:g+e.1l);!3v(c)&&!3v(b)&&(d[a.7u+"9y"].1o({2e:a,1u:K(c,b),1x:q(c,b)}),h=!0)}}),h&&D(b,"it",d,1b(a){b.46(v(a,c?{2W:!1}:1g))});1a.3p=1a.3p.1t();c&&1a.ak({2C:b.1U,2n:b.1X,7c:1,54:1})}if(b)L(b.3x,{3b:b.ir}),b.ag=1a.7F>10,b.ae=1a.7F=1a.al=!1,1a.ai=[]},hI:1b(a){a=1a.4O(a);a.6t&&a.6t();1a.j1(a)},hO:1b(a){1a.av(a)},hN:1b(a){1c b=1a.1j,c=1a.8r,d=b.3J,a=ah(a);c&&d&&d.45&&!b.3M(a.5z-c.1z-b.1U,a.7I-c.1H-b.1X)&&1a.5x()},hG:1b(){1a.5x();1a.8r=1g},hD:1b(a){1c b=1a.1j,a=1a.4O(a);a.no=!1;b.ae==="np"&&1a.j0(a);b.3M(a.3j-b.1U,a.3e-b.1X)&&!b.n3&&1a.8q(a)},an:1b(a,b){1k(1c c;a;){if(c=A(a,"3V"))if(c.3H(b)!==-1)1d!0;1m if(c.3H("2j-3x")!==-1)1d!1;a=a.41}},e9:1b(a){1c b=1a.1j.3J;if(b&&!b.1e.6r&&!1a.an(a.n2||a.mJ,"2j-2H"))b.3T()},hE:1b(a){1c b=1a.1j,c=b.4h,d=b.1U,e=b.1X,f=b.1R,g,h,i,a=1a.4O(a);a.mI=!0;if(!b.ag)c&&1a.an(a.5p,"2j-3Y")?(g=1a.8r,h=c.1P,i=c.2c,v(c,{5z:g.1z+d+(f?b.2K-i:h),7I:g.1H+e+(f?b.33-h:i)}),D(c.1n,"3h",v(a,{28:c})),b.4h&&c.3O("3h",a)):(v(a,1a.jh(a)),b.3M(a.3j-d,a.3e-e)&&D(b,"3h",a))},hW:1b(a){1c b=1a.1j;a.5r.1h===1?(a=1a.4O(a),b.3M(a.3j-b.1U,a.3e-b.1X)&&(1a.8q(a),1a.8v(a))):a.5r.1h===2&&1a.8v(a)},hX:1b(a){(a.5r.1h===1||a.5r.1h===2)&&1a.8v(a)},hY:1b(a){1a.av(a)},hM:1b(){1c a=1a,b=a.1j.3x,c;1a.ar=c=[[b,"mK","hI"],[b,"hH","hD"],[b,"cU","hE"],[b,"au","hG"],[z,"mL","hN"],[z,"mM","hO"]];fb&&c.1o([b,"ap","hW"],[b,"mH","hX"],[z,"mG","hY"]);n(c,1b(b){a["86"+b[2]]=1b(c){a[b[2]](c)};b[1].3H("on")===0?b[0][b[1]]=a["86"+b[2]]:J(b[0],b[1],a["86"+b[2]])})},1t:1b(){1c a=1a;n(a.ar,1b(b){b[1].3H("on")===0?b[0][b[1]]=1g:ba(b[0],b[1],a["86"+b[2]])});29 a.ar;mB(a.88)}};9w.1w={1K:1b(a,b){1c c=1a,d=b.7w,e=o(b.2Q,8),f=b.a3||0;1a.1e=b;if(b.1N)c.9m=u(d.2z)+3+f,c.7w=d,c.7y=x(d,b.7y),c.a3=f,c.2Q=e,c.9Z=e,c.hg=e-5,c.a7=0,c.1j=a,c.he=0,c.5y=0,c.2d(),J(c.1j,"io",1b(){c.8w()})},9M:1b(a,b){1c c=1a.1e,d=a.4E,e=a.dF,f=a.9E,g=1a.7y.1r,c=b?c.7w.1r:g,h=b?a.1r:g,g=a.1e&&a.1e.2k,i={1q:h,1I:h},j;d&&d.1G({1I:c,1r:c});e&&e.1i({1q:h});if(f){if(g)1k(j in g=a.4p(g),g)d=g[j],d!==y&&(i[j]=d);f.1i(i)}},hz:1b(a){1c b=1a.1e,c=b.a2,b=!b.hQ,d=a.hd,e=d[0],d=d[1],f=a.47;a.4G&&a.4G.1L(b?e:1a.8T-e-2*c-4,d);if(f)f.x=e,f.y=d},dR:1b(a){1c b=a.47;n(["4E","dF","9E","4G"],1b(b){a[b]&&a[b].1t()});b&&6e(a.47)},1t:1b(){1c a=1a.1O,b=1a.3s;if(b)1a.3s=b.1t();if(a)1a.1O=a.1t()},8w:1b(a){1c b=1a.1O.a0,c,d=1a.8V||1a.8D;if(b)c=b.2n,n(1a.hp,1b(e){1c f=e.47,g;f&&(g=c+f.y+(a||0)+3,L(f,{1z:b.2C+e.hi+f.x-20+"px",1H:g+"px",3y:g>c-6&&g<c+d-6?"":S}))})},hh:1b(){1c a=1a.2Q,b=1a.1e.1W,c=0;if(b.1C){if(!1a.1W)1a.1W=1a.1j.1v.27(b.1C,a-3,a-4,1g,1g,1g,1g,1g,"3k-1W").1i({1D:1}).1G(b.1p).1s(1a.1O);c=1a.1W.31().1l;1a.93.1i({2n:c})}1a.8W=c},hw:1b(a){1c w;1c b=1a,c=b.1j,d=c.1v,e=b.1e,f=e.aZ==="aV",g=e.9u,h=e.a2,i=b.7w,j=b.7y,k=b.2Q,m=!e.hQ,l=e.1f,p=e.mA||0,s=b.a3,o=b.9Z,n=a.4E,t=a.1n||a,r=t.1e,v=r.hS,u=e.4w;if(!n&&(a.4G=d.g("3k-iS").1i({1D:1}).1s(b.8Y),t.5L(b,a),a.4E=n=d.1C(e.hA?34(e.hA,a):e.8c.1Y(a),m?g+h:-h,b.9m,u).1G(x(a.1E?i:j)).1i({1y:m?"1z":"2a",1D:2}).1s(a.4G),(u?n:a.4G).on("cY",1b(){a.35("2V");n.1G(b.1e.hk)}).on("ec",1b(){n.1G(a.1E?i:j);a.35()}).on("3h",1b(b){1c c=1b(){a.5C()},b={mC:b};a.3O?a.3O("hl",b,c):D(a,"hl",b,c)}),b.9M(a,a.1E),r&&v))a.47=U("mD",{1F:"47",9D:a.2M,mF:a.2M},e.hn,c.3x),J(a.47,"3h",1b(b){D(a,"mE",{9D:b.5p.9D},1b(){a.2u()})});d=n.31();w=a.hi=e.mN||g+h+d.1f+k+(v?20:0),e=w;b.he=g=d.1l;if(f&&b.60-o+e>(l||c.3f-2*k-o))b.60=o,b.7B+=s+b.5y+p,b.5y=0;b.a7=q(b.a7,e);b.b1=s+b.7B+p;b.5y=q(g,b.5y);a.hd=[b.60,b.7B];f?b.60+=e:(b.7B+=s+g+p,b.5y=g);b.3X=l||q(f?b.60-o:e,b.3X)},2d:1b(){1c a=1a,b=a.1j,c=b.1v,d=a.1O,e,f,g,h,i=a.3s,j=a.1e,k=a.2Q,m=j.3d,l=j.5F;a.60=a.9Z;a.7B=a.hg;a.3X=0;a.b1=0;if(!d)a.1O=d=c.g("3k").1i({1D:7}).1s(),a.93=c.g().1i({1D:1}).1s(d),a.8Y=c.g().1s(a.93);a.hh();e=[];n(b.1n,1b(a){1c b=a.1e;b.aS&&!r(b.8G)&&(e=e.2g(a.mY||(b.9L==="28"?a.1V:a)))});cV(e,1b(a,b){1d(a.1e&&a.1e.ho||0)-(b.1e&&b.1e.ho||0)});j.3L&&e.df();a.hp=e;a.3y=f=!!e.1h;n(e,1b(b){a.hw(b)});g=j.1f||a.3X;h=a.b1+a.5y+a.8W;h=a.9i(h);if(m||l){g+=k;h+=k;if(i){if(g>0&&h>0)i[i.3A?"1i":"1B"](i.4U(1g,1g,1g,g,h)),i.3A=!1}1m a.3s=i=c.2I(0,0,g,h,j.3S,m||0).1i({1q:j.3o,"1q-1f":m||0,1I:l||S}).1s(d).1Z(j.1Z),i.3A=!0;i[f?"3K":"2D"]()}a.8T=g;a.8D=h;n(e,1b(b){a.hz(b)});f&&d.1y(v({1f:g,1l:h},j),!0,"7N");b.82||1a.8w()},9i:1b(a){1c b=1a,c=1a.1j,d=c.1v,e=1a.1e,f=e.y,f=c.7N.1l+(e.3c==="1H"?-f:f)-1a.2Q,g=e.n0,h=1a.2R,i=e.aX,j=o(i.2W,!0),k=i.n1||12,m=1a.aY;e.aZ==="aV"&&(f/=2);g&&(f=K(f,g));if(a>f&&!e.4w){1a.8V=c=f-20-1a.8W;1a.ay=ja(a/c);1a.9j=o(1a.9j,1);1a.iC=a;if(!h)h=b.2R=d.2R(0,0,aq,0),b.93.2G(h);h.1i({1l:c});if(!m)1a.aY=m=d.g().1i({1D:1}).1s(1a.1O),1a.i0=d.2b("6z",0,0,k,k).on("3h",1b(){b.8Z(-1,j)}).1s(m),1a.b5=d.1C("",15,10).1G(i.1p).1s(m),1a.7C=d.2b("6z-7C",0,0,k,k).on("3h",1b(){b.8Z(1,j)}).1s(m);b.8Z(0);a=f}1m if(m)h.1i({1l:c.3g}),m.2D(),1a.8Y.1i({2n:1}),1a.8V=0;1d a},8Z:1b(a,b){1c c=1a.ay,d=1a.9j+a,e=1a.8V,f=1a.1e.aX,g=f.hs,h=f.ht,f=1a.b5,i=1a.2Q;d>c&&(d=c);if(d>0)b!==y&&4Y(b,1a.1j),1a.aY.1i({2C:i,2n:e+7+1a.8W,2s:"1E"}),1a.i0.1i({1I:d===1?h:g}).1G({3b:d===1?"4x":"3w"}),f.1i({1C:d+"/"+1a.ay}),1a.7C.1i({x:18+1a.b5.31().1f,1I:d===c?h:g}).1G({3b:d===c?"4x":"3w"}),e=-K(e*(d-1),1a.iC-e+i)+1,1a.8Y.1B({2n:e}),f.1i({1C:d+"/"+c}),1a.9j=d,1a.8w(e)}};9G.1w={1K:1b(a,b){1c c,d=a.1n;a.1n=1g;c=x(N,a);c.1n=a.1n=d;1c d=c.1j,e=d.7q,e=V(e)?e:[e,e,e,e];1a.8S=o(d.bd,e[0]);1a.e7=o(d.5R,e[1]);1a.ed=o(d.4Z,e[2]);1a.8N=o(d.be,e[3]);1a.mW=(e=d.39)&&!!e.3h;1a.bf={h:{},v:{}};1a.hJ=b;1a.82=0;1a.1e=c;1a.2Z=[];1a.1n=[];1a.5X=d.mV;1c f=1a,g;f.2A=4L.1h;4L.1o(f);d.mQ!==!1&&J(f,"jg",1b(){f.il()});if(e)1k(g in e)J(f,g,e[g]);f.1M=[];f.23=[];f.2W=$?!1:o(d.2W,!0);f.8H=0;f.dr=2f bc;f.76()},cW:1b(a){1c b=1a.1e.1j;(b=aa[a.1F||b.1F||b.dv])||40(17,!0);b=2f b;b.1K(1a,a);1d b},iz:1b(a,b,c){1c d,e=1a;a&&(b=o(b,!0),D(e,"iz",{1e:a},1b(){d=e.cW(a);e.6O=!0;b&&e.2m(c)}));1d d},mP:1b(a,b,c,d){1c b=b?"1M":"23",e=1a.1e;2f ab(1a,x(a,{2A:1a[b].1h}));e[b]=ha(e[b]||{});e[b].1o(a);o(c,!0)&&1a.2m(d)},3M:1b(a,b,c){1c d=c?b:a,a=c?a:b;1d d>=0&&d<=1a.2K&&a>=0&&a<=1a.33},8L:1b(){1a.1e.1j.b9!==!1&&n(1a.2Z,1b(a){a.ix()});1a.5K=1g},2m:1b(a){1c b=1a.2Z,c=1a.1n,d=1a.3w,e=1a.3k,f=1a.6O,g,h=1a.4D,i=c.1h,j=i,k=1a.1v,m=k.3U(),l=[];4Y(a,1a);1k(m&&1a.77();j--;)if(a=c[j],a.1S&&a.1e.3z){g=!0;3R}if(g)1k(j=i;j--;)if(a=c[j],a.1e.3z)a.1S=!0;n(c,1b(a){a.1S&&a.1e.9L==="28"&&(f=!0)});if(f&&e.1e.1N)e.2d(),1a.6O=!1;if(1a.5X){if(!1a.82)1a.5K=1g,n(b,1b(a){a.8K()});1a.8L();1a.7U();n(b,1b(a){if(a.b7)a.b7=!1,l.1o(1b(){D(a,"mR",a.6o())});if(a.1S||h||g)a.2m(),h=!0})}h&&1a.ds();n(c,1b(a){a.1S&&a.1E&&(!a.45||a.1M)&&a.2m()});d&&d.5x&&d.5x(!0);k.d8();D(1a,"2m");m&&1a.77(!0);n(l,1b(a){a.1Y()})},mS:1b(a){1c b=1a.1e,c=1a.aT,d=b.6f;if(!c)1a.aT=c=U(4C,{5i:"2j-6f"},v(d.1p,{1D:10,3y:S}),1a.3x),1a.iN=U("2O",1g,d.iG,c);1a.iN.4s=a||b.5u.6f;if(!1a.aG)L(c,{1T:0,3y:"",1z:1a.1U+"px",1H:1a.1X+"px",1f:1a.2K+"px",1l:1a.33+"px"}),96(c,{1T:d.1p.1T},{4B:d.mU||0}),1a.aG=!0},mT:1b(){1c a=1a.1e,b=1a.aT;b&&96(b,{1T:0},{4B:a.6f.ny||36,7f:1b(){L(b,{3y:S})}});1a.aG=!1},2S:1b(a){1c b=1a.2Z,c=1a.1n,d,e;1k(d=0;d<b.1h;d++)if(b[d].1e.id===a)1d b[d];1k(d=0;d<c.1h;d++)if(c[d].1e.id===a)1d c[d];1k(d=0;d<c.1h;d++){e=c[d].2h||[];1k(b=0;b<e.1h;b++)if(e[b].id===a)1d e[b]}1d 1g},iX:1b(){1c a=1a,b=1a.1e,c=b.1M=ha(b.1M||{}),b=b.23=ha(b.23||{});n(c,1b(a,b){a.2A=b;a.iH=!0});n(b,1b(a,b){a.2A=b});c=c.2g(b);n(c,1b(b){2f ab(a,b)});a.8L()},eX:1b(){1c a=[];n(1a.1n,1b(b){a=a.2g(ob(b.2h||[],1b(a){1d a.2M}))});1d a},od:1b(){1d ob(1a.1n,1b(a){1d a.2M})},i7:1b(){1c a=1a,b=N.5u,c=a.1e.1j.6a,d=c.iI,e=d.3N,f=c.oc==="1j"?1g:"7S";1a.6a=a.1v.aH(b.iJ,1g,1g,1b(){a.iu()},d,e&&e.2V).1i({1y:c.2F.1y,1W:b.iK}).1s().1y(c.2F,!1,f)},iu:1b(){1c a=1a;D(a,"it",{i8:!0},1b(){a.46()})},46:1b(a){1c b,c=1a.3w,d=!1,e;!a||a.i8?n(1a.2Z,1b(a){b=a.46()}):n(a.1M.2g(a.23),1b(a){1c e=a.2e,h=e.3Q;if(c[h?"aE":"aD"]||c[h?"of":"og"])b=e.46(a.1u,a.1x),e.ie&&(d=!0)});e=1a.6a;if(d&&!e)1a.i7();1m if(!d&&V(e))1a.6a=e.1t();b&&1a.2m(o(1a.1e.1j.2W,a&&a.2W,1a.8H<36))},aB:1b(a){1c b=1a.1M[0],c=1a.7G,d=b.3C/2,e=b.6o(),f=b.1L(c-a,!0)+d,c=b.1L(c+1a.2K-a,!0)-d;(d=1a.3W)&&n(d,1b(a){a.35()});b.1n.1h&&f>K(e.2t,e.1u)&&c<q(e.2w,e.1x)&&b.9h(f,c,!0,!1,{aA:"aB"});1a.7G=a;L(1a.3x,{3b:"9d"})},dB:1b(a,b){1c f;1c c=1a,d=c.1e,e;e=d.1W=x(d.1W,a);f=d.4t=x(d.4t,b),d=f;n([["1W",a,e],["4t",b,d]],1b(a){1c b=a[0],d=c[b],e=a[1],a=a[2];d&&e&&(c[b]=d=d.1t());a&&a.1C&&!d&&(c[b]=c.1v.1C(a.1C,0,0,a.4w).1i({1y:a.1y,"3V":"2j-"+b,1D:a.1D||4}).1G(a.1p).1s().1y(a,!1,"7N"))})},i4:1b(){1c a=1a.1e.1j,b=1a.7p||1a.3P;1a.8E=gb(b,"1f");1a.7J=gb(b,"1l");1a.3f=q(0,a.1f||1a.8E||o8);1a.3g=q(0,o(a.1l,1a.7J>19?1a.7J:o3))},77:1b(a){1c b=1a.7p,c=1a.3x;a?b&&(1a.3P.2x(c),6e(b),29 1a.7p):(c&&1a.3P.9a(c),1a.7p=b=1a.3P.i1(0),L(b,{2F:"42",1H:"-o2",3y:"6k"}),z.o4.2x(b),c&&b.2x(c))},iZ:1b(){1c a,b=1a.1e.1j,c,d,e;1a.3P=a=b.3P;e="2j-"+8U++;if(fa(a))1a.3P=a=z.o5(a);a||40(13,!0);c=u(A(a,"1V-2j-1j"));!3v(c)&&4L[c]&&4L[c].1t();A(a,"1V-2j-1j",1a.2A);a.4s="";a.3X||1a.77();1a.i4();c=1a.3f;d=1a.3g;1a.3x=a=U(4C,{5i:"2j-3x"+(b.5i?" "+b.5i:""),id:e},v({2F:"aP",ig:"3i",1f:c+"px",1l:d+"px",3B:"1z",7K:"ip",1D:0,"-iq-o6-oh-1r":"44(0,0,0,0)"},b.1p),1a.7p||a);1a.ir=a.1p.3b;1a.1v=b.6w?2f 4z(a,c,d,!0):2f 64(a,c,d);$&&1a.1v.oi(1a,a,c,d)},7U:1b(){1c a=1a.1e.1j,b=a.8O,c=a.8A,d=a.8P,a=a.8Q,e,f=1a.3k,g=1a.8S,h=1a.8N,i=1a.e7,j=1a.ed,k=1a.1e.1W,m=1a.1e.4t,l=1a.1e.3k,p=o(l.7q,10),s=l.x,t=l.y,B=l.1y,w=l.3c;1a.d1();e=1a.dQ;if((1a.1W||1a.4t)&&!r(1a.8S))if(m=q(1a.1W&&!k.aL&&!k.3c&&k.y||0,1a.4t&&!m.aL&&!m.3c&&m.y||0))1a.1X=q(1a.1X,m+o(k.7q,15)+b);if(f.3y&&!l.aL)if(B==="2a"){if(!r(i))1a.5R=q(1a.5R,f.8T-s+p+c)}1m if(B==="1z"){if(!r(h))1a.1U=q(1a.1U,f.8T+s+p+a)}1m if(w==="1H"){if(!r(g))1a.1X=q(1a.1X,f.8D+t+p+b)}1m if(w==="3m"&&!r(j))1a.4Z=q(1a.4Z,f.8D-t+p+d);1a.ii&&(1a.4Z+=1a.ii);1a.ij&&(1a.1X+=1a.ij);1a.5X&&n(1a.2Z,1b(a){a.ik()});r(h)||(1a.1U+=e[3]);r(g)||(1a.1X+=e[0]);r(j)||(1a.4Z+=e[2]);r(i)||(1a.5R+=e[1]);1a.8R()},il:1b(){1b a(a){1c g=c.1f||gb(d,"1f"),h=c.1l||gb(d,"1l"),a=a?a.5p:O;if(!b.e0&&g&&h&&(a===O||a===z)){if(g!==b.8E||h!==b.7J)5n(e),b.os=e=57(1b(){if(b.3x)b.5P(g,h,!1),b.e0=1g},36);b.8E=g;b.7J=h}}1c b=1a,c=b.1e.1j,d=b.3P,e;J(O,"5I",a);J(b,"1t",1b(){ba(O,"5I",a)})},5P:1b(a,b,c){1c d=1a,e,f,g;d.82+=1;g=1b(){d&&D(d,"io",1g,1b(){d.82-=1})};4Y(c,d);d.8B=d.3g;d.e1=d.3f;if(r(a))d.3f=e=q(0,t(a)),d.e0=!!e;if(r(b))d.3g=f=q(0,t(b));L(d.3x,{1f:e+"px",1l:f+"px"});d.8R(!0);d.1v.5P(e,f,c);d.5K=1g;n(d.2Z,1b(a){a.1S=!0;a.8K()});n(d.1n,1b(a){a.1S=!0});d.6O=!0;d.4D=!0;d.7U();d.2m(c);d.8B=1g;D(d,"5I");4F===!1?g():57(g,4F&&4F.4B||8x)},8R:1b(a){1c b=1a.1R,c=1a.1v,d=1a.3f,e=1a.3g,f=1a.1e.1j,g=f.8O,h=f.8A,i=f.8P,j=f.8Q,k=1a.dG,m,l,p,o;1a.1U=m=t(1a.1U);1a.1X=l=t(1a.1X);1a.2K=p=q(0,t(d-m-1a.5R));1a.33=o=q(0,t(e-l-1a.4Z));1a.7a=b?o:p;1a.dN=b?p:o;1a.dh=b=f.dh||0;1a.7N=c.7N={x:j,y:g,1f:d-j-h,1l:e-g-i};1a.7S=c.7S={x:m,y:l,1f:p,1l:o};c=ja(q(b,k[3])/2);d=ja(q(b,k[0])/ 2); 1a.8j = { x: c, y: d, 1f: T(1a.7a - q(b, k[1])/2-c),1l:T(1a.dN-q(b,k[2])/2-d)};a||n(1a.2Z,1b(a){a.e3();a.dO()})},d1:1b(){1c a=1a.1e.1j,b=a.8A,c=a.8P,d=a.8Q;1a.1X=o(1a.8S,a.8O);1a.5R=o(1a.e7,b);1a.4Z=o(1a.ed,c);1a.1U=o(1a.8N,d);1a.dQ=[0,0,0,0];1a.dG=[0,0,0,0]},ds:1b(){1c a=1a.1e.1j,b=1a.1v,c=1a.3f,d=1a.3g,e=1a.dg,f=1a.dH,g=1a.d9,h=1a.d7,i=a.3d||0,j=a.5F,k=a.ou,m=a.ov,l=a.dh||0,p,o=1a.1U,n=1a.1X,t=1a.2K,q=1a.33,r=1a.7S,v=1a.2R,u=1a.8j;p=i+(a.1Z?8:0);if(i||j)if(e)e.1B(e.4U(1g,1g,1g,c-p,d-p));1m{e={1I:j||S};if(i)e.1q=a.3o,e["1q-1f"]=i;1a.dg=b.2I(p/2,p/2,c-p,d-p,a.3S,i).1i(e).1s().1Z(a.1Z)}if(k)f?f.1B(r):1a.dH=b.2I(o,n,t,q,0).1i({1I:k}).1s().1Z(a.oq);if(m)h?h.1B(r):1a.d7=b.7T(m,o,n,t,q).1s();v?v.1B({1f:u.1f,1l:u.1l}):1a.2R=b.2R(u);if(l)g?g.1B(g.4U(1g,o,n,t,q)):1a.d9=b.2I(o,n,t,q,0,l).1i({1q:a.iP,"1q-1f":l,1D:1}).1s();1a.4D=!1},iY:1b(){1c a=1a,b=a.1e.1j,c,d=a.1e.1n,e,f;n(["1R","op","ok"],1b(g){c=aa[b.1F||b.dv];f=a[g]||b[g]||c&&c.1w[g];1k(e=d&&d.1h;!f&&e--;)(c=aa[d[e].1F])&&c.1w[g]&&(f=!0);a[g]=f})},2d:1b(){1c a=1a,b=a.2Z,c=a.1v,d=a.1e,e=d.2y,f=d.6H,g;a.dB();a.3k=2f 9w(a,d.3k);n(b,1b(a){a.8K()});a.7U();a.5K=1g;n(b,1b(a){a.dD(!0);a.dt()});a.8L();a.7U();a.ds();a.5X&&n(b,1b(a){a.2d()});if(!a.9r)a.9r=c.g("1n-1O").1i({1D:3}).1s();n(a.1n,1b(a){a.1L();a.7x();a.2d()});e.iB&&n(e.iB,1b(b){1c d=v(e.1p,b.1p),f=u(d.1z)+a.1U,g=u(d.1H)+a.1X+12;29 d.1z;29 d.1H;c.1C(b.8M,f,g).1i({1D:2}).1G(d).1s()});if(f.1N&&!a.6H)g=f.4r,a.6H=c.1C(f.1C,0,0).on("3h",1b(){if(g)dk.4r=g}).1i({1y:f.2F.1y,1D:8}).1G(f.1p).1s().1y(f.2F);a.55=!0},1t:1b(){1c a=1a,b=a.2Z,c=a.1n,d=a.3x,e,f=d&&d.41;D(a,"1t");4L[a.2A]=y;a.3P.d2("1V-2j-1j");ba(a);1k(e=b.1h;e--;)b[e]=b[e].1t();1k(e=c.1h;e--;)c[e]=c[e].1t();n("1W,4t,dg,dH,d7,d9,9r,2R,6H,3w,om,oo,3k,6a,2H,1v".2p(","),1b(b){1c c=a[b];c&&c.1t&&(a[b]=c.1t())});if(d)d.4s="",ba(d),f&&6e(d);1k(e in a)29 a[e]},jf:1b(){1c a=1a;1d!Z&&O==O.1H&&z.hC!=="7f"||$&&!O.o1?($?dS.1o(1b(){a.76()},a.1e.6I.hU):z.o0("hF",1b(){z.hV("hF",a.76);z.hC==="7f"&&a.76()}),!1):!0},76:1b(){1c a=1a,b=a.1e,c=a.hJ;if(a.jf())a.iZ(),D(a,"1K"),a.d1(),a.8R(),a.iY(),a.iX(),n(b.1n||[],1b(b){a.cW(b)}),D(a,"nI"),a.3w=2f 9v(a,b),a.2d(),a.1v.d8(),c&&c.2o(a,[a]),n(a.j2,1b(b){b.2o(a,[a])}),a.77(!0),D(a,"jg")}};9G.1w.j2=[];1c 4T=1b(){};4T.1w={1K:1b(a,b,c){1a.1n=a;1a.6Z(b,c);1a.4c={};if(a.1e.9O&&(b=a.1e.74||a.1j.1e.74,1a.1r=1a.1r||b[a.73++],a.73===b.1h))a.73=0;a.1j.8H++;1d 1a},6Z:1b(a,b){1c c=1a.1n,d=c.nH,a=4T.1w.j8.1Y(1a,a);v(1a,a);1a.1e=1a.1e?v(1a.1e,a):a;if(d)1a.y=1a[d];if(1a.x===y&&c)1a.x=b===y?c.ff():b;1d 1a},j8:1b(a){1c b,c=1a.1n,d=c.d5||["y"],e=d.1h,f=0,g=0;if(3q a==="6V"||a===1g)b={y:a};1m if(4V(a)){b={};if(a.1h>e){c=3q a[0];if(c==="dZ")b.38=a[0];1m if(c==="6V")b.x=a[0];f++}1k(;g<e;)b[d[g++]]=a[f++]}1m if(3q a==="67"){b=a;if(a.4S)c.a8=!0;if(a.2k)c.fX=!0}1d b},1t:1b(){1c a=1a.1n.1j,b=a.3W,c;a.8H--;if(b&&(1a.35(),ga(b,1a),!b.1h))a.3W=1g;if(1a===a.4h)1a.3T();if(1a.2B||1a.2T)ba(1a),1a.dE();1a.4E&&a.3k.dR(1a);1k(c in 1a)1a[c]=1g},dE:1b(){1k(1c a="2B,2T,nJ,1O,52,4d".2p(","),b,c=6;c--;)b=a[c],1a[b]&&(1a[b]=1a[b].1t())},9S:1b(){1d{x:1a.6U,y:1a.y,6L:1a.38||1a.6U,1n:1a.1n,28:1a,9F:1a.9F,4e:1a.4e||1a.fP}},2u:1b(a,b){1c c=1a,d=c.1n,e=d.1j,a=o(a,!c.2M);c.3O(a?"2u":"9K",{nK:b},1b(){c.2M=c.1e.2M=a;d.1e.1V[la(c,d.1V)]=c.1e;c.35(a&&"2u");b||n(e.eX(),1b(a){if(a.2M&&a!==c)a.2M=a.1e.2M=!1,d.1e.1V[la(a,d.1V)]=a.1e,a.35(""),a.3O("9K")})})},53:1b(a){1c b=1a.1n,c=b.1j,d=c.2H,e=c.4h;if(e&&e!==1a)e.3T();1a.3O("e8");d&&(!d.4I||b.4H)&&d.8z(1a,a);1a.35("2V");c.4h=1a},3T:1b(){1c a=1a.1n.1j,b=a.3W;if(!b||la(1a,b)===-1)1a.3O("e2"),1a.35(),a.4h=1g},8y:1b(a){1c b=1a.1n,c=b.6T,d=o(c.nL,""),e=c.nG||"",f=c.nF||"";n(b.d5||["y"],1b(b){b="{28."+b;if(e||f)a=a.1J(b+"}",e+b+"}"+f);a=a.1J(b+"}",b+":,."+d+"f}")});1d 34(a,{28:1a,1n:1a.1n})},6n:1b(a,b,c){1c d=1a,e=d.1n,f=d.2B,g,h=e.1V,i=e.1j,b=o(b,!0);d.3O("6n",{1e:a},1b(){d.6Z(a);V(a)&&(e.9I(),f&&f.1i(d.4c[e.6F]));g=la(d,h);e.4v[g]=d.x;e.6P[g]=e.6l?e.6l(d):d.y;e.98[g]=d.z;e.1e.1V[g]=d.1e;e.1S=!0;e.5A=!0;b&&i.2m(c)})},3G:1b(a,b){1c c=1a,d=c.1n,e=d.1j,f,g=d.1V;4Y(b,e);a=o(a,!0);c.3O("3G",1g,1b(){f=la(c,g);g.2X(f,1);d.1e.1V.2X(f,1);d.4v.2X(f,1);d.6P.2X(f,1);d.98.2X(f,1);c.1t();d.1S=!0;d.5A=!0;a&&e.2m()})},3O:1b(a,b,c){1c d=1a,e=1a.1n.1e;(e.28.39[a]||d.1e&&d.1e.39&&d.1e.39[a])&&1a.eN();a==="3h"&&e.d6&&(c=1b(a){d.2u(1g,a.nA||a.nz||a.nB)});D(1a,a,b,c)},eN:1b(){if(!1a.eR){1c a=x(1a.1n.1e.28,1a.1e).39,b;1a.39=a;1k(b in a)J(1a,b,a[b]);1a.eR=!0}},35:1b(a){1c b=1a.1P,c=1a.2c,d=1a.1n,e=d.1e.3N,f=X[d.1F].2k&&d.1e.2k,g=f&&!f.1N,h=f&&f.3N[a],i=h&&h.1N===!1,j=d.eP,k=1a.2k||{},m=d.1j,l=1a.4c,a=a||"";if(!(a===1a.6F||1a.2M&&a!=="2u"||e[a]&&e[a].1N===!1||a&&(i||g&&!h.1N))){if(1a.2B)e=f&&1a.2B.65&&l[a].r,1a.2B.1i(x(l[a],e?{x:b-e,y:c-e,1f:2*e,1l:2*e}:{}));1m{if(a&&h)e=h.4m,k=k.2b||d.2b,j&&j.f5!==k&&(j=j.1t()),j?j.1i({x:b-e,y:c-e}):(d.eP=j=m.1v.2b(k,b-e,c-e,2*e,2*e).1i(l[a]).1s(d.3n),j.f5=k);if(j)j[a&&m.3M(b,c)?"3K":"2D"]()}1a.6F=a}}};1c R=1b(){};R.1w={45:!0,1F:"6Y",7i:4T,aK:!0,7m:!0,7l:{1q:"6y","1q-1f":"2N",1I:"78",r:"4m"},73:0,1K:1b(a,b){1c c,d,e=a.1n;1a.1j=a;1a.1e=b=1a.7A(b);1a.fi();v(1a,{38:b.38,6F:"",4c:{},1E:b.1E!==!1,2M:b.2M===!0});if($)b.2W=!1;d=b.39;1k(c in d)J(1a,c,d[c]);if(d&&d.3h||b.28&&b.28.39&&b.28.39.3h||b.d6)a.nC=!0;1a.aI();1a.9x();1a.9H(b.1V,!1);if(1a.45)a.5X=!0;e.1o(1a);1a.cZ=e.1h-1;cV(e,1b(a,b){1d o(a.1e.2A,a.cZ)-o(b.1e.2A,a.cZ)});n(e,1b(a,b){a.2A=b;a.38=a.38||"fM "+(b+1)});c=b.8G;1a.dp=[];if(fa(c)&&(c=c===":nE"?e[1a.2A-1]:a.2S(c)))c.dp.1o(1a),1a.5e=c},fi:1b(){1c a=1a,b=a.1e,c=a.1j,d;a.45&&n(["1M","23"],1b(e){n(c[e],1b(c){d=c.1e;if(b[e]===d.2A||b[e]!==y&&b[e]===d.id||b[e]===y&&d.2A===0)c.1n.1o(a),a[e]=c,c.1S=!0});a[e]||40(18,!0)})},ff:1b(){1c a=1a.1e,b=1a.7d,b=o(b,a.dU,0);1a.71=o(1a.71,a.71,1);1a.7d=b+1a.71;1d b},9A:1b(){1c a=-1,b=[],c,d=1a.2h,e=d.1h;if(e)if(1a.1e.nD){1k(c=e;c--;)d[c].y===1g&&d.2X(c,1);d.1h&&(b=[d])}1m n(d,1b(c,g){c.y===1g?(g>a+1&&b.1o(d.3t(a+1,g)),a=g):g===e-1&&b.1o(d.3t(a+1,g+1))});1a.7e=b},7A:1b(a){1c b=1a.1j.1e,c=b.dm,d=c[1a.1F];1a.4u=a;a=x(d,c.1n,a);1a.6T=x(b.2H,a.2H);d.2k===1g&&29 a.2k;1d a},aI:1b(){1c a=1a.1e,b=1a.4u,c=1a.1j.1e.74,d=1a.1j.dr,e;e=a.1r||X[1a.1F].1r;if(!e&&!a.9O)r(b.dl)?a=b.dl:(b.dl=d.1r,a=d.1r++),e=c[a];1a.1r=e;d.fe(c.1h)},9x:1b(){1c a=1a.4u,b=1a.1e.2k,c=1a.1j,d=c.1e.4q,c=c.dr;1a.2b=b.2b;if(!1a.2b)r(a.dq)?a=a.dq:(a.dq=c.2b,a=c.2b++),1a.2b=d[a];if(/^3I/.2i(1a.2b))b.4m=0;c.eh(d.1h)},5L:1b(a){1c b=1a.1e,c=b.2k,d=a.1e.9u,e=1a.1j.1v,f=1a.4G,a=a.9m,g;if(b.2N){g={"1q-1f":b.2N};if(b.5W)g.4g=b.5W;1a.dF=e.2v(["M",0,a-4,"L",d,a-4]).1i(g).1s(f)}if(c&&c.1N)b=c.4m,1a.9E=e.2b(1a.2b,d/2-b,a-4-b,2*b,2*b).1s(f)},nN:1b(a,b,c,d){1c e=1a.1e,f=1a.1V,g=1a.6K,h=1a.4M,i=1a.1j,j=1a.4v,k=1a.6P,m=1a.98,l=1a.e5,p=g&&g.3u||0,n=e.1V;4Y(d,i);if(g&&c)g.3u=p+1;if(h){if(c)h.3u=p+1;h.eA=!0}b=o(b,!0);d={1n:1a};1a.7i.1w.6Z.2o(d,[a]);j.1o(d.x);k.1o(1a.6l?1a.6l(d):d.y);m.1o(d.z);if(l)l[d.x]=d.38;n.1o(a);e.9L==="28"&&1a.7H();c&&(f[0]&&f[0].3G?f[0].3G(!1):(f.3u(),j.3u(),k.3u(),m.3u(),n.3u()));1a.9I();1a.5A=1a.1S=!0;b&&i.2m()},9H:1b(a,b){1c c=1a.2h,d=1a.1e,e=1a.1j,f=1g,g=1a.1M,h=g&&g.3r&&!g.3r.1h?[]:1g,i;1a.7d=1g;1a.3C=g&&g.3r?1:d.3C;1a.73=0;1c j=[],k=[],m=[],l=a?a.1h:[],p=(i=1a.d5)&&i.1h,n=!!1a.6l;if(l>(d.nV||3E)){1k(i=0;f===1g&&i<l;)f=a[i],i++;if(5G(f)){f=o(d.dU,0);d=o(d.71,1);1k(i=0;i<l;i++)j[i]=f,k[i]=a[i],f+=d;1a.7d=f}1m if(4V(f))if(p)1k(i=0;i<l;i++)d=a[i],j[i]=d[0],k[i]=d.3t(1,p+1);1m 1k(i=0;i<l;i++)d=a[i],j[i]=d[0],k[i]=d[1]}1m 1k(i=0;i<l;i++)if(a[i]!==y&&(d={1n:1a},1a.7i.1w.6Z.2o(d,[a[i]]),j[i]=d.x,k[i]=n?1a.6l(d):d.y,m[i]=d.z,h&&d.38))h[i]=d.38;1a.7m&&j.1h>1&&j[1]<j[0]&&40(15);fa(k[0])&&40(14,!0);1a.1V=[];1a.1e.1V=a;1a.4v=j;1a.6P=k;1a.98=m;1a.e5=h;1k(i=c&&c.1h||0;i--;)c[i]&&c[i].1t&&c[i].1t();if(g)g.49=g.gy;1a.1S=1a.5A=e.4D=!0;o(b,!0)&&e.2m(!1)},3G:1b(a,b){1c c=1a,d=c.1j,a=o(a,!0);if(!c.du)c.du=!0,D(c,"3G",1g,1b(){c.1t();d.6O=d.4D=!0;a&&d.2m(b)});c.du=!1},9s:1b(a){1c b=1a.4v,c=1a.6P,d=b.1h,e=0,f=d,g,h,i=1a.1M,j=1a.1e,k=j.d4,m=1a.45;if(m&&!1a.1S&&!i.1S&&!1a.23.1S&&!a)1d!1;if(m&&1a.aK&&(!k||d>k||1a.nY))if(a=i.6o(),i=a.1u,k=a.1x,b[d-1]<i||b[0]>k)b=[],c=[];1m if(b[0]<i||b[d-1]>k){1k(a=0;a<d;a++)if(b[a]>=i){e=q(0,a-1);3R}1k(;a<d;a++)if(b[a]>k){f=a+1;3R}b=b.3t(e,f);c=c.3t(e,f);g=!0}1k(a=b.1h-1;a>0;a--)if(d=b[a]-b[a-1],d>0&&(h===y||d<h))h=d;1a.dW=g;1a.gW=e;1a.8X=b;1a.do=c;if(j.3C===1g)1a.3C=h||1;1a.6G=h},7H:1b(){1c a=1a.1e.1V,b=1a.1V,c,d=1a.8X,e=1a.do,f=1a.7i,g=d.1h,h=1a.gW||0,i,j=1a.nZ,k,m=[],l;if(!b&&!j)b=[],b.1h=a.1h,b=1a.1V=b;1k(l=0;l<g;l++)i=h+l,j?m[l]=(2f f).1K(1a,[d[l]].2g(ha(e[l]))):(b[i]?k=b[i]:a[i]!==y&&(b[i]=k=(2f f).1K(1a,a[i],d[l])),m[l]=k);if(b&&(g!==(c=b.1h)||j))1k(l=0;l<c;l++)if(l===h&&!j&&(l+=g),b[l])b[l].dE(),b[l].1P=y;1a.1V=b;1a.2h=m},1L:1b(){1a.8X||1a.9s();1a.7H();1c a=1a.1e,b=a.3z,c=1a.1M,d=c.3r,e=1a.23,f=1a.2h,g=f.1h,h=!!1a.8k,i,j,k=a.gU==="dC",m=a.4b;j=e.1n.5Y(1b(a,b){1d a.2A-b.2A});1k(a=j.1h;a--;)if(j[a].1E){j[a]===1a&&(i=!0);3R}1k(a=0;a<g;a++){j=f[a];1c l=j.x,p=j.y,n=j.dw,q=e.4o[(p<m?"-":"")+1a.7Z];if(e.2U&&p<=0)j.y=p=1g;j.1P=c.1L(l,0,0,0,1,k);if(b&&1a.1E&&q&&q[l])n=q[l],q=n.4e,n.7b=n=n.7b-p,p=n+p,i&&(n=o(m,e.1u)),e.2U&&n<=0&&(n=1g),b==="6X"&&(n=q?n*36/q:0,p=q?p*36/ q : 0), j.9F = q ? j.y * 36/q:0,j.4e=j.fP=q,j.fU=p;j.7D=r(n)?e.1L(n,0,1,0,1):1g;h&&(p=1a.8k(p,j));j.2c=3q p==="6V"&&p!==nT?t(e.1L(p,0,1,0,1)*10)/10:y;j.51=k?c.1L(l,0,0,0,1):j.1P;j.cL=j.y<(m||0);j.6U=d&&d[j.x]!==y?d[j.x]:j.x}1a.9A()},7x:1b(a){1c b=[],c,d,e=(c=1a.1M)?c.nO||c.2r:1a.1j.7a,f,g,h=[];if(1a.1e.cX!==!1){if(a)1a.6S=1g;n(1a.7e||1a.2h,1b(a){b=b.2g(a)});c&&c.3L&&(b=b.df());a=b.1h;1k(g=0;g<a;g++){f=b[g];c=b[g-1]?d+1:0;1k(d=b[g+1]?q(0,T((f.51+(b[g+1]?b[g+1].51:e))/2)):e;c>=0&&c<=d;)h[c++]=f}1a.6S=h}},fz:1b(a){1c b=1a.6T,c=b.nQ,d=b.8a,e=1a.1M,f=e&&e.1e.1F==="fy",b=b.dY,e=e&&e.6G,g;if(f&&!c)if(e)1k(g in E){if(E[g]>=e){c=d[g];3R}}1m c=d.89;f&&c&&5G(a.6L)&&(b=b.1J("{28.6L}","{28.6L:"+c+"}"));1d 34(b,{28:a,1n:1a})},53:1b(){1c a=1a.1j,b=a.3J;if(b&&b!==1a)b.3T();1a.1e.39.e8&&D(1a,"e8");1a.35("2V");a.3J=1a},3T:1b(){1c a=1a.1e,b=1a.1j,c=b.2H,d=b.4h;if(d)d.3T();1a&&a.39.e2&&D(1a,"e2");c&&!a.6r&&(!c.4I||1a.4H)&&c.2D();1a.35();b.3J=1g},1B:1b(a){1c b=1a,c=b.1j,d=c.1v,e;e=b.1e.2W;1c f=c.8j,g=c.1R,h;if(e&&!V(e))e=X[b.1F].2W;h="nR"+e.4B+e.gh;if(a)a=c[h],e=c[h+"m"],a||(c[h]=a=d.2R(v(f,{1f:0})),c[h+"m"]=e=d.2R(-99,g?-c.1U:-c.1X,99,g?c.3f:c.3g)),b.1O.2G(a),b.3n.2G(e),b.dA=h;1m{if(a=c[h])a.1B({1f:c.7a},e),c[h+"m"].1B({1f:c.7a+99},e);b.1B=1g;b.g0=57(1b(){b.dz()},e.4B)}},dz:1b(){1c a=1a.1j,b=1a.dA,c=1a.1O;c&&1a.1e.2G!==!1&&(c.2G(a.2R),1a.3n.2G());57(1b(){b&&a[b]&&(a[b]=a[b].1t(),a[b+"m"]=a[b+"m"].1t())},36)},9C:1b(){1c a,b=1a.2h,c=1a.1j,d,e,f,g,h,i,j,k,m=1a.1e.2k,l,n=1a.3n;if(m.1N||1a.fX)1k(f=b.1h;f--;)if(g=b[f],d=g.1P,e=g.2c,k=g.2B,i=g.2k||{},a=m.1N&&i.1N===y||i.1N,l=c.3M(t(d),e,c.1R),a&&e!==y&&!3v(e)&&g.y!==1g)if(a=g.4c[g.2M?"2u":""],h=a.r,i=o(i.2b,1a.2b),j=i.3H("3I")===0,k)k.1i({2s:l?Z?"9U":"1E":"3i"}).1B(v({x:d-h,y:e-h},k.65?{1f:2*h,1l:2*h}:{}));1m{if(l&&(h>0||j))g.2B=c.1v.2b(i,d-h,e-h,2*h,2*h).1i(a).1s(n)}1m if(k)g.2B=k.1t()},4p:1b(a,b,c,d){1c e=1a.7l,f,g,h={},a=a||{},b=b||{},c=c||{},d=d||{};1k(f in e)g=e[f],h[f]=o(a[g],b[f],c[f],d[f]);1d h},9I:1b(){1c a=1a,b=a.1e,c=X[a.1F].2k?b.2k:b,d=c.3N,e=d.2V,f,g=a.1r,h={1q:g,1I:g},i=a.2h||[],j=[],k,m=a.7l,l=b.70,p;b.2k?(e.4m=e.4m||c.4m+2,e.2N=e.2N||c.2N+1):e.1r=e.1r||ma(e.1r||g).9f(e.7o).2S();j[""]=a.4p(c,h);n(["2V","2u"],1b(b){j[b]=a.4p(d[b],j[""])});a.4c=j;1k(g=i.1h;g--;){h=i[g];if((c=h.1e&&h.1e.2k||h.1e)&&c.1N===!1)c.4m=0;if(h.cL&&l)h.1r=h.78=l;f=b.9O||h.1r;if(h.1e)1k(p in m)r(c[m[p]])&&(f=!0);if(f){c=c||{};k=[];d=c.3N||{};f=d.2V=d.2V||{};if(!b.2k)f.1r=ma(f.1r||h.1r).9f(f.7o||e.7o).2S();k[""]=a.4p(v({1r:h.1r},c),j[""]);k.2V=a.4p(d.2V,j.2V,k[""]);k.2u=a.4p(d.2u,j.2u,k[""]);if(h.cL&&b.2k&&l)k[""].1I=k.2V.1I=k.2u.1I=a.4p({78:l}).1I}1m k=j;h.4c=k}},6n:1b(a,b){1c c=1a.1j,d=1a.1F,a=x(1a.4u,{2W:!1,2A:1a.2A,dU:1a.4v[0]},a);1a.3G(!1);v(1a,aa[a.1F||d].1w);1a.1K(c,a);o(b,!0)&&c.2m(!1)},1t:1b(){1c a=1a,b=a.1j,c=/g6\\/nS/.2i(4Q),d,e,f=a.1V||[],g,h,i;D(a,"1t");ba(a);n(["1M","23"],1b(b){if(i=a[b])ga(i.1n,a),i.1S=i.dX=!0});a.4E&&a.1j.3k.dR(a);1k(e=f.1h;e--;)(g=f[e])&&g.1t&&g.1t();a.2h=1g;5n(a.g0);n("4M,6K,5q,1O,3n,3Y,9n,de,dc,dd".2p(","),1b(b){a[b]&&(d=c&&b==="1O"?"2D":"1t",a[b][d]())});if(b.3J===a)b.3J=1g;ga(b.1n,a);1k(h in a)29 a[h]},7P:1b(){1c a=1a,b=a.1e.4S,c=a.2h,d,e,f,g;if(b.1N||a.a8)a.gk&&a.gk(b),g=a.9t("5q","1V-2y",a.1E?"1E":"3i",b.1D||6),e=b,n(c,1b(c){1c i,j=c.2T,k,m,l=c.52,n=!0;d=c.1e&&c.1e.4S;i=e.1N||d&&d.1N;if(j&&!i)c.2T=j.1t();1m if(i){i=b.26;b=x(e,d);k=c.9S();f=b.7Y?34(b.7Y,k):b.5g.1Y(k,b);b.1p.1r=o(b.1r,b.1p.1r,a.1r,"9J");if(j)if(r(f))j.1i({1C:f}),n=!1;1m{if(c.2T=j=j.1t(),l)c.52=l.1t()}1m if(r(f)){j={1I:b.5F,1q:b.3o,"1q-1f":b.3d,r:b.3S||0,26:i,2Q:b.2Q,1D:1};1k(m in j)j[m]===y&&29 j[m];j=c.2T=a.1j.1v[i?"1C":"27"](f,0,-6b,1g,1g,1g,b.4w).1i(j).1G(b.1p).1s(g).1Z(b.1Z)}j&&a.7R(c,j,b,1g,n)}})},7R:1b(a,b,c,d,e){1c f=1a.1j,g=f.1R,h=o(a.1P,-6b),a=o(a.2c,-6b),i=b.31(),d=v({x:g?f.2K-a:h,y:t(g?f.33-h:a),1f:0,1l:0},d);v(c,{1f:i.1f,1l:i.1l});c.26?(d={1y:c.1y,x:d.x+c.x+d.1f/2,y:d.y+c.y+d.1l/2},b[e?"1i":"1B"](d)):b.1y(c,1g,d);b.1i({2s:c.gf===!1||f.3M(h,a,g)?f.1v.68?"9U":"1E":"3i"})},63:1b(a){1c b=1a,c=[],d=b.1e.5h;n(a,1b(e,f){1c g=e.1P,h=e.2c,i;b.dM?c.1o.2o(c,b.dM(a,e,f)):(c.1o(f?"L":"M"),d&&f&&(i=a[f-1],d==="2a"?c.1o(i.1P,h):d==="1Q"?c.1o((i.1P+g)/2,i.2c,(i.1P+g)/2,h):c.1o(g,i.2c)),c.1o(e.1P,e.2c))});1d c},gd:1b(){1c a=1a,b=[],c,d=[];n(a.7e,1b(e){c=a.63(e);e.1h>1?b=b.2g(c):d.1o(e[0])});a.gG=d;1d a.fv=b},43:1b(){1c a=1a,b=1a.1e,c=[["6K",b.6y||1a.1r]],d=b.2N,e=b.5W,f=1a.gd(),g=b.70;g&&c.1o(["9n",g]);n(c,1b(c,g){1c j=c[0],k=a[j];if(k)6i(k),k.1B({d:f});1m if(d&&f.1h){k={1q:c[1],"1q-1f":d,1D:1};if(e)k.4g=e;a[j]=a.1j.1v.2v(f).1i(k).1s(a.1O).1Z(!g&&b.1Z)}})},fK:1b(){1c a=1a.1e,b=1a.1j,c=b.1v,d=a.70,e,f=1a.6K,g=1a.4M,h=1a.dc,i=1a.dd;e=b.3f;1c j=b.3g,k=q(e,j);if(d&&(f||g))d=ja(1a.23.2r-1a.23.1L(a.4b||0)),a={x:0,y:0,1f:k,1l:d},k={x:0,y:d,1f:k,1l:k-d},b.1R&&c.fV&&(a={x:b.2K-d-b.1U,y:0,1f:e,1l:j},k={x:d+b.1U-e,y:0,1f:b.1U+d,1l:e}),1a.23.3L?(b=k,e=a):(b=a,e=k),h?(h.1B(b),i.1B(e)):(1a.dc=h=c.2R(b),1a.dd=i=c.2R(e),f&&(f.2G(h),1a.9n.2G(i)),g&&(g.2G(h),1a.de.2G(i)))},d3:1b(){1b a(){1c a={1f:b.23.2r,1l:b.1M.2r};n(["1O","3n"],1b(c){b[c]&&b[c].1i(a).fw()})}1c b=1a,c=b.1j;if(b.1M)J(c,"5I",a),J(b,"1t",1b(){ba(c,"5I",a)}),a(),b.d3=a},9t:1b(a,b,c,d,e){1c f=1a[a],g=!f,h=1a.1j,i=1a.1M,j=1a.23;g&&(1a[a]=f=h.1v.g(b).1i({2s:c,1D:d||0.1}).1s(e));f[g?"1i":"1B"]({2C:i?i.1z:h.1U,2n:j?j.1H:h.1X,7c:1,54:1});1d f},2d:1b(){1c a=1a.1j,b,c=1a.1e,d=c.2W&&!!1a.1B&&a.1v.68,e=1a.1E?"1E":"3i",f=c.1D,g=1a.55,h=a.9r;b=1a.9t("1O","1n",e,f,h);1a.3n=1a.9t("3n","nP",e,f,h);d&&1a.1B(!0);1a.9I();b.1R=1a.45?a.1R:!1;1a.43&&(1a.43(),1a.fK());1a.7P();1a.9C();1a.1e.cX!==!1&&1a.5H();a.1R&&1a.d3();c.2G!==!1&&!1a.dA&&!g&&b.2G(a.2R);d?1a.1B():g||1a.dz();1a.1S=1a.5A=!1;1a.55=!0},2m:1b(){1c a=1a.1j,b=1a.5A,c=1a.1O,d=1a.1M,e=1a.23;c&&(a.1R&&c.1i({1f:a.2K,1l:a.33}),c.1B({2C:o(d&&d.1z,a.1U),2n:o(e&&e.1H,a.1X)}));1a.1L();1a.7x(!0);1a.2d();b&&D(1a,"nU")},35:1b(a){1c b=1a.1e,c=1a.6K,d=1a.9n,e=b.3N,b=b.2N,a=a||"";if(1a.6F!==a)1a.6F=a,e[a]&&e[a].1N===!1||(a&&(b=e[a].2N||b+1),c&&!c.4g&&(a={"1q-1f":b},c.1i(a),d&&d.1i(a)))},5C:1b(a,b){1c c=1a,d=c.1j,e=c.4E,f,g=d.1e.1j.dn,h=c.1E;f=(c.1E=a=c.4u.1E=a===y?!h:a)?"3K":"2D";n(["1O","5q","3n","3Y"],1b(a){if(c[a])c[a][f]()});if(d.3J===c)c.3T();e&&d.3k.9M(c,a);c.1S=!0;c.1e.3z&&n(d.1n,1b(a){if(a.1e.3z&&a.1E)a.1S=!0});n(c.dp,1b(b){b.5C(a,!1)});if(g)d.4D=!0;b!==!1&&d.2m();D(c,f)},3K:1b(){1a.5C(!0)},2D:1b(){1a.5C(!1)},2u:1b(a){1a.2M=a=a===y?!1a.2M:a;if(1a.47)1a.47.9D=a;D(1a,a?"2u":"9K")},5H:1b(){1c a=1a,b=a.1e,c=b.nX,d=[].2g(c?a.79:a.fv),e=d.1h,f=a.1j,g=f.3w,h=f.1v,i=f.1e.2H.gz,j=a.3Y,k=b.3b,k=k&&{3b:k},m=a.gG,l,n=1b(){if(f.3J!==a)a.53()};if(e&&!c)1k(l=e+1;l--;)d[l]==="M"&&d.2X(l+1,0,d[l+1]-i,d[l+2],"L"),(l&&d[l]==="M"||l===e)&&d.2X(l,0,"L",d[l-2]+i,d[l-1]);1k(l=0;l<m.1h;l++)e=m[l],d.1o("M",e.1P-i,e.2c,"L",e.1P+i,e.2c);if(j)j.1i({d:d});1m if(a.3Y=j=h.2v(d).1i({"3V":"2j-3Y","1q-hv":"b3",2s:a.1E?"1E":"3i",1q:ee,1I:c?ee:S,"1q-1f":b.2N+(c?0:2*i),1D:2}).d0("2j-3Y").on("cY",n).on("ec",1b(a){g.e9(a)}).1G(k).1s(a.3n),fb)j.on("9W",n)}};M=ea(R);aa.6Y=M;X.4M=x(W,{4b:0});M=ea(R,{1F:"4M",9A:1b(){1c a=[],b=[],c=[],d=1a.1M,e=1a.23,f=e.4o[1a.7Z],g={},h,i,j=1a.2h,k,m;if(1a.1e.3z&&!1a.dW){1k(k=0;k<j.1h;k++)g[j[k].x]=j[k];1k(m in f)c.1o(+m);c.5Y(1b(a,b){1d a-b});n(c,1b(a){g[a]?b.1o(g[a]):(h=d.1L(a),i=e.7W(f[a].7b,!0),b.1o({y:1g,1P:h,51:h,2c:i,7D:i,53:48}))});b.1h&&a.1o(b)}1m R.1w.9A.1Y(1a),a=1a.7e;1a.7e=a},63:1b(a){1c b=R.1w.63.1Y(1a,a),c=[].2g(b),d,e=1a.1e;b.1h===3&&c.1o("L",b[1],b[2]);if(e.3z&&!1a.j5)1k(d=a.1h-1;d>=0;d--)d<a.1h-1&&e.5h&&c.1o(a[d+1].1P,a[d].7D),c.1o(a[d].1P,a[d].7D);1m 1a.9T(c,a);1a.79=1a.79.2g(c);1d b},9T:1b(a,b){1c c=1a.23.dj(1a.1e.4b);a.1o("L",b[b.1h-1].1P,c,"L",b[0].1P,c)},43:1b(){1a.79=[];R.1w.43.2o(1a);1c a=1a,b=1a.79,c=1a.1e,d=[["4M",1a.1r,c.78]];c.70&&d.1o(["de",c.70,c.nW]);n(d,1b(d){1c f=d[0],g=a[f];g?g.1B({d:b}):a[f]=a.1j.1v.2v(b).1i({1I:o(d[2],ma(d[1]).ew(c.nM||0.75).2S()),1D:0}).1s(a.1O)})},5L:1b(a,b){b.9E=1a.1j.1v.2I(0,a.9m-11,a.1e.9u,12,2).1i({1D:3}).1s(b.4G)}});aa.4M=M;X.dV=x(W);F=ea(R,{1F:"dV",dM:1b(a,b,c){1c d=b.1P,e=b.2c,f=a[c-1],g=a[c+1],h,i,j,k;if(f&&g){a=f.2c;j=g.1P;1c g=g.2c,m;h=(1.5*d+f.1P)/2.5;i=(1.5*e+a)/ 2.5; j = (1.5 * d + j)/2.5;k=(1.5*e+g)/ 2.5; m = (k - i) * (j - d) /(j-h)+e-k;i+=m;k+=m;i>a&&i>e?(i=q(a,e),k=2*e-i):i<a&&i<e&&(i=K(a,e),k=2*e-i);k>g&&k>e?(k=q(g,e),i=2*e-k):k<g&&k<e&&(k=K(g,e),i=2*e-k);b.dI=j;b.dJ=k}c?(b=["C",f.dI||f.1P,f.dJ||f.2c,h||d,i||e,d,e],f.dI=f.dJ=1g):b=["M",d,e];1d b}});aa.dV=F;X.e4=x(X.4M);na=M.1w;F=ea(F,{1F:"e4",j5:!0,63:na.63,9T:na.9T,43:na.43});aa.e4=F;X.9Q=x(W,{3o:"#7r",3d:1,3S:0,hf:0.2,2k:1g,hy:0.1,hq:0,d4:50,3C:1g,3N:{2V:{7o:0.1,1Z:!1},2u:{1r:"#9k",3o:"#hL",1Z:!1}},4S:{1y:1g,3c:1g,y:1g},6r:!1,4b:0});F=ea(R,{1F:"9Q",hP:!0,7m:!1,7l:{1q:"3o","1q-1f":"3d",1I:"1r",r:"3S"},9X:["1O","5q"],1K:1b(){R.1w.1K.2o(1a,2L);1c a=1a,b=a.1j;b.55&&n(b.1n,1b(b){if(b.1F===a.1F)b.1S=!0})},hr:1b(){1c a=1a,b=a.1j,c=a.1e,d=1a.1M,e=d.3L,f,g={},h,i=0;c.hR===!1?i=1:n(b.1n,1b(b){1c c=b.1e;if(b.1F===a.1F&&b.1E&&a.1e.1O===c.1O)c.3z?(f=b.7Z,g[f]===y&&(g[f]=i++),h=g[f]):c.hR!==!1&&(h=i++),b.di=h});1c b=K(Q(d.5o)*(d.dT||c.3C||d.6G||1),d.2r),d=b*c.hf,j=(b-2*d)/i,k=c.iE,c=r(k)?(j-k)/2:j*c.hy,k=o(k,j-2*c);1d a.ol={1f:k*1.5,2Y:c+1.5*(d+((e?i-(a.di||0):a.di)||0)*j-b/2)*(e?-1:1)}},1L:1b(){1c a=1a,b=a.1j,c=a.1e,d=c.3z,e=c.3d,f=a.23,g=a.i3=f.dj(c.4b),h=o(c.hq,5),c=a.hr(),i=c.1f,j=ja(q(i,1+2*e)),k=c.2Y;R.1w.1L.2o(a);n(a.2h,1b(c){1c l=K(q(-6b,c.2c),f.2r+6b),n=o(c.7D,g),s=c.1P+k,t=ja(K(l,n)),l=ja(q(l,n)-t),r=f.4o[(c.y<0?"-":"")+a.7Z];d&&a.1E&&r&&r[c.x]&&r[c.x].hZ(k,j);Q(l)<h&&h&&(l=h,t=Q(t-g)>h?n-h:g-(f.1L(c.y,0,1,0,1)<=g?h:0));c.oj=s;c.iE=i;c.b8="2I";c.6v=c=b.1v.9o.1w.4U.1Y(0,e,s,t,j,l);e%2&&(c.y-=1,c.1l+=1)})},9x:48,5L:M.1w.5L,43:48,9C:1b(){1c a=1a,b=a.1e,c=a.1j.1v,d;n(a.2h,1b(e){1c f=e.2c,g=e.2B;if(f!==y&&!3v(f)&&e.y!==1g)d=e.6v,g?(6i(g),g.1B(x(d))):e.2B=c[e.b8](d).1i(e.4c[e.2M?"2u":""]).1s(a.1O).1Z(b.1Z,1g,b.3z&&!b.3S);1m if(g)e.2B=g.1t()})},5H:1b(){1c a=1a,b=a.1j.3w,c=a.1e.3b,d=c&&{3b:c},e=1b(b){1c c=b.5p,d;1k(a.53();c&&!d;)d=c.28,c=c.41;if(d!==y)d.53(b)};n(a.2h,1b(a){if(a.2B)a.2B.1A.28=a;if(a.2T)a.2T.1A.28=a});a.iw?a.iw=!0:n(a.9X,1b(c){if(a[c]&&(a[c].d0("2j-3Y").on("cY",e).on("ec",1b(a){b.e9(a)}).1G(d),fb))a[c].on("9W",e)})},7R:1b(a,b,c,d,e){1c f=1a.1j,g=f.1R,h=a.ot||a.6v,i=a.or||a.2c>o(1a.i3,f.dN),j=o(c.ih,!!1a.1e.3z);if(h&&(d=x(h),g&&(d={x:f.2K-d.y-d.1l,y:f.33-d.x-d.1f,1f:d.1l,1l:d.1f}),!j))g?(d.x+=i?0:d.1f,d.1f=0):(d.y+=i?d.1l:0,d.1l=0);c.1y=o(c.1y,!g||j?"1Q":i?"2a":"1z");c.3c=o(c.3c,g||j?"4f":i?"1H":"3m");R.1w.7R.1Y(1a,a,b,c,d,e)},1B:1b(a){1c b=1a.23,c=1a.1e,d=1a.1j.1R,e={};if(Z)a?(e.54=0.9P,a=K(b.3a+b.2r,q(b.3a,b.7W(c.4b))),d?e.2C=a-b.2r:e.2n=a,1a.1O.1i(e)):(e.54=1,e[d?"2C":"2n"]=b.3a,1a.1O.1B(e,1a.1e.2W),1a.1B=1g)},3G:1b(){1c a=1a,b=a.1j;b.55&&n(b.1n,1b(b){if(b.1F===a.1F)b.1S=!0});R.1w.3G.2o(a,2L)}});aa.9Q=F;X.dK=x(X.9Q);na=ea(F,{1F:"dK",1R:!0});aa.dK=na;X.aO=x(W,{2N:0,2H:{dY:\'<2O 1p="9V-6A: im; 1r:{1n.1r}">{1n.38}</2O><br/>\',aN:"x: <b>{28.x}</b><br/>y: <b>{28.y}</b><br/>",6q:!0},6r:!1});na=ea(R,{1F:"aO",aK:!1,7m:!1,4H:!0,9X:["3n"],5H:F.1w.5H,7x:48});aa.aO=na;X.cS=x(W,{3o:"#7r",3d:1,1Q:[1g,1g],2G:!1,9O:!0,4S:{9z:30,1N:!0,5g:1b(){1d 1a.28.38}},aF:!0,9L:"28",2k:1g,6A:1g,aS:!1,az:10,3N:{2V:{7o:0.1,1Z:!1}},6r:!1,2H:{6q:!0}});W={1F:"cS",45:!1,7i:ea(4T,{1K:1b(){4T.1w.1K.2o(1a,2L);1c a=1a,b;if(a.y<0)a.y=1g;v(a,{1E:a.1E!==!1,38:o(a.38,"o7")});b=1b(){a.3t()};J(a,"2u",b);J(a,"9K",b);1d a},5C:1b(a){1c b=1a,c=b.1n,d=c.1j,e;b.1E=b.1e.1E=a=a===y?!b.1E:a;c.1e.1V[la(b,c.1V)]=b.1e;e=a?"3K":"2D";n(["2B","2T","52","4d"],1b(a){if(b[a])b[a][e]()});b.4E&&d.3k.9M(b,a);if(!c.1S&&c.1e.aF)c.1S=!0,d.2m()},3t:1b(a,b,c){1c d=1a.1n;4Y(c,d.1j);o(b,!0);1a.9B=1a.1e.9B=a=r(a)?a:!1a.9B;d.1e.1V[la(1a,d.1V)]=1a.1e;a=a?1a.aW:{2C:0,2n:0};1a.2B.1B(a);1a.4d&&1a.4d.1B(a)}}),7m:!1,4H:!0,9X:["1O","5q"],7l:{1q:"3o","1q-1f":"3d",1I:"1r"},aI:48,1B:1b(a){1c b=1a,c=b.2h,d=b.i6;if(!a)n(c,1b(a){1c c=a.2B,a=a.6v;c&&(c.1i({r:b.1Q[3]/2,3l:d,37:d}),c.1B({r:a.r,3l:a.3l,37:a.37},b.1e.2W))}),b.1B=1g},9H:1b(a,b){R.1w.9H.1Y(1a,a,!1);1a.9s();1a.7H();o(b,!0)&&1a.1j.2m()},iM:1b(){1c a=1a.1e,b=1a.1j,c=2*(a.az||0),d,e=b.2K-2*c,f=b.33-2*c,b=a.1Q,a=[o(b[0],"50%"),o(b[1],"50%"),a.6A||"36%",a.o9||0],g=K(e,f),h;1d 59(a,1b(a,b){h=/%$/.2i(a);d=b<2||b===2&&h;1d(h?[e,f,g,g][b]*u(a)/36:a)+(d?c:0)})},1L:1b(a){1a.7H();1c b=0,c=0,d=1a.1e,e=d.az,f=e+d.3d,g,h,i,j=1a.i6=5E/ic*((d.oe||0)%i9-90),k=1a.2h,m=2*5E,l=d.4S.9z,n=d.aF,o,q=k.1h,r;if(!a)1a.1Q=a=1a.iM();1a.ji=1b(b,c){i=I.nx((b-a[1])/(a[2]/ 2 + l)); 1d a[0] + (c ? -1 : 1) * Y(i) * (a[2] /2+l)};1k(o=0;o<q;o++)r=k[o],b+=n&&!r.1E?0:r.y;1k(o=0;o<q;o++){r=k[o];d=b?r.y/b:0;g=t((j+c*m)*3E)/ 3E; if (!n || r.1E) c += d; h = t((j + c * m) * 3E)/3E;r.b8="5V";r.6v={x:a[0],y:a[1],r:a[2]/ 2, 4A: a[3]/2,3l:g,37:h};i=(h+g)/ 2; i > 0.75 * m && (i -= 2 * 5E); r.aW = { 2C: t(Y(i) * e), 2n: t(ca(i) * e) }; g = Y(i) * a[2]/2;h=ca(i)*a[2]/ 2; r.iD = [a[0] + g * 0.7, a[1] + h * 0.7]; r.ac = i < m/4?0:1;r.7z=i;f=K(f,l/2);r.9Y=[a[0]+g+Y(i)*l,a[1]+h+ca(i)*l,a[0]+g+Y(i)*f,a[1]+h+ca(i)*f,a[0]+g,a[1]+h,l<0?"1Q":r.ac?"2a":"1z",i];r.9F=d*36;r.4e=b}1a.7x()},43:1g,9C:1b(){1c a=1a,b=a.1j.1v,c,d,e=a.1e.1Z,f,g;if(e&&!a.4d)a.4d=b.g("1Z").1s(a.1O);n(a.2h,1b(h){d=h.2B;g=h.6v;f=h.4d;if(e&&!f)f=h.4d=b.g("1Z").1s(a.4d);c=h.9B?h.aW:{2C:0,2n:0};f&&f.1i(c);d?d.1B(v(g,c)):h.2B=d=b.5V(g).hu(a.1Q).1i(h.4c[h.2M?"2u":""]).1i({"1q-hv":"b3"}).1i(c).1s(a.1O).1Z(e,f);h.1E===!1&&h.5C(!1)})},7P:1b(){1c a=1a,b=a.1V,c,d=a.1j,e=a.1e.4S,f=o(e.mZ,10),g=o(e.mX,1),h=d.2K,d=d.33,i,j,k=o(e.mO,!0),m=e.9z,l=a.1Q,p=l[2]/2,s=l[1],r=m>0,v,w,u,x,y=[[],[]],A,z,E,H,C,D=[0,0,0,0],K=1b(a,b){1d b.y-a.y},M=1b(a,b){a.5Y(1b(a,c){1d a.7z!==3Z 0&&(c.7z-a.7z)*b})};if(e.1N||a.a8){R.1w.7P.2o(a);n(b,1b(a){a.2T&&y[a.ac].1o(a)});1k(H=0;!x&&b[H];)x=b[H]&&b[H].2T&&(b[H].2T.31().1l||21),H++;1k(H=2;H--;){1c b=[],L=[],I=y[H],J=I.1h,F;M(I,H-0.5);if(m>0){1k(C=s-p-m;C<=s+p+m;C+=x)b.1o(C);w=b.1h;if(J>w){c=[].2g(I);c.5Y(K);1k(C=J;C--;)c[C].hT=C;1k(C=J;C--;)I[C].hT>=w&&I.2X(C,1);J=I.1h}1k(C=0;C<J;C++){c=I[C];u=c.9Y;c=aq;1c O,N;1k(N=0;N<w;N++)O=Q(b[N]-u[1]),O<c&&(c=O,F=N);if(F<C&&b[C]!==1g)F=C;1m 1k(w<J-C+F&&b[C]!==1g&&(F=w-J+C);b[F]===1g;)F++;L.1o({i:F,y:b[F]});b[F]=1g}L.5Y(K)}1k(C=0;C<J;C++){c=I[C];u=c.9Y;v=c.2T;E=c.1E===!1?"3i":"1E";c=u[1];if(m>0){if(w=L.9p(),F=w.i,z=w.y,c>z&&b[F+1]!==1g||c<z&&b[F-1]!==1g)z=c}1m z=c;A=e.iR?l[0]+(H?-1:1)*(p+m):a.ji(F===0||F===b.1h-1?c:z,H);v.cc={2s:E,1y:u[6]};v.9q={x:A+e.x+({1z:f,2a:-f}[u[6]]||0),y:z+e.y-10};v.iV=A;v.j3=z;if(1a.1e.6A===1g)w=v.1f,A-w<f?D[3]=q(t(w-A+f),D[3]):A+w>h-f&&(D[1]=q(t(A+w-h+f),D[1])),z-x/2<0?D[0]=q(t(-z+x/ 2), D[0]) : z + x/2>d&&(D[2]=q(t(z+x/2-d),D[2]))}}if(pa(D)===0||1a.f1(D))1a.fm(),r&&g&&n(1a.2h,1b(b){i=b.52;u=b.9Y;if((v=b.2T)&&v.9q)E=v.cc.2s,A=v.iV,z=v.j3,j=k?["M",A+(u[6]==="1z"?5:-5),z,"C",A,z,2*u[2]-u[4],2*u[3]-u[5],u[2],u[3],"L",u[4],u[5]]:["M",A+(u[6]==="1z"?5:-5),z,"L",u[2],u[3],"L",u[4],u[5]],i?(i.1B({d:j}),i.1i("2s",E)):b.52=i=a.1j.1v.2v(j).1i({"1q-1f":g,1q:e.n4||b.1r||"#f2",2s:E}).1s(a.1O);1m if(i)b.52=i.1t()})}},f1:1b(a){1c b=1a.1Q,c=1a.1e,d=c.1Q,e=c=c.n5||80,f;d[0]!==1g?e=q(b[2]-q(a[1],a[3]),c):(e=q(b[2]-a[1]-a[3],c),b[0]+=(a[3]-a[1])/2);d[1]!==1g?e=q(K(e,b[2]-q(a[0],a[2])),c):(e=q(K(e,b[2]-a[0]-a[2]),c),b[1]+=(a[0]-a[2])/2);e<b[2]?(b[2]=e,1a.1L(b),n(1a.2h,1b(a){if(a.2T)a.2T.9q=1g}),1a.7P()):f=!0;1d f},fm:1b(){n(1a.2h,1b(a){1c a=a.2T,b;if(a)(b=a.9q)?(a.1i(a.cc),a[a.fd?"1B":"1i"](b),a.fd=!0):a&&a.1i({y:-6b})})},7R:48,5H:F.1w.5H,5L:M.1w.5L,9x:48};W=ea(R,W);aa.cS=W;v(3F,{9y:ab,cv:9G,gn:ma,p7:9w,pD:9v,pC:4T,gV:5k,pN:9l,pj:64,fM:R,po:4l,oD:4z,oC:4X,oy:pa,oO:4L,oK:7X,7Y:34,pg:9N,pH:1b(){1d N},pE:gj,pn:bH,pr:4K,ps:aa,7A:1b(a){N=x(N,a);aw();1d N},bP:J,bM:ba,2l:U,jE:6e,1G:L,7t:n,fT:v,bE:59,m7:x,ls:o,lD:ha,jz:ea,kH:u,kQ:aQ,6R:Z,aR:$,9R:!Z&&!$,kj:"3F",is:"3.0.2"})})();',62,1601,'||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||this|function|var|return|options|width|null|length|attr|chart|for|height|else|series|push|style|stroke|color|add|destroy|min|renderer|prototype|max|align|left|element|animate|text|zIndex|visible|type|css|top|fill|replace|init|translate|xAxis|enabled|group|plotX|center|inverted|isDirty|opacity|plotLeft|data|title|plotTop|call|shadow||||yAxis|||rotation|label|point|delete|right|symbol|plotY|render|axis|new|concat|points|test|highcharts|marker|createElement|redraw|translateY|apply|split|join|len|visibility|dataMin|select|path|dataMax|appendChild|labels|fontSize|index|graphic|translateX|hide|tickInterval|position|clip|tooltip|rect|stops|plotWidth|arguments|selected|lineWidth|span|horiz|padding|clipRect|get|dataLabel|isLog|hover|animation|splice|offset|axes||getBBox||plotHeight|wa|setState|100|end|name|events|pos|cursor|verticalAlign|borderWidth|chartY|chartWidth|chartHeight|click|hidden|chartX|legend|start|bottom|markerGroup|borderColor|selectionMarker|typeof|categories|box|slice|shift|isNaN|pointer|container|display|stacking|isNew|textAlign|pointRange|tickPositions|1E3|Highcharts|remove|indexOf|url|hoverSeries|show|reversed|isInsidePlot|states|firePointEvent|renderTo|isXAxis|break|borderRadius|onMouseOut|isHidden|class|hoverPoints|offsetWidth|tracker|void|qa|parentNode|absolute|drawGraph|rgba|isCartesian|zoom|checkbox|ta|minRange|styles|threshold|pointAttr|shadowGroup|total|middle|dashstyle|hoverPoint|circle|sa|opposite|ra|radius|va|stacks|convertAttribs|symbols|href|innerHTML|subtitle|userOptions|xData|useHTML|default|added|Ca|innerR|duration|ya|isDirtyBox|legendItem|za|legendGroup|noSharedTooltip|shared|userMin|ua|Ba|area|bBox|normalize|userMax|Aa|xa|dataLabels|Na|crisp|Da|linearGradient|Ga|Ia|marginBottom||clientX|connector|onMouseOver|scaleY|hasRendered|rgb|setTimeout|transform|La|hcv|staggerLines|Fa|prepVML|linkedParent|isLinked|formatter|step|className|Ha|Ja|axisTitle|minorTickInterval|clearTimeout|transA|target|dataLabelsGroup|touches|attrSetters|strokeWidth|lang|crosshairs|stop|reset|lastLineHeight|pageX|isDirtyData|Array|setVisible|updateTransform|Ka|backgroundColor|Ea|drawTracker|resize|anchorX|maxTicks|drawLegendSymbol|anchorY|Ma|shape|setSize|Pa|marginRight|255|isDatetimeAxis|oldMin|arc|dashStyle|hasCartesianSeries|sort|fontFamily|itemX|substr|com|getSegmentPath|Sa|symbolName|http|object|isSVG||resetZoomButton|999|getPlotLinePath|axisGroup|Ra|loading|value|Date|Ta|defs|block|toYData|alignedObjects|update|getExtremes|createElementNS|followPointer|stickyTracking|boxWrapper|preventDefault|shadows|shapeArgs|forExport|isActive|lineColor|triangle|size|pow|Qa|plotLinesAndBands|Oa|state|closestPointRange|credits|global|Za|graph|key|Xa|Wa|isDirtyLegend|yData|Va|svg|tooltipPoints|tooltipOptions|category|number|Ya|percent|line|applyOptions|negativeColor|pointInterval||colorCounter|colors||firstRender|cloneRenderTo|fillColor|areaPath|plotSizeX|cum|scaleX|xIncrement|segments|complete|toString|Math|pointClass|offsetHeight|zoomEnabled|pointAttrToOptions|requireSorting|childNodes|brightness|renderToClone|margin|FFFFFF|www|each|xOrY|clipPath|itemStyle|setTooltipPoints|itemHiddenStyle|angle|setOptions|itemY|down|yBottom|destroyClip|hasDragged|mouseDownX|generatePoints|pageY|containerHeight|lineHeight|parseFloat|ticks|spacingBox|axisLine|drawDataLabels|auto|alignDataLabel|plotBox|image|getMargins|radialGradient|toPixels|Ua|format|stackKey||range|isResizing|tickPixelInterval|nodeName||_|yb|tooltipTimeout|day|dateTimeLabelFormats|transB|labelFormatter|htmlUpdateTransform|log|safeRemoveChild|addPlotBandOrLine|side|toValue|clipBox|modifyValue|getPosition|minPixelPadding|getElementsByTagName|crispLine|ss_i|runPointActions|chartPosition|getLinearTickPositions|usePercentage|hideTimer|pinch|positionCheckboxes|500|tooltipFormatter|refresh|spacingRight|oldChartHeight|buildText|legendHeight|containerWidth|textStr|linkedTo|pointCount|xb|toLowerCase|setScale|adjustTickAmounts|html|optionsMarginLeft|spacingTop|spacingBottom|spacingLeft|setChartSize|optionsMarginTop|legendWidth|ub|clipHeight|titleHeight|processedXData|scrollGroup|scroll||alignOptions|bold|contentGroup|fontWeight|fontMetrics|wb|div|zData||removeChild|match|isFirst|move|gradients|brighten|isLast|setExtremes|handleOverflow|currentPage|C0C0C0|qb|baseline|graphNeg|Element|pop|_pos|seriesGroup|processData|plotGroup|symbolWidth|rb|sb|getSymbol|Axis|distance|getSegments|sliced|drawPoints|checked|legendSymbol|percentage|tb|setData|getAttribs|black|unselect|legendType|colorizeItem|vb|colorByPoint|001|column|vml|getLabelConfig|closeSegment|inherit|font|touchstart|trackerGroups|labelPos|initialItemX|alignAttr|_dist|symbolPadding|itemMarginTop|updatePosition|grep|hoverX|maxItemWidth|_hasPointLabels|getAnchor|||half|pinchTranslateDirection|mouseIsDown|inArray|cancelClick|Qb|pinchDown|zoomVert|scaleGroups|hasPinched||inClass|zoomHor|ontouchstart|9999|_events|originalEvent||mouseleave|drop|Jb|scale|pageCount|slicedOffset|trigger|pan|864E5|zoomY|zoomX|ignoreHiddenPoint|loadingShown|button|getColor|Bb|sorted|floating|Gb|pointFormat|scatter|relative|zb|canvas|showInLegend|loadingDiv|cur|horizontal|slicedTranslation|navigation|nav|layout|toD|lastItemY|HighchartsAdapter|round|decimalPoint|pager|set|isDirtyExtremes|shapeType|alignTicks|||Hb|marginTop|marginLeft|bounds|getScript|from|subPixelFix|tagName|solid|inline|radialReference|y2|gradient|x1|y1||x2|behavior|VML|w3|org|getLabelSides|xy|alignTo|square|img|src|invertChild|map|unshift|createTextNode|Mb|symbolAttr|Nb|SPAN|alignOnAdd|removeEvent|whiteSpace|Pb|addEvent|gradientUnits|alignByTranslate|setAttribute|DIV|updateClipping|members|getCSS|insertBefore|cutOff|htmlCss|cutOffPath|strokeweight|filled|millisecond|second|addLabel|12px|axisTitleMargin|stackLabels|hasVisibleSeries|||_attr|endOnTick|oldMax|exec|F0|tickmarkOffset|274b6d|gridGroup|labelGroup|now|useUTC|stackTotalGroup|alternateBands|Fb|_addedPlotLB|stack|minorTicks|startOnTick|minPointOffset|Chart|Kb|||Lb|lin2val|rotate|year|minute|hour|week|month|textWidth|_minorAutoInterval|Ab|startOfWeek|negative|getLogTickPositions|Cb|LN10|hasStroke|maxPadding|minPadding|pie|thousandsSep|onclick|Ib|initSeries|enableMouseTracking|mouseover|_i|addClass|resetMargins|removeAttribute|invertGroups|cropThreshold|pointArrayMap|allowPointSelect|plotBGImage|draw|plotBorder|||posClip|negClip|areaNeg|reverse|chartBackground|plotBorderWidth|columnIndex|getThreshold|location|_colorIndex|plotOptions|ignoreHiddenSeries|processedYData|linkedSeries|_symbolIndex|counters|drawChartBox|setMaxTicks|isRemoving|defaultSeriesType|low|||afterAnimate|sharedClipKey|setTitle|between|setTickPositions|destroyElements|legendLine|clipOffset|plotBackground|rightContX|rightContY|bar|Db|getPointSpline|plotSizeY|setAxisTranslation|Eb|axisOffset|destroyItem|Rb|ordinalSlope|pointStart|spline|cropped|forceRedraw|headerFormat|string|hasUserSize|oldChartWidth|mouseOut|setAxisSize|areaspline|names|192|optionsMarginRight|mouseOver|onTrackerMouseOut|||mouseout|optionsMarginBottom|Ob|dateTimeLabelFormat|ignoreMinPadding|wrapSymbol|filter|setTotal|numericSymbols|270||tickmarkPlacement|_stacksTouched|beforeSetTickPositions|touched|ignoreMaxPadding|val2lin|defaultLeftAxisOptions|console|defaultRightAxisOptions|setOpacity|defaultBottomAxisOptions|oldTransA|defaultTopAxisOptions|isArea|pointRangePadding|beforePadding|defaultLabelFormatter|getPlotBandPath|defaultYAxisOptions|defaultOptions|adjustForMinRange|offsetLeft|getMinorTickPositions|to|plotLines|plotBands|importEvents|showAxis|stateMarkerGraphic|CCC|hasImportedEvents|hasData|getLinePath|getTitlePosition|code|defaultFormatter|getSelectedPoints|Reset|plotLow|fadeOut|verifyDataLabelOverflow|606060|Lucida|13px|currentSymbol|oldAxisLength|getSeriesExtremes|oldUserMin|oldUserMax|||tickAmount|moved|wrapColor|autoIncrement|getTime|_maxTicksKey|bindAxes|tickWidth|getLabelSize|FullYear|placeDataLabels||high|grid|Month|Minutes|Hours|909090|postProcessTickInterval|graphPath|invert||datetime|tooltipHeaderFormatter||tspan|toFixed|offsetTop|cssText|ry|rx|namespaces|68A|String|clipNeg|IMG|Series|isIE8|xmlns|stackTotal|getBoundingClientRect|strong|VMLRadialGradientURL|extend|stackY|isVML|offsetY|_hasPointMarkers|1px|diamond|animationTimeout|mouseenter|userSpaceOnUse|isImg|parentGroup|nowrap|AppleWebKit|Object|stroked|isShadow|||true|getGraphPath|offsetX|crop|setAttributeNS|easing|getAttribute|Sb|dlProcessOptions|urn|schemas|Color|onGetPath|svgElem|isNegative|placed|getLabelPosition||gridLine|getMarkPath|mark|event|userMinRange|snap|C0D0E0|outside|4d759e|showLastLabel|textContent|xCorr|singlePoints|01|cTT|yCorr|try|catch|isArc|isCircle|unitRange|parentInverted|cutHeight|open|microsoft|coordsize|pointPlacement|Tick|cropStart|count|handleZ|toPrecision|11px|htmlGetBBox|labelBBox|unitName|1999|Tb|info|higherRanks|05|removePlotBandOrLine||||_legendItemPos|itemHeight|groupPadding|initialItemY|renderTitle|legendItemWidth|fireEvent|itemHoverStyle|legendItemClick|washMouseEvent|itemCheckboxStyle|legendIndex|allItems|minPointLength|getColumnMetrics|activeColor|inactiveColor|setRadialReference|linejoin|renderItem|adapterRun|pointPadding|positionItem|labelFormat|srcElement|readyState|onContainerMouseMove|onContainerClick|onreadystatechange|onContainerMouseLeave|onmousemove|onContainerMouseDown|callback|months|000000|setDOMEvents|onDocumentMouseMove|onDocumentMouseUp|tooltipOutsidePlot|rtl|grouping|showCheckbox|rank|canvasToolsURL|detachEvent|onContainerTouchStart|onContainerTouchMove|onDocumentTouchEnd|setOffset|up|cloneNode|6E4|translatedThreshold|getChartSize|getSeconds|startAngleRad|showResetZoom|resetSelection|360|||180||displayBtn||overflow|inside|extraBottomMargin|extraTopMargin|getOffset|initReflow|10px||endResize|normal|webkit|_cursor|version|selection|zoomOut|forEach|_hasTracking|adjustTickAmount|started|addSeries|removeEventListener|items|fullHeight|tooltipPos|pointWidth|elem|labelStyle|isX|theme|resetZoom|resetZoomTitle|Firefox|getCenter|loadingSpan|parseInt|plotBorderColor|_default|justify|item|shortMonths|May|connX|mouseDownY|getAxes|propFromSeries|getContainer|drag|dragStart|callbacks|connY|hideCrosshairs|closedStacks|getIndex|Ub|optionsToObject|plot|||weekdays|lastValidTouch|Width|isReadyToRender|load|getCoordinates|getX|Unicode|allowDecimals|abs|Verdana|italic|propHooks|Tween|Monday|weight||31556952E3|Loading|FEFEFE|CCCCCC|F6F6F6|alpha|extendClass|shortdashdotdot|firstChild|border|1fill|discardElement|cos|cssHooks|navigator|Dec|desc|serif|window|February|200|c42525|base|bind|16px|createSVGRect|sans|Arial|with|easeOutQuad|getContext|Helvetica|Created|a6c96a|floor|prop|Sunday|ceil|FFF|nodeType|tools|166|PI|||AM|onload|PM|longdash|undefined|gfx|setUTC|product|modules|shortdot|sin|Saturday|Friday|level|hasOwnProperty|shortdash|date|Invalid|Thursday|xlink|radial|9BD|CDF|Grande|documentElement|Wednesday|Tuesday|unbind|6048E5|ACF|Sans|pInt|36E5|toUpperCase|002|dateFormats|January|0E|none|4572A7|wrap|preserveAspectRatio|png|26784E5|Event|M12|M11|M21|M22|getUTC|anchor|November|Microsoft|March|Matrix|2f7ed8|9px|December|innerText|666|||enmotech|Jan|dasharray|elemHeight|sizingMethod|expand|14px|elemWidth|msie|DXImageTransform|NaN|June|July|deg|MozTransform|throw|pick||77a1e5|April|f28f43|errors|492970|8bbc21|October|0d233a|progid|splat|910000|August|1aadce|opera|September|error|Enmotech|000|dot|Nov|UTC|Phone|Windows|Aug|Sep|150|Oct|onmouseout|shortdashdot|detached|300|2000|document|layerX|3E576F|setMilliseconds|stopPropagation|layerY|onmouseover|merge|isDefaultPrevented|Mar|||Mobile|HongyeDBA|8px|documentMode|setSeconds|toFront|totalRange|getTimezoneOffset|Feb|Apr|333333|Android|1em|Jul|jQuery|white||Jun|userAgent|Week|namespaceURI|dash|Day|ordinalPositions|itemMarginBottom|clearInterval|browserEvent|input|checkboxClick|defaultChecked|touchend|ontouchmove|cancelBubble|relatedTarget|onmousedown|mousemove|mouseup|itemWidth|softConnector|addAxis|reflow|afterSetExtremes|showLoading|hideLoading|showDuration|showAxes|runChartClick|connectorWidth|legendItems|connectorPadding|maxHeight|arrowSize|toElement|openMenu|connectorColor|minSize|hideDelay|plotHigh|tooltipRefresh|footerFormat|||setCategories|minor|showEmpty|addPlotLine|gridZIndex|lineTop|alternateGridColor|positioner|zoomType|167|114|panning|returnValue|mousedown|selectionMarkerFill|sqrt|Top|Left|Height|followTouchMove|pinchVert|asin|hideDuration|metaKey|ctrlKey|shiftKey|runTrackerClick|connectNulls|previous|valueSuffix|valuePrefix|pointValKey|beforeRender|dataLabelUpper|accumulate|valueDecimals|fillOpacity|addPoint|tooltipLen|markers|xDateFormat|_sharedClip|533|Infinity|updatedData|turboThreshold|negativeFillColor|trackByArea|forceCrop|hasGroupedData|attachEvent|canvg|9999px|400|body|getElementById|tap|Slice|600|innerSize|||relativeTo|getSelectedSeries|startAngle|pinchX|pinchY|highlight|create|barX|polar|columnMetrics|scroller||rangeSelector|angular|plotShadow|below|reflowTimeout|dlBox|plotBackgroundColor|plotBackgroundImage|addPlotBand|pinchHor|arrayMax|pattern|Values|xhtml|arrayMin|SVGRenderer|linear|gridLineWidth|opacity2|logarithmic|maxZoom|LineWidth|dateFormat|08|MSIE|getExtremesFromAll|charts|removePlotLine|removePlotBand|createStyleSheet|focus|tickPosition|showFirstLabel|gridLineColor|minorGridLineColor|E0E0E0|tick|Position|LineColor|LineDashStyle|Length|minorGridLineWidth|minorTickColor|Grid|method|Legend|tickLength|any|||tickColor|A0A0A0|minorTickLength|minorTickPosition|pathAnim|ordinal|false|Renderer|getNonLinearTimeTicks|deferUpdateTransform||isTouchDevice|SVGElement|paddingLeft|units|numberFormat|seriesTypes|textDecoration|atan|color2|VMLElement||999em|allowZoomOutside|CanVGRenderer|VMLRenderer|Point|Pointer|hasBidiBug|translationSlope|tickPositioner|getOptions|strokecolor|origin|flip|minTickInterval|offsetRight|Tooltip|fillcolor'.split('|'),0,{}))
 eval(function(p,a,c,k,e,d){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--){d[e(c)]=k[c]||e(c)}k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1};while(c--){if(k[c]){p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c])}}return p}('g.h={C:[\'#x\',\'#J\',\'#K\',\'#U\',\'#T\',\'#V\',\'#W\',\'#R\',\'#M\'],L:{N:{O:{Q:0,P:0,Y:1,S:1},X:[[0,\'o(c, c, c)\'],[1,\'o(m, m, c)\']]},z:3,A:10,y:\'#v\',w:l,B:1,H:I},G:{F:{D:{E:l,i:0,1n:3}}},d:{7:{4:\'#1o\',b:\'j 1m "a 9", 8, 5-6\'}},1l:{7:{4:\'#1i\',b:\'j q "a 9", 8, 5-6\'}},1j:{1k:1,1p:Z,p:\'#1q\',t:\'#n\',i:2,f:{7:{4:\'#e\',b:\'1u a 9, 8, 5-6\'}},d:{7:{4:\'#r\',k:\'u\',s:\'a 9, 8, 5-6\'}}},1s:{1t:\'1r\',t:\'#n\',i:2,1h:1,p:\'#e\',f:{7:{4:\'#e\',b:\'q a 9, 8, 5-6\'}},d:{7:{4:\'#r\',k:\'u\',s:\'a 9, 8, 5-6\'}}},1g:{16:{b:\'17 a 9, 8, 5-6\',4:\'15\'},14:{4:\'#11\'},12:{4:\'13\'}},f:{7:{4:\'#18\'}},19:{1e:{h:{1f:\'#1d\'}}}};1c 1a=g.1b(g.h);',62,93,'||||color|sans|serif|style|Verdana|MS|Trebuchet|font|255|title|000|labels|Highcharts|theme|lineWidth|bold|fontSize|false|240|B8860B|rgb|tickColor|11px|333|fontFamily|lineColor|12px|F4F4F4|plotShadow|058DC7|plotBackgroundColor|borderWidth|borderRadius|plotBorderWidth|colors|marker|enabled|spline|plotOptions|spacingRight|25|50B432|ED561B|chart|6AF9C4|backgroundColor|linearGradient|y1|x1|FFF263|y2|24CBE5|DDDF00|64E572|FF9655|stops|x2|86400000||039|itemHiddenStyle|gray|itemHoverStyle|black|itemStyle|10pt|99b|navigation|highchartsOptions|setOptions|var|CCCCCC|buttonOptions|stroke|legend|tickWidth|888888|xAxis|gridLineWidth|subtitle|15px|radius|000000|tickInterval|FFFFFF|auto|yAxis|minorTickInterval|10px'.split('|'),0,{}))
 </script>
EOFOFGRAPHICHTML
    print_log "[make_html_header]" "" "Successfully Create Graphic Header "
    print_log "[make_html_header]" "5" "${__GRAPHIC_HEADER}"
  else
    print_log "[make_html_header]" "" "Graphic Header already Created, Skip Creation ..."
  fi
  print_log "[make_html_header]" "" "End Create Html Graphic Header"
}

#########################################################################################################
##                                                                                                     ##
## Function make_os_scripts(): Create getOSData Scripts for OS Related Data Collection                 ##
##                                                                                                     ##
#########################################################################################################
make_os_scripts(){

  print_log "[make_os_scripts]" "" "Begin Create OS Collection Script into [${__OS_SCRIPT}]"
  cat > ${__OS_SCRIPT} <<ENDOFOSPERL
 \$scriptVersion = ${__SCRIPT_VERSION};
 \$resultDir = "${__RESULT_DIR}";
 \$errorFile = "${__ERRORFILE}";
 \$alertHTML = "${__ALERT_HTML}";
 \$logFile = "${__LOGFILE}";
 \$deleteFileScripts = "${__DELETE_FILE}";
 \$hostname = "${__HOSTNAME}";
ENDOFOSPERL

  cat >> ${__OS_SCRIPT} <<"ENDOFOSPERL"
 $OSType = `uname`;
 chomp $OSType;
 my ($bsec, $bmin, $bhour, $bmday, $bmonth, $byear, $bwday, $byday, $bdaylight) = localtime(time - 2678400);
 my ($esec, $emin, $ehour, $emday, $emonth, $eyear, $ewday, $eyday, $edaylight) = localtime;
 $byear += 1900;
 $bmonth += 1;
 $eyear += 1900;
 $emonth += 1;
 if ($emonth < 10){
   $emonth = "0".$emonth;
 }
 if ($bmonth < 10){
   $bmonth = "0".$bmonth;
 }
 if ($bmday < 10){
   $bmday = "0".$bmday;
 }
 if ($emday < 10){
   $emday = "0".$emday;
 }
 $endTime=$eyear.$emonth.$emday;
 $beginTime=$byear.$bmonth.$bmday;

 $traceDir = ${resultDir}."/Trace";
 $OSDir = ${resultDir}."/OS_Info";
 $logDir = ${resultDir}."/Logs";
 $CRSDir = ${logDir};
 $listenerDir = ${logDir};
 $dbAlertFileName='N/A';
 $asmAlertFileName='N/A';
 $maxAlertLines=100000;
 $maxListenerLines=100000;
 $commandCode="11111";
 $dbVersion="0";
 $oracleSID = $ENV{'ORACLE_SID'};
 $oracleHome = $ENV{'ORACLE_HOME'};
 $tnsAdmin = $ENV{'TNS_ADMIN'};
 $crsHome = $ENV{'CRS_HOME'} if $ENV{'CRS_HOME'};
 $crsHome = $ENV{'ORA_CRS_HOME'} if $ENV{'ORA_CRS_HOME'};
 $crsHome = $ENV{'GRID_HOME'} if $ENV{'GRID_HOME'};
 $loginUser = $ENV{'LOGNAME'};
 $currentPWD = $ENV{'PWD'};
 $userShell = $ENV{'SHELL'};
 $setEnvCommand = "";
 $sqlplusUser = 'sys/oracle as sysdba';

 open LOGFILE, ">>", $logFile || die "Cannot open logfile [${logFile}]";

 $helpMSG="
   Usage : perl getOSData.pl [-f <alert_file_name>] [-a <alert_file_name>] [-b 20120909]
 Options :
           -c  Input Command Code, Default 11111, see Command
           -d  Input OS Data Directory
           -t  Input Trace File Directory
           -f  Input DB Alert Manual if the Instance is not Running
           -a  Input ASM Alert Manual if you have ASM in 11g or ASM Instance is not Running
           -b  Input a Begin Time to analyzer , default 31 days ago
           -u  Input a USER Login Info for SQLPLUS, default 'sys/oracle as sysdba'
           -v  Input Database Version, default 10
           -o  Input Oracle Home
           -i  Input Oracle SID
           -h  Show the help message
 Command :
           Char 1 : 1 = Collect DB ALert , 0 = Not Collect
           Char 2 : 1 = Collect ASM ALert, 0 = Not Collect
           Char 3 : 1 = Collect CRS Log  , 0 = Not Collect
           Char 4 : 1 = Collect OS Report, 0 = Not Collect
           Char 5 : 1 = Collect Listener , 0 = Not Collect\n";

 sub print_log{
   my ( $sec, $min, $hour, $mday, $month, $year, $wday, $yday, $daylight )=localtime;
   $year += 1900;
   $month += 1;
   $month = "0".$month if ($month < 10);
   $mday = "0".$mday if ($mday < 10);
   $sec = "0".$sec if ($sec < 10);
   $min = "0".$min if ($min < 10);
   $hour = "0".$hour if ($hour < 10);
   $date = "$year-$month-$mday $hour:$min:$sec";
   printf LOGFILE "%18s%22s : %s\n", $date, "[".$_[0]."]", $_[1];
   printf STDOUT "%18s%22s : %s\n", $date, "[".$_[0]."]", $_[1];
 }

 sub print_logfile{
   my ( $sec, $min, $hour, $mday, $month, $year, $wday, $yday, $daylight )=localtime;
   $year += 1900;
   $month += 1;
   $month = "0".$month if ($month < 10);
   $mday = "0".$mday if ($mday < 10);
   $sec = "0".$sec if ($sec < 10);
   $min = "0".$min if ($min < 10);
   $hour = "0".$hour if ($hour < 10);
   $date = "$year-$month-$mday $hour:$min:$sec";
   printf LOGFILE "%18s%22s : %s\n", $date, "[".$_[0]."]", $_[1];
 }

 &print_log("prepare_env", "CRS Home from Environment is [$crsHome]");
 if ((! -f $crsHome."/log/".$hostname."/alert".$hostname.".log") || (! -f $crsHome."/log/".$hostname."/crsd/crsd.log") || (! -f $crsHome."/log/".$hostname."/cssd/ocssd.log")) {
   $crsHome = "";
 }
 if ("$crsHome" eq ""){
   $crsHome=`ps -ef | grep -v grep | grep "/bin/crsd.bin"`;
   $crsHome=~ s#/bin/crsd.bin.*##;
   $crsHome=~ s#\A.* /#/#g;
   chomp $crsHome;
   &print_log("prepare_env", "Dynamic Get CRS Home is [$crsHome]");
 }

 # Make Sure Begin Time is earlier than End Time
 if ( $beginTime gt $endTime ) {
   &print_log("ERROR", "Begin Time ($beginTime) is bigger than End Time ($endTime) , Program exit ...") && die;
 } else {
   &print_log("prepare_env", "Begin Time is [$beginTime], End Time is [$endTime]");
 }

 while ( my $optName = shift @ARGV ){
   if ( $optName eq "-f" ){
     $dbAlertFileName = shift @ARGV;
     &print_log("prepare_env", "User Input Value for DB Alert [$dbAlertFileName]");
   }
   elsif ( $optName eq "-a" ){
     $asmAlertFileName = shift @ARGV;
     &print_log("prepare_env", "User Input Value for ASM Alert [$asmAlertFileName]");
   }
   elsif ( $optName eq "-b" ){
     $beginTime = shift @ARGV;
     &print_log("prepare_env", "User Input Value for Begin Time [$beginTime]");
   }
   elsif ( $optName eq "-c" ){
     $commandCode = shift @ARGV;
     if ( $commandCode =~ m/[01][01][01][01][01]/ ){
       &print_log("prepare_env", "User Input Value for Command Code [$commandCode]");
     } else {
       &print_log("ERROR", "Command Code must Having Five Char, Which Contain only 1 or 0 ...");
       exit 1;
     }
   }
   elsif ( $optName eq "-e" ){
     $endTime = shift @ARGV;
     &print_log("prepare_env", "User Input Value for End Time [$endTime]");
   }
   elsif ( $optName eq "-i" ){
     $oracleSID = shift @ARGV;
     &print_log("prepare_env", "User Input Value for Oracle SID [$oracleSID]");
   }
   elsif ( $optName eq "-o" ){
     $oracleHome = shift @ARGV;
     &print_log("prepare_env", "User Input Value for Oracle Home [$oracleHome]");
   }
   elsif ( $optName eq "-v" ){
     $dbVersion = shift @ARGV;
     &print_log("prepare_env", "User Input Value for DB Version [$dbVersion]");
   }
   elsif ( $optName eq "-u" ){
     $sqlplusUser = "@ARGV";
     shift @ARGV;
     shift @ARGV;
     shift @ARGV;
     &print_log("prepare_env", "User Input Value for User Login Info to SQLPLUS [$sqlplusUser]");
   }
   else{
     print $helpMSG;
     exit 0;
   }
 }

 if ($userShell =~ m#.*/csh#){
   $setEnvCommand = "setenv ORACLE_HOME $oracleHome; setenv ORACLE_SID $oracleSID"
 }else{
   $setEnvCommand = "ORACLE_HOME=$oracleHome; ORACLE_SID=$oracleSID; export ORACLE_HOME ORACLE_SID"
 }
 &print_log("prepare_env", "Oracle Env set as [$setEnvCommand]");

 open RMTEMPSCRIPT, ">>", ${deleteFileScripts} || die "cannot open remove scripts [${deleteFileScripts}]";

 #########################################################################################################
 ##                                                                                                     ##
 ## Function get_dbalert() : Get Alert File                                                             ##
 ##                                                                                                     ##
 #########################################################################################################
 sub get_dbalert{

   if ($dbAlertFileName ne "N/A") {
     &print_log("get_dbalert", "No Need to Get Alert From DB, it already set to [$dbAlertFileName]");
   } else{
     my $alertTMP = ${CRSDir}."/db_alert_filename_${oracleSID}.tmp";
     print RMTEMPSCRIPT "rm $currentPWD/${alertTMP} 2>/dev/null\n";
     my $sql = 'SELECT (SELECT VALUE FROM V\\$PARAMETER WHERE NAME=\'background_dump_dest\') || \'/alert_\' || (SELECT VALUE FROM V\\$PARAMETER WHERE NAME=\'instance_name\') ||\'.log\' FROM DUAL;';
     `$setEnvCommand ; $oracleHome/bin/sqlplus -s "${sqlplusUser}" <<EOF
     SET FEEDBACK OFF TI OFF TIMI OFF HEADING OFF VER OFF TRIMSPOOL on TRIMOUT on LINES 1111
     SPOOL $alertTMP
     $sql
     SPOOL OFF
     EXIT
ENDOFOSPERL

  echo 'EOF`;' >> ${__OS_SCRIPT}
  cat >> ${__OS_SCRIPT} <<"ENDOFOSPERL"
     if( "`cat $alertTMP | grep '^ORA-'`" != "" ){
       &print_log("ERROR", "Cannot get DB Alert File");
       &print_log("Cause", "${sqlplusUser}");
     }
     else {
       $dbAlertFileName =`cat $alertTMP | grep 'alert_$oracleSID'`;
       #$dbAlertFileName =~ s/(^ +| +\n$)//g;
       chomp($dbAlertFileName);
     }
   }
   my $noCollect=0;
   until ( (-T $dbAlertFileName) || $noCollect ==1 ){
     &print_log("get_dbalert", " DB Alert File [$dbAlertFileName] not Correct, Please input another (None for Manual Collect):");
     print "==========[ Waiting for input ]=========> ";
     $dbAlertFileName = <STDIN>;
     chomp $dbAlertFileName;
     &print_log("get_dbalert()", $dbAlertFileName);
     $noCollect = 1 if "$dbAlertFileName " =~ m/\A\s\z/;
   }
   if ($noCollect == 0){
     my $fileNameOnly = $dbAlertFileName;
     $fileNameOnly =~ s/.*[\|\/]//;
     &get_content($dbAlertFileName, $fileNameOnly);
     &get_trace($fileNameOnly);
   }
 }

 #########################################################################################################
 ##                                                                                                     ##
 ## Function get_asmalert() : Get ASM Alert File                                                        ##
 ##                                                                                                     ##
 #########################################################################################################
 sub get_asmalert{

   my $asmRunning=`ps -ef | grep asm_pmon_ | grep -v grep | wc -l\n`;
   $asmRunning =~ s/\A\s*|\s*\z//g;
   if ($asmAlertFileName ne "N/A") {
     &print_log("get_asmalert", "No Need to Get ASM Alert FileName, it already set to [$asmAlertFileName]");
   } elsif ($asmRunning eq "0"){
     $asmAlertFileName = "N/A";
     &print_log("get_asmalert", "No ASM Instance Currently Running, Skip ASM Alert Collection");
   } else{
     # Get ASM SID
     my $asmSID = `ps -ef | grep asm_pmon_ | grep -v grep`;
     $asmSID =~ s/\A^.*asm_pmon_//;
     chomp $asmSID;
     &print_log("get_asmalert", "Get ASM SID is [$asmSID]");

     # Get ASM Home
     my $asmHome="";
     my $asmUser=$sqlplusUser;
     my $asmAlertError="";
     my $alertTMP="";
     if ($dbVersion == 10){
       $asmHome=$oracleHome;
     } elsif ($dbVersion == 11){
       $asmHome=$crsHome;
       $asmUser =~ s#as sysdba#as sysasm#g;
     }
     &print_log("get_asmalert", "Get ASM Home is [$asmHome]");
     &print_log("get_asmalert", "Get ASM Login User is [$asmUser]");

     $alertTMP=`ORACLE_SID=$asmSID; export ORACLE_SID; ORACLE_HOME=$asmHome; export ORACLE_HOME; $asmHome/bin/sqlplus -s "${asmUser}" <<EOF
     SET FEEDBACK OFF TI OFF TIMI OFF HEADING OFF VER OFF TRIMSPOOL ON TRIMOUT ON LINES 1111
     SELECT (SELECT VALUE FROM V\\\$PARAMETER WHERE NAME='background_dump_dest')||'/alert_'||(SELECT VALUE FROM V\\\$PARAMETER WHERE NAME='instance_name') ||'.log' FROM DUAL;
     EXIT
ENDOFOSPERL

  echo 'EOF`;' >> ${__OS_SCRIPT}
  cat >> ${__OS_SCRIPT} <<"ENDOFOSPERL"
     $asmAlertError = `echo "$alertTMP" | grep ORA-`;
     chomp $asmAlertError;
     if ( "$asmAlertError" eq "" && "$alertTMP" ne "" ){
       $asmAlertFileName =`echo "$alertTMP" | grep 'alert_$asmSID'`;
       chomp($asmAlertFileName);
       &print_log("get_asmalert", "Get ASM Alert File is [$asmAlertFileName]");
     } elsif ("$alertTMP" ne "" ){
       &print_log("get_asmalert", "[Error] Cannot get ASM Alert File with [${asmAlertError}]");
       &print_log("get_asmalert", "Try to collect ASM File Name with OS Authentication");
       if ( $dbVersion >= 11 ){
         $asmUser = '/ as sysasm';
       } else {
         $asmUser ='/ as sysdba';
       }
       &print_log("get_asmalert", "Get ASM Login User (OS Authentication) is [$asmUser]");
       $alertTMP=`ORACLE_SID=$asmSID; export ORACLE_SID; ORACLE_HOME=$asmHome; export ORACLE_HOME; $asmHome/bin/sqlplus -s "$asmUser" <<EOF
       SET FEEDBACK OFF TI OFF TIMI OFF HEADING OFF VER OFF TRIMSPOOL ON TRIMOUT ON
       SELECT (SELECT VALUE FROM V\\\$PARAMETER WHERE NAME='background_dump_dest')||'/alert_'||(SELECT VALUE FROM V\\\$PARAMETER WHERE NAME='instance_name') ||'.log' FROM DUAL;
       EXIT
ENDOFOSPERL

  echo 'EOF`;' >> ${__OS_SCRIPT}
  cat >> ${__OS_SCRIPT} <<"ENDOFOSPERL"
       `ORACLE_SID=$oracleSID; export ORACLE_SID; ORACLE_HOME=$oracleHome; export ORACLE_HOME`;
       $asmAlertError = `echo "$alertTMP" | grep ORA-`;
       chomp $asmAlertError;
       if ( "$asmAlertError" eq "" && "$alertTMP" ne "" ){
         $asmAlertFileName =`echo "$alertTMP" | grep 'alert_$asmSID'`;
         chomp($asmAlertFileName);
         &print_log("get_asmalert", "Get ASM Alert File (OS Authentication) is [$asmAlertFileName]");
       } elsif ("$alertTMP" ne "" ){
         &print_log("get_asmalert", "[Error] Cannot get ASM Alert File (OS Authentication) with [${asmAlertError}]");
       } else {
         &print_log("get_asmalert", "No ASM Alert Spool File Created, Something Error in Get ASM Alert File Name (OS Authentication)");
       }
     } else {
       &print_log("get_asmalert", "No ASM Alert Spool File Created, Something Error in Get ASM Alert File Name ");
     }
   }
   if ( $asmAlertFileName eq "N/A"){
     &print_log("get_asmalert", "No ASM or Manual Collect ASM Alert ");
   } else {
     my $noCollect=0;
     until ( (-T $asmAlertFileName) || $noCollect ==1 ){
       &print_log("get_asmalert", "ASM Alert File [$asmAlertFileName] not Correct, Please input another (None for Manual Collect):");
       print "==========[ Waiting for input ]=========> ";
       $asmAlertFileName = <STDIN>;
       chomp $asmAlertFileName;
       &print_log("get_asmalert()", $asmAlertFileName);
       $noCollect = 1 if "$asmAlertFileName " =~ m/\A\s\z/;
     }
     if ($noCollect == 0){
       my $fileNameOnly = $asmAlertFileName;
       $fileNameOnly =~ s/.*[\|\/]//;
       &get_content($asmAlertFileName, $fileNameOnly);
       &get_trace($fileNameOnly);
     }
   }
 }

 #########################################################################################################
 ##                                                                                                     ##
 ## Function get_content() : Get Alert File from Begin Time to End Time                                 ##
 ## Need Two Parameters : Alert File Name , Collected Alert File Name                                   ##
 ##                                                                                                     ##
 #########################################################################################################
 sub get_content(){

   my $collectAlertFile = $CRSDir."/".$_[1];
   my $alertContents = $CRSDir."/alertContents.tmp";
   `tail -$maxAlertLines $_[0] > $alertContents`;
   &print_log("get_content", "Get $maxAlertLines Lines From Tail of the Alert [$_[1]]");
   print RMTEMPSCRIPT "rm ".$currentPWD."/".$alertContents." 2>/dev/null\n";

   open ALERTFILE, "<", "$alertContents" || die "cannot open Temp Alert File [$alertContents]";
   @AllAlert = <ALERTFILE>;
   close ALERTFILE;

   my $nowDate=11111111;
   #Thu Mar 03 09:49:00 2011
   my $stepSize = @AllAlert/2;
   $stepSize =~ s/\..*\z//;
   my $nowStep = 0;
   my $nowLineContent = '';
   $maxAlertLines = @AllAlert;
   my $currLoopCount=1;
   while (1){
 #   print "Now Step = $nowStep , Step Size = $stepSize \n";
     $nowLineContent = $AllAlert[$nowStep];
     $nowDate=11111111;
 #   print "Now Step is : $nowStep\n";
     if ($nowLineContent =~ m/\A(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+([0-9]*)\s+[0-9]*:[0-9]*:[0-9]*.*\s+([0-9][0-9][0-9][0-9])/){
       $nowDate=$4;
       if($2 eq "Jan"){
         $nowDate=$nowDate."01";
       } elsif ($2 eq "Feb"){
         $nowDate=$nowDate."02";
       } elsif ($2 eq "Mar"){
         $nowDate=$nowDate."03";
       } elsif ($2 eq "Apr"){
         $nowDate=$nowDate."04";
       } elsif ($2 eq "May"){
         $nowDate=$nowDate."05";
       } elsif ($2 eq "Jun"){
         $nowDate=$nowDate."06";
       } elsif ($2 eq "Jul"){
         $nowDate=$nowDate."07";
       } elsif ($2 eq "Aug"){
         $nowDate=$nowDate."08";
       } elsif ($2 eq "Sep"){
         $nowDate=$nowDate."09";
       } elsif ($2 eq "Oct"){
         $nowDate=$nowDate."10";
       } elsif ($2 eq "Nov"){
         $nowDate=$nowDate."11";
       } else{
         $nowDate=$nowDate."12";
       }
       if (length($3) == 1) {
         $nowDate=$nowDate."0".$3;
       } else{
         $nowDate=$nowDate.$3;
       }
 #      print "Match Time Line : Year = [$4], Month = [$2], Day = [$3], nowDate = [$nowDate]\n";
     }

     # Loop Counter to Avoid Endless Loop
     if ($currLoopCount > $maxAlertLines/2){
        &print_logfile("get_content", "Loop for [$currLoopCount] Count, Maybe Arithmetic Error !");
        $nowStep = 0;
        last;
     }
     else {
        $currLoopCount += 1;
     }

 ##############################################################################
 ## 1. 非时间行，进入下一行
 ## 2. 时间行，
 ##    1. 当前行 - 当前步长 > 最大行 - 1000    --> 取最后1000行，退出
 ##    2. 步子 != 1
 ##       1. 当前时间  < 开始时间    --> 前跳剩余行的一半，步子变为剩余行一半
 ##       2. 当前时间 >= 开始时间    --> 后跳步子的一半，步子减半
 ##    3. 步子  = 1
 ##       1. 当前时间 >= 开始时间    --> 退出
 ##       2. 当前时间  < 开始时间    --> 重新计算步子
 ##############################################################################
     #&print_logfile("get_content", "steps = [$stepSize], Now =[$nowStep], Lines = [$maxAlertLines]");
     if ( $nowDate == 11111111 ) {
       &print_logfile("get_content", "Step=[$stepSize], Now=[$nowStep], Not Time, Move next ...");
       $nowStep += 1;
     }
     else {
       if (($maxAlertLines - $nowStep + $stepSize) < 1000 ){
            &print_log("get_content", "Step=[$stepSize], Now=[$nowStep], Scanned all, Copy Last 1000 Lines !");
            $nowStep = $maxAlertLines - 1000 < 0 ? 0 : $maxAlertLines - 1000;
            last;
       }
       elsif ($stepSize == 1){
          if ($nowDate >= $beginTime) {
            &print_log("get_content", "Step=[$stepSize], Now=[$nowStep], Date=[$nowDate] Later then Begin Time, Over !");
            last;
          }
          else {
            $stepSize = ($maxAlertLines - $nowStep)/2;
          }
       }
       else {
         if ( $nowDate < $beginTime ) {
           &print_logfile("get_content", "Step=[$stepSize], Now=[$nowStep], Date=[$nowDate] Earler then Begin Time, Jump to next ...");
           $stepSize = int(($maxAlertLines - $nowStep)/2);
           $nowStep += $stepSize;
         }
         else {
           &print_logfile("get_content", "Step=[$stepSize], Now=[$nowStep], Date=[$nowDate] not Earlier and StepSize > 1, Back to Half ...");
           $stepSize = int($stepSize >= 2 ?  $stepSize/2 : 1);
           $nowStep = $nowStep > $stepSize ? $nowStep - $stepSize : 0;
         }
       }
     }
   }

   # Begin Loop Write Needed Alert to Target File
   &print_log("get_content", "Get Begin Line[$nowStep]");
   open COLLECTEDALERT, ">", $collectAlertFile;
   print COLLECTEDALERT "<pre style=\"word-wrap: break-word; white-space: pre-wrap; white-space: -moz-pre-wrap\">\n";
   for (my $x=$nowStep; $x<@AllAlert; $x++){
     print COLLECTEDALERT $AllAlert[$x];
   }
   close COLLECTEDALERT;
   &print_log("get_content", "Write Needed Alert into [$collectAlertFile]");
 }

 #########################################################################################################
 ##                                                                                                     ##
 ## Function get_trace() : Get Trace File refered in collected Alert                                    ##
 ##                                                                                                     ##
 #########################################################################################################
 sub get_trace(){

   my $alertName=$_[0];
   my $alertCollected = $CRSDir."/".$alertName;
   open ALERTFILE, "<", "$alertCollected" || die "cannot open Alert File [$alertCollected]";

   my $currentContent = '';
   my $currentDate = '';
   my $errorIndex=0;
   my @errorCode=(' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
   my @errorMsg=(' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
   my @errorFileList=(' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
   my $currentColor="";
   my $OrigFileName="";
   my $CollectFileName="";
   my $traceFileOK=1;
   my $errorFileNameOnly="";
   open ALERTTOHTML, ">>", $alertHTML;
   print ALERTTOHTML "<br><H3 class='awr'> Alert Errors for : [<a href='./Logs/$alertName.html'>$alertName</a>] </H3><p><table border=1 WIDTH=300></table><p> <table border=1 width=1000><tr><th class=awrbg height=30px width=14%>Time</th><th class=awrbg height=30px width=8%>Error Code</th><th class=awrbg height=30px>Error Message</th><th class=awrbg height=30px width=15%>Trace File</th></tr>";
   while ( <ALERTFILE> ){
     chomp ;
     $currentContent = $_;
     if ($currentContent =~ m/\A(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+([0-9]*)\s+([0-9]*:[0-9]*:[0-9]*).*\s+([0-9][0-9][0-9][0-9])/){
       # Write Pre Error Message
       for (my $idxI=0; $idxI<$errorIndex; $idxI++){
         #&print_log('Pro_Debug', "Write Error Line : Time = [$currentDate], Code = [$errorCode[$idxI]], Message = [$errorMsg[$idxI]]");
         if ($idxI == 0){
           print ALERTTOHTML "<tr><th rowSpan=$errorIndex class=awrnbg>$currentDate</th> <td class=awr${currentColor}c>$errorCode[0]</td> <td class=awr${currentColor}c>$errorMsg[0]</td><td class=awr${currentColor}c>$errorFileList[$idxI]</td></tr>";
         } else{
           print ALERTTOHTML "<tr> <td class=awr${currentColor}c>$errorCode[$idxI]</td> <td class=awr${currentColor}c>$errorMsg[$idxI]</td><td class=awr${currentColor}c>$errorFileList[$idxI]</td></tr>";
         }
         if ($currentColor eq "n"){
           $currentColor="";
         } else{
           $currentColor="n";
         }
       }
       # Prepare New Error Message
       @errorCode=(' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
       @errorMsg=(' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
       @errorFileList=(' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
       $errorIndex=0;
       $currentDate=$5;
       if($2 eq "Jan"){
         $currentDate=$currentDate."-01-";
       } elsif ($2 eq "Feb"){
         $currentDate=$currentDate."-02-";
       } elsif ($2 eq "Mar"){
         $currentDate=$currentDate."-03-";
       } elsif ($2 eq "Apr"){
         $currentDate=$currentDate."-04-";
       } elsif ($2 eq "May"){
         $currentDate=$currentDate."-05-";
       } elsif ($2 eq "Jun"){
         $currentDate=$currentDate."-06-";
       } elsif ($2 eq "Jul"){
         $currentDate=$currentDate."-07-";
       } elsif ($2 eq "Aug"){
         $currentDate=$currentDate."-08-";
       } elsif ($2 eq "Sep"){
         $currentDate=$currentDate."-09-";
       } elsif ($2 eq "Oct"){
         $currentDate=$currentDate."-10-";
       } elsif ($2 eq "Nov"){
         $currentDate=$currentDate."-11-";
       } else{
         $currentDate=$currentDate."-12-";
       }
       if (length($3) == 1) {
         $currentDate=$currentDate."0".$3;
       } else{
         $currentDate=$currentDate.$3;
       }
       $currentDate=$currentDate.' '.$4;
       #&print_log("Pro_Debug", "Match Time Line : Year = [$5], Month = [$2], Day = [$3], Time = [$4], currentDate = [$currentDate]");
     }
     if ($currentContent =~ m/ in file /) {
       s/.* in file *//;
       s/trc.*:.*\z/trc/;
       $OrigFileName = $_;
       s/.*[\|\/]//;
       $errorFileNameOnly=$_;
       $CollectFileName = $traceDir."/".$errorFileNameOnly;
       $traceFileOK=1;
       if ( -f $OrigFileName && -f $CollectFileName){
         &print_log("get_trace", "     SKIP [$OrigFileName]");
       } elsif ( -f $OrigFileName ) {
         `echo '<pre style="word-wrap: break-word; white-space: pre-wrap; white-space: -moz-pre-wrap">' > ${CollectFileName}; cat ${OrigFileName} >> ${CollectFileName}`;
         if ( $? == 0 ){
           &print_log("get_trace", "COLLECTED [$OrigFileName]");
         }else{
           $traceFileOK=0;
           &print_log("WARNING", "   MISSED [$OrigFileName] with Error : $!");
         }
       } else {
         $traceFileOK=0;
         &print_log("get_trace", "   MISSED [$OrigFileName]");
       }
       if ( $traceFileOK == 1 && $errorFileList[$errorIndex] eq ' ' ){
         $errorFileList[$errorIndex]="<a href='./Trace/$errorFileNameOnly.html'>$errorFileNameOnly</a>";
       } elsif ( $traceFileOK == 1 ){
         $errorFileList[$errorIndex]="$errorFileList[$errorIndex]<br><a href='./Trace/$errorFileNameOnly.html'>$errorFileNameOnly</a>";
       }
     } elsif ($currentContent =~ m/details in:/) {
       s/.* details in: *//;
       s/trc.*:.*\z/trc/;
       $OrigFileName = $_;
       s/.*[\|\/]//;
       $errorFileNameOnly=$_;
       $CollectFileName = $traceDir."/".$errorFileNameOnly;
       $traceFileOK=1;
       if ( -f $OrigFileName && -f $CollectFileName ){
         &print_log("get_trace", "     SKIP [$OrigFileName]");
       } elsif ( -f $OrigFileName) {
         `echo '<pre style="word-wrap: break-word; white-space: pre-wrap; white-space: -moz-pre-wrap">' > ${CollectFileName}; cat ${OrigFileName} >> ${CollectFileName}`;
         if ( $? == 0 ){
           &print_log("get_trace", "COLLECTED [$OrigFileName]");
         }else{
           $traceFileOK=0;
           &print_log("WARNING", "   MISSED [$OrigFileName] with Error : $!");
         }
       } else {
         $traceFileOK=0;
         &print_log("get_trace()", "   MISSED [$OrigFileName]");
       }
       if ( $traceFileOK == 1 && exists $errorFileList[$errorIndex-1] eq ' ' ){
         $errorFileList[$errorIndex-1]="<a href='./Trace/$errorFileNameOnly.html'>$errorFileNameOnly</a>";
       } elsif ( $traceFileOK == 1 ){
         $errorFileList[$errorIndex-1]="$errorFileList[$errorIndex-1]<br><a href='./Trace/$errorFileNameOnly.html'>$errorFileNameOnly</a>";
       }
     } elsif ($currentContent =~ m/(ORA-[0-9]+)[:|\s]*(.*)/i){
       #&print_log("Pro_Debug", "Match Error Line : Code = [$1], Message = [$2]");
       $errorCode[$errorIndex]=$1;
       $errorMsg[$errorIndex]=$2;
       $errorIndex++;
     } elsif ($currentContent =~ m/(Starting\s*ORACLE\s*instance.*)/i){
       #&print_log("Pro_Debug", "Match Startup Line : Message = [$1]");
       $errorCode[$errorIndex]='<font color=blue><b>Startup</b></font>';
       $errorMsg[$errorIndex]=$1;
       $errorIndex++;
     } elsif ($currentContent =~ m/(Completed)?(\s*:\s*)?(alter\s*.*)/i){
       #&print_log("Pro_Debug", "Match Alter Command : Message = [$3]");
       $errorCode[$errorIndex]='<font color=green><b>Alter</b></font>';
       if ($1 eq 'Completed'){
         $errorMsg[$errorIndex]=$3.' (<font color=green><b>Completed</b><font>)';
       }
       else{
         $errorMsg[$errorIndex]=$3;
       }

       $errorIndex++;
     } elsif ($currentContent =~ m/(Shutting\sdown\sinstance.*)/i){
       #&print_log("Pro_Debug", "Match Shutdonw Line : Message = [$1]");
       $errorCode[$errorIndex]='<font color=red><b>Shutdown</b></font>';
       $errorMsg[$errorIndex]=$1;
       $errorIndex++;
     }
   }
   print ALERTTOHTML "</table>";
   close ALERTFILE;
   close ALERTTOHTML;
 }

 #########################################################################################################
 ##                                                                                                     ##
 ## Function get_crs_log() : Get CRS Logfiles in RAC Environment                                        ##
 ##                                                                                                     ##
 #########################################################################################################
 sub get_crs_log(){

   my $crsProcNum = `ps -ef | grep init.crs | grep -v grep | wc -l`;
   $crsProcNum = `ps -ef | grep "init.ohasd" | grep -v grep | wc -l` if ( ${crsProcNum} == 0);
   if ( ${crsProcNum} == 0){
     &print_log("get_crs_log", "No CRS Runing in the Machine");
   } else {
     $noCollect = 0;
     until (( -f $crsHome."/log/".$hostname."/alert".$hostname.".log" &&
              -f $crsHome."/log/".$hostname."/crsd/crsd.log" &&
              -f $crsHome."/log/".$hostname."/cssd/ocssd.log") || $noCollect) {
       &print_log ("get_crs_log", "ORA_CRS_HOME, CRS_HOME, GRID_HOME not set Correct , Needed input (None for Manual Collect) : ");
       print "==========[ Waiting for input ]=========> ";
       $crsHome = <STDIN>;
       chomp $crsHome;
       &print_log ("get_crs_log()", $crsHome);
       $noCollect = 1 if $crsHome eq "";
     }
     if ( $crsHome eq "" ){
       &print_log("get_crs_log", "User Select Manual Collect CRS Logfile later after the script");
     } else {
       &print_log("get_crs_log", "Collect CRS Logfiles into [$CRSDir]");
       `tail -10000 $crsHome/log/$hostname/alert$hostname.log > $CRSDir/alert$hostname.log`;
       `cp $crsHome/log/$hostname/crsd/crsd.log $CRSDir/crsd_$hostname.log`;
       `cp $crsHome/log/$hostname/cssd/ocssd.log $CRSDir/ocssd_$hostname.log`;
       `cp $crsHome/log/$hostname/evmd/evmd.log $CRSDir/evmd_$hostname.log 2>/dev/null`;
       #`cp -rp $crsHome/log/$hostname/racg $CRSDir 2>/dev/null`;
       &print_log("get_crs_log", "Collect /etc/hosts into [$CRSDir]");
       `cp /etc/hosts $CRSDir/hosts_$hostname`;
     }
   }
 }

 #########################################################################################################
 ##                                                                                                     ##
 ## Function get_osreport() : Get OS Report in HTML Format                                              ##
 ##                                                                                                     ##
 #########################################################################################################
 sub get_osreport(){

   #===========================
   # OS Report Header
   #===========================
   my $htmlHeader="<html lang=\"en\"><head><title>OS Report for ".$hostname."</title> <style type=\"text/css\">
   body.awr   {font:bold 10pt Arial,Helvetica,Geneva,sans-serif;color:black; background:White;}
   h1.awr     {font:bold 20pt Arial,Helvetica,Geneva,sans-serif;color:#336699;background-color:White;border-bottom:1px solid #cccc99;margin-top:0pt; margin-bottom:0pt;padding:0px 0px 0px 0px;}
   h2.awr     {font:bold 16pt Arial,Helvetica,Geneva,sans-serif;color:#336699;background-color:White;margin-top:4pt; margin-bottom:0pt;}
   th.awrbg   {font:bold 8pt Arial,Helvetica,Geneva,sans-serif; color:White; background:#0066CC;padding-left:4px; padding-right:4px;padding-bottom:2px}
   th.awrnc   {font:8pt Arial,Helvetica,Geneva,sans-serif;color:black;background:White;}
   th.awrc    {font:8pt Arial,Helvetica,Geneva,sans-serif;color:black;background:#FFFFCC;}
   td.awrnc   {font:8pt Arial,Helvetica,Geneva,sans-serif;color:black;background:White;vertical-align:top;}
   td.awrc    {font:8pt Arial,Helvetica,Geneva,sans-serif;color:black;background:#FFFFCC; vertical-align:top;}
   </style></head><body class=\"awr\"> <h1 class=\"awr\">
   Operation System Information Report for ".$hostname."</h1><p><h2 class=\"awr\">File System Usage</h2> <table BORDER=1 WIDTH=500>";
   open OSREPORTFILE, ">>", $OSDir."/os_report_$hostname.html";
   print OSREPORTFILE $htmlHeader."\n";

   #===========================
   # Disk Usage
   #===========================
   my @diskUsage = ();
   my $lineLength = 6;
   if ( $OSType eq "Linux" || $OSType eq "SunOS" ){
     `df -h 2>>$errorFile > $OSDir/disk_usage_$hostname.txt`;
     @diskUsage=`cat $OSDir/disk_usage_$hostname.txt`;
   } elsif ( $OSType eq "AIX" ){
     `df -m 2>>$errorFile > $OSDir/disk_usage_$hostname.txt`;
     @diskUsage=`cat $OSDir/disk_usage_$hostname.txt`;
     $lineLength = 7;
   } elsif ( $OSType eq "HP-UX" ){
     `bdf 2>>$errorFile > $OSDir/disk_usage_$hostname.txt`;
     @diskUsage=`cat $OSDir/disk_usage_$hostname.txt`;
   }
   my $diskHeaderLine = shift @diskUsage;
   chomp ($diskHeaderLine);
   $diskHeaderLine =~ s/\A\s*|\s*\z//g;
   $diskHeaderLine =~ s/Mounted on/Mounted/;
   $diskHeaderLine =~ s/MB blocks/MBblocks/;
   $diskHeaderLine =~ s|\s+|</th><th class="awrbg">|g;
   $diskHeaderLine =~ s/Mounted/Mounted on/;
   $diskHeaderLine =~ s/MBblocks/MB blocks/;
   $diskHeaderLine = '<tr><th class="awrbg">'.$diskHeaderLine."</th> </tr>";
   print OSREPORTFILE $diskHeaderLine."\n";

 #  my $lineBefore = shift @diskUsage;
   my $diskUsageContents = "@diskUsage";
   $diskUsageContents =~ s/\s+/ /g;
   @diskUsage = split(/ /, $diskUsageContents);
 #  chomp ($lineBefore);
 #  $lineBefore =~ s|\s+|</th><td class=$lineColor>|g;
   my $lineNow = 1;
   my $lineColor = "awrnc";
   foreach (@diskUsage) {
     chomp;
     if ( $lineNow == 1) {
       $lineNow ++;
       print OSREPORTFILE "<tr><td class='$lineColor'> ".$_." </td>";
     } elsif ( $lineNow == $lineLength) {
       print OSREPORTFILE "<td class='$lineColor'> ".$_." </td> </tr>";
       if ( $lineColor eq "awrnc" ) {
         $lineColor = "awrc";
       } else {
         $lineColor = "awrnc";
       }
       $lineNow = 1;
     } else {
       $lineNow ++;
       print OSREPORTFILE "<td class='$lineColor'> ".$_." </td>";
     }
   }
   print OSREPORTFILE "</table><p>";
   &print_log("get_osreport", "File System Usage have been collected !");

   #===========================
   # OS Configurations
   #===========================
   &print_log("get_osreport", "Begin Get OS Configuration for [".$OSType."]");
   print OSREPORTFILE '<h2 class="awr"> Operation System Configuration : </h2><p> ';

   if ($OSType eq "Linux") {
     # Collect System Configuration File
     `cat /proc/meminfo > $OSDir/meminfo_$hostname.txt 2>>$errorFile`;
     &print_logfile("get_osreport", "System File Collected [/proc/meminfo]");
     `cat /proc/cpuinfo > $OSDir/cpuinfo_$hostname.txt 2>>$errorFile`;
     &print_logfile("get_osreport", "System File Collected [/proc/cpuinfo]");
     `uname -a > $OSDir/uname_$hostname.txt 2>>$errorFile`;
     &print_logfile("get_osreport", "System Information Collected [uname -a]");
     `uptime > $OSDir/uptime_$hostname.txt 2>>$errorFile`;
     &print_logfile("get_osreport", "System Information Collected [uptime]");
     #`dmesg > $OSDir/dmesg_$hostname.txt 2>>$errorFile`;
     my $memTotal = `cat $OSDir/meminfo_$hostname.txt 2>>$errorFile | grep "MemTotal" | cut -c 12-`;
     $memTotal =~ s/\A\s+|\s+//g;
     &print_logfile("get_osreport", "Total Memory Size is [".$memTotal."]");
     my $swapTotal = `cat $OSDir/meminfo_$hostname.txt 2>>$errorFile | grep "SwapTotal" | cut -c 12-`;
     $swapTotal =~ s/\A\s+|\s+//g;
     &print_logfile("get_osreport", "Total Swap Size is [".$swapTotal."]");
     my $cpuCount = `cat $OSDir/cpuinfo_$hostname.txt 2>>$errorFile | grep "processor" | wc -l`;
     &print_logfile("get_osreport", "Total CPU Count is [".$cpuCount."]");
     my $cpuMHZ = `cat $OSDir/cpuinfo_$hostname.txt 2>>$errorFile | grep "cpu MHz" | head -1 | cut -c 11-`;
     $cpuMHZ =~ s/\A\s+|\s+//g;
     &print_logfile("get_osreport", "Total CPU MHZ is [".$cpuMHZ."]");
     # Generate HTML Report
     print OSREPORTFILE '<table BORDER=1 WIDTH=500> <tr> <th class="awrbg">Name</th><th class="awrbg">Value</th><th class="awrbg">Name</th><th class="awrbg">Value</th> </tr>';
     print OSREPORTFILE "<tr><td class=\"awrc\">Hostname</th><td class=\"awrnc\">$hostname</td>";
     print OSREPORTFILE "<td class=\"awrc\">OS Type</th><td class=\"awrnc\">$OSType</td>";
     print OSREPORTFILE "<tr><td class=\"awrc\">Memory Size</th><td class=\"awrnc\">$memTotal</td>";
     print OSREPORTFILE "<td class=\"awrc\">Swap Size</th><td class=\"awrnc\">$swapTotal</td>";
     print OSREPORTFILE "<tr><td class=\"awrc\">CPU Count</th><td class=\"awrnc\">$cpuCount</td>";
     print OSREPORTFILE "<td class=\"awrc\">CPU MHz</th><td class=\"awrnc\">$cpuMHZ</td> </table><p>";
   } elsif ($OSType eq "SunOS") {
     # Collect System Configuration File
     `/usr/sbin/prtconf -v >$OSDir/prtconf_v_$hostname.txt 2>>$errorFile`;
     `/usr/sbin/prtconf >$OSDir/prtconf_$hostname.txt 2>>$errorFile`;
     `dmesg >$OSDir/dmesg_$hostname.txt 2>>$errorFile`;
     my $memTotal = `cat $OSDir/prtconf_$hostname.txt | grep "Memory" | cut -d ' ' -f 3,4`;
     my @swapDevList = `/usr/sbin/swap -l | grep -vi 'swapfile'`;
     my $swapTotal = 0;
     my $currentSwap = 0;
     foreach (@swapDevList) {
       $currentSwap = `$echo $_ | cut -f 4 -d ' '`;
       $swapTotal += $currentSwap;
     }
     $SwapTotal = $SwapTotal * 512 / 1073741824;
     my $cpuCount = `cat $OSDir/prtconf_v_$hostname.txt | grep " cpu " | wc -l`;
     my $cpuMHZ = 'None';
     # Generate HTML Report
     print OSREPORTFILE '<table BORDER=1 WIDTH=500> <tr> <th class="awrbg"> Name </th><th class="awrbg"> Value</th><th class="awrbg"> Name </th><th class="awrbg"> Value</th> </tr>';
     print OSREPORTFILE "<tr><td class=\"awrc\">Hostname</th><td class=\"awrnc\">$hostname</td>";
     print OSREPORTFILE "<td class=\"awrc\">OS Type</th><td class=\"awrnc\">$OSType</td>";
     print OSREPORTFILE "<tr><td class=\"awrc\">Memory Size</th><td class=\"awrnc\">$memTotal</td>";
     print OSREPORTFILE "<td class=\"awrc\">Swap Size</th><td class=\"awrnc\">$swapTotal</td>";
     print OSREPORTFILE "<tr><td class=\"awrc\">CPU Count</th><td class=\"awrnc\">$cpuCount</td>";
     print OSREPORTFILE "<td class=\"awrc\">CPU MHz</th><td class=\"awrnc\">$cpuMHZ</td></table><p>";
   } elsif ( $OSType eq "AIX" ) {
     `prtconf >$OSDir/prtconf_$hostname.txt 2>>$errorFile`;
     `errpt > $OSDir/errpt_$hostname.txt 2>>$errorFile`;
     my $cpuCount = `cat $OSDir/prtconf_$hostname.txt | grep "Number Of Processors:"`;
     $cpuCount =~ s/.*:\s+//;
     my $cpuMHZ = `cat $OSDir/prtconf_$hostname.txt | grep "Processor Clock Speed:"`;
     $cpuMHZ =~ s/.*:\s+//;
     my $memTotal = `cat $OSDir/prtconf_$hostname.txt | grep "Memory Size"`;
     $memTotal =~ s/.*:\s+//;
     $memTotal =~ s/MB.*//;
     $memTotal = "$memTotal MB";
     my $swapTotal = `cat $OSDir/prtconf_$hostname.txt | grep "Total Paging Space"`;
     $swapTotal =~ s/.*:\s+//;
     my $firmwareVersion = `cat $OSDir/prtconf_$hostname.txt | grep "Firmware Version"`;
     $firmwareVersion =~ s/.*:\s+//;
     my $procType = `cat $OSDir/prtconf_$hostname.txt | grep "Processor Type"`;
     $procType =~ s/.*:\s+//;
     # Generate HTML Report
     print OSREPORTFILE '<table BORDER=1 WIDTH=500> <tr> <th class="awrbg"> Name </th><th class="awrbg"> Value</th><th class="awrbg"> Name </th><th class="awrbg"> Value</th> </tr>';
     print OSREPORTFILE "<tr><td class=\"awrc\">Hostname</th><td class=\"awrnc\">$hostname</td>";
     print OSREPORTFILE "<td class=\"awrc\">OS Type</th><td class=\"awrnc\">$OSType</td>";
     print OSREPORTFILE "<tr><td class=\"awrc\">Memory Size</th><td class=\"awrnc\">$memTotal</td>";
     print OSREPORTFILE "<td class=\"awrc\">Swap Size</th><td class=\"awrnc\">$swapTotal</td>";
     print OSREPORTFILE "<tr><td class=\"awrc\">CPU Count</th><td class=\"awrnc\">$cpuCount</td>";
     print OSREPORTFILE "<td class=\"awrc\">CPU MHz</th><td class=\"awrnc\">$cpuMHZ</td>";
     print OSREPORTFILE "<tr><td class=\"awrc\">Firmware Version</th><td class=\"awrnc\">$firmwareVersion</td>";
     print OSREPORTFILE "<td class=\"awrc\">Process Type</th><td class=\"awrnc\">$procType</td></table><p>";
   } elsif ( $OSType eq "HP-UX" ) {
     # Collect System Configuration File
     `machinfo >$OSDir/machinfo_$hostname.txt 2>>$errorFile`;
     my $cpuCount = `cat $OSDir/machinfo_$hostname.txt | grep "logical processors"`;
     $cpuCount =~ s/\A\s+//;
     $cpuCount =~ s/logical processors.*//;
     my $cpuMHZ = `cat $OSDir/machinfo_$hostname.txt | grep "series processors"`;
     $cpuMHZ =~ s/.*series processors\s+\(//;
     $cpuMHZ =~ s/,\s+.*//;
     my $memTotal = `cat $OSDir/machinfo_$hostname.txt | grep "Memory:"`;
     $memTotal =~ s/Memory:\s+//;
     my @swapDevList = `swapinfo -atm | grep 'dev'`;
     my $swapTotal = 0;
     foreach (@swapDevList) {
       $swapTotal += `$echo $_ | cut -f 2 -d ' '`;
     }
     my $firmwareVersion = `cat $OSDir/machinfo_$hostname.txt | grep "Firmware revision:"`;
     $firmwareVersion =~ s/.*:\s+//;
     my $osrelease = `cat $OSDir/machinfo_$hostname.txt | grep "Release:"`;
     $osrelease =~ s/.*:\s+//;
     # Generate HTML Report
     print OSREPORTFILE '<table BORDER=1 WIDTH=500> <tr> <th class="awrbg"> Name </th><th class="awrbg"> Value</th><th class="awrbg"> Name </th><th class="awrbg"> Value</th> </tr>';
     print OSREPORTFILE "<tr><td class=\"awrc\">Hostname</th><td class=\"awrnc\">$hostname</td>";
     print OSREPORTFILE "<td class=\"awrc\">OS Type</th><td class=\"awrnc\">$OSType</td>";
     print OSREPORTFILE "<tr><td class=\"awrc\">Memory Size</th><td class=\"awrnc\">$memTotal</td>";
     print OSREPORTFILE "<td class=\"awrc\">Swap Size</th><td class=\"awrnc\">$swapTotal MB</td>";
     print OSREPORTFILE "<tr><td class=\"awrc\">CPU Count</th><td class=\"awrnc\">$cpuCount</td>";
     print OSREPORTFILE "<td class=\"awrc\">CPU MHz</th><td class=\"awrnc\">$cpuMHZ</td>";
     print OSREPORTFILE "<tr><td class=\"awrc\">Firmware Version</th><td class=\"awrnc\">$firmwareVersion</td>";
     print OSREPORTFILE "<td class=\"awrc\">OS Release</th><td class=\"awrnc\">$osrelease</td></table><p>";
   } else {
     &print_log("get_osreport", "OS Configuration cannot collected !");
   }
   &print_log("get_osreport", "OS Configuration have been collected !");

   #===========================
   # /etc/hosts
   #===========================
   open OSHOSTS, "<", "/etc/hosts";
   `cat /etc/hosts > $OSDir/hosts_$hostname.txt`;
   print OSREPORTFILE "<h2 class=\"awr\">OS Naming Resolution</h2> <table BORDER=1 WIDTH=500> <tr> <th class='awrbg'>IP Address</th><th class='awrbg'>Hostnames</th></tr>\n";
   $lineColor = "awrnc";
   my $blankPos = 0;
   my $ipAddr = "";
   my $hostnames = "";
   while (<OSHOSTS>) {
     chomp;
     next if (m/(\A#)|(\A\s*\z)/);
     s/\A\s+//g;
     s/\s+/ /g;
     $blankPos = index($_, ' ');
     $ipAddr = substr($_, 0, $blankPos);
     $hostnames = substr($_, 1+$blankPos);
     print OSREPORTFILE "<tr> <td class='$lineColor'> ".$ipAddr." </td><td class='$lineColor'> ".$hostnames." </td> </tr>";
     if ( $lineColor eq "awrnc" ) {
       $lineColor = "awrc";
     } else {
       $lineColor = "awrnc";
     }
   }
   close OSHOSTS;
   print OSREPORTFILE "</table><p>";
   &print_log("get_osreport", "/etc/hosts have been collected !");

   #===========================
   # User and Groups
   #===========================
   open OSUSERS, "<", "/etc/passwd";
   `cat /etc/passwd > $OSDir/passwd_$hostname.txt`;
   print OSREPORTFILE "<h2 class=\"awr\">OS Users</h2> <table BORDER=1 WIDTH=800> <tr> <th class='awrbg'>Login Name</th><th class='awrbg'>Password</th>";
   print OSREPORTFILE "<th class='awrbg'>User ID</th><th class='awrbg'>Group ID<th class='awrbg'>Username</th><th class='awrbg'>Home</th><th class='awrbg'>Shell</th></tr>\n";
   $lineColor = "awrnc";
   while (<OSUSERS>) {
     s|:|</td><td class=$lineColor>|g;
     print OSREPORTFILE "<tr><td class='$lineColor'> ".$_." </td> </tr>";
     if ( $lineColor eq "awrnc" ) {
       $lineColor = "awrc";
     } else {
       $lineColor = "awrnc";
     }
   }
   close OSUSERS;
   print OSREPORTFILE "</table><p>";
   &print_log("get_osreport", "OS User Info have been collected !");

   open OSGROUPS, "<", "/etc/group";
   `cat /etc/group > $OSDir/group_$hostname.txt`;
   print OSREPORTFILE "<h2 class=\"awr\">OS Groups</h2> <table BORDER=1 WIDTH=500><tr><th class='awrbg'>Group Name</th><th class='awrbg'>Password</th><th class='awrbg'>Group ID</th><th class='awrbg'>User List</th></tr>\n";
   $lineColor = "awrnc";
   while (<OSGROUPS>) {
     s|:|</td><td class=$lineColor>|g;
     print OSREPORTFILE "<tr><td class='$lineColor'> ".$_." </td> </tr>";
     if ( $lineColor eq "awrnc" ) {
       $lineColor = "awrc";
     } else {
       $lineColor = "awrnc";
     }
   }
   close OSGROUPS;
   print OSREPORTFILE "</table><p>";
   &print_log("get_osreport", "OS Group Info have been collected !");

   #===========================
   # Linux Kernel Settings
   #===========================
   if ($OSType eq "Linux") {
     if ( -r '/etc/sysctl.conf' ){
       `cat /etc/sysctl.conf >$OSDir/sysctl_$hostname.txt`;
     } else{
       `sysctl -a >$OSDir/sysctl_$hostname.txt 2>>$errorFile`;
     }
     open OSKERNELSETTINGS, "<", "$OSDir/sysctl_$hostname.txt";
     print OSREPORTFILE "<h2 class=\"awr\">OS Kernel Settings for Linux</h2> <table BORDER=1 WIDTH=500><tr><th class='awrbg'>Name</th><th class='awrbg'>Value</th></tr>\n";
     my $lineColor = "awrnc";
     while (<OSKERNELSETTINGS>) {
       if ( ! ($_ =~ m/(\A\s*#+)|(\A\s*\z)/) ){
         s|=|</td><td class=$lineColor>|g;
         print OSREPORTFILE "<tr><td class='$lineColor'> ".$_." </td> </tr>";
         if ( $lineColor eq "awrnc" ) {
           $lineColor = "awrc";
         } else {
           $lineColor = "awrnc";
         }
       }
     }
     close OSKERNELSETTINGS;
     print OSREPORTFILE "</table><p>";
     &print_log("get_osreport", "OS Kernel Settings have been collected !");
   }

   #===========================
   # Linux Package Install Info
   #===========================
   if ($OSType eq "Linux") {
     my $versionWarning = '';
     foreach (`ls /etc | grep -i release`){
       chomp;
       `cp /etc/$_ $OSDir/${hostname}_$_ 2>>$errorFile` if (-f "/etc/$_");
     }
     my @pkgForLinux=('10g SUSE9 binutils', '10g SUSE9 gcc', '10g SUSE9 gcc-c++', '10g SUSE9 glibc', '10g SUSE9 gnome-libs', '10g SUSE9 libstdc++', '10g SUSE9 libstdc++-devel', '10g SUSE9 make', '10g SUSE9 pdksh', '10g SUSE9 sysstat', '10g SUSE9 xscreensaver'
       , '10g RHEL4 binutils', '10g RHEL4 compat-db', '10g RHEL4 control-center', '10g RHEL4 gcc', '10g RHEL4 gcc-c++', '10g RHEL4 glibc', '10g RHEL4 glibc-common', '10g RHEL4 gnome-libs', '10g RHEL4 libstdc++', '10g RHEL4 libstdc++-devel', '10g RHEL4 make', '10g RHEL4 pdksh', '10g RHEL4 sysstat', '10g RHEL4 xscreensaver'
       , '10g RHEL3 make', '10g RHEL3 compat-db', '10g RHEL3 control-center', '10g RHEL3 gcc', '10g RHEL3 gcc-c++', '10g RHEL3 gdb', '10g RHEL3 glibc', '10g RHEL3 glibc-common', '10g RHEL3 glibc-devel', '10g RHEL3 compat-db', '10g RHEL3 compat-gcc', '10g RHEL3 compat-gcc-c++', '10g RHEL3 compat-libstdc++', '10g RHEL3 compat-libstdc++-devel', '10g RHEL3 gnome-libs', '10g RHEL3 libstdc++', '10g RHEL3 libstdc++-devel', '10g RHEL3 openmotif', '10g RHEL3 sysstat', '10g RHEL3 setarch', '10g RHEL3 libaio', '10g RHEL3 libaio-devel'
       , '11g RHEL4 binutils', '11g RHEL4 compat-libstdc++-33', '11g RHEL4 elfutils-libelf', '11g RHEL4 elfutils-libelf-devel', '11g RHEL4 expat', '11g RHEL4 gcc', '11g RHEL4 gcc-c++', '11g RHEL4 glibc', '11g RHEL4 glibc-common', '11g RHEL4 glibc-devel', '11g RHEL4 glibc-headers', '11g RHEL4 libaio', '11g RHEL4 libaio-devel', '11g RHEL4 libgcc', '11g RHEL4 libstdc++', '11g RHEL4 libstdc++-devel', '11g RHEL4 make', '11g RHEL4 numactl', '11g RHEL4 pdksh', '11g RHEL4 sysstat'
       , '11g RHEL5 binutils', '11g RHEL5 compat-libstdc++-33', '11g RHEL5 elfutils-libelf', '11g RHEL5 elfutils-libelf-devel', '11g RHEL5 gcc', '11g RHEL5 gcc-c++', '11g RHEL5 glibc', '11g RHEL5 glibc-common', '11g RHEL5 glibc-devel', '11g RHEL5 glibc-headers', '11g RHEL5 ksh', '11g RHEL5 libaio', '11g RHEL5 libaio-devel', '11g RHEL5 libgcc', '11g RHEL5 libstdc++', '11g RHEL5 libstdc++-devel', '11g RHEL5 make', '11g RHEL5 sysstat'
       , '11g SUSE10 binutils', '11g SUSE10 compat-libstdc++', '11g SUSE10 gcc', '11g SUSE10 gcc-c++', '11g SUSE10 glibc', '11g SUSE10 glibc-devel', '11g SUSE10 glibc-devel-32bit', '11g SUSE10 ksh-93r', '11g SUSE10 libaio', '11g SUSE10 libaio-32bit', '11g SUSE10 libaio-devel', '11g SUSE10 libaio-devel-32bit', '11g SUSE10 libelf', '11g SUSE10 libgcc', '11g SUSE10 libstdc++', '11g SUSE10 libstdc++-devel', '11g SUSE10 make', '11g SUSE10 numactl', '11g SUSE10 sysstat'
       , '11g SUSE11 binutils', '11g SUSE11 gcc', '11g SUSE11 gcc-32bit', '11g SUSE11 gcc-c++', '11g SUSE11 glibc', '11g SUSE11 glibc-32bit', '11g SUSE11 glibc-devel', '11g SUSE11 glibc-devel-32bit', '11g SUSE11 ksh-93t', '11g SUSE11 libaio', '11g SUSE11 libaio-32bit', '11g SUSE11 libaio-devel', '11g SUSE11 libaio-devel-32bit', '11g SUSE11 libstdc++33', '11g SUSE11 libstdc++33-32bit', '11g SUSE11 libstdc++43', '11g SUSE11 libstdc++43-32bit', '11g SUSE11 libstdc++43-devel', '11g SUSE11 libstdc++43-devel-32bit', '11g SUSE11 libgcc43', '11g SUSE11 libstdc++-devel', '11g SUSE11 make', '11g SUSE11 sysstat');
     my $preOSTypeforPkg='SUSE9';

     my $releaseVersion = `cat $OSDir/*release* | grep -i "red hat" | grep " 5."`;
     chomp;
     if ( "$releaseVersion" ne "" ){
       @pkgForLinux = ('10g RHEL4 binutils', '10g RHEL4 compat-db', '10g RHEL4 control-center', '10g RHEL4 gcc', '10g RHEL4 gcc-c++', '10g RHEL4 glibc', '10g RHEL4 glibc-common', '10g RHEL4 gnome-libs', '10g RHEL4 libstdc++', '10g RHEL4 libstdc++-devel', '10g RHEL4 make', '10g RHEL4 pdksh', '10g RHEL4 sysstat', '10g RHEL4 xscreensaver', '11g RHEL5 binutils', '11g RHEL5 compat-libstdc++-33', '11g RHEL5 elfutils-libelf', '11g RHEL5 elfutils-libelf-devel', '11g RHEL5 gcc', '11g RHEL5 gcc-c++', '11g RHEL5 glibc', '11g RHEL5 glibc-common', '11g RHEL5 glibc-devel', '11g RHEL5 glibc-headers', '11g RHEL5 ksh', '11g RHEL5 libaio', '11g RHEL5 libaio-devel', '11g RHEL5 libgcc', '11g RHEL5 libstdc++', '11g RHEL5 libstdc++-devel', '11g RHEL5 make', '11g RHEL5 sysstat');
       $versionWarning = "Redhat 5 is only Authenticated with Oracle Database 11g<br>Current DB Version is : $dbVersion" if ($dbVersion != 11);
       $preOSTypeforPkg='RHEL5';
     } else{
       $releaseVersion = `cat $OSDir/*release* | grep -i "red hat" | grep " 4."`;
       chomp;
       if ( "$releaseVersion" ne "" && $dbVersion == 11 ){
         @pkgForLinux = ('11g RHEL4 binutils', '11g RHEL4 compat-libstdc++-33', '11g RHEL4 elfutils-libelf', '11g RHEL4 elfutils-libelf-devel', '11g RHEL4 expat', '11g RHEL4 gcc', '11g RHEL4 gcc-c++', '11g RHEL4 glibc', '11g RHEL4 glibc-common', '11g RHEL4 glibc-devel', '11g RHEL4 glibc-headers', '11g RHEL4 libaio', '11g RHEL4 libaio-devel', '11g RHEL4 libgcc', '11g RHEL4 libstdc++', '11g RHEL4 libstdc++-devel', '11g RHEL4 make', '11g RHEL4 numactl', '11g RHEL4 pdksh', '11g RHEL4 sysstat');
         $preOSTypeforPkg='RHEL4';
       } elsif ( "$releaseVersion" ne "" && $dbVersion == 10 ){
         @pkgForLinux = ('10g RHEL4 binutils', '10g RHEL4 compat-db', '10g RHEL4 control-center', '10g RHEL4 gcc', '10g RHEL4 gcc-c++', '10g RHEL4 glibc', '10g RHEL4 glibc-common', '10g RHEL4 gnome-libs', '10g RHEL4 libstdc++', '10g RHEL4 libstdc++-devel', '10g RHEL4 make', '10g RHEL4 pdksh', '10g RHEL4 sysstat', '10g RHEL4 xscreensaver');
         $preOSTypeforPkg='RHEL4';
       } elsif ("$releaseVersion" ne ""){
         $versionWarning = "Redhat 4 is only Authenticated with Oracle Database 10g and 11g<br>Current DB Version is : $dbVersion";
       } else{
         $releaseVersion = `cat $OSDir/*release* | grep -i "red hat" | grep " 3."`;
         chomp;
         if ( "$releaseVersion" ne "" ){
           @pkgForLinux = ('10g RHEL3 make', '10g RHEL3 compat-db', '10g RHEL3 control-center', '10g RHEL3 gcc', '10g RHEL3 gcc-c++', '10g RHEL3 gdb', '10g RHEL3 glibc', '10g RHEL3 glibc-common', '10g RHEL3 glibc-devel', '10g RHEL3 compat-db', '10g RHEL3 compat-gcc', '10g RHEL3 compat-gcc-c++', '10g RHEL3 compat-libstdc++', '10g RHEL3 compat-libstdc++-devel', '10g RHEL3 gnome-libs', '10g RHEL3 libstdc++', '10g RHEL3 libstdc++-devel', '10g RHEL3 openmotif', '10g RHEL3 sysstat', '10g RHEL3 setarch', '10g RHEL3 libaio', '10g RHEL3 libaio-devel', '11g RHEL4 binutils', '11g RHEL4 compat-libstdc++-33', '11g RHEL4 elfutils-libelf', '11g RHEL4 elfutils-libelf-devel', '11g RHEL4 expat', '11g RHEL4 gcc', '11g RHEL4 gcc-c++', '11g RHEL4 glibc', '11g RHEL4 glibc-common', '11g RHEL4 glibc-devel', '11g RHEL4 glibc-headers', '11g RHEL4 libaio', '11g RHEL4 libaio-devel', '11g RHEL4 libgcc', '11g RHEL4 libstdc++', '11g RHEL4 libstdc++-devel', '11g RHEL4 make', '11g RHEL4 numactl', '11g RHEL4 pdksh', '11g RHEL4 sysstat');
           $versionWarning = "Redhat 3 is only Authenticated with Oracle Database 10g<br>Current DB Version is : $dbVersion" if ($dbVersion != 10);
           $preOSTypeforPkg='RHEL3';
         } else {
           $releaseVersion = `cat $OSDir/*release* | grep -i "suse" | grep " 9"`;
           chomp;
           if ( "$releaseVersion" ne "" ){
             @pkgForLinux = ('10g SUSE9 binutils', '10g SUSE9 gcc', '10g SUSE9 gcc-c++', '10g SUSE9 glibc', '10g SUSE9 gnome-libs', '10g SUSE9 libstdc++', '10g SUSE9 libstdc++-devel', '10g SUSE9 make', '10g SUSE9 pdksh', '10g SUSE9 sysstat', '10g SUSE9 xscreensaver');
             $versionWarning = "SUSE 9 is only Authenticated with Oracle Database 10g<br>Current DB Version is : $dbVersion" if ($dbVersion != 10);
           } else {
             $releaseVersion = `cat $OSDir/*release* | grep -i "suse" | grep " 10"`;
             chomp;
             if ( "$releaseVersion" ne "" ){
               @pkgForLinux = ('11g SUSE10 binutils', '11g SUSE10 compat-libstdc++', '11g SUSE10 gcc', '11g SUSE10 gcc-c++', '11g SUSE10 glibc', '11g SUSE10 glibc-devel', '11g SUSE10 glibc-devel-32bit', '11g SUSE10 ksh-93r', '11g SUSE10 libaio', '11g SUSE10 libaio-32bit', '11g SUSE10 libaio-devel', '11g SUSE10 libaio-devel-32bit', '11g SUSE10 libelf', '11g SUSE10 libgcc', '11g SUSE10 libstdc++', '11g SUSE10 libstdc++-devel', '11g SUSE10 make', '11g SUSE10 numactl', '11g SUSE10 sysstat');
               $versionWarning = "SUSE 10 is only Authenticated with Oracle Database 11g<br>Current DB Version is : $dbVersion" if ($dbVersion != 11);
               $preOSTypeforPkg='SUSE10';
             } else {
               $releaseVersion = `cat $OSDir/*release* | grep -i "suse" | grep " 11"`;
               chomp;
               if ( "$releaseVersion" ne "" ){
                 @pkgForLinux = ('11g SUSE11 binutils', '11g SUSE11 gcc', '11g SUSE11 gcc-32bit', '11g SUSE11 gcc-c++', '11g SUSE11 glibc', '11g SUSE11 glibc-32bit', '11g SUSE11 glibc-devel', '11g SUSE11 glibc-devel-32bit', '11g SUSE11 ksh-93t', '11g SUSE11 libaio', '11g SUSE11 libaio-32bit', '11g SUSE11 libaio-devel', '11g SUSE11 libaio-devel-32bit', '11g SUSE11 libstdc++33', '11g SUSE11 libstdc++33-32bit', '11g SUSE11 libstdc++43', '11g SUSE11 libstdc++43-32bit', '11g SUSE11 libstdc++43-devel', '11g SUSE11 libstdc++43-devel-32bit', '11g SUSE11 libgcc43', '11g SUSE11 libstdc++-devel', '11g SUSE11 make', '11g SUSE11 sysstat');
                 $versionWarning = "SUSE 11 is only Authenticated with Oracle Database 11g<br>Current DB Version is : $dbVersion" if ($dbVersion != 11);
                 $preOSTypeforPkg='SUSE11';
               }
             }
           }
         }
       }
     }

     print OSREPORTFILE "<h2 class=\"awr\">OS Required Packages for Linux</h2> <table BORDER=1 WIDTH=500><tr><th class='awrbg'>DB Version</th><th class='awrbg'>Server</th><th class='awrbg'>Package</th><th class='awrbg'>Installed ?</th></tr> <br>$versionWarning\n";
     my $lineColor = "awrnc";
     my $pkgInstallInfo='';
     my @pkgInfo = '';
     foreach (@pkgForLinux) {
       @pkgInfo = split(/ /, $_);
 #     print "@pkgInfo \n";
       if ( $preOSTypeforPkg ne $pkgInfo[1] ){
         print OSREPORTFILE "<tr><td class='$lineColor'>###############</td><td class='$lineColor'>###############</td><td class='$lineColor'>##############################</td><td class='$lineColor'>###############</td> </tr>";
       }
       $preOSTypeforPkg = $pkgInfo[1];
       $pkgInstalled = `rpm -q $pkgInfo[2]`;
       if ( $pkgInstalled =~ /not installed/){
         $pkgInstallInfo = 'Not Installed';
         print OSREPORTFILE "<tr><td class='$lineColor'> <font color=red><b>".$pkgInfo[0]."</b></font> </td><td class='$lineColor'> <font color=red><b>".$pkgInfo[1]."</b></font> </td><td class='$lineColor'> <font color=red><b>".$pkgInfo[2]."</b></font> </td><td class='$lineColor'> <font color=red><b>".$pkgInstallInfo."</b></font> </td> </tr>";
       } else{
         $pkgInstallInfo = 'Installed';
         print OSREPORTFILE "<tr><td class='$lineColor'> ".$pkgInfo[0]." </td><td class='$lineColor'> ".$pkgInfo[1]." </td><td class='$lineColor'> ".$pkgInfo[2]." </td><td class='$lineColor'> ".$pkgInstallInfo." </td> </tr>";
       }
       if ( $lineColor eq "awrnc" ) {
         $lineColor = "awrc";
       } else {
         $lineColor = "awrnc";
       }
     }
   }
   &print_log("get_osreport", "OS Report Completed written in [".$OSDir."/os_report.html]");
   close OSREPORTFILE;
 }

 #########################################################################################################
 ##                                                                                                     ##
 ## Function get_listener()        : Get Listener Related File                                          ##
 ##                                                                                                     ##
 #########################################################################################################
 sub get_listener(){

   my @listenerTemp = `ps -ef | grep tnslsnr | grep -v grep`;
   my $listenerNo = 1;

   foreach ( @listenerTemp ){
     # Get Listener Name
     chomp;
     my $listenerName = $_;
     my $listenerProgram = $listenerName;
     $listenerName =~ s/.*tnslsnr //;
     $listenerName =~ s/\s-inherit//;
     &print_log("get_listener", "Get Listener Name is [$listenerName], Sequence is [$listenerNo]");

     # Get Listener Program
     $listenerProgram =~ s#.* /#/#;
     $listenerProgram =~ s/tnslsnr.*//;
     chomp $listenerProgram;
     $listenerProgram = $listenerProgram."lsnrctl";
     &print_log("get_listener", "Get Listener Program is : $listenerProgram");

     # Get Listener Log and Status
     my $listenerLog = `$listenerProgram status $listenerName 2>$errorFile | grep "Listener Log File"`;
     $listenerLog =~ s#.* /#/#;
     `$listenerProgram status $listenerName > $listenerDir/${listenerNo}_${listenerName}_status_$hostname.txt 2>$errorFile`;

     # Convert Listener Log, from XML to LOG
     my $listenerLogType = $listenerLog;
     $listenerLogType =~ s/.*\.//;
     chomp $listenerLogType;
     &print_log("get_listener", "Get Listener Log Type is [$listenerLogType]");
     if ( $listenerLogType eq 'xml' ){
       &print_log("get_listener", "XML logfile convert to Log logfile");
       $listenerLog =~ s/alert.*//;
       chomp $listenerLog;
       $listenerLog = $listenerLog.'trace/'.lc($listenerName).'.log';
     } else {
       chomp $listenerLog;
     }
     &print_log("get_listener", "Get Listener Log is : $listenerLog");
     my $listenerNameLC = lc($listenerName);
     $listenerNameLC =~ s/(\A\s+)|(\s+\Z)//g;
     if ( -T "$listenerLog" ){
       `tail -$maxListenerLines $listenerLog > $listenerDir/${listenerNo}_${listenerNameLC}_$hostname.log`;
     } else {
       &print_log("get_listener", "Input Correct Logfile (None for Skip) : ");
       print "==========[ Waiting for input ]=========> ";
       $listenerLog = <STDIN>;
       chomp $listenerLog;
       &print_log("get_listener", "Input Correct Logfile (None for Skip) : $listenerLog");
       if ( -T "$listenerLog" ){
         print "tail -$maxListenerLines $listenerLog > $listenerDir/${listenerNo}_${listenerNameLC}_$hostname.log\n";
         `tail -$maxListenerLines $listenerLog > $listenerDir/${listenerNo}_${listenerNameLC_}$hostname.log`;
       } else {
         &print_log("get_listener", "Listener Logfile for [$listenerName] is not collect");
       }
     }

     # Get tnsnames.ora, listener.ora and sqlnet.ora
     my $listenerParamLoc = '';
     if ( ! $tnsAdmin ){
       &print_log("get_listener", "TNS_ADMIN environment is not set");
       $listenerProgram =~ s/bin.*//;
       $listenerParamLoc = $listenerProgram.'network/admin';
     } else {
       &print_log("get_listener", "TNS_ADMIN set to [$tnsAdmin]");
       $listenerParamLoc = $tnsAdmin.'/network/admin';
     }
     if ( -T "$listenerParamLoc/tnsnames.ora" ){
       `cp $listenerParamLoc/tnsnames.ora $listenerDir/${listenerNo}_tnsnames_$hostname.ora`;
       &print_log("get_listener", "Listener Parameter tnsnames.ora Collect");
     } else {
       &print_log("get_listener", "Listener Parameter tnsnames.ora Does not exist or not a text file");
     }
     if ( -T "$listenerParamLoc/listener.ora" ){
       `cp $listenerParamLoc/listener.ora $listenerDir/${listenerNo}_listener_$hostname.ora`;
       &print_log("get_listener", "Listener Parameter listener.ora Collect");
     } else {
       &print_log("get_listener", "Listener Parameter listener.ora Does not exist or not a text file");
     }
     if ( -T "$listenerParamLoc/sqlnet.ora" ){
       `cp $listenerParamLoc/sqlnet.ora $listenerDir/${listenerNo}_sqlnet_$hostname.ora`;
       &print_log("get_listener", "Listener Parameter sqlnet.ora Collect");
     } else {
       &print_log("get_listener", "Listener Parameter sqlnet.ora Does not exist or not a text file");
     }
     $listenerNo += 1;
  }
 }


 #########################################################################################################
 ##                                                                                                     ##
 ## Main Function                                                                                       ##
 ##                                                                                                     ##
 #########################################################################################################

 &get_dbalert  if ( $commandCode =~ m/\A1/ );
 &get_asmalert if ( $commandCode =~ m/\A[1|0]1/ );
 &get_crs_log  if ( $commandCode =~ m/\A[1|0][1|0]1/ );
 &get_osreport if ( $commandCode =~ m/\A[1|0][1|0][1|0]1/ );
 &get_listener if ( $commandCode =~ m/\A[1|0][1|0][1|0][1|0]1/ );

 ## Collect OPatch Information and Check is correct collected
 `$setEnvCommand; nohup $oracleHome/OPatch/opatch lsinventory -all 1> $CRSDir/opatch_$hostname.txt 2>$errorFile &`;
 my $opatchProcLine = `ps -ef | grep 'opatch lsinventory -all' | grep -v grep`;
 chomp($opatchProcLine);
 my $opatchProcID = 0;
 my $checkStepSize = 1;
 my $allStepsGoing = 0;
 until($opatchProcLine eq ""){
   sleep $checkStepSize;
   $allStepsGoing += $checkStepSize;
   $checkStepSize += 1;
   if ($allStepsGoing >= 10){
     $opatchProcID = `echo $opatchProcLine | cut -d ' ' -f 2`;
     chomp($opatchProcID);
     #print "Line is : [$opatchProcLine]\nProc Id : [$opatchProcID]\n";
     &print_log("Main Function", "OPatch Collection didn't Returned for [$allStepsGoing] seconds, Kill Command is [kill -9 $opatchProcID]");
   }
   $opatchProcLine = `ps -ef | grep 'opatch lsinventory -all' | grep -v grep`;
   chomp($opatchProcLine);
 }
 my $opatchError = `cat $CRSDir/opatch_$hostname.txt | grep -i error | wc -l`;
 my $opatchWarning = `cat $CRSDir/opatch_$hostname.txt | grep -i warning | wc -l`;
 if ( $opatchError == 0 && $opatchWarning == 0 ){
   &print_log("Main Function", "OPatch Information collected !");
 } elsif( $opatchWarning == 0 ){
   &print_log("Main Function", "OPatch Information collected With Error, See: $CRSDir/opatch_$hostname.txt");
 } else {
   &print_log("Main Function", "OPatch Information collected With Warnning, See: $CRSDir/opatch_$hostname.txt");
 }

 # Close Logfile
 close LOGFILE;
ENDOFOSPERL
  print_log "[make_os_scripts]" "" "End Create OS Collection Script"
}

#########################################################################################################
##                                                                                                     ##
## Function make_snap_scripts(): Create getOSData Scripts for OS Related Data Collection               ##
##                                                                                                     ##
#########################################################################################################
make_snap_scripts(){

  print_log "[make_snap_scripts]" "" "Begin Create Snapshot Script into [${__SCRIPT_DIR}]"

  if [ "${1}" != "9" ] && [ "${1}" != "10" ]; then
    print_log "[make_snap_scripts]" "2" "Cannot Identify Snapshot Version with \$1 = [${1}]"
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  else
    __SNAP_SCRIPT="${__SNAP_SCRIPT}${1}_${__SNAPSHOT_TYPE}.sql"
    SNAPSHOT_VER=${1}
  fi
  print_log "[make_snap_scripts]" "" "Snapshot Script Created with Version = [${SNAPSHOT_VER}] and Type = [${__SNAPSHOT_TYPE}]"

  cat > ${__SNAP_SCRIPT} <<EOFSCRIPT
 prompt +--------------------------------------------------------------------------------+
 prompt |                       EnmoTech Health Check Report v${SNAPSHOT_VER}                          |
 prompt |--------------------------------------------------------------------------------+
 prompt | Copyright (c) 2012-2012 Hongye DBA. All rights reserved. (www.enmotech.com)    |
 prompt +--------------------------------------------------------------------------------+
 prompt
 prompt Creating database report.
 prompt This script must be run as sys or user with DBA role.
 prompt This process may take several minutes to complete.

 set ti off timi off autot off termout off echo off feedback off heading off verify off wrap on trimspool on serveroutput on escape on pagesize 50000 linesize 175 long 2000000000
 clear buffer computes columns breaks
 -- +----------------------------------------------------------------------------+
 -- |                   GATHER DATABASE REPORT INFORMATION                       |
 -- +----------------------------------------------------------------------------+
 COLUMN tdate NEW_VALUE _date NOPRINT
 COLUMN time NEW_VALUE _time NOPRINT
 COLUMN date_time NEW_VALUE _date_time NOPRINT
 COLUMN date_time_timezone NEW_VALUE _date_time_timezone NOPRINT
 COLUMN spool_time NEW_VALUE _spool_time NOPRINT
 COLUMN reportRunUser NEW_VALUE _reportRunUser NOPRINT
 SELECT TO_CHAR(SYSDATE,'yyyy-mm-dd') tdate
      , TO_CHAR(SYSDATE,'HH24:MI:SS') time
      , TO_CHAR(SYSDATE,'yyyy-mm-dd HH24:MI:SS') date_time
      , TO_CHAR(systimestamp, 'Mon DD, YYYY (') || TRIM(TO_CHAR(systimestamp, 'Day')) || TO_CHAR(systimestamp, ') "at" HH:MI:SS AM') || TO_CHAR(systimestamp, ' "in Timezone" TZR') date_time_timezone
      , TO_CHAR(SYSDATE,'YYYYMMDD') spool_time
      , user reportRunUser FROM dual;

 COLUMN dbname NEW_VALUE _dbname NOPRINT
 COLUMN dbid NEW_VALUE _dbid NOPRINT
 COLUMN platform_id NEW_VALUE _platform_id NOPRINT
 COLUMN platform_name NEW_VALUE _platform_name NOPRINT
EOFSCRIPT


 if [ "${SNAPSHOT_VER}" = "9" ]; then
   echo "SELECT name dbname, dbid,'N/A' platform_id,'N/A' platform_name FROM v\$database;" >> ${__SNAP_SCRIPT}
 else
   echo "SELECT name dbname, dbid, platform_id, platform_name FROM v\$database;" >> ${__SNAP_SCRIPT}
 fi

 cat >> ${__SNAP_SCRIPT} <<EOFSCRIPT
 COLUMN global_name NEW_VALUE _global_name NOPRINT
 SELECT global_name global_name FROM global_name;

 COLUMN blocksize NEW_VALUE _blocksize NOPRINT
 SELECT value blocksize FROM v\$parameter WHERE name='db_block_size';

 COLUMN startup_time NEW_VALUE _startup_time NOPRINT
 COLUMN host_name NEW_VALUE _host_name NOPRINT
 COLUMN instance_name NEW_VALUE _instance_name NOPRINT
 COLUMN instance_number NEW_VALUE _instance_number NOPRINT
 COLUMN thread_number NEW_VALUE _thread_number NOPRINT
 SELECT TO_CHAR(startup_time, 'yyyy-mm-dd HH24:MI:SS') startup_time, host_name, instance_name, instance_number, thread# thread_number FROM v\$instance;

 COLUMN cluster_database NEW_VALUE _cluster_database NOPRINT
 SELECT value cluster_database FROM v\$parameter WHERE name='cluster_database';

 COLUMN cluster_database_instances NEW_VALUE _cluster_database_instances NOPRINT
 SELECT value cluster_database_instances FROM v\$parameter WHERE name='cluster_database_instances';

 COLUMN buffer_cache_hit_ratio NEW_VALUE _buffer_cache_hit_ratio NOPRINT
 SELECT to_char(100*(1-(phy.value/(cur.value+con.value))),90.99) buffer_cache_hit_ratio
 FROM   v\$sysstat cur,v\$sysstat con,v\$sysstat phy
 WHERE  cur.name = 'db block gets'AND con.name = 'consistent gets'AND phy.name = 'physical reads';

 COLUMN timed_statistics NEW_VALUE _timed_statistics NOPRINT
 SELECT value timed_statistics FROM v\$parameter WHERE name='timed_statistics';

 -- +----------------------------------------------------------------------------+
 -- |                   GATHER DATABASE REPORT INFORMATION                       |
 -- +----------------------------------------------------------------------------+
 set heading on markup html on spool on preformat off entmap on -
 head '<title>Database Report</title><style type="text/css"> -
    body              {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
    p                 {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
    table,tr,td       {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#FFFFCC; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;} -
    th                {font:bold 10pt Arial,Helvetica,sans-serif; color:White; background:#0066cc; padding:0px 0px 0px 0px;} -
    h1                {font:bold 12pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:#0066cc; border-bottom:1px solid #cccc99; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;} -
    h2                {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; margin-top:4pt; margin-bottom:0pt;} -
    a                 {font:10pt Arial,Helvetica,sans-serif; color:#663300; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.link            {font:10pt Arial,Helvetica,sans-serif; color:#663300; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLink          {font:10pt Arial,Helvetica,sans-serif; color:#663300; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLinkBlue      {font:10pt Arial,Helvetica,sans-serif; color:#0000ff; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLinkDarkBlue  {font:10pt Arial,Helvetica,sans-serif; color:#000099; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLinkRed       {font:10pt Arial,Helvetica,sans-serif; color:#ff0000; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLinkDarkRed   {font:10pt Arial,Helvetica,sans-serif; color:#990000; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLinkGreen     {font:10pt Arial,Helvetica,sans-serif; color:#00ff00; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLinkDarkGreen {font:10pt Arial,Helvetica,sans-serif; color:#009900; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
  </style>' -
 body   'BGCOLOR="#C0C0C0"' -
 table  'WIDTH="90%" BORDER="1"'
EOFSCRIPT

  if [ "${__SNAPSHOT_TYPE}" = "B" ] || [ "${__SNAPSHOT_TYPE}" = "A" ]; then
    cat >> ${__SNAP_SCRIPT} <<EOFSCRIPT
 define reportHeader="<font size=+3 color=darkgreen><b>EnmoTech Health Check Report v10 (Basic Edition)</b></font><hr>Copyright (c) 2012-2012 Hongye DBA. All rights reserved. (<a target=""_blank"" href=""http://www.enmotech.com"">www.enmotech.com</a>)<p>"
 define fileName=enmotech_report_v${SNAPSHOT_VER}
 define versionType=Basic
 spool &FileName._&_spool_time._&versionType..html
 set markup html on entmap off
 prompt <a name=top></a> &reportHeader

 -- +----------------------------------------------------------------------------+
 -- |                             - REPORT INDEX -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="report_index"></a> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Report Index</b></font><hr align="center" width="250"></center><table width="90%" border="1"> -
 <tr><th colspan="4">Database and Instance Information</th></tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#report_header">Report Header</a></td> <td nowrap align="center" width="25%"><a class="link" href="#version">Version</a></td> <td nowrap align="center" width="25%"><a class="link" href="#initialization_parameters">Initialization Parameters</a></td> <td nowrap align="center" width="25%"><a class="link" href="#nls_parameters">NLS Parameters</a></td> </tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#control_files">Control Files</a></td> <td nowrap align="center" width="25%"><a class="link" href="#database_instance_overview">Database Instance Overview</a></td> <td nowrap align="center" width="25%"><a class="link" href="#redo_logs">Redo Logs</a></td> <td nowrap align="center" width="25%"><a class="link" href="#scn_report">SCN Report</a></td> </tr> <tr><th colspan="4">Storage</th></tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#tablespaces">Tablespaces</a></td> <td nowrap align="center" width="25%"><a class="link" href="#data_files">Data Files</a></td> <td nowrap align="center" width="25%"><a class="link" href="#tablespace_to_owner">Tablespace to Owner</a></td>
EOFSCRIPT

    if [ "${SNAPSHOT_VER}" = "9" ]; then
      echo 'prompt <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> </tr> <tr><th colspan="4">UNDO Segments</th></tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#undo_retention_parameters">UNDO Retention Parameters</a></td> <td nowrap align="center" width="25%"><a class="link" href="#undo_segment_contention">UNDO Segment Contention</a></td> <td nowrap align="center" width="25%"><a class="link" href="#undo_segments">UNDO Segments</a></td>  <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> </tr> <tr><th colspan="4">Backups</th></tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#rman_backup_control_files">RMAN Backup Control Files</a></td> <td nowrap align="center" width="25%"><a class="link" href="#rman_backup_pieces">RMAN Backup Pieces</a></td> <td nowrap align="center" width="25%"><a class="link" href="#rman_backup_sets">RMAN Backup Sets</a></td> <td nowrap align="center" width="25%"><a class="link" href="#rman_backup_spfile">RMAN Backup SPFILE</a></td> </tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#rman_configuration">RMAN Configuration</a></td> <td nowrap align="center" width="25%"> </td> <td nowrap align="center" width="25%"> </td> <td nowrap align="center" width="25%"></td> </tr> <tr>' >> ${__SNAP_SCRIPT}
    else
      echo 'prompt <td nowrap align="center" width="25%"><a class="link" href="#asm_disk">ASM Disk</a></td> </tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#asm_diskgroup">ASM Diskgroup</a></td>  <td nowrap align="center" width="25%"><a class="link" href="#"></a></td>  <td nowrap align="center" width="25%"><a class="link" href="#"></a></td>  <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> </tr> <tr><th colspan="4">UNDO Segments</th></tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#undo_retention_parameters">UNDO Retention Parameters</a></td> <td nowrap align="center" width="25%"><a class="link" href="#undo_segment_contention">UNDO Segment Contention</a></td> <td nowrap align="center" width="25%"><a class="link" href="#undo_segments">UNDO Segments</a></td>  <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> </tr> <tr><th colspan="4">Backups</th></tr> <tr><td nowrap align="center" width="25%"><a class="link" href="#rman_backup_control_files">RMAN Backup Control Files</a></td> <td nowrap align="center" width="25%"><a class="link" href="#rman_backup_pieces">RMAN Backup Pieces</a></td> <td nowrap align="center" width="25%"><a class="link" href="#rman_backup_sets">RMAN Backup Sets</a></td> <td nowrap align="center" width="25%"><a class="link" href="#rman_backup_spfile">RMAN Backup SPFILE</a></td> </tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#rman_configuration">RMAN Configuration</a></td> <td nowrap align="center" width="25%"><a class="link" href="#flash_recovery_area_parameters">Flash Recovery Area Parameters</a></td> <td nowrap align="center" width="25%"><a class="link" href="#flash_recovery_area_status">Flash Recovery Area Status</a></td> <td nowrap align="center" width="25%"></td> </tr> <tr>' >>${__SNAP_SCRIPT}
    fi

    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt <th colspan="4">Objects</th></tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#invalid_objects">Invalid Objects</a></td> <td nowrap align="center" width="25%"><a class="link" href="#objects_in_the_system_tablespace">Objects in the SYSTEM Tablespace</a></td> <td nowrap align="center" width="25%"><a class="link" href="#tables_suffering_from_row_chaining_migration">Tables Suffering From Row Chaining/Migration</a></td> <td nowrap align="center" width="25%"><a class="link" href="#top_10_segments_by_size">Top 10 Segments (by size)</a></td> </tr></tr></table><p> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Database and Instance Information</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                            - REPORT HEADER -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="report_header"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Report Header</b></font><hr align="left" width="460"> <table width="90%" border="1"> -
 <tr><th align="left" width="20%">Report Name</th><td width="80%"><tt>&FileName._&_dbname._&_spool_time..html</tt></td></tr> -
 <tr><th align="left" width="20%">Snapshot Type</th><td width="80%"><tt>&versionType</tt></td></tr> -
 <tr><th align="left" width="20%">Run Date / Time / Timezone</th><td width="80%"><tt>&_date_time_timezone</tt></td></tr> -
 <tr><th align="left" width="20%">Host Name</th><td width="80%"><tt>&_host_name</tt></td></tr> -
 <tr><th align="left" width="20%">Database Name</th><td width="80%"><tt>&_dbname</tt></td></tr> -
 <tr><th align="left" width="20%">Database ID</th><td width="80%"><tt>&_dbid</tt></td></tr> -
 <tr><th align="left" width="20%">Global Database Name</th><td width="80%"><tt>&_global_name</tt></td></tr> -
 <tr><th align="left" width="20%">Platform Name / ID</th><td width="80%"><tt>&_platform_name / &_platform_id</tt></td></tr> -
 <tr><th align="left" width="20%">Clustered Database?</th><td width="80%"><tt>&_cluster_database</tt></td></tr> -
 <tr><th align="left" width="20%">Clustered Database Instances</th><td width="80%"><tt>&_cluster_database_instances</tt></td></tr> -
 <tr><th align="left" width="20%">Instance Name</th><td width="80%"><tt>&_instance_name</tt></td></tr> -
 <tr><th align="left" width="20%">Instance Number</th><td width="80%"><tt>&_instance_number</tt></td></tr> -
 <tr><th align="left" width="20%">Thread Number</th><td width="80%"><tt>&_thread_number</tt></td></tr> -
 <tr><th align="left" width="20%">Database Startup Time</th><td width="80%"><tt>&_startup_time</tt></td></tr> -
 <tr><th align="left" width="20%">Database Block Size</th><td width="80%"><tt>&_blocksize</tt></td></tr> -
 <tr><th align="left" width="20%">Report Run User</th><td width="80%"><tt>&_reportRunUser</tt></td></tr> -
 </table> <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                                 - VERSION -                                |
 -- +----------------------------------------------------------------------------+
 prompt <a name="version"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Version</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN banner FORMAT a120 HEADING 'Banner'
 SELECT * FROM v$version;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                       - INITIALIZATION PARAMETERS -                        |
 -- +----------------------------------------------------------------------------+
 prompt <a name="initialization_parameters"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Initialization Parameters</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN spfile  HEADING 'SPFILE Usage'
 SELECT 'This database '|| DECODE(   (1-SIGN(1-SIGN(count(*) - 0))) , 1 , '<font color="#663300"><b>IS</b></font>', '<font color="#990000"><b>IS NOT</b></font>') || ' using an SPFILE.'spfile
 FROM v$spparameter
 WHERE value IS NOT null;
 COLUMN pname               HEADING 'Parameter Name' ENTMAP off
 COLUMN instance_name_print HEADING 'Instance Name'  ENTMAP off
 COLUMN value               HEADING 'Value'          ENTMAP off
 COLUMN isdefault           HEADING 'Is Default?'    ENTMAP off
 COLUMN issys_modifiable    HEADING 'Is Dynamic?'    ENTMAP off
 BREAK ON report ON pname
 SELECT DECODE( p.isdefault , 'FALSE', '<b><font color="#336699">' || SUBSTR(p.name,0,512) || '</font></b>', '<b><font color="#336699">' || SUBSTR(p.name,0,512) || '</font></b>' ) pname , DECODE(   p.isdefault , 'FALSE', '<font color="#663300"><b>' || i.instance_name || '</b></font>', i.instance_name ) instance_name_print , DECODE(   p.isdefault , 'FALSE', '<font color="#663300"><b>' || SUBSTR(p.value,0,512) || '</b></font>', SUBSTR(p.value,0,512) ) value , DECODE(   p.isdefault , 'FALSE', '<div align="center"><font color="#663300"><b>' || p.isdefault || '</b></font></div>', '<div align="center">' || p.isdefault || '</div>') isdefault , DECODE(   p.isdefault , 'FALSE', '<div align="right"><font color="#663300"><b>' || p.issys_modifiable || '</b></font></div>', '<div align="right">' || p.issys_modifiable || '</div>') issys_modifiable
 FROM gv$parameter p , gv$instance  i
 WHERE p.inst_id = i.inst_id
 ORDER BY p.name , i.instance_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - NLS PARAMETERS -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="nls_parameters"></a>
 prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>NLS Parameters</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN PARAMETER HEADING 'Parameter Name' ENTMAP off
 COLUMN value     HEADING 'Value'          ENTMAP off
 select PARAMETER, VALUE from nls_database_parameters;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                            - CONTROL FILES -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="control_files"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Control Files</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN name      HEADING 'Controlfile Name'  ENTMAP off
 COLUMN status    HEADING 'Status'            ENTMAP off
 COLUMN file_size HEADING 'File Size'         ENTMAP off
EOFSCRIPT

    if [ "${SNAPSHOT_VER}" = "9" ]; then
      echo "SELECT '<tt>' || c.name || '</tt>' name , DECODE(c.status , NULL ,  '<div align=center><b><font color=darkgreen>VALID</font></b></div>',  '<div align=center><b><font color=\"#663300\">'   || c.status || '</font></b></div>') status , 'N/A' file_size" >> ${__SNAP_SCRIPT}
    else
      echo "SELECT '<tt>' || c.name || '</tt>' name , DECODE(c.status , NULL ,  '<div align=center><b><font color=darkgreen>VALID</font></b></div>',  '<div align=center><b><font color=\"#663300\">'   || c.status || '</font></b></div>') status , '<div align=right>' || TO_CHAR(block_size *  file_size_blks, '999,999,999,999') || '</div>' file_size" >> ${__SNAP_SCRIPT}
    fi

    cat >> ${__SNAP_SCRIPT} <<EOFSCRIPT
 FROM v\$controlfile c
 ORDER BY c.name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                      - DATABASE INSTANCE OVERVIEW -                        |
 -- +----------------------------------------------------------------------------+
 prompt <a name="database_instance_overview"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Database Instance Overview</b></font><hr align="left" width="460">
 prompt Database Overview :
 CLEAR COLUMNS BREAKS COMPUTES
EOFSCRIPT

    if [ "${SNAPSHOT_VER}" = "9" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 COLUMN name               HEADING 'Database|Name'     ENTMAP off
 COLUMN dbid               HEADING 'Database|ID'       ENTMAP off
 COLUMN creation_date      HEADING 'Creation|Date'     ENTMAP off
 COLUMN log_mode           HEADING 'Log|Mode'          ENTMAP off
 COLUMN open_mode          HEADING 'Open|Mode'         ENTMAP off
 COLUMN force_logging      HEADING 'Force|Logging'     ENTMAP off
 COLUMN controlfile_type   HEADING 'Controlfile|Type'  ENTMAP off
 SELECT '<div align="center"><font color="#336699"><b>'|| name|| '</b></font></div>' name, '<div align="center">' || dbid|| '</div>' dbid , '<div align="center">' || TO_CHAR(created, 'yyyy-mm-dd HH24:MI:SS') || '</div>' creation_date , '<div align="center">' || log_mode|| '</div>' log_mode , '<div align="center">' || open_mode|| '</div>' open_mode , '<div align="center">' || force_logging || '</div>' force_logging , '<div align="center">' || controlfile_type || '</div>' controlfile_type
   FROM v$database;
EOFSCRIPT
    else
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 COLUMN name                 HEADING 'Database|Name'         ENTMAP off
 COLUMN dbid                 HEADING 'Database|ID'           ENTMAP off
 COLUMN db_unique_name       HEADING 'Database|Unique Name'  ENTMAP off
 COLUMN creation_date        HEADING 'Creation|Date'         ENTMAP off
 COLUMN platform_name_print  HEADING 'Platform|Name'         ENTMAP off
 COLUMN current_scn          HEADING 'Current|SCN'           ENTMAP off
 COLUMN log_mode             HEADING 'Log|Mode'              ENTMAP off
 COLUMN open_mode            HEADING 'Open|Mode'             ENTMAP off
 COLUMN force_logging        HEADING 'Force|Logging'         ENTMAP off
 COLUMN flashback_on         HEADING 'Flashback|On?'         ENTMAP off
 COLUMN controlfile_type     HEADING 'Controlfile|Type'      ENTMAP off
 COLUMN last_open_inc_number HEADING 'Last Incarnation Num'  ENTMAP off
 SELECT '<div align="center"><font color="#336699"><b>'  || name  || '</b></font></div>' name , '<div align="center">' || dbid || '</div>' dbid , '<div align="center">' || db_unique_name || '</div>' db_unique_name , '<div align="center">' || TO_CHAR(created, 'yyyy-mm-dd HH24:MI:SS') || '</div>' creation_date , '<div align="center">' || platform_name || '</div>' platform_name_print , '<div align="center">' || current_scn || '</div>' current_scn , '<div align="center">' || log_mode || '</div>' log_mode , '<div align="center">' || open_mode || '</div>' open_mode , '<div align="center">' || force_logging || '</div>' force_logging , '<div align="center">' || flashback_on || '</div>' flashback_on , '<div align="center">' || controlfile_type || '</div>' controlfile_type , '<div align="center">' || last_open_incarnation# || '</div>' last_open_inc_number
 FROM v$database;
EOFSCRIPT
    fi

    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt Instance Overview :
 COLUMN instance_name_print   HEADING 'Instance|Name'    ENTMAP off
 COLUMN instance_number_print HEADING 'Instance|Num'     ENTMAP off
 COLUMN thread_number_print   HEADING 'Thread|Num'       ENTMAP off
 COLUMN host_name_print       HEADING 'Host|Name'        ENTMAP off
 COLUMN version               HEADING 'Oracle|Version'   ENTMAP off
 COLUMN start_time            HEADING 'Start|Time'       ENTMAP off
 COLUMN uptime                HEADING 'Uptime|(in days)' ENTMAP off
 COLUMN parallel              HEADING 'Parallel - (RAC)' ENTMAP off
 COLUMN instance_status       HEADING 'Instance|Status'  ENTMAP off
 COLUMN database_status       HEADING 'Database|Status'  ENTMAP off
 COLUMN logins                HEADING 'Logins'           ENTMAP off
 COLUMN archiver              HEADING 'Archiver'         ENTMAP off
 SELECT '<div align="center"><font color="#336699"><b>' || instance_name || '</b></font></div>' instance_name_print , '<div align="center">' || instance_number || '</div>' instance_number_print , '<div align="center">' || thread# || '</div>' thread_number_print , '<div align="center">' || host_name || '</div>' host_name_print , '<div align="center">' || version || '</div>' version , '<div align="center">' || TO_CHAR(startup_time,'yyyy-mm-dd HH24:MI:SS') || '</div>' start_time , ROUND(TO_CHAR(SYSDATE-startup_time), 2) uptime , '<div align="center">' || parallel || '</div>' parallel , '<div align="center">' || status || '</div>' instance_status , '<div align="center">' || logins || '</div>' logins , DECODE(   archiver , 'FAILED', '<div align="center"><b><font color="#990000">'   || archiver || '</font></b></div>', '<div align="center"><b><font color="darkgreen">' || archiver || '</font></b></div>') archiver
 FROM gv$instance
 ORDER BY instance_number;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                              - REDO LOGS -                                 |
 -- +----------------------------------------------------------------------------+
 prompt <a name="redo_logs"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Redo Logs</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name_print  HEADING 'Instance Name' ENTMAP off
 COLUMN groupno              HEADING 'Group Number'  ENTMAP off
 COLUMN member               HEADING 'Member'        ENTMAP off
 COLUMN redo_file_type       HEADING 'Redo Type'     ENTMAP off
 COLUMN log_status           HEADING 'Log Status'    ENTMAP off
 COLUMN bytes FORMAT 999,999 HEADING 'Size/MB'       ENTMAP off
 COLUMN archived             HEADING 'Archived?'     ENTMAP off
 BREAK ON report ON instance_name_print ON thread_number_print
 SELECT '<div align="center"><font color="#336699"><b>' || i.instance_name || '</b></font></div>' instance_name_print , f.group# groupno , '<tt>' || f.member || '</tt>' member , f.type redo_file_type , DECODE(   l.status , 'CURRENT', '<div align="center"><b><font color="darkgreen">' || l.status || '</font></b></div>', '<div align="center"><b><font color="#990000">'   || l.status || '</font></b></div>')  log_status , l.bytes/1048576 bytes , '<div align="center">'  || l.archived || '</div>' archived
 FROM gv$logfile  f , gv$log l , gv$instance i
 WHERE f.group#  = l.group# AND l.thread# = i.thread# AND i.inst_id = f.inst_id AND f.inst_id = l.inst_id
 ORDER BY i.instance_name , f.group# , f.member;
 -- +----------------------------------------------------------------------------+
 -- |                         - REDO LOG SWITCHES -                              |
 -- +----------------------------------------------------------------------------+
 prompt <P><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Redo Log Switches</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN DAY                      HEADING 'Day/Time' ENTMAP off
 COLUMN H00   FORMAT 999,999B    HEADING '00'       ENTMAP off
 COLUMN H01   FORMAT 999,999B    HEADING '01'       ENTMAP off
 COLUMN H02   FORMAT 999,999B    HEADING '02'       ENTMAP off
 COLUMN H03   FORMAT 999,999B    HEADING '03'       ENTMAP off
 COLUMN H04   FORMAT 999,999B    HEADING '04'       ENTMAP off
 COLUMN H05   FORMAT 999,999B    HEADING '05'       ENTMAP off
 COLUMN H06   FORMAT 999,999B    HEADING '06'       ENTMAP off
 COLUMN H07   FORMAT 999,999B    HEADING '07'       ENTMAP off
 COLUMN H08   FORMAT 999,999B    HEADING '08'       ENTMAP off
 COLUMN H09   FORMAT 999,999B    HEADING '09'       ENTMAP off
 COLUMN H10   FORMAT 999,999B    HEADING '10'       ENTMAP off
 COLUMN H11   FORMAT 999,999B    HEADING '11'       ENTMAP off
 COLUMN H12   FORMAT 999,999B    HEADING '12'       ENTMAP off
 COLUMN H13   FORMAT 999,999B    HEADING '13'       ENTMAP off
 COLUMN H14   FORMAT 999,999B    HEADING '14'       ENTMAP off
 COLUMN H15   FORMAT 999,999B    HEADING '15'       ENTMAP off
 COLUMN H16   FORMAT 999,999B    HEADING '16'       ENTMAP off
 COLUMN H17   FORMAT 999,999B    HEADING '17'       ENTMAP off
 COLUMN H18   FORMAT 999,999B    HEADING '18'       ENTMAP off
 COLUMN H19   FORMAT 999,999B    HEADING '19'       ENTMAP off
 COLUMN H20   FORMAT 999,999B    HEADING '20'       ENTMAP off
 COLUMN H21   FORMAT 999,999B    HEADING '21'       ENTMAP off
 COLUMN H22   FORMAT 999,999B    HEADING '22'       ENTMAP off
 COLUMN H23   FORMAT 999,999B    HEADING '23'       ENTMAP off
 COLUMN TOTAL FORMAT 999,999,999 HEADING 'Total'    ENTMAP off
 BREAK ON report
 COMPUTE sum LABEL '<font color="#990000"><b>Total:</b></font>' avg label '<font color="#990000"><b>Average:</b></font>' OF total ON report
 SELECT '<div align="center"><font color="#336699"><b>' || TO_CHAR(first_time, 'MM/DD') || '</b></font></div>'  DAY , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'00',1,0)) H00 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'01',1,0)) H01 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'02',1,0)) H02 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'03',1,0)) H03 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'04',1,0)) H04 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'05',1,0)) H05 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'06',1,0)) H06 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'07',1,0)) H07 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'08',1,0)) H08 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'09',1,0)) H09 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'10',1,0)) H10 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'11',1,0)) H11 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'12',1,0)) H12 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'13',1,0)) H13 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'14',1,0)) H14 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'15',1,0)) H15 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'16',1,0)) H16 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'17',1,0)) H17 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'18',1,0)) H18 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'19',1,0)) H19 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'20',1,0)) H20 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'21',1,0)) H21 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'22',1,0)) H22 , SUM(DECODE(TO_CHAR(first_time, 'HH24'),'23',1,0)) H23 , COUNT(*) TOTAL
   FROM (SELECT ROWNUM RN,FIRST_TIME FROM V$LOG_HISTORY WHERE FIRST_TIME > ADD_MONTHS(SYSDATE, -1) ORDER BY FIRST_TIME)
  GROUP BY TO_CHAR(first_time, 'MM/DD')
  ORDER BY MIN(RN);
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                               - SCN REPORT -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="scn_report"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>SCN Report</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN tim      HEAD 'Time'      ENTMAP off
 COLUMN scn      HEAD 'SCN Value' ENTMAP off
 COLUMN Headroom HEAD 'Headroom'  ENTMAP off
 SELECT to_char(tim,'yyyy-mm-dd hh24:mi:ss') tim,scn,round((chk16kscn-scn)/24/3600/16/1024,1) Headroom
 FROM (select tim, scn, ((((to_number(to_char(tim,'YYYY'))-1988)*12*31*24*60*60) + ((to_number(to_char(tim,'MM'))-1)*31*24*60*60) + (((to_number(to_char(tim,'DD'))-1))*24*60*60) + (to_number(to_char(tim,'HH24'))*60*60) + (to_number(to_char(tim,'MI'))*60) + (to_number(to_char(tim,'SS'))) ) * (16*1024)) chk16kscn from (select sysdate tim,dbms_flashback.get_system_change_number scn from dual))
 ORDER BY tim;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Storage</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                            - TABLESPACES -                                 |
 -- +----------------------------------------------------------------------------+
 prompt <a name="tablespaces"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Tablespaces</b></font><hr align="left" width="460">
 prompt <b>Tablespace Size and Used Infomation , <font color='red'> All Size Unit is MB </font></b>
 prompt <b><font color='red'> All Size </font></b>: the summary size of all datafiles current
 prompt <b><font color='red'> Max Size </font></b>: the summary size of all datafiles which extent to Maxsize
 prompt <b><font color='red'> Free Size</font></b>: the summary Free size of all datafiles
 prompt <b><font color='red'> Max Free </font></b>: the summary Free size of all datafiles which extent to Maxsize
 prompt <b><font color='red'> Pct. Free</font></b>: the Free Percent of the tablespace
 prompt <b><font color='red'> Max Free%</font></b>: the Free Percent of the tablespace which extent to Maxsize
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN STATUS                      HEADING 'Status'    ENTMAP off
 COLUMN TABLESPACE_NAME             HEADING 'Name'      ENTMAP off
 COLUMN CONTENTS FORMAT a12         HEADING 'TS Type'   ENTMAP off
 COLUMN ALL_MB   FORMAT 999,999,999 HEADING 'All Size'  ENTMAP off
 COLUMN MAX_MB   FORMAT 999,999,999 HEADING 'Max Size'  ENTMAP off
 COLUMN FREE_MB  FORMAT 999,999,999 HEADING 'Free Size' ENTMAP off
 COLUMN FREE_EXT FORMAT 999,999,999 HEADING 'Max Free'  ENTMAP off
 COLUMN PCT_FREE FORMAT 999         HEADING 'Pct. Free' ENTMAP off
 COLUMN PCT_EXT  FORMAT 999         HEADING 'Max Free%' ENTMAP off
 SELECT T.TABLESPACE_NAME TABLESPACE_NAME, T.CONTENTS CONTENTS, DECODE(T.STATUS, 'OFFLINE' , '<div align="center"><b><font color="#990000"> Offline </font></b></div>', '<div align="center"><b><font color="darkgreen">' || T.STATUS || '</font></b></div>') STATUS, ROUND(SUM(A.BYTES) / 1048576) ALL_MB, ROUND(SUM(MAXBYTES)/1048576) MAX_MB, ROUND(SUM(NVL(F.BYTES,0)) / 1048576) FREE_MB, ROUND((SUM(MAXBYTES-A.BYTES)+SUM(NVL(F.BYTES, 0))) / 1048576) FREE_EXT, CASE WHEN ROUND(100 * SUM(NVL(F.BYTES, 0)) / SUM(A.BYTES)) <= 20 THEN '<font color="#990000">'||ROUND(100 * SUM(NVL(F.BYTES, 0)) / SUM(A.BYTES))||'</font>'ELSE '<font color="darkgreen">'||ROUND(100 * SUM(NVL(F.BYTES, 0)) / SUM(A.BYTES))||'</font>' END PCT_FREE, CASE WHEN ROUND(100 * (SUM(MAXBYTES-A.BYTES)+SUM(NVL(F.BYTES, 0))) / SUM(A.MAXBYTES)) <= 20 THEN '<font color="#990000">'||ROUND(100 * (SUM(MAXBYTES-A.BYTES) + SUM(NVL(F.BYTES, 0))) / SUM(A.MAXBYTES))||'</font>'ELSE '<font color="darkgreen">'||ROUND(100 * (SUM(MAXBYTES-A.BYTES) + SUM(NVL(F.BYTES, 0))) / SUM(A.MAXBYTES))||'</font>' END PCT_EXT
   FROM (select file_id, tablespace_name, file_name, bytes, case when MAXBYTES > bytes then MAXBYTES else bytes end MAXBYTES from DBA_DATA_FILES) A, DBA_TABLESPACES T, (SELECT FILE_ID,SUM(BYTES) BYTES FROM DBA_FREE_SPACE GROUP BY FILE_ID) F
  WHERE A.FILE_ID = F.FILE_ID(+) AND A.TABLESPACE_NAME = T.TABLESPACE_NAME AND T.CONTENTS != 'TEMPORARY'
  GROUP BY T.TABLESPACE_NAME, T.CONTENTS, T.STATUS
  ORDER BY ROUND(100 * SUM(NVL(F.BYTES, 0)) / SUM(A.BYTES));
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                            - DATA FILES -                                  |
 -- +----------------------------------------------------------------------------+
 prompt <a name="data_files"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Data Files</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN tablespace FORMAT A50 HEADING 'Tbs Name'       ENTMAP off
 COLUMN filename              HEADING 'Filename'       ENTMAP off
 COLUMN filesize   FORMAT A30 HEADING 'File Size'      ENTMAP off
 COLUMN autoextensible        HEADING 'Autoextensible' ENTMAP off
 COLUMN status     FORMAT A40 HEADING 'Status'         ENTMAP off
 COLUMN maxsize    FORMAT A30 HEADING 'Max Size'       ENTMAP off
 SELECT /*+ ordered */ '<font color="#336699"><b>' || tablespace_name  || '</b></font>'  tablespace , '<tt>' || file_name || '</tt>' filename , case when bytes<1048576 then '<div align="right">'|| round(bytes/1024)||' KB</div>'when bytes<1073741824 then '<div align="right">'|| round(bytes/1048576)||' MB</div>'else '<div align="right">'|| round(bytes/1073741824) ||' GB</div>' end filesize , case status when 'AVAILABLE' then '<font color=darkgreen> Available </font>'else '<font color=red>'||status||'</font>' end status , '<div align="center">' || NVL(autoextensible, '<br>') || '</div>' autoextensible , case when nvl(maxbytes,0)<1048576 then '<div align="right">'|| round(nvl(maxbytes,0)/1024)||' KB</div>'when maxbytes<1073741824 then '<div align="right">'|| round(maxbytes/1048576)||' MB</div>'else '<div align="right">'|| round(maxbytes/1073741824) ||' GB</div>' end maxbytes
 FROM (SELECT TABLESPACE_NAME, FILE_NAME, BYTES, STATUS, AUTOEXTENSIBLE, CASE WHEN MAXBYTES > BYTES THEN MAXBYTES ELSE BYTES END MAXBYTES FROM DBA_DATA_FILES
 UNION ALL SELECT TABLESPACE_NAME, FILE_NAME, BYTES, STATUS, AUTOEXTENSIBLE, CASE WHEN MAXBYTES > BYTES THEN MAXBYTES ELSE BYTES END MAXBYTES FROM DBA_TEMP_FILES);
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                        - TABLESPACE TO OWNER  -                            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="tablespace_to_owner"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Tablespace to Owner</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN tablespace_name              HEADING 'Tablespace Name'  ENTMAP off
 COLUMN owner                        HEADING 'Owner'            ENTMAP off
 COLUMN segment_type                 HEADING 'Segment Type'     ENTMAP off
 COLUMN bytes     FORMAT 999,999,999 HEADING 'Size/MB'          ENTMAP off
 COLUMN seg_count FORMAT 999,999,999 HEADING 'Segment Count'    ENTMAP off
 BREAK ON report ON tablespace_name
 COMPUTE sum LABEL '<font color="#990000"><b>Total: </b></font>' of seg_count bytes ON report
 SELECT '<font color="#336699"><b>' || tablespace_name || '</b></font>'  tablespace_name , '<div align="right">' || owner || '</div>' owner , '<div align="right">' || segment_type || '</div>' segment_type , round(sum(bytes)/1048576) bytes , count(*) seg_count
 FROM dba_segments
 GROUP BY tablespace_name , owner , segment_type
 ORDER BY tablespace_name , owner , segment_type;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT

    if [ "${SNAPSHOT_VER}" = "10" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"

 -- +----------------------------------------------------------------------------+
 -- |                              - ASM Disk -                                  |
 -- +----------------------------------------------------------------------------+
 prompt <a name="asm_disk"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>ASM Disk</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 col DISK_NUMBER  HEADING 'Disk Number'    ENTMAP off
 col group_name   HEADING 'Group Name'     ENTMAP off
 col disk_name    HEADING 'Disk Name '     ENTMAP off
 col path         HEADING 'Path'           ENTMAP off
 col total_gb     HEADING 'Total Size(GB)' ENTMAP off
 col free_gb      HEADING 'Free Size(GB)'  ENTMAP off
 col free_percent HEADING '% Free'         ENTMAP off
 break on report on disk_number
 compute sum label '<font color="#990000"><b>Total: </b></font>' of seg_count bytes on report
 SELECT '<font color="#336699"><b>' || disk_number || '</b></font>' disk_number , decode(a.state,'CONNECTED','<font color=darkgreen><b>'|| a.state || '</b></font>','MOUNTED','<font color="#336699"><b>' || a.state || '</b></font>','DISMOUNTED','<font color=darkred><b>' || a.state || '</b></font>','<font color=red><b>' || a.state || '</b></font>') state , b.name group_name , a.name disk_name , a.path , round(a.total_mb/1024) total_gb , round(a.free_mb/1024) free_gb , case when round(a.free_mb/a.total_mb*100)>90 then '<font color=red><b>' || round(a.free_mb/a.total_mb*100) || '</b></font>'when round(a.free_mb/a.total_mb*100)<50 then '<font color=GREEN><b>' || round(a.free_mb/a.total_mb*100) || '</b></font>'else '<b>' || round(a.free_mb/a.total_mb*100) || '</b>'end free_percent
 FROM V$ASM_DISK A,V$ASM_DISKGROUP B
 WHERE A.GROUP_NUMBER=B.GROUP_NUMBER
 ORDER BY disk_number;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                            - ASM Diskgroup -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="asm_diskgroup"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>ASM Diskgroup</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 col group_number  HEADING 'Group Number'   ENTMAP off
 col State         HEADING 'State'          ENTMAP off
 col name          HEADING 'Name'           ENTMAP off
 col total_gb      HEADING 'Total Size(GB)' ENTMAP off
 col free_gb       HEADING 'Free Size(GB)'  ENTMAP off
 col free_percent  HEADING '% Free'         ENTMAP off
 break on report on group_number
 compute sum label '<font color="#990000"><b>Total: </b></font>' of seg_count bytes on report
 SELECT '<font color="#336699"><b>'||group_number||'</b></font>' group_number, decode(state,'CONNECTED','<font color=darkgreen><b>CONNECTED</b></font>','MOUNTED','<font color="#336699"><b>MOUNTED</b></font>','DISMOUNTED','<font color=darkred><b>DISMOUNTED</b></font>','<font color=red><b>'||state||'</b></font>') state, name, round(total_mb/1024) total_gb, round(free_mb/1024) free_gb, case when free_percent>90 then '<font color=red><b>'||free_percent||'</b></font>' when free_percent<50 then '<font color=GREEN><b>'||free_percent||'</b></font>' else '<b>'||free_percent||'</b>' end free_percent
 FROM (select group_number, state, name, total_mb, free_mb, round(free_mb/(case when total_mb is null or total_mb=0 then 1 else total_mb end)*100) free_percent from v$ASM_DISKGROUP)
 ORDER BY group_number;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    fi

    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>UNDO Segments</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                       - UNDO RETENTION PARAMETERS -                        |
 -- +----------------------------------------------------------------------------+
 prompt <a name="undo_retention_parameters"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>UNDO Retention Parameters</b></font><hr align="left" width="460"> <b>undo_retention is specified in minutes</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name_print FORMAT a95  HEADING 'Instance Name' ENTMAP off
 COLUMN thread_number_print FORMAT a95  HEADING 'Thread Number' ENTMAP off
 COLUMN name                FORMAT a125 HEADING 'Name'          ENTMAP off
 COLUMN value                           HEADING 'Value'         ENTMAP off
 BREAK ON report ON instance_name_print ON thread_number_print
 SELECT '<div align="center"><font color="#336699"><b>' || i.instance_name || '</b></font></div>' instance_name_print , '<div align="center">' || i.thread# || '</div>' thread_number_print , '<div nowrap>' || p.name || '</div>' name , (CASE p.name WHEN 'undo_retention' THEN '<div nowrap align="right">' || TO_CHAR(TO_NUMBER(p.value)/60, '999,999,999,999,999') || ' Min </div>'ELSE '<div nowrap align="right">' || p.value || '</div>'END) value
  FROM gv$parameter p , gv$instance  i
 WHERE p.inst_id = i.inst_id AND p.name LIKE 'undo%'
 ORDER BY i.instance_name , p.name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                        - UNDO SEGMENT CONTENTION -                         |
 -- +----------------------------------------------------------------------------+
 prompt <a name="undo_segment_contention"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>UNDO Segment Contention</b></font><hr align="left" width="460"> <b>UNDO statistics from V$ROLLSTAT - (ordered by waits)</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN roll_name                           HEADING 'UNDO Segment Name' ENTMAP off
 COLUMN gets             FORMAT 999,999,999 HEADING 'Gets'              ENTMAP off
 COLUMN waits            FORMAT 999,999,999 HEADING 'Waits'             ENTMAP off
 COLUMN immediate_misses FORMAT 999,999,999 HEADING 'Immediate Misses'  ENTMAP off
 COLUMN hit_ratio                           HEADING 'Hit Ratio'         ENTMAP off
 BREAK ON report
 COMPUTE SUM label '<font color="#990000"><b>Total:</b></font>' OF gets waits ON report
 SELECT '<font color="#336699"><b>' || b.name || '</b></font>'  roll_name , gets gets , waits waits , '<div align="right">' || TO_CHAR(ROUND(((gets - waits)*100)/gets, 2)) || '%</div>' hit_ratio
  FROM v$rollstat a , v$rollname b
 WHERE a.USN = b.USN
 ORDER BY waits DESC;
 prompt <b>Wait statistics</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN class  HEADING 'Class'
 COLUMN ratio  HEADING 'Wait Ratio'
 SELECT '<font color="#336699"><b>' || w.class || '</b></font>' class , '<div align="right">' || TO_CHAR(ROUND(100*(w.count/SUM(s.value)),8)) || '%</div>' ratio
  FROM v$waitstat  w , v$sysstat   s
 WHERE w.class IN ('system undo header', 'system undo block', 'undo header', 'undo block') AND s.name IN ('db block gets', 'consistent gets')
 GROUP BY w.class , w.count;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                            - UNDO SEGMENTS -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="undo_segments"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>UNDO Segments</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name              HEADING 'Instance Name'      ENTMAP off
 COLUMN tablespace  FORMAT a85     HEADING 'Tablspace'          ENTMAP off
 COLUMN roll_name                  HEADING 'UNDO Segment Name'  ENTMAP off
 COLUMN in_extents                 HEADING 'Init/Next Extents'  ENTMAP off
 COLUMN m_extents                  HEADING 'Min/Max Extents'    ENTMAP off
 COLUMN status                     HEADING 'Status'             ENTMAP off
 COLUMN wraps   FORMAT 999,999,999 HEADING 'Wraps'              ENTMAP off
 COLUMN shrinks FORMAT 999,999,999 HEADING 'Shrinks'            ENTMAP off
 COLUMN opt     FORMAT 999,999,999 HEADING 'Opt. Size'          ENTMAP off
 COLUMN bytes   FORMAT 999,999,999 HEADING 'Size_MB'            ENTMAP off
 COLUMN extents FORMAT 999,999,999 HEADING 'Extents'            ENTMAP off
 CLEAR COMPUTES BREAKS
 BREAK ON report ON instance_name ON tablespace
 SELECT '<div nowrap><font color="#336699"><b>' ||  NVL(i.instance_name, '<br>') || '</b></font></div>' instance_name , '<div nowrap><font color="#336699"><b>' ||  a.tablespace_name || '</b></font></div>'  tablespace , '<div nowrap>' ||  a.owner || '.' || a.segment_name || '</div>' roll_name , '<div align="right">' || TO_CHAR(a.initial_extent) || ' / ' || TO_CHAR(a.next_extent) || '</div>' in_extents , '<div align="right">' || TO_CHAR(a.min_extents) || ' / ' || TO_CHAR(a.max_extents) || '</div>' m_extents , DECODE(a.status , 'OFFLINE', '<div align="center"><b><font color="#990000">'   || a.status || '</font></b></div>', '<div align="center"><b><font color="darkgreen">'||a.status||'</font></b></div>') status, round(b.bytes/1048576) bytes , b.extents extents , d.shrinks shrinks , d.wraps wraps , d.optsize opt
  FROM dba_rollback_segs a , dba_segments b , v$rollname c , v$rollstat d , gv$parameter p , gv$instance  i
 WHERE a.segment_name  = b.segment_name AND a.segment_name  = c.name (+) AND  c.usn = d.usn (+) AND  p.name (+) = 'undo_tablespace'AND  p.value (+) = a.tablespace_name AND  p.inst_id = i.inst_id (+)
 ORDER BY a.tablespace_name , a.segment_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Backups</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                       - RMAN BACKUP CONTROL FILES -                        |
 -- +----------------------------------------------------------------------------+
 prompt <a name="rman_backup_control_files"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>RMAN Backup Control Files</b></font><hr align="left" width="460">
 prompt <b>Available automatic control files within all available (and expired) backup sets</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN bs_key  HEADING 'BS Key'  ENTMAP off
 COLUMN piece#  HEADING 'Piece #' ENTMAP off
 COLUMN copy#   HEADING 'Copy #'  ENTMAP off
 COLUMN bp_key  HEADING 'BP Key'  ENTMAP off
 COLUMN handle  HEADING 'Handle'  ENTMAP off
 BREAK ON bs_key
 SELECT '<div align="center"><font color="#336699"><b>' || bs.recid  || '</b></font></div>' bs_key , bp.piece# piece# , bp.copy# copy# , bp.recid bp_key , handle handle
 FROM v$backup_set bs , v$backup_piece  bp
 WHERE bs.set_stamp = bp.set_stamp AND bs.set_count = bp.set_count AND bp.status = 'A' AND bs.controlfile_included = 'YES'
 ORDER BY bs.recid , piece#;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                          - RMAN BACKUP PIECES -                            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="rman_backup_pieces"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>RMAN Backup Pieces</b></font><hr align="left" width="460">
 prompt <b>Available backup pieces contained in the control file including available and expired backup sets</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN bs_key                             HEADING 'BS Key'          ENTMAP off
 COLUMN piece#                             HEADING 'Piece #'         ENTMAP off
 COLUMN copy#                              HEADING 'Copy #'          ENTMAP off
 COLUMN bp_key                             HEADING 'BP Key'          ENTMAP off
 COLUMN handle                             HEADING 'Handle'          ENTMAP off
 COLUMN start_time                         HEADING 'Start Time'      ENTMAP off
 COLUMN completion_time                    HEADING 'End Time'        ENTMAP off
 COLUMN elapsed_seconds FORMAT 999,999,999 HEADING 'Elapsed Seconds' ENTMAP off
 BREAK ON bs_key
 SELECT '<div align="center"><font color="#336699"><b>' || bs.recid  || '</b></font></div>' bs_key , bp.piece# piece# , bp.copy# copy# , bp.recid bp_key , handle handle , '<div nowrap align="right">' || TO_CHAR(bp.start_time, 'yyyy-mm-dd HH24:MI:SS') || '</div>' start_time , '<div nowrap align="right">' || TO_CHAR(bp.completion_time, 'yyyy-mm-dd HH24:MI:SS') || '</div>' completion_time , bp.elapsed_seconds elapsed_seconds
 FROM v$backup_set bs , v$backup_piece  bp
 WHERE bs.set_stamp = bp.set_stamp AND bs.set_count = bp.set_count AND bp.status = 'A'
 ORDER BY bs.recid , piece#;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - RMAN BACKUP SETS -                             |
 -- +----------------------------------------------------------------------------+
 prompt <a name="rman_backup_sets"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>RMAN Backup Sets</b></font><hr align="left" width="460">
 prompt <b>Available backup sets contained in the control file including available and expired backup sets</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN bs_key                             HEADING 'BS Key'            ENTMAP off
 COLUMN backup_type            FORMAT a70  HEADING 'Backup Type'       ENTMAP off
 COLUMN device_type                        HEADING 'Device Type'       ENTMAP off
 COLUMN controlfile_included   FORMAT a30  HEADING 'Control Included?' ENTMAP off
 COLUMN spfile_included FORMAT a30         HEADING 'SPFILE Included?'  ENTMAP off
 COLUMN incremental_level                  HEADING 'Inc. Level'        ENTMAP off
 COLUMN pieces          FORMAT 999,999,999 HEADING '# of Pieces'       ENTMAP off
 COLUMN start_time                         HEADING 'Start Time'        ENTMAP off
 COLUMN completion_time                    HEADING 'End Time'          ENTMAP off
 COLUMN elapsed_seconds FORMAT 999,999,999 HEADING 'Elapsed Seconds'   ENTMAP off
 COLUMN tag                                HEADING 'Tag'               ENTMAP off
 BREAK ON report
 COMPUTE sum LABEL '<font color="#990000"><b>Total:</b></font>' OF pieces elapsed_seconds ON report
 SELECT '<div align="center"><font color="#336699"><b>' || bs.recid || '</b></font></div>' bs_key, DECODE(backup_type , 'L', '<div nowrap><font color="#990000">Archived Redo Logs</font></div>', 'D', '<div nowrap><font color="#000099">Datafile Full Backup</font></div>', 'I', '<div nowrap><font color="darkgreen">Incremental Backup</font></div>') backup_type , '<div nowrap align="right">' || device_type || '</div>' device_type , '<div align="center">' || DECODE(bs.controlfile_included, 'NO', '-', bs.controlfile_included) || '</div>' controlfile_included , '<div align="center">' || NVL(sp.spfile_included, '-') || '</div>' spfile_included , bs.incremental_level, '<div nowrap align="right">' || TO_CHAR(bs.start_time, 'yyyy-mm-dd HH24:MI:SS') || '</div>' start_time , '<div nowrap align="right">' || TO_CHAR(bs.completion_time, 'yyyy-mm-dd HH24:MI:SS') || '</div>' completion_time , bs.elapsed_seconds, bp.tag
 FROM v$backup_set bs , (select distinct set_stamp , set_count , tag , device_type from v$backup_piece where status = 'A') bp ,  (select distinct set_stamp, set_count, 'YES' spfile_included from v$backup_spfile) sp
 WHERE bs.set_stamp = bp.set_stamp AND bs.set_count = bp.set_count AND bs.set_stamp = sp.set_stamp (+) AND bs.set_count = sp.set_count (+)
 ORDER BY bs.recid;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - RMAN BACKUP SPFILE -                           |
 -- +----------------------------------------------------------------------------+
 prompt <a name="rman_backup_spfile"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>RMAN Backup SPFILE</b></font><hr align="left" width="460">
 prompt <b>Available automatic SPFILE backups within all available (and expired) backup sets</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN bs_key   HEADING 'BS Key'  ENTMAP off
 COLUMN piece#   HEADING 'Piece #' ENTMAP off
 COLUMN copy#    HEADING 'Copy #'  ENTMAP off
 COLUMN bp_key   HEADING 'BP Key'  ENTMAP off
 COLUMN handle   HEADING 'Handle'  ENTMAP off
 BREAK ON bs_key
 SELECT '<div align="center"><font color="#336699"><b>' || bs.recid  || '</b></font></div>' bs_key , bp.piece# piece# , bp.copy# copy# , bp.recid bp_key , handle handle
 FROM v$backup_set bs , v$backup_piece bp ,  (select distinct set_stamp, set_count, 'YES' spfile_included from v$backup_spfile) sp
 WHERE bs.set_stamp = bp.set_stamp AND bs.set_count = bp.set_count AND bp.status = 'A'AND bs.set_stamp = sp.set_stamp AND bs.set_count = sp.set_count
 ORDER BY bs.recid , piece#;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - RMAN CONFIGURATION -                           |
 -- +----------------------------------------------------------------------------+
 prompt <a name="rman_configuration"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>RMAN Configuration</b></font><hr align="left" width="460">
 prompt <b>All non-default RMAN configuration settings</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN name   HEADING 'Name'   ENTMAP off
 COLUMN value  HEADING 'Value'  ENTMAP off
 SELECT '<div nowrap><b><font color="#336699">' || name || '</font></b></div>' name , value
 FROM v$rman_configuration
 ORDER BY name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT

    if [ "${SNAPSHOT_VER}" = "10" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"

 -- +----------------------------------------------------------------------------+
 -- |                     - FLASH RECOVERY AREA PARAMETERS -                     |
 -- +----------------------------------------------------------------------------+
 prompt <a name="flash_recovery_area_parameters"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Flash Recovery Area Parameters</b></font><hr align="left" width="460">
 prompt <b>db_recovery_file_dest_size is specified in bytes</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name_print FORMAT a95 HEADING 'Instance Name' ENTMAP off
 COLUMN thread_number_print FORMAT a55 HEADING 'Thread Number' ENTMAP off
 COLUMN name                FORMAT A80 HEADING 'Name'          ENTMAP off
 COLUMN value                          HEADING 'Value'         ENTMAP off
 BREAK ON report ON instance_name_print ON thread_number_print
 SELECT '<div align="center"><font color="#336699"><b>' || i.instance_name || '</b></font></div>' instance_name_print , '<div align="center">' || i.thread# || '</div>' thread_number_print , '<div nowrap>' || p.name || '</div>' name , (CASE p.name WHEN 'db_recovery_file_dest_size' THEN '<div nowrap align="right">' || TO_CHAR(p.value, '999,999,999,999,999') || '</div>'ELSE '<div nowrap align="right">' || NVL(p.value, '(null)') || '</div>'END) value
 FROM gv$parameter p , gv$instance  i
 WHERE p.inst_id = i.inst_id AND p.name IN ('db_recovery_file_dest_size', 'db_recovery_file_dest')
 ORDER BY 1, 3;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                      - FLASH RECOVERY AREA STATUS -                        |
 -- +----------------------------------------------------------------------------+
 prompt <a name="flash_recovery_area_status"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Flash Recovery Area Status</b></font><hr align="left" width="460">
 prompt <b>Current location, disk quota, space in use, space reclaimable by deleting files, and number of files in the Flash Recovery Area</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN name                                 HEADING 'Name'               ENTMAP off
 COLUMN space_limit        FORMAT 99,999,999 HEADING 'Space Limit'        ENTMAP off
 COLUMN space_used         FORMAT 99,999,999 HEADING 'Space Used'         ENTMAP off
 COLUMN space_used_pct     FORMAT 999.99     HEADING '% Used'             ENTMAP off
 COLUMN space_reclaimable  FORMAT 99,999,999 HEADING 'Space Reclaimable'  ENTMAP off
 COLUMN pct_reclaimable    FORMAT 999.99     HEADING '% Reclaimable'      ENTMAP off
 COLUMN number_of_files    FORMAT 999,999    HEADING 'Number of Files'    ENTMAP off
 COLUMN file_type                            HEADING 'File Type'
 COLUMN percent_space_used                   HEADING 'Percent Space Used'
 COLUMN percent_space_reclaimable            HEADING 'Percent Space Reclaimable'
 COLUMN number_of_files    FORMAT 999,999    HEADING 'Number of Files'
 SELECT '<div align="center"><font color="#336699"><b>' || name || '</b></font></div>' name , round(space_limit/1048576) space_limit , round(space_used/1048576) space_used , ROUND((space_used / DECODE(space_limit, 0, 0.000001, space_limit))*100, 2) space_used_pct , round(space_reclaimable/1048576) space_reclaimable , ROUND((space_reclaimable / DECODE(space_limit, 0, 0.000001, space_limit))*100, 2) pct_reclaimable , number_of_files
 FROM v$recovery_file_dest
 ORDER BY name;
 SELECT '<div align="center"><font color="#336699"><b>' || file_type || '</b></font></div>' file_type , percent_space_used percent_space_used , percent_space_reclaimable percent_space_reclaimable , number_of_files number_of_files
 FROM v$flash_recovery_area_usage;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    fi

    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Objects</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                          - INVALID OBJECTS -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="invalid_objects"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Invalid Objects</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner       FORMAT a35 HEADING 'Owner'       ENTMAP off
 COLUMN object_name FORMAT a40 HEADING 'Object Name' ENTMAP off
 COLUMN object_type FORMAT a30 HEADING 'Object Type' ENTMAP off
 COLUMN status                 HEADING 'Status'      ENTMAP off
 BREAK ON report ON owner
 COMPUTE count LABEL '<font color="#990000"><b>Grand Total: </b></font>' OF object_name ON report
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || owner || '</b></font></div>' owner , object_name , object_type , DECODE(status , 'VALID', '<div align="center"><font color="darkgreen"><b>' || status || '</b></font></div>', '<div align="center"><font color="#990000"><b>'|| status || '</b></font></div>' ) status
  FROM dba_objects
 WHERE status <> 'VALID'
 ORDER BY owner , object_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                  - OBJECTS IN THE SYSTEM TABLESPACE -                      |
 -- +----------------------------------------------------------------------------+
 prompt <a name="objects_in_the_system_tablespace"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Objects in the SYSTEM Tablespace</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner                               HEADING 'Owner'        ENTMAP off
 COLUMN segment_name    FORMAT a125         HEADING 'Segment Name' ENTMAP off
 COLUMN segment_type                        HEADING 'Type'         ENTMAP off
 COLUMN tablespace_name FORMAT a125         HEADING 'Tablespace'   ENTMAP off
 COLUMN bytes           FORMAT 999,999,999  HEADING 'Byte_MB'      ENTMAP off
 COLUMN extents         FORMAT 999,999,999  HEADING 'Extents'      ENTMAP off
 COLUMN max_extents     FORMAT 999,999,999  HEADING 'Max|Ext'      ENTMAP off
 COLUMN initial_extent  FORMAT 999,999,999  HEADING 'Initial|Ext'  ENTMAP off
 COLUMN next_extent     FORMAT 999,999,999  HEADING 'Next|Ext'     ENTMAP off
 COLUMN pct_increase    FORMAT 999,999,999  HEADING 'Pct|Inc'      ENTMAP off
 BREAK ON report ON owner
 COMPUTE count LABEL '<font color="#990000"><b>Total Count: </b></font>' OF segment_name ON report
 COMPUTE sum   LABEL '<font color="#990000"><b>Total Bytes: </b></font>' OF bytes ON report
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || owner || '</b></font></div>' owner , segment_name , segment_type , tablespace_name , round(bytes/1048576) bytes , extents , initial_extent , next_extent , pct_increase
  FROM dba_segments
 WHERE owner NOT IN ('SYS','SYSTEM') AND tablespace_name = 'SYSTEM'
 ORDER BY owner , segment_name , extents DESC;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |           - TABLES SUFFERING FROM ROW CHAINING/MIGRATION -                 |
 -- +----------------------------------------------------------------------------+
 prompt <a name="tables_suffering_from_row_chaining_migration"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Tables Suffering From Row Chaining/Migration</b></font><hr align="left" width="460"> <b><font color="#990000">NOTE</font>: Tables must have statistics gathered</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner                                   HEADING 'Owner'           ENTMAP off
 COLUMN table_name                              HEADING 'Table Name'      ENTMAP off
 COLUMN partition_name                          HEADING 'Partition Name'  ENTMAP off
 COLUMN num_rows         FORMAT 999,999,999,999 HEADING 'Total Rows'      ENTMAP off
 COLUMN pct_chained_rows FORMAT a65             HEADING '% Chained Rows'  ENTMAP off
 COLUMN avg_row_length   FORMAT 999,999,999,999 HEADING 'Avg Row Length'  ENTMAP off
 SELECT owner owner , table_name table_name , '' partition_name , num_rows num_rows , '<div align="right">' || ROUND((chain_cnt/num_rows)*100, 2) || '%</div>' pct_chained_rows , avg_row_len avg_row_length
  FROM (select owner , table_name , chain_cnt , num_rows , avg_row_len from dba_tables where chain_cnt is not null and num_rows is not null and chain_cnt > 0 and num_rows > 0 and owner != 'SYS')
 UNION ALL
 SELECT table_owner owner , table_name table_name , partition_name partition_name , num_rows num_rows , '<div align="right">' || ROUND((chain_cnt/num_rows)*100, 2) || '%</div>' pct_chained_rows , avg_row_len avg_row_length
  FROM (select table_owner , table_name , partition_name , chain_cnt , num_rows , avg_row_len from dba_tab_partitions where chain_cnt is not null and num_rows is not null and chain_cnt > 0 and num_rows > 0 and table_owner != 'SYS') b
 WHERE (chain_cnt/num_rows)*100 > 10;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                     - TOP 10 SEGMENTS (BY SIZE) -                          |
 -- +----------------------------------------------------------------------------+
 prompt <a name="top_10_segments_by_size"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Top 10 Segments (by size)</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner                       HEADING 'Owner'            ENTMAP off
 COLUMN segment_name                HEADING 'Segment Name'     ENTMAP off
 COLUMN partition_name              HEADING 'Partition Name'   ENTMAP off
 COLUMN segment_type                HEADING 'Segment Type'     ENTMAP off
 COLUMN tablespace_name             HEADING 'Tablespace Name'  ENTMAP off
 COLUMN bytes    FORMAT 999,999,999 HEADING 'Size_MB'          ENTMAP off
 COLUMN extents  FORMAT 999,999,999 HEADING 'Extents'          ENTMAP off
 BREAK ON report
 COMPUTE sum LABEL '<font color="#990000"><b>Total: </b></font>' OF bytes extents ON report
 SELECT a.owner , a.segment_name , a.partition_name , a.segment_type , a.tablespace_name , round(a.bytes/1048576) bytes, a.extents
  FROM (select b.owner , b.segment_name , b.partition_name , b.segment_type , b.tablespace_name , b.bytes , b.extents from dba_segments b order by b.bytes desc ) a
 WHERE rownum < 10;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                         - END OF BASIC REPORT -                            |
 -- +----------------------------------------------------------------------------+
 SPOOL OFF
 prompt Basic Edition Output written to: &FileName._&_spool_time._&versionType..html
EOFSCRIPT
  fi

  # Add Suplement Contents to Scripts
  if [ "${__SNAPSHOT_TYPE}" = "S" ] || [ "${__SNAPSHOT_TYPE}" = "A" ]; then
    cat >> ${__SNAP_SCRIPT} <<EOFSCRIPT
 -- +----------------------------------------------------------------------------+
 -- |                        - do supplement collect -                           |
 -- +----------------------------------------------------------------------------+
 define reportHeader="<font size=+3 color=darkgreen><b>EnmoTech Health Check Report v${SNAPSHOT_VER} (Supplement Edition)</b></font><hr>Copyright (c) 2012-2012 Hongye DBA. All rights reserved. (<a target=""_blank"" href=""http://www.enmotech.com"">www.enmotech.com</a>)<p>"
 define fileName=enmotech_report_v${SNAPSHOT_VER}
 define versionType="Supplement"
 spool &FileName._&_spool_time._&versionType..html
 set markup html on entmap off
 prompt <a name=top></a> &reportHeader

 -- +----------------------------------------------------------------------------+
 -- |                             - REPORT INDEX -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="report_index"></a> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Report Index</b></font><hr align="center" width="250"></center> <table width="90%" border="1"> <tr><th colspan="4">Database and Instance Information</th></tr> <tr> -
EOFSCRIPT

    if [ "${SNAPSHOT_VER}" = "10" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 <td nowrap align="center" width="25%"><a class="link" href="#feature_usage_statistics">Feature Usage Statistics</a></td> <td nowrap align="center" width="25%"><a class="link" href="#high_water_mark_statistics">High Water Mark Statistics</a></td> <td nowrap align="center" width="25%"><a class="link" href="#outstanding_alerts">Outstanding Alerts</a></td> <td nowrap align="center" width="25%"><a class="link" href="#options">Options</a></td> </tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#control_file_records">Control File Records</a></td> <td nowrap align="center" width="25%"><a class="link" href="#statistics_level">Statistics Level</a></td> <td nowrap align="center" width="25%"><a class="link" href="#database_registry">Database Registry</a></td> <td nowrap align="center" width="25%"><a class="link" href="#psu_history">PSU History</a></td> </tr> <tr>
EOFSCRIPT
    else
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 <td nowrap align="center" width="25%"><a class="link" href="#options">Options</a></td> <td nowrap align="center" width="25%"><a class="link" href="#control_file_records">Control File Records</a></td> <td nowrap align="center" width="25%"><a class="link" href="#statistics_level">Statistics Level</a></td> <td nowrap align="center" width="25%"><a class="link" href="#database_registry">Database Registry</a></td> </tr>
EOFSCRIPT
    fi

    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt <tr> <th colspan="4">Scheduler / Jobs</th></tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#jobs">Jobs</a></td> <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> -
 </tr> <tr> <th colspan="4">Storage</th></tr> <tr>  -
 <td nowrap align="center" width="25%"><a class="link" href="#tablespace_extents">Tablespace Extents</a></td> <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> -
 </tr> <tr><th colspan="4">Backups</th> </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#archive_destinations">Archive Destinations</a></td> <td nowrap align="center" width="25%"><a class="link" href="#archiving_history">Archiving History</a></td> <td nowrap align="center" width="25%"><a class="link" href="#archiving_instance_parameters">Archiving Instance Parameters</a></td> <td nowrap align="center" width="25%"><a class="link" href="#archiving_mode">Archiving Mode</a></td> -
 </tr>
EOFSCRIPT

    if [ "${SNAPSHOT_VER}" = "10" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt <tr> <td nowrap align="center" width="25%"><a class="link" href="#rman_backup_jobs">RMAN Backup Jobs</a></td> <td nowrap align="center" width="25%"></td> <td nowrap align="center" width="25%"></td> <td nowrap align="center" width="25%"></td></tr> <tr> <th colspan="4">Flashback Technologies</th></tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#flashback_database_parameters">Flashback Database Parameters</a></td> <td nowrap align="center" width="25%"><a class="link" href="#flashback_database_redo_time_matrix">Flashback Database Redo Time Matrix</a></td> <td nowrap align="center" width="25%"><a class="link" href="#flashback_database_status">Flashback Database Status</a></td> <td nowrap align="center" width="25%"><a class="link" href="#dba_recycle_bin">Recycle Bin</a></td> </tr>
EOFSCRIPT
    fi

    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt <tr><th colspan="4">Performance</th> </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#sga_asmm_dynamic_components">SGA (ASMM) Dynamic Components</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#sga_information">SGA Information</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#sorts">Sorts</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#file_io_statistics">File I/O Statistics</a></td> -
 </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#file_io_timings">File I/O Timings</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#full_table_scans">Full Table Scans</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#sql_statements_with_most_buffer_gets">SQL Statements With Most Buffer Gets</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#sql_statements_with_most_disk_reads">SQL Statements With Most Disk Reads</a></td> -
 </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#average_overall_io_per_sec">Average Overall I/O per Second</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#dba_outline_hints">Outline Hints</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#dba_outlines">Outlines</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#pga_target_advice">PGA Target Advice</a></td> -
 </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#redo_log_contention">Redo Log Contention</a></td>
EOFSCRIPT

    if [ "${SNAPSHOT_VER}" = "10" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt <td nowrap align="center" width="25%"><a class="link" href="#dba_enabled_aggregations">Enabled Aggregations</a></td> <td nowrap align="center" width="25%"><a class="link" href="#dba_enabled_traces">Enabled Traces</a></td> <tr><td nowrap align="center" width="25%"><a class="link" href="#sga_target_advice">SGA Target Advice</a></td></tr> -
 <tr><th colspan="4">Automatic Workload Repository</th></tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#awr_baselines">AWR Baselines</a></td> <td nowrap align="center" width="25%"><a class="link" href="#awr_snapshot_list">AWR Snapshot List</a></td> <td nowrap align="center" width="25%"><a class="link" href="#awr_snapshot_settings">AWR Snapshot Settings</a></td> <td nowrap align="center" width="25%"><a class="link" href="#awr_snapshot_size_estimates">AWR Snapshot Size Estimates</a></td> </tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#awr_workload_repository_information">Workload Repository Information</a></td> <td nowrap align="center" width="25%"></td> <td nowrap align="center" width="25%"></td> <td nowrap align="center" width="25%"></td> </tr> -
EOFSCRIPT
    else
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt <td nowrap align="center" width="25%"></td> <td nowrap align="center" width="25%"></td> <td nowrap align="center" width="25%"></td> </tr> -
EOFSCRIPT
    fi

    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 <tr> <th colspan="4">Sessions</th> </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#current_sessions">Current Sessions</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#user_session_matrix">User Session Matrix</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#high_water">High Water</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> </tr> -
 <tr><th colspan="4">Security</th></tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#users_role">User Roles</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#user_accounts">User Accounts</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#user_obj">User Object Privileges</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#role_obj_privs">Role Object Privileges</td> -
 </tr> <tr>
 prompt <td nowrap align="center" width="25%"><a class="link" href="#roles_user">Role Users</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#role_sys_privs">Role System Privileges</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#sys_user">System Privilege Users</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#user_sys">User System Privileges</a></td> -
 </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#db_links">DB Links</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#default_passwords">Default Passwords</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> </tr> -
 <tr><th colspan="4">Objects</th></tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#dba_collections">Collections</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#dba_directories">Directories</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#dba_directory_privileges">Directory Privileges</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#dba_libraries">Libraries</a></td> -
 </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#dba_lob_segments">LOB Segments</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#dba_type_attributes">Type Attributes</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#dba_type_methods">Type Methods</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#dba_types">Types</a></td> -
 </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#object_summary">Object Summary</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#objects_unable_to_extend">Objects Unable to Extend</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#objects_which_are_nearing_maxextents">Objects Which Are Nearing MAXEXTENTS</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#objects_without_statistics">Objects Without Statistics</a></td> -
 </tr> <tr>
 prompt <td nowrap align="center" width="25%"><a class="link" href="#owner_to_tablespace">Owner to Tablespace</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#procedural_object_errors">Procedural Object Errors</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#segment_summary">Segment Summary</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#top_100_segments_by_extents">Top 100 Segments (by number of extents)</a></td> -
 </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#users_with_default_tablespace_defined_as_system">Users With Default Tablespace (SYSTEM)</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#users_with_default_temporary_tablespace_as_system">Users With Default Temp Tablespace (SYSTEM)</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> -
 </tr> <tr> -
 <th colspan="4">Partitions ( Table and Index)</th></tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#part_index_detail">Partition Index Detail</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#part_index_summary">Partition Index Summary</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#part_table_detail">Partition Table Detail</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#part_table_summary">Partition Table Summary</a></td> -
 </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#list_no_default">List Partition Without Default</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#range_no_maxvalue">Range Partition Without MaxValue</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#global_ind_part_table">Global Indexes on Partition Table</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> -
 </tr> <tr>
 prompt <th colspan="4">Online Analytical Processing - (OLAP)</th></tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#dba_olap_materialized_view_logs">Materialized View Logs</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#dba_olap_materialized_view_refresh_groups">Materialized View Refresh Groups</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#dba_olap_materialized_views">Materialized Views</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> -
 </tr> <tr><th colspan="4">Networking</th> </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#mts_dispatcher_response_queue_wait_stats">MTS Dispatcher Response Queue Wait Stats</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#mts_dispatcher_statistics">MTS Dispatcher Statistics</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#mts_shared_server_wait_statistics">MTS Shared Server Wait Statistics</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> -
 </tr> <tr><th colspan="4">Replication</th> </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#replication_summary">Replication Summary</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#rep_initialization_parameters">Initialization Parameters</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#deferred_transactions">Deferred Transactions</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#administrative_request_jobs">Administrative Request Jobs</a></td> -
 </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#schedule_purge_jobs">(Schedule) Purge Jobs</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#schedule_push_jobs">(Schedule) Push Jobs</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#schedule_refresh_jobs">(Schedule) Refresh Jobs</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#multimaster_master_groups_and_sites">(Multi-Master) Master Groups and Sites</a></td> -
 </tr> <tr>
 prompt <td nowrap align="center" width="25%"><a class="link" href="#multimaster_master_groups">(Multi-Master) Master Groups</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#materialized_view_groups">(Materialized View) Groups</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#materialized_view_master_site_logs">(Materialized View) Master Site Logs</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#materialized_view_master_site_summary">(Materialized View) Master Site Summary</a></td> -
 </tr> <tr> -
 <td nowrap align="center" width="25%"><a class="link" href="#materialized_view_master_site_templates">(Materialized View) Master Site Templates</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#materialized_view_materialized_views">(Materialized View) Materialized Views</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#materialized_view_refresh_groups">(Materialized View) Refresh Groups</a></td> -
 <td nowrap align="center" width="25%"><a class="link" href="#materialized_view_summary">(Materialized View) Summary</a></td> -
 </tr></tr> -
EOFSCRIPT

    if [ "${SNAPSHOT_VER}" = "10" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 <tr><th colspan="4">Data Pump</th></tr> <tr> <td nowrap align="center" width="25%"><a class="link" href="#data_pump_job_progress">Data Pump Job Progress</a></td> <td nowrap align="center" width="25%"><a class="link" href="#data_pump_jobs">Data Pump Jobs</a></td> <td nowrap align="center" width="25%"><a class="link" href="#data_pump_sessions">Data Pump Sessions</a></td>  <td nowrap align="center" width="25%"><a class="link" href="#"></a></td> </tr> -
EOFSCRIPT
    fi

    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 </table><p> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Database and Instance Information</u></b></font></center>
EOFSCRIPT

    if [ "${SNAPSHOT_VER}" = "10" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 -- +----------------------------------------------------------------------------+
 -- |                       - FEATURE USAGE STATISTICS -                         |
 -- +----------------------------------------------------------------------------+
 prompt <a name="feature_usage_statistics"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Feature Usage Statistics</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN feature_name     HEADING 'Feature|Name'
 COLUMN version          HEADING 'Version'
 COLUMN detected_usages  HEADING 'Detected|Usages'
 COLUMN total_samples    HEADING 'Total|Samples'
 COLUMN currently_used   HEADING 'Currently|Used'
 COLUMN first_usage_date HEADING 'First Usage|Date'
 COLUMN last_usage_date  HEADING 'Last Usage|Date'
 COLUMN last_sample_date HEADING 'Last Sample|Date'
 COLUMN next_sample_date HEADING 'Next Sample|Date'
 SELECT '<div align="left"><font color="#336699"><b>' || name || '</b></font></div>' feature_name , DECODE(   detected_usages , 0 , version , '<font color="#663300"><b>' || version || '</b></font>') version , DECODE(   detected_usages , 0 , '<div align="right">' || NVL(TO_CHAR(detected_usages), '<br>') || '</div>', '<div align="right"><font color="#663300"><b>' || NVL(TO_CHAR(detected_usages), '<br>') || '</b></font></div>') detected_usages , DECODE(   detected_usages , 0 , '<div align="right">' || NVL(TO_CHAR(total_samples), '<br>') || '</div>', '<div align="right"><font color="#663300"><b>' || NVL(TO_CHAR(total_samples), '<br>') || '</b></font></div>') total_samples , DECODE(   detected_usages , 0 , '<div align="center">' || NVL(currently_used, '<br>') || '</div>', '<div align="center"><font color="#663300"><b>' || NVL(currently_used, '<br>') || '</b></font></div>') currently_used , DECODE(   detected_usages , 0 , '<div align="right">' || NVL(TO_CHAR(first_usage_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>', '<div align="right"><font color="#663300"><b>' || NVL(TO_CHAR(first_usage_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</b></font></div>') first_usage_date , DECODE(   detected_usages , 0 , '<div align="right">' || NVL(TO_CHAR(last_usage_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>', '<div align="right"><font color="#663300"><b>' || NVL(TO_CHAR(last_usage_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</b></font></div>') last_usage_date , DECODE(   detected_usages , 0 , '<div align="right">' || NVL(TO_CHAR(last_sample_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>', '<div align="right"><font color="#663300"><b>' || NVL(TO_CHAR(last_sample_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</b></font></div>') last_sample_date , DECODE(   detected_usages , 0 , '<div align="right">' || NVL(TO_CHAR((last_sample_date+SAMPLE_INTERVAL/60/60/24), 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>', '<div align="right"><font color="#663300"><b>' || NVL(TO_CHAR((last_sample_date+SAMPLE_INTERVAL/60/60/24), 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</b></font></div>') next_sample_date
 FROM dba_feature_usage_statistics
 ORDER BY name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                      - HIGH WATER MARK STATISTICS -                        |
 -- +----------------------------------------------------------------------------+
 prompt <a name="high_water_mark_statistics"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>High Water Mark Statistics</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN statistic_name FORMAT a115                  HEADING 'Statistic Name'
 COLUMN version        FORMAT a62                   HEADING 'Version'
 COLUMN highwater      FORMAT 9,999,999,999,999,999 HEADING 'Highwater'
 COLUMN last_value     FORMAT 9,999,999,999,999,999 HEADING 'Last Value'
 COLUMN description    FORMAT a120                  HEADING 'Description'
 SELECT '<div align="left"><font color="#336699"><b>' || name || '</b></font></div>'  statistic_name , '<div align="right">' || version || '</div>' version , highwater highwater , last_value last_value , description description
 FROM dba_high_water_mark_statistics
 ORDER BY name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                          - OUTSTANDING ALERTS -                            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="outstanding_alerts"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Outstanding Alerts</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN severity        HEADING 'Severity'        ENTMAP off
 COLUMN target_name     HEADING 'Target Name'     ENTMAP off
 COLUMN target_type     HEADING 'Target Type'     ENTMAP off
 COLUMN category        HEADING 'Category'        ENTMAP off
 COLUMN name            HEADING 'Name'            ENTMAP off
 COLUMN message         HEADING 'Message'         ENTMAP off
 COLUMN alert_triggered HEADING 'Alert Triggered' ENTMAP off
 SELECT DECODE( alert_state , 'Critical', '<div align="center"><b><font color="#990000">' || alert_state || '</font></b></div>', '<div align="center"><b><font color="#336699">' || alert_state || '</font></b></div>')  severity , target_name , (CASE target_type WHEN 'oracle_listener' THEN 'Oracle Listener'WHEN 'rac_database' THEN 'Cluster Database'WHEN 'cluster' THEN 'Clusterware'WHEN 'host' THEN 'Host'WHEN 'osm_instance' THEN 'OSM Instance'WHEN 'oracle_database' THEN 'Database Instance'WHEN 'oracle_emd' THEN 'Oracle EMD'WHEN 'oracle_emrep' THEN 'Oracle EMREP'ELSE target_type END) target_type , metric_label category , column_label name , message message , '<div nowrap align="right">' || TO_CHAR(collection_timestamp, 'yyyy-mm-dd HH24:MI:SS') || '</div>'  alert_triggered
 FROM mgmt$alert_current
 ORDER BY alert_state , collection_timestamp;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    fi

    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 -- +----------------------------------------------------------------------------+
 -- |                                 - OPTIONS -                                |
 -- +----------------------------------------------------------------------------+
 prompt <a name="options"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Options</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN parameter HEADING 'Option Name' ENTMAP off
 COLUMN value     HEADING 'Installed?'  ENTMAP off
 SELECT DECODE( value , 'FALSE', '<b><font color="#336699">' || parameter || '</font></b>', '<b><font color="#336699">' || parameter || '</font></b>') parameter , DECODE(   value , 'FALSE', '<div align="center"><font color="#990000"><b>' || value || '</b></font></div>', '<div align="center">' || value || '</div>' ) value
 FROM v$option
 ORDER BY parameter;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                         - CONTROL FILE RECORDS -                           |
 -- +----------------------------------------------------------------------------+
 prompt <a name="control_file_records"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Control File Records</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN type          FORMAT        a95  HEADING 'Record Section Type'    ENTMAP off
 COLUMN record_size   FORMAT     999,999 HEADING 'Record Size|(in bytes)' ENTMAP off
 COLUMN records_total FORMAT     999,999 HEADING 'Records Allocated'      ENTMAP off
 COLUMN bytes_alloc   FORMAT 999,999,999 HEADING 'Bytes Allocated'        ENTMAP off
 COLUMN records_used  FORMAT     999,999 HEADING 'Records Used'           ENTMAP off
 COLUMN bytes_used    FORMAT 999,999,999 HEADING 'Bytes Used'             ENTMAP off
 COLUMN pct_used      FORMAT        B999 HEADING '% Used'                 ENTMAP off
 COLUMN first_index                      HEADING 'First Index'            ENTMAP off
 COLUMN last_index                       HEADING 'Last Index'             ENTMAP off
 COLUMN last_recid                       HEADING 'Last RecID'             ENTMAP off
 BREAK ON report
 COMPUTE sum LABEL '<font color="#990000"><b>Total: </b></font>'   of record_size records_total bytes_alloc records_used bytes_used ON report
 COMPUTE avg LABEL '<font color="#990000"><b>Average: </b></font>' of pct_used ON report
 SELECT '<div align="left"><font color="#336699"><b>' || type || '</b></font></div>'  type , record_size record_size , records_total records_total , (records_total * record_size) bytes_alloc , records_used records_used , (records_used * record_size) bytes_used , NVL(records_used/records_total * 100, 0) pct_used , first_index first_index , last_index last_index , last_recid last_recid
 FROM v$controlfile_record_section
 ORDER BY type;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                          - STATISTICS LEVEL -                              |
 -- +----------------------------------------------------------------------------+
 prompt <a name="statistics_level"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Statistics Level</b></font><hr align="left" width="460">
 prompt "Automatic Database Management" was first introduced in Oracle10<i>g</i> where the Oracle database
 prompt can now automatically perform many of the routine monitoring and administrative activities that had
 prompt to be manually executed by the DBA in previous versions. Several of the new components that make
 prompt up this new feature include (1) Automatic Workload Repository (2) Automatic Database Diagnostic
 prompt Monitoring (3) Automatic Shared Memory Management and (4) Automatic UNDO Retention Tuning. All
 prompt of these new components can only be enabled when the STATISTICS_LEVEL initialization parameter
 prompt is set to TYPICAL (the default) or ALL. A value of BASIC turns off these components and disables
 prompt all self-tuning capabilities of the database. The view V$STATISTICS_LEVEL shows the statistic
 prompt component, description, and at what level of the STATISTICS_LEVEL parameter the
 prompt component is enabled.
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name_print     FORMAT a95    HEADING 'Instance Name'         ENTMAP off
 COLUMN statistics_name         FORMAT a95    HEADING 'Statistics Name'       ENTMAP off
 COLUMN session_status          FORMAT a95    HEADING 'Session Status'        ENTMAP off
 COLUMN system_status           FORMAT a95    HEADING 'System Status'         ENTMAP off
 COLUMN activation_level        FORMAT a95    HEADING 'Activation Level'      ENTMAP off
 COLUMN statistics_view_name    FORMAT a95    HEADING 'Statistics View Name'  ENTMAP off
 COLUMN session_settable        FORMAT a95    HEADING 'Session Settable?'     ENTMAP off
 BREAK ON report ON instance_name_print
 SELECT '<div align="center"><font color="#336699"><b>' || i.instance_name || '</b></font></div>' instance_name_print , '<div align="left" nowrap>' || s.statistics_name  || '</div>' statistics_name , DECODE( s.session_status , 'ENABLED', '<div align="center"><b><font color="darkgreen">' || s.session_status || '</font></b></div>', '<div align="center"><b><font color="#990000">' || s.session_status || '</font></b></div>') session_status , DECODE(   s.system_status , 'ENABLED', '<div align="center"><b><font color="darkgreen">' || s.system_status || '</font></b></div>', '<div align="center"><b><font color="#990000">' || s.system_status || '</font></b></div>') system_status , (CASE s.activation_level WHEN 'TYPICAL' THEN '<div align="center"><b><font color="darkgreen">' || s.activation_level || '</font></b></div>'WHEN 'ALL' THEN '<div align="center"><b><font color="darkblue">'  || s.activation_level || '</font></b></div>'WHEN 'BASIC' THEN '<div align="center"><b><font color="#990000">' || s.activation_level || '</font></b></div>'ELSE '<div align="center"><b><font color="#663300">'   || s.activation_level || '</font></b></div>'END) activation_level , s.statistics_view_name statistics_view_name , '<div align="center">' || s.session_settable || '</div>' session_settable
 FROM gv$statistics_level s , gv$instance  i
 WHERE s.inst_id = i.inst_id
 ORDER BY i.instance_name , s.statistics_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                         - DATABASE REGISTRY -                              |
 -- +----------------------------------------------------------------------------+
 prompt <a name="database_registry"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Database Registry</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN comp_id    HEADING 'Component ID'   ENTMAP off
 COLUMN comp_name  HEADING 'Component Name' ENTMAP off
 COLUMN version    HEADING 'Version'        ENTMAP off
 COLUMN status     HEADING 'Status'         ENTMAP off
 COLUMN modified   HEADING 'Modified'       ENTMAP off
 COLUMN control    HEADING 'Control'        ENTMAP off
 COLUMN schema     HEADING 'Schema'         ENTMAP off
 COLUMN procedure  HEADING 'Procedure'      ENTMAP off
 SELECT '<font color="#336699"><b>' || comp_id || '</b></font>' comp_id , '<div nowrap>' || comp_name || '</div>' comp_name , version , DECODE( status , 'VALID',   '<div align="center"><b><font color="darkgreen">' || status || '</font></b></div>', 'INVALID', '<div align="center"><b><font color="#990000">' || status || '</font></b></div>', '<div align="center"><b><font color="#663300">' || status || '</font></b></div>' ) status , '<div nowrap align="right">' || modified || '</div>' modified , control , schema , procedure
 FROM dba_registry
 ORDER BY comp_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    if [ "${SNAPSHOT_VER}" = "10" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"

 -- +----------------------------------------------------------------------------+
 -- |                              - PSU History -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="psu_history"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>PSU History</b></font><hr align="left" width="460">
 prompt "PSU History" record database registry history
 CLEAR COLUMNS BREAKS COMPUTES
 column ACTION_TIME HEADING 'Action Time' ENTMAP off
 column ACTION      HEADING 'Action'      ENTMAP off
 column NAMESPACE   HEADING 'Namespace'   ENTMAP off
 column VERSION     HEADING 'Version'     ENTMAP off
 column ID          HEADING 'ID'          ENTMAP off
 column COMMENTS    HEADING 'Comments'    ENTMAP off
 SELECT ACTION_TIME , ACTION , '<div align="center"><font color="#336699"><b>' || id || '</b></font></div>'  id , Namespace , '<font color=darkred><b>' || version ||'</b></font>' version , Comments
 from dba_registry_history;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    fi
    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Scheduler / Jobs</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                                 - JOBS -                                   |
 -- +----------------------------------------------------------------------------+
 prompt <a name="jobs"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Jobs</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN job_id                HEADING 'Job ID'        ENTMAP off
 COLUMN username              HEADING 'User'          ENTMAP off
 COLUMN what      FORMAT a175 HEADING 'What'          ENTMAP off
 COLUMN next_date FORMAT a110 HEADING 'Next Run Date' ENTMAP off
 COLUMN interval              HEADING 'Interval'      ENTMAP off
 COLUMN last_date FORMAT a110 HEADING 'Last Run Date' ENTMAP off
 COLUMN failures              HEADING 'Failures'      ENTMAP off
 COLUMN broken                HEADING 'Broken?'       ENTMAP off
 SELECT DECODE(   broken , 'Y', '<b><font color="#990000"><div align="center">' || job || '</div></font></b>', '<b><font color="#336699"><div align="center">' || job || '</div></font></b>') job_id , DECODE(   broken , 'Y', '<b><font color="#990000">' || log_user || '</font></b>', log_user ) username , DECODE(   broken , 'Y', '<b><font color="#990000">' || what || '</font></b>', what ) what , DECODE(   broken , 'Y', '<div nowrap align="right"><b><font color="#990000">' || NVL(TO_CHAR(next_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</font></b></div>', '<div nowrap align="right">' || NVL(TO_CHAR(next_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>') next_date , DECODE(   broken , 'Y', '<b><font color="#990000">' || interval || '</font></b>', interval ) interval , DECODE(   broken , 'Y', '<div nowrap align="right"><b><font color="#990000">' || NVL(TO_CHAR(last_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</font></b></div>', '<div nowrap align="right">' || NVL(TO_CHAR(last_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>') last_date , DECODE(   broken , 'Y', '<b><font color="#990000"><div align="center">' || NVL(failures, 0) || '</div></font></b>', '<div align="center">' || NVL(failures, 0) || '</div>') failures , DECODE(   broken , 'Y', '<b><font color="#990000"><div align="center">' || broken || '</div></font></b>', '<div align="center">' || broken || '</div>') broken
 FROM dba_jobs
 ORDER BY job;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Storage</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                        - TABLESPACE EXTENTS -                              |
 -- +----------------------------------------------------------------------------+
 prompt <a name="tablespace_extents"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Tablespace Extents</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN tablespace_name                 HEADING 'Tablespace Name'         ENTMAP off
 COLUMN largest_ext  FORMAT 999,999,999 HEADING 'Largest Extent/MB'       ENTMAP off
 COLUMN smallest_ext FORMAT 999,999,999 HEADING 'Smallest Extent/MB'      ENTMAP off
 COLUMN total_free   FORMAT 999,999,999 HEADING 'Total Free/MB'           ENTMAP off
 COLUMN pieces       FORMAT 999,999,999 HEADING 'Number of Free Extents'  ENTMAP off
 break on report
 compute sum label '<font color="#990000"><b>Total:</b></font>' of largest_ext smallest_ext total_free pieces on report
 SELECT '<b><font color="#336699">'||tablespace_name||'</font></b>' tablespace_name , round(max(bytes)/1048576) largest_ext , round(min(bytes)/1048576) smallest_ext , round(sum(bytes)/1048576) total_free , count(*) pieces
 FROM dba_free_space
 GROUP BY tablespace_name
 ORDER BY tablespace_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Backups</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                         - ARCHIVE DESTINATIONS -                           |
 -- +----------------------------------------------------------------------------+
 prompt <a name="archive_destinations"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Archive Destinations</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN dest_id                             HEADING 'Destination|ID'       ENTMAP off
 COLUMN dest_name                           HEADING 'Destination|Name'     ENTMAP off
 COLUMN destination                         HEADING 'Destination'          ENTMAP off
 COLUMN status                              HEADING 'Status'               ENTMAP off
 COLUMN schedule                            HEADING 'Schedule'             ENTMAP off
 COLUMN archiver                            HEADING 'Archiver'             ENTMAP off
 COLUMN log_sequence FORMAT 999999999999999 HEADING 'Current Log|Sequence' ENTMAP off
 SELECT '<div align="center"><font color="#336699"><b>' || a.dest_id || '</b></font></div>'    dest_id , a.dest_name dest_name , a.destination destination , DECODE(   a.status , 'VALID', '<div align="center"><b><font color="darkgreen">' || status || '</font></b></div>', 'INACTIVE', '<div align="center"><b><font color="#990000">'   || status || '</font></b></div>', '<div align="center"><b><font color="#663300">'   || status || '</font></b></div>' ) status , DECODE(   a.schedule , 'ACTIVE',   '<div align="center"><b><font color="darkgreen">' || schedule || '</font></b></div>', 'INACTIVE', '<div align="center"><b><font color="#990000">'   || schedule || '</font></b></div>', '<div align="center"><b><font color="#663300">'   || schedule || '</font></b></div>' ) schedule , a.archiver archiver , a.log_sequence log_sequence
 FROM v$archive_dest a
 ORDER BY a.dest_id;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - ARCHIVING HISTORY -                            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="archiving_history"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Archiving History</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN thread#   FORMAT a79         HEADING 'Thread#'         ENTMAP off
 COLUMN sequence# FORMAT a79         HEADING 'Sequence#'       ENTMAP off
 COLUMN name                         HEADING 'Name'            ENTMAP off
 COLUMN first_change#                HEADING 'First|Change #'  ENTMAP off
 COLUMN first_time                   HEADING 'First|Time'      ENTMAP off
 COLUMN next_change#                 HEADING 'Next|Change #'   ENTMAP off
 COLUMN next_time                    HEADING 'Next|Time'       ENTMAP off
 COLUMN log_size  FORMAT 999,999,999 HEADING 'Size (in bytes)' ENTMAP off
 COLUMN archived  FORMAT a31         HEADING 'Archived?'       ENTMAP off
 COLUMN applied   FORMAT a31         HEADING 'Applied?'        ENTMAP off
 COLUMN deleted   FORMAT a31         HEADING 'Deleted?'        ENTMAP off
 COLUMN status                       HEADING 'Status'          ENTMAP off
 BREAK ON report ON thread#
 SELECT '<div align="center"><b><font color="#336699">'||thread#||'</font></b></div>' thread#, '<div align="center"><b><font color="#336699">'||sequence#||'</font></b></div>'  sequence# , name , first_change# , '<div align="right" nowrap>' || TO_CHAR(first_time, 'yyyy-mm-dd HH24:MI:SS') || '</div>' first_time , next_change# , '<div align="right" nowrap>' || TO_CHAR(next_time, 'yyyy-mm-dd HH24:MI:SS')  || '</div>' next_time , round((blocks * block_size)/1048576) log_size , '<div align="center">' || archived || '</div>'  archived , '<div align="center">' || applied  || '</div>'  applied , '<div align="center">' || deleted  || '</div>'  deleted , DECODE(   status , 'A', '<div align="center"><b><font color="darkgreen">Available</font></b></div>', 'D', '<div align="center"><b><font color="#663300">Deleted</font></b></div>', 'U', '<div align="center"><b><font color="#990000">Unavailable</font></b></div>', 'X', '<div align="center"><b><font color="#990000">Expired</font></b></div>') status
 FROM v$archived_log
 WHERE status in ('A')
 ORDER BY thread# , sequence#;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                    - ARCHIVING INSTANCE PARAMETERS -                       |
 -- +----------------------------------------------------------------------------+
 prompt <a name="archiving_instance_parameters"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Archiving Instance Parameters</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN name  HEADING 'Parameter Name'   ENTMAP off
 COLUMN value HEADING 'Parameter Value'  ENTMAP off
 SELECT '<b><font color="#336699">' || a.name || '</font></b>' name , a.value value
 FROM v$parameter a
 WHERE a.name like 'log_%'
 ORDER BY a.name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                             - ARCHIVING MODE -                             |
 -- +----------------------------------------------------------------------------+
 prompt <a name="archiving_mode"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Archiving Mode</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN db_log_mode                                       HEADING 'Database|Log Mode'           ENTMAP off
 COLUMN log_archive_start                                 HEADING 'Automatic|Archival'          ENTMAP off
 COLUMN oldest_online_log_sequence FORMAT 999999999999999 HEADING 'Oldest Online |Log Sequence' ENTMAP off
 COLUMN current_log_seq            FORMAT 999999999999999 HEADING 'Current |Log Sequence'       ENTMAP off
 SELECT '<div align="center"><font color="#663300"><b>' || d.log_mode || '</b></font></div>' db_log_mode , '<div align="center"><font color="#663300"><b>' || p.log_archive_start  || '</b></font></div>' log_archive_start , c.current_log_seq current_log_seq , o.oldest_online_log_sequence oldest_online_log_sequence
 FROM (select DECODE(   log_mode , 'ARCHIVELOG', 'Archive Mode', 'NOARCHIVELOG', 'No Archive Mode', log_mode )   log_mode from v$database ) d , (select DECODE(   log_mode , 'ARCHIVELOG', 'Enabled', 'NOARCHIVELOG', 'Disabled')   log_archive_start from v$database ) p , (select a.sequence#   current_log_seq from   v$log a where  a.status = 'CURRENT'and thread# = &_thread_number ) c , (select min(a.sequence#) oldest_online_log_sequence from   v$log a where  thread# = &_thread_number ) o;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    if [ "${SNAPSHOT_VER}" = "10" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"

 -- +----------------------------------------------------------------------------+
 -- |                           - RMAN BACKUP JOBS -                             |
 -- +----------------------------------------------------------------------------+
 prompt <a name="rman_backup_jobs"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>RMAN Backup Jobs</b></font><hr align="left" width="460">
 prompt <b>Last 10 RMAN backup jobs</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN backup_name FORMAT a100 HEADING 'Backup Name'         ENTMAP off
 COLUMN start_time              HEADING 'Start Time'          ENTMAP off
 COLUMN elapsed_time            HEADING 'Elapsed Time'        ENTMAP off
 COLUMN status                  HEADING 'Status'              ENTMAP off
 COLUMN input_type              HEADING 'Input Type'          ENTMAP off
 COLUMN output_device_type      HEADING 'Output Devices'      ENTMAP off
 COLUMN input_size              HEADING 'Input Size'          ENTMAP off
 COLUMN output_size             HEADING 'Output Size'         ENTMAP off
 COLUMN output_rate_per_sec     HEADING 'Output Rate Per Sec' ENTMAP off
 SELECT '<div nowrap><b><font color="#336699">' || r.command_id || '</font></b></div>'  backup_name , '<div nowrap align="right">' || TO_CHAR(r.start_time, 'yyyy-mm-dd HH24:MI:SS') || '</div>' start_time , '<div nowrap align="right">' || r.time_taken_display || '</div>' elapsed_time , DECODE( r.status , 'COMPLETED', '<div align="center"><b><font color="darkgreen">' || r.status || '</font></b></div>', 'RUNNING', '<div align="center"><b><font color="#000099">' || r.status || '</font></b></div>', 'FAILED', '<div align="center"><b><font color="#990000">' || r.status || '</font></b></div>', '<div align="center"><b><font color="#663300">' || r.status || '</font></b></div>') status , r.input_type input_type , r.output_device_type output_device_type , '<div nowrap align="right">' || r.input_bytes_display || '</div>'  input_size , '<div nowrap align="right">' || r.output_bytes_display || '</div>'  output_size , '<div nowrap align="right">' || r.output_bytes_per_sec_display  || '</div>'  output_rate_per_sec
 FROM (select command_id , start_time , time_taken_display , status , input_type , output_device_type , input_bytes_display , output_bytes_display , output_bytes_per_sec_display from v$rman_backup_job_details order by start_time DESC ) r
 WHERE rownum < 11;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
 <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Flashback Technologies</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                     - FLASHBACK DATABASE PARAMETERS -                      |
 -- +----------------------------------------------------------------------------+
 prompt <a name="flashback_database_parameters"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Flashback Database Parameters</b></font><hr align="left" width="460">
 prompt <b>db_flashback_retention_target is specified in minutes</b>
 prompt <b>db_recovery_file_dest_size is specified in bytes</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name_print FORMAT a95  HEADING 'Instance Name' ENTMAP off
 COLUMN thread_number_print FORMAT a95  HEADING 'Thread Number' ENTMAP off
 COLUMN name                FORMAT a125 HEADING 'Name'          ENTMAP off
 COLUMN value                           HEADING 'Value'         ENTMAP off
 BREAK ON report ON instance_name_print ON thread_number_print
 SELECT '<div align="center"><font color="#336699"><b>' || i.instance_name || '</b></font></div>' instance_name_print , '<div align="center">' || i.thread# || '</div>' thread_number_print , '<div nowrap>' || p.name || '</div>' name , (CASE p.name WHEN 'db_recovery_file_dest_size' THEN '<div nowrap align="right">' || TO_CHAR(p.value, '999,999,999,999,999') || '</div>'WHEN 'db_flashback_retention_target' THEN '<div nowrap align="right">' || TO_CHAR(p.value, '999,999,999,999,999') || '</div>'ELSE '<div nowrap align="right">' || NVL(p.value, '(null)') || '</div>'END) value
 FROM gv$parameter p , gv$instance  i
 WHERE p.inst_id = i.inst_id AND p.name IN ('db_flashback_retention_target', 'db_recovery_file_dest_size', 'db_recovery_file_dest')
 ORDER BY 1 , 3;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                  - FLASHBACK DATABASE REDO TIME MATRIX -                   |
 -- +----------------------------------------------------------------------------+
 prompt <a name="flashback_database_redo_time_matrix"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Flashback Database Redo Time Matrix</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN begin_time                      HEADING 'Begin Time'               ENTMAP off
 COLUMN end_time                        HEADING 'End Time'                 ENTMAP off
 COLUMN flashback_data FORMAT 9,999,999 HEADING 'Flashback Data'           ENTMAP off
 COLUMN db_data        FORMAT 9,999,999 HEADING 'DB Data'                  ENTMAP off
 COLUMN redo_data      FORMAT 9,999,999 HEADING 'Redo Data'                ENTMAP off
 COLUMN estimated_size FORMAT 9,999,999 HEADING 'Estimated Flashback Size' ENTMAP off
 SELECT '<div align="right">' || TO_CHAR(begin_time,'yyyy-mm-dd HH24:MI:SS') || '</div>'  begin_time , '<div align="right">' || TO_CHAR(end_time,'yyyy-mm-dd HH24:MI:SS') || '</div>' end_time , round(flashback_data/1048576) flashback_data, round(db_data/1048576) db_data, round(redo_data/1048576) redo_data, round(estimated_flashback_size/1048576) estimated_size
 FROM v$flashback_database_stat
 ORDER BY begin_time;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                       - FLASHBACK DATABASE STATUS -                        |
 -- +----------------------------------------------------------------------------+
 prompt <a name="flashback_database_status"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Flashback Database Status</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN dbid                                      HEADING 'DB ID'                     ENTMAP off
 COLUMN name                                      HEADING 'DB Name'                   ENTMAP off
 COLUMN log_mode                                  HEADING 'Log Mode'                  ENTMAP off
 COLUMN flashback_on                              HEADING 'Flashback DB On?'          ENTMAP off
 COLUMN oldest_flashback_time    FORMAT a125      HEADING 'Oldest Flashback Time'     ENTMAP off
 COLUMN oldest_flashback_scn                      HEADING 'Oldest Flashback SCN'      ENTMAP off
 COLUMN retention_target         FORMAT 999,999   HEADING 'Retention Target (min)'    ENTMAP off
 COLUMN retention_target_hours   FORMAT 999,999   HEADING 'Retention Target (hour)'   ENTMAP off
 COLUMN flashback_size           FORMAT 9,999,999 HEADING 'Flashback Size'            ENTMAP off
 COLUMN estimated_flashback_size FORMAT 9,999,999 HEADING 'Estimated Flashback Size'  ENTMAP off
 SELECT '<div align="center"><font color="#336699"><b>' || dbid || '</b></font></div>'  dbid , '<div align="center">' || name || '</div>' name , '<div align="center">' || log_mode || '</div>' log_mode , '<div align="center">' || flashback_on  || '</div>' flashback_on
 FROM v$database;
 SELECT '<div align="center"><font color="#336699"><b>' || TO_CHAR(oldest_flashback_time,'yyyy-mm-dd HH24:MI:SS') || '</b></font></div>'  oldest_flashback_time , oldest_flashback_scn oldest_flashback_scn , retention_target retention_target , retention_target/60 retention_target_hours , round(flashback_size/1048576) flashback_size, round(estimated_flashback_size/1048576) estimated_size
 FROM v$flashback_database_log
 ORDER BY 1;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                              - RECYCLE BIN -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_recycle_bin"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Recycle Bin</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner   FORMAT a85        HEADING 'Owner'         ENTMAP off
 COLUMN original_name             HEADING 'Original|Name' ENTMAP off
 COLUMN type                      HEADING 'Object|Type'   ENTMAP off
 COLUMN object_name               HEADING 'Object|Name'   ENTMAP off
 COLUMN ts_name                   HEADING 'Tablespace'    ENTMAP off
 COLUMN operation                 HEADING 'Operation'     ENTMAP off
 COLUMN createtime                HEADING 'Create|Time'   ENTMAP off
 COLUMN droptime                  HEADING 'Drop|Time'     ENTMAP off
 COLUMN can_undrop                HEADING 'Can|Undrop?'   ENTMAP off
 COLUMN can_purge                 HEADING 'Can|Purge?'    ENTMAP off
 COLUMN bytes  FORMAT 999,999,999 HEADING 'Size/MB'       ENTMAP off
 BREAK ON report ON owner
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || owner || '</b></font></div>' owner , original_name , type , object_name , ts_name , operation , '<div nowrap align="right">' || NVL(createtime, '<br>') || '</div>' createtime , '<div nowrap align="right">' || NVL(droptime, '<br>')   || '</div>' droptime , DECODE(   can_undrop , null , '<BR>', 'YES', '<div align="center"><font color="darkgreen"><b>' || can_undrop || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>' || can_undrop || '</b></font></div>', '<div align="center"><font color="#663300"><b>' || can_undrop || '</b></font></div>') can_undrop , DECODE( can_purge , null , '<BR>', 'YES', '<div align="center"><font color="darkgreen"><b>' || can_purge || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>' || can_purge || '</b></font></div>', '<div align="center"><font color="#663300"><b>' || can_purge || '</b></font></div>') can_purge , round((space * p.blocksize)/1048576) bytes
 FROM dba_recyclebin r , (SELECT value blocksize FROM v$parameter WHERE name='db_block_size') p
 ORDER BY owner , object_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Performance</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                      - SGA (ASMM) DYNAMIC COMPONENTS -                     |
 -- +----------------------------------------------------------------------------+
 prompt <a name="sga_asmm_dynamic_components"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>SGA (ASMM) Dynamic Components</b></font><hr align="left" width="460">
 prompt Provides a summary report of all dynamic components as part of the Automatic Shared Memory
 prompt Management (ASMM) configuration. This will display the total real memory allocation for the current
 prompt SGA from the V$SGA_DYNAMIC_COMPONENTS view, which contains both manual and autotuned SGA components.
 prompt As with the other manageability features of Oracle Database 10g, ASMM requires you to set the
 prompt STATISTICS_LEVEL parameter to at least TYPICAL (the default) before attempting to enable ASMM. ASMM
 prompt can be enabled by setting SGA_TARGET to a nonzero value in the initialization parameter file (pfile/spfile).
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name       FORMAT a79             HEADING 'Instance Name'       ENTMAP off
 COLUMN component           FORMAT a79             HEADING 'Component Name'      ENTMAP off
 COLUMN current_size        FORMAT 999,999,999,999 HEADING 'Current Size'        ENTMAP off
 COLUMN min_size            FORMAT 999,999,999,999 HEADING 'Min Size'            ENTMAP off
 COLUMN max_size            FORMAT 999,999,999,999 HEADING 'Max Size'            ENTMAP off
 COLUMN user_specified_size FORMAT 999,999,999,999 HEADING 'User Specified|Size' ENTMAP off
 COLUMN oper_count          FORMAT 999,999,999,999 HEADING 'Oper.|Count'         ENTMAP off
 COLUMN last_oper_type                             HEADING 'Last Oper.|Type'     ENTMAP off
 COLUMN last_oper_mode                             HEADING 'Last Oper.|Mode'     ENTMAP off
 COLUMN last_oper_time                             HEADING 'Last Oper.|Time'     ENTMAP off
 COLUMN granule_size        FORMAT 999,999,999,999 HEADING 'Granule Size'        ENTMAP off
 BREAK ON report ON instance_name
 SELECT '<div align="left"><font color="#336699"><b>' || i.instance_name || '</b></font></div>'  instance_name , sdc.component , sdc.current_size , sdc.min_size , sdc.max_size , sdc.user_specified_size , sdc.oper_count , sdc.last_oper_type , sdc.last_oper_mode , '<div align="right">' || NVL(TO_CHAR(sdc.last_oper_time, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>' last_oper_time , sdc.granule_size
 FROM gv$sga_dynamic_components sdc , gv$instance  i
 ORDER BY i.instance_name , sdc.component DESC;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    else
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Performance</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                      - SGA (ASMM) DYNAMIC COMPONENTS -                     |
 -- +----------------------------------------------------------------------------+
 prompt <a name="sga_asmm_dynamic_components"></a>
 prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>SGA (ASMM) Dynamic Components</b></font><hr align="left" width="460">
 prompt Provides a summary report of all dynamic components as part of the Automatic Shared Memory
 prompt Management (ASMM) configuration. This will display the total real memory allocation for the current
 prompt SGA from the V$SGA_DYNAMIC_COMPONENTS view, which contains both manual and autotuned SGA components.
 prompt As with the other manageability features of Oracle Database 10g, ASMM requires you to set the
 prompt STATISTICS_LEVEL parameter to at least TYPICAL (the default) before attempting to enable ASMM. ASMM
 prompt can be enabled by setting SGA_TARGET to a nonzero value in the initialization parameter file (pfile/spfile).
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name  FORMAT a79         HEADING 'Instance Name'   ENTMAP off
 COLUMN component      FORMAT a79         HEADING 'Component Name'  ENTMAP off
 COLUMN current_size   FORMAT 999,999,999 HEADING 'Current Size/MB' ENTMAP off
 COLUMN min_size       FORMAT 999,999,999 HEADING 'Min Size/MB'     ENTMAP off
 COLUMN max_size       FORMAT 999,999,999 HEADING 'Max Size/MB'     ENTMAP off
 COLUMN oper_count     FORMAT 999,999,999 HEADING 'Oper.|Count'     ENTMAP off
 COLUMN last_oper_type                    HEADING 'Last Oper.|Type' ENTMAP off
 COLUMN last_oper_mode                    HEADING 'Last Oper.|Mode' ENTMAP off
 COLUMN last_oper_time                    HEADING 'Last Oper.|Time' ENTMAP off
 COLUMN granule_size   FORMAT 999,999     HEADING 'Granule Size/MB' ENTMAP off
 BREAK ON report ON instance_name
 SELECT '<div align="left"><font color="#336699"><b>' || i.instance_name || '</b></font></div>'  instance_name , sdc.component , round(sdc.current_size/1048576) current_size, round(sdc.min_size/1048576) min_size, round(sdc.max_size/1048576) max_size, sdc.oper_count , sdc.last_oper_type , sdc.last_oper_mode , '<div align="right">' || NVL(TO_CHAR(sdc.last_oper_time, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>'   last_oper_time , round(sdc.granule_size/1048576) granule_size
 FROM gv$sga_dynamic_components sdc , gv$instance  i
 ORDER BY i.instance_name , sdc.component DESC;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    fi
    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"

 -- +----------------------------------------------------------------------------+
 -- |                             - SGA INFORMATION -                            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="sga_information"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>SGA Information</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name FORMAT a79         HEADING 'Instance Name' ENTMAP off
 COLUMN name          FORMAT a150        HEADING 'Pool Name'     ENTMAP off
 COLUMN value         FORMAT 999,999,999 HEADING 'Bytes/MB'      ENTMAP off
 BREAK ON report ON instance_name
 COMPUTE sum LABEL '<font color="#990000"><b>Total:</b></font>' OF value ON instance_name
 SELECT '<div align="left"><font color="#336699"><b>' || i.instance_name || '</b></font></div>'  instance_name , '<div align="left"><font color="#336699"><b>' || s.name || '</b></font></div>'  name , round(s.value/1048576) value
 FROM gv$sga s , gv$instance  i
 WHERE s.inst_id = i.inst_id
 ORDER BY i.instance_name , s.value DESC;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                                - SORTS -                                   |
 -- +----------------------------------------------------------------------------+
 prompt <a name="sorts"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Sorts</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN disk_sorts     FORMAT 999,999,999,999,999 HEADING 'Disk Sorts'       ENTMAP off
 COLUMN memory_sorts   FORMAT 999,999,999,999,999 HEADING 'Memory Sorts'     ENTMAP off
 COLUMN pct_disk_sorts                            HEADING 'Pct. Disk Sorts'  ENTMAP off
 SELECT a.value disk_sorts , b.value memory_sorts , '<div align="right">' || ROUND(100*a.value/DECODE((a.value+b.value),0,1,(a.value+b.value)),2) || '%</div>' pct_disk_sorts
 FROM v$sysstat  a , v$sysstat  b
 WHERE a.name = 'sorts (disk)'AND b.name = 'sorts (memory)';
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                         - FILE I/O STATISTICS -                            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="file_io_statistics"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>File I/O Statistics</b></font><hr align="left" width="460">
 prompt <b>Ordered by "Physical Reads" since last startup of the Oracle instance</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN tablespace_name   FORMAT a50           HEAD 'Tablespace'       ENTMAP off
 COLUMN fname                                  HEAD 'File Name'        ENTMAP off
 COLUMN phyrds    FORMAT 999,999,999,999,999   HEAD 'Physical Reads'   ENTMAP off
 COLUMN phywrts   FORMAT 999,999,999,999,999   HEAD 'Physical Writes'  ENTMAP off
 COLUMN read_pct                               HEAD 'Read Pct.'        ENTMAP off
 COLUMN write_pct                              HEAD 'Write Pct.'       ENTMAP off
 COLUMN total_io  FORMAT 999,999,999,999,999   HEAD 'Total I/O'        ENTMAP off
 BREAK ON report
 COMPUTE sum LABEL '<font color="#990000"><b>Total: </b></font>' OF phyrds phywrts total_io ON report
 SELECT '<font color="#336699"><b>' || df.tablespace_name || '</b></font>' tablespace_name , df.file_name fname , fs.phyrds phyrds , '<div align="right">' || ROUND((fs.phyrds * 100) / (fst.pr + tst.pr), 2) || '%</div>' read_pct , fs.phywrts phywrts , '<div align="right">' || ROUND((fs.phywrts * 100) / (fst.pw + tst.pw), 2) || '%</div>' write_pct , (fs.phyrds + fs.phywrts) total_io
 FROM dba_data_files df , v$filestat fs , (select sum(f.phyrds) pr, sum(f.phywrts) pw from v$filestat f) fst , (select sum(t.phyrds) pr, sum(t.phywrts) pw from v$tempstat t) tst
 WHERE df.file_id = fs.file#
 UNION all
 SELECT '<font color="#336699"><b>' || tf.tablespace_name || '</b></font>' tablespace_name , tf.file_name fname , ts.phyrds phyrds , '<div align="right">' || ROUND((ts.phyrds * 100) / (fst.pr + tst.pr), 2) || '%</div>'  read_pct , ts.phywrts phywrts , '<div align="right">' || ROUND((ts.phywrts * 100) / (fst.pw + tst.pw), 2) || '%</div>' write_pct , (ts.phyrds + ts.phywrts) total_io
 FROM dba_temp_files  tf , v$tempstat ts , (select sum(f.phyrds) pr, sum(f.phywrts) pw from v$filestat f) fst , (select sum(t.phyrds) pr, sum(t.phywrts) pw from v$tempstat t) tst
 WHERE tf.file_id = ts.file#
 ORDER BY phyrds DESC;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - FILE I/O TIMINGS -                             |
 -- +----------------------------------------------------------------------------+
 prompt <a name="file_io_timings"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>File I/O Timings</b></font><hr align="left" width="460">
 prompt <b>Average time (in milliseconds) for an I/O call per datafile since last startup of the Oracle instance - (ordered by Physical Reads)</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN fname                                    HEAD 'File Name'                                      ENTMAP off
 COLUMN phyrds     FORMAT 999,999,999,999,999    HEAD 'Physical Reads'                                 ENTMAP off
 COLUMN read_rate  FORMAT 999,999,999,999,999.99 HEAD 'Average Read Time<br>(milliseconds per read)'   ENTMAP off
 COLUMN phywrts    FORMAT 999,999,999,999,999    HEAD 'Physical Writes'                                ENTMAP off
 COLUMN write_rate FORMAT 999,999,999,999,999.99 HEAD 'Average Write Time<br>(milliseconds per write)' ENTMAP off
 BREAK ON REPORT
 COMPUTE sum LABEL '<font color="#990000"><b>Total: </b></font>' OF phyrds phywrts ON report
 COMPUTE avg LABEL '<font color="#990000"><b>Average: </b></font>' OF read_rate write_rate ON report
 SELECT '<b><font color="#336699">' || d.name || '</font></b>'  fname , s.phyrds phyrds , ROUND((s.readtim/GREATEST(s.phyrds,1)), 2)   read_rate , s.phywrts phywrts , ROUND((s.writetim/GREATEST(s.phywrts,1)),2)  write_rate
 FROM v$filestat  s , v$datafile  d
 WHERE s.file# = d.file#
 UNION all
 SELECT '<b><font color="#336699">' || t.name || '</font></b>'  fname , s.phyrds phyrds , ROUND((s.readtim/GREATEST(s.phyrds,1)), 2)   read_rate , s.phywrts phywrts , ROUND((s.writetim/GREATEST(s.phywrts,1)),2)  write_rate
 FROM v$tempstat  s , v$tempfile  t
 WHERE s.file# = t.file#
 ORDER BY 2 DESC;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - FULL TABLE SCANS -                             |
 -- +----------------------------------------------------------------------------+
 prompt <a name="full_table_scans"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Full Table Scans</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN large_table_scans   FORMAT 999,999,999,999,999  HEADING 'Large Table Scans'   ENTMAP off
 COLUMN small_table_scans   FORMAT 999,999,999,999,999  HEADING 'Small Table Scans'   ENTMAP off
 COLUMN pct_large_scans                                 HEADING 'Pct. Large Scans'    ENTMAP off
 SELECT a.value large_table_scans , b.value small_table_scans , '<div align="right">' || ROUND(100*a.value/DECODE((a.value+b.value),0,1,(a.value+b.value)),2) || '%</div>' pct_large_scans
 FROM v$sysstat  a , v$sysstat  b
 WHERE a.name = 'table scans (long tables)'AND b.name = 'table scans (short tables)';
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    if [ "${SNAPSHOT_VER}" = "10" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"

 -- +----------------------------------------------------------------------------+
 -- |                - SQL STATEMENTS WITH MOST BUFFER GETS -                    |
 -- +----------------------------------------------------------------------------+
 prompt <a name="sql_statements_with_most_buffer_gets"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>SQL Statements With Most Buffer Gets</b></font><hr align="left" width="460">
 prompt <b>Top 100 SQL statements with buffer gets greater than 1000</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN sql_id                                   HEADING 'SQL ID'            ENTMAP off
 COLUMN username                                 HEADING 'Username'          ENTMAP off
 COLUMN buffer_gets   FORMAT 999,999,999,999,999 HEADING 'Buffer Gets'       ENTMAP off
 COLUMN executions    FORMAT 999,999,999,999,999 HEADING 'Executions'        ENTMAP off
 COLUMN gets_per_exec FORMAT 999,999,999,999,999 HEADING 'Buffer Gets/Exec'  ENTMAP off
 COLUMN sql_text                                 HEADING 'SQL Text'          ENTMAP off
 SELECT a.sql_id sql_id , '<font color="#336699"><b>' || UPPER(b.username) || '</b></font>' username , a.buffer_gets buffer_gets , a.executions executions , (a.buffer_gets / decode(a.executions, 0, 1, a.executions)) gets_per_exec , a.sql_text sql_text
 FROM (SELECT ai.sql_id,ai.buffer_gets, ai.executions, ai.sql_text, ai.parsing_user_id FROM v$sqlarea ai ORDER BY ai.buffer_gets ) a , dba_users b
 WHERE a.parsing_user_id = b.user_id AND a.buffer_gets > 1000 AND b.username NOT IN ('SYS','SYSTEM') AND rownum < 101
 ORDER BY a.buffer_gets DESC;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                 - SQL STATEMENTS WITH MOST DISK READS -                    |
 -- +----------------------------------------------------------------------------+
 prompt <a name="sql_statements_with_most_disk_reads"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>SQL Statements With Most Disk Reads</b></font><hr align="left" width="460">
 prompt <b>Top 100 SQL statements with disk reads greater than 1000</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN sql_id                                     HEADING 'SQL ID'      ENTMAP off
 COLUMN username                                   HEADING 'Username'    ENTMAP off
 COLUMN disk_reads      FORMAT 999,999,999,999,999 HEADING 'Disk Reads'  ENTMAP off
 COLUMN executions      FORMAT 999,999,999,999,999 HEADING 'Executions'  ENTMAP off
 COLUMN reads_per_exec  FORMAT 999,999,999,999,999 HEADING 'Reads/Exec'  ENTMAP off
 COLUMN sql_text                                   HEADING 'SQL Text'    ENTMAP off
 SELECT a.sql_id sql_id , '<font color="#336699"><b>' || UPPER(b.username) || '</b></font>' username , a.disk_reads disk_reads , a.executions executions , (a.disk_reads / decode(a.executions, 0, 1, a.executions))  reads_per_exec , a.sql_text sql_text
 FROM (SELECT ai.sql_id, ai.disk_reads, ai.executions, ai.sql_text, ai.parsing_user_id FROM v$sqlarea ai ORDER BY ai.buffer_gets ) a , dba_users b
 WHERE a.parsing_user_id = b.user_id AND a.disk_reads > 1000 AND b.username NOT IN ('SYS','SYSTEM') AND rownum < 101
 ORDER BY a.disk_reads DESC;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    else
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"

 -- +----------------------------------------------------------------------------+
 -- |                - SQL STATEMENTS WITH MOST BUFFER GETS -                    |
 -- +----------------------------------------------------------------------------+
 prompt <a name="sql_statements_with_most_buffer_gets"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>SQL Statements With Most Buffer Gets</b></font><hr align="left" width="460">
 prompt <b>Top 100 SQL statements with buffer gets greater than 1000</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN address                                  HEADING 'SQL Address'      ENTMAP off
 COLUMN username                                 HEADING 'Username'         ENTMAP off
 COLUMN buffer_gets   FORMAT 999,999,999,999,999 HEADING 'Buffer Gets'      ENTMAP off
 COLUMN executions    FORMAT 999,999,999,999,999 HEADING 'Executions'       ENTMAP off
 COLUMN gets_per_exec FORMAT 999,999,999,999,999 HEADING 'Buffer Gets/Exec' ENTMAP off
 COLUMN sql_text                                 HEADING 'SQL Text'         ENTMAP off
 SELECT a.address , '<font color="#336699"><b>' || UPPER(b.username) || '</b></font>' username , a.buffer_gets buffer_gets , a.executions executions , (a.buffer_gets / decode(a.executions, 0, 1, a.executions))  gets_per_exec , a.sql_text sql_text
 FROM (SELECT ai.address, ai.buffer_gets, ai.executions, ai.sql_text, ai.parsing_user_id FROM v$sqlarea ai ORDER BY ai.buffer_gets ) a , dba_users b
 WHERE a.parsing_user_id = b.user_id AND a.buffer_gets > 1000 AND b.username NOT IN ('SYS','SYSTEM') AND rownum < 101
 ORDER BY a.buffer_gets DESC;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                 - SQL STATEMENTS WITH MOST DISK READS -                    |
 -- +----------------------------------------------------------------------------+
 prompt <a name="sql_statements_with_most_disk_reads"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>SQL Statements With Most Disk Reads</b></font><hr align="left" width="460">
 prompt <b>Top 100 SQL statements with disk reads greater than 1000</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN address                                    HEADING 'SQL Address' ENTMAP off
 COLUMN username                                   HEADING 'Username'    ENTMAP off
 COLUMN disk_reads      FORMAT 999,999,999,999,999 HEADING 'Disk Reads'  ENTMAP off
 COLUMN executions      FORMAT 999,999,999,999,999 HEADING 'Executions'  ENTMAP off
 COLUMN reads_per_exec  FORMAT 999,999,999,999,999 HEADING 'Reads/Exec'  ENTMAP off
 COLUMN sql_text                                   HEADING 'SQL Text'    ENTMAP off
 SELECT a.address, '<font color="#336699"><b>' || UPPER(b.username) || '</b></font>' username , a.disk_reads disk_reads , a.executions executions , (a.disk_reads / decode(a.executions, 0, 1, a.executions))  reads_per_exec , a.sql_text sql_text
 FROM (SELECT ai.address, ai.disk_reads, ai.executions, ai.sql_text, ai.parsing_user_id FROM v$sqlarea ai ORDER BY ai.buffer_gets ) a , dba_users b
 WHERE a.parsing_user_id = b.user_id AND a.disk_reads > 1000 AND b.username NOT IN ('SYS','SYSTEM') AND rownum < 101
 ORDER BY a.disk_reads DESC;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    fi
    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"

 -- +----------------------------------------------------------------------------+
 -- |                    - AVERAGE OVERALL I/O PER SECOND -                      |
 -- +----------------------------------------------------------------------------+
 prompt <a name="average_overall_io_per_sec"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Average Overall I/O per Second</b></font><hr align="left" width="460">
 prompt <b>Average overall I/O calls (physical read/write calls) since last startup of the Oracle instance</b>
 CLEAR COLUMNS BREAKS COMPUTES
 DECLARE
 CURSOR get_file_io IS SELECT NVL(SUM(a.phyrds + a.phywrts), 0)  sum_datafile_io , TO_NUMBER(null) sum_tempfile_io FROM v$filestat a UNION ALL SELECT TO_NUMBER(null) sum_datafile_io , NVL(SUM(b.phyrds + b.phywrts), 0)  sum_tempfile_io FROM v$tempstat b;
 current_time           DATE;
 elapsed_time_seconds   NUMBER;
 sum_datafile_io        NUMBER;
 sum_datafile_io2       NUMBER;
 sum_tempfile_io        NUMBER;
 sum_tempfile_io2       NUMBER;
 total_io               NUMBER;
 datafile_io_per_sec    NUMBER;
 tempfile_io_per_sec    NUMBER;
 total_io_per_sec       NUMBER;
 BEGIN
    OPEN get_file_io;
    FOR i IN 1..2 LOOP
      FETCH get_file_io INTO sum_datafile_io, sum_tempfile_io;
      IF i = 1 THEN
        sum_datafile_io2 := sum_datafile_io;
      ELSE
        sum_tempfile_io2 := sum_tempfile_io;
      END IF;
    END LOOP;
    total_io := sum_datafile_io2 + sum_tempfile_io2;
    SELECT sysdate INTO current_time FROM dual;
    SELECT CEIL ((current_time - startup_time)*(60*60*24)) INTO elapsed_time_seconds FROM v$instance;
    datafile_io_per_sec := sum_datafile_io2/elapsed_time_seconds;
    tempfile_io_per_sec := sum_tempfile_io2/elapsed_time_seconds;
    total_io_per_sec    := total_io/elapsed_time_seconds;
    DBMS_OUTPUT.PUT_LINE('<table width="90%" border="1">');
    DBMS_OUTPUT.PUT_LINE('<tr><th align="left" width="20%">Elapsed Time (in seconds)</th><td width="80%">' || TO_CHAR(elapsed_time_seconds, '9,999,999,999,999') || '</td></tr>');
    DBMS_OUTPUT.PUT_LINE('<tr><th align="left" width="20%">Datafile I/O Calls per Second</th><td width="80%">' || TO_CHAR(datafile_io_per_sec, '9,999,999,999,999') || '</td></tr>');
    DBMS_OUTPUT.PUT_LINE('<tr><th align="left" width="20%">Tempfile I/O Calls per Second</th><td width="80%">' || TO_CHAR(tempfile_io_per_sec, '9,999,999,999,999') || '</td></tr>');
    DBMS_OUTPUT.PUT_LINE('<tr><th align="left" width="20%">Total I/O Calls per Second</th><td width="80%">' || TO_CHAR(total_io_per_sec, '9,999,999,999,999') || '</td></tr></table>');
 END;
 /
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                            - OUTLINE HINTS -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_outline_hints"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Outline Hints</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN category FORMAT a125 HEADING 'Category'      ENTMAP off
 COLUMN owner    FORMAT a125 HEADING 'Owner'         ENTMAP off
 COLUMN name     FORMAT a125 HEADING 'Name'          ENTMAP off
 COLUMN node                 HEADING 'Node'          ENTMAP off
 COLUMN join_pos             HEADING 'Join Position' ENTMAP off
 COLUMN hint                 HEADING 'Hint'          ENTMAP off
 BREAK ON category ON owner ON name
 SELECT '<div nowrap><font color="#336699"><b>' || a.category || '</b></font></div>' category , a.owner owner , a.name name , '<div align="center">' || b.node || '</div>'      node , '<div align="center">' || b.join_pos || '</div>'  join_pos , b.hint hint
 FROM dba_outlines a , dba_outline_hints  b
 WHERE a.owner = b.owner AND b.name  = b.name
 ORDER BY category , owner , name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                               - OUTLINES -                                 |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_outlines"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Outlines</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN category  FORMAT a125 HEADING 'Category'   ENTMAP off
 COLUMN owner     FORMAT a125 HEADING 'Owner'      ENTMAP off
 COLUMN name      FORMAT a125 HEADING 'Name'       ENTMAP off
 COLUMN used                  HEADING 'Used?'      ENTMAP off
 COLUMN timestamp FORMAT a125 HEADING 'Time Stamp' ENTMAP off
 COLUMN version               HEADING 'Version'    ENTMAP off
 COLUMN sql_text              HEADING 'SQL Text'   ENTMAP off
 SELECT '<div nowrap><font color="#336699"><b>' || category || '</b></font></div>' category , owner , name , used , '<div nowrap align="right">' || TO_CHAR(timestamp, 'yyyy-mm-dd HH24:MI:SS') || '</div>' timestamp , version , sql_text
 FROM dba_outlines
 ORDER BY category , owner , name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - PGA TARGET ADVICE -                            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="pga_target_advice"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>PGA Target Advice</b></font><hr align="left" width="460">
 prompt The <b>V$PGA_TARGET_ADVICE</b> view predicts how the statistics cache hit percentage and over
 prompt allocation count in V$PGASTAT will be impacted if you change the value of the
 prompt initialization parameter PGA_AGGREGATE_TARGET. When you set the PGA_AGGREGATE_TARGET and
 prompt WORKAREA_SIZE_POLICY to <b>AUTO</b> then the *_AREA_SIZE parameter are automatically ignored and
 prompt Oracle will automatically use the computed value for these parameters. Use the results from
 prompt the query below to adequately set the initialization parameter PGA_AGGREGATE_TARGET as to avoid
 prompt any over allocation. If column ESTD_OVERALLOCATION_COUNT in the V$PGA_TARGET_ADVICE
 prompt view (below) is nonzero, it indicates that PGA_AGGREGATE_TARGET is too small to even
 prompt meet the minimum PGA memory needs. If PGA_AGGREGATE_TARGET is set within the over
 prompt allocation zone, the memory manager will over-allocate memory and actual PGA memory
 prompt consumed will be more than the limit you set. It is therefore meaningless to set a
 prompt value of PGA_AGGREGATE_TARGET in that zone. After eliminating over-allocations, the
 prompt goal is to maximize the PGA cache hit percentage, based on your response-time requirement
 prompt and memory constraints.
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name FORMAT a79 HEADING 'Instance Name'  ENTMAP off
 COLUMN name          FORMAT a79 HEADING 'Parameter Name' ENTMAP off
 COLUMN value         FORMAT a79 HEADING 'Value'          ENTMAP off
 BREAK ON report ON instance_name
 SELECT '<div align="left"><font color="#336699"><b>' || i.instance_name || '</b></font></div>'  instance_name , p.name    name , (CASE p.name WHEN 'pga_aggregate_target' THEN '<div align="right">' || TO_CHAR(p.value, '999,999,999,999,999') || '</div>'ELSE '<div align="right">' || p.value || '</div>'END) value
 FROM gv$parameter p , gv$instance  i
 WHERE p.inst_id = i.inst_id AND p.name IN ('pga_aggregate_target', 'workarea_size_policy')
 ORDER BY i.instance_name , p.name;
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name                  FORMAT a79         HEADING 'Instance Name'             ENTMAP off
 COLUMN pga_target_for_estimate        FORMAT 999,999,999 HEADING 'PGA Target for Estimate'   ENTMAP off
 COLUMN estd_extra_bytes_rw            FORMAT 999,999,999 HEADING 'Estimated Extra Bytes R/W' ENTMAP off
 COLUMN estd_pga_cache_hit_percentage  FORMAT 999,999,999 HEADING 'Estimated PGA Cache Hit %' ENTMAP off
 COLUMN estd_overalloc_count           FORMAT 999,999,999 HEADING 'ESTD_OVERALLOC_COUNT'      ENTMAP off
 BREAK ON report ON instance_name
 SELECT '<div align="left"><font color="#336699"><b>'||i.instance_name||'</b></font></div>' instance_name , round(p.pga_target_for_estimate/1048576) pga_target_for_estimate, round(p.estd_extra_bytes_rw/1048576) estd_extra_bytes_rw, p.estd_pga_cache_hit_percentage , p.estd_overalloc_count
 FROM gv$pga_target_advice p , gv$instance  i
 WHERE p.inst_id = i.inst_id
 ORDER BY i.instance_name , p.pga_target_for_estimate;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                        - REDO LOG CONTENTION -                             |
 -- +----------------------------------------------------------------------------+
 prompt <a name="redo_log_contention"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Redo Log Contention</b></font><hr align="left" width="460">
 prompt <b>All latches like redo% - (ordered by misses)</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN name                                    HEADING 'Latch Name'
 COLUMN gets             FORMAT 999,999,999,999 HEADING 'Gets'
 COLUMN misses           FORMAT 999,999,999,999 HEADING 'Misses'
 COLUMN sleeps           FORMAT 999,999,999,999 HEADING 'Sleeps'
 COLUMN immediate_gets   FORMAT 999,999,999,999 HEADING 'Immediate Gets'
 COLUMN immediate_misses FORMAT 999,999,999,999 HEADING 'Immediate Misses'
 BREAK ON report
 COMPUTE sum LABEL '<font color="#990000"><b>Total:</b></font>' OF gets misses sleeps immediate_gets immediate_misses ON report
 SELECT '<div align="left"><font color="#336699"><b>' || INITCAP(name) || '</b></font></div>' name , gets , misses , sleeps , immediate_gets , immediate_misses
 FROM v$latch
 WHERE name LIKE 'redo%'
 ORDER BY 1;
 prompt <b>System statistics like redo%</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN name                             HEADING 'Statistics Name'
 COLUMN value FORMAT 999,999,999,999,999 HEADING 'Value'
 SELECT '<div align="left"><font color="#336699"><b>' || INITCAP(name) || '</b></font></div>' name , value
 FROM v$sysstat
 WHERE name LIKE 'redo%'
 ORDER BY 1;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    if [ "${SNAPSHOT_VER}" = "10" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"

 -- +----------------------------------------------------------------------------+
 -- |                         - ENABLED AGGREGATIONS -                           |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_enabled_aggregations"></a>
 prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Enabled Aggregations</b></font><hr align="left" width="460">
 prompt <b><u>Statistics Aggregation from View DBA_ENABLED_AGGREGATIONS.</u></b><li> <b>Aggregation Type:</b> Possible values are CLIENT_ID, SERVICE_MODULE, and SERVICE_MODULE_ACTION, based on the type of statistics being gathered.<li> <b>Primary ID:</b> Specific client identifier (username) or service name. <p>
 prompt <b><u>Statistics aggregation is enabled using the DBMS_MONITOR package and the following procedures.</u></b> Note that statistics gathering is global for the database and is persistent across instance starts and restarts.<li> <b>CLIENT_ID_STAT_ENABLE:</b> Enable statistics gathering based on client identifier (username).<li> <b>CLIENT_ID_STAT_DISABLE:</b> Disable client identifier statistics gathering.<li> <b>SERV_MOD_ACT_STAT_ENABLE:</b> Enable statistics gathering for a given combination of service name, module, and action.<li> <b>SERV_MOD_ACT_STAT_DISABLE:</b> Disable service, module, and action statistics gathering. <p>
 prompt <b><font color="#ff0000">Hint</font>:</b> While the DBA_ENABLED_AGGREGATIONS provides global statistics for currently enabled statistics, several other views can be used to query statistics aggregation values: V$CLIENT_STATS, V$SERVICE_STATS, V$SERV_MOD_ACT_STATS, and V$SERVICEMETRIC.
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN aggregation_type      HEADING 'Aggregation Type'   ENTMAP off
 COLUMN primary_id            HEADING 'Primary ID'         ENTMAP off
 COLUMN qualifier_id1         HEADING 'Module Name'        ENTMAP off
 COLUMN qualifier_id2         HEADING 'Action Name'        ENTMAP off
 SELECT '<div align="left"><font color="#336699"><b>' || aggregation_type || '</b></font></div>' aggregation_type , '<div align="left">' || NVL(primary_id, '<br>') || '</div>' primary_id , '<div align="left">' || NVL(qualifier_id1, '<br>') || '</div>' qualifier_id1 , '<div align="left">' || NVL(qualifier_id2, '<br>') || '</div>' qualifier_id2
 FROM dba_enabled_aggregations
 ORDER BY aggregation_type , primary_id , qualifier_id1 , qualifier_id2;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                            - ENABLED TRACES -                              |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_enabled_traces"></a>
 prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Enabled Traces</b></font><hr align="left" width="460">
 prompt <b><u>End-to-End Application Tracing from View DBA_ENABLED_TRACES.</u></b><li> <b>Trace Type:</b> Possible values are CLIENT_ID, SESSION, SERVICE, SERVICE_MODULE, SERVICE_MODULE_ACTION, and DATABASE, based on the type of tracing enabled.<li> <b>Primary ID:</b> Specific client identifier (username) or service name.<p>
 prompt <b><u>Application tracing is enabled using the DBMS_MONITOR package and the following procedures:</u></b><li> <b>CLIENT_ID_TRACE_ENABLE:</b> Enable tracing based on client identifier (username).<li> <b>CLIENT_ID_TRACE_DISABLE:</b> Disable client identifier tracing.<li> <b>SESSION_TRACE_ENABLE:</b> Enable tracing based on SID and SERIAL# of V$SESSION.<li> <b>SESSION_TRACE_DISABLE:</b> Disable session tracing.<li> <b>SERV_MOD_ACT_TRACE_ENABLE:</b> Enable tracing for a given combination of service name, module, and action.<li> <b>SERV_MOD_ACT_TRACE_DISABLE:</b> Disable service, module, and action tracing.<li> <b>DATABASE_TRACE_ENABLE:</b> Enable tracing for the entire database.<li> <b>DATABASE_TRACE_DISABLE:</b> Disable database tracing. <p> <b><font color="#ff0000">Hint</font>:</b> In a shared environment where you have more than one session to trace, it is
 prompt possible to end up with many trace files when tracing is enabled (i.e. connection pools).Oracle10<i>g</i> introduces the <b>trcsess</b> command-line utility to combine all the relevanttrace files based on a session or client identifier or the service name, module name, andaction name hierarchy combination. The output trace file from the trcsess command can then besent to tkprof for a formatted output. Type trcsess at the command-line without any arguments toshow the parameters and usage.
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN trace_type    HEADING 'Trace Type'    ENTMAP off
 COLUMN primary_id    HEADING 'Primary ID'    ENTMAP off
 COLUMN qualifier_id1 HEADING 'Module Name'   ENTMAP off
 COLUMN qualifier_id2 HEADING 'Action Name'   ENTMAP off
 COLUMN waits         HEADING 'Waits?'        ENTMAP off
 COLUMN binds         HEADING 'Binds?'        ENTMAP off
 COLUMN instance_name HEADING 'Instance Name' ENTMAP off
 SELECT '<div align="left"><font color="#336699"><b>' || trace_type || '</b></font></div>' trace_type , '<div align="left">' || NVL(primary_id, '<br>') || '</div>' primary_id , '<div align="left">' || NVL(qualifier_id1, '<br>') || '</div>' qualifier_id1 , '<div align="left">' || NVL(qualifier_id2, '<br>') || '</div>' qualifier_id2 , '<div align="center">' || waits || '</div>' waits , '<div align="center">' || binds || '</div>' binds , '<div align="left">' || NVL(instance_name, '<br>') || '</div>' instance_name
 FROM dba_enabled_traces
 ORDER BY trace_type , primary_id , qualifier_id1 , qualifier_id2;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - SGA TARGET ADVICE -                            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="sga_target_advice"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>SGA Target Advice</b></font><hr align="left" width="460">
 prompt Modify the SGA_TARGET parameter (up to the size of the SGA_MAX_SIZE, if necessary) to reduce
 prompt the number of "Estimated Physical Reads".
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name FORMAT a79 HEADING 'Instance Name'  ENTMAP off
 COLUMN name          FORMAT a79 HEADING 'Parameter Name' ENTMAP off
 COLUMN value         FORMAT a79 HEADING 'Value'          ENTMAP off
 BREAK ON report ON instance_name
 SELECT '<div align="left"><font color="#336699"><b>' || i.instance_name || '</b></font></div>'  instance_name , p.name name , (CASE p.name WHEN 'sga_max_size' THEN '<div align="right">' || TO_CHAR(p.value, '999,999,999,999,999') || '</div>'WHEN 'sga_target' THEN '<div align="right">' || TO_CHAR(p.value, '999,999,999,999,999') || '</div>'ELSE '<div align="right">' || p.value || '</div>'END) value
 FROM gv$parameter p , gv$instance  i
 WHERE p.inst_id = i.inst_id AND p.name IN ('sga_max_size', 'sga_target')
 ORDER BY i.instance_name , p.name;
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name       FORMAT a79                 HEADING 'Instance Name'            ENTMAP off
 COLUMN sga_size_MB         FORMAT 999,999,999         HEADING 'SGA Size/MB'              ENTMAP off
 COLUMN sga_size_factor     FORMAT 999,999,999         HEADING 'SGA Size Factor'          ENTMAP off
 COLUMN estd_db_time        FORMAT 999,999,999,999,999 HEADING 'Estimated DB Time'        ENTMAP off
 COLUMN estd_db_time_factor FORMAT 999,999,999,999,999 HEADING 'Estimated DB Time Factor' ENTMAP off
 COLUMN estd_physical_reads FORMAT 999,999,999,999,999 HEADING 'Estimated Physical Reads' ENTMAP off
 BREAK ON report ON instance_name
 SELECT '<div align="left"><font color="#336699"><b>' || i.instance_name || '</b></font></div>'  instance_name , round(s.sga_size/1048576) sga_size_MB, s.sga_size_factor , s.estd_db_time , s.estd_db_time_factor , s.estd_physical_reads
 FROM gv$sga_target_advice s , gv$instance  i
 WHERE s.inst_id = i.inst_id
 ORDER BY i.instance_name , s.sga_size_factor;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p><center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Automatic Workload Repository</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                              - AWR BASELINES -                             |
 -- +----------------------------------------------------------------------------+
 prompt <a name="awr_baselines"></a>
 prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>AWR Baselines</b></font><hr align="left" width="460">
 prompt Use the <b>DBMS_WORKLOAD_REPOSITORY.CREATE_BASELINE</b> procedure to create a named baseline. A baseline (also known as a preserved snapshot set) is a pair of AWR snapshots that represents a specific period of database usage. The Oracle database server will exempt the AWR snapshots assigned to a specific baseline from the automated purge routine. The main purpose of a baseline is to preserve typical run-time statistics in the AWR repository which can then be compared to current performance or similar periods in the past.
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN dbbid           HEAD 'Database ID'             ENTMAP off
 COLUMN dbb_name        HEAD 'Database Name'           ENTMAP off
 COLUMN baseline_id     HEAD 'Baseline ID'             ENTMAP off
 COLUMN baseline_name   HEAD 'Baseline Name'           ENTMAP off
 COLUMN start_snap_id   HEAD 'Beginning Snapshot ID'   ENTMAP off
 COLUMN start_snap_time HEAD 'Beginning Snapshot Time' ENTMAP off
 COLUMN end_snap_id     HEAD 'Ending Snapshot ID'      ENTMAP off
 COLUMN end_snap_time   HEAD 'Ending Snapshot Time'    ENTMAP off
 SELECT '<div align="left"><font color="#336699"><b>' || b.dbid || '</b></font></div>'  dbbid , d.name dbb_name , b.baseline_id baseline_id , baseline_name baseline_name , b.start_snap_id start_snap_id , '<div nowrap align="right">' || TO_CHAR(b.start_snap_time, 'yyyy-mm-dd HH24:MI:SS')  || '</div>'  start_snap_time , b.end_snap_id end_snap_id , '<div nowrap align="right">' || TO_CHAR(b.end_snap_time, 'yyyy-mm-dd HH24:MI:SS')  || '</div>'    end_snap_time
  FROM dba_hist_baseline   b , v$database d
 WHERE b.dbid = d.dbid
 ORDER BY dbbid , b.baseline_id;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - AWR SNAPSHOT LIST -                            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="awr_snapshot_list"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>AWR Snapshot List</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name_print         HEADING 'Instance Name'          ENTMAP off
 COLUMN snap_id                     HEADING 'Snap ID'                ENTMAP off
 COLUMN startup_time                HEADING 'Instance Startup Time'  ENTMAP off
 COLUMN begin_interval_time         HEADING 'Begin Interval Time'    ENTMAP off
 COLUMN end_interval_time           HEADING 'End Interval Time'      ENTMAP off
 COLUMN elapsed_time FORMAT 999,999 HEADING 'Elapsed Time (min)'     ENTMAP off
 COLUMN db_time      FORMAT 999,999 HEADING 'DB Time (min)'          ENTMAP off
 COLUMN pct_db_time                 HEADING '% DB Time'              ENTMAP off
 COLUMN cpu_time     FORMAT 999,999 HEADING 'CPU Time (min)'         ENTMAP off
 BREAK ON instance_name_print ON startup_time
 SELECT '<div align="center"><font color="#336699"><b>' || i.instance_name || '</b></font></div>'  instance_name_print , '<div align="center"><font color="#336699"><b>' || s.snap_id || '</b></font></div>'  snap_id , '<div nowrap align="right">' || TO_CHAR(s.startup_time, 'yyyy-mm-dd HH24:MI:SS') || '</div>' startup_time , '<div nowrap align="right">' || TO_CHAR(s.begin_interval_time, 'yyyy-mm-dd HH24:MI:SS') || '</div>' begin_interval_time , '<div nowrap align="right">' || TO_CHAR(s.end_interval_time, 'yyyy-mm-dd HH24:MI:SS') || '</div>' end_interval_time , ROUND(EXTRACT(DAY FROM  s.end_interval_time - s.begin_interval_time) * 1440 + EXTRACT(HOUR FROM s.end_interval_time - s.begin_interval_time) * 60 + EXTRACT(MINUTE FROM s.end_interval_time - s.begin_interval_time) + EXTRACT(SECOND FROM s.end_interval_time - s.begin_interval_time) / 60, 2) elapsed_time , ROUND((e.value - b.value)/1000000/60, 2) db_time , '<div align="right">' || ROUND(((((e.value - b.value)/1000000/60) / (EXTRACT(DAY FROM  s.end_interval_time - s.begin_interval_time) * 1440 + EXTRACT(HOUR FROM s.end_interval_time - s.begin_interval_time) * 60 + EXTRACT(MINUTE FROM s.end_interval_time - s.begin_interval_time) + EXTRACT(SECOND FROM s.end_interval_time - s.begin_interval_time) / 60) ) * 100), 2) || ' %</div>' pct_db_time
 FROM dba_hist_snapshot s , gv$instance i , dba_hist_sys_time_model e , dba_hist_sys_time_model b
 WHERE i.instance_number = s.instance_number AND e.snap_id = s.snap_id AND b.snap_id = s.snap_id - 1 AND e.stat_id = b.stat_id AND e.instance_number = b.instance_number AND e.instance_number = s.instance_number AND e.stat_name = 'DB time'
 ORDER BY i.instance_name , s.snap_id;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                          - AWR SNAPSHOT SETTINGS -                         |
 -- +----------------------------------------------------------------------------+
 prompt <a name="awr_snapshot_settings"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>AWR Snapshot Settings</b></font><hr align="left" width="460">
 prompt Use the <b>DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS</b> procedure to modify the interval of the snapshot generation and how long the snapshots are retained in the Workload Repository. The default interval is 60 minutes and can be set to a value between 10 minutes and 5,256,000 (1 year). The default retention period is 10,080 minutes (7 days) and can be set to a value between 1,440 minutes (1 day) and 52,560,000 minutes (100 years).
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN dbbid         HEAD 'Database ID'      ENTMAP off
 COLUMN dbb_name      HEAD 'Database Name'    ENTMAP off
 COLUMN snap_interval HEAD 'Snap Interval'    ENTMAP off
 COLUMN retention     HEAD 'Retention Period' ENTMAP off
 COLUMN topnsql       HEAD 'Top N SQL'        ENTMAP off
 SELECT '<div align="left"><font color="#336699"><b>' || s.dbid || '</b></font></div>'  dbbid , d.name dbb_name , s.snap_interval snap_interval , s.retention retention , s.topnsql
 FROM dba_hist_wr_control   s , v$database d
 WHERE s.dbid = d.dbid
 ORDER BY dbbid;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                      - AWR SNAPSHOT SIZE ESTIMATES -                       |
 -- +----------------------------------------------------------------------------+
 prompt <a name="awr_snapshot_size_estimates"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>AWR Snapshot Size Estimates</b></font><hr align="left" width="460">
 DECLARE
    CURSOR get_instances IS SELECT COUNT(instance_number) FROM gv$instance;
    CURSOR get_wr_control_info IS select extract(hour from SNAP_INTERVAL)*60+extract(minute from SNAP_INTERVAL) from dba_hist_wr_control where dbid = (select dbid from v$database);
    CURSOR get_snaps IS SELECT SUM(all_snaps), SUM(today_snaps) , SYSDATE - MIN(begin_interval_time) FROM (SELECT 1 AS all_snaps , (CASE WHEN (s.end_interval_time > SYSDATE - 1) THEN 1 ELSE 0 END) AS today_snaps , CAST(s.begin_interval_time AS DATE) AS begin_interval_time FROM dba_hist_snapshot s );
    CURSOR sysaux_occ_usage IS SELECT occupant_name , schema_name , space_usage_kbytes/1024 space_usage_mb FROM v$sysaux_occupants ORDER BY space_usage_kbytes DESC , occupant_name;
    mb_format           CONSTANT  VARCHAR2(30)  := '99,999,990.0';
    kb_format           CONSTANT  VARCHAR2(30)  := '999,999,990';
    pct_format          CONSTANT  VARCHAR2(30)  := '990.0';
    snapshot_interval   NUMBER;
    all_snaps           NUMBER;
    awr_size            NUMBER;
    snap_size           NUMBER;
    awr_average_size    NUMBER;
    est_today_snaps     NUMBER;
    awr_size_past24     NUMBER;
    today_snaps         NUMBER;
    num_days            NUMBER;
    num_instances       NUMBER;
 BEGIN
    OPEN get_instances;
    FETCH get_instances INTO num_instances;
    CLOSE get_instances;
    OPEN get_wr_control_info;
    FETCH get_wr_control_info INTO snapshot_interval;
    CLOSE get_wr_control_info;
    OPEN get_snaps;
    FETCH get_snaps INTO all_snaps, today_snaps, num_days;
    CLOSE get_snaps;
    FOR occ_rec IN sysaux_occ_usage
    LOOP
        IF (occ_rec.occupant_name = 'SM/AWR') THEN
            awr_size := occ_rec.space_usage_mb;
        END IF;
    END LOOP;
    snap_size := awr_size/all_snaps;
    awr_average_size := snap_size*86400/snapshot_interval;
    today_snaps := today_snaps / num_instances;
    IF (num_days < 1) THEN
        est_today_snaps := ROUND(today_snaps / num_days);
    ELSE
        est_today_snaps := today_snaps;
    END IF;
    awr_size_past24 := snap_size * est_today_snaps;
    DBMS_OUTPUT.PUT_LINE('<table width="90%" border="1">');
    DBMS_OUTPUT.PUT_LINE('<tr><th align="center" colspan="3">Estimates based on ' || ROUND(snapshot_interval) || ' minute snapshot intervals</th></tr>');
    DBMS_OUTPUT.PUT_LINE('<tr><td>AWR size/day</td><td align="right">'|| TO_CHAR(awr_average_size, mb_format) || ' MB</td><td align="right">(' || TRIM(TO_CHAR(snap_size*1024, kb_format)) || ' K/snap * '|| ROUND(1440/snapshot_interval) || ' snaps/day)</td></tr>' );
    DBMS_OUTPUT.PUT_LINE('<tr><td>AWR size/wk</td><td align="right">'|| TO_CHAR(awr_average_size * 7, mb_format) || ' MB</td><td align="right">(size_per_day * 7) per instance</td></tr>' );
    IF (num_instances > 1) THEN
        DBMS_OUTPUT.PUT_LINE('<tr><td>AWR size/wk</td><td align="right">'|| TO_CHAR(awr_average_size * 7 * num_instances, mb_format) || ' MB</td><td align="right">(size_per_day * 7) per database</td></tr>' );
    END IF;
    DBMS_OUTPUT.PUT_LINE('<tr><th align="center" colspan="3">Estimates based on ' || ROUND(today_snaps) || ' snaps in past 24 hours</th></tr>');
    DBMS_OUTPUT.PUT_LINE('<tr><td>AWR size/day</td><td align="right">'|| TO_CHAR(awr_size_past24, mb_format) || ' MB</td><td align="right">('|| TRIM(TO_CHAR(snap_size*1024, kb_format)) || ' K/snap and '|| ROUND(today_snaps) || ' snaps in past '|| ROUND(least(num_days*24,24),1) || ' hours)</td></tr>' );
    DBMS_OUTPUT.PUT_LINE('<tr><td>AWR size/wk</td><td align="right">'|| TO_CHAR(awr_size_past24 * 7, mb_format) || ' MB</td><td align="right">(size_per_day * 7) per instance</td></tr>' );
    IF (num_instances > 1) THEN
        DBMS_OUTPUT.PUT_LINE('<tr><td>AWR size/wk</td><td align="right">'|| TO_CHAR(awr_size_past24 * 7 * num_instances, mb_format) || ' MB</td><td align="right">(size_per_day * 7) per database</td></tr>' );
    END IF;
    DBMS_OUTPUT.PUT_LINE('</table>');
 END;
 /
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                   - WORKLOAD REPOSITORY INFORMATION -                      |
 -- +----------------------------------------------------------------------------+
 prompt <a name="awr_workload_repository_information"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Workload Repository Information</b></font><hr align="left" width="460">
 prompt <b>Instances found in the "Workload Repository"</b> <b>The instance running this report (&_instance_name) is indicated in "<font color="darkgreen">GREEN</font>"</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN dbbid                     HEAD 'Database ID'     ENTMAP off
 COLUMN dbb_name                  HEAD 'Database Name'   ENTMAP off
 COLUMN instt_name                HEAD 'Instance Name'   ENTMAP off
 COLUMN instt_num     FORMAT 999  HEAD 'Instance Number' ENTMAP off
 COLUMN host                      HEAD 'Host'            ENTMAP off
 COLUMN host_platform FORMAT a125 HEAD 'Host Platform'   ENTMAP off
 SELECT DISTINCT (CASE WHEN cd.dbid = wr.dbid AND cd.name = wr.db_name AND ci.instance_number = wr.instance_number AND ci.instance_name = wr.instance_name THEN '<div align="left"><font color="darkgreen"><b>' || wr.dbid || '</b></font></div>'ELSE '<div align="left"><font color="#663300"><b>' || wr.dbid || '</b></font></div>'END) dbbid , wr.db_name dbb_name , wr.instance_name instt_name , wr.instance_number instt_num , wr.host_name host , cd.platform_name host_platform
 FROM dba_hist_database_instance wr , v$database cd , v$instance ci
 ORDER BY wr.instance_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    fi

    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Automatic Workload Repository</u></b></font></center> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Sessions</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                          - CURRENT SESSIONS -                              |
 -- +----------------------------------------------------------------------------+
 prompt <a name="current_sessions"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Current Sessions</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name_print  FORMAT a45 HEADING 'Instance Name'            ENTMAP off
 COLUMN thread_number_print  FORMAT a45 HEADING 'Thread Number'            ENTMAP off
 COLUMN count                FORMAT a45 HEADING 'Current No. of Processes' ENTMAP off
 COLUMN value                FORMAT a45 HEADING 'Max No. of Processes'     ENTMAP off
 COLUMN pct_usage            FORMAT a45 HEADING '% Usage'                  ENTMAP off
 SELECT '<div align="center"><font color="#336699"><b>' || a.instance_name  || '</b></font></div>'  instance_name_print , '<div align="center">' || a.thread# || '</div>'  thread_number_print , '<div align="center">' || TO_CHAR(a.count) || '</div>'  count , '<div align="center">' || b.value || '</div>'  value , '<div align="center">' || TO_CHAR(ROUND(100*(a.count / b.value), 2)) || '%</div>'  pct_usage
 FROM (select count(*) count, a1.inst_id, a2.instance_name, a2.thread# from gv$session a1 , gv$instance a2 where a1.inst_id = a2.inst_id group by a1.inst_id , a2.instance_name , a2.thread#) a , (select value, inst_id from gv$parameter where name='processes') b
 WHERE a.inst_id = b.inst_id
 ORDER BY a.instance_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                        - USER SESSION MATRIX -                             |
 -- +----------------------------------------------------------------------------+
 prompt <a name="user_session_matrix"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>User Session Matrix</b></font><hr align="left" width="460">
 prompt <b>User sessions (excluding SYS and background processes)</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name_print              HEADING 'Instance Name'          ENTMAP off
 COLUMN thread_number_print              HEADING 'Thread Number'          ENTMAP off
 COLUMN username      FORMAT a79         HEADING 'Oracle User'            ENTMAP off
 COLUMN num_user_sess FORMAT 999,999,999 HEADING 'Total Number of Logins' ENTMAP off
 COLUMN count_a       FORMAT 999,999,999 HEADING 'Active Logins'          ENTMAP off
 COLUMN count_i       FORMAT 999,999,999 HEADING 'Inactive Logins'        ENTMAP off
 COLUMN count_k       FORMAT 999,999,999 HEADING 'Killed Logins'          ENTMAP off
 BREAK ON report ON instance_name_print ON thread_number_print
 SELECT '<div align="center"><font color="#336699"><b>' || i.instance_name || '</b></font></div>' instance_name_print , '<div align="center"><font color="#336699"><b>' || i.thread# || '</b></font></div>' thread_number_print , '<div align="left"><font color="#000000">' || NVL(sess.username, '[B.G. Process]') || '</font></div>' username , count(*) num_user_sess , NVL(act.count, 0) count_a , NVL(inact.count, 0) count_i , NVL(killed.count, 0)  count_k
 FROM gv$session sess , gv$instance i , (SELECT count(*) count, NVL(username, '[B.G. Process]') username, inst_id FROM gv$session WHERE status = 'ACTIVE'GROUP BY  username, inst_id) act , (SELECT count(*) count, NVL(username, '[B.G. Process]') username, inst_id FROM gv$session WHERE status = 'INACTIVE'GROUP BY  username, inst_id) inact , (SELECT count(*) count, NVL(username, '[B.G. Process]') username, inst_id FROM gv$session WHERE status = 'KILLED'GROUP BY  username, inst_id) killed
 WHERE sess.inst_id = i.inst_id AND (NVL(sess.username, '[B.G. Process]') = act.username (+) AND sess.inst_id  = act.inst_id (+) ) AND (NVL(sess.username, '[B.G. Process]') = inact.username (+) AND sess.inst_id  = inact.inst_id (+) ) AND (NVL(sess.username, '[B.G. Process]') = killed.username (+) AND sess.inst_id  = killed.inst_id (+) ) AND sess.username NOT IN ('SYS')
 GROUP BY i.instance_name , i.thread# , sess.username , act.count , inact.count , killed.count
 ORDER BY i.instance_name , i.thread# , sess.username;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    if [ "${SNAPSHOT_VER}" = "10" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"

 -- +----------------------------------------------------------------------------+
 -- |                            - High Water -                                  |
 -- +----------------------------------------------------------------------------+
 prompt <a name="high_water"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>High Water</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN SESSIONS_HIGHWATER     HEADING 'Session Highwater' ENTMAP off
 COLUMN USERS_MAX              HEADING 'User Max'          ENTMAP off
 COLUMN SESSIONS_MAX           HEADING 'Session Max'       ENTMAP off
 COLUMN CPU_CORE_COUNT_CURRENT HEADING 'CPU Core Count'    ENTMAP off
 COLUMN CPU_COUNT_CURRENT      HEADING 'CPU Count'         ENTMAP off
 select SESSIONS_HIGHWATER,USERS_MAX,SESSIONS_MAX,CPU_CORE_COUNT_CURRENT,CPU_COUNT_CURRENT from v$license;
EOFSCRIPT
    else
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 -- +----------------------------------------------------------------------------+
 -- |                            - High Water -                                  |
 -- +----------------------------------------------------------------------------+
 prompt <a name="high_water"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>High Water</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN SESSIONS_HIGHWATER HEADING 'Session Highwater' ENTMAP off
 COLUMN USERS_MAX          HEADING 'User Max'          ENTMAP off
 COLUMN SESSIONS_MAX       HEADING 'Session Max'       ENTMAP off
 select SESSIONS_HIGHWATER,USERS_MAX,SESSIONS_MAX from v$license;
EOFSCRIPT
    fi

    cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Security</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                              - USER ROLES -                                |
 -- +----------------------------------------------------------------------------+
 prompt <a name="users_role"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>User Roles</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN grantee        HEADING 'Grantee'         ENTMAP off
 COLUMN granted_role   HEADING 'Granted Role'    ENTMAP off
 COLUMN admin_option   HEADING 'Admin. Option?'  ENTMAP off
 COLUMN default_role   HEADING 'Default Role?'   ENTMAP off
 break on grantee
 SELECT '<b><font color="#336699">' || grantee || '</font></b>'  grantee , granted_role , DECODE(   admin_option , 'YES', '<div align="center"><font color="darkgreen"><b>' || admin_option || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>'   || admin_option || '</b></font></div>', '<div align="center"><font color="#663300"><b>'   || admin_option || '</b></font></div>')   admin_option , DECODE(   default_role , 'YES', '<div align="center"><font color="darkgreen"><b>' || default_role || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>'   || default_role || '</b></font></div>', '<div align="center"><font color="#663300"><b>'   || default_role || '</b></font></div>')   default_role
 FROM dba_role_privs
 WHERE grantee IN (select username from dba_users where username not in (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC'))
 ORDER BY grantee, granted_role;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                             - USER ACCOUNTS -                              |
 -- +----------------------------------------------------------------------------+
 prompt <a name="user_accounts"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>User Accounts</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN user_id  FORMAT 999    HEAD 'UserID'          ENTMAP off
 COLUMN username               HEAD 'Username'        ENTMAP off
 COLUMN account_status         HEAD 'Account Status'  ENTMAP off
 COLUMN expiry_date            HEAD 'Expire Date'     ENTMAP off
 COLUMN default_tablespace     HEAD 'Default Tbs.'    ENTMAP off
 COLUMN temporary_tablespace   HEAD 'Temp Tbs.'       ENTMAP off
 COLUMN created                HEAD 'Created On'      ENTMAP off
 COLUMN profile                HEAD 'Profile'         ENTMAP off
 COLUMN sysdba                 HEAD 'SYSDBA'          ENTMAP off
 COLUMN sysoper                HEAD 'SYSOPER'         ENTMAP off
 SELECT '<div nowrap align="right"><b><font color="black">' || user_id || '</font></b></div>' user_id , '<b><font color="#336699">' || username || '</font></b>' username , DECODE( account_status , 'OPEN', '<div align="left"><b><font color="darkgreen">' || account_status || '</font></b></div>', '<div align="left"><b><font color="#663300">'   || account_status || '</font></b></div>') account_status , '<div nowrap align="right">' || NVL(TO_CHAR(expiry_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>' expiry_date , default_tablespace default_tablespace , temporary_tablespace temporary_tablespace , '<div nowrap align="right">' || TO_CHAR(created, 'yyyy-mm-dd HH24:MI:SS') || '</div>' created , profile profile , '<div nowrap align="center">' || NVL(DECODE(sysdba,'TRUE', 'TRUE',''), '<br>') || '</div>' sysdba , '<div nowrap align="center">' || NVL(DECODE(sysoper,'TRUE','TRUE',''), '<br>') || '</div>' sysoper
 FROM (select user_id,u.username,account_status,expiry_date,default_tablespace,temporary_tablespace,created,profile,sysdba,sysoper from dba_users u,v$pwfile_users p where p.username (+) = u.username order by user_id) ;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                       - USER OBJECT PRIVILEGES  -                          |
 -- +----------------------------------------------------------------------------+
 prompt <a name="user_obj"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>User Object Privileges</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN grantee    HEAD 'Grantee'     ENTMAP off
 COLUMN owner      HEAD 'Owner'       ENTMAP off
 COLUMN table_name HEAD 'Table Name'  ENTMAP off
 COLUMN privilege  HEAD 'Privilege'   ENTMAP off
 COLUMN grantable  HEAD 'grantable ?' ENTMAP off
 COLUMN HIERARCHY  HEAD 'Hierarchy ?' ENTMAP off
 BREAK ON grantee
 SELECT '<font color="black"><b>'  ||  grantee|| '</b></font>' grantee , '<font color="black"><b>' ||  owner || '</b></font>' owner , '<font color="darkgreen"><b>' ||  table_name || '</b></font>'  table_name , CASE WHEN privilege like 'DROP%' then '<div align="center"><font color="darkred"><b>' || privilege || '</b></font></div>'ELSE '<div align="center"><font color="darkgreen"><b>'   || privilege || '</b></font></div>' end   privilege , DECODE(   grantable , null , '<br>', 'YES', '<div align="center"><font color="darkgreen"><b>' || grantable || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>'   || grantable || '</b></font></div>', '<div align="center"><font color="#663300"><b>'   || grantable || '</b></font></div>')   grantable , '<b><font color="#336699">' ||  HIERARCHY || '</font></b>' HIERARCHY
 FROM dba_tab_privs
 WHERE grantee IN (select username from dba_users where username not in (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC'))
 ORDER BY grantee , privilege;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                        - Role Object PRIVILEGES  -                         |
 -- +----------------------------------------------------------------------------+
 prompt <a name="role_obj_privs"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Role Object Privileges</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN role        HEAD 'Role'        ENTMAP off
 COLUMN owner       HEAD 'Owner'       ENTMAP off
 COLUMN table_name  HEAD 'Table Name'  ENTMAP off
 COLUMN column_name HEAD 'Column Name' ENTMAP off
 COLUMN privilege   HEAD 'Privilege'   ENTMAP off
 COLUMN grantable   HEAD 'grantable ?' ENTMAP off
 BREAK ON role
 SELECT '<font color="#336699"><b>'  || role|| '</b></font>' role , '<font color="black"><b>' ||  owner || '</b></font>' owner , '<font color="darkgreen"><b>' ||  table_name || '</b></font>'  table_name , column_name , CASE WHEN privilege like 'DROP%' then '<font color="darkred"><b>' || privilege || '</b></font>'ELSE '<font color="darkgreen"><b>' || privilege || '</b></font>' end   privilege , DECODE(   grantable , null , '<br>', 'YES', '<div align="center"><font color="darkgreen"><b>' || grantable || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>' || grantable || '</b></font></div>', '<div align="center"><font color="#663300"><b>' || grantable || '</b></font></div>') grantable
 FROM role_tab_privs
 ORDER BY role,owner,table_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - ROLE USERS -                                   |
 -- +----------------------------------------------------------------------------+
 prompt <a name="roles_user"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Role Users</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN role         HEAD 'Role Name'       ENTMAP off
 COLUMN grantee      HEAD 'Grantee'         ENTMAP off
 COLUMN admin_option HEAD 'Admin Option?'   ENTMAP off
 COLUMN default_role HEAD 'Default Role?'   ENTMAP off
 BREAK ON role
 SELECT '<b><font color="black">' ||  b.role || '</font></b>' role , '<b><font color="#663300">'|| a.grantee || '</font></b>' grantee , DECODE( a.admin_option , null , '<br>', 'YES', '<div align="center"><font color="darkgreen"><b>' || a.admin_option || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>' || a.admin_option || '</b></font></div>', '<div align="center"><font color="#663300"><b>' || a.admin_option || '</b></font></div>') admin_option , DECODE( a.default_role , null , '<br>', 'YES', '<div align="center"><font color="darkgreen"><b>' || a.default_role || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>' || a.default_role || '</b></font></div>', '<div align="center"><font color="#663300"><b>' || a.default_role || '</b></font></div>') default_role
 FROM dba_role_privs  a , dba_roles       b
 WHERE granted_role(+) = b.role AND grantee IN (select username from dba_users where username not in (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC'))
 ORDER BY b.role , a.grantee;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                        - Role System PRIVILEGES  -                         |
 -- +----------------------------------------------------------------------------+
 prompt <a name="role_sys_privs"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Role System Privileges</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN role         HEAD 'Role Name'       ENTMAP off
 COLUMN privilege    HEAD 'Privilege'       ENTMAP off
 COLUMN admin_option HEAD 'Admin Options'   ENTMAP off
 BREAK ON role
 SELECT '<font color="#336699"><b>'  || role|| '</b></font>' role , CASE WHEN privilege like 'DROP%' then '<font color="darkred"><b>' || privilege || '</b></font>'ELSE '<font color="darkgreen"><b>'   || privilege || '</b></font>'end privilege , DECODE( admin_option , null , '<br>', 'YES', '<div align="center"><font color="darkgreen"><b>' || admin_option|| '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>' || admin_option|| '</b></font></div>', '<div align="center"><font color="#663300"><b>' || admin_option|| '</b></font></div>') admin_option
 FROM role_sys_privs
 ORDER BY role , privilege;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                    -  SYSTEM PRIVILEGE USERS -                             |
 -- +----------------------------------------------------------------------------+
 prompt <a name="sys_user"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>System Privilege Users</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN grantee      HEAD 'Grantee'         ENTMAP off
 COLUMN privilege    HEAD 'Privilege'       ENTMAP off
 COLUMN admin_option HEAD 'Admin Option?'   ENTMAP off
 BREAK ON privilege
 SELECT CASE WHEN privilege like 'DROP%' then '<font color="darkred"><b>' || privilege || '</b></font>'ELSE '<font color="darkgreen"><b>' || privilege || '</b></font>' end privilege , '<font color="black"><b>' ||  grantee || '</b></font>' grantee , DECODE(   admin_option , null , '<br>', 'YES', '<div align="center"><font color="darkgreen"><b>' || admin_option || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>' || admin_option || '</b></font></div>', '<div align="center"><font color="#663300"><b>' || admin_option || '</b></font></div>') admin_option
 FROM dba_sys_privs
 WHERE grantee IN (select username from dba_users where username not in (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC'))
 ORDER BY privilege , grantee;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                      - USER SYSTEM PRIVILEGES  -                           |
 -- +----------------------------------------------------------------------------+
 prompt <a name="user_sys"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>User System Privileges</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN grantee       HEAD 'Grantee'         ENTMAP off
 COLUMN privilege     HEAD 'Privilege'       ENTMAP off
 COLUMN admin_option  HEAD 'Admin Option?'   ENTMAP off
 BREAK ON grantee
 SELECT '<font color="black"><b>' ||  grantee || '</b></font>' grantee , CASE WHEN privilege like 'DROP%' then '<font color="darkred"><b>' || privilege || '</b></font>'ELSE '<font color="darkgreen"><b>'   || privilege || '</b></font>' end   privilege , DECODE( admin_option , null , '<br>', 'YES', '<div align="center"><font color="darkgreen"><b>' || admin_option || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>' || admin_option || '</b></font></div>', '<div align="center"><font color="#663300"><b>' || admin_option || '</b></font></div>') admin_option
 FROM dba_sys_privs
 WHERE grantee IN (select username from dba_users where username not in (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC'))
 ORDER BY grantee , privilege;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                              - DB LINKS -                                  |
 -- +----------------------------------------------------------------------------+
 prompt <a name="db_links"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>DB Links</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner    HEADING 'Owner'        ENTMAP off
 COLUMN db_link  HEADING 'DB Link Name' ENTMAP off
 COLUMN username HEADING 'Username'     ENTMAP off
 COLUMN host     HEADING 'Host'         ENTMAP off
 COLUMN created  HEADING 'Created'      ENTMAP off
 BREAK ON owner
 SELECT '<b><font color="#336699">' || owner || '</font></b>'  owner , db_link , username , host , '<div nowrap align="right">' || TO_CHAR(created, 'yyyy-mm-dd HH24:MI:SS') || '</div>' created
 FROM dba_db_links
 ORDER BY owner, db_link;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                          - DEFAULT PASSWORDS -                             |
 -- +----------------------------------------------------------------------------+
 prompt <a name="default_passwords"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Default Passwords</b></font><hr align="left" width="460">
 prompt <b>User(s) with default password </b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN username         HEADING 'Username'        ENTMAP off
 COLUMN account_status   HEADING 'Account Status'  ENTMAP off
 SELECT '<b><font color="#336699">' || username || '</font></b>' username , DECODE(account_status , 'OPEN', '<div align="left"><b><font color="darkgreen">' || account_status || '</font></b></div>', '<div align="left"><b><font color="#663300">' || account_status || '</font></b></div>') account_status
 FROM dba_users
 WHERE password IN ('E066D214D5421CCC', '24ABAB8B06281B4C', '72979A94BAD2AF80', 'C252E8FA117AF049', 'A7A32CD03D3CE8D5', '88A2B2C183431F00', '7EFA02EC7EA6B86F', '4A3BA55E08595C81', 'F894844C34402B67', '3F9FBD883D787341', '79DF7A1BD138CF11', '7C9BA362F8314299', '88D8364765FCE6AF', 'F9DA8977092B7B81', '9300C0977D7DC75E', 'A97282CE3D94E29E', 'AC9700FD3F1410EB', 'E7B5D92911C831E1', 'AC98877DE1297365', 'D4C5016086B2DC6A', 'D4DF7931AB130E37')
 ORDER BY username;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Objects</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                              - COLLECTIONS -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_collections"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Collections</b></font><hr align="left" width="460">
 prompt <b>Excluding all internal system schemas (i.e. CTXSYS, MDSYS, SYS, SYSTEM)</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner              HEADING 'Owner'              ENTMAP off
 COLUMN type_name          HEADING 'Type Name'          ENTMAP off
 COLUMN coll_type          HEADING 'Collection Type'    ENTMAP off
 COLUMN upper_bound        HEADING 'VARRAY Limit'       ENTMAP off
 COLUMN elem_type_owner    HEADING 'Element Type Owner' ENTMAP off
 COLUMN elem_datatype      HEADING 'Element Data Type'  ENTMAP off
 COLUMN character_set_name HEADING 'Character Set'      ENTMAP off
 COLUMN elem_storage       HEADING 'Element Storage'    ENTMAP off
 COLUMN nulls_stored       HEADING 'Nulls Stored?'      ENTMAP off
 BREAK ON report ON owner ON type_name
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || c.owner || '</b></font></div>' owner , '<div nowrap>' || c.type_name || '</div>'  type_name , '<div nowrap>' || c.coll_type || '</div>'  coll_type , '<div nowrap align="right">' || NVL(TO_CHAR(c.upper_bound, '9,999,999,999'), '<br>')  || '</div>'  upper_bound , '<div nowrap>' || NVL(c.elem_type_owner, '<br>') || '</div>'  elem_type_owner , (CASE WHEN (c.length IS NOT NULL) THEN c.elem_type_name || '(' || c.length || ')'WHEN (c.elem_type_name='NUMBER' AND (c.precision IS NOT NULL AND c.scale IS NOT NULL)) THEN c.elem_type_name || '(' || c.precision || ',' || c.scale || ')'WHEN (c.elem_type_name='NUMBER' AND (c.precision IS NOT NULL AND c.scale IS NULL)) THEN c.elem_type_name || '(' || c.precision || ')'ELSE c.elem_type_name END) elem_datatype , '<div nowrap>' || NVL(c.character_set_name, '<br>') || '</div>'  character_set_name , '<div nowrap>' || NVL(c.elem_storage, '<br>') || '</div>'  elem_storage , DECODE(c.nulls_stored , 'YES', '<div align="center"><font color="darkgreen"><b>' || c.nulls_stored || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>'   || c.nulls_stored || '</b></font></div>', '<div align="center"><font color="#663300"><b>'   || c.nulls_stored || '</b></font></div>') nulls_stored
 FROM dba_coll_types  c
 WHERE c.owner NOT IN (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 ORDER BY c.owner , c.type_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - DIRECTORIES -                                  |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_directories"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Directories</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner          FORMAT a75  HEADING 'Owner'          ENTMAP off
 COLUMN directory_name FORMAT a75  HEADING 'Directory Name' ENTMAP off
 COLUMN directory_path             HEADING 'Directory Path' ENTMAP off
 BREAK ON report ON owner
 SELECT '<div align="left"><font color="#336699"><b>' || owner || '</b></font></div>'  owner , '<b><font color="#663300">' || directory_name || '</font></b>' directory_name , '<tt>' || directory_path || '</tt>' directory_path
 FROM dba_directories
 ORDER BY owner , directory_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                        - DIRECTORY PRIVILEGES -                            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_directory_privileges"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Directory Privileges</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN table_name HEADING 'Directory Name' ENTMAP off
 COLUMN grantee    HEADING 'Grantee'        ENTMAP off
 COLUMN privilege  HEADING 'Privilege'      ENTMAP off
 COLUMN grantable  HEADING 'Grantable?'     ENTMAP off
 BREAK ON report ON table_name ON grantee
 SELECT '<b><font color="#336699">' || table_name || '</font></b>'  table_name , '<b><font color="#663300">' || grantee    || '</font></b>'  grantee , privilege privilege , DECODE(   grantable , 'YES', '<div align="center"><font color="darkgreen"><b>' || grantable || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>'   || grantable || '</b></font></div>', '<div align="center"><font color="#663300"><b>'   || grantable || '</b></font></div>')   grantable
 FROM dba_tab_privs
 WHERE privilege IN ('READ', 'WRITE')
 ORDER BY table_name , grantee , privilege;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                             - LIBRARIES -                                  |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_libraries"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Libraries</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner           HEADING 'Owner'         ENTMAP off
 COLUMN library_name    HEADING 'Library Name'  ENTMAP off
 COLUMN file_spec       HEADING 'File Spec'     ENTMAP off
 COLUMN dynamic         HEADING 'Dynamic?'      ENTMAP off
 COLUMN status          HEADING 'Status'        ENTMAP off
 BREAK ON report ON owner
 SELECT '<div align="left"><font color="#336699"><b>' || owner || '</b></font></div>'  owner , '<b><font color="#663300">' || library_name || '</font></b>' library_name , file_spec file_spec , '<div align="center">' || dynamic || '</div>' dynamic , DECODE(   status , 'VALID', '<div align="center"><font color="darkgreen"><b>' || status || '</b></font></div>', '<div align="center"><font color="#990000"><b>'   || status || '</b></font></div>' ) status
 FROM dba_libraries
 ORDER BY owner , library_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - LOB SEGMENTS -                                 |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_lob_segments"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>LOB Segments</b></font><hr align="left" width="460">
 prompt <b>Excluding all internal system schemas (i.e. CTXSYS, MDSYS, SYS, SYSTEM)</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner         FORMAT a85  HEADING 'Owner'              ENTMAP off
 COLUMN table_name                HEADING 'Table Name'         ENTMAP off
 COLUMN column_name               HEADING 'Column Name'        ENTMAP off
 COLUMN segment_name  FORMAT a125 HEADING 'LOB Segment Name'   ENTMAP off
 COLUMN tablespace_name           HEADING 'Tablespace Name'    ENTMAP off
 COLUMN lob_segment_bytes         HEADING 'Segment Size/MB'    ENTMAP off
 COLUMN index_name    FORMAT a125 HEADING 'LOB Index Name'     ENTMAP off
 COLUMN in_row                    HEADING 'In Row?'            ENTMAP off
 BREAK ON report ON owner ON table_name
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || l.owner || '</b></font></div>' owner , '<div nowrap>' || l.table_name || '</div>' table_name , '<div nowrap>' || l.column_name || '</div>' column_name , '<div nowrap>' || l.segment_name || '</div>' segment_name , '<div nowrap>' || s.tablespace_name || '</div>' tablespace_name , '<div nowrap align="right">' || round(s.bytes/1048576) || '</div>' lob_segment_bytes , '<div nowrap>' || l.index_name || '</div>' index_name , DECODE(   l.in_row , 'YES', '<div align="center"><font color="darkgreen"><b>' || l.in_row || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>'   || l.in_row || '</b></font></div>', '<div align="center"><font color="#663300"><b>'   || l.in_row || '</b></font></div>')   in_row
 FROM dba_lobs     l , dba_segments s
 WHERE l.owner = s.owner AND l.segment_name = s.segment_name AND l.owner NOT IN (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 ORDER BY l.owner , l.table_name , l.column_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - TYPE ATTRIBUTES -                              |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_type_attributes"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Type Attributes</b></font><hr align="left" width="460">
 prompt <b>Excluding all internal system schemas (i.e. CTXSYS, MDSYS, SYS, SYSTEM)</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner              HEADING 'Owner'                ENTMAP off
 COLUMN type_name          HEADING 'Type Name'            ENTMAP off
 COLUMN typecode           HEADING 'Type Code'            ENTMAP off
 COLUMN attribute_name     HEADING 'Attribute Name'       ENTMAP off
 COLUMN attribute_datatype HEADING 'Attribute Data Type'  ENTMAP off
 COLUMN inherited          HEADING 'Inherited?'           ENTMAP off
 BREAK ON report ON owner ON type_name ON typecode
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || t.owner || '</b></font></div>' owner , '<div nowrap>' || t.type_name || '</div>' type_name , '<div nowrap>' || t.typecode || '</div>' typecode , '<div nowrap>' || a.attr_name || '</div>' attribute_name , (CASE WHEN (a.length IS NOT NULL) THEN a.attr_type_name || '(' || a.length || ')'WHEN (a.attr_type_name='NUMBER' AND (a.precision IS NOT NULL AND a.scale IS NOT NULL)) THEN a.attr_type_name || '(' || a.precision || ',' || a.scale || ')'WHEN (a.attr_type_name='NUMBER' AND (a.precision IS NOT NULL AND a.scale IS NULL)) THEN a.attr_type_name || '(' || a.precision || ')'ELSE a.attr_type_name END) attribute_datatype , DECODE(   a.inherited , 'YES', '<div align="center"><font color="darkgreen"><b>' || a.inherited || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>'   || a.inherited || '</b></font></div>', '<div align="center"><font color="#663300"><b>'   || a.inherited || '</b></font></div>')   inherited
 FROM dba_types t , dba_type_attrs   a
 WHERE t.owner = a.owner AND t.type_name   = a.type_name AND t.owner NOT IN (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 ORDER BY t.owner , t.type_name , t.typecode , a.attr_no;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                             - TYPE METHODS -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_type_methods"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Type Methods</b></font><hr align="left" width="460">
 prompt <b>Excluding all internal system schemas (i.e. CTXSYS, MDSYS, SYS, SYSTEM)</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner          HEADING 'Owner'           ENTMAP off
 COLUMN type_name      HEADING 'Type Name'       ENTMAP off
 COLUMN typecode       HEADING 'Type Code'       ENTMAP off
 COLUMN method_name    HEADING 'Method Name'     ENTMAP off
 COLUMN method_type    HEADING 'Method Type'     ENTMAP off
 COLUMN num_parameters HEADING 'Num. Parameters' ENTMAP off
 COLUMN results        HEADING 'Results'         ENTMAP off
 COLUMN final          HEADING 'Final?'          ENTMAP off
 COLUMN instantiable   HEADING 'Instantiable?'   ENTMAP off
 COLUMN overriding     HEADING 'Overriding?'     ENTMAP off
 COLUMN inherited      HEADING 'Inherited?'      ENTMAP off
 BREAK ON report ON owner ON type_name ON typecode
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || t.owner || '</b></font></div>' owner , '<div nowrap>' || t.type_name || '</div>'  type_name , '<div nowrap>' || t.typecode || '</div>'  typecode , '<div nowrap>' || m.method_name || '</div>'  method_name , '<div nowrap>' || m.method_type || '</div>'  method_type , '<div nowrap align="right">'  || TO_CHAR(m.parameters, '999,999')  || '</div>'  num_parameters , '<div nowrap align="right">'  || TO_CHAR(m.results, '999,999') || '</div>'  results , '<div nowrap align="center">' || m.final || '</div>'  final , '<div nowrap align="center">' || m.instantiable || '</div>'  instantiable , '<div nowrap align="center">' || m.overriding || '</div>'  overriding , DECODE(   m.inherited , 'YES', '<div align="center"><font color="darkgreen"><b>' || m.inherited || '</b></font></div>', 'NO', '<div align="center"><font color="#990000"><b>'   || m.inherited || '</b></font></div>', '<div align="center"><font color="#663300"><b>'   || m.inherited || '</b></font></div>')   inherited
 FROM dba_types t , dba_type_methods   m
 WHERE t.owner = m.owner AND t.type_name   = m.type_name AND t.owner NOT IN (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 ORDER BY t.owner , t.type_name , t.typecode , m.method_no;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                               - TYPES -                                    |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_types"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Types</b></font><hr align="left" width="460">
 prompt <b>Excluding all internal system schemas (i.e. CTXSYS, MDSYS, SYS, SYSTEM)</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner            HEADING 'Owner'            ENTMAP off
 COLUMN type_name        HEADING 'Type Name'        ENTMAP off
 COLUMN typecode         HEADING 'Type Code'        ENTMAP off
 COLUMN attributes       HEADING 'Num. Attributes'  ENTMAP off
 COLUMN methods          HEADING 'Num. Methods'     ENTMAP off
 COLUMN predefined       HEADING 'Predefined?'      ENTMAP off
 COLUMN incomplete       HEADING 'Incomplete?'      ENTMAP off
 COLUMN final            HEADING 'Final?'           ENTMAP off
 COLUMN instantiable     HEADING 'Instantiable?'    ENTMAP off
 COLUMN supertype_owner  HEADING 'Super Owner'      ENTMAP off
 COLUMN supertype_name   HEADING 'Super Name'       ENTMAP off
 COLUMN local_attributes HEADING 'Local Attributes' ENTMAP off
 COLUMN local_methods    HEADING 'Local Methods'    ENTMAP off
 BREAK ON report ON owner
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || t.owner || '</b></font></div>' owner , '<div nowrap>' || t.type_name || '</div>' type_name , '<div nowrap>' || t.typecode || '</div>' typecode , '<div nowrap align="right">' || TO_CHAR(t.attributes, '999,999') || '</div>' attributes , '<div nowrap align="right">' || TO_CHAR(t.methods, '999,999') || '</div>' methods , '<div nowrap align="center">' || t.predefined || '</div>' predefined , '<div nowrap align="center">' || t.incomplete || '</div>' incomplete , '<div nowrap align="center">' || t.final || '</div>' final , '<div nowrap align="center">' || t.instantiable || '</div>' instantiable , '<div nowrap align="left">' || NVL(t.supertype_owner, '<br>') || '</div>' supertype_owner , '<div nowrap align="left">' || NVL(t.supertype_name, '<br>') || '</div>' supertype_name , '<div nowrap align="right">' || NVL(TO_CHAR(t.local_attributes, '999,999'), '<br>')  || '</div>' local_attributes , '<div nowrap align="right">' || NVL(TO_CHAR(t.local_methods, '999,999'), '<br>') || '</div>' local_methods
 FROM dba_types  t
 WHERE t.owner NOT IN (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 ORDER BY t.owner , t.type_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                            - OBJECT SUMMARY -                              |
 -- +----------------------------------------------------------------------------+
 prompt <a name="object_summary"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Object Summary</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner                          HEADING 'Owner'        ENTMAP off
 COLUMN object_type FORMAT a25         HEADING 'Object Type'  ENTMAP off
 COLUMN obj_count   FORMAT 999,999,999 HEADING 'Object Count' ENTMAP off
 BREAK ON report ON owner SKIP 2
 COMPUTE sum LABEL '<font color="#990000"><b>Total: </b></font>' OF obj_count ON report
 SELECT '<b><font color="#336699">' || owner || '</font></b>'  owner , object_type object_type , count(*) obj_count
 FROM dba_objects
 GROUP BY owner , object_type
 ORDER BY owner , object_type;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                      - OBJECTS UNABLE TO EXTEND -                          |
 -- +----------------------------------------------------------------------------+
 prompt <a name="objects_unable_to_extend"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Objects Unable to Extend</b></font><hr align="left" width="460">
 prompt <b>Segments that cannot extend because of MAXEXTENTS or not enough space</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner                            HEADING 'Owner'           ENTMAP off
 COLUMN tablespace_name                  HEADING 'Tablespace Name' ENTMAP off
 COLUMN segment_name                     HEADING 'Segment Name'    ENTMAP off
 COLUMN segment_type                     HEADING 'Segment Type'    ENTMAP off
 COLUMN next_extent  FORMAT 999,999,999  HEADING 'Next Extent/KB'  ENTMAP off
 COLUMN max          FORMAT 999,999,999  HEADING 'Max Piece Size'  ENTMAP off
 COLUMN sum          FORMAT 999,999,999  HEADING 'Sum of MB'       ENTMAP off
 COLUMN extents      FORMAT 999,999,999  HEADING 'Num. of Extents' ENTMAP off
 COLUMN max_extents  FORMAT 999,999,999  HEADING 'Max Extents'     ENTMAP off
 BREAK ON report ON owner
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || ds.owner || '</b></font></div>' owner , ds.tablespace_name tablespace_name , ds.segment_name segment_name , ds.segment_type segment_type , round(ds.next_extent/1024) next_extent , NVL(dfs.max, 0) max , NVL(dfs.sum, 0) sum , ds.extents extents , ds.max_extents max_extents
 FROM dba_segments ds , (select round(max(bytes)/1048576) max , round(sum(bytes)/1048576) sum , tablespace_name from dba_free_space group by tablespace_name ) dfs
 WHERE (ds.next_extent > nvl(dfs.max, 0) OR ds.extents >= ds.max_extents) AND ds.tablespace_name = dfs.tablespace_name (+) AND ds.owner NOT IN ('SYS','SYSTEM')
 ORDER BY ds.owner , ds.tablespace_name , ds.segment_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |               - OBJECTS WHICH ARE NEARING MAXEXTENTS -                     |
 -- +----------------------------------------------------------------------------+
 prompt <a name="objects_which_are_nearing_maxextents"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Objects Which Are Nearing MAXEXTENTS</b></font><hr align="left" width="460">
 prompt <b>Segments where number of EXTENTS is less than 1/2 of MAXEXTENTS</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner                              HEADING 'Owner'             ENTMAP off
 COLUMN tablespace_name FORMAT a30         HEADING 'Tablespace name'   ENTMAP off
 COLUMN segment_name    FORMAT a30         HEADING 'Segment Name'      ENTMAP off
 COLUMN segment_type    FORMAT a20         HEADING 'Segment Type'      ENTMAP off
 COLUMN bytes           FORMAT 999,999,999 HEADING 'Size/MB'           ENTMAP off
 COLUMN next_extent     FORMAT 999,999,999 HEADING 'Next Extent/KB'    ENTMAP off
 COLUMN pct_increase                       HEADING '% Increase'        ENTMAP off
 COLUMN extents         FORMAT 999,999,999 HEADING 'Num. of Extents'   ENTMAP off
 COLUMN max_extents     FORMAT 999,999,999 HEADING 'Max Extents'       ENTMAP off
 COLUMN pct_util        FORMAT a35         HEADING '% Utilized'        ENTMAP off
 SELECT owner , tablespace_name , segment_name , segment_type , round(bytes/1048576) bytes, round(next_extent/1024) next_extent, pct_increase , extents , max_extents , '<div align="right">' || ROUND((extents/max_extents)*100, 2) || '%</div>'   pct_util
 FROM dba_segments
 WHERE extents > max_extents/2 AND max_extents != 0
 ORDER BY (extents/max_extents) DESC;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                     - OBJECTS WITHOUT STATISTICS -                         |
 -- +----------------------------------------------------------------------------+
 prompt <a name="objects_without_statistics"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Objects Without Statistics</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner                          HEAD 'Owner'       ENTMAP off
 COLUMN object_type FORMAT a20         HEAD 'Object Type' ENTMAP off
 COLUMN count       FORMAT 999,999,999 HEAD 'Count'       ENTMAP off
 BREAK ON report ON owner
 COMPUTE count LABEL '<font color="#990000"><b>Total: </b></font>' OF object_name ON report
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || owner || '</b></font></div>' owner , 'Table' object_type , count(*) count FROM dba_tables WHERE last_analyzed IS NULL AND owner NOT IN ('SYS','SYSTEM') AND partitioned = 'NO'GROUP BY owner
 UNION ALL
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || owner || '</b></font></div>' owner , 'Index' object_type , count(*) count FROM dba_indexes WHERE last_analyzed IS NULL AND owner NOT IN ('SYS','SYSTEM') AND partitioned = 'NO'GROUP BY owner
 UNION ALL
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || table_owner || '</b></font></div>'  owner , 'Table Partition' object_type , count(*) count FROM dba_tab_partitions WHERE last_analyzed IS NULL AND table_owner NOT IN ('SYS','SYSTEM') GROUP BY table_owner
 UNION ALL
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || index_owner || '</b></font></div>'  owner , 'Index Partition' object_type , count(*) count FROM dba_ind_partitions WHERE last_analyzed IS NULL AND index_owner NOT IN ('SYS','SYSTEM') GROUP BY index_owner
 ORDER BY 1 , 2 , 3;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                       - OWNER TO TABLESPACE -                              |
 -- +----------------------------------------------------------------------------+
 prompt <a name="owner_to_tablespace"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Owner to Tablespace</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner                        HEADING 'Owner'            ENTMAP off
 COLUMN tablespace_name              HEADING 'Tablespace Name'  ENTMAP off
 COLUMN segment_type                 HEADING 'Segment Type'     ENTMAP off
 COLUMN bytes     FORMAT 999,999,999 HEADING 'Size (in Bytes)'  ENTMAP off
 COLUMN seg_count FORMAT 999,999,999 HEADING 'Segment Count'    ENTMAP off
 break on report on owner
 compute sum label '<font color="#990000"><b>Total: </b></font>' of seg_count bytes on report
 SELECT '<font color="#336699"><b>'  || owner || '</b></font>' owner , '<div align="right">' || tablespace_name || '</div>' tablespace_name , '<div align="right">' || segment_type    || '</div>' segment_type , round(sum(bytes)/1048576) bytes , count(*) seg_count
 FROM dba_segments
 GROUP BY owner , tablespace_name , segment_type
 ORDER BY owner , tablespace_name , segment_type;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                     - PROCEDURAL OBJECT ERRORS -                           |
 -- +----------------------------------------------------------------------------+
 prompt <a name="procedural_object_errors"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Procedural Object Errors</b></font><hr align="left" width="460">
 prompt <b>All records from DBA_ERRORS</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner    FORMAT a85      HEAD 'Schema'      ENTMAP off
 COLUMN name     FORMAT a30      HEAD 'Object Name' ENTMAP off
 COLUMN type     FORMAT a15      HEAD 'Object Type' ENTMAP off
 COLUMN sequence FORMAT 999,999  HEAD 'Sequence'    ENTMAP off
 COLUMN line     FORMAT 999,999  HEAD 'Line'        ENTMAP off
 COLUMN position FORMAT 999,999  HEAD 'Position'    ENTMAP off
 COLUMN text                     HEAD 'Text'        ENTMAP off
 BREAK ON report ON owner
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || owner || '</b></font></div>' owner , name , type , sequence , line , position , replace(text, 'ORA-', ' ORA-') text
 FROM dba_errors
 ORDER BY 1 , 2 , 3;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                          - SEGMENT SUMMARY -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="segment_summary"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Segment Summary</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner        FORMAT a50         HEADING 'Owner'         ENTMAP off
 COLUMN segment_type FORMAT a25         HEADING 'Segment Type'  ENTMAP off
 COLUMN seg_count    FORMAT 999,999,999 HEADING 'Segment Count' ENTMAP off
 COLUMN bytes        FORMAT 999,999,999 HEADING 'Size/MB'       ENTMAP off
 BREAK ON report ON owner SKIP 2
 COMPUTE sum LABEL '<font color="#990000"><b>Total: </b></font>' OF seg_count bytes ON report
 SELECT '<b><font color="#336699">' || owner || '</font></b>'  owner , segment_type segment_type , count(*) seg_count , round(sum(bytes)/1048576) bytes
 FROM dba_segments
 GROUP BY owner , segment_type
 ORDER BY owner , segment_type;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                      - TOP 100 SEGMENTS (BY EXTENTS) -                     |
 -- +----------------------------------------------------------------------------+
 prompt <a name="top_100_segments_by_extents"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Top 100 Segments (by number of extents)</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner                       HEADING 'Owner'            ENTMAP off
 COLUMN segment_name                HEADING 'Segment Name'     ENTMAP off
 COLUMN partition_name              HEADING 'Partition Name'   ENTMAP off
 COLUMN segment_type                HEADING 'Segment Type'     ENTMAP off
 COLUMN tablespace_name             HEADING 'Tablespace Name'  ENTMAP off
 COLUMN extents  FORMAT 999,999,999 HEADING 'Extents'          ENTMAP off
 COLUMN bytes    FORMAT 999,999,999 HEADING 'Size/MB'          ENTMAP off
 BREAK ON report
 COMPUTE sum LABEL '<font color="#990000"><b>Total: </b></font>' OF extents bytes ON report
 SELECT a.owner , a.segment_name , a.partition_name , a.segment_type , a.tablespace_name , a.extents , round(a.bytes/1048576) bytes
 FROM (select b.owner , b.segment_name , b.partition_name , b.segment_type , b.tablespace_name , b.bytes , b.extents from dba_segments b order by b.extents desc ) a
 WHERE rownum < 100;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |             - USERS WITH DEFAULT TABLESPACE - (SYSTEM) -                   |
 -- +----------------------------------------------------------------------------+
 prompt <a name="users_with_default_tablespace_defined_as_system"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Users With Default Tablespace - (SYSTEM)</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN username                        HEADING 'Username'             ENTMAP off
 COLUMN default_tablespace   FORMAT a55 HEADING 'Default Tablespace'   ENTMAP off
 COLUMN temporary_tablespace FORMAT a55 HEADING 'Temporary Tablespace' ENTMAP off
 COLUMN created                         HEADING 'Created'              ENTMAP off
 COLUMN account_status                  HEADING 'Account Status'       ENTMAP off
 SELECT '<font color="#336699"><b>' || username || '</font></b>' username , '<div align="left">' || default_tablespace   || '</div>' default_tablespace , '<div align="left">' || temporary_tablespace || '</div>' temporary_tablespace , '<div align="right">' || TO_CHAR(created, 'yyyy-mm-dd HH24:MI:SS') || '</div>'  created , DECODE(   account_status , 'OPEN', '<div align="center"><b><font color="darkgreen">' || account_status || '</font></b></div>', '<div align="center"><b><font color="#663300">'   || account_status || '</font></b></div>') account_status
 FROM dba_users
 WHERE default_tablespace = 'SYSTEM'
 ORDER BY username;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |          - USERS WITH DEFAULT TEMPORARY TABLESPACE - (SYSTEM) -            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="users_with_default_temporary_tablespace_as_system"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Users With Default Temporary Tablespace - (SYSTEM)</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN username                        HEADING 'Username'             ENTMAP off
 COLUMN default_tablespace   FORMAT a55 HEADING 'Default Tablespace'   ENTMAP off
 COLUMN temporary_tablespace FORMAT a55 HEADING 'Temporary Tablespace' ENTMAP off
 COLUMN created                         HEADING 'Created'              ENTMAP off
 COLUMN account_status                  HEADING 'Account Status'       ENTMAP off
 SELECT '<font color="#336699"><b>'  || username || '</font></b>' username , '<div align="center">' || default_tablespace || '</div>' default_tablespace , '<div align="center">' || temporary_tablespace || '</div>' temporary_tablespace , '<div align="right">' || TO_CHAR(created, 'yyyy-mm-dd HH24:MI:SS') || '</div>'  created , DECODE(   account_status , 'OPEN', '<div align="center"><b><font color="darkgreen">' || account_status || '</font></b></div>', '<div align="center"><b><font color="#663300">'   || account_status || '</font></b></div>') account_status
 FROM dba_users
 WHERE temporary_tablespace = 'SYSTEM'
 ORDER BY username;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Partitions ( Table and Index)</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                       - Partition Index Detail -                           |
 -- +----------------------------------------------------------------------------+
 prompt <a name="part_index_detail"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Partition Index Detail</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner             for a30 HEADING 'Owner'             ENTMAP off
 COLUMN table_name        for a50 HEADING 'Table Name'        ENTMAP off
 COLUMN partitioning_name for a30 HEADING 'Partition Name'    ENTMAP off
 COLUMN columns                   HEADING 'Partition Columns' ENTMAP off
 COLUMN high_value        for a30 HEADING 'High Value'        ENTMAP off
 COLUMN tablespace_name   for a30 HEADING 'Tablespace Name'   ENTMAP off
 COLUMN compression               HEADING 'Compression'       ENTMAP off
 BREAK on owner
 select '<div nowrap align="left"><font color="#336699"><b>' || index_owner || '</b></font></div>'    owner , index_name , partition_name , columns , high_value , tablespace_name , compression
 from dba_ind_partitions p, (select owner,name,max(decode(column_position,1,column_name,null)) ||max(decode(column_position,2,', '||column_name,null)) ||max(decode(column_position,3,', '||column_name,null)) ||max(decode(column_position,4,', '||column_name,null)) ||max(decode(column_position,5,', '||column_name,null)) columns from dba_PART_KEY_COLUMNS where object_type='INDEX'group by owner,name ) c
 where p.index_name=c.name and p.index_owner=c.owner and index_owner NOT IN (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 order by index_owner,index_name,partition_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                      - Partition Index Summary -                           |
 -- +----------------------------------------------------------------------------+
 prompt <a name="part_index_summary"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Partition Index Summary</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner                for a30 HEADING 'Owner'              ENTMAP off
 COLUMN index_name           for a50 HEADING 'Index Name'         ENTMAP off
 COLUMN table_name           for a50 HEADING 'Table Name'         ENTMAP off
 COLUMN locality             for a50 HEADING 'Local ?'            ENTMAP off
 COLUMN partitioning_type    for a30 HEADING 'Partition Type'     ENTMAP off
 COLUMN partition_count              HEADING 'Partition Count'    ENTMAP off
 COLUMN subpartitioning_type for a30 HEADING 'Subpartition Type'  ENTMAP off
 COLUMN def_subpartition_count       HEADING 'Subpartition Count' ENTMAP off
 COLUMN def_tablespace_name          HEADING 'Tablespace Name'    ENTMAP off
 BREAK on owner
 select  '<div nowrap align="left"><font color="#336699"><b>' || owner || '</b></font></div>' owner , index_name , table_name , locality , def_tablespace_name ,  '<div nowrap align="center"><b>' ||partitioning_type || '</b></div>' partitioning_type ,  '<div nowrap align="center"><b>' ||partition_count || '</b></div>' partition_count ,  '<div nowrap align="center"><b>' ||subpartitioning_type   || '</b></div>' subpartitioning_type ,  '<div nowrap align="center"><b>' ||def_subpartition_count || '</b></div>' def_subpartition_count
 from dba_part_indexes
 where owner NOT IN ('CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 order by owner;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                       - Partition Table Detail -                           |
 -- +----------------------------------------------------------------------------+
 prompt <a name="part_table_detail"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Partition Table Detail</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner             for a30 HEADING 'Owner'             ENTMAP off
 COLUMN table_name        for a50 HEADING 'Table Name'        ENTMAP off
 COLUMN partitioning_name for a30 HEADING 'Partition Name'    ENTMAP off
 COLUMN columns                   HEADING 'Partition Columns' ENTMAP off
 COLUMN high_value        for a30 HEADING 'High Value'        ENTMAP off
 COLUMN tablespace_name   for a30 HEADING 'Tablespace Name'   ENTMAP off
 COLUMN compression               HEADING 'Compression'       ENTMAP off
 BREAK on owner
 select '<div nowrap align="left"><font color="#336699"><b>' || table_owner || '</b></font></div>'    owner , table_name , partition_name , columns , high_value , tablespace_name , compression
 from dba_tab_partitions p, (select owner,name,max(decode(column_position,1,column_name,null)) ||max(decode(column_position,2,', '||column_name,null)) ||max(decode(column_position,3,', '||column_name,null)) ||max(decode(column_position,4,', '||column_name,null)) ||max(decode(column_position,5,', '||column_name,null)) columns from dba_PART_KEY_COLUMNS where object_type='TABLE'group by owner,name ) c
 where p.table_name=c.name and p.table_owner=c.owner and table_owner NOT IN (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 order by table_owner,table_name,partition_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                      - Partition Table Summary -                           |
 -- +----------------------------------------------------------------------------+
 prompt <a name="part_table_summary"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Partition Table Summary</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner                for a30 HEADING 'Owner'              ENTMAP off
 COLUMN table_name           for a50 HEADING 'Table Name'         ENTMAP off
 COLUMN partitioning_type    for a30 HEADING 'Partition Type'     ENTMAP off
 COLUMN partition_count              HEADING 'Partition Count'    ENTMAP off
 COLUMN subpartitioning_type for a30 HEADING 'Subpartition Type'  ENTMAP off
 COLUMN def_subpartition_count       HEADING 'Subpartition Count' ENTMAP off
 COLUMN def_tablespace_name          HEADING 'Tablespace Name'    ENTMAP off
 BREAK on owner
 select  '<div nowrap align="left"><font color="#336699"><b>' || owner || '</b></font></div>' owner , table_name , def_tablespace_name ,  '<div nowrap align="center"><b>' ||partitioning_type || '</b></div>' partitioning_type ,  '<div nowrap align="center"><b>' ||partition_count || '</b></div>' partition_count ,  '<div nowrap align="center"><b>' ||subpartitioning_type   || '</b></div>' subpartitioning_type ,  '<div nowrap align="center"><b>' ||def_subpartition_count || '</b></div>' def_subpartition_count
 from dba_part_tables
 where owner NOT IN (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 order by owner;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                     - List Partition Without Default -                     |
 -- +----------------------------------------------------------------------------+
 prompt <a name="list_no_default"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>List Partition Without Default</b></font><hr align="left" width="460">
 prompt Because of HIGH_VALUE column in DBA_TAB_PARTITIONS is LONG, It's hardly to convert and compare it <br /> So we does not support in this scripts
 --CLEAR COLUMNS BREAKS COMPUTES
 --COLUMN owner    HEADING 'Owner'             ENTMAP off
 --COLUMN name     HEADING 'Table Name'        ENTMAP off
 --COLUMN type     HEADING 'Partition Type'    ENTMAP off
 --COLUMN sub_type HEADING 'SubPartition Type' ENTMAP off
 --COLUMN tbs_name HEADING 'Tablespace Name'   ENTMAP off
 --BREAK on owner
 --select '<div nowrap align="left"><font color="#336699"><b>' || p.owner || '</b></font></div>'    owner
 --    , p.table_name name
 --    , '<font color="red"><b>' || p.partitioning_type || '</b></font>' type
 --    , p.subpartitioning_type sub_type
 --    , p.def_tablespace_name tbs_name
 --from (SELECT table_owner,table_name,sum(decode(substr(high_value,1,7),'default',1,0)) tips
 --        FROM (SELECT TABLE_OWNER,TABLE_NAME,PARTITION_NAME, HIGH_VALUE FROM DBA_TAB_PARTITIONS)
 --      group by table_owner,table_name
 --     having sum(decode(substr(high_value,1,7),'default',1,0))=0) v
 --     , dba_part_tables p
 --where v.table_owner=p.owner
 --  and v.table_name=p.table_name
 --  and p.partitioning_type='LIST'
 --  and v.table_owner NOT IN (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 --union all
 --select '<div nowrap align="left"><font color="#336699"><b>' || p.owner || '</b></font></div>'    owner
 --   , p.table_name name
 --   , p.partitioning_type type
 --   , '<font color="red"><b>' || p.subpartitioning_type || '</b></font>' sub_type
 --   , p.def_tablespace_name tbs_name
 --  from (SELECT table_owner,table_name,sum(decode(substr(high_value,1,7),'default',1,0)) tips
 --          FROM (SELECT TABLE_OWNER,TABLE_NAME,PARTITION_NAME, HIGH_VALUE FROM DBA_TAB_SUBPARTITIONS)
 --         group by table_owner,table_name
 --        having sum(decode(substr(high_value,1,7),'default',1,0))=0) v
 --  , dba_part_tables p
 --  where v.table_owner=p.owner
 --    and v.table_name=p.table_name
 --    and p.subpartitioning_type='LIST'
 --    and v.table_owner NOT IN (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 --order by 1;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                   - Range Partition Without MaxValue -                     |
 -- +----------------------------------------------------------------------------+
 prompt <a name="range_no_maxvalue"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Range Partition Without MaxValue</b></font><hr align="left" width="460">
 prompt Because of HIGH_VALUE column in DBA_TAB_PARTITIONS is LONG, It's hardly to convert and compare it <br /> So we does not support in this scripts
 --CLEAR COLUMNS BREAKS COMPUTES
 --COLUMN owner      for a30 HEADING 'Owner'             ENTMAP off
 --COLUMN name       for a30 HEADING 'Table Name'        ENTMAP off
 --COLUMN type       for a30 HEADING 'Partition Type'    ENTMAP off
 --COLUMN sub_type   for a30 HEADING 'SubPartition Type' ENTMAP off
 --COLUMN high_value for a30 HEADING 'High Value'        ENTMAP off
 --COLUMN tbs_name   for a30 HEADING 'Tablespace Name'   ENTMAP off
 --BREAK on owner
 --select '<div nowrap align="left"><font color="#336699"><b>' || p.owner || '</b></font></div>'    owner
 --    , p.table_name name
 --    , '<font color="red"><b>' || p.partitioning_type || '</b></font>' type
 --    , p.subpartitioning_type sub_type
 --    , v.high_value high_value
 --    , p.def_tablespace_name tbs_name
 --from (SELECT table_owner,table_name,max(high_value) high_value,sum(decode(substr(high_value,1,8),'MAXVALUE',1,0)) tips
 --        FROM (SELECT TABLE_OWNER,TABLE_NAME,PARTITION_NAME, HIGH_VALUE
 --          FROM DBA_TAB_PARTITIONS)
 --      group by table_owner,table_name
 --     having sum(decode(high_value,'MAXVALUE',1,0))=0) v
 --     , dba_part_tables p
 --where v.table_owner=p.owner
 --  and v.table_name=p.table_name
 --  and p.partitioning_type='RANGE'
 --  and v.table_owner NOT IN (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 --union all
 --select '<div nowrap align="left"><font color="#336699"><b>' || p.owner || '</b></font></div>'    owner
 --   , p.table_name name
 --   , p.partitioning_type type
 --   , '<font color="red"><b>' || p.subpartitioning_type || '</b></font>' sub_type
 --   , v.high_value high_value
 --   , p.def_tablespace_name tbs_name
 --  from (SELECT table_owner,table_name,max(high_value) high_value,sum(decode(substr(high_value,1,8),'MAXVALUE',1,0)) tips
 --          FROM (SELECT TABLE_OWNER,TABLE_NAME,PARTITION_NAME, HIGH_VALUE FROM DBA_TAB_SUBPARTITIONS)
 --         group by table_owner,table_name
 --        having sum(decode(high_value,'MAXVALUE',1,0))=0) v
 --  , dba_part_tables p
 --  where v.table_owner=p.owner
 --    and v.table_name=p.table_name
 --    and p.subpartitioning_type='RANGE'
 --    and v.table_owner NOT IN (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 --order by 1;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                   - Global Indexes on Partition Table -                    |
 -- +----------------------------------------------------------------------------+
 prompt <a name="global_ind_part_table"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Global Indexes on Partition Table</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner                for a30 HEADING 'Owner'              ENTMAP off
 COLUMN Index_name           for a50 HEADING 'Index Name'         ENTMAP off
 COLUMN table_name           for a50 HEADING 'Table Name'         ENTMAP off
 COLUMN partitioning_type    for a30 HEADING 'Partition Type'     ENTMAP off
 COLUMN subpartitioning_type for a30 HEADING 'Sub Partition Type' ENTMAP off
 COLUMN tablespace_name      for a30 HEADING 'Tablespace Name'    ENTMAP off
 BREAK on owner
 select '<div nowrap align="left"><font color="#336699"><b>' || i.owner || '</b></font></div>'    owner , i.index_name index_name , i.table_name table_name , i.partitioning_type partitioning_type , i.subpartitioning_type subpartitioning_type , i.def_tablespace_name tablespace_name
  from dba_part_indexes i,dba_part_tables t
 where i.owner=t.owner and i.table_name=t.table_name and i.locality='GLOBAL'and i.owner NOT IN (  'CTXSYS', 'DBSNMP', 'DMSYS', 'EXFSYS', 'IX', 'LBACSYS', 'MDSYS', 'OLAPSYS', 'ORDSYS', 'OUTLN', 'SYS', 'SYSMAN', 'SYSTEM', 'WKSYS', 'WMSYS', 'XDB', 'DIP', 'TSMSYS', 'ORACLE_OCM', 'PUBLIC')
 order by owner,index_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Online Analytical Processing - (OLAP)</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                        - MATERIALIZED VIEW LOGS -                          |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_olap_materialized_view_logs"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Materialized View Logs</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN log_owner          HEADING 'Log Owner'            ENTMAP off
 COLUMN log_table          HEADING 'Log Table'            ENTMAP off
 COLUMN master             HEADING 'Master'               ENTMAP off
 COLUMN log_trigger        HEADING 'Log Trigger'          ENTMAP off
 COLUMN rowids             HEADING 'Rowids?'              ENTMAP off
 COLUMN primary_key        HEADING 'Primary Key?'         ENTMAP off
 COLUMN object_id          HEADING 'Object ID?'           ENTMAP off
 COLUMN filter_columns     HEADING 'Filter Columns?'      ENTMAP off
 COLUMN sequence           HEADING 'Sequence?'            ENTMAP off
 COLUMN include_new_values HEADING 'Include New Values?'  ENTMAP off
 BREAK ON log_owner
 SELECT '<div align="left"><font color="#336699"><b>' || ml.log_owner || '</b></font></div>' log_owner , ml.log_table log_table , ml.master master , ml.log_trigger log_trigger , '<div align="center">' || NVL(ml.rowids,'<br>') || '</div>'  rowids , '<div align="center">' || NVL(ml.primary_key,'<br>') || '</div>'  primary_key , '<div align="center">' || NVL(ml.object_id,'<br>') || '</div>'  object_id , '<div align="center">' || NVL(ml.filter_columns,'<br>') || '</div>'  filter_columns , '<div align="center">' || NVL(ml.sequence,'<br>') || '</div>'  sequence , '<div align="center">' || NVL(ml.include_new_values,'<br>')  || '</div>'  include_new_values
 FROM dba_mview_logs  ml
 ORDER BY ml.log_owner , ml.master;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                   - MATERIALIZED VIEW REFRESH GROUPS -                     |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_olap_materialized_view_refresh_groups"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Materialized View Refresh Groups</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner         HEADING 'Owner'        ENTMAP off
 COLUMN name          HEADING 'Name'         ENTMAP off
 COLUMN broken        HEADING 'Broken?'      ENTMAP off
 COLUMN next_date     HEADING 'Next Date'    ENTMAP off
 COLUMN interval      HEADING 'Interval'     ENTMAP off
 BREAK ON report ON owner
 SELECT '<div nowrap align="left"><font color="#336699"><b>' || rowner || '</b></font></div>'  owner , '<div align="left">' || rname || '</div>' name , '<div align="center">' || broken || '</div>' broken , '<div nowrap align="right">' || NVL(TO_CHAR(next_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>' next_date , '<div nowrap align="right">' || interval || '</div>' interval
 FROM dba_refresh
 ORDER BY rowner , rname;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                          - MATERIALIZED VIEWS -                            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="dba_olap_materialized_views"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Materialized Views</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner              HEADING 'Owner'               ENTMAP off
 COLUMN mview_name         HEADING 'MView|Name'          ENTMAP off
 COLUMN master_link        HEADING 'Master|Link'         ENTMAP off
 COLUMN updatable          HEADING 'Updatable?'          ENTMAP off
 COLUMN update_log         HEADING 'Update|Log'          ENTMAP off
 COLUMN rewrite_enabled    HEADING 'Rewrite|Enabled?'    ENTMAP off
 COLUMN refresh_mode       HEADING 'Refresh|Mode'        ENTMAP off
 COLUMN refresh_method     HEADING 'Refresh|Method'      ENTMAP off
 COLUMN build_mode         HEADING 'Build|Mode'          ENTMAP off
 COLUMN fast_refreshable   HEADING 'Fast|Refreshable'    ENTMAP off
 COLUMN last_refresh_type  HEADING 'Last Refresh|Type'   ENTMAP off
 COLUMN last_refresh_date  HEADING 'Last Refresh|Date'   ENTMAP off
 COLUMN staleness          HEADING 'Staleness'           ENTMAP off
 COLUMN compile_state      HEADING 'Compile State'       ENTMAP off
 BREAK ON owner
 SELECT '<div align="left"><font color="#336699"><b>' || m.owner || '</b></font></div>' owner , m.mview_name mview_name , m.master_link master_link , '<div align="center">' || NVL(m.updatable,'<br>') || '</div>' updatable , update_log update_log , '<div align="center">' || NVL(m.rewrite_enabled,'<br>')  || '</div>' rewrite_enabled , m.refresh_mode refresh_mode , m.refresh_method refresh_method , m.build_mode build_mode , m.fast_refreshable fast_refreshable , m.last_refresh_type last_refresh_type , '<div nowrap align="right">' || TO_CHAR(m.last_refresh_date, 'yyyy-mm-dd HH24:MI:SS') || '</div>'  last_refresh_date , m.staleness staleness , DECODE(   m.compile_state , 'VALID', '<div align="center"><font color="darkgreen"><b>' || m.compile_state || '</b></font></div>', '<div align="center"><font color="#990000"><b>'   || m.compile_state || '</b></font></div>' ) compile_state
 FROM dba_mviews m
 ORDER BY owner , mview_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
 <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Networking</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |             - MTS DISPATCHER RESPONSE QUEUE WAIT STATS -                   |
 -- +----------------------------------------------------------------------------+
 prompt <a name="mts_dispatcher_response_queue_wait_stats"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>MTS Dispatcher Response Queue Wait Stats</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN type        HEADING 'Type'                         ENTMAP off
 COLUMN avg_wait    HEADING 'Avg Wait Time Per Response'   ENTMAP off
 SELECT a.type , DECODE( SUM(a.totalq), 0, 'NO RESPONSES', SUM(a.wait)/SUM(a.totalq) || ' HUNDREDTHS OF SECONDS') avg_wait
 FROM v$queue a
 WHERE a.type='DISPATCHER'
 GROUP BY a.type;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                     - MTS DISPATCHER STATISTICS -                          |
 -- +----------------------------------------------------------------------------+
 prompt <a name="mts_dispatcher_statistics"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>MTS Dispatcher Statistics</b></font><hr align="left" width="460">
 prompt <b>Dispatcher rate</b>
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN name                 HEADING 'Name'                  ENTMAP off
 COLUMN avg_loop_rate        HEADING 'Avg|Loop|Rate'         ENTMAP off
 COLUMN avg_event_rate       HEADING 'Avg|Event|Rate'        ENTMAP off
 COLUMN avg_events_per_loop  HEADING 'Avg|Events|Per|Loop'   ENTMAP off
 COLUMN avg_msg_rate         HEADING 'Avg|Msg|Rate'          ENTMAP off
 COLUMN avg_svr_buf_rate     HEADING 'Avg|Svr|Buf|Rate'      ENTMAP off
 COLUMN avg_svr_byte_rate    HEADING 'Avg|Svr|Byte|Rate'     ENTMAP off
 COLUMN avg_svr_byte_per_buf HEADING 'Avg|Svr|Byte|Per|Buf'  ENTMAP off
 COLUMN avg_clt_buf_rate     HEADING 'Avg|Clt|Buf|Rate'      ENTMAP off
 COLUMN avg_clt_byte_rate    HEADING 'Avg|Clt|Byte|Rate'     ENTMAP off
 COLUMN avg_clt_byte_per_buf HEADING 'Avg|Clt|Byte|Per|Buf'  ENTMAP off
 COLUMN avg_buf_rate         HEADING 'Avg|Buf|Rate'          ENTMAP off
 COLUMN avg_byte_rate        HEADING 'Avg|Byte|Rate'         ENTMAP off
 COLUMN avg_byte_per_buf     HEADING 'Avg|Byte|Per|Buf'      ENTMAP off
 COLUMN avg_in_connect_rate  HEADING 'Avg|In|Connect|Rate'   ENTMAP off
 COLUMN avg_out_connect_rate HEADING 'Avg|Out|Connect|Rate'  ENTMAP off
 COLUMN avg_reconnect_rate   HEADING 'Avg|Reconnect|Rate'    ENTMAP off
 SELECT name , avg_loop_rate , avg_event_rate , avg_events_per_loop , avg_msg_rate , avg_svr_buf_rate , avg_svr_byte_rate , avg_svr_byte_per_buf , avg_clt_buf_rate , avg_clt_byte_rate , avg_clt_byte_per_buf , avg_buf_rate , avg_byte_rate , avg_byte_per_buf , avg_in_connect_rate , avg_out_connect_rate , avg_reconnect_rate
 FROM v$dispatcher_rate
 ORDER BY name;
 COLUMN protocol        HEADING 'Protocol'         ENTMAP off
 COLUMN total_busy_rate HEADING 'Total Busy Rate'  ENTMAP off
 prompt <b>Dispatcher busy rate</b>
 SELECT a.network protocol , (SUM(a.BUSY) / (SUM(a.BUSY) + SUM(a.IDLE))) total_busy_rate
 FROM v$dispatcher a
 GROUP BY a.network;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                  - MTS SHARED SERVER WAIT STATISTICS -                     |
 -- +----------------------------------------------------------------------------+
 prompt <a name="mts_shared_server_wait_statistics"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>MTS Shared Server Wait Statistics</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN avg_wait   HEADING 'Average Wait Time Per Request'  ENTMAP off
 SELECT DECODE(a.totalq, 0, 'No Requests', a.wait/a.totalq || ' HUNDREDTHS OF SECONDS') avg_wait
 FROM v$queue a
 WHERE a.type='COMMON';
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p> <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Replication</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                         - REPLICATION SUMMARY -                            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="replication_summary"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Replication Summary</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN gname           HEADING 'Current Database Name'       ENTMAP off
 COLUMN admin_request   HEADING '# Admin. Requests'           ENTMAP off
 COLUMN status          HEADING '# Admin. Request Errors'     ENTMAP off
 COLUMN df_txn          HEADING '# Def. Trans'                ENTMAP off
 COLUMN df_error        HEADING '# Def. Tran Errors'          ENTMAP off
 COLUMN complete        HEADING '# Complete Trans in Queue'   ENTMAP off
 SELECT g.global_name gname , d.admin_request admin_request , e.status status , dt.tran df_txn , de.error df_error , c.complete complete
 FROM (select global_name from global_name)  g , (select count(id) admin_request from dba_repcatlog) d , (select count(status) status from dba_repcatlog where status = 'ERROR') e , (select count(*) tran from deftrandest) dt , (select count(*) error from deferror) de , (select count(a.deferred_tran_id) complete from deftran a where a.deferred_tran_id not in (select b.deferred_tran_id from deftrandest b) ) c;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                      - INITIALIZATION PARAMETERS -                         |
 -- +----------------------------------------------------------------------------+
 prompt <a name="rep_initialization_parameters"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Initialization Parameters</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN pname             FORMAT a55  HEADING 'Parameter Name' ENTMAP off
 COLUMN value             FORMAT a55  HEADING 'Value'          ENTMAP off
 COLUMN isdefault         FORMAT a55  HEADING 'Is Default?'    ENTMAP off
 COLUMN issys_modifiable  FORMAT a55  HEADING 'Is Dynamic?'    ENTMAP off
 SELECT DECODE( isdefault , 'FALSE', '<b><font color="#336699">' || SUBSTR(name,0,512) || '</font></b>', '<b><font color="#336699">' || SUBSTR(name,0,512) || '</font></b>' ) pname , DECODE(   isdefault , 'FALSE', '<font color="#663300"><b>' || SUBSTR(value,0,512) || '</b></font>', SUBSTR(value,0,512) ) value , DECODE(   isdefault , 'FALSE', '<div align="right"><font color="#663300"><b>' || isdefault || '</b></font></div>', '<div align="right">' || isdefault || '</div>') isdefault , DECODE(   isdefault , 'FALSE', '<div align="right"><font color="#663300"><b>' || issys_modifiable || '</b></font></div>', '<div align="right">' || issys_modifiable || '</div>') issys_modifiable
 FROM v$parameter
 WHERE name IN ( 'compatible', 'commit_point_strength', 'dblink_encrypt_login', 'distributed_lock_timeout', 'distributed_recovery_connection_hold_time', 'distributed_transactions', 'global_names', 'job_queue_interval', 'job_queue_processes', 'max_transaction_branches', 'open_links', 'open_links_per_instance', 'parallel_automatic_tuning', 'parallel_max_servers', 'parallel_min_servers', 'parallel_server_idle_time', 'processes', 'remote_dependencies_mode', 'replication_dependency_tracking', 'shared_pool_size', 'utl_file_dir')
 ORDER BY name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                        - DEFERRED TRANSACTIONS -                           |
 -- +----------------------------------------------------------------------------+
 prompt <a name="deferred_transactions"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Deferred Transactions</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN source     HEADING 'Source'              ENTMAP off
 COLUMN dest       HEADING 'Target'              ENTMAP off
 COLUMN trans      HEADING '# Def. Trans'        ENTMAP off
 COLUMN errors     HEADING '# Def. Tran Errors'  ENTMAP off
 SELECT source , dest , trans , errors
 FROM (select e.origin_tran_db   source , e.destination dest , 'n/a' trans , to_char(count(*))  errors from deferror e group by e.origin_tran_db , e.destination union select g.global_name source , d.dblink dest , to_char(count(*))  trans , 'n/a' errors from (select global_name from global_name)  g ,  deftran t ,  deftrandest d where d.deferred_tran_id = t.deferred_tran_id group by g.global_name, d.dblink );
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                     - ADMINISTRATIVE REQUEST JOBS -                        |
 -- +----------------------------------------------------------------------------+
 prompt <a name="administrative_request_jobs"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Administrative Request Jobs</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN job               HEADING 'Job ID'             ENTMAP off
 COLUMN priv_user         HEADING 'Privilege Schema'   ENTMAP off
 COLUMN what FORMAT a175  HEADING 'Definition'         ENTMAP off
 COLUMN status            HEADING 'Status'             ENTMAP off
 COLUMN next_date         HEADING 'Start'              ENTMAP off
 COLUMN interval          HEADING 'Interval'           ENTMAP off
 SELECT job job , priv_user priv_user , what what , DECODE(broken, 'Y', 'Broken', 'Normal') status , '<div nowrap align="right">' || NVL(TO_CHAR(next_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>'   next_date , interval
 FROM dba_jobs
 WHERE what LIKE '%dbms_repcat.do_deferred_repcat_admin%'
 ORDER BY 1;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                        - (SCHEDULE) - PURGE JOBS -                         |
 -- +----------------------------------------------------------------------------+
 prompt <a name="schedule_purge_jobs"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>(Schedule) - Purge Jobs</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN job       HEADING 'Job ID'            ENTMAP off
 COLUMN priv_user HEADING 'Privilege Schema'  ENTMAP off
 COLUMN status    HEADING 'Status'            ENTMAP off
 COLUMN next_date HEADING 'Start'             ENTMAP off
 COLUMN interval  HEADING 'Interval'          ENTMAP off
 SELECT j.job job , j.priv_user priv_user , decode(broken, 'Y', 'Broken', 'Normal') status , '<div nowrap align="right">' || NVL(TO_CHAR(s.next_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>' next_date , s.interval interval
 FROM defschedule   s , dba_jobs j
 WHERE s.dblink = (select global_name from global_name) AND s.interval is not null AND s.job = j.job
 ORDER BY 1;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                       - (SCHEDULE) - PUSH JOBS -                           |
 -- +----------------------------------------------------------------------------+
 prompt <a name="schedule_push_jobs"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>(Schedule) - Push Jobs</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN job        HEADING 'Job ID'           ENTMAP off
 COLUMN priv_user  HEADING 'Privilege Schema' ENTMAP off
 COLUMN dblink     HEADING 'Target'           ENTMAP off
 COLUMN broken     HEADING 'Status'           ENTMAP off
 COLUMN next_date  HEADING 'Start'            ENTMAP off
 COLUMN interval   HEADING 'Interval'         ENTMAP off
 SELECT j.job job , j.priv_user priv_user , s.dblink dblink , decode(j.broken, 'Y', 'Broken', 'Normal') broken , '<div nowrap align="right">' || NVL(TO_CHAR(s.next_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>' next_date , s.interval interval
 FROM defschedule  s , dba_jobs j
 WHERE s.dblink != (select global_name from global_name) AND s.interval is not null AND s.job = j.job
 ORDER BY 1;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                      - (SCHEDULE) - REFRESH JOBS -                         |
 -- +----------------------------------------------------------------------------+
 prompt <a name="schedule_refresh_jobs"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>(Schedule) - Refresh Jobs</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN job                   HEADING 'Job ID'           ENTMAP off
 COLUMN priv_user             HEADING 'Privilege Schema' ENTMAP off
 COLUMN refresh_group         HEADING 'Refresh Group'    ENTMAP off
 COLUMN broken                HEADING 'Status'           ENTMAP off
 COLUMN next_date FORMAT a75  HEADING 'Start'            ENTMAP off
 COLUMN interval  FORMAT a75  HEADING 'Interval'         ENTMAP off
 SELECT j.job job , j.priv_user priv_user , r.rowner || '.' || r.rname refresh_group , decode(j.broken, 'Y', 'Broken', 'Normal') broken , '<div nowrap align="right">' || NVL(TO_CHAR(j.next_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>' next_date , '<div nowrap align="right">' || j.interval || '</div>' interval
 FROM dba_refresh  r , dba_jobs j
 WHERE r.job = j.job
 order by 1;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |               - (MULTI-MASTER) - MASTER GROUPS AND SITES -                 |
 -- +----------------------------------------------------------------------------+
 prompt <a name="multimaster_master_groups_and_sites"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>(Multi-Master) - Master Groups and Sites</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN master_group             HEADING 'Master Group'            ENTMAP off
 COLUMN sites                    HEADING 'Sites'                   ENTMAP off
 COLUMN master_definition_site   HEADING 'Master Definition Site'  ENTMAP off
 SELECT gname master_group , dblink sites , DECODE(masterdef, 'Y', 'YES', 'N', 'NO')  master_definition_site
 FROM dba_repsites
 WHERE master = 'Y'AND gname NOT IN (SELECT gname from dba_repsites WHERE snapmaster = 'Y')
 ORDER BY gname;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                    - (MULTI-MASTER) - MASTER GROUPS -                      |
 -- +----------------------------------------------------------------------------+
 prompt <a name="multimaster_master_groups"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>(Multi-Master) - Master Groups</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN name                       HEADING 'Master Group'             ENTMAP off
 COLUMN num_def_trans              HEADING '# Def. Trans'             ENTMAP off
 COLUMN num_tran_errors            HEADING '# Def. Tran Errors'       ENTMAP off
 COLUMN num_admin_requests         HEADING '# Admin. Requests'        ENTMAP off
 COLUMN num_admin_request_errors   HEADING '# Admin. Request Errors'  ENTMAP off
 SELECT g.gname name , NVL(t.cnt1, 0) num_def_trans , NVL(ie.cnt2, 0) num_tran_errors , NVL(a.cnt3, 0) num_admin_requests , NVL(b.cnt4, 0) num_admin_request_errors
 FROM (select distinct gname from dba_repgroup where master='Y') g , (select rog rog , count(dt.deferred_tran_id) cnt1 from (select distinct ro.gname rog , d.deferred_tran_id  dft from dba_repobject  ro , defcall d , deftrANDest td where ro.sname = d.schemaname AND ro.oname = d.packagename AND ro.type in ('TABLE', 'PACKAGE', 'SNAPSHOT') AND td.deferred_tran_id = d.deferred_tran_id ) t0, deftrANDest dt where dt.deferred_tran_id = dft group by rog ) t , (select distinct ro.gname , count(distinct e.deferred_tran_id) cnt2 from dba_repobject  ro , defcall d , deferror e where ro.sname = d.schemaname AND ro.oname = d.packagename AND ro.type in ('TABLE', 'PACKAGE', 'SNAPSHOT') AND e.deferred_tran_id = d.deferred_tran_id AND e.callno = d.callno group by ro.gname ) ie , (select gname, count(*) cnt3 from dba_repcatlog group by gname ) a , (select gname, count(*) cnt4 from dba_repcatlog where status = 'ERROR'group BY gname ) b
 WHERE g.gname = ie.gname (+) AND g.gname = t.rog (+) AND g.gname = a.gname (+) AND g.gname = b.gname (+)
 ORDER BY g.gname;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                 - (MATERIALIZED VIEW) - SITE GROUPS -                      |
 -- +----------------------------------------------------------------------------+
 prompt <a name="materialized_view_groups"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>(Materialized View) - Site Groups</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN gname         HEADING 'Name'           ENTMAP off
 COLUMN dblink        HEADING 'Master'         ENTMAP off
 COLUMN propagation   HEADING 'Propagation'    ENTMAP off
 COLUMN remark        HEADING 'Remark'         ENTMAP off
 SELECT s.gname gname , s.dblink dblink , decode(s.prop_updates, 0, 'Async', 'Sync')   propagation , g.schema_comment remark
 FROM dba_repsites  s , dba_repgroup  g
 WHERE s.gname = g.gname AND s.snapmaster = 'Y'
 ORDER BY s.gname;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |               - (MATERIALIZED VIEW) - MASTER SITE LOGS -                   |
 -- +----------------------------------------------------------------------------+
 prompt <a name="materialized_view_master_site_logs"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>(Materialized View) - Master Site Logs</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN log_owner      HEADING 'Log Owner'      ENTMAP off
 COLUMN log_table      HEADING 'Log Table'      ENTMAP off
 COLUMN master         HEADING 'Master'         ENTMAP off
 COLUMN rowids         HEADING 'Row ID'         ENTMAP off
 COLUMN primary_key    HEADING 'Primary Key'    ENTMAP off
 COLUMN filter_columns HEADING 'Filter Columns' ENTMAP off
 BREAK ON report ON log_owner
 SELECT '<div align="left"><font color="#336699"><b>' || log_owner || '</b></font></div>'  log_owner , log_table , master , '<div align="center">' || rowids || '</div>'   rowids , '<div align="center">' || primary_key || '</div>'   primary_key , '<div align="center">' || filter_columns  || '</div>'   filter_columns
 FROM dba_snapshot_logs
 ORDER BY log_owner;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |               - (MATERIALIZED VIEW) - MASTER SITE SUMMARY -                |
 -- +----------------------------------------------------------------------------+
 prompt <a name="materialized_view_master_site_summary"></a><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>(Materialized View) - Master Site Summary</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN mgroup    HEADING '# of Master Groups'        ENTMAP off
 COLUMN mvgroup   HEADING '# of Registered MV Groups' ENTMAP off
 COLUMN mv        HEADING '# of Registered MVs'       ENTMAP off
 COLUMN mvlog     HEADING '# of MV Logs'              ENTMAP off
 COLUMN template  HEADING '# of Templates'            ENTMAP off
 SELECT a.mgroup mgroup , b.mvgroup mvgroup , c.mv mv , d.mvlog mvlog , e.template template
 FROM (select count(g.gname) mgroup from dba_repgroup g, dba_repsites s where g.master = 'Y'and s.master = 'Y'and g.gname = s.gname and s.my_dblink = 'Y') a , (select count(*) mvGROUP from dba_registered_snapshot_groups) b , (select count(*) mv from dba_registered_snapshots) c , (select count(*) mvlog from dba_snapshot_logs) d , (select count(*) template from dba_repcat_refresh_templates) e;
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN log_owner       HEADING 'Log Owner'      ENTMAP off
 COLUMN log_table       HEADING 'Log Table'      ENTMAP off
 COLUMN master          HEADING 'Master'         ENTMAP off
 COLUMN rowids          HEADING 'Row ID'         ENTMAP off
 COLUMN primary_key     HEADING 'Primary Key'    ENTMAP off
 COLUMN filter_columns  HEADING 'Filter Columns' ENTMAP off
 BREAK ON report ON log_owner
 SELECT '<div align="left"><font color="#336699"><b>' || log_owner || '</b></font></div>' log_owner , log_table , master , '<div align="center">' || rowids || '</div>' rowids , '<div align="center">' || primary_key || '</div>' primary_key , '<div align="center">' || filter_columns || '</div>' filter_columns
 FROM dba_snapshot_logs
 ORDER BY log_owner;
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN ref_temp_name    HEADING 'Refresh Template Name'   ENTMAP off
 COLUMN owner            HEADING 'Owner'                   ENTMAP off
 COLUMN public_template  HEADING 'Public'                  ENTMAP off
 COLUMN instantiated     HEADING '# of Instantiated Sites' ENTMAP off
 COLUMN template_comment HEADING 'Comment'                 ENTMAP off
 SELECT rt.refresh_template_name ref_temp_name , owner owner , decode(public_template, 'Y', 'YES', 'NO')  public_template , rs.instantiated instantiated , rt.template_comment template_comment
 FROM dba_repcat_refresh_templates rt , (SELECT y.refresh_template_name, count(x.status) instantiated FROM dba_repcat_template_sites x, dba_repcat_refresh_templates y WHERE x.refresh_template_name(+) = y.refresh_template_name GROUP BY y.refresh_template_name) rs
 WHERE rt.refresh_template_name(+) = rs.refresh_template_name
 ORDER BY rt.refresh_template_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |             - (MATERIALIZED VIEW) - MASTER SITE TEMPLATES -                |
 -- +----------------------------------------------------------------------------+
 prompt <a name="materialized_view_master_site_templates"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>(Materialized View) - Master Site Templates</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner                   HEADING 'Owner'                     ENTMAP off
 COLUMN refresh_template_name   HEADING 'Refresh Template Name'     ENTMAP off
 COLUMN public_template         HEADING 'Public'                    ENTMAP off
 COLUMN instantiated            HEADING '# of Instantiated Sites'   ENTMAP off
 COLUMN template_comment        HEADING 'Comment'                   ENTMAP off
 BREAK ON owner
 SELECT '<div align="left"><font color="#336699"><b>' || owner || '</b></font></div>'  owner , rt.refresh_template_name refresh_template_name , decode(public_template, 'Y', 'YES', 'NO') public_template , rs.instantiated instantiated , rt.template_comment template_comment
 FROM dba_repcat_refresh_templates rt , ( SELECT y.refresh_template_name, count(x.status) instantiated FROM dba_repcat_template_sites x, dba_repcat_refresh_templates y WHERE x.refresh_template_name(+) = y.refresh_template_name GROUP BY y.refresh_template_name ) rs
 WHERE rt.refresh_template_name(+) = rs.refresh_template_name
 ORDER BY owner;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |            - (MATERIALIZED VIEW) - SITE MATERIALIZED VIEWS -               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="materialized_view_materialized_views"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>(Materialized View) - Site Materialized Views</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner        FORMAT a75  HEADING 'Owner'        ENTMAP off
 COLUMN name                     HEADING 'Name'         ENTMAP off
 COLUMN master_owner             HEADING 'Master Owner' ENTMAP off
 COLUMN master_table             HEADING 'Master Table' ENTMAP off
 COLUMN master_link              HEADING 'Master Link'  ENTMAP off
 COLUMN type                     HEADING 'Type'         ENTMAP off
 COLUMN updatable    FORMAT a75  HEADING 'Updatable?'   ENTMAP off
 COLUMN can_use_log  FORMAT a75  HEADING 'Can Use Log?' ENTMAP off
 COLUMN last_refresh FORMAT a75  HEADING 'Last Refresh' ENTMAP off
 BREAK ON owner
 SELECT '<div align="left"><font color="#336699"><b>' || s.owner  || '</b></font></div>'  owner , s.name name , s.master_owner master_owner , s.master master_table , s.master_link master_link , nls_initcap(s.type) type , '<div align="center">' || DECODE(s.updatable, 'YES', 'YES', 'NO')  || '</div>' updatable , '<div align="center">' || DECODE(s.can_use_log,'YES', 'YES', 'NO') || '</div>' can_use_log , '<div nowrap align="right">' || NVL(TO_CHAR(m.last_refresh_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>' last_refresh
 FROM dba_snapshots  s , dba_mviews m
 WHERE s.name = m.mview_name AND s.owner = m.owner
 ORDER BY s.owner , s.name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |              - (MATERIALIZED VIEW) - SITE REFRESH GROUPS -                 |
 -- +----------------------------------------------------------------------------+
 prompt <a name="materialized_view_refresh_groups"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>(Materialized View) - Site Refresh Groups</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner     HEADING 'Owner'     ENTMAP off
 COLUMN name      HEADING 'Name'      ENTMAP off
 COLUMN broken    HEADING 'Broken?'   ENTMAP off
 COLUMN next_date HEADING 'Next Date' ENTMAP off
 COLUMN interval  HEADING 'Interval'  ENTMAP off
 BREAK ON owner
 SELECT '<div align="left"><font color="#336699"><b>' || rowner || '</b></font></div>'  owner , '<div align="left">' || rname || '</div>' name , '<div align="center">' || broken || '</div>' broken , '<div nowrap align="right">' || NVL(TO_CHAR(next_date, 'yyyy-mm-dd HH24:MI:SS'), '<br>') || '</div>' next_date , '<div nowrap align="right">' || interval || '</div>' interval
 FROM dba_refresh
 ORDER BY rowner , rname;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                  - (MATERIALIZED VIEW) - SITE SUMMARY -                    |
 -- +----------------------------------------------------------------------------+
 prompt <a name="materialized_view_summary"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>(Materialized View) - Site Summary</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN mvgroup   HEADING '# of Materialized View Groups'  ENTMAP off
 COLUMN mv        HEADING '# of Materialized Views'        ENTMAP off
 COLUMN rgroup    HEADING '# of Refresh Groups'            ENTMAP off
 SELECT a.mvgroup mvgroup , b.mv mv , c.rgroup rgroup
 FROM (  select count(s.gname) mvgroup from dba_repsites s where s.snapmaster = 'Y') a , (  select count(*) mv from dba_snapshots) b , (  select count(*) rgroup from dba_refresh) c;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    if [ "${SNAPSHOT_VER}" = "10" ]; then
      cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"
 prompt <center><font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#663300"><b><u>Data Pump</u></b></font></center>

 -- +----------------------------------------------------------------------------+
 -- |                        - DATA PUMP JOB PROGRESS -                          |
 -- +----------------------------------------------------------------------------+
 prompt <a name="data_pump_job_progress"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Data Pump Job Progress</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name_print                     HEADING 'Instance Name'           ENTMAP off
 COLUMN owner_name                              HEADING 'Owner Name'              ENTMAP off
 COLUMN job_name                                HEADING 'Job Name'                ENTMAP off
 COLUMN session_type                            HEADING 'Session Type'            ENTMAP off
 COLUMN start_time                              HEADING 'Start Time'              ENTMAP off
 COLUMN time_remaining FORMAT 9,999,999,999,999 HEADING 'Time Remaining (min.)'   ENTMAP off
 COLUMN sofar          FORMAT 9,999,999,999,999 HEADING 'Bytes Completed So Far'  ENTMAP off
 COLUMN totalwork      FORMAT 9,999,999,999,999 HEADING 'Total Bytes for Job'     ENTMAP off
 COLUMN pct_completed                           HEADING '% Completed'             ENTMAP off
 BREAK ON report ON instance_name_print ON owner_name ON job_name
 SELECT '<div align="center"><font color="#336699"><b>' || i.instance_name  || '</b></font></div>' instance_name_print , dj.owner_name owner_name , dj.job_name job_name , ds.type session_type , '<div align="center" nowrap>' || TO_CHAR(sl.start_time,'yyyy-mm-dd HH24:MI:SS') || '</div>'  start_time , ROUND(sl.time_remaining/60,0) time_remaining , sl.sofar sofar , sl.totalwork totalwork , '<div align="right">' || TRUNC(ROUND((sl.sofar/sl.totalwork) * 100, 1)) || '%</div>' pct_completed
 FROM gv$datapump_job dj , gv$datapump_session ds , gv$session s , gv$instance i , gv$session_longops sl
 WHERE s.inst_id  = i.inst_id AND ds.inst_id = i.inst_id AND dj.inst_id = i.inst_id AND sl.inst_id = i.inst_id AND s.saddr = ds.saddr AND dj.job_id  = ds.job_id AND sl.sid = s.sid AND sl.serial# = s.serial# AND ds.type = 'MASTER'
 ORDER BY i.instance_name , dj.owner_name , dj.job_name , ds.type;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                           - DATA PUMP JOBS -                               |
 -- +----------------------------------------------------------------------------+
 prompt <a name="data_pump_jobs"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Data Pump Jobs</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN owner_name                           HEADING 'Owner Name'        ENTMAP off
 COLUMN job_name                             HEADING 'Job Name'          ENTMAP off
 COLUMN operation                            HEADING 'Operation'         ENTMAP off
 COLUMN job_mode                             HEADING 'Job Mode'          ENTMAP off
 COLUMN state                                HEADING 'State'             ENTMAP off
 COLUMN degree            FORMAT 999,999,999 HEADING 'Degree'            ENTMAP off
 COLUMN attached_sessions FORMAT 999,999,999 HEADING 'Attached Sessions' ENTMAP off
 SELECT '<div align="left"><font color="#336699"><b>' || dpj.owner_name || '</b></font></div>'  owner_name , dpj.job_name job_name , dpj.operation operation , dpj.job_mode job_mode , dpj.state state , dpj.degree degree , dpj.attached_sessions attached_sessions
 FROM dba_datapump_jobs dpj
 ORDER BY dpj.owner_name , dpj.job_name;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

 -- +----------------------------------------------------------------------------+
 -- |                          - DATA PUMP SESSIONS -                            |
 -- +----------------------------------------------------------------------------+
 prompt <a name="data_pump_sessions"></a> <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Data Pump Sessions</b></font><hr align="left" width="460">
 CLEAR COLUMNS BREAKS COMPUTES
 COLUMN instance_name_print HEADING 'Instance Name'    ENTMAP off
 COLUMN owner_name          HEADING 'Owner Name'       ENTMAP off
 COLUMN job_name            HEADING 'Job Name'         ENTMAP off
 COLUMN session_type        HEADING 'Session Type'     ENTMAP off
 COLUMN sid                 HEADING 'SID'              ENTMAP off
 COLUMN serial_no           HEADING 'Serial#'          ENTMAP off
 COLUMN oracle_username     HEADING 'Oracle Username'  ENTMAP off
 COLUMN os_username         HEADING 'O/S Username'     ENTMAP off
 COLUMN os_pid              HEADING 'O/S PID'          ENTMAP off
 BREAK ON report ON instance_name_print ON owner_name ON job_name
 SELECT '<div align="center"><font color="#336699"><b>' || i.instance_name  || '</b></font></div>'  instance_name_print , dj.owner_name owner_name , dj.job_name job_name , ds.type session_type , s.sid sid , s.serial# serial_no , s.username oracle_username , s.osuser os_username , p.spid os_pid
   FROM gv$datapump_job dj , gv$datapump_session ds , gv$session s , gv$instance i , gv$process p
  WHERE s.inst_id  = i.inst_id AND s.inst_id  = p.inst_id AND ds.inst_id = i.inst_id AND dj.inst_id = i.inst_id AND s.saddr = ds.saddr AND s.paddr = p.addr (+) AND dj.job_id  = ds.job_id
  ORDER BY i.instance_name , dj.owner_name , dj.job_name , ds.type;
 prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>
EOFSCRIPT
    fi
  fi
  cat >> ${__SNAP_SCRIPT} <<"EOFSCRIPT"

 -- +----------------------------------------------------------------------------+
 -- |                            - END OF REPORT -                               |
 -- +----------------------------------------------------------------------------+
 SPOOL OFF
 SET MARKUP HTML OFF TERMOUT ON
 prompt
 prompt Output written to: &FileName._&_spool_time._&versionType..html
 EXIT;
EOFSCRIPT

  print_log "[make_snap_scripts]" "" "Enmotech Snapshot Scripts Created as [${__SNAP_SCRIPT}]"
}

#########################################################################################################
##                                                                                                     ##
## Function get_awrdump(): Get AWR Dump File                                                           ##
##   Result write into ${__DUMP_DIR} Directory                                                         ##
##                                                                                                     ##
#########################################################################################################
get_awrdump(){

  print_log "[get_awrdump]" "" "Begin Collect AWR Dump File"
  print_log "[get_awrdump]" "3" "Get AWR Dump File into [${__DUMP_DIR}] Directory"

  AWREXTR_LOG="${__DUMP_DIR}/awrextr_spool.log"
  SQLS="SET TRIMS ON TRIM ON TIMI OFF LINES 1111 PAGES 0 HEADING OFF FEEDBACK OFF AUTOT OFF
 SPOOL ${AWREXTR_LOG}
 DROP DIRECTORY \"__DIR_DC_SCRIPTS_TEMP\";
 CREATE DIRECTORY \"__DIR_DC_SCRIPTS_TEMP\" AS '`pwd`/${__DUMP_DIR}';
 COL MINID NEW_VALUE BEGIN_SNAP
 COL MAXID NEW_VALUE END_SNAP
 COL FNAME NEW_VALUE FILE_NAME
 SELECT /*+ RULE */ MIN(SNAP_ID) MINID, MAX(SNAP_ID) MAXID, 'awrdat_'||MIN(SNAP_ID)||'_'||MAX(SNAP_ID) FNAME
   FROM DBA_HIST_SNAPSHOT
  WHERE DBID=${__DBID}
    AND END_INTERVAL_TIME BETWEEN TO_DATE('${__AWR_TIME_BEGIN}', 'YYYYMMDDHH24MI') AND TO_DATE('${__AWR_TIME_END}', 'YYYYMMDDHH24MI');
 DEFINE DBID = ${__DBID}
 DEFINE NUM_DAYS = 1
 DEFINE DIRECTORY_NAME = '__DIR_DC_SCRIPTS_TEMP'
 @?/rdbms/admin/awrextr.sql
 DROP DIRECTORY \"__DIR_DC_SCRIPTS_TEMP\";
 SPO OFF
 EXIT"
  print_log "[get_awrdump]" "4" "AWR Dump File Collection" "${SQLS}"
  ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1>/dev/null 2>>${__ERRORFILE} <<EOF
  ${SQLS}
EOF
  if [ "`cat ${AWREXTR_LOG} | grep '^ORA-'`" != "" ]; then
    print_log "[get_awrdump]" "2" "[Error] Get AWR Dump File Completed with ORA Errors, Check it in [${AWREXTR_LOG}]"
  else
    print_log "[get_awrdump]" "" "Get AWR Dump File Completed Successfully"
  fi
  print_log "[get_awrdump]" "" "End Collect AWR Dump File"
}

#########################################################################################################
##                                                                                                     ##
## Function get_spdump(): Get STATSPACK Dump File                                                      ##
##   Result write into ${__DUMP_DIR} Directory                                                         ##
##                                                                                                     ##
#########################################################################################################
get_spdump(){

  print_log "[get_awrdump]" "" "Begin Collect STATSPACK Dump File into [${__DUMP_DIR}] Directory"
  SPDUMP_PAR_ID="${__DUMP_DIR}/spdump_with_id.par"
  SPDUMP_PAR_NOID="${__DUMP_DIR}/spdump_no_id.par"
  NLS_PARAMETERS="${__SCRIPT_DIR}/nls_lang_parameter.par"
  SPDUMP_SQL="SET LINES 1111 PAGES 0 HEADING OFF TRIM ON TRIMSPOOL ON FEEDBACK OFF VERIFY OFF AUTOT OFF
 COL MIN_ID NEW_VALUE MINID
 COL MAX_ID NEW_VALUE MAXID
 SELECT /*+ RULE */ MIN(SNAP_ID) MIN_ID, MAX(SNAP_ID) MAX_ID
   FROM ${__PERFSTAT_USER}.STATS\$SNAPSHOT
  WHERE SNAP_TIME BETWEEN TO_DATE('${__AWR_TIME_BEGIN}', 'YYYYMMDDHH24MI') AND TO_DATE('${__AWR_TIME_END}', 'YYYYMMDDHH24MI');
 SPOOL ${NLS_PARAMETERS}
 SELECT /*+ RULE */ 'DC_NLS_LANG='
     || DECODE(INSTR(USERENV('LANGUAGE'), ' '), 0, '', '\"')
     || USERENV('LANGUAGE')
     || DECODE(INSTR(USERENV('LANGUAGE'), ' '), 0, '', '\"')
   FROM DUAL;
 SPOOL OFF
 SPOOL ${SPDUMP_PAR_ID}
 SELECT /*+ RULE */ 'USERID=''${__SQLPLUS_USER}''
 FILE=${__DUMP_DIR}/SPDUMP_WITH_ID.DMP
 LOG=${__DUMP_DIR}/SPDUMP_WITH_ID.LOG
 BUFFER=8192000 CONSISTENT=Y STATISTICS=NONE
 QUERY=\" WHERE SNAP_ID BETWEEN '||&MINID||' AND '||&MAXID||'\" TABLES=('
  FROM DUAL
 UNION ALL
 SELECT /*+ RULE */ '${__PERFSTAT_USER}.'||TABLE_NAME FROM DBA_TAB_COLUMNS
  WHERE OWNER='${__PERFSTAT_USER}' AND COLUMN_NAME='SNAP_ID' AND TABLE_NAME!='STATS\$DATABASE_INSTANCE'
 UNION ALL
 SELECT ')' FROM DUAL;
 SPOOL OFF
 SPOOL ${SPDUMP_PAR_NOID}
 SELECT /*+ RULE */ 'USERID=''${__SQLPLUS_USER}''
 FILE=${__DUMP_DIR}/SPDUMP_NO_ID.DMP
 LOG=${__DUMP_DIR}/SPDUMP_NO_ID.LOG
 BUFFER=8192000 CONSISTENT=Y STATISTICS=NONE
 TABLES=(' FROM DUAL
 UNION ALL
 SELECT * FROM (SELECT /*+ RULE */ '${__PERFSTAT_USER}.'||TABLE_NAME FROM DBA_TABLES WHERE OWNER='${__PERFSTAT_USER}' MINUS
 SELECT '${__PERFSTAT_USER}.'||TABLE_NAME FROM DBA_TAB_COLUMNS WHERE OWNER='${__PERFSTAT_USER}' AND COLUMN_NAME='SNAP_ID')
 UNION ALL
 SELECT /*+ RULE */ 'STATS\$DATABASE_INSTANCE)' FROM DUAL;
 SPOOL OFF
 EXIT"
  print_log "[get_spdump]" "4" "Statspack Dump File Collection" "${SPDUMP_SQL}"
  ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1>/dev/null 2>>${__ERRORFILE} <<EOF
  ${SPDUMP_SQL}
EOF

  SPDUMP_ERRORS=""
  SET_NLS_COMMAND=""
  if [ -f "${SPDUMP_PAR_ID}" ] && [ "`cat ${SPDUMP_PAR_ID} | grep ORA-`" = "" ]; then
    print_log "[get_spdump]" "" "Statspack Dump with ID Filter Parfile in [${SPDUMP_PAR_ID}]"
  elif [ `cat ${SPDUMP_PAR_ID} | grep ORA-` != "" ]; then
    SPDUMP_ERRORS="PAR_ID:`cat ${SPDUMP_PAR_ID} | grep '^ORA-' | sort -u` ! "
  else
    SPDUMP_ERRORS="NO SPDUMP With ID Parfile Create ! "
  fi

  if [ -f "${SPDUMP_PAR_NOID}" ] && [ "`cat ${SPDUMP_PAR_NOID} | grep ORA-`" = "" ]; then
    print_log "[get_spdump]" "" "Statspack Dump with no ID Filter Parfile in [${SPDUMP_PAR_NOID}]"
  elif [ `cat ${SPDUMP_PAR_NOID} | grep ORA-` != "" ]; then
    SPDUMP_ERRORS="${SPDUMP_ERRORS}, PAR_NOID:`cat ${SPDUMP_PAR_NOID} | grep '^ORA-' | sort -u` ! "
  else
    SPDUMP_ERRORS="${SPDUMP_ERRORS}, NO SPDUMP With no ID Parfile Create ! "
  fi

  if [ -f "${NLS_PARAMETERS}" ] && [ "`cat ${NLS_PARAMETERS} | grep ORA-`" = "" ]; then
    print_log "[get_spdump]" "" "Statspack Dump with NLS Parameter in [${NLS_PARAMETERS}]"
    USER_SHELL=`grep 'csh' ${__SHELL}`
    if [ "${USER_SHELL}" != "" ]; then
      setenv NLS_LANG `cat ${NLS_PARAMETERS} | grep 'DC_NLS_LANG' | cut -d '=' -f 2-`
    else
      export NLS_LANG=`cat ${NLS_PARAMETERS} | grep 'DC_NLS_LANG' | cut -d '=' -f 2-`
    fi
  elif [ `cat ${NLS_PARAMETERS} | grep ORA-` != "" ]; then
    SPDUMP_ERRORS="${SPDUMP_ERRORS}, NLS_LANG:`cat ${NLS_PARAMETERS} | grep '^ORA-' | sort -u` ! "
  else
    SPDUMP_ERRORS="${SPDUMP_ERRORS}, NO SPDUMP With NLS_LANG file Create ! "
  fi

  if [ "${SPDUMP_ERRORS}" = "" ]; then
    print_log "[get_spdump]" "3" "Begin Dump Statspack Data with ID Filter to [${__DUMP_DIR}/SPDUMP_WITH_ID.DMP]"
    ${__ORACLE_HOME}/bin/exp parfile=${SPDUMP_PAR_ID} 1>/dev/null 2>/dev/null
    print_log "[get_spdump]" "3" "Begin Dump Statspack Data with no Filter to [${__DUMP_DIR}/SPDUMP_NO_ID.DMP]"
    ${__ORACLE_HOME}/bin/exp parfile=${SPDUMP_PAR_NOID} 1>/dev/null 2>/dev/null
    if [ -f "${__DUMP_DIR}/SPDUMP_WITH_ID.LOG" ] && [ -f "${__DUMP_DIR}/SPDUMP_NO_ID.LOG" ]; then
      ORA_ERROR=`cat ${__DUMP_DIR}/SPDUMP_*_ID.LOG | grep '^ORA-' | wc -l`
      EXP_ERROR=`cat ${__DUMP_DIR}/SPDUMP_*_ID.LOG | grep '^EXP-' | wc -l`
    else
      ORA_ERROR="-1"
      EXP_ERROR="-1"
    fi
    if [ ${ORA_ERROR} -eq 0 ] && [ ${EXP_ERROR} -eq 0 ]; then
      print_log "[get_spdump]" "" "Export Statspack Data Completed Successfully"
    else
      print_log "[get_spdump]" "2" "Export Statspack Data Completed with [${ORA_ERROR}] ORA Errors and [${EXP_ERROR}] Exp Errors"
    fi
  else
    print_log "[get_spdump]" "2" "[Error] Some Error Occured, We cannot Dump STATSPACK Data by this scripts"
    print_log "[get_spdump]" "2" "[Cause] ${SPDUMP_ERRORS}"
  fi
  print_log "[get_awrdump]" "" "End Collect STATSPACK Dump"
}

#########################################################################################################
##                                                                                                     ##
## Function make_metaScripts(): Create Metadata Import Scripts                                         ##
##   Result write into ${__DUMP_DIR} Directory                                                         ##
##                                                                                                     ##
#########################################################################################################
make_metaScripts(){

  print_log "[make_metaScripts]" "" "Begining of Create Metadata Import Script"
  METADUMPFILE=$1
  METAIMPSCRIPT=${__DUMP_DIR}/metadict_import.sh

  cat >${METAIMPSCRIPT} <<EOFSCRIPTS
 __METADMP='${METADUMPFILE}'
EOFSCRIPTS

  cat >>${METAIMPSCRIPT} <<"EOFSCRIPTS"
 __SQLPLUSSCRIPT='sqlplusScript.sql'
 __SQLPLUSRESULT='sqlplusRessult.log'
 __METASTAGEUSER='ENMO_META_STAGE'
 __ORACLE_HOME=${ORACLE_HOME}
 __ORACLE_SID=${ORACLE_SID}
 __DBID=`echo "${__METADMP}" | cut -d '.' -f 2`


 print_log(){
   # Parameters :
   # $1   : Function Name
   # $2   : Log Type, Null for Normal Message
   #        0  ==> Normal Message
   #        1  ==> Need User Input
   # $3~$9: All Messages
   MYDATE=`date +"%Y-%m-%d %H:%M:%S"`
   case ${2} in
   1)
     printf "%18s%22s : %s\n%s" "${MYDATE}" "$1" "$4$5$6$7$8$9" "==========[ Waiting for input ]=========> "
     read __USER_INPUT_CHAR
   ;;
   *) printf "%18s%22s : %s\n" "${MYDATE}" "$1" "$3$4$5$6$7$8$9" ;;
   esac
 }

 # Print My Symbol
 print_log "[HongyeDBA]" "" "============================================================"
 print_log "[HongyeDBA]" "" '[                 +d:                                      ]'
 print_log "[HongyeDBA]" "" '[                 `hds`                   .`               ]'
 print_log "[HongyeDBA]" "" '[                  -ddh+`                /h`               ]'
 print_log "[HongyeDBA]" "" '[                   odddh+              /hy`               ]'
 print_log "[HongyeDBA]" "" '[                   .hdhhhhs.`        ./hhy.               ]'
 print_log "[HongyeDBA]" "" '[                   `shhhhhhhh/`     /yhyhy-               ]'
 print_log "[HongyeDBA]" "" '[                    ohhhhhhhhho.  `/hhyyhh:               ]'
 print_log "[HongyeDBA]" "" '[                    -hhhhyhhhhhh: ohhhshhy/               ]'
 print_log "[HongyeDBA]" "" '[                     -yhhhyyhhhhy+hhhyyyyy:               ]'
 print_log "[HongyeDBA]" "" '[                     `shhhhyyhhhhhyyyoyyyy-               ]'
 print_log "[HongyeDBA]" "" '[                 `.``` :yhhhsyhyyyyyssyyy+    .-`-:-`     ]'
 print_log "[HongyeDBA]" "" '[      `.``-::osysyhhhhysshhyyssyyyyy+yyys+oyyyyyy+.       ]'
 print_log "[HongyeDBA]" "" '[     `:osyhhhyyyhhhhhhhyyy[ HongyeDBA ]yyyyssyys:         ]'
 print_log "[HongyeDBA]" "" '[          ./syhyyyyysssyyyyyyyyssyy+yyyssssyyo.           ]'
 print_log "[HongyeDBA]" "" '[             `:+osyyyyysssoooosysoossoo++/:.              ]'
 print_log "[HongyeDBA]" "" '[                  .:/+//+syyyysoo/:/+sys/`                ]'
 print_log "[HongyeDBA]" "" '[                     `:syyyyyssoo+.`   `.`                ]'
 print_log "[HongyeDBA]" "" '[                    :yyyssssssoy/  `.                     ]'
 print_log "[HongyeDBA]" "" '[                  :syysso+/-` `-    `.                    ]'
 print_log "[HongyeDBA]" "" '[                -+o/:-.`             `.                   ]'
 print_log "[HongyeDBA]" "" '[               ``                     `.                  ]'
 print_log "[HongyeDBA]" "" '[                                       `.                 ]'
 print_log "[HongyeDBA]" "" '[                                         `                ]'
 print_log "[HongyeDBA]" "" "============================================================"

 #########################################################################################################
 ##                                                                                                     ##
 ## Funtion execute_sql(): Executed SQL in Oracle                                                       ##
 ##                                                                                                     ##
 #########################################################################################################
 check_env(){

     # Check Oracle Environment
     if [ "${__ORACLE_SID}" = "" ]; then
         print_log "[check_env]" "" "User Environment Oracle SID is not Set"
         exit 1
     elif [ "${__ORACLE_HOME}" = "" ]; then
         print_log "[check_env]" "" "User Environment Oracle Home is not Set"
         exit 1
     else
         print_log "[check_env]" "" "[OK] Oracle SID set to [${__ORACLE_SID}]"
         print_log "[check_env]" "" "[OK] Oracle Home set to [${__ORACLE_HOME}]"
     fi
 }


 #########################################################################################################
 ##                                                                                                     ##
 ## Funtion execute_sql(): Executed SQL in Oracle                                                       ##
 ##                                                                                                     ##
 #########################################################################################################
 execute_sql(){

     CHECK_ERROR=$1

     # Execute SQL in SQL Scripts and Write Result
     ${__ORACLE_HOME}/bin/sqlplus -s "/ as sysdba" 1> /dev/null <<EOF
     SPO ${__SQLPLUSRESULT}
     @${__SQLPLUSSCRIPT}
     COMMIT;
     SPO OFF
     EXIT
EOFSCRIPTS

  echo 'EOF' >> ${METAIMPSCRIPT}
  cat >>${METAIMPSCRIPT} <<"EOFSCRIPTS"

     # Check Error in SQL Plus Result
     if [ "${CHECK_ERROR}" != "N" ]; then
         ERROR_MSG=`cat ${__SQLPLUSRESULT} | grep '^ORA-' | sort -u`
         if [ "${ERROR_MSG}" != "" ]; then
             print_log "[execute_sql]" "" "Error Message Detected as :"
             print_log "[execute_sql]" "" "${ERROR_MSG}"
             exit 1
         fi
     fi
 }


 #########################################################################################################
 ##                                                                                                     ##
 ## Funtion initial_repo(): Initial Enmo Metadata Repository                                            ##
 ##                                                                                                     ##
 #########################################################################################################
 initial_repo(){

     print_log "[initial_repo]" "" "Begin Initialization Enmo Metadata Repository"
     # Initial SQL Scripts
     cat > ${__SQLPLUSSCRIPT} <<EOF
     CREATE TABLE ENMO_CONSTRAINTS (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,OWNER                        VARCHAR2(30)
     ,CONSTRAINT_NAME              VARCHAR2(30)
     ,CONSTRAINT_TYPE              VARCHAR2(1)
     ,TABLE_NAME                   VARCHAR2(30)
     ,SEARCH_CONDITION             CLOB
     ,R_OWNER                      VARCHAR2(30)
     ,R_CONSTRAINT_NAME            VARCHAR2(30)
     ,DELETE_RULE                  VARCHAR2(9)
     ,STATUS                       VARCHAR2(8)
     ,DEFERRABLE                   VARCHAR2(14)
     ,DEFERRED                     VARCHAR2(9)
     ,VALIDATED                    VARCHAR2(13)
     ,GENERATED                    VARCHAR2(14)
     ,BAD                          VARCHAR2(3)
     ,RELY                         VARCHAR2(4)
     ,LAST_CHANGE                  DATE
     ,INDEX_OWNER                  VARCHAR2(30)
     ,INDEX_NAME                   VARCHAR2(30)
     ,INVALID                      VARCHAR2(7)
     ,VIEW_RELATED                 VARCHAR2(14));

     CREATE TABLE ENMO_ROLES (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,ROLE                         VARCHAR2(30)
     ,PASSWORD_REQUIRED            VARCHAR2(8));

     CREATE TABLE ENMO_COL_PRIVS (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,GRANTEE                      VARCHAR2(30)
     ,OWNER                        VARCHAR2(30)
     ,TABLE_NAME                   VARCHAR2(30)
     ,COLUMN_NAME                  VARCHAR2(30)
     ,GRANTOR                      VARCHAR2(30)
     ,PRIVILEGE                    VARCHAR2(40)
     ,GRANTABLE                    VARCHAR2(3));

     CREATE TABLE ENMO_PART_INDEXES (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,OWNER                        VARCHAR2(30)
     ,INDEX_NAME                   VARCHAR2(30)
     ,TABLE_NAME                   VARCHAR2(30)
     ,PARTITIONING_TYPE            VARCHAR2(7)
     ,SUBPARTITIONING_TYPE         VARCHAR2(7)
     ,PARTITION_COUNT              NUMBER
     ,DEF_SUBPARTITION_COUNT       NUMBER
     ,PARTITIONING_KEY_COUNT       NUMBER
     ,SUBPARTITIONING_KEY_COUNT    NUMBER
     ,LOCALITY                     VARCHAR2(6)
     ,ALIGNMENT                    VARCHAR2(12)
     ,DEF_TABLESPACE_NAME          VARCHAR2(30)
     ,DEF_PCT_FREE                 NUMBER
     ,DEF_INI_TRANS                NUMBER
     ,DEF_MAX_TRANS                NUMBER
     ,DEF_INITIAL_EXTENT           VARCHAR2(40)
     ,DEF_NEXT_EXTENT              VARCHAR2(40)
     ,DEF_MIN_EXTENTS              VARCHAR2(40)
     ,DEF_MAX_EXTENTS              VARCHAR2(40)
     ,DEF_PCT_INCREASE             VARCHAR2(40)
     ,DEF_FREELISTS                NUMBER
     ,DEF_FREELIST_GROUPS          NUMBER
     ,DEF_LOGGING                  VARCHAR2(7)
     ,DEF_BUFFER_POOL              VARCHAR2(7)
     ,DEF_PARAMETERS               VARCHAR2(1000));

     CREATE TABLE ENMO_PART_TABLES (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,OWNER                        VARCHAR2(30)
     ,TABLE_NAME                   VARCHAR2(30)
     ,PARTITIONING_TYPE            VARCHAR2(7)
     ,SUBPARTITIONING_TYPE         VARCHAR2(7)
     ,PARTITION_COUNT              NUMBER
     ,DEF_SUBPARTITION_COUNT       NUMBER
     ,PARTITIONING_KEY_COUNT       NUMBER
     ,SUBPARTITIONING_KEY_COUNT    NUMBER
     ,STATUS                       VARCHAR2(8)
     ,DEF_TABLESPACE_NAME          VARCHAR2(30)
     ,DEF_PCT_FREE                 NUMBER
     ,DEF_PCT_USED                 NUMBER
     ,DEF_INI_TRANS                NUMBER
     ,DEF_MAX_TRANS                NUMBER
     ,DEF_INITIAL_EXTENT           VARCHAR2(40)
     ,DEF_NEXT_EXTENT              VARCHAR2(40)
     ,DEF_MIN_EXTENTS              VARCHAR2(40)
     ,DEF_MAX_EXTENTS              VARCHAR2(40)
     ,DEF_PCT_INCREASE             VARCHAR2(40)
     ,DEF_FREELISTS                NUMBER
     ,DEF_FREELIST_GROUPS          NUMBER
     ,DEF_LOGGING                  VARCHAR2(7)
     ,DEF_COMPRESSION              VARCHAR2(8)
     ,DEF_BUFFER_POOL              VARCHAR2(7));

     CREATE TABLE ENMO_SEGMENTS (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,OWNER                        VARCHAR2(30)
     ,SEGMENT_NAME                 VARCHAR2(81)
     ,PARTITION_NAME               VARCHAR2(30)
     ,SEGMENT_TYPE                 VARCHAR2(18)
     ,TABLESPACE_NAME              VARCHAR2(30)
     ,HEADER_FILE                  NUMBER
     ,HEADER_BLOCK                 NUMBER
     ,BYTES                        NUMBER
     ,BLOCKS                       NUMBER
     ,EXTENTS                      NUMBER
     ,INITIAL_EXTENT               NUMBER
     ,NEXT_EXTENT                  NUMBER
     ,MIN_EXTENTS                  NUMBER
     ,MAX_EXTENTS                  NUMBER
     ,PCT_INCREASE                 NUMBER
     ,FREELISTS                    NUMBER
     ,FREELIST_GROUPS              NUMBER
     ,RELATIVE_FNO                 NUMBER
     ,BUFFER_POOL                  VARCHAR2(7));

     CREATE TABLE ENMO_TABLESPACES (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,TABLESPACE_NAME              VARCHAR2(30)
     ,BLOCK_SIZE                   NUMBER
     ,INITIAL_EXTENT               NUMBER
     ,NEXT_EXTENT                  NUMBER
     ,MIN_EXTENTS                  NUMBER
     ,MAX_EXTENTS                  NUMBER
     ,PCT_INCREASE                 NUMBER
     ,MIN_EXTLEN                   NUMBER
     ,STATUS                       VARCHAR2(9)
     ,CONTENTS                     VARCHAR2(9)
     ,LOGGING                      VARCHAR2(9)
     ,FORCE_LOGGING                VARCHAR2(3)
     ,EXTENT_MANAGEMENT            VARCHAR2(10)
     ,ALLOCATION_TYPE              VARCHAR2(9)
     ,PLUGGED_IN                   VARCHAR2(3)
     ,SEGMENT_SPACE_MANAGEMENT     VARCHAR2(6)
     ,DEF_TAB_COMPRESSION          VARCHAR2(8)
     ,RETENTION                    VARCHAR2(11)
     ,BIGFILE                      VARCHAR2(3));

     CREATE TABLE ENMO_TAB_COLUMNS (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,OWNER                        VARCHAR2(30)
     ,TABLE_NAME                   VARCHAR2(30)
     ,COLUMN_NAME                  VARCHAR2(30)
     ,DATA_TYPE                    VARCHAR2(106)
     ,DATA_TYPE_MOD                VARCHAR2(3)
     ,DATA_TYPE_OWNER              VARCHAR2(30)
     ,DATA_LENGTH                  NUMBER
     ,DATA_PRECISION               NUMBER
     ,DATA_SCALE                   NUMBER
     ,NULLABLE                     VARCHAR2(1)
     ,COLUMN_ID                    NUMBER
     ,DEFAULT_LENGTH               NUMBER
     ,DATA_DEFAULT                 CLOB
     ,NUM_DISTINCT                 NUMBER
     ,LOW_VALUE                    RAW(32)
     ,HIGH_VALUE                   RAW(32)
     ,DENSITY                      NUMBER
     ,NUM_NULLS                    NUMBER
     ,NUM_BUCKETS                  NUMBER
     ,LAST_ANALYZED                DATE
     ,SAMPLE_SIZE                  NUMBER
     ,CHARACTER_SET_NAME           VARCHAR2(44)
     ,CHAR_COL_DECL_LENGTH         NUMBER
     ,GLOBAL_STATS                 VARCHAR2(3)
     ,USER_STATS                   VARCHAR2(3)
     ,AVG_COL_LEN                  NUMBER
     ,CHAR_LENGTH                  NUMBER
     ,CHAR_USED                    VARCHAR2(1)
     ,V80_FMT_IMAGE                VARCHAR2(3)
     ,DATA_UPGRADED                VARCHAR2(3)
     ,HISTOGRAM                    VARCHAR2(15));

     CREATE TABLE ENMO_ROLE_ROLE_PRIVS (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,ROLE                         VARCHAR2(30)
     ,GRANTED_ROLE                 VARCHAR2(30)
     ,ADMIN_OPTION                 VARCHAR2(3));

     CREATE TABLE ENMO_ROLE_SYS_PRIVS (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,ROLE                         VARCHAR2(30)
     ,PRIVILEGE                    VARCHAR2(40)
     ,ADMIN_OPTION                 VARCHAR2(3));

     CREATE TABLE ENMO_ROLE_TAB_PRIVS (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,ROLE                         VARCHAR2(30)
     ,OWNER                        VARCHAR2(30)
     ,TABLE_NAME                   VARCHAR2(30)
     ,COLUMN_NAME                  VARCHAR2(30)
     ,PRIVILEGE                    VARCHAR2(40)
     ,GRANTABLE                    VARCHAR2(3));

     CREATE TABLE ENMO_INDEXES (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,OWNER                        VARCHAR2(30)
     ,INDEX_NAME                   VARCHAR2(30)
     ,INDEX_TYPE                   VARCHAR2(27)
     ,TABLE_OWNER                  VARCHAR2(30)
     ,TABLE_NAME                   VARCHAR2(30)
     ,TABLE_TYPE                   VARCHAR2(11)
     ,UNIQUENESS                   VARCHAR2(9)
     ,COMPRESSION                  VARCHAR2(8)
     ,PREFIX_LENGTH                NUMBER
     ,TABLESPACE_NAME              VARCHAR2(30)
     ,INI_TRANS                    NUMBER
     ,MAX_TRANS                    NUMBER
     ,INITIAL_EXTENT               NUMBER
     ,NEXT_EXTENT                  NUMBER
     ,MIN_EXTENTS                  NUMBER
     ,MAX_EXTENTS                  NUMBER
     ,PCT_INCREASE                 NUMBER
     ,PCT_THRESHOLD                NUMBER
     ,INCLUDE_COLUMN               NUMBER
     ,FREELISTS                    NUMBER
     ,FREELIST_GROUPS              NUMBER
     ,PCT_FREE                     NUMBER
     ,LOGGING                      VARCHAR2(3)
     ,BLEVEL                       NUMBER
     ,LEAF_BLOCKS                  NUMBER
     ,DISTINCT_KEYS                NUMBER
     ,AVG_LEAF_BLOCKS_PER_KEY      NUMBER
     ,AVG_DATA_BLOCKS_PER_KEY      NUMBER
     ,CLUSTERING_FACTOR            NUMBER
     ,STATUS                       VARCHAR2(8)
     ,NUM_ROWS                     NUMBER
     ,SAMPLE_SIZE                  NUMBER
     ,LAST_ANALYZED                DATE
     ,DEGREE                       VARCHAR2(40)
     ,INSTANCES                    VARCHAR2(40)
     ,PARTITIONED                  VARCHAR2(3)
     ,TEMPORARY                    VARCHAR2(1)
     ,GENERATED                    VARCHAR2(1)
     ,SECONDARY                    VARCHAR2(1)
     ,BUFFER_POOL                  VARCHAR2(7)
     ,USER_STATS                   VARCHAR2(3)
     ,DURATION                     VARCHAR2(15)
     ,PCT_DIRECT_ACCESS            NUMBER
     ,ITYP_OWNER                   VARCHAR2(30)
     ,ITYP_NAME                    VARCHAR2(30)
     ,PARAMETERS                   VARCHAR2(1000)
     ,GLOBAL_STATS                 VARCHAR2(3)
     ,DOMIDX_STATUS                VARCHAR2(12)
     ,DOMIDX_OPSTATUS              VARCHAR2(6)
     ,FUNCIDX_STATUS               VARCHAR2(8)
     ,JOIN_INDEX                   VARCHAR2(3)
     ,IOT_REDUNDANT_PKEY_ELIM      VARCHAR2(3)
     ,DROPPED                      VARCHAR2(3));

     CREATE TABLE ENMO_IND_COLUMNS (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,INDEX_OWNER                  VARCHAR2(30)
     ,INDEX_NAME                   VARCHAR2(30)
     ,TABLE_OWNER                  VARCHAR2(30)
     ,TABLE_NAME                   VARCHAR2(30)
     ,COLUMN_NAME                  VARCHAR2(4000)
     ,COLUMN_POSITION              NUMBER
     ,COLUMN_LENGTH                NUMBER
     ,CHAR_LENGTH                  NUMBER
     ,DESCEND                      VARCHAR2(4));

     CREATE TABLE ENMO_OBJECTS (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,OWNER                        VARCHAR2(30)
     ,OBJECT_NAME                  VARCHAR2(128)
     ,SUBOBJECT_NAME               VARCHAR2(30)
     ,OBJECT_ID                    NUMBER
     ,DATA_OBJECT_ID               NUMBER
     ,OBJECT_TYPE                  VARCHAR2(19)
     ,CREATED                      DATE
     ,LAST_DDL_TIME                DATE
     ,TIMESTAMP                    VARCHAR2(19)
     ,STATUS                       VARCHAR2(7)
     ,TEMPORARY                    VARCHAR2(1)
     ,GENERATED                    VARCHAR2(1)
     ,SECONDARY                    VARCHAR2(1));

     CREATE TABLE ENMO_ROLE_PRIVS (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,GRANTEE                      VARCHAR2(30)
     ,GRANTED_ROLE                 VARCHAR2(30)
     ,ADMIN_OPTION                 VARCHAR2(3)
     ,DEFAULT_ROLE                 VARCHAR2(3));

     CREATE TABLE ENMO_SEQUENCES (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,SEQUENCE_OWNER               VARCHAR2(30)
     ,SEQUENCE_NAME                VARCHAR2(30)
     ,MIN_VALUE                    NUMBER
     ,MAX_VALUE                    NUMBER
     ,INCREMENT_BY                 NUMBER
     ,CYCLE_FLAG                   VARCHAR2(1)
     ,ORDER_FLAG                   VARCHAR2(1)
     ,CACHE_SIZE                   NUMBER
     ,LAST_NUMBER                  NUMBER);

     CREATE TABLE ENMO_SYS_PRIVS (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,GRANTEE                      VARCHAR2(30)
     ,PRIVILEGE                    VARCHAR2(40)
     ,ADMIN_OPTION                 VARCHAR2(3));

     CREATE TABLE ENMO_TABLES (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,OWNER                        VARCHAR2(30)
     ,TABLE_NAME                   VARCHAR2(30)
     ,TABLESPACE_NAME              VARCHAR2(30)
     ,CLUSTER_NAME                 VARCHAR2(30)
     ,IOT_NAME                     VARCHAR2(30)
     ,STATUS                       VARCHAR2(8)
     ,PCT_FREE                     NUMBER
     ,PCT_USED                     NUMBER
     ,INI_TRANS                    NUMBER
     ,MAX_TRANS                    NUMBER
     ,INITIAL_EXTENT               NUMBER
     ,NEXT_EXTENT                  NUMBER
     ,MIN_EXTENTS                  NUMBER
     ,MAX_EXTENTS                  NUMBER
     ,PCT_INCREASE                 NUMBER
     ,FREELISTS                    NUMBER
     ,FREELIST_GROUPS              NUMBER
     ,LOGGING                      VARCHAR2(3)
     ,BACKED_UP                    VARCHAR2(1)
     ,NUM_ROWS                     NUMBER
     ,BLOCKS                       NUMBER
     ,EMPTY_BLOCKS                 NUMBER
     ,AVG_SPACE                    NUMBER
     ,CHAIN_CNT                    NUMBER
     ,AVG_ROW_LEN                  NUMBER
     ,AVG_SPACE_FREELIST_BLOCKS    NUMBER
     ,NUM_FREELIST_BLOCKS          NUMBER
     ,DEGREE                       VARCHAR2(30)
     ,INSTANCES                    VARCHAR2(30)
     ,CACHE                        VARCHAR2(15)
     ,TABLE_LOCK                   VARCHAR2(8)
     ,SAMPLE_SIZE                  NUMBER
     ,LAST_ANALYZED                DATE
     ,PARTITIONED                  VARCHAR2(3)
     ,IOT_TYPE                     VARCHAR2(12)
     ,TEMPORARY                    VARCHAR2(1)
     ,SECONDARY                    VARCHAR2(1)
     ,NESTED                       VARCHAR2(3)
     ,BUFFER_POOL                  VARCHAR2(7)
     ,ROW_MOVEMENT                 VARCHAR2(8)
     ,GLOBAL_STATS                 VARCHAR2(3)
     ,USER_STATS                   VARCHAR2(3)
     ,DURATION                     VARCHAR2(15)
     ,SKIP_CORRUPT                 VARCHAR2(8)
     ,MONITORING                   VARCHAR2(3)
     ,CLUSTER_OWNER                VARCHAR2(30)
     ,DEPENDENCIES                 VARCHAR2(8)
     ,COMPRESSION                  VARCHAR2(8)
     ,DROPPED                      VARCHAR2(3));

     CREATE TABLE ENMO_TAB_PRIVS (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,GRANTEE                      VARCHAR2(30)
     ,OWNER                        VARCHAR2(30)
     ,TABLE_NAME                   VARCHAR2(30)
     ,GRANTOR                      VARCHAR2(30)
     ,PRIVILEGE                    VARCHAR2(40)
     ,GRANTABLE                    VARCHAR2(3)
     ,HIERARCHY                    VARCHAR2(3));

     CREATE TABLE ENMO_USERS (
      DBID                         NUMBER
     ,LOAD_DATE                    DATE
     ,USERNAME                     VARCHAR2(30)
     ,USER_ID                      NUMBER
     ,PASSWORD                     VARCHAR2(30)
     ,ACCOUNT_STATUS               VARCHAR2(32)
     ,LOCK_DATE                    DATE
     ,EXPIRY_DATE                  DATE
     ,DEFAULT_TABLESPACE           VARCHAR2(30)
     ,TEMPORARY_TABLESPACE         VARCHAR2(30)
     ,CREATED                      DATE
     ,EXTERNAL_NAME                VARCHAR2(4000));

     CREATE TABLE ENMO_PART_KEY_COLUMNS (
      DBID                        NUMBER
     ,LOAD_DATE                   DATE
     ,OWNER                       VARCHAR2(30)
     ,NAME                        VARCHAR2(30)
     ,OBJECT_TYPE                 CHAR(5)
     ,COLUMN_NAME                 VARCHAR2(4000)
     ,COLUMN_POSITION             NUMBER);

     CREATE TABLE ENMO_SUBPART_KEY_COLUMNS (
      DBID                        NUMBER
     ,LOAD_DATE                   DATE
     ,OWNER                       VARCHAR2(30)
     ,NAME                        VARCHAR2(30)
     ,OBJECT_TYPE                 CHAR(5)
     ,COLUMN_NAME                 VARCHAR2(4000)
     ,COLUMN_POSITION             NUMBER);

     CREATE TABLE ENMO_TAB_PARTITIONS (
      DBID                        NUMBER
     ,LOAD_DATE                   DATE
     ,TABLE_OWNER                 VARCHAR2(30)
     ,TABLE_NAME                  VARCHAR2(30)
     ,COMPOSITE                   VARCHAR2(3)
     ,PARTITION_NAME              VARCHAR2(30)
     ,SUBPARTITION_COUNT          NUMBER
     ,HIGH_VALUE                  CLOB
     ,HIGH_VALUE_LENGTH           NUMBER
     ,PARTITION_POSITION          NUMBER
     ,TABLESPACE_NAME             VARCHAR2(30)
     ,PCT_FREE                    NUMBER
     ,PCT_USED                    NUMBER
     ,INI_TRANS                   NUMBER
     ,MAX_TRANS                   NUMBER
     ,INITIAL_EXTENT              NUMBER
     ,NEXT_EXTENT                 NUMBER
     ,MIN_EXTENT                  NUMBER
     ,MAX_EXTENT                  NUMBER
     ,PCT_INCREASE                NUMBER
     ,FREELISTS                   NUMBER
     ,FREELIST_GROUPS             NUMBER
     ,LOGGING                     VARCHAR2(7)
     ,COMPRESSION                 VARCHAR2(8)
     ,NUM_ROWS                    NUMBER
     ,BLOCKS                      NUMBER
     ,EMPTY_BLOCKS                NUMBER
     ,AVG_SPACE                   NUMBER
     ,CHAIN_CNT                   NUMBER
     ,AVG_ROW_LEN                 NUMBER
     ,SAMPLE_SIZE                 NUMBER
     ,LAST_ANALYZED               DATE
     ,BUFFER_POOL                 VARCHAR2(7)
     ,GLOBAL_STATS                VARCHAR2(3)
     ,USER_STATS                  VARCHAR2(3));

     CREATE TABLE ENMO_IND_PARTITIONS (
      DBID                        NUMBER
     ,LOAD_DATE                   DATE
     ,INDEX_OWNER                 VARCHAR2(30)
     ,INDEX_NAME                  VARCHAR2(30)
     ,COMPOSITE                   VARCHAR2(3)
     ,PARTITION_NAME              VARCHAR2(30)
     ,SUBPARTITION_COUNT          NUMBER
     ,HIGH_VALUE                  CLOB
     ,HIGH_VALUE_LENGTH           NUMBER
     ,PARTITION_POSITION          NUMBER
     ,STATUS                      VARCHAR2(8)
     ,TABLESPACE_NAME             VARCHAR2(30)
     ,PCT_FREE                    NUMBER
     ,INI_TRANS                   NUMBER
     ,MAX_TRANS                   NUMBER
     ,INITIAL_EXTENT              NUMBER
     ,NEXT_EXTENT                 NUMBER
     ,MIN_EXTENT                  NUMBER
     ,MAX_EXTENT                  NUMBER
     ,PCT_INCREASE                NUMBER
     ,FREELISTS                   NUMBER
     ,FREELIST_GROUPS             NUMBER
     ,LOGGING                     VARCHAR2(7)
     ,COMPRESSION                 VARCHAR2(8)
     ,BLEVEL                      NUMBER
     ,LEAF_BLOCKS                 NUMBER
     ,DISTINCT_KEYS               NUMBER
     ,AVG_LEAF_BLOCKS_PER_KEY     NUMBER
     ,AVG_DATA_BLOCKS_PER_KEY     NUMBER
     ,CLUSTERING_FACTOR           NUMBER
     ,NUM_ROWS                    NUMBER
     ,SAMPLE_SIZE                 NUMBER
     ,LAST_ANALYZED               DATE
     ,BUFFER_POOL                 VARCHAR2(7)
     ,USER_STATS                  VARCHAR2(3)
     ,PCT_DIRECT_ACCESS           NUMBER
     ,GLOBAL_STATS                VARCHAR2(3)
     ,DOMIDX_OPSTATUS             VARCHAR2(6)
     ,PARAMETERS                  VARCHAR2(1000));

     CREATE TABLE ENMO_LOBS (
      DBID                        NUMBER
     ,LOAD_DATE                   DATE
     ,OWNER                       VARCHAR2(30)
     ,TABLE_NAME                  VARCHAR2(30)
     ,COLUMN_NAME                 VARCHAR2(4000)
     ,SEGMENT_NAME                VARCHAR2(30)
     ,TABLESPACE_NAME             VARCHAR2(30)
     ,INDEX_NAME                  VARCHAR2(30)
     ,CHUNK                       NUMBER
     ,PCTVERSION                  NUMBER
     ,RETENTION                   NUMBER
     ,FREEPOOLS                   NUMBER
     ,CACHE                       VARCHAR2(10)
     ,LOGGING                     VARCHAR2(7)
     ,IN_ROW                      VARCHAR2(3)
     ,FORMAT                      VARCHAR2(15)
     ,PARTITIONED                 VARCHAR2(3));

     CREATE TABLE ENMO_LATEST_INFO (
      DBID                        NUMBER
     ,LATEST_DATE                 DATE);
EOFSCRIPTS

  echo 'EOF' >> ${METAIMPSCRIPT}
  cat >>${METAIMPSCRIPT} <<"EOFSCRIPTS"
     execute_sql 'N'

     # Check Initialization Errors
     ERROR_MSG=`cat ${__SQLPLUSRESULT} | grep '^ORA-' | grep -v 'ORA-00955' | sort -u`
     if [ "${ERROR_MSG}" != "" ]; then
         print_log "[initial_repo]" "" "Error Message Detected as :"
         print_log "[initial_repo]" "" "${ERROR_MSG}"
         exit 1
     fi

     print_log "[initial_repo]" "" "Enmo Metadata Repository Already Prepared"
 }


 #########################################################################################################
 ##                                                                                                     ##
 ## Funtion create_view(): Create Dict View in Stage User                                               ##
 ##                                                                                                     ##
 #########################################################################################################
 create_view(){

     print_log "[create_view]" "" "Begin Create Dict View in Stage User"
     # Initial SQL Scripts
     cat > ${__SQLPLUSSCRIPT} <<EOF
     connect ${__METASTAGEUSER}/${__METASTAGEUSER}
EOFSCRIPTS

  echo 'EOF' >> ${METAIMPSCRIPT}
  cat >>${METAIMPSCRIPT} <<"EOFSCRIPTS"

    cat >> ${__SQLPLUSSCRIPT} <<"EOF"
    -- View Name  : ROLE_SYS_PRIVS
    -- Base Table : user$ , system_privilege_map , sysauth$
    CREATE OR REPLACE VIEW ROLE_SYS_PRIVS (ROLE, PRIVILEGE, ADMIN_OPTION)
    AS
    select u.name, spm.name, decode(min(option$), 1, 'YES', 'NO')
      from user$ u, system_privilege_map spm, sysauth$ sa
     where u.type# = 0
       and u.user# = sa.grantee#
       and sa.privilege# = spm.privilege
     group by u.name, spm.name
    /

    -- View Name  : ROLE_TAB_PRIVS
    -- Base Table : user$ , table_privilege_map , objauth$ , col$ , obj$
    CREATE OR REPLACE VIEW ROLE_TAB_PRIVS (ROLE, OWNER, TABLE_NAME, COLUMN_NAME, PRIVILEGE, GRANTABLE)
    AS
    select u1.name,
           u2.name,
           o.name,
           col$.name,
           tpm.name,
           decode(max(mod(oa.option$, 2)), 1, 'YES', 'NO')
      from user$                   u1,
           user$                   u2,
           table_privilege_map     tpm,
           objauth$                oa,
           obj$                    o,
           col$
     where u1.type# = 0
       and u1.user# = oa.grantee#
       and oa.privilege# = tpm.privilege
       and oa.obj# = o.obj#
       and oa.obj# = col$.obj#(+)
       and oa.col# = col$.col#(+)
       and u2.user# = o.owner#
       and (col$.property IS NULL OR bitand(col$.property, 32) = 0)
     group by u1.name, u2.name, o.name, col$.name, tpm.name
    /

    -- View Name  : ROLE_ROLE_PRIVS
    -- Base Table : user$ , sysauth$
    CREATE OR REPLACE VIEW ROLE_ROLE_PRIVS (ROLE, GRANTED_ROLE, ADMIN_OPTION)
    AS
    select u1.name, u2.name, decode(min(option$), 1, 'YES', 'NO')
      from user$ u1, user$ u2, sysauth$ sa
     where u1.type# = 0
       and u1.user# = sa.grantee#
       and u2.user# = sa.privilege#
     group by u1.name, u2.name
    /

    -- View Name  : DBA_ROLE_PRIVS
    -- Base Table : sysauth$ , user$ , user$ , defrole$
    create or replace view DBA_ROLE_PRIVS(GRANTEE, GRANTED_ROLE, ADMIN_OPTION, DEFAULT_ROLE)
    as
    select /*+ ordered */
     decode(sa.grantee#, 1, 'PUBLIC', u1.name),
     u2.name,
     decode(min(option$), 1, 'YES', 'NO'),
     decode(min(u1.defrole), 0, 'NO', 1, 'YES', 2, decode(min(ud.role#), null, 'NO', 'YES'), 3, decode(min(ud.role#), null, 'YES', 'NO'), 'NO')
      from sysauth$ sa, user$ u1, user$ u2, defrole$ ud
     where sa.grantee# = ud.user#(+)
       and sa.privilege# = ud.role#(+)
       and u1.user# = sa.grantee#
       and u2.user# = sa.privilege#
     group by decode(sa.grantee#, 1, 'PUBLIC', u1.name), u2.name
    /

    -- View Name  : DBA_ROLES
    -- Base Table : user$
    CREATE OR REPLACE FORCE VIEW DBA_ROLES (ROLE, PASSWORD_REQUIRED)
    AS
    select name, decode(password, null, 'NO', 'EXTERNAL', 'EXTERNAL', 'GLOBAL', 'GLOBAL', 'YES')
      from user$
     where type# = 0
       and name not in ('PUBLIC', '_NEXT_USER')
    /

    -- View Name  : DBA_USERS
    -- Base Table : user$ , ts$ , user_astatus_map
    create or replace view DBA_USERS
        (USERNAME, USER_ID, PASSWORD, ACCOUNT_STATUS, LOCK_DATE, EXPIRY_DATE,
         DEFAULT_TABLESPACE, TEMPORARY_TABLESPACE, CREATED, EXTERNAL_NAME)
    as
    select u.name, u.user#, u.password, m.status,
           decode(u.astatus, 4, u.ltime, 5, u.ltime, 6, u.ltime, 8, u.ltime, 9, u.ltime, 10, u.ltime, to_date(NULL)),
           decode(u.astatus, 1, u.exptime, 2, u.exptime, 5, u.exptime, 6, u.exptime, 9, u.exptime, 10, u.exptime, to_date(NULL)),
           dts.name, tts.name, u.ctime, u.ext_username
           from user$ u, ts$ dts, ts$ tts, USER_ASTATUS_MAP m
           where u.datats# = dts.ts#
           and u.tempts# = tts.ts#
           and u.astatus = m.status#
           and u.type# = 1
    /

    -- View Name  : DBA_SYS_PRIVS
    -- Base Table : system_privilege_map , sysauth$ , user$
    create or replace view DBA_SYS_PRIVS(GRANTEE, PRIVILEGE, ADMIN_OPTION)
    as
    select u.name, spm.name, decode(min(option$), 1, 'YES', 'NO')
      from system_privilege_map spm, sysauth$ sa, user$ u
     where sa.grantee# = u.user#
       and sa.privilege# = spm.privilege
     group by u.name, spm.name
    /

    -- View Name  : DBA_TAB_PRIVS
    -- Base Table : objauth$ , obj$ , user$
    create or replace view DBA_TAB_PRIVS(GRANTEE, OWNER, TABLE_NAME, GRANTOR, PRIVILEGE, GRANTABLE, HIERARCHY)
    as
    select ue.name,
           u.name,
           o.name,
           ur.name,
           tpm.name,
           decode(mod(oa.option$, 2), 1, 'YES', 'NO'),
           decode(bitand(oa.option$, 2), 2, 'YES', 'NO')
      from objauth$            oa,
           obj$                o,
           user$               u,
           user$               ur,
           user$               ue,
           table_privilege_map tpm
     where oa.obj# = o.obj#
       and oa.grantor# = ur.user#
       and oa.grantee# = ue.user#
       and oa.col# is null
       and oa.privilege# = tpm.privilege
       and u.user# = o.owner#
    /

    -- View Name  : DBA_COL_PRIVS
    -- Base Table : objauth$ , obj$ , user$ , user$ , user$ , col$ , table_privilege_map
    CREATE OR REPLACE VIEW DBA_COL_PRIVS(GRANTEE, OWNER, TABLE_NAME, COLUMN_NAME, GRANTOR, PRIVILEGE, GRANTABLE)
    AS
    select ue.name,
           u.name,
           o.name,
           c.name,
           ur.name,
           tpm.name,
           decode(mod(oa.option$, 2), 1, 'YES', 'NO')
      from objauth$            oa,
           obj$                o,
           user$               u,
           user$               ur,
           user$               ue,
           col$                c,
           table_privilege_map tpm
     where oa.obj# = o.obj#
       and oa.grantor# = ur.user#
       and oa.grantee# = ue.user#
       and oa.obj# = c.obj#
       and oa.col# = c.col#
       and bitand(c.property, 32) = 0 /* not hidden column */
       and oa.col# is not null
       and oa.privilege# = tpm.privilege
       and u.user# = o.owner#
    /

    -- View Name  : DBA_TABLES
    -- Base Table : user$ , ts$ , seg$ , obj$ , tab$
    create or replace view DBA_TABLES
        (OWNER, TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME, IOT_NAME, STATUS,
         PCT_FREE, PCT_USED,
         INI_TRANS, MAX_TRANS,
         INITIAL_EXTENT, NEXT_EXTENT,
         MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
         FREELISTS, FREELIST_GROUPS, LOGGING,
         BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
         AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN,
         AVG_SPACE_FREELIST_BLOCKS, NUM_FREELIST_BLOCKS,
         DEGREE, INSTANCES, CACHE, TABLE_LOCK,
         SAMPLE_SIZE, LAST_ANALYZED, PARTITIONED,
         IOT_TYPE, TEMPORARY, SECONDARY, NESTED,
         BUFFER_POOL, ROW_MOVEMENT,
         GLOBAL_STATS, USER_STATS, DURATION, SKIP_CORRUPT, MONITORING,
         CLUSTER_OWNER, DEPENDENCIES, COMPRESSION, DROPPED)
    as
    select u.name, o.name, decode(bitand(t.property,2151678048), 0, ts.name, null),
           decode(bitand(t.property, 1024), 0, null, co.name),
           decode((bitand(t.property, 512)+bitand(t.flags, 536870912)),
                  0, null, co.name),
           decode(bitand(t.trigflag, 1073741824), 1073741824, 'UNUSABLE', 'VALID'),
           decode(bitand(t.property, 32+64), 0, mod(t.pctfree$, 100), 64, 0, null),
           decode(bitand(ts.flags, 32), 32, to_number(NULL),
              decode(bitand(t.property, 32+64), 0, t.pctused$, 64, 0, null)),
           decode(bitand(t.property, 32), 0, t.initrans, null),
           decode(bitand(t.property, 32), 0, t.maxtrans, null),
           s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
           s.minexts, s.maxexts,
           decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                          s.extpct),
           decode(bitand(ts.flags, 32), 32, to_number(NULL),
             decode(bitand(o.flags, 2), 2, 1, decode(s.lists, 0, 1, s.lists))),
           decode(bitand(ts.flags, 32), 32, to_number(NULL),
             decode(bitand(o.flags, 2), 2, 1, decode(s.groups, 0, 1, s.groups))),
           decode(bitand(t.property, 32+64), 0,
                    decode(bitand(t.flags, 32), 0, 'YES', 'NO'), null),
           decode(bitand(t.flags,1), 0, 'Y', 1, 'N', '?'),
           t.rowcnt,
           decode(bitand(t.property, 64), 0, t.blkcnt, null),
           decode(bitand(t.property, 64), 0, t.empcnt, null),
           t.avgspc, t.chncnt, t.avgrln, t.avgspc_flb,
           decode(bitand(t.property, 64), 0, t.flbcnt, null),
           lpad(decode(t.degree, 32767, 'DEFAULT', nvl(t.degree,1)),10),
           lpad(decode(t.instances, 32767, 'DEFAULT', nvl(t.instances,1)),10),
           lpad(decode(bitand(t.flags, 8), 8, 'Y', 'N'),5),
           decode(bitand(t.flags, 6), 0, 'ENABLED', 'DISABLED'),
           t.samplesize, t.analyzetime,
           decode(bitand(t.property, 32), 32, 'YES', 'NO'),
           decode(bitand(t.property, 64), 64, 'IOT',
                   decode(bitand(t.property, 512), 512, 'IOT_OVERFLOW',
                   decode(bitand(t.flags, 536870912), 536870912, 'IOT_MAPPING', null))),
           decode(bitand(o.flags, 2), 0, 'N', 2, 'Y', 'N'),
           decode(bitand(o.flags, 16), 0, 'N', 16, 'Y', 'N'),
           decode(bitand(t.property, 8192), 8192, 'YES',
                  decode(bitand(t.property, 1), 0, 'NO', 'YES')),
           decode(bitand(o.flags, 2), 2, 'DEFAULT',
                 decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)),
           decode(bitand(t.flags, 131072), 131072, 'ENABLED', 'DISABLED'),
           decode(bitand(t.flags, 512), 0, 'NO', 'YES'),
           decode(bitand(t.flags, 256), 0, 'NO', 'YES'),
           decode(bitand(o.flags, 2), 0, NULL,
              decode(bitand(t.property, 8388608), 8388608,
                     'SYS$SESSION', 'SYS$TRANSACTION')),
           decode(bitand(t.flags, 1024), 1024, 'ENABLED', 'DISABLED'),
           decode(bitand(o.flags, 2), 2, 'NO',
               decode(bitand(t.property, 2147483648), 2147483648, 'NO', 'XXX')),
           decode(bitand(t.property, 1024), 0, null, cu.name),
           decode(bitand(t.flags, 8388608), 8388608, 'ENABLED', 'DISABLED'),
           decode(bitand(t.property, 32), 32, null,
                    decode(bitand(s.spare1, 2048), 2048, 'ENABLED', 'DISABLED')),
           decode(bitand(o.flags, 128), 128, 'YES', 'NO')
    from user$ u, ts$ ts, seg$ s, obj$ co, tab$ t, obj$ o,
         obj$ cx, user$ cu
    where o.owner# = u.user#
      and o.obj# = t.obj#
      and bitand(t.property, 1) = 0
      and bitand(o.flags, 128) = 0
      and t.bobj# = co.obj# (+)
      and t.ts# = ts.ts#
      and t.file# = s.file# (+)
      and t.block# = s.block# (+)
      and t.ts# = s.ts# (+)
      and t.dataobj# = cx.obj# (+)
      and cx.owner# = cu.user# (+)
    /

    -- View Name  : DBA_PART_TABLES
    -- Base Table : obj$ , partobj$ , ts$ , tab$ , user$
    CREATE OR REPLACE VIEW DBA_PART_TABLES
        (OWNER, TABLE_NAME, PARTITIONING_TYPE, SUBPARTITIONING_TYPE, PARTITION_COUNT, DEF_SUBPARTITION_COUNT, PARTITIONING_KEY_COUNT,
          SUBPARTITIONING_KEY_COUNT, STATUS, DEF_TABLESPACE_NAME, DEF_PCT_FREE, DEF_PCT_USED, DEF_INI_TRANS, DEF_MAX_TRANS,
          DEF_INITIAL_EXTENT, DEF_NEXT_EXTENT, DEF_MIN_EXTENTS, DEF_MAX_EXTENTS, DEF_PCT_INCREASE, DEF_FREELISTS,
          DEF_FREELIST_GROUPS, DEF_LOGGING, DEF_COMPRESSION, DEF_BUFFER_POOL)
    AS
    select u.name, o.name,
           decode(po.parttype, 1, 'RANGE', 2, 'HASH', 3, 'SYSTEM', 4, 'LIST', 'UNKNOWN'),
           decode(mod(po.spare2, 256), 0, 'NONE', 2, 'HASH', 3, 'SYSTEM', 4, 'LIST', 'UNKNOWN'),
           po.partcnt, mod(trunc(po.spare2/65536), 65536), po.partkeycols,
           mod(trunc(po.spare2/256), 256),
           decode(bitand(t.trigflag, 1073741824), 1073741824, 'UNUSABLE', 'VALID'),
           ts.name, po.defpctfree,
           decode(bitand(ts.flags, 32), 32,  to_number(NULL),po.defpctused),
           po.definitrans,
           po.defmaxtrans,
           decode(po.deftiniexts, NULL, 'DEFAULT', po.deftiniexts),
           decode(po.defextsize, NULL, 'DEFAULT', po.defextsize),
           decode(po.defminexts, NULL, 'DEFAULT', po.defminexts),
           decode(po.defmaxexts, NULL, 'DEFAULT', po.defmaxexts),
           decode(po.defextpct, NULL, 'DEFAULT', po.defextpct),
           decode(bitand(ts.flags, 32), 32,  to_number(NULL),po.deflists),
           decode(bitand(ts.flags, 32), 32, to_number(NULL), po.defgroups),
           decode(po.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
           decode(mod(trunc(po.spare2/4294967296),256), 0, 'NONE', 1, 'ENABLED', 2, 'DISABLED', 'UNKNOWN'),
           decode(po.spare1, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
    from   obj$ o, partobj$ po, ts$ ts, tab$ t, user$ u
    where  o.obj# = po.obj# and po.defts# = ts.ts# and t.obj# = o.obj# and
           o.owner# = u.user# and o.subname IS NULL and
           o.namespace = 1 and o.remoteowner IS NULL and o.linkname IS NULL and
           bitand(t.property, 64 + 128) = 0
    union all -- NON-IOT and IOT
    select u.name, o.name,
           decode(po.parttype, 1, 'RANGE', 2, 'HASH', 3, 'SYSTEM', 4, 'LIST',
                                                                      'UNKNOWN'),
           decode(mod(po.spare2, 256), 0, 'NONE', 2, 'HASH', 3, 'SYSTEM',
                                         4, 'LIST', 'UNKNOWN'),
           po.partcnt, mod(trunc(po.spare2/65536), 65536), po.partkeycols,
           mod(trunc(po.spare2/256), 256),
           decode(bitand(t.trigflag, 1073741824), 1073741824, 'UNUSABLE', 'VALID'),
           NULL, TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),
           NULL,--decode(po.deftiniexts, NULL, 'DEFAULT', po.deftiniexts),
           NULL,--decode(po.defextsize, NULL, 'DEFAULT', po.defextsize),
           NULL,--decode(po.defminexts, NULL, 'DEFAULT', po.defminexts),
           NULL,--decode(po.defmaxexts, NULL, 'DEFAULT', po.defmaxexts),
           NULL,--decode(po.defextpct, NULL, 'DEFAULT', po.defextpct),
           TO_NUMBER(NULL),TO_NUMBER(NULL),--po.deflists, po.defgroups,
           decode(po.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
           'N/A',
           decode(po.spare1, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
    from   obj$ o, partobj$ po, tab$ t, user$ u
    where  o.obj# = po.obj# and t.obj# = o.obj# and
           o.owner# = u.user# and o.subname IS NULL and
           o.namespace = 1 and o.remoteowner IS NULL and o.linkname IS NULL and
           bitand(t.property, 64 + 128) != 0
    /

    -- View Name  : DBA_OBJECTS
    -- Base Table : obj$ , user$ , sum$
    create or replace view DBA_OBJECTS
        (OWNER, OBJECT_NAME, SUBOBJECT_NAME, OBJECT_ID, DATA_OBJECT_ID,
         OBJECT_TYPE, CREATED, LAST_DDL_TIME, TIMESTAMP, STATUS,
         TEMPORARY, GENERATED, SECONDARY)
    as
    select u.name, o.name, o.subname, o.obj#, o.dataobj#,
           decode(o.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                          4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
                          7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                          11, 'PACKAGE BODY', 12, 'TRIGGER',
                          13, 'TYPE', 14, 'TYPE BODY',
                          19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
                          22, 'LIBRARY', 23, 'DIRECTORY', 24, 'QUEUE',
                          28, 'JAVA SOURCE', 29, 'JAVA CLASS', 30, 'JAVA RESOURCE',
                          32, 'INDEXTYPE', 33, 'OPERATOR',
                          34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
                          40, 'LOB PARTITION', 41, 'LOB SUBPARTITION',
                          42, NVL((SELECT distinct 'REWRITE EQUIVALENCE' FROM sum$ s WHERE s.obj#=o.obj# and bitand(s.xpflags, 8388608) = 8388608), 'MATERIALIZED VIEW'),
                          43, 'DIMENSION',
                          44, 'CONTEXT', 46, 'RULE SET', 47, 'RESOURCE PLAN',
                          48, 'CONSUMER GROUP',
                          51, 'SUBSCRIPTION', 52, 'LOCATION',
                          55, 'XML SCHEMA', 56, 'JAVA DATA',
                          57, 'SECURITY PROFILE', 59, 'RULE',
                          60, 'CAPTURE', 61, 'APPLY',
                          62, 'EVALUATION CONTEXT',
                          66, 'JOB', 67, 'PROGRAM', 68, 'JOB CLASS', 69, 'WINDOW',
                          72, 'WINDOW GROUP', 74, 'SCHEDULE', 79, 'CHAIN',
                          81, 'FILE GROUP',
                         'UNDEFINED'),
           o.ctime, o.mtime,
           to_char(o.stime, 'YYYY-MM-DD:HH24:MI:SS'),
           decode(o.status, 0, 'N/A', 1, 'VALID', 'INVALID'),
           decode(bitand(o.flags, 2), 0, 'N', 2, 'Y', 'N'),
           decode(bitand(o.flags, 4), 0, 'N', 4, 'Y', 'N'),
           decode(bitand(o.flags, 16), 0, 'N', 16, 'Y', 'N')
    from obj$ o, user$ u
    where o.owner# = u.user#
      and o.linkname is null
      and (o.type# not in (1  /* INDEX - handled below */,
                          10 /* NON-EXISTENT */)
           or
           (o.type# = 1 and 1 = (select 1
                                  from ind$ i
                                 where i.obj# = o.obj#
                                   and i.type# in (1, 2, 3, 4, 6, 7, 9))))
      and o.name != '_NEXT_OBJECT'
      and o.name != '_default_auditing_options_'
      and bitand(o.flags, 128) = 0
    /

    -- View Name  : DBA_INDEXES
    -- Base Table : ts$ , seg$ , user$ , obj$ , ind$
    create or replace view DBA_INDEXES
        (OWNER, INDEX_NAME,
         INDEX_TYPE,
         TABLE_OWNER, TABLE_NAME,
         TABLE_TYPE,
         UNIQUENESS,
         COMPRESSION, PREFIX_LENGTH,
         TABLESPACE_NAME, INI_TRANS, MAX_TRANS,
         INITIAL_EXTENT, NEXT_EXTENT,
         MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE, PCT_THRESHOLD, INCLUDE_COLUMN,
         FREELISTS, FREELIST_GROUPS, PCT_FREE, LOGGING, BLEVEL,
         LEAF_BLOCKS, DISTINCT_KEYS, AVG_LEAF_BLOCKS_PER_KEY,
         AVG_DATA_BLOCKS_PER_KEY, CLUSTERING_FACTOR, STATUS,
         NUM_ROWS, SAMPLE_SIZE, LAST_ANALYZED, DEGREE, INSTANCES, PARTITIONED,
         TEMPORARY, GENERATED, SECONDARY, BUFFER_POOL,
         USER_STATS, DURATION, PCT_DIRECT_ACCESS,
         ITYP_OWNER, ITYP_NAME, PARAMETERS, GLOBAL_STATS, DOMIDX_STATUS,
         DOMIDX_OPSTATUS, FUNCIDX_STATUS, JOIN_INDEX, IOT_REDUNDANT_PKEY_ELIM,
         DROPPED)
    as
    select u.name, o.name,
           decode(bitand(i.property, 16), 0, '', 'FUNCTION-BASED ') ||
            decode(i.type#, 1, 'NORMAL'||
                              decode(bitand(i.property, 4), 0, '', 4, '/REV'),
                          2, 'BITMAP', 3, 'CLUSTER', 4, 'IOT - TOP',
                          5, 'IOT - NESTED', 6, 'SECONDARY', 7, 'ANSI', 8, 'LOB',
                          9, 'DOMAIN'),
           iu.name, io.name,
           decode(io.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                           4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 'UNDEFINED'),
           decode(bitand(i.property, 1), 0, 'NONUNIQUE', 1, 'UNIQUE', 'UNDEFINED'),
           decode(bitand(i.flags, 32), 0, 'DISABLED', 32, 'ENABLED', null),
           i.spare2,
           decode(bitand(i.property, 34), 0,
               decode(i.type#, 9, null, ts.name), null),
           decode(bitand(i.property, 2),0, i.initrans, null),
           decode(bitand(i.property, 2),0, i.maxtrans, null),
           s.iniexts * ts.blocksize, s.extsize * ts.blocksize,
           s.minexts, s.maxexts,
            decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                         s.extpct),
           decode(i.type#, 4, mod(i.pctthres$,256), NULL), i.trunccnt,
           decode(bitand(ts.flags, 32), 32, to_number(NULL),
             decode(bitand(o.flags, 2), 2, 1, decode(s.lists, 0, 1, s.lists))),
           decode(bitand(ts.flags, 32), 32, to_number(NULL),
             decode(bitand(o.flags, 2), 2, 1, decode(s.groups, 0, 1, s.groups))),
           decode(bitand(i.property, 2),0,i.pctfree$,null),
           decode(bitand(i.property, 2), 2, NULL,
                    decode(bitand(i.flags, 4), 0, 'YES', 'NO')),
           i.blevel, i.leafcnt, i.distkey, i.lblkkey, i.dblkkey, i.clufac,
           decode(bitand(i.property, 2), 2,
                       decode(i.type#, 9, decode(bitand(i.flags, 8),
                                            8, 'INPROGRS', 'VALID'), 'N/A'),
                         decode(bitand(i.flags, 1), 1, 'UNUSABLE',
                                decode(bitand(i.flags, 8), 8, 'INPROGRS',
                                                                'VALID'))),
           rowcnt, samplesize, analyzetime,
           decode(i.degree, 32767, 'DEFAULT', nvl(i.degree,1)),
           decode(i.instances, 32767, 'DEFAULT', nvl(i.instances,1)),
           decode(bitand(i.property, 2), 2, 'YES', 'NO'),
           decode(bitand(o.flags, 2), 0, 'N', 2, 'Y', 'N'),
           decode(bitand(o.flags, 4), 0, 'N', 4, 'Y', 'N'),
           decode(bitand(o.flags, 16), 0, 'N', 16, 'Y', 'N'),
           decode(bitand(o.flags, 2), 2, 'DEFAULT',
                 decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)),
           decode(bitand(i.flags, 64), 0, 'NO', 'YES'),
           decode(bitand(o.flags, 2), 0, NULL,
               decode(bitand(i.property, 64), 64, 'SYS$SESSION', 'SYS$TRANSACTION')),
           decode(bitand(i.flags, 128), 128, mod(trunc(i.pctthres$/256),256),
                  decode(i.type#, 4, mod(trunc(i.pctthres$/256),256), NULL)),
           itu.name, ito.name, i.spare4,
           decode(bitand(i.flags, 2048), 0, 'NO', 'YES'),
           decode(i.type#, 9, decode(o.status, 5, 'IDXTYP_INVLD',
                                               1, 'VALID'),  ''),
           decode(i.type#, 9, decode(bitand(i.flags, 16), 16, 'FAILED', 'VALID'), ''),
           decode(bitand(i.property, 16), 0, '',
                  decode(bitand(i.flags, 1024), 0, 'ENABLED', 'DISABLED')),
           decode(bitand(i.property, 1024), 1024, 'YES', 'NO'),
           decode(bitand(i.property, 16384), 16384, 'YES', 'NO'),
           decode(bitand(o.flags, 128), 128, 'YES', 'NO')
    from ts$ ts, seg$ s,
         user$ iu, obj$ io, user$ u, ind$ i, obj$ o,
         user$ itu, obj$ ito
    where u.user# = o.owner#
      and o.obj# = i.obj#
      and i.bo# = io.obj#
      and io.owner# = iu.user#
      and bitand(i.flags, 4096) = 0
      and bitand(o.flags, 128) = 0
      and i.ts# = ts.ts# (+)
      and i.file# = s.file# (+)
      and i.block# = s.block# (+)
      and i.ts# = s.ts# (+)
      and i.indmethod# = ito.obj# (+)
      and ito.owner# = itu.user# (+)
    /

    -- View Name  : DBA_PART_INDEXES
    -- Base Table : obj$ , partobj$ , ts$ , ind$ ,user$
    CREATE OR REPLACE VIEW DBA_PART_INDEXES
           (OWNER, INDEX_NAME, TABLE_NAME, PARTITIONING_TYPE, SUBPARTITIONING_TYPE, PARTITION_COUNT, DEF_SUBPARTITION_COUNT,
             PARTITIONING_KEY_COUNT, SUBPARTITIONING_KEY_COUNT, LOCALITY, ALIGNMENT, DEF_TABLESPACE_NAME, DEF_PCT_FREE,
             DEF_INI_TRANS, DEF_MAX_TRANS, DEF_INITIAL_EXTENT, DEF_NEXT_EXTENT, DEF_MIN_EXTENTS, DEF_MAX_EXTENTS, DEF_PCT_INCREASE,
             DEF_FREELISTS, DEF_FREELIST_GROUPS, DEF_LOGGING, DEF_BUFFER_POOL, DEF_PARAMETERS)
    AS
    select u.name, io.name, o.name,
           decode(po.parttype, 1, 'RANGE', 2, 'HASH', 3, 'SYSTEM', 4, 'LIST', 'UNKNOWN'),
           decode(mod(po.spare2, 256), 0, 'NONE', 2, 'HASH', 3, 'SYSTEM', 4, 'LIST', 'UNKNOWN'),
           po.partcnt, mod(trunc(po.spare2/65536), 65536), po.partkeycols,
           mod(trunc(po.spare2/256), 256), decode(bitand(po.flags, 1), 1, 'LOCAL', 'GLOBAL'),
           decode(po.partkeycols, 0, 'NONE', decode(bitand(po.flags,2), 2, 'PREFIXED', 'NON_PREFIXED')),
           ts.name, po.defpctfree, po.definitrans,
           po.defmaxtrans,
           decode(po.deftiniexts, NULL, 'DEFAULT', po.deftiniexts),
           decode(po.defextsize, NULL, 'DEFAULT', po.defextsize),
           decode(po.defminexts, NULL, 'DEFAULT', po.defminexts),
           decode(po.defmaxexts, NULL, 'DEFAULT', po.defmaxexts),
           decode(po.defextpct,  NULL, 'DEFAULT', po.defextpct),
           po.deflists, po.defgroups,
           decode(po.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
           decode(po.spare1, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
           po.parameters
    from   obj$ io, obj$ o, partobj$ po, ts$ ts, ind$ i,user$ u
    where  io.obj# = po.obj# and po.defts# = ts.ts# (+) and
           i.obj# = io.obj# and o.obj# = i.bo# and u.user# = io.owner# and
           io.namespace = 4 and io.remoteowner IS NULL and io.linkname IS NULL
           and io.subname IS NULL
    /

    -- View Name  : DBA_SEQUENCES
    -- Base Table : seq$ , obj$ , user$
    create or replace view DBA_SEQUENCES
      (SEQUENCE_OWNER, SEQUENCE_NAME,
                      MIN_VALUE, MAX_VALUE, INCREMENT_BY,
                      CYCLE_FLAG, ORDER_FLAG, CACHE_SIZE, LAST_NUMBER)
    as select u.name, o.name,
          s.minvalue, s.maxvalue, s.increment$,
          decode (s.cycle#, 0, 'N', 1, 'Y'),
          decode (s.order$, 0, 'N', 1, 'Y'),
          s.cache, s.highwater
    from seq$ s, obj$ o, user$ u
    where u.user# = o.owner#
      and o.obj# = s.obj#
    /

    -- View Name  : DBA_IND_COLUMNS
    -- Base Table : col$ , obj$ , icol$ , user$ , ind$ , attrcol$
    create or replace view DBA_IND_COLUMNS
        (INDEX_OWNER, INDEX_NAME,
         TABLE_OWNER, TABLE_NAME,
         COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH,
         CHAR_LENGTH, DESCEND)
    as
    select io.name, idx.name, bo.name, base.name,
           decode(bitand(c.property, 1024), 1024,
                  (select decode(bitand(tc.property, 1), 1, ac.name, tc.name)
                  from col$ tc, attrcol$ ac
                  where tc.intcol# = c.intcol#-1
                    and tc.obj# = c.obj#
                    and tc.obj# = ac.obj#(+)
                    and tc.intcol# = ac.intcol#(+)),
                  decode(ac.name, null, c.name, ac.name)),
           ic.pos#, c.length, c.spare3,
           decode(bitand(c.property, 131072), 131072, 'DESC', 'ASC')
    from col$ c, obj$ idx, obj$ base, icol$ ic,
         user$ io, user$ bo, ind$ i, attrcol$ ac
    where ic.bo# = c.obj#
      and decode(bitand(i.property,1024),0,ic.intcol#,ic.spare2) = c.intcol#
      and ic.bo# = base.obj#
      and io.user# = idx.owner#
      and bo.user# = base.owner#
      and ic.obj# = idx.obj#
      and idx.obj# = i.obj#
      and i.type# in (1, 2, 3, 4, 6, 7, 9)
      and c.obj# = ac.obj#(+)
      and c.intcol# = ac.intcol#(+)
    /

    -- View Name  : SYS_OBJECTS
    -- Base Table : tab$ , tabpart$ , ind$ , indpart$
    CREATE OR REPLACE VIEW SYS_OBJECTS(OBJECT_TYPE, OBJECT_TYPE_ID, SEGMENT_TYPE_ID, OBJECT_ID, HEADER_FILE, HEADER_BLOCK, TS_NUMBER)
    AS
    select decode(bitand(t.property, 8192), 8192, 'NESTED TABLE', 'TABLE'),
           2,
           5,
           t.obj#,
           t.file#,
           t.block#,
           t.ts#
      from tab$ t
     where bitand(t.property, 1024) = 0 /* exclude clustered tables */
    union all
    select 'TABLE PARTITION', 19, 5, tp.obj#, tp.file#, tp.block#, tp.ts#
      from tabpart$ tp
    union all
    select decode(i.type#, 8, 'LOBINDEX', 'INDEX'),
           1,
           6,
           i.obj#,
           i.file#,
           i.block#,
           i.ts#
      from ind$ i
     where i.type# in (1, 2, 3, 4, 6, 7, 8, 9)
    union all
    select 'INDEX PARTITION', 20, 6, ip.obj#, ip.file#, ip.block#, ip.ts#
      from indpart$ ip
    /

    -- View Name  : SYS_DBA_SEGS
    -- Base Table : user$ , obj$ , ts$ , sys_objects , seg$ , file$
    CREATE OR REPLACE VIEW SYS_DBA_SEGS
          (OWNER, SEGMENT_NAME, PARTITION_NAME, SEGMENT_TYPE, SEGMENT_TYPE_ID, TABLESPACE_ID, TABLESPACE_NAME, BLOCKSIZE,
            HEADER_FILE, HEADER_BLOCK, BYTES, BLOCKS, EXTENTS, INITIAL_EXTENT, NEXT_EXTENT, MIN_EXTENTS, MAX_EXTENTS,
            PCT_INCREASE, FREELISTS, FREELIST_GROUPS, RELATIVE_FNO, BUFFER_POOL_ID, SEGMENT_FLAGS, SEGMENT_OBJD)
    AS
    select NVL(u.name, 'SYS'), o.name, o.subname,
           so.object_type, s.type#,
           ts.ts#, ts.name, ts.blocksize,
           f.file#, s.block#,
           s.blocks * ts.blocksize, s.blocks, s.extents,
           s.iniexts * ts.blocksize,
           s.extsize * ts.blocksize,
           s.minexts, s.maxexts,
           decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                          s.extpct),
           decode(bitand(ts.flags, 32), 32, to_number(NULL),
                  decode(s.lists, 0, 1, s.lists)),
           decode(bitand(ts.flags, 32), 32, to_number(NULL),
                  decode(s.groups, 0, 1, s.groups)),
           s.file#, s.cachehint, NVL(s.spare1,0), o.dataobj#
    from user$ u, obj$ o, ts$ ts, sys_objects so, seg$ s, file$ f
    where s.file# = so.header_file
      and s.block# = so.header_block
      and s.ts# = so.ts_number
      and s.ts# = ts.ts#
      and o.obj# = so.object_id
      and o.owner# = u.user# (+)
      and s.type# = so.segment_type_id
      and o.type# = so.object_type_id
      and s.ts# = f.ts#
      and s.file# = f.relfile#
    union all
    select NVL(u.name, 'SYS'), to_char(f.file#) || '.' || to_char(s.block#), NULL,
           decode(s.type#, 2, 'DEFERRED ROLLBACK', 3, 'TEMPORARY',
                          4, 'CACHE', 9, 'SPACE HEADER', 'UNDEFINED'), s.type#,
           ts.ts#, ts.name, ts.blocksize,
           f.file#, s.block#,
           s.blocks * ts.blocksize, s.blocks, s.extents,
           s.iniexts * ts.blocksize,
           s.extsize * ts.blocksize,
           s.minexts, s.maxexts,
           decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                          s.extpct),
           decode(bitand(ts.flags, 32), 32, to_number(NULL),
             decode(s.lists, 0, 1, s.lists)),
           decode(bitand(ts.flags, 32), 32, to_number(NULL),
             decode(s.groups, 0, 1, s.groups)),
           s.file#, s.cachehint, NVL(s.spare1,0), s.hwmincr
    from user$ u, ts$ ts, seg$ s, file$ f
    where s.ts# = ts.ts#
      and s.user# = u.user# (+)
      and s.type# not in (1, 5, 6, 8, 10)
      and s.ts# = f.ts#
      and s.file# = f.relfile#
    /

    -- View Name  : DBA_SEGMENTS
    -- Base Table : sys_dba_segs
    CREATE OR REPLACE VIEW DBA_SEGMENTS
           (OWNER, SEGMENT_NAME, PARTITION_NAME, SEGMENT_TYPE, TABLESPACE_NAME, HEADER_FILE, HEADER_BLOCK, BYTES, BLOCKS, EXTENTS,
            INITIAL_EXTENT, NEXT_EXTENT, MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,FREELISTS, FREELIST_GROUPS, RELATIVE_FNO, BUFFER_POOL)
    AS
    select owner, segment_name, partition_name, segment_type, tablespace_name,
           header_file, header_block,
           decode(bitand(segment_flags, 131072), 131072, blocks,
               (decode(bitand(segment_flags,1),1,
                sys.dbms_space_admin.segment_number_blocks(tablespace_id, relative_fno,
                header_block, segment_type_id, buffer_pool_id, segment_flags,
                segment_objd, blocks), blocks)))*blocksize,
           decode(bitand(segment_flags, 131072), 131072, blocks,
               (decode(bitand(segment_flags,1),1,
                sys.dbms_space_admin.segment_number_blocks(tablespace_id, relative_fno,
                header_block, segment_type_id, buffer_pool_id, segment_flags,
                segment_objd, blocks), blocks))),
           decode(bitand(segment_flags, 131072), 131072, extents,
               (decode(bitand(segment_flags,1),1,
               sys.dbms_space_admin.segment_number_extents(tablespace_id, relative_fno,
               header_block, segment_type_id, buffer_pool_id, segment_flags,
               segment_objd, extents) , extents))),
           initial_extent, next_extent, min_extents, max_extents, pct_increase,
           freelists, freelist_groups, relative_fno,
           decode(buffer_pool_id, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
    from sys_dba_segs
    /

    -- View Name  : DBA_TABLESPACES
    -- Base Table : ts$
    CREATE OR REPLACE VIEW DBA_TABLESPACES
           (TABLESPACE_NAME, BLOCK_SIZE, INITIAL_EXTENT, NEXT_EXTENT, MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
             MIN_EXTLEN, STATUS, CONTENTS, LOGGING, FORCE_LOGGING, EXTENT_MANAGEMENT, ALLOCATION_TYPE,
             PLUGGED_IN, SEGMENT_SPACE_MANAGEMENT, DEF_TAB_COMPRESSION, RETENTION, BIGFILE)
    AS
    select ts.name, ts.blocksize, ts.blocksize * ts.dflinit,
              decode(bitand(ts.flags, 3), 1, to_number(NULL), ts.blocksize * ts.dflincr),
              ts.dflminext,
              decode(ts.contents$, 1, to_number(NULL), ts.dflmaxext),
              decode(bitand(ts.flags, 3), 1, to_number(NULL), ts.dflextpct),
              ts.blocksize * ts.dflminlen,
              decode(ts.online$, 1, 'ONLINE', 2, 'OFFLINE', 4, 'READ ONLY', 'UNDEFINED'),
              decode(ts.contents$, 0, (decode(bitand(ts.flags, 16), 16, 'UNDO', 'PERMANENT')), 1, 'TEMPORARY'),
              decode(bitand(ts.dflogging, 1), 0, 'NOLOGGING', 1, 'LOGGING'),
              decode(bitand(ts.dflogging, 2), 0, 'NO', 2, 'YES'),
              decode(ts.bitmapped, 0, 'DICTIONARY', 'LOCAL'),
              decode(bitand(ts.flags, 3), 0, 'USER', 1, 'SYSTEM', 2, 'UNIFORM', 'UNDEFINED'),
              decode(ts.plugged, 0, 'NO', 'YES'),
              decode(bitand(ts.flags,32), 32,'AUTO', 'MANUAL'),
              decode(bitand(ts.flags,64), 64,'ENABLED', 'DISABLED'),
              decode(bitand(ts.flags,16), 16, (decode(bitand(ts.flags, 512), 512, 'GUARANTEE', 'NOGUARANTEE')), 'NOT APPLY'),
              decode(bitand(ts.flags,256), 256, 'YES', 'NO')
    from ts$ ts
    where ts.online$ != 3
    and bitand(flags,2048) != 2048
    /

    -- View Name  : DBA_TAB_COLS
    -- Base Table : col$ c, obj$ , hist_head$ , user$ , coltype$ , attrcol$ , obj$ , user$
    CREATE OR REPLACE VIEW DBA_TAB_COLS
           (OWNER, TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_TYPE_MOD, DATA_TYPE_OWNER, DATA_LENGTH, DATA_PRECISION, DATA_SCALE,
             NULLABLE, COLUMN_ID, DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE, DENSITY, NUM_NULLS, NUM_BUCKETS,
             LAST_ANALYZED, SAMPLE_SIZE, CHARACTER_SET_NAME, CHAR_COL_DECL_LENGTH, GLOBAL_STATS, USER_STATS, AVG_COL_LEN, CHAR_LENGTH,
             CHAR_USED, V80_FMT_IMAGE, DATA_UPGRADED, HIDDEN_COLUMN, VIRTUAL_COLUMN, SEGMENT_COLUMN_ID, INTERNAL_COLUMN_ID, HISTOGRAM, QUALIFIED_COL_NAME)
    AS
    select u.name, o.name, c.name,
           decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2', 'VARCHAR2'),
                           2, decode(c.scale, null, decode(c.precision#, null, 'NUMBER', 'FLOAT'), 'NUMBER'),
                           8, 'LONG',
                           9, decode(c.charsetform, 2, 'NCHAR VARYING', 'VARCHAR'),
                           12, 'DATE',
                           23, 'RAW', 24, 'LONG RAW',
                           58, nvl2(ac.synobj#, (select o.name from obj$ o where o.obj#=ac.synobj#), ot.name),
                           69, 'ROWID',
                           96, decode(c.charsetform, 2, 'NCHAR', 'CHAR'),
                           100, 'BINARY_FLOAT',
                           101, 'BINARY_DOUBLE',
                           105, 'MLSLABEL',
                           106, 'MLSLABEL',
                           111, nvl2(ac.synobj#, (select o.name from obj$ o where o.obj#=ac.synobj#), ot.name),
                           112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'),
                           113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
                           121, nvl2(ac.synobj#, (select o.name from obj$ o where o.obj#=ac.synobj#), ot.name),
                           122, nvl2(ac.synobj#, (select o.name from obj$ o where o.obj#=ac.synobj#), ot.name),
                           123, nvl2(ac.synobj#, (select o.name from obj$ o where o.obj#=ac.synobj#), ot.name),
                           178, 'TIME(' ||c.scale|| ')',
                           179, 'TIME(' ||c.scale|| ')' || ' WITH TIME ZONE',
                           180, 'TIMESTAMP(' ||c.scale|| ')',
                           181, 'TIMESTAMP(' ||c.scale|| ')' || ' WITH TIME ZONE',
                           231, 'TIMESTAMP(' ||c.scale|| ')' || ' WITH LOCAL TIME ZONE',
                           182, 'INTERVAL YEAR(' ||c.precision#||') TO MONTH',
                           183, 'INTERVAL DAY(' ||c.precision#||') TO SECOND(' || c.scale || ')',
                           208, 'UROWID', 'UNDEFINED'),
           decode(c.type#, 111, 'REF'),
           nvl2(ac.synobj#, (select u.name from user$ u, obj$ o where o.owner#=u.user# and o.obj#=ac.synobj#), ut.name),
           c.length, c.precision#, c.scale,
           decode(sign(c.null$),-1,'D', 0, 'Y', 'N'),
           decode(c.col#, 0, to_number(null), c.col#), c.deflength,
           c.default$, h.distcnt, h.lowval, h.hival, h.density, h.null_cnt,
           case when nvl(h.distcnt,0) = 0 then h.distcnt
                when h.row_cnt = 0 then 1
                when (h.bucket_cnt > 255
                      or
                      (h.bucket_cnt > h.distcnt
                       and h.row_cnt = h.distcnt
                       and h.density*h.bucket_cnt <= 1))
                    then h.row_cnt
                else h.bucket_cnt
           end,
           h.timestamp#, h.sample_size,
           decode(c.charsetform, 1, 'CHAR_CS', 2, 'NCHAR_CS', 3, NLS_CHARSET_NAME(c.charsetid), 4, 'ARG:'||c.charsetid),
           decode(c.charsetid, 0, to_number(NULL), nls_charset_decl_len(c.length, c.charsetid)),
           decode(bitand(h.spare2, 2), 2, 'YES', 'NO'),
           decode(bitand(h.spare2, 1), 1, 'YES', 'NO'),
           h.avgcln,
           c.spare3,
           decode(c.type#, 1, decode(bitand(c.property, 8388608), 0, 'B', 'C'),
                          96, decode(bitand(c.property, 8388608), 0, 'B', 'C'),
                          null),
           decode(bitand(ac.flags, 128), 128, 'YES', 'NO'),
           decode(o.status, 1, decode(bitand(ac.flags, 256), 256, 'NO', 'YES'),
                            decode(bitand(ac.flags, 2), 2, 'NO',
                                   decode(bitand(ac.flags, 4), 4, 'NO',
                                          decode(bitand(ac.flags, 8), 8, 'NO',
                                                 'N/A')))),
           decode(c.property, 0, 'NO', decode(bitand(c.property, 32), 32, 'YES',
                                              'NO')),
           decode(c.property, 0, 'NO', decode(bitand(c.property, 8), 8, 'YES',
                                              'NO')),
           decode(c.segcol#, 0, to_number(null), c.segcol#), c.intcol#,
           case when nvl(h.row_cnt,0) = 0 then 'NONE'
                when (h.bucket_cnt > 255
                      or
                      (h.bucket_cnt > h.distcnt and h.row_cnt = h.distcnt
                       and h.density*h.bucket_cnt <= 1))
                    then 'FREQUENCY'
                else 'HEIGHT BALANCED'
           end,
           decode(bitand(c.property, 1024), 1024,
                  (select decode(bitand(cl.property, 1), 1, rc.name, cl.name)
                   from col$ cl, attrcol$ rc where cl.intcol# = c.intcol#-1
                   and cl.obj# = c.obj# and c.obj# = rc.obj#(+) and
                   cl.intcol# = rc.intcol#(+)),
                  decode(bitand(c.property, 1), 0, c.name,
                         (select tc.name from attrcol$ tc
                          where c.obj# = tc.obj# and c.intcol# = tc.intcol#)))
    from col$ c, obj$ o, hist_head$ h, user$ u, coltype$ ac, obj$ ot, user$ ut
    where o.obj# = c.obj#
      and o.owner# = u.user#
      and c.obj# = h.obj#(+) and c.intcol# = h.intcol#(+)
      and c.obj# = ac.obj#(+) and c.intcol# = ac.intcol#(+)
      and ac.toid = ot.oid$(+)
      and ot.type#(+) = 13
      and ot.owner# = ut.user#(+)
      and (o.type# in (3, 4)                                     /* cluster, view */
           or
           (o.type# = 2     /* tables, excluding iot - overflow and nested tables */
            and
            not exists (select null
                          from tab$ t
                         where t.obj# = o.obj#
                           and (bitand(t.property, 512) = 512 or
                                bitand(t.property, 8192) = 8192))))
    /

    -- View Name  : DBA_TAB_COLUMNS
    -- Base Table : DBA_TAB_COLS
    CREATE OR REPLACE VIEW DBA_TAB_COLUMNS
           (OWNER, TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_TYPE_MOD, DATA_TYPE_OWNER, DATA_LENGTH, DATA_PRECISION, DATA_SCALE,
            NULLABLE, COLUMN_ID, DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE, DENSITY, NUM_NULLS, NUM_BUCKETS,
            LAST_ANALYZED, SAMPLE_SIZE, CHARACTER_SET_NAME, CHAR_COL_DECL_LENGTH, GLOBAL_STATS, USER_STATS, AVG_COL_LEN, CHAR_LENGTH,
            CHAR_USED, V80_FMT_IMAGE, DATA_UPGRADED, HISTOGRAM)
    AS
    select OWNER, TABLE_NAME,
           COLUMN_NAME, DATA_TYPE, DATA_TYPE_MOD, DATA_TYPE_OWNER,
           DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID,
           DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE,
           DENSITY, NUM_NULLS, NUM_BUCKETS, LAST_ANALYZED, SAMPLE_SIZE,
           CHARACTER_SET_NAME, CHAR_COL_DECL_LENGTH,
           GLOBAL_STATS, USER_STATS, AVG_COL_LEN, CHAR_LENGTH, CHAR_USED,
           V80_FMT_IMAGE, DATA_UPGRADED, HISTOGRAM
      from DBA_TAB_COLS
     where HIDDEN_COLUMN = 'NO'
    /

    -- View Name  : DBA_CONSTRAINTS
    -- Base Table : con$ , user$ , obj$ , cdef$ c
    CREATE OR REPLACE FORCE VIEW DBA_CONSTRAINTS (OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME,
    SEARCH_CONDITION, R_OWNER, R_CONSTRAINT_NAME, DELETE_RULE, STATUS, DEFERRABLE, DEFERRED, VALIDATED,
    GENERATED, BAD, RELY, LAST_CHANGE, INDEX_OWNER, INDEX_NAME, INVALID, VIEW_RELATED) AS
    select ou.name, oc.name,
           decode(c.type#, 1, 'C', 2, 'P', 3, 'U', 4, 'R', 5, 'V', 6, 'O', 7,'C', '?'),
           o.name, c.condition, ru.name, rc.name,
           decode(c.type#, 4, decode(c.refact, 1, 'CASCADE', 2, 'SET NULL', 'NO ACTION'), NULL),
           decode(c.type#, 5, 'ENABLED', decode(c.enabled, NULL, 'DISABLED', 'ENABLED')),
           decode(bitand(c.defer, 1), 1, 'DEFERRABLE', 'NOT DEFERRABLE'),
           decode(bitand(c.defer, 2), 2, 'DEFERRED', 'IMMEDIATE'),
           decode(bitand(c.defer, 4), 4, 'VALIDATED', 'NOT VALIDATED'),
           decode(bitand(c.defer, 8), 8, 'GENERATED NAME', 'USER NAME'),
           decode(bitand(c.defer,16),16, 'BAD', null),
           decode(bitand(c.defer,32),32, 'RELY', null),
           c.mtime,
           decode(c.type#, 2, ui.name, 3, ui.name, null),
           decode(c.type#, 2, oi.name, 3, oi.name, null),
           decode(bitand(c.defer, 256), 256,
                  decode(c.type#, 4,
                         case when (bitand(c.defer, 128) = 128
                                    or o.status in (3, 5)
                                    or ro.status in (3, 5)) then 'INVALID'
                              else null end,
                         case when (bitand(c.defer, 128) = 128
                                    or o.status in (3, 5)) then 'INVALID'
                              else null end
                        ),
                  null),
           decode(bitand(c.defer, 256), 256, 'DEPEND ON VIEW', null)
      from con$ oc, con$ rc, user$ ou, user$ ru, obj$ ro,
           obj$ o, cdef$ c, obj$ oi, user$ ui
     where oc.owner# = ou.user#
       and oc.con# = c.con#
       and c.obj# = o.obj#
       and c.type# != 8        /* don't include hash expressions */
       and c.type# != 12       /* don't include log groups */
       and c.rcon# = rc.con#(+)
       and c.enabled = oi.obj#(+)
       and oi.owner# = ui.user#(+)
       and rc.owner# = ru.user#(+)
       and c.robj# = ro.obj#(+)
    /

    -- More Views
    -- DBA_PART_KEY_COLUMNS
    -- DBA_SUBPART_KEY_COLUMNS
    -- DBA_TAB_PARTITIONS
    -- DBA_IND_PARTITIONS
    -- DBA_LOBS
    -- TABPARTV$
    -- INDPARTV$
    -- TABCOMPARTV$
    CREATE OR REPLACE FORCE VIEW "TABPARTV$" ("OBJ#", "DATAOBJ#", "BO#", "PART#", "HIBOUNDLEN", "HIBOUNDVAL", "TS#",
      "FILE#", "BLOCK#", "PCTFREE$", "PCTUSED$", "INITRANS", "MAXTRANS", "FLAGS", "ANALYZETIME", "SAMPLESIZE", "ROWCNT",
      "BLKCNT", "EMPCNT", "AVGSPC", "CHNCNT", "AVGRLN", "PHYPART#") AS
    select obj#, dataobj#, bo#,
              row_number() over (partition by bo# order by part#),
              hiboundlen, hiboundval, ts#, file#, block#, pctfree$, pctused$,
              initrans, maxtrans, flags, analyzetime, samplesize, rowcnt, blkcnt,
              empcnt, avgspc, chncnt, avgrln, part#
    from tabpart$
    /

    CREATE OR REPLACE FORCE VIEW "INDPARTV$" ("OBJ#", "DATAOBJ#", "BO#", "PART#", "HIBOUNDLEN", "HIBOUNDVAL", "FLAGS",
      "TS#", "FILE#", "BLOCK#", "PCTFREE$", "PCTTHRES$", "INITRANS", "MAXTRANS", "ANALYZETIME", "SAMPLESIZE", "ROWCNT",
      "BLEVEL", "LEAFCNT", "DISTKEY", "LBLKKEY", "DBLKKEY", "CLUFAC", "SPARE1", "SPARE2", "SPARE3", "INCLCOL", "PHYPART#")
    AS
    select obj#, dataobj#, bo#,
              row_number() over (partition by bo# order by part#),
              hiboundlen, hiboundval, flags, ts#, file#, block#,
              pctfree$, pctthres$, initrans, maxtrans, analyzetime, samplesize,
              rowcnt, blevel, leafcnt, distkey, lblkkey, dblkkey, clufac, spare1,
              spare2, spare3, inclcol, part#
    from indpart$
    /

    CREATE OR REPLACE FORCE VIEW "TABCOMPARTV$" ("OBJ#", "DATAOBJ#", "BO#", "PART#", "HIBOUNDLEN", "HIBOUNDVAL", "SUBPARTCNT",
      "FLAGS", "DEFTS#", "DEFPCTFREE", "DEFPCTUSED", "DEFINITRANS", "DEFMAXTRANS", "DEFINIEXTS", "DEFEXTSIZE", "DEFMINEXTS",
      "DEFMAXEXTS", "DEFEXTPCT", "DEFLISTS", "DEFGROUPS", "DEFLOGGING", "DEFBUFPOOL", "ANALYZETIME", "SAMPLESIZE", "ROWCNT",
      "BLKCNT", "EMPCNT", "AVGSPC", "CHNCNT", "AVGRLN", "SPARE1", "SPARE2", "SPARE3", "PHYPART#") AS
    select obj#, dataobj#, bo#,
              row_number() over (partition by bo# order by part#),
              hiboundlen, hiboundval, subpartcnt, flags, defts#, defpctfree,
              defpctused, definitrans, defmaxtrans, definiexts,
              defextsize, defminexts, defmaxexts, defextpct, deflists, defgroups,
              deflogging, defbufpool, analyzetime, samplesize, rowcnt, blkcnt,
              empcnt, avgspc, chncnt, avgrln, spare1, spare2, spare3, part#
    from tabcompart$
    /

    CREATE OR REPLACE FORCE VIEW "INDCOMPARTV$" ("OBJ#", "DATAOBJ#", "BO#", "PART#", "HIBOUNDLEN", "HIBOUNDVAL",
      "SUBPARTCNT", "FLAGS", "DEFTS#", "DEFPCTFREE", "DEFINITRANS", "DEFMAXTRANS", "DEFINIEXTS", "DEFEXTSIZE",
      "DEFMINEXTS", "DEFMAXEXTS", "DEFEXTPCT", "DEFLISTS", "DEFGROUPS", "DEFLOGGING", "DEFBUFPOOL", "ANALYZETIME",
      "SAMPLESIZE", "ROWCNT", "BLEVEL", "LEAFCNT", "DISTKEY", "LBLKKEY", "DBLKKEY", "CLUFAC", "SPARE1", "SPARE2",
      "SPARE3", "PHYPART#") AS
    select obj#, dataobj#, bo#,
              row_number() over (partition by bo# order by part#),
              hiboundlen, hiboundval, subpartcnt, flags, defts#,
              defpctfree, definitrans, defmaxtrans, definiexts, defextsize,
              defminexts, defmaxexts, defextpct, deflists, defgroups, deflogging,
              defbufpool, analyzetime, samplesize, rowcnt, blevel, leafcnt,
              distkey, lblkkey, dblkkey, clufac, spare1, spare2, spare3, part#
    from indcompart$
    /

    CREATE OR REPLACE FORCE VIEW "DBA_PART_KEY_COLUMNS" ("OWNER", "NAME", "OBJECT_TYPE", "COLUMN_NAME", "COLUMN_POSITION")
    AS
      select u.name, o.name, 'TABLE',
      decode(bitand(c.property, 1), 1, a.name, c.name), pc.pos#
    from partcol$ pc, obj$ o, col$ c, user$ u, attrcol$ a
    where pc.obj# = o.obj# and pc.obj# = c.obj# and c.intcol# = pc.intcol# and
          u.user# = o.owner# and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+)
          and o.namespace = 1 and o.remoteowner IS NULL and o.linkname IS NULL
          and o.subname IS NULL
    union all
    select u.name, io.name, 'INDEX',
      decode(bitand(c.property, 1), 1, a.name, c.name), pc.pos#
    from partcol$ pc, obj$ io, col$ c, user$ u, ind$ i, attrcol$ a
    where pc.obj# = i.obj# and i.obj# = io.obj# and i.bo# = c.obj# and
            c.intcol# = pc.intcol# and u.user# = io.owner#
            and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+) and
            io.namespace = 4 and io.remoteowner IS NULL and io.linkname IS NULL
            and io.subname IS NULL
    /

    CREATE OR REPLACE FORCE VIEW "DBA_SUBPART_KEY_COLUMNS" ("OWNER", "NAME", "OBJECT_TYPE", "COLUMN_NAME", "COLUMN_POSITION")
    AS
      select u.name, o.name, 'TABLE',
      decode(bitand(c.property, 1), 1, a.name, c.name), spc.pos#
    from   obj$ o, subpartcol$ spc, col$ c, user$ u, attrcol$ a
    where  spc.obj# = o.obj# and spc.obj# = c.obj#
           and c.intcol# = spc.intcol#
           and u.user# = o.owner#
           and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+)
           and o.subname IS NULL
           and o.namespace = 1 and o.remoteowner IS NULL and o.linkname IS NULL
    union all
    select u.name, o.name, 'INDEX',
      decode(bitand(c.property, 1), 1, a.name, c.name), spc.pos#
    from   obj$ o, subpartcol$ spc, col$ c, user$ u, ind$ i, attrcol$ a
    where  spc.obj# = i.obj# and i.obj# = o.obj# and i.bo# = c.obj#
           and c.intcol# = spc.intcol#
           and u.user# = o.owner#
           and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+)
           and o.subname IS NULL
           and o.namespace = 4 and o.remoteowner IS NULL and o.linkname IS NULL
    /

    CREATE OR REPLACE FORCE VIEW "DBA_TAB_PARTITIONS" ("TABLE_OWNER", "TABLE_NAME", "COMPOSITE", "PARTITION_NAME",
      "SUBPARTITION_COUNT", "HIGH_VALUE", "HIGH_VALUE_LENGTH", "PARTITION_POSITION", "TABLESPACE_NAME", "PCT_FREE",
      "PCT_USED", "INI_TRANS", "MAX_TRANS", "INITIAL_EXTENT", "NEXT_EXTENT", "MIN_EXTENT", "MAX_EXTENT", "PCT_INCREASE",
      "FREELISTS", "FREELIST_GROUPS", "LOGGING", "COMPRESSION", "NUM_ROWS", "BLOCKS", "EMPTY_BLOCKS", "AVG_SPACE",
      "CHAIN_CNT", "AVG_ROW_LEN", "SAMPLE_SIZE", "LAST_ANALYZED", "BUFFER_POOL", "GLOBAL_STATS", "USER_STATS") AS
      select u.name, o.name, 'NO', o.subname, 0,
           tp.hiboundval, tp.hiboundlen, tp.part#, ts.name,
           tp.pctfree$,
           decode(bitand(ts.flags, 32), 32, to_number(NULL), tp.pctused$),
           tp.initrans, tp.maxtrans, s.iniexts * ts.blocksize,
           s.extsize * ts.blocksize,
           s.minexts, s.maxexts,
           decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                          s.extpct),
           decode(bitand(ts.flags, 32), 32, to_number(NULL),
              decode(s.lists, 0, 1, s.lists)),
           decode(bitand(ts.flags, 32), 32, to_number(NULL),
              decode(s.groups, 0, 1, s.groups)),
           decode(mod(trunc(tp.flags / 4), 2), 0, 'YES', 'NO'),
           decode(bitand(s.spare1, 2048), 2048, 'ENABLED', 'DISABLED'),
           tp.rowcnt, tp.blkcnt, tp.empcnt, tp.avgspc, tp.chncnt, tp.avgrln,
           tp.samplesize, tp.analyzetime,
           decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
           decode(bitand(tp.flags, 16), 0, 'NO', 'YES'),
           decode(bitand(tp.flags, 8), 0, 'NO', 'YES')
    from   obj$ o, tabpartv$ tp, ts$ ts, seg$ s, user$ u, tab$ t
    where  o.obj# = tp.obj# and ts.ts# = tp.ts# and u.user# = o.owner# and
           tp.file#=s.file# and tp.block#=s.block# and tp.ts#=s.ts# and
           tp.bo# = t.obj# and bitand(t.trigflag, 1073741824) != 1073741824
           and o.namespace = 1 and o.remoteowner IS NULL and o.linkname IS NULL
    union all -- IOT PARTITIONS
    select u.name, o.name, 'NO', o.subname, 0,
           tp.hiboundval, tp.hiboundlen, tp.part#, NULL,
           TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),
           TO_NUMBER(NULL),
           TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),
           TO_NUMBER(NULL),TO_NUMBER(NULL),
           NULL,
           'N/A',
           tp.rowcnt, TO_NUMBER(NULL), TO_NUMBER(NULL), 0, tp.chncnt, tp.avgrln,
           tp.samplesize, tp.analyzetime, NULL,
           decode(bitand(tp.flags, 16), 0, 'NO', 'YES'),
           decode(bitand(tp.flags, 8), 0, 'NO', 'YES')
    from   obj$ o, tabpartv$ tp, user$ u, tab$ t
    where  o.obj# = tp.obj# and o.owner# = u.user# and
           tp.file#=0 and tp.block#=0 and tp.bo# = t.obj# and
           bitand(t.trigflag, 1073741824) != 1073741824
           and o.namespace = 1 and o.remoteowner IS NULL and o.linkname IS NULL
    union all -- COMPOSITE PARTITIONS
    select u.name, o.name, 'YES', o.subname, tcp.subpartcnt,
           tcp.hiboundval, tcp.hiboundlen, tcp.part#, ts.name,
           tcp.defpctfree, decode(bitand(ts.flags, 32), 32, to_number(NULL),
           tcp.defpctused),
           tcp.definitrans, tcp.defmaxtrans,
           tcp.definiexts, tcp.defextsize, tcp.defminexts, tcp.defmaxexts,
           tcp.defextpct,
           decode(bitand(ts.flags, 32), 32, to_number(NULL), tcp.deflists),
           decode(bitand(ts.flags, 32), 32, to_number(NULL), tcp.defgroups),
           decode(tcp.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
           decode(mod(tcp.spare2,256), 0, 'NONE', 1, 'ENABLED',  2, 'DISABLED',
                                       'UNKNOWN'),
           tcp.rowcnt, tcp.blkcnt, tcp.empcnt, tcp.avgspc, tcp.chncnt, tcp.avgrln,
           tcp.samplesize, tcp.analyzetime,
           decode(tcp.defbufpool, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
           decode(bitand(tcp.flags, 16), 0, 'NO', 'YES'),
           decode(bitand(tcp.flags, 8), 0, 'NO', 'YES')
    from   obj$ o, tabcompartv$ tcp, ts$ ts, user$ u, tab$ t
    where  o.obj# = tcp.obj# and tcp.defts# = ts.ts# and u.user# = o.owner# and
           tcp.bo# = t.obj#
           and bitand(t.trigflag, 1073741824) != 1073741824
           and o.namespace = 1 and o.remoteowner IS NULL and o.linkname IS NULL
    /

    CREATE OR REPLACE FORCE VIEW "DBA_IND_PARTITIONS" ("INDEX_OWNER", "INDEX_NAME", "COMPOSITE", "PARTITION_NAME",
      "SUBPARTITION_COUNT", "HIGH_VALUE", "HIGH_VALUE_LENGTH", "PARTITION_POSITION", "STATUS", "TABLESPACE_NAME",
      "PCT_FREE", "INI_TRANS", "MAX_TRANS", "INITIAL_EXTENT", "NEXT_EXTENT", "MIN_EXTENT", "MAX_EXTENT", "PCT_INCREASE",
      "FREELISTS", "FREELIST_GROUPS", "LOGGING", "COMPRESSION", "BLEVEL", "LEAF_BLOCKS", "DISTINCT_KEYS",
      "AVG_LEAF_BLOCKS_PER_KEY", "AVG_DATA_BLOCKS_PER_KEY", "CLUSTERING_FACTOR", "NUM_ROWS", "SAMPLE_SIZE", "LAST_ANALYZED",
      "BUFFER_POOL", "USER_STATS", "PCT_DIRECT_ACCESS", "GLOBAL_STATS", "DOMIDX_OPSTATUS", "PARAMETERS") AS
      select u.name, io.name, 'NO', io.subname, 0,
           ip.hiboundval, ip.hiboundlen, ip.part#,
           decode(bitand(ip.flags, 1), 1, 'UNUSABLE', 'USABLE'), ts.name,
           ip.pctfree$,ip.initrans, ip.maxtrans, s.iniexts * ts.blocksize,
           s.extsize * ts.blocksize,
           s.minexts, s.maxexts,
           decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                          s.extpct),
           decode(bitand(ts.flags, 32), 32, to_number(NULL),
             decode(s.lists, 0, 1, s.lists)),
           decode(bitand(ts.flags, 32), 32, to_number(NULL),
             decode(s.groups, 0, 1, s.groups)),
           decode(mod(trunc(ip.flags / 4), 2), 0, 'YES', 'NO'),
           decode(bitand(ip.flags, 1024), 0, 'DISABLED', 1024, 'ENABLED', null),
           ip.blevel, ip.leafcnt, ip.distkey, ip.lblkkey, ip.dblkkey,
           ip.clufac, ip.rowcnt, ip.samplesize, ip.analyzetime,
           decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
           decode(bitand(ip.flags, 8), 0, 'NO', 'YES'), ip.pctthres$,
           decode(bitand(ip.flags, 16), 0, 'NO', 'YES'),'',''
    from   obj$ io, indpartv$ ip, ts$ ts, seg$ s, user$ u, ind$ i, tab$ t
    where  io.obj# = ip.obj# and ts.ts# = ip.ts# and ip.file#=s.file# and
           ip.block#=s.block# and ip.ts#=s.ts# and io.owner# = u.user# and
           i.obj# = ip.bo# and i.bo# = t.obj# and
           bitand(t.trigflag, 1073741824) != 1073741824
           and io.namespace = 4 and io.remoteowner IS NULL and io.linkname IS NULL
          union all
    select u.name, io.name, 'YES', io.subname, icp.subpartcnt,
           icp.hiboundval, icp.hiboundlen, icp.part#, 'N/A', ts.name,
           icp.defpctfree, icp.definitrans, icp.defmaxtrans,
           icp.definiexts, icp.defextsize, icp.defminexts, icp.defmaxexts,
           icp.defextpct, icp.deflists, icp.defgroups,
           decode(icp.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
           decode(bitand(icp.flags, 1024), 0, 'DISABLED', 1024, 'ENABLED', null),
           icp.blevel, icp.leafcnt, icp.distkey, icp.lblkkey, icp.dblkkey,
           icp.clufac, icp.rowcnt, icp.samplesize, icp.analyzetime,
           decode(icp.defbufpool, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
           decode(bitand(icp.flags, 8), 0, 'NO', 'YES'), TO_NUMBER(NULL),
           decode(bitand(icp.flags, 16), 0, 'NO', 'YES'),'',''
    from   obj$ io, indcompartv$ icp, ts$ ts, user$ u, ind$ i, tab$ t
    where  io.obj# = icp.obj# and icp.defts# = ts.ts# (+) and
           u.user# = io.owner# and i.obj# = icp.bo# and i.bo# = t.obj# and
           bitand(t.trigflag, 1073741824) != 1073741824
           and io.namespace = 4 and io.remoteowner IS NULL and io.linkname IS NULL
          union all
    select u.name, io.name, 'NO', io.subname, 0,
           ip.hiboundval, ip.hiboundlen, ip.part#,
           decode(bitand(ip.flags, 1), 1, 'UNUSABLE',
                    decode(bitand(ip.flags, 4096), 4096, 'INPROGRS', 'USABLE')),
           null, ip.pctfree$, ip.initrans, ip.maxtrans,
           0, 0, 0, 0, 0, 0, 0,
           decode(mod(trunc(ip.flags / 4), 2), 0, 'YES', 'NO'),
           decode(bitand(ip.flags, 1024), 0, 'DISABLED', 1024, 'ENABLED', null),
           ip.blevel, ip.leafcnt, ip.distkey, ip.lblkkey, ip.dblkkey,
           ip.clufac, ip.rowcnt, ip.samplesize, ip.analyzetime,
           'DEFAULT',
           decode(bitand(ip.flags, 8), 0, 'NO', 'YES'), ip.pctthres$,
           decode(bitand(ip.flags, 16), 0, 'NO', 'YES'),
           decode(i.type#,
                 9, decode(bitand(ip.flags, 8192), 8192, 'FAILED', 'VALID'),
                 ''),
           ipp.parameters
    from   obj$ io, indpartv$ ip,  user$ u, ind$ i, indpart_param$ ipp, tab$ t
    where  io.obj# = ip.obj# and io.owner# = u.user# and
           ip.bo# = i.obj# and ip.obj# = ipp.obj# and i.bo# = t.obj# and
           bitand(t.trigflag, 1073741824) != 1073741824
           and io.namespace = 4 and io.remoteowner IS NULL and io.linkname IS NULL
    /

    CREATE OR REPLACE FORCE VIEW "DBA_LOBS" ("OWNER", "TABLE_NAME", "COLUMN_NAME", "SEGMENT_NAME", "TABLESPACE_NAME",
      "INDEX_NAME", "CHUNK", "PCTVERSION", "RETENTION", "FREEPOOLS", "CACHE", "LOGGING", "IN_ROW", "FORMAT", "PARTITIONED")
    AS
      select u.name, o.name,
           decode(bitand(c.property, 1), 1, ac.name, c.name), lo.name,
           decode(bitand(l.property, 8), 8, ts1.name, ts.name),
           io.name,
           l.chunk * decode(bitand(l.property, 8), 8, ts1.blocksize,
                            ts.blocksize),
           decode(bitand(l.flags, 32), 0, l.pctversion$, to_number(NULL)),
           decode(bitand(l.flags, 32), 32, l.retention, to_number(NULL)),
           decode(l.freepools, 0, to_number(NULL), 65534, to_number(NULL),
                  65535, to_number(NULL), l.freepools),
           decode(bitand(l.flags, 27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                       16, 'CACHEREADS', 'YES'),
           decode(bitand(l.flags, 18), 2, 'NO', 16, 'NO', 'YES'),
           decode(bitand(l.property, 2), 2, 'YES', 'NO'),
           decode(c.type#, 113, 'NOT APPLICABLE ',
                  decode(bitand(l.property, 512), 512,
                         'ENDIAN SPECIFIC', 'ENDIAN NEUTRAL ')),
           decode(bitand(ta.property, 32), 32, 'YES', 'NO')
    from obj$ o, col$ c, attrcol$ ac, tab$ ta, lob$ l,
         obj$ lo, obj$ io, user$ u, ts$ ts, ts$ ts1
    where o.owner# = u.user#
      and o.obj# = c.obj#
      and c.obj# = l.obj#
      and c.intcol# = l.intcol#
      and l.lobj# = lo.obj#
      and l.ind# = io.obj#
      and l.ts# = ts.ts#(+)
      and u.tempts# = ts1.ts#
      and c.obj# = ac.obj#(+)
      and c.intcol# = ac.intcol#(+)
      and bitand(c.property,32768) != 32768           /* not unused column */
      and o.obj# = ta.obj#
      and bitand(ta.property, 32) != 32           /* not partitioned table */
    union all
    select u.name, o.name,
           decode(bitand(c.property, 1), 1, ac.name, c.name),
           lo.name,
           NVL(ts1.name,
            (select ts2.name
            from    ts$ ts2, partobj$ po
            where   o.obj# = po.obj# and po.defts# = ts2.ts#)),
           io.name,
           plob.defchunk * NVL(ts1.blocksize, NVL((
            select ts2.blocksize
            from   ts$ ts2, lobfrag$ lf
            where  l.lobj# = lf.parentobj# and
                   lf.ts# = ts2.ts# and rownum < 2),
            (select ts2.blocksize
            from   ts$ ts2, lobcomppart$ lcp, lobfrag$ lf
            where  l.lobj# = lcp.lobj# and lcp.partobj# = lf.parentobj# and
                   lf.ts# = ts2.ts# and rownum < 2))),
           decode(plob.defpctver$, 101, to_number(NULL), 102, to_number(NULL),
                                               plob.defpctver$),
           decode(l.retention, -1, to_number(NULL), l.retention),
           decode(l.freepools, 0, to_number(NULL), 65534, to_number(NULL),
                  65535, to_number(NULL), l.freepools),
           decode(bitand(plob.defflags, 27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                             16, 'CACHEREADS', 'YES'),
           decode(bitand(plob.defflags,22), 0,'NONE', 4,'YES', 2,'NO',
                                            16,'NO', 'UNKNOWN'),
           decode(bitand(plob.defpro, 2), 2, 'YES', 'NO'),
           decode(c.type#, 113, 'NOT APPLICABLE ',
                  decode(bitand(l.property, 512), 512,
                         'ENDIAN SPECIFIC', 'ENDIAN NEUTRAL ')),
           decode(bitand(ta.property, 32), 32, 'YES', 'NO')
    from obj$ o, col$ c, attrcol$ ac, partlob$ plob,
         lob$ l, obj$ lo, obj$ io, ts$ ts1, tab$ ta,
         user$ u
    where o.owner# = u.user#
      and o.obj# = c.obj#
      and c.obj# = l.obj#
      and c.intcol# = l.intcol#
      and l.lobj# = lo.obj#
      and l.ind# = io.obj#
      and l.lobj# = plob.lobj#
      and plob.defts# = ts1.ts# (+)
      and c.obj# = ac.obj#(+)
      and c.intcol# = ac.intcol#(+)
      and bitand(c.property,32768) != 32768    /* not unused column */
      and o.obj# = ta.obj#
      and bitand(ta.property, 32) = 32         /* partitioned table */
    /
EOFSCRIPTS

  echo 'EOF' >> ${METAIMPSCRIPT}
  cat >>${METAIMPSCRIPT} <<"EOFSCRIPTS"

     execute_sql
     print_log "[create_view]" "" "Successfully Create Dict View in Stage User"
 }


 #########################################################################################################
 ##                                                                                                     ##
 ## Funtion move_to_repo(): Move Stage Data into Repository                                             ##
 ##                                                                                                     ##
 #########################################################################################################
 move_to_repo(){

     print_log "[move_to_repo]" "" "Begin Move Stage Data into Repository"
     # Initial SQL Scripts
     cat > ${__SQLPLUSSCRIPT} <<EOF
    COL CDATE NEW_VALUE CDATE
    SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') CDATE FROM DUAL;

    INSERT INTO ENMO_CONSTRAINTS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,OWNER
    ,CONSTRAINT_NAME
    ,CONSTRAINT_TYPE
    ,TABLE_NAME
    ,TO_LOB(SEARCH_CONDITION)
    ,R_OWNER
    ,R_CONSTRAINT_NAME
    ,DELETE_RULE
    ,STATUS
    ,DEFERRABLE
    ,DEFERRED
    ,VALIDATED
    ,GENERATED
    ,BAD
    ,RELY
    ,LAST_CHANGE
    ,INDEX_OWNER
    ,INDEX_NAME
    ,INVALID
    ,VIEW_RELATED
    FROM ${__METASTAGEUSER}.DBA_CONSTRAINTS;
    COMMIT;

    INSERT INTO ENMO_ROLES SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,ROLE
    ,PASSWORD_REQUIRED
    FROM ${__METASTAGEUSER}.DBA_ROLES;
    COMMIT;

    INSERT INTO ENMO_COL_PRIVS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,GRANTEE
    ,OWNER
    ,TABLE_NAME
    ,COLUMN_NAME
    ,GRANTOR
    ,PRIVILEGE
    ,GRANTABLE
    FROM ${__METASTAGEUSER}.DBA_COL_PRIVS;
    COMMIT;

    INSERT INTO ENMO_PART_INDEXES SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,OWNER
    ,INDEX_NAME
    ,TABLE_NAME
    ,PARTITIONING_TYPE
    ,SUBPARTITIONING_TYPE
    ,PARTITION_COUNT
    ,DEF_SUBPARTITION_COUNT
    ,PARTITIONING_KEY_COUNT
    ,SUBPARTITIONING_KEY_COUNT
    ,LOCALITY
    ,ALIGNMENT
    ,DEF_TABLESPACE_NAME
    ,DEF_PCT_FREE
    ,DEF_INI_TRANS
    ,DEF_MAX_TRANS
    ,DEF_INITIAL_EXTENT
    ,DEF_NEXT_EXTENT
    ,DEF_MIN_EXTENTS
    ,DEF_MAX_EXTENTS
    ,DEF_PCT_INCREASE
    ,DEF_FREELISTS
    ,DEF_FREELIST_GROUPS
    ,DEF_LOGGING
    ,DEF_BUFFER_POOL
    ,DEF_PARAMETERS
    FROM ${__METASTAGEUSER}.DBA_PART_INDEXES;
    COMMIT;

    INSERT INTO ENMO_PART_TABLES SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,OWNER
    ,TABLE_NAME
    ,PARTITIONING_TYPE
    ,SUBPARTITIONING_TYPE
    ,PARTITION_COUNT
    ,DEF_SUBPARTITION_COUNT
    ,PARTITIONING_KEY_COUNT
    ,SUBPARTITIONING_KEY_COUNT
    ,STATUS
    ,DEF_TABLESPACE_NAME
    ,DEF_PCT_FREE
    ,DEF_PCT_USED
    ,DEF_INI_TRANS
    ,DEF_MAX_TRANS
    ,DEF_INITIAL_EXTENT
    ,DEF_NEXT_EXTENT
    ,DEF_MIN_EXTENTS
    ,DEF_MAX_EXTENTS
    ,DEF_PCT_INCREASE
    ,DEF_FREELISTS
    ,DEF_FREELIST_GROUPS
    ,DEF_LOGGING
    ,DEF_COMPRESSION
    ,DEF_BUFFER_POOL
    FROM ${__METASTAGEUSER}.DBA_PART_TABLES;
    COMMIT;

    INSERT INTO ENMO_SEGMENTS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,OWNER
    ,SEGMENT_NAME
    ,PARTITION_NAME
    ,SEGMENT_TYPE
    ,TABLESPACE_NAME
    ,HEADER_FILE
    ,HEADER_BLOCK
    ,BYTES
    ,BLOCKS
    ,EXTENTS
    ,INITIAL_EXTENT
    ,NEXT_EXTENT
    ,MIN_EXTENTS
    ,MAX_EXTENTS
    ,PCT_INCREASE
    ,FREELISTS
    ,FREELIST_GROUPS
    ,RELATIVE_FNO
    ,BUFFER_POOL
    FROM ${__METASTAGEUSER}.DBA_SEGMENTS;
    COMMIT;

    INSERT INTO ENMO_TABLESPACES SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,TABLESPACE_NAME
    ,BLOCK_SIZE
    ,INITIAL_EXTENT
    ,NEXT_EXTENT
    ,MIN_EXTENTS
    ,MAX_EXTENTS
    ,PCT_INCREASE
    ,MIN_EXTLEN
    ,STATUS
    ,CONTENTS
    ,LOGGING
    ,FORCE_LOGGING
    ,EXTENT_MANAGEMENT
    ,ALLOCATION_TYPE
    ,PLUGGED_IN
    ,SEGMENT_SPACE_MANAGEMENT
    ,DEF_TAB_COMPRESSION
    ,RETENTION
    ,BIGFILE
    FROM ${__METASTAGEUSER}.DBA_TABLESPACES;
    COMMIT;

    INSERT INTO ENMO_TAB_COLUMNS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,OWNER
    ,TABLE_NAME
    ,COLUMN_NAME
    ,DATA_TYPE
    ,DATA_TYPE_MOD
    ,DATA_TYPE_OWNER
    ,DATA_LENGTH
    ,DATA_PRECISION
    ,DATA_SCALE
    ,NULLABLE
    ,COLUMN_ID
    ,DEFAULT_LENGTH
    ,TO_LOB(DATA_DEFAULT)
    ,NUM_DISTINCT
    ,LOW_VALUE
    ,HIGH_VALUE
    ,DENSITY
    ,NUM_NULLS
    ,NUM_BUCKETS
    ,LAST_ANALYZED
    ,SAMPLE_SIZE
    ,CHARACTER_SET_NAME
    ,CHAR_COL_DECL_LENGTH
    ,GLOBAL_STATS
    ,USER_STATS
    ,AVG_COL_LEN
    ,CHAR_LENGTH
    ,CHAR_USED
    ,V80_FMT_IMAGE
    ,DATA_UPGRADED
    ,HISTOGRAM
    FROM ${__METASTAGEUSER}.DBA_TAB_COLUMNS;
    COMMIT;

    INSERT INTO ENMO_ROLE_ROLE_PRIVS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,ROLE
    ,GRANTED_ROLE
    ,ADMIN_OPTION
    FROM ${__METASTAGEUSER}.ROLE_ROLE_PRIVS;
    COMMIT;

    INSERT INTO ENMO_ROLE_SYS_PRIVS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,ROLE
    ,PRIVILEGE
    ,ADMIN_OPTION
    FROM ${__METASTAGEUSER}.ROLE_SYS_PRIVS;
    COMMIT;

    INSERT INTO ENMO_ROLE_TAB_PRIVS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,ROLE
    ,OWNER
    ,TABLE_NAME
    ,COLUMN_NAME
    ,PRIVILEGE
    ,GRANTABLE
    FROM ${__METASTAGEUSER}.ROLE_TAB_PRIVS;
    COMMIT;

    INSERT INTO ENMO_INDEXES SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,OWNER
    ,INDEX_NAME
    ,INDEX_TYPE
    ,TABLE_OWNER
    ,TABLE_NAME
    ,TABLE_TYPE
    ,UNIQUENESS
    ,COMPRESSION
    ,PREFIX_LENGTH
    ,TABLESPACE_NAME
    ,INI_TRANS
    ,MAX_TRANS
    ,INITIAL_EXTENT
    ,NEXT_EXTENT
    ,MIN_EXTENTS
    ,MAX_EXTENTS
    ,PCT_INCREASE
    ,PCT_THRESHOLD
    ,INCLUDE_COLUMN
    ,FREELISTS
    ,FREELIST_GROUPS
    ,PCT_FREE
    ,LOGGING
    ,BLEVEL
    ,LEAF_BLOCKS
    ,DISTINCT_KEYS
    ,AVG_LEAF_BLOCKS_PER_KEY
    ,AVG_DATA_BLOCKS_PER_KEY
    ,CLUSTERING_FACTOR
    ,STATUS
    ,NUM_ROWS
    ,SAMPLE_SIZE
    ,LAST_ANALYZED
    ,DEGREE
    ,INSTANCES
    ,PARTITIONED
    ,TEMPORARY
    ,GENERATED
    ,SECONDARY
    ,BUFFER_POOL
    ,USER_STATS
    ,DURATION
    ,PCT_DIRECT_ACCESS
    ,ITYP_OWNER
    ,ITYP_NAME
    ,PARAMETERS
    ,GLOBAL_STATS
    ,DOMIDX_STATUS
    ,DOMIDX_OPSTATUS
    ,FUNCIDX_STATUS
    ,JOIN_INDEX
    ,IOT_REDUNDANT_PKEY_ELIM
    ,DROPPED
    FROM ${__METASTAGEUSER}.DBA_INDEXES;
    COMMIT;

    INSERT INTO ENMO_IND_COLUMNS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,INDEX_OWNER
    ,INDEX_NAME
    ,TABLE_OWNER
    ,TABLE_NAME
    ,COLUMN_NAME
    ,COLUMN_POSITION
    ,COLUMN_LENGTH
    ,CHAR_LENGTH
    ,DESCEND
    FROM ${__METASTAGEUSER}.DBA_IND_COLUMNS;
    COMMIT;

    INSERT INTO ENMO_OBJECTS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,OWNER
    ,OBJECT_NAME
    ,SUBOBJECT_NAME
    ,OBJECT_ID
    ,DATA_OBJECT_ID
    ,OBJECT_TYPE
    ,CREATED
    ,LAST_DDL_TIME
    ,TIMESTAMP
    ,STATUS
    ,TEMPORARY
    ,GENERATED
    ,SECONDARY
    FROM ${__METASTAGEUSER}.DBA_OBJECTS;
    COMMIT;

    INSERT INTO ENMO_ROLE_PRIVS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,GRANTEE
    ,GRANTED_ROLE
    ,ADMIN_OPTION
    ,DEFAULT_ROLE
    FROM ${__METASTAGEUSER}.DBA_ROLE_PRIVS;
    COMMIT;

    INSERT INTO ENMO_SEQUENCES SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,SEQUENCE_OWNER
    ,SEQUENCE_NAME
    ,MIN_VALUE
    ,MAX_VALUE
    ,INCREMENT_BY
    ,CYCLE_FLAG
    ,ORDER_FLAG
    ,CACHE_SIZE
    ,LAST_NUMBER
    FROM ${__METASTAGEUSER}.DBA_SEQUENCES;
    COMMIT;

    INSERT INTO ENMO_SYS_PRIVS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,GRANTEE
    ,PRIVILEGE
    ,ADMIN_OPTION
    FROM ${__METASTAGEUSER}.DBA_SYS_PRIVS;
    COMMIT;

    INSERT INTO ENMO_TABLES SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,OWNER
    ,TABLE_NAME
    ,TABLESPACE_NAME
    ,CLUSTER_NAME
    ,IOT_NAME
    ,STATUS
    ,PCT_FREE
    ,PCT_USED
    ,INI_TRANS
    ,MAX_TRANS
    ,INITIAL_EXTENT
    ,NEXT_EXTENT
    ,MIN_EXTENTS
    ,MAX_EXTENTS
    ,PCT_INCREASE
    ,FREELISTS
    ,FREELIST_GROUPS
    ,LOGGING
    ,BACKED_UP
    ,NUM_ROWS
    ,BLOCKS
    ,EMPTY_BLOCKS
    ,AVG_SPACE
    ,CHAIN_CNT
    ,AVG_ROW_LEN
    ,AVG_SPACE_FREELIST_BLOCKS
    ,NUM_FREELIST_BLOCKS
    ,DEGREE
    ,INSTANCES
    ,CACHE
    ,TABLE_LOCK
    ,SAMPLE_SIZE
    ,LAST_ANALYZED
    ,PARTITIONED
    ,IOT_TYPE
    ,TEMPORARY
    ,SECONDARY
    ,NESTED
    ,BUFFER_POOL
    ,ROW_MOVEMENT
    ,GLOBAL_STATS
    ,USER_STATS
    ,DURATION
    ,SKIP_CORRUPT
    ,MONITORING
    ,CLUSTER_OWNER
    ,DEPENDENCIES
    ,COMPRESSION
    ,DROPPED
    FROM ${__METASTAGEUSER}.DBA_TABLES;
    COMMIT;

    INSERT INTO ENMO_TAB_PRIVS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,GRANTEE
    ,OWNER
    ,TABLE_NAME
    ,GRANTOR
    ,PRIVILEGE
    ,GRANTABLE
    ,HIERARCHY
    FROM ${__METASTAGEUSER}.DBA_TAB_PRIVS;
    COMMIT;

    INSERT INTO ENMO_USERS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,USERNAME
    ,USER_ID
    ,PASSWORD
    ,ACCOUNT_STATUS
    ,LOCK_DATE
    ,EXPIRY_DATE
    ,DEFAULT_TABLESPACE
    ,TEMPORARY_TABLESPACE
    ,CREATED
    ,EXTERNAL_NAME
    FROM ${__METASTAGEUSER}.DBA_USERS;
    COMMIT;

    INSERT INTO ENMO_PART_KEY_COLUMNS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,OWNER
    ,NAME
    ,OBJECT_TYPE
    ,COLUMN_NAME
    ,COLUMN_POSITION
    FROM ${__METASTAGEUSER}.DBA_PART_KEY_COLUMNS;
    COMMIT;

    INSERT INTO ENMO_SUBPART_KEY_COLUMNS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,OWNER
    ,NAME
    ,OBJECT_TYPE
    ,COLUMN_NAME
    ,COLUMN_POSITION
    FROM ${__METASTAGEUSER}.DBA_SUBPART_KEY_COLUMNS;
    COMMIT;

    INSERT INTO ENMO_TAB_PARTITIONS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,TABLE_OWNER
    ,TABLE_NAME
    ,COMPOSITE
    ,PARTITION_NAME
    ,SUBPARTITION_COUNT
    ,TO_LOB(HIGH_VALUE)
    ,HIGH_VALUE_LENGTH
    ,PARTITION_POSITION
    ,TABLESPACE_NAME
    ,PCT_FREE
    ,PCT_USED
    ,INI_TRANS
    ,MAX_TRANS
    ,INITIAL_EXTENT
    ,NEXT_EXTENT
    ,MIN_EXTENT
    ,MAX_EXTENT
    ,PCT_INCREASE
    ,FREELISTS
    ,FREELIST_GROUPS
    ,LOGGING
    ,COMPRESSION
    ,NUM_ROWS
    ,BLOCKS
    ,EMPTY_BLOCKS
    ,AVG_SPACE
    ,CHAIN_CNT
    ,AVG_ROW_LEN
    ,SAMPLE_SIZE
    ,LAST_ANALYZED
    ,BUFFER_POOL
    ,GLOBAL_STATS
    ,USER_STATS
    FROM ${__METASTAGEUSER}.DBA_TAB_PARTITIONS;
    COMMIT;

    INSERT INTO ENMO_IND_PARTITIONS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,INDEX_OWNER
    ,INDEX_NAME
    ,COMPOSITE
    ,PARTITION_NAME
    ,SUBPARTITION_COUNT
    ,TO_LOB(HIGH_VALUE)
    ,HIGH_VALUE_LENGTH
    ,PARTITION_POSITION
    ,STATUS
    ,TABLESPACE_NAME
    ,PCT_FREE
    ,INI_TRANS
    ,MAX_TRANS
    ,INITIAL_EXTENT
    ,NEXT_EXTENT
    ,MIN_EXTENT
    ,MAX_EXTENT
    ,PCT_INCREASE
    ,FREELISTS
    ,FREELIST_GROUPS
    ,LOGGING
    ,COMPRESSION
    ,BLEVEL
    ,LEAF_BLOCKS
    ,DISTINCT_KEYS
    ,AVG_LEAF_BLOCKS_PER_KEY
    ,AVG_DATA_BLOCKS_PER_KEY
    ,CLUSTERING_FACTOR
    ,NUM_ROWS
    ,SAMPLE_SIZE
    ,LAST_ANALYZED
    ,BUFFER_POOL
    ,USER_STATS
    ,PCT_DIRECT_ACCESS
    ,GLOBAL_STATS
    ,DOMIDX_OPSTATUS
    ,PARAMETERS
    FROM ${__METASTAGEUSER}.DBA_IND_PARTITIONS;
    COMMIT;

    INSERT INTO ENMO_LOBS SELECT ${__DBID}, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS')
    ,OWNER
    ,TABLE_NAME
    ,COLUMN_NAME
    ,SEGMENT_NAME
    ,TABLESPACE_NAME
    ,INDEX_NAME
    ,CHUNK
    ,PCTVERSION
    ,RETENTION
    ,FREEPOOLS
    ,CACHE
    ,LOGGING
    ,IN_ROW
    ,FORMAT
    ,PARTITIONED
    FROM ${__METASTAGEUSER}.DBA_LOBS;
    COMMIT;

    MERGE INTO ENMO_LATEST_INFO L USING (SELECT ${__DBID} dbid, TO_DATE('&CDATE', 'YYYY-MM-DD HH24:MI:SS') cdate FROM DUAL) C
    ON (L.DBID = C.DBID) WHEN MATCHED THEN UPDATE SET L.LATEST_DATE = C.CDATE WHEN NOT MATCHED THEN INSERT VALUES(C.DBID, C.CDATE);
    COMMIT;
EOFSCRIPTS

  echo 'EOF' >> ${METAIMPSCRIPT}
  cat >>${METAIMPSCRIPT} <<"EOFSCRIPTS"

     execute_sql
     print_log "[move_to_repo]" "" "Successfully Move Stage Data into Repository"
 }


 #########################################################################################################
 ##                                                                                                     ##
 ## Main Funtion                                                                                        ##
 ##                                                                                                     ##
 #########################################################################################################

 print_log "[Main]" "" "We are Going to Input Metadata into Enmo Meta Respository ..."
 print_log "[Main]" "" "Metadata DBID to import : [${__DBID}]"


 # ==> [1]. Input Stage User
 print_log "[Main]" "1" "N" "Please input Stage User, default is [ENMO_META_STAGE] : "
 if [ "${__USER_INPUT_CHAR}" = "" ]; then
     __METASTAGEUSER="ENMO_META_STAGE"
 else
     __METASTAGEUSER="${__USER_INPUT_CHAR}"
 fi


 # ==> [2]. Initial Enmo Metadata Repository
 initial_repo


 # ==> [3]. Load Data into Stage User
 print_log "[Main]" "" "Create Stage User and Give Needed Priviledge"
 cat > ${__SQLPLUSSCRIPT} <<EOF
 GRANT DBA TO ${__METASTAGEUSER} IDENTIFIED BY ${__METASTAGEUSER};
 GRANT EXECUTE ON DBMS_SPACE_ADMIN TO ${__METASTAGEUSER};
EOFSCRIPTS

  echo 'EOF' >> ${METAIMPSCRIPT}
  cat >>${METAIMPSCRIPT} <<"EOFSCRIPTS"
 execute_sql

 print_log "[Main]" "" "Import Metadata Into Stage Schema"
 IMPLOG="metadict_imp.${__DBID}.log"
 ${__ORACLE_HOME}/bin/imp \'/ as sysdba\' file=${__METADMP} log=${IMPLOG} fromuser=SYS touser=${__METASTAGEUSER} GRANTS=n CONSTRAINTS=N INDEXES=N 1>/dev/null 2>&1

 # Check Import Errors
 ORA_ERRORS=`cat ${IMPLOG} | grep '^ORA-' | wc -l`
 IMP_ERRORS=`cat ${IMPLOG} | grep '^IMP-' | wc -l`
 if [ ${ORA_ERRORS} -gt 0 ] || [ ${IMP_ERRORS} -gt 0 ]; then
     print_log "[Main]" "" "Metadata Import with [${ORA_ERRORS}] ORA-Errors and [${IMP_ERRORS}] IMP-Errors !"
     print_log "[Main]" "" "Detail Log in : [${IMPLOG}]"
     exit 1
 else
     print_log "[Main]" "" "Metadata Already Loaded into Stage User !"
 fi



 # ==> [4]. Create Dict View in Stage User
 create_view


 # ==> [5]. Move Data from Stage User to Enmo Metadata Repository
 move_to_repo


 # ==> [6]. Drop Stage User
 print_log "[Main]" "" "Drop Stage User with cascade option !"
 cat > ${__SQLPLUSSCRIPT} <<EOF
 drop user ${__METASTAGEUSER} cascade;
EOFSCRIPTS

  echo 'EOF' >> ${METAIMPSCRIPT}
  cat >>${METAIMPSCRIPT} <<"EOFSCRIPTS"
 execute_sql
 print_log "[Main]" "" "Stage User already Dropped !"

 print_log "[Main]" "" "Metadata Successfully Loaded into Enmo Metadata Respository !"
 print_log "[Main]" "" "------------------------[ Summary ]--------------------------"
 print_log "[Main]" "" "Avaliable Metadata Table in SYS is :"
 print_log "[Main]" "" "     1. ENMO_COL_PRIVS"
 print_log "[Main]" "" "     2. ENMO_CONSTRAINTS"
 print_log "[Main]" "" "     3. ENMO_INDEXES"
 print_log "[Main]" "" "     4. ENMO_IND_COLUMNS"
 print_log "[Main]" "" "     5. ENMO_OBJECTS"
 print_log "[Main]" "" "     6. ENMO_PART_INDEXES"
 print_log "[Main]" "" "     7. ENMO_PART_TABLES"
 print_log "[Main]" "" "     8. ENMO_ROLES"
 print_log "[Main]" "" "     9. ENMO_ROLE_SYS_PRIVS"
 print_log "[Main]" "" "    10. ENMO_ROLE_ROLE_PRIVS"
 print_log "[Main]" "" "    11. ENMO_ROLE_TAB_PRIVS"
 print_log "[Main]" "" "    12. ENMO_SEGMENTS"
 print_log "[Main]" "" "    13. ENMO_SEQUENCES"
 print_log "[Main]" "" "    14. ENMO_SYS_PRIVS"
 print_log "[Main]" "" "    15. ENMO_TABLES"
 print_log "[Main]" "" "    16. ENMO_TABLESPACES"
 print_log "[Main]" "" "    17. ENMO_TAB_COLUMNS"
 print_log "[Main]" "" "    18. ENMO_TAB_PRIVS"
 print_log "[Main]" "" "    19. ENMO_USERS"
 print_log "[Main]" "" "    20. ENMO_PART_KEY_COLUMNS"
 print_log "[Main]" "" "    21. ENMO_SUBPART_KEY_COLUMNS"
 print_log "[Main]" "" "    22. ENMO_TAB_PARTITIONS"
 print_log "[Main]" "" "    23. ENMO_IND_PARTITIONS"
 print_log "[Main]" "" "    24. ENMO_LOBS"
 print_log "[Main]" "" "------------------------[ Summary ]--------------------------"
 print_log "[Main]" "" "You can Query Pre-Loaded Metadata with Filter [ DBID=${__DBID} ]"
EOFSCRIPTS

  chmod a+x $METAIMPSCRIPT 2>/dev/null
  print_log "[make_metaScripts]" "" "Metadata Import Script already Created as [${METAIMPSCRIPT}]"
}

#########################################################################################################
##                                                                                                     ##
## Function get_metadata(): Export Metadata                                                            ##
##   Result write into ${__DUMP_DIR} Directory                                                         ##
##                                                                                                     ##
#########################################################################################################
get_metadata(){

  METADUMPFILE=metadict.${__DBID}.dmp
  METADUMPPAR=metadict.${__DBID}.par
  METADUMPLOG=metadict.${__DBID}.log
  print_log "[get_metadata]" "" "Begin Collect Metadata Dump File, Parfile is [${__DUMP_DIR}/${METADUMPPAR}]"
  cat >${__DUMP_DIR}/metadict.${__DBID}.par <<EOFOFMETAPAR
  USERID='/ AS SYSDBA'
  FILE=${__DUMP_DIR}/${METADUMPFILE}
  TABLES=(ATTRCOL\$, CCOL\$, CDEF\$, COL\$, COLTYPE\$, CON\$, DEFROLE\$, FILE\$, HISTGRM\$, HIST_HEAD\$, ICOL\$, IND\$, INDCOMPART\$, INDPART\$, INDPART_PARAM\$, INDSUBPART\$, LINK\$, LOB\$, LOBCOMPPART\$, LOBFRAG\$, MON_MODS_ALL\$, OBJ\$, OBJAUTH\$, PARTCOL\$, PARTLOB\$, PARTOBJ\$, SEG\$, SEQ\$, SOURCE\$, SUBPARTCOL\$, SUM\$, SYSAUTH\$, SYSTEM_PRIVILEGE_MAP, TAB\$, TABCOMPART\$, TABLE_PRIVILEGE_MAP, TABPART\$, TABSUBPART\$, TS\$, UNDO\$, USER\$, USER_ASTATUS_MAP)
  BUFFER=40960000
  DIRECT=Y
  FEEDBACK=10000
  STATISTICS=NONE
EOFOFMETAPAR

  NLSLANG_FILE="${__SCRIPT_DIR}/nls_lang.tmp"
  print_log "[get_metadata]" "5" "${NLSLANG_FILE}"

  # Get current Shell
  if [ "`grep 'csh' ${__SHELL}`" != "" ]; then
    SHELL_SETTING="setenv NLS_LANG "
  else
    SHELL_SETTING="export NLS_LANG="
  fi

  # Setting Current NLS_LANG Environments
  SQL_EXEC="SET LINES 111 PAGES 0 HEADING OFF TRIM ON TRIMS ON FEEDBACK OFF AUTOT OFF
 SPOOL ${NLSLANG_FILE}
 SELECT /*+ RULE */ '${SHELL_SETTING}'
     || DECODE(INSTR(USERENV('LANGUAGE'), ' '), 0, '', '\"')
     || USERENV('LANGUAGE')
     || DECODE(INSTR(USERENV('LANGUAGE'), ' '), 0, '', '\"')
   FROM DUAL;
 SPO OFF
 EXIT"
  print_log "[get_metadata]" "4" "Get NLS Parameter Value for Dump Metadata" "${SQL_EXEC}"
  ${__ORACLE_HOME}/bin/sqlplus -s "${__SQLPLUS_USER}" 1>/dev/null 2>>${__ERRORFILE} <<EOF
  ${SQL_EXEC}
EOF

  if [ -f "${NLSLANG_FILE}" ] && [ "`cat ${NLSLANG_FILE} | grep '^ORA-'`" = "" ]; then
    print_log "[get_metadata]" "3" "Export Metadata File, Log is [${__DUMP_DIR}/${METADUMPLOG}]"
    source ${NLSLANG_FILE}
    ${__ORACLE_HOME}/bin/exp parfile=${__DUMP_DIR}/${METADUMPPAR} 1>${__DUMP_DIR}/${METADUMPLOG} 2>&1
    ORA_ERROR=`cat ${__DUMP_DIR}/${METADUMPLOG} | grep '^ORA-' | wc -l`
    EXP_ERROR=`cat ${__DUMP_DIR}/${METADUMPLOG} | grep '^EXP-' | wc -l`
    if [ ${ORA_ERROR} -eq 0 ] && [ ${EXP_ERROR} -eq 0 ]; then
      print_log "[get_metadata]" "" "Export Metadata Completed Successfully"
    else
      print_log "[get_metadata]" "2" "Export Metadata Completed with [${ORA_ERROR}] ORA Errors and [${EXP_ERROR}] Exp Errors"
    fi
    make_metaScripts ${METADUMPFILE}
  elif [ -f "${NLSLANG_FILE}" ]; then
    print_log "[get_metadata]" "2" "[Error] Cannot get NLS Parameter, Export Process is ignored !"
    print_log "[get_metadata]" "2" "[Cause] `cat ${NLSLANG_FILE} | grep '^ORA-' | sort -u`"
  else
    print_log "[get_metadata]" "2" "[Error] Cannot get NLS Parameter, Export Process is ignored !"
    print_log "[get_metadata]" "2" "[Cause] no NLS Result File created"
  fi
  print_log "[get_metadata]" "" "End Collect Metadata Dump File"
}

#########################################################################################################
##                                                                                                     ##
## Function get_snapshot(): Collect Snapshot Result                                                    ##
##   Result write into ${__AWRRPT_DIR} Directory                                                       ##
##                                                                                                     ##
#########################################################################################################
get_snapshot(){

  SNAPSHOT_VER=10
  if [ ${__SNAP_VERSION} -eq 9 ] || [ ${__DB_VERSION_MAJOR} -lt 10 ]; then
    SNAPSHOT_VER=9
  fi
  make_snap_scripts ${SNAPSHOT_VER}
  print_log "[get_snapshot]" "3" "Begin Get Snapshot Result with SNAP_VERSION = [${__SNAP_VERSION}] and DB_VERSION = [${__DB_VERSION_MAJOR}]"
  ${__ORACLE_HOME}/bin/sqlplus "${__SQLPLUS_USER}" \@${__SNAP_SCRIPT} 1>>${__SNAP_LOGFILE} 2>>${__ERRORFILE}
  mv enmotech_report_v*.html ${__AWRRPT_DIR} 2>/dev/null
  if [ $? -eq 0 ]; then
    print_log "[get_snapshot]" "" "Successfully Create Snapshot Result into [${__AWRRPT_DIR}]"
    if [ "`cat ${__AWRRPT_DIR}/enmotech_report_v*.html | grep '^ORA-'`" != "" ]; then
      print_log "[get_snapshot]" "2" "[Warnning] Snapshot Report have some ORA Errors"
      print_log "[get_snapshot]" "2" "[Cause] `cat ${__AWRRPT_DIR}/enmotech_report_v*.html | grep '^ORA-' | sort -u`"
    fi
  else
    print_log "[get_snapshot]" "2" "[Error] move Snapshot HTML File with Error, Please check Snapshot Report in [${__AWRRPT_DIR}]"
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    exit 1
  fi
  print_log "[get_metadata]" "" "End Collect Snapshot Result File"
}

#########################################################################################################
##                                                                                                     ##
## Function get_osdata(): Get OSData by getOSData Scripts                                              ##
##   Result write into ${__RESULT_DIR} Directory                                                       ##
##                                                                                                     ##
#########################################################################################################
get_osdata(){

  print_log "[get_osdata]" "" "Begin Collect OS Related Data into [${__OSDATA_DIR}]"
  make_os_scripts

  # Get Perl Executable Command
  PERL_EXECUTABLE=`which perl 2>/dev/null`
  if [ "${PERL_EXECUTABLE}" = "" ]; then
    print_log "[get_osdata]" "2" "Cannot find perl Executable in system, trying to use perl with Oracle ..."
    PERL_EXECUTABLE=`ls ${__ORACLE_HOME}/perl/bin/perl 2>/dev/null`
    if [ "${PERL_EXECUTABLE}" = "" ]; then
      print_log "[get_osdata]" "2" "Cannot find perl Executable in [${__ORACLE_HOME}/perl/bin]"
    else
      print_log "[get_osdata]" "" "Find perl Executable [${PERL_EXECUTABLE}]"
    fi
  else
    print_log "[get_osdata]" "" "Find perl Executable [${PERL_EXECUTABLE}]"
  fi

  # If Perl Found, the Collect OS Data
  if [ "${PERL_EXECUTABLE}" != "" ]; then
    # Get Perl Version
    PERL_VERSION_LINE=`${PERL_EXECUTABLE} -v | grep "This is perl"`
    PERL_VERSION=`echo ${PERL_VERSION_LINE} -v | grep "This is perl" | cut -d 'v' -f 2 | cut -d ' ' -f 1`
    if [ ${PERL_VERSION} = "ersion" ]; then
      PERL_VERSION=`${PERL_VERSION_LINE} -v | grep "This is perl" | cut -d 'v' -f 4 | cut -d ')' -f 1`
    fi
    PERL_VERSION_MAJOR=`echo ${PERL_VERSION} | cut -d '.' -f 1`
    PERL_VERSION_MINOR=`echo ${PERL_VERSION} | cut -d '.' -f 2`
    if [ ${PERL_VERSION_MAJOR} -ge 5 ] && [ ${PERL_VERSION_MINOR} -ge 8 ]; then
      print_log "[get_osdata]" "" "Get perl Version [${PERL_VERSION}] greater than our test environment"
    else
      print_log "[get_osdata]" "2" "[ WARNING ] Get perl Version [${PERL_VERSION}] that we do not test"
    fi
    # Get Options for getOSData Scripts
    OS_OPTS="-c ${__X_CODE}"
    if [ "${__DB_ALERT_FILE}" != "" ]; then
      OS_OPTS="${OS_OPTS} -f ${__DB_ALERT_FILE}"
    fi
    if [ "${__ASM_ALERT_FILE}" != "" ]; then
      OS_OPTS="${OS_OPTS} -a ${__ASM_ALERT_FILE}"
    fi
    if [ "${__BEGIN_TIME}" != "" ]; then
     OS_OPTS="${OS_OPTS} -b ${__BEGIN_TIME}"
    fi

    # Collect Current Machine
    print_log "[get_osdata]" "" "Get OS Info with : [${PERL_EXECUTABLE} ${__OS_SCRIPT} ${OS_OPTS} -v ${__DB_VERSION_MAJOR} -u ${__SQLPLUS_USER}]"
    ${PERL_EXECUTABLE} ${__OS_SCRIPT} ${OS_OPTS} -v ${__DB_VERSION_MAJOR} -o ${__ORACLE_HOME} -i ${ORACLE_SID} -u ${__SQLPLUS_USER}
    print_log "[get_osdata]" "" "OS Related Data already collected"

    # About to Collect Other Machines Info
    if [ "${__OS_PLATFORM}" == "Linux" ]; then
      LEFT_NODE=${__RAC_NODES}
      while [ "$LEFT_NODE" != "${CURR_NODE}" ];
      do
        CURR_NODE=`echo ${LEFT_NODE} | cut -d ':' -f 1`
        LEFT_NODE=`echo ${LEFT_NODE} | cut -d ':' -f 2-`
        print_log "[get_osdata]" "" "Transfer Scripts [${__SCRIPT_NAME}] to [${CURR_NODE}]"
        scp ${__SCRIPT_NAME} oracle@${CURR_NODE}:/tmp 1>/dev/null 2>>${__ERRORFILE}
        ssh oracle@${CURR_NODE} "cd /tmp;chmod u+x ${__SCRIPT_NAME};OH=${__ORACLE_HOME};OID=\`ps -ef | grep -i ora_ckp[t]_ | cut -d '_' -f 3\`;export ORACLE_HOME=\${OH} ORACLE_SID=\${OID};./${__SCRIPT_NAME} -m 010 -n -z" 1>/dev/null 2>>${__ERRORFILE}
        scp oracle@${CURR_NODE}:/tmp/dataCollector_*_`date +"%Y%m%d"`.tar.gz . 1>/dev/null 2>>${__ERRORFILE}
      done
    fi
  fi
  print_log "[get_osdata]" "" "End Collect OS Related Data"
}

#########################################################################################################
##                                                                                                     ##
## Function get_osload() : Start/Stop OS Load in backgroud                                             ##
##   Result write into ${__RESULT_DIR} Directory                                                       ##
##                                                                                                     ##
#########################################################################################################
get_osload(){

  OS_LOAD_SWITCHER=${1}
  if [ "${OS_LOAD_SWITCHER}" = "1" ]; then
    print_log "[get_osload]" "" "Get OS Load Switcher [${OS_LOAD_SWITCHER}], Start OS Load Collection, Please Wait [3] Seconds to initialization ..."
    echo "TRUE" > ${__OSLOAD_SWITCHER}
    cat > ${__OSLOAD_SCRIPT} <<EOFLOAD
 ISRUNNING=\`head -1 ${__OSLOAD_SWITCHER}\`
 RUNNINGTIMES=0
 MAXRUNNING=3600
 VMOPTS=""
 if [ "\`uname\`" = "AIX" ] || [ "\`uname\`" = "Linux" ]; then
   VMOPTS=" -t"
 fi

 while [ "\${ISRUNNING}" = "TRUE" ]
 do
   vmstat \${VMOPTS} 1 10 1>> ${__OSLOAD_RESULT} 2>>${__ERRORFILE}
   ISRUNNING=\`head -1 ${__OSLOAD_SWITCHER}\`
   let "RUNNINGTIMES+=10"
   if [ \${RUNNINGTIMES} -gt \${MAXRUNNING} ]; then
     ISRUNNING='FALSE'
   fi
 done
 exit 0
EOFLOAD
    nohup sh ${__OSLOAD_SCRIPT} 1>/dev/null 2>>${__ERRORFILE} &
    sleep 3
    print_log "[get_osload]" "" "OS Load Collection started"
  elif [ "${OS_LOAD_SWITCHER}" = "0" ]; then
    print_log "[get_osload]" "" "Get OS Load Switcher [${OS_LOAD_SWITCHER}], Stop OS Load Collection, Maybe Need 10 Seconds to Completed"
    echo "FALSE" > ${__OSLOAD_SWITCHER}
    DETECT_TIME=0
    OS_LOAD_PID=`ps -ef | grep ${__OSLOAD_SCRIPT} | grep -v grep`
    OS_LOAD_PID=`echo ${OS_LOAD_PID} | cut -d ' ' -f 2`
    while [ "${OS_LOAD_PID}" != "" ] && [ ${DETECT_TIME} -le 11 ]
    do
      sleep 1
      let "DETECT_TIME+=1"
      OS_LOAD_PID=`ps -ef | grep ${__OSLOAD_SCRIPT} | grep -v grep`
      OS_LOAD_PID=`echo ${OS_LOAD_PID} | cut -d ' ' -f 2`
    done
    if [ "${OS_LOAD_PID}" = "" ]; then
      print_log "[get_osload]" "" "OS Load Collection Successfully Completed"
    else
      print_log "[get_osload]" "2" "OS Load Collection Continue Running with PID [${OS_LOAD_PID}]"
    fi
  else
    print_log "[get_osload]" "" "Cannot Identified OS Load Switcher [${OS_LOAD_SWITCHER}]"
  fi
}

#########################################################################################################
##                                                                                                     ##
## Function interactive_mode(): Add or Remove needed Data in the Bucket                                ##
##                                                                                                     ##
#########################################################################################################
print_list(){
  print_log "[interactive_mode]" "" " >>> Notes : Lines Begin as '+' means already in the Bucket <<<"
  if [ "${__C_AWR_DBTIME}" = "1D" ] || [ "${__C_AWR_DBTIME}" = "1A" ]; then
    print_log "[interactive_mode]" "" "Select Needed : [+]  1 : AWR Report of Day DB Time"
  else
    print_log "[interactive_mode]" "" "Select Needed :      1 : AWR Report of Day DB Time"
  fi
  if [ "${__C_AWR_LOGICAL}" = "1D" ] || [ "${__C_AWR_LOGICAL}" = "1A" ]; then
    print_log "[interactive_mode]" "" "                [+]  2 : AWR Report of Day Logical Read"
  else
    print_log "[interactive_mode]" "" "                     2 : AWR Report of Day Logical Read"
  fi
  if [ "${__C_AWR_PHYSICAL}" = "1D" ] || [ "${__C_AWR_PHYSICAL}" = "1A" ]; then
    print_log "[interactive_mode]" "" "                [+]  3 : AWR Report of Day Physical Read"
  else
    print_log "[interactive_mode]" "" "                     3 : AWR Report of Day Physical Read"
  fi
  if [ "${__C_AWR_DBTIME}" = "1N" ] || [ "${__C_AWR_DBTIME}" = "1A" ]; then
    print_log "[interactive_mode]" "" "                [+]  4 : AWR Report of Night DB Time"
  else
    print_log "[interactive_mode]" "" "                     4 : AWR Report of Night DB Time"
  fi
  if [ "${__C_AWR_LOGICAL}" = "1N" ] || [ "${__C_AWR_LOGICAL}" = "1A" ]; then
    print_log "[interactive_mode]" "" "                [+]  5 : AWR Report of Night Logical Read"
  else
    print_log "[interactive_mode]" "" "                     5 : AWR Report of Night Logical Read"
  fi
  if [ "${__C_AWR_PHYSICAL}" = "1N" ] || [ "${__C_AWR_PHYSICAL}" = "1A" ]; then
    print_log "[interactive_mode]" "" "                [+]  6 : AWR Report of Night Physical Read"
  else
    print_log "[interactive_mode]" "" "                     6 : AWR Report of Night Physical Read"
  fi
  print_log "[interactive_mode]" "" "----------------------------------------------------------------"
  if [ "${__C_SQL_ELAPSE}" = "1D" ] || [ "${__C_SQL_ELAPSE}" = "1A" ]; then
    print_log "[interactive_mode]" "" "                [+]  7 : SQL Report of Day Elapse Time"
  else
    print_log "[interactive_mode]" "" "                     7 : SQL Report of Day Elapse Time"
  fi
  if [ "${__C_SQL_BUFFER}" = "1D" ] || [ "${__C_SQL_BUFFER}" = "1A" ]; then
    print_log "[interactive_mode]" "" "                [+]  8 : SQL Report of Day Logical Read"
  else
    print_log "[interactive_mode]" "" "                     8 : SQL Report of Day Logical Read"
  fi
  if [ "${__C_SQL_DISK}" = "1D" ] || [ "${__C_SQL_DISK}" = "1A" ]; then
    print_log "[interactive_mode]" "" "                [+]  9 : SQL Report of Day Physical Read"
  else
    print_log "[interactive_mode]" "" "                     9 : SQL Report of Day Physical Read"
  fi
  if [ "${__C_SQL_EXECUTION}" = "1D" ] || [ "${__C_SQL_EXECUTION}" = "1A" ]; then
    print_log "[interactive_mode]" "" "                [+] 10 : SQL Report of Day Execution"
  else
    print_log "[interactive_mode]" "" "                    10 : SQL Report of Day Execution"
  fi
  if [ "${__C_SQL_ELAPSE}" = "1N" ] || [ "${__C_SQL_ELAPSE}" = "1A" ]; then
    print_log "[interactive_mode]" "" "                [+] 11 : SQL Report of Night Elapse Time"
  else
    print_log "[interactive_mode]" "" "                    11 : SQL Report of Night Elapse Time"
  fi
  if [ "${__C_SQL_BUFFER}" = "1N" ] || [ "${__C_SQL_BUFFER}" = "1A" ]; then
    print_log "[interactive_mode]" "" "                [+] 12 : SQL Report of Night Logical Read"
  else
    print_log "[interactive_mode]" "" "                    12 : SQL Report of Night Logical Read"
  fi
  if [ "${__C_SQL_DISK}" = "1N" ] || [ "${__C_SQL_DISK}" = "1A" ]; then
    print_log "[interactive_mode]" "" "                [+] 13 : SQL Report of Night Physical Read"
  else
    print_log "[interactive_mode]" "" "                    13 : SQL Report of Night Physical Read"
  fi
  if [ "${__C_SQL_EXECUTION}" = "1N" ] || [ "${__C_SQL_EXECUTION}" = "1A" ]; then
    print_log "[interactive_mode]" "" "                [+] 14 : SQL Report of Night Execution"
  else
    print_log "[interactive_mode]" "" "                    14 : SQL Report of Night Execution"
  fi
  print_log "[interactive_mode]" "" "----------------------------------------------------------------"
  if [ ${__C_AWR_STATS} -eq 1 ]; then
    print_log "[interactive_mode]" "" "                [+] 15 : Statistics Graphic and Text Info, include DB Time, Physical Read, Physical Read"
  else
    print_log "[interactive_mode]" "" "                    15 : Statistics Graphic and Text Info, include DB Time, Physical Read, Physical Read"
  fi
  if [ ${__C_AWR_WAIT} -eq 1 ]; then
    print_log "[interactive_mode]" "" "                [+] 16 : Top Wait Graphic and Text Info"
  else
    print_log "[interactive_mode]" "" "                    16 : Top Wait Graphic and Text Info"
  fi
  if [ ${__C_AWR_PROFILE} -eq 1 ]; then
    print_log "[interactive_mode]" "" "                [+] 17 : AWR Profile Infomation"
  else
    print_log "[interactive_mode]" "" "                    17 : AWR Profile Infomation"
  fi
  if [ ${__C_AWRDUMP} -eq 1 ]; then
    print_log "[interactive_mode]" "" "                [+] 18 : AWR Dump File"
  else
    print_log "[interactive_mode]" "" "                    18 : AWR Dump File"
  fi
  if [ ${__C_METADATA} -eq 1 ]; then
    print_log "[interactive_mode]" "" "                [+] 19 : Metadata from Database"
  else
    print_log "[interactive_mode]" "" "                    19 : Metadata from Database"
  fi
  if [ ${__M_OSDATA} -eq 1 ]; then
    print_log "[interactive_mode]" "" "                [+] 20 : OS Related Infomation"
  else
    print_log "[interactive_mode]" "" "                    20 : OS Related Infomation"
  fi
  if [ ${__M_SNAPSHOT} -eq 1 ]; then
    print_log "[interactive_mode]" "" "                [+] 21 : Snapshot Result"
  else
    print_log "[interactive_mode]" "" "                    21 : Snapshot Result"
  fi
}

interactive_mode(){

  print_log "[interactive_mode]" "6" ">>> ... Welcome to the Interactive Mode ... <<<"
  while [ "${__USER_INPUT_CHAR}" != "C" ];
  do
    list_collected
    print_log "[interactive_mode]" "" "Begin with : A/a : Add Needed to the Collection Bucket"
    print_log "[interactive_mode]" "" "             D/d : Delete Needed from the Collection Bucket"
    print_log "[interactive_mode]" "" "     <Enter>/C/c : Collect Data listed in the Bucket"
    print_log "[interactive_mode]" "" "             L/l : List Selection Page"
    print_log "[interactive_mode]" "8" "BEGIN" "             Q/q : Quit and do not Collect anything"
    if [ "${__USER_INPUT_CHAR}" = "C" ] || [ "${__USER_INPUT_CHAR}" = "c" ] || [ "${__USER_INPUT_CHAR}" = "" ]; then
      print_log "[interactive_mode]" "6" ">>> ... Leave Interactive Mode ... <<<"
      __USER_INPUT_CHAR="C"
    elif [ "${__USER_INPUT_CHAR}" = "Q" ] || [ "${__USER_INPUT_CHAR}" = "q" ]; then
      print_log "[interactive_mode]" "6" ">>> ... Quit Data Collection ... <<<"
      echo "FALSE" > ${__OSLOAD_SWITCHER}
      exit 1
    elif [ "${__USER_INPUT_CHAR}" = "L" ] || [ "${__USER_INPUT_CHAR}" = "l" ]; then
      print_list
    elif [ "${__USER_INPUT_CHAR}" = "A" ] || [ "${__USER_INPUT_CHAR}" = "a" ]; then
      print_list
      print_log "[interactive_mode]" "8" "ADD" "                     0 : All of Above"
      BUCKET_COMMANDS="${__USER_INPUT_CHAR} "
      while [ "${BUCKET_COMMANDS}" != "" ];
      do
        FIRST_COMMAND=`echo "${BUCKET_COMMANDS}" | cut -d ' ' -f 1`
        BUCKET_COMMANDS=`echo "${BUCKET_COMMANDS}" | cut -d ' ' -f 2-`
        FIRST_COMMAND_1=`echo "${FIRST_COMMAND}" | cut -d '-' -f 1`
        FIRST_COMMAND_2=`echo "${FIRST_COMMAND}" | cut -d '-' -f 2`
        if [ "${FIRST_COMMAND_1}" != "${FIRST_COMMAND_2}" ]; then
          EXPAND_SELECTION=${FIRST_COMMAND_1}
          while [ ${EXPAND_SELECTION} -lt ${FIRST_COMMAND_2} ]
          do
            let "EXPAND_SELECTION+=1"
            BUCKET_COMMANDS="${EXPAND_SELECTION} ${BUCKET_COMMANDS}"
          done
        fi
        FIRST_COMMAND=${FIRST_COMMAND_1}
        case ${FIRST_COMMAND} in
          0)
            __C_AWR_DBTIME=1A
            __C_AWR_LOGICAL=1A
            __C_AWR_PHYSICAL=1A
            __C_SQL_ELAPSE=1A
            __C_SQL_BUFFER=1A
            __C_SQL_DISK=1A
            __C_SQL_EXECUTION=1A
            __C_AWR_STATS=1
            __C_AWR_WAIT=1
            __C_AWR_PROFILE=1
            __C_AWRDUMP=1
            __C_METADATA=1
            __M_OSDATA=1
            __M_SNAPSHOT=1
          ;;
          1)
            if [ "`echo ${__C_AWR_DBTIME} | cut -c 1`" = "0" ]; then
              __C_AWR_DBTIME=1D
            elif [ "${__C_AWR_DBTIME}" = "1N" ]; then
              __C_AWR_DBTIME=1A
            fi
          ;;
          2)
            if [ "`echo ${__C_AWR_LOGICAL} | cut -c 1`" = "0" ]; then
              __C_AWR_LOGICAL=1D
            elif [ "${__C_AWR_LOGICAL}" = "1N" ]; then
              __C_AWR_LOGICAL=1A
            fi
          ;;
          3)
            if [ "`echo ${__C_AWR_PHYSICAL} | cut -c 1`" = "0" ]; then
              __C_AWR_PHYSICAL=1D
            elif [ "${__C_AWR_PHYSICAL}" = "1N" ]; then
              __C_AWR_PHYSICAL=1A
            fi
          ;;
          4)
            if [ "`echo ${__C_AWR_DBTIME} | cut -c 1`" = "0" ]; then
              __C_AWR_DBTIME=1N
            elif [ "${__C_AWR_DBTIME}" = "1D" ]; then
              __C_AWR_DBTIME=1A
            fi
          ;;
          5)
            if [ "`echo ${__C_AWR_LOGICAL} | cut -c 1`" = "0" ]; then
              __C_AWR_LOGICAL=1N
            elif [ "${__C_AWR_LOGICAL}" = "1D" ]; then
              __C_AWR_LOGICAL=1A
            fi
          ;;
          6)
            if [ "`echo ${__C_AWR_PHYSICAL} | cut -c 1`" = "0" ]; then
              __C_AWR_PHYSICAL=1N
            elif [ "${__C_AWR_PHYSICAL}" = "1D" ]; then
              __C_AWR_PHYSICAL=1A
            fi
          ;;
          7)
            if [ "`echo ${__C_SQL_ELAPSE} | cut -c 1`" = "0" ]; then
              __C_SQL_ELAPSE=1D
            elif [ "${__C_SQL_ELAPSE}" = "1N" ]; then
              __C_SQL_ELAPSE=1A
            fi
          ;;
          8)
            if [ "`echo ${__C_SQL_BUFFER} | cut -c 1`" = "0" ]; then
              __C_SQL_BUFFER=1D
            elif [ "${__C_SQL_BUFFER}" = "1N" ]; then
              __C_SQL_BUFFER=1A
            fi
          ;;
          9)
            if [ "`echo ${__C_SQL_DISK} | cut -c 1`" = "0" ]; then
              __C_SQL_DISK=1D
            elif [ "${__C_SQL_DISK}" = "1N" ]; then
              __C_SQL_DISK=1A
            fi
          ;;
          10)
            if [ "`echo ${__C_SQL_EXECUTION} | cut -c 1`" = "0" ]; then
              __C_SQL_EXECUTION=1D
            elif [ "${__C_SQL_EXECUTION}" = "1N" ]; then
              __C_SQL_EXECUTION=1A
            fi
          ;;
          11)
            if [ "`echo ${__C_SQL_ELAPSE} | cut -c 1`" = "0" ]; then
              __C_SQL_ELAPSE=1N
            elif [ "${__C_SQL_ELAPSE}" = "1D" ]; then
              __C_SQL_ELAPSE=1A
            fi
          ;;
          12)
            if [ "`echo ${__C_SQL_BUFFER} | cut -c 1`" = "0" ]; then
              __C_SQL_BUFFER=1N
            elif [ "${__C_SQL_BUFFER}" = "1D" ]; then
              __C_SQL_BUFFER=1A
            fi
          ;;
          13)
            if [ "`echo ${__C_SQL_DISK} | cut -c 1`" = "0" ]; then
              __C_SQL_DISK=1N
            elif [ "${__C_SQL_DISK}" = "1D" ]; then
              __C_SQL_DISK=1A
            fi
          ;;
          14)
            if [ "`echo ${__C_SQL_EXECUTION} | cut -c 1`" = "0" ]; then
              __C_SQL_EXECUTION=1N
            elif [ "${__C_SQL_EXECUTION}" = "1D" ]; then
              __C_SQL_EXECUTION=1A
            fi
          ;;
          15) __C_AWR_STATS=1 ;;
          16) __C_AWR_WAIT=1 ;;
          17) __C_AWR_PROFILE=1 ;;
          18) __C_AWRDUMP=1 ;;
          19) __C_METADATA=1 ;;
          20) __M_OSDATA=1 ;;
          21) __M_SNAPSHOT=1 ;;
        esac
      done
    elif [ "${__USER_INPUT_CHAR}" = "D" ] || [ "${__USER_INPUT_CHAR}" = "d" ]; then
      print_list
      print_log "[interactive_mode]" "8" "DELETE" "                     0 : All of Above"
      BUCKET_COMMANDS="${__USER_INPUT_CHAR} "
      while [ "${BUCKET_COMMANDS}" != "" ];
      do
        #echo "[${BUCKET_COMMANDS}]"
        FIRST_COMMAND=`echo "${BUCKET_COMMANDS}" | cut -d ' ' -f 1`
        BUCKET_COMMANDS=`echo "${BUCKET_COMMANDS}" | cut -d ' ' -f 2-`
        FIRST_COMMAND_1=`echo "${FIRST_COMMAND}" | cut -d '-' -f 1`
        FIRST_COMMAND_2=`echo "${FIRST_COMMAND}" | cut -d '-' -f 2`
        if [ "${FIRST_COMMAND_1}" != "${FIRST_COMMAND_2}" ]; then
          EXPAND_SELECTION=${FIRST_COMMAND_1}
          while [ ${EXPAND_SELECTION} -lt ${FIRST_COMMAND_2} ]
          do
            let "EXPAND_SELECTION+=1"
            BUCKET_COMMANDS="${EXPAND_SELECTION} ${BUCKET_COMMANDS}"
          done
        fi
        FIRST_COMMAND=${FIRST_COMMAND_1}
        case ${FIRST_COMMAND} in
          0)
            __C_AWR_DBTIME=0D
            __C_AWR_LOGICAL=0D
            __C_AWR_PHYSICAL=0D
            __C_SQL_ELAPSE=0D
            __C_SQL_BUFFER=0D
            __C_SQL_DISK=0D
            __C_SQL_EXECUTION=0D
            __C_AWR_STATS=0
            __C_AWR_WAIT=0
            __C_AWR_PROFILE=0
            __C_AWRDUMP=0
            __C_METADATA=0
            __M_OSDATA=0
            __M_SNAPSHOT=0
          ;;
          1)
            if [ "${__C_AWR_DBTIME}" = "1A" ]; then
              __C_AWR_DBTIME=1N
            elif [ "${__C_AWR_DBTIME}" = "1D" ]; then
              __C_AWR_DBTIME=0N
            fi
          ;;
          2)
            if [ "${__C_AWR_LOGICAL}" = "1A" ]; then
              __C_AWR_LOGICAL=1N
            elif [ "${__C_AWR_LOGICAL}" = "1D" ]; then
              __C_AWR_LOGICAL=0N
            fi
          ;;
          3)
            if [ "${__C_AWR_PHYSICAL}" = "1A" ]; then
              __C_AWR_PHYSICAL=1N
            elif [ "${__C_AWR_PHYSICAL}" = "1D" ]; then
              __C_AWR_PHYSICAL=0N
            fi
          ;;
          4)
            if [ "${__C_AWR_DBTIME}" = "1A" ]; then
              __C_AWR_DBTIME=1D
            elif [ "${__C_AWR_DBTIME}" = "1N" ]; then
              __C_AWR_DBTIME=0N
            fi
          ;;
          5)
            if [ "${__C_AWR_LOGICAL}" = "1A" ]; then
              __C_AWR_LOGICAL=1D
            elif [ "${__C_AWR_LOGICAL}" = "1N" ]; then
              __C_AWR_LOGICAL=0N
            fi
          ;;
          6)
            if [ "${__C_AWR_PHYSICAL}" = "1A" ]; then
              __C_AWR_PHYSICAL=1D
            elif [ "${__C_AWR_PHYSICAL}" = "1N" ]; then
              __C_AWR_PHYSICAL=0N
            fi
          ;;
          7)
            if [ "${__C_SQL_ELAPSE}" = "1A" ]; then
              __C_SQL_ELAPSE=1N
            elif [ "${__C_SQL_ELAPSE}" = "1D" ]; then
              __C_SQL_ELAPSE=0N
            fi
          ;;
          8)
            if [ "${__C_SQL_BUFFER}" = "1A" ]; then
              __C_SQL_BUFFER=1N
            elif [ "${__C_SQL_BUFFER}" = "1D" ]; then
              __C_SQL_BUFFER=0N
            fi
          ;;
          9)
            if [ "${__C_SQL_DISK}" = "1A" ]; then
              __C_SQL_DISK=1N
            elif [ "${__C_SQL_DISK}" = "1D" ]; then
              __C_SQL_DISK=0N
            fi
          ;;
          10)
            if [ "${__C_SQL_EXECUTION}" = "1A" ]; then
              __C_SQL_EXECUTION=1N
            elif [ "${__C_SQL_EXECUTION}" = "1D" ]; then
              __C_SQL_EXECUTION=0N
            fi
          ;;
          11)
            if [ "${__C_SQL_ELAPSE}" = "1A" ]; then
              __C_SQL_ELAPSE=1D
            elif [ "${__C_SQL_ELAPSE}" = "1N" ]; then
              __C_SQL_ELAPSE=0N
            fi
          ;;
          12)
            if [ "${__C_SQL_BUFFER}" = "1A" ]; then
              __C_SQL_BUFFER=1D
            elif [ "${__C_SQL_BUFFER}" = "1N" ]; then
              __C_SQL_BUFFER=0N
            fi
          ;;
          13)
            if [ "${__C_SQL_DISK}" = "1A" ]; then
              __C_SQL_DISK=1D
            elif [ "${__C_SQL_DISK}" = "1N" ]; then
              __C_SQL_DISK=0N
            fi
          ;;
          14)
            if [ "${__C_SQL_EXECUTION}" = "1A" ]; then
              __C_SQL_EXECUTION=1D
            elif [ "${__C_SQL_EXECUTION}" = "1N" ]; then
              __C_SQL_EXECUTION=0N
            fi
          ;;
          15) __C_AWR_STATS=0 ;;
          16) __C_AWR_WAIT=0 ;;
          17) __C_AWR_PROFILE=0 ;;
          18) __C_AWRDUMP=0 ;;
          19) __C_METADATA=0 ;;
          20) __M_OSDATA=0 ;;
          21) __M_SNAPSHOT=0 ;;
        esac
      done
    else
      print_log "[interactive_mode]" "" "Cannot Identify User Input Command with [${__USER_INPUT_CHAR}]"
    fi
  done
}

#########################################################################################################
##                                                                                                     ##
## Main Function                                                                                       ##
##                                                                                                     ##
#########################################################################################################
initialization
get_osload 1
if [ ${__SILENT_MODE} -eq 0 ]; then
  interactive_mode
else
  list_collected
fi

# Really Begin to Collect Related Data
if [ ${__M_DBDATA} -eq 1 ]; then
  get_dbinfo
  calculate_time
elif [ ${__M_SNAPSHOT} -eq 1 ]; then
  get_dbinfo
elif [ "${__DB_ALERT_FILE}" = "" ] && [ "`echo ${__X_CODE} | cut -c 1`" = "1" ]; then
  get_dbinfo
elif [ "${__ASM_ALERT_FILE}" = "" ] && [ "`echo ${__X_CODE} | cut -c 2`" = "1" ]; then
  get_dbinfo
fi

# Get DB Data, include AWR or STATSPACK, AWR Dump and Metadata Dump
if [ ${__M_DBDATA} -eq 1 ] && [ ${__USE_STATSPACK} -eq 0 ]; then
  # AWR Report
  if [ "${__C_AWR_DBTIME}" = "1D" ]; then
    get_awr_needed dbtime D
  elif [ "${__C_AWR_DBTIME}" = "1N" ]; then
    get_awr_needed dbtime N
  elif [ "${__C_AWR_DBTIME}" = "1A" ]; then
    get_awr_needed dbtime D
    get_awr_needed dbtime N
  fi
  if [ "${__C_AWR_LOGICAL}" = "1D" ]; then
    get_awr_needed logical D
  elif [ "${__C_AWR_LOGICAL}" = "1N" ]; then
    get_awr_needed logical N
  elif [ "${__C_AWR_LOGICAL}" = "1A" ]; then
    get_awr_needed logical D
    get_awr_needed logical N
  fi
  if [ "${__C_AWR_PHYSICAL}" = "1D" ]; then
    get_awr_needed physical D
  elif [ "${__C_AWR_PHYSICAL}" = "1N" ]; then
    get_awr_needed physical N
  elif [ "${__C_AWR_PHYSICAL}" = "1A" ]; then
    get_awr_needed physical D
    get_awr_needed physical N
  fi
  # SQL Report
  if [ "${__C_SQL_ELAPSE}" = "1D" ]; then
    get_sql_needed ELAPSED_TIME D
  elif [ "${__C_SQL_ELAPSE}" = "1N" ]; then
    get_sql_needed ELAPSED_TIME N
  elif [ "${__C_SQL_ELAPSE}" = "1A" ]; then
    get_sql_needed ELAPSED_TIME D
    get_sql_needed ELAPSED_TIME N
  fi
  if [ "${__C_SQL_BUFFER}" = "1D" ]; then
    get_sql_needed BUFFER_GETS D
  elif [ "${__C_SQL_BUFFER}" = "1N" ]; then
    get_sql_needed BUFFER_GETS N
  elif [ "${__C_SQL_BUFFER}" = "1A" ]; then
    get_sql_needed BUFFER_GETS D
    get_sql_needed BUFFER_GETS N
  fi
  if [ "${__C_SQL_DISK}" = "1D" ]; then
    get_sql_needed DISK_READS D
  elif [ "${__C_SQL_DISK}" = "1N" ]; then
    get_sql_needed DISK_READS N
  elif [ "${__C_SQL_DISK}" = "1A" ]; then
    get_sql_needed DISK_READS D
    get_sql_needed DISK_READS N
  fi
  if [ "${__C_SQL_EXECUTION}" = "1D" ]; then
    get_sql_needed EXECUTIONS D
  elif [ "${__C_SQL_EXECUTION}" = "1N" ]; then
    get_sql_needed EXECUTIONS N
  elif [ "${__C_SQL_EXECUTION}" = "1A" ]; then
    get_sql_needed EXECUTIONS D
    get_sql_needed EXECUTIONS N
  fi

  # Generate AWR and SQL Report in HTML Format
  if [ -f "${__RPT_NEEDED}" ]; then
    get_awrrpt
  fi
  if [ -f "${__SQL_NEEDED}" ]; then
    get_sqlrpt
  fi

  # Get Stat Data from AWR , used for make Graphic
  if [ ${__C_AWR_STATS} -eq 1 ]; then
    # get_awrinfo need 7 parameters , which means :
    # <FILE_NAME>  <STAT_NAME>  <CONVERT_OPTION>  <HTML_TITLE>  <HTML_SUB_TITLE>  <HTML_Y_AXIS>  <STAT_TYPE>
    # STAT_TYPE can be S (sysstat) and T (sys_timed_model)
    begin_statGraphic 1
    get_awrinfo "dbtime" "DB time" "/1000000" "DB Time Trendline" "Unit: DB Time/s" "DB Time" "T"
    get_awrinfo "logical" "db block gets', 'consistent gets" "*${__DB_BLOCK_SIZE}/1024" "logical Read Trendline" "Unit: KB/s" "Logical Read" "S"
    get_awrinfo "physical" "physical reads" "*${__DB_BLOCK_SIZE}/1024" "Physical Read Trendline" "Unit: KB/s" "Physical Read" "S"
    while [ "${__OTHER_GRAPHIC}" != "" ];
    do
      MORE_GRAPHIC_LINE=`echo ${__OTHER_GRAPHIC} | cut -f 1 -d '#'`
      __OTHER_GRAPHIC=`echo ${__OTHER_GRAPHIC} | cut -f 2- -d '#'`
      STAT_FILE_NAME=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 1`
      STAT_NAME=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 2`
      CONVERT_OPTION=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 3`
      HTML_TITLE=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 4`
      HTML_SUB_TITLE=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 5`
      HTML_Y_AXIS=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 6`
      STAT_TYPE=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 7`
      if [ "${MORE_GRAPHIC_LINE}" != "" ]; then
        get_awrinfo "${STAT_FILE_NAME}" "${STAT_NAME}" "${CONVERT_OPTION}" "${HTML_TITLE}" "${HTML_SUB_TITLE}" "${HTML_Y_AXIS}" "${STAT_TYPE}"
      fi
    done
    end_statGraphic 1
  fi
  if [ ${__C_AWR_PROFILE} -eq 1 ]; then
    get_awr_profile
  fi
  # Get Stat Data from AWR , used for make Graphic
  if [ ${__C_AWR_WAIT} -eq 1 ]; then
    get_top_waits
  fi
  # Get AWR Dump Data
  if [ ${__C_AWRDUMP} -eq 1 ]; then
    get_awrdump
  fi
  # Export Metadata
  if [ ${__C_METADATA} -eq 1 ]; then
    get_metadata
  fi
elif [ ${__M_DBDATA} -eq 1 ] && [ ${__USE_STATSPACK} -eq 1 ]; then
  # STATSPACK Report
  if [ "${__C_AWR_LOGICAL}" = "1D" ]; then
    get_sp_needed logical D
  elif [ "${__C_AWR_LOGICAL}" = "1N" ]; then
    get_sp_needed logical N
  elif [ "${__C_AWR_LOGICAL}" = "1A" ]; then
    get_sp_needed logical D
    get_sp_needed logical N
  fi
  if [ "${__C_AWR_PHYSICAL}" = "1D" ]; then
    get_sp_needed physical D
  elif [ "${__C_AWR_PHYSICAL}" = "1N" ]; then
    get_sp_needed physical N
  elif [ "${__C_AWR_PHYSICAL}" = "1A" ]; then
    get_sp_needed physical D
    get_sp_needed physical N
  fi

  # Statspack SQL Report
  if [ "${__C_SQL_ELAPSE}" = "1D" ]; then
    get_spsql_needed ELAPSED_TIME D
  elif [ "${__C_SQL_ELAPSE}" = "1N" ]; then
    get_spsql_needed ELAPSED_TIME N
  elif [ "${__C_SQL_ELAPSE}" = "1A" ]; then
    get_spsql_needed ELAPSED_TIME D
    get_spsql_needed ELAPSED_TIME N
  fi
  if [ "${__C_SQL_BUFFER}" = "1D" ]; then
    get_spsql_needed BUFFER_GETS D
  elif [ "${__C_SQL_BUFFER}" = "1N" ]; then
    get_spsql_needed BUFFER_GETS N
  elif [ "${__C_SQL_BUFFER}" = "1A" ]; then
    get_spsql_needed BUFFER_GETS D
    get_spsql_needed BUFFER_GETS N
  fi
  if [ "${__C_SQL_DISK}" = "1D" ]; then
    get_spsql_needed DISK_READS D
  elif [ "${__C_SQL_DISK}" = "1N" ]; then
    get_spsql_needed DISK_READS N
  elif [ "${__C_SQL_DISK}" = "1A" ]; then
    get_spsql_needed DISK_READS D
    get_spsql_needed DISK_READS N
  fi
  if [ "${__C_SQL_EXECUTION}" = "1D" ]; then
    get_spsql_needed EXECUTIONS D
  elif [ "${__C_SQL_EXECUTION}" = "1N" ]; then
    get_spsql_needed EXECUTIONS N
  elif [ "${__C_SQL_EXECUTION}" = "1A" ]; then
    get_spsql_needed EXECUTIONS D
    get_spsql_needed EXECUTIONS N
  fi

  # Generate STATSPACK and SQL Report in TEXT Format
  if [ -f "${__RPT_NEEDED}" ]; then
    get_sprpt
  fi
  if [ -f "${__SQL_NEEDED}" ]; then
    get_spsqlrpt
  fi
  # Get Stat Data from STATSPACK , used for make Graphic
  if [ ${__C_AWR_STATS} -eq 1 ]; then
    begin_statGraphic 0
    get_spinfo "logical" "db block gets', 'consistent gets" "*${__DB_BLOCK_SIZE}/1024" "Logical Read Trendline" "Unit: KB/s" "Logical Read" "S"
    get_spinfo "physical" "physical reads" "*${__DB_BLOCK_SIZE}/1024" "Physical Read Trendline" "Unit: KB/s" "Physical Read" "S"
    while [ "${__OTHER_GRAPHIC}" != "" ];
    do
      MORE_GRAPHIC_LINE=`echo ${__OTHER_GRAPHIC} | cut -f 1 -d '#'`
      __OTHER_GRAPHIC=`echo ${__OTHER_GRAPHIC} | cut -f 2- -d '#'`
      STAT_FILE_NAME=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 1`
      STAT_NAME=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 2`
      CONVERT_OPTION=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 3`
      HTML_TITLE=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 4`
      HTML_SUB_TITLE=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 5`
      HTML_Y_AXIS=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 6`
      STAT_TYPE=`echo ${MORE_GRAPHIC_LINE} | cut -d '|' -f 7`
      if [ "${MORE_GRAPHIC_LINE}" != "" ]; then
        get_spinfo "${STAT_FILE_NAME}" "${STAT_NAME}" "${CONVERT_OPTION}" "${HTML_TITLE}" "${HTML_SUB_TITLE}" "${HTML_Y_AXIS}" "${STAT_TYPE}"
      fi
    done
    end_statGraphic 0
  fi
  # Get STATSPACK Dump Data
  if [ ${__C_AWRDUMP} -eq 1 ]; then
    get_spdump
  fi
  # Export Metadata
  if [ ${__C_METADATA} -eq 1 ]; then
  get_metadata
  fi
fi

# Get Snapshot Result
if [ ${__M_SNAPSHOT} -eq 1 ]; then
  get_snapshot
fi

# Get OS Related Data
if [ ${__M_OSDATA} -eq 1 ]; then
  get_osdata
fi

# Build Report Index
build_index

# Completed OS Load Collector
get_osload 0
#########################################################################################################
##                                                                                                     ##
## Clear Environment                                                                                   ##
##                                                                                                     ##
#########################################################################################################
END_HOUR=`date +"%H"`
END_MINUTE=`date +"%M"`
END_SECOND=`date +"%S"`
if [ "`echo ${BEGIN_HOUR} | cut -c 1`" = "0" ]; then
  BEGIN_HOUR=`echo ${BEGIN_HOUR} | cut -c 2`
fi
if [ "`echo ${BEGIN_MINUTE} | cut -c 1`" = "0" ]; then
  BEGIN_MINUTE=`echo ${BEGIN_MINUTE} | cut -c 2`
fi
if [ "`echo ${BEGIN_SECOND} | cut -c 1`" = "0" ]; then
  BEGIN_SECOND=`echo ${BEGIN_SECOND} | cut -c 2`
fi
if [ "`echo ${END_HOUR} | cut -c 1`" = "0" ]; then
  END_HOUR=`echo ${END_HOUR} | cut -c 2`
fi
if [ "`echo ${END_MINUTE} | cut -c 1`" = "0" ]; then
  END_MINUTE=`echo ${END_MINUTE} | cut -c 2`
fi
if [ "`echo ${END_SECOND} | cut -c 1`" = "0" ]; then
  END_SECOND=`echo ${END_SECOND} | cut -c 2`
fi

let "ELAPSED_SECONDS=(${END_HOUR}-${BEGIN_HOUR})*3600+(${END_MINUTE}-${BEGIN_MINUTE})*60+(${END_SECOND}-${BEGIN_SECOND})"
#echo "EH=${END_HOUR}, BH=${BEGIN_HOUR}, BM=${END_MINUTE}, BM=${BEGIN_MINUTE}, ES=${END_SECOND}, BS=${BEGIN_SECOND}"
let "ELAPSED_MINUTES=${ELAPSED_SECONDS}/60"
let "ELAPSED_SECONDS=${ELAPSED_SECONDS}%60"
print_log "[End CLear]" "6" "Successfully Completed with Elapsed Time : ${ELAPSED_MINUTES} mins ${ELAPSED_SECONDS} secs"

cat ${__DELETE_FILE} | sort -u > ${__DELETE_FILE}.tmp
mv ${__DELETE_FILE}.tmp ${__DELETE_FILE}
if [ ! -s ${__ERRORFILE} ]; then
  print_log "[End CLear]" "5" "${__ERRORFILE}"
fi

# Remove Temp File in Silent Mode
if [ ${__SILENT_MODE} -eq 1 ]; then
  print_log "[End CLear]" "" "Remove Tempfile by [${__DELETE_FILE}]"
  sh ${__DELETE_FILE}
fi

# Pack Result
if [ ${__PACK_RESULT} -eq 1 ]; then
  print_log "[End CLear]" "" "Remove Tempfile by [${__DELETE_FILE}]"
  sh ${__DELETE_FILE}
  rm -rf ${__RESULT_DIR}.* 2>/dev/null
  print_log "[End CLear]" "" "Pack Result file into [${__RESULT_DIR}.tar.gz]"
  tar -cvf ${__RESULT_DIR}.tar ${__RESULT_DIR} 1>/dev/null 2>&1
  gzip ${__RESULT_DIR}.tar
  if [ $? -eq 0 ]; then
    rm -rf ${__RESULT_DIR} 2>/dev/null
  fi
else
  if [ -s ${__DELETE_FILE} ]; then
    echo ""
    echo "============================= Below List All the Temp File to be Removed =================================="
    cat ${__DELETE_FILE} 2>/dev/null
    echo "==========================================================================================================="
    echo "You can manually remove them all or run scripts below :"
    echo "sh `pwd`/${__DELETE_FILE}"
  fi
fi

echo ""
exit 0
