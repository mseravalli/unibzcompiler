%option noyywrap
%{
#include <stdlib.h>
#include <string.h>
%}

DIGIT [0-9]
LETTER [a-zA-Z]
DIGITS {DIGIT}* 

/****************************** C-style comments ******************************/
ONEC \/\/.*
MULTIC "/*"([^/]|"/"[^*])*"*/"

/******************************** Statements **********************************/
/* Main Program*/
START hallo
END pfiati

/* Contitional statement */
IF wenn
THEN nor
ELIF "oder wenn"
ELSE sunscht

/* Loop statement */
WHILE solang
DO tua
DONE passt

/****************************** Types *****************************************/
INT ganz
FLOAT genau
VOID nichts

/* C-others */
STRING \".*\"
IDENTIFIER {LETTER}({LETTER}|{DIGIT}|[_-])

%%

[ \t\n] { /* discarded characters */ }

{START} { return START; }
{END} { return END; }

{IF} { return IF; }
{THEN} { return THEN; }
{ELIF} { return ELIF; }
{ELSE} { return ELSE; }

{WHILE} { return WHILE; }
{DO} { return DO; }
{DONE} { return DONE; }

INT { return INT; }
FLOAT { return FLOAT; }
VOID { return VOID; }

{ONEC} { /* discared comments */ }
{MULTIC} { /* discared comments */ }

{STRING} { printf( "String Constant %s\n", yytext); }

{LETTER}({LETTER}|{DIGIT})* { printf( "Identifier %s\n", yytext ); } 

{DIGIT}* { printf( "Integer %s\n", yytext); }

{DIGITS}?"."{DIGITS}|{DIGITS}"."{DIGITS}? { printf( "Float %s\n", yytext); }

%%
