//
//  symbol.c
//  Système Info
//
//  Created by Rémi on 26/02/2015.
//

#include "symbol.h"
#include <stdio.h>
#include <string.h>

#define SYM_COUNT 100

static symbol symbols[SYM_COUNT];

void initSymbolTable() {
	for(int i = 0; i < SYM_COUNT; ++i) {
		symbols[i].affected = false;
		symbols[i].name = NULL;
		symbols[i].add = 0;
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

