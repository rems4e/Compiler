//
//  symbol.h
//  Système Info
//
//  Created by Rémi on 26/02/2015.
//

#ifndef __Syste_me_Info__symbol__
#define __Syste_me_Info__symbol__

#include "constants.h"
#include <stdint.h>

typedef unsigned int address_t;

typedef struct {
	uint32_t constMask;
	bool topLevelConst;
	int indirectionCount;
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

symbol_t *allocTemp(int indirectionCount);
void freeIfTemp(symbol_t *s);

void pushSymbol(symbol_t *s);
symbol_t *popSymbol(void);
void clearSymbolStack(void);

void checkScalar(symbol_t const *s);
void checkIndirectionLevel(symbol_t const *s1, symbol_t const *s2);
bool sameType(VarType const *t1, VarType const *t2);
bool compatibleForAffectation(VarType const *left, VarType const *right, bool allowConst);
void checkCompatibilityForAffectation(symbol_t const *left, symbol_t const *right, bool allowConst);

void printSymbolTable(void);


#endif /* defined(__Syste_me_Info__symbol__) */
