#! /usr/bin/perl -w
#######################################################################
# Script displays memory statistics for ORACLE processes
# running under AIX as well as associated session information
#
# Script is significantly more useful when used
# with ORACLE session information (-c parameter or $ORA_DB/$DORA_DB) 
# and on a BIG screen (180 symbols minimum) 
#
# Usage: Run ora_mem.pl -h for usage info
#
# Prerequisites:
#   1) Database instance needs to run
#   2) svmon -P needs to be avaialbe
#
# Maxym Kharchenko 2010
#######################################################################

use strict;
use Getopt::Std qw(getopts);
use POSIX qw(ceil);

use FindBin qw($Bin);
use lib $Bin; 

# Trapping exit signals to exit (interactive mode) gracefully
use sigtrap qw(handler SigHandler normal-signals stack-trace error-signals);  

BEGIN { $| = 1 } # Immediate flush in buffered output (printf etc)

#-----------------------------------------------------------------------
# Colored output setup - Term::ANSIColor should be standard in Perl 5.8+
#-----------------------------------------------------------------------
# Check whether Term::ANSIColor is installed and use it if it is
if ("require Term::ANSIColor") {
   use Term::ANSIColor qw(color);
   $Term::ANSIColor::AUTORESET = 1;
} else {
   eval "sub color { return ''; };"
}

use Data::Dumper qw(Dumper);

#-----------------------------------------------------------------------
# Script constants
#-----------------------------------------------------------------------
use constant SVMON_MEMORY_TYPES   => qw(user_data private stack library other COMBINED);
use constant SVMON_MEMORY_METRICS => qw(inuse pin pgsp virtual total);
use constant PS_MEMORY_METRICS    => qw(rss trs virtual inuse);

use constant DEFAULT_RUN_COUNT => 1000;

use constant STATUS_WAITING => 'Waiting ...';
use constant STATUS_WORKING => 'Collecting Data ...'; 

# This key is used throughout all program, so we make a special consideration for it
use constant c_PageSizeKey        => 'page_size';

#-----------------------------------------------------------------------
# Global screen variables
#-----------------------------------------------------------------------
my $g_nCurrentLine = 0; 

#-----------------------------------------------------------------------
# Segment descriptions
#-----------------------------------------------------------------------

# Exclusive svmon segments that we track
my $SVMON_UNRECOGNIZED_SEGMENT = 'unrecognized segment';
my $g_rhSvmonUnrecognizedSegs = {
  $SVMON_UNRECOGNIZED_SEGMENT => {pid => -1000, type => 'OTHER', regex => '(?:work|clnt|pers).*?(?=\s{2,})'}, 
};

my $g_rhSvmonExclusiveSegs = {
  'work text data bss heap'  => {type => 'user_data', regex => 'work text data BSS heap'},
  'work process private'     => {type => 'private',   regex => 'work process private'},
  'work application stack'   => {type => 'stack',     regex => 'work application stack'},
  'work shared library data' => {type => 'library',   regex => 'work shared library data'}, 
  'work private load data'   => {type => 'other',     regex => 'work private load data'},
  'work usla heap'           => {type => 'other',     regex => 'work USLA heap'},
};

# Shared svmon segments that we track
my $g_rhSvmonSharedSegs = {
  'clnt text data bss heap'   => {pid => -100,  type => 'PROGRAM TEXT',    regex => 'clnt text data BSS heap'},
  'work shared library text'  => {pid => -200,  type => 'SHARED LIB TEXT', regex => 'work shared library text'},
  'work shared library'       => {pid => -300,  type => 'SHARED LIB',      regex => 'work shared library (?!data|text)'},
  'pers usla text'            => {pid => -400,  type => 'USLA',            regex => 'pers USLA text'},
};

# Segments that we do not want to process, i.e. they do not really belong with the process, such as SGA shared segments
my $g_rhSvmonSkipSegs = {
  'work default shmat/mmap' => {regex => 'work default shmat/mmap', type => 'sga_segment'},
};

#-----------------------------------------------------------------------
# Script variables and default values
#-----------------------------------------------------------------------
my $g_rhScriptVars = {
  F_TOP_PROCESSES => -1,
  REPORT_MODE    => 'basic',
  DISPLAY_MODE   => 'mb',
  SORT_BY        => 'total',
  ORACLE_SID     => $ENV{ORACLE_SID},
  ORACLE_CON     => defined($ENV{ORA_DB}) ? $ENV{ORA_DB} : $ENV{DORA_DB},
  F_SKIP_SHARED    => 'N',
  F_CLI_PATTERN  => undef,
  F_SRV_PATTERN  => undef,
  F_CLI_PID      => undef,
  F_SRV_PID      => undef,
  INTERACTIVE    => 'N',
  SCREEN_LINES   => 0,
  SCREEN_COLUMNS => 0,
  DISABLE_COLOR  => 'N',
  WAIT_INTERVAL  => -1,
  RUN_COUNT      => 1,
  PRINT_WARNINGS => 'N',
};

####################### SUBROUTINE SECTION #############################

# ----------------------------------------------------------------------------
# SigHandler: Exit program cleanly
# ----------------------------------------------------------------------------
sub SigHandler
{
  print color 'clear' if 'Y' ne $g_rhScriptVars->{DISABLE_COLOR};
  die "Thank you for using ora_mem.pl ;-)";
}

#-----------------------------------------------------------------------
# Print in color
#-----------------------------------------------------------------------
sub printf_unconditional_c {
  my $szColor = shift;
  my $szFormat = shift;
  my @aVars = @_;
  my $bDisableColor = $g_rhScriptVars->{DISABLE_COLOR};

  print color $szColor unless 'Y' eq $bDisableColor;
  printf $szFormat, @aVars;
  print color 'reset' unless 'Y' eq $bDisableColor;
}

#-----------------------------------------------------------------------
# Fit on the Screen and Print in color
#-----------------------------------------------------------------------
sub printf_c {
  my $szColor = shift;
  my $szFormat = shift;
  my @aVars = @_;
  my ($bInteractive, $nMaxScreenLines, $nMaxScreenCols) = @$g_rhScriptVars{qw(INTERACTIVE SCREEN_LINES SCREEN_COLUMNS)};

  return -1 if 'Y' eq $bInteractive and $g_nCurrentLine > $nMaxScreenLines;

  my $szLine = sprintf $szFormat, @aVars;
  $szLine =~ s/%/%%/g;

  if('Y' eq $bInteractive and -1 != $nMaxScreenLines and -1 != $nMaxScreenCols) {
    my $nNewLines = ceil(length($szLine)/$nMaxScreenCols);
    if($g_nCurrentLine+$nNewLines > $nMaxScreenLines) {
      $szLine = substr($szLine, 1, ($nMaxScreenLines-$g_nCurrentLine)*$nMaxScreenCols);
      $g_nCurrentLine = $nMaxScreenLines;
    } else {
      $g_nCurrentLine += $nNewLines;
    }
  }

  printf_unconditional_c $szColor, $szLine;

  if('Y' eq $bInteractive and -1 != $nMaxScreenLines and -1 != $nMaxScreenCols) {
    return ($g_nCurrentLine >= $nMaxScreenLines) ? -1 : $g_nCurrentLine;
  } else {
    return 0;
  }
}

#-----------------------------------------------------------------------
# Triple check: Hash key exists, value is defined and is not empty
#-----------------------------------------------------------------------
sub element_not_empty {
  my ($rhH, $szKey) = @_;

  die "Invalid HASH in element_not_empty()" if ! defined $rhH or 'HASH' ne ref $rhH;
  die "Invalid KEY in element_not_empty()" if ! defined $szKey or length($szKey) <= 0;

  return (exists($rhH->{$szKey}) and defined($rhH->{$szKey}) and length($rhH->{$szKey}) > 0) ? 1 : 0;
}

#-----------------------------------------------------------------------
# Double check: Hash key exists and value is defined
#-----------------------------------------------------------------------
sub element_defined {
  my ($rhH, $szKey) = @_;

  die "Invalid HASH in element_not_empty()" if ! defined $rhH or 'HASH' ne ref $rhH;
  die "Invalid KEY in element_not_empty()" if ! defined $szKey or length($szKey) <= 0;

  return (exists($rhH->{$szKey}) and defined($rhH->{$szKey})) ? 1 : 0;
}

#-----------------------------------------------------------------------
# Double check: value is defined and is not empty
#-----------------------------------------------------------------------
sub not_empty {
  my $Val = shift;

  return (defined($Val) and length($Val) > 0) ? 1 : 0;
} 

#-----------------------------------------------------------------------
# Transform Pid list from comma separated to match pattern
#-----------------------------------------------------------------------
sub PidListToPattern {
  my $szPidList = shift;

  die "Undefined list supplied in PidListToPattern()" if ! defined $szPidList;

  $szPidList =~ s/,/|/g; $szPidList =~ s/\s+//g;

  return $szPidList;
} 

#-----------------------------------------------------------------------
# Find screen (terminal) dimensions
#-----------------------------------------------------------------------
sub FindScreenSize {
  my $szCmd = 'stty size';
  my @aT = split(/ /, `$szCmd`);

  if(1 == $#aT) {
    # [3 lines - header (basic), 5 lines - header (detailed)]*2, 1 line - status, 1 - totals, 1 - (reserved) status line by terminal
    $g_rhScriptVars->{SCREEN_LINES} = $aT[0] - (('basic' eq $g_rhScriptVars->{REPORT_MODE}) ? 3 : 5)*2-1-1-1 ;
    $g_rhScriptVars->{SCREEN_COLUMNS} = $aT[1];
  } else {
    $g_rhScriptVars->{SCREEN_LINES} = -1;
    $g_rhScriptVars->{SCREEN_COLUMNS} = -1;
    printf_c 'REVERSE', "Problem running stty: Screen size cannot be determined\n";
  }
}

#-----------------------------------------------------------------------
# Print program header
#-----------------------------------------------------------------------
sub PrintHeader
{
  print <<EOM ;

Display Memory Statistics for ORACLE Processes on AIX
Author: Maxym Kharchenko, 2010

EOM
}

#-----------------------------------------------------------------------
# Print program usage info
#-----------------------------------------------------------------------
sub usage
{
  die <<EOM ;
usage: ora_mem.pl <options| -h> [<wait seconds> [<count>] ]

Options: [-r basic|detailed ] [-i oracle_sid] [-c oracle_connection | -C] [-s inuse|total|virtual|pgsp]

         [-t N] [-S] [-z <client name pattern> ] [-Z <server name pattern>]
         [-p <client pid1,pid2 ...>] [-P <server pid1,pid2 ...>]

         [-d Kb|Mb|Gb] [-w] [-g]

Basic Paramaters:
  -r Report mode          Default: $g_rhScriptVars->{REPORT_MODE}
  -i Oracle Instance      Default: \$ENV{ORACLE_SID}
  -c Oracle Connection    Default: \$ENV{ORA_DB} or \$ENV{DORA_DB}
  -C Do NOT connect to ORACLE
  -s Sort by ...          Default: $g_rhScriptVars->{SORT_BY}

Filters:
  -t N Limit report to top N most active processes. Default: show all    
  -S Skip SHARED segments (program code etc)
  -z <pattern> Limit report to only specified <pattern> in client process names
  -Z <pattern> Limit report to only specified <pattern> in server process names
  -p <pid1,pid2 ...> Limit report to only specified client process pids
  -P <pid1,pid2 ...> Limit report to only specified server process pids

Miscellaneous:
  -d Display sizes in ... Default: $g_rhScriptVars->{DISPLAY_MODE}
  -w Print warnings
  -g Disable colors


  -h Print usage message

EOM
}

#-----------------------------------------------------------------------
# Parse command line
#-----------------------------------------------------------------------
sub ParseCmdLine
{
  my %Options;
  my $Var;

  die("Flag is not supported")
    if ! Getopt::Std::getopts('r:d:s:t:z:Z:p:P:i:c:CSwgh', \%Options);
  usage() if exists $Options{h};

  $g_rhScriptVars->{REPORT_MODE} = lc($Options{r}) if exists $Options{r};
  die "Invalid report mode: $g_rhScriptVars->{REPORT_MODE}"
    if $g_rhScriptVars->{REPORT_MODE} !~ /^basic$|^detailed$/;

  $g_rhScriptVars->{DISPLAY_MODE} = lc($Options{d}) if exists $Options{d};
  die "Invalid display mode: $g_rhScriptVars->{DISPLAY_MODE}"
    if $g_rhScriptVars->{DISPLAY_MODE} !~ /^kb$|^mb$|^gb$/;

  $g_rhScriptVars->{SORT_BY} = lc($Options{s}) if exists $Options{s};
  die "Invalid sort mode: $g_rhScriptVars->{SORT_BY}"
    if $g_rhScriptVars->{SORT_BY} !~ /^inuse$|^total$|^virtual$|^pgsp$/;

  $g_rhScriptVars->{F_TOP_PROCESSES} = $Options{t} if exists $Options{t};
  die "-t parameter is supposed to be a positive number"
    if $g_rhScriptVars->{F_TOP_PROCESSES} !~ /^\d+$/ and -1 != $g_rhScriptVars->{F_TOP_PROCESSES}; 

  $g_rhScriptVars->{ORACLE_SID} = lc($Options{i}) if exists $Options{i};

  die "Options -c and -C are mutually exclusive"
    if exists $Options{c} and exists $Options{C};
  $g_rhScriptVars->{ORACLE_CON} = $Options{c} if exists $Options{c};  
  $g_rhScriptVars->{ORACLE_CON} = undef if exists $Options{C};  

  # Detailed report does not display client information, so why bother ...
  $g_rhScriptVars->{ORACLE_CON} = undef if 'basic' ne $g_rhScriptVars->{REPORT_MODE}; 

  $g_rhScriptVars->{PRINT_WARNINGS} = 'Y' if exists $Options{w};

  $g_rhScriptVars->{F_CLI_PATTERN} = $Options{z} if exists($Options{z});
  $g_rhScriptVars->{F_SRV_PATTERN} = $Options{Z} if exists($Options{Z});
  $g_rhScriptVars->{F_CLI_PID} = PidListToPattern($Options{p}) if exists($Options{p});
  $g_rhScriptVars->{F_SRV_PID} = PidListToPattern($Options{P}) if exists($Options{P});

  $g_rhScriptVars->{DISABLE_COLOR} = 'Y' if exists($Options{g});

  # Shared segments are disabled whenever we have an active filter
  #   or if requested explicitly
  $g_rhScriptVars->{F_SKIP_SHARED} = 'Y'
    if exists $Options{S} or exists $Options{z} or exists $Options{Z} or exists $Options{p} or exists $Options{P};

  # $ARGV[0] = wait_interval, $ARGV[1] = runs
  if(defined($ARGV[0])) {
    $g_rhScriptVars->{INTERACTIVE} = 'Y';
    $g_rhScriptVars->{WAIT_INTERVAL} = $ARGV[0];
    die "Wait interval is supposed to be a positive number"
      if $g_rhScriptVars->{WAIT_INTERVAL} !~ /^\d+$/ and -1 != $g_rhScriptVars->{WAIT_INTERVAL};

    $g_rhScriptVars->{RUN_COUNT} = defined($ARGV[1]) ? $ARGV[1] : DEFAULT_RUN_COUNT;
    die "Run count is supposed to be a positive number"
      if $g_rhScriptVars->{RUN_COUNT} !~ /^\d+$/;
  }
}

#-----------------------------------------------------------------------
# Check Prerequisites
#-----------------------------------------------------------------------
sub CheckPrerequisites {
  my $szCmd = 'ps -ef | fgrep ora_smon_' . $g_rhScriptVars->{ORACLE_SID} . ' | grep -v fgrep | awk \'{print $2}\'';
  my $nSmonPid = `$szCmd`;
  die "Database instance $g_rhScriptVars->{ORACLE_SID} is NOT running"
    if $nSmonPid !~ /\d+/;

  # Set autotop option to screen size
  FindScreenSize();
  # SCREEN_LINES, SCREEN_COLUMNS == -1 IF stty did not return valid numbers 

  print "Displaying memory statistics for ORACLE instance: $g_rhScriptVars->{ORACLE_SID}. Report mode: $g_rhScriptVars->{REPORT_MODE}\n";

  # Check that svmon tool is accessible
  $szCmd = 'svmon -P $nSmonPid 2>/dev/null';
  my $szOut = `$szCmd`;

  # Even though svmon may be available to run from regular user account, it might not return any meaningful
  #   information when not run by root. So, we are checking if svmon returned a "body"
  #   (and data segment seems like a good candidate to look for)
  die "svmon tool does NOT seem to be available. Perhaps, you need to run this tool as root?"
    if $szOut !~ /text data BSS heap/i;

  # We do not need to check for ORACLE connection if it is NOT requested
  if(! defined $g_rhScriptVars->{ORACLE_CON}) {
    print "Database session information has NOT been requested\n" if 'basic' eq $g_rhScriptVars->{REPORT_MODE};
    return;
  }

  # Check whether ExecSql module is available and only use it then
  if(eval "require ExecSql") {
    eval "use ExecSql";
  } else {
    # If ExecSql module is not available - do NOT try to connect to ORACLE
    $g_rhScriptVars->{ORACLE_CON} = undef;
    die "Unable to connect to ORACLE. Module: ExecSql.pm is not available. Locate the module or disable with -C";
  }

  print "Gathering memory statistics for database instance: $g_rhScriptVars->{ORACLE_SID}\n";

  print "Checking database connection $g_rhScriptVars->{ORACLE_CON} ...";

  my $SQL = ExecSql->connect($g_rhScriptVars->{ORACLE_CON});
  my $szInstance = $SQL->selectall_str('select instance_name from v$instance');

  if(0 == $SQL->err) {
    print " SUCCESS\n\n";
    die "It appears that ORACLE connection is made to the wrong instance. Expected: $g_rhScriptVars->{ORACLE_SID} Got: $szInstance"
      if $g_rhScriptVars->{ORACLE_SID} ne $szInstance;
  } else {
    print " FAILED\n\n";
    die($SQL->errstr);
  }
}

#-----------------------------------------------------------------------
# Replace undefined value
#-----------------------------------------------------------------------
sub nvl {
  my $i = shift;
  my $r = shift;

  $r = 0 if ! defined $r;

  return (defined($i) ? $i : $r);
}

#-----------------------------------------------------------------------
# Convert sizes to Mb/Gb
#-----------------------------------------------------------------------
sub _resize_data {
  my ($rhProc, $rhTotals, $nDiv) = @_;

  foreach my $nPid (keys %$rhProc) {
    foreach my $szKey (keys %{$rhProc->{$nPid}->{ps}}) {
      $rhProc->{$nPid}->{ps}->{$szKey} /= $nDiv;
    }

    foreach my $szKey (keys %{$rhProc->{$nPid}->{svmon}}) {
      foreach my $szK (grep {'c_PageSizeKey' ne $_} keys %{$rhProc->{$nPid}->{svmon}->{$szKey}}) {
        $rhProc->{$nPid}->{svmon}->{$szKey}->{$szK} /= $nDiv;
      }
    }
  }

  foreach my $szKey (keys %$rhTotals) {
    foreach my $szK (grep {'c_PageSizeKey' ne $_} keys %{$rhTotals->{$szKey}}) {
      $rhTotals->{$szKey}->{$szK} /= $nDiv;
    }
  }
}

#-----------------------------------------------------------------------
# Convert sizes to Mb
#-----------------------------------------------------------------------
sub to_mb {
  my ($rhProc, $rhTotals) = @_;

  _resize_data($rhProc, $rhTotals, 1024);
}

#-----------------------------------------------------------------------
# Convert sizes to Gb
#-----------------------------------------------------------------------
sub to_gb {
  my ($rhProc, $rhTotals) = @_;

  _resize_data($rhProc, $rhTotals, 1024*1024);
}

#-----------------------------------------------------------------------
# Grab memory data from PS command
#-----------------------------------------------------------------------
sub GetPsData {
  my $szSid = $g_rhScriptVars->{ORACLE_SID};
  my ($szSrvPids, $szSrvPattern) = @$g_rhScriptVars{qw(F_SRV_PID F_SRV_PATTERN)};
  my $szCmd = "ps vgw | egrep \" oracle$szSid | ora_.\*_$szSid \" ";
  $szCmd .= "| egrep \"$szSrvPids\""    if defined $szSrvPids;    # Quick and dirty initial srv pid grep, will double check later
  $szCmd .= "| egrep \"$szSrvPattern\"" if defined $szSrvPattern; # Quick and dirty initial srv pattern grep, will double check later
  $szCmd .= "| grep -v egrep "; 

  my @aProc = split /\n/, `$szCmd`; 
  my $rhProc = {};

  foreach $_ (@aProc) {
    my @aProcOpts = split /\s+/;
    my ($nPid, $nRss, $nVirtual, $nTrs, $szCmd) = @aProcOpts[1,7,9,10,13];

    next if defined $szSrvPids and $nPid !~ m/$szSrvPids/;         # Double checking PIDs
    next if defined $szSrvPattern and $szCmd !~ m/$szSrvPattern/;  # Double checking pattern 

    $rhProc->{$nPid}->{cmd} = $szCmd;

    $rhProc->{$nPid}->{ps}->{rss} = $nRss;
    $rhProc->{$nPid}->{ps}->{virtual} = $nVirtual;
    $rhProc->{$nPid}->{ps}->{trs} = $nTrs;
    $rhProc->{$nPid}->{ps}->{inuse} = $nRss - $nTrs;

    # Initialize svmon metrics
    for my $szT (SVMON_MEMORY_TYPES) {
      for my $szM (SVMON_MEMORY_METRICS) {
        $rhProc->{$nPid}->{svmon}->{$szT}->{$szM} = 0;
      }
    }
  }

  return $rhProc;
}

#-----------------------------------------------------------------------
# Complile svmon regexes for supplied patterns for faster processing
#-----------------------------------------------------------------------
sub CompileSvmonRegexes {
  my $rhRegexStruct = shift;
  my @aRegexes = ();

  push @aRegexes, $rhRegexStruct->{$_}->{regex} for keys %$rhRegexStruct;
  my $szAllRelevantRegexes = join "|", @aRegexes;

  my $rRegex = eval { qr/^\s*(\S+).*($szAllRelevantRegexes).*?\s(s|m|sm|L)\s+((?:\d|\-)+)\s+((?:\d|\-)+)\s+((?:\d|\-)+)\s+((?:\d|\-)+)/i };
  die "Invalid regular expression: $@" if $@;

  return $rRegex;
}

#-----------------------------------------------------------------------
# Get "pid" for a shared segment to be used as a key in a process hash
#-----------------------------------------------------------------------
sub GetSharedPid {
  my ($rhProc, $rhSvmonSegs, $szSegmentClass) = @_;
  my $nBasePid = $rhSvmonSegs->{$szSegmentClass}->{pid};
  my $nPid = undef;

  # Check if the key has already been used and find the next unused one
  for($nPid = $nBasePid; exists($rhProc->{$nPid}); $nPid--) {1;}

  return $nPid;
}

#-----------------------------------------------------------------------
# Grab memory data from SVMON command
#-----------------------------------------------------------------------
sub GetSvmonData {
  my ($hVsid, $szKey, $szPage, $nInUse, $nPin, $nPgsp, $nVirtual);

  my $szSegmentClass = undef;
  my ($rhShared, $rhSvmonSegs) = ({}, undef);

  my $rhProc = shift;
  my $bSkipShared = $g_rhScriptVars->{F_SKIP_SHARED};

  my ($rExclusiveRegexes, $rSharedRegexes, $rUnrecognizedRegexes, $rSkipRegexes) = (
    CompileSvmonRegexes($g_rhSvmonExclusiveSegs), 
    ('N' eq $bSkipShared) ? CompileSvmonRegexes($g_rhSvmonSharedSegs) : undef, 
    CompileSvmonRegexes($g_rhSvmonUnrecognizedSegs),
    CompileSvmonRegexes($g_rhSvmonSkipSegs)
  );

  # Run SVMON - this is the MAIN thing that we do here
  my $szCmd = 'svmon -O segment=category -O filterprop=data -P ' . join " ", (sort keys %$rhProc);
  my $szCmdOut = `$szCmd`;

  # Analyze SVMON output
  my $szArea = 'none'; # 'Area' is a part of svmon output
  my $nPid = undef;
  foreach my $szLine (split /\n/, $szCmdOut) {
    # Skip separators
    next if $szLine =~ /^-------------/;

    # This is header line - prepare to extract PID on the next one
    if($szLine =~ /Pid\s+Command\s+Inuse/i) {
      $szArea = 'header';
      next;
    }

    # This is PID line - extract PID
    if('header' eq $szArea) { 
      if($szLine =~ /^\s+(\d+)\s+/) {
        $nPid = $1;
        $szArea = 'none';
      }
      next;
    }

    # EXCLUSIVE Segments Area
    if($szLine =~ /^EXCLUSIVE segments/) {
      $szArea = 'exclusive';
      next;
    } 

    # SHARED Segments Area
    if($szLine =~ /^SHARED segments/) {
      $szArea = 'shared';
      next;
    } 

    # This is memory area - extract data
    if($szArea =~ /exclusive|shared/) {
      my $rRegexes = ('exclusive' eq $szArea) ? $rExclusiveRegexes : $rSharedRegexes;
      next if ! defined $rRegexes;
      if($szLine =~ m/$rRegexes/ or ($szLine =~ m/$rUnrecognizedRegexes/ and $szLine !~ m/$rSkipRegexes/)) {
        ($hVsid, $szKey, $szPage, $nInUse, $nPin, $nPgsp, $nVirtual) = ($1, lc($2), $3, $4, $5, $6, $7);
        $szKey =~ s/^\s+//; $szKey =~ s/\s+$//; # Trim blanks at the beginning and end of the key

        if(defined($szKey) && 0 != length($szKey)) {
          map { $_ = 0 if $_ eq '-'; } ($szPage, $nInUse, $nPin, $nPgsp, $nVirtual);

          # AIX can use different page sizes
          die "Unexpected AIX page size: $szPage" if $szPage !~ /^s$|^m$|^sm$|^L$/;
          $_ *= (('L' eq $szPage) ? 16*1024 : ('m' eq $szPage) ? 64 : 4) for ($nInUse, $nPin, $nPgsp, $nVirtual);

          if('exclusive' eq $szArea) {
            $szSegmentClass = exists($g_rhSvmonExclusiveSegs->{$szKey}) ? $g_rhSvmonExclusiveSegs->{$szKey}->{type} : $SVMON_UNRECOGNIZED_SEGMENT;

            $rhProc->{$nPid}->{svmon}->{$szSegmentClass}->{inuse} += $nInUse;
            $rhProc->{$nPid}->{svmon}->{$szSegmentClass}->{pin} += $nPin;
            $rhProc->{$nPid}->{svmon}->{$szSegmentClass}->{pgsp} += $nPgsp;
            $rhProc->{$nPid}->{svmon}->{$szSegmentClass}->{virtual} += $nVirtual;
            $rhProc->{$nPid}->{svmon}->{$szSegmentClass}->{total} += ($nInUse + $nPgsp);
            $rhProc->{$nPid}->{svmon}->{$szSegmentClass}->{c_PageSizeKey}->{$szPage} += $nInUse;
          } elsif('shared' eq $szArea) {
            # "Shared" segments are only allocated once for all ORACLE processes (per instance)
            # We assign it to a special "process" with negative hardcoded pid to differentiate from regular processes

            # Skip if this shared segment has already been processed (it is _shared_ after all)
            next if exists $rhShared->{$hVsid};
            $rhShared->{$hVsid} = 1;
  
            if(exists($g_rhSvmonSharedSegs->{$szKey})) {
              $szSegmentClass = $szKey;
              $rhSvmonSegs = $g_rhSvmonSharedSegs;
            } else {
              $szSegmentClass = $SVMON_UNRECOGNIZED_SEGMENT;
              $rhSvmonSegs = $g_rhSvmonUnrecognizedSegs;
              print "Unrecognized pattern: $szKey in line $szLine\n" if 'Y' eq $g_rhScriptVars->{PRINT_WARNINGS};
            }

            my $nP = GetSharedPid($rhProc, $rhSvmonSegs, $szSegmentClass);

            $rhProc->{$nP}->{svmon}->{$szSegmentClass}->{inuse} = $nInUse;
            $rhProc->{$nP}->{svmon}->{$szSegmentClass}->{pin} = $nPin;
            $rhProc->{$nP}->{svmon}->{$szSegmentClass}->{pgsp} = $nPgsp;
            $rhProc->{$nP}->{svmon}->{$szSegmentClass}->{virtual} = $nVirtual;
            $rhProc->{$nP}->{svmon}->{$szSegmentClass}->{total} = ($nInUse + $nPgsp);
            $rhProc->{$nP}->{svmon}->{$szSegmentClass}->{c_PageSizeKey}->{$szPage} += $nInUse;

            # In addition to that, we fill 'text' segment "identification info"
            $rhProc->{$nP}->{cmd} = $rhSvmonSegs->{$szSegmentClass}->{type};
            $rhProc->{$nP}->{client} = $szKey . ': ' . $hVsid;
          }
        }
      }
    }
  }

  return $rhProc;
}

#-----------------------------------------------------------------------
# Grab session data from ORACLE Instance
#-----------------------------------------------------------------------
sub GetOracleInstanceData {
  my $rhProc = shift;
  my $szOraCon = $g_rhScriptVars->{ORACLE_CON};

  return $rhProc if ! defined $szOraCon;

  my $SQL = ExecSql->connect($szOraCon);
  my $szSql = <<EOM ;
SELECT p.spid, s.osuser||'\@'||s.machine||' ['||s.username||']: '||nvl(s.process, '?process')||'->'||nvl(s.program, '?client') AS client
FROM v\$session s, v\$process p
WHERE s.paddr = p.addr
  AND s.type='USER'
UNION ALL
SELECT p.spid, 'BACKGROUND: '||b.name||' '||b.description AS client
FROM v\$session s, v\$bgprocess b, v\$process p
WHERE s.paddr = b.paddr
  AND b.paddr = p.addr
  AND s.type='BACKGROUND'

EOM

  my $raSql = $SQL->selectall_hashref($szSql);

  foreach my $rhRow (@$raSql) {
    $rhProc->{$rhRow->{SPID}}->{client} = $rhRow->{CLIENT} if exists($rhProc->{$rhRow->{SPID}});
  }

  $SQL->disconnect();

  return $rhProc;
}

#-----------------------------------------------------------------------
# Preprocess data: calculate totals, deltas etc
#-----------------------------------------------------------------------
sub PreprocessMemoryData {
  my ($rhProc, $rhTotals, $szSort) = @_;

  # Here we calculate memory totals for svmon
  foreach my $nPid (keys %$rhProc) {
    foreach my $szKey (grep {'COMBINED' ne $_} keys %{$rhProc->{$nPid}->{svmon}}) {
      foreach my $szK (keys %{$rhProc->{$nPid}->{svmon}->{$szKey}}) {
        if('c_PageSizeKey' ne $szK) {
          $rhProc->{$nPid}->{svmon}->{$szKey}->{$szK} = 0 if ! defined($rhProc->{$nPid}->{svmon}->{$szKey}->{$szK});
          $rhProc->{$nPid}->{svmon}->{COMBINED}->{$szK} += $rhProc->{$nPid}->{svmon}->{$szKey}->{$szK};
          $rhTotals->{$szKey}->{$szK} += $rhProc->{$nPid}->{svmon}->{$szKey}->{$szK};
          $rhTotals->{COMBINED}->{$szK} += $rhProc->{$nPid}->{svmon}->{$szKey}->{$szK};
        } else {
          # Here we count the # of different page sizes
          foreach my $szP (keys %{$rhProc->{$nPid}->{svmon}->{$szKey}->{c_PageSizeKey}}) {
            $rhProc->{$nPid}->{svmon}->{COMBINED}->{c_PageSizeKey}->{$szP} += $rhProc->{$nPid}->{svmon}->{$szKey}->{c_PageSizeKey}->{$szP};
            $rhTotals->{$szKey}->{c_PageSizeKey}->{$szP} += $rhProc->{$nPid}->{svmon}->{$szKey}->{c_PageSizeKey}->{$szP};
            $rhTotals->{COMBINED}->{c_PageSizeKey}->{$szP} += $rhProc->{$nPid}->{svmon}->{$szKey}->{c_PageSizeKey}->{$szP};  
          }
        }
      }
    }
  }

  # Calculate delta (if any) between svmon inuse+pgsp and virtual
  foreach my $nPid (grep {$_ > 0} keys %$rhProc) {
    my $s = $rhProc->{$nPid}->{svmon}->{COMBINED};
    $s->{delta} = ($s->{virtual} - ($s->{inuse} + $s->{pgsp}) );
    $rhTotals->{COMBINED}->{delta} += $s->{delta};
  }

  return ($rhProc, $rhTotals);
}

#-----------------------------------------------------------------------
# Print detailed memory report header
#-----------------------------------------------------------------------
sub PrintDetailedReportHeader {
  print <<EOM;
-------- ----------------------- ----------------------- ----------------------- ----------------------- ----------------------- ----------------------- ------- --------------------
                 TOTAL              PROCESS/User Data        PROCESS/Private          PROCESS/Stack          SHARED LIBRARY              OTHER                     
  PID    ----------------------- ----------------------- ----------------------- ----------------------- ----------------------- -----------------------  Delta        COMMAND       
          InMem    Pin   Paging   InMem    Pin   Paging   InMem    Pin   Paging  InMem     Pin   Paging  InMem     Pin   Paging  InMem     Pin   Paging   InMem
-------- ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- --------------------
EOM
}

#-----------------------------------------------------------------------
# Print detailed memory report
#-----------------------------------------------------------------------
sub PrintDetailedReport {
  my ($rhProc, $rhTotals) = @_;
  my $szSort = $g_rhScriptVars->{SORT_BY};
  my $nTop = $g_rhScriptVars->{F_TOP_PROCESSES};
  my $szFormat = ('kb' ne $g_rhScriptVars->{DISPLAY_MODE}) ?
    "%-8s %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %-20s\n" :
    "%-8s %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %7d %-20s\n"
  ;

  PrintDetailedReportHeader();

  my $cProc = 0; my $cMaxProc = scalar keys %$rhProc; $g_nCurrentLine = 0;
  foreach my $nPid (sort {nvl($rhProc->{$b}->{svmon}->{COMBINED}->{$szSort}) <=> nvl($rhProc->{$a}->{svmon}->{COMBINED}->{$szSort})} 
      grep {exists($rhProc->{$_}->{svmon}) && $_ > 0} keys %$rhProc) {
    my $p = $rhProc->{$nPid}->{svmon};
    $cProc++;
    last if -1 != $nTop and $cProc >= $nTop;

    last if -1 == printf_c 'RESET', $szFormat,
      $nPid,
      $p->{COMBINED}->{inuse}, $p->{COMBINED}->{pin}, $p->{COMBINED}->{pgsp},
      $p->{user_data}->{inuse}, $p->{user_data}->{pin}, $p->{user_data}->{pgsp},
      $p->{private}->{inuse}, $p->{private}->{pin}, $p->{private}->{pgsp},
      $p->{stack}->{inuse}, $p->{stack}->{pin}, $p->{stack}->{pgsp},
      $p->{library}->{inuse}, $p->{library}->{pin}, $p->{library}->{pgsp},
      $p->{other}->{inuse}, $p->{other}->{pin}, $p->{other}->{pgsp},
      $p->{COMBINED}->{delta}, $rhProc->{$nPid}->{cmd}
    ;

  }

  PrintDetailedReportHeader();

  my $p = $rhTotals;
  printf $szFormat,
    'TOTAL:',
    $p->{COMBINED}->{inuse}, $p->{COMBINED}->{pin}, $p->{COMBINED}->{pgsp},
    $p->{user_data}->{inuse}, $p->{user_data}->{pin}, $p->{user_data}->{pgsp},
    $p->{private}->{inuse}, $p->{private}->{pin}, $p->{private}->{pgsp},
    $p->{stack}->{inuse}, $p->{stack}->{pin}, $p->{stack}->{pgsp},
    $p->{library}->{inuse}, $p->{library}->{pin}, $p->{library}->{pgsp},
    $p->{other}->{inuse}, $p->{other}->{pin}, $p->{other}->{pgsp},
    $p->{COMBINED}->{delta}, 'Processes: ' . scalar keys %$rhProc
  ;

  # Print Status Line
  printf_unconditional_c 'REVERSE',
    "%-120s", " ... $cProc top processes are displayed ... Skipped: " . ($cMaxProc-$cProc) . ' ';
  printf_unconditional_c 'RESET', " %-30s", STATUS_WAITING if 'Y' eq $g_rhScriptVars->{INTERACTIVE};
}

#-----------------------------------------------------------------------
# Print basic memory report header - no session data
#-----------------------------------------------------------------------
sub PrintBasicReportHeaderNoSessionData {
  print <<EOM;
---------- ---------- ---------- ---------- ---------- ----- --------------------
   PID       Total      InMem      Paging     Virtual  Pages       COMMAND      
---------- ---------- ---------- ---------- ---------- ----- --------------------
EOM
}

#-----------------------------------------------------------------------
# Print basic memory report header - with session data
#-----------------------------------------------------------------------
sub PrintBasicReportHeader {
  print <<EOM;
---------- ---------- ---------- ---------- ---------- ----- -------------------- ------------------------------------------------------------
   PID       Total      InMem      Paging     Virtual  Pages       COMMAND                                  CLIENT
---------- ---------- ---------- ---------- ---------- ----- -------------------- ------------------------------------------------------------
EOM
}

#-----------------------------------------------------------------------
# Get a string of active filters
#-----------------------------------------------------------------------
sub GetActiveFilters {
  return ' N/A' if ! defined $g_rhScriptVars->{ORACLE_CON};

  my ($nTop, $bSkipShared, $szSrvPat, $szSrvPids, $szCliPat, $szCliPids) =
    @$g_rhScriptVars{qw(F_TOP_PROCESSES F_SKIP_SHARED F_SRV_PATTERN F_SRV_PID F_CLI_PATTERN F_CLI_PID)};

  my $szFilters = '';

  $szFilters .= " TOP: $nTop" if -1 != $nTop;
  $szFilters .= " NO SHARED SEGS" if 'Y' eq $bSkipShared;
  $szFilters .= " SERVER: $szSrvPat" if not_empty($szSrvPat);
  $szFilters .= " SERVER PIDS: " . ( (length($szSrvPids) > 10) ? substr($szSrvPids, 0, 10) . ".." : $szSrvPids )
    if not_empty($szSrvPids);
  $szFilters .= " CLIENT: $szCliPat" if not_empty($szCliPat);
  $szFilters .= " CLIENT PIDS: " . ( (length($szCliPids) > 10) ? substr($szCliPids, 0, 10) . ".." : $szCliPids )
    if not_empty($szCliPids);

  return (0 == length($szFilters)) ? ' NONE' : $szFilters;
} 

#-----------------------------------------------------------------------
# Print basic memory report
#-----------------------------------------------------------------------
sub PrintBasicReport {
  my ($rhProc, $rhTotals) = @_;
  my ($nTop, $szCliPattern, $szCliPids) = @$g_rhScriptVars{qw(F_TOP_PROCESSES F_CLI_PATTERN F_CLI_PID)};
  my $szSort = $g_rhScriptVars->{SORT_BY};

  my $szFormat = ('kb' ne $g_rhScriptVars->{DISPLAY_MODE}) ?
    "%-10s %10.2f %10.2f %10.2f %10.2f %1s %1s %1s %-20s" :
    "%10s %10d %10d %10d %10d %1s %1s %1s %-20s"
  ;

  my $cProc = 0; my $cMaxProc = scalar keys %$rhProc; $g_nCurrentLine = 0;
  if(defined($g_rhScriptVars->{ORACLE_CON})) {
    PrintBasicReportHeader();

    foreach my $nPid (sort {nvl($rhProc->{$b}->{svmon}->{COMBINED}->{$szSort}) <=> nvl($rhProc->{$a}->{svmon}->{COMBINED}->{$szSort})}
       grep {
         my $cli = nvl($rhProc->{$_}->{client}, '');

         exists($rhProc->{$_}->{svmon})

         # Restricting by client pattern, if requested
         and (! defined($szCliPattern) or $cli =~ /$szCliPattern/)

         # Restricting by client pids, if requested
         and (! defined($szCliPids) or $cli =~ /$szCliPids/)

      } keys %$rhProc) {
      my $p = $rhProc->{$nPid}->{svmon};
      my ($s, $m, $L) = (
        exists($p->{COMBINED}->{c_PageSizeKey}->{s}) ? 's' : '',
        exists($p->{COMBINED}->{c_PageSizeKey}->{m}) ? (exists($p->{COMBINED}->{c_PageSizeKey}->{sm}) ? 'M' : 'm') : '',
        exists($p->{COMBINED}->{c_PageSizeKey}->{L}) ? 'L' : ''
      );
      $cProc++;
      last if -1 != $nTop and $cProc >= $nTop;

      last if -1 == printf_c 'RESET', "$szFormat %-60s\n",
        $nPid,
        $p->{COMBINED}->{total}, $p->{COMBINED}->{inuse}, $p->{COMBINED}->{pgsp}, $p->{COMBINED}->{virtual},
        $s, $m, $L,
        $rhProc->{$nPid}->{cmd}, nvl($rhProc->{$nPid}->{client}, '')
      ;
    } 

    PrintBasicReportHeader();
  } else {
    PrintBasicReportHeaderNoSessionData();

    foreach my $nPid (sort {nvl($rhProc->{$b}->{svmon}->{COMBINED}->{$szSort}) <=> nvl($rhProc->{$a}->{svmon}->{COMBINED}->{$szSort})}
       grep {exists($rhProc->{$_}->{svmon})} keys %$rhProc) {
      my $p = $rhProc->{$nPid}->{svmon};
      my ($s, $m, $L) = (
        exists($p->{COMBINED}->{c_PageSizeKey}->{s}) ? 's' : '',
        exists($p->{COMBINED}->{c_PageSizeKey}->{m}) ? (exists($p->{COMBINED}->{c_PageSizeKey}->{sm}) ? 'M' : 'm') : '',
        exists($p->{COMBINED}->{c_PageSizeKey}->{L}) ? 'L' : ''
      );
      $cProc++;
      last if -1 != $nTop and $cProc >= $nTop;

      last if -1 == printf_c 'RESET', "$szFormat\n",
        $nPid,
        $p->{COMBINED}->{total}, $p->{COMBINED}->{inuse}, $p->{COMBINED}->{pgsp}, $p->{COMBINED}->{virtual},
        $s, $m, $L,
        $rhProc->{$nPid}->{cmd}
      ;
    }

    PrintBasicReportHeaderNoSessionData();
  } # if(defined($g_rhScriptVars->{ORACLE_CON}))

  # Print totals
  my $p = $rhTotals;
  my ($s, $m, $L) = (
    exists($p->{COMBINED}->{c_PageSizeKey}->{s}) ? 's' : '',
    exists($p->{COMBINED}->{c_PageSizeKey}->{m}) ? (exists($p->{COMBINED}->{c_PageSizeKey}->{sm}) ? 'M' : 'm') : '',
    exists($p->{COMBINED}->{c_PageSizeKey}->{L}) ? 'L' : ''
  );

  printf_unconditional_c 'RESET', "$szFormat\n",
    'TOTAL:',
    $p->{COMBINED}->{total}, $p->{COMBINED}->{inuse}, $p->{COMBINED}->{pgsp}, $p->{COMBINED}->{virtual},
    $s, $m, $L,
    'Processes: ' . scalar keys %$rhProc
  ;

  # Print Status Line
  printf_unconditional_c 'REVERSE',
    "%-120s", " ... $cProc top processes are displayed ... Skipped: " . ($cMaxProc-$cProc) . " Filters:" . GetActiveFilters() . ' ';
  printf_unconditional_c 'RESET', " %-30s", STATUS_WAITING if 'Y' eq $g_rhScriptVars->{INTERACTIVE};
}

#################### MAIN PROGRAM BEGINS HERE #########################################################
PrintHeader();
die "Sorry, this tool only supports AIX" if 'aix' ne $^O;
ParseCmdLine();
CheckPrerequisites();

my ($rhProc, $rhTotals);

for(my $nRun = 0; $nRun < $g_rhScriptVars->{RUN_COUNT}; $nRun++) {
  printf_unconditional_c 'RESET', "\b" x 31 . " %-30s", STATUS_WORKING
    if 'Y' eq $g_rhScriptVars->{INTERACTIVE} and $nRun > 0;

  $rhProc = GetPsData();
  $rhProc = GetSvmonData($rhProc);
  $rhProc = GetOracleInstanceData($rhProc)
    if defined $g_rhScriptVars->{ORACLE_CON};

  ($rhProc, $rhTotals) = PreprocessMemoryData($rhProc);
  # print Dumper($rhProc) . "\n";

  if('mb' eq $g_rhScriptVars->{DISPLAY_MODE}) {
    to_mb($rhProc, $rhTotals);
  } elsif ('gb' eq $g_rhScriptVars->{DISPLAY_MODE}) {
    to_gb($rhProc, $rhTotals);
  }

  system 'clear'
    if 'Y' eq $g_rhScriptVars->{INTERACTIVE} and $g_rhScriptVars->{RUN_COUNT} > 1;
  if('basic' eq $g_rhScriptVars->{REPORT_MODE}) {
    PrintBasicReport($rhProc, $rhTotals);
  } elsif ('detailed' eq $g_rhScriptVars->{REPORT_MODE}) {
    PrintDetailedReport($rhProc, $rhTotals);
  }

  sleep($g_rhScriptVars->{WAIT_INTERVAL})
    if 'Y' eq $g_rhScriptVars->{INTERACTIVE} and $g_rhScriptVars->{RUN_COUNT} > 1;
}

print "\n";
