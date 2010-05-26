%option noyywrap
%{
#include <stdio.h>
int TokenCont=0;
%}

DIGIT [0-9]
LETTER [a-zA-Z]
DIGITS {DIGIT}* 

/****************************** C-style comments ******************************/
ONEC \/\/.*
MULTIC "/*"([^/]|"/"[^*])*"*/"

/******************************** Statements **********************************/
/* Contitional statement */
IF wenn
THEN nor
ELSE_IF oder wenn
ELSE sunscht

/* Loop statement */
WHILE solang
DO tua
DONE passt

/****************************** Types *****************************************/
INT ganz
FLOAT float
VOID nichts


/* C-others */
STRING \".*\"
IDENTIFIER {LETTER}({LETTER}|{DIGIT}|[_-])

%%
[ \t\n] { /* discarded characters */ }

{IF} { printf( "Keyword: %s\n", yytext); }
{THEN} { printf( "Keyword: %s\n", yytext); }
{ELSE} { printf( "Keyword: %s\n", yytext); }
{LAST_ELIF} { printf( "Keyword: %s\n", yytext); }

{WHILE} { printf( "Keyword: %s\n", yytext); }
{DO} { printf( "Keyword: %s\n", yytext); }
{DONE} { printf( "Keyword: %s\n", yytext); }

INT { printf( "Type: %s\n", yytext); }
FLOAT { printf( "Type: %s\n", yytext); }
VOID { printf( "Type: %s\n", yytext); }

{ONEC} { /* discared comments */ }
{MULTIC} { /* discared comments */ }

{STRING_CONST} { printf( "String Constant %s\n", yytext); }

{LETTER}({LETTER}|{DIGIT})* { printf( "Identifier %s\n", yytext ); } 

{DIGIT}* { printf( "Integer %s\n", yytext); }

{DIGITS}?"."{DIGITS}|{DIGITS}"."{DIGITS}? { printf( "Float %s\n", yytext); }

%%

main()
{
    yylex();
    return 0;
}
