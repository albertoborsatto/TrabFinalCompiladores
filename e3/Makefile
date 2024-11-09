all: etapa3

main: main.c
	gcc main.c -c

asd: asd.c
	gcc asd.c -c

scanner: scanner.l
	flex scanner.l
	gcc -c lex.yy.c 
	
bison: parser.y
	bison -d parser.y
	gcc -c parser.tab.c 

etapa3: bison scanner asd main  
	gcc lex.yy.o parser.tab.o asd.o main.o -o etapa3