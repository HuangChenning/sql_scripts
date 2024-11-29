
mcasttest.pl :

Version: 29-Sep-2010

With Grid Infrastructure 11.2.0.1 muticasting is used for mDNS across the
cluster nodes to advertise any profile changes required ion the bootstrapping
process and for GNS. This traffic is sent across all avilable networks.

With Grid Infrastructure 11.2.0.2 multicasting is also used to advertise
communication endpoints for the cluster interconnet when nodes join the 
cluster.  11.2.0.2 base version will use the 230.0.1.0 address for
muticasting on the private network for this purpose. 11.2.0.2 with Grid 
Infrastructure PSU 1 will use the 224.0.0.251 and  230.0.1.0 addresses for
this purpose.  A node cannot join the cluster if multicasting does not work on
these address and as such this code can be used to test multicasting prior to
any installation or upgrade.  If the test fails for 230.0.1.0 then the patch
available under bug 9974223 or the Grid Infrastructure PSU 1 must be applied
prior to running root.sh or rootupgrade.sh as part of an install or upgrade.
Please see My Oracle Support Note: 1212703.1  for further details.


Table of contents:
==================

  1) Prerequisites
  2) Running mcasttest.pl
  3) Determining Success

1) Prerequisites:
=================

  * All nodes must be up and reachable via ping.

  * Passwordless login via ssh must be set up.

  * The Script must be able to create or use a directory to stage the binary.
    This diretcory will by default be /tmp/mcasttest but can be specified.

  * Network interfaces should be globally the same on all nodes ie. All nodes 
     must have the same public and private inteface names configured.
  
  * The commands 'ls','scp','rm','cp','ping','mv' must be available in your 
    path.

2) Running mcasttest.pl
=======================

  * The mcasttest.pl perl script is run from the directory it was extracted to.
   
  * All the required files are also extracted to that directory.

 1) cd /<extract directory>
 2) chmod +x mcasttest.pl mcast2* 
 3) ./mcasttest.pl <options>

  Options:
     -h                              : The help message
     -n node,node,...                : List of cluster nodes 
     -i interface,interface,...      : List of interfaces to test
     -m IP,IP,....                   : Multicast Address(es) to test
     -d directory                    : Directory to place executable
     -g debug level                  : Debug Level 'low' or 'high'

  Example:
    ./mcasttest.pl -n node1,node2 -i eth0,eth1 

  Note: The -n and -i flags are mandatory. 
        The dafault Multicast addresses to test are 224.0.0.251 and 230.0.1.0
        The default Directory is /tmp/mcasttest   

3) Determining Success
======================         

The success or Failure of multicasting for each supplied  interface is
displayed.

There is no concept of partial success. Unless all nodes join the multicast
group for an interface we will report Failure.

An Example of Successful output is:

[user@node1]$ ./mcasttest.pl -n node1,node2 -i eth0,eth1

###########  testing Multicast on all nodes  ##########

Test for Multicast address 230.0.1.0

Nov  4 07:11:13 | Multicast Succeeded for eth0 using address 230.0.1.0:42000
Nov  4 07:11:13 | Multicast Succeeded for eth1 using address 230.0.1.0:42001

Test for Multicast address 224.0.0.251

Nov  4 07:11:18 | Multicast Succeeded for eth0 using address 224.0.0.251:42002
Nov  4 07:11:18 | Multicast Succeeded for eth1 using address 224.0.0.251:42003

