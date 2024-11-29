# sgastat.awk  
#
# Purpose
# ~~~~~~~
# This takes a spooled output from selecting from v$sgastat multiple times
# and determines which types of memory are increasing or decreasing (shared
# pool memory only) and reports it as a summary.
#
# Multiple distinct spooled outputs can be concatenated together before this
# script is executed against the file.
#
# Asssumptions
# ~~~~~~~~~~~~
# 1. It is assumed that the first shared pool entry will be the same value as
#    the variable "first_tok". This is used to distinguish individual selects
#    from v$sgastat.
#
#
# v1.0.0 kquinn april 2002..........Created
# v1.0.1 kquinn april 2002..........Strip carriage returns
# v1.0.2 kquinn feb   2003..........Strip tabs
# v1.0.3 kquinn june  2003..........Delta summary added
# v1.0.4 kquinn oct   2006..........Add comments regarding first section
#                                   and correct start of sampling
#

# shared pool dlm process array             1076096

BEGIN			{ MAX_MINVAL = 4294967295;   # rogue value
			  version   = "v1.0.4"; 
sec1="This first section prints the value seen across each sample.\n";
sec2="This section just reports on the memory increase / decrease.\n";
warn[0]="Warning: This utility expects that the output from V$SGASTAT has a";
warn[1]="~~~~~~~  consistent order across each sample. If this assumption";
warn[2]="         doesn't hold then the report may be misleading.";
MAXWRN=3;
			}

//			{ gsub("", ""); }
			
/^ *shared pool */	{ sub(" *shared pool ", ""); 
			  gsub("\t", " ");
                          if (!first_tok)
                           {
                            ol = $0;
                            sub(" *[0-9]* *$", "", ol);
                            first_tok = ol;
                           }
			  mem = $(NF);
			  sub(" *[0-9][0-9]* *$", "");
			  type = $0;
			  if (type == first_tok) sample++;
                          if (sample==1) vmin[type] = MAX_MINVAL;
              		  val[type,sample] = mem;
                          if (mem < vmin[type]) vmin[type] = mem;
                          if (mem > vmax[type]) vmax[type] = mem;
			  gsub(" ", "_", type);
			  if (!index(list, type))
			    list = list " " type;
			}

END	{ printf("sgastat.awk - %s (source=%s)\n\n", version, FILENAME);
          for (i=0; i<MAXWRN; i++)
           printf("%s\n", warn[i]);

	  printf("\nSamples seen: %d\n\n", sample);
	  if (sample <=1) 
            printf("WARNING: Only 1 sample seen. More than 1 expected.\n"); 

          printf("%s\n", sec1);
	  mt = split(list, mtype, " ");  # get memory types
	  for (i=1; i<=mt; i++)
	   {
	    mem = mtype[i];
            gsub("_", " ", mem);
	    differ = 0;
	    for (j=2; j<= sample; j++)
              if (val[mem, j] != val[mem, 1]) differ = 1;

            if (differ)
             {
	      difference_seen = 1;
              printf("%-20s ", mem);

              for (j=1; j<=sample; j++)
		printf("%10d ", val[mem, j]);

	      printf("\n");
             } # end differ

	   } # end mtype
          
          if (difference_seen)
           {
            printf("\nSummary of Deltas\n~~~~~~~~~~~~~~~~~\n");
            printf("%s\n", sec2);
            for (i=1; i<=mt; i++)
             {
              mem = mtype[i];
              gsub("_", " ", mem);

              if (vmax[mem]-vmin[mem]) # Only show those that have changed
                printf("%-20s %10d\n", mem, vmax[mem]-vmin[mem]);
             }
           }

          if (!difference_seen)
            printf("NO difference seen across %d samples\n", sample);
           
	}
