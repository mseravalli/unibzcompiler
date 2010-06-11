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
/*  */
ASSIGN isch
SEMICOL ;

/* Main Program*/
START hallo
END pfiati

/* Contitional statement */
IF wenn
THEN nor
ELIF "oder wenn"
ELSE sunscht

/* Loop statement */
WHILE solong
DO tua
DONE passt

/****************************** Types *****************************************/
INT ganz
FLOAT gena
BOOL bool
VOID nichts

/****************************** Relational operators *****************************************/
NET net
UND und
ODER oder
TRUE richtig
FALSE folsch
EQUALS gleich

INT_NUM {DIGIT}*

/* C-others */
STRING \".*\"
IDENTIFIER {LETTER}({LETTER}|{DIGIT}|[_-])*
%%

[ \t\n] { /* discarded characters */ }

{START} { return START; }
{END} { return END; }

{ASSIGN} { return ASSIGN; }

{IF} { return IF; }
{THEN} { return THEN; }
{ELIF} { return ELIF; }
{ELSE} { return ELSE; }

{WHILE} { return WHILE; }
{DO} { return DO; }
{DONE} { return DONE; }

{INT} { return INT; }
{FLOAT} { return FLOAT; }
{BOOL} { return BOOL; }
{VOID} { return VOID; }

{NET} { return NET; }
{UND} { return UND; }
{ODER} { return ODER; } 

{EQUALS} { return EQUALS; }

{TRUE} { return TRUE; } 
{FALSE} { return FALSE; } 

"+" { return '+'; }
"-" { return '-'; }
"*" { return '*'; }
"/" { return '/'; }

"<" { return '<'; }
">" { return '>'; }

"(" { return '('; }
")" { return ')'; }
"[" { return '['; }
"]" { return ']'; }



{ONEC} { /* discared comments */ }
{MULTIC} { /* discared comments */ }

{SEMICOL} { return SEMICOL; }
{INT_NUM} { return INT_NUM; }

{IDENTIFIER} { return IDENTIFIER; }
%%
