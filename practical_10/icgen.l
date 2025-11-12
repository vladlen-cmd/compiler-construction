%{
#include "y.tab.h"
#include <stdlib.h>

%}

%%
[a-zA-Z][a-zA-Z0-9]* 	{yylval.str=strdup(yytext); return ID;}
[0-9]+ 					{yylval.str=strdup(yytext); return NUM;}
[\+\-\*/\(\)] 			{return yytext[0]; }
[\n\t ]+ 				{}
. 						{printf("Invalid character: %s\n", yytext);}
%%

int yywrap() {
    return 1;
}

