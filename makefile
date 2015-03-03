all: y.tab.c lex.yy.c symbol.c
	gcc -std=gnu99 -g y.tab.c lex.yy.c symbol.c -ll -o desc
	
y.tab.c: desc.y
	yacc -d desc.y
	
lex.yy.c: desc.l
	flex desc.l

desc.l: y.tab.c
