//
//  error.c
//  Système Info
//
//  Created on 31/05/2015.
//

#include "error.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "constants.h"

extern int lineNumber;
static int errorCount = 0;
static bool emitErrors = true;

#define MAX_ERROR 20

void enableErrorReporting() {
	emitErrors = true;
}

bool errorsOccurred() {
	return errorCount > 0;
}

void warning(const char *s, ...) {
	va_list args;
	va_start(args, s);

	fprintf(stderr, "Attention ligne %d : ", lineNumber);
	vfprintf(stderr, s, args);
	fputc('\n', stderr);

	va_end(args);
}

void yyerror(const char *s, ...) {
	if(!emitErrors) {
		// On n'affiche qu'une erreur par instruction
		return;
	}
	emitErrors = true;

	va_list args;
	va_start(args, s);

	fprintf(stderr, "Erreur ligne %d : ", lineNumber);
	vfprintf(stderr, s, args);
	fputc('\n', stderr);

	++errorCount;

	if(errorCount >= MAX_ERROR) {
		fprintf(stderr, "Trop d'erreurs, on abandonne.\n");
		exit(COMPILATION_FAILURE);
	}

	va_end(args);
}

void compilerError(const char *s, ...) {
	va_list args;
	va_start(args, s);

	fprintf(stderr, "Erreur interne du compilateur (ligne courante : %d) : ", lineNumber);
	vfprintf(stderr, s, args);
	fputc('\n', stderr);

	va_end(args);

	exit(INTERNAL_FAILURE);
}
