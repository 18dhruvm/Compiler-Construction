number[0-9]+

%%
"+" printf("PLUS\n");
"-" printf("MINUS\n");
"*" printf("MULT\n");
"/" printf("DIV\n");
{number} {printf("NUMBER\n");}
. printf("MYSTERY\n");
"\n" printf("NEWLINE\n");
%%
