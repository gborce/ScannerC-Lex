##############################################################
# 	Scanner for C- (implementation C/Lex)
#	Makefile, Bruce Gjorgjievski
##############################################################

LIBS    = -lfl
CFLAGS  = -O2
MOD	= -c
CC	= gcc
LEX	= flex

all: lex sca

lex: langdef.l newscan.h
	$(LEX) langdef.l
	$(CC) $(MOD) $(CFLAGS) lex.yy.c

utils: utils.c newscan.h
	$(CC) $(MOD) $(CFLAGS) utils.c

main: main.c newscan.h
	$(CC) $(MOD) $(CFLAGS) main.c

sca: main.o lex.yy.o utils.o
	$(CC) -o sca main.o lex.yy.o utils.o $(LIBS)

clean:
	rm -f *.o core a.out sca lex.yy.c

