#!/usr/bin/python
#-*- coding: utf-8 -*-
from sys import argv
max_number=10000000
if len(argv)!=1:
	max_number=int(argv[1])
number=1
while number!=max_number:
	str_number=str(number)
	length=len(str_number)
	current_cipher=length
	result=0
	while current_cipher:
		result+=int(str_number[current_cipher-1])**length
		current_cipher-=1
	if result==number:
		print number,'is Armstrong number'
	number+=1
