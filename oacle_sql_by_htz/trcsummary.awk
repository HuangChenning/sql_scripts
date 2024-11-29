# TRCSUMMARY 0.2
#       Script to process RAW 10046 level 8 or 12 trace files.
#       The aim is to extract wait information and ACTUAL plans.
#
# 17-Aug-98     RPOWELL Base version base on 10046.waits / anal.10046
#
function show_statement( dostat )  {
          if (StmtLines[curno] && (Depth[curno]<DEPTH)) {
           print "";
           print "=== Usage for CURSOR ",curno,"=============================";
           printf " Depth: %d\n\n", Depth[curno];
           #
           # Print the statement
           #
           for (j=1; j<=StmtLines[curno]; j++) { 
                printf " %s\n",Stmt[curno,j]; 
           }
           printf " Operation  %10s %12s %12s   %12s\n",\
                "Count","CPU","Elapsed","Rows";
           printf "  Parse:    %10.0f %12.2f %12.2f\n",\
                CPn[curno],(CPcpu[curno]+0.0)/100,(CPela[curno]+0.0)/100;
           printf "  Execute:  %10.0f %12.2f %12.2f     %12d\n", \
                CEn[curno],(CEcpu[curno]+0.0)/100,(CEela[curno]+0.0)/100,
                CErow[curno];
           printf "  Fetch:    %10.0f %12.2f %12.2f     %12d\n", \
                CFn[curno],(CFcpu[curno]+0.0)/100,(CFela[curno]+0.0)/100,
                CFrow[curno];
           printf "  ------------------------------------------------\n";
           printf "  Total:    %10.0f %12.2f %12.2f\n", \
                CFn[curno]+CEn[curno]+CP[curno],\
                (CFcpu[curno]+CEcpu[curno]+CPcpu[curno]+0.0)/100, \
                (CFela[curno]+CEela[curno]+CEela[curno]+0.0)/100;
           #
           # Print then Clear any Wait info for this cursor
           #
           printf "\n";
           printf " %-37s  %8s %8s %8s\n","Wait-Event","Elapsed","Count",""
           for (j=0; j<Nevents; j++) { 
                xnam=names[j];
                if (WaitTime[curno,xnam] || WaitCnt[curno,xnam]) {
                  printf "  %-37s %8.2f %8.0f\n",\
                         xnam, WaitTime[curno,xnam]/100, WaitCnt[curno,xnam];
                  WaitTime[curno,xnam]=0;
                  WaitCnt[curno,xnam]=0;
                } 
           }
           printf "\n";
           if (dostat) { 
             printf " %-10s %s\n", "Rows","Row Source";
             printf " %-10s %s\n", "~~~~~~~~~~","~~~~~~~~~~";
           }
           in_curno=curno;
          }
           #
           # and clear totals
           #
           CPela[curno]=0; CPcpu[curno]=0; CPn[curno]=0;
           CEela[curno]=0; CEcpu[curno]=0; CEn[curno]=0; CErow[curno]=0;
           CFela[curno]=0; CFcpu[curno]=0; CFn[curno]=0; CFrow[curno]=0;
           StmtLines[curno]=0;
}
BEGIN   { print "TRCSUMMARY V0.2 Trace Summary"; 
          print "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
          print ""
          Nevents=0;
        }
/^PARSE ERROR/ { 
          in_curno=0;
          curno=substr($1,14,length($1)-17)+0;
          show_statement(0);
          next;
}
/^PARSING IN CURSOR/ { 
          in_curno=0;
          curno=substr($1,20,length($1)-4-19)+0;
          show_statement(0);
          dep=0+substr($3,1,length($3)-4);
          Depth[curno]=dep;
          if (dep>=DEPTH) { next; }
          Sparsing=1;
          Sline=1;
          next;
        }
Sparsing && $0!~/END OF STMT/ {
          Stmt[curno,Sline]=$0;
          Sline++
          Stmt[curno,Sline]="";
          next;
        }
Sparsing && $0~/END OF STMT/ {
          StmtLines[curno]=Sline;
          Sparsing=0;
          next;
        }
/^STAT/ {
          curno=substr($1,7,length($1)-3-6)+0;
          if (Depth[curno]>=DEPTH) { next; }
          show_statement(1);
          if (curno==in_curno) {
           id=substr($2,1,length($2)-4);
           cnt=substr($3,1,length($3)-4);
           pid=substr($4,1,length($4)-4);
           pos=substr($5,1,length($5)-4);
           obj=0+substr($6,1,length($6)-3);
           indent=StatPos[curno,pid]+1;
           StatPos[curno,id]=indent;
           xplain=substr($7,2,length($7)-2);
           fmt=sprintf(" %%10d  %%%ds %%s",indent*2);
           printf fmt,cnt,"",xplain;
           if (obj) { 
            printf " (obj %d)",obj;
           }
           printf "\n";
          }
          next;
        }
/^WAIT/ { 
          curno=substr($1,7,length($1)-5-6)+0;
          nam=$2;
          gsub(" ela$","",nam);
          # Note individual latch waits
          if ($2~/latch free/) { 
                nam=nam" for Latch# "substr($5,1,length($5)-2);
          }
          if ($2~/parallel query dequeue/) { 
                nam="PQ dequeue - Reason# "substr($4,1,length($4)-2);
          }
          if (stat[nam]==0) {
                stat[nam]=1;
                names[Nevents++]=nam;
          }
          val=0+substr($3,1,length($3)-2);
          ela[nam]=ela[nam]+val;
          tot=tot+val;
          count[nam]++
          if (val==0) zero[nam]++;
          xnam=state[curno]"-"nam;
#       print "curno=",curno,"Xnam=",xnam
          xstat[xnam]=xstat[xnam]+val;
          #
          # Per cursor WAITS
          #
          if (Depth[curno]<DEPTH) { 
            WaitTime[curno,nam]+=val;
            WaitCnt[curno,nam]++;
          }
        } 
/^FETCH/ { 
          curno=substr($1,8,length($1)-9)+0;
          state[curno]="FETCH";
          fcpu=substr($2,1,length($2)-2);
          fela=substr($3,1,length($3)-2);
          frow=substr($8,1,length($8)-4);
          dep=0+substr($9,1,length($9)-3);
          if (dep == 0) {
            totfcpu=totfcpu+fcpu;
            totfela=totfela+fela;
            totf++;
          } else {
            Rtotfcpu=Rtotfcpu+fcpu;
            Rtotfela=Rtotfela+fela;
            Rtotf++;
          }
          CFela[curno]+=fela;
          CFcpu[curno]+=fcpu;
          CFn[curno]++;
          CFrow[curno]+=frow;
        }
/^EXEC/ { 
          curno=substr($1,7,length($1)-8)+0;
          state[curno]="EXEC";
          ecpu=substr($2,1,length($2)-2);
          eela=substr($3,1,length($3)-2);
          erow=substr($8,1,length($8)-4);
          dep=0+substr($9,1,length($9)-3);
          if (dep == 0) {
            totecpu=totecpu+ecpu;
            toteela=toteela+eela;
            tote++;
          } else {
            Rtotecpu=Rtotecpu+ecpu;
            Rtoteela=Rtoteela+eela;
            Rtote++;
          }
          CEela[curno]+=eela;
          CEcpu[curno]+=ecpu;
          CEn[curno]++;
          CErow[curno]+=erow;
        }
/^PARSE/{ 
          curno=substr($1,8,length($1)-9)+0;
          state[curno]="PARSE";
          pcpu=substr($2,1,length($2)-2);
          pela=substr($3,1,length($3)-2);
          dep=0+substr($9,1,length($9)-3);
          if (dep == 0) {
            totpcpu=totpcpu+pcpu;
            totpela=totpela+pela;
            totp++;
          } else {
            Rtotpcpu=Rtotpcpu+pcpu;
            Rtotpela=Rtotpela+pela;
            Rtotp++;
          }
          CPela[curno]+=pela;
          CPcpu[curno]+=pcpu;
          CPn[curno]++;
        }
/^XCTEND/  { # rlbk=0, rd_only=1
          Nxct++;
          if ($3+0==0) { 
            if (substr($2,1,1)=="0") { 
                Ncommit++;
            } else { 
                Nrollback++;
            }
          } 
        }
END     { 
          printf "\n\n";
          printf "Unclosed Cursors seen in the trace extract\n\n";
          for (i=0; i<1000; i++) { 
            if (StmtLines[i]) { show_statement(0); }
          }
          printf "\n\n";
          printf "Summary of CPU and Elapsed Times\n";
          printf "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
          #
          printf "NON RECURSIVE STATEMENTS:    ";
          printf "  NB: CPU and Elapsed times INCLUDE recursive time\n\n";
          if (totp==0) totp=1;
          if (tote==0) tote=1;
          if (totf==0) totf=1;
          printf " Operation%12s %12s %12s       %12s\n",\
                "Count","CPU","Elapsed","CPU/call"
          printf " %-9s%12s %12s %12s       %12s\n",\
                "","","(secs)","(secs)","(mS)"
          printf " %-9s%12.0f %12.2f %12.2f       %12.0f\n",\
                "Parse",totp,totpcpu/100,totpela/100, totpcpu*10/totp
          printf " %-9s%12.0f %12.2f %12.2f       %12.0f\n",\
                "Execute",tote,totecpu/100,toteela/100, totecpu*10/tote
          printf " %-9s%12.0f %12.2f %12.2f       %12.0f\n",\
                "Fetch",totf,totfcpu/100,totfela/100, totfcpu*10/totf
          #
          totcpu=totpcpu+totecpu+totfcpu;
          totela=totpela+toteela+totfela;
          totcal=totp+tote+totf;
          print " ------------------------------------------------------------"
          printf " %-9s%12.0f %12.2f %12.2f\n",\
                "Total",totcal,totcpu/100,totela/100;
          #
          cli="'SQL*Net message from client'";
          if (!ela[cli]) {  
            cli="'client message'";
          }
            printf " %-9s%12.0f %12s %12.2f\n",\
                "SQL*Net",count[cli],"",ela[cli]/100
          print " ------------------------------------------------------------"
          printf " %-9s%12.0f %12.2f %12.2f\n",\
                "Overall",totcal+count[nam], totcpu/100,(totela+ela[cli])/100
          lowerbound=totela+ela[cli];
          upperbound=lowerbound+zero[cli]
          guess=lowerbound+(zero[cli]/2);
          #
          printf "\n";
          printf "RECURSIVE STATEMENTS:\n";
          if (Rtotp==0) Rtotp=1;
          if (Rtote==0) Rtote=1;
          if (Rtotf==0) Rtotf=1;
          printf " Operation%12s %12s %12s       %12s\n",\
                "Count","CPU","Elapsed","CPU/call"
          printf " %-9s%12s %12s %12s       %12s\n",\
                "","","(secs)","(secs)","(mS)"
          printf " %-9s%12.0f %12.2f %12.2f       %12.0f\n",\
                "Parse",Rtotp,Rtotpcpu/100,Rtotpela/100, Rtotpcpu*10/Rtotp
          printf " %-9s%12.0f %12.2f %12.2f       %12.0f\n",\
                "Execute",Rtote,Rtotecpu/100,Rtoteela/100, Rtotecpu*10/Rtote
          printf " %-9s%12.0f %12.2f %12.2f       %12.0f\n",\
                "Fetch",Rtotf,Rtotfcpu/100,Rtotfela/100, Rtotfcpu*10/Rtotf
          #
          Rtotcpu=Rtotpcpu+Rtotecpu+Rtotfcpu;
          Rtotela=Rtotpela+Rtoteela+Rtotfela;
          Rtotcal=Rtotp+Rtote+Rtotf;
          print " ------------------------------------------------------------"
          printf " %-9s%12.0f %12.2f %12.2f\n",\
                "Total",Rtotcal,Rtotcpu/100,Rtotela/100;
          #
          printf "\nGiving wait time to account for of:"
          printf "         %12.2f seconds\n", (totela-totcpu)/100;
          print
        #  print "Trace accounts for a total elapsed time between:",\
        #       lowerbound/100,\
        #       "and",upperbound/100, "secs"
        #  print "Averaging: ",guess/100
        #
        #
        # Sort the time waited
        #
         for (j=0; j<Nevents; j++) { 
          for (worst=0;worst<Nevents;worst++) {
                if (!EventUsed[worst]) break;
          }
          for (k=0;k<Nevents;k++) {
            if (!EventUsed[k] && \
                (ela[names[k]]>ela[names[worst]])) {
                worst=k;
            }
          }
          EventOrder[j]=worst;
          EventUsed[worst]=1;
         }
          printf "Wait Events waited for\n";
          printf "~~~~~~~~~~~~~~~~~~~~~~\n";
          printf " %-45s  %8s %8s %8s\n","Event","Elapsed","Count","Zero"
          totcnt=0;
          totzero=0;
          for (j=0; j<Nevents; j++) { 
                nam=names[EventOrder[j]];
                if (nam!=cli) {
                  printf "  %-45s %8.2f %8.0f %8.0f\n",\
                         nam, ela[nam]/100, count[nam], zero[nam];
                  totcnt+=count[nam];
                  totzero+=zero[nam];
                }
          } 
          printf "  %-45s %8s %8s %8s\n","--------------------------------",\
                "--------","--------","--------"
          tot=tot-ela[cli];
          printf "  %-45s %8.2f %8.0f %8.0f\n","TOTAL",tot/100,totcnt,totzero
          print
          printf "\nGiving unaccounted wait time of:   "
          printf "         %12.2f seconds\n", (totela-totcpu-tot)/100;
          printf " (generally this is time on run queue etc)\n";
        #
          printf "\n";
          printf "Transactions\n";
          printf "~~~~~~~~~~~~\n";
          printf "  Transaction Ends: %8d\n",Nxct;
          printf "  Real Commits:     %8d\n",Ncommit;
          printf "  Rollbacks:        %8d\n",Nrollback;
        }
