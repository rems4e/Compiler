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

#define MEMORY_SIZE 1000000
#define STACK_CAPACITY 1000
#define MAX_LINES 100000

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

void push(int val) {
	assert(stackSize < STACK_CAPACITY - 1);
	stack[stackSize++] = val;
}

int pop(void) {
	assert(stackSize > 0);
	return stack[--stackSize];
}

#define SCAN_ONE { sscanf(line, "%d", &op1); }
#define SCAN_TWO { sscanf(line, "%d %d", &op1, &op2); }
#define SCAN_THREE { sscanf(line, "%d %d %d", &op1, &op2, &op3); }

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

	int *memory = malloc(MEMORY_SIZE * sizeof(int));

	int opcode, op1, op2, op3, val1, val2;
	int pc = 0;
	while(pc < linesCount) {
		char *line = &source[linesIndex[pc]];
		if(line[0] >= '0' && line[0] <= '9')
			opcode = line[0] - '0';
		else {
			opcode = line[0] - 'A' + 10;
		}
		++line;

		switch(opcode) {
			case ADD:
				SCAN_THREE;
				memory[op1] = memory[op2] + memory[op3];
				break;
			case SOU:
				SCAN_THREE;
				memory[op1] = memory[op2] - memory[op3];
				break;
			case MUL:
				SCAN_THREE;
				memory[op1] = memory[op2] * memory[op3];
				break;
			case DIV:
				SCAN_THREE;
				 memory[op1] = memory[op2] / memory[op3];
				break;
			case EQU:
				SCAN_THREE;
				memory[op1] = memory[op2] == memory[op3];
				break;
			case INF:
				SCAN_THREE;
				memory[op1] = memory[op2] < memory[op3];
				break;
			case SUP:
				SCAN_THREE;
				memory[op1] = memory[op2] > memory[op3];
				break;

			case COP:
				SCAN_TWO;
				memory[op1] = memory[op2];
				break;

			case AFC:
				SCAN_TWO;
				memory[op1] = op2;
				break;

			case JMP:
				SCAN_ONE;
				pc = op1;
				continue;
			case JMF:
				SCAN_TWO;
				if(!memory[op1]) {
					pc = op2;
					continue;
				}
				break;
				
			case PRI:
				SCAN_ONE;
				printf("%d\n", memory[op1]);
				break;
		}

		++pc;
	}

	free(memory);
	free(source);
	fclose(sourceFile);
}

