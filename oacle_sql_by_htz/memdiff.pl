#!/usr/bin/perl
#
# Make sure to set LANG=en_US before running this script or you
# will get a 'Split loop' error.
#
# This script will go through two iterations of gathering process
# memory data and then output the differences to a file. The
# purpose is to determine which process is consuming the most
# memory over the given time period. All numbers are KB.
#
# The purpose of this script is to determine processes
# *consuming* memory. To that end, processes *releasing*
# memory are not factored.
#
# Two arguments can be specified:
# Number of seconds to sleep between iterations (default: 60)
# Directory where the report will be written (default: /tmp)
#
# Example:
# memdiff.pl 30 /home/oracle
#

# Set constants
$sleeptime = $ARGV[0] || 60;
$outdir = $ARGV[1] || '/tmp';
($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time);
$Month=$Month+1;
$Year=$Year+1900;

# Open files
open(bfile,">$outdir/before_memdiff_$Year-$Month-$Day:$Hour:$Minute:$Second_$sleeptime.secs");
open(afile,">$outdir/after_memdiff_$Year-$Month-$Day:$Hour:$Minute:$Second_$sleeptime.secs");
open(tfile,">$outdir/threads_memdiff_$Year-$Month-$Day:$Hour:$Minute:$Second_$sleeptime.secs");
open(outfile,">$outdir/memdiff_$Year-$Month-$Day:$Hour:$Minute:$Second_$sleeptime.secs");

# Get first iteration of memory data and populate hash arrays
open (STATUS_FILES, "ls /proc/*/status|");
while (<STATUS_FILES>) {
open(SFILE,"$_");
foreach $line (<SFILE>) {
chomp;
@split_status = split(/\s+|\n/,$line);
if ($line =~ /^Name:/) {$name = $split_status[1]};
if ($line =~ /^Pid:/) {$pid = $split_status[1]};
if ($line =~ /^VmSize:/) {$vmsize = $split_status[1]};
if ($line =~ /^VmRSS:/) {$vmrss = $split_status[1]};
if ($line =~ /^VmData:/) {$vmdata = $split_status[1]};
if ($line =~ /^VmStk/) {$vmstk = $split_status[1]};
if ($line =~ /^VmExe:/) {$vmexe = $split_status[1]};
if ($line =~ /^VmLib:/) {$vmlib = $split_status[1]};
}
$name{$pid} = $name;
$vmsize{$pid} = $vmsize;
$vmrss{$pid} = $vmrss;
$vmdata{$pid} = $vmdata;
$vmstk{$pid} = $vmstk;
$vmexe{pid} = $vmexe;
$vmlib{pid} = $vmlib;
$vmshared = $vmsize-$vmdata-$vmstk;
$vmshared{$pid} = $vmshared;
$name = sprintf("%-20s",$name);
$bline = join "\t",$pid,$name,$vmsize,$vmrss,$vmshared,$vmdata,$vmstk,$vmexe,$vmlib,"\n";
print bfile $bline;
}
close(STATUS_FILES);

# Sleep for a while to let memory accumulate
sleep $sleeptime;

# Get second iteration of memory data and populate hash arrays
open (STATUS_FILES, "ls /proc/*/status|");
while (<STATUS_FILES>) {
open(SFILE,"$_");
foreach $line (<SFILE>) {
chomp;
@split_status = split(/\s+|\n/,$line);
if ($line =~ /^Name:/) {$name = $split_status[1]};
if ($line =~ /^Pid:/) {$pid = $split_status[1]};
if ($line =~ /^VmSize:/) {$vmsize = $split_status[1]};
if ($line =~ /^VmRSS:/) {$vmrss = $split_status[1]};
if ($line =~ /^VmData:/) {$vmdata = $split_status[1]};
if ($line =~ /^VmStk/) {$vmstk = $split_status[1]};
if ($line =~ /^VmExe:/) {$vmexe = $split_status[1]};
if ($line =~ /^VmLib:/) {$vmlib = $split_status[1]};
}
$name2{$pid} = $name;
$vmsize2{$pid} = $vmsize;
$vmrss2{$pid} = $vmrss;
$vmdata2{$pid} = $vmdata;
$vmstk2{$pid} = $vmstk;
$vmexe2{pid} = $vmexe;
$vmlib2{pid} = $vmlib;
$vmshared = $vmsize-$vmdata-$vmstk;
$vmshared2{$pid} = $vmshared;
$name = sprintf("%-20s",$name);
$aline = join "\t",$pid,$name,$vmsize,$vmrss,$vmshared,$vmdata,$vmstk,$vmexe,$vmlib,"\n";
print afile $aline;
}
close(STATUS_FILES);

# Fill an array with various process info for any
# process that increased its local memory
foreach $ky (keys %vmsize) {
$vmsizediff = $vmsize2{$ky}-$vmsize{$ky};
$vmrssdiff = $vmrss2{$ky}-$vmrss{$ky};
$vmshareddiff = $vmshared2{$ky}-$vmshared{$ky};
$vmdatadiff = $vmdata2{$ky}-$vmdata{$ky};
$vmstkdiff = $vmstk2{$ky}-$vmstk{$ky};
$vmexediff = $vmexe2{$ky}-$vmexe{$ky};
$vmlibdiff = $vmlib2{$ky}-$vmlib{$ky};
if ($vmsizediff > 100 || $vmrssdiff > 100 || $vmdatadiff > 100 || $vmstkdiff > 100 || $vmexediff
> 100 || $vmlibdiff > 100) {
$line = join
"\t",$ky,sprintf("%-20s",$name{$ky}),$vmsizediff,$vmrssdiff,$vmshareddiff,$vmdatadiff,$vmstkdiff,$vmexediff,$vmlibdiff,"\n";
push(@file,$line);
}
}

# Sort the array by process name,virtual size to prep it for dup elimination
sort { $b->[2] cmp $a->[2] or $b->[3] <=> $a->[3] }
map { [$_,split]} @file;

# Assume that if a process has an identical size difference AND identical
# rss difference AND identical program name as the previous line, that
# this process is a thread who's memory consumption has already been
# counted, so don't add it.
# This is NOT a full-proof method for thread determination - just a best guess
foreach $line (@sortedp) {
if ($sField[2] == $oldvmsize && $sField[3] == $oldvmrss && $sField[1] eq $oldname) {
push(@threads, $line);
}
else {
push(@sortedpu,$line);
$vmsizedifftotal = $sField[2]+$vmsizedifftotal;
$vmrssdifftotal = $sField[3]+$vmrssdifftotal;
$vmshareddifftotal = $sField[4]+$vmshareddifftotal;
$oldvmsize = $sField[2];
$oldvmrss = $sField[3];
$oldname = $sField[1];
}
}

# Sort the array by descending virtual size to ease report reading
sort { $b->[3] <=> $a->[3] }
map { [$_,split]} @sortedpu;

# Print output
print tfile "The following processes were identified as threads and therefore\n";
print tfile "their memory consumption is only listed once in the main report \n";
print tfile "Keep in mind that since there is no definitive way to identify\n";
print tfile "threads (vs normal processes), this list is simply a best guess\n\n";
print tfile "PID\tNAME SIZE\tRSS\tSHARE\tDATA\tSTK\tEXE\tLIB\n";
print tfile @threads;
print outfile "******************************************************************\n";
print outfile "The KB differences for various memory categories are listed below.\n";
print outfile "Since the purpose is to determine an *increase* in proc memory, \n";
print outfile "processes must have consumed at least 100KB to be included.\n\n";
print outfile "Keep in mind that if a process is threaded, only one of the\n";
print outfile "threads will be displayed because most memory info is duplicated.\n";
print outfile "Threads are listed in separate report starting with 'thread'.\n";
print outfile "Since there is no definitive way to identify threads \n";
print outfile "(vs normal processes), this list is simply a best guess\n";
print outfile "i.e. threads may exist in this report and processes may\n";
print outfile "exist in the thread report. Check the app to be sure\n\n";
print outfile "The time sampling for this report is $sleeptime seconds.\n";
print outfile "You can get the actual date, time and sampling from the file name.\n";
print outfile "You can also get the before and after raw data in files with\n";
print outfile "with the same name, but prefaced with 'before' or 'after'.\n";
print outfile "******************************************************************\n\n";
print outfile "Memory Consumption Summary:\n";
print outfile "Approximate total Virtual KB added in $sleeptime seconds:\t$vmsizedifftotal\n";
print outfile "Approximate total Shared KB added in $sleeptime seconds:\t$vmshareddifftotal\n";
print outfile "Approximate total Physical KB added in $sleeptime seconds:\t$vmrssdifftotal\n\n";
print outfile "Memory Consumption Details:\n";
print outfile "PID\tNAME SIZE\tRSS\tSHARE\tDATA\tSTK\tEXE\tLIB\n";
print outfile @sortedfinal;

# Close files
close(bfile);
close(afile);
close(tfile);
close(outfile);
