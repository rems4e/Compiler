//
//  utility.c
//  Système Info
//
//  Created by Rémi on 16/03/2015.
//

#include "utility.h"
#include <string.h>

void stringReplaceWithShorter(char *replaced, size_t toReplace, char const *replacing, size_t replacingLength) {
	if(replacingLength == 0) {
		replacingLength = strlen(replacing);
	}

	memcpy(replaced, replacing, replacingLength);
	size_t length2 = strlen(replaced + toReplace - replacingLength);
	memmove(replaced + replacingLength, replaced + toReplace, length2);
	replaced[length2] = 0;
}
