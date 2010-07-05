%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include "../lib/headers.h"
#include "../lib/utilities.h"
%}

%union {
    char    *lexeme;
    float   floatnum;
    int     intnum;
    int     type;
	char*   result;
	int     op_t;       // operator type (int value)
	char    op_c;       // operator type (char value)
}
%token START END
%token <type> INT
%token <type> FLOAT
%token <type> BOOL
%token <type> VOID
%token TRUE FALSE
%token NOT AND OR
%token ASSIGN EQ SM BG EQSM EQBG
%token IF THEN ELIF ELSE
%token WHILE DO DONE SEMICOL
%token <intnum> INTNUM
%token <floatnum> FLOATNUM
%token <lexeme> ID

%type <type> Declaration
/*%type <type> Type_specifier*/
%type <type> Id_Seq
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

%type <op_t> Relop
%type <op_c> Addop
%type <op_c>Multop

%start Scope
%%

Scope                       : M1 Main                                   /* { print_symbols(); } */
                            ;

M1                          : /* emty */                                { init(); }
                            ;

Main                        : START Body END;

Body                        : Stmts
                            ;

Stmts                       : /* empty */
                            | Stmts Declaration SEMICOL
                            | Stmts Assignment SEMICOL
                            | Stmts Conditional
                            | Stmts Whileloop
                            | Stmts M2 Main                             { exit_scope(); }
                            ;

M2                          : /* empty */                               { char* e = (char *)malloc(10*sizeof(char));
                                                                          sprintf(e, "scope%d", i);
                                                                          add_symbol(ID, e, yyline, 'v', 1);}
                            ;

Declaration                 : INT { $<type>$ = 'i'; } Id_Seq
                            | FLOAT { $<type>$ = 'f'; } Id_Seq
                            | BOOL { $<type>$ = 'b'; } Id_Seq
                            ;

/* In this rule $0 is accessible directly as there is no other */
/* reduction of any other rules occur before the semantic action is */
/* reduced. */ 
Id_Seq                      : ID                                { sym_node *r = NULL;
                                                                          scope *s = NULL;
                                                                          scope *actual = this_scope();

                                                                          find_symbol($1, &r, &s);
                                                                          if(r == NULL || s != actual) {
                                                                              add_symbol(ID, $1, yyline, $<type>0, 0);
                                                                              printf("%s := 0\n" , $1);
                                                                          } else {
                                                                              printf("1. Error line: %d; %s already defined.\n", yyline, $1);
                                                                              exit(1);
                                                                          } }

                            | ID ASSIGN Expression              { sym_node *r = NULL;
                                                                          scope *s = NULL;
                                                                          scope *actual = this_scope();

                                                                          if(r == NULL || s != actual) {
                                                                              add_symbol(ID, $1, yyline, $<type>0, 0);
                                                                              printf("%s := %s\n", $1, $3);
                                                                          } else {
                                                                              printf("2. Error line: %d; %s already defined.\n", yyline, $1);
                                                                              exit(1);
                                                                          } } 

                            | Id_Seq ',' ID                     { sym_node *r = NULL;
                                                                          scope *s = NULL;
                                                                          scope *actual = this_scope();

                                                                          find_symbol($1, &r, &s);
                                                                          if(r == NULL || s != actual) {
                                                                              add_symbol(ID, $3, yyline, $<type>0, 0);
                                                                              printf("%d := %s\n", $1, $3);
                                                                          } else {
                                                                              printf("3. Error line %d; %s already defined.\n", yyline, $3);
                                                                              exit(1);
                                                                          } }

                            | Id_Seq ',' ID ASSIGN Expression   { sym_node *r = NULL;
                                                                          scope *s = NULL;
                                                                          scope *actual = this_scope();

                                                                          find_symbol($3, &r, &s);
                                                                          if(r == NULL || s != actual) {
                                                                              add_symbol(ID, $3, yyline, $<type>0, 0);
                                                                              printf("%s := %s\n", $3, $5);
                                                                          } else {
                                                                              printf("4. Error line %d; %s already defined.\n", yyline, $3);
                                                                              exit(1);
                                                                          } }
                            ;

Assignment                  : ID ASSIGN Expression              { sym_node *r = NULL;
                                                                          scope *s = NULL;

                                                                          find_symbol($1, &r, &s);
                                                                          if(r != NULL) {
                                                                              printf("%s isch %s\n", $1, $3);
                                                                          } else {
                                                                              printf("1. Error line: %d; %s not defined.\n", yyline, $1);
                                                                              exit(1);
                                                                          } }
                            ;

Condition                   : Bool_expression                           { char *e = (char *)malloc(100*sizeof(char));
                                                                          sprintf(e, "if %s goto _\ngoto _", $1);
                                                                          $$ = e;}
                            ;

Ending                      : Stmts DONE;

Conditional                 : IF '[' Condition ']' THEN Ending          { printf("%s\n", $3); }
                            | IF '[' Condition ']' THEN Stmts Else ELSE Ending {printf("%s\n", $3);}
                            ;

Else                        : /* empty */
                            | ELIF '[' Condition ']' THEN Stmts Else    { printf("%s\n", $3); }
                            ;

Whileloop                   : WHILE '[' Condition ']' DO Ending         { printf("_: %s\n_: \ngoto _\n", $3); }
                            ;

Expression 			        : Bool_expression
					        ;


Relop                       : EQ                                        { $$ = EQ; }
                            | BG                                        { $$ = BG; }
                            | SM                                        { $$ = SM; }
                            | EQSM                                      { $$ = EQBG; }
                            | EQBG                                      { $$ = EQSM; }

                            ;

Bool_expression             : Bool_expression OR Bool_And_Expr          { $$ = ""; 
                                                                          int num = i++; 
                                                                          char* e = malloc(10*sizeof(char)); 
                                                                          sprintf(e, "e%d", num);
                                                                          $$ = e; 
                                                                          printf("e%d := %s || %s\n",num,$1,$3); }
                            | Bool_And_Expr                             { $$ = $1; }
                            ;

Bool_And_Expr               : Bool_And_Expr AND Bool_Not_Expr           { $$ = "";
                                                                          int num = i++; 
                                                                          char* e = malloc(10*sizeof(char)); 
                                                                          sprintf(e, "e%d", num);
                                                                          $$ = e ; 
                                                                          printf("e%d := %s && %s\n",num,$1,$3); }
                            | Bool_Not_Expr                             { $$ = $1; }
                            ;

Bool_Not_Expr               : NOT Preposition                           { $$ = "";
                                                                          int num = i++; 
                                                                          char* e = malloc(10*sizeof(char)); 
                                                                          sprintf(e, "e%d", num);
                                                                          $$ = e; 
                                                                          printf("e%d := NOT %s\n",num, $2); }
                            | Preposition                               { $$ = $1; }
                            | NOT Rel_Expr                              { $$ = $2; }
                            | Rel_Expr                                  { $$ = $1; }
                            ;

Preposition                 : TRUE                                      { int num = i++;
                                                                          char* e = malloc(10*sizeof(char)); 
                                                                          sprintf(e, "temp%d", num);
                                                                          $$ = e; 
                                                                          printf("temp%d := 1\n", num);}

                            | FALSE                                     { int num = i++;
                                                                          char* e = malloc(10*sizeof(char)); 
                                                                          sprintf(e, "temp%d", num);
                                                                          $$ = e; 
                                                                          printf("temp%d := 0\n", num);}
                            | '[' Bool_expression ']'                   { $$ = $2; }
                            ;

Rel_Expr                    : Rel_Expr Relop Arith_expression           { int num = i++; 
                                                                          char* e = malloc(10*sizeof(char));
                                                                          sprintf(e, "e%d", num);
                                                                          $$ = e; 
                                                                          switch($2) {
                                                                            case EQ:
                                                                                printf("e%d := %s = %s\n",num,$1,$3);
                                                                                break;

                                                                            case BG:
                                                                                printf("e%d := %s > %s\n",num,$1,$3);
                                                                                break;

                                                                            case SM:
                                                                                printf("e%d := %s < %s\n",num,$1,$3);
                                                                                break;
                                                                            case EQBG:
                                                                                printf("e%d := %s >= %s\n",num,$1,$3);
                                                                                break;

                                                                            case EQSM:
                                                                                printf("e%d := %s <= %s\n",num,$1,$3);
                                                                                break;
                                                                          } }
                            | Arith_expression                          { $$ = $1; }
                            ;

Arith_expression            : Arith_expression Addop T                  { int num = i++; 
                                                                          char* e = malloc(10*sizeof(char)); 
                                                                          sprintf(e, "e%d", num);
                                                                          $$ = e;
                                                                          printf("e%d := %s %c %s\n",num,$1,$2,$3);
                                                                        }
                            | T                                         { $$ = $1; }
                            ;

T                           : T Multop F                                { int num = i++; 
                                                                          char* e = malloc(10*sizeof(char)); 
                                                                          sprintf(e, "t%d", num);
                                                                          $$ = e/*calculate($1, $3, $2)*/; 
                                                                          printf("t%d := %s %c %s\n", num,$1, $2, $3);}
                            | F                                         { $$ = $1; }
                            ;

F                           : '(' Arith_expression ')'                  { $$ = $2; }
                            | ID                                        { $$ = $1; }
                            | INTNUM                                   { int num = i++; 
                                                                          char* e = malloc(10*sizeof(char)); 
                                                                          sprintf(e, "temp%d", num);
                                                                          $$ = e;
                                                                          printf("temp%d := %d\n", num, $1);}
                            | FLOATNUM                                 { int num = i++; 
                                                                          char* e = malloc(10*sizeof(char)); 
                                                                          sprintf(e, "temp%d", num);
                                                                          $$ = e;
                                                                          printf("temp%d := %f\n", num, $1);}
                            ;

Addop                       : '+'                                       { $$ = '+'; }
                            | '-'                                       { $$ = '-'; }
                            ;

Multop                      : '*'                                       { $$ = '*'; }
                            | '/'                                       { $$ = '/'; }
                            ;


%%
#include "../lex/lex.daitsch.c"

/* Called by yyparse on error.  */
void
yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}
