#ifndef lint
static const char yysccsid[] = "@(#)yaccpar	1.9 (Berkeley) 02/21/93";
#endif

#define YYBYACC 1
#define YYMAJOR 1
#define YYMINOR 9
#define YYPATCH 20140101

#define YYEMPTY        (-1)
#define yyclearin      (yychar = YYEMPTY)
#define yyerrok        (yyerrflag = 0)
#define YYRECOVERING() (yyerrflag != 0)

#define YYPREFIX "yy"

#define YYPURE 0

#line 2 "cross_assembleur.yacc"
  #include <stdio.h>

  #ifdef DEBUG
    #define DEBUG_YACC(list...) \
      printf(list);
  #else
    #define DEBUG_YACC(list...)
  #endif


  #define TRAITER_INSTRUCTION(A, B, C, D) \
    {                                     \
      printf("\"");                       \
      print_binaire(A, 8);                \
      printf("\" \& \"");                 \
      print_binaire(B, 8);                \
      printf("\" \& \"");                 \
      print_binaire(C, 8);                \
      printf("\" \& \"");                 \
      print_binaire(D, 8);                \
      printf("\",\n ");                   \
    } while (0);

  void print_binaire(int nombre, int taille) {
    int mask = 1 << (taille - 1);
    while (mask) {
      if ((nombre & mask) == 0) {
        printf("0");
      } else {
        printf("1");
      }
      mask = mask >> 1;
    }
  }

  #define DEST_ADD   0x1
  #define DEST_MUL   0x2
  #define DEST_SOU   0x3
  #define DEST_DIV   0x4
  #define DEST_COP   0x5
  #define DEST_AFC   0x6
  #define DEST_JMP   0x7
  #define DEST_JMF   0x8
  #define DEST_INF   0x9
  #define DEST_SUP   0xA
  #define DEST_EQU   0xB
  #define DEST_PRI   0xC
  #define DEST_LOAD  0xD
  #define DEST_STORE 0xE

#line 70 "y.tab.c"

#ifndef YYSTYPE
typedef int YYSTYPE;
#endif

/* compatibility with bison */
#ifdef YYPARSE_PARAM
/* compatibility with FreeBSD */
# ifdef YYPARSE_PARAM_TYPE
#  define YYPARSE_DECL() yyparse(YYPARSE_PARAM_TYPE YYPARSE_PARAM)
# else
#  define YYPARSE_DECL() yyparse(void *YYPARSE_PARAM)
# endif
#else
# define YYPARSE_DECL() yyparse(void)
#endif

/* Parameters sent to lex. */
#ifdef YYLEX_PARAM
# define YYLEX_DECL() yylex(void *YYLEX_PARAM)
# define YYLEX yylex(YYLEX_PARAM)
#else
# define YYLEX_DECL() yylex(void)
# define YYLEX yylex()
#endif

/* Parameters sent to yyerror. */
#ifndef YYERROR_DECL
#define YYERROR_DECL() yyerror(const char *s)
#endif
#ifndef YYERROR_CALL
#define YYERROR_CALL(msg) yyerror(msg)
#endif

extern int YYPARSE_DECL();

#define ADD 257
#define MUL 258
#define SOU 259
#define DIV 260
#define COP 261
#define AFC 262
#define JMP 263
#define JMF 264
#define INF 265
#define SUP 266
#define EQU 267
#define PRI 268
#define ENT 269
#define YYERRCODE 256
static const short yylhs[] = {                           -1,
    0,    0,    1,    1,    1,    1,    1,    1,    1,    1,
    1,    1,    1,    1,    2,    3,    4,    5,    6,    7,
    8,    9,   10,   11,   12,   13,
};
static const short yylen[] = {                            2,
    2,    0,    1,    1,    1,    1,    1,    1,    1,    1,
    1,    1,    1,    1,    4,    4,    4,    4,    3,    3,
    2,    3,    4,    4,    4,    2,
};
static const short yydefred[] = {                         0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    3,    4,    5,    6,    7,    8,
    9,   10,   11,   12,   13,   14,    0,    0,    0,    0,
    0,    0,   21,    0,    0,    0,    0,   26,    1,    0,
    0,    0,    0,   19,   20,   22,    0,    0,    0,   15,
   16,   17,   18,   23,   24,   25,
};
static const short yydgoto[] = {                         13,
   14,   15,   16,   17,   18,   19,   20,   21,   22,   23,
   24,   25,   26,
};
static const short yysindex[] = {                      -257,
 -256, -255, -254, -253, -252, -251, -250, -249, -248, -247,
 -246, -245,    0, -257,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0, -244, -243, -242, -241,
 -240, -239,    0, -238, -237, -236, -235,    0,    0, -234,
 -233, -232, -231,    0,    0,    0, -230, -229, -228,    0,
    0,    0,    0,    0,    0,    0,
};
static const short yyrindex[] = {                        12,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   12,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,
};
static const short yygindex[] = {                        28,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,
};
#define YYTABLESIZE 42
static const short yytable[] = {                          1,
    2,    3,    4,    5,    6,    7,    8,    9,   10,   11,
   12,    2,   27,   28,   29,   30,   31,   32,   33,   34,
   35,   36,   37,   38,   40,   41,   42,   43,   44,   45,
   46,   47,   48,   49,   50,   51,   52,   53,   54,   55,
   56,   39,
};
static const short yycheck[] = {                        257,
  258,  259,  260,  261,  262,  263,  264,  265,  266,  267,
  268,    0,  269,  269,  269,  269,  269,  269,  269,  269,
  269,  269,  269,  269,  269,  269,  269,  269,  269,  269,
  269,  269,  269,  269,  269,  269,  269,  269,  269,  269,
  269,   14,
};
#define YYFINAL 13
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 269
#define YYTRANSLATE(a) ((a) > YYMAXTOKEN ? (YYMAXTOKEN + 1) : (a))
#if YYDEBUG
static const char *yyname[] = {

"end-of-file",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"ADD","MUL","SOU","DIV","COP",
"AFC","JMP","JMF","INF","SUP","EQU","PRI","ENT","illegal-symbol",
};
static const char *yyrule[] = {
"$accept : instructions",
"instructions : instruction instructions",
"instructions :",
"instruction : instruction_add",
"instruction : instruction_mul",
"instruction : instruction_sou",
"instruction : instruction_div",
"instruction : instruction_cop",
"instruction : instruction_afc",
"instruction : instruction_jmp",
"instruction : instruction_jmf",
"instruction : instruction_inf",
"instruction : instruction_sup",
"instruction : instruction_equ",
"instruction : instruction_pri",
"instruction_add : ADD ENT ENT ENT",
"instruction_mul : MUL ENT ENT ENT",
"instruction_sou : SOU ENT ENT ENT",
"instruction_div : DIV ENT ENT ENT",
"instruction_cop : COP ENT ENT",
"instruction_afc : AFC ENT ENT",
"instruction_jmp : JMP ENT",
"instruction_jmf : JMF ENT ENT",
"instruction_inf : INF ENT ENT ENT",
"instruction_sup : SUP ENT ENT ENT",
"instruction_equ : EQU ENT ENT ENT",
"instruction_pri : PRI ENT",

};
#endif

int      yydebug;
int      yynerrs;

int      yyerrflag;
int      yychar;
YYSTYPE  yyval;
YYSTYPE  yylval;

/* define the initial stack-sizes */
#ifdef YYSTACKSIZE
#undef YYMAXDEPTH
#define YYMAXDEPTH  YYSTACKSIZE
#else
#ifdef YYMAXDEPTH
#define YYSTACKSIZE YYMAXDEPTH
#else
#define YYSTACKSIZE 10000
#define YYMAXDEPTH  10000
#endif
#endif

#define YYINITSTACKSIZE 200

typedef struct {
    unsigned stacksize;
    short    *s_base;
    short    *s_mark;
    short    *s_last;
    YYSTYPE  *l_base;
    YYSTYPE  *l_mark;
} YYSTACKDATA;
/* variables for the parser stack */
static YYSTACKDATA yystack;
#line 149 "cross_assembleur.yacc"

void yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv) {
  int ret;
  printf("(");
  ret = yyparse();
  printf("others => (others => '0'));\n");
  return ret;
}
#line 273 "y.tab.c"

#if YYDEBUG
#include <stdio.h>		/* needed for printf */
#endif

#include <stdlib.h>	/* needed for malloc, etc */
#include <string.h>	/* needed for memset */

/* allocate initial stack or double stack size, up to YYMAXDEPTH */
static int yygrowstack(YYSTACKDATA *data)
{
    int i;
    unsigned newsize;
    short *newss;
    YYSTYPE *newvs;

    if ((newsize = data->stacksize) == 0)
        newsize = YYINITSTACKSIZE;
    else if (newsize >= YYMAXDEPTH)
        return -1;
    else if ((newsize *= 2) > YYMAXDEPTH)
        newsize = YYMAXDEPTH;

    i = (int) (data->s_mark - data->s_base);
    newss = (short *)realloc(data->s_base, newsize * sizeof(*newss));
    if (newss == 0)
        return -1;

    data->s_base = newss;
    data->s_mark = newss + i;

    newvs = (YYSTYPE *)realloc(data->l_base, newsize * sizeof(*newvs));
    if (newvs == 0)
        return -1;

    data->l_base = newvs;
    data->l_mark = newvs + i;

    data->stacksize = newsize;
    data->s_last = data->s_base + newsize - 1;
    return 0;
}

#if YYPURE || defined(YY_NO_LEAKS)
static void yyfreestack(YYSTACKDATA *data)
{
    free(data->s_base);
    free(data->l_base);
    memset(data, 0, sizeof(*data));
}
#else
#define yyfreestack(data) /* nothing */
#endif

#define YYABORT  goto yyabort
#define YYREJECT goto yyabort
#define YYACCEPT goto yyaccept
#define YYERROR  goto yyerrlab

int
YYPARSE_DECL()
{
    int yym, yyn, yystate;
#if YYDEBUG
    const char *yys;

    if ((yys = getenv("YYDEBUG")) != 0)
    {
        yyn = *yys;
        if (yyn >= '0' && yyn <= '9')
            yydebug = yyn - '0';
    }
#endif

    yynerrs = 0;
    yyerrflag = 0;
    yychar = YYEMPTY;
    yystate = 0;

#if YYPURE
    memset(&yystack, 0, sizeof(yystack));
#endif

    if (yystack.s_base == NULL && yygrowstack(&yystack)) goto yyoverflow;
    yystack.s_mark = yystack.s_base;
    yystack.l_mark = yystack.l_base;
    yystate = 0;
    *yystack.s_mark = 0;

yyloop:
    if ((yyn = yydefred[yystate]) != 0) goto yyreduce;
    if (yychar < 0)
    {
        if ((yychar = YYLEX) < 0) yychar = 0;
#if YYDEBUG
        if (yydebug)
        {
            yys = yyname[YYTRANSLATE(yychar)];
            printf("%sdebug: state %d, reading %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
    }
    if ((yyn = yysindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: state %d, shifting to state %d\n",
                    YYPREFIX, yystate, yytable[yyn]);
#endif
        if (yystack.s_mark >= yystack.s_last && yygrowstack(&yystack))
        {
            goto yyoverflow;
        }
        yystate = yytable[yyn];
        *++yystack.s_mark = yytable[yyn];
        *++yystack.l_mark = yylval;
        yychar = YYEMPTY;
        if (yyerrflag > 0)  --yyerrflag;
        goto yyloop;
    }
    if ((yyn = yyrindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
        yyn = yytable[yyn];
        goto yyreduce;
    }
    if (yyerrflag) goto yyinrecovery;

    yyerror("syntax error");

    goto yyerrlab;

yyerrlab:
    ++yynerrs;

yyinrecovery:
    if (yyerrflag < 3)
    {
        yyerrflag = 3;
        for (;;)
        {
            if ((yyn = yysindex[*yystack.s_mark]) && (yyn += YYERRCODE) >= 0 &&
                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: state %d, error recovery shifting\
 to state %d\n", YYPREFIX, *yystack.s_mark, yytable[yyn]);
#endif
                if (yystack.s_mark >= yystack.s_last && yygrowstack(&yystack))
                {
                    goto yyoverflow;
                }
                yystate = yytable[yyn];
                *++yystack.s_mark = yytable[yyn];
                *++yystack.l_mark = yylval;
                goto yyloop;
            }
            else
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: error recovery discarding state %d\n",
                            YYPREFIX, *yystack.s_mark);
#endif
                if (yystack.s_mark <= yystack.s_base) goto yyabort;
                --yystack.s_mark;
                --yystack.l_mark;
            }
        }
    }
    else
    {
        if (yychar == 0) goto yyabort;
#if YYDEBUG
        if (yydebug)
        {
            yys = yyname[YYTRANSLATE(yychar)];
            printf("%sdebug: state %d, error recovery discards token %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
        yychar = YYEMPTY;
        goto yyloop;
    }

yyreduce:
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: state %d, reducing by rule %d (%s)\n",
                YYPREFIX, yystate, yyn, yyrule[yyn]);
#endif
    yym = yylen[yyn];
    if (yym)
        yyval = yystack.l_mark[1-yym];
    else
        memset(&yyval, 0, sizeof yyval);
    switch (yyn)
    {
case 15:
#line 75 "cross_assembleur.yacc"
	{
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-2], 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-1], 2, 0);
                    TRAITER_INSTRUCTION(DEST_ADD,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, yystack.l_mark[-1], 1, 0);
                  }
break;
case 16:
#line 82 "cross_assembleur.yacc"
	{
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-2], 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-1], 2, 0);
                    TRAITER_INSTRUCTION(DEST_MUL,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, yystack.l_mark[-1], 1, 0);
                  }
break;
case 17:
#line 89 "cross_assembleur.yacc"
	{
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-2], 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-1], 2, 0);
                    TRAITER_INSTRUCTION(DEST_SOU,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, yystack.l_mark[-1], 1, 0);
                  }
break;
case 18:
#line 96 "cross_assembleur.yacc"
	{
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-2], 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-1], 2, 0);
                    TRAITER_INSTRUCTION(DEST_DIV,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, yystack.l_mark[-1], 1, 0);
                  }
break;
case 19:
#line 103 "cross_assembleur.yacc"
	{
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[0], 1, 0);
                    TRAITER_INSTRUCTION(DEST_STORE, yystack.l_mark[-1], 1, 0);
                  }
break;
case 20:
#line 108 "cross_assembleur.yacc"
	{
                    TRAITER_INSTRUCTION(DEST_AFC,   yystack.l_mark[0], 1, 0);
                    TRAITER_INSTRUCTION(DEST_STORE, yystack.l_mark[-1], 1, 0);
                  }
break;
case 21:
#line 113 "cross_assembleur.yacc"
	{
                    TRAITER_INSTRUCTION(DEST_JMP, yystack.l_mark[0], 0, 0);
                  }
break;
case 22:
#line 117 "cross_assembleur.yacc"
	{
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-1], 1, 0);
                    TRAITER_INSTRUCTION(DEST_JMF,   yystack.l_mark[0], 1, 0);
                  }
break;
case 23:
#line 122 "cross_assembleur.yacc"
	{
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-2], 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-1], 2, 0);
                    TRAITER_INSTRUCTION(DEST_INF,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, yystack.l_mark[-1], 1, 0);
                  }
break;
case 24:
#line 129 "cross_assembleur.yacc"
	{
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-2], 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-1], 2, 0);
                    TRAITER_INSTRUCTION(DEST_SUP,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, yystack.l_mark[-1], 1, 0);
                  }
break;
case 25:
#line 136 "cross_assembleur.yacc"
	{
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-2], 1, 0);
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[-1], 2, 0);
                    TRAITER_INSTRUCTION(DEST_EQU,    2, 1, 1);
                    TRAITER_INSTRUCTION(DEST_STORE, yystack.l_mark[-1], 1, 0);
                  }
break;
case 26:
#line 143 "cross_assembleur.yacc"
	{
                    TRAITER_INSTRUCTION(DEST_LOAD,  yystack.l_mark[0], 1, 0);
                    TRAITER_INSTRUCTION(DEST_PRI,    2, 1, 1);
                  }
break;
#line 572 "y.tab.c"
    }
    yystack.s_mark -= yym;
    yystate = *yystack.s_mark;
    yystack.l_mark -= yym;
    yym = yylhs[yyn];
    if (yystate == 0 && yym == 0)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: after reduction, shifting from state 0 to\
 state %d\n", YYPREFIX, YYFINAL);
#endif
        yystate = YYFINAL;
        *++yystack.s_mark = YYFINAL;
        *++yystack.l_mark = yyval;
        if (yychar < 0)
        {
            if ((yychar = YYLEX) < 0) yychar = 0;
#if YYDEBUG
            if (yydebug)
            {
                yys = yyname[YYTRANSLATE(yychar)];
                printf("%sdebug: state %d, reading %d (%s)\n",
                        YYPREFIX, YYFINAL, yychar, yys);
            }
#endif
        }
        if (yychar == 0) goto yyaccept;
        goto yyloop;
    }
    if ((yyn = yygindex[yym]) && (yyn += yystate) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)
        yystate = yytable[yyn];
    else
        yystate = yydgoto[yym];
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: after reduction, shifting from state %d \
to state %d\n", YYPREFIX, *yystack.s_mark, yystate);
#endif
    if (yystack.s_mark >= yystack.s_last && yygrowstack(&yystack))
    {
        goto yyoverflow;
    }
    *++yystack.s_mark = (short) yystate;
    *++yystack.l_mark = yyval;
    goto yyloop;

yyoverflow:
    yyerror("yacc stack overflow");

yyabort:
    yyfreestack(&yystack);
    return (1);

yyaccept:
    yyfreestack(&yystack);
    return (0);
}
