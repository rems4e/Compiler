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
#include "utility.h"

#define ADDRESS_SHIFT 2

typedef struct {
	symbol_t symbols[SYM_COUNT];
	symbol_t globals[GLOBAL_COUNT];
	symbol_t *symbolsStack[SYM_COUNT];
	int stackSize, globalCount;

	symbol_t *nestedSymbols[MAX_NESTING][SYM_COUNT];
	int nestingLevel;
} symbolTable_t;


static symbolTable_t symbolTable;
static char *tempSymbol;
static bool globalScope;

void resetSymbolTable();
void initFunctionTable();
void freeFunctionTable();

void initSymbols() {
	tempSymbol = strdup("__temp__");

	symbolTable.nestingLevel = 0;
	for(int i = 0; i < MAX_NESTING; ++i) {
		for(int j = 0; j < SYM_COUNT; ++j) {
			symbolTable.nestedSymbols[i][j] = NULL;
		}
	}

	resetSymbolTable();
	initFunctionTable();

	symbolTable.globalCount = 0;
	for(int i = 0; i < GLOBAL_COUNT; ++i) {
		symbolTable.globals[i].initialized = false;
		symbolTable.globals[i].name = NULL;
		symbolTable.globals[i].address = i;
		symbolTable.globals[i].type.constMask = 0;
		symbolTable.globals[i].type.indirectionCount = 0;
		symbolTable.globals[i].type.baseType = BT_INT;
	}
}

void resetSymbolTable() {
	symbolTable.stackSize = 0;

	for(int i = 0; i < SYM_COUNT; ++i) {
		symbolTable.symbols[i].initialized = false;
		if(!isTemp(&symbolTable.symbols[i])) {
			free(symbolTable.symbols[i].name);
		}
		symbolTable.symbols[i].name = NULL;
		symbolTable.symbols[i].address = i + ADDRESS_SHIFT;
		symbolTable.symbols[i].type.constMask = 0;
		symbolTable.symbols[i].type.indirectionCount = 0;
		symbolTable.symbols[i].type.baseType = BT_INT;

		symbolTable.symbolsStack[i] = NULL;
	}

	for(int i = 1; i < symbolTable.nestingLevel; ++i) {
		for(int j = 0; j < SYM_COUNT; ++j) {
			symbolTable.nestedSymbols[i][j] = NULL;
		}
	}
	symbolTable.nestingLevel = 0;
}

void cleanSymbols() {
	resetSymbolTable();

	for(int i = 0; i < GLOBAL_COUNT; ++i) {
		if(!isTemp(&symbolTable.globals[i])) {
			free(symbolTable.globals[i].name);
		}
	}

	free(tempSymbol);
	freeFunctionTable();
}

bool getGlobalScope() {
	return globalScope;
}

void setGlobalScope(bool global) {
	globalScope = global;
}

int getStackSize() {
	for(int i = SYM_COUNT - 1; i >= 0; --i) {
		if(symbolTable.symbols[i].name != NULL) {
			return i + 1;
		}
	}

	return 0;
}

int getGlobalSymbolsCount() {
	return symbolTable.globalCount;
}

int getSymbolSize(symbol_t const *symbol) {
	if(symbol->type.indirectionCount > 0) {
		if((symbol->type.constMask & (1 << symbol->type.indirectionCount)) != 0) {
			dereferencedSymbol_t first = getTabIndex(symbol->name, 0);
			if(first.symbol != NULL) {
				return getSymbolSize(first.symbol) * (symbol->address - first.symbol->address);
			}
		}

		return SIZEOF_PTR;
	}
	else if(symbol->type.baseType == BT_CHAR) {
		return 1;
	}
	else if(symbol->type.baseType == BT_INT) {
		return SIZEOF_INT;
	}

	return 0;
}

dereferencedSymbol_t createString(char const *value) {
	bool const oldGlobalScope = getGlobalScope();

	setGlobalScope(true);

	int len = strlen(value) + 1;
	char *interningName;
	asprintf(&interningName, "__internedString__%s", value);

	dereferencedSymbol_t deref = getExistingSymbol(interningName, false);
	symbol_t *tab = deref.symbol;
	if(tab == NULL) {
		tab = createTable(interningName, (varType_t){.indirectionCount = 0, .baseType = BT_CHAR, .constMask = 1}, len);
		dereferencedSymbol_t data = getTabIndex(interningName, 0);
		assert(data.symbol);
		for(int i = 0; i < len; ++i) {
			assemblyOutput(AFC" %d %d", data.symbol->address + i, value[i]);
		}
	}

	free(interningName);

	setGlobalScope(oldGlobalScope);

	return getExistingSymbol(interningName, true);
}

dereferencedSymbol_t getExistingSymbol(char const *name, bool failIfNotFound) {
	int const maxLevel = getGlobalScope() ? 0 : symbolTable.nestingLevel;
	// On cherche d'abord dans le niveau d'imbrication le plus élevé
	for(int i = maxLevel; i >= 0; --i) {
		for(int j = 0; j < SYM_COUNT; ++j) {
			symbol_t *sym = symbolTable.nestedSymbols[i][j];
			if(sym != NULL && sym->name != NULL && strcmp(sym->name, name) == 0) {
				if(sym >= symbolTable.globals && sym < symbolTable.globals + GLOBAL_COUNT && !getGlobalScope()) {
					symbol_t *s = allocTemp(sym->type.indirectionCount + 1, sym->type.baseType);
					s->type.constMask = sym->type.constMask;
					asprintf(&s->name, "__global__%s", sym->name);
					s->initialized = true;

					char *comment = safeComment(name);
					assemblyOutput(AFC" %d %d ; Accès à la variable globale %s", s->address, sym->address, comment ? comment : NULL);
					free(comment);

					return DEREF(s, 1);
				}

				return DEREF(sym, 0);
			}
		}
	}

	if(failIfNotFound) {
		yyerror("Variable %s non déclarée\n", name);
	}

	return DEREF(NULL, 0);
}

symbol_t *createSymbol(char const *name, varType_t type) {
	int const nestingLevel = getGlobalScope() ? 0 : symbolTable.nestingLevel;

	symbol_t **newSym = NULL;
	for(int i = 0; i < SYM_COUNT; ++i) {
		symbol_t *sym = symbolTable.nestedSymbols[nestingLevel][i];
		if(sym == NULL) {
			newSym = &symbolTable.nestedSymbols[nestingLevel][i];
			break;
		}
		else if(sym->name != NULL && strcmp(sym->name, name) == 0) {
			yyerror("La variable %s existe déjà !\n", name);
			return NULL;
		}
	}

	// On a trouvé la place dans la table nestedSymbols, plus qu'à trouver la place dans la table principale
	if(newSym != NULL) {
		symbol_t *sym = NULL;
		if(getGlobalScope()) {
			for(int i = 0; i < GLOBAL_COUNT; ++i) {
				if(symbolTable.globals[i].name == NULL) {
					sym = &symbolTable.globals[i];
					++symbolTable.globalCount;
					break;
				}
			}
		}
		else {
			for(int i = 0; i < SYM_COUNT; ++i) {
				if(symbolTable.symbols[i].name == NULL) {
					sym = &symbolTable.symbols[i];
					break;
				}
			}
		}
		if(sym != NULL) {
			sym->name = strdup(name);
			sym->type = type;
			*newSym = sym;
			return *newSym;
		}
	}

	compilerError("La table des symboles est trop petite, impossible de réserver l'espace pour le symbole %s. Essayez avec moins de variables/tableaux, ou contactez l'éditeur pour réduire cette limitation.", name);
	return NULL;
}

symbol_t *createTable(char const *name, varType_t type, int size) {
	int const nestingLevel = getGlobalScope() ? 0 : symbolTable.nestingLevel;

	if(size == 0) {
		size = 1;
	}

	symbol_t **newSym = NULL;
	for(int i = 0; i <= SYM_COUNT - size && newSym == NULL; ++i) {
		for(int j = 0; j < size; ++j) {
			symbol_t *sym = symbolTable.nestedSymbols[nestingLevel][i + j];
			if(sym == NULL && j == size - 1) {
				newSym = &symbolTable.nestedSymbols[nestingLevel][i];
				break;
			}
			else if(sym != NULL && sym->name != NULL) {
				if(strcmp(sym->name, name) == 0) {
					yyerror("La variable %s existe déjà !\n", name);
					return NULL;
				}
				break;
			}
		}
	}

	// On a trouvé la place dans la table nestedSymbols, plus qu'à trouver la place dans la table principale
	if(newSym != NULL) {
		int const count = getGlobalScope() ? GLOBAL_COUNT : SYM_COUNT;
		symbol_t *symbols = getGlobalScope() ? symbolTable.globals : symbolTable.symbols;
		for(int i = 0; i < count; ++i) {
			bool ok = true;
			if(symbols[i].name == NULL) {
				for(int j = 1; j < size; ++j) {
					if(symbols[i + j].name != NULL) {
						// Ça rentre pas…
						ok = false;
						break;
					}
				}
				if(ok) {
					for(int j = 0; j < size; ++j) {
						*(newSym + j) = &symbols[i + j];
						symbols[i + j].type = type;
						asprintf(&symbols[i + j].name, "%s__tabIndice%d", name, j);
					}

					++type.indirectionCount;
					type.constMask |= 1 << type.indirectionCount;
					symbol_t *ptr = createSymbol(name, type);
					ptr->initialized = true;

					char *comment = safeComment(name);

					assemblyOutput(AFC" %d %d ; Tableau \"%s\"", ptr->address, (*newSym)->address, comment ? comment : "");
					free(comment);
					assemblyOutput(ABS" %d", ptr->address);

					if(getGlobalScope()) {
						symbolTable.globalCount += size;
					}
					return ptr;
				}
			}
		}
	}

	compilerError("La table des symboles est trop petite, impossible de réserver l'espace pour le symbole %s. Essayez avec moins de variables/tableaux, ou contactez l'éditeur pour réduire cette limitation.", name);
	return NULL;
}

dereferencedSymbol_t getTabIndex(char const *name, int index) {
	char *toFind;
	asprintf(&toFind, "%s__tabIndice%d", name, index);

	dereferencedSymbol_t ret = getExistingSymbol(toFind, false);

	free(toFind);
	return ret;

}

symbol_t *allocTemp(int indirectionCount, baseType_t baseType) {
	symbol_t *symbols = getGlobalScope() ? symbolTable.globals : symbolTable.symbols;

	for(int i = 0; i < SYM_COUNT; ++i) {
		if(symbols[i].name == NULL) {
			symbols[i].name = tempSymbol;
			symbols[i].type.constMask = 0;
			symbols[i].type.indirectionCount = indirectionCount;
			symbols[i].type.baseType = baseType;
			return &symbols[i];
		}
	}

	compilerError("La table des symboles est trop petite, impossible de réserver l'espace pour un symbole temporaire. Essayez avec moins de variables/tableaux, ou contactez l'éditeur pour réduire cette limitation.");
	return NULL;
}

bool isTemp(symbol_t *s) {
	return s->name == tempSymbol;
}

void freeIfTemp(symbol_t *s) {
	if(isTemp(s)) {
		s->name = NULL;
	}
}

void pushBlock() {
	assert(symbolTable.nestingLevel < MAX_NESTING - 1);
	++symbolTable.nestingLevel;
}

void popBlock() {
	assert(symbolTable.nestingLevel > 0);
	for(int i = 0; i < SYM_COUNT; ++i) {
		symbol_t *toDelete = symbolTable.nestedSymbols[symbolTable.nestingLevel][i];
		if(toDelete == NULL)
			break;

		free(toDelete->name);
		toDelete->name = NULL;

		symbolTable.nestedSymbols[symbolTable.nestingLevel][i] = NULL;
	}
	--symbolTable.nestingLevel;
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

symbol_t *dereferenceExp(dereferencedSymbol_t exp) {
	symbol_t *s = exp.symbol;
	if(!s->initialized && !isTemp(s)) {
		yyerror("Variable %s non initialisée avant utilisation!", s->name);
	}

	if(exp.dereferenceCount > 0) {
		if (exp.dereferenceCount > s->type.indirectionCount) {
			if(exp.dereferenceCount == 1) {
				yyerror("Impossible de déréférencer l'expression.");
			}
			else {
				yyerror("Impossible de déréférencer l'expression %d fois.", exp.dereferenceCount);
			}
		}
		else {
			symbol_t *ind;

			for(int i = 0; i < exp.dereferenceCount; ++i) {
				ind = allocTemp(s->type.indirectionCount - 1, s->type.baseType);
				ind->type.constMask = s->type.constMask & ~(1 << s->type.indirectionCount);
				assemblyOutput(DR2" %d %d", ind->address, s->address);
				freeIfTemp(s);
				s = ind;
			}
			if(isVoid(&ind->type)) {
				yyerror("L'expression ne peut pas être de type void.");
			}

			return ind;
		}
	}

	return s;
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
		yyerror("L'expression n'est pas un scalaire.");
	}
}

void checkIndirectionLevel(symbol_t const *s1, symbol_t const *s2) {
	if(s1->type.indirectionCount != s2->type.indirectionCount) {
		yyerror("Les expressions n'ont pas le même niveau d'indirection.");
	}
}

bool sameType(varType_t const *t1, varType_t const *t2) {
	return t1->indirectionCount == t2->indirectionCount && t1->constMask == t2->constMask && t1->baseType == t2->baseType;
}

bool compatibleForAffectation(varType_t const *left, varType_t const *right, bool allowConst) {
	if(left->indirectionCount != right->indirectionCount && !(left->indirectionCount > 0 && right->indirectionCount > 0 && (left->baseType == BT_VOID || right->baseType == BT_VOID))) {
		return false;
	}
	else if(isVoid(left) || isVoid(right)) {
		return false;
	}
	else if(left->baseType != right->baseType && left->indirectionCount > 0 && !(left->baseType == BT_VOID || right->baseType == BT_VOID)) {
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
	if((left->type.indirectionCount != right->type.indirectionCount) && !(left->type.indirectionCount > 0 && right->type.indirectionCount > 0 && (left->type.baseType == BT_VOID || right->type.baseType == BT_VOID))) {
		yyerror("Le type de l'expression est incompatible avec le type de la variable %s (%d indirections à gauche, %d à droite).", left->name, left->type.indirectionCount, right->type.indirectionCount);
	}
	else if(isVoid(&left->type)) {
		yyerror("Une expression de type void ne peut se trouver à gauche d'une affectation.");
	}
	else if(isVoid(&right->type)) {
		yyerror("Une expression de type void ne peut se trouver à gauche d'une affectation.");
	}
	else if(left->type.baseType != right->type.baseType && left->type.indirectionCount > 0 && !(left->type.baseType == BT_VOID || right->type.baseType == BT_VOID)) {
		yyerror("Les types des deux opérandes sont incompatibles.");
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

bool isVoid(varType_t const *type) {
	return type->baseType == BT_VOID && type->indirectionCount == 0;
}
