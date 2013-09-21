#!/usr/bin/python
#-*- coding: utf-8 -*-
#rewrited from compiled/c/normal.c
from sys import argv

def calc_count_cipher(number):
	result=1
	while number>9:
		number=number/10
		result+=1
	return result

def check_ppdi(number):
	power=calc_count_cipher(number)
	current_cipher=0
	cipher=0
	div=1
	narciss=0
	while current_cipher!=power:
		cipher=(number/div)%10
		div=div*10
		narciss+=cipher**power
		current_cipher+=1
	if narciss==number:
		return True
	else:
		return False

max_number=10000000
if len(argv)!=1:
	max_number=int(argv[1])
number=1
while number!=max_number:
	if check_ppdi(number):
		print number,"is Armstrong number"
	number+=1
