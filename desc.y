%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <stdarg.h>
	#include "constants.h"
	#include "symbol.h"

	typedef struct yy_buffer_state *YY_BUFFER_STATE;


	void yyerror(const char *s, ...);
	int yylex();
	YY_BUFFER_STATE yy_scan_string (const char *yy_str);

	void affectation(char const *nom) {
		symbol_t *sym = getExistingSymbol(nom);
		if(sym == NULL) {
			yyerror("variable non déclarée");
		}
		else if(sym->constant) {
			yyerror("affectation d'une constante");
		}

		printf("Affectation de la variable %s.\n", nom);
		sym->affected = true;

		printSymbolTable();
	}

	void declaration(char const *nom) {
		symbol_t *sym = createSymbol(nom);
		if(sym == NULL) {
			yyerror("variable déjà déclarée");
		}

		printf("Déclaration de la variable %s.\n", nom);
		
		printSymbolTable();
	}

	void print(int val){
		printf("%d",val) ;
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

Type : tINT  {printf("type reconnue \n") ;}
        | tCONST {printf("type reconnue \n") ;} ;
        
        
TypedDef : tID {declaration($1);} tVIR TypedDef
| tID {declaration($1);} tF
| tID  tEGAL Exp {declaration($1);affectation($1);} tVIR TypedDef 
| tID tEGAL Exp {declaration($1);affectation($1);} tF;

Instrucs:
| Instrucs Instruc; 

Instruc : Exp tVIR Instruc
| Exp tF
| tID tEGAL Exp tVIR {affectation($1);} Instruc
| tID tEGAL Exp tF {affectation($1);}
| tIF Cond tBO Instrucs tBF 
| tIF Cond tBO Instrucs tBF tELSE tBO Instrucs tBF
| tWHILE Cond tBO Instrucs tBF 
| tDO tBO Instrucs tBF tWHILE Cond ;
| tPRINTF tPO Exp tPF tF ;


Terme :  tNOMBRE
| tID {isUsable($1);} ;

Cond : Bool
| Bool tET Cond 
| Bool tOU Cond ;

Bool : tPO Exp tPF
| tPO Exp tINF Exp tPF 
| tPO Exp tSUP Exp tPF
| tPO Exp tINFEGAL Exp tPF
| tPO Exp tSUPEGAL Exp tPF
| tPO Exp tBOOLEGAL Exp tPF
| tTRUE 
| tFALSE;


Exp : Terme
| Exp tPLUS Exp 
| Exp tMOINS Exp 
| Exp tMUL Exp
| Exp tDIV Exp 
| tPO Exp tPF ;



%%
void yyerror(const char *s, ...) {
	va_list args;
	va_start(args, s);

	static char const *prefix = "Erreur : ";
	static size_t prefix_len = 0;
	if(prefix_len == 0) {
		prefix_len = strlen(prefix);
	}

	char *format = malloc(strlen(s) + prefix_len + 1);
	strcpy(format, prefix);
	strcpy(format + prefix_len, prefix);

	vfprintf(stderr, format, args);

	va_end(args);
}

int main(int argc, char const **argv) {
	initSymbolTables();

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

	cleanSymbolTables();

	return 0;
}

//http://langevin.univ-tln.fr/CDE/LEXYACC/Lex-Yacc3.html
