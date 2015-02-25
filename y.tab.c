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


#line 65 "desc.y"
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union {int nb; char* var;} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
#line 90 "y.tab.c"

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
    0,    0,    0,    1,    2,    2,    4,    4,    6,    7,
    6,    9,    6,   10,    6,    5,    5,   11,   11,   11,
   12,   12,    8,    8,    8,    8,    8,    8,    8,    8,
   13,   13,   14,   14,    3,    3,
};
static const short yylen[] = {                            2,
    0,    1,    2,    7,    2,    8,    0,    2,    3,    0,
    4,    0,    6,    0,    6,    0,    2,    0,    4,    4,
    0,    2,    1,    1,    3,    3,    3,    3,    3,    4,
    0,    2,    1,    3,    1,    1,
};
static const short yydefred[] = {                         0,
   35,   36,    0,    2,    0,    0,    0,    0,    3,    0,
    0,    0,    5,    0,    0,    8,    0,    9,    0,    0,
    0,    0,   17,    0,    0,   23,    0,    0,    0,   11,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   19,   20,    0,    0,    0,    0,   29,    0,
    0,   27,   28,   13,   15,    0,    0,    0,    0,   30,
   32,    4,    6,   34,
};
static const short yydgoto[] = {                          3,
    4,    5,    6,    7,   13,    8,   20,   46,   40,   41,
   14,    0,   47,   48,
};
static const short yysindex[] = {                      -239,
    0,    0,    0,    0, -239, -251, -242, -239,    0, -254,
 -227, -236,    0, -242, -238,    0, -210,    0, -247, -217,
 -202, -247,    0, -248, -203,    0, -199, -247, -224,    0,
 -201, -184, -239, -247, -174, -247, -247, -247, -247, -197,
 -200, -239,    0,    0, -242, -170, -188, -247,    0, -230,
 -230,    0,    0,    0,    0, -190, -183, -185, -247,    0,
    0,    0,    0,    0,
};
static const short yyrindex[] = {                         2,
    0,    0,    0,    0,    2,    0,    1,    4,    0, -192,
    0,    0,    0,    1,    0,    0,    0,    0,    0,    0,
    0,    0,    0, -192,    0,    0, -220,    0, -253,    0,
    0,    0, -240, -202,    0,    0,    0,    0,    0,    0,
    0, -240,    0,    0, -182, -156,    0, -202,    0, -204,
 -191,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,
};
static const short yygindex[] = {                        84,
    0,   48,   -8,   -5,   -9,    0,    0,   -7,    0,    0,
    0,    0,   43,   44,
};
#define YYTABLESIZE 268
static const short yytable[] = {                         15,
   16,    1,   16,    7,   23,   17,   10,   18,   12,   26,
   27,   29,   28,   18,   32,   12,   19,    7,   14,   24,
   35,   11,   19,    7,   15,    1,    2,   45,   50,   51,
   52,   53,   21,   57,   22,   58,   24,   24,   38,   39,
   24,   24,   36,   37,   38,   39,   24,   24,   24,   24,
   25,   24,   25,   25,   30,   25,   25,   25,   31,   33,
   34,   42,   25,   25,   54,   26,   26,   25,   26,   26,
   26,   55,   60,   62,   10,   26,   26,   43,   63,   10,
   26,   16,   36,   37,   38,   39,   49,   44,    9,   56,
   61,   59,   36,   37,   38,   39,   36,   37,   38,   39,
   33,   33,   64,   33,   33,    0,    0,    0,    0,    0,
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
    0,    0,    0,    0,    0,    0,    0,    0,    0,    7,
    0,    7,    0,    0,   16,   16,   16,    7,
};
static const short yycheck[] = {                          8,
    0,    0,    8,    0,   14,  260,  258,  262,  262,  257,
  258,   19,  260,  262,   22,  258,  271,  258,  272,  258,
   28,  273,  271,  264,   33,  265,  266,   33,   36,   37,
   38,   39,  260,   42,  271,   45,  257,  258,  269,  270,
  261,  262,  267,  268,  269,  270,  267,  268,  269,  270,
  261,  272,  257,  258,  272,  260,  261,  262,  261,  263,
  260,  263,  267,  268,  262,  257,  258,  272,  260,  261,
  262,  272,  261,  264,  258,  267,  268,  262,  264,  272,
  272,  264,  267,  268,  269,  270,  261,  272,    5,   42,
   48,  262,  267,  268,  269,  270,  267,  268,  269,  270,
  257,  258,   59,  260,  261,   -1,   -1,   -1,   -1,   -1,
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
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  258,
   -1,  258,   -1,   -1,  264,  265,  266,  264,
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
"S : LeMain",
"S : Corps S",
"LeMain : Type tMAIN tPO tPF tBO Corps tBF",
"Corps : Defs Instrucs",
"Corps : Type tID tPO tPF tBO Defs Instrucs tBF",
"Defs :",
"Defs : Def Defs",
"Def : Type tID tVIR",
"$$1 :",
"Def : Type tID $$1 tF",
"$$2 :",
"Def : Type tID tEGAL Exp $$2 tVIR",
"$$3 :",
"Def : Type tID tEGAL Exp $$3 tF",
"Instrucs :",
"Instrucs : Instruc Instrucs",
"Instruc :",
"Instruc : tID tEGAL Exp tVIR",
"Instruc : tID tEGAL Exp tF",
"Exps :",
"Exps : Exp Exps",
"Exp : tNOMBRE",
"Exp : tID",
"Exp : Exp tPLUS Exp",
"Exp : Exp tMOINS Exp",
"Exp : Exp tDIV Exp",
"Exp : Exp tMUL Exp",
"Exp : tPO Exp tPF",
"Exp : tID tPO Args tPF",
"Args :",
"Args : Arg Args",
"Arg : Exp",
"Arg : Exp tVIR Arg",
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
#line 130 "desc.y"
int yyerror(const char *s) {
  printf("%s \n",s);
}

int main(void) {
  yyparse();
}

//http://langevin.univ-tln.fr/CDE/LEXYACC/Lex-Yacc3.html
#line 350 "y.tab.c"

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
#line 87 "desc.y"
	{printf("Main \n");}
break;
case 9:
#line 95 "desc.y"
	{printf("%s",yystack.l_mark[-1].var) ; declaration(yystack.l_mark[-1].var);}
break;
case 10:
#line 96 "desc.y"
	{printf("%s",yystack.l_mark[0].var) ; declaration(yystack.l_mark[0].var);}
break;
case 12:
#line 97 "desc.y"
	{printf("%s",yystack.l_mark[-2].var) ; declaration(yystack.l_mark[-2].var);affectation(yystack.l_mark[-2].var);}
break;
case 14:
#line 98 "desc.y"
	{printf("%s",yystack.l_mark[-2].var) ; declaration(yystack.l_mark[-2].var);affectation(yystack.l_mark[-2].var);}
break;
case 23:
#line 110 "desc.y"
	{printf("nombre \n") ; }
break;
case 24:
#line 111 "desc.y"
	{printf("identifiant \n") ;}
break;
case 25:
#line 112 "desc.y"
	{printf("Expression \n") ;}
break;
case 26:
#line 113 "desc.y"
	{printf("Expression \n") ;}
break;
case 27:
#line 114 "desc.y"
	{printf("Expression \n") ;}
break;
case 28:
#line 115 "desc.y"
	{printf("Expression \n") ;}
break;
case 29:
#line 116 "desc.y"
	{printf("Expression \n") ;}
break;
case 30:
#line 117 "desc.y"
	{printf("Expression \n") ;}
break;
case 35:
#line 126 "desc.y"
	{printf("type reconnue \n") ;}
break;
case 36:
#line 127 "desc.y"
	{printf("type reconnue \n") ;}
break;
#line 612 "y.tab.c"
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
