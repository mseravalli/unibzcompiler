%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
%}

%token BEGIN END
%token ID INT FLOAT VOID NUM
%token IF THEN ELIF ELSE
%token WHILE DO DONE
%start Program 
%%

Program             : Main
                    ;

Main                : BEGIN /* Statements */ END
                    ;

Statements          : /* nothing */
	                | Conditions
	                ;

Conditions          : IF '(' Expressions ')' THEN Ending
                    | IF '(' Expressions ')' THEN Statements Else ELSE Ending
                    ;

Ending              : Statements DONE;

Else                : /* nothing */
                    | ELIF Statements Else
                    ;

Expressions         : '--expr--'
                    ;

%%

#include "../lex/lex.daitsch.c"

void yyerror (char *s)
{
fprintf (stderr, "%s\n", s);
}
