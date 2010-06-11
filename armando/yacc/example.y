%{
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include "../lib/headers.h"
%}

%union
{
    char* lexeme;
}

%token <lexeme> ID
%start Scope
%%

Scope               : Program               {printf("ciccio\n");}
                    ;

Program             : ID                    {printf("lexeme\n");}
                    ;

%%
#include "../lex/lex.example.c"
void yyerror (char *s)
{
    fprintf (stderr, "%s\n", s);
}
