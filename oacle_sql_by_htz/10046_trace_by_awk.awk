#!/usr/bin/gawk -f
#
# IMPORTANT:  Must be run using Gawk
#             may appear to run on other versions of awk but may have incorrect results
#             gawk is available on number of OS's including solaris.
#
# Nigel Noble - September 2006 - The Sporting Exchange
#             - This version supports Oracle 10g and should work on 11g
#             - A separate version is available for 9i (Only slight changes)
#
#
# Version 1.0 nigelnoble.wordpress.com version available for download - June 2010
#
# ACKNOWLEDGMENT:
#  This script is based on a script by James Morle (tclconv.awk). tclconv.awk was
#  included in his book "Scaling Oracle 8i". I have "nicked" the cursor tracking code
#  and chopped the rest out.
#  Note: safe to assume the well written awk is James's and the not so well written is mine!!!
#
#  This script includes two copyright notices. One for trace_by_hash.awk (this) and the other taken from
#  the original "Scaling Oracle 8i" CD to cover James Morle's tclconv.awk script
############################################################################################################
# trace_by_hash.awk
#
#  Copyright (c) 2010, The Sporting Exchange
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without modification, are permitted provided
#  that the following conditions are met:
#
#       o Redistributions of source code must retain the above copyright notice, this list of conditions and
#         the following disclaimer.
#       o Redistributions in binary form must reproduce the above copyright notice, this list of conditions
#         and the following disclaimer in the documentation and/or other materials provided with the distribution.
#       o Neither the name of The Sporting Exchange nor the names of its contributors may be used to
#         endorse or promote products derived from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
#  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
#  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
#  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
#  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
#  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.
############################################################################################################
# tclconv.awk - Notice taken from "Scaling Oracle 8i" by James Morle
#
#  This software is copyrighted by James Morle (Author).
#
#  The following terms apply to all files associated with the software unless explicitly disclaimed in individual files.
#
#  The author hereby grants permission to use, copy, modify, and distribute this software and its documentation for
#  any purpose, provided that this notice is retained and included in any such distribution.
#
#  NO WARRANTY, IMPLIED OR OTHERWISE, IS SUPPLIED WITH THIS SOFTWARE OR ITS DERIVATIVES. THE AUTHOR SPECIFICALLY DISCLAIMS
#  ANY AND ALL LIABILITY ARISING FROM THE USE OF THIS SOFTWARE. THE SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, AND THE
#  AUTHOR HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, OR UPDATES TO THE SOFTWARE.
#
############################################################################################################
# trace_by_hash.awk
# #################
#
# Change cursor numbers to be hash values
#      Allows for consistent matching when cursors are opened and closed during a run.
# also:
#      Can add PARSING IN CURSOR text to executions to make reading simpler
#      Allows part trace files to run through tkprof without needing original parse call (Need to switch
#      off the other formatting / indent changes).
# also:
#      Can build a hash file which links all sql to parent pl/sql calls (type 47 declare/begin calls
# also:
#      Can indent calling levels for easier trace file reading.
#
# Also, Option to replace tim= with real time (in seconds). Currently works out base time for a
#       set of messages written into the top of the trace file. These will have to be set manual
#       for a live db trace. This is still under development and will hopefully be made simpler.
#
#       The times are more accurate if you are able to write the epoch time and run sql statement
#       at the same point in time in the top of the trace file.
#
#       If you are not able to write the timer message in the top of the trace file, then we make
#       an approximate attempt. We take the first oracle time stamp for the session and convert this to
#       an epoch time, then we take the first tim= (which might be some time later) and assume
#       these are for the same time.
#
#       NOTE: tim= values are actually the time from when the machine was first started and can be
#             converted on some OS's but does not seem to work on Solaris. What we do is to take a
#             tim= value when we know the time and use this as the base time.
#
#
# Also,
#       September 2007
#       Process bind variables into a format which can be later parsed.
#       example way to process DUMPSTAT line
#       grep DUMPSTAT out of hash_by_binds10.awk
#       cat bind_stats.txt | sort|uniq -c | sort -rn | gawk '{print substr($0,index($0,"BINDSTAT")) "   "  $1;}' | sort
#
#       known bug: Does not track binds for actual call to plsql. Problem is that all the sql inside the plsql appears before
#       we know which cursor we are on.
#       Can be fixed at some point. Just needs to remember the last binds for the current depth.
#
##################################################################################################
# Begin section:
#####
BEGIN                           {
###################################################
#
#                                 configure options
#                                 #################
#
#
#                                 switch parse sql text on every execution
                                  debug=1;
#                                 convert cursor numbers to hash_value
                                  sqlhash_for_cursor=1;
#                                 indent sql depth. 0=none, 5 works well
                                  indent_level=5;
#                                 add approx clock  0=off, 1=on
                                  clock_time_on = 1;
#                                 attempt to generate mapping of sql to parent plsql call
#                                 0 = off and 1=on
                                  generate_hash_file=0;
                                  hash_file="hash.txt"
#
#
###################################################
#
                                  padding="                                                           ";
                                  display_time="";
                                  current_pad = "";
                                  poslog=1;
                                  in_bind=-1;
                                  bind_pos=-1;
                                  nbinds=0;
                                  lasttim=0;
                                  oraver=0;
                                  parent_depth=0;
                                  found_base_time=0;
                                  current_human_time="";
                                  one_space="";
                                  first_tim_found=0;
                                  inside_binding=0;
                                }
# grab c= and e= values
 
/^[A-Z]+ #[0-9].*,e=/           {
 
                                }
################################################################################
# Keep track of timing information
#####
/tim=[0-9]+$/                   { newtim=substr($0,match($0,"tim=[0-9]+$")+4);
                                  if (first_tim_found==0)
                                  {
                                      base_tim=newtim;
                                  }
                                  first_tim_found=1;
                                  if (oraver==0) {
                                        if (length(newtim)>15)
                                                oraver=9;
                                        else
                                                oraver=8;
                                  }
                                  diff=newtim-lasttim;
                                  lasttim=newtim;
 
                                  # add timing information
                                  #print "BASE TIME= " base_tim " " base_epoch;
                                  current_tim=newtim;
                                  #print " NOW TIME= " current_tim;
                                  current_seconds = sprintf("%.0f",(current_tim - base_tim) / 1000000 );
                                  current_epoch = base_epoch + current_seconds;
                                  #print "current_seconds = " current_seconds;
                                  #print "current_epoch = " current_epoch;
                                  if (found_base_time > 0) {
                                      if (clock_time_on > 0) {
                                              current_human_time = sprintf("%s %8.8s" ,strftime("%F %T",current_epoch), diff);
                                              one_space = " ";
                                      }
                                  }
                                }
#################################################################################
#/e=[0-9]+,/                    { n=split($0,temp_array,",");
#                                  elapsed=temp_array[2];
#                                  gsub("e=","",elapsed);
#                                  print elapsed;
#}
################################################################################
# Attempt to get the time the trace was switched on. In the worst case, this can
# be use to provide aprox timing to the offsets of the tim= column.
#
#/*** SESSION ID:(64.53566) 2006-10-13 10:04:36.744
/*** SESSION ID:/ {
                    print "SESS " $4;
                    print "SESS " substr($5,1,8);
#                 YYYY MM DD HH MM SS
                    sess_time=$4 " " substr($5,1,8);
                    gsub("-"," ",sess_time);
                    gsub(":"," ",sess_time);
                    sess_epoch = mktime(sess_time);
                    print sess_epoch;
                    base_epoch = sess_epoch;
                    # Apox time being used
                    found_base_time=2;
}
################################################################################
# New cursor definition starting. We use the cur2hash array to associate
# the current cursor context to hash values, ie Cursor 4 has hash value XYZ.
# If there is an open cursor in this cursor handle, take care of the implicit
# close of the cursor (not reported explicitly in the trace file)explicitly
# If running in OCI7 mode:
#   Build the oci_open call for the statement. Actually, the PARSING IN
#   structure in the trace file implies an OPEN call, not a PARSE call,
#   as there is an explicit PARSE call later on...
#####
#####PARSING IN CURSOR #25 len=68 dep=2 uid=0 oct=42 lid=0 tim=2802023202583 hv=2212335334 ad='2d39f3a8'
/PARSING IN CURSOR/     {
#                                 get the depth of the statement
                                  level_depth=$6;
                                  gsub("dep=","",level_depth);
                                  current_pad=substr(padding,1,level_depth * indent_level);
#
                                  new_curs=1;
                                  current=substr($4,2);
                                  if (current in cur2hash) {
#                                       delete text[cur2hash[substr($4,2)]];
                                        delete cur2hash[substr($4,2)];
                                  }
                                  cur2hash[current]=sprintf("%s_%s",
                                          substr($(NF-1),4),
                                          substr($NF,5,8));
                                  actflg[current]=0;
                                  parseflg[current]=0;
 
                                  sql_hash_value[current]=substr($11,4);
 
                                  if (sqlhash_for_cursor==1) {
                                         s=sprintf ("PARSING IN CURSOR #%d %s %s %s %s %s %s %s %s %s" ,sql_hash_value[current],
                                             $5,$6,$7,$8,$9,$10,$11,$12,$13);
                                         print current_human_time one_space current_pad s;
                                         parsing_in_cursor[current]=s;
                                  }
                                  else {
                                         print current_pad $0;
                                         parsing_in_cursor[current]=$0;
                                  }
                                  temp_command=$8;
                                  gsub("oct=","",temp_command);
                                  parsing_in_command[current]=temp_command;
                                  temp_hash=$11;
                                  gsub("hv=","",temp_hash);
                                  parsing_in_hv[current]=temp_hash;
#print "----------------- "  parsing_in_hv[current];
 
                                  next;
                                }
################################################################################
# new_curs flag is raised when we see 'PARSING IN CURSOR'. When we see
# 'END OF STMT', we can turn it off again - no more SQL text for this cursor.
#####
/END OF STMT/                   {
#hope this line is ok
                                  cnum=current;
                                  dbind=dump_binds();
                                  print current_human_time one_space current_pad $0;
                                  new_curs=0;
                                  next;
                                }
#
#
#BINDS #8:
#kkscoacd
# Bind#0
#  oacdty=02 mxl=22(22) mxlc=00 mal=00 scl=00 pre=00
#  oacflg=03 fl2=1000000 frm=01 csi=871 siz=24 off=0
#  kxsbbbfp=ffffffff7aeeab28  bln=22  avl=05  flg=05
#  value=1365020
#
################################################################################
/^ Bind/                        {
                                  current_binding_count=current_binding_count+1;
                                  current_binding_id=substr($0,index($0,"#")+1);
                                  print current_human_time one_space current_pad $0;
                                }
################################################################################
/^  oacdty=/                      {
                                  print current_human_time one_space current_pad $0;
                                }
################################################################################
/^  oacflg=/                      {
                                  print current_human_time one_space current_pad $0;
                                }
################################################################################
/^  kxsbbbfp=/                      {
                                  print current_human_time one_space current_pad $0;
                                }
################################################################################
/^Dump of memory from/                      {
                                  print current_human_time one_space current_pad $0;
                                  getline;
                                  print current_human_time one_space current_pad $0
                                }
################################################################################
/^  value=/                        {
                                  current_binding_value=substr($0,index($0,"value=")+6);
                                  len_value=length(current_binding_value);
                                  if ( len_value == 0)
                                  {
                                          current_binding_value = "<x>";
                                  }
                                  binds_array[current_binding_cursor "," current_binding_id] = current_binding_value;
                                  print current_human_time one_space current_pad $0;
                                }
################################################################################
# If we are in SQL text territory, append all the text to the text[] array.
# We throw a space between the lines in order to ensure all parses correctly
# in the PARSE stage. It sometimes results in double spaces compared to the
# original statement, but we don't really care too much about having
# *identical* text.
#####
new_curs==1                     {
#                                 attempt to get base start tim= for replacement with real time.
                                  if (index($0,"FORCE GENERATION OF KNOWN BASE")) {
                                     base_timing_sql = 1;
                                  }
                                  else {
                                     base_timing_sql = 0;
                                  }
#
 
                                    print current_human_time one_space current_pad $0;
                                    if ( substr(text[cur2hash[current]],
                                                2,length($0))== $0 ) {
                                        # .... then we don't need to proceed
                                        # restoring this cursor - its a dup.
                                        new_curs=0;
                                        next;
                                  } else {
                                        text[cur2hash[current]]=sprintf("%s %s",
                                                text[cur2hash[current]],$0);
                                          next;
                                  }
                                }
################################################################################
/^EXEC #/ && base_timing_sql==1  {
                                  dbind=dump_binds();
                             n=split($0,temp_array,",");
                             gsub("tim=","",temp_array[10]);
                             base_tim=temp_array[10];
                             found_base_time =1;
}
/^SWITCHSQLTRACE /               {
                                 base_epoch = $3;
}
################################################################################
# The explicit PARSE call. Some statements can get pretty long, so we fold the
# string to allow editing of the script with vi.
#####
/^PARSE #/              {
                                  prev_level_depth=level_depth;
#                                 get the depth of the statement
                                  n=split($0,temp_array,",");
                                  level_depth=temp_array[8];
                                  gsub("dep=","",level_depth);
                                  current_pad=substr(padding,1,level_depth * indent_level);
#
                                  cnum=substr($2,2,index($2,":")-2);
                                  dbind=dump_binds();
                                  if (actflg[cnum]==1)
                                        printf("oci_cancel %d\n",cnum);
                                  parseflg[cnum]=1;
 
                                  if (debug>2) {
                                  printf("oci_parse %s %d { %s } \n",
                                        assign, cnum,
                                        foldit(text[cur2hash[cnum]]));
                                  }
 
                                  temp_value=$0;
                                  gsub(/#.*:/,"#" sql_hash_value[cnum]":",temp_value);
                                  if (sqlhash_for_cursor==1) {
                                         print current_human_time one_space current_pad temp_value;
                                  }
                                  else {
                                         print current_human_time one_space current_pad $0;
                                  }
                                  if (parsing_in_command[cnum] == 47) {
                                     if (generate_hash_file > 0) {
                                         tmp_sql = text[cur2hash[cnum]];
                                         gsub("'","",tmp_sql);
                                         print "insert into sql (area,hash_value) values ('" parsing_in_hv[cnum] "- " tmp_sql "',0);">> hash_file;
                                         print "insert into sql (area,hash_value) values ('" parsing_in_hv[cnum] "'," current_pad " " parsing_in_hv[cnum] ");" >> hash_file;
                                     }
                                      parent_hash = parsing_in_hv[cnum];
                                      parent_depth = level_depth;
                                  }
 
                                  if (level_depth > parent_depth) {
                                    if (generate_hash_file > 0) {
                                       print "insert into sql (area,hash_value) values ('" parent_hash "'," current_pad " " parsing_in_hv[cnum] ");" >> hash_file;
                                    }
                                  }
                                }
################################################################################
# The EXEC section. If the statement has not been parsed already, we need to
# do it implicitly. If the cursor is already open and in context, we need to
# cancel that prior cursor first.
# A comment line is output just above the EXEC to make the TCL script easy to
# read and edit later.
#####
#EXEC #25:c=0,e=71,p=0,cr=0,cu=0,mis=0,r=0,dep=2,og=4,tim=2802023206653
/^EXEC #/               {
                                  prev_level_depth=level_depth;
#                                 get the depth of the statement
                                  n=split($0,temp_array,",");
                                  level_depth=temp_array[8];
                                  gsub("dep=","",level_depth);
                                  elapsed=temp_array[2];
                                  gsub("e=","",elapsed);
                                  last_at_tim = at_tim;
                                  at_tim=temp_array[10];
                                  gsub("tim=","",at_tim);
 
                                  current_pad=substr(padding,1,level_depth * indent_level);
#
                                  cnum=substr($2,2,index($2,":")-2);
#wait until we know what current cursor is
                                  dbind=dump_binds();
                                  current=cnum;
                                  if (parseflg[cnum]!=1) {
                                        if (debug>2) {
                                            printf("oci_parse %d { %s }\n",
                                                cnum,
                                                text[cur2hash[cnum]]);
                                        }
                                        parseflg[cnum]=1;
                                  }
 
                                  st=substr($0,match($0,":c=[0-9]+")+3);
                                  c=substr(st,0, match(st,",e=[0-9]")-1);
                                  e=substr(st,length(c)+4, match(st,",p=[0-9]")-length(c)-4);
                                  cCache[current]=c;
                                  eCache[current]=e;
 
                                  #if (debug>0) {
                                  #   printf("EXEC_text #%d:%s:%s\n",cnum,sql_hash_value[cnum],
                                  #     substr(text[cur2hash[cnum]],1,100),1,60);
                                  #}
                                  actflg[cnum]=1;
 
                                  if (debug>0) {
                                          print current_human_time one_space current_pad "=====================" ;
                                          print current_human_time one_space current_pad parsing_in_cursor[cnum];
                                          print current_human_time one_space current_pad text[cur2hash[cnum]];
                                          print current_human_time one_space current_pad "END OF STMT";
                                  }
 
                                  temp_value=$0;
                                  gsub(/#.*:/,"#" sql_hash_value[cnum]":",temp_value);
                                  #print "                         " at_tim - last_at_tim " "elapsed ;
                                  if (sqlhash_for_cursor==1) {
                                         print current_human_time one_space current_pad temp_value;
                                  }
                                  else {
                                         print current_human_time one_space current_pad $0;
                                  }
 
                                  #dump the full sql for the executing sql statement
                                  #printf("oci_sql_text %s %d { %s } \n",
                                  #             assign, cnum,
                                  #foldit(text[cur2hash[cnum]]));
 
                                  # print hash & parent
                                  if (level_depth > parent_depth) {
                                     if (generate_hash_file > 0) {
                                       print "insert into sql (area,hash_value) values ('" parent_hash "'," current_pad " " parsing_in_hv[cnum] ");" >> hash_file;
                                     }
                                  }
 
                              #    # add timing information
                              #    #print "BASE TIME= " base_tim " " base_epoch;
                              #    current_tim=temp_array[10];
                              #    gsub("tim=","",current_tim);
                              #    #print " NOW TIME= " current_tim;
                              #    current_seconds = sprintf("%.0f",(current_tim - base_tim) / 1000000);
                              #    current_epoch = base_epoch + current_seconds;
                              #    #print "current_seconds = " current_seconds;
                              #    #print "current_epoch = " current_epoch;
                              #    current_human_time = strftime("%F %T",current_epoch);
                                }
################################################################################
# The FETCH section. One of the more straghtforward tokens to deal with.
# Pulls out the number of rows and makes a call to fetch that number. If the
# tracefile shows 0 rows fetched (ie no data found), we still do the fetch,
# but for just one row (knowing that it will return zero rows, all things being
# equal).
#####
/^FETCH #/              {
                                  cnum=substr($2,2,index($2,":")-2);
                                  dbind=dump_binds();
                                  off=index($0,",r=")+3;
                                  rows=substr($0,off,index($0,",dep=")-off);
                                  if (rows<1)
                                        rows=1;
#
#
                                  temp_value=$0;
                                  gsub(/#.*:/,"#" sql_hash_value[cnum]":",temp_value);
                                  if (sqlhash_for_cursor==1) {
                                         print current_human_time one_space current_pad temp_value;
                                  }
                                  else {
                                         print current_human_time one_space current_pad $0;
                                  }
 
                                }
################################################################################
/^WAIT #/               {
                                  cnum=substr($2,2,index($2,":")-2);
                                  dbind=dump_binds();
                                  temp_value=$0;
                                  if (length(sql_hash_value[cnum])==0)
                                  {
                                       null_test=0;
                                  }
                                  else
                                  {
                                      gsub(/#.*:/,"#" sql_hash_value[cnum]":",temp_value);
                                  }
                                  if (sqlhash_for_cursor==1) {
                                         print current_human_time one_space current_pad temp_value;
                                  }
                                  else {
                                         print current_human_time one_space current_pad $0;
                                  }
 
                        }
################################################################################
/^STAT #/               {
                                  tmp=$2;
                                  gsub(/#/,"",tmp);
                                  cnum=tmp;
                                  dbind=dump_binds();
                                  temp_value=substr($0,index($0,"id="));
                                  if (sqlhash_for_cursor==1) {
                                         if (length(sql_hash_value[cnum])==0) {
                                             print current_human_time one_space current_pad $0;
                                         }
                                         else {
                                              print current_human_time one_space current_pad "STAT #" sql_hash_value[cnum] " " temp_value;
                                         }
 
                                  }
                                  else {
                                         print current_human_time one_space current_pad $0;
                                  }
                        }
################################################################################
/^=====================/                {
                                 print current_human_time one_space current_pad $0;
                        }
################################################################################
# Start of the BIND section. The BIND directive does not contain any recursive
# state information, and so we need to use the cur2hash array as the master
# to determine whether this is a recursive statement, or not.
# Checks the status flags to to determine whether or not a cancel is required
# prior to binding (ie, a re-execution of the cursor). A stack is used to place
# the calls in, as an empty BINDS section is used when there are no bind
# variables in the cursor. We do not know this until we get to the individual
# bind variable definitions, so the stack is used to control whether the calls
# are printed, or not.
#####
/^BINDS #/                      {
                                  cnum=substr($2,2,length($2)-2);
                                  if (cnum in cur2hash) { # If not a recursive BIND
                                        in_bind=cnum;
                                        if (actflg[cnum]==1) {
                                                actflg[cnum]=0;
                                        }
                                  }
# note: can't map cursor to hash as this stage as binds are before parses
#
                                  temp_value=$0;
                                  gsub(/#.*:/,"#" sql_hash_value[cnum]":",temp_value);
#                                  if (sqlhash_for_cursor==1) {
#                                         print current_human_time one_space current_pad temp_value;
#                                  }
#                                  else {
                                         print current_human_time one_space current_pad $0;
#                                  }
                                  inside_binding=1;
                                  current_binding_cursor=cnum;
                                  current_binding_count=0;
                                }
 
################################################################################
#
# Handle transaction directives. Only simple commit or rollbacks currently supported.
#
#####
/^XCTEND/                       {
                                  dbind=dump_binds();
                                   print current_human_time one_space current_pad $0;
                                }
################################################################################
# End of pattern/action section.
################################################################################
 
################################################################################
# Functions
################################################################################
#
function dump_binds ( ) {
 
         if (inside_binding ==1)
         {
#    print ">>>>>>>> Exit line from binds>>>>" $0;
           inside_binding=0;
               b=0
               bind_line="";
               while ( b < current_binding_count )
               {
                     bind_line = bind_line ", " binds_array[current_binding_cursor "," b] ;
                     b=b+1;
               }
               short_sql=substr(text[cur2hash[cnum]],1,80);
               #is there a comment
               comment = "";
               if (index(short_sql,"*/") > 0)
               {
                   comment = substr(short_sql,index(short_sql,"/*"), index(short_sql,"*/") - index(short_sql,"/*") + 2);
               }
               if (length(comment) == 0)
               {
                   comment = substr(text[cur2hash[cnum]],1,40) ;
               }
               print current_human_time one_space current_pad "BINDDUMP# ," comment ", " sql_hash_value[cnum] ", num_binds ," current_binding_count ", bind_data"   bind_line;
               print current_human_time one_space current_pad "BINDSTAT# ," sql_hash_value[cnum] ", num_binds ," current_binding_count ", sql, ~ ," comment "~"
               text[cur2hash[cnum]];
         }
         return 0;
}
################################################################################
# push() - pushes the supplied item onto the stack.
#####
function push ( item )  {
 
        stack[sptr++]=item;
 
}
################################################################################
# pop() - pops one item off the stack.
#####
function pop ( )        {
 
        return stack[--sptr];
 
}
 
################################################################################
# addWatchList() - Add a value to the watchlist.
#####
function addWatchList(ind,val) {
        gsub(/"/,"",val);
        watchList[ind]=val
}
 
################################################################################
# checkWatchList() - Check for value on the watchlist.
#####
function checkWatchList(val) {
        nval=val
        gsub(/"/,"",nval);
        for (i in watchList) {
                if (watchList[i]==nval) {
                        return i;
                }
        }
        return 0;
}
################################################################################
# foldit() - If the supplied str is longer than 60 characters, attempt to
# insert newlines as close to every 60th column as possible. Care is taken to
# to only split on comma boundaries, and not at all if inside a literal string.
# Net result is that some lines can be quite a bit longer than 60 characters,
# but still a good deal more manageble than before!
#####
function foldit (str)   {
 
        ovl=0;
        done_nl=0;
        in_lit=0;
        ostr="";
 
        if (length(str)>60)
                for(i=1;i<=length(str);i++) {
                        ch=substr(str,i,1);
                        if (ch~/[\"\']/)
                                in_lit=!in_lit;
                        if ((ovl || (i%60>50)) && !(done_nl))
                                if ((ch==",") && (in_lit==0) ) {
                                        done_nl=1;
                                        ovl=0;
                                        ostr=ostr ch "\n";
                                } else  ostr=ostr ch;
                        else ostr=ostr ch;
 
                        if (i%60==0 && done_nl==1)
                                done_nl=0;
                        else if (i%60==0 && done_nl==0)
                                ovl=1;
                }
        else ostr=str;
 
        return ostr;
}
################################################################################
# End
################################################################################