//
//  assembly.c
//  Système Info
//
//  Created by Rémi on 05/03/2015.
//

#include "assembly.h"
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

static FILE *output = NULL;
labels_stack labelsStack = {NULL,0} ;

static int NAME_LABEL = 0 ;


void initAssemblyOutput(char const *path) {
	output = fopen(path, "w+");
}

void closeAssemblyOutput() {
	fclose(output);
}

void assemblyOutput(char const *lineFormat, ...) {
	va_list args;
	va_start(args, lineFormat);

	vfprintf(output, lineFormat, args);
	fputc('\n', output);

	va_end(args);
}

int numCharInstruc() {
	int num = ftell(output) ;
}


void freeLabelStack(){
	label* lab = labelsStack.label ;
	label* temp ;
	while(lab !=NULL){
		temp = lab ;
		lab = temp->suiv ;
		freeLabel(temp);
	}
	
	freeLabel(lab) ;
	freeLabel(temp);
} 

void freeLabel(label* lab){
	free(lab->suiv) ;
	free(lab->name) ;
}


label makeLabel(int saut){

	char* name = malloc(100) ; 
	sprintf(name,"toto%d",NAME_LABEL);  
	label lab = {name,0,labelsStack.label} ;
	
	return lab ;
}

void pushLabel(label lab){
	labelsStack.label = &lab ;
	labelsStack.stackSize ++ ;
}


label* popLabel(){
	label* point = labelsStack.label ;
	
	labelsStack.label = point->suiv ;
	labelsStack.stackSize -- ;
	
	point->suiv = NULL ;
	return point ;
}

char* getNameLabel(label lab){
	return lab.name ;
}

label getLabel(char* name){

	label* lab = labelsStack.label ;
	label* temp ;
	while(lab !=NULL){
		temp = lab ;
		lab = temp->suiv ;
		if(strcmp(name,getNameLabel(*temp))){
			return (*temp) ;
		}
	}
}


int getAddSaut(char* name){
	return (*(getLabel(name).adresseSaut)) ;
	
}

void setLabelAdd (char* name, int saut){
	label l = getLabel(name) ;

	l.adresseSaut = &saut ;
}

