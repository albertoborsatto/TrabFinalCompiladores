/* scanner.l */

%{
#include "tokens.h"

int line_number = 1;
%}

%option noyywrap

%%

"int"     {return TK_PR_INT;}
"float"   {return TK_PR_FLOAT;}
"if"      {return TK_PR_IF;}
"else"    {return TK_PR_ELSE;}
"while"   {return TK_PR_WHILE;}
"return"  {return TK_PR_RETURN;}
"&"       {return TK_OC_AND;}
"|"       {return TK_OC_OR;}
"\n"      {line_number++;}

%%

int get_line_number(void)
{
    return line_number;
}
