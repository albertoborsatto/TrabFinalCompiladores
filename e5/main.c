#include <stdio.h>
#include <stdlib.h>
#include "asd.h"
#include "table.h"
#include "stack.h"
#include "iloc.h"

extern int yyparse(void);
extern int yylex_destroy(void);
void *arvore = NULL;
table_stack *stack = NULL;
void exporta (void *arvore);
int main (int argc, char **argv)
{
    int ret = yyparse(); 
    exporta (arvore);
    yylex_destroy();
    return ret;
    // gcc main.c asd.c table.c stack.c iloc.c -o main -Wall -g 
    // iloc_code_t code = gera_codigo("loadI", "10", "r1", NULL);
    // iloc_t instr = gera_iloc("add", "r1", "r2", "r3");
    // inserir_iloc_code(&code, &instr);

    // iloc_code_t code2 = gera_codigo("ticolinha", "10", "r1", NULL);

    // concat_code(&code, &code2);
    
    // printf("Generated Code:\n");
    // print_code(&code);

    // free_code(&code);

    // return 0;
}

void exporta(void *arvore)
{
    // testar se arvore é null
    if (arvore == NULL) {
        return;
    }

    asd_tree_t *tree = (asd_tree_t *) arvore;
    printf("%p [label=\"%s\"];\n", tree, tree->label);

    for (int i=0; i < tree->number_of_children; i++) {
        printf("%p, %p \n", tree, tree->children[i]);
        exporta(tree->children[i]);
    }

    free(tree->label);
    tree->label = NULL;
    free(tree->children);
    tree->children = NULL;
    free(tree);
    tree = NULL;

    // return
    return;
}