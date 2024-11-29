export PERL5LIB=$ORACLE_HOME/perl/lib:$ORACLE_HOME/perl/lib/site_perl
export LD_LIBRARY_PATH=$ORACLE_HOME/lib32:$ORACLE_HOME/lib:$ORACLE_HOME/network/lib32:$ORACLE_HOME/network/lib:$ORACLE_HOME/perl/lib
$ORACLE_HOME/perl/bin/perl AWRRange.pl

