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
	char*   result;
}
%token START END
%token <type> INT
%token <type> FLOAT
%token <type> BOOL
%token <type> VOID
%token TRUE FALSE
%token NET UND ODER
%token ASSIGN EQUALS
%token IF THEN ELIF ELSE
%token WHILE DO DONE SEMICOL
%token <intnum> INT_NUM
%token <floatnum> FLOAT_NUM
%token <lexeme> IDENTIFIER

%type <type> Declaration
/*%type <type> Type_specifier*/
%type <type> Id_sequence
%type <result> Bool_expression
%type <result> Bool_And_Expr
%type <result> Bool_Not_Expr   
%type <result> Preposition
%type <result> Rel_Expr 
%type <result> Arith_expression
%type <result> T
%type <result> F

%type <intnum> Relop
%type <intnum> Addop
%type <intnum> Multop



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

/*
Declaration         : Type_specifier IDENTIFIER { if( find_symbol($2) == -1 ) {
                                                                    add_symbol(IDENTIFIER, $2, $1);
                                                                } else {
                                                                    printf("Sorry, identifier %s already defined\n", $2);
                                                                    exit(1);
                                                                }
                                                              } Id_sequence
                    ;

Id_sequence         : Id_sequence IDENTIFIER
                    |
                    ;

Type_specifier      : FLOAT {$$ = FLOAT;}
                    | INT {$$ = INT;}
					| BOOL {$$ = BOOL;}
                    ;

*/

Declaration
    : INT { $<type>$ = INT; } Id_sequence
    | FLOAT { $<type>$ = FLOAT; } Id_sequence
    | BOOL { $<type>$ = BOOL; } Id_sequence
    ;

/* In this rule $0 is accessible directly as there is no other */
/* reduction of any other rules occur before the semantic action is */
/* reduced. */ 
Id_sequence : IDENTIFIER { if( find_symbol($1) == -1 ) {
                               add_symbol(IDENTIFIER, $1, $<type>0);
                           } else {
                               printf("Sorry, identifier %s already defined\n", $1);
                               exit(1);
                           } } 
            | Id_sequence IDENTIFIER { if( find_symbol($2) == -1 ) {
                                           add_symbol(IDENTIFIER, $2, $<type>0);
                                       } else {
                                           printf("Sorry, identifier %s already defined\n", $2);
                                           exit(1);
                                       } }
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

Expression 			: Bool_expression
					;


Relop				: EQUALS {$$ = 3;}
					| '<'  {$$ = 4;}
					| '>'  {$$ = 5;}
					;

Bool_expression		: Bool_expression ODER Bool_And_Expr {$$ = compare($1, $3, 0);}
					| Bool_And_Expr {$$ = $1;}
					;

Bool_And_Expr		: Bool_And_Expr UND Bool_Not_Expr {$$ = compare($1, $3, 1);}
					| Bool_Not_Expr {$$ = $1;}
					;

Bool_Not_Expr		: NET Preposition {$$ = compare($2, "", 2);}
					| Preposition {$$ = $1;}
					| NET Rel_Expr {$$ = $2;}
					| Rel_Expr {$$ = $1;}
					;

Preposition			: TRUE {$$ = "1";}
					| FALSE {$$ = "0";}
					| '[' Bool_expression ']' {$$ = $2;}
					;

Rel_Expr			: Rel_Expr Relop Arith_expression {$$ = compare($1, $3, $2); printf("first %s\n",$1);}
					| Arith_expression {$$ = $1;}
					;

Arith_expression    : Arith_expression Addop T {$$ = calculate($1, $3, $2);}
                    | T {$$ = $1;}
                    ;

T                   : T Multop F {$$ = calculate($1, $3, $2);}
                    | F {$$ = $1;}
                    ;

F                   : '(' Arith_expression ')' {$$ = $2;}
                    | IDENTIFIER {$$ = $1;}
                    | INT_NUM { $$ = itoa($1); }
					| FLOAT_NUM {$$ = ftoa($1); }
                    ;

Addop               : '+' {$$ = 0;}
                    | '-' {$$ = 1;}
                    ;

Multop              : '*' {$$ = 2;}
                    | '/' {$$ = 3;}
                    ;


%%
#include "../lex/lex.daitsch.c"

/* Called by yyparse on error.  */
void
yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}
