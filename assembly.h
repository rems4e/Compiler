//
//  assembly.h
//  Système Info
//
//  Created by Rémi on 05/03/2015.
//

#ifndef __Syste_me_Info__assembly__
#define __Syste_me_Info__assembly__

void initAssemblyOutput(char const *path);
void closeAssemblyOutput();

void assemblyOutput(char const *lineFormat, ...);

typedef struct label {
	char* name ;
	int* adresseSaut ;
	struct label* suiv ;
} label ;

typedef struct labels_stack {
	struct label* label ;
	int stackSize ;
} labels_stack ;

int numCharInstruc() ;
void freeLabelStack() ;
void pushLabel(label lab) ;
label* popLabel() ;
char* getNameLabel(label lab) ;
label makeLabel(int saut) ;

void freeLabel(label* lab) ;
void freeLabelStack() ;

#endif /* defined(__Syste_me_Info__assembly__) */
