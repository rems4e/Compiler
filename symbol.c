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
		symbolTable.symbols[i].address = i + 4;
		symbolTable.symbols[i].type = VarInt;

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

	return NULL;
}

symbol_t *createSymbol(char const *name) {
	symbol_t *symbols = symbolTable.symbols;

	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name != NULL && strcmp(symbols[i].name, name) == 0) {
			yyerror("La variable %s existe déjà !\n", name);
			return NULL;
		}
		else if(symbols[i].name == NULL) {
			symbols[i].name = strdup(name);
			return &symbols[i];
		}
	}

	fprintf(stderr, "Symbol table too small, couldn't get room for new symbol %s.\n", name);
	return NULL;
}

symbol_t *allocTemp() {
	symbol_t *symbols = symbolTable.symbols;

	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name == NULL) {
			symbols[i].name = tempSymbol;
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

bool symbolDeclared(char const *name) {
	return getExistingSymbol(name) != NULL;
}

bool symbolInitialized(char const *name) {
	symbol_t *s = getExistingSymbol(name);
	return s != NULL && s->initialized;
}

void printSymbolTable() {
	symbol_t *symbols = symbolTable.symbols;

	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name != NULL) {
			printf("%#x: \"%s\" affected: %s\n", symbols[i].address, symbols[i].name, (symbols[i].initialized ? "true" : "false"));
		}
	}
}
