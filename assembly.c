//
//  assembly.c
//  Système Info
//
//  Created by Rémi on 05/03/2015.
//

#include "assembly.h"
#include <stdio.h>

static FILE *output = NULL;

void initAssemblyOutput(char const *path) {
	output = fopen(path, "w+");
}

void closeAssemblyOutput() {
	fclose(output);
}

void assemblyOutput(char const *line) {
	fprintf(output, "%s\n", line);
}
