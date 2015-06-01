//
//  error.h
//  Système Info
//
//  Created on 31/05/2015.
//

#ifndef __Syste_me_Info__error__
#define __Syste_me_Info__error__

#include <stdbool.h>

void yyerror(const char *s, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
void warning(const char *s, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
void compilerError(const char *s, ...) __attribute__ ((__format__ (__printf__, 1, 2)));

void enableErrorReporting(void);

bool errorsOccurred(void);

#endif /* defined(__Syste_me_Info__error__) */
