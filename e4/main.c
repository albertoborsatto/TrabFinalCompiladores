#include <stdio.h>
#include <stdlib.h>
#include "asd.h"
#include "table.h"
#include "stack.h"

extern int yyparse(void);
extern int yylex_destroy(void);
void *arvore = NULL;
void exporta (void *arvore);
int main (int argc, char **argv)
{
//   int ret = yyparse(); 
//   exporta (arvore);
//   yylex_destroy();
//   return ret;
    // gcc main.c asd.c table.c stack.c -o main -Wall -g
    symbol_table table;
    init_symbol_table(&table);

    table_contents contents1 = {1, IDENTIFIER, INT, {.int_value = 42}};
    add_entry(&table, "x", contents1);

    table_contents contents2 = {2, FUNCTION, FLOAT, {.float_value = 3.14}};
    add_entry(&table, "y", contents2);

    print_table_entry(&table, 0);

    print_table_entry(&table, 1); 

    print_table_entry(&table, 2);

    printf("capacity: %ld\n", table.capacity);

    table_stack table_stack;

    init_table_stack(&table_stack);
    push_table_stack(&table_stack, &table);
    symbol_table tico = pop_table_stack(&table_stack);

    print_table_entry(&tico, 0);

    //free_symbol_table(&table);
    return 0;
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