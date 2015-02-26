//
//  symbol.h
//  Système Info
//
//  Created by Rémi on 26/02/2015.
//

#ifndef __Syste_me_Info__symbol__
#define __Syste_me_Info__symbol__

#include "constants.h"

typedef struct {
	bool affected;
	char *name;
	int add;
} symbol;

void initSymbolTable(void);

symbol *getExistingSymbol(char const *name);
symbol *createSymbol(char const *name);

bool symbolDeclared(char const *name);

#endif /* defined(__Syste_me_Info__symbol__) */
