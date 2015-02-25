%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

%}

Delim	[ \t]+
Op	[\/\*\-\+\=]
Nom	[a-zA-Z][_a-zA-Z0-9]*
chiffre	[0-9]
nombre	{chiffre}+(\.{chiffre}+)?(E[+\-]?{chiffre}+)?
Comm	"/*"."*/"
Comml	"//".\n
string 	"\""({Op}|{nombre}|{Nom}|{Delim})*"\""


%%
"main"		{return tMAIN;}
"("		{return tPO;}
")"		{return tPF;}
"}"		{return tBO;}
"{"		{return tBF;}
","		{return tVIR;}
{Delim}	;
"/"		{return tDIV;}
"*"		{return tMUL;}
"-"		{return tMOINS;}
"+"		{return tPLUS;}
"="		{return tEGAL ;}
\n	;
";"		{return tF;}
		
"int"		{return tINT;}
		
"const"		{return tCONST;}

{Nom}		{return tID;}
	
{nombre}	{return tNOMBRE;}

{Comm}	;
{Comml} ;
