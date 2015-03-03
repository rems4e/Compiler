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
	#include "constants.h"
	#include "symbol.h"

	#define SYMBOL_SIZE 30

	typedef struct yy_buffer_state *YY_BUFFER_STATE;

	bool isUsable(char* nom){
		if(!symbolDeclared(nom)){printf("affectation avec %s , variable non déclarée \n", nom) ;}
		else if (!symbolAffected(nom)){printf("affectation avec %s, variable non affectée \n", nom);}
		return symbolDeclared(nom) && symbolAffected(nom) ;
	}



	void yyerror(const char *s) ;
	int yylex() ;
	YY_BUFFER_STATE yy_scan_string (const char *yy_str  );

	void affectation(char const *nom) {
		symbol *sym = getExistingSymbol(nom);
		if(sym == NULL) {
			yyerror("Erreur : variable non déclarée");
		}

		printf("Affectation de la variable %s.\n", nom);
		sym->affected = true;

		printSymbolTable();
	}

	void declaration(char const *nom) {
		symbol *sym = createSymbol(nom);
		if(sym == NULL) {
			yyerror("Erreur : variable déjà déclarée");
		}

		printf("Déclaration de la variable %s.\n", nom);
		
		printSymbolTable();
	}

	void print(int val){
		printf("%d",val) ;
	}
 

	
#line 54 "desc.y"
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union {int nb; char* var;} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
#line 80 "y.tab.c"

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
#define tBOOL 267
#define tPLUS 268
#define tMOINS 269
#define tDIV 270
#define tMUL 271
#define tEGAL 272
#define tBOOLEGAL 273
#define tINFEGAL 274
#define tSUPEGAL 275
#define tSUP 276
#define tINF 277
#define tF 278
#define tMAIN 279
#define tIF 280
#define tTHEN 281
#define END_OF_FILE 282
#define OpBool 283
#define YYERRCODE 256
static const short yylhs[] = {                           -1,
    0,    0,    1,    2,    2,    4,    7,    6,    8,    6,
   10,    6,   11,    6,    3,    3,   12,   12,   12,   13,
   12,   12,   12,    9,    9,    9,    9,    9,    9,    9,
    9,   15,   15,   16,   16,    5,    5,   14,   14,
};
static const short yylen[] = {                            2,
    0,    2,    5,    0,    2,    2,    0,    4,    0,    3,
    0,    6,    0,    5,    0,    2,    0,    2,    2,    0,
    6,    4,    4,    1,    1,    3,    3,    3,    3,    3,
    4,    0,    2,    1,    2,    1,    1,    1,    3,
};
static const short yydefred[] = {                         1,
    0,    0,    2,    0,   36,   37,   15,    0,    0,    0,
    5,    0,    6,   24,    0,    0,    3,    0,    0,   16,
    0,    0,    0,   32,    0,    0,    0,   38,    0,    0,
   18,    0,    0,    0,    0,   19,    0,    0,   10,    0,
    0,   30,    0,    0,    0,    0,   28,   29,    0,    0,
    8,   31,    0,   33,   20,   22,    0,   23,    0,   14,
   35,    0,   12,   21,
};
static const short yydgoto[] = {                          1,
    3,    7,   10,    8,    9,   13,   22,   23,   19,   49,
   50,   20,   62,   30,   40,   54,
};
static const short yysindex[] = {                         0,
 -276, -257,    0, -131,    0,    0,    0, -131, -246, -250,
    0, -249,    0,    0, -259, -135,    0, -143, -180,    0,
 -135, -234, -247,    0, -135, -223, -176,    0, -206, -208,
    0, -135, -135, -135, -135,    0, -138, -246,    0, -203,
 -165,    0, -135, -219, -187, -187,    0,    0, -181, -178,
    0,    0, -142,    0,    0,    0, -138,    0, -246,    0,
    0, -219,    0,    0,
};
static const short yyrindex[] = {                         0,
    0,    0,    0, -214,    0,    0,    0, -214,    0,    0,
    0, -258,    0,    0, -160,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0, -236,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0, -222,    0,    0,    0,
    0,    0,    0, -157, -209, -182,    0,    0,    0,    0,
    0,    0, -190,    0,    0,    0, -169,    0,    0,    0,
    0, -157,    0,    0,
};
static const short yygindex[] = {                         0,
    0,  108,    0,    0,    0,  -23,    0,    0,  -16,    0,
    0,  -33,    0,    0,    0,    0,
};
#define YYTABLESIZE 135
static const short yytable[] = {                         27,
   24,   29,    2,    7,   37,    4,   14,   15,   41,   16,
   58,   12,   25,   17,   51,   45,   46,   47,   48,    9,
   25,   25,   21,   53,   25,   25,   57,   38,   64,   18,
   39,   25,   25,   25,   25,   63,   24,   14,   15,   11,
   16,   25,    4,    4,   25,    4,   25,   26,   26,    4,
   26,   26,   26,   14,   26,   13,   16,   52,   26,   26,
   18,   32,   33,   34,   35,    4,   34,   34,   26,   34,
   34,   26,   44,   26,   27,   27,   43,   27,   27,   27,
   59,   31,   34,   35,   42,   27,   27,   32,   33,   34,
   35,   32,   33,   34,   35,   27,   55,   36,   27,   60,
   27,   25,   32,   33,   34,   35,   17,   25,   25,   25,
   25,   39,   56,   14,   26,   11,   16,   25,    0,   61,
    0,   14,   26,   28,   16,   32,   33,   34,   35,   32,
   33,   34,   35,    5,    6,
};
static const short yycheck[] = {                         16,
  260,   18,  279,  262,   21,  263,  257,  258,   25,  260,
   44,  258,  272,  264,   38,   32,   33,   34,   35,  278,
  257,  258,  272,   40,  261,  262,   43,  262,   62,  280,
  278,  268,  269,  270,  271,   59,  260,  257,  258,  262,
  260,  278,  257,  258,  281,  260,  283,  257,  258,  264,
  260,  261,  262,  257,  258,  278,  260,  261,  268,  269,
  280,  268,  269,  270,  271,  280,  257,  258,  278,  260,
  261,  281,  281,  283,  257,  258,  283,  260,  261,  262,
  262,  262,  270,  271,  261,  268,  269,  268,  269,  270,
  271,  268,  269,  270,  271,  278,  262,  278,  281,  278,
  283,  262,  268,  269,  270,  271,  264,  268,  269,  270,
  271,  281,  278,  257,  258,    8,  260,  278,   -1,  262,
   -1,  257,  258,  267,  260,  268,  269,  270,  271,  268,
  269,  270,  271,  265,  266,
};
#define YYFINAL 1
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 283
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
"tPF","tVIR","tBO","tBF","tINT","tCONST","tBOOL","tPLUS","tMOINS","tDIV","tMUL",
"tEGAL","tBOOLEGAL","tINFEGAL","tSUPEGAL","tSUP","tINF","tF","tMAIN","tIF",
"tTHEN","END_OF_FILE","OpBool","illegal-symbol",
};
static const char *yyrule[] = {
"$accept : S",
"S :",
"S : S Corps",
"Corps : tMAIN tBO Defs Instrucs tBF",
"Defs :",
"Defs : Def Defs",
"Def : Type TypedDef",
"$$1 :",
"TypedDef : tID $$1 tVIR TypedDef",
"$$2 :",
"TypedDef : tID $$2 tF",
"$$3 :",
"TypedDef : tID tEGAL Exp $$3 tVIR TypedDef",
"$$4 :",
"TypedDef : tID tEGAL Exp $$4 tF",
"Instrucs :",
"Instrucs : Instrucs Instruc",
"Instruc :",
"Instruc : Exp tVIR",
"Instruc : Exp tF",
"$$5 :",
"Instruc : tID tEGAL Exp tVIR $$5 Instruc",
"Instruc : tID tEGAL Exp tF",
"Instruc : tIF Bool tTHEN Instruc",
"Exp : tNOMBRE",
"Exp : tID",
"Exp : Exp tPLUS Exp",
"Exp : Exp tMOINS Exp",
"Exp : Exp tDIV Exp",
"Exp : Exp tMUL Exp",
"Exp : tPO Exp tPF",
"Exp : tID tPO Args tPF",
"Args :",
"Args : Args Arg",
"Arg : Exp",
"Arg : Exp tVIR",
"Type : tINT",
"Type : tCONST",
"Bool : tBOOL",
"Bool : Exp OpBool Exp",

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
#line 136 "desc.y"
void yyerror(const char *s) {
	printf("%s\n",s);
}

int main(int argc, char const **argv) {
	initSymbolTable();

	char *buf;
	if(argc > 1) {
		long len;
		FILE * f = fopen (argv[1], "rb");

		if(f) {
			fseek (f, 0, SEEK_END);
			len = ftell (f);
			fseek (f, 0, SEEK_SET);
			buf = malloc (len);
			if(buf) {
				fread (buf, 1, len, f);
			}
			fclose (f);
		}

		if(buf) {
			yy_scan_string(buf);
		}
		else {
			return 1;
		}
	}



	yyparse();
	free(buf);

	return 0;
}

//http://langevin.univ-tln.fr/CDE/LEXYACC/Lex-Yacc3.html
#line 359 "y.tab.c"

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
case 7:
#line 86 "desc.y"
	{declaration(yystack.l_mark[0].var);}
break;
case 9:
#line 87 "desc.y"
	{declaration(yystack.l_mark[0].var);}
break;
case 11:
#line 88 "desc.y"
	{declaration(yystack.l_mark[-2].var);affectation(yystack.l_mark[-2].var);}
break;
case 13:
#line 89 "desc.y"
	{declaration(yystack.l_mark[-2].var);affectation(yystack.l_mark[-2].var);}
break;
case 20:
#line 100 "desc.y"
	{affectation(yystack.l_mark[-3].var);}
break;
case 22:
#line 101 "desc.y"
	{affectation(yystack.l_mark[-3].var);}
break;
case 25:
#line 111 "desc.y"
	{isUsable(yystack.l_mark[0].var);}
break;
case 36:
#line 128 "desc.y"
	{printf("type reconnue \n") ;}
break;
case 37:
#line 129 "desc.y"
	{printf("type reconnue \n") ;}
break;
#line 597 "y.tab.c"
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
