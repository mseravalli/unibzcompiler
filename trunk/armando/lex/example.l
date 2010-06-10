%option noyywrap
%{
#include <stdlib.h>
#include <string.h>
%}

DIGIT [0-9]
LETTER [a-zA-Z]
DIGITS {DIGIT}* 

ID {LETTER}({LETTER}|{DIGIT}|[_-])*

%%

[ \t\n] { /* discarded characters */ }

{ID} {  yylval.lexeme = strdup(yytext);
        return ID; } 

%%
