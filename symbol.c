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

static symbolTable_t symbolTable;
static char *tempSymbol;

void initSymbolTable() {
	tempSymbol = strdup("__temp__");
	resetSymbolTable();
}

void resetSymbolTable() {
	symbolTable.stackSize = 0;

	for(int i = 0; i < SYM_COUNT; ++i) {
		symbolTable.symbols[i].affected = false;
		symbolTable.symbols[i].name = NULL;
		symbolTable.symbols[i].address = i + 1;
		symbolTable.symbols[i].constant = false;
		symbolTable.symbols[i].refCount = 0;

		symbolTable.symbolsStack[i] = NULL;
	}
}

void cleanSymbolTable() {
	symbol_t *symbols = symbolTable.symbols;

	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name != tempSymbol) {
			free(symbols[i].name);
		}
	}

	free(tempSymbol);
}

address_t getStackPointerAddress() {
	return 0;
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
		else if(symbols[i].name == NULL) {
			fprintf(stderr, "Symbol %s not found!\n", name);
			break;
		}
	}

	return NULL;
}

symbol_t *createSymbol(char const *name) {
	symbol_t *symbols = symbolTable.symbols;

	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name != NULL && strcmp(symbols[i].name, name) == 0) {
			fprintf(stderr, "Symbol %s already exists!\n", name);
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
			symbols[i].refCount = 1;
			return &symbols[i];
		}
	}

	fprintf(stderr, "Symbol table too small, couldn't get room for new temporary symbol.\n");
	return NULL;

}

void freeIfTemp(symbol_t *s) {
	if(s->name == tempSymbol) {
		assert(s->refCount > 0);
		--s->refCount;
		if(s->refCount == 0) {
			s->name = NULL;
		}
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

bool symbolAffected(char const *name) {
	symbol_t *s = getExistingSymbol(name);
	return s != NULL && s->affected;
}

void printSymbolTable() {
	symbol_t *symbols = symbolTable.symbols;

	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name != NULL) {
			printf("%#x: \"%s\" affected: %s\n", symbols[i].address, symbols[i].name, (symbols[i].affected ? "true" : "false"));
		}
		else {
			break;
		}
	}
}
