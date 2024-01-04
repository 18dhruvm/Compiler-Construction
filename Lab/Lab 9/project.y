%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
	int current_data_type;
	int expn_type=-1;
	int temp;
	struct symbol_table{char var_name[30]; int type;}var_list[20];
	int var_count=-1;
	extern int lookup_in_table(char var[30]);
	extern void insert_to_table(char var[30], int type);
%}

%union{
int data_type;
char var_name[30];
}
%token HEADER WHILE DO FOR MAIN LB RB LCB RCB SC COMA EQ PLUS MINUS MUL DIV UPLUS UMINUS NUMBER IF ELSE DEQ LAND LOR GEQ LEQ GT LT NEQ QMARK C

%left PLUS MINUS
%left MUL DIV
%left UPLUS UMINUS

%token<data_type>INT
%token<data_type>CHAR
%token<data_type>FLOAT
%token<data_type>DOUBLE
%type<data_type>DATA_TYPE
%token<var_name>VAR
%start prm

%%
prm	: HEADERS MAIN_TYPE MAIN LB RB LCB BODY RCB {printf("\n parsing successful\n"); exit(0);}

HEADERS : HEADER HEADERS |;

BODY	: DECLARATION_STATEMENTS PROGRAM_STATEMENTS

DECLARATION_STATEMENTS : DECLARATION_STATEMENT DECLARATION_STATEMENTS {printf("\n Declaration section successfully parsed\n");}| DECLARATION_STATEMENT

PROGRAM_STATEMENTS : PROGRAM_STATEMENT PROGRAM_STATEMENTS {printf("\n program statements successfully parsed\n");} | PROGRAM_STATEMENT

DECLARATION_STATEMENT: DATA_TYPE VAR_LIST SC {}

VAR_LIST : VAR COMA VAR_LIST {insert_to_table($1,current_data_type);}| VAR {insert_to_table($1,current_data_type);}

PROGRAM_STATEMENT : VAR EQ A_EXPN SC {	
					if((temp=lookup_in_table($1))!=-1)
					{
						if(expn_type==-1)
						{
							expn_type=temp;
						}
						else if(expn_type!=temp)
						{
							printf("\ntype mismatch in the expression\n");
							exit(0);
						}
					}
					else
						{
							printf("\n variable \"%s\" undeclared\n",$1);exit(0);
						}
					expn_type=-1;	
				     } | 
					BODY | |IFBLOCK|LOGICALOP|WHILEBLOCK|DOBLOCK|FORBLOCK|A_EXPN SC;

A_EXPN		: A_EXPN OP A_EXPN
		| LB A_EXPN RB | NUMBER | 
		| VAR OP1{
			if((temp=lookup_in_table($1))!=-1)
			{
				if(expn_type==-1)
				{
					expn_type=temp;
				}else if(expn_type!=temp)
				{
					printf("\ntype mismatch in the expression\n");
					exit(0);
				}
			}else
			{
				printf("\n variable \"%s\" undeclared\n",$1);exit(0);
			}
		     }
OP : PLUS | MINUS | DIV | MUL
OP1 : UPLUS | UMINUS | ;

IFBLOCK : IF LB BODY1 RB LCB BODY2 RCB ELSEBLOCK;

BODY1 : LB VAR LOP VAR RB COMPOUND| LB VAR LOP NUMBER RB COMPOUND;
COMPOUND : LOP BODY1 | ;
LOP : DEQ | NEQ | LAND | LOR | GEQ | LEQ | GT | LT;
ELSEBLOCK: ELSE LCB BODY2 RCB | ;
BODY2 : PROGRAM_STATEMENTS BODY | PROGRAM_STATEMENTS | ;

LOGICALOP : BODY1 QMARK LCB BODY2 RCB C LCB BODY2 RCB

WHILEBLOCK : WHILE LB BODY1 RB LCB BODY2 RCB;

DOBLOCK : DO LCB BODY2 RCB WHILE LB BODY1 RB;

FORBLOCK : FOR LB INT VAR {insert_to_table($4,current_data_type);} EQ A_EXPN SC {	
					if((temp=lookup_in_table($4))!=-1)
					{
						if(expn_type==-1)
						{
							expn_type=temp;
						}
						else if(expn_type!=temp)
						{
							printf("\ntype mismatch in the expression\n");
							exit(0);
						}
					}
					else
						{
							printf("\n variable \"%s\" undeclared\n",$4);exit(0);
						}
					expn_type=-1;	
				     }| VAR {if((temp=lookup_in_table($1))!=-1)
					{
						if(expn_type==-1)
						{
							expn_type=temp;
						}
						else if(expn_type!=temp)
						{
							printf("\ntype mismatch in the expression\n");
							exit(0);
						}
					}
					else
						{
							printf("\n variable \"%s\" undeclared\n",$1);exit(0);
						}
					expn_type=-1;} LOP A_EXPN SC A_EXPN RB LCB BODY2 RCB; 

MAIN_TYPE : INT
DATA_TYPE : INT {
			$$=$1;
			current_data_type=$1;
		} 
	| CHAR  {
			$$=$1;
			current_data_type=$1;
		}
	| FLOAT{
			$$=$1;
			current_data_type=$1;
		}
	| DOUBLE {
			$$=$1;
			current_data_type=$1;
		}
%%

int lookup_in_table(char var[30])//returns the data type associated with a variable
{
	for(int i=0;i<=var_count;i++)
	{
		if(strcmp(var_list[i].var_name,var)==0)
		{
			return var_list[i].type;
		}
	}
	return -1;
}
void insert_to_table(char var[30], int type)
{
	for(int i=0;i<=var_count;i++)
	{
		if(strcmp(var_list[i].var_name,var)==0)
		{
			printf("\n multiple declaration of variable \"%s\"\n", var);
			exit(0);
		}
	}
	strcpy(var_list[++var_count].var_name,var);
	var_list[var_count].type=type;
	//printf("\n Inserted %s,%d",var,type);
}
int main()
{
    yyparse();
    return 0;
}

int yyerror(const char *msg)
{
extern int yylineno;
printf("Parsing Failed\nLine Number: %d %s\n",yylineno,msg);
return 0;
}