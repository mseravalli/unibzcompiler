%option noyywrap
%{
#include <stdio.h>
int TokenCont=0;
%}

DIGIT [0-9]
LETTER [a-zA-Z]
DIGITS {DIGIT}* 

/* C-style comments */
ONEC \/\/.*
MULTIC "/*"([^/]|"/"[^*])*"*/"

/* C-keywords */
IF if
THEN then
ELSE else
FOR for
WHILE while
DO do
SWITCH switch
CASE case
DEFAULT default
GOTO goto
CONTINUE continue
BREAK break
RETURN return

/* C-statements */

/* C-type */
INT int
FLOAT float
CHAR char

/* C-type values */
VOID void



/* C-others */
STRING \".*\"
IDENTIFIER {LETTER}({LETTER}|{DIGIT}|[_-])

%%
[ \t\n] { /* discarded characters */ }

{IF} { printf( "Keyword: %s\n", yytext); }
{THEN} { printf( "Keyword: %s\n", yytext); }
{ELSE} { printf( "Keyword: %s\n", yytext); }
{FOR} { printf( "Keyword: %s\n", yytext); }
{WHILE} { printf( "Keyword: %s\n", yytext); }
{DO} { printf( "Keyword: %s\n", yytext); }
{SWITCH} { printf( "Keyword: %s\n", yytext); }
{CASE} { printf( "Keyword: %s\n", yytext); }
{DEFAULT} { printf( "Keyword: %s\n", yytext); }
{GOTO} { printf( "Keyword: %s\n", yytext); }
{CONTINUE} { printf( "Keyword: %s\n", yytext); }
{BREAK} { printf( "Keyword: %s\n", yytext); }
{RETURN} { printf( "Keyword: %s\n", yytext); }

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
