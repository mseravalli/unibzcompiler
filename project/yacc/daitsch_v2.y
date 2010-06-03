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
	            : multiple_declaration
	            ;

unary_declaration
                : type_specifier ID
                ;

//  MULTIPLE DECLARATIONS THROWS 2 REDUCE/REDUCE CONFLICTS
multiple_declaration
                : type_specifier ID id_sequence
                ;


id_sequence     : id_sequence, ID
		| 
                ;


type_specifier  : GENAU
                | GANZ
                ;

assignment      : ID ISCH expression
                | unary_declaration ISCH expression
                ;

expression	: expression addop T
		|T
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