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

#define SYM_COUNT 1000
#define GLOBAL_COUNT 1000
#define MAX_NESTING 20

#define SIZEOF_PTR 1
#define SIZEOF_INT 1

typedef unsigned int address_t;

typedef struct symbol_t {
	bool initialized;
	char *name;
	address_t address;
	varType_t type;
} symbol_t;


void initSymbols(void);
void cleanSymbols(void);

int getStackSize(void);
int getGlobalSymbolsCount(void);

bool getGlobalScope(void);
void setGlobalScope(bool global);

int getSymbolSize(symbol_t const *symbol);

dereferencedID_t createString(char const *value);

dereferencedID_t getExistingSymbol(char const *name, bool failIfNotFound);
symbol_t *createSymbol(char const *name, varType_t type);

symbol_t *createTable(char const *name, varType_t type, int size);
dereferencedID_t getTabIndex(char const *name, int index);

symbol_t *allocTemp(int indirectionCount, baseType_t baseType);
bool isTemp(symbol_t *s);
void freeIfTemp(symbol_t *s);

void pushBlock();
void popBlock();

void pushSymbol(symbol_t *s);
symbol_t *popSymbol(void);
void clearSymbolStack(void);

bool topLevelConst(varType_t const *t);

void checkScalar(symbol_t const *s);
void checkIndirectionLevel(symbol_t const *s1, symbol_t const *s2);
bool sameType(varType_t const *t1, varType_t const *t2);
bool compatibleForAffectation(varType_t const *left, varType_t const *right, bool allowConst);
void checkCompatibilityForAffectation(symbol_t const *left, symbol_t const *right, bool allowConst);

bool isVoid(varType_t const *type);

void printSymbolTable(void);


#endif /* defined(__Syste_me_Info__symbol__) */
