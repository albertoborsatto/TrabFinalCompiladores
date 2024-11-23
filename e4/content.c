#include "content.h"

table_contents create_table_content_entry(int line, type_content type_c, type_symbol type_s, content_value content_v) {
    table_contents table_content_entry;
    table_content_entry.line_number = line;
    table_content_entry.content_type = type_c;
    table_content_entry.symbol_type = type_s;
    table_content_entry.content = content_v;
    
    return table_content_entry;
}