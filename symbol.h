//
//  symbol.h
//  Système Info
//
//  Created by Rémi on 26/02/2015.
//

#ifndef __Syste_me_Info__symbol__
#define __Syste_me_Info__symbol__

#include "constants.h"

#define SYM_COUNT 100

typedef unsigned int address_t;

typedef struct {
	bool affected;
	char *name;
	address_t address;
	bool constant;
	int refCount;
} symbol_t;

typedef struct {
	symbol_t symbols[SYM_COUNT];
	symbol_t *symbolsStack[SYM_COUNT];
	int stackSize;
} symbolTable_t;


void initSymbolTable(void);
void resetSymbolTable(void);
void cleanSymbolTable(void);

symbol_t *getExistingSymbol(char const *name);
symbol_t *createSymbol(char const *name);

symbol_t *allocTemp(void);
void freeIfTemp(symbol_t *s);

void pushSymbol(symbol_t *s);
symbol_t *popSymbol(void);
void clearSymbolStack();

bool symbolDeclared(char const *name);
bool symbolAffected(char const *name);

void printSymbolTable();


#endif /* defined(__Syste_me_Info__symbol__) */
