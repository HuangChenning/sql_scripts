# impshow2sql Tries to convert output of an IMP SHOW=Y command into a 
# usage SQL script.
#
# To use:
# Start a Unix script session and import with show=Y thus:
# 
# $ imp user/password file=exportfile show=Y log=/tmp/showfile
# 
# You now have the SHOW=Y output in /tmp/showfile . 
# Run this script against this file thus:
# 
# $ ./impshow2sql /tmp/showfile > /tmp/imp.sql
# 
# The file /tmp/imp.sql should now contain the main SQL for
# the IMPORT. 
# You can edit this as required.
# Note: This script may split lines incorrectly for some statements
# so it is best to check the output.
#
# CONSTRAINT "" problem:
# You can use this script to help get the SQL from an export
# then correct it if it includes bad SQL such as CONSTRAINT "".
# Eg:
# Use the steps above to get a SQL script and then
# $ sed -e 's/CONSTRAINT ""//' infile > outfile
# Now precreate all the objects and import the export file.
#
# Extracting Specific Statements only:
# It is fairly easy to change the script to extract certain statements
# only. For statements you do NOT want to extract change N=1 to N=0
# Eg: To extract CREATE TRIGGER statements only:
# a) Change all lines to set N=0. 
# Eg: / \"CREATE / { N=0; }
# This stops CREATE statements being output.
#
# b) Add a line (After the general CREATE line above): 
# / \"CREATE TRIGGER/ { N=1; }
# This flags that we SHOULD output CREATE TRIGGER statements.
#
# c) Run the script as described to get CREATE TRIGGER statements.
# 

awk ' BEGIN { prev=";" }
/ \"CREATE / { N=1; }
/ \"ALTER / { N=1; }
/ \"ANALYZE / { N=1; }
/ \"GRANT / { N=1; }
/ \"COMMENT / { N=1; }
/ \"AUDIT / { N=1; }
N==1 { printf "\n/\n\n"; N++ }
/\"$/ { prev=""
if (N==0) next;
s=index( $0, "\"" );
if ( s!=0 ) {
printf "%s",substr( $0,s+1,length( substr($0,s+1))-1 ) 
prev=substr($0,length($0)-1,1 );
} 
if (length($0)<78) printf( "\n" );
}' $*
