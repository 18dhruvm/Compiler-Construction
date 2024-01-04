%{
int yylex(void);
#include<stdio.h>
void yyerror(char *);
#include<stdlib.h>
%}

%token PLUS MINUS DIV MUL INT N;

%left DIV MUL;
%left PLUS MINUS;
%%
PGM : E N {printf("%d",$1); exit(0);}
E : E DIV E {$$ = $1 / $3;}
  | E MUL E {$$ = $1 * $3;} 
  | E MINUS E {$$ = $1 - $3;}
  | E PLUS E {$$ = $1 + $3;} 
  | INT {$$ = $1;}
  ;
%%

void yyerror(char *s)
{
	printf("%s\n",s);
}

int main()
{
	yyparse();
	return 0;
}
