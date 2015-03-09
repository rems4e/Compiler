//
//  exec.c
//  Système Info
//
//  Created by Rémi on 09/03/2015.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MEMORY_SIZE 1000000

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


void exec(char const *source);

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

void exec(char const *sourceFile) {
	FILE *source = fopen(sourceFile, "rb");

	int *memory = malloc(MEMORY_SIZE * sizeof(int));

	int opcode;
	while(fscanf(source, "%d", &opcode) > 0) {
		switch(opcode) {
			case ADD:
			case SOU:
			case MUL:
			case DIV:

			case EQU:
			case INF:
			case SUP:

			case COP:
			case AFC:
				
			case JMP:
			case JMF:
				
			case PRI:
				break;
		}
	}

	free(memory);

	fclose(source);
}

