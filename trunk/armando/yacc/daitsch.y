%{
#include <string.h>
#include <ctype.h>
#include <stdio.h>
%}

%token HALLO PFIATI
%token ID GENAU GANZ NUM
%token IF THEN ELIF ELSE
%token WHILE DO DONE
%start Program 
%%

Program             : Main     {printf("OK..\n"); exit(0);}
                    ;

Main                : HALLO Statements PFIATI
                    ;

Statements          : /* nothing */
                    | Statements Statements
	                | Conditions
	                | Whileloop
	                ;

Conditions          : IF '(' Expressions ')' THEN Ending
                    | IF '(' Expressions ')' THEN Statements Else ELSE Ending
                    ;

Whileloop           : WHILE '(' Expressions ')' DO Ending
                    ;

Ending              : Statements DONE;

Else                : /* nothing */
                    | ELIF Statements Else
                    ;

Expressions         : '--expr--'
                    ;

%%

#include "../lex/lex.daitsch.c"

