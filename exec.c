//
//  exec.c
//  Système Info
//
//  Created by Rémi on 09/03/2015.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

#define STRINGIFY(X) #X

#define MEMORY_SIZE 1000000
#define STACK_CAPACITY 1000
#define MAX_LINES 100000

#define STK 0x0

#define ADD 0x1
#define SOU 0x3
#define MUL 0x2
#define DIV 0x4

#define EQU 0xB
#define INF 0x9
#define SUP 0xA

#define COP 0x5
#define AFC 0x6

#define JMP 0x7
#define JMF 0x8

#define PRI 0xC

#define RET 0xD
#define DR1 0xE
#define DR2 0xF


void exec(char const *sourcePath);

int main(int argc, char const **argv) {
	if(argc > 1) {
		long len = strlen(argv[1]);

		if(len < 2 || argv[1][len - 1] != 's' || argv[1][len - 2] != '.') {
			fprintf(stderr, "Le fichier doit avoir l'extension \".s\" !\n");
			return 1;
		}

		exec(argv[1]);
	}

	return 0;
}

static int stackSize = 0;
static int stack[STACK_CAPACITY];
static int *memory;
static int stackPointer = 0;

void push(int val) {
	assert(stackSize < STACK_CAPACITY - 1);
	stack[stackSize++] = val;
}

int pop(void) {
	assert(stackSize > 0);
	return stack[--stackSize];
}

void error(char const *opcode, int expected, int got) {
	fprintf(stderr, "L'opcode %s a besoin de %d %s ; seulement %d %s.\n", opcode, expected, (expected > 1 ? "opérandes" : "opérande"), got, (got > 1 ? "valides ont été trouvées" : "valide a été trouvée"));
	exit(1);
}

#define SCAN_ONE(OPCODE) { int got = sscanf(line, "%d", &op1); if(got != 1) { error(OPCODE, 1, got); } }
#define SCAN_TWO(OPCODE) { int got = sscanf(line, "%d %d", &op1, &op2); if(got != 2) { error(OPCODE, 2, got); } }
#define SCAN_THREE(OPCODE) { int got = sscanf(line, "%d %d %d", &op1, &op2, &op3); if(got != 3) { error(OPCODE, 3, got); } }

int *getMemory(int address) {
	address += stackPointer;
	assert(address >= 0 && address < MEMORY_SIZE);

	return &memory[address];
}

void exec(char const *sourcePath) {
	FILE *sourceFile = fopen(sourcePath, "rb");
	char *source;

	size_t linesIndex[MAX_LINES] = {0};
	size_t linesCount = 0;
	if(sourceFile) {
		fseek(sourceFile, 0, SEEK_END);
		size_t len = ftell(sourceFile);
		fseek(sourceFile, 0, SEEK_SET);
		source = malloc(len);
		if(source) {
			fread(source, 1, len, sourceFile);
			for(size_t i = 0, last = 0; i < len; ++i) {
				if(source[i] == '\n') {
					linesIndex[linesCount++] = last;
					last = i + 1;
				}
			}
		}
		fclose(sourceFile);
	}
	else {
		fprintf(stderr, "Fichier pas ouvert : %s\n", sourcePath);
		return;
	}

	memory = malloc(MEMORY_SIZE * sizeof(int));

	//memset(memory, 0xFF, MEMORY_SIZE);

	int opcode, op1, op2, op3;
	int pc = 0;
	while(pc < linesCount) {
		char *line = &source[linesIndex[pc]];
		if(line[0] >= '0' && line[0] <= '9')
			opcode = line[0] - '0';
		else {
			opcode = line[0] - 'A' + 10;
		}
		++line;

		/*printf("Ligne : %d\nsp : %d\n", pc + 1, stackPointer);

		for(int i = 0; i < 30; ++i) {
			printf("\tmemory[%d]: %d\n", i, memory[i]);
		}
		putc('\n', stdout);*/
		switch(opcode) {
			case STK:
				SCAN_ONE(STRINGIFY(STK));
				stackPointer += op1;
				break;
			case ADD:
				SCAN_THREE(STRINGIFY(ADD));
				*getMemory(op1) = *getMemory(op2) + *getMemory(op3);
				break;
			case SOU:
				SCAN_THREE(STRINGIFY(SOU));
				*getMemory(op1) = *getMemory(op2) - *getMemory(op3);
				break;
			case MUL:
				SCAN_THREE(STRINGIFY(MUL));
				*getMemory(op1) = *getMemory(op2) * *getMemory(op3);
				break;
			case DIV:
				SCAN_THREE(STRINGIFY(DIV));
				 *getMemory(op1) = *getMemory(op2) / *getMemory(op3);
				break;
			case EQU:
				SCAN_THREE(STRINGIFY(EQU));
				*getMemory(op1) = *getMemory(op2) == *getMemory(op3);
				break;
			case INF:
				SCAN_THREE(STRINGIFY(INF));
				*getMemory(op1) = *getMemory(op2) < *getMemory(op3);
				break;
			case SUP:
				SCAN_THREE(STRINGIFY(SUP));
				*getMemory(op1) = *getMemory(op2) > *getMemory(op3);
				break;

			case COP:
				SCAN_TWO(STRINGIFY(COP));
				*getMemory(op1) = *getMemory(op2);
				break;

			case AFC:
				SCAN_TWO(STRINGIFY(AFC));
				*getMemory(op1) = op2;
				break;

			case JMP:
				SCAN_ONE(STRINGIFY(JMP));
				pc = op1;
				continue;
			case JMF:
				SCAN_TWO(STRINGIFY(JMF));
				if(!*getMemory(op1)) {
					pc = op2;
					continue;
				}
				break;
				
			case PRI:
				SCAN_ONE(STRINGIFY(PRI));
				printf("%d\n", *getMemory(op1));
				break;

			case RET:
				pc = *getMemory(0);

				continue;

			case DR1:
				SCAN_TWO(STRINGIFY(DR1));
				memory[*getMemory(op1)] = *getMemory(op2);
				break;

			case DR2:
				SCAN_TWO(STRINGIFY(DR2));
				*getMemory(op1) = memory[*getMemory(op2)];
				break;
		}

		++pc;
	}

	free(memory);
	free(source);
}
