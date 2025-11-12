%{
#include<stdio.h>
int id = 0;
int comment = 0;
int key = 0;
int word = 0;
int space = 0, nline = 0;

%}

%%
[A-Za-z]+ {word++;}
.|\n { }
%%
int main()
{
printf("Enter your code: \n");
yylex();

printf("Number of words: %d", word);
return 0;
}
int yywrap()
{
return 1;
}
