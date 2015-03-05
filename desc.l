%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

#define ECHO fwrite(yytext, yyleng, 1, yyout)

%}

Delim	[ \t]+
Nom	[a-zA-Z][_a-zA-Z0-9]*
chiffre	[0-9]
nombre	{chiffre}+(\.{chiffre}+)?(E[+\-]?{chiffre}+)?
Comm	"/*".*"*/"
Comml	"//".*\n
string 	"\""({Op}|{nombre}|{Nom}|{Delim})*"\""

%%

"main"	{ECHO;return tMAIN;}


"true"	{ECHO;return tTRUE;}
"false"	{ECHO;return tFALSE;}
"int"	{ECHO;return tINT;}
"const"	{ECHO;return tCONST;}

"if"	{ECHO;return tIF;}
"else"	{ECHO;return tELSE;}
"&&"	{ECHO;return tET;}
"||"	{ECHO;return tOU;}

"("	{ECHO;return tPO;}
")"	{ECHO;return tPF;}
"{"	{ECHO;return tBO;}
"}"	{ECHO;return tBF;}
","	{ECHO;return tVIR;}
Delim	{ECHO;}
\n	{ECHO;}
"/"	{ECHO;return tDIV;}
"*"	{ECHO;return tMUL;}
"-"	{ECHO;return tMOINS;}
"+"	{ECHO;return tPLUS;}
"="	{ECHO;return tEGAL ;}
";"	{ECHO;return tF;}

"=="	{ECHO;return tBOOLEGAL;}
"<="	{ECHO;return tINFEGAL;}
">="	{ECHO;return tSUPEGAL;}
">"	{ECHO;return tSUP;}
"<"	{ECHO;return tINF;}




{Nom}	{yylval.var= strdup(yytext) ;
	return tID;}

{nombre}	{yylval.nb=atoi(yytext);
		return tNOMBRE;}

{Comm}	;
{Comml} ;

%%

int yywrap(void) {
	return 1;
}
