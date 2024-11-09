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