%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include "../lib/headers.h"
%}

%union {
    char* lexeme;
    float floatnum;
    int   intnum;
    int   type;
}
%token START END
%token INT FLOAT BOOL VOID
%token TRUE FALSE
%token NET UND ODER
%token ASSIGN EQUALS
%token IF THEN ELIF ELSE
%token WHILE DO DONE SEMICOL
%token <intnum> INT_NUM
%token <floatnum> FLOAT_NUM
%token <lexeme> IDENTIFIER

%type <type> Type_specifier
%start Scope
%%

Scope               : Main              {print_symbols();}
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

Declaration         : Type_specifier IDENTIFIER { add_symbol(IDENTIFIER, $2, $1); } Id_sequence
                    ;

Id_sequence         : Id_sequence IDENTIFIER
                    |
                    ;

Type_specifier      : FLOAT {$$ = FLOAT;}
                    | INT {$$ = INT;}
					| BOOL {$$ = BOOL;}
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
