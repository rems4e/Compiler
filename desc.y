%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "constants.h"
	#include "symbol.h"

	#define SYMBOL_SIZE 30

	typedef struct yy_buffer_state *YY_BUFFER_STATE;

	bool isDeclar(char* nom);
	void yyerror(const char *s) ;
	int yylex() ;
	YY_BUFFER_STATE yy_scan_string (const char *yy_str  );

	//TODO
	void affectation(char const *nom) {
		symbol *sym = getExistingSymbol(nom);
		if(sym == NULL) {
			yyerror("Erreur : variable non déclarée");
		}

		printf("Affectation de la variable %s.\n", nom);
		// TODO:
	}

	void declaration(char const *nom) {
		symbol *sym = createSymbol(nom);
		if(sym == NULL) {
			yyerror("Erreur : variable déjà déclarée");
		}

		printf("Déclaration de la variable %s.\n", nom);
		// TODO:
	}

	void print(int val){
		printf("%d",val) ;
	}

	%}

%union {int nb; char* var;}

%token <nb> tNOMBRE
%token <var> tID
%token tFCT

%token tPO tPF tVIR tBO tBF
%token tINT tCONST
%token tPLUS tMOINS tDIV tMUL tEGAL
%token tF
%token tMAIN
%token END_OF_FILE

%left tPLUS tMOINS
%left tDIV tMUL

%start S

%%
S :
| S Corps ;

Corps :	tMAIN tBO Defs Instrucs tBF;

Defs :
| Def Defs ;

Def : Type tID tVIR {declaration($2);}
| Type tID {declaration($2);}tF
| Type tID  tEGAL Exp {declaration($2);affectation($2);} tVIR
| Type tID tEGAL Exp {declaration($2);affectation($2);} tF ;




Instrucs:
| Instrucs Instruc ;

Instruc :
| Exp tVIR
| Exp tF
| tID tEGAL Exp tVIR
| tID tEGAL Exp tF;




Exps :
| Exps Exp ;

Exp :  tNOMBRE
| tID
| Exp tPLUS Exp  //{$$=$1+$3 ;}
| Exp tMOINS Exp //{$$=$1-$3 ;}
| Exp tDIV Exp //{$$=$1/$3 ;}
| Exp tMUL Exp //{$$=$1*$3 ;}
| tPO Exp tPF 	//{$$=$2}
| tID tPO Args tPF ;//{$$=$2;}; //TODO




Args :
| Args Arg ;

Arg : Exp
| Exp tVIR; //{$$=$1};

Type : tINT | tCONST;

%%
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
