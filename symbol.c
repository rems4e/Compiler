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

#define SYM_COUNT 100

static symbol symbols[SYM_COUNT];
static symbol privateSymbols[SYM_COUNT];

void initSymbolTable() {
	int address = 0;
	for(int i = 0; i < SYM_COUNT; ++i, ++address) {
		symbols[i].affected = false;
		symbols[i].name = NULL;
		symbols[i].address = i;
		symbols[i].constant = false;
	}
	for(int i = 0; i < SYM_COUNT; ++i, ++address) {
		privateSymbols[i].affected = false;
		privateSymbols[i].name = NULL;
		privateSymbols[i].address = address;
		privateSymbols[i].constant = false;
	}
}

symbol *getExistingSymbol(char const *name) {
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

symbol *createSymbol(char const *name) {
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

bool symbolDeclared(char const *name) {
	return getExistingSymbol(name) != NULL;
}

bool symbolAffected(char const *name) {
	symbol *s = getExistingSymbol(name);
	return s != NULL && s->affected;
}

void printSymbolTable() {
	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name != NULL) {
			printf("%#x: \"%s\" affected: %s\n", symbols[i].address, symbols[i].name, (symbols[i].affected ? "true" : "false"));
		}
		else {
			break;
		}
	}
}


symbol *createPrivateSymbol() {
	for(int i = 0; i < SYM_COUNT; ++i) {
		if(privateSymbols[i].name == NULL) {
			privateSymbols[i].name = malloc(10 + 1);
			strcpy(privateSymbols[i].name, "__private");
			privateSymbols[i].name[10] = i;
			return &privateSymbols[i];
		}
	}

	fprintf(stderr, "Symbol table too small, couldn't get room for new private symbol.\n");
	return NULL;

}


