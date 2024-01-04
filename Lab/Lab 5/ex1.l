%{
#include "y.tab.h"
%}

%%
"#include<stdio.h>" return HEADER;
"int" return INT;
"main" return MAIN;
[(] return LB;
[)] return RB;
[{] return LCB;
[}] return RCB;
[\n\t ]+ return S;
%%

