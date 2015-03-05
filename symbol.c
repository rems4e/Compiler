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

typedef struct _tablesLink_t {
	symbolTable_t table;
	struct _tablesLink_t *next;
} tablesLink_t;

static tablesLink_t *tablesChain = NULL;
static symbolTable_t *currentTable = NULL;
static int lastAddress = 0;

void initSymbolTables() {
	currentTable = pushSymbolTable();
}

void cleanSymbolTables() {
	assert(tablesChain);
	while(tablesChain->next != NULL) {
		popSymbolTable();
	}

	free(tablesChain);
	tablesChain = NULL;
}

symbolTable_t *pushSymbolTable() {
	tablesLink_t *link = malloc(sizeof(tablesLink_t));
	link->next = NULL;

	for(int i = 0; i < SYM_COUNT; ++i, ++lastAddress) {
		link->table.symbols[i].affected = false;
		link->table.symbols[i].name = NULL;
		link->table.symbols[i].address = i;
		link->table.symbols[i].constant = false;
	}
	
	if(tablesChain != NULL) {
		tablesChain->next = link;
	}
	else {
		tablesChain = link;
	}

	return &link->table;
}

void popSymbolTable() {
	assert(tablesChain);
	if(&tablesChain->table == currentTable) {
		fprintf(stderr, "Faudrait ptet en garder une quand même !\n");
		exit(1);
	}

	tablesLink_t *link = tablesChain, *next = tablesChain->next;
	while(next != NULL) {
		if(next->next == NULL) { // Quant on a atteint le bout de la pile…
			// … on supprime le maillon…
			link->next = NULL;
			free(next->next);

			// … et on récupère la table de symboles située juste avant
			currentTable = &link->table;
		}
		else {
			link = next;
			next = link->next;
		}
	}
}


symbol_t *getExistingSymbol(char const *name) {
	assert(tablesChain);

	symbol_t *symbols = currentTable->symbols;

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
	assert(tablesChain);

	symbol_t *symbols = currentTable->symbols;

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
	symbol_t *s = getExistingSymbol(name);
	return s != NULL && s->affected;
}

void printSymbolTable() {
	assert(tablesChain);

	symbol_t *symbols = currentTable->symbols;

	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name != NULL) {
			printf("%#x: \"%s\" affected: %s\n", symbols[i].address, symbols[i].name, (symbols[i].affected ? "true" : "false"));
		}
		else {
			break;
		}
	}
}
