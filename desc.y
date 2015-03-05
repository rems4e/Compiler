%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <stdarg.h>
	#include "constants.h"
	#include "symbol.h"

	typedef struct yy_buffer_state *YY_BUFFER_STATE;


	void yyerror(const char *s, ...) ;
	int yylex() ;
	YY_BUFFER_STATE yy_scan_string (const char *yy_str  );

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
%token tINT tCONST tBOOL
%token tPLUS tMOINS tDIV tMUL tEGAL
%token tBOOLEGAL tINFEGAL tSUPEGAL tSUP tINF

%token tF
%token tMAIN
%token tIF tTHEN tELSE
%token END_OF_FILE

%left tPLUS tMOINS
%left tDIV tMUL

%start S

%%
S :
| S Corps;

Corps :	tMAIN tBO Defs Instrucs tBF;

Defs :
| Def Defs;

Def : Type TypedDef;

TypedDef : tID {declaration($1);} tVIR TypedDef
| tID {declaration($1);} tF
| tID  tEGAL Exp {declaration($1);affectation($1);} tVIR TypedDef 
| tID tEGAL Exp {declaration($1);affectation($1);} tF;




Instrucs:
| Instrucs Instruc; 

Instruc :
| Exp tVIR 
| Exp tF
| tID tEGAL Exp tVIR {affectation($1);} Instruc
| tID tEGAL Exp tF {affectation($1);}
| tIF Cond tBO Instruc tBF;

Cond : tPO Exp tPF ;

Exp :  tNOMBRE
| tID {isUsable($1);}
| Exp Exps  //{$$=$1+$3 ;}
| Cond 	//{$$=$2}
//| tID tPO Args tPF
| Exp ExpsBool ;//{$$=$2;}; //TODO

ExpsBool : OpBool Exp ;

Exps : Op Exp ;

/*Args : ;
| Args Arg;

Arg : Exp
| Exp tVIR; //{$$=$1};
*/
Type : tINT  {printf("type reconnue \n") ;}
        | tCONST {printf("type reconnue \n") ;} ;

/*Bool : tBOOL
	|Exp OpBool Exp ; */

OpBool : tBOOLEGAL | tINFEGAL | tSUPEGAL | tSUP | tINF ;
Op : tPLUS | tMOINS | tMUL | tDIV ;
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

	vprintf(format, args);

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
