#include "util.h"

void print_error(symbol_table *table, int line_number, char *value, type_content content_type, int error_code, int previous_line) {
    const char *nature = (content_type == 0) ? "IDENTIFICADOR" : "FUNÇÃO";

    switch (error_code) {
        case 10:
             printf(
            "Erro semântico: O identificador '%s' (natureza: %s), referenciado na linha %d, não foi declarado.\n",
            value, nature, line_number);
            break;
        case 11:
             printf(
            "Erro semântico: O identificador '%s' (natureza: %s), declarado na linha %d, já foi declarado anteriormente na linha %d.\n",
            value, nature, line_number, previous_line);
            break;
        case 20:
            printf(
            "Erro semântico: O identificador '%s' (natureza: %s), declarado na linha %d, foi utilizado de maneira incorreta na linha %d.\n",
            value, nature, previous_line, line_number);
            break;
        case 21:
            printf(
            "Erro semântico: O identificador '%s' (natureza: %s), declarado na linha %d, foi utilizado de maneira incorreta na linha %d.\n",
            value, nature, previous_line, line_number);
            break;
            
    }

    exit(error_code);
}

type_symbol type_infer(type_symbol type1, type_symbol type2) {
    if (type1 == type2) {
        return type1;
    }

    if (type1 == FLOAT || type2 == FLOAT) {
        return FLOAT;
    }

    return UNDEFINED;
}