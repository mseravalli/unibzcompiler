%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include "../lib/headers.h"
#include "../lib/utilities.h"

i = 0;
%}

%union {
    char    *lexeme;
    float   floatnum;
    int     intnum;
    int     type;
	char*   result;
	char operatorType;
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
%type <result> Expression
%type <result> Bool_expression
%type <result> Bool_And_Expr
%type <result> Bool_Not_Expr   
%type <result> Preposition
%type <result> Rel_Expr 
%type <result> Arith_expression
%type <result> T
%type <result> F
%type <result> Condition

%type <operatorType> Relop
%type <operatorType> Addop
%type <operatorType> Multop

%start Scope
%%

Scope               : Marker Main               {/*print_symbols();*/}
                    ;

Marker              : /* emty */                {init();}
                    ;

Main                : START Body END;

Body                : Statements
                    ;

Statements          : /* empty */
                    | Statements Declaration SEMICOL
                    | Statements Assignment SEMICOL
                    | Statements Conditional
                    | Statements Whileloop
                    | Statements Marker2 Main           {exit_scope();}
                    ;

Marker2             : /* empty */                       { char* e = (char *)malloc(10*sizeof(char));
                                                          sprintf(e, "scope%d", i);
                                                          add_symbol(IDENTIFIER, e, yyline, 'v', 1);}
                    ;

Declaration         : INT { $<type>$ = 'i'; } Id_sequence
                    | FLOAT { $<type>$ = 'f'; } Id_sequence
                    | BOOL { $<type>$ = 'b'; } Id_sequence
                    ;

/* In this rule $0 is accessible directly as there is no other */
/* reduction of any other rules occur before the semantic action is */
/* reduced. */ 
Id_sequence : IDENTIFIER { printf("%s := 0\n" , $1);
                           if( find_symbol($1) == -1 ) {
                               add_symbol(IDENTIFIER, $1, yyline, $<type>0, 0);
                           } else {
							   printf("Error, %s already defined in line %d\n", $1, yyline);
                               exit(1);
                           } } 
			| IDENTIFIER ASSIGN Expression { printf("%s := %s\n", $1, $3);
                                            if( find_symbol($1) == -1 ) {
						             			add_symbol(IDENTIFIER, $1, yyline, $<type>0, 0);
								            } else {
							                   printf("Error, %s already defined in line %d\n", $1, yyline);
								               exit(1);
								           } } 
            | Id_sequence ',' IDENTIFIER { printf("%s := 0\n" , $3);
                                           if( find_symbol($3) == -1 ) {
                                               add_symbol(IDENTIFIER, $3, yyline, $<type>0, 0);
                                           } else {
							                   printf("Error, %s already defined in line %d\n", $3, yyline);
                                               exit(1);
                                           } }
			| Id_sequence ',' IDENTIFIER ASSIGN Expression{ printf("%s := %s\n", $3, $5);
                                                         	if( find_symbol($3) == -1 ) {
						                     				    add_symbol(IDENTIFIER, $3, yyline, $<type>0, 0);
						                           		    } else {
							                                    printf("Error, %s already defined in line %d\n", $3, yyline);
						                              		    exit(1);
														    } }
            ;

Assignment          : IDENTIFIER ASSIGN Expression { printf("%s isch %s\n", $1, $3);}
                    /*| Declaration ASSIGN Expression*/
                    ;

Condition           : Bool_expression { char *e = (char *)malloc(100*sizeof(char));
                                        sprintf(e, "if %s goto _\ngoto _", $1);
                                        $$ = e;}
                    ;

Ending              : Statements DONE;

Conditional         : IF '[' Condition ']' THEN Ending   {printf("%s\n", $3);}
                    | IF '[' Condition ']' THEN Statements Else ELSE Ending {printf("%s\n", $3);}
                    ;

Else                : /* empty */
                    | ELIF '[' Condition ']' THEN Statements Else {printf("%s\n", $3);}
                    ;

Whileloop           : WHILE '[' Condition ']' DO Ending {printf("_: %s\n_: \ngoto _\n", $3);}
                    ;

Expression 			: Bool_expression
					;


Relop				: EQUALS {$$ = '=';}
					| '<'  {$$ = '<';}
					| '>'  {$$ = '>';}
					;

Bool_expression : Bool_expression ODER Bool_And_Expr {$$ = ""; 
int num = i++; 
char* e = malloc(10*sizeof(char)); 
sprintf(e, "e%d", num);
$$ = e; 
printf("e%d := %s || %s\n",num,$1,$3); }
| Bool_And_Expr {$$ = $1;}
;

Bool_And_Expr : Bool_And_Expr UND Bool_Not_Expr {$$ = ""/*bool_compare($1, $3, '&')*/;int num = i++; 
char* e = malloc(10*sizeof(char)); 
sprintf(e, "e%d", num);
$$ = e ; 
printf("e%d := %s && %s\n",num,$1,$3); }
| Bool_Not_Expr {$$ = $1;}
;

Bool_Not_Expr : NET Preposition {$$ = ""/*bool_compare($2, NULL, '!')*/;int num = i++; 
char* e = malloc(10*sizeof(char)); 
sprintf(e, "e%d", num);
$$ = e; 
printf("e%d := NOT %s\n",num, $2); }
| Preposition {$$ = $1;}
| NET Rel_Expr {$$ = $2;}
| Rel_Expr {$$ = $1;}
;

Preposition : TRUE { int num = i++;
char* e = malloc(10*sizeof(char)); 
sprintf(e, "temp%d", num);
$$ = e; 
printf("temp%d := 1\n", num);}

| FALSE { int num = i++;
char* e = malloc(10*sizeof(char)); 
sprintf(e, "temp%d", num);
$$ = e; 
printf("temp%d := 0\n", num);}

| '[' Bool_expression ']' {$$ = $2;}
;

Rel_Expr : Rel_Expr Relop Arith_expression  {int num = i++; 
char* e = malloc(10*sizeof(char));
sprintf(e, "e%d", num);
$$ = e /*calculate($1, $3, $2)*/; 
printf("e%d := %s %c %s\n",num,$1,$2,$3);}
| Arith_expression {$$ = $1;}
;

Arith_expression    : Arith_expression Addop T {int num = i++; 
char* e = malloc(10*sizeof(char)); 
sprintf(e, "e%d", num);
$$ = e /*calculate($1, $3, $2)*/; 
printf("e%d := %s %c %s\n",num,$1,$2,$3);}
                    | T {$$ = $1;}
                    ;

T                   : T Multop F { int num = i++; 
char* e = malloc(10*sizeof(char)); 
sprintf(e, "t%d", num);
$$ = e/*calculate($1, $3, $2)*/; 
printf("t%d := %s %c %s\n", num,$1, $2, $3);}
                    | F {$$ = $1;}
                    ;

F                   : '(' Arith_expression ')' {$$ = $2;}
                    | IDENTIFIER {$$ = $1;}
                    | INT_NUM { int num = i++; 
char* e = malloc(10*sizeof(char)); 
sprintf(e, "temp%d", num);
$$ = e;
printf("temp%d := %d\n", num, $1);}
                    | FLOAT_NUM { int num = i++; 
char* e = malloc(10*sizeof(char)); 
sprintf(e, "temp%d", num);
$$ = e;
printf("temp%d := %f\n", num, $1);}
                    ;

Addop               : '+' {$$ = '+';}
                    | '-' {$$ = '-';}
                    ;

Multop              : '*' {$$ = '*';}
                    | '/' {$$ = '/';}
                    ;


%%
#include "../lex/lex.daitsch.c"

/* Called by yyparse on error.  */
void
yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}

