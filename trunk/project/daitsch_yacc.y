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
	            : unary_declaration
	            | multiple_declaration
	            ;

unary_declaration
                : type_specifier ID
                ;

multiple_declaration
                : type_specifier ID id_sequence
                ;

id_sequence     : 
                | , ID
                | id_sequence
                ;

type_specifier  : GENAU
                | GANZ
                ;

assignment      : ID ISCH NUM
                | unary_declaration ISCH NUM
                ;
