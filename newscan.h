/**************************************************** 
Scanner for C- (implementation C/Lex)
Bruce Gjorgjievski
newscan.h
Global definitions 
****************************************************/

/* define */
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif

struct idlist {
   char *node; 
   struct idlist *next;
} *ident, *prior, *start; /* start, prior and ident(current) nodes of llist */ 

/* global variables */
int nested, nestedErr;
int chars, lines;

/* function prototypes */
void syserr(char *message);
void printToken(tokenInfo *pt);

