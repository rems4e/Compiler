all: compiler exec

clean:
	rm -rf y.tab.c y.tab.h lex.yy.c *.dSYM compiler exec y.output

compiler: y.tab.c lex.yy.c symbol.c assembly.c assembly.h symbol.h constants.h function.h function.c utility.h utility.c enum.h enum.c
	gcc -std=gnu99 -g y.tab.c lex.yy.c symbol.c assembly.c function.c utility.c enum.c -ll -o compiler
	
y.tab.c: desc.y
	yacc -dv desc.y
	
lex.yy.c: desc.l
	flex desc.l

desc.l: y.tab.c

exec: exec.c
	gcc -std=gnu99 -g exec.c -o exec
