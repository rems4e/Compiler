%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//#include <hashcode.h>

#define True 1
#define False 0
#define length 30

char buffer[400] ;
typedef int bool ;
typedef struct entry {
	bool affected ;//TODO
	char* nom ;
	int add ;
} entry ;

bool isDeclar(char* nom);
int yyerror(const char *s) ;
int yylex() ;

/*table des symbole*/
entry tab_symb[length] ; // à remplacer par un hashcode //TODO
int ind = 0 ;

//TODO
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

%left tPLUS tMOINS
%left tDIV tMUL

%start S

%%
S :     
        |LeMain  
        |Corps S ;

LeMain : 	Type tMAIN  tPO tPF  tBO Corps tBF {printf("Main \n");};

Corps :	Defs Instrucs
        |Type tID tPO tPF tBO Defs Instrucs tBF ;

Defs : 
	|Def Defs ;

Def : Type tID tVIR {printf("%s",$2) ; declaration($2);}
	|Type tID {printf("%s",$2) ; declaration($2);} tF
	|Type tID  tEGAL Exp {printf("%s",$2) ; declaration($2);affectation($2);} tVIR
	|Type tID tEGAL Exp {printf("%s",$2) ; declaration($2);affectation($2);} tF ;

Instrucs :
	|Instruc Instrucs ;

Instruc :
	|tID tEGAL Exp tVIR
	|tID tEGAL Exp tF;

Exps :
	|Exp Exps ;	

Exp :  tNOMBRE {printf("nombre \n") ; }
	| tID  {printf("identifiant \n") ;}
	| Exp tPLUS Exp {printf("Expression \n") ;}  //{$$=$1+$3 ;} 
	| Exp tMOINS Exp {printf("Expression \n") ;} //{$$=$1-$3 ;}
	| Exp tDIV Exp {printf("Expression \n") ;} //{$$=$1/$3 ;}
	| Exp tMUL Exp {printf("Expression \n") ;} //{$$=$1*$3 ;}
	| tPO Exp tPF {printf("Expression \n") ;} //{$$=$2}
	| tID tPO Args tPF {printf("Expression \n") ;} ; //{$$=$2;}; //TODO

	
Args : 
	|Arg Args ;
	
Arg :	Exp
	|Exp tVIR Arg; //{$$=$1};

Type : tINT  {printf("type reconnue \n") ;}
        | tCONST {printf("type reconnue \n") ;} ;

%%
int yyerror(const char *s) {
  printf("%s \n",s);
}

int main(void) {
  yyparse();
}

//http://langevin.univ-tln.fr/CDE/LEXYACC/Lex-Yacc3.html
