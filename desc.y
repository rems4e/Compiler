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

	typedef struct yy_buffer_state *YY_BUFFER_STATE;

	int yylex();
	YY_BUFFER_STATE yy_scan_string(const char *yy_str);

	extern int const lineNumber;
	static int retourConditionFor;
	static int paramsCount;
	static bool lastInstructionIsReturn = false;
	static varType_t lastVarType, returnValueType;
	static char const *funcName;

	function_t *currentFunction = NULL;

	void affectation(dereferencedID_t id, bool allowConst) {
		symbol_t *sym = getExistingSymbol(id.name);
		symbol_t *val = popSymbol();

		if(id.dereferenceCount > 0) {
			symbol_t *temp;
			for(int i = 0; i < id.dereferenceCount - 1; ++i) {
				temp = allocTemp(sym->type.indirectionCount - 1, sym->type.baseType);
				assemblyOutput(DR2" %d %d", temp->address, sym->address);

				freeIfTemp(sym);
				sym = temp;
			}
			symbol_t cop = *sym;
			--cop.type.indirectionCount;
			checkCompatibilityForAffectation(&cop, val, allowConst);
			assemblyOutput(DR1" %d %d ; %s", sym->address, val->address);
		}
		else {
			checkCompatibilityForAffectation(sym, val, allowConst);
			assemblyOutput(COP" %d %d ; %s", sym->address, val->address, id.name);
		}

		freeIfTemp(val);
		freeIfTemp(sym);
		sym->initialized = true;
	}

	void checkBinOp(char const *op, symbol_t const *s1, symbol_t const *s2) {
		if(isVoid(&s1->type) || isVoid(&s2->type)) {
			yyerror("Les opérandes ne peuvent pas être de type void.");
		}
		else if(op == EQU || op == INF || op == SUP) {
			checkIndirectionLevel(s1, s2);
		}
		else if(op == SOU) {
			if(s1->type.indirectionCount != s2->type.indirectionCount && s2->type.indirectionCount > 0) {
				yyerror("Opérandes invalide pour l'opérateur de soustraction");
			}
		}
		else if(op == ADD) {
			checkScalar(s2);
		}
		else if(op == MUL || op == DIV) {
			checkScalar(s1);
			checkScalar(s2);
		}
	}

	void binOp(char const *op) {
		symbol_t *s2 = popSymbol();
		symbol_t *s1 = popSymbol();

		checkBinOp(op, s1, s2);

		symbol_t *res = allocTemp(s1->type.indirectionCount, s1->type.baseType);
		pushSymbol(res);

		assemblyOutput("%s %d %d %d", op, res->address, s1->address, s2->address);
		freeIfTemp(s2);
		freeIfTemp(s1);
	}

	void binOpEq(char const *op, dereferencedID_t id) {
		symbol_t *r = getExistingSymbol(id.name);
		symbol_t *s = popSymbol();

		if(id.dereferenceCount > 0) {
			symbol_t *ind;
			for(int i = 0; i < id.dereferenceCount; ++i) {
				ind = allocTemp(r->type.indirectionCount - 1, r->type.baseType);
				assemblyOutput(DR2" %d %d", ind->address, r->address);
				freeIfTemp(r);
				r = ind;
			}

			pushSymbol(ind);
			pushSymbol(s);
			binOp(op);
			affectation(id, false);
		}
		else {
			checkBinOp(op, r, s);
			checkScalar(s);
			assemblyOutput("%s %d %d %d", op, r->address, r->address, s->address);
		}

		pushSymbol(r);
		freeIfTemp(s);
	}

	void negate() {
		symbol_t *zero = allocTemp(0, BT_INT);
		assemblyOutput(AFC" %d %d ; negate", zero->address, 0);

		pushSymbol(zero);
		binOp(EQU);
	}

	void toBoolean() {
		negate();
		negate();
	}

	%}

%union {
	int nb;
	char const *var;
	struct dereferencedID_t dereferencedID;
	varType_t varType;
}

%token <nb> tNOMBRE
%token <var> tID

%type <dereferencedID> DereferencedID
%type <varType> Type

%token tPO tPF tVIR tBO tBF
%token tINT tCONST tVOID tTRUE tFALSE
%token tINCR tDECR
%token tPLUSEQ tMOINSEQ tDIVEQ tMULEQ tEGAL
%token tPLUS tMOINS tDIV tSTAR
%token tBOOLEGAL tINFEGAL tSUPEGAL tSUP tINF tET tOU tDIFF

%token tNULL
%token tAMP

%token tF
%token tRETURN tPRINTF
%token tIF tELSE tWHILE tFOR tDO

%right tPLUSEQ tMOINSEQ tDIVEQ tMULEQ tEGAL

%left tBOOLEGAL tINFEGAL tSUPEGAL tSUP tINF tDIFF
%left tET
%left tOU

%left tPLUS tMOINS
%left tDIV tSTAR

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
	createSymbol($1, lastVarType);
	affectation((dereferencedID_t){.name = $1, .dereferenceCount = 0}, true);
} TypedDefNext;

Instrucs:
| Instrucs { lastInstructionIsReturn = false; } Instruc { clearSymbolStack(); };

Instruc : tF
| Exp tVIR Instruc
| Exp tF
| Return tF { lastInstructionIsReturn = true; }
| tIF Cond tBO Instrucs tBF { popLabel(); }
| tIF Cond tBO Instrucs tBF { pushLabelLastButOne(); assemblyOutput(JMP_UNKNOWN" "UNKNOWN_ADDRESS); } tELSE tBO { popLabel(); } Instrucs tBF { popLabel(); }
| tWHILE { pushInstructionCount(); } Cond tBO Instrucs FinWhile
| tDO { pushInstructionCount(); } tBO Instrucs tBF tWHILE Cond tF { assemblyOutput(JMP" %d", popInstructionCount()); popLabel(); }

| tFOR tPO Exp { // Initialisation
	pushInstructionCount();
} tF Exp { // Condition
	symbol_t *cond = popSymbol();
	if(isVoid(&cond->type)) {
		yyerror("La condition ne peut pas être de type void.");
	}
	pushLabel();
	assemblyOutput(JMF_UNKNOWN" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
	pushLabel();
	assemblyOutput(JMP_UNKNOWN" "UNKNOWN_ADDRESS);
} tF { // Action en fin de boucle
	retourConditionFor = popInstructionCount();
	pushInstructionCount();
} Exp {
	assemblyOutput(JMP" %d", retourConditionFor);
} tPF tBO {  // Corps de boucle
	popLabel();
} Instrucs { // Corps de boucle
	assemblyOutput(JMP" %d", popInstructionCount()); // Action de fin de boucle
} tBF {
	popLabel();
}

| tPRINTF tPO Exp tPF tF {
	symbol_t *s = popSymbol();
	if(isVoid(&s->type)) {
		yyerror("L'expression ne peut pas être de type void.");
	}
	assemblyOutput(PRI" %d", s->address);
	freeIfTemp(s);
};

FinWhile : tBF {
	assemblyOutput(JMP" %d", popInstructionCount());
	popLabel();
};

DereferencedID : tSTAR DereferencedID { $$ = (dereferencedID_t){.name = $2.name, .dereferenceCount = $2.dereferenceCount + 1}; }
| tID { $$ = (dereferencedID_t){.name = $1, .dereferenceCount = 0}; };

Terme :  tNOMBRE {
	symbol_t *s = allocTemp(0, BT_INT);
	assemblyOutput(AFC" %d %d", s->address, $1);
	pushSymbol(s);
}
| DereferencedID {
	symbol_t *s = getExistingSymbol($1.name);

	if(!s->initialized) {
		yyerror("Variable %s non initialisée avant utilisation!", $1);
	}

	if($1.dereferenceCount == 0) {
		pushSymbol(s);
	}
	else {
		if($1.dereferenceCount > s->type.indirectionCount) {
			yyerror("Impossible de déréférencer l'expression %d fois.", $1.dereferenceCount);
		}
		symbol_t *ind;
		for(int i = 0; i < $1.dereferenceCount; ++i) {
			ind = allocTemp(s->type.indirectionCount - 1, s->type.baseType);
			assemblyOutput(DR2" %d %d", ind->address, s->address);
			freeIfTemp(s);
			s = ind;
		}

		if(isVoid(&ind->type)) {
			yyerror("L'expression ne peut pas être de type void.");
		}

		pushSymbol(ind);
	}
}
| Bool
| tNULL {
	int ind = -1;
	symbol_t *s = allocTemp(ind, BT_VOID);
	pushSymbol(s);
	assemblyOutput(AFC" %d 0", s->address);
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
| tAMP DereferencedID {
	symbol_t *s = getExistingSymbol($2.name);

	if(isVoid(&s->type)) {
		yyerror("Impossible de prendre l'adresse d'une expression de type void.");
	}

	symbol_t *a = allocTemp(s->type.indirectionCount + 1 - $2.dereferenceCount, s->type.baseType);
	assemblyOutput(AFC" %d %d", a->address, s->address);
	pushSymbol(a);
}
| DereferencedID tEGAL Exp { affectation($1, false); }
| tINCR DereferencedID {
	symbol_t *one = allocTemp(0, BT_INT), *result = getExistingSymbol($2.name);
	assemblyOutput(AFC" %d 1", one->address);
	assemblyOutput(ADD" %d %d %d", result->address, result->address, one->address);
	pushSymbol(result);
}
| DereferencedID tINCR {
	symbol_t *one = allocTemp(0, BT_INT), *result = getExistingSymbol($1.name);
	symbol_t *copy = allocTemp(result->type.indirectionCount, result->type.baseType);
	assemblyOutput(COP" %d %d", copy->address, result->address);
	assemblyOutput(AFC" %d 1", one->address);
	assemblyOutput(ADD" %d %d %d", result->address, result->address, one->address);
	pushSymbol(copy);
}
| tDECR DereferencedID {
	symbol_t *one = allocTemp(0, BT_INT), *result = getExistingSymbol($2.name);
	assemblyOutput(AFC" %d 1", one->address);
	assemblyOutput(SOU" %d %d %d", result->address, result->address, one->address);
	pushSymbol(result);
}
| DereferencedID tDECR {
	symbol_t *one = allocTemp(0, BT_INT), *result = getExistingSymbol($1.name);
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
