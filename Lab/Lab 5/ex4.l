%{
#include "y.tab.h"
%}

var[a-z]+
var1[A-Z]*
var2[_]*
colon [;]
comma [,]
plus [+]
minus [-]
mul [*]
div [/]
mod [%]
eq [=]


%%
"#include<stdio.h>" return HEADER;
"int" return INT;
"main" return MAIN;
[(] return LB;
[)] return RB;
[{] return LCB;
[}] return RCB;
[\n\t ]+ return S;
"float" return FLOAT;
"double" return DOUBLE;
"char" return CHAR;
"if"  {printf("Error"); exit(0);}
"while" {printf("Error"); exit(0);}
"do" {printf("Error"); exit(0);}
{var}""{var1}""{var2} {return VAR;}
{colon} {return COLON;}
{comma} {return COMMA;}
{plus} {return PLUS;}
{minus} {return MINUS;}
{mul} {return MUL;}
{div} {return DIV;}
{mod} {return MOD;}
{eq} {return EQ;}
. return MYSTERY;
%%

