%{
int yylex(void);
#include<stdio.h>
void yyerror (char *);
#include<stdlib.h>
%}

%token HEADER INT MAIN LB RB LCB RCB S MYSTERY 

%%
PGM : HEADER S INT S MAIN LB RB S LCB S RCB {printf("Success\n");}
;
%%

void yyerror (char *s)
{
	printf ("%s\n",s);
}

int main()
{
	yyparse();
	return 0;
}
