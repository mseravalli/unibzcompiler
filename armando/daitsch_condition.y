%token HALLO PFIATI ID GENAU GANZ ISCH NUM
%token IF THEN ELSE LAST_ELIF DONE
%start conditional

%%

conditional : IF '(' expression ')' THEN statement DONE
            | IF '(' expression ')' THEN statement else LAST_ELIF statement DONE
            ;

else        : ELSE statement
            |
            ;

loop        :
            ;

expression  :
            ;

statement   : conditional
            | loop
            ;
