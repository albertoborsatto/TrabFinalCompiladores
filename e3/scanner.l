/* scanner.l */

%{
#include "parser.tab.h"
#include "valor_lexico.h"
int line_number = 1;
%}

%option noyywrap
digit       [0-9]
letter      [a-zA-Z]
lowerLetter [a-z]
litInt      {digit}+
litFloat    {digit}*\.{digit}+
identifier  ({lowerLetter}|_)({letter}|{digit}|_)*
comment     "//".*"\n"

%%

"int"           {return TK_PR_INT;}
"float"         {return TK_PR_FLOAT;}
"if"            {return TK_PR_IF;}
"else"          {return TK_PR_ELSE;}
"while"         {return TK_PR_WHILE;}
"return"        {return TK_PR_RETURN;}


"-"             {return '-';}
"!"             {return '!';}
"*"             {return '*';}
"/"             {return '/';}
"%"             {return '%';}
"+"             {return '+';}
"<"             {return '<';}
">"             {return '>';}
"{"             {return '{';}
"}"             {return '}';}
"("             {return '(';}
")"             {return ')';}
"="             {return '=';}
","             {return ',';}
";"             {return ';';}


"<="            {return TK_OC_LE;}
">="            {return TK_OC_GE;}
"=="            {return TK_OC_EQ;}
"!="            {return TK_OC_NE;}
"&"             {return TK_OC_AND;}
"|"             {return TK_OC_OR;}


" "             {}
"\t"            {}
{identifier}    { yylval.val_lexico = create_lex_value(IDENTIFIER, yytext); return TK_IDENTIFICADOR; }
{litInt}        { yylval.val_lexico = create_lex_value(LITERAL, yytext); return TK_LIT_INT; }
{litFloat}      { yylval.val_lexico = create_lex_value(LITERAL, yytext); return TK_LIT_FLOAT; }
{comment}       {line_number++;}
\n              {line_number++;}
.               {return TK_ERRO;}

%%

int get_line_number(void)
{
    return line_number;
}

valor_lexico create_lex_value(int type, const char *text) {
    valor_lexico value;
    value.line_number = get_line_number();
    value.type = type;
    value.value = strdup(text); 
    
    return value;
}
