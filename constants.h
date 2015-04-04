//
//  constants.h
//  Système Info
//
//  Created by Rémi on 26/02/2015.
//


#ifndef Syste_me_Info_constants_h
#define Syste_me_Info_constants_h

/**
 * TODO:
 * char val[] = "machin" -> copie du tableau
 * déclaration des tableaux avec []
 * variables globales
 * printf(*(a + 1));
 * break/continue
 * …
 */

//#define YACC_DEBUG

#ifdef YACC_DEBUG
#define YYDEBUG 1
#endif

#include <stdbool.h>
#include <stdint.h>

void yyerror(char const *s, ...);

struct symbol_t;
typedef enum { BT_INT, BT_VOID, BT_CHAR } baseType_t;

typedef struct dereferencedID_t {
	struct symbol_t *symbol;
	int dereferenceCount;
} dereferencedID_t;

typedef struct {
	uint32_t constMask;
	int indirectionCount;
	baseType_t baseType;
} varType_t;

#endif


