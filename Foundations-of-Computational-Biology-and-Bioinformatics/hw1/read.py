#!/usr/bin/env python
scoreDict = {}
fd = open("mutation.txt","r")
line = fd.readline()    #skip header
line = fd.readline()    #first mutation
while line != "":
        cols = line.rstrip().split("\t")
        mutationKey = "_".join(cols[:5])
        #mutationKey = tuple(cols[:5])
        scoreDict[mutationKey]  = cols[-1]
        line = fd.readline()
fd.close()
print(scoreDict)
print('###########split##############')
for key in scoreDict.keys():
        print(key, scoreDict[key])
