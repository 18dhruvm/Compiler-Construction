%{
int char_count =0;
int newline=0;
int word_count=0;
%}

char [a-z,A-Z]

%%
{char}+ {++word_count; 
char_count+=yyleng;}
"\n" {++newline;}
%%

int main()
{
yylex();
printf("\nNo of characters = %d",char_count);
printf("\nNo of words = %d", word_count);
printf("\nNo of newlines = %d\n", newline);

return 1;
}
