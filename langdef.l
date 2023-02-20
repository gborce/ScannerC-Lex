/****************************************************
Scanner for C-
(c) Bruce Gjorgjievski
langdef.l
C- Language Definitions
****************************************************/

%{
#include <stdio.h>
#include <strings.h>
#include "scan.h"
#include "newscan.h"
%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
validcchar  [\040-&(-[\]-~]
validschar  [\040-!#-[\]-~]
validcspec  [nt\\']
validsspec  [nt\\"]
newline     \n
whitespace  [ \t]+

%x CMNT

%%

"if"            { return IF;}
"else"          { return ELSE;}
"while"         { return WHILE;}
"return"        { return RETURN;}
"int"           { return INT;}
"char"          {  return CHAR;}
"void"          { return VOID;}

"="             { return ASSIGN;}
"=="            { return EQ;}
"<"             { return LT;}
">"             { return GT;}
"<="            { return LE;}
">="            { return GE;}
"!="            { return NE;}
"+"             { return PLUS;}
"-"             { return MINUS;}
"*"             { return TIMES;}
"/"             { return DIV;}
"("             { return LPAREN;}
")"             { return RPAREN;}
"{"             { return LBRACKET;}
"}"             { return RBRACKET;}
"["             { return LBRACE;}
"]"             { return RBRACE;}
";"             { return SEMICOLON;}
","             { return COMMA;}

'{validcchar}'   { return CHARVAL;}
'\\{validcspec}' { return CHARVAL; }

\"(\\{validsspec}|{validschar})*\" {return STRING;}


{number}        {return NUM;}
{identifier}    {return ID;}

{newline}       {chars++; lines++;}
{whitespace}    {chars += yyleng;}

"/*"		{nested = 1; chars += yyleng; BEGIN(CMNT);  }
"*/"            {nestedErr = TRUE; chars += yyleng; }
<CMNT>"/*"	{++nested; chars += yyleng;}
<CMNT>"*/"	{chars += yyleng;
		if (--nested == 0) {
                     			BEGIN(INITIAL);
					/* handle finished comment */
				} /* if nested */
			/* add to the comment */
		}
<CMNT>{newline}	{chars++; lines++;}
<CMNT>.		{chars++;}

.               {return ERROR;}

<<EOF>>         {	if (nested != 0) nestedErr = TRUE; 
			return ENDFILE;}

%%

tokenInfo *getToken(void)
{ 
 int i; 			/* the ubiquitous i */
 int skip; 			/* how many chars to skip in a string */
 int found = FALSE; 		/* is the ID already present */

 tokenInfo *ret;
 struct idlist *lsearch, *lnext; /* local nodes used for searching llist */

  ret  = ( tokenInfo *) malloc (sizeof( tokenInfo));
  ret->tokType = yylex();
  
   switch (ret->tokType)
  { 
    case ID:
	/* search for ident in llist */
	lsearch = start;
	do {
      	lnext = lsearch->next;
	if (strcmp(lsearch->node, yytext) == 0) {
				ret->spell = lsearch->node; 
      				found = TRUE;
			}
      	lsearch = lsearch->next;
   	} while ((lnext != NULL) && (found == FALSE));

	if (found == FALSE) {
		/* create new node in llist if not found */
		ident = (struct idlist *)malloc(sizeof(struct idlist));
                ident->node = (char *) calloc((yyleng+1), sizeof(char));
                
		strcpy(ident->node, yytext);
		ident->next = NULL;
		prior->next = ident;
		prior = ident;  
  
		ret->spell = ident->node; 
        }
	break;
    case CHARVAL:
        ret->spell = (char *) calloc(strlen(yytext)+1, sizeof(char));
 
	if (yytext[1] == '\\')
      	switch(yytext[2]) {
	 case 't': ret->spell[0] = 9; 
			break; 
	 case 'n': ret->spell[0] = 10; 
			break;
	 case '\\': ret->spell[0] =  92;  
			break;
	 case '\'': ret->spell[0] = 39; 
			break;
	 default: /* this should never happen */ 
		ret->spell = (char *) realloc(ret->spell, strlen("CHARVALerr")+1);  
		strcpy (ret->spell, "CHARVALerr");  

	} /* switch yytext */
	else 
		ret->spell[0] =  yytext[1];		
	break;
    case STRING: 
        ret->spell = (char *) calloc(strlen(yytext)+1, sizeof(char));

	/* if yyleng=2 -> empty string */ 
	if (yyleng==2) {ret->spell[0] = '\0'; break; }

	i=1; skip=0;
	do{ 
	 if (yytext[i] == '\\') {	
		i++;
		switch(yytext[i]) {
	 		case 't': 	skip++;
					ret->spell[i-1-skip] = 9;
			 		i++;
					break; 
	 		case 'n': 	skip++;
					ret->spell[i-1-skip] = 10;
			 		i++;
					break;
	 		case '\\': 	skip++;
					ret->spell[i-1-skip] =  92;  
					i++;
					break;
		 	case '"': 	skip++;
					ret->spell[i-1-skip] = 34; 
					i++;
					break;
	 		default: /* this should never happen */
					ret->spell = (char *) realloc(ret->spell, strlen("STRINGerr")+1);  
					strcpy (ret->spell,"STRINGerr"); 
		  
		} /* switch yytext */
	 } else {
		 ret->spell[i-1-skip] =  yytext[i];
		 i++;
		} /* else of if yytext[i] */

	} while (i<(yyleng-1)); /* do i */

	break;
    default: 	ret->spell = (char *) calloc(strlen(yytext)+1, sizeof(char)); 
		strcpy (ret->spell, yytext);  
   }; /* switch ret->tokType */ 

  ret->lineNum = lines;
  ret->startPos = chars;
  chars += yyleng;
  ret->endPos = chars;

  return ret;
} /* getToken */


void initScanner(FILE *inputFile)
{

 /* check for command line args and if file exists in main() */

 yyin = inputFile;
 chars = 0;
 lines = 1;
 nested = 0;
 nestedErr = FALSE;

 /* initialize the anchor node of the llist to ""  */
 start = (struct idlist *)malloc(sizeof(struct idlist));
 start->node = malloc(2);
 strcpy(start->node, "");
 start->next = NULL;

 /* start becomes prior, ready for additions */
 prior = start;

} /* initScanner */
