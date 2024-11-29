# sumheap.awk - Summarize Output from "heap.awk"
#
# PURPOSE
#  This script has been developed so that it processes the output from
#  multiple heap.awk runs and then highlights the areas of memory that have
#  have change. The primary purpose is to detect memory GROWTH.
#
# INPUT
#  The expected input is a SINGLE file which consists of multiple heap.awk
#  output files (which I will call "samples"). Before concatenation of the
#  files that are altered so that each line is preceded by a sample number
#  AND a space.
#
#  Eg, let's say we have 2 sample files. If you have access to "vi" then 
#  edit the 1st file and enter :
#
#     :1,$s/^/1 /g
#
#  Do the same for the 2nd file but use :1,$s/^/2 /g
#
#  Repeat for other samples if more than 2. In general, if you need to change
#  sample number X then use the following (replacing X as appropriate) :
#
#     :1,$s/^/X /g
#  
# ASSUMPTIONS
#  1. Samples start from 1 and increase sequentially
#  2. At least 2 samples are given
#  3. Samples are expected to correlate with the timeline. Eg, if sample #1
#     is taken at time t1, then sample#2 will be a time t1+x etc.
#  4. Only 1 heap is dumped and it is the same across samples
#  5. We just compare the start and end samples to determine the biggest user
#     of memory growth. (The output can be checked to see if we have an
#     interim large consumer of memory).
#
# HISTORY
#  v1.0.0a  Feb 2003  Creation
#  v1.0.0b  Jun 2003  Improve error handling
#  v1.0.1   Aug 2003  Handle version 1.3 heap.awk output
#  v1.0.2   Nov 2009  Don't include "Free(heap.awk)" in the max growth

function abs(_val)
{
 return (_val > 0) ? _val : (_val * -1);
}

BEGIN	{ version="V1.0.1";	# current version
	  heapver="1.2"; 	# minimum heap.awk version supported
	  mb=1024.0*1024.0;	# constant for ease of use
          PRTLIM=0.0050; 	# Don't worry about differences of this size

msg[1]="Wrong version of heap.awk used to create input files";
msg[2]="Samples out of order or are incorrect";
			       }

# Summary (Version 1.2)
/^[1-9][0-9]* Summary .Version/	       { ver=$4;
                                 # strip trailing parenthesis
				 ver=substr(ver, 1, length(ver)-1);
				 if (ver < heapver)
				  {
				   lno=NR;
				   err=1;
				   adderr="Version required is " heapver ", version seen is " ver;
                                   exit; # transfer processing to END block
				  }
			         next;
			       }

/^[1-9][0-9]* *Type .*Percent/ { 
				if (sample && 
				    (sample > $1+2 || $1 < sample))
				 {
				  err=2;
				  lno=NR;
				  adderr="Previous sample was " sample ", next was " $1;
				  next;
				 }
			        go=1; sample=$1; 
			        getline; next; # skip underline as well
 			       }

/^[1-9][0-9]* Total =/	       { go=0; next }

go != 1	 { next }
err != 0 { next }

# Expected format :
# 
# sample# comment count sum average percent

NF>=6   { pcnt=$(NF); avg=$(NF-1); sum=$(NF-2); cnt=$(NF-3);
	  sub("^[1-9][0-9]*", "");
          sub(" [1-9][0-9]* *[1-9][0-9]*.*$", ""); 
	  sub("^ *", "");
	  sub(" *$", "");
	  ucomm = comm = $0;
	  #printf(">%s<\n", $0);
	  gsub(" ", "_", ucomm);
	  if (!index(all_comms, ucomm))
	    all_comms = all_comms " " ucomm;
	  all_sum[sample, comm] = sum;
          if (sum != all_sum[1, comm]) seen_diff[comm] = 1;
          if (sample == 1)
            minval[comm] = sum;
          else if (sum < minval[comm])
            minval[comm] = sum;
          if (sum > maxval[comm])
            maxval[comm] = sum;

          if (sample != 1 && 
              comm != "Free(heap.awk)" &&
              sum-all_sum[1, comm] > maxgrow[comm])
           {
	    maxgrow[comm] = sum - all_sum[1,comm];
            if (maxgrow[comm] > biggest)  
             {
              biggest = maxgrow[comm];
              biggestcom = comm;
             }
	   }
	}

END	{ if (err)
	    printf("Error at line %d\n%s\nAdditional Info: %s\n", 
			lno, msg[err], adderr);
	  else
	  {

	  printf("Memory that has changed across samples :\n\n");
          #printf("DBG> %s\n", all_comms);
  	  ncom = split(all_comms, xcom, " ");
  	  # printf("DBG> Count=%d\n", ncom);
	  for (i=1; i<=ncom; i++)
	   {
            gsub("_", " ", xcom[i]);
            if (!seen_diff[xcom[i]]) continue;

	    # printf("DBG> Comm: %s max=%d min=%d\n", xcom[i],
            #       maxval[xcom[i]], minval[xcom[i]]);
	    # Assume ascending sample # and more than 1 sample
            printf("%-20s %10d", xcom[i], all_sum[1, xcom[i]]);
	    for (j=2; j<=sample; j++)
              printf(" %10d", all_sum[j, xcom[i]]);
            printf("\n");
	   } # end i

         printf("\nMax Growth is '%s' of %d bytes (%7.2fK, %7.2fM)\n", 
               biggestcom, biggest, biggest/1024.0, biggest/mb);

         printf("\n%-20s %-13s%-13s\n%s %s %s\n", "Comment", "Variance(MB)",
            "Strt->End(MB)", "~~~~~~~~~~~~~~~~~~~~", 
             "~~~~~~~~~~~~", "~~~~~~~~~~~~~");
         for (i=1; i<=ncom; i++)
          {
# printf("DBG> %s max=%d min=%d\n", xcom[i], maxval[xcom[i]] , minval[xcom[i]]);
           if (!seen_diff[xcom[i]]) continue;
           diff  = maxval[xcom[i]] - minval[xcom[i]];
           if (abs(diff/mb) <= PRTLIM) continue;
           printf("%-20s%13.2f %13.2f\n", xcom[i], diff/mb, 
                      (all_sum[sample, xcom[i]]-all_sum[1, xcom[i]])/mb);

          }
printf("\nVariance : The biggest variance across samples that was seen\n");
printf("Strt->End: The difference between first and last sample\n");
printf("           (Negative values indicate a reduction in the statistic)\n");
printf("\nValues with a difference of %7.5f MB are ignored\n", PRTLIM);
         }
	}
