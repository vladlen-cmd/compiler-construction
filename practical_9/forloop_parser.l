%{

#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
"for"       { return FOR; }
"++"		{ return PLUSPLUS; }
"--"		{ return DEC; }
"="   		{ return EQ; }
"<"			{ return LT; }
">"         { return GT; }
";"         { return SEMI; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }

[0-9]+      { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.id = strdup(yytext); return ID; }

[ \t\n]+    ;  

.           { printf("Unexpected character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}

