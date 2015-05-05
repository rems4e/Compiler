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
static const char *ng0 = "/home/remi/Bureau/SysInfo/VHDL/sysinfo/banc_registres.vhd";
extern char *IEEE_P_1242562249;

int ieee_p_1242562249_sub_17802405650254020620_1035706684(char *, char *, char *);


static void work_a_1439684516_3212880686_p_0(char *t0)
{
    unsigned char t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    unsigned char t9;
    unsigned int t10;
    char *t11;
    char *t12;
    char *t13;
    unsigned char t14;
    unsigned char t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    int t24;
    int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;
    char *t35;

LAB0:    xsi_set_current_line(55, ng0);
    t3 = (t0 + 2312U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 == 1)
        goto LAB8;

LAB9:    t2 = (unsigned char)0;

LAB10:    if (t2 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:
LAB17:    t21 = (t0 + 2472U);
    t22 = *((char **)t21);
    t21 = (t0 + 1192U);
    t23 = *((char **)t21);
    t21 = (t0 + 7400U);
    t24 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t23, t21);
    t25 = (t24 - 15);
    t26 = (t25 * -1);
    xsi_vhdl_check_range_of_index(15, 0, -1, t24);
    t27 = (8U * t26);
    t28 = (0 + t27);
    t29 = (t22 + t28);
    t30 = (t0 + 4672);
    t31 = (t30 + 56U);
    t32 = *((char **)t31);
    t33 = (t32 + 56U);
    t34 = *((char **)t33);
    memcpy(t34, t29, 8U);
    xsi_driver_first_trans_fast_port(t30);

LAB2:    t35 = (t0 + 4560);
    *((int *)t35) = 1;

LAB1:    return;
LAB3:    t12 = (t0 + 1992U);
    t16 = *((char **)t12);
    t12 = (t0 + 4672);
    t17 = (t12 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t16, 8U);
    xsi_driver_first_trans_fast_port(t12);
    goto LAB2;

LAB5:    t12 = (t0 + 2152U);
    t13 = *((char **)t12);
    t14 = *((unsigned char *)t13);
    t15 = (t14 == (unsigned char)3);
    t1 = t15;
    goto LAB7;

LAB8:    t3 = (t0 + 1192U);
    t7 = *((char **)t3);
    t3 = (t0 + 1832U);
    t8 = *((char **)t3);
    t9 = 1;
    if (4U == 4U)
        goto LAB11;

LAB12:    t9 = 0;

LAB13:    t2 = t9;
    goto LAB10;

LAB11:    t10 = 0;

LAB14:    if (t10 < 4U)
        goto LAB15;
    else
        goto LAB13;

LAB15:    t3 = (t7 + t10);
    t11 = (t8 + t10);
    if (*((unsigned char *)t3) != *((unsigned char *)t11))
        goto LAB12;

LAB16:    t10 = (t10 + 1);
    goto LAB14;

LAB18:    goto LAB2;

}

static void work_a_1439684516_3212880686_p_1(char *t0)
{
    unsigned char t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    unsigned char t9;
    unsigned int t10;
    char *t11;
    char *t12;
    char *t13;
    unsigned char t14;
    unsigned char t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    int t24;
    int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;
    char *t35;

LAB0:    xsi_set_current_line(56, ng0);
    t3 = (t0 + 2312U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 == 1)
        goto LAB8;

LAB9:    t2 = (unsigned char)0;

LAB10:    if (t2 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:
LAB17:    t21 = (t0 + 2472U);
    t22 = *((char **)t21);
    t21 = (t0 + 1352U);
    t23 = *((char **)t21);
    t21 = (t0 + 7416U);
    t24 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t23, t21);
    t25 = (t24 - 15);
    t26 = (t25 * -1);
    xsi_vhdl_check_range_of_index(15, 0, -1, t24);
    t27 = (8U * t26);
    t28 = (0 + t27);
    t29 = (t22 + t28);
    t30 = (t0 + 4736);
    t31 = (t30 + 56U);
    t32 = *((char **)t31);
    t33 = (t32 + 56U);
    t34 = *((char **)t33);
    memcpy(t34, t29, 8U);
    xsi_driver_first_trans_fast_port(t30);

LAB2:    t35 = (t0 + 4576);
    *((int *)t35) = 1;

LAB1:    return;
LAB3:    t12 = (t0 + 1992U);
    t16 = *((char **)t12);
    t12 = (t0 + 4736);
    t17 = (t12 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t16, 8U);
    xsi_driver_first_trans_fast_port(t12);
    goto LAB2;

LAB5:    t12 = (t0 + 2152U);
    t13 = *((char **)t12);
    t14 = *((unsigned char *)t13);
    t15 = (t14 == (unsigned char)3);
    t1 = t15;
    goto LAB7;

LAB8:    t3 = (t0 + 1352U);
    t7 = *((char **)t3);
    t3 = (t0 + 1832U);
    t8 = *((char **)t3);
    t9 = 1;
    if (4U == 4U)
        goto LAB11;

LAB12:    t9 = 0;

LAB13:    t2 = t9;
    goto LAB10;

LAB11:    t10 = 0;

LAB14:    if (t10 < 4U)
        goto LAB15;
    else
        goto LAB13;

LAB15:    t3 = (t7 + t10);
    t11 = (t8 + t10);
    if (*((unsigned char *)t3) != *((unsigned char *)t11))
        goto LAB12;

LAB16:    t10 = (t10 + 1);
    goto LAB14;

LAB18:    goto LAB2;

}

static void work_a_1439684516_3212880686_p_2(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned char t11;
    unsigned int t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    int t17;
    int t18;
    unsigned int t19;
    unsigned int t20;

LAB0:    xsi_set_current_line(60, ng0);
    t1 = (t0 + 1032U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)3);
    if (t4 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 4592);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(61, ng0);
    t1 = (t0 + 2152U);
    t5 = *((char **)t1);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)2);
    if (t7 != 0)
        goto LAB5;

LAB7:    t1 = (t0 + 2312U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)3);
    if (t4 != 0)
        goto LAB10;

LAB11:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(62, ng0);
    t1 = xsi_get_transient_memory(128U);
    memset(t1, 0, 128U);
    t8 = t1;
    t9 = (t0 + 2768U);
    t10 = *((char **)t9);
    t11 = (8U != 0);
    if (t11 == 1)
        goto LAB8;

LAB9:    t9 = (t0 + 4800);
    t13 = (t9 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    memcpy(t16, t1, 128U);
    xsi_driver_first_trans_fast(t9);
    goto LAB6;

LAB8:    t12 = (128U / 8U);
    xsi_mem_set_data(t8, t10, 8U, t12);
    goto LAB9;

LAB10:    xsi_set_current_line(64, ng0);
    t1 = (t0 + 1992U);
    t5 = *((char **)t1);
    t1 = (t0 + 1832U);
    t8 = *((char **)t1);
    t1 = (t0 + 7464U);
    t17 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t8, t1);
    t18 = (t17 - 15);
    t12 = (t18 * -1);
    t19 = (8U * t12);
    t20 = (0U + t19);
    t9 = (t0 + 4800);
    t10 = (t9 + 56U);
    t13 = *((char **)t10);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t5, 8U);
    xsi_driver_first_trans_delta(t9, t20, 8U, 0LL);
    goto LAB6;

}


void ieee_p_2592010699_sub_7991387870887201249_503743352();

extern void work_a_1439684516_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1439684516_3212880686_p_0,(void *)work_a_1439684516_3212880686_p_1,(void *)work_a_1439684516_3212880686_p_2};
	xsi_register_didat("work_a_1439684516_3212880686", "isim/banc_registres_test_isim_beh.exe.sim/work/a_1439684516_3212880686.didat");
	xsi_register_executes(pe);
	xsi_register_resolution_function(3, 2, (void *)ieee_p_2592010699_sub_7991387870887201249_503743352, 8);
}
