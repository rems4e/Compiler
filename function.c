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

#define STACK_SIZE_ADDRESS 2
#define RETURN_ADDRESS 3

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
		for(int j = 0; j < MAX_PARAMS; ++j) {
			functionTable.functions[i].params[j].name = NULL;
		}
	}

	paramList.size = 0;
	for(int i = 0; i < MAX_PARAMS; ++i) {
		paramList.params[i].name = NULL;
	}

	createFunction("main", false, 0);
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
}

void pushParam(char const *name, VarType type) {
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

void callFunction(char const *name, int argsCount) {
	int stackSize = getStackSize();
	allocTemp(), allocTemp();
	int returnAddress = instructionsCount();
	if(currentFunction != NULL) {
		stackSize += 2;
	}
	assemblyOutput(AFC" %d %d ; taille de la pile", STACK_SIZE_ADDRESS + stackSize, stackSize);
	assemblyOutput(ADD" 0 0 %d ; Incrémentation stack pointer", STACK_SIZE_ADDRESS + 2); // Incrémentation stack pointer
	if(currentFunction != NULL) {
		assemblyOutput(COP" %d 1 ; Sauvegarde ancienne adresse retour", RETURN_ADDRESS); // Sauvegarde adresse de retour
	}

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
	if(function->paramsCount != argsCount) {
		yyerror("Nombre d'arguments passés à la fonction %s invalide (%d au lieu de %d) !\n", name, argsCount, function->paramsCount);
	}

	for(int i = 0; i < argsCount; ++i) {
		symbol_t *param = createSymbol(function->params[i].name);
		symbol_t *arg = popSymbol();
		if(!paramAndArgCompatible(&function->params[i], arg)) {
			yyerror("Type de l'argument %d passé à la fonction %s invalide !\n", i + 1, name);
		}

		assemblyOutput(COP" %d %d ; Copie de l'argument %s lors de l'appel de %s", param->address, arg->address, arg->name, function->name); // Copie des arguments
	}

	assemblyOutput(AFC" 1 %d ; Sauvegarde adresse retour %s", instructionsCount() + 2, currentFunction ? currentFunction->name : "<NULL>"); // Sauvegarde adresse de retour
	if(currentFunction == NULL) {
		assemblyOutput(JMP" %d ; On ne termine le programme que plus tard", instructionsCount() + 2); // Sauvegarde adresse de retour
		assemblyOutput(JMP" EOF%s ; Fin du programme", UNKNOWN_ADDRESS); // Sauvegarde adresse de retour
	}

	assemblyOutput(JMP" FUN%s%d ; appel de la fonction %s", UNKNOWN_ADDRESS, function - &functionTable.functions[0], function->name); // Appel de la fonction
	if(currentFunction != NULL) {
		addFunctionReturnAddress(instructionsCount());
	}
	assemblyOutput(COP" 1 %d ; Récupération adresse de retour", RETURN_ADDRESS); // Récupération adresse de retour
}

void createFunction(char const *name, bool definition, int paramsCount) {
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

		for(int i = 0; i < paramsCount; ++i) {
			function->params[i] = popParam();
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
				ok = paramsEquivalent(&param, &function->params[i]);
			}

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
		assemblyOutput(SOU" 0 0 %d ; Décrémentation stack pointer", STACK_SIZE_ADDRESS); // Décrémentation stack pointer
		assemblyOutput(JMP" FUN_RET ; On saute à la table de retour de fonction en fin de fichier"); // Retour à la fonction appelante
		popLabel();

		currentFunction = function;
	}
}

function_t *getFunction(int functionIndex) {
	return &functionTable.functions[functionIndex];
}

bool paramsEquivalent(param_t *p1, param_t *p2) {
	return p1->type == p2->type;
}

bool paramAndArgCompatible(param_t *param, symbol_t *arg) {
	return true;
}

