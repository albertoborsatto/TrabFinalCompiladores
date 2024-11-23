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

void free_symbol_table(symbol_table *table) {
    for (size_t i = 0; i < table->size; i++) {
        free(table->entries[i].value); 
    }
    free(table->entries); 
    table->entries = NULL;
    table->size = 0;
    table->capacity = 0;
}