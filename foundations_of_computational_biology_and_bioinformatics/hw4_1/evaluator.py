'''
LuchaoQi JHED ID:lqi9
Pratical04
Usage: python3 evaluator.py -m output_model_file.txt -t ese_test.txt -d permuted_ese.txt
Evaluate the performance of discriminating between trusted ESEs and decoys. It will also give give FDRs. 
'''
import math
import sys
import argparse
import pandas as pd
import numpy as np


#input error checking
if len(sys.argv) != 7 or not sys.argv[1].startswith('-') or not sys.argv[3].startswith('-') or not sys.argv[5].startswith('-'):
	sys.stdout.write('Usage: python3 evaluator.py -m output_model_file.txt -t ese_test.txt -d permuted_ese.txt\n')
	sys.exit()
if not sys.argv[2].endswith('.txt'):
	sys.stdout.write('Please input .txt file\n')
	sys.exit()
if not sys.argv[4].endswith('.txt'):
	sys.stdout.write('Please input .txt file\n')
	sys.exit()
if not sys.argv[6].endswith('.txt'):
	sys.stdout.write('Please input .txt file\n')
	sys.exit()

parser = argparse.ArgumentParser()
parser.add_argument('-m', required=True, metavar="FILE") 
parser.add_argument('-t',  required=True, metavar="FILE") 
parser.add_argument('-d',  required=True, metavar="FILE" ) 
args = parser.parse_args()

model = open(args.m, 'rb')
test = open(args.t, 'rb')
decoy = open(args.d, 'rb')
model_tab = np.loadtxt(model, delimiter='\t')
def calcSeqScore(x, y):
   Score = 0 
   rowIndex = ['A', 'G', 'C', 'T']
   for col in range(0, len(x)): 
      row = rowIndex.index(x[col])
      nucScore = y[row][col]
      nucScore = math.log2(nucScore)
      Score = Score + nucScore
   return Score



testArray = []
testScoreArray = []
for line in test.readlines():
   line = line.strip()
   line = line.decode("utf-8")
   testArray.append(line)
   seqScore = calcSeqScore(line, model_tab)
   testScoreArray.append(seqScore)

decoyArray = []
decoyScoreArray = []
for line in decoy.readlines():
   line = line.strip()
   line = line.decode("utf-8")
   if line not in testArray:
      decoyArray.append(line)
      seqScore = calcSeqScore(line, model_tab)
      decoyScoreArray.append(seqScore)

totalScore = testScoreArray + decoyScoreArray
uniqueScore = list(set(totalScore))
uniqueScore.sort()
TP = []
FP = []
TN = []
FN = []
FDR = []
testScoreArray = np.array(testScoreArray)
decoyScoreArray = np.array(decoyScoreArray)

for score in uniqueScore: 
   TP.append(sum(testScoreArray >= score))
   FP.append(sum(decoyScoreArray >= score))
   TN.append(len(decoyScoreArray) - sum(decoyScoreArray >= score))
   FN.append(len(testScoreArray)- sum(testScoreArray >= score))
   FDR.append(FP[-1] / (FP[-1] + TP[-1]))
#   if FP[-1]+TP[-1] == 0:
#      FDR.append('0')
#   else:
#      FDR.append(FP[-1] / (FP[-1] + TP[-1]))

dataframe_dict = {"#thresh":uniqueScore, "TP":TP, "FP":FP, "TN":TN, "FN":FN, "FDR":FDR}
dataframe_return = pd.DataFrame(dataframe_dict)
print(dataframe_return)
