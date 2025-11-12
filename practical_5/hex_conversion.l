
%{
#include<stdio.h>

void dec_to_hex(int num)
{
	int i = 0;
	char hex[100];
	int r;
	if(num == 0){
		printf("00");
	return;
}

while(num != 0){
	r = num % 16;
	if(r < 10)
		hex[i++] = r + '0';

	else
		hex[i++] = r - 10 + 'A';
		num = num / 16;
}

for(int j = i-1; j >= 0; j--){
	printf("%c", hex[j]);
	}
}

int str_to_num(char *str)
{
	int n = 0;
	for(int i = 0; str[i] != '\0'; i++){
	n = n * 10 +(str[i]-'0');
	}
	return n;
}

%}

%%
[0-9]+ {int num = str_to_num(yytext);
dec_to_hex(num);}

%%
            
int main()
{
printf("Enter a decimal number: ");
yylex();
return 0;
}

int yywrap()
{
return 1;
}
    


