#!/usr/bin/perl
use strict;
use warnings;
print "please input lob column locator values(20):";
chomp(my $datavalue=<STDIN>);

$datavalue=~s/\s//g;
print $datavalue;

printf "  kolbl {                                                      \n";
printf "    len             LobLocator length       =(Oub2) 0x%s (%d) \n",substr($datavalue,0,4),hex(substr($datavalue,0,4));
printf "    version         Version                 =(Oub2) 0x%s (%d) \n",substr($datavalue,4,4),hex(substr($datavalue,4,4));
printf "    lobflg1         Flag 1                  =(ub1)  0x%s (%d) \n",substr($datavalue,8,2),hex(substr($datavalue,8,2));
printf "        [0x00000002 KOLBLCLOB  char lob ]                     \n";
printf "    lobflg2         Flag 2                  =(ub1)  0x%s (%d) \n",substr($datavalue,10,2),hex(substr($datavalue,10,2));
printf "        [0x00000008 KOLBLINI   locator has been initialized]  \n";
printf "    lobflg3         Flag 3                  =(ub1)  0x%s (%d) \n",substr($datavalue,12,2),hex(substr($datavalue,12,2));
printf "    lobflg4         unused flag             =(ub1)  0x%s (%d) \n",substr($datavalue,14,2),hex(substr($datavalue,14,2));
printf "    bytelen         Char.Set ByteLength     =(Oub2) 0x%s (%d) \n",substr($datavalue,16,4),hex(substr($datavalue,16,4));
printf "    lobid           LobID (10 bytes)        =(kdlid)          \n";
printf "      KDLID (LobID) (10 bytes) {                              \n";
printf "        Instance=0, SOID=0x%s      \n"                           ,substr($datavalue,20,20);
printf "        The above LobID is a key into the LOBINDEX              \n";
printf "      }                                                         \n";
printf "                                                                \n";
printf "   }                                                            \n";
