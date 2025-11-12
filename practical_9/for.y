%{

#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    int num;
    char* id;
}

%token <id> ID
%token <num> NUMBER
%token FOR PLUSPLUS DEC EQ LT GT SEMI LPAREN RPAREN LBRACE RBRACE

%start for_loop

%%

for_loop:
    FOR LPAREN assignment SEMI condition SEMI operation RPAREN block {
        printf("Parsed a valid FOR loop.\n");
    }
;

assignment:
    ID EQ NUMBER
;

condition:
      ID LT NUMBER
    | ID GT NUMBER
;

operation:
    ID PLUSPLUS
	| ID DEC
;

block:
    LBRACE statements RBRACE
;

statements:

    | statements statement
;

statement:
    assignment SEMI
;

%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    printf("Enter a FOR loop:\n");
    yyparse();
    return 0;
}

