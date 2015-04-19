/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x8ddf5b5d */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/yann/Documents/INSA/TP/repos/sysinfo/VHDL/sysinfo/Instruc_Mem.vhd";
extern char *IEEE_P_1242562249;

int ieee_p_1242562249_sub_17802405650254020620_1035706684(char *, char *, char *);


static void work_a_0549514797_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    char *t5;
    char *t6;
    int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;

LAB0:    t1 = (t0 + 2784U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(48, ng0);
    t2 = (t0 + 1192U);
    t3 = *((char **)t2);
    t2 = (t0 + 5392U);
    t4 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t3, t2);
    t5 = (t0 + 1808U);
    t6 = *((char **)t5);
    t5 = (t6 + 0);
    *((int *)t5) = t4;
    xsi_set_current_line(49, ng0);
    t2 = (t0 + 1512U);
    t3 = *((char **)t2);
    t2 = (t0 + 1808U);
    t5 = *((char **)t2);
    t4 = *((int *)t5);
    t7 = (t4 - 1023);
    t8 = (t7 * -1);
    xsi_vhdl_check_range_of_index(1023, 0, -1, t4);
    t9 = (32U * t8);
    t10 = (0 + t9);
    t2 = (t3 + t10);
    t6 = (t0 + 3184);
    t11 = (t6 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t2, 32U);
    xsi_driver_first_trans_fast_port(t6);
    xsi_set_current_line(50, ng0);

LAB6:    t2 = (t0 + 3104);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    t3 = (t0 + 3104);
    *((int *)t3) = 0;
    goto LAB2;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

}


void ieee_p_2592010699_sub_7991387870887201249_503743352();

extern void work_a_0549514797_3212880686_init()
{
	static char *pe[] = {(void *)work_a_0549514797_3212880686_p_0};
	xsi_register_didat("work_a_0549514797_3212880686", "isim/Instruc_Mem_isim_beh.exe.sim/work/a_0549514797_3212880686.didat");
	xsi_register_executes(pe);
	xsi_register_resolution_function(3, 2, (void *)ieee_p_2592010699_sub_7991387870887201249_503743352, 8);
}
