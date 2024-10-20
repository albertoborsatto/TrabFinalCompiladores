%{ 
#include <stdio.h>
int yylex(void);
void yyerror (char const *mensagem);
%}

%define parse.error verbose
%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_IF
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_RETURN
%token TK_OC_LE
%token TK_OC_GE
%token TK_OC_EQ
%token TK_OC_NE
%token TK_OC_AND
%token TK_OC_OR
%token TK_IDENTIFICADOR
%token TK_LIT_INT
%token TK_LIT_FLOAT
%token TK_ERRO

%%

programa: lista_de_funcoes | /* vazio */ ;
lista_de_funcoes: lista_de_funcoes funcao | funcao;

funcao: cabecalho_funcao corpo_funcao;

cabecalho_funcao: nome_funcao '=' lista_params '>' tipo | nome_funcao '=' '>' tipo;

nome_funcao: TK_IDENTIFICADOR;

lista_params: lista_params TK_OC_OR param | param;

param: TK_IDENTIFICADOR '<''-' tipo;

corpo_funcao: '{' bloco_comando '}' | '{' '}';

bloco_comando: bloco_comando comando | comando;

comando: variavel ';' | atribuicao ';' | chamada_funcao ';' | retorno ';' | controle_fluxo ';' | corpo_funcao ';';

variavel: tipo lista_identificadores;
lista_identificadores: TK_IDENTIFICADOR TK_OC_LE literal ',' lista_identificadores  | TK_IDENTIFICADOR TK_OC_LE literal | TK_IDENTIFICADOR ',' lista_identificadores | TK_IDENTIFICADOR;

atribuicao: TK_IDENTIFICADOR '=' expressao;

chamada_funcao: nome_da_funcao '(' argumentos ')' | nome_da_funcao '(' ')';
argumentos: argumento ',' argumentos | argumento;
argumento: TK_LIT_FLOAT | TK_LIT_INT | expressao;

retorno: TK_PR_RETURN expressao;

controle_fluxo: TK_PR_IF '(' expressao ')' corpo_funcao | TK_PR_IF '(' expressao ')' corpo_funcao TK_PR_ELSE corpo_funcao | TK_PR_WHILE '(' expressao ')' corpo_funcao;

expressao:;
operando: TK_IDENTIFICADOR | literal | chamada_funcao;

tipo: TK_PR_INT | TK_PR_FLOAT;
literal; TK_LIT_INT | TK_LIT_FLOAT;

%%

void yyerror (char const *mensagem)
{
    fprintf(stderr, "%s\n", mensagem);
}