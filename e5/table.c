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
    if (index >= table->size || index < 0)  {
        printf("Invalid index!\n");
    } else {
        printf("Entry %d:\n", index);
        printf("\tValue: %s\n", table->entries[index].value);
        printf("\tOfsset: %d\n", table->entries[index].table_contents.offset);
    }
    return;
}

void print_table(symbol_table *table) {
    printf("Table:\n");

    for (int i = 0; i < table->size; i++) {
        symbol_table_entry entry = table->entries[i];
        char *content_type;
        char *symbol_type;
        if (entry.table_contents.content_type == 0) {
            content_type = "ID";
        } else {
            content_type = "FUNCTION";
        }

        if (entry.table_contents.symbol_type == 0) {
            symbol_type = "INT";
        } else {
            symbol_type = "FLOAT";
        }

        printf("\tValue: %s | ", entry.value);
        printf("\t Line Number: %d |", entry.table_contents.line_number);
        printf("\t Type Content: %s |", content_type);
        printf("\t Symbol Type: %s |", symbol_type);
        printf("\t Content: %s\n ", entry.table_contents.content);
        printf("\t Offset: %d\n", entry.table_contents.offset);
    }
}

symbol_table_entry get_table_entry(symbol_table *table, char *value) {
    for (int i = 0; i<table->size; i++) {
        if (strcmp(table->entries[i].value, value) == 0) {
            return table->entries[i];
        }
    }
}

int search_table_value(symbol_table *table, char *value, int *previous_line) {
    for (int i = 0; i<table->size; i++) {
        if (strcmp(table->entries[i].value, value) == 0) {
            *previous_line = table->entries[i].table_contents.line_number;
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

void fill_type(symbol_table *table, type_symbol type_symbol) {
    for (int i = 0; i < table->size; i++) {
        if (table->entries[i].table_contents.symbol_type == UNDEFINED) {
            table->entries[i].table_contents.symbol_type = type_symbol;
        }
    }

    return;
}
