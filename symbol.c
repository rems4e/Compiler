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
	symbolTable.lastTemporary = SYM_COUNT;

	for(int i = 0; i < SYM_COUNT; ++i) {
		symbolTable.symbols[i].affected = false;
		symbolTable.symbols[i].name = NULL;
		symbolTable.symbols[i].address = i;
		symbolTable.symbols[i].constant = false;
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

	for(int i = symbolTable.lastTemporary - 1; i >= 0; ++i) {
		if(symbols[i].name == NULL) {
			symbols[i].name = tempSymbol;
			--symbolTable.lastTemporary;

			return &symbols[i];
		}
	}

	fprintf(stderr, "Symbol table too small, couldn't get room for new temporary symbol.\n");
	return NULL;

}

address_t freeTempAndGetAddress() {
	symbol_t *symbols = symbolTable.symbols;

	assert(symbolTable.lastTemporary < SYM_COUNT);
	symbol_t *temp = &symbols[symbolTable.lastTemporary];

	temp->name = NULL;
	++symbolTable.lastTemporary;

	return temp->address;
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
