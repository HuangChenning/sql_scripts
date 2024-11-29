#!/usr/sbin/dtrace -CZs

/********************************************************************************************/
/*                                                                                          */
/*   File Name:    dtracelio.d                                                              */
/*   Version:      2.1                                                                     */
/*   Authors:      Alexander Anokhin ( http://alexanderanokhin.com )                        */
/*                 Andrey Nikolaev   ( http://andreynikolaev.wordpress.com )                */
/*   Dated:        Mar 2012                                                                 */
/*   Purpose:      The script shows calls of the functions                                  */
/*                 performing logical I/O in Oracle.                                        */
/*                                                                                          */
/*   Usage:        dtracelio.d <PID> [show_each_call] [interval]                            */
/*                 PID: unix process ID                                                     */
/*                 show_each_call - Bitmask determining how functions calls will be shown   */
/*                                  1st bit - logical I/O functions                         */
/*                                  2nd bit - buffer pinning                                */
/*                                  Examples:                                               */
/*                                    0: output of each call will be disabled               */
/*                                    1: logical I/O functions will be shown                */
/*                                    3: logical I/O and buffer pinning functions           */
/*                                       will be shown                                      */
/*                                  Default value: 1                                        */
/*                 interval - Specifies the number of seconds over which                    */
/*                            Summary form with cumulative figures will be shown.           */
/*                            Works only when show_each_call is disabled.                   */
/*                                                                                          */
/*   Other:        Some bits of info in 8103.1                                              */
/*                 Note that data structures definitions are not full                       */
/*                 in current version of the script                                         */
/*                                                                                          */
/********************************************************************************************/

#pragma D option quiet
#pragma D option defaultargs
#pragma D option switchrate=10Hz

/*      0. Several standard oratype.h declarations */

typedef unsigned long long ub8; /* unsigned int of length 8 */
typedef unsigned int       ub4;
typedef unsigned short     ub2;
typedef unsigned char      ub1;
typedef int       sb4;

/*  */
typedef sb4 kobjd;
typedef sb4 kobjn;
typedef ub4 ktsn;
typedef ub4 krdba;

/* definition from MOS note 8103.1 */

typedef struct kdbafr /* full relative dba */
{
    ktsn tsn_kdbafr;  /* a tablespace number */
    krdba dba_kdbafr; /* a relative dba */
} kdbafr;

typedef struct ktid /* relative dba + objd */
{
    struct kdbafr dbr_ktid; /* a relative dba */
    kobjd objd_ktid; /* data object number */
    kobjn objn_ktid; /* dictionary object number */
} ktid;

typedef struct kcbds
{
    struct ktid kcbdstid; /* full relative DBA plus object number */
    /* Here unknown (yet ;-)) part of the structure */
} kcbds;

BEGIN
{
    show_each_call      = ($$2 == NULL) ? 1:$2;
    tick_time_interval  = ($$3 == NULL) ? 0:$3;
    trace_logical_io    = 1;
    trace_buf_pinning   = 1;
    show_lio_calls      = show_each_call & 1;
    show_buf_pins_calls = show_each_call & 2;
    printf("\nDynamic tracing of Oracle logical I/O v2.1 by Alexander Anokhin ( http://alexanderanokhin.wordpress.com )\n\n");
}

pid$1::kcbgtcr:entry,
pid$1::kcbgcur:entry,
pid$1::kcbnew:entry,
pid$1::kcbrls:entry,
pid$1::kcbispnd:entry,
pid$1::kcbldrget:entry,
pid$1::kcbget:entry
{
    blk         = ((kcbds *) copyin(arg0, sizeof(kcbds)));
    tsn         = blk->kcbdstid.dbr_ktid.tsn_kdbafr;
    rdba        = blk->kcbdstid.dbr_ktid.dba_kdbafr;
    objd        = blk->kcbdstid.objd_ktid;
    objn        = blk->kcbdstid.objn_ktid;
    rdba_file   = rdba >> 22; /* for smallfile tablespaces */
    rdba_block  = rdba & 0x3FFFFF;
}



pid$1::kcbgtcr:entry
/trace_logical_io/
{
    stat       = "cr";
    where      = arg2&0xFFFF;
    mode_held  = "";

    @func[probefunc,stat,objn,objd,mode_held,where] = count();
    @bufs[probefunc,stat,objn,objd,mode_held,where] = sum(1);

    @obj_cr[objn,objd] = sum(1);
    @total_cr = sum(1);

    @obj_cr_exam[objn,objd] = sum(arg1);
    @total_cr_exam = sum(arg1);

    @obj_lio[objn,objd] = sum(1);
    @total_lio = sum(1);
}

pid$1::kcbgtcr:entry
/trace_logical_io && show_lio_calls/
{
    printf("%s(0x%X,%d,%d,%d) [tsn: %d rdba: 0x%x (%d/%d) obj: %d dobj: %d] where: %d exam: %d\n",probefunc,arg0,arg1,arg2,arg3,tsn, rdba,rdba_file,rdba_block,objn, objd, where, arg1);
}


pid$1::kcbldrget:entry
/trace_logical_io/
{
    stat       = "cr (d)";
    where      = 0;
    mode_held  = "";

    @func[probefunc,stat,objn,objd,mode_held,where] = count();
    @bufs[probefunc,stat,objn,objd,mode_held,where] = sum(1);

    @obj_cr_d[objn,objd] = sum(1);
    @total_cr_d = sum(1);

    @obj_cr[objn,objd] = sum(-1);
    @total_cr = sum(-1);

  /* commented because incremented in kcbgtcr yet
    @obj_lio[objn,objd] = sum(1);
    @total_lio = sum(1);
  */
}

pid$1::kcbldrget:entry
/trace_logical_io && show_lio_calls/
{
    printf("%s(0x%X,%d,%d,%d)\n",probefunc,arg0,arg1,arg2,arg3);
}


pid$1::kcbgcur:entry,
pid$1::kcbget:entry
/trace_logical_io/
{
    stat       = "cu";
    where      = arg2&0xFFFF;
    mode_held  = lltostr(arg1);

    @func[probefunc,stat,objn,objd,mode_held,where] = count();
    @bufs[probefunc,stat,objn,objd,mode_held,where] = sum(1);

    @obj_cu[objn,objd] = sum(1);
    @total_cu  = sum(1);

    @obj_lio[objn,objd] = sum(1);
    @total_lio = sum(1);
}

pid$1::kcbgcur:entry,
pid$1::kcbget:entry
/trace_logical_io && show_lio_calls/
{
    printf("%s(0x%X,%d,%d,%d) [tsn: %d rdba: 0x%x (%d/%d) obj: %d dobj: %d] where: %d mode_held: %s\n",probefunc,arg0,arg1,arg2,arg3,tsn, rdba,rdba_file,rdba_block,objn, objd, where, mode_held);
}

pid$1::kcbnew:entry
/trace_logical_io/
{
    stat       = "cu";
    where      = arg2&0xFFFF;
    mode_held  = "";
    blocks     = arg1;

    @func[probefunc,stat,objn,objd,mode_held,where] = count();
    @bufs[probefunc,stat,objn,objd,mode_held,where] = sum(blocks);

    @obj_cu[objn,objd] = sum(blocks);
    @total_cu = sum(blocks);

    @obj_lio[objn,objd] = sum(blocks);
    @total_lio = sum(blocks);
}

pid$1::kcbnew:entry
/trace_logical_io && show_lio_calls/
{
    printf("%s(0x%X,%d,%d,%d) [tsn: %d rdba: 0x%x (%d/%d) obj: %d dobj: %d] where: %d mode_held: %s blocks: %d\n",probefunc,arg0,arg1,arg2,arg3,tsn, rdba,rdba_file,rdba_block,objn, objd, where, mode_held, blocks);
}

pid$1::kcblnb:entry, pid$1::kcblnb_dscn:entry
/trace_logical_io/
{
    stat = "cu (d)";
    @func[probefunc,stat,0,0,"",0] = count();
    @bufs[probefunc,stat,0,0,"",0] = sum(1);

    @obj_cu[objn,objd] = sum(1);
    @total_cu = sum(1);

    @obj_cu_d[objn,objd] = sum(1);
    @total_cu_d = sum(1);

    @obj_lio[objn,objd] = sum(1);
    @total_lio = sum(1);
}



pid$1::kcblnb:entry, pid$1::kcblnb_dscn:entry
/trace_logical_io && show_lio_calls/
{
    printf("%s(0x%X,%d,%d,%d)\n",probefunc,arg0,arg1,arg2,arg3);
}



/* buffer pinning */

pid$1::kcbispnd:entry
/trace_buf_pinning && show_buf_pins_calls/
{
    printf("%s(0x%X,%d,%d,%d) [tsn: %d rdba: 0x%x (%d/%d) obj: %d dobj: %d]: ",probefunc,arg0,arg1,arg2,arg3,tsn, rdba,rdba_file,rdba_block,objn,objd);
}

pid$1::kcbispnd:return
/trace_buf_pinning && arg1 == 0/
{
    @obj_is_not_pnd[objn,objd] = sum(1);
    @total_is_not_pnd = sum(1);
}

pid$1::kcbispnd:return
/trace_buf_pinning && arg1 == 1/
{
    @obj_is_pnd[objn,objd] = sum(1);;
    @total_is_pnd = sum(1);
}

pid$1::kcbispnd:return
/trace_buf_pinning && show_buf_pins_calls/
{
    printf("%d\n",arg1);
}

pid$1::kcbrls:entry
/trace_buf_pinning/
{
    @obj_pinrls[objn,objd] = sum(1);
    @total_pinrls = sum(1);
}

pid$1::kcbrls:entry
/trace_buf_pinning && show_buf_pins_calls/
{
    printf("%s(0x%X,%d,%d,%d) [tsn: %d rdba: 0x%x (%d/%d) obj: %d dobj: %d]\n",probefunc,arg0,arg1,arg2,arg3,tsn, rdba,rdba_file,rdba_block,objn,objd);
}


tick-1sec
/show_each_call == 0 && tick_time_interval > 0 && ++ticks >= tick_time_interval/
{
    printf("\n\n");
    printf("\n================================= Logical I/O Summary (grouped by object) ==========================================\n");
    printf(" object_id  data_object_id       lio        cr    cr (e)    cr (d)        cu    cu (d) ispnd (Y) ispnd (N)   pin rls\n");
    printf("---------- --------------- --------- --------- --------- --------- --------- --------- --------- --------- ---------\n");
    printa("%10d %15d %9@d %9@d %9@d %9@d %9@d %9@d %9@d %9@d %9@d\n", 
            @obj_lio, @obj_cr, @obj_cr_exam, @obj_cr_d, @obj_cu, @obj_cu_d, @obj_is_pnd, @obj_is_not_pnd, @obj_pinrls);
    printf("---------- --------------- --------- --------- --------- --------- --------- --------- --------- --------- ---------\n");
    printa("     total %25@d %9@d %9@d %9@d %9@d %9@d %9@d %9@d %9@d\n", @total_lio, @total_cr, @total_cr_exam, @total_cr_d, @total_cu, @total_cu_d, @total_is_pnd, @total_is_not_pnd, @total_pinrls);
    printf("====================================================================================================================\n");
    ticks = 0;
}



END
{
    printf("\n===================== Logical I/O Summary (grouped by object/function) ==============\n");
    printf(" function    stat   object_id   data_object_id   mode_held   where     bufs     calls\n");
    printf("--------- ------- ----------- ---------------- ----------- ------- -------- ---------\n");
    printa("%9s %7s %11d %16d %11s %7d %@8d %@9d\n", @bufs, @func);
    printf("=====================================================================================\n");
}

END
{
    printf("\n================================= Logical I/O Summary (grouped by object) ==========================================\n");
    printf(" object_id  data_object_id       lio        cr    cr (e)    cr (d)        cu    cu (d) ispnd (Y) ispnd (N)   pin rls\n");
    printf("---------- --------------- --------- --------- --------- --------- --------- --------- --------- --------- ---------\n");
    printa("%10d %15d %9@d %9@d %9@d %9@d %9@d %9@d %9@d %9@d %9@d\n", 
            @obj_lio, @obj_cr, @obj_cr_exam, @obj_cr_d, @obj_cu, @obj_cu_d, @obj_is_pnd, @obj_is_not_pnd, @obj_pinrls);
    printf("---------- --------------- --------- --------- --------- --------- --------- --------- --------- --------- ---------\n");
    printa("     total %25@d %9@d %9@d %9@d %9@d %9@d %9@d %9@d %9@d\n", @total_lio, @total_cr, @total_cr_exam, @total_cr_d, @total_cu, @total_cu_d, @total_is_pnd, @total_is_not_pnd, @total_pinrls);
    printf("====================================================================================================================\n");
    printf("\n");
    printf("Legend\n");
    printf("lio      : logical gets (cr + cu)\n");
    printf("cr       : consistent gets\n");
    printf("cr (e)   : consistent gets - examination\n");
    printf("cr (d)   : consistent gets direct\n");
    printf("cu       : db block gets\n");
    printf("cu (d)   : db block gets direct\n");
    printf("ispnd (Y): buffer is pinned count\n");
    printf("ispnd (N): buffer is not pinned count\n");
    printf("pin rls  : pin releases\n");

}