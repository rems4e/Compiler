//
//  symbol.c
//  Système Info
//
//  Created by Rémi on 26/02/2015.
//

#include "symbol.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "assembly.h"

#define SYM_COUNT 1000
#define ADDRESS_SHIFT 5

typedef struct {
	symbol_t symbols[SYM_COUNT];
	symbol_t *symbolsStack[SYM_COUNT];
	int stackSize;
} symbolTable_t;


static symbolTable_t symbolTable;
static char *tempSymbol;
void resetSymbolTable();
void initFunctionTable();
void freeFunctionTable();

void initSymbols() {
	tempSymbol = strdup("__temp__");

	resetSymbolTable();
	initFunctionTable();
}

void resetSymbolTable() {
	symbolTable.stackSize = 0;

	for(int i = 0; i < SYM_COUNT; ++i) {
		symbolTable.symbols[i].initialized = false;
		if(symbolTable.symbols[i].name != tempSymbol) {
			free(symbolTable.symbols[i].name);
		}
		symbolTable.symbols[i].name = NULL;
		symbolTable.symbols[i].address = i + ADDRESS_SHIFT;
		symbolTable.symbols[i].type.constMask = 0;
		symbolTable.symbols[i].type.indirectionCount = 0;

		symbolTable.symbolsStack[i] = NULL;
	}
}

void cleanSymbols() {
	resetSymbolTable();
	free(tempSymbol);
	freeFunctionTable();
}

int getStackSize() {
	for(int i = SYM_COUNT - 1; i >= 0; --i) {
		if(symbolTable.symbols[i].name != NULL) {
			return i + 1;
		}
	}

	return 0;
}

symbol_t *getExistingSymbol(char const *name) {
	symbol_t *symbols = symbolTable.symbols;

	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name != NULL && strcmp(symbols[i].name, name) == 0) {
			return &symbols[i];
		}
	}

	yyerror("variable %s non déclarée\n", name);

	return NULL;
}

symbol_t *createSymbol(char const *name, varType_t type) {
	symbol_t *symbols = symbolTable.symbols;

	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name != NULL && strcmp(symbols[i].name, name) == 0) {
			yyerror("La variable %s existe déjà !\n", name);
			return NULL;
		}
		else if(symbols[i].name == NULL) {
			symbols[i].name = strdup(name);
			symbols[i].type = type;
			return &symbols[i];
		}
	}

	fprintf(stderr, "Symbol table too small, couldn't get room for new symbol %s.\n", name);
	return NULL;
}

symbol_t *createTable(char const *name, int size) {
	symbol_t *symbols = symbolTable.symbols;
	
	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name != NULL && strcmp(symbols[i].name, name) == 0) {
			yyerror("La variable %s existe déjà !\n", name);
			return NULL;
		}
		else if(symbols[i].name == NULL) {
			symbols[i].name = strdup(name);
			symbols[i].type.constMask=2;
			symbols[i].type.indirectionCount = 1 ;
			for(int j = 1 ; j < size ; j++){
				asprintf(&symbols[j].name,"%s_tabIndice_%d",name,j) ;
				symbols[j].type.constMask=2;
				symbols[j].type.indirectionCount = 1 ;
			}
			
			return &symbols[i];
		}
	}

	fprintf(stderr, "Symbol table too small, couldn't get room for new symbol %s.\n", name);
	return NULL;
	
}

symbol_t *allocTemp(int indirectionCount) {
	symbol_t *symbols = symbolTable.symbols;

	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name == NULL) {
			symbols[i].name = tempSymbol;
			symbols[i].type.indirectionCount = indirectionCount;
			return &symbols[i];
		}
	}

	fprintf(stderr, "Symbol table too small, couldn't get room for new temporary symbol.\n");
	return NULL;

}

void freeIfTemp(symbol_t *s) {
	if(s->name == tempSymbol) {
		s->name = NULL;
	}
}


void pushSymbol(symbol_t *s) {
	assert(symbolTable.stackSize < SYM_COUNT - 1);
	symbolTable.symbolsStack[symbolTable.stackSize] = s;
	++symbolTable.stackSize;
}

symbol_t *popSymbol() {
	assert(symbolTable.stackSize > 0);
	--symbolTable.stackSize;
	symbol_t *ret = symbolTable.symbolsStack[symbolTable.stackSize];
	symbolTable.symbolsStack[symbolTable.stackSize] = NULL;

	return ret;
}

void clearSymbolStack() {
	while(symbolTable.symbolsStack[0] != NULL) {
		popSymbol();
	}
}

void printSymbolTable() {
	symbol_t *symbols = symbolTable.symbols;

	int *a;
	int * const b;

	a = b;

	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name != NULL) {
			printf("%#x: \"%s\" affected: %s\n", symbols[i].address, symbols[i].name, (symbols[i].initialized ? "true" : "false"));
		}
	}
}

bool topLevelConst(varType_t const *t) {
	return t->constMask & (1 << t->indirectionCount);
}

void checkScalar(symbol_t const *s) {
	if(s->type.indirectionCount > 0) {
		yyerror("L'expresion n'est pas un scalaire.");
	}
}

void checkIndirectionLevel(symbol_t const *s1, symbol_t const *s2) {
	if(s1->type.indirectionCount != s2->type.indirectionCount) {
		yyerror("Les expressions n'ont pas le même niveau d'indirection.");
	}
}

bool sameType(varType_t const *t1, varType_t const *t2) {
	return t1->indirectionCount == t2->indirectionCount && t1->constMask == t2->constMask;
}

bool compatibleForAffectation(varType_t const *left, varType_t const *right, bool allowConst) {
	if(left->indirectionCount != right->indirectionCount) {
		return false;
	}
	else if(!allowConst && topLevelConst(left)) {
		return false;
	}

	for(int i = 0; i < left->indirectionCount; ++i) {
		bool lC = left->constMask & (1 << i);
		bool rC = right->constMask & (1 << i);
		if(rC && !lC) {
			return false;
		}
	}
	
	return true;
}
void checkCompatibilityForAffectation(symbol_t const *left, symbol_t const *right, bool allowConst) {
	if((left->type.indirectionCount != right->type.indirectionCount) && !(right->type.indirectionCount == -1 && left->type.indirectionCount > 0)) {
		yyerror("Le type de l'expression est incompatible avec le type de la variable %s (%d indirections à gauche, %d à droite).", left->name, left->type.indirectionCount, right->type.indirectionCount);
	}
	else if(!allowConst && topLevelConst(&left->type)) {
		yyerror("La variable %s est constante.", left->name);
	}

	for(int i = 0; i < left->type.indirectionCount; ++i) {
		bool lC = left->type.constMask & (1 << i);
		bool rC = right->type.constMask & (1 << i);
		if(rC && !lC) {
			yyerror("Perte de la qualification const pour l'affectation de la variable %s.", left->name);
		}
	}
}
