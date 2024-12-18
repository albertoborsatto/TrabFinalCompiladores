#include "stack.h"
#include "table.h"

void init_table_stack(table_stack *stack) {
    if (!stack) {
        perror("Failed to allocate memory for table stack");
        exit(EXIT_FAILURE);
    }
    
    stack->tables = NULL; 
    stack->size = 0;
}



void push_table_stack(table_stack *stack, symbol_table *table) {
    if (!stack || !table) {
        perror("Failed to allocate memory for table stack");
        exit(EXIT_FAILURE);
    }
    
    if (stack->tables == NULL) {
        stack->tables = malloc(sizeof(symbol_table));
    } else {
        stack->tables = realloc(stack->tables, (stack->size + 1) * sizeof(symbol_table));
    }
    
    if (!stack->tables) {
        perror("Failed to reallocate memory for table stack");
        exit(EXIT_FAILURE);
    }

    stack->tables[stack->size] = *table;
    stack->size++;
}

void pop_table_stack(table_stack *stack) {
    if (!stack || stack->size == 0) {
        fprintf(stderr, "Invalid operation: Stack is either NULL or empty.\n");
        return;
    }

    stack->size--;

    if (stack->size == 0) {
        free_table_stack(stack);
    } else {
        stack->tables = realloc(stack->tables, stack->size * sizeof(symbol_table));
        if (!stack->tables) {
            perror("Failed to reallocate memory for table stack after pop");
            exit(EXIT_FAILURE);
        }
    }
}

void free_table_stack(table_stack *stack) {
    if (!stack) {
        perror("Failed to allocate memory for table stack");
        exit(EXIT_FAILURE);
    }

    free(stack->tables);
    stack->tables = NULL;
}

int search_stack_value(table_stack *stack, char *value, int *previous_line) {
    if (!stack) {
        perror("Failed to allocate memory for table stack");
        exit(EXIT_FAILURE);
    }

    int searchResult;

    for (int i = (stack->size - 1); i >= 0; i--) {
        symbol_table table = stack->tables[i];
        searchResult = search_table_value(&table, value, previous_line);

        if (searchResult == 1) {
            return searchResult;
        }
    }
    
    return searchResult;
}

symbol_table search_stack_table(table_stack *stack, char *value) {
    if (!stack) {
        perror("Failed to allocate memory for table stack");
        exit(EXIT_FAILURE);
    }

    int searchResult;
    int previous_line = -1;
    
    for (int i = (stack->size - 1); i >= 0; i--) {
        symbol_table table = stack->tables[i];
        searchResult = search_table_value(&table, value, &previous_line);

        if (searchResult == 1) {
            return table;
        }
    }
}

symbol_table* get_top_table(table_stack *stack) {
    if (!stack) {
        perror("Failed to allocate memory for table stack");
        exit(EXIT_FAILURE);
    }

    int last_index = stack->size - 1;

    if (last_index < 0) {
        perror("Stack is empty");
        exit(EXIT_FAILURE);
    }

    return &stack->tables[last_index];
}

symbol_table* get_bottom_table(table_stack *stack) {
    if (!stack) {
        perror("Failed to allocate memory for table stack");
        exit(EXIT_FAILURE);
    }

    int index = stack->size - 2;

    if (index < 0) {
        perror("Stack is empty");
        exit(EXIT_FAILURE);
    }

    return &stack->tables[index];
}



