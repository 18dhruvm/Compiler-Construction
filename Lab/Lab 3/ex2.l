%{
int count = 2;
%}

%%
"\n" {fprintf(yyout, "\n%d ",count);
count++;
}
. {fprintf(yyout, "%s", yytext);}
%%

int main()
{
	extern FILE *yyin, *yyout;
	yyin = fopen("input.txt", "r");
	yyout = fopen("output.txt", "w");
	yylex();
	return 0;
}
