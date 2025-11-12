%{
#include<stdio.h>
int id = 0;
int comment = 0;
int key = 0;
int word = 0;
int space = 0, nline = 0;

%}

%%
\n {nline++;}
int|float|char|if|else|for {key++;}
[a-zA-Z_][a-zA-Z0-9_]* {id++;}
"//"[a-zA-Z0-9_\t ]* {comment++;}
"/*"[a-zA-Z0-9\t\n_ ]*"*/" {comment++;}
[ \t] {space++;}
.|\n { }
%%
int main()
{
printf("Enter your code: \n");
yylex();
printf("Number of Identifiers: %d\n", id);
printf("Number of spaces: %d\n", space);
printf("Number of keywords: %d\n", key);
printf("Number of comments: %d\n", comment);
printf("Number of newline: %d\n", nline);
printf("Number of words: %d\n", word);
return 0;
}
int yywrap()
{
return 1;
}
