#include <stdio.h>
#include <stdlib.h>
#include "asd.h"

extern int yyparse(void);
extern int yylex_destroy(void);
void *arvore = NULL;
void exporta (void *arvore);
int main (int argc, char **argv)
{
  int ret = yyparse(); 
  exporta (arvore);
  yylex_destroy();
  return ret;
}

void exporta(void *arvore)
{
    if (arvore == NULL) {
        return;
    }
    
    asd_tree_t *tree = (asd_tree_t *) arvore;
    fprintf(stdout, "%p [label=\"%s\"]; \n", tree, tree->label);
    
    int i = 0;
    for (i = 0; i < tree->number_of_children; i++) {
        fprintf(stdout, "%p, %p\n", tree, tree->children[i]);
        exporta(tree->children[i]);
    }

    // Libera memória ao final da exportação
    free(tree->children);
    tree->children = NULL;
    free(tree->label);
    tree->label = NULL;
    free(tree);
    tree = NULL;

    return;
}