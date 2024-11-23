#include "table.h"

void init_symbol_table(symbol_table *table) {
    table->entries = malloc(sizeof(symbol_table_entry));
    if (!table->entries) {
        perror("Failed to allocate memory for symbol table");
        exit(EXIT_FAILURE);
    }
    table->size = 0;
    table->capacity = 1;
}

// make sure value is not null?
void add_entry(symbol_table *table, const char *value, table_contents contents) {
    if (table->size >= table->capacity) {
        table->capacity *= 2;
        table->entries = realloc(table->entries, table->capacity * sizeof(symbol_table_entry));
        if (!table->entries) {
            perror("Failed to reallocate memory for symbol table");
            exit(EXIT_FAILURE);
        }
    }

    table->entries[table->size].value = strdup(value);
    table->entries[table->size].table_contents = contents;
    table->size++;
}

void print_table_entry(symbol_table *table, int index) {
    // invalid index
    if (index >= table->size || index < 0)  {
        printf("Invalid index!\n");
    } else {
        printf("Entry %d:\n", index);
        printf("\tValue: %s\n", table->entries[index].value);
    }
    return;
}

int search_table_value(symbol_table *table, char *value) {
    for (int i = 0; i<table->size; i++) {
        if (strcmp(table->entries[i].value, value) == 0) {
            return 1;
        }
    }

    return 0;
}

void free_symbol_table(symbol_table *table) {
    for (size_t i = 0; i < table->size; i++) {
        free(table->entries[i].value); 
    }
    free(table->entries); 
    table->entries = NULL;
    table->size = 0;
    table->capacity = 0;
}