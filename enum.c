//
//  enum.c
//  Système Info
//
//  Created on 28/05/2015.
//

#include "enum.h"
#include <stdlib.h>
#include <string.h>

#define ENUM_MAX 1000

static char *enums[ENUM_MAX] = {NULL};
static enumValue_t enumValues[ENUM_MAX] = {{NULL, 0}};
static int enumCount = 0, enumValuesCount = 0;

void createEnum(char const *name) {
	if(isEnum(name)) {
		yyerror("L'enum %s a déjà été déclarée.", name);
	}
	else {
		if(enumCount < ENUM_MAX - 1) {
			enums[enumCount++] = strdup(name);
		}
		else {
			compilerError("Trop d'enums déclarées dans cette unité de compilation.");
		}
	}
}

bool isEnum(char const *name) {
	for(int i = 0; i < enumCount; ++i) {
		if(strcmp(name, enums[i]) == 0) {
			return true;
		}
	}

	return false;
}

void cleanEnums() {
	for(int i = 0; i < enumCount; ++i) {
		free(enums[i]);
	}
	for(int i = 0; i < enumValuesCount; ++i) {
		free(enumValues[i].name);
	}
}

void addEnumValue(enumValue_t value) {
	if(enumCount < ENUM_MAX - 1) {
		enumValues[enumValuesCount].value = value.value;
		enumValues[enumValuesCount].name = strdup(value.name);
		++enumValuesCount;
	}
	else {
		compilerError("Trop de valeurs d'enums déclarées dans cette unité de compilation.");
	}
}

bool isEnumValue(char const *name) {
	for(int i = 0; i < enumValuesCount; ++i) {
		if(strcmp(enumValues[i].name, name) == 0) {
			return true;
		}
	}

	return false;
}

int getEnumValue(char const *name) {
	for(int i = 0; i < enumValuesCount; ++i) {
		if(strcmp(enumValues[i].name, name) == 0) {
			return enumValues[i].value;
		}
	}

	yyerror("L'identifiant %s n'est pas une valeur énumérée.", name);
	
	return 0;
}
