#ifndef _LEX_VALUE_H_
#define _LEX_VALUE_H_
#include "parser.tab.h"

typedef enum lex_type {
    LITERAL,
    IDENTIFIER
} type;

typedef struct lex_value
{
    int line_number;
    int type;
    char *value;
} valor_lexico;

valor_lexico create_lex_value(int line_number, int type, char *text);

#endif