//
//  enum.h
//  Système Info
//
//  Created on 28/05/2015.
//

#ifndef __Syste_me_Info__enum__
#define __Syste_me_Info__enum__

#include "constants.h"

typedef struct {
	char *name;
	int value;
} enumValue_t;

void createEnum(char const *name);
bool enumExists(char const *name);
void cleanEnums();

void addEnumValue(enumValue_t value);
int getEnumValue(char const *name);

#endif /* defined(__Syste_me_Info__enum__) */
