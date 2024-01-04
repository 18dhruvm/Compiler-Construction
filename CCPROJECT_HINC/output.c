struct bank{
int bal;

char id;

float uid;

};


#include<stdio.h>
int main()
{

struct bank b1;
	
int a[4];
	
int b[4];
	
int c[2];
	
float sum1;
	
float sum2;
	
int num;
	
int i;
	
	a[0]=1;
	
	a[1]=3;
	
	a[2]=4;
	
	a[3]=6;
	
	b[0]=5;
	
	b[1]=10;
	
	b[2]=9;
	
	b[3]=3;
	

	while(i<4
		){

		if(i%2!=0){

			continue;
			
		}
		else{

			c[i/2]=a[i]+b[i];
			
			i=i+1;
			
		}
		
	}
	

	printf("Enter a number:");
	
	scanf("%d",&num);
	
	for(i=2; i < num/2;i=i+1){

		if(num%i==0){

			goto NonPrime;
			
		}
		else{

			break;
			
		}
		
	}
	

Prime:
	
	scanf("%d",&num);
	
	printf("The number is a prime number%d",num);
	
	goto exit;
	

NonPrime:
	
	printf("The number is not a prime number%d",num);
	

Exit:
	
	printf("Sum of array A and B is stored in array C");
	
}


void getbal()

{

	printf("This function prints your savings account balance");
	
}


void statements()

{

	printf("This function prints your latest bank statements");
	
}


void getOtp()

{

	printf("This function generates an otp pin that will be sent to your registered mobile number");
	
}


