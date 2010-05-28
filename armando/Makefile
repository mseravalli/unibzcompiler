LEX=flex
LFLAGS=-l
YACC=yacc
YFLEGS=-vd
CC=gcc
CCFLAGS=-DYYDEBUG -ly -ll

parser: 
	$(CC) $(CCFLAGS) -o parser yacc/yacc.daitsch.c
	$(YACC) ${YFLEGS} -o yacc/yacc.daitsch.c yacc/daitsch.y
	$(LEX) $(LFLAGS) -o lex/lex.daitsch.c lex/daitsch.l
