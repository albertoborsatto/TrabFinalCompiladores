#include "stack.h"
#include "table.h"

void init_table_stack(table_stack *stack) {
    stack->tables = malloc(sizeof(symbol_table));

    if (!stack->tables) {
        perror("Failed to allocate memory for table stack");
        exit(EXIT_FAILURE);
    }

     stack->size = 0;
}


void push_table_stack(table_stack *stack, symbol_table *table) {
    if (stack->size > 0) {
        stack->tables = realloc(stack->tables, (stack->size + 1) * sizeof(symbol_table));
    }

    if (!stack->tables) {
        perror("Failed to reallocate memory for table stack");
        exit(EXIT_FAILURE);
    }

    stack->tables[stack->size] = *table;
    stack->size++;
}

symbol_table pop_table_stack(table_stack *stack) {
    if (stack->size == 0) {
        return;
    }

    symbol_table popped_table = stack->tables[stack->size - 1];
    stack->size--;

    stack->tables = realloc(stack->tables, (stack->size) * sizeof(symbol_table));

    if (!stack->tables && stack->size > 0) {
        perror("Failed to reallocate memory for table stack after pop");
        exit(EXIT_FAILURE);
    }

    return popped_table;
}

void free_table_stack(table_stack *stack) {
    free(stack->tables);
    stack->tables = NULL;
}

int search_stack_value(table_stack *stack, char *value) {
    int searchResult;

    for (int i = (stack->size - 1); i >= 0; i--) {
        symbol_table table = stack->tables[i];
        searchResult = search_table_value(&table, value);

        if (searchResult == 1) {
            return searchResult;
        }
    }

    return searchResult;
}



