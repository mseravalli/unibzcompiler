%token HALLO PFIATI ID GENAU GANZ ISCH NUM
%token IF THEN ELSE LAST_ELIF DONE
%start conditional

%%

conditional             : IF '(' expression ')' THEN ending
                        | IF '(' expression ')' THEN statement else LAST_ELIF ending
                        ;

ending                  : statement DONE
                        ;

else                    : ELSE statement
                        | else
                        |
                        ;

loop                    :
                        ;

expression              :
                        ;

statement               : conditional
                        | loop
                        ;
