# Usage Instructions
# ~~~~~~~~~~~~~~~~~~
#  Usage: [n]awk -f ass.awk fname.trc   (But read the Portability Section !!)
#
#  This script is tested using "nawk". If your system doesn't have this then
#  please try "gawk" and then "awk" (in that order). If issues are seen
#  with "gawk" or "awk" then please let me know.
#
#  IMPORTANT:
#  Some platforms still run the "old" version of awk and this is NOT supported
#  as you will see errors such as:
#
#   awk: syntax error near line ...
#   awk: bailing out near line ...
#
#  To test whether you are running the "old" awk version execute the 
#  following command:
#
#   echo " " | awk '{printf("ARGC=%d\n", ARGC)}'
#
#  If the result is "ARGC=0" then this indicates that the awk version is "old"
#  and this script will probably FAIL. 
#
#  --------------------------------------------------------------------------
#
#  Configuring Ass
#  ~~~~~~~~~~~~~~~
#   
#  By default, 'ass' attempts to dump as much information as possible and
#  assumes that the output is to be printed to screen. This means that 'ass'
#  runs in its slowest mode. Ass can be changed/speeded up by amending the
#  following variables in the BEGIN section :
#
#   interactive...........1 = show indication of processing [default]
#                         0 = don't show anything (faster)
#   verbose...............1 = prints additional info        [default]
#                         0 = don't show info (faster)
#   eventdetail...........1 = prints additional event info for selected events 
#                             [default] 
#                         0 = don't do the above (faster)
#   skipbranch............1 = Skip 'branch of' state objects cause by SQL*NET
#                             loopback sessions etc (default)
#                         0 = don't skip 'branch of' transactions
#   seqinfo...............1 = Output sequence number for WAITING processes
#			  0 = Do not dump seq# information.
#   skipmsess.............1 = Skip the multi-session reporting
#                         0 = Do not skip this (default)
#   waitsummary...........1 = Print summary of all waits (default)
#                         0 = Do not print the summary
#
# Portability
# ~~~~~~~~~~~
#  1) This uses the nawk extension of functions. Some variants of awk accept
#     this (eg HP-UX v10) and others do not. Use nawk if awk fails !!
#                                            ^^^^^^^^^^^^^^^^^^^^^
#
#      Alpha OSF/1    nawk         IBM RS/6000   awk
#      Sun Solaris    nawk         HPUX          awk (v10)  ??? (v9)
#      Sun SunOS      nawk         Sequent       nawk
#
#  2) The Alpha version of awk can only handle 99 fields and will return 
#     a message like 'awk: Line ..... cannot have more than 99 fields'.
#     The w/a: Either change the identified line or use a different platform.
#
# Known Restrictions
# ~~~~~~~~~~~~~~~~~~
#  o The script assumes a certain structure to the System State. This means
#    that this cannot be used on systemstates produced by MVS or VM.
#    [To make it work the first two or three words need to be stripped from]
#    [each line in the systemstate trace file.                             ]
#
#  o This has been developed to work with Oracle7. It *may* work with Oracle
#    version 6 but this has not been tested.
#
#  o It looks like there may be a bug with listing processes that are 
#    blocking others because they have a buffer s.o. that others are waiting
#    on.
#
#  o We need to be able to handle multiple-session process state object dumps
#    better. Currently, only the LAST session's wait is used. V1.0.15 will
#    now ignore "last wait for" entries if we have seen a session for this 
#    process beforehand. Still not ideal...
#
#  o Give "possible deadlock" warnings on processes acquiring TM locks in
#    different orders. (Extend to rowcache entries ?).
#
# Coding Notes
# ~~~~~~~~~~~~ 
#  o There's an obscure usage of building the blkres word list. It seems
#    that you cannot just say : blkres[a,b] = blkres[a,b] " " newval
#    You have to use a temporary variable ('tb' in our case) to achieve this.
#  o Sequent doesn't seem to like logical operators being used with regular
#    expressions. Hence the 'wait event' section had to be re-written to use
#    $0 ~ /a/ || $0 ~ /b/. Just try the following test :
#       NR == 1 && /a/ || /b/ { print }
#  o This script has evolved heavily and could now do with a total rewrite
#    (possibly using a faster method such as Perl) for speed and memory
#    consumption improvements. The RDBMS server is getting better in tracking
#    blocking processes so it is probably not worth the effort...
#
# History
# ~~~~~~~
#  kquinn.uk	v1.0.0	04/96	Created
#  kquinn.uk	v1.0.1	04/96	Minor changes to run with nawk on OSF1 and AIX
#                               Blocking Section's output changed slightly
#  kquinn.uk    v1.0.2  04/96   Dumps object names for library objects 
#                               Now sequent-nawk aware                        
#                               First public release
#  kquinn.uk    v1.0.3  06/96   File I/O wait events now output file, block etc
#  kquinn.uk    v1.0.4  07/96   Parallel Query Dequeue Reason codes now output
#  kquinn.uk    v1.0.5  08/96   Added QC to QS code
#                               Added code to skip 'branch of' state objects
#  kquinn.uk    v1.0.5  03/97   Output Oracle command based on 'oct:' code.
#				(Note that only the PARENT session's command
#				 code is output).
#				Strip carriage returns (^M)
#  kquinn.uk    v1.0.6  10/97   Indicate dead processes
#  kquinn.uk    v1.0.7  09/98   Print some more wait information for certain
# 				wait events and handle waits on the sequence
#				enqueue.
#  kquinn.uk    v1.0.8  12/98   Minor changes
#				Changed to accomodate new systemstate format
#				so that we identify the start of a systemstate
#				correctly once more.
#				Added seq# processing for waiting processes.
#				Dumped more info for DFS lock acquisition
#  kquinn.uk    v1.0.9  03/00   Cater for change in 8i enqueue dump
#                               Dump who waits for who according to the 8i
#                               wait "blocking sess" information
#  kquinn.uk    v1.0.10 07/01   sameseq() ignores more irrelevant waits
#                               getasc() function added [assumes ASCII]
#  kquinn.uk    v1.0.11 11/01   Added comment about child latches, detect 9i
#                               trace files, extend sameseq(), print seq info
#                               for processes not in wait and detect end of 
#                               systemstate.
#  kquinn.uk    v1.0.12 12/02   Handle 'rdbms ipc reply' and correctly diagnose
#                               processes blocked by KGL locks.
#  kquinn.uk    v1.0.13 02/03   Warn about aborted state object dumps
#  kquinn.uk    v1.0.14 04/03   Tidy up enqueue info, IPC dump and rowcache info
#                               Other minor changes.
#  kquinn.uk    v1.0.15 08/03   Initial attempt to handle multi-sessions
#                               by ignoring "last wait" entries
#  kquinn.uk    v1.0.16 05/04   Support 9i lock element dumps
#                               Record pin instance lock blockers
#                               Report on libcache load locks
#                               Warn when systemstate level is too low
#                               Catch "dictionary object cache" waits
#                               Handle 10g seq format
#  kquinn.uk    v1.0.17 10/06   Handle mutex state objects
#  kquinn.uk    v1.0.18 02/07   Handle v10.2 BH state object
#  kquinn.uk    v1.0.19 03/07   Capture time of systemstate
#  kquinn.uk    v1.0.20 04/07   Handle 10g wait blocking format
#  kquinn.uk    v1.0.21 04/07   Correct a bug spotted by Alper Ikinci
#  kquinn.uk    v1.0.22 11/07   Initial 11g support
#  kquinn.uk    v1.0.23 02/08   Correct "Blockers According to" processing
#                               Added wait summary
#  kquinn.uk    v1.0.24 02/08   Latch improvements
#  kquinn.uk    v1.0.25 06/08   Mutex changes
#  kquinn.uk    v1.0.26 08/08   Isolate the self-deadlocking resource and
#                               dump rowcache names for later releases
#  kquinn.uk    v1.0.27 09/08   Cygwin portability change
#  kquinn.uk    v1.0.28 11/08   Stop ass.awk when we hit PSEUDO process
#  kquinn.uk    v1.0.29 11/08   Handle enqueue conversion case
#  kquinn.uk    v1.0.30 11/09   Handle newer form of dead processes
#  kquinn.uk    v1.0.31 08/10   Support 11.2 kgl locks/pins
#  kquinn.uk    v1.0.32 12/10   Print warning if "SYSTEM STATE" not seen.
#  kquinn.uk    v1.0.33 11/11   Dump latch waiter information
#  kquinn.uk    v1.0.34 12/11   Handle 11.2 LibraryObjectLoadLock
#  kquinn.uk    v1.0.35 01/13   Print warning if "PROCESS STATE" seen
#                               (if seen -during- systemstate we can stop)
#  kquinn.uk    v1.0.36 06/13   Added usage notes regarding nawk, gawk etc.
#  kquinn.uk    v1.0.37 06/13   Added notes to determine whether the "old" awk
#                               version is being used, which is not supported.
#  kquinn.uk    v1.0.38 07/13   Correctly process Pids with zero (e.g. Pid 200)
#
# Current Enhancement Requests Oustanding
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  o For enqueue conversations, detect when we have another session that is
#    blocked by our enqueue-converting session and highlight this
#  o Handle multiple session better. We could elect to handle all session 
#    state objects or choose the most relevant one (e.g. ones that are in 
#    BSY state or are blocked).
#  o Pick out error code in PQO Queue Ref's
#  o Test concatenating all array elements so that we effectively use singular
#    arrays. This may speed the processing depending upon how the implementation
#    of awk uses multi-dimensional arrays.
#  o Consider dumping a quick "transaction profile" of the database to get
#    an idea about update activity, DDL etc.
#
##############################################################################
# Any failure cases or suggested improvements then please email              #
# kevin.p.quinn@oracle.com with the details and the systemstate file (if     #
# relevant). Thanks.                                                         #
##############################################################################

# Function : add_resource
# ~~~~~~~~~~~~~~~~~~~~~~~
function add_resource (list, item) {        
 if (index(list, item))
   return list;
 else
   return list " " item;
}
# Function : warn_level
# ~~~~~~~~~~~~~~~~~~~~~
function warn_level () {
printf("Warning: No wait information seen - the systemstate level may have\n");
printf("         been too low. Please use 10 or above.\n");
}
# Function : sameseq
# ~~~~~~~~~~~~~~~~~~
function sameseq(ev1, ev2, seq1, seq2) {
 #printf("sameseq: Comparing :\n");
 #printf("Ev=(%s) seq=(%s)\n", ev1, seq1);
 #printf("against Ev=(%s) seq=(%s)\n", ev2, seq2);
 if (!seq1) return 0;
 if (seq1 != seq2) return 0;
 if (ev1 != ev2) return 0;

 if (ev1 ~ "'rdbms ipc message'" ||
#    ev1 ~ "'rdbms ipc reply'"	  ||
     ev1 ~ "'smon timer'"	  ||
     ev1 ~ "Net message from client'" ||
     ev1 ~ "Net message to client'" ||
     ev1 ~ "Net message from dblink'" ||
     ev1 ~ "'pmon timer'")
   return 0;
 return 1;
}
# Function : min
# ~~~~~~~~~~~~~~
function min(one, two) {
 return (one<two?one:two);
}
# Function: hx2dec
# ~~~~~~~~~~~~~~~~
function hx2dec(inhex) {
 _table["A"]=10; _table["B"]=11;_table["C"]=12;_table["D"]=13;_table["E"]=14;
 _table["F"]=15;
 _res = 0;
 _ll = length(inhex);
 for (_i=1; _i<=_ll; _i++)
  {
   _res *= 16;
   _tok=toupper(substr(inhex,_i,1));

   if ("ABCDEF" ~ _tok)
     _res += _table[_tok];
   else
     _res += _tok;   # coerce to numeric

  } # end for

 return _res;
}
# Function : getasc
# ~~~~~~~~~~~~~~~~~
function getasc(_str) {
 _val = hx2dec(_str);
 # Use string comparison to test for a valid value :
 if (_val < 65 || _val > 90 ) return "?";
 return substr(ascii_str,_val-65+1,1);          # ASCII 'A' = 0x41 = 65
}
# Function: procevent
# ~~~~~~~~~~~~~~~~~~~
function procevent (str) {
 if (!eventdetail) return str;  
 realev = str;
 sub("^.* for ", "", str);
 sub("holding ", "", str);
 sub("acquiring ", "", str);
 # printf("DBG> String = '%s'\n", str);
 if (str == "'db file sequential read'"||str == "'db file scattered read'"   ||
     str == "'db file parallel write'" ||str == "'db file sequential write'" ||
     str == "'buffer busy waits'" || str == "'free buffer waits'" ||
     str == "'buffer deadlock'" || str == "'parallel query qref latch'")
  {
   getline; sub("",""); gsub("="," ");
   realev = realev " (" $2 $4 $6 ")";
  }
 else if (str == "'pipe get'")
  {
   getline; sub("","");
   realev = realev " (" $2 ")"; 
  }
 else if (str == "'parallel query dequeue wait'")
  {
   getline; sub("","");
   gsub("="," ");
   realev = realev " (" $2 $4 $6 ")";
   print_pqo = 1;
  }
 else if (str == "'enqueue'" || str == "'DFS lock acquisition'")
  {
   getline; sub("",""); gsub("="," ");
   # For now let's not do anything too clever !
   tm1=getasc(substr($2,1,2));
   tm2=getasc(substr($2,3,2));
   realev = realev " (" tm1 tm2 " id=" $4 $6 ")";
   ############################################
   ### The following tends to crowd the output.
   ############################################
   #else
   # realev = realev " (" $2 $4 $6 ")";
  }
 else if (str == "'rdbms ipc reply'")     # v1.0.12
  {
#    waiting for 'rdbms ipc reply' blocking sess=0x0 seq=2345 wait_time=0
#                from_process=c, timeout=147ada4, =0

   getline; sub("",""); gsub("="," ");
   sub(",","",$2);
   _proc = hx2dec($2);
   realev = realev " (" $1 "=" _proc ")";  
   waitres[sstate, pid] = "IPC " _proc;
   blkres[sstate, "IPC " _proc] = _proc;
  }

 return realev;
}

# Function: pq_details
# ~~~~~~~~~~~~~~~~~~~~
function pq_details(rversion)
{
 split(rversion, _ver, ".");
 printf("\nAdditional Note:\n~~~~~~~~~~~~~~~~\n");
 printf(" A 'parallel query dequeue' wait event has been encountered. The\n");
 printf("arguments to this wait event are described below :\n\n");

 if (_ver[2] < 2)
  {
   printf(" Parameter 1 - Process Queue to Dequeue\n"); 
  }
 else
  {
#  Reasons can be seen in the fixed table X$KXFPSDS.
   printf(" Parameter 1 - Reason for Dequeue. One of (Based upon 7.2.x) :\n");
   printf("  0x01 - QC waiting for reply from Slaves for Parallel Recovery\n");
   printf("  0x02 - Slave Dequeueing for Parallel Recovery\n");
   printf("  0x03 - Waiting for the Join Group Message from new KXFP client\n");
   printf("  0x04 - QC dequeueing from Slaves after starting a Server Group\n");
   printf("  0x05 - Dequeueing a credit only\n");
   printf("  0x06 - Dequeueing to free up a NULL buffer\n");
   printf("  0x07 - Dequeueing to get the credit so that we can enqueue\n");
   printf("  0x08 - Testing for dequeue\n");
   printf("  0x09 - Slave is waiting to dequeue a message fragment from QC\n");
   printf("  0x0a - QC waiting for Slaves to parse SQL and return OK\n"); 
   printf("  0x0b - QC waiting to dequeue (execution reply) msg from slave\n");
   printf("  0x0c - QC waiting to dequeue (execution) msg from slave\n");
   printf("  0x0d - We are dequeueing a message (range partitioned)\n");
   printf("  0x0e - We are dequeueing samples (consumer) from the QC\n"); 
   printf("  0x0f - We are dequeueing a message (ordered)\n");
   printf("  0x10 - Range TQ producer and are waiting to dequeue\n");
   printf("  0x11 - Consumer waiting to dequeue prior to closing TQ\n");
  }

 printf(" Parameter 2 - Sleep Time/Sender Id\n");
 printf("   Time to sleep in 1/100ths of a second\n");
 printf("   If sleeptime greater than 0x10000000, the lower sixteen bits\n");
 printf("   indicate the slave number on the remote instance indicated by\n");
 printf("   the higher sixteen bits of the first 32 bits.\n");

 printf(" Parameter 3 - Number of passes through the dequeueing code\n\n");
 printf(" (This information assumes the trace file has a version number in the header)\n");
 return 0;
}

# Function: pq_qc2slave
# ~~~~~~~~~~~~~~~~~~~~~
#
# Note: If the following line is added in then the awk script causes awk to
#       CORE dump under HP and AIX. The line is designed to make variables have
#       local scope but unfortunately it cannot be used here.
#function pq_qc2slave(state_no       ,_tmp,_temp,_qcarr,_i,_j,_k,_qc,_slaveid)
function pq_qc2slave(state_no)
{
 if (!(_qc = split(qclist[state_no], _qcarr, " ")))
   return;

 printf("\nQuery Co-Ordinator to Query Slave Mapping (system state %d)\n",
    state_no);
 printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");

## TODO: Add a Receiving/Sending message at end of line to denote what we are
##       up to.
#  o Make use of PS enqueues  (PS-instance-slave) (Output them in QC dump ?)
 for (_i=1; _i<=_qc; _i++)
  {
   printf("QC=%5s  [Count=%s]\n", _qcarr[_i], qc_cnt[state_no, _qcarr[_i]]-1);
   for (_j=0; _j<pqenq_cnt[state_no, _qcarr[_i]]; _j++)
    {
#printf("DBG> pqenq[%d, %d] = '%s'\n", _qcarr[_i], _j, pqenq[_qcarr[_i], _j]);
     split(pqenq[_qcarr[_i], _j], _pqtmp, "-");    
     printf("%10s Communicates with Slave %s (hex) on instance %d (%s)\n",  " ",
       _pqtmp[3], _pqtmp[2], pqenq[_qcarr[_i], _j]);
    }

  printf("%5s %8s %3s %8s %11s %11s %5s %7s %8s %4s\n", 
        "Slave", "Info", "Msg", "State", "From", "To", 
		"Type", "Status", "Mode","Err"); 
   for (_j=qc_cnt[state_no, _qcarr[_i]]-1; _j>0; _j--)
    {
     _temp = qc[state_no, _qcarr[_i], _j];
     _slaveid = slave[state_no, _temp]; 
     #printf("DBG: Slaveid = slave[sstate=%d, qref=%s]\n", state_no, _temp);
     _printed = 0;

     for (_k=0; _k<2; _k++)
      {
       _msg = pqdetail[state_no, _slaveid, _k];
       if (!_msg) continue; 
       
       split(_msg, _tmp, " ");

       printf("%5s %8s %3d %8s %11s %11s %5s %7s %8s %4s\n", 
	  _printed?" ":_slaveid, pqenq[_slaveid, 0], _k, _tmp[1], 
	  slave[state_no,_tmp[2]]?slave[state_no, _tmp[2]]:_tmp[2],
	  slave[state_no,_tmp[3]]?slave[state_no, _tmp[3]]:_tmp[3],
         _tmp[4], _tmp[5], _tmp[6], _tmp[7]);
     #printf("DBG: From = slave[sstate=%d, qref=%s]\n", state_no, _tmp[2]);
     #printf("DBG: To   = slave[sstate=%d, qref=%s]\n", state_no, _tmp[3]);
       _printed = 1;
      }
    }
  }

 printf("%*s------------------------\n", 25, " "); 
 printf("STATUS Key:\n");
 printf("  DEQ = buffer has been dequeued\n");         
 printf("  EML = buffer on emergency message list\n"); 
 printf("  ENQ = buffer has been enqueued\n");
 printf("  FLST= buffer is on SGA freelist\n");
 printf("  FRE = buffer is free (unused)\n");
 printf("  GEB = buffer has been gotten for enqueuing\n");
 printf("  GDB = dequeued buffer has been gotten \n");
 printf("  INV = buffer is invalid (non-existent)\n");
 printf("  QUE = buffer on queue message list\n");
 printf("  RCV = buffer has been received \n"); 
 printf("  NOFL= not on freelist (just removed)\n");

 printf("%*s------------------------\n", 30, " "); 
#                    KXFPMTYINV  0 - Invalid message (new buffer).         [INV]
#                    KXFPMTYNUL  1 - Null message, used to send credit.    [NUL]
#                    KXFPMTYJOI  2 - Join group, from QC to slaves.        [JOI]
#                    KXFPMTYERR  3 - Exiting group from slave to QC.       [ERR]
#                    KXFPMTYRQS  4 - Request for statistics, QC to slaves. [RQS]
#                    KXFPMTYSTA  5 - Statistics update, slaves to QC.      [STA]
#                    KXFPMTYDTA  6 - User data, stuff kxfp doesn't look at.[DTA]
#                    KXFPMTYJVR  7 - Slave to QC, ack and version number.
#          KXFPHSTRE :  0x01 - Stream mode, return credit immediately.    [STRE]
#          KXFPHDIAL :  0x02 - Dialog mode, expect a reply message.       [DIAL]
#          KXFPHNPNG :  0x04 - No pings, error if next message pings.     [NPNG]
#          KXFPMHPRI :  0x08 - Priority (JOIn|ERRor|EXIt) message.         [PRI]
#          KXFPMHSTP :  0x10 - Stream ping message. @@                     [STP]
#          KXFPMHNDS :  0x20 - Non-default sized buffer.                   [NDS]
#          KXFPMHCLR :  0x40 - Sent from a clear qref.                     [CLR]
#          KXFPMHNID :  0x80 - No implicit dequeue.                        [NID]
}

##############################################################################
#                   S T A R T   O F   P R O C E S S I N G                    #
#                                                                            #
# BEGIN Section: 							     #
#  Can amend 'interactive', 'verbose','skipmsess' and 'eventdetail'.         #
##############################################################################
BEGIN		{ version="1.0.38"; lwidth=79; interactive=1; verbose=1;
		  eventdetail=1; skipbranch=1; seqinfo=1; skipmsess=0;
                  waitsummary=1; waitsummary_thresh=10;
                  EQCNV=2;
 util_url="http://dlsunuk11.uk.oracle.com/Public/Utils.html#ass";
 doc_url ="http://dlsunuk11.uk.oracle.com/Public/TOOLS/Ass.html";
 emailid ="kevin.p.quinn@oracle.com"; 
 TERM="------------------ooOoo------------------";
 tx1="Above is a list of all the processes. If they are waiting for a resource";
 tx2="then it will be given in square brackets. Below is a summary of the";
 tx3="waited upon resources, together with the holder of that resource.";
 tx4="Notes:\n\t~~~~~";
 tx5=" o A process id of '???' implies that the holder was not found in the";
 tx6="   systemstate. (The holder may have released the resource before we"; 
 tx7="   dumped the state object tree of the blocking process).";
 tx8=" o Lines with 'Enqueue conversion' below can be ignored *unless* ";
 tx9="   other sessions are waiting on that resource too. For more, see ";
 tx10="   http://dlsunuk11.uk.oracle.com/Public/TOOLS/Ass.html#enqcnv)";
 br1="WARNING: The following is a list of process id's that have state";
 br2="         objects that are NOT owned by the parent state object and as";
 br3="         such have been SKIPPED during processing. (These are typically";
 br4="         SQL*Net loopback sessions).";

 abort_err="WARNING: The following processes had a corrupted / in-flux state object tree :";

 cmdtab[1]="Create Table"; cmdtab[2]="Insert";cmdtab[3]="Select";
 cmdtab[4]="Create Cluster";cmdtab[5]="Alter Cluster";cmdtab[6]="Update";
 cmdtab[7]="Delete";cmdtab[8]="drop Cluster";cmdtab[9]="Create Index";
 cmdtab[10]="Drop Index";cmdtab[11]="Alter Index";cmdtab[12]="Drop Table";
 cmdtab[13]="Create Sequence";cmdtab[14]="Alter Sequence";
 cmdtab[15]="Alter Table";cmdtab[16]="Drop Sequence"; 
 cmdtab[17]="Grant";cmdtab[18]="Revoke";cmdtab[19]="Create Synonym";
 cmdtab[21]="Create View";cmdtab[22]="Drop View";
 cmdtab[24]="Create Procedure";cmdtab[25]="Alter Procedure";
 cmdtab[25]="ALter Procedure";cmdtab[40]="Alter Tablespace";
 cmdtab[42]="Alter Session";cmdtab[44]="Commit";cmdtab[45]="Rollback";
 cmdtab[47]="PL/SQL Execute";cmdtab[50]="Explain"; cmdtab[53]="Drop User";
 cmdtab[54]="Drop Role";cmdtab[62]="Analyze Table"; cmdtab[63]="Analyze Index";
 cmdtab[64]="Analyze Cluster";cmdtab[67]="Alter Profile"; 
 cmdtab[68]="Drop Procedure";cmdtab[85]="Truncate Table";
 cmdtab[88]="Alter View";cmdtab[94]="Create Pkg";cmdtab[95]="Alter Pkg";
 cmdtab[170]="Call Method"; cmdtab[189]="Upsert";

 ascii_str="ABCDEFGHIJKLMNOPQRSTUVWXYZ";

 ## Child latch Warning array 
 cw[0]="Some processes are being blocked waiting for child latches.\n";
 cw[1]="At the moment this script does not detect the blocker because the";
 cw[2]="child latch address differs to the parent latch address. To manually";
 cw[3]="detect the blocker please take the following steps :";                
 cw[4]="1. Determine the TYPE of latch (Eg library cache) that is involved."; 
 cw[5]="2. Search the source trace file for a target of :";
 cw[6]="         holding.*Parent.*library cache";
 cw[7]="   (Assuming we have a child library cache and have vi-like regular expressions)\n";
 cw[8]="If this shows nothing then the blocker may have released the resource";
 cw[9]="before we got to dump the state object tree of the blocked process.\n";
cw[10]="A list of processes that hold parent latches is given below :\n";
 CHILD_WARN=11;

pstr[0]="The following processes have the PIN INSTANCE LOCK set in a way in";
pstr[1]="which other pin requesters may be blocked. Please use the 'id='";
pstr[2]="column to correlate potential blockers across nodes.";
}

# Start of trace file
# ~~~~~~~~~~~~~~~~~~~
# Oracle7 Server Release 7.1.6.2.0 
# Oracle8 Enterprise Edition Release 8.0.5.0.0
/^Oracle7 Server Release 7\./	{ rdbms_ver = $4; next }
/^Oracle8 .* .* Release 8\./	{ rdbms_ver = $5; next }
/^Oracle8i /			{ rdbms_ver = $(NF-2); a8ienabled=1; next }
/^Oracle9i /			{ rdbms_ver = $(NF-2); 
                                  a9ienabled= a8ienabled=1; next }
/^Oracle10i /			{ rdbms_ver = $(NF-2); 
                                  a10ienabled=a9ienabled=a8ienabled=1; next }
/^Oracle Database 10g/		{ sub("^Oracle.*Release ", "");
                                  rdbms_ver = $1;
                                  a10genabled=a10ienabled=a9ienabled=1;
                                  a8ienabled=1; next }
# Strip Carriage returns
//				{ sub("",""); }

# Timestamp assumed to be of the form:
# 
# *** 2007-03-14 15:11:20.646
# *** SESSION ID:(25.119) 2008-03-07 05:27:02.885
#
# See ksdddt() which prints this form regardless of NLS settins

# Use a pattern that should be "good enough"
/^\*\*\* [12][0-9]*-[0-9]*-[0-9]* [0-9]*:.*:/ { tempts=$2 " " $3; next }
/^... SESSION ID:/		{ tempts=$4 " " $5; next }
				  
# Start of Systemstate
# ~~~~~~~~~~~~~~~~~~~~
/^SYSTEM STATE/		{ printf("\nStarting Systemstate %d\n", ++sstate);
                          tstamp[sstate] = tempts;
                          # Even tho' we don't need to initialise scalers 
			  # before they are referenced (they implicitly default
			  # to 0) it seems that we must do this for arrays.
			  platch[sstate] = 0;
			  lcount=1; insystate=1; inbranch=0; next }

/^END OF SYSTEM STATE/  { insystate=0; next }
/^PSEUDO PROCESS for group/	{ insystate=0; next }
/^PROCESS [1-9][0-9]*:/		{ tmpid=$2; sub(":","", tmpid);
                                  numpid = tmpid+0; #coerce
                                  if (numpid>hipid) hipid=numpid; 
				}

# Skipped Lines
# ~~~~~~~~~~~~~
insystate!=1			{ next }
                                # Used for PQO--flds 1 and two are good enuf
				# Do NOT skip additional processing (ie no next)
# v1.0.9 - We need to save session state objects
/^ *SO:/			{ myso=$2; 
  			          getline; sub("",""); sotype=$1 " " $2; }

# record the last pid seen. If we haven't seen one then we don't care.
/^PROCESS STATE/		{ insystate=0; 
                                  pstate_seen[sstate]=numpid; 
                                  next; 
                                }
/SHUTDOWN: waiting for logins to complete/	{ next }

# Code to skip 'branch of' state objects which are caused by silly things 
# such as SQLNET loopback sessions 
skipbranch && inbranch > 0	{ tmp = $0;
				  sub(branchstr, "", tmp);
				  if (tmp !~ "^ ")
				    inbranch = 0;
				}
				    
/^  *branch of *$/		{ if (skipbranch)
				   {
				    sub("branch of.*", ""); branchstr="^" $0;
				    inbranch=length(branchstr); 
				    branchlst[sstate]=branchlst[sstate] " " pid;
         			    next 
				   }
				}

# Start of New Process
# ~~~~~~~~~~~~~~~~~~~~ 
/PROCESS [1-9][0-9]*:/		{ pid=$2; 
                                  inbranch=0;
				  # Need to use pidarray to avoid "holes"
				  # in processes causing us problems.
				  pidarray[sstate, ++pidcnt[sstate]] = pid;
				  handle=""; inpq = 0; 
				  # v1.0.9 - keep max pid for use with a8iblk[]
				  if (numpid > maxpid) maxpid = numpid;
				  if (!interactive) next;
				  if (++lcount > lwidth) lcount=1;
				  printf("%s", lcount==1? "\n.":".");
				  next }
# Oracle Command
# ~~~~~~~~~~~~~~
# oct: 3, prv: 0, user: 221/MRCHTMH
/^ *oct: .*, prv:/		{ tmp=$2; sub(",", "",tmp);
				  # Only output the parent session's command.
				  if (!oct[sstate, pid]) oct[sstate, pid]=tmp;
				  next }

# Aborted State Object Dump
# ~~~~~~~~~~~~~~~~~~~~~~~~~
# Let's just assume one aborted state object tree per session for now
/^Aborting this subtree dump/	{ aborted[pid] = NR; 
			          abort_seen[sstate] = 1;
                                  ablist[sstate] = ablist[sstate] " " pid;
                                  next; }

# Capture Seq
# ~~~~~~~~~~~
# last wait for 'db file sequential read' seq=39279 wait_time=4

/waiting for .*seq=.*wait_time/ { if (seqinfo)
                                   {
                                    tmp = $0;
                                    sub("^.*seq", "seq", tmp);
                                    sub("wait.*$", "", tmp);
				    seq[sstate, pid] = tmp;
                                   }
## v1.0.9 - See if we have the new 8i "blocking sess" token and store this
##          for later use as well.
#
# waiting for 'enqueue' blocking sess=0x800618a4 seq=173 wait_time=0
#             name|mode=54580006, id1=10021, id2=a
#
## v1.0.23 - Format changed so need to isolate the session differently
#

                                  if ($0 ~ "blocking sess=" &&
    				      $0 !~ "blocking sess=0x0" &&
                                      $0 !~ "blocking sess=0x.nil")
				   {
                                    tmp = $0;
                                    sub("^.*sess=", "", tmp);
                                    sub(" .*$", "", tmp);
                                    sub("0x", "", tmp);
				    a8iblk[sstate, numpid] = tmp;
		#printf("DBG> a8iblk[%d, %d] = '%s'\n", sstate, numpid, tmp);
				   }

                                  if (waitsummary)
                                  {
                                    tmp = $0;
                                    sub("^.*waiting for '", "", tmp);
                                    sub("'.*$", "", tmp);
                                    gsub(" ", "_", tmp);
                                   
                                    waitsum[sstate, tmp]++;
                                    if (!index(waitlist[sstate], tmp))
                                      waitlist[sstate]=waitlist[sstate] " " tmp;
                                  }
				}

## v1.0.14 - Remove the following code otherwise we will report that these
##           processes are "stuck" when they are not, they are busy doing
##           something!
#/last wait for '/		{ if (seqinfo)
#				  seq[sstate, pid] = $(NF-1);
#				}

## v1.0.9 - To make use of a8iblk array we need to capture the session state
##          object.

# Capture Session S.O. (for use with 8i)
# ~~~~~~~~~~~~~~~~~~~~
# SO: 800620e4, type: 3, owner: 80053418, flag: INIT/-/-/0x00
# (session) trans: 801382dc, creator: 80053418, flag: (41) USR/- BSY/-/-/-/-/-
#
# v1.0.23. (session) line changed to:
# (session) sid: 4332 trans: 0, creator: 10600193b0, flag: (40000041) ...

/^ *.session. .* trans/		{ tmp = myso; sub(",", "", tmp);
 			          a8isess[sstate, tmp] = numpid; 
                  #printf("DBG> a8isess[%d, '%s'] = %d\n", sstate, tmp, numpid);
                                }

# Wait Event Information
# ~~~~~~~~~~~~~~~~~~~~~~
#  Gather the current wait event information for a simple overview of the
# 'Waiter' information summarised at the end.
#

# v1.0.22: Convert 11g format to pre-11g format
$0 ~ "^ *[0-9]*: *waiting for .*'" { sub("[0-9]*:", ""); }

$0 ~ "last wait for .*'"   ||
$0 ~ "acquiring .*'"	|| 
$0 ~ "^ *waiting for .*'" ||
$0 ~ "holding .*'"       	{ # v1.0.15: detect multiple sessions
				  if (wait_event[sstate, pid])
				   {
				    msess[sstate] = add_resource(msess[sstate],
							pid);
				    # ignore non-waiting sessions
				    if ($0 ~ "last wait for") next;
				    
				   }
                                  tmp=$0;
                                  # Just keep event name
				  sub("' .*$", "'", tmp);  
				  sub("^ *","", tmp);
				  wait_event[sstate, pid] = procevent(tmp);
                                }

/^ *holding .*Parent.*level=/	{ pl_pid[sstate, platch[sstate]] = pid;
                                  tmp=$0;
				  sub("^ *holding *","", tmp);
			  	  pl_str[sstate, platch[sstate]] = tmp;
			          platch[sstate]++; }

# Spot Dead Processes
# ~~~~~~~~~~~~~~~~~~~
# (process) Oracle pid=6, calls cur/top: 22060e34/22060e34, flag: (3) DEAD
/(process).*flag:.*DEAD/	{ isdead[sstate,pid]=1; }
# newer form:
# O/S info: user: oracle, term: UNKNOWN, ospid: 8687 (DEAD)
/ospid:.*DEAD/			{ isdead[sstate,pid]=1; }

# RESOURCE: Latch
# ~~~~~~~~~~~~~~~
# Example:
#   waiting for  80108e04 shared pool level=7 state=free
#      wtr=80108e04, next waiter 0
#   holding     80108eec library cache pin level=6 state=busy
#
/^ *waiting for *[a-f0-9][a-f0-9]* /	{ waitres[sstate, pid] = "Latch " $3; 	
                                  if (verbose)
                                  {
				    if (!objname[sstate, "Latch " $3])
				    {
				     tmp = $3;
				     sub("^ *waiting for *[a-f0-9]* ","");
				     sub(" level.*$","");
				     objname[sstate, "Latch " tmp] = $0;

				     curlatch = "'" $0 "'"; # used later
				    }
				    else curlatch=objname[sstate, "Latch " $3];
                                  }
				  next }

# v1.0.24: With later versions (10g) we can -also- see this form:
#
#  holding    (efd=6) 380142c78 Child shared pool level=7 child#=5
#
# so strip out the (efd=.*)

/^ *holding *.efd=/		{ 
                                  sub(" .efd=[0-9][0-9]*. ", " ");
                                }
/holding *[a-f0-9]* /		{ tb = blkres[sstate, "Latch " $2];
				  tb = add_resource(tb,pid);
				  blkres[sstate, "Latch " $2] = tb;
				  if (verbose && !objname[sstate, "Latch " $3])
				   {
				    tmp = $3;
				    sub("^ *holding *[a-f0-9][a-f0-9]* ","");
				    sub(" level.*$","");
				    objname[sstate, "Latch " tmp] = $0;
				   }
				  next }
/acquiring *[a-f0-9]* /		{ tb = blkres[sstate, "Latch " $2];
                                  tb = add_resource(tb,pid);
				  blkres[sstate, "Latch " $2] = tb;
				  if (verbose && !objname[sstate, "Latch " $3])
				   {
				    tmp = $3;
				    sub("^ *acquiring *[a-f0-9]* ","");
				    sub(" level.*$","");
				    objname[sstate, "Latch " tmp] = $0;
				   }
                                  next }

# v1.0.33 - Dump additional latch wait information, if present
#
# waiters [orapid (seconds since: put on list, posted, alive check)]:
#   1410 (3889, 1318434741, 3889)
#   1374 (3889, 1318434741, 3889)
#   1437 (3889, 1318434741, 3889)
#   ..
#   waiter count=257
#  gotten 4101002 times wait, failed first 71496 sleeps 59303
#  gotten 0 times nowait, failed: 0
# possible holder pid = 1383 ospid=27748

/^ *waiter count=[1-9]/	{ if (!verbose) next; 

			  gsub("^ *waiter count=", "");
			  wcnt = $0+0;		# coerce to numeric

			  getline;getline;getline;
			  if ($0 ~ "possible holder pid")
			  {
		            gsub("^.*=", "");
			    wtrpid=$1;
			    gsub(".* ospid=.*", "");
			    wtrospid=$0;     # might be a string on some OS
			  }
			  else wtrpid = -1;

			  wtrcount[sstate]++;
                          wtrtmp=sprintf("Pid %d is blocked waiting for latch",
				pid);
                          wtrtmp=sprintf("%s %s with %d waiters.", 
                                 wtrtmp, curlatch, wcnt);
                          if (wtrpid != -1)
                            wtrtmp=wtrtmp "\nPossible holder is Pid " wtrpid ".";
			  wtrstr[sstate, wtrcount[sstate]] = wtrtmp;
			}
			  


# RESOURCE: Enqueue
# ~~~~~~~~~~~~~~~~~
# Example:
#  (enqueue) TX-00030007-00004170
#  lv: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
#  res:c07c3e90, mode: X, prv: c07c3e98, sess: c1825fc8, proc: c180d338
#
/\(enqueue\) <no resource>/	{ next }   # Skip this

/\(enqueue\)/			{ tmp = $2;
                                  eqres = "Enq " tmp;
				  getline; getline; sub("","");

## v1.0.9 - Under 8i we now print a space following the "res:" token above
##          which means that we can no longer rely on word position so let's
##          just search for the fact that the line CONTAINS "mode:" or 
##          "req:". 

## V1.0.29:
## Sometimes a session might be in the process of converting a lock which
## would appear as follows:
##
##      (enqueue) TM-000063A0-00000000  DID: 0001-0024-0000075B
##      lv: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  res_flag: 0x7
##      res: 0x3fe7eb850, mode: SX, req: SSX, lock_flag: 0x0
## 
## Our session both blocks and is blocked and prior to V1.0.29 it would be
## reported as a self-deadlock. We still need to record the blocked and 
## is-blocked for comparison with other sessions but lets record the fact
## that we are converting and then avoid the bogus self-deadlock message.

                                  mode_seen = req_seen = 0;
				  if ($0 ~ "mode:")
				   {
                                    mode_seen = 1;
				    tb = blkres[sstate, eqres];
				    tb = add_resource(tb , pid);
				    blkres[sstate, eqres] = tb;
				    if (substr(tmp,1,2)=="PS")
				     {
				      tb = pqenq_cnt[sstate, pid]++;
				      tmp1 = tmp;
				      gsub("-0*","-0", tmp1);
				      pqenq[pid, tb] = tmp1;
				     }
				   }

				  if ($0 ~ "req:")
                                  {
                                    req_seen = 1;
				    waitres[sstate, pid] = eqres;
                                  }

## The code below tries to record the correct state to determine whether this
## might be a blocker. If we -ever- see just a mode: or a req: then we are
## potentially interested in the session so we ignore any other enqueue
## conversion on this resource. If we see -both- a mode: and a req: then we
## set this as an enqueue conversion iff we haven't seen a previous enqueue
## conversion on this resource. 

                                  if (mode_seen && req_seen)
                                  {
                                    if (!eqconv[sstate, pid, eqres])
                                      eqconv[sstate, pid, eqres] = EQCNV;
                                    else
                                      eqconv[sstate, pid, eqres] = EQCNV+1;
                                  }
                                  else if (mode_seen || req_seen)
                                    eqconv[sstate, pid, eqres] = EQCNV+1;
                                   
## V1.0.29: mode isn't correct with more recent versions and isn't reported
##          so let's just comment it out for now.
                                  # sub(", prv.*$", "");
				  # mode[sstate, pid, tmp] = $NF; 
				  next }

# RESOURCE: Row Cache Enqueue
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Example:
#  row cache enqueue: count=1 session=c1825fc8 object=c146e960, request=S
#  row cache parent object: address=c146e960 type=9(dc_tables)
#
/row cache enqueue:.*mode/	{ tb = blkres[sstate, "Rcache " $6];

				  tb = add_resource(tb, pid);
				  blkres[sstate, "Rcache " $6] = tb;
				  if (verbose && !objname[sstate, "Rcache " $6])
				   {
				    mode[sstate, pid, $6] = $7;
				    tmp = $6; getline; sub("","");
                                    # Oracle version 10 introduced another line
                                    if ($0 !~ "row cache parent object")
                                    {
				      getline; sub("","");
                                    }
				    objname[sstate, "Rcache " tmp] = $6;
				    sub(".*type=.*dc_", "(dc_",
					objname[sstate, "Rcache " tmp]);
				   }
				  next }

/row cache enqueue:/		{ waitres[sstate, pid] = "Rcache " $6;
				  if (verbose && !objname[sstate, "Rcache " $6])
				   {
				    mode[sstate, pid, $6] = $7;
				    tmp = $6;
				    getline; sub("","");
                                    # Oracle version 10 introduced another line
                                    if ($0 !~ "row cache parent object")
                                    {
				      getline; sub("","");
                                    }
				    objname[sstate, "Rcache " tmp] = $6;
				    sub(".*type=.*dc_", "(dc_",
					objname[sstate, "Rcache " tmp]);
				   }
				  next }

# RESOURCE: Mutex
# ~~~~~~~~~~~~~~~
# Example:
#     KGX Atomic Operation Log 0x263407c8
#      Mutex 0x2587ea64(0, 1) idn 22373e0c oper SHRD
#      Cursor Pin uid 29 efd 0 whr 5 slp 0
#      opr=4 pso=0x263f8674 flg=0
#      pcs=0x2587ea64 nxt=(nil) flg=25 cld=0 hd=0x267b6368 par=0x2587e860
#      ct=1 hsh=0 unp=(nil) unn=0 hvl=2587e744 nhv=1 ses=0x29154334
#      hep=0x2587eaac flg=80 ld=1 ob=0x2586bbe0 ptr=0x25867010 fex=0x25866ff8

/^ *Mutex \(nil\)/ { next; }

# We have a mutex holder if we see "Mutex 0x2587ea64(0, 1)" where
#                      this field is not 0  ---------+
/^ *Mutex/	{ mxmode=$NF; 
                  hldr=$2;
                  # v1.0.27: The previous version tried to use the code:
                  #          sub("^.*\(", "", hldr);
                  # but this isn't portable (it fails on Cygwin) and isn't
                  # strictly correct. See
                  # http://www.gnu.org/manual/gawk/html_node/Gory-Details.html
                  #
                  # For now, let's just use index() and substr().

                  ## printf("hldr was '%s', but now ", hldr);
                  sub(",", "", hldr);
                  ## printf(" =>'%s' and lastly ", hldr);
                  brket = index(hldr, "(");
                  ## printf("(brk=%d) ", brket);
                  if (brket) brket++;          # bump passed the '('
                  hldr = substr(hldr, brket);
                  ## sub("^.*\x28", "", hldr);
                  ## sub("^.*\(", "", hldr);
                  ## printf("'%s'\n", hldr);
 		  sub("^.*idn ", "");
		  mid=$1;
                  # We have: GET_SHRD, SHRD, SHRD_EXAM, REL_SHRD, GET_EXCL,
		  # EXL, REL_EXCL, GET_INCR, INCR_EXAM, GET_DECR, DECR_EXAM,
		  # RELEASED, EXCL_SHRD, GET_EXAM, EXAM
                  if (mxmode ~ "GET_")
                   {
                    waitres[sstate, pid] = "Mutex " mid;
                   }
		  else if (hldr != "0" && mxmode != "NONE")
		   {
		    tb = blkres[sstate, "Mutex " mid];
                    tb = add_resource(tb, pid);
                    blkres[sstate, "Mutex " mid] = tb;
                   }
                 }

# RESOURCE: Dictionary Object Cache Enqueue
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Example:
#     dictionary object cache enqueue
#     address: 7000002754e8858 next: 7000002754e88b8 prev: 700000000020038
#     process: 7000002623f2400 state: WAIT

/^ *dictionary object cache enqueue/ { getline; getline;
				       if ($NF == "REPL")
                                        {
                                         tb = blkres[sstate, "DictObj"];
                                         tb = add_resource(tb, pid);
                                         blkres[sstate, "DictObj"] = tb;
                                        }
                                       else
                                        {
                                         waitres[sstate, pid] = "DictObj";
                                        }
                                       next;
				     }

# RESOURCE: Library Object Load Lock
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Example:
#         LIBRARY OBJECT LOAD LOCK: lock=c00000007a366fe8
#         process=c000000077bc1148 object=c00000007baac6c8 request=X mask=0101
#
# Or, under 11.2.0.2:
# 
# LibraryObjectLoadLock: Address=0x213259120 User=0x24ebb79e0 Handle=0x2135c2900
# Mode=X Mask=0001 LockCount=0       
#
# Due to bug 13447674, we might not have a RequestMode=.. value so use Mode=
# to determine holder and the absence of Mode= to indicate waiter

/LIBRARY OBJECT LOAD/	{ getline;
                          gsub("=", " ");
                          if ($5 == "request")
                           {
                            waitres[sstate, pid] = "LOAD: " $4;
                            mode[sstate, pid, $4] = $6;
                           }
                          else
                           { 
			    tb = blkres[sstate, "LOAD: " $4];
			    tb = add_resource(tb, pid);
		            blkres[sstate, "LOAD: " $4] = tb;
			    mode[sstate, pid, $4] = $6; 
                           }
                        }

/^ *LibraryObjectLoadLock:/ { gsub("=", " ");
                              if ($0 ~ "Mode")
                              {
                                tb = blkres[sstate, "LOAD: " $7];
                                tb = add_resource(tb, pid);
                                blkres[sstate, "LOAD: " $7] = tb;
                                mode[sstate, pid, $7] = $9; 
                              }
                              else
                              {
                               waitres[sstate, pid] = "LOAD: " $7; 
                               mode[sstate, pid, $7] = $9;
                              }
                           }

# RESOURCE: Library Object Pin/Lock
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Example:
#  LIBRARY OBJECT PIN: pin=c0f3aa90 handle=c15bcac0 mode=S lock=c0f3b840
#  LIBRARY OBJECT LOCK: lock=c0f3b840 handle=c15bcac0 mode=N
#
/LIBRARY OBJECT .*mod/		{ if ($6 != "mode=N") # Ignore Null locks
                                   {
				    tb = blkres[sstate, $3 " " $5];
				    tb = add_resource(tb, pid);
			            blkres[sstate, $3 " " $5] = tb;
				    mode[sstate, pid, $5] = $6; 
				    next;
                                   }
                                }

/LIBRARY OBJECT .*req/		{ waitres[sstate, pid] = $3 " " $5;
				  mode[sstate, pid, $5] = $6; next }

# 11g Example:
#   LibraryObjectLock:  Address=7b6910a0 Handle=7b65e758 Mode=X ...
#   LibraryObjectLock:  Address=7b709208 Handle=7b6c22a0 RequestMode=X
#   LibraryObjectPin: Address=7b6f9ab8 Handle=7b65e758 Mode=X ..

/^ *LibraryObjectLock: .* Mod/	{ if ($4 != "Mode=N") # Ignore Null locks
                                   {
				    tb = blkres[sstate, "LOCK: " $3];
				    tb = add_resource(tb, pid);
			            blkres[sstate, "LOCK: " $3] = tb;
				    mode[sstate, pid, $3] = $4; 
				    next;
                                   }
                                }

/^ *LibraryObjectLock: .*Req/	{ waitres[sstate, pid] = "LOCK: " $3;
                                  mode[sstate, pid, $3] = $4; next }

/^ *LibraryObjectPin: .* Mod/	{ if ($4 != "Mode=N") # Ignore Null locks
                                   {
				    tb = blkres[sstate, "PIN: " $3];
				    tb = add_resource(tb, pid);
			            blkres[sstate, "PIN: " $3] = tb;
				    mode[sstate, pid, $3] = $4; 
				    next;
                                   }
                                }

/^ *LibraryObjectPin: .*Req/	{ waitres[sstate, pid] = "PIN: " $3;
                                  mode[sstate, pid, $3] = $4; next }

/Rel-Stack=/			{ kglstack=1; }

# RESOURCE: Pin instance lock
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
#       LOCK INSTANCE LOCK: id=LB3791b1418e1e06ff
#       PIN INSTANCE LOCK: id=NB3791b1418e1e06ff mode=S release=T flags=[00]
#       INVALIDATION INSTANCE LOCK: id=IV006ed60b11172935 mode=S

/^ *PIN INSTANCE LOCK:.*release=T/ { tcnt = pinins[sstate];
                                     # are we a new process ? If so, bump count
                                     if (pinins_pid[sstate, tcnt] != pid)
                                      {
                                       tcnt = ++pinins[sstate];
                                       pinins_pid[sstate, tcnt] = pid;
                                      }
                                     pinins_pin[sstate, pid] = add_resource(pinins_pin[sstate, pid], $4);
                                   }

# RESOURCE: Cache Buffer
# ~~~~~~~~~~~~~~~~~~~~~~
# Example:
#   (buffer) (CR) PR: 37290 FLG:    0
#   kcbbfbp    : [BH: befd8, LINK: 7836c] (WAITING)
#   BH #1067 (0xbefd8) dba: 5041865 class 1 ba: a03800
#     hash: [7f2d8,b47d0],  lru: [16380,b1b50]
#     use:  [78eb4,78eb4], wait: [79cf4,78664]
#     st: READING, md: EXCL, rsop: 0
#     cr:[[scn: 0.00000000],[xid: 00.00.00],[uba: 00.00.00], sfl: 0]
#     flags: only_sequential_access
#     L:[0.0.0] H:[0.0.0] R:[0.0.0]
#     Using State Objects
#
/^ *kcbbfbp/		{ if (a10genabled)
                          {
                            blmode = $6;  # 'kcbbfbp :' became 'kcbbfp:'
			    getline; getline; sub("","");
			    dba = $6; 
                          }
                          else
                          {
                            blmode = $7;
			    getline; sub("","");
			    dba = $5; 
                          }
                          # We might dump state objects in use which doesn't
                          # have a line with "BH " in it. If this is the case
                          # then stop processing now. (See 10.2.0.3 example).
                          if ($0 !~ "BH ")
                           next;

			  if ( blmode == "(WAITING)" || blmode == "EXCLUSIVE" )
			    waitres[sstate, pid] = "Buffer " dba;
			  else
			   {
			    tb = blkres[sstate, "Buffer " dba];
			    tb = add_resource(tb, pid);
			    blkres[sstate, "Buffer " dba] = tb;
			   }
			  mode[sstate, pid, dba] = blmode; 
			  next; }

# RESOURCE: Lock Element Dump
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# pre-9i Example:
#   LOCK CONTEXT DUMP (address: 0x90ceab20):
#   op: 2 nmd: EXCLUSIVE  dba: 0x5400004f cls: DATA       cvt: 0 cln: 1
#      LOCK ELEMENT DUMP (number: 14048, address: 0x91212498):
#      mod: NULL       rls:0x00 acq:03 inv:0 lch:0x921a366c,0x921a366c
#      lcp: 0x90ceab20 lnk: 0x90ceab30,0x90ceab30

#
# Complete: Always assumes waiting AND just identifies one resource !!
#
#
# 9i Example:
#     LOCK CONTEXT DUMP (address: 0x5f720b778):
#     op: 3 nmd: S tsn: 6 rdba: 0xd300e0fb cls: DATA type: 1
#       GLOBAL CACHE ELEMENT DUMP (address: 0x3f0fb07a0):
#       id1: 0xd2c0e0fb id2: 0x8000 lock: SG rls: 0x000 acq: 0x01
#                                         ^^
#    this is actually two strings. kcllemode and kcllelocal. The first is the
#    lock mode and the second a one letter code to denote a [G]lobal or [L]ocal
#    lock.

/LOCK CONTEXT DUMP/	{ getline; sub("",""); isnull = 0; 
			  if ($4 == "NULL" ||
                              (a9ienabled && $4 == "N")) isnull = 1; 
			  wantmode = $4;
			  getline; sub("","");
                          if (a9ienabled)
			    tmp = "Elem " $6; 
                          else
			    tmp = "Elem " $5; 
			  if (!isnull)
			    waitres[sstate, pid] = tmp;
			  else
			    blkres[sstate, tmp] = pid;
			  if (!verbose) next;
			  getline; sub("","");
      
                          # For 9i+ just use the entire lock code even tho'
                          # it has a G or L appended to denote the lock scope
                          if (a9ienabled)
			    mode[sstate, pid, tmp] = $6;
                          else
			    mode[sstate, pid, tmp] = $2;
		  	  getline; getline; getline; getline;getline;getline;
			  sub("","");
			  tb = objname[sstate, tmp] " ";
			  tb = tb $2;
			  objname[sstate, tmp] = tb;
			  next }

##
## Verbose Processing
##
verbose != 1		{ next }

# Handle to Object Mapping (Verbose mode)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Example:
#     LIBRARY OBJECT HANDLE: handle=40e25e08
#     name=TEST.CRSMESSAGELOG
#     hash=e2deff52 timestamp=11-22-1995 17:53:55
#     namespace=TABL/PRCD flags=TIM/SML/[02000000]

/LIBRARY OBJECT HANDLE:/	{ # next; # Just skip for now
				  handle=$4; getline; sub("","");
				  if (objname[sstate, handle]) next;
				  # Skip child cursors for now.
				  if ($0 ~ "namespace=") next;
				  sub("^ *name=","");
				  if (!$0) getline; sub("","");
				  txt = $0;
				  while ($0 !~ "namespace") getline; 
				  sub("",""); type=$1;
				  sub("namespace=","",type);
				  objname[sstate, handle] = type ":" txt;
				  next }

# v1.0.22: Handle new 11g format

# Example:
#       LIBRARY HANDLE:0x29472d38 bid=11645 hid=351c2d7d lmd=S pmd=S sta=VALD
#       name=TC.TEST   
#       hash=525f272508994441bd41310f351c2d7d idn=60479
#       tim=11-27-2007 12:10:24        kkkk-dddd-llll=0000-0741-0741
#       exc=0 ivc=0 ldc=4 cbb=8 rpr=4 kdp=0 slc=1 dbg=0
#       dmtx=0x29472d94(0, 336, 0) mtx=0x29472db8(0, 78722, 0)
#       nsp=TABL(01) typ=TABL(02) llm=0 flg=KGHP/TIM/SML/[0200e800]

/LIBRARY HANDLE:/	{ sub("HANDLE:", "HANDLE: ");
                          handle=$3; getline; sub("","");
			  if (objname[sstate, handle]) next;
			  # Skip child cursors for now.
			  if ($0 ~ "name=") 
                           {
			     sub("^ *name=","");
			     if (!$0) txt = "Unknown";
			     else txt = $0;
			     while ($0 !~ "nsp=") getline; 
			     sub("",""); 
                             type=$1;
			     sub("nsp=","",type);
		     	     objname[sstate, handle] = type ":" txt;
                           }
                         }

# PQO QC <-> QS Code (verbose)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  o A QC can be identified within a systemstate by any of the following
#    methods :
#      - Look for 'flags' being set to ISQC when dumped as part of the Process
#        Queue state object dump (not the Message Buffer state object dump).
#      - Look for PS enqueues being held in EXCLUSIVE mode. 
#        (Null is used for the query slaves).
#        We can then pick up the 'proc:' address of the enqeueue s.o. and link

#      - Check to see whether the Process Queue state object hangs under the
#        Session state object (QC) rather than the process state object (Slave).
#
# Notes:
#  o One QC can have TWO Process Queue state objects with flag ISQC if the QC
#    manipulates two query slave sets (producer/consumer).
#
# Here we maintain the following variables :
#  o qclist  - This is a space delimited list of processes that are recognised
#              as QC's. The queue descriptor is also used to differentiate 
#              seperate slave sets for the same QC pid.
#  
#  o qcid    - The pid of the last QC processed.
#  
#  o qc_cnt  - Count of Opposite Qrefs we have seen for a particular QC. This
#              is indexed by [sstate, qcid]. (This is one HIGHER than the actual
#              count found).
#
#
# TODO: Complete descriptions !!
#

#Queue Reference--kxfpqr: 0x67d4244, ser: 23040, seq: 31066, error: 0
/Queue Reference--kxfpqr/	{ # printf("DBG slave[%d, qref=%s] saved\n",
				  # 	sstate, $3);
				  slave[sstate, $3] = pid; 	
				  qreferr[sstate, $3] = $9; next }

# We need to skip processing if we are dealing with a QC that we have ALREADY
# seen (Eg a QC with 2 slave sets). 
# (We have to check for this in two phases because of Sequent 'feature'
/flags: ISQC/			{ if (sotype ~ "Process Queue")
				   {
				    inpq=1;
				    if (qc_cnt[sstate,  pid]) next;
				    qclist[sstate]=qclist[sstate] " " pid; 
				    qcid = pid; ++qc_cnt[sstate, qcid]; next;
				   } 
				}

#opp qref: 0x67dd950, process: 0x7046ae4, bufs: {0x0, 0x65ff6f8}
# (We have to check for this in two phases because of Sequent 'feature'
/opp qref:.*process:/           { if (inpq==1)
				   {
				    qc[sstate, qcid, qc_cnt[sstate, qcid]++]=$3;
				    next;
				    }
				}

#client 1, detached proc: 0x726899c, QC qref 0x67dd950, flags: -none-
/client.*QC qref 0x0/		{ next; }                       # Skip QC qref's
/client.*QC qref/		{ qref=$8; slave[sstate, $8] = pid; next }
#state: 00000, flags: SMEM OPEN COPE, nulls 0, hint 0x0
/state.*hint/			{ pqostate=$2; next }
#ser: 23040, seq: 1, flags: DIAL CLR, status: FRE, err: 0
/^ *ser:.*seq:.*flags:.*err:/	{ gsub(" ","_");
				  split($0, tmparr, ",");
				  sub("^.*:_", "", tmparr[3]);
				  sub("^.*:_", "", tmparr[4]);
				  sub("^.*:_", "", tmparr[5]);
				  pqomode=tmparr[3]; pqostatus=tmparr[4];
				  pqoerr=tmparr[5];  next }

/Message Buffer--/		{ pqotype = $5; pqobufnum = $7; next }
/to qref.*from qref/		{ tmp=sprintf("%5s %10s %10s %5s %7s %7s %4s",
				  pqostate, $6, $3, pqotype, pqostatus,pqomode,
				  pqoerr);
				  pqdetail[sstate,pid,pqobufnum] = tmp; next}
#       "QC", "Slave", "Msg", "State", "From", "To", "Type", "Status", "Err"); 
				
# END Processing
# ~~~~~~~~~~~~~~
#  Ok - Let's put all the pieces together and you never know.....It just may
# make sense !!
#
END	{ printf("\nAss.Awk Version %s\n~~~~~~~~~~~~~~~~~~~~~~\n", version);
          printf("Source file : %s\n", FILENAME);
          if (kglstack) printf("\nKGL/KQR Stacks captured.\n");

          if (!sstate)
          {
            printf("\nWARNING:\n~~~~~~~\n");
            printf("The string \"SYSTEM STATE\" wasn't found in the file!!\n");
          }

	  for (i=1; i<=sstate; i++)
	   {
	    printf("\nSystem State %d\t(%s)\n%s\n", i, tstamp[i],
                     "~~~~~~~~~~~~~~\t ~~~~~~~~~~~~~~~~~~~~~~~");
            if (pstate_seen[i])
            {
              printf("\nWARNING:\n~~~~~~~\n");
              printf("The string \"PROCESS STATE\" was seen in the file and ");
              printf("this can stop processing\nif seen -within- a ");
              printf("systemstate.\n");
              printf("* Highest PID seen across systemstate is %5d\n", 
                      pstate_seen[i]);
              printf("* Highest PID seen across file        is %5d\n\n", hipid);
            }
            if (abort_seen[i])
             {
              printf("%s\n", abort_err);
              al = split(ablist[i], abelem, " ");
              for (abort_ind=1; abort_ind <= al; abort_ind++)
                printf(" Process %s at line %d\n", abelem[abort_ind],
                         aborted[abelem[abort_ind]]);
              printf("\n");
             }
	    blocking = "";
	    blkcnt = 0; objcnt = 0;
	    for (j=1; j<=pidcnt[i]; j++)
	     {
	      pid = pidarray[i,j];
	      tmp = waitres[i, pid];
	      tmp1 = "";
	      if (tmp) tmp1 = "["tmp"]";
	      printf("%-4s%-35s%s%s %s\n", pid, wait_event[i,pid],tmp1,
			isdead[i, pid]?" [DEAD]":"",seq[i, pid]);
              if (wait_event[i,pid]) level_big_enuf[i] = 1;
	      if (seqinfo && i > 1 && 
		  sameseq(wait_event[i,pid], wait_event[i-1,pid],
			seq[i, pid], seq[i-1, pid]) )
		{
		# printf("DBG> Process %s seq (%s)\n", pid, seq[i, pid]);
		seq_stuck = seq_stuck?min(seq_stuck, j):j;
		}

	      if (oct[i,pid] && oct[i,pid]!=0)
	       {
                if (cmdtab[oct[i,pid]]) printf("     Cmd: %s\n", 
		   cmdtab[oct[i,pid]]);
   		else
		  printf("     Cmd: Unknown(%s)\n", oct[i,pid]);
	       }
#
# Verbose: Need to describe wait_event details as well !!
#

              sub(" ", "_", tmp);
	      if (!index(blocking, tmp) && waitres[i,pid])
	       {
	      	blocking = blocking " " tmp;
		blklist[++blkcnt] = waitres[i,pid];
		if (verbose)
		 {
		  objid[++objcnt] = waitres[i, pid];
		 } # end verbose
	       }
	     } # end j

            # if systemstate level seems to low then warn of this
            if (!level_big_enuf[i])
              warn_level();
#
# Summary of the blocking resources
#
	    if (blkcnt)
	     {
              printf("\n");
	      printf("Blockers\n~~~~~~~~\n\n\t%s\n\t%s\n\t%s\n", tx1, tx2, tx3);
	      printf("\t%s\n\t%s\n\t%s\n\t%s\n", tx4, tx5, tx6, tx7);
              printf("\t%s\n\t%s\n\t%s\n\n", tx8, tx9, tx10);
	      printf("%28s %6s %s\n", "Resource", "Holder", "State");
	     }
	    else
	     printf("\nNO BLOCKING PROCESSES FOUND\n");
			
	    for (k=1; k<=blkcnt; k++)
	     {
	      pidlist = blkres[i, blklist[k]];

#	      Someone must be waiting for the resource if we got this far. 
	      if (!pidlist) pidlist = "???"; 

	      numpids = split(pidlist, tpid, " ");
	      for (z=1; z<=numpids; z++)
	       {
	        printf("%28s %6s ", blklist[k], tpid[z]);
	        # -- Handle self deadlocks !!
                if (!latches_seen && blklist[k] ~ "Latch")
                  latches_seen = 1;

	        if (waitres[i, tpid[z]])
	         {
# What if blker is multiple blockers ? Need to handle this case as well
# (and tidy code up [use functions?]). Currently just lists it in the following
# format :
#  Enqueue TM-000008EC-00000000              7:   7: is waiting for 7: 13:
#
		  blker = blkres[i, waitres[i, tpid[z]]];

		  # Don't know holder so let's print the resource
		  if (!sub("^ ", "", blker)) blker = waitres[i, tpid[z]];

                  # Prior to v1.0.26 if we had a self-deadlocked session then
                  # the output would list ALL the resources that the session
                  # held that blocked itself or others as being in a 
                  # self-deadlock. We now test the resource so that *only* the
                  # resource that caused the self-deadlock is listed with the
                  # "self-deadlock" attribute.
		  if (tpid[z] == blker &&
                      blklist[k] == waitres[i, tpid[z]])
                  {
                    if (eqconv[i, tpid[z], waitres[i, tpid[z]]] == EQCNV)
                      printf("Enqueue conversion\n");
                    else
		      printf("Self-Deadlock\n");
                  }
		  else
	            printf("%s is waiting for %s\n", tpid[z], blker);
	         }
	        else if (wait_event[i, tpid[z]])
		  printf("%s\n", wait_event[i, tpid[z]]); 
		else
	  	  printf("Blocker\n");
	       } # end z
	     } # end k

            # Processes with a PIN INSTANCE LOCK set with "resource=T" may
            # block other processes as the pin cannot be granted until this
            # setting is released. Since this is only seen under RAC just
            # record that these have the -potential- to block other users
            # across all nodes.
            if (pinins[i])
             {
              printf("\n%s\n%s\n%s\n\n",pstr[0],pstr[1],pstr[2]);
              for (tt=1; tt<=pinins[i]; tt++)
               printf("%s%s\n", pinins_pid[i,tt], 
                pinins_pin[i, pinins_pid[i,tt]]);
             } # end pinins

            if (latches_seen)
             {
              printf("\nSome of the above latches may be child latches. ");
              printf("Please check the section\n");
              printf("named 'Child Latch Report' below for further notes.\n");
             }

            # v1.0.15 - alert the user of multiple session processes
            if (msess[i] && !skipmsess)
             {
	      printf("\nWarning: The following processes have multiple ");
              printf("session state objects and\n");
              printf("may not be properly represented above :\n");
	      msc = split(msess[i], ms, " ");
	      for (msi=1; msi <= msc; msi += 13)
               printf("  %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s\n",
                 ms[msi], ms[msi+1], ms[msi+2], ms[msi+3], ms[msi+4], ms[msi+5],
	 	 ms[msi+6], ms[msi+7], ms[msi+8], ms[msi+9], ms[msi+10], 
		 ms[msi+11], ms[msi+12]);
             }

	    # v1.0.9 - Let's print what the 8i wait info believes are the
	    #          blockers.
	    if (a8ienabled && maxpid)
             {
	      printf("\nBlockers According to Tracefile Wait Info:");
	      printf("\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
              printf("1. This may not work for 64bit platforms. ");
              printf("See bug 2902997 for details.\n");
              printf("2. If the blocking process is shown as 0 then ");
              printf("that session may no longer be\n   present.\n");
              printf("3. If resources are held across code layers then ");
              printf("sometimes the tracefile wait\n   ");
              printf("info will not recognise the problem.\n\n");
	      for (i8=1; i8<=maxpid; i8++)
               {
	        # If I am now waiting or I am a non-existent pid then skip
		if (a8iblk[i,i8] == "" || a8iblk[i,i8] == "0")
		  continue;

                tmp_seen = 1;
		printf("Process %4d blocked by process %4d\n", i8,
                  a8isess[i, a8iblk[i,i8]]);
			
               } # end i8
            
             if (!tmp_seen) printf("No blockers seen.\n");
             }

	    if (!verbose || !blkcnt) continue;

	    printf("\nObject Names\n~~~~~~~~~~~~\n");
	    for (y=1; y<=objcnt; y++)
	     {
	      tmp = objid[y];
	      sub("^PIN: ","", tmp); 
	      sub("^LOCK: ","", tmp); 
              sub(" *handle=","",tmp);  # needed for 11g

              #printf("DBG> objname[%d, %s] = '%s'\n", i, tmp, objname[i,tmp]);
	      printf("%-25s\t%-30s\n", objid[y], substr(objname[i, tmp],1,50));
              if (!child_latches && tmp ~ "Latch" && objname[i,tmp] ~ "Child")
                child_latches = 1;
	     } # End y
	   # Print out skipped branches
           if (branchlst[i])
             printf("\n%s\n%s\n%s\n%s\n%s\n", br1,br2,br3,br4, branchlst[i]);

            # If we see child latches then just make this fact obvious for now
            # rather than trying to deduce the parent. The child and parent 
            # addresses will differ and this will not be properly detected by 
            # our blocker list.
            if (latches_seen)
             {
              printf("\nChild Latch Report\n~~~~~~~~~~~~~~~~~~\n");
              if (child_latches)
               {
                for (y=0; y<CHILD_WARN; y++)
                 printf("%s\n", cw[y]);
            
                if (platch[i])
                  for (y=0; y<platch[i]; y++)
                    printf("  %-4s %s\n", pl_pid[i, y], pl_str[i, y]);
                else
                  printf("  No processes found.\n");
               }
              else
                printf("No child latches seen.\n");
             }

             # V1.0.33
             if (wtrcount[i])
             {
               printf("\nLatch Wait List Information\n");
               printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");

               for (ww=1; ww<= wtrcount[i]; ww++)
                 printf("%s\n", wtrstr[i, ww]);

               printf("%d entries seen\n", wtrcount[i]);
	     }
             if (waitsummary)
             {
               printf("\nSummary of Wait Events Seen (count>%d)\n",
                   waitsummary_thresh);
               printf(  "~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");

              wlc = split(waitlist[i], wl, " ");
              wlseen = 0;
	      for (wli=1; wli <= wlc; wli++)
              {
                if (waitsum[i, wl[wli]] < waitsummary_thresh)
                  continue;
                wlseen = 1;
                wltmp = wl[wli];
                gsub("_", " ", wltmp);
                printf("%6d : '%s'\n", waitsum[i, wl[wli]], wltmp);
              } 
               if (!wlseen)
                 printf("  No wait events seen more than %d times\n",
                     waitsummary_thresh);
# KEVIN TODO KEV KPQ #
             }
	   } # end i

	  # Highlight processes that seem to be stuck
	  # Note that we do not care if it is stuck across ALL iterations
	  # of the systemstate dump - just across any TWO adjacent 
	  # systemstates. This is because the user may have dumped the 
	  # systemstate before the problem started, or killed the process.
	  #
	  # TODO: Remember that we may actually have a different OS process
	  #       But unlikely to have the same seq# anyway
	  #       Also, the wait_event string may actually comprise of more
	  #       than just the wait event string itself. In some cases it
	  #       also includes the p1,p2,p3 info as well.
	  if (seq_stuck)
	   {
	    printf("\nList of Processes That May Be Stuck");
	    printf("\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
	    for (i=2; i<=sstate; i++)
	     {
	      for (j=seq_stuck; j<=pidcnt[i]; j++)
	       {
		pid = pidarray[i,j];
		#printf("DBG: wait_event[%d,%s] = (%s)\n", i, pid, 
			#wait_event[i,pid]);
		#printf("KDBG: seq[%d, %s] = %s\n", i, pid, seq[i, pid]);
                if (wait_event[i, pid] ~ "waiting for" && 
                    sameseq(wait_event[i,pid], wait_event[i-1,pid],
                         seq[i, pid], seq[i-1, pid]) )
		 {
		  printf("%s %s %s\n", pid, wait_event[i,pid], seq[i,pid]);
		  ## Stop duplicate printouts
		  seq[i,pid] = "";
		 }

               } # end for j
	     } # end for i
	   } # end seq_stuck

	 if (print_pqo) pq_details(rdbms_ver);
         for (i=1; i<=sstate; i++)
           pq_qc2slave(i);

	 printf("\n%*s%s\n", ((80-length(TERM))-1)/2, " ", TERM);
         printf("For the LATEST version of this utility see\n  %s\n", 
                util_url);
         printf("\nFor additional documentation see\n  %s\n", doc_url);
         printf("\nSuggested improvements, bugs etc. should be sent to %s\n",
                emailid);
	 printf("\nEnd of report. %d Lines Processed.\n", NR);

	} # end END
