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
%start scope
%%

scope           : main
                ;

main            : START body END

                ;

body            : statements
	            ;

statements      : /* epsylon */
                | declaration SEMICOL
	            | assignment SEMICOL
                ;

declaration     : type_specifier IDENTIFIER id_sequence
	            ;

id_sequence     : id_sequence IDENTIFIER
				| 
                ;

type_specifier  : FLOAT
                | INT
                ;

assignment      : IDENTIFIER ASSIGN expression
                | declaration ASSIGN expression
                ;

expression	: expression addop T
			| T
			;

T		: T multop F 
		| F
		;

F		: '('expression')'
		| IDENTIFIER
        | INT_NUM
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
