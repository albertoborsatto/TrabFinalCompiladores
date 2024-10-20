all: build

main: main.c
	gcc main.c -c

scanner: scanner.l
	flex scanner.l
	gcc -c lex.yy.c 
	
bison: parser.y
	bison -d parser.y
	gcc -c parser.tab.c 

build: bison scanner main  
	gcc lex.yy.o parser.tab.o main.o -o etapa2