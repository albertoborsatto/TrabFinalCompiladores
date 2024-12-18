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
    print_code(arvore); 
    //exporta (arvore);

    yylex_destroy();
    return ret;
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