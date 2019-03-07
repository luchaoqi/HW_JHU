'''
Modified trainer.py for pratical04
Usage: python3 trainer.py -f ESE.txt -o output_model_file.txt
'''
import sys
import pandas as pd
import numpy as np
import argparse

#input error echecking
if len(sys.argv) != 5 or not sys.argv[1].startswith('-') or not sys.argv[3].startswith('-'):
	sys.stdout.write('Usage: python3 trainer.py -f you input seq.txt file -o output_model_file.txt \n')
	sys.exit()
if not sys.argv[2].endswith('.txt'):
	sys.stdout.write('Please input .txt file\n')
	sys.exit()
if not sys.argv[4].endswith('.txt'):
	sys.stdout.write('Please input .txt file\n')
	sys.exit()

parser = argparse.ArgumentParser()
parser.add_argument("-f",required = True, type=str)
parser.add_argument("-o",required = True, type=str)
args = parser.parse_args()
#inputPath = args.f
inputFile = open(args.f)
outputFile = args.o

uL = []
mS = 0
for line in inputFile.readlines():
   line = line.strip()
   if mS < len(line):
      mS = len(line)
   for i in range(0, len(line)):
      if line[i] not in uL:
         uL.append(line[i])

dic = {}
uL.sort() 
for i in range(0, len(uL)) :
   dic[uL[i]] = [0] * mS

inputFile = open(args.f)

x = 0
for line in inputFile.readlines():
   x = x + 1
   line = line.strip()

   for i in range(0, len(line)): 
      dic[line[i]][i] = dic[line[i]][i] + 1 


Keys = ['A', 'G', 'C', 'T']

Array = []
for key in Keys: 
   tempArray = []

   for index in range(0, mS):
      prob = dic[key][index]/x
      tempArray.append(prob)
   Array.append(tempArray)

Array = np.array(Array)

np.savetxt(outputFile, Array, delimiter='\t')
