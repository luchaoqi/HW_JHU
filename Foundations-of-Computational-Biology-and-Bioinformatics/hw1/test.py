#!/usr/bin/env python
import sys
b = sys.stdin.readline()[:-1]
a = open(b,"r")
scoreDict = {}

line = a.readline()    #skip header
line = a.readline()     #first mutation
while line != "":
        cols = line.rstrip().split("\t")
        mutationKey = "_".join(cols[:5])
        #mutationKey = tuple(cols[:5])
        scoreDict[mutationKey] = cols[-1]

        line = a.readline()

for key in scoreDict.keys():
        print(key, scoreDict[key])
