%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
%}

%token START END
%token IDENTIFIER INT FLOAT BOOL VOID
%token INT_NUM TRUE FALSE
%token NET UND ODER
%token ASSIGN EQUALS
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
                    ;

Id_sequence         : Id_sequence IDENTIFIER
                    |
                    ;

Type_specifier      : FLOAT
                    | INT
					| BOOL
                    ;

Assignment          : IDENTIFIER ASSIGN Expression
                    | Declaration ASSIGN Expression
                    ;

Condition           : Bool_expression
                    ;

Ending              : Statements DONE;

Conditional         : IF '[' Condition ']' THEN Ending
                    | IF '[' Condition ']' THEN Statements Else ELSE Ending
                    ;

Else                : /* empty */
                    | ELIF '[' Condition ']' THEN Statements Else
                    ;

Whileloop           : WHILE '[' Condition ']' DO Ending
                    ;

Expression 			: Bool_Not_Expr
					;


Relop				: EQUALS
					| '<'
					| '>'
					;

Bool_expression		: Bool_expression ODER Bool_And_Expr
					| Bool_And_Expr
					;

Bool_And_Expr		: Bool_And_Expr UND Bool_Not_Expr
					| Bool_Not_Expr
					;

Bool_Not_Expr		: NET Preposition
					| Preposition
					| NET Rel_Expr
					| Rel_Expr
					;

Preposition			: TRUE 
					| FALSE
					| '[' Bool_expression ']'
					;

Rel_Expr			: Rel_Expr Relop Arith_expression
					| Arith_expression
					;

Arith_expression    : Arith_expression Addop T
                    | T
                    ;

T                   : T Multop F 
                    | F
                    ;

F                   : '(' Arith_expression ')'
                    | IDENTIFIER
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
