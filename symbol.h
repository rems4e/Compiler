//
//  symbol.h
//  Système Info
//
//  Created by Rémi on 26/02/2015.
//

#ifndef __Syste_me_Info__symbol__
#define __Syste_me_Info__symbol__

#include "constants.h"

typedef unsigned int address_t;

typedef enum {
	VarInt,
	VarConst
} VarType;

typedef struct {
	bool initialized;
	char *name;
	address_t address;
	VarType type;
} symbol_t;

void initSymbols(void);
void cleanSymbols(void);

int getStackSize(void);

symbol_t *getExistingSymbol(char const *name);
symbol_t *createSymbol(char const *name, VarType type);

symbol_t *allocTemp(void);
void freeIfTemp(symbol_t *s);

void pushSymbol(symbol_t *s);
symbol_t *popSymbol(void);
void clearSymbolStack(void);

bool symbolDeclared(char const *name);
bool symbolInitialized(char const *name);

void printSymbolTable(void);


#endif /* defined(__Syste_me_Info__symbol__) */
