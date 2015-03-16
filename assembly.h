//
//  assembly.h
//  Système Info
//
//  Created by Rémi on 05/03/2015.
//

#ifndef __Syste_me_Info__assembly__
#define __Syste_me_Info__assembly__

#include <stdlib.h>

//#define STRIP_COMMENTS

//#define OPCODE_TEXT

#define UNKNOWN_PREFIX "U_"
#define UNKNOWN_ADDRESS "00000"

#ifdef OPCODE_TEXT

#define ADD "ADD"
#define SOU "SOU"
#define MUL "MUL"
#define DIV "DIV"

#define EQU "EQU"
#define INF "INF"
#define SUP "SUP"

#define COP "COP"
#define AFC "AFC"

#define JMP "JMP"
#define JMF "JMF"
#define JMP_UNKNOWN "U_JMP"
#define JMF_UNKNOWN "U_JMF"

#define PRI "PRI"

#else

#define ADD "1"
#define SOU "3"
#define MUL "2"
#define DIV "4"

#define EQU "B"
#define INF "9"
#define SUP "A"

#define COP "5"
#define AFC "6"

#define JMP "7"
#define JMF "8"
#define JMP_UNKNOWN "U_7"
#define JMF_UNKNOWN "U_8"

#define PRI "C"

#endif

void initAssemblyOutput(char const *path);
void closeAssemblyOutput(void);

void assemblyOutput(char const *lineFormat, ...);

size_t instructionsCount(void);

void pushInstructionCount(void);
int popInstructionCount(void);

void pushLabel(void);
void pushLabelLastButOne(void);
void popLabel(void);
void popLabelWithAddress(int address);

void addFunctionReturnAddress(int returnAddress);

#endif /* defined(__Syste_me_Info__assembly__) */
