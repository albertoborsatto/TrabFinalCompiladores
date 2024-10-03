/* scanner.l */

%{
#include "tokens.h"

int line_number = 1;
%}

%option noyywrap
litInt      [0-9]+
litFloat    [0-9]*\.[0-9]+
identifier  [a-z_][a-zA-Z0-9_]*
comment     "//".*"\n"

%%

"int"           {return TK_PR_INT;}
"float"         {return TK_PR_FLOAT;}
"if"            {return TK_PR_IF;}
"else"          {return TK_PR_ELSE;}
"while"         {return TK_PR_WHILE;}
"return"        {return TK_PR_RETURN;}
"&"             {return TK_OC_AND;}
"|"             {return TK_OC_OR;}
"<="            {return TK_OC_LE;}
">="            {return TK_OC_GE;}
"=="            {return TK_OC_EQ;}
"!="            {return TK_OC_NE;}
"="             {return '=';}
"!"             {return '!';}
"*"             {return '*';}
"/"             {return '/';}
"%"             {return '%';}
"+"             {return '+';}
"-"             {return '-';}
"<"             {return '<';}
">"             {return '>';}
","             {return ',';}
";"             {return ';';}
"("             {return '(';}
")"             {return ')';}
"{"             {return '{';}
"}"             {return '}';}
" "             {}
{identifier}    {return TK_IDENTIFICADOR;}
{litInt}        {return TK_LIT_INT;}
{litFloat}      {return TK_LIT_FLOAT;}
{comment}       {line_number++;}
\n              {line_number++;}
.               {return TK_ERRO;}

%%

int get_line_number(void)
{
    return line_number;
}
