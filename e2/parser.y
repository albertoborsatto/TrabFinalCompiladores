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

funcao: cabecalho corpo;

cabecalho: nome_funcao '=' lista_params '>' tipo | nome_funcao '=' '>' tipo;

nome_funcao: TK_IDENTIFICADOR;

lista_params: lista_params param TK_OC_OR | param;

param: TK_IDENTIFICADOR '<''-' tipo;

corpo:;

tipo: TK_PR_INT | TK_PR_FLOAT;

%%

void yyerror (char const *mensagem)
{
    fprintf(stderr, "%s\n", mensagem);
}