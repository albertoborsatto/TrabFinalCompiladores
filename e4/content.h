#ifndef _CONTENT_H_
#define _CONTENT_H_

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef enum type_c {
    IDENTIFIER,
    FUNCTION
} type_content;

typedef enum type_s {
    INT,
    FLOAT
} type_symbol;

typedef union content_value {
    int int_value;
    float float_value;
} content_value;

typedef struct content {
    int line_number;
    type_content content_type;
    type_symbol symbol_type;
    content_value content;
} table_contents;

table_contents create_table_content_entry(int line, type_content type_c, type_symbol type_s, content_value content_v);

#endif