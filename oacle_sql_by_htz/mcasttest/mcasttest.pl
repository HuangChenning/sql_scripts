#!/usr/bin/perl -w
#
#
# Test to see if Muticsst works across supplied nodes and intefaces.
#
# Version: 2010-10-27
#
# usage: mcasttest.pl <option>...
#
# Options:
# -n node,node,...                     List of cluster nodes 
# -i interface,interface,...           List of interfaces to test
# -m IP,IP,...                         Multicast Address(es) to test
# -d directory                         Directory to place executable
# -g debug level	 	        Debug Level 'low' or 'high'			
#
# History: yyyy/mm/dd
# -------------------
#
# bburton  2010/10/29  Initial Version 
# bvongray 2011/07/12  Added support for zLinux (s390x)
#
#################################################################
#

=head1 NAME
	mcasttest.pl

=head1 SYNOPSIS

	Wrapper for the mcast2 'C' code.

Options:
   -h                              : The help message
   -n node,node,...                : List of cluster nodes 
   -i interface,interface,...      : List of interfaces to test
   -m IP,IP,...                    : Multicast Address(es) to test
   -d directory                    : Directory to place executable on all hosts
   -g debug level                  : Debug Level 'low' or 'high'


=cut

################ End Documentation ################

use strict;
use POSIX;
use English;
use File::Basename;
use File::Spec::Functions;
use Getopt::Std;

################### debug

my $DBG_NOTE = 1;              # Notes to the user
my $DBG_WHAT = 2;              # Explain what you do
my $DBG_VERB = 4;              # Be verbose
my $DBG_HOST = 8;              # print command executed on local host

#my $DEBUG = $DBG_NOTE | $DBG_WHAT | $DBG_VERB | $DBG_HOST;
my $DEBUG = $DBG_NOTE | $DBG_WHAT ;


###################################

my $PWD;
my $SSH="/usr/bin/ssh -x";
my $RM;
my $MV;
my $CP;
my $SCP;
my $LS;
my $inf;
my $command;
my $localhost = `hostname`;

my $cmd_host;
my @cmd_result;
my @cmd_result_local;
my $node;
my $mcast_binary;
my $osname = `uname`;
my $processor;
my $pingflag;
chomp ($osname);

if ($osname eq "Linux") {
        $pingflag = "-c";
        $processor = `uname -p`;
        chomp ($processor);
        if ($processor eq "x86_64") {
            $mcast_binary="mcast2.linux.x64"}
        elsif ($processor eq "s390x") {
            $mcast_binary="mcast2.linux.s390x"}
        else { 
            $mcast_binary="mcast2.linux.x32"}
} 
elsif ($osname eq "SunOS") {
        $pingflag = "-c";
        $processor = `uname -p`;
        chomp ($processor);
        if ($processor eq "sparc") {
            $mcast_binary="mcast2.solaris.sparc64"}
        else { 
            $mcast_binary="mcast2.solaris.x64"}
} 
elsif ($osname eq "AIX") {
        $pingflag = "-c";
        $mcast_binary="mcast2.aix.ppc64"}
elsif ($osname eq "HP-UX") {
        $pingflag = "-n";
        $processor = `uname -m`;
        chomp ($processor);
        if ($processor eq "ia64") {
            $mcast_binary="mcast2.hpux.ia64"}
        else {
            $mcast_binary="mcast2.hpux.parisc64"}
}
else {
        print "This Code cannot run on  $osname $processor \n";
        exit 0;}

#my $mcast_addr="224.0.0.251:";
my $mcast_addr;
my @mcast_addrs=qw(230.0.1.0 224.0.0.251);
my $portaddr=42000;
my $portsupplied=0;
my @nodes;
my @interfaces;
my $tmpdir="/tmp/mcasttest";
my $nodecount;
my $infcount;
my $now_string;

## Argument handling
my %options;
my $pid;
my $interface;

getopts("hn:i:d:g:m:", \%options);

if ($options{h}) {
 print <<EOF;

 $0: mcasttest.pl - tests if an interface can multicast across the list of nodes

 Syntax: $0 -h | [-n node(s) -i interface(s) -d directory] [-m ip address] [-g level] 

 Options:
   -h                              : This help message
   -n node,node,...                : List of cluster nodes 
   -i interface,interface,...      : List of interfaces to test
   -m IP,IP,...                    : Multicast Address(es) to test
   -d directory                    : Directory to place executable on all hosts
   -g debug level                  : Debug Level 'low' or 'high'
EOF
  exit;
}
elsif ($options{n} && $options{i})
{
@nodes = split /,/, $options{n};
@interfaces = split /,/, $options{i};
$nodecount = @nodes;
$infcount = @interfaces;
}
else
{
print "Invalid arguments please supply at least -n and  -i or just -h for help\n";
exit 1;
}
# change the binary staging diretcory if supplied

if ($options{d}) {
   $tmpdir = $options{d};
}

# change the multicast address if supplied
if ($options{m}) {
   if ($options{m} =~ /\:/){
       print " Please DO NOT supply a port with the multicast address (-m) option\n";
       exit 1;
   }
   @mcast_addrs =  split /,/, $options{m} ;
}


# set the debug level
if ($options{g}) {
if ($options{g} eq "low") {
   $DEBUG |= $DBG_VERB;}
elsif ($options{g} eq "high") {
   $DEBUG |= $DBG_HOST;}
}

###########################################################

# print debug info

sub dbg
{
    my ($level, $line) = @_;
    if( $level & $DEBUG) {
        print "$line";
    }
}


sub trim
{
    $_ = shift;
    s/^\s+//;
    s/\s+$//;
    return $_;
}

sub wait_enter
{
    print "Press <ENTER> to continue...\n";
    my $key;
    read( STDIN, $key, 1);
}

# Print fatal error and die

sub fatal
{
    my $line = shift;

    if( $cmd_host ne "") {
        print "\nResult of last host command:\n";
        print "EXE: $cmd_host\n";
        foreach my $l (@cmd_result) {
            chomp( $l);
            print "...: $l\n";
        }
    }
    die "FATAL: $line\n";
}

sub warning
{
    my $line = shift;

    if( $cmd_host ne "") {
        print "\nResult of last host command:\n";
        print "EXE: $cmd_host\n";
        foreach my $l (@cmd_result) {
            chomp( $l);
            print "...: $l\n";
        }
    }

    print "WARNING: $line\n";
}

# Execute a command on the local host

sub host
{
    $cmd_host = shift;
    dbg( $DBG_HOST, "EXE: $cmd_host\n");
    @cmd_result = qx( $cmd_host 2>/dev/null);
    my $last = $?;
    foreach my $l (@cmd_result) {
        chomp( $l);
        dbg( $DBG_HOST, "...: $l\n");
    }
    dbg( $DBG_HOST, "RET: $last\n");
    return $last;
}

# Execute a command on a remote host. If the host specified is the local node
# execute local instead

sub host_remote
{
    my $host = shift;
    $cmd_host = shift;
    my $last;
    my $pattern = $host;

    # if we are on the local host we don't need remote access
    if( $localhost =~ /$pattern/ ) {
        return host( $cmd_host);
    }
    
    return host_force_remote( $host, $cmd_host);
}

# Execute a command on a remote host.

sub host_force_remote
{
    my $host = shift;
    $cmd_host = shift;
    my $last;

    dbg( $DBG_HOST, "EXE ($host): $cmd_host\n");
    @cmd_result = qx( $SSH $host '$cmd_host; echo \$\?' 2>/dev/null);
    foreach my $l (@cmd_result) {
        chomp( $l);
        dbg( $DBG_HOST, "...: $l\n");
        $last = trim($l);
    }
    dbg( $DBG_HOST, "RET: $last\n");
    return $last;
}

sub copy_remote
{
    my ($node,$from,$to) = @_;
    my $cmd;
    dbg( $DBG_WHAT, "Distributing mcast2 binary to node '$node'\n");
    # if we are on the local host we don't need remote access
    if( $localhost =~ /$node/ ) {
        $cmd = "$CP $from \"$to\"";
    }
    else {
        $cmd = "$SCP $from $node:\"$to\"";
    }

    return host( $cmd);
}



sub runmcast
{
    my $host = shift;
    $cmd_host = shift;
    my $last;
    my $pattern = $host;

    # if we are on the local host we don't need remote access
    if( $localhost =~ /$pattern/ ) {
        return localmcast( $host, $cmd_host);
    }

    return remotemcast( $host, $cmd_host);
}

sub localmcast
{
    my $host = shift;
    $cmd_host = shift;
    dbg( $DBG_HOST, "EXE: $cmd_host\n");
    #@cmd_result = qx( $cmd_host 2>/dev/null);
    @cmd_result = qx( $cmd_host );
    my $last = $?;
    my $locatedcount = 0;
    my $logfile = "$tmpdir/$host" . "mcast.log";
    open(OUT, ">> $logfile") or die " Can't write to file $logfile: $!\n";
 
    foreach my $l (@cmd_result) {
        chomp( $l);
        if ( $l =~ /Located new peer/) {
            $locatedcount += 1;
        }
        print OUT "$l\n";
        dbg( $DBG_HOST, "...: $l\n");
    }
    close(OUT);
    if ($locatedcount == $nodecount) {
       return 1; }
    else {
       return 0; }

}
sub remotemcast
{
    my $host = shift;
    $cmd_host = shift;
    my $last;
    my $logfile = "$tmpdir/$host" . "mcast.log";
    open(OUT, ">> $logfile") or die " Can't write to file $logfile: $!\n";

    dbg( $DBG_HOST, "EXE ($host): $cmd_host\n");
    @cmd_result = qx( $SSH $host '$cmd_host; echo \$\?' 2>/dev/null);
    foreach my $l (@cmd_result) {
        chomp( $l);
        print OUT "$l\n";
        dbg( $DBG_HOST, "...: $l\n");
        $last = trim($l);
    }
    close(OUT);
    dbg( $DBG_HOST, "RET: $last\n");
    return 99;
}


# Check if a node is reachable (pingable)

sub check_node
{
    my $node = shift;
    my $pingcommand;

    dbg( $DBG_WHAT, "Checking node access '$node'\n");
    if ( $osname eq "HP-UX" ) {
       $pingcommand = "ping $node $pingflag 1"}
    else {
       $pingcommand = "ping $pingflag 1 $node"}

    if( host( $pingcommand ) ne 0) {
        fatal( "Node '$node' not reachable.");
    }
}

# Check if passwordless login works for a node
sub check_login
{
    my $node = shift;

    dbg( $DBG_WHAT, "Checking node login '$node'\n");
    if( host( "$SSH -q -o NumberOfPasswordPrompts=0 $node pwd") ne 0) {
        dbg( $DBG_WHAT, "SSH failed to $node : Please set up SSH and try again\n");
        fatal( "Failed to login to node '$node'");
    }
}

# Create a directory path on a node. 
sub mkdir_path
{
    my ($node,$dir) = @_;

    my @subs = split( /\//, $dir);
    my $path = '';
    dbg( $DBG_WHAT, "Checking/Creating Directory $tmpdir for binary on node '$node'\n");
    foreach my $p ( @subs ) {
        if( $p ne '') {
            $path = $path . '/' . $p;
            if( host_remote( $node, "$LS -d $path") != 0) { 
                dbg( $DBG_VERB, "mkdir '$path' on '$node'\n");
                if( host_remote( $node, "mkdir $path")) {
                    fatal( "Failed to make path '$path' on '$node'");
                }
	    }
            else {
                dbg( $DBG_VERB, "'$path' on '$node' exists\n");
            }
        }
    }
}

############################  MAIN  ##############################

# Set up some command stuff
chomp( $PWD = `pwd`);
chomp( $SCP = qx(which scp));
chomp( $RM  = qx(which rm));
chomp( $MV  = qx(which mv));
chomp( $CP  = qx(which cp));
chomp( $LS  = qx(which ls));


# Firstly loop through the nodes to ensure we can ssh, and distribute code

foreach $node (@nodes) {
	dbg($DBG_WHAT,"###########  Setup for node $node  ##########\n");
	chomp($node);
	check_node($node);
	check_login($node);
        mkdir_path($node, $tmpdir);
        copy_remote($node,$mcast_binary,$tmpdir);

} 

# Now run the mcast at all the supplied nodes by interface.

dbg($DBG_WHAT,"###########  testing Multicast on all nodes  ##########\n");
foreach $mcast_addr (@mcast_addrs) {
   dbg($DBG_WHAT,"\nTest for Multicast address $mcast_addr\n\n");
   foreach $interface (@interfaces) {
	my @chpids;
	my $chpid;
   	foreach $node (@nodes) {
   	  $pid = fork ();
          if ($pid > 0) {
	    # create array of child pids within the parrent process
	    push(@chpids, $pid);
          } elsif ($pid == 0 ) {
   	    my $result;
               $command = "$tmpdir/$mcast_binary -mcast $mcast_addr:$portaddr -inf $interface -num $nodecount";
               dbg($DBG_HOST,"Calling remote host for $command on $node\n"); 
   	    $result = runmcast( $node, $command );
               $now_string = strftime "%b %e %H:%M:%S", localtime;
   	    if ( $result == 1 ) {
   		dbg($DBG_NOTE, $now_string . " | Multicast Succeeded for $interface using address $mcast_addr:$portaddr\n"); }
   	    if ( $result == 0 ) {
   		dbg($DBG_NOTE, $now_string .  " | Multicast Failed for $interface using address $mcast_addr:$portaddr\n"); }
               exit 0;
         } else {
           # Just in case the fork fails (status of -1)
	   print "Fork Failed!!\n";
         }
       }
	# Check that all child processes have completed before moving on
       foreach $chpid (@chpids) {
	  waitpid($chpid,0);
       }
       $portaddr += 1;
   }
}
sleep(5);
