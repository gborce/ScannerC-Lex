/****************************************************
Project 1: Scanner for C-
Borce Gjorgjievski
main.c
Main testing module
****************************************************/

#include <stdio.h>
#include "scan.h"
#include "newscan.h"

main( int argc, char *argv[] )
{  
  int i;
  tokenInfo *tok;
  FILE* infile;


if (argc == 1)
        infile = stdin;
    else if (argc == 2) {
        infile = fopen(argv[1], "r");
        if (infile == NULL) syserr("Could not open input file\n");
    } else syserr("Too many command-line arguments given to scanner\n");

  initScanner(infile);

  do {
    tok = getToken();
    printToken(tok);
      } while (tok->tokType != ENDFILE);

  /* print the linked list of identifiers
  ident = start;
   do {
      prior = ident->next;
      printf("Node = %s\n", ident->node);
      ident = ident->next;
   } while (prior != NULL);
*/

  printf("\nNested Comments Error Status: %s\n", nestedErr?"true":"false");
  fclose(infile);
}

