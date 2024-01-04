%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
	int current_data_type;
	int current_size;
	int expn_type = -1;
	int temp;
	int idx = 0;
	int stru_idx=0;
	int table_idx = 0;
	int arr_table_idx=0;
	int current_arr_idx=0;
	int s_idx;
	int tab_count = 0;
	char for_var[30];
	char ARR_NAME[30];
	struct symbol_table{char var_name[30]; int type;} sym[20];
	struct structure_table{char var_name[30];} stru[20];
	struct array_table{char var_name[30]; int type; int size;} art[20];
	extern int lookup_in_table(char var[30]);
	extern void insert_to_table(char var[30], int type);
	extern int structure_lookup_in_table(char var[30]);
	extern void structure_insert_to_table(char var[30]);
	extern void print_tabs();
	char var_list[20][50];	//20 variable names with each variable being atmost 50 characters long
	int string_or_var[20];
	extern int *yytext;
	char sss[20];
%}
%union{
int data_type;
char var_name[30];
}

%token NUMBER F_NUMBER STRUCT FUNC STRU SLB SRB LCB RCB MAIN BGIN SLABEL END ASSIGNMENT VAR_START COMA SEMICOLON VAR READ LB RB WRITE QUOTED_STRING IF ELSE ENDIF GEQ LEQ GT LT NEQ DEQ NOT LAND LOR GOTO ELSEIF FOR THEN DO ENDFOR PLUS MINUS MUL DIV MOD REPEAT UNTIL WHILE ENDWHILE BREAK CONTINUE COMMENT ENDALL

%left LAND LOR GEQ LEQ NOT GT LT NEQ DEQ PLUS MINUS MUL DIV MOD

%token<data_type>INT
%token<data_type>CHAR
%token<data_type>FLOAT
%token<data_type>DOUBLE
%token<data_type>STRU

%type<data_type>TYPE
%type<var_name>VAR

%start prm
%%

FUNCTION:				FUNC VAR LB RB {printf("void %s()\n",yylval.var_name);}
					BGIN SLABEL {
						printf("{\n");
						tab_count++;
					}
					STATEMENTS END{
						tab_count=0;
						printf("}\n");
					}
					FUNCTION
					|
					;

prm:	 			STRUCT_BLOCK MAIN BGIN SLABEL{
						printf("#include<stdio.h>\nint main()\n{\n");
						tab_count++;
					}
					STATEMENTS END{
						tab_count=0;
						printf("}\n");
					} FUNCTION


STATEMENTS: 		DLSTATEMENT {print_tabs();} STATEMENTS 
					| PSTATEMENT {print_tabs();} STATEMENTS
					|
					;

STRUCT_BLOCK : STRUCT {printf("struct ");}
				VAR {
							strcpy(var_list[s_idx], yylval.var_name);
							strcpy(sss, yylval.var_name); 
							printf("%s", sss);
							s_idx++;
							structure_insert_to_table(var_list[s_idx-1]);
							s_idx = 0;
						}
				LCB {printf("{\n");}
				DLSTATEMENTS
				RCB SEMICOLON {printf("};\n");} STRUCT_BLOCK
				|
				;

DLSTATEMENTS:	DLSTATEMENTS DLSTATEMENT
				|
				;
DLSTATEMENT: 		VAR_START TYPE VAR_LIST SLB NUMBER {current_size=atoi(yylval.var_name);} 
					SRB SEMICOLON {
						if(current_data_type == 0)
							printf("int ");
						else if(current_data_type == 1)
							printf("char ");
						else if(current_data_type == 2)
							printf("float ");
						else if(current_data_type == 3)
							printf("double ");
						for(int i = 0; i < idx - 1; i++){
							insert_to_arr_table(var_list[i], current_data_type,current_size);	
							printf("%s[%d],", var_list[i],current_size);
						}
						insert_to_arr_table(var_list[idx-1], current_data_type,current_size);
						printf("%s[%d];\n",var_list[idx-1],current_size);
						idx = 0;
					}
					|VAR_START TYPE VAR_LIST SEMICOLON {
						if(current_data_type == 0)
							printf("int ");
						else if(current_data_type == 1)
							printf("char ");
						else if(current_data_type == 2)
							printf("float ");
						else if(current_data_type == 3)
							printf("double ");
						for(int i = 0; i < idx - 1; i++){
							insert_to_table(var_list[i], current_data_type);	
							printf("%s,", var_list[i]);
						}
						insert_to_table(var_list[idx-1], current_data_type);
						printf("%s;\n", var_list[idx-1]);
						idx = 0;
					}

PSTATEMENT:			VAR {
							print_tabs();printf("%s", yylval.var_name);
							if((temp=lookup_in_table(yylval.var_name))!=-1) {
								if(expn_type==-1)
									expn_type=temp;
								else if(expn_type!=temp) {
									printf("\n type mismatch in the expression\n");
									yyerror("");
									exit(0);
								}
							}
							else {
								printf("\n variable \" %s\" undeclared\n", yylval.var_name);
								yyerror("");
								exit(0);
							}
							expn_type=-1;
					} 
					ASSIGNMENT {printf("=");} A_EXPN SEMICOLON {
						printf(";\n");
					}
					| VAR   {
							print_tabs();
							printf("%s",yylval.var_name);
							if((temp=lookup_in_arr_table(yylval.var_name))!=-1){
								if(expn_type==-1)
									expn_type=temp;
								else if(expn_type!=temp){
									printf("\n typo mismatch arr expn\n");
									yyerror("");
									exit(0);
								}
							}
							else{
								printf("\n variable undeclared\n");
								yyerror("");
								exit(0);
								}
							expn_type=-1;
					}
					SLB {printf("[",current_arr_idx);} A_EXPN {printf("]");} SRB ASSIGNMENT {printf("=");} A_EXPN SEMICOLON {printf(";\n");}
					| READ LB READ_VAR_LIST RB SEMICOLON {
						print_tabs();
						printf("scanf(\"");
						for(int i = 0; i < idx; i++) {
							if((temp=lookup_in_table(var_list[i])) != -1) {
								if(temp==0)
									printf("%%d");
								else if(temp==1)
									printf("%%c");
								else if(temp==2)
									printf("%%f");
								else
									printf("%%e");
							}
							else
							{
								printf("Cannot read undeclared variable %s !", yylval.var_name);
								yyerror("");
								exit(0);
							}
						}
						printf("\"");
						for(int i = 0; i < idx; i++) {
							printf(",&%s", var_list[i]);
						}
						printf(");\n");
						idx=0;
					}
					| STRUCT_BODY
					| BREAK SEMICOLON {print_tabs();printf("break;\n");}
					| CONTINUE SEMICOLON {print_tabs();printf("continue;\n");}
					| WRITE LB WRITE_VAR_LIST RB SEMICOLON {
						print_tabs();
						char *s;
						printf("printf(\"");
						for(int i = 0; i < idx; i++) {
							if(string_or_var[i] == 1) {
								s = var_list[i];
								s++;
								s[strlen(s)-1] = 0;
								printf("%s", s);
							}
							else {	
								if((temp=lookup_in_table(var_list[i])) != -1) {
									if(temp==0)
										printf("%%d");
									else if(temp==1)
										printf("%%c");
									else if(temp==2)
										printf("%%f");
									else
										printf("%%e");
								}
								else
								{
									printf("Cannot read undeclared variable %s !", var_list[i]);
									yyerror("");
									exit(0);
								}
							}
						}
						printf("\"");
						for(int i = 0; i < idx; i++) {
							if(string_or_var[i] != 1)
								printf(",%s", var_list[i]);
						}
						printf(");\n");
						idx = 0;
					}
					| IF_BLOCK ELSEIF_BLOCKS ELSE_BLOCK ENDIF
					| IF_BLOCK ENDIF
					| GOTO {print_tabs();printf("goto ");} 
    				  VAR {printf("%s", yylval.var_name);} 
					  SEMICOLON {printf(";\n");}
					| FOR LB {print_tabs();printf("for(");} 
					  VAR {strcpy(for_var, yylval.var_name); printf("%s", for_var);} 
					  ASSIGNMENT {printf("=");}
					  TERMINALS  
					  SEMICOLON {printf("; %s < ",for_var);} 
					  A_EXPN  
					  SEMICOLON 
					  NUMBER {printf(";%s=%s+%s", for_var, for_var, yylval.var_name);}
					  RB  {printf("){\n"); tab_count++;} 
					  STATEMENTS ENDFOR {tab_count--;print_tabs();printf("}\n");}
					| REPEAT {printf("do{\n");tab_count++;}
					  STATEMENTS UNTIL LB {tab_count--;print_tabs();printf("}while(");} 
				      A_EXPN RB {printf(");\n");}
					| WHILE LB {print_tabs();tab_count++; printf("while(");} 
					  A_EXPN RB DO {print_tabs();printf("){\n");}
					  STATEMENTS ENDWHILE {tab_count--;print_tabs();printf("}\n");}
					| VAR SLABEL {printf("%s:\n", yylval.var_name);}
					| COMMENT {printf("/%s/\n", yylval.var_name);}

STRUCT_BODY : 			VAR_START STRU {printf("struct ");} 
						VAR {
							printf("%s ", yylval.var_name);
							if((temp=structure_lookup_in_table(yylval.var_name))!=-1) {
								if(expn_type==-1)
									expn_type=temp;
								else if(expn_type!=temp) {
									printf("\n type mismatch in the expression\n");
									yyerror("");
									exit(0);
								}
							}
							else {
								printf("\n variable \" %s\" undeclared\n", yylval.var_name);
								yyerror("");
								exit(0);
							}
							expn_type=-1;}
					VAR {	
						insert_to_table(yylval.var_name,4);
						printf("%s",yylval.var_name);
						}

			SEMICOLON{printf(";\n");}
						

IF_BLOCK:		 	IF LB {print_tabs();printf("if(");} 
					A_EXPN RB THEN {printf("){\n");tab_count++;} 
					STATEMENTS
					{tab_count--;print_tabs();printf("}\n");}
					  	

ELSEIF_BLOCKS:		ELSEIF_BLOCKS ELSEIF_BLOCK
					| ;


ELSEIF_BLOCK:		ELSEIF LB {print_tabs();printf("else if(");}
					A_EXPN RB THEN {printf("){\n");tab_count++;}
					STATEMENTS
					{tab_count--;print_tabs();printf("}\n");}

ELSE_BLOCK: 	    ELSE {print_tabs();printf("else{\n");tab_count++;} 
					STATEMENTS
					{tab_count--;print_tabs();printf("}\n");}
				
VAR_LIST: 			VAR {
						strcpy(var_list[idx], $1); 
						idx++;
					} COMA VAR_LIST
					| VAR {
						strcpy(var_list[idx], $1); 
						idx++;
					}


TYPE : 				INT {
						$$=$1;
						current_data_type=$1;	
					}
					| CHAR  {
						$$=$1;
						current_data_type=$1;
					}
					| FLOAT {
						$$=$1;
						current_data_type=$1;
					}
					| DOUBLE {
						$$=$1;
						current_data_type=$1; 
					}

WRITE_VAR_LIST:		QUOTED_STRING {
						strcpy(var_list[idx], yylval.var_name); 
						string_or_var[idx]=1; 
						idx++;
					} 
					COMA WRITE_VAR_LIST
					| VAR {
						strcpy(var_list[idx], yylval.var_name); 
						idx++;
					} 
					COMA WRITE_VAR_LIST
					| QUOTED_STRING{
						strcpy(var_list[idx], yylval.var_name);
						string_or_var[idx]=1;
						idx++;
					}
					| VAR {
						strcpy(var_list[idx], yylval.var_name);
						idx++;
					}

READ_VAR_LIST:		VAR {
						strcpy(var_list[idx], yylval.var_name); 
						idx++;
					} COMA READ_VAR_LIST
					| VAR {
						strcpy(var_list[idx], yylval.var_name); 
						idx++;
					}

A_EXPN: 		A_EXPN LAND {printf("&&");} A_EXPN
				| A_EXPN LOR {printf("||");} A_EXPN
	 			| A_EXPN LEQ {printf("<=");} A_EXPN
				| A_EXPN GT {printf(">");} A_EXPN
				| A_EXPN LT {printf("<");} A_EXPN
				| A_EXPN NEQ {printf("!=");} A_EXPN
				| A_EXPN DEQ {printf("==");} A_EXPN
				| NOT {printf("!");} A_EXPN 
				| A_EXPN PLUS {printf("+");} A_EXPN
				| A_EXPN MINUS {printf("-");} A_EXPN
				| A_EXPN MUL {printf("*");} A_EXPN
				| A_EXPN DIV {printf("/");} A_EXPN
				| A_EXPN MOD {printf("%%");} A_EXPN	
				| TERMINALS

TERMINALS:			VAR {
						if((temp=lookup_in_table(yylval.var_name))!=-1) {
							printf("%s", yylval.var_name);
							if(expn_type==-1){
								expn_type=temp;
							}
							else if(expn_type!=temp){
								printf("\ntype mismatch in the expression\n");
								yyerror("");
								exit(0);
							}
						}
						else{
							printf("\n variable \"%s\" undeclared\n", yylval.var_name);
							yyerror("");
							exit(0);
						}
						expn_type=-1;
					}
					|VAR {
						if((temp=lookup_in_arr_table(yylval.var_name))!=-1) {
							printf("%s", yylval.var_name);
							if(expn_type==-1){
								expn_type=temp;
							}
							else if(expn_type!=temp){
								printf("\ntype mismatch in the expression\n");
								yyerror("");
								exit(0);
							}
						}
						else{
							printf("\n variable \"%s\" undeclared\n", yylval.var_name);
							yyerror("");
							exit(0);
						}
						expn_type=-1;
					} SLB {printf("[");} A_EXPN SRB {printf("]");}
					| NUMBER {if (temp==0) printf("%s", yylval.var_name); else{printf("Incorrect value assigned\n"); exit(0);}}
					| F_NUMBER { if (temp==2) printf("%s", yylval.var_name); else{printf("Incorrect value assigned\n"); exit(0);}temp=0;}
					| QUOTED_STRING {if (temp==1)printf("%s",yylval.var_name); else{printf("Incorrect value assigned\n"); exit(0);}temp=0;} 

%%

int lookup_in_table(char var[30])
{
	for(int i=0; i<=table_idx; i++)
	{
		if(strcmp(sym[i].var_name, var)==0)
			return sym[i].type;
	}
	return -1;
}


int lookup_in_arr_table(char var[30])
{
	for(int i=0; i<=arr_table_idx; i++)
	{
		if(strcmp(art[i].var_name, var)==0)
			return art[i].type;
	}
	return -1;
}

void insert_to_table(char var[30], int type)
{
	if(lookup_in_table(var)==-1 && lookup_in_arr_table(var)==-1)
	{
		strcpy(sym[table_idx+1].var_name,var);
		sym[table_idx+1].type = type;
		table_idx++;
	}
	else {
		printf("Multiple declaration of variable\n");
		yyerror("");
		exit(0);
	}
}
void insert_to_arr_table(char var[30], int type, int size)
{
	if(lookup_in_table(var)==-1 && lookup_in_arr_table(var)==-1)
	{
		strcpy(art[arr_table_idx].var_name,var);
		art[arr_table_idx].type = type;
		art[arr_table_idx].size = size;
		arr_table_idx++;
	}
	else {
		printf("Multiple declaration of variable in arr\n");
		yyerror("");
		exit(0);
	}
}

int structure_lookup_in_table(char var[30])
{
	for(int i=0; i<=stru_idx; i++)
	{
		if(strcmp(stru[i].var_name, var)==0)
			return 1;
	}
	return -1;
}

void structure_insert_to_table(char var[30])
{
	if(lookup_in_table(var)==-1 && lookup_in_arr_table(var)==-1)
	{
		strcpy(stru[table_idx+1].var_name,var);
		stru_idx++;
	}
	else {
		printf("Multiple declaration of variable\n");
		yyerror("");
		exit(0);
	}
}

void print_tabs() {
	for(int i = 0; i < tab_count; i++){
		printf("\t");
	}
	return;
}

int main(){
	yyparse();
	return 0;
}

int yyerror(const char *msg) {
	extern int yylineno;
	printf("Parsing failed\nLine number: %d %s\n", yylineno, msg);
	success = 0;
	return 0;
}
