%{
%}

word[a-z,A-Z," "]
slash[/]
newline[\n]

%%
{slash}""{slash}""{word}+""{newline} {fprintf(yyout, "\n");}
. {fprintf(yyout, "%s", yytext);}
%%

int main()
{
	extern FILE *yyin, *yyout;
	yyin = fopen("input_comment.txt", "r");
	yyout = fopen("output_comment.txt", "w");
	yylex();
	return 0;
}
