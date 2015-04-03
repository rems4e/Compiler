//
//  function.c
//  Système Info
//
//  Created by Rémi on 15/03/2015.
//

#include "function.h"
#include "assembly.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>

#define FUN_COUNT 1000

#define RETURN_ADDRESS 0
#define RETURN_VALUE_ADDRESS 1

void resetSymbolTable();

typedef struct {
	function_t functions[FUN_COUNT];
	int size;
} functionTable_t;

typedef struct {
	param_t params[MAX_PARAMS];
	int size;
} paramList_t;

static functionTable_t functionTable;
static paramList_t paramList;
extern function_t *currentFunction;

void initFunctionTable() {
	functionTable.size = 0;
	for(int i = 0; i < FUN_COUNT; ++i) {
		functionTable.functions[i].name = NULL;
		functionTable.functions[i].address = 0;
		functionTable.functions[i].paramsCount = 0;
		functionTable.functions[i].returnType.indirectionCount = 0;
		functionTable.functions[i].returnType.constMask = 0;
		functionTable.functions[i].returnType.baseType = BT_INT;
		for(int j = 0; j < MAX_PARAMS; ++j) {
			functionTable.functions[i].params[j].name = NULL;
		}
	}

	paramList.size = 0;
	for(int i = 0; i < MAX_PARAMS; ++i) {
		paramList.params[i].name = NULL;
	}

	varType_t type = {.indirectionCount = 0, .constMask = 0, .baseType = BT_INT};
	createFunction(&type, "main", false, 0);
}

void freeFunctionTable() {
	for(int i = 0; i < FUN_COUNT; ++i) {
		free(functionTable.functions[i].name);
		for(int j = 0; j < MAX_PARAMS; ++j) {
			free(functionTable.functions[i].params[j].name);
		}
	}
	for(int i = 0; i < MAX_PARAMS; ++i) {
		free(paramList.params[i].name);
	}
}

void initSymbolTable(function_t *function) {
	resetSymbolTable();
	for(int i = 0; i < function->paramsCount; ++i) {
		symbol_t *s = createSymbol(function->params[i].name, function->params[i].type);
		s->initialized = true;
	}
}

void pushParam(char const *name, varType_t type) {
	assert(paramList.size < MAX_PARAMS - 1);
	param_t param = {.name = strdup(name), .type = type};
	paramList.params[paramList.size++] = param;
}

param_t popParam() {
	assert(paramList.size > 0);
	--paramList.size;

	param_t retVal = {.name = paramList.params[paramList.size].name, .type = paramList.params[paramList.size].type};
	paramList.params[paramList.size].name = NULL;

	return retVal;
}

void callFunction(function_t *function, int argsCount, symbol_t *returnSymbol) {
	allocTemp(0, BT_INT), allocTemp(0, BT_INT);
	int stackSize = getStackSize();

	if(function->paramsCount != argsCount) {
		yyerror("Nombre d'arguments passés à la fonction %s invalide (%d au lieu de %d) !\n", function->name, argsCount, function->paramsCount);
	}
	for(int i = 0; i < argsCount; ++i) {
		symbol_t *arg = popSymbol();
		symbol_t *param = allocTemp(arg->type.indirectionCount, arg->type.baseType);
		if(!compatibleForAffectation(&function->params[i].type, &arg->type, true)) {
			yyerror("Type de l'argument %d passé à la fonction %s invalide !\n", i + 1, function->name);
		}

		assemblyOutput(COP" %d %d ; Copie de l'argument %s lors de l'appel de %s", param->address, arg->address, function->params[i].name, function->name);
	}

	assemblyOutput(STK" %d ; Incrémentation stack pointer", stackSize);
	if(currentFunction != NULL) {
		assemblyOutput(AFC" %d %d ; Sauvegarde adresse retour ", RETURN_ADDRESS, instructionsCount() + 2);
	}
	else {
		assemblyOutput(AFC" %d EOF%s ; Sauvegarde adresse retour ", RETURN_ADDRESS, UNKNOWN_ADDRESS);
	}

	assemblyOutput(JMP" FUN%s%d ; appel de la fonction %s", UNKNOWN_ADDRESS, function - &functionTable.functions[0], function->name);
	if(currentFunction != NULL) {
		addFunctionReturnAddress(instructionsCount());
	}

	if(returnSymbol != NULL && (!isVoid(&returnSymbol->type))) {
		assemblyOutput(COP" %d %d ; Récupération valeur de retour", returnSymbol->address - stackSize, RETURN_VALUE_ADDRESS);
	}
	assemblyOutput(STK" %d ; Décrémentation stack pointer", -stackSize);
}

void createFunction(varType_t *returnType, char const *name, bool definition, int paramsCount) {
	function_t *function = &functionTable.functions[functionTable.size];
	for(int i = 0; (i < functionTable.size) && (functionTable.functions[i].name != NULL); ++i) {
		if(strcmp(functionTable.functions[i].name, name) == 0) {
			function = &functionTable.functions[i];
			break;
		}
	}

	if(function->name == NULL) { // Fonction nouvellement créée
		++functionTable.size;
		function->name = strdup(name);
		function->paramsCount = paramsCount;
		function->returnType = *returnType;

		for(int i = 0; i < paramsCount; ++i) {
			param_t p = popParam();
			function->params[i].name = strdup(p.name);
			function->params[i].type = p.type;
		}
	}
	else { // Fonction déjà déclarée ou définie
		if(function->address != 0) { // Fonction déjà définie, pas touche !
			yyerror("La fonction %s a déjà été définie !\n", name);
		}
		else { // Fonction déjà déclarée, il faut vérifier la compatibilité des paramètres
			bool ok = function->paramsCount == paramsCount;
			for(int i = 0; ok && i < paramsCount; ++i) {
				param_t param = popParam();
				free(function->params[i].name);
				function->params[i].name = strdup(param.name);
				ok = sameType(&param.type, &function->params[i].type);
			}

			ok = sameType(&function->returnType, returnType);

			if(!ok) {
				yyerror("Les paramètres de la fontion %s ne sont pas compatibles avec une déclaration antérieure !\n", name);
			}
		}
	}

	if(definition) {
		function->address = instructionsCount();
		initSymbolTable(function);
		currentFunction = function;
	}
}

function_t *getFunction(char const *name) {
	function_t *function = NULL;
	for(int i = 0; (i < functionTable.size) && (functionTable.functions[i].name != NULL); ++i) {
		if(strcmp(functionTable.functions[i].name, name) == 0) {
			function = &functionTable.functions[i];
			break;
		}
	}

	if(function == NULL) {
		yyerror("La fonction %s n'a pas été déclarée !\n", name);
	}

	return function;
}

function_t *getFunctionWithIndex(int functionIndex) {
	return &functionTable.functions[functionIndex];
}
