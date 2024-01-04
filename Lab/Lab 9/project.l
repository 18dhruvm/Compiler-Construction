%option yylineno

%{
	#include<stdio.h>
	#include<string.h>
	#include"y.tab.h"
	#include<math.h>
	extern int var_count;

%}

%%
"#include<"""[a-z]+""".h>" {return HEADER;}
"int"	{yylval.data_type=0;return INT;}
"char" {yylval.data_type=1; return CHAR;}
"float" {yylval.data_type=2; return FLOAT;}
"double" {yylval.data_type=3; return DOUBLE;}
"main"	{return MAIN;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"do" {return DO;}
"for" {return FOR;}
"("	{return LB;}
")"	{return RB;}
"{"	{return LCB;}
"}"	{return RCB;}
","	{return COMA;}
";"	{return SC;}
"++" {return UPLUS;}
"--" {return UMINUS;}
[+] {return PLUS;}
[-] {return MINUS;}
[*] {return MUL;}
[/] {return DIV;}
"==" {return DEQ;}
"="	{return EQ;}
"&&" {return LAND;}
"||" {return LOR;}
">=" {return GEQ;}
"<=" {return LEQ;}
">" {return GT;}
"<" {return LT;}
"!=" {return NEQ;}
"?" {return QMARK;}
":" {return C;}
[a-z]+  {strcpy(yylval.var_name,yytext);return VAR;}
[0-9]+  {strcpy(yylval.var_name,yytext);return NUMBER;}
[\n\t ]+  {/*new line or space*/}
. {printf("invalid character sequence %s\n",yytext); exit(0);}
%%


int yywrap(void)
{
    return 1;
}
