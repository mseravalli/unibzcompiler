%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
%}

%token START END
%token IDENTIFIER INT FLOAT VOID
%token INT_NUM
%token ASSIGN
%token IF THEN ELIF ELSE
%token WHILE DO DONE SEMICOL
%token ADDOP SUBOP MULTOP DIVOP
%token OPBR CLBR

%start Scope
%%

Scope               : Main
                    ;

Main                : START Body END;

Body                : Statements
                    ;

Statements          : /* empty */
                    | Statements Declaration SEMICOL
                    | Statements Assignment SEMICOL
                    | Statements Conditional
                    | Statements Whileloop
                    ;

Declaration         : Type_specifier IDENTIFIER Id_sequence
                    ;

Id_sequence         : Id_sequence IDENTIFIER
                    | 
                    ;

Type_specifier      : FLOAT
                    | INT
                    ;

Assignment          : IDENTIFIER ASSIGN Expression
                    | Declaration ASSIGN Expression
                    ;

Condition           :
                    ;

Ending              : Statements DONE;

Conditional         : IF OPBR Condition CLBR THEN Ending
                    | IF OPBR Condition CLBR THEN Statements Else ELSE Ending
                    ;

Else                : /* empty */
                    | ELIF OPBR Condition CLBR THEN Statements Else
                    ;

Whileloop           : WHILE OPBR Condition CLBR DO Ending
                    ;

Expression          : Expression Addop T
                    | T
                    ;

T                   : T Multop F 
                    | F
                    ;

F                   : OPBR Expression CLBR
                    | IDENTIFIER
                    | INT_NUM
                    ;

Addop               : ADDOP
                    | SUBOP
                    ;

Multop              : MULTOP
                    | DIVOP
                    ;
%%

#include "../lex/lex.daitsch.c"

void yyerror (char *s)
{
fprintf (stderr, "%s\n", s);
}
