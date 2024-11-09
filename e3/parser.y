%{ 
#include <stdio.h>
int yylex(void);
void yyerror (char const *mensagem);
int get_line_number(void);
%}

%code requires { 
   #include "asd.h" 
   #include "valor_lexico.h"
}

%union {
    valor_lexico val_lexico;
    asd_tree_t *tree;
}

/* %define parse.error verbose
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
%token TK_ERRO */

%token<val_lexico> TK_PR_INT
%token<val_lexico> TK_PR_FLOAT
%token<val_lexico> TK_PR_IF
%token<val_lexico> TK_PR_ELSE
%token<val_lexico> TK_PR_WHILE
%token<val_lexico> TK_PR_RETURN
%token<val_lexico> TK_OC_LE
%token<val_lexico> TK_OC_GE
%token<val_lexico> TK_OC_EQ
%token<val_lexico> TK_OC_NE
%token<val_lexico> TK_OC_AND
%token<val_lexico> TK_OC_OR
%token<val_lexico> TK_IDENTIFICADOR
%token<val_lexico> TK_LIT_INT
%token<val_lexico> TK_LIT_FLOAT
%token<val_lexico> TK_ERRO
%type<val_lexico> nome_funcao
%type<val_lexico> tipo
%type<val_lexico> literal

%type<tree> programa
%type<tree> lista_de_funcoes
%type<tree> funcao
%type<tree> cabecalho_funcao
%type<tree> lista_params
%type<tree> param
%type<tree> corpo_funcao
%type<tree> bloco_comando
%type<tree> comando
%type<tree> variavel
%type<tree> lista_identificadores
%type<tree> atribuicao
%type<tree> chamada_funcao
%type<tree> argumentos
%type<tree> argumento
%type<tree> retorno
%type<tree> controle_fluxo
%type<tree> expressao
%type<tree> expressao2
%type<tree> expressao3
%type<tree> expressao4
%type<tree> expressao5
%type<tree> expressao6
%type<tree> expressao7
%type<tree> expressao8 
%type<tree> operando //??? 

%%

programa: lista_de_funcoes | /* vazio */;
lista_de_funcoes: lista_de_funcoes funcao | funcao;

funcao: cabecalho_funcao corpo_funcao;

cabecalho_funcao: nome_funcao '=' lista_params '>' tipo | nome_funcao '=' '>' tipo; 
lista_params: lista_params TK_OC_OR param | param;
param: TK_IDENTIFICADOR '<' '-' tipo;

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

controle_fluxo: TK_PR_IF '(' expressao ')' corpo_funcao { $$ = asd_new("if"); }
                | TK_PR_IF '(' expressao ')' corpo_funcao TK_PR_ELSE corpo_funcao
                | TK_PR_WHILE '(' expressao ')' corpo_funcao;

expressao: expressao TK_OC_OR expressao2  { $$ = asd_new("||"); asd_add_child($$, $1); asd_add_child($$, $3); }
         | expressao2 { $$ = $1; }; /* OR tem menor precedência */

expressao2: expressao2 TK_OC_AND expressao3 { $$ = asd_new("&&"); asd_add_child($$, $1); asd_add_child($$, $3); }
          | expressao3 { $$ = $1; }; /* AND tem precedência maior que OR */

expressao3: expressao3 TK_OC_EQ expressao4 { $$ = asd_new("=="); asd_add_child($$, $1); asd_add_child($$, $3); }  /* Comparações de igualdade e desigualdade */
          | expressao3 TK_OC_NE expressao4 { $$ = asd_new("!="); asd_add_child($$, $1); asd_add_child($$, $3); }
          | expressao4 { $$ = $1; };

expressao4: expressao4 '<' expressao5 { $$ = asd_new("<"); asd_add_child($$, $1); asd_add_child($$, $3); }       /* Comparações de maior e menor */
          | expressao4 '>' expressao5 { $$ = asd_new(">"); asd_add_child($$, $1); asd_add_child($$, $3); }
          | expressao4 TK_OC_LE expressao5 { $$ = asd_new("<="); asd_add_child($$, $1); asd_add_child($$, $3); }
          | expressao4 TK_OC_GE expressao5 { $$ = asd_new(">="); asd_add_child($$, $1); asd_add_child($$, $3); }
          | expressao5 { $$ = $1; };

expressao5: expressao5 '+' expressao6 { $$ = asd_new("+"); asd_add_child($$, $1); asd_add_child($$, $3); }        /* Soma e subtração, associatividade à esquerda */
          | expressao5 '-' expressao6 { $$ = asd_new("-"); asd_add_child($$, $1); asd_add_child($$, $3); }
          | expressao6 { $$ = $1; };

expressao6: expressao6 '*' expressao7 { $$ = asd_new("*"); asd_add_child($$, $1); asd_add_child($$, $3); } /* Multiplicação, divisão e módulo, associatividade à esquerda */
          | expressao6 '/' expressao7 { $$ = asd_new("/"); asd_add_child($$, $1); asd_add_child($$, $3); }
          | expressao6 '%' expressao7 { $$ = asd_new("%"); asd_add_child($$, $1); asd_add_child($$, $3); }
          | expressao7 { $$ = $1; };

expressao7: '-' expressao8 { $$ = asd_new("-"); asd_add_child($$, $2); }                  /* Unário, precedência mais alta */
          | '!' expressao8 { $$ = asd_new("!"); asd_add_child($$, $2); }
          | expressao8 { $$ = $1; };

expressao8: operando { $$ = $1; }                         /* Parênteses e operandos */
          | '(' expressao ')' { $$ = $2; };

operando: TK_IDENTIFICADOR { $$ = asd_new($1.value); }
         | literal { $$ = asd_new($1.value); }
         | chamada_funcao { $$ = $1; } ;

// ???
tipo: TK_PR_INT { $$ = $1; }
    | TK_PR_FLOAT { $$ = $1; };

literal: TK_LIT_FLOAT { $$ = $1; }
       | TK_LIT_INT { $$ = $1; };

%%

void yyerror (char const *mensagem)
{
    fprintf(stderr, "%s - line %d\n", mensagem, get_line_number());
}