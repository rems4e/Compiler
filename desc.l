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
	// On enlève les 2 délimiteurs
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

identifier	[_a-zA-Z][_a-zA-Z0-9]*
digit		[0-9]
octDigit	[0-7]
hexDigit	[0-9a-fA-F]
numberExp	{digit}+(\.{digit}+)?((E|e)[+\-]?{digit}+)?
number		(({digit}+)|(0{octDigit}+)|((0x|0X){hexDigit}+))

%x COMMENT_MODE
%x LCOMMENT_MODE

%%

"/*"            	{ BEGIN(COMMENT_MODE); }
<COMMENT_MODE>"*/" 	{ BEGIN(INITIAL); }
<COMMENT_MODE>"\n"  { ++lineNumber; }
<COMMENT_MODE>.    	{ }

"//"            	{ BEGIN(LCOMMENT_MODE); }
<LCOMMENT_MODE>"\n" { BEGIN(INITIAL); ++lineNumber; }
<LCOMMENT_MODE>.    { }

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

"enum"				{ ECHO; return tENUM; }
"goto"				{ ECHO; return tGOTO; }
"return"			{ ECHO; return tRETURN; }
"print"				{ ECHO; return tPRINT; }
"scan"				{ ECHO; return tSCAN; }

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

"switch"			{ ECHO; return tSWITCH; }
"case"				{ ECHO; return tCASE; }
"default"			{ ECHO; return tDEFAULT; }
"if"				{ ECHO; return tIF; }
"else"				{ ECHO; return tELSE; }
"&&"				{ ECHO; return tAND; }
"||"				{ ECHO; return tOR; }
"while"				{ ECHO; return tWHILE; }
"for"				{ ECHO; return tFOR; }
"do"				{ ECHO; return tDO; }

"NULL"				{ ECHO; return tNULL; }
"&"                 { ECHO; return tAMP; }
"|"                 { ECHO; return tBITOR; }
"~"                 { ECHO; return tBITNOT; }
"^"                 { ECHO; return tBITXOR; }
"<<"                { ECHO; return tSHIFTL; }
">>"                { ECHO; return tSHIFTR; }

"("					{ ECHO; return tO_P; }
")"					{ ECHO; return tC_P; }
"{"					{ ECHO; return tO_BR; }
"}"					{ ECHO; return tC_BR; }
","					{ ECHO; return tCOMMA; }
\n					{ ECHO; ++lineNumber; }
[ \t]+				{ ECHO; }

"++"				{ ECHO; return tINCR; }
"--"				{ ECHO; return tDECR; }

"/="				{ ECHO; return tDIVEQ; }
"*="				{ ECHO; return tMULEQ; }
"%="				{ ECHO; return tMODEQ; }
"-="				{ ECHO; return tMINUSEQ; }
"+="				{ ECHO; return tPLUSEQ; }
"&="                { ECHO; return tBITANDEQ; }
"|="                { ECHO; return tBITOREQ; }
"^="                { ECHO; return tBITXOREQ; }
"<<="               { ECHO; return tSHIFTLEQ; }
">>="               { ECHO; return tSHIFTREQ; }

"/"					{ ECHO; return tDIV; }
"*"					{ ECHO; return tSTAR; }
"%"					{ ECHO; return tMOD; }
"-"					{ ECHO; return tMINUS; }
"+"					{ ECHO; return tPLUS; }
"="					{ ECHO; return tEQUAL ; }
";"					{ ECHO; return tSEMI; }
"!"					{ ECHO; return tNOT; }

"=="				{ ECHO; return tBOOLEQUAL; }
"<="				{ ECHO; return tLESSEQUAL; }
">="				{ ECHO; return tGREATEQUAL; }
">"					{ ECHO; return tGREAT; }
"<"					{ ECHO; return tLESS; }
"!="				{ ECHO; return tDIFF; }


"["					{ ECHO; return tO_SQBR; }
"]"					{ ECHO; return tC_SQBR; }

"?"					{ ECHO; return tQUESTION; }
":"					{ ECHO; return tCOLON; }

"sizeof"			{ ECHO; return tSIZEOF; }

{identifier}		{ ECHO; yylval.string = strdup(yytext); return tID; }

{number}			{
						ECHO;
						char *last;
						yylval.nb = strtol(yytext, &last, 0);
						if(last - yytext < strlen(yytext)) {
							yyerror("constante numérique invalide %s.", yytext);
						}
						return tNUMBER;
					}
{numberExp}			{
						ECHO;
						char *last;
						yylval.nb = (int)strtod(yytext, &last);
						if(last - yytext < strlen(yytext)) {
							yyerror("constante numérique invalide %s.", yytext);
						}
						return tNUMBER;
					}

%%

int yywrap(void) {
	return 1;
}
