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
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    unsigned char t14;
    unsigned int t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    int t20;
    int t21;
    unsigned int t22;
    unsigned int t23;

LAB0:    xsi_set_current_line(60, ng0);
    t2 = (t0 + 992U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4592);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(61, ng0);
    t4 = (t0 + 2152U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)2);
    if (t10 != 0)
        goto LAB8;

LAB10:    t2 = (t0 + 2312U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = (t1 == (unsigned char)3);
    if (t3 != 0)
        goto LAB13;

LAB14:
LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 1032U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(62, ng0);
    t4 = xsi_get_transient_memory(128U);
    memset(t4, 0, 128U);
    t11 = t4;
    t12 = (t0 + 2768U);
    t13 = *((char **)t12);
    t14 = (8U != 0);
    if (t14 == 1)
        goto LAB11;

LAB12:    t12 = (t0 + 4800);
    t16 = (t12 + 56U);
    t17 = *((char **)t16);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    memcpy(t19, t4, 128U);
    xsi_driver_first_trans_fast(t12);
    goto LAB9;

LAB11:    t15 = (128U / 8U);
    xsi_mem_set_data(t11, t13, 8U, t15);
    goto LAB12;

LAB13:    xsi_set_current_line(64, ng0);
    t2 = (t0 + 1992U);
    t5 = *((char **)t2);
    t2 = (t0 + 1832U);
    t8 = *((char **)t2);
    t2 = (t0 + 7464U);
    t20 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t8, t2);
    t21 = (t20 - 15);
    t15 = (t21 * -1);
    t22 = (8U * t15);
    t23 = (0U + t22);
    t11 = (t0 + 4800);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    t16 = (t13 + 56U);
    t17 = *((char **)t16);
    memcpy(t17, t5, 8U);
    xsi_driver_first_trans_delta(t11, t23, 8U, 0LL);
    goto LAB9;

}


void ieee_p_2592010699_sub_7991387870887201249_503743352();

extern void work_a_1439684516_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1439684516_3212880686_p_0,(void *)work_a_1439684516_3212880686_p_1,(void *)work_a_1439684516_3212880686_p_2};
	xsi_register_didat("work_a_1439684516_3212880686", "isim/banc_registres_test_isim_beh.exe.sim/work/a_1439684516_3212880686.didat");
	xsi_register_executes(pe);
	xsi_register_resolution_function(3, 2, (void *)ieee_p_2592010699_sub_7991387870887201249_503743352, 8);
}
