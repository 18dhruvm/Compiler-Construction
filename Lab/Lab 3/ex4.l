%{
#include<stdio.h>
#include<string.h>
char a[13];
%}

year [0-9]+
stream [AA,A1,A7]+
id [0-9]+
type [TS,PS]+
Campus [P, U, G, H]+

%%
{year}""{year}""{year}""{year}""{stream}""{type}""{id}""{id}""{id}""{id}""{Campus} {printf("Correct\n");
strcpy(a, yytext);
printf("Year: %c%c%c%c\n", a[0],a[1],a[2], a[3]);

char stream1[10];
if (a[5]=='A'){strcpy(stream1, "Electrical");}
else if (a[5]=='1'){strcpy(stream1, "Mechanic");}
else {strcpy(stream1, "Computer");}
printf("Stream: %s\n",stream1);

char type1[15];
if (a[6]=='P'){strcpy(type1, "Practice");}
else {strcpy(type1, "Theory");}
printf("Type: %s\n",type1);

printf("Roll no: %c%c%c%c\n",a[8],a[9],a[10],a[11]);

char campus1[15];
if (a[12]=='P'){strcpy(campus1, "Pilani");}
else if (a[12]=='G'){strcpy(campus1, "Goa");}
else if (a[12]=='H'){strcpy(campus1, "Hyderabad");}
else {strcpy(campus1, "Dubai");}
printf("Campus: %s\n",campus1);
}

. {printf("Incorrect\n");}
%%
