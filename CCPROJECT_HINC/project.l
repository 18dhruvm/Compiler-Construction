%option yylineno

%{
	#include<stdio.h>
	#include<string.h>
	#include"y.tab.h"
	#include<math.h>
%}

digit [0-9]
%%

"$-"(.|\n)*"-$"						{strcpy(yylval.var_name, yytext);return COMMENT;}
"Mukhya()"							{return MAIN;}
"Shuru"								{return BGIN;}
":"									{return ASSIGNMENT;}
"Khatm"								{return END;}
"~"								{return VAR_START;}
"ank"								{yylval.data_type=0; return INT;}
"akshr"								{yylval.data_type=1; return CHAR;}
"dashm"								{yylval.data_type=2; return FLOAT;}
"dodashm"							{yylval.data_type=3; return DOUBLE;}
"rachna"							{yylval.data_type=4; return STRU;}
"Padh"								{return READ;}
"Likh"								{return WRITE;}
"VrnaAgr"							{return ELSEIF;}
"Agr"								{return IF;}
"Vrna"								{return ELSE;}
"KhatmAgr"								{return ENDIF;}
"Ja"								{return GOTO;}
"Dohrah"								{return FOR;}
"Toh"								{return THEN;}
"Tabtak"								{return DO;}
"KhatmDohrah"							{return ENDFOR;}
"Phirse"							{return REPEAT;}
"PhirJabtak"								{return UNTIL;}
"Jabtak"								{return WHILE;}
"KhatmJabtak"							{return ENDWHILE;}
"todh"								{return BREAK;}
"chlnedo"							{return CONTINUE;}
"Karya"									{return FUNC;}
"=>"								{return SLABEL;}
"("									{return LB;}
")"									{return RB;}
"{"									{return LCB;}
"}"									{return RCB;}
"["									{return SLB;}
"]"									{return SRB;}
";"									{return SEMICOLON;}
","									{return COMA;}
"Aur"								{return LAND;}
"Ya"								{return LOR;}
">="								{return GEQ;}
"<="								{return LEQ;}
">"									{return GT;}
"<"									{return LT;}
"Ulta"								{return NEQ;}
"Brbr"								{return DEQ;}
"Sanrachna"								{return STRUCT;}
"+"									{return PLUS;}
"-"									{return MINUS;}
"*"									{return MUL;}
"/"									{return DIV;}
"%"									{return MOD;}
"Not"									{return NOT;}
'[^'"]*'							{strcpy(yylval.var_name, yytext);
									 return QUOTED_STRING;}
([a-zA-Z]+[a-zA-Z0-9]*)				{strcpy(yylval.var_name, yytext);
									 return VAR;}
[0-9]+ 								{strcpy(yylval.var_name, yytext);
									 return NUMBER;}
{digit}"."{digit}						{strcpy(yylval.var_name, yytext);
									 return F_NUMBER;}
[\n\t ]+							{/* ignoring newlines, tabs and spaces */}
%%

int yywrap(void) {
	return 1;
}
