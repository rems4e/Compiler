//
//  assembly.h
//  Système Info
//
//  Created on 05/03/2015.
//

#ifndef __Syste_me_Info__assembly__
#define __Syste_me_Info__assembly__

#include <stdlib.h>
#include "constants.h"
#include "symbol.h"

//#define STRIP_COMMENTS
//#define OPCODE_TEXT

#define UNKNOWN_GOTO_PREFIX "UG_"
#define UNKNOWN_IF_PREFIX "UI_"
#define UNKNOWN_LOOP_PREFIX "UL_"
#define UNKNOWN_ADDRESS "00000"

#ifdef OPCODE_TEXT

#define STK "STK" // Ajout de l'opérande 1 au stack pointer, ou du stack pointer à l'opérande 1 selon la valeur de l'opérande 2

#define ADD "ADD"
#define SOU "SOU"
#define MUL "MUL"
#define DIV "DIV"

#define EQU "EQU"
#define INF "INF"
#define SCN "SCN"

#define COP "COP"
#define AFC "AFC"

#define JMP "JMP"
#define JMF "JMF"
#define JMP_UNKNOWN_IF   "UI_JMP"
#define JMP_UNKNOWN_LOOP "UL_JMP"
#define JMP_UNKNOWN_GOTO "UG_JMP"

#define JMF_UNKNOWN_IF   "UI_JMF"
#define JMF_UNKNOWN_LOOP "UL_JMF"
#define JMF_UNKNOWN_GOTO "UG_JMF"

#define PRI "PRI"

#define RET "RET" // Retour à la fontion appelante
#define DR1 "DR1" // Copie du contenu de l'adresse passée en deuxième opérande dans l'adresse contenue dans l'adresse passée en opérande 1
#define DR2 "DR2" // Copie du contenu de l'adresse contenue dans l'adresse passée en deuxième opérande dans l'opérande 1

#else

#define STK "0"

#define ADD "1"
#define SOU "3"
#define MUL "2"
#define DIV "4"

#define EQU "B"
#define INF "9"
#define SCN "A"

#define COP "5"
#define AFC "6"

#define JMP "7"
#define JMF "8"
#define JMP_UNKNOWN_IF   "UI_7"
#define JMP_UNKNOWN_LOOP "UL_7"
#define JMP_UNKNOWN_GOTO "UG_7"

#define JMF_UNKNOWN_IF   "UI_8"
#define JMF_UNKNOWN_LOOP "UL_8"
#define JMF_UNKNOWN_GOTO "UG_8"

#define PRI "C"

#define RET "D" // Retour à la fonction appelante
#define DR1 "E" // Copie du contenu de l'adresse passée en deuxième opérande dans l'adresse contenue dans l'adresse passée en opérande 1
#define DR2 "F" // Copie du contenu de l'adresse contenue dans l'adresse passée en deuxième opérande dans l'opérande 1

#endif

void initAssemblyOutput(char const *path);
void closeAssemblyOutput(bool error, char const *path);

void assemblyOutput(char const *lineFormat, ...)  __attribute__ ((__format__ (__printf__, 1, 2))) ;//__printflike(1, 2);

int instructionsCount(void);

int lastInstructionCount(void);
void pushInstructionCount(void);
int popInstructionCount(void);

void pushIfLabel(void);
void popIfLabel(void);
void pushIfLabelLastButOne(void);
void pushLoopLabel(void);
void popLoopLabel(void);

void addGotoLabel(char const *name);
void pushGotoLabel(char const *name);
void resetGotoLabels(void);

void addFunctionReturnAddress(int returnAddress);

void affectation(dereferencedSymbol_t id, symbol_t *value, bool allowConst);

void checkBinOp(char const *op, symbol_t const *s1, symbol_t const *s2);
symbol_t *binOp(char const *op, symbol_t *s1, symbol_t *s2);
symbol_t *binOpEq(char const *op, dereferencedSymbol_t id, symbol_t *value);

symbol_t *negate(symbol_t *s);
symbol_t *toBoolean(symbol_t *s);

symbol_t *modulo(symbol_t *s1, symbol_t *s2);

symbol_t *powerOfTwo(symbol_t *power);
symbol_t *bitand(symbol_t *s1, symbol_t *s2);
symbol_t *bitor(symbol_t *s1, symbol_t *s2);
symbol_t *bitxor(symbol_t *s1, symbol_t *s2);
symbol_t *bitnot(symbol_t *s1);


#endif /* defined(__Syste_me_Info__assembly__) */
