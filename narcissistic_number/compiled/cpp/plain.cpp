#include<stdlib.h>
#include<stdio.h>
#include<math.h>

int main(int argc,char** argv){
	int max_number=10000000;
	if (argc!=1)
		max_number=atoi(argv[1]);
	int number=0;
	int temporal_number=0;
	int num_count=0;
	int div=1;
	int narciss=0;
	int current_cipher=0;
	while (++number!=max_number){
		temporal_number=number;
		num_count=1;
		div=1;
		narciss=0;
		current_cipher=0;
		while (temporal_number>9){
			temporal_number/=10;
			num_count++;
		}
		while (num_count!=current_cipher){
			temporal_number=(number/div)%10;
			div*=10;
			narciss+=pow(temporal_number,num_count);
			current_cipher++;
		}
		if (narciss==number) printf("%d is Armstrong number\n",number);
	}
}
