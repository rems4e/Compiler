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
	static VarType lastVarType;
	function_t *currentFunction = NULL;

	void affectation(char const *nom, bool allowConst) {
		symbol_t *sym = getExistingSymbol(nom);
		symbol_t *val = popSymbol();

		checkCompatibilityForAffectation(sym, val, allowConst);
		sym->initialized = true;

		assemblyOutput(COP" %d %d ; %s", sym->address, val->address, nom);
		sym->pointedAddress = val->pointedAddress;
		freeIfTemp(val);
	}

	void declaration(char const *nom) {
		symbol_t *sym = createSymbol(nom, lastVarType);
		if(sym == NULL) {
			yyerror("variable déjà déclarée\n");
		}
	}

	void binOp(char const *op) {
		symbol_t *s2 = popSymbol();
		symbol_t *s1 = popSymbol();

		if(op == EQU || op == INF || op == SUP) {
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

		symbol_t *res = allocTemp(s1->type.indirectionCount);
		pushSymbol(res);

		assemblyOutput("%s %d %d %d", op, res->address, s1->address, s2->address);
		freeIfTemp(s2);
		freeIfTemp(s1);
	}

	void binOpEq(char const *op) {
		symbol_t *r = popSymbol();
		symbol_t *s = popSymbol();
		pushSymbol(r);

		checkCompatibilityForAffectation(r, s, false);

		assemblyOutput("%s %d %d %d", op, r->address, r->address, s->address);
		freeIfTemp(s);
	}

	void negate() {
		symbol_t *zero = allocTemp(0);
		assemblyOutput(AFC" %d %d ; negate", zero->address, 0);

		pushSymbol(zero);
		binOp(EQU);
	}

	void toBoolean() {
		negate();
		negate();
	}

	%}

%union {int nb; char* var;}

%token <nb> tNOMBRE
%token <var> tID
%token <var> tFCT

%token tPO tPF tVIR tBO tBF
%token tINT tCONST tTRUE tFALSE
%token tINCR tDECR
%token tPLUSEQ tMOINSEQ tDIVEQ tMULEQ tEGAL
%token tPLUS tMOINS tDIV tSTAR tEGAL
%token tBOOLEGAL tINFEGAL tSUPEGAL tSUP tINF tET tOU tDIFF

%token tNULL
%token tAMP

%token tF
%token tRETURN tPRINTF
%token tIF tELSE tWHILE tFOR tDO
%token END_OF_FILE

%left tPLUS tMOINS
%left tDIV tMUL

%left tBOOLEGAL tINFEGAL tSUPEGAL tSUP tINF
%left tOU
%left tET

%start S

%%
S :
| S Corps;

//Fonction : tINT tID tPO { paramsCount = 0; } Params tPF { createFunction($2, false, paramsCount); } tF;
FonctionDef : Type tID tPO { paramsCount = 0; } Params tPF { createFunction(&lastVarType, $2, true, paramsCount); } CorpsFonction { currentFunction = NULL; };
CorpsFonction : tBO Defs Instrucs Return tF tBF;

Return : tRETURN Exp {
	symbol_t *returnValue = popSymbol();
	assemblyOutput(COP" 2 %d ; Copie de la valeur de retour pour récupération par l'appelant", returnValue->address);
	freeIfTemp(returnValue);
	assemblyOutput(JMP" %d ; return de la fonction %s", currentFunction->address + 1, currentFunction->name);
};

Params :
| ParamsList;

ParamsList : Param
| ParamsList tVIR Param;

Param : Type tID { ++paramsCount; pushParam($2, lastVarType); };

Corps : FonctionDef
| Corps;


Defs :
| Defs Def;

Def : Type TypedDef;

Indirections :
| Indirection;

Indirection :
| tSTAR tCONST {
	++lastVarType.indirectionCount;
	lastVarType.constMask |= 1 << lastVarType.indirectionCount;
}
| tSTAR {
	++lastVarType.indirectionCount;
}

Type : tINT {
	lastVarType.constMask = 0;
	lastVarType.indirectionCount = 0;
} Indirections
| tCONST {
	lastVarType.constMask = 1;
	lastVarType.indirectionCount = 0;
} Indirections;
        
        
TypedDef : tID { if(topLevelConst(&lastVarType)) { yyerror("La constante %s n'est pas initialisée.", $1); } declaration($1); } tVIR TypedDef
| tID { if(topLevelConst(&lastVarType)) { yyerror("La constante %s n'est pas initialisée.", $1); } declaration($1); } tF
| tID  tEGAL Exp { declaration($1); affectation($1, true); } tVIR TypedDef
| tID tEGAL Exp { declaration($1); affectation($1, true); } tF;

Instrucs:
| Instrucs Instruc { clearSymbolStack(); };

Instruc : Exp tVIR Instruc
| Exp tF
| Return tF
| tIF Cond tBO Instrucs tBF { popLabel(); }
| tIF Cond tBO Instrucs tBF { pushLabelLastButOne(); assemblyOutput(JMP_UNKNOWN" "UNKNOWN_ADDRESS); } tELSE tBO { popLabel(); } Instrucs tBF { popLabel(); }
| tWHILE { pushInstructionCount(); } Cond tBO Instrucs FinWhile
| tDO { pushInstructionCount(); } tBO Instrucs tBF tWHILE Cond tF { assemblyOutput(JMP" %d", popInstructionCount()); popLabel(); }

| tFOR tPO Exp { // Initialisation
	pushInstructionCount();
} tF Exp { // Condition
	symbol_t *cond = popSymbol();
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
	assemblyOutput(PRI" %d", s->address);
	freeIfTemp(s);
};

FinWhile : tBF {
	assemblyOutput(JMP" %d", popInstructionCount());
	popLabel();
};

Terme :  tNOMBRE {
	symbol_t *s = allocTemp(0);
	assemblyOutput(AFC" %d %d", s->address, $1);
	pushSymbol(s);
}
| tID {
	symbol_t *s = getExistingSymbol($1);

	if(s == NULL) {
		yyerror("Variable %s non déclarée!", $1);
	}
	else if(!s->initialized) {
		yyerror("Variable %s non initialisée avant utilisation!", $1);
	}

	pushSymbol(s);
}
| Bool
| tNULL {
	int ind = lastVarType.indirectionCount;
	if(ind == 0) {
		ind = 1;
	}
	symbol_t *s = allocTemp(ind);
	s->pointedAddress = 0;
	pushSymbol(s);
	assemblyOutput(AFC" %d 0", s->address);
};

Cond : tPO Exp tPF {
	symbol_t *cond = popSymbol();
	pushLabel();
	assemblyOutput(JMF_UNKNOWN" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
} ;

Bool:
| tTRUE {
	symbol_t *s = allocTemp(0);
	assemblyOutput(AFC" %d 1", s->address);
	pushSymbol(s);
}
| tFALSE {
	symbol_t *s = allocTemp(0);
	assemblyOutput(AFC" %d 0", s->address);
	pushSymbol(s);
};

Args :
| ArgsList;

ArgsList : Exp { ++paramsCount; }
| ArgsList tVIR Exp { ++paramsCount; };

Exp : Terme
| tID tPO { paramsCount = 0; } tPF {
	function_t *function = getFunction($1);
	symbol_t *returnValue = allocTemp(function->returnType.indirectionCount);
	callFunction(function, paramsCount);
	assemblyOutput(COP" %d 2 ; Récupération de la valeur retournée par la fonction %s", returnValue->address, $1);
	pushSymbol(returnValue);
}
| tID tPO { paramsCount = 0; } Args tPF {
	function_t *function = getFunction($1);
	symbol_t *returnValue = allocTemp(function->returnType.indirectionCount);
	callFunction(function, paramsCount);
	assemblyOutput(COP" %d 2 ; Récupération de la valeur retournée par la fonction %s", returnValue->address, $1);
	pushSymbol(returnValue);
}
| tAMP tID {
	symbol_t *s = getExistingSymbol($2);
	symbol_t *a = allocTemp(s->type.indirectionCount + 1);
	a->pointedAddress = s->address;
	assemblyOutput(AFC" %d %d", a->address, s->address);
	pushSymbol(a);
}
| tSTAR tID {
	symbol_t *s = getExistingSymbol($2);
	if(s->type.indirectionCount == 0) {
		yyerror("La variable %s n'est pas un pointeur.", $2);
	}
	else {
		symbol_t *i = allocTemp(s->type.indirectionCount - 1);
		assemblyOutput(COP" %d %d", i->address, s->pointedAddress);
		pushSymbol(i);
	}
}
| tID tEGAL Exp { affectation($1, false); }
| tINCR tID {
	symbol_t *one = allocTemp(0);
	assemblyOutput(AFC" %d 1", one->address);
	pushSymbol(one);
	pushSymbol(getExistingSymbol($2));
	binOpEq(ADD);
}
| tID tINCR {
	symbol_t *one = allocTemp(0), *result = getExistingSymbol($1);
	symbol_t *copy = allocTemp(result->type.indirectionCount);
	assemblyOutput(COP" %d %d", copy->address, result->address);
	assemblyOutput(AFC" %d 1", one->address);
	pushSymbol(one);
	pushSymbol(result);
	binOpEq(ADD);
	freeIfTemp(popSymbol());
	pushSymbol(copy);
}
| tDECR tID {
	symbol_t *one = allocTemp(0);
	assemblyOutput(AFC" %d 1", one->address);
	pushSymbol(one);
	pushSymbol(getExistingSymbol($2));
	binOpEq(SOU);
}
| tID tDECR {
	symbol_t *one = allocTemp(0), *result = getExistingSymbol($1);
	symbol_t *copy = allocTemp(result->type.indirectionCount);
	assemblyOutput(COP" %d %d", copy->address, result->address);
	assemblyOutput(AFC" %d 1", one->address);
	pushSymbol(one);
	pushSymbol(result);
	binOpEq(SOU);
	freeIfTemp(popSymbol());
	pushSymbol(copy);
}
| Exp tPLUS Exp { binOp(ADD); }
| Exp tMOINS Exp { binOp(SOU); }
| Exp tSTAR Exp { binOp(MUL); }
| Exp tDIV Exp { binOp(DIV); }

| tID tPLUSEQ Exp { pushSymbol(getExistingSymbol($1)); binOpEq(ADD); }
| tID tMOINSEQ Exp { pushSymbol(getExistingSymbol($1)); binOpEq(SOU); }
| tID tDIVEQ Exp { pushSymbol(getExistingSymbol($1)); binOpEq(DIV); }
| tID tMULEQ Exp { pushSymbol(getExistingSymbol($1)); binOpEq(MUL); }

| Exp tET Exp {
	toBoolean();
	symbol_t *op2 = popSymbol();
	toBoolean();
	symbol_t *op1 = popSymbol();

	pushSymbol(op1);
	pushSymbol(op2);
	binOp(ADD);

	symbol_t *deux = allocTemp(0);
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

	symbol_t *zero = allocTemp(0);
	assemblyOutput(AFC" %d %d", zero->address, 0);
	pushSymbol(zero);
	binOp(SUP);
}
| Exp tINF Exp { binOp(INF); }
| Exp tSUP Exp { binOp(SUP); }
| Exp tINFEGAL Exp {
	binOp(SOU);
	symbol_t *val = allocTemp(0);
	assemblyOutput(AFC" %d %d", val->address, 1);
	pushSymbol(val);
	binOp(INF);
}
| Exp tSUPEGAL Exp {
	binOp(SOU);
	symbol_t *val = allocTemp(0);
	assemblyOutput(AFC" %d %d", val->address, -1);
	pushSymbol(val);
	binOp(SUP);
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
