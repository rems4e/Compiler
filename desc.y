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

	#define YYERROR_VERBOSE

	#define MAX_INITIALIZER 2048

	typedef struct yy_buffer_state *YY_BUFFER_STATE;

	int yylex();
	YY_BUFFER_STATE yy_scan_string(const char *yy_str);

	extern int const lineNumber;
	static int retourConditionFor;
	static int paramsCount;
	static int tabSize;
	static bool lastInstructionIsReturn = false;
	static int loop = 0;
	static varType_t lastVarType, returnValueType;
	static char const *idName = NULL;

	function_t *currentFunction = NULL;

	static struct {
		symbol_t *data[MAX_INITIALIZER];
		int count;
	} initializerList;

	static int loopMarkers[MAX_NESTING];

	%}

%union {
	int nb;
	char const *string;
	struct dereferencedID_t dereferencedID;
	varType_t varType;
}

%token <nb> tNOMBRE
%token <string> tID
%token <string> tSTRING_LITTERAL
%token <string> tCHAR_LITTERAL

%type <dereferencedID> DereferencedID
%type <varType> Type

%token tPO tPF tVIR tBO tBF tCRO tCRF
%token tCONST tINT tCHAR tCONSTC tVOID
%token tINCR tDECR
%token tPLUSEQ tMOINSEQ tDIVEQ tMULEQ tMODEQ tEGAL
%token tPLUS tMOINS tDIV tSTAR tMOD
%token tBOOLEGAL tINFEGAL tSUPEGAL tSUP tINF tET tOU tDIFF

%token tNULL tTRUE tFALSE
%token tAMP

%token tF

%token tRETURN tPRINTF
%token tIF tELSE tWHILE tFOR tDO tBREAK tCONTINUE

%right tPLUSEQ tMOINSEQ tDIVEQ tMULEQ tMODEQ tEGAL

%left tBOOLEGAL tINFEGAL tSUPEGAL tSUP tINF tDIFF
%left tET
%left tOU

%left tPLUS tMOINS
%left tDIV tSTAR tMOD

%left tCRO tCRF

%nonassoc EndIf
%nonassoc tELSE

%start Corps

%%

Corps :
| Corps DefCorps;

DefCorps : Def
| Type tID tPO {
	paramsCount = 0;
	returnValueType = $1;
} Params tPF { idName = $2; } FonctionEnd;

FonctionEnd : { createFunction(&returnValueType, idName, false, paramsCount); } tF
| { pushBlock(); setGlobalScope(false); createFunction(&returnValueType, idName, true, paramsCount); pushBlock(); setGlobalScope(false); } CorpsFonction { currentFunction = NULL; popBlock(); setGlobalScope(true); };

CorpsFonction : tBO Instrucs tBF {
	if(!lastInstructionIsReturn && !isVoid(&currentFunction->returnType)) {
		yyerror("Une valeur de retour est obligatoire à la fin d'une fonction ne retournant pas void.");
	}
	else if(!lastInstructionIsReturn) {
		assemblyOutput(RET" ; Retour à la fonction appelante");
	}
};

Return : tRETURN ReturnValue;

ReturnValue : Exp {
	symbol_t *returnValue = popSymbol();

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
| ParamsList tVIR Param;

Param : Type tID { ++paramsCount; pushParam($2, $1); };

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
};

TypedDefNext : tF
| tVIR TypedDef;
        
TypedDef : tID {
	if(topLevelConst(&lastVarType)) {
		yyerror("La constante %s n'est pas initialisée.", $1);
	}
	else if(isVoid(&lastVarType)) {
		yyerror("Impossible de déclarer une variable de type void.");
	}
	createSymbol($1, lastVarType);
} TypedDefNext
| tID tEGAL Exp {
	if(isVoid(&lastVarType)) {
		yyerror("Impossible de déclarer une variable de type void.");
	}
	symbol_t *s = createSymbol($1, lastVarType);
	affectation((dereferencedID_t){.symbol = s, .dereferenceCount = 0}, true);
} TypedDefNext
| Tab TabDef TypedDefNext;

Tab :  tID tCRO tNOMBRE tCRF {
	if($3 < 0) {
		yyerror("Impossible de créer un tableau de dimension négative.");
	}

	tabSize = $3;
	idName = $1;
}
| tID tCRO tCRF {
	tabSize = -1;
	idName = $1;
};

TabDef : {
	if(tabSize == -1) {
		yyerror("Un tableau dont la dimension n'a pas été spécifiée doit être initialisé.");
	}
	else {
		symbol_t *symTab = createTable(idName, lastVarType, tabSize);
	}
}
| tEGAL tBO FinTab {
	if(tabSize == -1) {
		tabSize = initializerList.count;
	}
	symbol_t *tab = createTable(idName, lastVarType, tabSize);

	symbol_t *last = getTabIndex(tab->name, initializerList.count - 1).symbol;
	if(last == NULL) {
		yyerror("Trop d'éléments dans la liste d'initialisation de %s.", tab->name);
	}
	else {
		symbol_t *current = getTabIndex(tab->name, 0).symbol;
		for(int i = 0; i < initializerList.count; ++i, ++current) {
			symbol_t *init = initializerList.data[i];
			assemblyOutput(COP" %d %d", current->address, init->address);
			freeIfTemp(init);
			current->initialized = true;
		}
		for(int i = initializerList.count; ; ++i) {
			symbol_t *current = getTabIndex(tab->name, i).symbol;
			if(current == NULL)
				break;
			current->initialized = true;
			assemblyOutput(AFC" %d 0", current->address);
		}
	}

	initializerList.count = 0;
}
| tEGAL tSTRING_LITTERAL {
	if(lastVarType.baseType != BT_CHAR || lastVarType.indirectionCount != 0) {
		yyerror("Impossible d'affecter une chaîne de caractère à un tableau de ce type.");
	}

	size_t len = strlen($2) + 1;

	if(tabSize >= 0 && tabSize != len) {
		yyerror("Nombre d'éléments dans la liste d'initialisation de %s invalide.", idName);
	}
	else {
		tabSize = len;

		symbol_t *tab = createTable(idName, lastVarType, tabSize);
		symbol_t *current = getTabIndex(tab->name, 0).symbol;
		for(int i = 0; i < len; ++i, ++current) {
			assemblyOutput(AFC" %d %d", current->address, (int)($2[i]));
			current->initialized = true;
		}
	}
};

FinTab : Exp tBF {
	initializerList.data[initializerList.count++] = popSymbol();
}
| Exp tVIR {
	initializerList.data[initializerList.count++] = popSymbol();
} FinTab;

Instrucs :
| Instrucs { lastInstructionIsReturn = false; } Instruc { clearSymbolStack(); };

Instruc : tF
| Def
| tBO { pushBlock(); } Instrucs tBF { popBlock(); }
| Exp tVIR Instruc
| Exp tF
| Return tF { lastInstructionIsReturn = true; }
| tIF CondIf Instruc %prec EndIf { popIfLabel(); }
| tIF CondIf Instruc tELSE { pushIfLabelLastButOne(); assemblyOutput(JMP_UNKNOWN_IF" "UNKNOWN_ADDRESS); popIfLabel(); } Instruc { popIfLabel(); }
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
} Instruc tWHILE CondLoop tF {
	assemblyOutput(JMP" %d", popInstructionCount());
	--loop;
	for(int i = 0; i < loopMarkers[loop] + 1; ++i) {
		popLoopLabel();
	}
}
| tFOR { pushBlock(); } tPO ExpOrEmptyOrDef { // Initialisation
	freeIfTemp(popSymbol());
	pushInstructionCount();
} ForCondition tF { // Action en fin de boucle
	retourConditionFor = popInstructionCount();
	pushInstructionCount();
} ExpOrEmpty {
	freeIfTemp(popSymbol());
	assemblyOutput(JMP" %d", retourConditionFor);
} tPF {  // Corps de boucle
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
	if(!loop) {
		yyerror("Le mot clé break doit se trouver dans une boucle.");
	}
	++loopMarkers[loop - 1];
	pushLoopLabel();
	assemblyOutput(JMP_UNKNOWN_LOOP" "UNKNOWN_ADDRESS" ; Break");
}
| tCONTINUE {
	if(!loop) {
		yyerror("Le mot clé continue doit se trouver dans une boucle.");
	}
	assemblyOutput(JMP" %d ; Continue", lastInstructionCount());
};

ExpOrEmptyOrDef : tF {
	pushSymbol(allocTemp(0, BT_VOID));
}
| Exp tF
| Def;

ExpOrEmpty : {
	pushSymbol(allocTemp(0, BT_VOID));
}
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
	symbol_t *cond = popSymbol();
	if(isVoid(&cond->type)) {
		yyerror("La condition ne peut pas être de type void.");
	}
	pushLoopLabel();
	assemblyOutput(JMF_UNKNOWN_LOOP" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
	pushLoopLabel();
	assemblyOutput(JMP_UNKNOWN_LOOP" "UNKNOWN_ADDRESS);
};

CondIf : tPO Exp tPF {
	symbol_t *cond = popSymbol();
	if(isVoid(&cond->type)) {
		yyerror("La condition ne peut pas être de type void.");
	}
	pushIfLabel();
	assemblyOutput(JMF_UNKNOWN_IF" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
};

CondLoop : tPO Exp tPF {
	symbol_t *cond = popSymbol();
	if(isVoid(&cond->type)) {
		yyerror("La condition ne peut pas être de type void.");
	}
	pushLoopLabel();
	assemblyOutput(JMF_UNKNOWN_LOOP" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
};

DereferencedID : tSTAR DereferencedID { $$ = (dereferencedID_t){.symbol = $2.symbol, .dereferenceCount = $2.dereferenceCount + 1}; }
| tID {
	dereferencedID_t id = getExistingSymbol($1, true);
	$$ = (dereferencedID_t){.symbol = id.symbol, .dereferenceCount = id.dereferenceCount};
	pushSymbol(id.symbol);
}
| tPO Exp tPF {
	symbol_t *s = popSymbol();
	$$ = (dereferencedID_t){.symbol = s, .dereferenceCount = 0};
	pushSymbol(s);
}
| Exp tCRO Exp tCRF {
	symbol_t *symbInd = popSymbol(), *ind, *ind2;
	symbol_t * symbTab = popSymbol() ;
	int indCount = symbTab->type.indirectionCount;

	checkBinOp(ADD, symbTab, symbInd);

	ind2 = allocTemp(indCount, symbTab->type.baseType);
	assemblyOutput(ADD" %d %d %d", ind2->address, symbTab->address, symbInd->address);

	freeIfTemp(symbTab);
	freeIfTemp(symbInd);
	
	$$ = (dereferencedID_t){.symbol = ind2, .dereferenceCount = 1};
	pushSymbol(ind2);
}
| tSTRING_LITTERAL {
	dereferencedID_t id = createString($1);
	$$ = id;
	pushSymbol(id.symbol);
};
	
Terme :  tNOMBRE {
	symbol_t *s = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d %d", s->address, $1);
	pushSymbol(s);
}
| DereferencedID {
	symbol_t *s = $1.symbol;
	if(!s->initialized && !isTemp(s)) {
		yyerror("Variable %s non initialisée avant utilisation!", $1);
	}

	if($1.dereferenceCount > 0) {
		popSymbol();
		if ($1.dereferenceCount > s->type.indirectionCount){
			yyerror("Impossible de déréférencer l'expresion %d fois.", $1.dereferenceCount);
		}
		else {
			symbol_t *ind;

			for(int i = 0; i < $1.dereferenceCount; ++i) {
				ind = allocTemp(s->type.indirectionCount - 1, $1.symbol->type.baseType);
				assemblyOutput(DR2" %d %d", ind->address, s->address);
				freeIfTemp(s);
				s = ind;
			}
			pushSymbol(ind);

			if(isVoid(&ind->type)) {
				yyerror("L'expression ne peut pas être de type void.");
			}
		}
		
	}
}
| Bool
| tNULL {
	symbol_t *s = allocTemp(1, BT_VOID);
	pushSymbol(s);
	assemblyOutput(AFC" %d 0", s->address);
}
| tCHAR_LITTERAL {
	symbol_t *s = allocTemp(0, BT_CHAR);
	assemblyOutput(AFC" %d %d", s->address, (int)($1[0]));
	pushSymbol(s);
};


Bool: tTRUE {
	symbol_t *s = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d 1", s->address);
	pushSymbol(s);
}
| tFALSE {
	symbol_t *s = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d 0", s->address);
	pushSymbol(s);
};

Args :
| ArgsList;

ArgsList : Exp { ++paramsCount; }
| ArgsList tVIR Exp { ++paramsCount; };

Exp : Terme
| tID tPO { paramsCount = 0; } Args tPF {
	function_t *function = getFunction($1);
	symbol_t *returnValue = allocTemp(function->returnType.indirectionCount, function->returnType.baseType);
	callFunction(function, paramsCount, returnValue);
	pushSymbol(returnValue);
}
| tPRINTF tPO Exp tPF {
	symbol_t *s = popSymbol();
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
	pushSymbol(ret);
}
| tAMP DereferencedID {
	symbol_t *s = $2.symbol;

	if(isVoid(&s->type)) {
		yyerror("Impossible de prendre l'adresse d'une expression de type void.");
	}

	symbol_t *a = allocTemp(s->type.indirectionCount + 1 - $2.dereferenceCount, s->type.baseType);
	assemblyOutput(AFC" %d %d", a->address, s->address);
	assemblyOutput(ABS" %d", a->address);
	pushSymbol(a);
}
| DereferencedID tEGAL Exp { affectation($1, false); }
| tINCR DereferencedID {
	symbol_t *one = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d 1", one->address);
	pushSymbol(one);
	binOpEq(ADD, $2);
}
| DereferencedID tINCR {
	symbol_t *one = allocTemp(0, BT_INT), *result = popSymbol();
	symbol_t *copy = allocTemp(result->type.indirectionCount, result->type.baseType);

	assemblyOutput(AFC" %d 1", one->address);
	pushSymbol(result);
	affectation((dereferencedID_t){.symbol = copy, .dereferenceCount = 0}, false);

	pushSymbol(one);
	binOpEq(ADD, $1);
	popSymbol();
}
| tDECR DereferencedID {
	symbol_t *one = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d 1", one->address);
	pushSymbol(one);
	binOpEq(SOU, $2);
}
| DereferencedID tDECR {
	symbol_t *one = allocTemp(0, BT_INT), *result = popSymbol();
	symbol_t *copy = allocTemp(result->type.indirectionCount, result->type.baseType);

	assemblyOutput(AFC" %d 1", one->address);
	pushSymbol(result);
	affectation((dereferencedID_t){.symbol = copy, .dereferenceCount = 0}, false);

	pushSymbol(one);
	binOpEq(SOU, $1);
	popSymbol();
}
| Exp tPLUS Exp { binOp(ADD); }
| Exp tMOINS Exp { binOp(SOU); }
| Exp tSTAR Exp { binOp(MUL); }
| Exp tDIV Exp { binOp(DIV); }
| Exp tMOD Exp { modulo(); }
| DereferencedID tMODEQ Exp {
	symbol_t *sym = $1.symbol;
	symbol_t *sym2 = popSymbol();
	pushSymbol(sym);
	pushSymbol(sym2);
	modulo();
	affectation($1, false);
}

| DereferencedID tPLUSEQ Exp { binOpEq(ADD, $1); }
| DereferencedID tMOINSEQ Exp { binOpEq(SOU, $1); }
| DereferencedID tDIVEQ Exp { binOpEq(DIV, $1); }
| DereferencedID tMULEQ Exp { binOpEq(MUL, $1); }

| Exp tET Exp {
	toBoolean();
	symbol_t *op2 = popSymbol();
	toBoolean();
	symbol_t *op1 = popSymbol();

	pushSymbol(op1);
	pushSymbol(op2);
	binOp(ADD);

	symbol_t *deux = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d %d", deux->address, 2);
	pushSymbol(deux);
	binOp(EQU);
}
| Exp tOU Exp {
	toBoolean();
	symbol_t *op2 = popSymbol();
	toBoolean();
	symbol_t *op1 = popSymbol();

	pushSymbol(op1);
	pushSymbol(op2);
	binOp(ADD);

	symbol_t *zero = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d %d", zero->address, 0);
	symbol_t *s = popSymbol();
	pushSymbol(zero);
	pushSymbol(s);
	binOp(INF);
}
| Exp tINF Exp { binOp(INF); }
| Exp tSUP Exp {
	symbol_t *s1 = popSymbol(), *s2 = popSymbol();
	pushSymbol(s1), pushSymbol(s2);
	binOp(INF);
}
| Exp tINFEGAL Exp {
	symbol_t *s1 = popSymbol(), *s2 = popSymbol();
	pushSymbol(s1), pushSymbol(s2);
	binOp(INF);
	negate();
}
| Exp tSUPEGAL Exp {
	binOp(INF);
	negate();
}
| Exp tBOOLEGAL Exp { binOp(EQU); }

| tPO Exp tPF
| Exp tDIFF Exp {
	binOp(EQU);
	negate();
}

%%

void yyerror(const char *s, ...) {
	va_list args;
	va_start(args, s);

	fprintf(stderr, "Erreur ligne %d : ", lineNumber);
	vfprintf(stderr, s, args);
	fputc('\n', stderr);

	va_end(args);

	exit(1);
}

int main(int argc, char const **argv) {
#ifdef YACC_DEBUG
	extern int yydebug;
	yydebug = 1;
#endif

	initializerList.count = 0;

	char *outputName = strdup("a.s");

	initSymbols();
	char *buf;
	if(argc > 1) {
		long len = strlen(argv[1]);

		if(len < 3 || argv[1][len - 1] != 'c' || argv[1][len - 2] != '.') {
			fprintf(stderr, "Le fichier doit avoir l'extension \".c\" !\n");
			return 1;
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
			return 1;
		}
	}

	initAssemblyOutput(outputName);
	free(outputName);

	yyparse();
	free(buf);

	closeAssemblyOutput();
	cleanSymbols();

	return 0;
}
