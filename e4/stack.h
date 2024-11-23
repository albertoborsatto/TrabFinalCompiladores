#ifndef _STACK_H_
#define _STACK_H_

#include <stdlib.h>
#include "table.h"

typedef struct table_stack {
    symbol_table *tables; // Array dinâmico de tabelas de símbolos
    size_t size;          // Número atual de tabelas na pilha
} table_stack;

void init_table_stack(table_stack *stack);
void push_table_stack(table_stack *stack, symbol_table *table);
symbol_table pop_table_stack(table_stack *stack);
void free_table_stack(table_stack *stack);

#endif