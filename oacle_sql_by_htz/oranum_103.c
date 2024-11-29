/* oranum.c - Simple program to convert Oracle hex numbers to real form. */
/*
Improvements
------------

 1.  If a number > 1 line is entered, we detect this but still print a result
    of -0 [lucifer].

 2.  Strip trailing zeros off converted numbers *if* a decimal point and not 
    the first digit after the decimal.

 3.  Handle '102' better (102 on own returns -0, 102 in string does ?)

 4.  Handle a single digit date on Sun (without core-dumping).
     And allow return() to be used in main() - Not just exit().


Portability Notes
----------------- 

 Compile with: cc oranum.c -o oranum

 Tested on: AIX, Sunos 4, Sequent Dynix/PTX, Solaris 5.3

Change History
--------------

 Version
 
  1.00    Original Version

  1.01    Added getcnum() to calculate numerics to the required permission
          since long double was not implemented across all ports and, where it
          has been, it looks like it's been implemented as a double (which 
          only gives 10 digits of precision.

  1.02    getnum() now replaced by getcnum() for good.
          However, the code has still been left in (just #defined out) for
          reference since the algorithm is easier to understand and we may 
          find a port with a true 'long double'.
          The code has been #defined out using ORANUM_GETNUM.

 1.03     getdat() change to void.
          Casting of strlen() to int to avoid warnings on Solaris
          Optionally include math.h depending on ORANUM_GETNUM

*/

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#ifdef ORANUM_GETNUM
#   include <math.h>
#endif /* ORANUM_GETNUM */

#define VERSION "1.03"

#ifdef ORANUM_GETNUM
#  ifndef ORANUM_SUNOS
     typedef long double LDOUBLE;
#  else
     typedef double LDOUBLE;
#  endif /* ORANUM_SUNOS */
#endif /* ORANUM_GETNUM */

#define MAX_DIGITS  21
#define MAX_DATE     7
#define MAX_DATESTR 23    /* DD-MON-YYYY HH:MI:SS BC */
#define MAX_ERR      50
#define MAX_ERR_TOK  25
#define MAX_PROGNAME 80
#define MAX_FMT_DIGIT_LEN  ((MAX_DIGITS*2)+2) /** Must be > MAX_DATE_STR +1 **/
#define SIGN_MASK          0x080
#define EXP_MASK           0x07f
#define MAX_NUM            0x0ff

#define ERR_BAD_SECOND   1
#define ERR_BAD_MINUTE   2
#define ERR_BAD_HOUR     3
#define ERR_BAD_DAY      4
#define ERR_BAD_MONTH    5

#define DELIM_LIST " ,"
#define BAD_NAME   "########"
#define PATH_DELIM_LEFT  '/'
#define PATH_DELIM_RIGHT '.'

#define LINES_PER_SCREEN 21

#define TOGGLE(x) {if (x) x = 0; else x = 1;}

#ifdef ORANUM_GETNUM
LDOUBLE getnum();
#endif /* ORANUM_GETNUM */

void   getdat();
void   getcnum();
void   help();
void   get_base_name();

main(argc, argv)
int argc; 
char *argv[];
{
 char more = 1;
 char inrec[81];
 char *idx;
 int innum[MAX_DIGITS];
#ifdef ORANUM_GETNUM
 LDOUBLE decnum;
#endif /* ORANUM_GETNUM */
 char *dgt_check;
 char errmsg[MAX_ERR+1];
 char cresult[MAX_FMT_DIGIT_LEN+1];
 short i;
 long  ltemp;
 int   base = 0;    /* 0 = dec, 1 = hex */ 
 int   mode = 0;    /* 0 = number, 1 = date */
#ifdef ORANUM_GETNUM
 int   chnum = 0;   /* 0 = use getnum, 1 = use getcnum */
#endif
 int   rc;

 errmsg[0] = (char) NULL;

 while (more)
  {
   i = 0;
   (void) fprintf(stdout, "h=help b=base m=mode q=quit %s\n", errmsg);
   (void) fprintf(stdout, "Enter %s : ", mode? "Date":"Number"); 
   (void) fgets(inrec, sizeof(inrec), stdin);

   inrec[(strlen(inrec)==1)?0:strlen(inrec)-1] = (char) NULL;
   errmsg[0] = (char) NULL;

   if (!inrec[0])
      continue;

   idx = strtok(inrec, DELIM_LIST);

   if (!idx)      /* Nothing input, let's go get another number. */
     continue;

   switch (toupper(idx[0]))                  /* Being very lazy here. */
    {
#ifdef ORANUM_GETNUM
     case 'C':            /* Hidden option */
       TOGGLE(chnum);
       (void) sprintf(errmsg, "[Using %s for numeric conversions]", 
              (!chnum)? "getnum": "getcnum");
       continue;
#endif /* ORANUM_GETNUM */ 
     case 'Q':
       more = 0;
       continue;
     case 'B':
       TOGGLE(base);
       (void) sprintf(errmsg, "[Base is now %s]", (!base)? "Decimal": "Hex");
       continue;
     case 'M':
       TOGGLE(mode);
       (void) sprintf(errmsg, "[Mode is now %s]", (!mode)? "Number" : "Date");
       continue;
     case 'H':
       help(argv[0]);
       continue;
    }

   while (idx)
    {
     /* Warning - subsequent large numbers may blow int buffer */ 
     ltemp = strtol(idx, &dgt_check, (!base)?0:16);

     if (*dgt_check || ltemp > MAX_NUM || ltemp < 0)
      {
       if ((int) strlen(idx) > MAX_ERR_TOK)
         *(idx+MAX_ERR_TOK) = (char) NULL;
       /* Possibility that buffer will blow here !! */ 
       sprintf(errmsg, "[Invalid number found:%s]", idx);
       break;
      }

     idx = strtok(NULL, DELIM_LIST);
     innum[i++] = (int) ltemp; 
     if ((!mode && i > MAX_DIGITS) || (mode && i > MAX_DATE))
      {
       strcpy(errmsg, "[Too many digits]");
       break;
      }
    }

   if (!(*dgt_check) && !errmsg[0])
    {
     if (mode)
       getdat(innum, (int) i, cresult, errmsg);
     else
      {
#ifdef ORANUM_GETNUM
       if (chnum)
#endif /* ORANUM_GETNUM */
         getcnum(innum, (int) i, cresult, errmsg);
#ifdef ORANUM_GETNUM
       else
        {
         decnum = getnum(innum, (int) i, errmsg);
         sprintf(cresult, "%lf", decnum);
        }
         /** What impact - If any with using %lf for a double on those ports **/
         /** that don't support long double types ? **/
#endif
      }
     if (!errmsg[0])
       (void) fprintf(stdout, "Result = %s\n", cresult);
    }
  }

 exit (0);
}
#ifdef ORANUM_GETNUM
/*
Under Sunos 
 o Compile with : cc oranum.c -o oranum /usr/lib/libm.a -DORANUM_SUNOS
On Sequent Dynix/Ptx
 o Compile with : cc oranum.c -o oranum /lib/libm.a
On AIX
 o Compile with : cc oranum.c -o oranum /usr/lib/libm.a
*/
LDOUBLE getnum(innum, max, errmsg)
int innum[]; 
short max; 
char *errmsg;
{
 int    sign, expo;
 int    i;
 int   val;
 LDOUBLE result = 0.0;

 *errmsg = (char) NULL;

 if (max == 1 && innum[0] == 128)
   return (0.0);

 sign = innum[0] & SIGN_MASK;
 
 if (!sign)
   expo = (~innum[0]) & EXP_MASK;
 else
   expo = innum[0] & EXP_MASK;

 expo -= 64;

 for (i=1; i<max; i++)
 {
  if (!sign && innum[i] == 102)   /* Could also check 102's position. */
    break;

  val = innum[i]-1;
  if (!sign) val = 100 - val;
  
  if (val < 0 || val >= 100)       /* Number out of range */
   {
    (void) sprintf(errmsg, 
        "[Digit %d is out of range when converted]", val);
    return ((double) i);
   }

  expo--;
  result += (LDOUBLE) val * (LDOUBLE) pow(100.0, (double)expo);
                              /* And how pow() is not implemented as */
 }                                     /* a macro anywhere .... */

 if (!sign) 
   return (result * -1.0);   
 else
   return (result);
}
#endif /* ORANUM_GETNUM */

/*----------------------------------------------------------------------------+
| getdat - Convert to Date.                                                   |
|                                                                             |
| 
*/ 

void getdat(innum, max, outstr, errmsg)
int innum[]; 
int max;
char *outstr;
char *errmsg;
{
 int century, year, month, day, hour, minute, second; 
 int rc = 0;
 static char *months[] =
 { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", 
   "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"};
 static char *daterr[] =
 { "Second", "Minute", "Hour", "Day", "Month" };

 if (max != MAX_DATE)
  {
   strcpy(errmsg, "[Not enough digits]");
   return;
  }

 *errmsg = (char) NULL;

 century = innum[0] - 100;
 year    = innum[1] - 100;
 month   = innum[2];
 day     = innum[3];
 hour    = innum[4]-1;
 minute  = innum[5]-1;
 second  = innum[6]-1;

 if (century < 0 && year > 0)
  {
   strcpy(errmsg, "[Century/Year inconsistency]");
   return;
  }
   
 if (month > 12 || month < 1)
   rc = ERR_BAD_MONTH;

 if (day < 1 || day > 31)         /** This could be made more sophisticated **/
   rc = ERR_BAD_DAY;

 if (hour >= 60 || hour < 0)
   rc = ERR_BAD_HOUR;

 if (second >= 60 || second < 0)
   rc = ERR_BAD_SECOND;

 if (minute >= 60 || minute < 0)
   rc = ERR_BAD_MINUTE;

 if (rc)
  {
   (void) sprintf(errmsg, "[Converted %s out of range]",
                  daterr[rc-1]);
   return;
  }

 sprintf(outstr, "%02d-%s-%02d%02d %02d:%02d:%02d %s", day, months[month-1], 
          (int) abs(century), (int) abs(year), hour, minute, second, 
          (century>=0)?"AD":"BC");

 return;
}
 
void help(pname)
char *pname;
{
 static char progname[MAX_PROGNAME+1];
 static char called = 0;
 int i;

 static char *help_desc[] = 
  {
"Description",
"-----------",
" ",
" This utility aids in the interpretation of date and numeric data. It allows",
"you to type in the hex numbers taken from a block dump (Oracle or Operating",
"system) and it will convert them and display the actual value.",
" ",
"Usage",
"-----",
" ",
" The available options are shown with the prompt. These are :",
" ",
"   Base -  This toggles the interpretation of the data entered between",
"          decimal and hex mode. When in hex mode, all numbers entered will be",
"          considered to be entered in hex. When in decimal mode hex numbers",
"          can still be entered if prefixed by either '0x' or '0X'.",
" ",
"   Help -  This information.",
" ",
"   Mode -  Typing 'm' will toggle the interpretation of any data from date",
"          conversion to number conversion. The current mode is obvious from",
"          the prompt.",
" ",
"   Quit -  Exit out.",
" ",
"Additional Notes",
"----------------",
" ",
" The bytes can be entered as comma delimited, space delimited or both. For",
"example, the following entries are all considered equivalent :",
" ",
"  119,194,10,7,15,20,17",
"  119 ,194 ,10,    7, 15,,,,,20, 17",
""
  };

 if (!called)
  {
   called = 1;
   get_base_name(pname, progname, MAX_PROGNAME);
  }

 /* Only derive program name once */ 
 (void) fprintf(stdout, "Utility %s (version %s)\n\n", progname, VERSION);

 for (i=0; i<help_desc[i][0]; i++)
  {
   if (!((i+1)%LINES_PER_SCREEN))
    {
     (void) fprintf(stdout, "Press Return to Continue\n");
     (void) fflush(stdout);
     while (getchar() != '\n')
       ;
     (void) fprintf(stdout, "Utility %s (version %s)\n\n", progname, VERSION);
    }
  (void) fprintf(stdout, "%s\n", help_desc[i]);
 } 
 
 i = LINES_PER_SCREEN - (i%LINES_PER_SCREEN) - 2;
 if (i != LINES_PER_SCREEN)
   while (i--)
     (void) fprintf(stdout, "\n");

 return;
}

void get_base_name(inname, outname, len)
char *inname; 
char *outname; 
int len;
{
 char *id1, *id2;              /* Char Pointer. */ 

 id1 = strrchr(inname, PATH_DELIM_LEFT);
 if (id1)
   id1++;
 else
   id1 = inname;

 id2 = strrchr(outname, PATH_DELIM_RIGHT);

 if (id2 != (char *) NULL)
   *id2 = (char) NULL;

 if ((int) strlen(id1) > len)
   strcpy(outname, BAD_NAME);

 strcpy(outname, id1);

 return;
}

void getcnum(innum, max, rstring, errmsg)
int innum[]; 
int max;
char *rstring;
char *errmsg;
{
 char   tstring[5];
 int    sign, expo, val;
 int    i; 

 *errmsg = (char) NULL;
 if (max == 1 && innum[0] == 128)
  {
   strcpy(rstring, "0");
   return;
  }

 *rstring = tstring[0] = (char) NULL;

 sign = innum[0] & SIGN_MASK;
 
 if (!sign)
  {
   strcat(rstring, "-");
   expo = (~innum[0]) & EXP_MASK;
  }
 else
   expo = innum[0] & EXP_MASK;

 expo -= 64;

 if (expo < 1)
  {
   strcat(rstring, "0");
   if (max != 1)
    {
     strcat(rstring, ".");
     for (i=0; expo<i; i--)
       strcat(rstring, "00");
    }
  }

 for (i=1; i<max; i++)
 {
  if (!sign && innum[i] == 102 && i==max-1) 
    break;

  if (expo == (i-1) && expo) 
     strcat(rstring, "."); 

  val = innum[i]-1;
  if (!sign) val = 100 - val;
  
  if (val < 0 || val >= 100)       /* Number out of range */
   {
    (void) sprintf(errmsg, 
        "[Digit %d is out of range]", i);
    return;        
   }

  /* Add leading zeros if required. */
  if (val < 10 && ((expo<1) || (i !=1)))
     strcat(rstring, "0");

  sprintf(tstring, "%d", val);
  strcat(rstring, tstring);
 }

 if (expo >= max)
  {
   if (expo > ((MAX_FMT_DIGIT_LEN-1-(int) strlen(rstring))/2))
    {
     strcpy(errmsg, "[Exponent too large]");
     return;
    }

   for (i=expo; i>=max; i--)
     strcat(rstring, "00");
  }

 if ((int)strlen(rstring) + (int)strlen(tstring) > MAX_FMT_DIGIT_LEN)
  {
   strcpy(errmsg, "[Result too large]");
   return;
  }

 return;
}
