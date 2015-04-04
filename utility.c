//
//  utility.c
//  Système Info
//
//  Created by Rémi on 16/03/2015.
//

#include "utility.h"
#include <string.h>
#include <assert.h>
#include "assembly.h"

void stringReplaceWithShorter(char *replaced, size_t toReplace, char const *replacing, size_t replacingLength) {
	if(replacingLength == 0) {
		replacingLength = strlen(replacing);
	}

	memcpy(replaced, replacing, replacingLength);
	size_t length2 = strlen(replaced + toReplace - replacingLength);
	memmove(replaced + replacingLength, replaced + toReplace, length2);
	replaced[length2] = 0;
}


char *safeComment(char const *unsafe) {
#ifndef STRIP_COMMENTS
	size_t count = 0, len = strlen(unsafe);
	for(size_t i = 0; i < len; ++i) {
		if(unsafe[i] == '\n')
			++count;
	}

	char *comment = malloc(len + count + 1), *pos = comment;
	strcpy(comment, unsafe);

	while((pos = strstr(pos, "\n")) != NULL) {
		size_t length2 = strlen(pos + 1 - 2);
		memmove(pos + 2, pos + 1, length2);
		memcpy(pos, "\\n", 2);
		pos[length2] = 0;
	}

	return comment;
#else
	return NULL;
#endif
}
