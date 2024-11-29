# lib.awk - summarise a libcache dump
#
# Written (in haste) by Kev Quinn.
# Version 1.0.0b...................Handle max children better
#				   Print largest heapds if SGA heap dump found
# Version 1.0.1c...................Determine max child latch and generate
#				   	latch usage statistics
#				   Calculate Authorization data
# Version 1.0.1d...................Count pinned/locked objects
# Version 1.0.2....................Get schema name table max
# Version 1.0.3....................Support latch usage for Oracle8.0 as well
# Version 1.0.4....................Added FEEDBACK variable to show progress
#                                  and the SORT_SQL boolean to state whether
#                                  we should sort SQL or not.
# Version 1.0.5....................Minor change
# Version 1.0.6....................Handle "short" SQL statements and count
#                                  kept objects
# Version 1.0.7b...................Handle "short" SQL statements better
#                                  Cater for new latch format/bucket distr'n
#                                  Strip out carriage returns
# Version 1.0.8....................Correct handles/bucket
# Version 1.0.9....................Latch statistics need tweaking for 10.2.0.4
#                                  Added summary of kgl state object space
#
# TODO:
#  o remove duplicate handles
#
# Tailoring
# ~~~~~~~~~
# This script can be amended according to preference. Find the BEGIN section
# below and then you can change these variables as required :
#
# CHILD_THRESHHOLD
#  This is set to 10 and is used to record those shared pool objects that
#  have an excessive number of children, which may indicate a problem with
#  sharing statements correctly.
# FEEDBACK 
#  This is used to print a period for each FEEDBACK key tokens encountered in 
#  the trace file. For large librarycache dumps this shows that the awk script 
#  is still working. A value of zero turns off the feedback.
# SORT_SQL 
#  If set to zero then it will DISABLE the sorting of the SQL statements found 
#  in the librarycache dump. For large trace files it may be quicker to sort 
#  the SQL via an external tool or OS command. Any other value implies that 
#  the SQL should be sorted.
# SQLLEN   
#  This is the length that any SQL text found will be truncated to and later 
#  used for comparisons to other SQL statements.
#
# Improvements
#  o Calculate number of Invalidations (as a %)
#  o Incorporate code from many.awk to summarise the duplicated sql
############################################################################
############################################################################
function print_dot()
{
 dotcount++;
 if (FEEDBACK && !(dotcount%FEEDBACK))
   printf(".");
}
 
function sort(ARRAY,ELEMENTS,   _temp, _i,_j)
{
 for (_i=2; _i<= ELEMENTS; _i++)
  {
   for (_j=_i; ARRAY[_j-1] > ARRAY[_j]; _j--)
    {
     _temp = ARRAY[_j];
     ARRAY[_j] = ARRAY[_j-1];
     ARRAY[_j-1] = _temp;
    }
   #printf("Sort Loop %7d of %7d\n", _i, ELEMENTS);
  }

}
 
############################################################################
BEGIN			{BEFORE=0; NONE=1; INCHILD=2;INSQL=3;INNONE=NONE;
			 INHEAP=4; dotcount=0; FEEDBACK=50;
			 SQLLEN=70; SORT_SQL=1;
			 CHILD_THRESHHOLD=10;   # Limit to num of children
			 mb=1024.0*1024.0;
			 MAX_CT=50;             # Number of allocs for a subheap

nt[1]="There may be other buckets with the same count";
nt[2]="We believe that these chunks are likely to be reused";
nt[3]="This space is likely to be non-contiguous";
nt[4]="If space is exhausted, this memory can be released";
nt[5]="If there is a very high number then this *might* fragment memory";

sotype[1]="Load Locks";
sotype[2]="KGL pins";
sotype[3]="KGL locks";
sotype[4]="KGL S handles";
sotype[5]="KGL M handles";
sotype[6]="KGL L handles";
sotype[7]="KGL A handles";
sotype[8]="KGL objects";
sotype[9]="KGL handle dependents";
maxso = 9;
			}

# Skip rubbish
/^ *----/		{ next }
/^ *$/			{ next }
			{ sub("",""); }

# If we have heap information from the SGA then handle this as well.
/HEAP DUMP heap name="sga heap"/	{ state=INHEAP; seen_heap = 1; }

/Unpinned space.*rcr=/ 	{ gsub("=", " ");
			  unpin=$3; rcr=$5; trn=$7; next }

/^Permanent space allocated for/ { sub("Permanent space allocated for ", "");
                                   pspc=$0;
				   next;
                                 }

/^LATCH:.*SPACE/	{ so_space[pspc] += $(NF); next }
/^FREELIST CHUNK/	{ ccnt=$3; sub("COUNT:", "", ccnt);
                          csze=$(NF); sub("SIZE:", "", csze);
                          fl_ccnt[pspc] += ccnt;
                          fl_size[pspc] = csze;
                          next;
                        }

# Chunk 26fa7320 sz=      864    recreate  "sql area       "  latch=26fa2ae8
/^ *Chunk .* recreate /	{ if ($0 ~ "sql area") chtype="sqlarea";
                          else if ($0 ~ "library cache") chtype="libcache";
                          else if ($0 ~ "PL/SQL DIANA") chtype="diana";
                          else chtype="";
			  next;
                        }
/^ *Chunk/		{ chtype=""; next }

# Note: The ds element is the sum of all sizes for the given descriptor.
#       The "recreate" indicates that we are a subheap and (in the eg below);
#            3892 = 864 + 712 + 2316
# Chunk 26fa7320 sz=      864    recreate  "sql area       "  latch=26fa2ae8
#    ds 26fa7724 sz=     3892 ct=        3
#       23fb4fc0 sz=      712
#       25f00c4c sz=     2316
/^ *ds .* sz=/		{ 
                          heapds[$2] += $4; 
                          # conditionally deal with ct=. Not there in all 
			  # versions
                          if ($0 ~ " ct= ")
                           {
			    if ($NF > MAX_CT)
                             {
                              if (!ct[$NF]) 
                                ct_list = ct_list " " $NF;
			      ct[$NF] = ct[$NF] " " $2 "(" ($4/1024) ")";
                             }
                           }

			  if (heapds[$2] > maxds)
			   {
			    maxds = heapds[$2];
			    bigds = $2;
			   }
            
			  # TODO: Consider using a better technique for the 
			  #       code below
                          if (chtype=="sqlarea" && heapds[$2] > maxsqlarea)
                           {
                            maxsqlarea = heapds[$2];
                            bigds_sqlarea = $2;
                           }
                          else if (chtype=="libcache" && heapds[$2]>maxlibcache)
                           {
                            maxlibcache = heapds[$2];
                            bigds_libcache = $2;
                           }
                          else if (chtype=="diana" && heapds[$2]>maxdiana)
                           {
                            maxdiana = heapds[$2];
                            bigds_diana = $2;
                           }
			  next; 
			}

#  SCHEMA: count=3232 size=3232 entrysize=4
/^ *SCHEMA: count=/	{ gsub("=", " ");
			  if ($3 > maxschema) maxschema=$3;
			}
            

##############
/BUCKET [1-9][0-9]*:/	{ sub(":", ""); buck = $NF; }
/BUCKET/		{ parent_or_child="P"; }
/ANONYMOUS LIST:/	{ parent_or_child="C"; in_anon=1; }


/LIBRARY CACHE HASH TABLE: /	{ sumline=$0; next }
# LIBRARY OBJECT HANDLE: handle=e2c720c4
/^ *LIBRARY OBJECT HANDLE:/	{hdl=$4; sum_kglhdl++; 
				 print_dot();
                                 if (!in_anon)
                                  {
				   hdl_buck[buck]++;
                                   if (hdl_buck[buck]>hdl_buck[max_buck])
                                     max_buck = buck;
                                  }
                                  
				 kglcnt[parent_or_child]++;
				 state=NONE; next }

state==BEFORE			{ next; }

/^ *child# *table/		{ state=INCHILD; next;}

/^ *DATA BLOCKS/		{ state=NONE; }

#    child#    table reference   handle
#    ------ -------- --------- --------
#         0 e182e284  e182e220 e14b52a0
#    DATA BLOCKS:
state==INCHILD			{ childno[hdl] = $1;
                                  # child count starts from zero
				  if ($1 >= CHILD_THRESHHOLD &&
				   manychild[cc] != hdl) manychild[++cc]=hdl;
				}
# type=CRSR flags=EXS[0001] status=VALD load=0
/^ *type=.*flags/		{ if (!index(typelist, $1))
				   typelist=sprintf("%s %s", typelist, $1);
				  typecount[$1]++;
				} 

# namespace=BODY/TYBD flags=KGHP/TIM/KEP/SML/[02800000]
/namespace.*KEP/		{ sub("^.*flags=", "");
				  if ($0 ~ "KEP")
				    kept++;
				  if ($0 ~ "BSO")
				    bso++;
				}

#kk-dd-aa-ll=00-01-00-01 lock=N pin=0 latch=1
# OR
#kkkk-dddd-llll=0000-0101-0101 lock=0 pin=0 latch=2
# OR
#kkkk-dddd-llll=0201-0201-0201 lock=0 pin=0 latch#=35
/kk*-dd*-.*lock.*pin.*latch/	{ if ($3 != "pin=0") pin++;
			          lnum=$4;
                                  if ($4 ~ "latch=")
                                    sub("latch=", "", lnum);
                                  else
                                    sub("latch#=", "", lnum);
			    	  ilnum = lnum+0;	# Coerce to integer
			  	  if (ilnum > max_lnum) max_lnum = ilnum;
			  	  latch[ilnum]++;
                                  next;
				}

# AUTHORIZATIONS: count=283 size=288 entrysize=12
/AUTHORIZATIONS: count/ { tmp=$2; sub("count=", "", tmp);
			  itmp = tmp + 0;
			  sum_auth += itmp;
			  if (itmp > max_auth) 
			   { 
			    max_auth = itmp;
			    max_auth_handle = hdl;
			   }
			}

#    type=CRSR flags=EXS[0001] pflags= [00] status=VALD load=0
#
# According to comments in kgl.h we determine a non-existent object by
# type and flags fields.
#
/type=.*flags=.*pflags/	{ if ($1 == "type=NEXS" ||
			      $2 ~ "NEX")
			   nonexist++; }
 
/^ *Total /		{ gsub("=", " "); }
/^ *Total free space/	{ totfree=$NF; next }
/^ *Total reserved/	{ totfree_res=$NF; next }
/^ *Total heap size /	{ state=INNONE; totheap=$NF; next }

###############################
#  Code to help detect similar SQL
###############################
# Skip object names
/^ *name=[A-Z][A-Z0-9$]*\.[A-Z][A-Z0-9_$]* *$/	{ next };

# But capture "short" sql
/^ *name=[a-zA-Z].* *$/		{ sub("^ *name= *", "");
				  sub("  *", " "); # Compress
				  sql=toupper($0);
				  if (length(sql) > SQLLEN)
				   sql = substr(sql, 1, SQLLEN);
       
				  if (sql != "")
			            realsql[sqlid++] = sql;
				  next;
			        }

/^ *name= *$/			{ state=INSQL; sql=""; 
				  sqllen=0; sqlid++; next }

/^ *hash=/ && state==INSQL	{ state=INNONE; 
				  realsql[sqlid]=toupper(sql); next }

state==INSQL			{ sub("  *", " "); # Compress
                         	  sub("^ *", " ");
				  sql=sql " " substr($0,1,SQLLEN);
				  if (length(sql)>=SQLLEN)
				   {
				   state=INNONE;
				   realsql[sqlid]=toupper(substr(sql,1,SQLLEN));
				   next;
				   }
				}


END	{ printf("\nlib.awk version 1.0.9 (file: %s)\n\n", FILENAME);
	  printf("%s\n", sumline);
          printf("Handles with more than %d children :\n", CHILD_THRESHHOLD);
	  if (!cc) printf(" NONE\n");
	  else printf("%15s %9s\n", "Handle", "Count");
          # need to add 1 to child count because children start from zero offset
	  for (i=1; i<=cc; i++)
	    printf("%15s %9d\n", manychild[i], childno[manychild[i]]+1);

	  printf("\nSummary Info:\n~~~~~~~~~~~~~\n");
	  printf(" Number of KGL handles  = %d\n", sum_kglhdl);
	  printf("               Parents  = %d\n", kglcnt["P"]);
	  printf("              Children  = %d\n", kglcnt["C"]);
	  printf("   Non-existent handles = %d (%d %%) [-ve Dependencies]\n",
			   nonexist, sum_kglhdl?(nonexist/sum_kglhdl):0);
	  printf(" Max handles per bucket = %d (bucket %s) (Note (1))\n",
		hdl_buck[max_buck], max_buck);
	  printf("     Max Authorizations = %d (%s)\n", max_auth,
				max_auth_handle);
	  printf("   Total Authorizations = %d\n", sum_auth);
	  printf("  No. of Pinned Objects = %d\n", pin);
	  printf("  No. of Kept   Objects = %d (%d are bootstrap objects)\n",
                     kept, bso);
          printf("  Max schema name table = %d\n", maxschema);
          
          printf("\nState Object Space Usage (approx):\n");
          for (k=1; k<= maxso; k++)
          {
            so = sotype[k];
            printf("%-21s space=%9.2fM freelist chunks=%6d x %4d=%9.2fM\n",
                    so, so_space[so]/(1024.0*1024.0), fl_ccnt[so], fl_size[so],
                    (fl_ccnt[so]*fl_size[so])/(1024.0*1024.0));
          }

	  t = split(typelist, tar, " ");
	  printf("\nSummary of Types :\n");
	  for (i=1; i<=t; i++)
	    printf("  %9s %5d %s\n", tar[i], typecount[tar[i]],
                (tar[i]=="type=?")?"See bug 683912": "");
	  
	  if (seen_heap)
	   {
             printf("\nLargest '%-13s' user was ds %s, size %12d (%9.2f MB)\n",
               "heap", bigds, maxds, maxds/mb);
            if (maxsqlarea)
             printf("Largest '%-13s' user was ds %s, size %12d (%9.2f MB)\n",
               "sql area", bigds_sqlarea, maxsqlarea, maxsqlarea/mb);
            if (maxlibcache)
             printf("Largest '%-13s' user was ds %s, size %12d (%9.2f MB)\n",
               "library cache", bigds_libcache, maxlibcache, maxlibcache/mb);
            if (maxdiana)
             printf("Largest '%-13s' user was ds %s, size %12d (%9.2f MB)\n",
               "pl/sql diana", bigds_diana, maxdiana, maxdiana/mb);

             printf("\nTotal heap size             = %12d (%9.2f MB)\n",
                 totheap, totheap/mb);
             printf("Total free space            = %12d (%9.2f MB)\n",
 		 totfree, totfree/mb);
             printf("Total free space (reserved) = %12d (%9.2f MB)\n",
                 totfree_res, totfree_res/mb);
             printf("Total releasable space      = %12d (%9.2f MB) %s\n\n",
               unpin, unpin/mb, "See Notes (3) and (4)");

             printf("# of recurrent chunks = %5d (See Note (2))\n", rcr);
             printf("# of transient chunks = %5d\n", trn);
	   }

          if (ct_list)
           {
            printf("\nList of descriptors with >%d allocations\n\n", MAX_CT);
            t = split(ct_list, tds, " ");
            printf("%5s List of Descriptors with this count %s\n", 
             "Count", "(memory, in KB, consumed)");
            printf("%5s ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%s\n", 
             "~~~~~", "~~~~~~~~~~~~~~~~~~~~~~~~~~");
	    for (i=1; i<t; i++)
             {
              printf("%5d %s\n", tds[i], ct[tds[i]]);
              if (tds[i] > maxtds) maxtds = tds[i];
             }
            printf("Maximum allocations seen = %d (See Note (5))\n\n", maxtds);
           }

         printf("\nSpread of Child Latches (max = %d)\n", max_lnum);
         latch_lo = -1; latch_hi = -2;
         latch[latch_lo] = 9999999; 
         latch[latch_hi] = -1;
	 for (i=1; i<=max_lnum; i++)
          {
           if (latch[i] < latch[latch_lo]) latch_lo = i;
           if (latch[i] > latch[latch_hi]) latch_hi = i;
	   printf("Latch %4d count = %6d\n", i, latch[i]);
          }
         printf("Latch %4d has smallest count of %d objects\n", 
             latch_lo, latch[latch_lo]);
         printf("Latch %4d has largest  count of %d objects\n", 
             latch_hi, latch[latch_hi]);

         printf("\nNotes:\n");
         for (i=1; nt[i]; i++)
           printf("(%d) %s\n", i, nt[i]);

	  printf("\nSQL Statements (compressed) that we saw (%d stmts):\n",
			sqlid);
          printf("[The output is %s]\n", SORT_SQL?"sorted":"unsorted");
          if (SORT_SQL)
           {
            if (FEEDBACK) printf("\nStarting to sort SQL statements...\n");
	    sort(realsql, sqlid);
           }

	  for (i=1; i<=sqlid;i++)
           {
            tsql = realsql[i];
	    gsub("^ *$", "", tsql);
            if (tsql != "")
	     printf("  %s\n", realsql[i]);
	   }

	}
