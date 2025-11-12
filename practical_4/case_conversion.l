%{
#include<stdio.h>
char convert(char c){
if(c >= 'a' && c <= 'z'){
return c - 32;
} else if (c >= 'A' && c <= 'Z'){
return c + 32;
}
return c;
}

%}

%%
[a-zA-Z] {putchar(convert(yytext[0]));}
. {putchar(yytext[0]);}
%%

int yywrap()
{
return 1;
}

int main()
{
printf("Enter a word: ");
yylex();
return 0;
}

