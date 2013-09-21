//rewrited from 2.1.1.
#include<stdlib.h>
#include<stdio.h>
#include<math.h>
int calc_count_cipher(int number){
	int result=1;
	while(number>9){
		number/=10;
		result++;
	}
	return result;
}

bool check_ppdi(int number){
	int power=calc_count_cipher(number);
	int current_cipher=0,cipher=0,div=1,narciss=0;
	while(current_cipher!=power){
		cipher = ( number / div ) % 10;
		div*=10;
		narciss+=pow(cipher,power);
		current_cipher++;
	}
	return (narciss==number) ? true : false;
}

int main(int argc,char** argv){
	int max_number=10000000;
	if (argc!=1)
		max_number=atoi(argv[1]);
	int number=0;
	while (++number!=max_number)
		if (check_ppdi(number))
			printf("%d is Armstrong number\n",number);
	return 0;

}
