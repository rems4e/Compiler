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

typedef struct {
	bool affected;
	char *name;
	int address;
	bool constant;
} symbol_t;

typedef struct {
	symbol_t symbols[SYM_COUNT];
} symbolTable_t;

void initSymbolTables(void);
void cleanSymbolTables(void);

symbolTable_t *pushSymbolTable();
void popSymbolTable();

symbol_t *getExistingSymbol(char const *name);
symbol_t *createSymbol(char const *name);
bool symbolDeclared(char const *name);
bool symbolAffected(char const *name);

void printSymbolTable();

#endif /* defined(__Syste_me_Info__symbol__) */
