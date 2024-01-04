%{
#include "y.tab.h"
int yylval;
%}

%%
[+] return PLUS;
[-] return MINUS;
[*] return MUL;
[/] return DIV;
"\n" return N;
[0-9]+ {yylval = atoi(yytext); return INT;}
[ \t] {}
. printf("Mystery");
%%
