/*
 * Check Oracle listener binding behavior
 * Support program for Oracle MetaLink Note 421305.1
 * 
 * Written by Adrian Penisoara <adrian.penisoara@oracle.com>
 * Copyright (c) 2007 Oracle Corp, Adrian Penisoara
 *
 * Usage: check-lsnrbind [-v] hostname [hostname2 ...]
 * Checks Oracle listener binding for TCP addresses.
 *
 *    -v           verbose mode (display IPs)
 *
 * Report bugs to <adrian.penisoara@oracle.com>
 *
 *
 * To build the executable use the following command:
 *
 *     cc check-lsnrbind.c -o check-lsnrbind
 *
 * For Sun Solaris you need to add "-lnsl" to the command line
 *
 */

#include <stdio.h>
#include <unistd.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>

#ifndef HOSTNAME_MAX
#define HOSTNAME_MAX 1024
#endif

/* Helper function */
char* decode_ip(char *);

int main(int argc, char *argv[])
{
  char syshn[HOSTNAME_MAX], *hn;
  struct hostent *sysaddr, *addr;
  char **p, sysaddr_first[32];
  int i, match_found, ip_cnt, verbose;

  if(argc < 2 || ( (verbose = !strncmp(argv[1], "-v", 2)) && argc < 3 ) )
  {
     printf("Usage: %s [-v] hostname [hostname2 ...]\n"
            "Checks Oracle listener binding for TCP addresses.\n\n"
            "   -v		verbose mode (display IPs)\n\n"
	    "Report bugs to <adrian.penisoara@oracle.com>\n", argv[0]);
     return -1;
  }

  /* Get system hostname */
  if(gethostname(syshn, HOSTNAME_MAX))
  {
     perror("Error getting system hostname");
     return -2;
  }

  printf("\nSystem hostname is: %s\n", syshn);

  /* Build list of IP(s) for system hostname */
  sysaddr = gethostbyname(syshn);
  if(!sysaddr)
  {
     perror("Error getting IPs for system hostname");
     printf("This is a system configuration error (wrong system hostname/domain name or bad network setup)\n");
     return -3;
  }

  /* Get and show the first IP address */
  /* We need to copy the memory buffer since gethostbyname() will reuse it */
  memcpy(sysaddr_first, *(sysaddr->h_addr_list), sysaddr->h_length);
  if(verbose)
     printf("First IP address for system hostname: %s \n",
                     decode_ip(sysaddr_first));

  printf("\n");

  for(i = (verbose ? 2 : 1); i < argc; i++)
  {
     hn = argv[i];
     printf("Checking binding for \"%s\": ", hn);

     /* Build list of IP(s) for the hostname */
     addr = gethostbyname(hn);
     if(!addr)
     {
        printf("[error looking up IP(s)]\n");
	continue;
     }

     /* Now check each IP to match to system address */
     if(verbose) printf("[");
     match_found = 0;
     for(p = addr->h_addr_list, ip_cnt = 0; *p != 0 ; p++, ip_cnt++)
     {
	if(verbose) printf(" %s", decode_ip(*p));
        if(!memcmp(*p, sysaddr_first, sysaddr->h_length))
	{
	   /* We have a match ! */
	   match_found = 1;
	   if(verbose) printf("*");
	}
     }
     if(verbose) printf(" ]\n\t\t");

     /* Display results */
     if(match_found)
	/* Will bind to all interfaces (INADDR_ANY) */
        printf("will listen on all interfaces\n");
     else
        /* Will bind on (an) IP address */
	/* If the results are coming from a DNS service query, then
	 * take into account that the IP list order is randomized each time,
	 * if there is more than one IP address returned */
        printf("will listen on IP %s\n", 
	        ip_cnt > 1 ? "" : decode_ip( *(addr->h_addr_list) ) );

     if(verbose) printf("\n");
  }

  printf("\n");
  return 0;
}


/* Decode the numerical IP address (as a string) from an h_addr_list entry */
char* decode_ip(char *h_addr_p)
{
 struct in_addr in;
 char *result;

 memcpy(&in.s_addr, h_addr_p, sizeof(in.s_addr));
 result = inet_ntoa(in);
 return result;
}
