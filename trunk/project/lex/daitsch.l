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
INT gonz
FLOAT genau
BOOL bool
VOID nichts

/********************************* Operators & basic tipes ***********************************/
NOT net
AND und
OR oder
TRUE richtig
FALSE folsch

EQ gleich
BG greaser
SM kloner
EQBG "greaser gleich"
EQSM "kloner gleich"

INTNUM "-"?{DIGIT}+
FLOATNUM "-"?{DIGIT}+"."{DIGIT}+

/* C-others */
STRING \".*\"
ID {LETTER}({LETTER}|{DIGIT}|[_-])*
%%

[ \t]       { /* discarded characters (tab and space) */ }
[\n]        { /* each time a new value line is found increment
              the line counter */ yyline++; }

{START}     { return START; }
{END}       { return END; }

{ASSIGN}    { return ASSIGN; }

{IF}        { return IF; }
{THEN}      { return THEN; }
{ELIF}      { return ELIF; }
{ELSE}      { return ELSE; }

{WHILE}     { return WHILE; }
{DO}        { return DO; }
{DONE}      { return DONE; }

{INT}       { return INT; }
{FLOAT}     { return FLOAT; }
{BOOL}      { return BOOL; }
{VOID}      { return VOID; }

{NOT}       { return NOT; }
{AND}       { return AND; }
{OR}        { return OR; } 

{TRUE}      { return TRUE; } 
{FALSE}     { return FALSE; } 

"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }

{EQ}        { return EQ; }
{BG}        { return BG; }
{SM}        { return SM; }
{EQBG}      { return EQBG; }
{EQSM}      { return EQSM; }

"("         { return '('; }
")"         { return ')'; }
"["         { return '['; }
"]"         { return ']'; }
","         { return ','; }

{ONEC}      { /* discared comments */ }
{MULTIC}    { /* discared comments */ }

{SEMICOL}   { return SEMICOL; }
{FLOATNUM}  { yylval.floatnum = atof(yytext);
              return FLOATNUM; }

{INTNUM}    { yylval.intnum = atoi(yytext);
              return INTNUM; }

{ID}        { yylval.lexeme = strdup(yytext);
              return ID; }
%%
