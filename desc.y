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
	static varType_t lastVarType, returnValueType;
	function_t *currentFunction = NULL;
	char const *funcName;

	void affectation(dereferencedID_t id, bool allowConst) {
		symbol_t *sym = id.symbol;
		symbol_t *val = popSymbol();

		if(id.dereferenceCount > 0) {
			symbol_t *temp;
			for(int i = 0; i < id.dereferenceCount - 1; ++i) {
				temp = allocTemp(sym->type.indirectionCount - 1);
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
			assemblyOutput(COP" %d %d ; %s", sym->address, val->address, id.symbol);
		}

		freeIfTemp(val);
		freeIfTemp(sym);
		sym->initialized = true;
	}

	void checkBinOp(char const *op, symbol_t const *s1, symbol_t const *s2) {
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
	}

	void binOp(char const *op) {
		symbol_t *s2 = popSymbol();
		symbol_t *s1 = popSymbol();

		checkBinOp(op, s1, s2);

		symbol_t *res = allocTemp(s1->type.indirectionCount);
		pushSymbol(res);

		assemblyOutput("%s %d %d %d", op, res->address, s1->address, s2->address);
		freeIfTemp(s2);
		freeIfTemp(s1);
	}

	void binOpEq(char const *op, dereferencedID_t id) {
		symbol_t *r = id.symbol;
		symbol_t *s = popSymbol();

		if(id.dereferenceCount > 0) {
			symbol_t *ind;
			for(int i = 0; i < id.dereferenceCount; ++i) {
				ind = allocTemp(r->type.indirectionCount - 1);
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

%token tPO tPF tVIR tBO tBF tCRO tCRF
%token tINT tCONST tTRUE tFALSE
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

CorpsFonction : tBO Defs Instrucs Return tF tBF;

Return : tRETURN Exp {
	symbol_t *returnValue = popSymbol();
	assemblyOutput(COP" 1 %d ; Copie de la valeur de retour pour récupération par l'appelant", returnValue->address);
	freeIfTemp(returnValue);
	assemblyOutput(RET" ; Retour à la fonction appelante");
};

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
	lastVarType = (varType_t){.constMask = 0, .indirectionCount = 0};
} Indirections {
	$$ = (varType_t){.constMask = lastVarType.constMask, .indirectionCount = lastVarType.indirectionCount};
}
| tCONST {
	lastVarType = (varType_t){.constMask = 1, .indirectionCount = 0};
} Indirections {
	$$ = (varType_t){.constMask = 1 | lastVarType.constMask, .indirectionCount = lastVarType.indirectionCount};
}

TypedDefNext : tF
| tVIR TypedDef
        
TypedDef : tID {
	if(topLevelConst(&lastVarType)) {
		yyerror("La constante %s n'est pas initialisée.", $1);
	}
	createSymbol($1, lastVarType);
} TypedDefNext
| tID tEGAL Exp {
	createSymbol($1, lastVarType);
	affectation((dereferencedID_t){.symbol = $1, .dereferenceCount = 0}, true);
} TypedDefNext
| tID tCRO tNOMBRE tCRF {
	createTable($1,$3);} TypedDefNext ; //TODO

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

DereferencedID : tSTAR DereferencedID { $$ = (dereferencedID_t){.symbol = $2.symbol, .dereferenceCount = $2.dereferenceCount + 1}; }
| tID { $$ = (dereferencedID_t){.symbol = $1, .dereferenceCount = 0}; } ;
| Exp tCRO Exp tCRF { 
	symbol_t * symbInd = popSymbol(), *ind, *ind2;
	symbol_t * symbTab = popSymbol() ;
	
	ind2 = allocTemp(symbTab->type.indirectionCount);
	assemblyOutput(ADD" %d %d %d", ind2->address, symbTab->address, symbInd->address) ;
		
	ind = allocTemp(symbTab->type.indirectionCount - 1);
	assemblyOutput(DR2" %d %d", ind->address, ind2->address);
	freeIfTemp(ind2);
	ind2 = ind;
	

	freeIfTemp(symbInd) ;
	freeIfTemp(symbTab) ;
	$$ = (dereferencedID_t){.symbol = ind2, .dereferenceCount = 0 };  } ; //TODO
	
Terme :  tNOMBRE {
	symbol_t *s = allocTemp(0);
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
		symbol_t *ind;
		if ($1.dereferenceCount > s->type.indirectionCount){
			yyerror("SegFault, erreur de pointeur : %s !",$1);
		}
		else{
			for(int i = 0; i < $1.dereferenceCount; ++i) {
				ind = allocTemp(s->type.indirectionCount - 1);
				assemblyOutput(DR2" %d %d", ind->address, s->address);
				freeIfTemp(s);
				s = ind;
			}
			pushSymbol(ind);
		}
		
	}
}
| Bool
| tNULL {
	int ind = -1;
	symbol_t *s = allocTemp(ind);
	pushSymbol(s);
	assemblyOutput(AFC" %d 0", s->address);
}
| Tableau; //TODO

Cond : tPO Exp tPF {
	symbol_t *cond = popSymbol();
	pushLabel();
	assemblyOutput(JMF_UNKNOWN" %d "UNKNOWN_ADDRESS, cond->address);
	freeIfTemp(cond);
} ;

Bool: tTRUE {
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
| tID tPO { paramsCount = 0; } Args tPF {
	function_t *function = getFunction($1);
	symbol_t *returnValue = allocTemp(function->returnType.indirectionCount);
	callFunction(function, paramsCount, returnValue);
	pushSymbol(returnValue);
}
| tAMP DereferencedID {
	symbol_t *s = $2.symbol;
	symbol_t *a = allocTemp(s->type.indirectionCount + 1 - $2.dereferenceCount);
	assemblyOutput(AFC" %d %d", a->address, s->address);
	pushSymbol(a);
}
| DereferencedID tEGAL Exp { affectation($1, false); }
| tINCR DereferencedID {
	symbol_t *one = allocTemp(0), *result = $2.symbol;
	assemblyOutput(AFC" %d 1", one->address);
	assemblyOutput(ADD" %d %d %d", result->address, result->address, one->address);
	pushSymbol(result);
}
| DereferencedID tINCR {
	symbol_t *one = allocTemp(0), *result = $1.symbol;
	symbol_t *copy = allocTemp(result->type.indirectionCount);
	assemblyOutput(COP" %d %d", copy->address, result->address);
	assemblyOutput(AFC" %d 1", one->address);
	assemblyOutput(ADD" %d %d %d", result->address, result->address, one->address);
	pushSymbol(copy);
}
| tDECR DereferencedID {
	symbol_t *one = allocTemp(0), *result = $2.symbol;
	assemblyOutput(AFC" %d 1", one->address);
	assemblyOutput(SOU" %d %d %d", result->address, result->address, one->address);
	pushSymbol(result);
}
| DereferencedID tDECR {
	symbol_t *one = allocTemp(0), *result = $1.symbol;
	symbol_t *copy = allocTemp(result->type.indirectionCount);
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
