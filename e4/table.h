#ifndef _TABLE_H_
#define _TABLE_H_

#include "content.h"

typedef struct symbol_table_e {
    char *value;
    table_contents table_contents;
} symbol_table_entry;

typedef struct symbol_table {
    symbol_table_entry *entries;
    size_t size;        
    size_t capacity;
} symbol_table;

void init_symbol_table(symbol_table *table);

void add_entry(symbol_table *table, const char *value, table_contents contents);

void free_symbol_table(symbol_table *table);

void print_table_entry(symbol_table *table, int index);

#endif 