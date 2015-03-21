//
//  constants.h
//  Système Info
//
//  Created by Rémi on 26/02/2015.
//


#ifndef Syste_me_Info_constants_h
#define Syste_me_Info_constants_h

void yyerror(char const *s, ...);
#include <stdbool.h>

typedef struct dereferencedID_t {
	char const *name;
	int dereferenceCount;
} dereferencedID_t;


#endif


