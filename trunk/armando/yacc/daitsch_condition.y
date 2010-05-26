%token HALLO PFIATI ID GENAU GANZ ISCH NUM
%token IF THEN ELSE_IF ELSE DONE
%start conditional

%%

conditional             : IF '(' expression ')' THEN ending
                        | IF '(' expression ')' THEN statement else ELSE ending
                        ;

ending                  : statement DONE
                        ;

else                    : ELSE_IF statement
                        | ELSE_IF statement else
                        |
                        ;

loop                    :
                        ;

expression              :
                        ;

statement               : conditional
                        | loop
                        ;
