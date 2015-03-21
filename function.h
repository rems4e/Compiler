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
	varType_t type;
} param_t;


typedef struct {
	char *name;
	int address;
	int paramsCount;
	varType_t returnType;
	param_t params[MAX_PARAMS];
} function_t;

void pushParam(char const *name, varType_t type);
param_t popParam(void);


void createFunction(varType_t *returnType, char const *name, bool definition, int paramsCount);
void callFunction(function_t *function, int argsCount);

function_t *getFunction(char const *name);
function_t *getFunctionWithIndex(int functionIndex);

#endif /* defined(__Syste_me_Info__function__) */
