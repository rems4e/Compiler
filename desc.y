%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <stdarg.h>
	#include <assert.h>
	#include <limits.h>
	#include "constants.h"
	#include "symbol.h"
	#include "assembly.h"

	#define YYERROR_VERBOSE

	typedef struct yy_buffer_state *YY_BUFFER_STATE;


	void yyerror(char const *s, ...);

	int yylex();
	YY_BUFFER_STATE yy_scan_string (const char *yy_str);

	void affectation(char const *nom) {
		symbol_t *sym = getExistingSymbol(nom);
		if(sym == NULL) {
			yyerror("variable %s non déclarée\n", nom);
		}
		else if(sym->constant) {
			yyerror("affectation d'une constante\n");
		}

		printf("Affectation de la variable %s.\n", nom);
		sym->affected = true;
		symbol_t *val = popSymbol();

		assemblyOutput(COP" %d %d ; %s", sym->address, val->address, nom);
		freeIfTemp(val);

		//printSymbolTable();
	}

	void declaration(char const *nom) {
		symbol_t *sym = createSymbol(nom);
		if(sym == NULL) {
			yyerror("variable déjà déclarée\n");
		}

		printf("Déclaration de la variable %s.\n", nom);
		
		//printSymbolTable();
	}

	void print(int val){
		printf("%d", val) ;
	}
 
	bool isUsable(char* nom) {
		bool d = symbolDeclared(nom), a = symbolAffected(nom);
		if(!d) {
			yyerror("affectation avec %s , variable non déclarée \n", nom);
		}
		else if(!a) {
			printf("affectation avec %s, variable non affectée \n", nom);
		}
		return d && a;
	}

	void binOp(char const *op) {
		symbol_t *s2 = popSymbol();
		symbol_t *s1 = popSymbol();
		symbol_t *res = allocTemp();
		pushSymbol(res);

		assemblyOutput("%s %d %d %d", op, res->address, s1->address, s2->address);
		freeIfTemp(s2);
		freeIfTemp(s1);
	}

	void negate() {
		symbol_t *zero = allocTemp();
		assemblyOutput(AFC" %d %d", zero->address, 0);

		pushSymbol(zero);
		binOp(EQU);
	}

	void toBoolean() {
		negate();
		negate();
	}

	void callFunction(char const *functionName) {

	}

	%}

%union {int nb; char* var;}

%token <nb> tNOMBRE
%token <var> tID
%token <var> tFCT

%token tPO tPF tVIR tBO tBF
%token tINT tCONST tTRUE tFALSE
%token tPLUS tMOINS tDIV tMUL tEGAL
%token tBOOLEGAL tINFEGAL tSUPEGAL tSUP tINF tET tOU tDIFF

%token tF
%token tMAIN tRETURN tPRINTF
%token tIF tELSE tWHILE tFOR tDO
%token END_OF_FILE

%left tPLUS tMOINS
%left tDIV tMUL

%left tBOOLEGAL tINFEGAL tSUPEGAL tSUP tINF
%left tOU
%left tET

%start S

%%
S :
| S Corps;

Corps :	tINT tMAIN Suite;

//Deb : tINT tMAIN ;

Suite : tBO Defs Instrucs tRETURN Exp tF tBF ;

Defs :
| Defs Def;

Def : Type TypedDef;

Type : tINT;
| tCONST;
        
        
TypedDef : tID { declaration($1); } tVIR TypedDef
| tID { declaration($1); } tF
| tID  tEGAL Exp { declaration($1); affectation($1); } tVIR TypedDef
| tID tEGAL Exp { declaration($1); affectation($1); } tF;

Instrucs:
| Instrucs Instruc { clearSymbolStack(); };

Instruc : Exp tVIR Instruc
| Exp tF
| tID tEGAL Exp tVIR { affectation($1); } Instruc
| tID tEGAL Exp tF {affectation($1);}
| tIF Cond tBO Instrucs tBF { popLabel(); }
| tIF Cond tBO Instrucs tBF { pushLabelLastButOne(); assemblyOutput(JMP_UNKNOWN" 0000"); } tELSE tBO { popLabel(); } Instrucs tBF { popLabel(); }
| tWHILE { pushInstructionCount(); } Cond tBO Instrucs FinWhile
| tDO tBO Instrucs tBF tWHILE Cond
| tFOR tPO Exp tF Exp tF Exp tPF tBO Instrucs tBF
| tPRINTF tPO Exp tPF tF {
	symbol_t *s = popSymbol();
	assemblyOutput(PRI" %d", s->address);
	freeIfTemp(s);
};

FinWhile : tBF {
	assemblyOutput(JMP" %d", popInstructionCount());
	popLabel();
};

Terme :  tNOMBRE {
	symbol_t *s = allocTemp();
	assemblyOutput(AFC" %d %d", s->address, $1);
	pushSymbol(s);
}
| tID {
	symbol_t *s = getExistingSymbol($1);

	if(s == NULL) {
		yyerror("Variable %s non déclarée!", $1);
	}
	pushSymbol(s);
}
| Bool ;

Cond : tPO Exp tPF {
	symbol_t *cond = popSymbol();
	pushLabel();
	assemblyOutput(JMF_UNKNOWN" %d 0000", cond->address);
	freeIfTemp(cond);
} ;

Bool:
| tTRUE {
	symbol_t *s = allocTemp();
	assemblyOutput(AFC" %d %d", s->address, 1);
	pushSymbol(s);
}
| tFALSE {
	symbol_t *s = allocTemp();
	assemblyOutput(AFC" %d %d", s->address, 0);
	pushSymbol(s);
};


Exp : Terme
| Exp tPLUS Exp { binOp(ADD); }
| Exp tMOINS Exp { binOp(SOU); }
| Exp tMUL Exp { binOp(MUL); }
| Exp tDIV Exp { binOp(DIV); }

| Exp tET Exp {
	toBoolean();
	symbol_t *op2 = popSymbol();
	toBoolean();
	symbol_t *op1 = popSymbol();

	pushSymbol(op1);
	pushSymbol(op2);
	binOp(ADD);

	symbol_t *deux = allocTemp();
	assemblyOutput(AFC" %d %d", deux->address, 2);
	pushSymbol(deux);
	binOp(EQU);
}
| Exp tOU Exp {
	toBoolean();
	symbol_t *op2 = popSymbol();
	toBoolean();
	symbol_t *op1 = popSymbol();

	pushSymbol(op1);
	pushSymbol(op2);
	binOp(ADD);

	symbol_t *zero = allocTemp();
	assemblyOutput(AFC" %d %d", zero->address, 0);
	pushSymbol(zero);
	binOp(SUP);
}
| Exp tINF Exp { binOp(INF); }
| Exp tSUP Exp { binOp(SUP); }
| Exp tINFEGAL Exp {
	binOp(SOU);
	symbol_t *val = allocTemp();
	assemblyOutput(AFC" %d %d", val->address, 1);
	pushSymbol(val);
	binOp(INF);
}
| Exp tSUPEGAL Exp {
	binOp(SOU);
	symbol_t *val = allocTemp();
	assemblyOutput(AFC" %d %d", val->address, -1);
	pushSymbol(val);
	binOp(SUP);
}
| Exp tBOOLEGAL Exp { binOp(EQU); }

| tPO Exp tPF 
| Exp tDIFF Exp;



%%
void yyerror(const char *s, ...) {
	va_list args;
	va_start(args, s);

	fprintf(stderr, "Erreur : ");
	vfprintf(stderr, s, args);
	fputc('\n', stderr);

	va_end(args);

	exit(1);
}

int main(int argc, char const **argv) {
	char *outputName = strdup("a.s");

	initSymbolTable();

	char *buf;
	if(argc > 1) {
		long len = strlen(argv[1]);

		if(len < 2 || argv[1][len - 1] != 'c' || argv[1][len - 2] != '.') {
			fprintf(stderr, "Le fichier doit avoir l'extension \".c\" !\n");
			return 1;
		}
		FILE *f = fopen(argv[1], "rb");
		char *name = strdup(argv[1]);
		name[len - 1] = 's';

		outputName = name;

		if(f) {
			fseek(f, 0, SEEK_END);
			len = ftell(f);
			fseek(f, 0, SEEK_SET);
			buf = malloc(len);
			if(buf) {
				fread(buf, 1, len, f);
			}
			fclose(f);
		}

		if(buf) {
			yy_scan_string(buf);
		}
		else {
			return 1;
		}
	}

	initAssemblyOutput(outputName);
	free(outputName);

	assemblyOutput(AFC" %d %d", getStackPointerAddress(), 0);
	/*callFunction(" main");
	pushLabel();
	assemblyOutput(JMP" 0000");*/

	yyparse();
	free(buf);

	//popLabel();
	closeAssemblyOutput();
	cleanSymbolTable();

	return 0;
}

//http://langevin.univ-tln.fr/CDE/LEXYACC/Lex-Yacc3.html
