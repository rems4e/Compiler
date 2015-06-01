%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <stdarg.h>
	#include <assert.h>
	#include <limits.h>
	#include "constants.h"
	#include "symbol.h"
	#include "assembly.h"
	#include "function.h"
	#include "utility.h"
	#include "enum.h"
	#include "error.h"

	#define YYERROR_VERBOSE

	#define MAX_INITIALIZER 2048
	#define MAX_STACK 1000
	#define MAX_CASE 1024

	typedef struct yy_buffer_state *YY_BUFFER_STATE;

	int yylex();
	YY_BUFFER_STATE yy_scan_string(const char *yy_str);

	extern int const lineNumber;
	static int forConditionReturn;
	static int tabSize;
	static bool lastInstructionIsReturn = false;
	static int loop = 0;
	static varType_t lastVarType, returnValueType;
	static char const *idName = NULL;
	static enumValue_t lastEnumValue = {NULL, 0};

	function_t *currentFunction = NULL;

	static struct {
		symbol_t *data[MAX_INITIALIZER];
		int count;
	} initializerList;

	static int loopMarkers[MAX_NESTING];

	static struct {
		int size;
		int argCount[MAX_STACK];
	} argsStack;

	static struct {
		int size;
		int values[MAX_STACK][MAX_CASE];
		int caseCount[MAX_STACK];
		bool hasDefault[MAX_STACK];
	} switchStack;

	%}

%union {
	int nb;
	char const *string;
	struct dereferencedSymbol_t dereferencedSymbol;
	varType_t varType;
}

%token <nb> tNUMBER
%token <string> tID
%token <string> tSTRING_LITTERAL
%token <string> tCHAR_LITTERAL

%type <dereferencedSymbol> Exp
%type <varType> Type

%token tO_P tC_P tCOMMA tO_BR tC_BR
%token tCONST tINT tCHAR tCONSTC tVOID
%token tINCR tDECR

%token tNULL tTRUE tFALSE
%token tAMP

%token tSEMI

%token tRETURN tGOTO tPRINT tSCAN tENUM
%token tIF tELSE tWHILE tFOR tDO tBREAK tCONTINUE tSWITCH tCASE tDEFAULT

%token tSIZEOF;

%right tPLUSEQ tMINUSEQ tDIVEQ tMULEQ tMODEQ tEQUAL tBITANDEQ tBITOREQ tBITXOREQ tSHIFTLEQ tSHIFTREQ

%right tQUESTION tCOLON

%left tOR
%left tAND
%left tBITOR
%left tBITXOR
%left tBOOLEQUAL tLESSEQUAL tGREATEQUAL tGREAT tLESS tDIFF

%left tSHIFTL tSHIFTR

%left tPLUS tMINUS
%left tDIV tSTAR tMOD

%right tSIZEOF tAMP;

%right tNOT tBITNOT

%nonassoc tO_SQBR tC_SQBR

%right tINCR tDECR

%nonassoc EndIf
%nonassoc tELSE

%start Body

%%

Body :
| Body DefBody;

EndOrError : error tSEMI {
	yyerrok;
	enableErrorReporting();
}
| tSEMI;

DefBody : Def
| tENUM tID { lastEnumValue.value = -1; createEnum($2); } tO_BR EnumBody tC_BR tSEMI
| tENUM tO_BR {lastEnumValue.value = -1; } EnumBody tC_BR tSEMI
| Type tID tO_P {
	argsStack.argCount[0] = 0;
	returnValueType = $1;
} Params tC_P { idName = $2; } FunctionEnd;

EnumBody : tID { lastEnumValue.name = strdup($1); } EnumVal EnumNext;

EnumNext :
| tCOMMA
| tCOMMA EnumBody;

EnumVal : {
	++lastEnumValue.value;
	addEnumValue(lastEnumValue);
	symbol_t *val = createSymbol(lastEnumValue.name, (varType_t){.constMask = 1, .indirectionCount = 0, .baseType = BT_INT});
	assemblyOutput(AFC" %d %d ; %s", val->address, lastEnumValue.value, lastEnumValue.name);
	free(lastEnumValue.name);
	lastEnumValue.name = NULL;
}
| tEQUAL tID {
	lastEnumValue.value = getEnumValue($2);
	addEnumValue(lastEnumValue);
	symbol_t *val = createSymbol(lastEnumValue.name, (varType_t){.constMask = 1, .indirectionCount = 0, .baseType = BT_INT});
	assemblyOutput(AFC" %d %d ; %s", val->address, lastEnumValue.value, lastEnumValue.name);
	free(lastEnumValue.name);
	lastEnumValue.name = NULL;
}
| tEQUAL tNUMBER {
	lastEnumValue.value = $2;
	addEnumValue(lastEnumValue);
	symbol_t *val = createSymbol(lastEnumValue.name, (varType_t){.constMask = 1, .indirectionCount = 0, .baseType = BT_INT});
	assemblyOutput(AFC" %d %d ; %s", val->address, lastEnumValue.value, lastEnumValue.name);
	free(lastEnumValue.name);
	lastEnumValue.name = NULL;
};

FunctionEnd : { createFunction(&returnValueType, idName, false, argsStack.argCount[0]); } EndOrError
| { pushBlock(); setGlobalScope(false); createFunction(&returnValueType, idName, true, argsStack.argCount[0]); pushBlock(); setGlobalScope(false); } FunctionBody;

FunctionBody : tO_BR Instrucs tC_BR {
	if(!lastInstructionIsReturn && !isVoid(&currentFunction->returnType)) {
		yyerror("Une valeur de retour est obligatoire à la fin d'une fonction ne retournant pas void.");
	}
	else if(!lastInstructionIsReturn) {
		assemblyOutput(RET" ; Retour à la fonction appelante");
	}

	resetGotoLabels();
	currentFunction = NULL;
	popBlock();
	setGlobalScope(true);
};

Return : tRETURN ReturnValue;

ReturnValue : Exp {
	symbol_t *returnValue = dereferenceExp($1);

	if(!compatibleForAffectation(&currentFunction->returnType, &returnValue->type, true)) {
		yyerror("L'expression est incompatible avec la valeur de retour de la fonction.");
	}

	assemblyOutput(COP" 1 %d ; Copie de la valeur de retour pour récupération par l'appelant", returnValue->address);
	freeIfTemp(returnValue);
	assemblyOutput(RET" ; Retour à la fonction appelante");
}
| {
	if(!isVoid(&currentFunction->returnType)) {
		yyerror("L'expression est incompatible avec la valeur de retour de la fonction.");
	}
}

Params :
| ParamsList;

ParamsList : Param
| ParamsList tCOMMA Param;

Param : Type tID { ++argsStack.argCount[0]; pushParam($2, $1); };

Def : Type TypedDef;

Indirections :
| Indirections Indirection;

Indirection : tSTAR tCONST {
	++lastVarType.indirectionCount;
	lastVarType.constMask |= 1 << lastVarType.indirectionCount;
}
| tSTAR {
	++lastVarType.indirectionCount;
};

Type : tINT {
	lastVarType = (varType_t){.constMask = 0, .indirectionCount = 0, .baseType = BT_INT};
} Indirections {
	$$ = (varType_t){.constMask = lastVarType.constMask, .indirectionCount = lastVarType.indirectionCount, .baseType = BT_INT};
}
| tCONST {
	lastVarType = (varType_t){.constMask = 1, .indirectionCount = 0, .baseType = BT_INT};
} Indirections {
	$$ = (varType_t){.constMask = 1 | lastVarType.constMask, .indirectionCount = lastVarType.indirectionCount, .baseType = BT_INT};
}
| tVOID {
	lastVarType = (varType_t){.constMask = 0, .indirectionCount = 0, .baseType = BT_VOID};
} Indirections {
	$$ = (varType_t){.constMask = lastVarType.constMask, .indirectionCount = lastVarType.indirectionCount, .baseType = BT_VOID};
}
| tCHAR {
	lastVarType = (varType_t){.constMask = 0, .indirectionCount = 0, .baseType = BT_CHAR};
} Indirections {
	$$ = (varType_t){.constMask = lastVarType.constMask, .indirectionCount = lastVarType.indirectionCount, .baseType = BT_CHAR};
}
| tCONSTC {
	lastVarType = (varType_t){.constMask = 1, .indirectionCount = 0, .baseType = BT_CHAR};
} Indirections {
	$$ = (varType_t){.constMask = 1 | lastVarType.constMask, .indirectionCount = lastVarType.indirectionCount, .baseType = BT_CHAR};
}
| tENUM tID {
	if(!isEnum($2)) {
		yyerror("L'enum %s n'a pas été déclarée.", $2);
	}
	lastVarType = (varType_t){.constMask = 0, .indirectionCount = 0, .baseType = BT_INT};
} Indirections {
	$$ = (varType_t){.constMask = lastVarType.constMask, .indirectionCount = lastVarType.indirectionCount, .baseType = BT_CHAR};
}
| tCONST tENUM tID {
	if(!isEnum($3)) {
		yyerror("L'enum %s n'a pas été déclarée.", $3);
	}
	lastVarType = (varType_t){.constMask = 1, .indirectionCount = 0, .baseType = BT_INT};
} Indirections {
	$$ = (varType_t){.constMask = 1 | lastVarType.constMask, .indirectionCount = lastVarType.indirectionCount, .baseType = BT_CHAR};
}
| tENUM tID tCONST {
	if(!isEnum($2)) {
		yyerror("L'enum %s n'a pas été déclarée.", $2);
	}
	lastVarType = (varType_t){.constMask = 1, .indirectionCount = 0, .baseType = BT_INT};
} Indirections {
	$$ = (varType_t){.constMask = 1 | lastVarType.constMask, .indirectionCount = lastVarType.indirectionCount, .baseType = BT_CHAR};
};


PureType : Type { tabSize = 1; }
| Type tO_SQBR tNUMBER tC_SQBR { if($3 < 0) { yyerror("Un tableau ne peut pas avoir de taille négative."); } tabSize = $3; };
| Type tO_P Indirections tC_P tO_SQBR ExpOrEmpty tC_SQBR { tabSize = 1; }
| Type tO_SQBR tC_SQBR { tabSize = -1; };

TypedDefNext : EndOrError
| tCOMMA TypedDef;
        
TypedDef : tID {
	if(topLevelConst(&lastVarType)) {
		yyerror("La constante %s n'est pas initialisée.", $1);
	}
	else if(isVoid(&lastVarType)) {
		yyerror("Impossible de déclarer une variable de type void.");
	}
	createSymbol($1, lastVarType);
} TypedDefNext
| tID tEQUAL Exp {
	if(isVoid(&lastVarType)) {
		yyerror("Impossible de déclarer une variable de type void.");
	}
	symbol_t *s = createSymbol($1, lastVarType);
	affectation(LDEREF(s, 0, true), dereferenceExp($3), true);
} TypedDefNext
| Tab TabDef TypedDefNext;

Tab : {
	if(tabSize == -1) {
		yyerror("Un tableau dont la dimension n'a pas été spécifiée doit être initialisé.");
	}
	else {
		symbol_t *symTab = createArray(idName, lastVarType, tabSize);
	}
}
| tID tO_SQBR tNUMBER tC_SQBR {
	if($3 < 0) {
		yyerror("Impossible de créer un tableau de dimension négative.");
	}

	tabSize = $3;
	idName = $1;
}
| tID tO_SQBR tC_SQBR {
	tabSize = -1;
	idName = $1;
}
| EndOrError;

TabDef : tEQUAL tO_BR TabEnd {
	if(tabSize == -1) {
		tabSize = initializerList.count;
	}
	symbol_t *tab = createArray(idName, lastVarType, tabSize);

	symbol_t *last = getArrayIndex(tab->name, initializerList.count - 1).symbol;
	if(last == NULL) {
		yyerror("Trop d'éléments dans la liste d'initialisation de %s.", tab->name);
	}
	else {
		symbol_t *current = getArrayIndex(tab->name, 0).symbol;
		for(int i = 0; i < initializerList.count; ++i, ++current) {
			symbol_t *init = initializerList.data[i];
			assemblyOutput(COP" %d %d", current->address, init->address);
			freeIfTemp(init);
			current->initialized = true;
		}
		for(int i = initializerList.count; ; ++i) {
			symbol_t *current = getArrayIndex(tab->name, i).symbol;
			if(current == NULL)
				break;
			current->initialized = true;
			assemblyOutput(AFC" %d 0", current->address);
		}
	}

	initializerList.count = 0;
}
| tEQUAL tSTRING_LITTERAL {
	if(lastVarType.baseType != BT_CHAR || lastVarType.indirectionCount != 0) {
		yyerror("Impossible d'affecter une chaîne de caractère à un tableau de ce type.");
	}

	size_t len = strlen($2) + 1;

	if(tabSize >= 0 && tabSize != len) {
		yyerror("Nombre d'éléments dans la liste d'initialisation de %s invalide.", idName);
	}
	else {
		tabSize = len;

		symbol_t *tab = createArray(idName, lastVarType, tabSize);
		symbol_t *current = getArrayIndex(tab->name, 0).symbol;
		for(int i = 0; i < len; ++i, ++current) {
			assemblyOutput(AFC" %d %d", current->address, (int)($2[i]));
			current->initialized = true;
		}
	}
};

TabEnd : Exp tC_BR {
	initializerList.data[initializerList.count++] = dereferenceExp($1);
}
| Exp tCOMMA {
	initializerList.data[initializerList.count++] = dereferenceExp($1);
} TabEnd;

Instrucs :
| Instrucs { lastInstructionIsReturn = false; } Instruc { clearSymbolStack(); };

SwitchInstruc : EndOrError
| tO_BR { pushBlock(); } Instrucs tC_BR { popBlock(); }
| Exp tCOMMA Instruc
| Exp EndOrError
| tID tCOLON {
	addGotoLabel($1);
}
| tGOTO tID EndOrError {
	pushGotoLabel($2);
	assemblyOutput(JMP_UNKNOWN_GOTO" "UNKNOWN_ADDRESS" ; goto %s", $2);
}
| Return EndOrError { lastInstructionIsReturn = true; }
| tIF CondIf Instruc %prec EndIf { popIfLabel(); }
| tIF CondIf Instruc tELSE { pushIfLabelLastButOne(); assemblyOutput(JMP_UNKNOWN_IF" "UNKNOWN_ADDRESS); popIfLabel(); } Instruc { popIfLabel(); }
| tSWITCH tO_P Exp {
	pushSymbol(dereferenceExp($3));
	loopMarkers[loop++] = 0;
	switchStack.caseCount[switchStack.size] = 0;
	switchStack.hasDefault[switchStack.size] = false;
	++switchStack.size;
} tC_P tO_BR SwitchBody tC_BR {
	popSymbol();
	--loop;
	--switchStack.size;

	for(int i = 0; i < loopMarkers[loop]; ++i) {
		popLoopLabel();
	}
}
| tWHILE { pushInstructionCount(); } CondLoop { loopMarkers[loop++] = 0; } Instruc {
	assemblyOutput(JMP" %d", popInstructionCount());
	--loop;
	for(int i = 0; i < loopMarkers[loop] + 1; ++i) {
		popLoopLabel();
	}
}
| tDO {
	pushInstructionCount();
	loopMarkers[loop++] = 0;
} Instruc tWHILE CondLoop EndOrError {
	assemblyOutput(JMP" %d", popInstructionCount());
	--loop;
	for(int i = 0; i < loopMarkers[loop] + 1; ++i) {
		popLoopLabel();
	}
}
| tFOR { pushBlock(); } tO_P ExpOrEmptyOrDef { // Initialisation
	pushInstructionCount();
} ForCondition tSEMI { // Action en fin de boucle
	forConditionReturn = popInstructionCount();
	pushInstructionCount();
} ExpOrEmpty {
	assemblyOutput(JMP" %d", forConditionReturn);
} tC_P {  // Corps de boucle
	popLoopLabel();
	loopMarkers[loop++] = 0;
} Instruc { // Corps de boucle
	assemblyOutput(JMP" %d", popInstructionCount()); // Action de fin de boucle
	--loop;
	for(int i = 0; i < loopMarkers[loop] + 1; ++i) {
		popLoopLabel();
	}
	popBlock();
}
| tBREAK {
	if(loop == 0) {
		yyerror("Le mot clé 'break' doit se trouver dans une boucle ou un bloc switch.");
	}
	++loopMarkers[loop - 1];
	pushLoopLabel();
	assemblyOutput(JMP_UNKNOWN_LOOP" "UNKNOWN_ADDRESS" ; break");
}
| tCONTINUE {
	if(!loop) {
		yyerror("Le mot clé 'continue' doit se trouver dans une boucle.");
	}
	assemblyOutput(JMP" %d ; continue", lastInstructionCount());
};

Instruc : SwitchInstruc
| Def;

SwitchBody :
| tCASE SwitchCase
| tDEFAULT SwitchDefault;

SwitchInstrucs :
| SwitchInstruc SwitchInstrucs;

SwitchCase : tID {
	pushIfLabel();

	if(!isEnumValue($1)) {
		yyerror("L'identificateur '%s' n'est pas une valeur constante.", $1);
	}
	else {
		int val = getEnumValue($1);

		for(int i = 0; i < switchStack.caseCount[switchStack.size - 1]; ++i) {
			if(switchStack.values[switchStack.size - 1][i] == val) {
				yyerror("Le cas '%d' a déjà été traité dans ce bloc switch.", $1);
				break;
			}
		}
		switchStack.values[switchStack.size - 1][switchStack.caseCount[switchStack.size - 1]++] = val;

		symbol_t *valSym = allocTemp(0, BT_INT);
		assemblyOutput(AFC" %d %d ; case %s", valSym->address, val, $1);
		symbol_t *cond = popSymbol();
		symbol_t *eq = binOp(EQU, cond, valSym);
		assemblyOutput(JMF_UNKNOWN_IF" %d "UNKNOWN_ADDRESS, eq->address);
		freeIfTemp(eq);

		pushSymbol(cond);
	}
} tCOLON SwitchInstrucs SwitchNextCase
| tNUMBER {
	pushIfLabel();

	for(int i = 0; i < switchStack.caseCount[switchStack.size - 1]; ++i) {
		if(switchStack.values[switchStack.size - 1][i] == $1) {
			yyerror("Le cas '%d' a déjà été traité dans ce bloc switch.", $1);
			break;
		}
	}
	switchStack.values[switchStack.size - 1][switchStack.caseCount[switchStack.size - 1]++] = $1;

	symbol_t *valSym = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d %d ; case %d", valSym->address, $1, $1);
	symbol_t *cond = popSymbol();
	symbol_t *eq = binOp(EQU, cond, valSym);
	assemblyOutput(JMF_UNKNOWN_IF" %d "UNKNOWN_ADDRESS, eq->address);
	freeIfTemp(eq);

	pushSymbol(cond);
} tCOLON SwitchInstrucs SwitchNextCase;

SwitchDefault : {
	if(switchStack.hasDefault[switchStack.size - 1]) {
		yyerror("Un cas par défaut est déjà présent pour ce bloc switch.");
	}
	switchStack.hasDefault[switchStack.size - 1] = true;
	pushIfLabel();
	assemblyOutput(JMP_UNKNOWN_IF" "UNKNOWN_ADDRESS " ; évitement du cas par défaut");
	pushInstructionCount();
} tCOLON SwitchInstrucs SwitchNextDefault;

SwitchNextCase : EndSwitch
| tCASE { assemblyOutput(JMP" %d ; saut au cas suivant", instructionsCount() + 3); popIfLabel(); } SwitchCase
| tDEFAULT { assemblyOutput(JMP" %d ; saut au cas suivant", instructionsCount() + 2); popIfLabel(); } SwitchDefault;

SwitchNextDefault : {
	++loopMarkers[loop - 1];
	pushLoopLabel();
	assemblyOutput(JMP_UNKNOWN_LOOP" "UNKNOWN_ADDRESS" ; break");
} EndSwitch
| tCASE { assemblyOutput(JMP" %d ; saut au cas suivant", instructionsCount() + 4); popIfLabel(); } SwitchCase
| tDEFAULT { assemblyOutput(JMP" %d ; saut au cas suivant", instructionsCount() + 3); popIfLabel(); } SwitchDefault;

EndSwitch : {
	popIfLabel();
	assemblyOutput(JMP" %d ; cas par défaut", popInstructionCount());
 }

ExpOrEmptyOrDef : EndOrError;
| Exp EndOrError;
| Def;

ExpOrEmpty :
| Exp;

ForCondition : { // Condition vide
	symbol_t *cond = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d 1", cond->address);
	pushLoopLabel();
	assemblyOutput(JMF_UNKNOWN_LOOP" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
	pushLoopLabel();
	assemblyOutput(JMP_UNKNOWN_LOOP" "UNKNOWN_ADDRESS);
}
| Exp { // Condition
	symbol_t *cond = dereferenceExp($1);
	if(isVoid(&cond->type)) {
		yyerror("La condition ne peut pas être de type void.");
	}
	pushLoopLabel();
	assemblyOutput(JMF_UNKNOWN_LOOP" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
	pushLoopLabel();
	assemblyOutput(JMP_UNKNOWN_LOOP" "UNKNOWN_ADDRESS);
};

CondIf : tO_P Exp tC_P {
	symbol_t *cond = dereferenceExp($2);
	if(isVoid(&cond->type)) {
		yyerror("La condition ne peut pas être de type void.");
	}
	pushIfLabel();
	assemblyOutput(JMF_UNKNOWN_IF" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
};

CondLoop : tO_P Exp tC_P {
	symbol_t *cond = dereferenceExp($2);
	if(isVoid(&cond->type)) {
		yyerror("La condition ne peut pas être de type void.");
	}
	pushLoopLabel();
	assemblyOutput(JMF_UNKNOWN_LOOP" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
};

Args :
| ArgsList;

ArgsList : Exp { ++argsStack.argCount[argsStack.size - 1]; pushSymbol(dereferenceExp($1)); }
| ArgsList tCOMMA Exp { ++argsStack.argCount[argsStack.size - 1]; pushSymbol(dereferenceExp($3)); };

Exp : tID {
	dereferencedSymbol_t id = getExistingSymbol($1, true);
	$$ = LDEREF(id.symbol, id.dereferenceCount, true);
}
| tNUMBER {
	symbol_t *s = allocTemp(0, BT_INT);
	s->type.constMask = 1;
	assemblyOutput(AFC" %d %d", s->address, $1);
	$$ = DEREF(s, 0);
}
| tTRUE {
	symbol_t *s = allocTemp(0, BT_INT);
	s->type.constMask = 1;
	assemblyOutput(AFC" %d 1", s->address);
	$$ = DEREF(s, 0);
}
| tFALSE {
	symbol_t *s = allocTemp(0, BT_INT);
	s->type.constMask = 1;
	assemblyOutput(AFC" %d 0", s->address);
	$$ = DEREF(s, 0);
}
| tNULL {
	symbol_t *s = allocTemp(1, BT_VOID);
	s->type.constMask = 1;
	assemblyOutput(AFC" %d 0", s->address);
	$$ = DEREF(s, 0);
}
| tCHAR_LITTERAL {
	symbol_t *s = allocTemp(0, BT_CHAR);
	s->type.constMask = 1;
	assemblyOutput(AFC" %d %d", s->address, (int)($1[0]));
	$$ = DEREF(s, 0);
}
| tSTAR Exp {
	if($2.dereferenceCount + 1 > $2.symbol->type.indirectionCount) {
		yyerror("Impossible de déréférencer %d fois l'expression.", $2.dereferenceCount +1);
	}
	else if($2.symbol->type.baseType == BT_VOID && $2.dereferenceCount + 1 == $2.symbol->type.indirectionCount) {
		yyerror("Impossible de déréférencer une expression de type void.");

	}
	$$ = LDEREF($2.symbol, $2.dereferenceCount + 1, true);
}
| Exp tO_SQBR Exp tC_SQBR {
	symbol_t *symbTab = dereferenceExp($1);
	symbol_t *symbInd = dereferenceExp($3);
	symbol_t *ind, *ind2;
	int indCount = symbTab->type.indirectionCount;

	checkBinOp(ADD, symbTab, symbInd);

	ind2 = allocTemp(indCount, symbTab->type.baseType);
	assemblyOutput(ADD" %d %d %d", ind2->address, symbTab->address, symbInd->address);

	freeIfTemp(symbTab);
	freeIfTemp(symbInd);

	$$ = LDEREF(ind2, 1, $1.lvalue);
}
| tSTRING_LITTERAL {
	$$ = createString($1);
}
| tID tO_P { argsStack.argCount[argsStack.size++] = 0; } Args tC_P {
	function_t *function = getFunction($1);
	symbol_t *returnValue = allocTemp(function->returnType.indirectionCount, function->returnType.baseType);
	callFunction(function, argsStack.argCount[--argsStack.size], returnValue);
	$$ = DEREF(returnValue, 0);
}
| tPRINT tO_P Exp tC_P {
	symbol_t *s = dereferenceExp($3);
	if(isVoid(&s->type)) {
		yyerror("L'expression ne peut pas être de type void.");
	}
	int mode = 0;
	if(s->type.baseType == BT_CHAR && s->type.indirectionCount == 1) {
		mode = 3; // chaîne de caracères
	}
	else if(s->type.baseType == BT_CHAR && s->type.indirectionCount == 0) {
		mode = 2; // caractère
	}
	else if(s->type.indirectionCount > 0) {
		mode = 1; //pointeur
	}
	assemblyOutput(PRI" %d %d", s->address, mode);
	freeIfTemp(s);
	symbol_t *ret = allocTemp(0, BT_VOID);
	DEREF(ret, 0);
}
| tSCAN tO_P Exp tC_P {
	symbol_t *s = dereferenceExp($3);
	symbol_t dummy;
	dummy.type = (varType_t){.constMask = 0, .indirectionCount = 1, .baseType = BT_INT};
	dummy.name = "ptr";
	checkCompatibilityForAffectation(&dummy, s, true);
	assemblyOutput(SCN" %d", s->address);
}
| tAMP Exp {
	if(!$2.lvalue) {
		yyerror("Impossible de prendre l'adresse d'une rvalue.");
	}
	symbol_t *s = $2.symbol;

	if(isVoid(&s->type)) {
		yyerror("Impossible de prendre l'adresse d'une expression de type void.");
	}

	symbol_t *a = allocTemp(s->type.indirectionCount + 1 - $2.dereferenceCount, s->type.baseType);
	a->type.constMask = s->type.constMask;
	assemblyOutput(AFC" %d %d", a->address, s->address);
	assemblyOutput(STK" %d 1", a->address);
	$$ = DEREF(a, 0);
}
| Exp tEQUAL Exp { affectation($1, dereferenceExp($3), false); $$ = DEREF($1.symbol, $1.dereferenceCount); }
| tINCR Exp {
	symbol_t *one = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d 1", one->address);
	$$ = DEREF(binOpEq(ADD, $2, one), 0);
}
| Exp tINCR {
	symbol_t *result = dereferenceExp($1);
	symbol_t *one = allocTemp(0, BT_INT);
	symbol_t *copy = allocTemp(result->type.indirectionCount, result->type.baseType);
	assemblyOutput(COP" %d %d", copy->address, result->address);

	assemblyOutput(AFC" %d 1", one->address);

	binOpEq(ADD, $1, one);
	$$ = DEREF(copy, 0);
}
| tDECR Exp {
	symbol_t *one = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d 1", one->address);
	$$ = DEREF(binOpEq(ADD, $2, one), 0);
}
| Exp tDECR {
	symbol_t *result = dereferenceExp($1);
	symbol_t *one = allocTemp(0, BT_INT);
	symbol_t *copy = allocTemp(result->type.indirectionCount, result->type.baseType);
	assemblyOutput(COP" %d %d", copy->address, result->address);

	assemblyOutput(AFC" %d 1", one->address);

	binOpEq(SOU, $1, one);
	$$ = DEREF(copy, 0);
}
| Exp tPLUS Exp { $$ = DEREF(binOp(ADD, dereferenceExp($1), dereferenceExp($3)), 0); }
| Exp tMINUS Exp { $$ = DEREF(binOp(SOU, dereferenceExp($1), dereferenceExp($3)), 0); }
| Exp tSTAR Exp { $$ = DEREF(binOp(MUL, dereferenceExp($1), dereferenceExp($3)), 0); }
| Exp tDIV Exp { $$ = DEREF(binOp(DIV, dereferenceExp($1), dereferenceExp($3)), 0); }
| Exp tMOD Exp {  $$ = DEREF(modulo(dereferenceExp($1), dereferenceExp($3)), 0); }
| Exp tAMP Exp %prec tBITXOR {  $$ = DEREF(bitand(dereferenceExp($1), dereferenceExp($3)), 0); }
| Exp tBITOR Exp {  $$ = DEREF(bitor(dereferenceExp($1), dereferenceExp($3)), 0); }
| Exp tBITXOR Exp {  $$ = DEREF(bitxor(dereferenceExp($1), dereferenceExp($3)), 0); }
| Exp tSHIFTL Exp { $$ = DEREF(binOp(MUL, dereferenceExp($1), powerOfTwo(dereferenceExp($3))), 0); }
| Exp tSHIFTR Exp { $$ = DEREF(binOp(DIV, dereferenceExp($1), powerOfTwo(dereferenceExp($3))), 0); }
| tMINUS Exp %prec tSTAR {
	symbol_t *tmp = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d -1", tmp->address);
	$$ = DEREF(binOp(MUL, dereferenceExp($2), tmp), 0);
}
| tPLUS Exp %prec tSTAR { $$ = $2; }
| tBITNOT Exp { $$ = DEREF(bitnot(dereferenceExp($2)), 0); }
| tNOT Exp { $$ = DEREF(negate(dereferenceExp($2)), 0); }
| Exp tMODEQ Exp {
	if(isTemp($1.symbol)) {
		yyerror("L'expression doit être une lvalue.");
	}

	affectation($1, modulo($1.symbol, dereferenceExp($3)), false);
	$$ = DEREF($1.symbol, $1.dereferenceCount);
}
| Exp tBITANDEQ Exp {
	if(isTemp($1.symbol)) {
		yyerror("L'expression doit être une lvalue.");
	}

	affectation($1, bitand($1.symbol, dereferenceExp($3)), false);
	$$ = DEREF($1.symbol, $1.dereferenceCount);
}
| Exp tBITOREQ Exp {
	if(isTemp($1.symbol)) {
		yyerror("L'expression doit être une lvalue.");
	}

	affectation($1, bitor($1.symbol, dereferenceExp($3)), false);
	$$ = DEREF($1.symbol, $1.dereferenceCount);
}
| Exp tBITXOREQ Exp {
	if(isTemp($1.symbol)) {
		yyerror("L'expression doit être une lvalue.");
	}

	affectation($1, bitxor($1.symbol, dereferenceExp($3)), false);
	$$ = DEREF($1.symbol, $1.dereferenceCount);
}
| Exp tPLUSEQ Exp { binOpEq(ADD, $1, dereferenceExp($3)); $$ = DEREF($1.symbol, $1.dereferenceCount); }
| Exp tMINUSEQ Exp { binOpEq(SOU, $1, dereferenceExp($3)); $$ = DEREF($1.symbol, $1.dereferenceCount); }
| Exp tDIVEQ Exp { binOpEq(DIV, $1, dereferenceExp($3)); $$ = DEREF($1.symbol, $1.dereferenceCount); }
| Exp tMULEQ Exp { binOpEq(MUL, $1, dereferenceExp($3)); $$ = DEREF($1.symbol, $1.dereferenceCount); }
| Exp tSHIFTLEQ Exp {
	symbol_t *tmp = powerOfTwo(dereferenceExp($3));
	binOpEq(MUL, $1, tmp); $$ = DEREF($1.symbol, $1.dereferenceCount);
}
| Exp tSHIFTREQ Exp {
	symbol_t *tmp = powerOfTwo(dereferenceExp($3));
	binOpEq(DIV, $1, tmp); $$ = DEREF($1.symbol, $1.dereferenceCount);
}

| Exp tAND Exp {
	symbol_t *s = binOp(ADD, toBoolean(dereferenceExp($1)), toBoolean(dereferenceExp($3)));

	symbol_t *deux = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d %d", deux->address, 2);
	$$ = DEREF(binOp(EQU, s, deux), 0);
}
| Exp tOR Exp {
	symbol_t *s = binOp(ADD, toBoolean(dereferenceExp($1)), toBoolean(dereferenceExp($3)));

	symbol_t *zero = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d %d", zero->address, 0);
	$$ = DEREF(binOp(INF, zero, s), 0);
}
| Exp tLESS Exp {
	$$ = DEREF(binOp(INF, dereferenceExp($1), dereferenceExp($3)), 0);
}
| Exp tGREAT Exp {
	$$ = DEREF(binOp(INF, dereferenceExp($3), dereferenceExp($1)), 0);
}
| Exp tLESSEQUAL Exp {
	$$ = DEREF(negate(binOp(INF, dereferenceExp($3), dereferenceExp($1))), 0);
}
| Exp tGREATEQUAL Exp {
	$$ = DEREF(negate(binOp(INF, dereferenceExp($1), dereferenceExp($3))), 0);
}
| Exp tBOOLEQUAL Exp {
	$$ = DEREF(binOp(EQU, dereferenceExp($1), dereferenceExp($3)), 0);
}

| tO_P Exp tC_P { $$ = $2; }
| Exp tDIFF Exp {
	$$ = DEREF(negate(binOp(EQU, dereferenceExp($1), dereferenceExp($3))), 0);
}
| Exp tQUESTION {
	symbol_t *cond = dereferenceExp($1);
	if(isVoid(&cond->type)) {
		yyerror("La condition ne peut pas être de type void.");
	}
	pushIfLabel();
	assemblyOutput(JMF_UNKNOWN_IF" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
} Exp tCOLON {
	symbol_t *exp = dereferenceExp($4);
	symbol_t *ternarySymbol = allocTemp(exp->type.indirectionCount, exp->type.baseType);
	pushSymbol(ternarySymbol);
	assemblyOutput(COP" %d %d", ternarySymbol->address, exp->address);

	pushIfLabelLastButOne();
	assemblyOutput(JMP_UNKNOWN_IF" "UNKNOWN_ADDRESS);
	popIfLabel();
} Exp {
	symbol_t *exp = dereferenceExp($7);
	symbol_t *ternarySymbol = popSymbol();
	if(!sameType(&exp->type, &ternarySymbol->type)) {
		yyerror("Les expressions de la condition ternaire doivent avoir le même type.");
	}
	assemblyOutput(COP" %d %d", ternarySymbol->address, exp->address);
	$$ = DEREF(ternarySymbol, 0);
	popIfLabel();
}
| tSIZEOF Exp {
	symbol_t *s1 = dereferenceExp($2), *s2 = allocTemp(0, BT_INT);
	if(isVoid(&s1->type)) {
		yyerror("Impossible de calculer la taille d'une expression de type void.");
	}
	assemblyOutput(AFC" %d %d", s2->address, getSymbolSize(s1));
	freeIfTemp(s1);

	$$ = DEREF(s2, 0);
}
| tSIZEOF tO_P PureType tC_P {
	if(isVoid(&lastVarType)) {
		yyerror("Impossible de calculer la taille d'une expression de type incomplet.");
	}
	else if(tabSize == -1) {
		yyerror("Impossible de calculer la taille d'une expression de type incomplet.");
	}

	symbol_t *s1 = allocTemp(lastVarType.indirectionCount, lastVarType.baseType), *s2 = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d %d", s2->address, getSymbolSize(s1) * tabSize);
	freeIfTemp(s1);
	$$ = DEREF(s2, 0);
};

%%

int main(int argc, char const **argv) {
#ifdef YACC_DEBUG
	extern int yydebug;
	yydebug = 1;
#endif
	argsStack.size = 0;
	switchStack.size = 0;
	initializerList.count = 0;

	char *outputName = strdup("a.s");

	initSymbols();
	char *buf;
	if(argc > 1) {
		long len = strlen(argv[1]);

		if(len < 3 || argv[1][len - 1] != 'c' || argv[1][len - 2] != '.') {
			fprintf(stderr, "Le fichier doit avoir l'extension \".c\" !\n");
			return INVALID_INVOCATION;
		}
		FILE *f = fopen(argv[1], "rb");
		char *name = strdup(argv[1]);
		name[len - 1] = 's';

		free(outputName);
		outputName = name;

		if(f) {
			fseek(f, 0, SEEK_END);
			len = ftell(f);
			fseek(f, 0, SEEK_SET);
			buf = malloc(len);
			if(buf) {
				fread(buf, 1, len, f);
			}
			fclose(f);
		}

		if(buf) {
			yy_scan_string(buf);
		}
		else {
			compilerError("Impossible de lire le fichier \"%s\".", argv[1]); // noreturn
		}
	}

	initAssemblyOutput(outputName);

	yyparse();
	free(buf);

	closeAssemblyOutput(outputName);
	free(outputName);
	cleanSymbols();
	cleanEnums();

	if(errorsOccurred() > 0) {
		fprintf(stderr, "Des erreurs sont survenues durant la compilation. Abandon.\n");
		return COMPILATION_FAILURE;
	}

	return 0;
}
