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

#define STACK_SIZE_ADDRESS 3
#define RETURN_ADDRESS 4

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
		for(int j = 0; j < MAX_PARAMS; ++j) {
			functionTable.functions[i].params[j].name = NULL;
		}
	}

	paramList.size = 0;
	for(int i = 0; i < MAX_PARAMS; ++i) {
		paramList.params[i].name = NULL;
	}

	varType_t type = {.indirectionCount = 0, .constMask = 0};
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
	free(paramList.params[paramList.size].name);
	paramList.params[paramList.size].name = NULL;

	return retVal;
}

void callFunction(function_t *function, int argsCount) {
	int stackSize = getStackSize();
	allocTemp(0), allocTemp(0);
	int returnAddress = instructionsCount();
	if(currentFunction != NULL) {
		stackSize += 2;
	}
	if(currentFunction != NULL) {
		assemblyOutput(COP" %d 1 ; Sauvegarde ancienne adresse retour", RETURN_ADDRESS);
	}

	if(function->paramsCount != argsCount) {
		yyerror("Nombre d'arguments passés à la fonction %s invalide (%d au lieu de %d) !\n", function->name, argsCount, function->paramsCount);
	}
	for(int i = 0; i < argsCount; ++i) {
		symbol_t *arg = popSymbol();
		symbol_t *param = allocTemp(arg->type.indirectionCount);
		if(!compatibleForAffectation(&function->params[i].type, &arg->type, true)) {
			yyerror("Type de l'argument %d passé à la fonction %s invalide !\n", i + 1, function->name);
		}

		assemblyOutput(COP" %d %d ; Copie de l'argument %s lors de l'appel de %s", param->address, arg->address, function->params[i].name, function->name);
	}
	assemblyOutput(AFC" %d %d ; Taille de la pile", STACK_SIZE_ADDRESS + stackSize, stackSize);
	assemblyOutput(ADD" 0 0 %d ; Incrémentation stack pointer", STACK_SIZE_ADDRESS + stackSize);

	assemblyOutput(AFC" 1 %d ; Sauvegarde adresse retour %s", instructionsCount() + 2, currentFunction ? currentFunction->name : "<NULL>");
	if(currentFunction == NULL) {
		assemblyOutput(JMP" %d ; On ne termine le programme que plus tard", instructionsCount() + 2);
		assemblyOutput(JMP" EOF%s ; Fin du programme", UNKNOWN_ADDRESS);
	}

	assemblyOutput(JMP" FUN%s%d ; appel de la fonction %s", UNKNOWN_ADDRESS, function - &functionTable.functions[0], function->name);
	if(currentFunction != NULL) {
		addFunctionReturnAddress(instructionsCount());
	}
	assemblyOutput(COP" 1 %d ; Récupération adresse de retour", RETURN_ADDRESS);
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

		// On saute le retour de la fonction
		pushLabel();
		assemblyOutput(JMP_UNKNOWN" "UNKNOWN_ADDRESS" ; On saute le retour de la fonction %s", function->name);
		assemblyOutput(SOU" 0 0 %d ; Décrémentation stack pointer", STACK_SIZE_ADDRESS);
		assemblyOutput(JMI" 1 ; Retour à la fonction appelante");
		popLabel();

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
