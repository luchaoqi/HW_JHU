import math
import sys
import argparse
import numpy as np
import random

random.seed(101) # set it as 100 

# yo lazy fuck, write some error catching mechanism 
# use try and except for the input shit 

parser = argparse.ArgumentParser()

parser.add_argument('-f', dest="input", required=True, metavar="FILE") # input 
parser.add_argument('-o', dest="output", required=True, metavar="FILE") # output 
args = parser.parse_args()

input_file = open(args.input)
outputFile = args.output

writeArray = []
for line in input_file.readlines():
   line = line.strip()
   tempLine = ''
   tempArray = []

   for char in line: 
      tempArray.append(char)
   
   np.random.seed(101) # set it as 100 
   for char in np.random.permutation(tempArray):
      tempLine = tempLine + char

   writeArray.append(tempLine)

with open(outputFile, 'a') as outFile: 
   for line in writeArray: 
      line = line + '\n'
      outFile.write(line)

