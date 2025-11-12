%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();void yyerror(const char *s);
int tempCount = 1;
void generate(const char *op, const char *arg1, const char *arg2, const char *res){
	printf("%s = %s %s %s\n", res, arg1, op, arg2)
}

%}

%union {
	char *str;}

%token <str> ID NUM
%type <str> E
%left '+' '-'
%left '*' '/'
%right UMINUS

%%

S: E {printf("\nIntermediate code generation successful!\n");}
	;
E: E '+' E {
			char t[10];
			printf(t, "t,%d", tempCount++);
			generate("+", $1, $3, t);
			$$ = strdup(t);
	}
	
	| E '-' E {
			char t[10];
			printf(t, "t%d", tempCount++);
			generate("-", $1, $3, t);
			$$ =  strdup(t);
	}
	
	| E '*' E {
			char t[10];
			printf(t, "t%d", tempCount++);
			generate("*", $1, $3, t);
			$$ =  strdup(t);
	}
	
	| E '/' E {
			char t[10];
			printf(t, "t%d", tempCount++);
			generate("/", $1, $3, t);
			$$ =  strdup(t);
	}
	
	| '(' E ')' { $$ = $2; }
	
	| '-' E %prec UMINUS {
			char t[10];
			printf(t, "t%d", tempCount++);
			generate("uminus", $2, "", t);
			$$ =  strdup(t);
	}
	
	| ID { $$ = strdup($1); }
	| NUM { $$ = strdup($1); }

%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    printf("Enter expression:\n");
    yyparse();
    return 0;
}
