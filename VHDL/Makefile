test: cross_assembleur
	./cross_assembleur < sample.asm

all: cross_assembleur

y.tab.c: cross_assembleur.yacc
	yacc -d cross_assembleur.yacc

lex.yy.c: cross_assembleur.lex
	flex cross_assembleur.lex

cross_assembleur: y.tab.c lex.yy.c
	gcc -Wall y.tab.c lex.yy.c -ll -o cross_assembleur

clean:
	rm -rf *.o y.tab.c y.tab.h lex.yy.c cross_assembleur

