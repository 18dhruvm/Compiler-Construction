%{
int yylex(void);
#include<stdio.h>
void yyerror (char *);
#include<stdlib.h>
%}

%token HEADER INT MAIN LB RB LCB RCB S VAR COMMA COLON PLUS MINUS MUL DIV MOD MYSTERY EQ FLOAT DOUBLE CHAR

%left DIV MUL;
%left PLUS MINUS;

%%
PGM : HEADER S INT S MAIN LB RB S LCB S BODY S RCB {printf("Success\n");}
;
BODY : DECL_STMTS S PROG_STMTS
;
DECL_STMTS : DECL_STMT | DECL_STMT DECL_STMTS
;
PROG_STMTS : PROG_STMT PROG_STMTS | PROG_STMT
;
DECL_STMT : TYPE S VAR_LIST COLON
;
TYPE : INT | DOUBLE | FLOAT | CHAR
;
VAR_LIST : VAR COMMA S VAR_LIST | VAR
;

PROG_STMT : VAR EQ A_EXPN COLON
;
A_EXPN : A_EXPN OP A_EXPN | LB A_EXPN RB | VAR
;
OP : PLUS | MINUS | MUL | DIV | MOD
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
