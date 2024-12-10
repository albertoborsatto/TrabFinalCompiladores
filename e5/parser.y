%{ 
#include <stdio.h>
#include <string.h>
#include "stack.h"
#include "errors.h"
#include "util.h"

int yylex(void);
void yyerror (char const *mensagem);
int get_line_number(void);
extern void *arvore;
extern table_stack stack;
%}

%code requires { 
   #include "asd.h" 
   #include "valor_lexico.h"
   #include "stack.h"
   #include "table.h"
   #include "content.h"
   #include "util.h"
   #include "iloc.h"
}

%union {
    valor_lexico *val_lexico;
    asd_tree_t *tree;
    type_symbol symbol_type;
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
%type<tree> literal
%type<symbol_type> tipo

%type<tree> programa
%type<tree> lista_de_funcoes
%type<tree> funcao
%type<tree> cabecalho_funcao
%type<tree> lista_params
%type<tree> param
%type<tree> corpo_funcao
%type<tree> escopo
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
programa 
    : cria_pilha lista_de_funcoes destroi_pilha {
        $$ = $2; 
        arvore = $$;
    }
    | { 
        $$ = NULL; 
        arvore = $$; 
    };

cria_pilha
    : {
        init_table_stack(&stack);
        symbol_table table;
        init_symbol_table(&table);
        push_table_stack(&stack, &table);
    };

destroi_pilha
    : {
        symbol_table *last_table = get_top_table(&stack); 
        free_symbol_table(last_table);
        free_table_stack(&stack);
    };

abre_escopo
    : {
        symbol_table table;
        init_symbol_table(&table);
        push_table_stack(&stack, &table);
    }

fecha_escopo
    : {
        symbol_table *popped_table = get_top_table(&stack);
        free_symbol_table(popped_table);
        pop_table_stack(&stack);
    }

lista_de_funcoes
    : funcao lista_de_funcoes { 
        $$ = $1; 
        asd_add_child($$, $2); 
    }
    | funcao { $$ = $1; };

// função$$ = $1;
funcao
    : cabecalho_funcao corpo_funcao { 
        $$ = $1; 
        if ($2 != NULL) 
            asd_add_child($$, $2); 
    };

cabecalho_funcao
    : TK_IDENTIFICADOR '=' abre_escopo lista_params '>' tipo {
        $$ = asd_new($1->value);

        symbol_table *bottom_table = get_bottom_table(&stack);
        check_table_and_add_entry(bottom_table, $1->value, $1->line_number, FUNCTION, $6, "", ERR_DECLARED);
    } 
    | TK_IDENTIFICADOR '=' abre_escopo '>' tipo {
        $$ = asd_new($1->value);
        
        symbol_table *bottom_table = get_bottom_table(&stack);
        check_table_and_add_entry(bottom_table, $1->value, $1->line_number, FUNCTION, $5, "", ERR_DECLARED);
    }; 

// parâmetros
lista_params
    : param TK_OC_OR lista_params  { $$ = NULL; }
    | param { $$ = NULL; };

param
    : TK_IDENTIFICADOR '<' '-' tipo {
        $$ = NULL;

        symbol_table *current_table = get_top_table(&stack);
        check_stack_and_add_entry(stack, current_table, $1->value, $1->line_number, ID, $4, "", ERR_DECLARED);
    };

// corpo
corpo_funcao
    : '{' bloco_comando '}' fecha_escopo { $$ = $2; }
    | '{' '}' fecha_escopo { $$ = NULL; };

escopo
    : '{' abre_escopo bloco_comando '}' fecha_escopo { $$ = $3; }
    | '{' abre_escopo '}' fecha_escopo { $$ = NULL; };

bloco_comando
    : comando bloco_comando { 
        $$ = $1;   
        // trata caso em que comando subsequente a uma lista de declarações seria filha da primeira declaração     
        if ($$!=NULL) {
            asd_tree_t *last_child = $1;
            while(last_child->number_of_children == 3) {
                last_child = last_child->children[last_child->number_of_children-1];
            }
            if ($2!=NULL)
                asd_add_child(last_child, $2);
        } else {
            if ($$==NULL) {
                $$ = $2;
            } else {
                asd_add_child($$, $2);
            }
        }
    }
    | comando { $$ = $1; };

// comandos ---------------------------------------------------------------
comando
    : variavel ';' { $$ = $1; }
    | atribuicao ';' { $$ = $1; }
    | chamada_funcao ';' { $$ = $1; }
    | retorno ';' { $$ = $1; }
    | controle_fluxo ';' { $$ = $1; }
    | escopo ';' { $$ = $1; };

variavel
    : tipo lista_identificadores {
        $$ = $2;
        // percorrer toda a tabela do topo
        // preencher UNDEFINED com 'tipo' (SS1.value)
        fill_type(get_top_table(&stack), $1);

    };

lista_identificadores
    : TK_IDENTIFICADOR {
        $$ = NULL;
        
        symbol_table *current_table = get_top_table(&stack);
        check_table_and_add_entry(current_table, $1->value, $1->line_number, ID, UNDEFINED, "", ERR_DECLARED);
    }
    | TK_IDENTIFICADOR ',' lista_identificadores {
        $$ = $3;

        symbol_table *current_table = get_top_table(&stack);
        check_table_and_add_entry(current_table, $1->value, $1->line_number, ID, UNDEFINED, "", ERR_DECLARED);  
    }
    | TK_IDENTIFICADOR TK_OC_LE literal {
        $$ = asd_new("<="); 
        asd_add_child($$, asd_new($1->value)); 
        asd_add_child($$, $3);

        symbol_table *current_table = get_top_table(&stack);
        check_table_and_add_entry(current_table, $1->value, $1->line_number, ID, UNDEFINED, $3->label, ERR_DECLARED);
    }
    | TK_IDENTIFICADOR TK_OC_LE literal ',' lista_identificadores {
        $$ = asd_new("<="); 
        asd_add_child($$, asd_new($1->value)); 
        asd_add_child($$, $3); 
        if ($5!=NULL) asd_add_child($$, $5);

        symbol_table *current_table = get_top_table(&stack);
        check_table_and_add_entry(current_table, $1->value, $1->line_number, ID, UNDEFINED, $3->label, ERR_DECLARED);
    };

atribuicao
    : TK_IDENTIFICADOR '=' expressao {
        $$ = asd_new("="); 
        asd_add_child($$, asd_new($1->value)); 
        asd_add_child($$, $3);

        int previous_line = -1;
        symbol_table *current_table = get_top_table(&stack);

        if (!search_stack_value(&stack, $1->value, &previous_line)){
            print_error(current_table, $1->line_number, $1->value, ID, ERR_UNDECLARED, previous_line);
        } else {
            check_symbol_content_type(stack, current_table, $1->value, $1->line_number, ID, previous_line, ERR_FUNCTION, $$);
        }
    };

chamada_funcao
    : TK_IDENTIFICADOR '(' argumentos ')' { 
        int previous_line = -1;
        symbol_table *current_table = get_top_table(&stack);

        if (!search_stack_value(&stack, $1->value, &previous_line)){
            print_error(current_table, $1->line_number, $1->value, FUNCTION, ERR_UNDECLARED, previous_line);
        } else {
            check_symbol_content_type(stack, current_table, $1->value, $1->line_number, FUNCTION, previous_line, ERR_VARIABLE, $$);
        }
        char call[] = "call ";
        $$ = asd_new(strcat(call, $1->value)); asd_add_child($$, $3); 
    } ;

argumentos
    : argumento ',' argumentos { 
        $$ = $1; 
        asd_add_child($$, $3); 
    }
    | argumento { $$ = $1; }

argumento
    : expressao { $$ = $1; };

retorno
    : TK_PR_RETURN expressao { 
        $$ = asd_new("return"); 
        asd_add_child($$, $2); 
    };

controle_fluxo
    : TK_PR_IF '(' expressao ')' escopo { 
        $$ = asd_new("if"); 
        asd_add_child($$, $3); 
        if ($5 != NULL) 
            asd_add_child($$, $5); 
    }
    | TK_PR_IF '(' expressao ')' escopo TK_PR_ELSE escopo { 
        $$ = asd_new("if"); 
        asd_add_child($$, $3); 
        if ($5 != NULL) 
            asd_add_child($$, $5); 
        if ($7 != NULL) 
            asd_add_child($$, $7); 
    }
    | TK_PR_WHILE '(' expressao ')' escopo { 
        $$ = asd_new("while"); 
        asd_add_child($$, $3);  
        if ($5 != NULL) 
            asd_add_child($$, $5); 
    };

// comandos ---------------------------------------------------------------

// expressões
expressao
    : expressao TK_OC_OR expressao2  { 
        $$ = asd_new("||"); 
        asd_add_child($$, $1); 
        asd_add_child($$, $3); 
        $$->type = type_infer($1->type, $3->type); 
    }
    | expressao2 { $$ = $1; }; /* OR tem menor precedência */

expressao2
    : expressao2 TK_OC_AND expressao3 { 
        $$ = asd_new("&&"); 
        asd_add_child($$, $1); 
        asd_add_child($$, $3); 
        $$->type = type_infer($1->type, $3->type);
    }
    | expressao3 { $$ = $1; }; /* AND tem precedência maior que OR */

expressao3
    : expressao3 TK_OC_EQ expressao4 { 
        $$ = asd_new("=="); 
        asd_add_child($$, $1); 
        asd_add_child($$, $3); 
        $$->type = type_infer($1->type, $3->type);
    }  /* Comparações de igualdade e desigualdade */
    | expressao3 TK_OC_NE expressao4 { 
        $$ = asd_new("!="); 
        asd_add_child($$, $1); 
        asd_add_child($$, $3); 
        $$->type = type_infer($1->type, $3->type);
    }
    | expressao4 { $$ = $1; };

expressao4
    : expressao4 '<' expressao5 { 
        $$ = asd_new("<"); 
        asd_add_child($$, $1); 
        asd_add_child($$, $3); 
        $$->type = type_infer($1->type, $3->type); 
    }       /* Comparações de maior e menor */
    | expressao4 '>' expressao5 { 
        $$ = asd_new(">"); 
        asd_add_child($$, $1); 
        asd_add_child($$, $3); 
        $$->type = type_infer($1->type, $3->type);
    }
    | expressao4 TK_OC_LE expressao5 { 
        $$ = asd_new("<="); 
        asd_add_child($$, $1); 
        asd_add_child($$, $3); 
        $$->type = type_infer($1->type, $3->type);
    }
    | expressao4 TK_OC_GE expressao5 { 
        $$ = asd_new(">="); 
        asd_add_child($$, $1); 
        asd_add_child($$, $3); 
        $$->type = type_infer($1->type, $3->type);
    }
    | expressao5 { $$ = $1; };

expressao5
    : expressao5 '+' expressao6 { 
        $$ = asd_new("+"); 
        asd_add_child($$, $1); 
        asd_add_child($$, $3); 
        $$->type = type_infer($1->type, $3->type);
    }        /* Soma e subtração, associatividade à esquerda */
    | expressao5 '-' expressao6 { 
        $$ = asd_new("-"); 
        asd_add_child($$, $1); 
        asd_add_child($$, $3); 
        $$->type = type_infer($1->type, $3->type);
    }
    | expressao6 { $$ = $1; };

expressao6
    : expressao6 '*' expressao7 { 
        $$ = asd_new("*"); 
        asd_add_child($$, $1); 
        asd_add_child($$, $3); 
        $$->type = type_infer($1->type, $3->type);
    } /* Multiplicação, divisão e módulo, associatividade à esquerda */
    | expressao6 '/' expressao7 { 
        $$ = asd_new("/"); 
        asd_add_child($$, $1); 
        asd_add_child($$, $3); 
        $$->type = type_infer($1->type, $3->type);
    }
    | expressao6 '%' expressao7 { 
        $$ = asd_new("%"); 
        asd_add_child($$, $1); 
        asd_add_child($$, $3); 
        $$->type = type_infer($1->type, $3->type);
    }
    | expressao7 { $$ = $1; };

expressao7
    : '-' expressao8 { 
        $$ = asd_new("-"); 
        asd_add_child($$, $2); 
        $$->temp = get_temp();
        iloc_t instr = gera_iloc("multI", $2->temp, "-1", $$->temp);
        inserir_iloc_code(&$2->code, &instr);
        $$->code = $2->code;
        print_code(&$$->code);
    }                  
    | '!' expressao8 { 
        $$ = asd_new("!");
        asd_add_child($$, $2); 
    }
    | expressao8 { $$ = $1; };

expressao8
    : operando { $$ = $1; }                         /* Parênteses e operandos */
    | '(' expressao ')' { $$ = $2; };

operando
    : TK_IDENTIFICADOR { 
        $$ = asd_new($1->value);

        int previous_line = -1;
        symbol_table *current_table = get_top_table(&stack);
        
        if (!search_stack_value(&stack, $1->value, &previous_line)){
            print_error(current_table, $1->line_number, $1->value, FUNCTION, ERR_UNDECLARED, previous_line);
        } else {
            check_symbol_content_type(stack, current_table, $1->value, $1->line_number, ID, previous_line, ERR_FUNCTION, $$);
        }
    }
    | literal { 
        $$->temp = get_temp();
        iloc_t instr = gera_iloc("loadI", $1->label, $$->temp, NULL);
        inserir_iloc_code(&$$->code, &instr);
    }
    | chamada_funcao { $$ = $1; } ;

tipo
    : TK_PR_INT { $$ = INT; }
    | TK_PR_FLOAT { $$ = FLOAT; };

literal
    : TK_LIT_FLOAT { 
        $$ = asd_new($1->value);
        $$->type = FLOAT; 
    }
    | TK_LIT_INT { 
        $$ = asd_new($1->value);
        $$->type = INT;  
    };

%%

void yyerror (char const *mensagem)
{
    fprintf(stderr, "%s - line %d\n", mensagem, get_line_number());
}

