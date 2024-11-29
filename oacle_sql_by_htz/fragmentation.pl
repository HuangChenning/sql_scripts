#!/usr/bin/perl

use Term::ANSIColor ;
 

my $user=tc;
my $pass=tc;
my $logf="./gen.log";
my $l1=400;


my $tab="\b\t\t\t\t\t\t";
print "Generating large sql statment using testcases from ";
print  colored( "bug 6360312/3989066/4601087", "red","on_yellow","blink"); 
print "\n\n\n";
print "                                 \n";
print " 1) cursor_sharing=force         \n";
print " 2) RBO                          \n";
print "     select * from tc where c1 in ('X1','X2',.....,'X$l1')\n";
print "     or c1 in ('Y2','Y2',......'Y$l1')\n\n\n\n";

print "Running Setup";
my $sqlstmt="select * from tc where c1 in ('X1' ";
my $vallist;
my $id=2;


my $rc=system("sqlplus /nolog  <<EOF 1>$logf 2>&1
conn /as sysdba
grant dba to $user;
conn $user/$pass
drop table tc;
whenever sqlerror  exit 1
create table tc (c1 varchar2(30) , c2 number );
begin for i in 1..1500 loop insert into  tc values ('X'||to_char(i),i);
     end loop;
end;
/
create index  c1x on tc (c1);
create index  c2x on tc (c2);
exit 0
EOF" );

if ( $rc != 0 ) {
   print "$tab [FAILURE]\n";
   exit 0 ;
   } else { print "$tab [OK]\n"; }

for (my $cnt=0; $cnt<$l1 ; $cnt++) {
  $id++;
  $vallist="${vallist},'X${id}'\n";
}

$sqlstmt="${sqlstmt} ${vallist} ) or c1 in ";

$vallist="";

for (my $cnt=0; $cnt<$l1 ; $cnt++) {
  $id++;
  $vallist="${vallist},'Y${id}'\n";
}

$sqlstmt="$sqlstmt ('1' ${vallist} ) ;";
print  colored( "Running Sql ","red","on_black","blink");

my $rc=system("sqlplus /nolog  <<EOF  1>>$logf 2>&1
conn /as sysdba 
alter system set \"_4031_dump_bitvec\"=16405;
alter system flush shared_pool;
conn $user/$pass
whenever sqlerror  exit 1
alter system set cursor_sharing=force;
alter session set optimizer_mode=rule;
$sqlstmt
EOF" );

if ( $rc != 0 ) {
   print "$tab [FAILURE]\n";
   print "error $rc\n";
   exit 0 ;
   } else { print "$tab [OK]\n"; }

print "Heapdump level 2";
my $oradebug=qx{ sqlplus -s \'/as sysdba\' <<EOF 
alter session set tracefile_identifier=HEAPDUMP;
oradebug setmypid 
oradebug unlimit
oradebug dump heapdump 2
oradebug tracefile_name
exit
EOF};

if ( $rc != 0 ) {
   print "$tab [FAILURE]\n";
   print "error $rc\n";
   exit 0 ;
   } else { print "$tab [OK]\n"; }

my $rc=system("sqlplus -s /nolog  <<EOF 
conn /as sysdba

set line 100
col sql_text for a55
col hash_value new_value _hash
prompt select hash_value,sql_text from v\\\$sqlarea...
select hash_value , sharable_mem,substr(sql_text,1,55)  sql_text
from v\\\$sqlarea where sql_text like 
'select * from tc%';

select kglobhd0,kglobhd6 
   from x\\\$kglob where KGLNAHSH=&_hash;

EOF");

@line = split /\n/,$oradebug;
for ($i = 0 ; $i < scalar @line ; $i++ ) { 
     if ( $line[$i] =~ "HEAPDUMP" ) { 
      print "heapdump:\n$line[$i]\n";
      system($^X, "heapdslist.pl", $line[$i],10);
       }        
     }



