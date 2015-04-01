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

	#define YYERROR_VERBOSE

	#define MAX_INITIALIZER 2048

	typedef struct yy_buffer_state *YY_BUFFER_STATE;

	int yylex();
	YY_BUFFER_STATE yy_scan_string(const char *yy_str);

	extern int const lineNumber;
	static int retourConditionFor;
	static int paramsCount;
	static bool lastInstructionIsReturn = false;
	static varType_t lastVarType, returnValueType;
	static char const *funcName = NULL;

	function_t *currentFunction = NULL;

	static struct {
		int data[MAX_INITIALIZER];
		int count;
	} initializerList;

	%}

%union {
	int nb;
	char const *string;
	struct dereferencedID_t dereferencedID;
	varType_t varType;
}

%token <nb> tNOMBRE
%token <string> tID
%token <string> tSTRING

%type <dereferencedID> DereferencedID
%type <varType> Type

%token tPO tPF tVIR tBO tBF tCRO tCRF
%token tINT tCONST tVOID tTRUE tFALSE
%token tINCR tDECR
%token tPLUSEQ tMOINSEQ tDIVEQ tMULEQ tMODEQ tEGAL
%token tPLUS tMOINS tDIV tSTAR tMOD
%token tBOOLEGAL tINFEGAL tSUPEGAL tSUP tINF tET tOU tDIFF

%token tNULL
%token tAMP

%token tF

%token tRETURN tPRINTF
%token tIF tELSE tWHILE tFOR tDO

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
| Corps Type {
	paramsCount = 0;
	returnValueType = $2;
} tID tPO Params tPF { funcName = $4; } FonctionEnd;

FonctionEnd : { createFunction(&returnValueType, funcName, false, paramsCount); } tF
| { createFunction(&returnValueType, funcName, true, paramsCount); } CorpsFonction { currentFunction = NULL; };

CorpsFonction : tBO Defs Instrucs tBF {
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

Defs :
| Defs Def;

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
};

TypedDefNext : tF
| tVIR TypedDef
        
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
| tID tCRO tNOMBRE tCRF {
	createTable($1, lastVarType, $3);
} TypedDefNext ; //TODO

Instrucs:
| Instrucs { lastInstructionIsReturn = false; } Instruc { clearSymbolStack(); };

Instruc : tF
| tBO { pushBlock(); } Defs Instrucs tBF { popBlock(); }
| Exp tVIR Instruc
| Exp tF
| Return tF { lastInstructionIsReturn = true; }
| tIF Cond Instruc %prec EndIf { popLabel(); }
| tIF Cond Instruc tELSE { pushLabelLastButOne(); assemblyOutput(JMP_UNKNOWN" "UNKNOWN_ADDRESS); popLabel(); } Instruc { popLabel(); }
| tWHILE { pushInstructionCount(); } Cond Instruc {
	assemblyOutput(JMP" %d", popInstructionCount());
	popLabel();
}
| tDO { pushInstructionCount(); } Instruc tWHILE Cond tF { assemblyOutput(JMP" %d", popInstructionCount()); popLabel(); }

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
	popLabel();
} Instruc { // Corps de boucle
	assemblyOutput(JMP" %d", popInstructionCount()); // Action de fin de boucle
	popLabel();
	popBlock();
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

ForCondition : { // Condition
	symbol_t *cond = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d 1", cond->address);
	pushLabel();
	assemblyOutput(JMF_UNKNOWN" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
	pushLabel();
	assemblyOutput(JMP_UNKNOWN" "UNKNOWN_ADDRESS);
}
| Exp { // Condition
	symbol_t *cond = popSymbol();
	if(isVoid(&cond->type)) {
		yyerror("La condition ne peut pas être de type void.");
	}
	pushLabel();
	assemblyOutput(JMF_UNKNOWN" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
	pushLabel();
	assemblyOutput(JMP_UNKNOWN" "UNKNOWN_ADDRESS);
};

DereferencedID : tSTAR DereferencedID { $$ = (dereferencedID_t){.symbol = $2.symbol, .dereferenceCount = $2.dereferenceCount + 1}; }
| tID { $$ = (dereferencedID_t){.symbol = getExistingSymbol($1, true), .dereferenceCount = 0}; } ;
| Exp tCRO Exp tCRF { 
	symbol_t * symbInd = popSymbol(), *ind, *ind2;
	symbol_t * symbTab = popSymbol() ;
	
	ind2 = allocTemp(symbTab->type.indirectionCount, symbTab->type.baseType);
	assemblyOutput(ADD" %d %d %d", ind2->address, symbTab->address, symbInd->address) ;
		
	ind = allocTemp(symbTab->type.indirectionCount - 1, symbTab->type.baseType);
	assemblyOutput(DR2" %d %d", ind->address, ind2->address);
	freeIfTemp(ind2);
	ind2 = ind;
	

	freeIfTemp(symbInd) ;
	freeIfTemp(symbTab) ;
	$$ = (dereferencedID_t){.symbol = ind2, .dereferenceCount = 0 };  } ; //TODO
	
Terme :  tNOMBRE {
	symbol_t *s = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d %d", s->address, $1);
	pushSymbol(s);
}
| DereferencedID {
	symbol_t *s = $1.symbol;

	if(!s->initialized) {
		yyerror("Variable %s non initialisée avant utilisation!", $1);
	}

	if($1.dereferenceCount == 0) {
		pushSymbol(s);
	}
	else {
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
	int ind = -1;
	symbol_t *s = allocTemp(ind, BT_VOID);
	pushSymbol(s);
	assemblyOutput(AFC" %d 0", s->address);
}
| tSTRING {
	int len = strlen($1) + 1;
	char *interningName;
	asprintf(&interningName, "__internedString__%s", $1);

	symbol_t *tab = getExistingSymbol(interningName, false);
	if(tab == NULL) {
		tab = createTable(interningName, (varType_t){.indirectionCount = 0, .baseType = BT_CHAR, .constMask = 1}, len);
		for(int i = 0; i < len; ++i) {
			assemblyOutput(AFC" %d %d", tab->address + i, $1[i]);
		}
	}

	free(interningName);
};

Cond : tPO Exp tPF {
	symbol_t *cond = popSymbol();
	if(isVoid(&cond->type)) {
		yyerror("La condition ne peut pas être de type void.");
	}
	pushLabel();
	assemblyOutput(JMF_UNKNOWN" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
} ;

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
	assemblyOutput(PRI" %d", s->address);
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
	pushSymbol(a);
}
| DereferencedID tEGAL Exp { affectation($1, false); }
| tINCR DereferencedID {
	symbol_t *one = allocTemp(0, BT_INT), *result = $2.symbol;
	assemblyOutput(AFC" %d 1", one->address);
	assemblyOutput(ADD" %d %d %d", result->address, result->address, one->address);
	pushSymbol(result);
}
| DereferencedID tINCR {
	symbol_t *one = allocTemp(0, BT_INT), *result = $1.symbol;
	symbol_t *copy = allocTemp(result->type.indirectionCount, result->type.baseType);
	assemblyOutput(COP" %d %d", copy->address, result->address);
	assemblyOutput(AFC" %d 1", one->address);
	assemblyOutput(ADD" %d %d %d", result->address, result->address, one->address);
	pushSymbol(copy);
}
| tDECR DereferencedID {
	symbol_t *one = allocTemp(0, BT_INT), *result = $2.symbol;
	assemblyOutput(AFC" %d 1", one->address);
	assemblyOutput(SOU" %d %d %d", result->address, result->address, one->address);
	pushSymbol(result);
}
| DereferencedID tDECR {
	symbol_t *one = allocTemp(0, BT_INT), *result = $1.symbol;
	symbol_t *copy = allocTemp(result->type.indirectionCount, result->type.baseType);
	assemblyOutput(COP" %d %d", copy->address, result->address);
	assemblyOutput(AFC" %d 1", one->address);
	assemblyOutput(SOU" %d %d %d", result->address, result->address, one->address);
	pushSymbol(copy);
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
	pushSymbol(zero);
	binOp(SUP);
}
| Exp tINF Exp { binOp(INF); }
| Exp tSUP Exp { binOp(SUP); }
| Exp tINFEGAL Exp {
	binOp(SUP);
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
