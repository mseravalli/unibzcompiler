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
                    | Type_specifier IDENTIFIER '[' INT_NUM ']' Id_sequence
                    ;

Id_sequence         : Id_sequence IDENTIFIER
                    | Id_sequence IDENTIFIER '[' INT_NUM ']'
                    |
                    ;

Type_specifier      : FLOAT
                    | INT
                    ;

Assignment          : IDENTIFIER ASSIGN Expression
                    | IDENTIFIER '[' INT_NUM ']' ASSIGN Expression
                    | Declaration ASSIGN Expression
                    ;

Condition           :
                    ;

Ending              : Statements DONE;

Conditional         : IF '(' Condition ')' THEN Ending
                    | IF '(' Condition ')' THEN Statements Else ELSE Ending
                    ;

Else                : /* empty */
                    | ELIF '(' Condition ')' THEN Statements Else
                    ;

Whileloop           : WHILE '(' Condition ')' DO Ending
                    ;

Expression          : Expression Addop T
                    | T
                    ;

T                   : T Multop F 
                    | F
                    ;

F                   : '(' Expression ')'
                    | IDENTIFIER
                    | IDENTIFIER '[' INT_NUM ']'
                    | INT_NUM
                    ;

Addop               : '+'
                    | '-'
                    ;

Multop              : '*'
                    | '/'
                    ;
%%

#include "../lex/lex.daitsch.c"

void yyerror (char *s)
{
fprintf (stderr, "%s\n", s);
}
