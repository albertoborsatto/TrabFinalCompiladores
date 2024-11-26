#ifndef _STACK_H_
#define _STACK_H_

#include <stdlib.h>
#include "table.h"

typedef struct table_stack {
    symbol_table *tables; 
    size_t size;          
} table_stack;

void init_table_stack(table_stack *stack);
void push_table_stack(table_stack *stack, symbol_table *table);
void pop_table_stack(table_stack *stack);
void free_table_stack(table_stack *stack);
int search_stack_value(table_stack *stack, char *value);
symbol_table search_stack_table(table_stack *stack, char *value);
symbol_table* get_top_table(table_stack *stack);
symbol_table* get_bottom_table(table_stack *stack);

#endif