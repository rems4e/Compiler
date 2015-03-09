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
#define TAILLE_MAX 100


static FILE *output = NULL;

labels_stack labelsStack = {NULL,0} ;



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
	return num ;
}


void freeLabelStack(){
	label* lab = labelsStack.label ;
	label* temp ;
	while(lab !=NULL){
		temp = lab ;
		lab = temp->suiv ;
		freeLabel(temp);
	}

	free(lab) ;
}

void freeLabel(label* lab){
	free(lab->suiv) ;
	free(lab->name) ;
	free(lab->adresseSaut) ;
}


label makeLabel(){

	char* name = malloc(100) ;
	sprintf(name,"toto%d",labelsStack.stackSize);
	label lab = {name,0,numCharInstruc(),labelsStack.label} ;

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

int getAddLabel(label l){
	return (l.adresseCourante) ;
}

void setLabelAdd (label l, int saut){

	l.adresseSaut = &saut ;
}

void handleLabel(FILE* f){
    char* chaine = malloc(TAILLE_MAX) ;
    while(fgets(chaine,TAILLE_MAX,f)!=NULL){

    }
    free(chaine);
}

