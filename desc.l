%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "constants.h"
#include "y.tab.h"
#include "utility.h"

#define ECHO /*fprintf(yyout, "%s\n", yytext)*/

int lineNumber = 1;

char *cleanString(char const *string) {
	// On enlève les 2 guillemets
	size_t len = strlen(string) - 2;
	char *val = malloc(len + 1);
	strncpy(val, string + 1, len);
	val[len] = 0;

	char *pos = val;
	while((pos = strstr(pos, "\\n")) != NULL) {
		stringReplaceWithShorter(pos, 2, "\n", 0);
	}
	pos = val;
	while((pos = strstr(pos, "\\t")) != NULL) {
		stringReplaceWithShorter(pos, 2, "\t", 0);
	}
	pos = val;
	while((pos = strstr(pos, "\\\\")) != NULL) {
		stringReplaceWithShorter(pos, 2, "\\", 0);
	}

	return val;
}

%}

Delim		[ \t\n]+
Nom			[_a-zA-Z][_a-zA-Z0-9]*
chiffre		[0-9]
chiffreOct	[0-7]
chiffreHex	[0-9a-fA-F]
nombreExp	{chiffre}+(\.{chiffre}+)?((E|e)[+\-]?{chiffre}+)?
nombre		(({chiffre}+)|(0{chiffreOct}+)|((0x|0X){chiffreHex}+))

%x C_COMMENT
%x C_COMMENTL

%%

"/*"            	{ BEGIN(C_COMMENT); }
<C_COMMENT>"*/" 	{ BEGIN(INITIAL); }
<C_COMMENT>"\n"    	{ ++lineNumber; }
<C_COMMENT>.    	{ }

"//"            	{ BEGIN(C_COMMENTL); }
<C_COMMENTL>"\n" 	{ BEGIN(INITIAL); ++lineNumber; }
<C_COMMENTL>.    	{ }

\"(\\.|[^\\"])*\"   { ECHO; yylval.string = cleanString(yytext); return tSTRING_LITTERAL; }

\'(\\.|[^\\'])+\'	{
						ECHO;
						char const *val = cleanString(yytext);
						if(strlen(val) > 1) {
							yyerror("Une constante de caractère ne peut comporter qu'un seul caractère.");
						}
						yylval.string = val;
						return tCHAR_LITTERAL;
					}

"return"			{ ECHO; return tRETURN; }
"printf"			{ ECHO; return tPRINTF; }

"true"				{ ECHO; return tTRUE; }
"false"				{ ECHO; return tFALSE; }
"int const"			{ ECHO; return tCONST; }
"const int"			{ ECHO; return tCONST; }
"int"				{ ECHO; return tINT; }
"char const"		{ ECHO; return tCONSTC; }
"const char"		{ ECHO; return tCONSTC; }
"char"				{ ECHO; return tCHAR; }
"const"				{ ECHO; return tCONST; }
"void"				{ ECHO; return tVOID; }
"void const"		{ ECHO; return tVOID; }
"const void"		{ ECHO; return tVOID; }

"break"				{ ECHO; return tBREAK; }
"continue"			{ ECHO; return tCONTINUE; }

"if"				{ ECHO; return tIF; }
"else"				{ ECHO; return tELSE; }
"&&"				{ ECHO; return tET; }
"||"				{ ECHO; return tOU; }
"while"				{ ECHO; return tWHILE; }
"for"				{ ECHO; return tFOR; }
"do"				{ ECHO; return tDO; }

"NULL"				{ ECHO; return tNULL; }
"&"                 { ECHO; return tAMP; }

"("					{ ECHO; return tPO; }
")"					{ ECHO; return tPF; }
"{"					{ ECHO; return tBO; }
"}"					{ ECHO; return tBF; }
","					{ ECHO; return tVIR; }
\n					{ ECHO; ++lineNumber; }
Delim				{ ECHO; }

"++"				{ ECHO; return tINCR; }
"--"				{ ECHO; return tDECR; }

"/="				{ ECHO; return tDIVEQ; }
"*="				{ ECHO; return tMULEQ; }
"%="				{ ECHO; return tMODEQ; }
"-="				{ ECHO; return tMOINSEQ; }
"+="				{ ECHO; return tPLUSEQ; }

"/"					{ ECHO; return tDIV; }
"*"					{ ECHO; return tSTAR; }
"%"					{ ECHO; return tMOD; }
"-"					{ ECHO; return tMOINS; }
"+"					{ ECHO; return tPLUS; }
"="					{ ECHO; return tEGAL ; }
";"					{ ECHO; return tF; }

"=="				{ ECHO; return tBOOLEGAL; }
"<="				{ ECHO; return tINFEGAL; }
">="				{ ECHO; return tSUPEGAL; }
">"					{ ECHO; return tSUP; }
"<"					{ ECHO; return tINF; }
"!="				{ ECHO; return tDIFF; }


"["				{ ECHO; return tCRO; }

"]"				{ ECHO; return tCRF; }

{Nom}			{ ECHO; yylval.string = strdup(yytext); return tID; }

{nombre}			{
						ECHO;
						char *last;
						yylval.nb = strtol(yytext, &last, 0);
						if(last - yytext < strlen(yytext)) {
							yyerror("constante numérique invalide %s.", yytext);
						}
						return tNOMBRE;
					}
{nombreExp}			{
						ECHO;
						char *last;
						yylval.nb = (int)strtod(yytext, &last);
						if(last - yytext < strlen(yytext)) {
							yyerror("constante numérique invalide %s.", yytext);
						}
						return tNOMBRE;
					}

%%

int yywrap(void) {
	return 1;
}
