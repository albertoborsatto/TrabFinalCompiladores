%{ 
#include <stdio.h>
#include <string.h>
int yylex(void);
void yyerror (char const *mensagem);
int get_line_number(void);
extern void *arvore;
%}

%code requires { 
   #include "asd.h" 
   #include "valor_lexico.h"
}

%union {
    valor_lexico val_lexico;
    asd_tree_t *tree;
}

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
%token TK_ERRO

%token<val_lexico> TK_IDENTIFICADOR
%token<val_lexico> TK_LIT_INT
%token<val_lexico> TK_LIT_FLOAT
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

// início
programa: lista_de_funcoes { $$ = $1; arvore = $$; asd_print_graphviz(arvore);}
        | /* vazio */ { $$ = NULL; arvore = $$; };

lista_de_funcoes: funcao lista_de_funcoes { $$ = $1; asd_add_child($$, $2); }
                | funcao { $$ = $1; };

// função$$ = $1;
funcao: cabecalho_funcao corpo_funcao { $$ = $1; if ($2 != NULL) asd_add_child($$, $2); };

cabecalho_funcao: TK_IDENTIFICADOR '=' lista_params '>' tipo { $$ = asd_new($1.value); } 
                | TK_IDENTIFICADOR '=' '>' tipo { $$ = asd_new($1.value); }; 

// parâmetros
lista_params: lista_params TK_OC_OR param  { $$ = asd_new("||"); asd_add_child($$, $1); asd_add_child($$, $3); }
            | param { $$ = $1; };
param: TK_IDENTIFICADOR '<' '-' tipo { $$ = asd_new($1.value); };

// corpo
corpo_funcao: '{' bloco_comando '}' { $$ = $2; }
            | '{' '}' { $$ = NULL; };
bloco_comando: bloco_comando comando  { $$ = $1;   
                    // trata caso em que comando subsequente a uma lista de declarações seria filha da primeira declaração     
                    if ($$!=NULL) {
                        asd_tree_t *last_child = $1;
                        while(last_child->number_of_children == 3) {
                            last_child = last_child->children[last_child->number_of_children-1];
                        }
                        if ($2!=NULL)
                            asd_add_child(last_child, $2);
                    }
                    else {
                        if ($$==NULL) {
                            $$ = $2;
                        } else {
                            asd_add_child($$, $2);
                        }
                    }
                }
             | comando { $$ = $1; };

// comandos ---------------------------------------------------------------
comando:  variavel ';' { $$ = $1; }
        | atribuicao ';' { $$ = $1; }
        | chamada_funcao ';' { $$ = $1; }
        | retorno ';' { $$ = $1; }
        | controle_fluxo ';' { $$ = $1; }
        | corpo_funcao ';' { $$ = $1; };

variavel: tipo lista_identificadores { $$ = $2; };
lista_identificadores: TK_IDENTIFICADOR { $$ = NULL; }
                    | TK_IDENTIFICADOR ',' lista_identificadores { $$ = $3; }
                    | TK_IDENTIFICADOR TK_OC_LE literal { $$ = asd_new("<="); asd_add_child($$, asd_new($1.value)); asd_add_child($$, asd_new($3.value)); }
                    | TK_IDENTIFICADOR TK_OC_LE literal ',' lista_identificadores
                    { $$ = asd_new("<="); asd_add_child($$, asd_new($1.value)); asd_add_child($$, asd_new($3.value)); if ($5!=NULL) asd_add_child($$, $5); };

    
atribuicao: TK_IDENTIFICADOR '=' expressao { $$ = asd_new("="); asd_add_child($$, asd_new($1.value)); asd_add_child($$, $3); };

chamada_funcao: TK_IDENTIFICADOR '(' argumentos ')' { 
    char call[] = "call ";
    $$ = asd_new(strcat(call, $1.value)); asd_add_child($$, $3); 
} ;
argumentos: argumentos ',' argumento { $$ = $1; asd_add_child($$, $3); }
          | argumento { $$ = $1; }
argumento: expressao { $$ = $1; };

retorno: TK_PR_RETURN expressao { $$ = asd_new("return"); asd_add_child($$, $2); };

controle_fluxo: TK_PR_IF '(' expressao ')' corpo_funcao { $$ = asd_new("if"); asd_add_child($$, $3); if ($5 != NULL) asd_add_child($$, $5); }
                | TK_PR_IF '(' expressao ')' corpo_funcao TK_PR_ELSE corpo_funcao { $$ = asd_new("if"); asd_add_child($$, $3); if ($5 != NULL) asd_add_child($$, $5); if ($7 != NULL) asd_add_child($$, $7); }
                | TK_PR_WHILE '(' expressao ')' corpo_funcao { $$ = asd_new("while"); asd_add_child($$, $3);  if ($5 != NULL) asd_add_child($$, $5); };

// comandos ---------------------------------------------------------------

// expressões
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
tipo: TK_PR_INT 
    | TK_PR_FLOAT

literal: TK_LIT_FLOAT { $$ = $1; }
       | TK_LIT_INT { $$ = $1; };

%%

void yyerror (char const *mensagem)
{
    fprintf(stderr, "%s - line %d\n", mensagem, get_line_number());
}