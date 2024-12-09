#include "util.h"

void print_error(symbol_table *table, int line_number, char *value, type_content content_type, int error_code, int previous_line) {
    const char *nature = (content_type == 0) ? "IDENTIFICADOR" : "FUNÇÃO";

    switch (error_code) {
        case 10:
            fprintf(stderr,  "Erro semântico: O identificador '%s', referenciado na linha %d, não foi declarado.\n",
            value, line_number);
             break;
        case 11:
            fprintf(stderr, "Erro semântico: O identificador '%s' (natureza: %s), declarado na linha %d, já foi declarado anteriormente na linha %d.\n",
            value, nature, line_number, previous_line);
            break;
        case 20:
            fprintf(stderr, "Erro semântico: O identificador '%s' (natureza: %s), declarado na linha %d, foi utilizado de maneira incorreta na linha %d.\n",
            value, nature, previous_line, line_number);
            break;
        case 21:
            fprintf(stderr, "Erro semântico: O identificador '%s' (natureza: %s), declarado na linha %d, foi utilizado de maneira incorreta na linha %d.\n",
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

void add_symbol_entry(symbol_table *table, char *identifier, int line_number, type_content content_type, type_symbol symbol_type, char *content) {
    table_contents contents = {line_number, content_type, symbol_type, content};
    add_entry(table, identifier, contents);
}

void check_table_and_add_entry(symbol_table *table, char *value, int line_number, type_content content_type, type_symbol symbol_type, char *content, int error_type) {
    int previous_line = -1;
    
    if (!search_table_value(table, value, &previous_line)) {
        add_symbol_entry(table, value, line_number, content_type, symbol_type, content);
    } else {
        print_error(table, line_number, value, content_type, error_type, previous_line);
    }
}

void check_stack_and_add_entry(table_stack stack, symbol_table *table, char *value, int line_number, type_content content_type, type_symbol symbol_type, char *content, int error_type) {
    int previous_line = -1;
    
    if (!search_stack_value(&stack, value, &previous_line)) {
        add_symbol_entry(table, value, line_number, content_type, symbol_type, content);
    } else {
        print_error(table, line_number, value, content_type, error_type, previous_line);
    }

}

void check_symbol_content_type(table_stack stack, symbol_table *current_table, char *value, int line_number, type_content content_type, int previous_line, int error_type, asd_tree_t *tree) {
    symbol_table table = search_stack_table(&stack, value);
    symbol_table_entry entry = get_table_entry(&table, value);
    
    if (entry.table_contents.content_type != content_type) {
        print_error(current_table, line_number, value, ID, content_type == FUNCTION ? ID : FUNCTION, previous_line);
    }

    if (content_type == ID) {
        tree->type = entry.table_contents.content_type;
    }
}

