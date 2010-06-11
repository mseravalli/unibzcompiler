%option noyywrap
%{
#include <stdlib.h>
#include <string.h>
%}

DIGIT [0-9]
LETTER [a-zA-Z]
ID {LETTER}({LETTER}|{DIGIT})*

%%

[ ] { /* discarded characters */ }

{ID} {yylval.lexeme = strdup(yytext);
      return ID;} 

%%
