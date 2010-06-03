%token HALLO PFIATI ID GENAU GANZ ISCH NUM
%start scope
%%

scope           : main
                ;

main            : HALLO body PFIATI
                ;

body            : statements ';'
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


type_specifier  : GENAU
                | GANZ
                ;

assignment      : ID ISCH expression
                | declaration ISCH expression
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

#include "../lex/lex.yy.c"

void yyerror (char *s)
{
fprintf (stderr, "%s\n", s);
}
