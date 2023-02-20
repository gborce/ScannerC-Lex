#ifndef _scan_h
#define _scan_h

typedef enum {
    CHAR, ELSE, IF, INT, RETURN, VOID, WHILE,
    PLUS, MINUS, TIMES, DIV, LT, LE, GT, GE, EQ, NE, ASSIGN,
    SEMICOLON, COMMA, LPAREN, RPAREN, LBRACKET, RBRACKET, LBRACE, RBRACE,
    ID, NUM, CHARVAL, STRING,
    ERROR, ENDFILE } tokenKind;

typedef struct {
    int tokType;
    char *spell;
    int lineNum;
    int startPos;
    int endPos;
} tokenInfo;

void initScanner(FILE *inputFile);

tokenInfo *getToken(void);

#endif
