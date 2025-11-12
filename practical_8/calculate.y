%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void yyerror(const char *s);
int yylex(void);
%}

%token NUMBER

%left '+' '-'
%left '*' '/'
%right '^'

%%
program:
    program expr '\n'   { printf("Result: %d\n", $2); }
  | 
  ;

expr:
    NUMBER              { $$ = $1; }
  | expr '+' expr       { $$ = $1 + $3; }
  | expr '-' expr       { $$ = $1 - $3; }
  | expr '*' expr       { $$ = $1 * $3; }
  | expr '/' expr       { 
        if ($3 == 0) {
          yyerror("division by zero");
          $$ = 0;
        } else {
          $$ = $1 / $3;
        }
    }
  | '(' expr ')'        { $$ = $2; }
  | expr '^' expr	{ $$ = pow($1, $3); }
  ;

%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    printf("Enter expressions:\n");
    yyparse();
    return 0;
}

