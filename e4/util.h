#ifndef _UTIL_H_
#define _UTIL_H_

#include "table.h"

void print_error(symbol_table *table, int line_number, char *value, type_content content_type, int error_code, int previous_line);

type_symbol type_infer(type_symbol type1, type_symbol type2);

#endif 