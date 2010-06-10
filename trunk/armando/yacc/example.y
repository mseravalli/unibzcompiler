%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include "../lex/lex.example.c"
#include "../lib/headers.h"
%}

%union
{
    char* lexeme;
    int   token;
}

%token <token> ID
%start Scope
%%

Scope               : Program               {print_symbols();}
                    ;

Program             : Program ID            {add_symbol($2, yylval.lexeme, 0);}
                    | /* empty string */
                    ;

%%

/*
void yyerror (char *s)
{
    fprintf (stderr, "%s\n", s);
}
*/
