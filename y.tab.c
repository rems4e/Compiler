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

#line 2 "desc.y"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*#include <hashcode.h>*/

#define True 1
#define False 0
#define length 30

char buffer[400] ;
typedef int bool ;
typedef struct entry {
	bool affected ;/*TODO*/
	char* nom ;
	int add ;
} entry ;

bool isDeclar(char* nom);
int yyerror(const char *s) ;
int yylex() ;

/*table des symbole*/
entry tab_symb[length] ; /* à remplacer par un hashcode //TODO*/
int ind = 0 ;

/*TODO*/
void affectation(char* nom){
int i = 0;
bool found = isDeclar(nom) ;

	for(i=0; i<length;i++){
		if(strcmp(nom,tab_symb[i].nom)==0)
			tab_symb[i].affected = 1 ;
			tab_symb[i].add = i ;		
	}
	if(found ==0){printf("Erreur : variable non déclarée") ;}
}

void declaration(char* nom){
int i = 0 ;
entry new_entry = {False,nom} ;
	for(i=0; i<length;i++){
		if(strcmp(nom,tab_symb[i].nom)==0)
			printf("redéclaration d'une variable");
		else{
			tab_symb[ind++]=new_entry ;
		}		
	}
}

bool isDeclar(char* nom){
int i = 0;
	for( i=0; i<length;i++){
		if(strcmp(nom,tab_symb[i].nom)==0)
			return True ;
	}
	return False ;
}

void print(int val){
	printf("%d",val) ;
} 

#line 68 "desc.y"
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union {int nb; char* var;} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
#line 93 "y.tab.c"

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

#define tNOMBRE 257
#define tID 258
#define tFCT 259
#define tPO 260
#define tPF 261
#define tVIR 262
#define tBO 263
#define tBF 264
#define tINT 265
#define tCONST 266
#define tPLUS 267
#define tMOINS 268
#define tDIV 269
#define tMUL 270
#define tEGAL 271
#define tF 272
#define tMAIN 273
#define YYERRCODE 256
static const short yylhs[] = {                           -1,
    0,    0,    1,    4,    6,    4,    8,    4,    9,    4,
   10,   10,   10,   10,   10,    2,    2,    3,    3,    7,
    7,    7,    7,    7,    7,    7,    7,   12,   12,   11,
   11,   13,   13,    5,    5,
};
static const short yylen[] = {                            2,
    0,    2,    2,    3,    0,    4,    0,    6,    0,    6,
    0,    2,    2,    4,    4,    0,    2,    0,    2,    1,
    1,    3,    3,    3,    3,    3,    4,    0,    2,    0,
    2,    1,    2,    1,    1,
};
static const short yydefred[] = {                         0,
   34,   35,    0,    0,    0,    0,    0,    2,   20,    0,
    0,    3,    0,    0,   17,    0,    0,    0,    0,    0,
   12,    0,    0,    0,    0,   13,   19,    4,    0,    0,
    0,    0,    0,    0,   26,    0,    0,   24,   25,    0,
    6,   33,   27,   31,   14,   15,    0,    0,    8,   10,
};
static const short yydgoto[] = {                          3,
    4,    5,   12,    6,    7,   30,   13,   47,   48,   14,
   32,    0,   33,
};
static const short yysindex[] = {                      -195,
    0,    0,    0, -195, -197, -195, -254,    0,    0, -247,
 -169,    0, -203, -197,    0, -230, -169, -169, -248, -175,
    0, -169, -169, -169, -169,    0,    0,    0, -169, -252,
 -262, -234, -169, -194,    0, -227, -227,    0,    0, -214,
    0,    0,    0,    0,    0,    0, -222, -226,    0,    0,
};
static const short yyrindex[] = {                         2,
    0,    0,    0,    2,    1,   11,    0,    0,    0, -185,
    0,    0,    0,    1,    0, -200, -182,    0, -239,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
 -161,    0, -182,    0,    0, -223, -210,    0,    0, -236,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
};
static const short yygindex[] = {                        76,
    0,   75,   84,    0,    0,    0,   -8,    0,    0,    0,
   57,    0,    0,
};
#define YYTABLESIZE 271
static const short yytable[] = {                         42,
   11,    1,   20,   16,   22,   23,   24,   25,   31,   34,
   16,   17,   17,   36,   37,   38,   39,   21,   21,   41,
   40,   21,   21,   18,   31,    7,   43,   21,   21,   21,
   21,   28,   21,   22,   22,    9,   22,   22,   22,   49,
   29,   24,   25,   22,   22,   50,   23,   23,   22,   23,
   23,   23,   22,   23,   24,   25,   23,   23,   21,    9,
   10,   23,   11,   22,   23,   24,   25,   45,   26,    1,
    2,    5,   22,   23,   24,   25,   21,   46,   30,    8,
   15,   21,   21,   21,   21,   35,   21,    9,   19,   44,
   11,   22,   23,   24,   25,   32,   32,   27,   32,   32,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   16,   16,
    0,   16,    0,    0,    0,   11,   11,   16,   16,    0,
   16,
};
static const short yycheck[] = {                        262,
    0,    0,   11,  258,  267,  268,  269,  270,   17,   18,
    0,  260,  260,   22,   23,   24,   25,  257,  258,  272,
   29,  261,  262,  271,   33,  262,  261,  267,  268,  269,
  270,  262,  272,  257,  258,  272,  260,  261,  262,  262,
  271,  269,  270,  267,  268,  272,  257,  258,  272,  260,
  261,  262,  267,  268,  269,  270,  267,  268,  262,  257,
  258,  272,  260,  267,  268,  269,  270,  262,  272,  265,
  266,  272,  267,  268,  269,  270,  262,  272,  261,    4,
    6,  267,  268,  269,  270,  261,  272,  257,  258,   33,
  260,  267,  268,  269,  270,  257,  258,   14,  260,  261,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  257,  258,
   -1,  260,   -1,   -1,   -1,  265,  266,  257,  258,   -1,
  260,
};
#define YYFINAL 3
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 273
#define YYTRANSLATE(a) ((a) > YYMAXTOKEN ? (YYMAXTOKEN + 1) : (a))
#if YYDEBUG
static const char *yyname[] = {

"end-of-file",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"tNOMBRE","tID","tFCT","tPO",
"tPF","tVIR","tBO","tBF","tINT","tCONST","tPLUS","tMOINS","tDIV","tMUL","tEGAL",
"tF","tMAIN","illegal-symbol",
};
static const char *yyrule[] = {
"$accept : S",
"S :",
"S : Corps S",
"Corps : Defs Instrucs",
"Def : Type tID tVIR",
"$$1 :",
"Def : Type tID $$1 tF",
"$$2 :",
"Def : Type tID tEGAL Exp $$2 tVIR",
"$$3 :",
"Def : Type tID tEGAL Exp $$3 tF",
"Instruc :",
"Instruc : Exp tVIR",
"Instruc : Exp tF",
"Instruc : tID tEGAL Exp tVIR",
"Instruc : tID tEGAL Exp tF",
"Defs :",
"Defs : Def Defs",
"Instrucs :",
"Instrucs : Instruc Instrucs",
"Exp : tNOMBRE",
"Exp : tID",
"Exp : Exp tPLUS Exp",
"Exp : Exp tMOINS Exp",
"Exp : Exp tDIV Exp",
"Exp : Exp tMUL Exp",
"Exp : tPO Exp tPF",
"Exp : tID tPO Args tPF",
"Exps :",
"Exps : Exp Exps",
"Args :",
"Args : Arg Args",
"Arg : Exp",
"Arg : Exp tVIR",
"Type : tINT",
"Type : tCONST",

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
#line 129 "desc.y"
int yyerror(const char *s) {
  printf("%s \n",s);
}

int main(void) {
  yyparse();
}

//http://langevin.univ-tln.fr/CDE/LEXYACC/Lex-Yacc3.html
#line 348 "y.tab.c"

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
case 4:
#line 91 "desc.y"
	{declaration(yystack.l_mark[-1].var);}
break;
case 5:
#line 92 "desc.y"
	{declaration(yystack.l_mark[0].var);}
break;
case 7:
#line 93 "desc.y"
	{declaration(yystack.l_mark[-2].var);affectation(yystack.l_mark[-2].var);}
break;
case 9:
#line 94 "desc.y"
	{declaration(yystack.l_mark[-2].var);affectation(yystack.l_mark[-2].var);}
break;
#line 566 "y.tab.c"
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
