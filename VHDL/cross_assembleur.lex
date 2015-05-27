%{
  #include <stdio.h>

  #include "y.tab.h"

  #define YYSTYPE int
  extern YYSTYPE yylval;

  #ifdef DEBUG
    #define DEBUG_LEX(list...) \
      do {                     \
        printf(list);          \
      } while (0);
  #else
    #define DEBUG_LEX(list...) \
      do {                     \
      } while (0);
  #endif

  int nombre_lignes = 1;
%}

NLG "\n"
ESP [\t ]
ADD ^" "*0*1
MUL ^" "*0*2
SOU ^" "*0*3
DIV ^" "*0*4
COP ^" "*0*5
AFC ^" "*0*6
JMP ^" "*0*7
JMF ^" "*0*8
INF ^" "*0*9
SUP ^" "*0*A
EQU ^" "*0*B
PRI ^" "*0*C
ENT -?[0-9]+
ERR .
COMMENT "--".*$

%%

{ESP} { }
{NLG} { nombre_lignes++; }

{ADD} { DEBUG_LEX("Fonction ADD\n"); return ADD; }
{MUL} { DEBUG_LEX("Fonction MUL\n"); return MUL; }
{SOU} { DEBUG_LEX("Fonction SOU\n"); return SOU; }
{DIV} { DEBUG_LEX("Fonction DIV\n"); return DIV; }
{COP} { DEBUG_LEX("Fonction COP\n"); return COP; }
{AFC} { DEBUG_LEX("Fonction AFC\n"); return AFC; }
{JMP} { DEBUG_LEX("Fonction JMP\n"); return JMP; }
{JMF} { DEBUG_LEX("Fonction JMF\n"); return JMF; }
{INF} { DEBUG_LEX("Fonction INF\n"); return INF; }
{SUP} { DEBUG_LEX("Fonction SUP\n"); return SUP; }
{EQU} { DEBUG_LEX("Fonction EQU\n"); return EQU; }
{PRI} { DEBUG_LEX("Fonction PRI\n"); return PRI; }

{COMMENT} { DEBUG_LEX("Comment %s\n", yytext); }

{ENT} { DEBUG_LEX("Entier: %d\n", atoi(yytext));
        yylval = atoi(yytext);
        return ENT;
      }

{ERR} { fprintf(stderr, "Erreur a la ligne %d.\n", nombre_lignes);
        exit(1);
      }

%%

//int main(int argc, char **argv) {
//  yylex();
//  return 0;
//}
