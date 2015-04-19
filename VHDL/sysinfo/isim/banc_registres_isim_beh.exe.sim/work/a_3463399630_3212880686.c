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



static void work_a_3463399630_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    int t5;
    char *t6;
    char *t7;
    char *t8;
    int t9;
    int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    unsigned char t15;
    unsigned int t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    unsigned char t22;
    unsigned char t23;
    char *t24;
    char *t25;

LAB0:    t1 = (t0 + 4584U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(69, ng0);
    t2 = (t0 + 9244);
    *((int *)t2) = 15;
    t3 = (t0 + 9248);
    *((int *)t3) = 0;
    t4 = 15;
    t5 = 0;

LAB4:    if (t4 >= t5)
        goto LAB5;

LAB7:    xsi_set_current_line(78, ng0);
    t2 = (t0 + 2152U);
    t3 = *((char **)t2);
    t15 = *((unsigned char *)t3);
    t22 = (t15 == (unsigned char)2);
    if (t22 != 0)
        goto LAB36;

LAB38:
LAB37:    xsi_set_current_line(81, ng0);
    t2 = (t0 + 2312U);
    t3 = *((char **)t2);
    t15 = *((unsigned char *)t3);
    t22 = (t15 == (unsigned char)3);
    if (t22 != 0)
        goto LAB41;

LAB43:
LAB42:    xsi_set_current_line(91, ng0);
    t2 = (t0 + 2472U);
    t3 = *((char **)t2);
    t2 = (t0 + 3368U);
    t6 = *((char **)t2);
    t4 = *((int *)t6);
    t5 = (t4 - 15);
    t11 = (t5 * -1);
    xsi_vhdl_check_range_of_index(15, 0, -1, t4);
    t12 = (8U * t11);
    t13 = (0 + t12);
    t2 = (t3 + t13);
    t7 = (t0 + 5048);
    t8 = (t7 + 56U);
    t14 = *((char **)t8);
    t17 = (t14 + 56U);
    t18 = *((char **)t17);
    memcpy(t18, t2, 8U);
    xsi_driver_first_trans_fast_port(t7);
    xsi_set_current_line(92, ng0);
    t2 = (t0 + 2472U);
    t3 = *((char **)t2);
    t2 = (t0 + 3488U);
    t6 = *((char **)t2);
    t4 = *((int *)t6);
    t5 = (t4 - 15);
    t11 = (t5 * -1);
    xsi_vhdl_check_range_of_index(15, 0, -1, t4);
    t12 = (8U * t11);
    t13 = (0 + t12);
    t2 = (t3 + t13);
    t7 = (t0 + 5112);
    t8 = (t7 + 56U);
    t14 = *((char **)t8);
    t17 = (t14 + 56U);
    t18 = *((char **)t17);
    memcpy(t18, t2, 8U);
    xsi_driver_first_trans_fast_port(t7);
    xsi_set_current_line(95, ng0);

LAB63:    t2 = (t0 + 4904);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB64;

LAB1:    return;
LAB5:    xsi_set_current_line(70, ng0);
    t6 = (t0 + 1192U);
    t7 = *((char **)t6);
    t6 = (t0 + 3248U);
    t8 = *((char **)t6);
    t6 = (t0 + 9244);
    t9 = *((int *)t6);
    t10 = (t9 - 15);
    t11 = (t10 * -1);
    xsi_vhdl_check_range_of_index(15, 0, -1, *((int *)t6));
    t12 = (4U * t11);
    t13 = (0 + t12);
    t14 = (t8 + t13);
    t15 = 1;
    if (4U == 4U)
        goto LAB11;

LAB12:    t15 = 0;

LAB13:    if (t15 != 0)
        goto LAB8;

LAB10:
LAB9:    xsi_set_current_line(71, ng0);
    t2 = (t0 + 1352U);
    t3 = *((char **)t2);
    t2 = (t0 + 3248U);
    t6 = *((char **)t2);
    t2 = (t0 + 9244);
    t9 = *((int *)t2);
    t10 = (t9 - 15);
    t11 = (t10 * -1);
    xsi_vhdl_check_range_of_index(15, 0, -1, *((int *)t2));
    t12 = (4U * t11);
    t13 = (0 + t12);
    t7 = (t6 + t13);
    t15 = 1;
    if (4U == 4U)
        goto LAB20;

LAB21:    t15 = 0;

LAB22:    if (t15 != 0)
        goto LAB17;

LAB19:
LAB18:    xsi_set_current_line(72, ng0);
    t2 = (t0 + 1832U);
    t3 = *((char **)t2);
    t2 = (t0 + 3248U);
    t6 = *((char **)t2);
    t2 = (t0 + 9244);
    t9 = *((int *)t2);
    t10 = (t9 - 15);
    t11 = (t10 * -1);
    xsi_vhdl_check_range_of_index(15, 0, -1, *((int *)t2));
    t12 = (4U * t11);
    t13 = (0 + t12);
    t7 = (t6 + t13);
    t15 = 1;
    if (4U == 4U)
        goto LAB29;

LAB30:    t15 = 0;

LAB31:    if (t15 != 0)
        goto LAB26;

LAB28:
LAB27:
LAB6:    t2 = (t0 + 9244);
    t4 = *((int *)t2);
    t3 = (t0 + 9248);
    t5 = *((int *)t3);
    if (t4 == t5)
        goto LAB7;

LAB35:    t9 = (t4 + -1);
    t4 = t9;
    t6 = (t0 + 9244);
    *((int *)t6) = t4;
    goto LAB4;

LAB8:    xsi_set_current_line(70, ng0);
    t19 = (t0 + 9244);
    t20 = (t0 + 3368U);
    t21 = *((char **)t20);
    t20 = (t21 + 0);
    *((int *)t20) = *((int *)t19);
    goto LAB9;

LAB11:    t16 = 0;

LAB14:    if (t16 < 4U)
        goto LAB15;
    else
        goto LAB13;

LAB15:    t17 = (t7 + t16);
    t18 = (t14 + t16);
    if (*((unsigned char *)t17) != *((unsigned char *)t18))
        goto LAB12;

LAB16:    t16 = (t16 + 1);
    goto LAB14;

LAB17:    xsi_set_current_line(71, ng0);
    t17 = (t0 + 9244);
    t18 = (t0 + 3488U);
    t19 = *((char **)t18);
    t18 = (t19 + 0);
    *((int *)t18) = *((int *)t17);
    goto LAB18;

LAB20:    t16 = 0;

LAB23:    if (t16 < 4U)
        goto LAB24;
    else
        goto LAB22;

LAB24:    t8 = (t3 + t16);
    t14 = (t7 + t16);
    if (*((unsigned char *)t8) != *((unsigned char *)t14))
        goto LAB21;

LAB25:    t16 = (t16 + 1);
    goto LAB23;

LAB26:    xsi_set_current_line(72, ng0);
    t17 = (t0 + 9244);
    t18 = (t0 + 3608U);
    t19 = *((char **)t18);
    t18 = (t19 + 0);
    *((int *)t18) = *((int *)t17);
    goto LAB27;

LAB29:    t16 = 0;

LAB32:    if (t16 < 4U)
        goto LAB33;
    else
        goto LAB31;

LAB33:    t8 = (t3 + t16);
    t14 = (t7 + t16);
    if (*((unsigned char *)t8) != *((unsigned char *)t14))
        goto LAB30;

LAB34:    t16 = (t16 + 1);
    goto LAB32;

LAB36:    xsi_set_current_line(78, ng0);
    t2 = xsi_get_transient_memory(128U);
    memset(t2, 0, 128U);
    t6 = t2;
    t7 = (t0 + 3008U);
    t8 = *((char **)t7);
    t23 = (8U != 0);
    if (t23 == 1)
        goto LAB39;

LAB40:    t7 = (t0 + 4984);
    t14 = (t7 + 56U);
    t17 = *((char **)t14);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    memcpy(t19, t2, 128U);
    xsi_driver_first_trans_fast(t7);
    goto LAB37;

LAB39:    t11 = (128U / 8U);
    xsi_mem_set_data(t6, t8, 8U, t11);
    goto LAB40;

LAB41:    xsi_set_current_line(82, ng0);
    t2 = (t0 + 1192U);
    t6 = *((char **)t2);
    t2 = (t0 + 1832U);
    t7 = *((char **)t2);
    t23 = 1;
    if (4U == 4U)
        goto LAB47;

LAB48:    t23 = 0;

LAB49:    if (t23 != 0)
        goto LAB44;

LAB46:    t2 = (t0 + 1352U);
    t3 = *((char **)t2);
    t2 = (t0 + 1832U);
    t6 = *((char **)t2);
    t15 = 1;
    if (4U == 4U)
        goto LAB55;

LAB56:    t15 = 0;

LAB57:    if (t15 != 0)
        goto LAB53;

LAB54:    xsi_set_current_line(84, ng0);
    t2 = (t0 + 1992U);
    t3 = *((char **)t2);
    t2 = (t0 + 3608U);
    t6 = *((char **)t2);
    t4 = *((int *)t6);
    t5 = (t4 - 15);
    t11 = (t5 * -1);
    t12 = (8U * t11);
    t13 = (0U + t12);
    t2 = (t0 + 4984);
    t7 = (t2 + 56U);
    t8 = *((char **)t7);
    t14 = (t8 + 56U);
    t17 = *((char **)t14);
    memcpy(t17, t3, 8U);
    xsi_driver_first_trans_delta(t2, t13, 8U, 0LL);

LAB45:    goto LAB42;

LAB44:    xsi_set_current_line(82, ng0);
    t14 = (t0 + 2472U);
    t17 = *((char **)t14);
    t14 = (t0 + 3368U);
    t18 = *((char **)t14);
    t4 = *((int *)t18);
    t5 = (t4 - 15);
    t12 = (t5 * -1);
    xsi_vhdl_check_range_of_index(15, 0, -1, t4);
    t13 = (8U * t12);
    t16 = (0 + t13);
    t14 = (t17 + t16);
    t19 = (t0 + 5048);
    t20 = (t19 + 56U);
    t21 = *((char **)t20);
    t24 = (t21 + 56U);
    t25 = *((char **)t24);
    memcpy(t25, t14, 8U);
    xsi_driver_first_trans_fast_port(t19);
    goto LAB45;

LAB47:    t11 = 0;

LAB50:    if (t11 < 4U)
        goto LAB51;
    else
        goto LAB49;

LAB51:    t2 = (t6 + t11);
    t8 = (t7 + t11);
    if (*((unsigned char *)t2) != *((unsigned char *)t8))
        goto LAB48;

LAB52:    t11 = (t11 + 1);
    goto LAB50;

LAB53:    xsi_set_current_line(83, ng0);
    t8 = (t0 + 2472U);
    t14 = *((char **)t8);
    t8 = (t0 + 3488U);
    t17 = *((char **)t8);
    t4 = *((int *)t17);
    t5 = (t4 - 15);
    t12 = (t5 * -1);
    xsi_vhdl_check_range_of_index(15, 0, -1, t4);
    t13 = (8U * t12);
    t16 = (0 + t13);
    t8 = (t14 + t16);
    t18 = (t0 + 5112);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    t21 = (t20 + 56U);
    t24 = *((char **)t21);
    memcpy(t24, t8, 8U);
    xsi_driver_first_trans_fast_port(t18);
    goto LAB45;

LAB55:    t11 = 0;

LAB58:    if (t11 < 4U)
        goto LAB59;
    else
        goto LAB57;

LAB59:    t2 = (t3 + t11);
    t7 = (t6 + t11);
    if (*((unsigned char *)t2) != *((unsigned char *)t7))
        goto LAB56;

LAB60:    t11 = (t11 + 1);
    goto LAB58;

LAB61:    t3 = (t0 + 4904);
    *((int *)t3) = 0;
    goto LAB2;

LAB62:    goto LAB61;

LAB64:    goto LAB62;

}


void ieee_p_2592010699_sub_7991387870887201249_503743352();

void ieee_p_2592010699_sub_7991387870887201249_503743352();

extern void work_a_3463399630_3212880686_init()
{
	static char *pe[] = {(void *)work_a_3463399630_3212880686_p_0};
	xsi_register_didat("work_a_3463399630_3212880686", "isim/banc_registres_isim_beh.exe.sim/work/a_3463399630_3212880686.didat");
	xsi_register_executes(pe);
	xsi_register_resolution_function(3, 2, (void *)ieee_p_2592010699_sub_7991387870887201249_503743352, 8);
	xsi_register_resolution_function(6, 2, (void *)ieee_p_2592010699_sub_7991387870887201249_503743352, 8);
}
