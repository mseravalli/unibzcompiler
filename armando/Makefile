LEX=flex
LFLAGS=-l
YACC=yacc
YFLEGS=-vd
CC=gcc
CCFLAGS=-DYYDEBUG -ly -ll

parser: 
	$(LEX) $(LFLAGS) -o lex/lex.daitsch.c lex/daitsch.l
	$(YACC) ${YFLEGS} -o yacc/yacc.daitsch.c yacc/daitsch.y
	$(CC) $(CCFLAGS) -o parser yacc/yacc.daitsch.c
