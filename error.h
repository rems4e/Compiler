//
//  error.h
//  Système Info
//
//  Created on 31/05/2015.
//

#ifndef __Syste_me_Info__error__
#define __Syste_me_Info__error__

#include <stdbool.h>

void yyerror(const char *s, ...);
void warning(const char *s, ...);
void compilerError(const char *s, ...);

void enableErrorReporting(void);

bool errorsOccurred(void);

#endif /* defined(__Syste_me_Info__error__) */
