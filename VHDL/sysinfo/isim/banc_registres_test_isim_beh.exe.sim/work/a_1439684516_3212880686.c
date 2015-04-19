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
static const char *ng0 = "/home/yann/Documents/INSA/TP/repos/sysinfo/VHDL/sysinfo/banc_registres.vhd";
extern char *IEEE_P_1242562249;

int ieee_p_1242562249_sub_17802405650254020620_1035706684(char *, char *, char *);


static void work_a_1439684516_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    char *t5;
    char *t6;
    unsigned char t7;
    unsigned char t8;
    char *t9;
    unsigned char t10;
    unsigned int t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;

LAB0:    t1 = (t0 + 4464U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(78, ng0);
    t2 = (t0 + 1192U);
    t3 = *((char **)t2);
    t2 = (t0 + 8208U);
    t4 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t3, t2);
    t5 = (t0 + 3248U);
    t6 = *((char **)t5);
    t5 = (t6 + 0);
    *((int *)t5) = t4;
    xsi_set_current_line(79, ng0);
    t2 = (t0 + 1352U);
    t3 = *((char **)t2);
    t2 = (t0 + 8224U);
    t4 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t3, t2);
    t5 = (t0 + 3368U);
    t6 = *((char **)t5);
    t5 = (t6 + 0);
    *((int *)t5) = t4;
    xsi_set_current_line(80, ng0);
    t2 = (t0 + 1832U);
    t3 = *((char **)t2);
    t2 = (t0 + 8272U);
    t4 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t3, t2);
    t5 = (t0 + 3488U);
    t6 = *((char **)t5);
    t5 = (t6 + 0);
    *((int *)t5) = t4;
    xsi_set_current_line(81, ng0);
    t2 = (t0 + 2152U);
    t3 = *((char **)t2);
    t7 = *((unsigned char *)t3);
    t8 = (t7 == (unsigned char)2);
    if (t8 != 0)
        goto LAB4;

LAB6:
LAB5:    xsi_set_current_line(84, ng0);
    t2 = (t0 + 2312U);
    t3 = *((char **)t2);
    t7 = *((unsigned char *)t3);
    t8 = (t7 == (unsigned char)3);
    if (t8 != 0)
        goto LAB9;

LAB11:
LAB10:    xsi_set_current_line(94, ng0);
    t2 = (t0 + 2472U);
    t3 = *((char **)t2);
    t2 = (t0 + 3248U);
    t5 = *((char **)t2);
    t4 = *((int *)t5);
    t16 = (t4 - 15);
    t11 = (t16 * -1);
    xsi_vhdl_check_range_of_index(15, 0, -1, t4);
    t17 = (8U * t11);
    t18 = (0 + t17);
    t2 = (t3 + t18);
    t6 = (t0 + 4928);
    t9 = (t6 + 56U);
    t12 = *((char **)t9);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t2, 8U);
    xsi_driver_first_trans_fast_port(t6);
    xsi_set_current_line(95, ng0);
    t2 = (t0 + 2472U);
    t3 = *((char **)t2);
    t2 = (t0 + 3368U);
    t5 = *((char **)t2);
    t4 = *((int *)t5);
    t16 = (t4 - 15);
    t11 = (t16 * -1);
    xsi_vhdl_check_range_of_index(15, 0, -1, t4);
    t17 = (8U * t11);
    t18 = (0 + t17);
    t2 = (t3 + t18);
    t6 = (t0 + 4992);
    t9 = (t6 + 56U);
    t12 = *((char **)t9);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t2, 8U);
    xsi_driver_first_trans_fast_port(t6);
    xsi_set_current_line(98, ng0);

LAB31:    t2 = (t0 + 4784);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB32;

LAB1:    return;
LAB4:    xsi_set_current_line(81, ng0);
    t2 = xsi_get_transient_memory(128U);
    memset(t2, 0, 128U);
    t5 = t2;
    t6 = (t0 + 3008U);
    t9 = *((char **)t6);
    t10 = (8U != 0);
    if (t10 == 1)
        goto LAB7;

LAB8:    t6 = (t0 + 4864);
    t12 = (t6 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t2, 128U);
    xsi_driver_first_trans_fast(t6);
    goto LAB5;

LAB7:    t11 = (128U / 8U);
    xsi_mem_set_data(t5, t9, 8U, t11);
    goto LAB8;

LAB9:    xsi_set_current_line(85, ng0);
    t2 = (t0 + 1192U);
    t5 = *((char **)t2);
    t2 = (t0 + 1832U);
    t6 = *((char **)t2);
    t10 = 1;
    if (4U == 4U)
        goto LAB15;

LAB16:    t10 = 0;

LAB17:    if (t10 != 0)
        goto LAB12;

LAB14:    t2 = (t0 + 1352U);
    t3 = *((char **)t2);
    t2 = (t0 + 1832U);
    t5 = *((char **)t2);
    t7 = 1;
    if (4U == 4U)
        goto LAB23;

LAB24:    t7 = 0;

LAB25:    if (t7 != 0)
        goto LAB21;

LAB22:    xsi_set_current_line(87, ng0);
    t2 = (t0 + 1992U);
    t3 = *((char **)t2);
    t2 = (t0 + 3488U);
    t5 = *((char **)t2);
    t4 = *((int *)t5);
    t16 = (t4 - 15);
    t11 = (t16 * -1);
    t17 = (8U * t11);
    t18 = (0U + t17);
    t2 = (t0 + 4864);
    t6 = (t2 + 56U);
    t9 = *((char **)t6);
    t12 = (t9 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t3, 8U);
    xsi_driver_first_trans_delta(t2, t18, 8U, 0LL);

LAB13:    goto LAB10;

LAB12:    xsi_set_current_line(85, ng0);
    t12 = (t0 + 2472U);
    t13 = *((char **)t12);
    t12 = (t0 + 3248U);
    t14 = *((char **)t12);
    t4 = *((int *)t14);
    t16 = (t4 - 15);
    t17 = (t16 * -1);
    xsi_vhdl_check_range_of_index(15, 0, -1, t4);
    t18 = (8U * t17);
    t19 = (0 + t18);
    t12 = (t13 + t19);
    t15 = (t0 + 4928);
    t20 = (t15 + 56U);
    t21 = *((char **)t20);
    t22 = (t21 + 56U);
    t23 = *((char **)t22);
    memcpy(t23, t12, 8U);
    xsi_driver_first_trans_fast_port(t15);
    goto LAB13;

LAB15:    t11 = 0;

LAB18:    if (t11 < 4U)
        goto LAB19;
    else
        goto LAB17;

LAB19:    t2 = (t5 + t11);
    t9 = (t6 + t11);
    if (*((unsigned char *)t2) != *((unsigned char *)t9))
        goto LAB16;

LAB20:    t11 = (t11 + 1);
    goto LAB18;

LAB21:    xsi_set_current_line(86, ng0);
    t9 = (t0 + 2472U);
    t12 = *((char **)t9);
    t9 = (t0 + 3368U);
    t13 = *((char **)t9);
    t4 = *((int *)t13);
    t16 = (t4 - 15);
    t17 = (t16 * -1);
    xsi_vhdl_check_range_of_index(15, 0, -1, t4);
    t18 = (8U * t17);
    t19 = (0 + t18);
    t9 = (t12 + t19);
    t14 = (t0 + 4992);
    t15 = (t14 + 56U);
    t20 = *((char **)t15);
    t21 = (t20 + 56U);
    t22 = *((char **)t21);
    memcpy(t22, t9, 8U);
    xsi_driver_first_trans_fast_port(t14);
    goto LAB13;

LAB23:    t11 = 0;

LAB26:    if (t11 < 4U)
        goto LAB27;
    else
        goto LAB25;

LAB27:    t2 = (t3 + t11);
    t6 = (t5 + t11);
    if (*((unsigned char *)t2) != *((unsigned char *)t6))
        goto LAB24;

LAB28:    t11 = (t11 + 1);
    goto LAB26;

LAB29:    t3 = (t0 + 4784);
    *((int *)t3) = 0;
    goto LAB2;

LAB30:    goto LAB29;

LAB32:    goto LAB30;

}


void ieee_p_2592010699_sub_7991387870887201249_503743352();

extern void work_a_1439684516_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1439684516_3212880686_p_0};
	xsi_register_didat("work_a_1439684516_3212880686", "isim/banc_registres_test_isim_beh.exe.sim/work/a_1439684516_3212880686.didat");
	xsi_register_executes(pe);
	xsi_register_resolution_function(3, 2, (void *)ieee_p_2592010699_sub_7991387870887201249_503743352, 8);
}
