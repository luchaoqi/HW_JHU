import sys
import pandas as pd
import numpy as np

for i in range(1, len(sys.argv)):
   if(sys.argv[i] == "-f"):
      inputPath = sys.argv[i + 1]
      try:
         inputFile = open(inputPath)
      except:
         sys.stderr.write("Please enter a file \n")
         sys.exit()
               
   if(sys.argv[i] == "-o"):
      try:
         outputFile = sys.argv[i + 1]
      except:
         sys.stderr.write("Please enter an outfile name \n")
         sys.exit()

# do the fucking check on the structure of the fucking files TA will fucking input 
# the ta can input whatever the fuck they want now 
uniqueLetter = []
maxSeqLength = 0
for line in inputFile.readlines():
   line = line.strip()
   if maxSeqLength < len(line):
      maxSeqLength = len(line)
   for i in range(0, len(line)):
      if line[i] not in uniqueLetter:
         uniqueLetter.append(line[i])

# construct a fucking dictionary to take anything fucking shit 
myDict = {}
uniqueLetter.sort() #sort the fucking list
for i in range(0, len(uniqueLetter)) :
   myDict[uniqueLetter[i]] = [0] * maxSeqLength

# re-import this fucking file
inputFile = open(inputPath)
totalSeq = 0
for line in inputFile.readlines():
   totalSeq = totalSeq + 1
   line = line.strip()

   for i in range(0, len(line)): 
      myDict[line[i]][i] = myDict[line[i]][i] + 1 

print(myDict)

orderedKey = ['A', 'G', 'C', 'T']

bigArray = []
for key in orderedKey: 
   tempArray = []

   for index in range(0, maxSeqLength):

      prob = myDict[key][index] / totalSeq

      tempArray.append(prob)
   
   bigArray.append(tempArray)

bigArray = np.array(bigArray)

print(bigArray)

np.savetxt(outputFile, bigArray, delimiter='\t')

'''
# fucking write my shit into a fucking file 
with open(outputFile, 'a') as outFile: 
   
   for key in orderedKey: 
      for index in range(0, maxSeqLength):

         prob = myDict[key][index] / totalSeq

         if index == 0: 
            tempString = str(prob)
         else:
            tempString = str(tempString) + '\t' + str(prob)
      
      tempString = tempString + '\n'
      
      outFile.write(tempString)
'''