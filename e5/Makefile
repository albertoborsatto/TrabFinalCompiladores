all: etapa4

main: main.c
	gcc main.c -c

table: table.c
	gcc table.c -c

stack: stack.c
	gcc stack.c -c

util: util.c
	gcc util.c -c

asd: asd.c
	gcc asd.c -c

scanner: scanner.l
	flex scanner.l
	gcc -c lex.yy.c 
	
bison: parser.y
	bison -d parser.y
	gcc -c parser.tab.c 

etapa4: bison scanner asd util stack table main  
	gcc lex.yy.o parser.tab.o asd.o util.o stack.o table.o main.o -o etapa4