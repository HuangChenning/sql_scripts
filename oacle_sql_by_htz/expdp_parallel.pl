#!/usr/bin/perl
 use strict;
 # define
 my $TAB_OWNER="TRAVEL";
 my $TAB_NAME="TEST";
 my $DIRECTORY="enmo";
 my $PARALLEL=10;
 my $PFILE="parallel_table_exp.par";
 my $LOG_FILE="expdp_command.log";
 my @row;
 my $sp_flash_time=`sqlplus -S / as sysdba << EOF
 set pages 9999 lines 172
 col x format a172
 set trimout on
 set trimspool on
 select 'row:' || TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24:mi:ss') x from dual
 /
EOF`;
 my $rc = $?;
 if ($rc) {
  print "sqlplus failed - exiting";
  exit $?;
 }
 my $flash_time;
 foreach ( split (/\n/, $sp_flash_time) ) {
  chomp;
  if ( /^row:/ ) {
   s/^row://g;
   $flash_time = $_;
  }
 }
 if ( !defined ($flash_time) ) {
  print "Unable to get database time - exiting";
 }
 print "Using flash time of: " . $flash_time . "\n";
 open(PARFILE, ">", $PFILE);
 print PARFILE "flashback_time=\"to_timestamp('${flash_time}', 'yyyy-mm-dd hh24:mi:ss')\"\n";
 print PARFILE "DIRECTORY=${DIRECTORY}\n";
 print PARFILE "parallel=1\n";
 print PARFILE "tables=${TAB_OWNER}.${TAB_NAME}\n";
 print PARFILE "exclude=statistics\n";
 close(PARFILE);
 $SIG{CHLD} = 'IGNORE';
 my $shard = 0;
 my $cmd;
 open(LOGFILE, ">", $LOG_FILE);
 foreach ($shard = 0 ; $shard < $PARALLEL ; $shard++) {
   $cmd = "expdp \\\'/ as sysdba\\\' dumpfile=${TAB_NAME}_${shard}%U logfile=${TAB_NAME}_${shard}.log";
   $cmd .= " parfile=${PFILE}";
   $cmd .= " query=${TAB_OWNER}.${TAB_NAME}:\'\"where mod(dbms_rowid.rowid_block_number(rowid), ${PARALLEL}) = " . $shard . "\"\'";
   $cmd .= " &";
   print "Starting: $cmd\n";
   print LOGFILE "$cmd\n";
   my $cpid = system($cmd);
   sleep(2);
 }
 print "Please Check expdp command in logfile : $LOG_FILE\n";