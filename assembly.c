//
//  assembly.c
//  Système Info
//
//  Created by Rémi on 05/03/2015.
//

#include "assembly.h"
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

static labelStack_t labelsStack;
static labelList_t labelsList;
static addressStack_t addressStack;
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
	}
}

void closeAssemblyOutput() {
	char *pos = buffer;
	char labelBuf[5];
	int currentLabel = 0;
	size_t length;

	char const *labelPattern = "\n"UNKNOWN_PREFIX;
	int const labelOffset = strlen("\n"JMP_UNKNOWN);

	while((pos = strstr(pos, labelPattern)) != NULL) {
		length = strlen(pos + 3);
		memmove(pos + 1, pos + 3, length);
		pos[length + 1] = 0;

		pos = strstr(pos, "0000");

		length = sprintf(labelBuf, "%d", labelsList.labels[currentLabel].adresseSaut);
		memcpy(pos, labelBuf, length);
		size_t length2 = strlen(pos + 4 - length);
		memmove(pos + length, pos + 4, length2);
		pos[4 - length + length2] = 0;
		++currentLabel;
	}
	assert(currentLabel == labelsList.size);

	fputs(buffer, output);
	fclose(output);
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
	assert(labelsList.size > 1);

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
