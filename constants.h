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
 * tableaux
 * chaînes de caractères
 * …
 */
//#define YACC_DEBUG

#ifdef YACC_DEBUG
#define YYDEBUG 1
#endif

#include <stdbool.h>
#include <stdint.h>

void yyerror(char const *s, ...);

typedef enum { BT_INT, BT_VOID } baseType_t;

typedef struct dereferencedID_t {
	char const *name;
	int dereferenceCount;
} dereferencedID_t;

typedef struct {
	uint32_t constMask;
	int indirectionCount;
	baseType_t baseType;
} varType_t;

#endif


