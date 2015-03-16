//
//  function.h
//  Système Info
//
//  Created by Rémi on 15/03/2015.
//

#ifndef __Syste_me_Info__function__
#define __Syste_me_Info__function__

#include "symbol.h"

#define MAX_PARAMS 100

typedef struct {
	char *name;
	VarType type;
} param_t;


typedef struct {
	char *name;
	int address;
	int paramsCount;
	param_t params[MAX_PARAMS];
} function_t;

void pushParam(char const *name, VarType type);
param_t popParam(void);


void createFunction(char const *name, bool definition, int paramsCount);
void callFunction(char const *name, int argsCount);
function_t *getFunction(int functionIndex);

bool paramsEquivalent(param_t *s1, param_t *s2);
bool paramAndArgCompatible(param_t *param, symbol_t *arg);

#endif /* defined(__Syste_me_Info__function__) */
