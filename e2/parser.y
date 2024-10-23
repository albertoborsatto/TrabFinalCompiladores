%{ 
#include <stdio.h>
int yylex(void);
void yyerror (char const *mensagem);
int get_line_number(void);
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

programa: lista_de_funcoes | /* vazio */;
lista_de_funcoes: lista_de_funcoes funcao | funcao;

funcao: cabecalho_funcao corpo_funcao;

cabecalho_funcao: nome_funcao '=' lista_params '>' tipo | nome_funcao '=' '>' tipo; 
lista_params: lista_params TK_OC_OR param | param;
param: nome_funcao '<' '-' tipo;

nome_funcao: TK_IDENTIFICADOR

corpo_funcao: '{' bloco_comando '}' | '{' '}';
bloco_comando: bloco_comando comando | comando;

comando:  variavel ';' 
        | atribuicao ';' 
        | chamada_funcao ';' 
        | retorno ';' 
        | controle_fluxo ';' 
        | corpo_funcao ';';

variavel: tipo lista_identificadores;
lista_identificadores: TK_IDENTIFICADOR 
                    | lista_identificadores ',' TK_IDENTIFICADOR 
                    | TK_IDENTIFICADOR TK_OC_LE literal 
                    | lista_identificadores ',' TK_IDENTIFICADOR TK_OC_LE literal;

    
atribuicao: TK_IDENTIFICADOR '=' expressao;

chamada_funcao: nome_funcao '(' argumentos ')';
argumentos: argumentos ',' argumento | argumento;
argumento: expressao;

retorno: TK_PR_RETURN expressao;

controle_fluxo: TK_PR_IF '(' expressao ')' corpo_funcao |
                        TK_PR_IF '(' expressao ')' corpo_funcao TK_PR_ELSE corpo_funcao |
                        TK_PR_WHILE '(' expressao ')' corpo_funcao;

expressao: expressao TK_OC_OR expressao2 | expressao2;   /* OR tem menor precedência */

expressao2: expressao2 TK_OC_AND expressao3 | expressao3; /* AND tem precedência maior que OR */

expressao3: expressao3 TK_OC_EQ expressao4   /* Comparações de igualdade e desigualdade */
          | expressao3 TK_OC_NE expressao4
          | expressao4;

expressao4: expressao4 '<' expressao5        /* Comparações de maior e menor */
          | expressao4 '>' expressao5
          | expressao4 TK_OC_LE expressao5
          | expressao4 TK_OC_GE expressao5
          | expressao5;

expressao5: expressao5 '+' expressao6        /* Soma e subtração, associatividade à esquerda */
          | expressao5 '-' expressao6
          | expressao6;

expressao6: expressao6 '*' expressao7        /* Multiplicação, divisão e módulo, associatividade à esquerda */
          | expressao6 '/' expressao7
          | expressao6 '%' expressao7
          | expressao7;

expressao7: '-' expressao8                   /* Unário, precedência mais alta */
          | '!' expressao8
          | expressao8;

expressao8: operando                         /* Parênteses e operandos */
          | '(' expressao ')';

operando : TK_IDENTIFICADOR 
         | literal
         | chamada_funcao;

tipo: TK_PR_INT | TK_PR_FLOAT;
literal: TK_LIT_FLOAT | TK_LIT_INT;

%%

void yyerror (char const *mensagem)
{
    fprintf(stderr, "%s - line %d\n", mensagem, get_line_number());
}