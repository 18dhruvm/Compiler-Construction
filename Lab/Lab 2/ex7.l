%{
int count =0;
%}

even [0-9]*[2|4|6|8|0]
odd [0-9]*[1|3|5|7|9]

%%
{even}""{odd} {printf("Correct\n");
count = yyleng;}
%%

int main()
{
	yylex();
	printf("Length = %d\n", count);
	return 0;
}
