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

static char *buffer = NULL;
static FILE *output = NULL;

typedef struct {
	int adresseSaut;
} label_t;

typedef struct {
	label_t *labels[TAILLE_MAX];
	int size;
} labelStack_t;

typedef struct  {
	label_t labels[TAILLE_MAX];
	int size;
} labelList_t;

typedef struct {
	int address[TAILLE_MAX];
	int size;
} addressStack_t;

typedef struct {
	char *address[TAILLE_MAX];
	int size;
} returnStack_t;

static labelStack_t labelsStack;
static labelList_t labelsList;
static addressStack_t addressStack;
static returnStack_t returnAddressStack;

static size_t linesCount = 0;


void initAssemblyOutput(char const *path) {
	output = fopen(path, "w+");
	buffer = malloc(1);
	buffer[0] = '\0';

	labelsList.size = 0;
	labelsStack.size = 0;
	addressStack.size = 0;
	for(int i = 0; i < TAILLE_MAX; ++i) {
		labelsList.labels[i].adresseSaut = 0;
		labelsStack.labels[i] = NULL;
		returnAddressStack.address[i] = NULL;
	}

	returnAddressStack.size = 1;
	returnAddressStack.address[0] = strdup("EOF"UNKNOWN_ADDRESS);

	callFunction(getFunction("main"), 0, NULL);
}

void closeAssemblyOutput() {
	char *pos = buffer;
	char labelBuf[5];
	int currentLabel = 0;
	int unknownLength = strlen(UNKNOWN_ADDRESS);
	size_t length;

#ifdef STRIP_COMMENTS
	while((pos = strstr(pos, ";")) != NULL) {
		if(pos[-1] == ' ')
			--pos;
		char *pos2 = strstr(pos, "\n");
		size_t length = pos2 - pos;
		stringReplaceWithShorter(pos, length, "", 0);
	}

#endif

	pos = buffer;
	length = sprintf(labelBuf, "%zu", instructionsCount());
	while((pos = strstr(pos, "EOF"UNKNOWN_ADDRESS)) != NULL) {
		stringReplaceWithShorter(pos, 3 + unknownLength, labelBuf, length);
	}

	pos = buffer;
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

	pos = buffer;

	char const *labelPattern = "\n"UNKNOWN_PREFIX;
	while((pos = strstr(pos, labelPattern)) != NULL) {
		length = strlen(pos + 3);
		memmove(pos + 1, pos + 3, length);
		pos[length + 1] = 0;

		pos = strstr(pos, UNKNOWN_ADDRESS);

		length = sprintf(labelBuf, "%d", labelsList.labels[currentLabel].adresseSaut);
		
		stringReplaceWithShorter(pos, unknownLength, labelBuf, length);
		++currentLabel;
	}
	assert(currentLabel == labelsList.size);

	fputs(buffer, output);
	fclose(output);

	for(int i = 0; i < TAILLE_MAX; ++i) {
		free(returnAddressStack.address[i]);
	}
}

void assemblyOutput(char const *lineFormat, ...) {
	va_list args;
	va_start(args, lineFormat);

	char *buf1, *buf2;
	vasprintf(&buf1, lineFormat, args);
	asprintf(&buf2, "%s%s\n", buffer, buf1);
	free(buf1);
	free(buffer);
	buffer = buf2;

	va_end(args);

	++linesCount;
}

size_t instructionsCount() {
	return linesCount;
}

void pushInstructionCount() {
	assert(addressStack.size < TAILLE_MAX - 1);
	addressStack.address[addressStack.size++] = instructionsCount();
}

int popInstructionCount() {
	assert(addressStack.size > 0);
	return addressStack.address[--addressStack.size];
}

void pushLabel() {
	assert(labelsList.size < TAILLE_MAX - 1);
	labelsStack.labels[labelsStack.size++] = &labelsList.labels[labelsList.size++];
}

void pushLabelLastButOne() {
	assert(labelsList.size < TAILLE_MAX - 1);
	assert(labelsList.size > 0);

	labelsStack.labels[labelsStack.size] = labelsStack.labels[labelsStack.size - 1];
	labelsStack.labels[labelsStack.size++ - 1] = &labelsList.labels[labelsList.size++];
}

void popLabel() {
	popLabelWithAddress(instructionsCount());
}

void popLabelWithAddress(int address) {
	assert(labelsStack.size > 0);
	--labelsStack.size;
	labelsStack.labels[labelsStack.size]->adresseSaut = address;
	labelsStack.labels[labelsStack.size] = NULL;
}

void addFunctionReturnAddress(int returnAddress) {
	assert(returnAddressStack.size < TAILLE_MAX - 1);
	char *buf;
	asprintf(&buf, "%d", returnAddress);
	returnAddressStack.address[returnAddressStack.size++] = buf;
}
