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

/* Operations */
ADDOP "+"
SUBOP "-"
MULTOP "*"
DIVOP "/"

OPBR "("
CLBR ")"
OPSBR "["
CLSBR "]"

/****************************** Types *****************************************/
INT ganz
FLOAT genau
VOID nichts

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
{VOID} { return VOID; }

{ADDOP} { return ADDOP; }
{SUBOP} { return SUBOP; }
{MULTOP} { return MULTOP; }
{DIVOP} { return DIVOP; }

{OPBR} { return OPBR; }
{CLBR} { return CLBR; }
{OPSBR} { return OPSBR;}
{CLSBR} { return CLSBR; }

{ONEC} { /* discared comments */ }
{MULTIC} { /* discared comments */ }

{SEMICOL} { return SEMICOL; }
{INT_NUM} { return INT_NUM; }

{IDENTIFIER} { return IDENTIFIER; }
%%
