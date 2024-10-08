etapa2: lex.yy.o parser.tab.o lex.yy.c
	gcc -o etapa2 lex.yy.o parser.tab.o -lfl

lex.yy.o: lex.yy.c parser.tab.o
	gcc -c lex.yy.c
	gcc -c parser.tab.c

lex.yy.c: scanner.l
	flex scanner.l

parser.tab.o: parser.y
	bison -d parser.y