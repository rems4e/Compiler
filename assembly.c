//
//  assembly.c
//  Système Info
//
//  Created by Rémi on 05/03/2015.
//

#include "assembly.h"
#include "symbol.h"
#include "function.h"
#include "utility.h"
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#define TAILLE_MAX 1000

extern int errno;

static char *assemblyBuffer = NULL;
static char *globalBuffer = NULL;
static FILE *output = NULL;

typedef struct {
	int adresseSaut;
} label_t;

typedef struct  {
	label_t labels[TAILLE_MAX];
	int size;
	label_t *stack[TAILLE_MAX];
	int stackSize;
} labelList_t;

typedef struct {
	int address[TAILLE_MAX];
	int size;
} addressStack_t;

typedef struct {
	char *address[TAILLE_MAX];
	int size;
} returnStack_t;

static labelList_t ifLabels, loopLabels;
static addressStack_t addressStack;
static returnStack_t returnAddressStack;

static int linesCount = 0, globalCount = 0;

static void replaceLabels(char *txt, char const *prefix, labelList_t *labels, char *buf, size_t unknownLength);
static void removeAssembyOutput(char const *path);

void initAssemblyOutput(char const *path) {
	output = fopen(path, "w");
	if(output == NULL) {
		fprintf(stderr, "Le fichier de sortie \"%s\" n'a pas pu être ouvert : %s\n", path, strerror(errno));
		exit(OPEN_OUTPUT_FAILURE);
	}
	assemblyBuffer = malloc(1);
	assemblyBuffer[0] = '\0';
	globalBuffer = malloc(1);
	globalBuffer[0] = '\0';

	ifLabels.size = loopLabels.size = 0;
	ifLabels.stackSize = loopLabels.stackSize = 0;
	addressStack.size = 0;
	for(int i = 0; i < TAILLE_MAX; ++i) {
		ifLabels.labels[i].adresseSaut = loopLabels.labels[i].adresseSaut = 0;
		ifLabels.stack[i] = loopLabels.stack[i] = NULL;
		returnAddressStack.address[i] = NULL;
	}

	setGlobalScope(false);

	returnAddressStack.size = 1;
	returnAddressStack.address[0] = strdup("EOF"UNKNOWN_ADDRESS);
	assemblyOutput(JMP" EOC"UNKNOWN_ADDRESS" ; Saut à l'initialisation des variables globales");

	setGlobalScope(true);

#ifndef STRIP_COMMENTS
	assemblyOutput(COP" 0 0 ; Initialisation des variables globales");
#endif
}

void closeAssemblyOutput(bool error, char const *path) {
	char *pos;
	char labelBuf[6];
	int unknownLength = strlen(UNKNOWN_ADDRESS);
	size_t length;

	callFunction(getFunction("main"), 0, NULL);

	char *buf2;
	asprintf(&buf2, "%s%s", assemblyBuffer, globalBuffer);
	free(assemblyBuffer);
	free(globalBuffer);
	assemblyBuffer = buf2;

	pos = assemblyBuffer;
	length = sprintf(labelBuf, "%d", instructionsCount());
	while((pos = strstr(pos, "EOC"UNKNOWN_ADDRESS)) != NULL) {
		stringReplaceWithShorter(pos, 3 + unknownLength, labelBuf, length);
	}

	pos = assemblyBuffer;
	length = sprintf(labelBuf, "%d", instructionsCount() + globalCount);
	while((pos = strstr(pos, "EOF"UNKNOWN_ADDRESS)) != NULL) {
		stringReplaceWithShorter(pos, 3 + unknownLength, labelBuf, length);
	}

	pos = assemblyBuffer;
	while((pos = strstr(pos, "FUN"UNKNOWN_ADDRESS)) != NULL) {
		int functionIndex;
		int charatersConsumed;
		sscanf(pos + strlen("FUN"UNKNOWN_ADDRESS), "%d%n", &functionIndex, &charatersConsumed);

		function_t *function = getFunctionWithIndex(functionIndex);
		if(function->address == 0) {
			yyerror("La fonction %s n'a pas été définie !\n", function->name);
		}
		length = sprintf(labelBuf, "%d", function->address);
		stringReplaceWithShorter(pos, strlen("FUN"UNKNOWN_ADDRESS) + charatersConsumed, labelBuf, length);
	}

	replaceLabels(assemblyBuffer, "\n"UNKNOWN_IF_PREFIX, &ifLabels, labelBuf, unknownLength);
	replaceLabels(assemblyBuffer, "\n"UNKNOWN_LOOP_PREFIX, &loopLabels, labelBuf, unknownLength);

#ifdef STRIP_COMMENTS
	pos = assemblyBuffer;
	while((pos = strstr(pos, ";")) != NULL) {
		if(pos[-1] == ' ')
			--pos;
		char *pos2 = strstr(pos, "\n");
		size_t length = pos2 - pos;
		stringReplaceWithShorter(pos, length, "", 0);
	}

#endif

	if(error) {
		fclose(output);
		remove(path);
	}
	else {
		fputs(assemblyBuffer, output);
		fclose(output);
	}
	free(assemblyBuffer);
	
	for(int i = 0; i < TAILLE_MAX; ++i) {
		free(returnAddressStack.address[i]);
	}
}



void replaceLabels(char *txt, char const *prefix, labelList_t *labels, char *buf, size_t unknownLength) {
	int currentLabel = 0;
	while((txt = strstr(txt, prefix)) != NULL) {
		size_t length = strlen(txt + 4);
		memmove(txt + 1, txt + 4, length);
		txt[length + 1] = 0;

		txt = strstr(txt, UNKNOWN_ADDRESS);
		length = sprintf(buf, "%d", labels->labels[currentLabel].adresseSaut);

		stringReplaceWithShorter(txt, unknownLength, buf, length);
		++currentLabel;
	}
	assert(currentLabel == labels->size);
}

void assemblyOutput(char const *lineFormat, ...) {
	va_list args;
	va_start(args, lineFormat);

	char **buffer = getGlobalScope() ? &globalBuffer : &assemblyBuffer;

	char *buf1, *buf2;
	vasprintf(&buf1, lineFormat, args);
	asprintf(&buf2, "%s%s\n", *buffer, buf1);
	free(buf1);
	free(*buffer);
	*buffer = buf2;

	va_end(args);

	getGlobalScope() ? ++globalCount : ++linesCount;
}

int instructionsCount() {
	return linesCount;
}

int lastInstructionCount() {
	assert(addressStack.size > 0);
	return addressStack.address[addressStack.size - 1];
}

void pushInstructionCount() {
	assert(addressStack.size < TAILLE_MAX - 1);
	addressStack.address[addressStack.size++] = instructionsCount();
}

int popInstructionCount() {
	assert(addressStack.size > 0);
	return addressStack.address[--addressStack.size];
}

void pushIfLabel() {
	assert(ifLabels.size < TAILLE_MAX - 1);
	ifLabels.stack[ifLabels.stackSize++] = &ifLabels.labels[ifLabels.size++];
}

void popIfLabel() {
	assert(ifLabels.stackSize > 0);
	ifLabels.stack[--ifLabels.stackSize]->adresseSaut = instructionsCount();
	ifLabels.stack[ifLabels.stackSize] = NULL;
}

void pushIfLabelLastButOne() {
	assert(ifLabels.size < TAILLE_MAX - 1);
	assert(ifLabels.size > 0);

	ifLabels.stack[ifLabels.stackSize] = ifLabels.stack[ifLabels.stackSize - 1];
	ifLabels.stack[ifLabels.stackSize++ - 1] = &ifLabels.labels[ifLabels.size++];
}

void pushLoopLabel() {
	assert(loopLabels.size < TAILLE_MAX - 1);
	loopLabels.stack[loopLabels.stackSize++] = &loopLabels.labels[loopLabels.size++];
}

void popLoopLabel() {
	assert(loopLabels.stackSize > 0);
	loopLabels.stack[--loopLabels.stackSize]->adresseSaut = instructionsCount();
	loopLabels.stack[loopLabels.stackSize] = NULL;
}

void addFunctionReturnAddress(int returnAddress) {
	assert(returnAddressStack.size < TAILLE_MAX - 1);
	char *buf;
	asprintf(&buf, "%d", returnAddress);
	returnAddressStack.address[returnAddressStack.size++] = buf;
}

void affectation(dereferencedSymbol_t id, symbol_t *val, bool allowConst) {
	symbol_t *sym = id.symbol;

	if(id.dereferenceCount > 0) {
		symbol_t *temp;
		for(int i = 0; i < id.dereferenceCount - 1; ++i) {
			temp = allocTemp(sym->type.indirectionCount - 1, sym->type.baseType);
			temp->type.constMask = sym->type.constMask & ~(1 << sym->type.indirectionCount);
			assemblyOutput(DR2" %d %d", temp->address, sym->address);

			freeIfTemp(sym);
			sym = temp;
		}
		symbol_t cop = *sym;
		--cop.type.indirectionCount;
		checkCompatibilityForAffectation(&cop, val, allowConst);
		assemblyOutput(DR1" %d %d", sym->address, val->address);
	}
	else {
		if(id.lvalue == false) {
			yyerror("L'expression n'est pas une lvalue.");
		}
		checkCompatibilityForAffectation(sym, val, allowConst);
		assemblyOutput(COP" %d %d ; %s", sym->address, val->address, id.symbol->name);
		sym->initialized = true;
	}

	freeIfTemp(val);
}

void checkBinOp(char const *op, symbol_t const *s1, symbol_t const *s2) {
	if(isVoid(&s1->type) || isVoid(&s2->type)) {
		yyerror("Les opérandes ne peuvent pas être de type void.");
	}
	else if(op == EQU || op == INF) {
		checkIndirectionLevel(s1, s2);
	}
	else if(op == SOU) {
		if(s1->type.indirectionCount != s2->type.indirectionCount && s2->type.indirectionCount > 0) {
			yyerror("Opérandes invalide pour l'opérateur de soustraction");
		}
	}
	else if(op == ADD) {
		checkScalar(s2);
	}
	else if(op == MUL || op == DIV) {
		checkScalar(s1);
		checkScalar(s2);
	}
}

symbol_t *binOp(char const *op, symbol_t *s1, symbol_t *s2) {
	checkBinOp(op, s1, s2);

	symbol_t *res = allocTemp(s1->type.indirectionCount, s1->type.baseType);

	assemblyOutput("%s %d %d %d", op, res->address, s1->address, s2->address);
	freeIfTemp(s2);
	freeIfTemp(s1);

	return res;
}

symbol_t *binOpEq(char const *op, dereferencedSymbol_t id, symbol_t *value) {
	symbol_t *r = id.symbol;

	if(id.dereferenceCount > 0) {
		char *oldName = id.symbol->name;
		symbol_t *dOp = dereferenceExp(id);
		id.symbol->name = "notTemp";
		symbol_t *res = binOp(op, dOp, value);
		id.symbol->name = oldName;
		affectation(id, res, false);
	}
	else {
		if(id.lvalue == false) {
			yyerror("L'expression n'est pas une lvalue.");
		}
		checkBinOp(op, r, value);
		checkScalar(value);
		assemblyOutput("%s %d %d %d", op, r->address, r->address, value->address);
	}

	freeIfTemp(value);

	return r;
}

symbol_t *negate(symbol_t *s) {
	symbol_t *zero = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d %d ; negate", zero->address, 0);

	return binOp(EQU, s, zero);
}

symbol_t *toBoolean(symbol_t *s) {
	return negate(negate(s));
}

symbol_t *modulo(symbol_t *left, symbol_t *right) {
	symbol_t *leftBackup = allocTemp(0, BT_INT);
	symbol_t *rightBackup = allocTemp(0, BT_INT);
	assemblyOutput(COP" %d %d", leftBackup->address, left->address);
	assemblyOutput(COP" %d %d", rightBackup->address, right->address);

	symbol_t *tmp = binOp(DIV, left, right);
	symbol_t *res = binOp(MUL, tmp, rightBackup);

	return binOp(SOU, leftBackup, res);
}

