%{
int yylex(void);
#include<stdio.h>
void yyerror (char *);
#include<stdlib.h>
%}

%token HEADER INT MAIN LB RB LCB RCB S VAR COMMA COLON OP MYSTERY EQ

%%
PGM : HEADER S INT S MAIN LB RB S LCB S BODY S RCB {printf("Success\n");}
;
BODY : DECL_STMTS 
;
DECL_STMTS : DECL_STMT | DECL_STMT DECL_STMTS
;
DECL_STMT : INT S VAR_LIST COLON
;
VAR_LIST : VAR COMMA S VAR_LIST | VAR
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
