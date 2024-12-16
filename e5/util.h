#ifndef _UTIL_H_
#define _UTIL_H_

#include "table.h"
#include "stack.h"
#include "asd.h"

void print_error(symbol_table *table, int line_number, char *value, type_content content_type, int error_code, int previous_line);

type_symbol type_infer(type_symbol type1, type_symbol type2);

void add_symbol_entry(symbol_table *table, char *identifier, int line_number, type_content content_type, type_symbol symbol_type, char *content);

void check_table_and_add_entry(symbol_table *table, char *value, int line_number, type_content content_type, type_symbol symbol_type, char *content, int error_type);

void check_stack_and_add_entry(table_stack stack, symbol_table *table, char *value, int line_number, type_content content_type, type_symbol symbol_type, char *content, int error_type);

void check_symbol_content_type(table_stack stack, symbol_table *current_table, char *value, int line_number, type_content content_type, int previous_line, int error_type, asd_tree_t *tree);

char* get_temp();

char* get_label();

void int_to_string(char* str, int num);

char* strcat_return(const char* str1, const char* str2);

#endif 
