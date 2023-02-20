/****************************************************
Borce Gjorgjievski
Compilers, Project 1, Scanner for C-
utils.c
misc utilities
****************************************************/

#include <stdio.h>
#include <strings.h>
#include "scan.h"
#include "newscan.h"

static char *names[] = {"char", "else", "if", "int", "return", "void", "while",
			"+", "-", "*", "/", "<", "<=", ">", ">=",
			"==", "!=", "=",
			";", ",", "(", ")", "[", "]", "{", "}",
			"ID", "NUM", "CHARVAL", "STRING",
			"ERROR", "ENDFILE"};

void syserr(char *message)
{
  fprintf(stderr, message);
  exit(1);

}

void printToken(tokenInfo *pt)
{
    char *charName;
    int i, leng;

    if (pt->tokType == ID) {
	printf("%5d%5d%5d  %-9s%s\n", pt->lineNum, pt->startPos,
	       pt->endPos, names[pt->tokType], pt->spell);
	printf("\t\t\tAddress: %x\n", pt->spell);
    } else if (pt->tokType == NUM) {
	printf("%5d%5d%5d  %-9s%s\n", pt->lineNum, pt->startPos,
	       pt->endPos, names[pt->tokType], pt->spell);
    } else if (pt->tokType == CHARVAL) {
      if (strlen(pt->spell) >= 0) {       /* change here for length */
	    if (pt->spell[0] == '\t')
		charName = "tab";
	    else if (pt->spell[0] == '\n')
		charName = "newline";
	    else
		charName = pt->spell;
	    printf("%5d%5d%5d  %-9s%s (%d)\n", pt->lineNum, pt->startPos,
		   pt->endPos, names[pt->tokType], charName, pt->spell[0]);
	} else {
	    fprintf(stderr, "Bad character given to printToken: %s\n",
		    pt->spell);
	}
    } else if (pt->tokType == STRING) {
	printf("%5d%5d%5d  %-9s%s\n", pt->lineNum, pt->startPos,
	       pt->endPos, names[pt->tokType], pt->spell);
	printf("\t\tCharacters in string:\n");
	leng = strlen(pt->spell);
	for (i = 0; i < leng; i++)
	    if (pt->spell[i] == '\n')
		printf("\t\t\tnewline (%d)\n", pt->spell[i]);
	    else if (pt->spell[i] == '\t')
		printf("\t\t\ttab (%d)\n", pt->spell[i]);
	    else if (32 <= pt->spell[i] && pt->spell[i] <= 126)
		printf("\t\t\t%c (%d)\n", pt->spell[i], pt->spell[i]);
	    else {
		fprintf(stderr, "Error in printToken.\n");
		exit(1);
	    }
    } else if (pt->tokType == ERROR) {
	printf("%5d%5d%5d  %-9s\n", pt->lineNum, pt->startPos,
	       pt->endPos, names[pt->tokType]);
	printf("\t\tCharacter(s) in erroneous token:\n");
	leng = strlen(pt->spell);
	for (i = 0; i < leng; i++)
	    if (32 <= pt->spell[i] && pt->spell[i] <= 126)
		printf("\t\t\t%c (%d)\n", pt->spell[i], pt->spell[i]);
	    else
		printf("\t\t\t  (%d)\n", pt->spell[i]);
    } else if (CHAR <= pt->tokType && pt->tokType <= ENDFILE) {
	printf("%5d%5d%5d  %s\n", pt->lineNum, pt->startPos,
	       pt->endPos, names[pt->tokType]);
    } else
	fprintf(stderr, "INTERNAL ERROR--Bad call to printToken.\n");
}

