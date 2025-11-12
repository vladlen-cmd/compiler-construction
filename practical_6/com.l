%{
#include<stdio.h>
int count = 0;
int counter = 0;
int com_count(char *text){
	count++;
	return count;
}

%}

%%
^.*com$ {char text = com_count(yytext);}
.*|\n {counter++;}
%%

int main()
{
	printf("Your input: \n");
	yylex();
	printf("Number of lines ending with com : %d\n",count);
	printf("Not ending with com : %d\n", counter);
	return 0;
}

int yywrap()
{
	return 1;
}
