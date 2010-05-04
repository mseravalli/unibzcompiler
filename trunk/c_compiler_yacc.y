%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%start translation_unit
%%

translation_unit
	: function_definition
	| declaration
	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;


type_specifier
	: VOID
	| CHAR
	| INT
	| FLOAT
	;

declaration_specifiers
	: type_specifier
	| type_specifier declaration_specifiers /*be careful!!!*/
	;

declaration
	: declaration_specifiers ';'
	;

declaration_list
	: declaration
	| declaration_list declaration
	;

assignment_expression
	: IDENTIFIER '=' assignment_expression
	; 

expression
	: assignment_expression
	/*| expression ',' assignment_expression nell'originale ci sarebbe anche questo solo che non capisco a cosa può servire e per ora lo commento*/
	;	


expression_statement
	: ';'
	| expression ';'
	;



statement
	: compound_statement
	| expression_statement
	;


statement_list
	: statement
	| statement_list statement
	;


/*praticamente sono i blocchi*/
compound_statement
	: '{' '}'
	| '{' statement_list '}'
	| '{' declaration_list '}'
	| '{' declaration_list statement_list '}'
	;

parameter_declaration
	: declaration_specifiers direct_declarator
	/*| declaration_specifiers questo lo toglierei così evitiamo la possiblità di defininire
	una funzione come void function (int) senza il nome del parametro
	voi che ne dite?*/
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;


direct_declarator
	: IDENTIFIER
	/*| direct_declarator '(' parameter_type_list ')' questo sarebbe l'originale*/
	| IDENTIFIER '(' parameter_list ')'
	| IDENTIFIER '(' identifier_list ')' /* forse questo serve quando una funzione  */
	;



/*
in teoria dovrebbe servire per una funzione definita come la seguente
int myFunction (int a, float b) { ... }
*/
function_definition 
	: type_specifier direct_declarator compound_statement
	;







%%
#include <stdio.h>

extern char yytext[];
extern int column;

yyerror(s)
char *s;
{
	fflush(stdout);
	printf("\n%*s\n%*s\n", column, "^", column, s);
}

