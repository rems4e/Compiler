%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

#define ECHO /*fprintf(yyout, "%s\n", yytext)*/

int lineNumber = 1;

%}

Delim	[ \t\n]+
Nom	[_a-zA-Z][_a-zA-Z0-9]*
chiffre	[0-9]
nombre	{chiffre}+(\.{chiffre}+)?(E[+\-]?{chiffre}+)?
string 	"\""({Op}|{nombre}|{Nom}|{Delim})*"\""

%x C_COMMENT
%x C_COMMENTL

%%



"/*"            { BEGIN(C_COMMENT); }
<C_COMMENT>"*/" { BEGIN(INITIAL); }
<C_COMMENT>"\n"    { ++lineNumber; }
<C_COMMENT>.    { }

"//"            { BEGIN(C_COMMENTL); }
<C_COMMENTL>"\n" { BEGIN(INITIAL); ++lineNumber; }
<C_COMMENTL>.    { }


"return"	{ECHO;return tRETURN;}
"printf"	{ECHO;return tPRINTF;}

"true"	{ECHO;return tTRUE;}
"false"	{ECHO;return tFALSE;}
"int const"	{ECHO;return tCONST;}
"const int"	{ECHO;return tCONST;}
"int"	{ECHO;return tINT;}
"const"	{ECHO;return tCONST;}

"if"	{ECHO;return tIF;}
"else"	{ECHO;return tELSE;}
"&&"	{ECHO;return tET;}
"||"	{ECHO;return tOU;}
"while"	{ECHO;return tWHILE;}
"for"	{ECHO;return tFOR;}
"do"	{ECHO;return tDO;}

"("	{ECHO;return tPO;}
")"	{ECHO;return tPF;}
"{"	{ECHO;return tBO;}
"}"	{ECHO;return tBF;}
","	{ECHO;return tVIR;}
\n	{ECHO; ++lineNumber;}
Delim	{ECHO;}
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
"!="	{ECHO;return tDIFF;}




{Nom}	{yylval.var= strdup(yytext) ;
	return tID;}

{nombre}	{yylval.nb=atoi(yytext);
		return tNOMBRE;}

%%

int yywrap(void) {
	return 1;
}
