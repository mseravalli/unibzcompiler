%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
%}

%token START END
%token ID INT FLOAT VOID NUM
%token ASSIGN
%token IF THEN ELIF ELSE
%token WHILE DO DONE SEMICOL
%start scope
%%

scope           : main
                ;

main            : START body END
                ;

body            : statements SEMICOL
	            ;

statements      : declaration
	            | assignment
	            ;

declaration
	            : type_specifier ID id_sequence
	            ;

id_sequence     : id_sequence ID
				| 
                ;


type_specifier  : FLOAT
                | INT
                ;

assignment      : ID ASSIGN expression
                | declaration ASSIGN expression
                ;

expression	: expression addop T
			| T
			;

T		: T multop F 
		| F
		;

F		: '('expression')'
		| ID
		;

addop		: '+'
			| '-'
			;

multop		: '*'
			| '/'
			;
%%
#include "../lex/lex.daitsch.c"

void yyerror (char *s)
{
fprintf (stderr, "%s\n", s);
}
