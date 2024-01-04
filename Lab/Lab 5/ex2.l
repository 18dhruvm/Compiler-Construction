%{
#include "y.tab.h"
%}

var[a-z]
colon [;]
comma [,]
op [+]
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
{var} {return VAR;}
{colon} {return COLON;}
{comma} {return COMMA;}
{op} {return OP;}
{eq} {return EQ;}
. return MYSTERY;
%%

