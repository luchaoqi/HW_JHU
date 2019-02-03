#!/usr/bin/env python
import sys
a = sys.stdin.readline()[:-1]    #input your file name
b = open(a,"r")
c = []				 
dic = {}				
des = b.readline().strip('>')    #first line & get the descriptor
line = b.readline()   	 	 #second line: sequence 
while line != "":
	d = line.rstrip('\n')
        c.append(d)
        line = b.readline()
b.close()
c = ''.join(c)			 #delete the ','
dic[des]=c
print (dic)			 #check the format
