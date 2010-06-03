LEX=flex
LFLAGS=-l
YACC=yacc
YFLEGS=-vd
CC=gcc
CCFLAGS=-DYYDEBUG -ly -lfl

parser: 
	$(LEX) $(LFLAGS) -o lex/lex.daitsch.c lex/daitsch.l
	$(YACC) ${YFLEGS} -o yacc/yacc.daitsch.c yacc/daitsch.y
	$(CC) $(CCFLAGS) -o bin/parser yacc/yacc.daitsch.c

clean:
	rm bin/parser lex/lex.daitsch.c yacc/yacc.daitsch.*
