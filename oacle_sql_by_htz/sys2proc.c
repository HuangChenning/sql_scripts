/* ------------------------------------------------------------------------- */
/* sys2proc.c */
/* ------------------------------------------------------------------------- */

/* -----------------------@(#) UXPS:    program:  version Status ------ */
static char *  ident   = "@(#) UXPS:    sys2proc:   1.0.0 Alpha";
/* -------------------------------------^^^^^^^^^-^^^^^^^-^^^^^^------- */

#include <stdio.h>
#include <errno.h>
#include <string.h>

extern char * malloc();

char prefix[1000];
char nam[2000];
char suffix[20];

#define MAX_BUF 1024*1024

usage()
{
  fprintf( stderr,"Usage: sys2proc [-p prefix] filename\n" );
  exit(1);
}
main( argc, argv )
int argc;
char ** argv;
{
char buf[MAX_BUF+4], *p;
char lab[MAX_BUF+4];
char *v[1];
char *colon;
int   argi;
FILE *ofp = (FILE *)0;
int n=0,c=0;
int ndumps=0;
int lastprocess=0;

	strcpy(prefix,"P");
	suffix[0]='\0';
	argi=1;
    if (argc<=1) usage();
	while (argi<argc) {
		/* printf( "Arg %d=%s\n", argi,argv[argi] );  */
		if (strcmp(argv[argi],"-?")==0) usage();
		else
		if (strcmp(argv[argi],"-h")==0) usage();
		else
		if (strcmp(argv[argi],"-p")==0) {
			argi++;
			if ( (argi>=argc) ||
			     (sscanf(argv[argi],"%s",prefix)!=1) ) {
				usage();
			}
		}
		else break;
		argi++;
	}
		
	if (argi<argc) {
	  if (freopen(argv[argi],"r",stdin)==(FILE *)0) {
		fprintf( stderr, "Cannot read file: %s\n",argv[argi] );
		perror("Reason");
		exit(1);
	  }
	  while (gets(buf) != (char *)0) {
	    if (strncmp(buf,"PROCESS ",8)==0) { 
			c++;
			printf("\n"); 
			if (ofp) { fclose(ofp); ofp=(FILE *)0; }
		    sscanf(buf+8,"%d",&n);
		/* If process id is same / goes down bump the suffix */
		    if (n<=lastprocess) { 
		    	sprintf(suffix,".%d",++ndumps);
		        lastprocess=n;
		    }
		/* If process id goes up bump the lastprocess seen */
		    if (n>lastprocess) lastprocess=n;
		/* Set up a filename */
		    sprintf(nam,"%s%04d%s",prefix,n,suffix);
			printf("Writing %s ...",nam); fflush(stdout);
			if ((ofp=fopen(nam,"w"))==(FILE *)0) {
				fprintf(stderr,"Problems writing to %s\n",nam);
				perror("Reason");
			}
		}
		if (ofp) fprintf(ofp,"%s\n",buf);
	  }
	} else { 
		fprintf(stderr,"Need a filename for the system state\n");
		exit(1);
	}
  printf("\n\n%d Process state trees seen. Highest pid=%d\n",c,lastprocess);
}
