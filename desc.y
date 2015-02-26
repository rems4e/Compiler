%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	//#include <hashcode.h>

	#define True 1
	#define False 0
	#define length 30

	typedef struct yy_buffer_state *YY_BUFFER_STATE;

	typedef int bool ;
	typedef struct entry {
		bool affected ;//TODO
		char* nom ;
		int add ;
	} entry ;

	bool isDeclar(char* nom);
	int yyerror(const char *s) ;
	int yylex() ;
	YY_BUFFER_STATE yy_scan_string (const char *yy_str  );

	/*table des symbole*/
	entry tab_symb[length] ; // à remplacer par un hashcode //TODO
	int ind = 0 ;

	//TODO
	void affectation(char* nom){
		bool found = isDeclar(nom) ;
		for(int i=0; i<length;i++){
			if(strcmp(nom,tab_symb[i].nom)==0)
			tab_symb[i].affected = 1 ;
			tab_symb[i].add = i ;
		}
		if(found ==0){printf("Erreur : variable non déclarée") ;}
	}

	void declaration(char* nom){
		entry new_entry = {False,nom} ;
		for(int i=0; i<length;i++){
			if(strcmp(nom,tab_symb[i].nom)==0)
			printf("redéclaration d'une variable");
			else{
				tab_symb[ind++]=new_entry ;
			}
		}
	}

	bool isDeclar(char* nom){
		for(int i=0; i<length;i++){
			if(strcmp(nom,tab_symb[i].nom)==0)
			return True ;
		}
		return False ;
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

Def : Type tID tVIR {declaration($2);}
| Type tID {declaration($2);}tF
| Type tID  tEGAL Exp {declaration($2);affectation($2);} tVIR
| Type tID tEGAL Exp {declaration($2);affectation($2);} tF ;

Instruc :
| Exp tVIR
| Exp tF
| tID tEGAL Exp tVIR
| tID tEGAL Exp tF;

Defs :
| Def Defs ;

Instrucs:
| Instrucs Instruc ;

Exp :  tNOMBRE
| tID
| Exp tPLUS Exp  //{$$=$1+$3 ;}
| Exp tMOINS Exp //{$$=$1-$3 ;}
| Exp tDIV Exp //{$$=$1/$3 ;}
| Exp tMUL Exp //{$$=$1*$3 ;}
| tPO Exp tPF 	//{$$=$2}
| tID tPO Args tPF ;//{$$=$2;}; //TODO

Exps :
| Exps Exp ;

Args :
| Args Arg ;

Arg :	Exp
| Exp tVIR; //{$$=$1};

Type : tINT | tCONST;

%%
int yyerror(const char *s) {
	printf("%s \n",s);
	return 0;
}

int main(int argc, char const **argv) {
	char *buf;
	if(argc > 1) {
		long len;
		FILE * f = fopen (argv[1], "rb");

		if (f)
		{
			fseek (f, 0, SEEK_END);
			len = ftell (f);
			fseek (f, 0, SEEK_SET);
			buf = malloc (length);
			if (buf)
			{
				fread (buf, 1, length, f);
			}
			fclose (f);
		}

		if (buf)
		{
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
