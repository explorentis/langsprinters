#!/bin/bash
#rewrited from compiled/c/normal.c
True=1
False=0

function calc_count_cipher(){
	number=$1
	result=1
	while [ $number -gt 9 ]
	do
		number=$((number / 10))
		result=$((result+1))
	done
}

function check_ppdi(){
	Number=$1
	calc_count_cipher $Number
	power=$result
	current_cipher=0
	cipher=0
	div=1
	narciss=0
	while [ $current_cipher -ne $power ]
	do
		cipher=$(((Number/div)%10))
		div=$((div*10))
		narciss=$((narciss+cipher**power))
		current_cipher=$((current_cipher+1))
	done
	if [ $narciss -eq $Number ]
	then
		result=$True
	else
		result=$False
	fi
}
MAX_NUMBER=10000000
if [ $# -ne 0 ]
then
	MAX_NUMBER=$1
fi
NUM=1
while [ $NUM -ne $MAX_NUMBER ]
do
	check_ppdi $NUM
	if [ $result == $True ]
	then
		echo "$NUM is Armstrong number"
	fi
	NUM=$((NUM+1))
done
