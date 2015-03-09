%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <stdarg.h>
	#include <assert.h>
	#include "constants.h"
	#include "symbol.h"
	#include "assembly.h"

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

		assemblyOutput("MOV %d %d ; %s", sym->address, val->address, nom);
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
	%}

%union {int nb; char* var;}

%token <nb> tNOMBRE
%token <var> tID
%token <var> tFCT

%token tPO tPF tVIR tBO tBF
%token tINT tCONST tTRUE tFALSE
%token tPLUS tMOINS tDIV tMUL tEGAL
%token tBOOLEGAL tINFEGAL tSUPEGAL tSUP tINF tET tOU

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

Type : tINT  { printf("type reconnu\n"); }
| tCONST { printf("type reconnu\n"); } ;
        
        
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
| tIF Cond tBO Instrucs tBF 
| tIF Cond tBO Instrucs tBF tELSE tBO Instrucs tBF
| tWHILE Cond tBO Instrucs tBF 
| tDO tBO Instrucs tBF tWHILE Cond ;
| tFOR tPO Exp tF Exp tF Exp tPF tBO Instrucs tBF
| tPRINTF tPO Exp tPF tF ;


Terme :  tNOMBRE {
	symbol_t *s = allocTemp();
	assemblyOutput("MOV %d %d", s->address, $1);
	pushSymbol(s);
}
| tID {
	assert(isUsable($1));
	pushSymbol(getExistingSymbol($1));
}
| Bool ;

Cond : tPO Exp tPF;

Bool:
| tTRUE {
	symbol_t *s = allocTemp();
	assemblyOutput("MOV %d %d", s->address, 1);
	pushSymbol(s);
}
| tFALSE {
	symbol_t *s = allocTemp();
	assemblyOutput("MOV %d %d", s->address, 0);
	pushSymbol(s);
};


Exp : Terme
| Exp tPLUS Exp { binOp("ADD"); }
| Exp tMOINS Exp { binOp("SUB"); }
| Exp tMUL Exp { binOp("MUL"); }
| Exp tDIV Exp { binOp("DIV"); }

| Exp tET Exp { binOp("AND"); }
| Exp tOU Exp { binOp("OR"); }
| Exp tINF Exp { binOp("INF"); }
| Exp tSUP Exp { binOp("SUP"); }
| Exp tINFEGAL Exp { binOp("INE"); }
| Exp tSUPEGAL Exp { binOp("SUE"); }
| Exp tBOOLEGAL Exp { binOp("EQ"); }

| tPO Exp tPF ;



%%
void yyerror(const char *s, ...) {
	va_list args;
	va_start(args, s);

	fprintf(stderr, "Erreur :");
	vfprintf(stderr, s, args);

	va_end(args);
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
		FILE * f = fopen(argv[1], "rb");
		char *name = strdup(argv[1]);
		name[len - 1] = 's';

		outputName = name;

		if(f) {
			fseek(f, 0, SEEK_END);
			len = ftell (f);
			fseek(f, 0, SEEK_SET);
			buf = malloc (len);
			if(buf) {
				fread (buf, 1, len, f);
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

	yyparse();
	free(buf);

	closeAssemblyOutput();
	cleanSymbolTable();

	return 0;
}

//http://langevin.univ-tln.fr/CDE/LEXYACC/Lex-Yacc3.html
