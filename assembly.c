//
//  assembly.c
//  Système Info
//
//  Created by Rémi on 05/03/2015.
//

#include "assembly.h"
#include <stdio.h>
#include <stdarg.h>

static FILE *output = NULL;

void initAssemblyOutput(char const *path) {
	output = fopen(path, "w+");
}

void closeAssemblyOutput() {
	fclose(output);
}

void assemblyOutput(char const *lineFormat, ...) {
	va_list args;
	va_start(args, lineFormat);

	vfprintf(output, lineFormat, args);
	fputc('\n', output);

	va_end(args);
}
