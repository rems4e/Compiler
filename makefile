all: y.tab.c lex.yy.c symbol.c
	gcc -std=gnu99 -g y.tab.c lex.yy.c symbol.c assembly.c -ll -o desc
	
y.tab.c: desc.y
	yacc -dv desc.y
	
lex.yy.c: desc.l
	flex desc.l

desc.l: y.tab.c

clean:
	rm -rf y.tab.c y.tab.h lex.yy.c desc.dSYM desc y.output
